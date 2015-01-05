Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753324AbbAERBd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 12:01:33 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:37016 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752900AbbAERBb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 12:01:31 -0500
Message-ID: <54AAC338.9030506@ti.com>
Date: Mon, 5 Jan 2015 11:00:40 -0600
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
Subject: Re: [PATCH v11 0/9] Enable L2 cache support on Exynos4210/4x12 SoCs
References: <1420460348-20302-1-git-send-email-m.szyprowski@samsung.com>
In-Reply-To: <1420460348-20302-1-git-send-email-m.szyprowski@samsung.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/05/2015 06:18 AM, Marek Szyprowski wrote:
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
> for Exynos boards running without secure firmware. I do not have access
> to affected non-Exynos boards, so I could not test on them.
> 
> Depends on:
> - v3.19-rc2
> 
> Changelog:
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
>  arch/arm/mach-omap2/common.h                   |   7 +
>  arch/arm/mach-omap2/omap4-common.c             |  16 +-
>  arch/arm/mm/cache-l2x0.c                       | 270 ++++++++++++++++---------
>  11 files changed, 323 insertions(+), 111 deletions(-)
> 
Applied all 9 patches and tested on as many boards as I could get my
hands on.. all boot fine, Thanks

 1: am335x-evm: BOOT: PASS: http://slexy.org/raw/s21Q8Zw33s
 2: am335x-sk: BOOT: PASS: http://slexy.org/raw/s28O0bBEyM
 3: am437x-sk: BOOT: PASS: http://slexy.org/raw/s203dOrLId
 4: am43xx-epos: BOOT: PASS: http://slexy.org/raw/s2uWmV1XkM
 5: am43xx-gpevm: BOOT: PASS: http://slexy.org/raw/s20jVsjU00
 6: BeagleBoard-X15(am57xx-evm): BOOT: PASS:
http://slexy.org/raw/s21ezwoOop
 7: BeagleBoard-XM: BOOT: PASS: http://slexy.org/raw/s21M0IYcdI
 8: beagleboard-vanilla: BOOT: PASS: http://slexy.org/raw/s2gCJ5VRr9
 9: beaglebone-black: BOOT: PASS: http://slexy.org/raw/s2vvB4u86O
10: beaglebone: BOOT: PASS: http://slexy.org/raw/s208k0tU3V
11: dra72x-evm: BOOT: PASS: http://slexy.org/raw/s212oTeZ2w
12: dra7xx-evm: BOOT: PASS: http://slexy.org/raw/s24deU2xtY
13: omap5-evm: BOOT: PASS: http://slexy.org/raw/s2DkUAGU0i
14: pandaboard-es: BOOT: PASS: http://slexy.org/raw/s2UKuDaAFf
15: pandaboard-vanilla: BOOT: PASS: http://slexy.org/raw/s21VAyb14r
16: sdp4430: BOOT: PASS: http://slexy.org/raw/s2J6nAHynd

for TI SoCs impacted OMAP4 and AM437x (other than the exynos patches):

Tested-by: Nishanth Menon <nm@ti.com>
Acked-by: Nishanth Menon <nm@ti.com>


-- 
Regards,
Nishanth Menon
