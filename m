Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756388AbaJ2JXS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 05:23:18 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:9790 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755726AbaJ2JXL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 05:23:11 -0400
X-AuditID: cbfec7f5-b7f956d000005ed7-a5-5450b1fc6bb5
From: Marek Szyprowski <m.szyprowski@samsung.com>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Kukjin Kim <kgene.kim@samsung.com>, lauraa@codeaurora.org,
        linux-omap@vger.kernel.org, linus.walleij@linaro.org, tony@atomide.com,
        drake@endlessm.com, loeliger@gmail.com,
        Mark Rutland <mark.rutland@arm.com>
Subject: [PATCH v7 0/8] Enable L2 cache support on Exynos4210/4x12 SoCs
Date: Wed, 29 Oct 2014 10:22:53 +0100
Message-id: <1414574581-2320-1-git-send-email-m.szyprowski@samsung.com>
X-Mailer: git-send-email 1.9.2
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprNLMWRmVeSWpSXmKPExsVy+t/xy7p/NgaEGMxczW7xaP5jZoveBVfZ
	LM42vWG32N45g91iyp/lTBabHl9jtbi8aw6bxewl/SwWM87vY7K4fZnX4tz2LSwWa4/cZbdY
	ev0ik8WqXX8YLfZf8XLg91gzbw2jR0tzD5vHt6+TWDwu9/UyeSz6nuWxc9Zddo871/aweWxe
	Uu/Rt2UVo8fnTXIBXFFcNimpOZllqUX6dglcGVsWX2cseC1dcavhK0sDY4tYFyMnh4SAicTq
	o//ZIWwxiQv31rOB2EICSxkl5r/i6mLkArL7mCRufDjLApJgEzCU6HrbBVYkIpAt8ePbZBaQ
	ImaBPmaJ89N7mEESwgLuEs0TFoI1sAioSqx4M4cJxOYFim9/2ssCsU1O4v/LFUwTGLkXMDKs
	YhRNLU0uKE5KzzXSK07MLS7NS9dLzs/dxAgJ0K87GJceszrEKMDBqMTDG8HiHyLEmlhWXJl7
	iFGCg1lJhHeHeUCIEG9KYmVValF+fFFpTmrxIUYmDk6pBkbu5pnPWQN5n6gaWUqFn4v9eaYl
	o/n31Bei4sarJv9513Tb6+QWk82MTdx2nQUNxzbO2f7uU87mvPLk/Jsr680WJJwN8mmZqiY+
	pa8g8tL1260bdvE+tfZJdv24UNRg/a+2uGkeG1dObfTcXiGtfSVH5T1r24vnPfLby33PVOWt
	0MyRZ2e2ua/EUpyRaKjFXFScCADYEQ2WLgIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an updated patchset, which intends to add support for L2 cache
on Exynos4 SoCs on boards running under secure firmware, which requires
certain initialization steps to be done with help of firmware, as
selected registers are writable only from secure mode.

First four patches extend existing support for secure write in L2C driver
to account for design of secure firmware running on Exynos. Namely:
 1) direct read access to certain registers is needed on Exynos, because
    secure firmware calls set several registers at once,
 2) not all boards are running secure firmware, so .write_sec callback
    needs to be installed in Exynos firmware ops initialization code,
 3) write access to {DATA,TAG}_LATENCY_CTRL registers fron non-secure world
    is not allowed and so must use l2c_write_sec as well,
 4) on certain boards, default value of prefetch register is incorrect
    and must be overridden at L2C initialization.
For boards running with firmware that provides access to individual
L2C registers this series should introduce no functional changes. However
since the driver is widely used on other platforms I'd like to kindly ask
any interested people for testing.

Further three patches add implementation of .write_sec and .configure
callbacks for Exynos secure firmware and necessary DT nodes to enable
L2 cache.

Changes in this version tested on Exynos4412-based TRATS2 and OdroidU3+
boards (both with secure firmware). There should be no functional change
for Exynos boards running without secure firmware. I do not have access
to affected non-Exynos boards, so I could not test on them.


Depends on:
 - [PATCH v3 0/5] Firmware-assisted suspend/resume of Exynos SoCs
   (https://lkml.org/lkml/2014/8/26/445)
   available in v3.19-next/pm-samsung branch in
   git://git.kernel.org/pub/scm/linux/kernel/git/kgene/linux-samsung.git


Changelog:

Changes since v6:
(https://lkml.org/lkml/2014/10/27/233)
- changed PL310 to L2C-310 prefix in error messages
- added patch shortening the error message about incorrect associativity

Changes since v5:
(https://lkml.org/lkml/2014/9/24/364)
- rebased onto v3.18-rc2
- added error message about missing properties values

Changes since v4:
(https://lkml.org/lkml/2014/8/26/461)
 - rewrote the code accessing l2x0_saved_regs from assembly code
 - added comment and reworked unconditional call to SMC_CMD_L2X0INVALL


Patch summary:

Marek Szyprowski (1):
  ARM: l2c: unify L2C-310 OF initialization error messages

Tomasz Figa (7):
  ARM: l2c: Refactor the driver to use commit-like interface
  ARM: l2c: Add interface to ask hypervisor to configure L2C
  ARM: l2c: Get outer cache .write_sec callback from mach_desc only if
    not NULL
  ARM: l2c: Add support for overriding prefetch settings
  ARM: EXYNOS: Add .write_sec outer cache callback for L2C-310
  ARM: EXYNOS: Add support for non-secure L2X0 resume
  ARM: dts: exynos4: Add nodes for L2 cache controller

 Documentation/devicetree/bindings/arm/l2cc.txt |  10 +
 arch/arm/boot/dts/exynos4210.dtsi              |   9 +
 arch/arm/boot/dts/exynos4x12.dtsi              |  14 ++
 arch/arm/include/asm/outercache.h              |   3 +
 arch/arm/kernel/irq.c                          |   3 +-
 arch/arm/mach-exynos/firmware.c                |  50 +++++
 arch/arm/mach-exynos/sleep.S                   |  46 +++++
 arch/arm/mm/cache-l2x0.c                       | 275 ++++++++++++++++---------
 8 files changed, 312 insertions(+), 98 deletions(-)

-- 
1.9.2

