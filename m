Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758508AbaHZOMl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 10:12:41 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:25683 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754945AbaHZOKp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 10:10:45 -0400
X-AuditID: cbfec7f4-b7f156d0000063c7-30-53fc95621785
From: Tomasz Figa <t.figa@samsung.com>
To: linux-samsung-soc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Kukjin Kim <kgene.kim@samsung.com>, Arnd Bergmann <arnd@arndb.de>,
        swarren@nvidia.com, acourbot@nvidia.com,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Tomasz Figa <tomasz.figa@gmail.com>, Olof Johansson <olof@lixom.net>,
        drake@endlessm.com, tomeu@tomeuvizoso.net,
        Tomasz Figa <t.figa@samsung.com>
Subject: [PATCH v3 0/5] Firmware-assisted suspend/resume of Exynos SoCs
Date: Tue, 26 Aug 2014 16:10:23 +0200
Message-id: <1409062228-14690-1-git-send-email-t.figa@samsung.com>
X-Mailer: git-send-email 2.0.4
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprCLMWRmVeSWpSXmKPExsVy+t/xq7pJU/8EG/y7qGHx/eEpVou/k46x
	Wzya/5jZonfBVTaLTY+vsVpc3jWHzWLG+X1MFrcv81qsPXKX3eLU9c9sFjemt7BarJ/xmsVi
	1a4/jBaXG80c+DxamnvYPH7/msToseh7lsfOWXfZPTYvqfe4cqKJ1aO3+R2bR9+WVYweR/+y
	eXzeJBfAFcVlk5Kak1mWWqRvl8CVMfF2H3tBp2jFljW72BoYzwp0MXJySAiYSKw9NJcZwhaT
	uHBvPVsXIxeHkMBSRomb304wgiSEBPqYJFoa4kBsNgE1ic8Nj9hAbBEBVYnPbQvYQRqYBTYy
	S/z4O4EdJCEs4C7x59ESsCIWoKLXjWeBNnBw8Ao4SdzuiIVYJiexauM+pgmM3AsYGVYxiqaW
	JhcUJ6XnGuoVJ+YWl+al6yXn525ihITklx2Mi49ZHWIU4GBU4uH9UPI7WIg1say4MvcQowQH
	s5II74+kP8FCvCmJlVWpRfnxRaU5qcWHGJk4OKUaGOUmm7qeXuAhv+Oe884C8+R4B6bXF2O1
	b26MM+XIl9n68vS90l89k0Tc8nxn8m06bzBtVtNXm2VyB/+HP/m0POudu1Z5/9J1G9pWMFg/
	4qpITdywIuOLzK9sll7D03tiGe5VBYRfP7CPt1K99denx77TVgdWn+dNnx34vcn0255HnSwG
	smHfYpRYijMSDbWYi4oTAfsL2HonAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Exynos-based boards running secure firmware the sequence of low level
operations to enter and leave system-wide sleep mode is different than
on those without the firmware. Namely:
 - CP15 power control and diagnostic registers cannot be written directly,
 - the way of setting boot address and boot flag is different,
 - different resume handler needs to be used,
 - dedicated SMC call needs to be performed instead of letting the CPU enter
   WFI.

This series introduces .suspend() and .resume() firmware operations to
perform low level firmware-specific suspend and resume and then leverages
them to provide suspend-resume path meeting the above requirements. Three
additional patches extend device tree sources of Trats2 board with necessary
setup to enable suspend/resume support.

This series has been tested on Exynos4412-based Trats2 board, without any
additional patches. Unfortunately v3.17-rc1 regressed ODROID support and
suspend stopped working on those boards, due to unknown reasons still being
investigated. It does not seem to be related to anything in this series,
though, so I would not consider this as a stopper.

Changes since v2:
(https://lkml.org/lkml/2014/7/17/431)
 - added board-specific fixes for device tree sources of Trats2 board,
 - rebased on next-20140826 of linux-next tree.

Changes since v1:
 - dropped outer_resume() - will be handled in assembly in further patches,
   as support for L2C in non-secure mode gets added,
 - moved CP15 resume to assembly as it needs to be done before MMU is enabled,
 - surrounded CP15 save with a check for cpuid part, because it is valid only
   on Cortex A9,
 - rebased on next-20140717 tag of linux-next tree.

Tomasz Figa (5):
  ARM: firmware: Introduce suspend and resume operations
  ARM: EXYNOS: Add support for firmware-assisted suspend/resume
  ARM: dts: exynos4412-trats2: Keep eMMC regulators soft-disabled
  ARM: dts: exynos4x12: Add utility macro to define pin sleep states
  ARM: dts: exynos4412-trats2: Add sleep mode pin configuration

 Documentation/arm/firmware.txt            |  28 +--
 arch/arm/boot/dts/exynos4412-trats2.dts   | 320 +++++++++++++++++++++++++++++-
 arch/arm/boot/dts/exynos4x12-pinctrl.dtsi |  16 ++
 arch/arm/include/asm/firmware.h           |   8 +
 arch/arm/mach-exynos/Makefile             |   1 +
 arch/arm/mach-exynos/common.h             |   4 +
 arch/arm/mach-exynos/firmware.c           |  45 +++++
 arch/arm/mach-exynos/pm.c                 |  16 +-
 arch/arm/mach-exynos/sleep.S              |  28 +++
 arch/arm/mach-exynos/smc.h                |   4 +
 10 files changed, 438 insertions(+), 32 deletions(-)

-- 
2.0.4

