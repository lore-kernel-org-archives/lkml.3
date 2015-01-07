Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753797AbbAGQkB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 11:40:01 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:54300 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753628AbbAGQj7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 11:39:59 -0500
Message-ID: <54AD612B.6030906@ti.com>
Date: Wed, 7 Jan 2015 10:39:07 -0600
From: Nishanth Menon <nm@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Marek Szyprowski <m.szyprowski@samsung.com>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
CC: Tomasz Figa <tomasz.figa@gmail.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        <linux-samsung-soc@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Kukjin Kim <kgene.kim@samsung.com>, <lauraa@codeaurora.org>,
        <linus.walleij@linaro.org>, <tony@atomide.com>, <drake@endlessm.com>,
        <loeliger@gmail.com>, Mark Rutland <mark.rutland@arm.com>,
        <khilman@linaro.org>
Subject: Re: [PATCH v12 0/9] Enable L2 cache support on Exynos4210/4x12 SoCs
References: <1420630224-8887-1-git-send-email-m.szyprowski@samsung.com>
In-Reply-To: <1420630224-8887-1-git-send-email-m.szyprowski@samsung.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/07/2015 05:30 AM, Marek Szyprowski wrote:
> This is an updated patchset, which intends to add support for L2 cache
> on Exynos4 SoCs on boards running under secure firmware, which requires
> certain initialization steps to be done with help of firmware, as
> selected registers are writable only from secure mode.
> 
> First patch updates Omap2+ platforms by moving l2cache initialization to
> common code. This will resolve too early call to l2cache init, what might
> cause kmalloc failure in code added in next patches.
> 
> Next patch fixes access method to latency and filter settings in l2cache
> driver.
> 
> Next four patches extend existing support for secure write in L2C driver
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
> for Exynos boards running without secure firmware. OMAP based platforms
> were tested by Nishanth Menon and Tony Lindgren.
> 
> Depends on:
> - v3.19-rc2
> 
> Changelog:
> 
> Changes since v11:
> (https://lkml.org/lkml/2015/1/5/254)
> - Added changes suggested by Nishanth to 'ARM: l2c: use l2c_write_sec()
>   for restoring latency and filter regs' patch
> - Fixed 'checkpatch --strict' issues
> - Added Nishanth's and Tony's acked/tested tags
> 
> Changes since v10:
> (https://lkml.org/lkml/2014/12/23/151)
> - Added patch, which fixes access method to latency and filter settings
>   in l2cache
> 
> Changes since v9:
> (https://lkml.org/lkml/2014/11/17/217)
> - Rebased onto vanilla v3.19-rc1
> - Added patch for Omap2+ (move l2cache initialization to common code), what
>   fixes too early initialization (kmalloc failure)
> 
> Changes since v8:
> (http://lkml.org/lkml/2014/11/13/263)
> - Rebased onto vanilla v3.18-rc3 and added required includes, which were
>   previously added by other patches
> - Added Acked-by tags for Exynos part
> 
> Changes since v7:
> (https://lkml.org/lkml/2014/10/29/158)
> - rebased onto arm-soc/for-next kernel tree (depends on patches merged to
>   v3.18-rc3 and arm-soc/samsung/pm2 branch)
> - removed 'ARM: l2c: unify L2C-310 OF initialization error messages' patch
>   (no longer needed)
> 
> Changes since v6:
> (https://lkml.org/lkml/2014/10/27/233)
> - changed PL310 to L2C-310 prefix in error messages
> - added patch shortening the error message about incorrect associativity
> 
> Changes since v5:
> (https://lkml.org/lkml/2014/9/24/364)
> - rebased onto v3.18-rc2
> - added error message about missing properties values
> 
> Changes since v4:
> (https://lkml.org/lkml/2014/8/26/461)
>  - rewrote the code accessing l2x0_saved_regs from assembly code
>  - added comment and reworked unconditional call to SMC_CMD_L2X0INVALL
> 
> 
> Patch summary:
> 
> Marek Szyprowski (2):
>   ARM: OMAP2+: use common l2cache initialization code
>   ARM: l2c: use l2c_write_sec() for restoring latency and filter regs
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
>  arch/arm/mach-omap2/board-generic.c            |   6 +
>  arch/arm/mach-omap2/common.h                   |   8 +
>  arch/arm/mach-omap2/omap4-common.c             |  16 +-
>  arch/arm/mm/cache-l2x0.c                       | 272 ++++++++++++++++---------
>  11 files changed, 325 insertions(+), 112 deletions(-)
> 

Did a re-run of the tests - and all look good on TI platforms that I
have access to.

 1: am335x-evm: BOOT: PASS: http://slexy.org/raw/s21ndr0q1k
 2: am335x-sk: BOOT: PASS: http://slexy.org/raw/s2r1UKeFPt
 3: am3517-evm: BOOT: PASS: http://slexy.org/raw/s2uUU4iBSa
 4: am37x-evm: BOOT: PASS: http://slexy.org/raw/s215NYMPek
 5: am437x-sk: BOOT: PASS: http://slexy.org/raw/s20uQ9Ap5y
 6: am43xx-epos: BOOT: PASS: http://slexy.org/raw/s21d1tVstA
 7: am43xx-gpevm: BOOT: PASS: http://slexy.org/raw/s212pvpS5M
 8: BeagleBoard-X15(am57xx-evm): BOOT: PASS:
http://slexy.org/raw/s21SmDLOXT
 9: BeagleBoard-XM: BOOT: PASS: http://slexy.org/raw/s221NFJt7X
10: beagleboard-vanilla: BOOT: PASS: http://slexy.org/raw/s2Ux1Uhb6t
11: beaglebone-black: BOOT: PASS: http://slexy.org/raw/s2yYU3pfDX
12: beaglebone: BOOT: PASS: http://slexy.org/raw/s29bwGVFZ3
13: craneboard: BOOT: PASS: http://slexy.org/raw/s2SvbHHARF
14: dra72x-evm: BOOT: PASS: http://slexy.org/raw/s20SDUtrIk
15: dra7xx-evm: BOOT: PASS: http://slexy.org/raw/s2mJ0BkX13
16: OMAP3430-Labrador(LDP): BOOT: PASS: http://slexy.org/raw/s22VlwObok
17: omap5-evm: BOOT: PASS: http://slexy.org/raw/s2iI8KthlS
18: pandaboard-es: BOOT: PASS: http://slexy.org/raw/s20bFdCiYz
19: pandaboard-vanilla: BOOT: PASS: http://slexy.org/raw/s21DucPhWr
20: sdp2430: BOOT: PASS: http://slexy.org/raw/s21nOPfnQ7
21: sdp3430: BOOT: PASS: http://slexy.org/raw/s2lUCkOWuU
22: sdp4430: BOOT: PASS: http://slexy.org/raw/s21cNNKpNL
TOTAL = 22 boards, Booted Boards = 22, No Boot boards = 0


-- 
Regards,
Nishanth Menon
