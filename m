Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934635AbaGQQjy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 12:39:54 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:64283 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756948AbaGQQjv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 12:39:51 -0400
X-AuditID: cbfec7f5-b7f626d000004b39-7a-53c7fc5430e2
From: Tomasz Figa <t.figa@samsung.com>
To: linux-samsung-soc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Kukjin Kim <kgene.kim@samsung.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        lauraa@codeaurora.org, linux-omap@vger.kernel.org,
        linus.walleij@linaro.org, santosh.shilimkar@ti.com, tony@atomide.com,
        drake@endlessm.com, Marek Szyprowski <m.szyprowski@samsung.com>,
        Tomasz Figa <tomasz.figa@gmail.com>, loeliger@gmail.com,
        Tomasz Figa <t.figa@samsung.com>
Subject: [PATCH v3 0/7] Enable L2 cache support on Exynos4210/4x12 SoCs
Date: Thu, 17 Jul 2014 18:38:55 +0200
Message-id: <1405615142-21426-1-git-send-email-t.figa@samsung.com>
X-Mailer: git-send-email 1.9.3
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprNLMWRmVeSWpSXmKPExsVy+t/xq7ohf44HG5zZqmrxaP5jZoveBVfZ
	LLZ3zmC3mPJnOZPFpsfXWC0u75rDZjF7ST+LxYzz+5gsbl/mtTi3fQuLxdojd9ktXvetYbZY
	P+M1i8WqXX8YLfZf8XLg92hp7mHz+PZ1EovH5b5eJo9F37M8ds66y+5x59oeNo/NS+o9+ras
	YvQ4fmM7k8fnTXIBXFFcNimpOZllqUX6dglcGZ3bHAqmK1TsXfCOtYFxo2QXIyeHhICJxO6n
	V5kgbDGJC/fWs3UxcnEICSxllNjxZBk7hNPHJHHpXDdYFZuAmsTnhkdsILaIgKrE57YFYEXM
	AgeYJS5sesACkhAWcJfo7P7NDGKzABU1n94OFucVcJKYv3IHG8Q6OYnebW+YJzByL2BkWMUo
	mlqaXFCclJ5rpFecmFtcmpeul5yfu4kREqBfdzAuPWZ1iFGAg1GJh/cH1/FgIdbEsuLK3EOM
	EhzMSiK82feBQrwpiZVVqUX58UWlOanFhxiZODilGhjXm2bwy7vtsNh2t+Vc85alpz08107z
	fWW6b/03u1iZ66+vbO93mxdw4P5ubjanN1E/PdJK+dtc9s5tyRQrXV+n0rbUqDc2q0N0zqeA
	lLSvYkKvr7d8M3z25cFKLlk7vT8HDPPzzbN2vL418anxOp9ZPhpSKz57PZW2+P6trSKkhEd1
	80nPe4eVWIozEg21mIuKEwFCUe16LgIAAA==
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

Further two patches add impelmentation of .write_sec for Exynos secure
firmware and necessary DT nodes to enable L2 cache.

Tested on Exynos4210-based Universal C210 and Trats (both without secure
firmware) and Exynos4412-based TRATS2 and ODROID-U3 boards (both with secure
firmware).

Depends on:
 - [PATCH] ARM: make it easier to check the CPU part number correctly
   (http://thread.gmane.org/gmane.linux.ports.arm.kernel/335126
    already in linux-next)
 - [PATCH v2 0/2] Firmware-assisted suspend/resume of Exynos SoCs
   (https://lkml.org/lkml/2014/7/17/431)

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
 arch/arm/mach-exynos/firmware.c                |  40 ++++
 arch/arm/mach-exynos/sleep.S                   |  41 +++++
 arch/arm/mm/cache-l2x0.c                       | 245 ++++++++++++++++---------
 9 files changed, 274 insertions(+), 92 deletions(-)

-- 
1.9.3

