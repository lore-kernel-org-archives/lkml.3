Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752712AbbAGLag (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 06:30:36 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:61519 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752477AbbAGLac (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 06:30:32 -0500
X-AuditID: cbfec7f5-b7fc86d0000066b7-d4-54ad18d70c7c
From: Marek Szyprowski <m.szyprowski@samsung.com>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-samsung-soc@vger.kernel.org, linux-omap@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Kukjin Kim <kgene.kim@samsung.com>, lauraa@codeaurora.org,
        linus.walleij@linaro.org, tony@atomide.com, drake@endlessm.com,
        loeliger@gmail.com, Mark Rutland <mark.rutland@arm.com>, nm@ti.com,
        khilman@linaro.org
Subject: [PATCH v12 0/9] Enable L2 cache support on Exynos4210/4x12 SoCs
Date: Wed, 07 Jan 2015 12:30:15 +0100
Message-id: <1420630224-8887-1-git-send-email-m.szyprowski@samsung.com>
X-Mailer: git-send-email 1.9.2
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrPLMWRmVeSWpSXmKPExsVy+t/xq7rXJdaGGMxeL2bxd9IxdotH8x8z
	W/QuuMpm8fXwCkaLs01v2C22d85gt5jyZzmTxabH11gtLu+aw2Yxe0k/i8WM8/uYLG5f5rU4
	t30Li8XaI3fZLZZev8hk8ebHWSaLU9c/s1ms2vWH0WL/FS8HYY8189YwerQ097B5/P41idHj
	29dJLB6X+3qZPBZ9z/LYOesuu8eda3vYPDYvqfe4cqKJ1aNvyypGj+M3tjN5fN4kF8AbxWWT
	kpqTWZZapG+XwJXxp+sQW8EftYpJc9tYGxj/yHUxcnJICJhIvN+6hxHCFpO4cG89WxcjF4eQ
	wFJGiaVbpjBDOH1MEltXn2IDqWITMJToetsFZosIuEn8W3cIrINZYBqLxKYj55lBEsICHhK3
	pr9mBbFZBFQl/i6/yQRi8wq4S5za+IAdYp2cxP+XK5gmMHIvYGRYxSiaWppcUJyUnmukV5yY
	W1yal66XnJ+7iRES6F93MC49ZnWIUYCDUYmHV2HymhAh1sSy4srcQ4wSHMxKIrxvfgGFeFMS
	K6tSi/Lji0pzUosPMTJxcEo1MDbK5FWkSpj3Mck313fLPnEw37rirMKLZ/vvrS6erHPtiauY
	+QaH0Dqujz/jnxUp/ct7U3NjodMXg03nKlI3FL/6xVLz4+6hGbO3LOw6eiPARWz6fLkZpUp9
	DeHeh1J3Zp14v0u58ZDmmeC85YIRjteD8pqvWPi3SzWtcjr1iFX9+bX7l/c0rldiKc5INNRi
	LipOBAAw/4rfUgIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an updated patchset, which intends to add support for L2 cache
on Exynos4 SoCs on boards running under secure firmware, which requires
certain initialization steps to be done with help of firmware, as
selected registers are writable only from secure mode.

First patch updates Omap2+ platforms by moving l2cache initialization to
common code. This will resolve too early call to l2cache init, what might
cause kmalloc failure in code added in next patches.

Next patch fixes access method to latency and filter settings in l2cache
driver.

Next four patches extend existing support for secure write in L2C driver
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
for Exynos boards running without secure firmware. OMAP based platforms
were tested by Nishanth Menon and Tony Lindgren.

Depends on:
- v3.19-rc2

Changelog:

Changes since v11:
(https://lkml.org/lkml/2015/1/5/254)
- Added changes suggested by Nishanth to 'ARM: l2c: use l2c_write_sec()
  for restoring latency and filter regs' patch
- Fixed 'checkpatch --strict' issues
- Added Nishanth's and Tony's acked/tested tags

Changes since v10:
(https://lkml.org/lkml/2014/12/23/151)
- Added patch, which fixes access method to latency and filter settings
  in l2cache

Changes since v9:
(https://lkml.org/lkml/2014/11/17/217)
- Rebased onto vanilla v3.19-rc1
- Added patch for Omap2+ (move l2cache initialization to common code), what
  fixes too early initialization (kmalloc failure)

Changes since v8:
(http://lkml.org/lkml/2014/11/13/263)
- Rebased onto vanilla v3.18-rc3 and added required includes, which were
  previously added by other patches
- Added Acked-by tags for Exynos part

Changes since v7:
(https://lkml.org/lkml/2014/10/29/158)
- rebased onto arm-soc/for-next kernel tree (depends on patches merged to
  v3.18-rc3 and arm-soc/samsung/pm2 branch)
- removed 'ARM: l2c: unify L2C-310 OF initialization error messages' patch
  (no longer needed)

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

Marek Szyprowski (2):
  ARM: OMAP2+: use common l2cache initialization code
  ARM: l2c: use l2c_write_sec() for restoring latency and filter regs

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
 arch/arm/mach-omap2/board-generic.c            |   6 +
 arch/arm/mach-omap2/common.h                   |   8 +
 arch/arm/mach-omap2/omap4-common.c             |  16 +-
 arch/arm/mm/cache-l2x0.c                       | 272 ++++++++++++++++---------
 11 files changed, 325 insertions(+), 112 deletions(-)

-- 
1.9.2

