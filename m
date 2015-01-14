Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753931AbbANPqk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 10:46:40 -0500
Received: from down.free-electrons.com ([37.187.137.238]:44905 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751930AbbANPqi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 10:46:38 -0500
Date: Wed, 14 Jan 2015 16:46:03 +0100
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, Kukjin Kim <kgene.kim@samsung.com>,
        lauraa@codeaurora.org, tony@atomide.com, linus.walleij@linaro.org,
        Tomasz Figa <tomasz.figa@gmail.com>, drake@endlessm.com,
        loeliger@gmail.com, Kyungmin Park <kyungmin.park@samsung.com>,
        santosh.shilimkar@ti.com,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        linux-omap@vger.kernel.org, Mark Rutland <mark.rutland@arm.com>
Subject: Re: [PATCH v5 0/7] Enable L2 cache support on Exynos4210/4x12 SoCs
Message-ID: <20150114154603.GK3843@piout.net>
References: <1411556741-5810-1-git-send-email-m.szyprowski@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1411556741-5810-1-git-send-email-m.szyprowski@samsung.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This patch set hasn't moved since while. We actually need patch 4 to
properly configure prefetch on sama5d4. What would be needed to come to
an agreement ?

On 24/09/2014 at 13:05:34 +0200, Marek Szyprowski wrote :
> This is an updated patchset, which intends to add support for L2 cache
> on Exynos4 SoCs on boards running under secure firmware, which requires
> certain initialization steps to be done with help of firmware, as
> selected registers are writable only from secure mode.
> 
> First four patches extend existing support for secure write in L2C driver
> to account for design of secure firmware running on Exynos. Namely:
>  1) direct read access to certain registers is needed on Exynos, because
>     secure firmware calls set several registers at once,
>  2) not all boards are running secure firmware, so .write_sec callback
>     needs to be installed in Exynos firmware ops initialization code,
>  3) write access to {DATA,TAG}_LATENCY_CTRL registers fron non-secure world
>     is not allowed and so must use l2c_write_sec as well,
>  4) on certain boards, default value of prefetch register is incorrect
>     and must be overridden at L2C initialization.
> For boards running with firmware that provides access to individual
> L2C registers this series should introduce no functional changes. However
> since the driver is widely used on other platforms I'd like to kindly ask
> any interested people for testing.
> 
> Further three patches add implementation of .write_sec and .configure
> callbacks for Exynos secure firmware and necessary DT nodes to enable
> L2 cache.
> 
> Changes in this version tested on Exynos4412-based TRATS2 and OdroidU3+
> boards (both with secure firmware). There should be no functional change
> for Exynos boards running without secure firmware. I do not have access
> to affected non-Exynos boards, so I could not test on them.
> 
> 
> Depends on:
>  - [PATCH v3 0/5] Firmware-assisted suspend/resume of Exynos SoCs
>    (https://lkml.org/lkml/2014/8/26/445)
> 
> 
> Changelog:
> 
> Changes since v4:
> (https://lkml.org/lkml/2014/8/26/461)
>  - rewrote the code accessing l2x0_saved_regs from assembly code
>  - added comment and reworked unconditional call to SMC_CMD_L2X0INVALL
> 
> Changes since v3:
> (https://lkml.org/lkml/2014/7/17/600)
>  - fixed issues with references to initdata on resume path by creating
>    a copy of affected structure (pointed out by Russell King),
>  - fixed unnecessary full reconfiguration of L2C controller on resume
>    (configuration is already determined after initialization, so the
>     only thing to do is to push those values to the controller),
>  - rebased on next-20140717 tag of linux-next tree and last versions
>    of dependencies.
> 
> Changes since v2:
> (https://lkml.org/lkml/2014/6/25/416)
>  - refactored L2C driver to use commit-like interface and make it no longer
>    depend on availability of writes to individual registers,
>  - moved L2C resume to assembly code, because doing it later makes some
>    systems unstable - this is also needed for deeper cpuidle modes,
>  - dropped unnecessary patch hacking around the .write_sec interface,
>  - dropped patch making the driver use l2c_write_sec() for LATENCY_CTRL
>    registers as Exynos is no longer affected and I'm not aware of any
>    reports that this is also needed on other platforms (can be applied
>    separately if it turns out to be so),
>  - rebased onto next-20140717 tag of linux-next tree.
> 
> Changes since v1:
> (https://www.mail-archive.com/linux-omap@vger.kernel.org/msg106323.html)
>  - rebased onto for-next branch of linux-samsung tree,
>  - changed argument order of outer_cache.write_sec() callback to match
>    l2c_write_sec() function in cache-l2x0.c,
>  - added support of overriding of prefetch settings to work around incorrect
>    default settings on certain Exynos4x12-based boards,
>  - added call to firmware to invalidate whole L2 cache before setting enable
>    bit in L2C control register (required by Exynos secure firmware).
> 
> 
> Patch summary:
> 
> Tomasz Figa (7):
>   ARM: l2c: Refactor the driver to use commit-like interface
>   ARM: l2c: Add interface to ask hypervisor to configure L2C
>   ARM: l2c: Get outer cache .write_sec callback from mach_desc only if
>     not NULL
>   ARM: l2c: Add support for overriding prefetch settings
>   ARM: EXYNOS: Add .write_sec outer cache callback for L2C-310
>   ARM: EXYNOS: Add support for non-secure L2X0 resume
>   ARM: dts: exynos4: Add nodes for L2 cache controller
> 
>  Documentation/devicetree/bindings/arm/l2cc.txt |  10 +
>  arch/arm/boot/dts/exynos4210.dtsi              |   9 +
>  arch/arm/boot/dts/exynos4x12.dtsi              |  14 ++
>  arch/arm/include/asm/outercache.h              |   3 +
>  arch/arm/kernel/irq.c                          |   3 +-
>  arch/arm/mach-exynos/firmware.c                |  50 +++++
>  arch/arm/mach-exynos/sleep.S                   |  46 +++++
>  arch/arm/mm/cache-l2x0.c                       | 255 ++++++++++++++++---------
>  8 files changed, 294 insertions(+), 96 deletions(-)
> 
> -- 
> 1.9.2
> 
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel

-- 
Alexandre Belloni, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
