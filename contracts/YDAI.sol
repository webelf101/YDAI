//SPDX-License-Identifier: Unlicense

pragma solidity 0.8.13;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

struct Deposit {
    uint256 amount;
    uint256 startTimestamp;
    uint256 lockPeriod;
}

contract YDAI {
    uint8 public constant decimals = 18;
    address public immutable dai;
    mapping(address => Deposit[]) public deposits;

    error InvalidatePeriod();
    error Invalidate();

    string public name;
    string public symbol;

    constructor(
        string memory name_,
        string memory symbol_,
        address dai_
    ) {
        name = name_;
        symbol = symbol_;
        dai = dai_;
    }

    function deposit(uint256 amount, uint256 lockPeriod) public {
        if (
            lockPeriod != 0 && lockPeriod != 8 weeks && lockPeriod != 365 days
        ) {
            revert InvalidatePeriod();
        }
        IERC20(dai).transferFrom(msg.sender, address(this), amount);
        deposits[msg.sender].push(
            Deposit({
                amount: amount,
                startTimestamp: block.timestamp,
                lockPeriod: lockPeriod
            })
        );
    }

    function deposit(uint256 amount) public {
        deposit(amount, 0);
    }

    function burn(uint256 amount) public {
        if (amount > balanceOf(msg.sender)) {
            revert Invalidate();
        }
        uint256 withdrawAmount = amount;
        for (uint256 i = 1; i <= deposits[msg.sender].length; i++) {
            Deposit memory dep = deposits[msg.sender][i - 1];
            if (dep.lockPeriod == 0) {
                if (
                    withdrawAmount <
                    dep.amount +
                        (dep.amount *
                            (block.timestamp - dep.startTimestamp) *
                            12) /
                        36500 days
                ) {
                    deposits[msg.sender][i - 1].amount -=
                        (withdrawAmount * 36500 days) /
                        (36500 days +
                            (block.timestamp - dep.startTimestamp) *
                            12);
                    withdrawAmount = 0;
                    break;
                } else {
                    withdrawAmount -=
                        dep.amount +
                        (dep.amount *
                            (block.timestamp - dep.startTimestamp) *
                            12) /
                        36500 days;
                    if (deposits[msg.sender].length == i) {
                        deposits[msg.sender].pop();
                        break;
                    } else {
                        deposits[msg.sender][i - 1] = deposits[msg.sender][
                            deposits[msg.sender].length - 1
                        ];
                        deposits[msg.sender].pop();
                        i--;
                        continue;
                    }
                }
            }
            if (
                dep.lockPeriod == 8 weeks &&
                dep.startTimestamp + 8 weeks <= block.timestamp
            ) {
                if (
                    withdrawAmount <
                    dep.amount +
                        (dep.amount *
                            (block.timestamp - dep.startTimestamp) *
                            20) /
                        36500 days
                ) {
                    deposits[msg.sender][i - 1].amount -=
                        (withdrawAmount * 36500 days) /
                        (36500 days +
                            (block.timestamp - dep.startTimestamp) *
                            20);
                    withdrawAmount = 0;
                    break;
                } else {
                    withdrawAmount -=
                        dep.amount +
                        (dep.amount *
                            (block.timestamp - dep.startTimestamp) *
                            20) /
                        36500 days;
                    if (deposits[msg.sender].length == i) {
                        deposits[msg.sender].pop();
                        break;
                    } else {
                        deposits[msg.sender][i - 1] = deposits[msg.sender][
                            deposits[msg.sender].length - 1
                        ];
                        deposits[msg.sender].pop();
                        i--;
                        continue;
                    }
                }
            }
            if (
                dep.lockPeriod == 365 days &&
                dep.startTimestamp + 365 days <= block.timestamp
            ) {
                if (
                    withdrawAmount <
                    dep.amount +
                        (dep.amount *
                            (block.timestamp - dep.startTimestamp) *
                            35) /
                        36500 days
                ) {
                    withdrawAmount = 0;
                    deposits[msg.sender][i - 1].amount -=
                        (withdrawAmount * 36500 days) /
                        (36500 days +
                            (block.timestamp - dep.startTimestamp) *
                            35);
                    break;
                } else {
                    withdrawAmount -=
                        dep.amount +
                        (dep.amount *
                            (block.timestamp - dep.startTimestamp) *
                            35) /
                        36500 days;
                    if (deposits[msg.sender].length == i) {
                        deposits[msg.sender].pop();
                        break;
                    } else {
                        deposits[msg.sender][i - 1] = deposits[msg.sender][
                            deposits[msg.sender].length - 1
                        ];
                        deposits[msg.sender].pop();
                        i--;
                    }
                }
            }
        }
        for (uint256 i = 1; i <= deposits[msg.sender].length; i++) {
            Deposit memory dep = deposits[msg.sender][i - 1];
            if (dep.lockPeriod == 8 weeks) {
                if (
                    withdrawAmount <
                    ((dep.amount +
                        (dep.amount *
                            (block.timestamp - dep.startTimestamp) *
                            20) /
                        36500 days) * 85) /
                        100
                ) {
                    deposits[msg.sender][i - 1].amount -=
                        (withdrawAmount * 36500 days) /
                        (36500 days +
                            (block.timestamp - dep.startTimestamp) *
                            20);
                    withdrawAmount = 0;
                    break;
                } else {
                    withdrawAmount -=
                        ((dep.amount +
                            (dep.amount *
                                (block.timestamp - dep.startTimestamp) *
                                20) /
                            36500 days) * 85) /
                        100;
                    if (deposits[msg.sender].length == i) {
                        deposits[msg.sender].pop();
                        break;
                    } else {
                        deposits[msg.sender][i - 1] = deposits[msg.sender][
                            deposits[msg.sender].length - 1
                        ];
                        deposits[msg.sender].pop();
                        i--;
                        continue;
                    }
                }
            }
            if (dep.lockPeriod == 365 days) {
                if (
                    withdrawAmount <
                    ((dep.amount +
                        (dep.amount *
                            (block.timestamp - dep.startTimestamp) *
                            35) /
                        36500 days) * 85) /
                        100
                ) {
                    withdrawAmount = 0;
                    deposits[msg.sender][i - 1].amount -=
                        (withdrawAmount * 36500 days) /
                        (36500 days +
                            (block.timestamp - dep.startTimestamp) *
                            35);
                    break;
                } else {
                    withdrawAmount -=
                        ((dep.amount +
                            (dep.amount *
                                (block.timestamp - dep.startTimestamp) *
                                35) /
                            36500 days) * 85) /
                        100;
                    if (deposits[msg.sender].length == i) {
                        deposits[msg.sender].pop();
                        break;
                    } else {
                        deposits[msg.sender][i - 1] = deposits[msg.sender][
                            deposits[msg.sender].length - 1
                        ];
                        deposits[msg.sender].pop();
                        i--;
                    }
                }
            }
        }
        IERC20(dai).transfer(msg.sender, amount);
    }

    function burnAll() public {
        burn(balanceOf(msg.sender));
    }

    function balanceOf(address account)
        public
        view
        returns (uint256)
    {
        uint256 bal;
        for (uint256 i = 0; i < deposits[account].length; i++) {
            Deposit memory dep = deposits[account][i];
            if (dep.lockPeriod == 0) {
                bal +=
                    dep.amount +
                    (dep.amount * (block.timestamp - dep.startTimestamp) * 12) /
                    36500 days;
            } else if (dep.lockPeriod == 8 weeks) {
                bal +=
                    dep.amount +
                    (dep.amount * (block.timestamp - dep.startTimestamp) * 20) /
                    36500 days;
            } else if (dep.lockPeriod == 365 days) {
                bal +=
                    dep.amount +
                    (dep.amount * (block.timestamp - dep.startTimestamp) * 35) /
                    36500 days;
            }
        }
        return bal;
    }
}
