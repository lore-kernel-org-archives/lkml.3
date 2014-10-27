Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752020AbaJ0LGA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 07:06:00 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:31377 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751180AbaJ0LF6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 07:05:58 -0400
X-AuditID: cbfec7f4-b7f6c6d00000120b-59-544e27135031
From: Marek Szyprowski <m.szyprowski@samsung.com>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Kukjin Kim <kgene.kim@samsung.com>, lauraa@codeaurora.org,
        linux-omap@vger.kernel.org, linus.walleij@linaro.org,
        santosh.shilimkar@ti.com, tony@atomide.com, drake@endlessm.com,
        loeliger@gmail.com, Mark Rutland <mark.rutland@arm.com>
Subject: [PATCH v6 0/7] Enable L2 cache support on Exynos4210/4x12 SoCs
Date: Mon, 27 Oct 2014 12:05:43 +0100
Message-id: <1414407950-3029-1-git-send-email-m.szyprowski@samsung.com>
X-Mailer: git-send-email 1.9.2
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrCLMWRmVeSWpSXmKPExsVy+t/xK7rC6n4hBntPKVo8mv+Y2aJ3wVU2
	i7NNb9gttnfOYLeY8mc5k8Wmx9dYLS7vmsNmMXtJP4vFjPP7mCxuX+a1OLd9C4vF2iN32S2W
	Xr/IZPG6bw2zxapdfxgt9l/xchDwWDNvDaNHS3MPm8e3r5NYPC739TJ5LPqe5bFz1l12jzvX
	9rB5bF5S79G3ZRWjx/Eb25k8Pm+SC+CO4rJJSc3JLEst0rdL4MpovTiXqeCEZMXVKd9YGhin
	iHQxcnJICJhIrFyymR3CFpO4cG89WxcjF4eQwFJGiY0dp8ASQgJ9TBKrJoWC2GwChhJdb7vY
	QGwRgWyJH98ms4A0MAusYpaYcmAdK0hCWMBd4vXjSUBFHBwsAqoSd18xgoR5gcLn/6yBWiYn
	8f/lCqYJjNwLGBlWMYqmliYXFCel5xrqFSfmFpfmpesl5+duYoSE7JcdjIuPWR1iFOBgVOLh
	3THNN0SINbGsuDL3EKMEB7OSCK/jT6AQb0piZVVqUX58UWlOavEhRiYOTqkGxg0W0yIle/7b
	m2XuPnOJteDOrSuaBzND5qQanpDu37WQe80C452bSj88j90hsrvIMFlrE+Ma3lsNFfcn7I34
	sePTE9N6mdSLUzp/OP08o9jX9bI3afXDVV42AYxv1J4V583YlfaP8c6tXX2HpLad8bU+VrRv
	bv47pWS/wK2xx5Ye2FpyaUnUlTYlluKMREMt5qLiRACC9F69NwIAAA==
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

Changes since v5:
(https://lkml.org/lkml/2014/9/24/364)
- rebased onto v3.18-rc2
- added error message about missing properties values

Changes since v4:
(https://lkml.org/lkml/2014/8/26/461)
 - rewrote the code accessing l2x0_saved_regs from assembly code
 - added comment and reworked unconditional call to SMC_CMD_L2X0INVALL


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
 arch/arm/mm/cache-l2x0.c                       | 271 ++++++++++++++++---------
 8 files changed, 310 insertions(+), 96 deletions(-)

-- 
1.9.2

