Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752179AbaGaTJA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 15:09:00 -0400
Received: from mail-we0-f169.google.com ([74.125.82.169]:48162 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751111AbaGaTI6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 15:08:58 -0400
Message-ID: <53DA9445.1090201@gmail.com>
Date: Thu, 31 Jul 2014 21:08:53 +0200
From: Tomasz Figa <tomasz.figa@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Tomasz Figa <t.figa@samsung.com>, linux-samsung-soc@vger.kernel.org
CC: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Kukjin Kim <kgene.kim@samsung.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        lauraa@codeaurora.org, linux-omap@vger.kernel.org,
        linus.walleij@linaro.org, santosh.shilimkar@ti.com, tony@atomide.com,
        drake@endlessm.com, Marek Szyprowski <m.szyprowski@samsung.com>,
        loeliger@gmail.com
Subject: Re: [PATCH v3 0/7] Enable L2 cache support on Exynos4210/4x12 SoCs
References: <1405615142-21426-1-git-send-email-t.figa@samsung.com>
In-Reply-To: <1405615142-21426-1-git-send-email-t.figa@samsung.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17.07.2014 18:38, Tomasz Figa wrote:
> This series intends to add support for L2 cache on Exynos4 SoCs on boards
> running under secure firmware, which requires certain initialization steps
> to be done with help of firmware, as selected registers are writable only
> from secure mode.
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
> Further two patches add impelmentation of .write_sec for Exynos secure
> firmware and necessary DT nodes to enable L2 cache.
> 
> Tested on Exynos4210-based Universal C210 and Trats (both without secure
> firmware) and Exynos4412-based TRATS2 and ODROID-U3 boards (both with secure
> firmware).
> 
> Depends on:
>  - [PATCH] ARM: make it easier to check the CPU part number correctly
>    (http://thread.gmane.org/gmane.linux.ports.arm.kernel/335126
>     already in linux-next)
>  - [PATCH v2 0/2] Firmware-assisted suspend/resume of Exynos SoCs
>    (https://lkml.org/lkml/2014/7/17/431)
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
>  arch/arm/mach-exynos/common.h                  |   1 +
>  arch/arm/mach-exynos/firmware.c                |  40 ++++
>  arch/arm/mach-exynos/sleep.S                   |  41 +++++
>  arch/arm/mm/cache-l2x0.c                       | 245 ++++++++++++++++---------
>  9 files changed, 274 insertions(+), 92 deletions(-)
> 

Any comments for this series?

Best regards,
Tomasz
