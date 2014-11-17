Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752489AbaKQLtI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 06:49:08 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:46767 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752380AbaKQLtE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 06:49:04 -0500
X-AuditID: cbfec7f4-b7f6c6d00000120b-05-5469e0937003
From: Marek Szyprowski <m.szyprowski@samsung.com>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-samsung-soc@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Olof Johansson <olof@lixom.net>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Kukjin Kim <kgene.kim@samsung.com>, lauraa@codeaurora.org,
        linux-omap@vger.kernel.org, linus.walleij@linaro.org, tony@atomide.com,
        drake@endlessm.com, loeliger@gmail.com,
        Mark Rutland <mark.rutland@arm.com>
Subject: [PATCH v9 0/7] Enable L2 cache support on Exynos4210/4x12 SoCs
Date: Mon, 17 Nov 2014 12:48:22 +0100
Message-id: <1416224909-4290-1-git-send-email-m.szyprowski@samsung.com>
X-Mailer: git-send-email 1.9.2
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrHLMWRmVeSWpSXmKPExsVy+t/xK7qTH2SGGCyexG7xd9IxdotH8x8z
	W/QuuMpmcbbpDbvF9s4Z7BZT/ixnstj0+BqrxeVdc9gsZi/pZ7GYcX4fk8Xty7wW57ZvYbFY
	e+Quu8XS6xeZLE5d/8xmsWrXH0aL/Ve8HAQ91sxbw+jR0tzD5vH71yRGj29fJ7F4XO7rZfJY
	9D3LY+esu+wed67tYfPYvKTe48qJJlaPvi2rGD0+b5IL4InisklJzcksSy3St0vgyuif+JO9
	YLJcxe0pNg2M18S7GDk5JARMJO5+Wc8GYYtJXLgHYnNxCAksZZT4+P4tK0hCSKCPSeJCAyeI
	zSZgKNH1tgusQUTATeLfukNgDcwCn5klLj1aA9YgLOAuMa9hJ1gRi4CqxMIT78FsXqD49zMT
	mSC2yUn8f7mCaQIj9wJGhlWMoqmlyQXFSem5hnrFibnFpXnpesn5uZsYIWH8ZQfj4mNWhxgF
	OBiVeHglDmSGCLEmlhVX5h5ilOBgVhLhjbkIFOJNSaysSi3Kjy8qzUktPsTIxMEp1cA4fatz
	95vMpIc1M96W/0pxYT3gWNFhtWD/fU2xh2UvpNl9xDfanl/CI7J7T27yweqVq1bd/61Qsy6l
	v2masmzADO7Ic3yzGhYcvHtTWbm0+5e4bU5GzYeGosbejaGtbubh2jstLU832635bR6Rf+ud
	o+urORdm/j0lkK0wMUPo1kzXewGr47YrsRRnJBpqMRcVJwIAs/lzT0ECAAA=
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
- v3.18-rc3

Changelog:

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
 arch/arm/mach-exynos/Makefile                  |   1 +
 arch/arm/mach-exynos/firmware.c                |  51 +++++
 arch/arm/mach-exynos/sleep.S                   |  48 +++++
 arch/arm/mach-exynos/smc.h                     |   4 +
 arch/arm/mm/cache-l2x0.c                       | 270 ++++++++++++++++---------
 10 files changed, 317 insertions(+), 96 deletions(-)

-- 
1.9.2

