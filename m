Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758662AbaHZOSL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 10:18:11 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:42184 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755333AbaHZOSI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 10:18:08 -0400
X-AuditID: cbfec7f4-b7f156d0000063c7-cd-53fc971da814
From: Tomasz Figa <t.figa@samsung.com>
To: linux-samsung-soc@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Kukjin Kim <kgene.kim@samsung.com>, lauraa@codeaurora.org,
        linux-omap@vger.kernel.org, linus.walleij@linaro.org,
        santosh.shilimkar@ti.com, tony@atomide.com, drake@endlessm.com,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Tomasz Figa <tomasz.figa@gmail.com>, loeliger@gmail.com,
        Tomasz Figa <t.figa@samsung.com>
Subject: [PATCH v4 0/7] Enable L2 cache support on Exynos4210/4x12 SoCs
Date: Tue, 26 Aug 2014 16:17:53 +0200
Message-id: <1409062680-15906-1-git-send-email-t.figa@samsung.com>
X-Mailer: git-send-email 2.0.4
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprFLMWRmVeSWpSXmKPExsVy+t/xK7qy0/8EG8xYKGvxaP5jZoveBVfZ
	LLZ3zmC3mPJnOZPFpsfXWC0u75rDZjF7ST+LxYzz+5gsbl/mtTi3fQuLxdojd9ktXvetYbZY
	P+M1i8WqXX8YLfZf8XLg92hp7mHz+PZ1EovH5b5eJo9F37M8ds66y+5x59oeNo/NS+o9+ras
	YvQ4fmM7k8fnTXIBXFFcNimpOZllqUX6dglcGW3zpQruKlfcf/SPuYFxlkwXIyeHhICJxLZt
	X9ghbDGJC/fWs3UxcnEICSxllLjw4jIzhNPHJLHhRgdYFZuAmsTnhkdsILaIgKrE57YFYHFm
	gQPMEu0rA0BsYQF3iUdTdrCC2CxANW1Lt4PZvAJOEv1TnkJtk5NYtXEf0wRG7gWMDKsYRVNL
	kwuKk9JzDfWKE3OLS/PS9ZLzczcxQsLzyw7GxcesDjEKcDAq8fB+KPkdLMSaWFZcmXuIUYKD
	WUmE90fSn2Ah3pTEyqrUovz4otKc1OJDjEwcnFINjDMyI6e+2/wk3O3TrB0rDzdV9jefymWK
	+FMedp/hV+C6qFzxdu1PObyiDdKCz7ZfyNypobdJ03z+vQ1GSoyPZZ12sy64uf/geYeoDZbO
	NR1SuxXjL9/dtNWD2XuXp1ubesAV1iurtCIumm3b+PWgjtof9f/R3826zm7ofJ0u5Xxslfbr
	5Jzqo0osxRmJhlrMRcWJAIqOWmUtAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series intends to add support for L2 cache on Exynos4 SoCs on boards
running under secure firmware, which requires certain initialization steps
to be done with help of firmware, as selected registers are writable only
from secure mode.

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

Changes in this version tested on Exynos4412-based TRATS2 board (with secure
firmware). There should be no functional change for Exynos boards running
without secure firmware. I do not have access to affected non-Exynos boards,
so I could not test on them.

Depends on:
 - [PATCH v3 0/5] Firmware-assisted suspend/resume of Exynos SoCs
   (https://lkml.org/lkml/2014/8/26/445)

Changes since v3:
(https://lkml.org/lkml/2014/7/17/600)
 - fixed issues with references to initdata on resume path by creating
   a copy of affected structure (pointed out by Russell King),
 - fixed unnecessary full reconfiguration of L2C controller on resume
   (configuration is already determined after initialization, so the
    only thing to do is to push those values to the controller),
 - rebased on next-20140717 tag of linux-next tree and last versions
   of dependencies.

Changes since v2:
(https://lkml.org/lkml/2014/6/25/416)
 - refactored L2C driver to use commit-like interface and make it no longer
   depend on availability of writes to individual registers,
 - moved L2C resume to assembly code, because doing it later makes some
   systems unstable - this is also needed for deeper cpuidle modes,
 - dropped unnecessary patch hacking around the .write_sec interface,
 - dropped patch making the driver use l2c_write_sec() for LATENCY_CTRL
   registers as Exynos is no longer affected and I'm not aware of any
   reports that this is also needed on other platforms (can be applied
   separately if it turns out to be so),
 - rebased onto next-20140717 tag of linux-next tree.

Changes since v1:
(https://www.mail-archive.com/linux-omap@vger.kernel.org/msg106323.html)
 - rebased onto for-next branch of linux-samsung tree,
 - changed argument order of outer_cache.write_sec() callback to match
   l2c_write_sec() function in cache-l2x0.c,
 - added support of overriding of prefetch settings to work around incorrect
   default settings on certain Exynos4x12-based boards,
 - added call to firmware to invalidate whole L2 cache before setting enable
   bit in L2C control register (required by Exynos secure firmware).

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
 arch/arm/mach-exynos/common.h                  |   1 +
 arch/arm/mach-exynos/firmware.c                |  42 +++-
 arch/arm/mach-exynos/sleep.S                   |  41 ++++
 arch/arm/mm/cache-l2x0.c                       | 255 ++++++++++++++++---------
 9 files changed, 281 insertions(+), 97 deletions(-)

-- 
2.0.4

