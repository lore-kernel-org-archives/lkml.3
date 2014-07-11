Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751473AbaGKGLJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 02:11:09 -0400
Received: from mail-qg0-f43.google.com ([209.85.192.43]:41515 "EHLO
	mail-qg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751081AbaGKGLH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 02:11:07 -0400
MIME-Version: 1.0
In-Reply-To: <1404878455-31518-1-git-send-email-pankaj.dubey@samsung.com>
References: <1404878455-31518-1-git-send-email-pankaj.dubey@samsung.com>
From: Naveen Krishna Ch <naveenkrishna.ch@gmail.com>
Date: Fri, 11 Jul 2014 11:40:46 +0530
Message-ID: <CAHfPSqCop+L2znhFxs+wXKiJ-gLjxf6Kc=tkwX+3Rv5o0Xx3WA@mail.gmail.com>
Subject: Re: [PATCH v7 0/4] ARM: Exynos: PMU cleanup and refactoring for using DT
To: Pankaj Dubey <pankaj.dubey@samsung.com>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        linux-kernel@vger.kernel.org, Kukjin Kim <kgene.kim@samsung.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>, t.figa@samsung.com,
        vikas.sajjan@samsung.com, joshi@samsung.com, naushad@samsung.com,
        Thomas Abraham <thomas.ab@samsung.com>, chow.kim@samsung.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Pankaj,

On 9 July 2014 09:30, Pankaj Dubey <pankaj.dubey@samsung.com> wrote:
> This patch series, modifies Exynos Power Management Unit (PMU) related code
> for converting it into a platform_driver. This is also preparation for moving
> PMU related code out of machine folder into a either "drivers/mfd", or
> "drivers/power" or some other suitable place so that ARM64 based SoC can
> utilize common piece of code.
>
> These patches are created on top of Kukjin Kim's for-next.
> I have tested this patches on Exynos5250 Snow board for system boot and S2R.
>
> This patch series depends on following two patch series:
> [1]: mfd: syscon: Decouple syscon interface from syscon devices.
>      https://lkml.org/lkml/2014/6/24/188
>
> [2]: Cleanup patches for mach-exynos.
>      http://www.spinics.net/lists/arm-kernel/msg341474.html

With the above mentioned patches + this series
I was able to add PMU registers using syscon in the DTS node for DP and ADC.
and access the PMU registers in the respective drivers using syscon API.

Tested-by: Naveen Krishna Chatradhi <ch.naveen@samsung.com>

>
> Patch v6 and discussion can be found here:
> https://lkml.org/lkml/2014/7/7/22
>
> Change since v6:
>  - Removed NULL check for pmu_data in pmu.c.
>  - Moved pmu_raw_readl and pmu_raw_writel inline helper function
>    into common.h.
>
> Change Since v5:
>  - Squashed patch "Move "mach/map.h" inclusion from regs-pmu.h to platsmp.c"
>    into patch "Refactored code for using PMU address via DT".
>  - Addressed review comments from Tomasz Figa.
>  - Using init_irq machine function to initialize PMU mapping instead
>    of init_time.
>  - Rebased on latest Kukjin Kim's for-next branch.
>
> Changes Since v4:
>  - Splitted patch series in two parts. Part 1 has code cleanup under mach-exynos
>    and posted as separate patch [2]. Current patchset is part 2 which modified
>    exynos pmu implementation for making it platform driver.
>  - Removed dependency over early_syscon API.
>  - Removed usage of regmap read/write APIs.
>  - Modified probe function to register exynos pmu as syscon provider using
>    Tomasz Figa's syscon patch [1].
>  - Address various other review comments from Tomasz Figa.
>  - Removed signed-off-by of Young-Gun Jang <yg1004.jang@samsung.com>,
>    as this id is no more valid. Taking ownership of all his patches.
>
> Changes Since v3:
>  - Optimized exynos_pmu_probe function by removing exynos_pmu_data_init
>    as suggested by Vikas Sajjan.
>  - Modified syscon_early_regmap_lookup_by_phandle and
>    syscon_regmap_lookup_by_phandle function call to pass property as NULL.
>
> Changes Since v2:
>  - Rebased on top of Daniel Lezcano's Exynos cpuidle refactor patches.
>  - Removed early mapping of PMU base address from exynos.c and removed
>    "get_exynos_pmuaddr" function. Instead of this added code in platsmp.c
>    to get PMU base address using of_iomap as suggested by Tomasz Figa.
>  - Converted PMU implementation into platform_driver by using static
>    platform_device method.
>
> Changes Since v1:
>  - Rebased on latest for-next of Kukjin Kim's tree.
>  - Updated patch: Add support for mapping PMU base address via DT
>         - Removed __initdata from declaration of "exynos_pmu_base", as it caused
>         kernel crash as pointed out by Vikas Sajjan.
>         - Added support for Syscon initialization and getting PMU regmap handle
>         as suggested by Sylwester. Since current implementation of early
>         intialization [1] has limitation that "early_syscon_init" requires
>         DT to be unflattened and system should be able to allocate memory,
>         we can't use regmap handles for platsmp.c file as "smp_secondary_init"
>         will be called before DT unflattening. So I have kept both method for
>         accessing PMU base address. platsmp.c will use ioremmaped address where
>         as rest other files can use regmap handle.
>  - Updated patch: Refactored code for PMU register mapping via DT
>         - Modified to use regmap_read/write when using regmap handle.
>  - Added patch: Add device tree based initialization support for PMU.
>         - Convert existing PMU implementation to be a device tree based
>          before moving it to "drivers/mfd" folder. As suggested by Bartlomiej.
>         - Dropped making a platform_driver for PMU, as currently PMU binding
>         has two compatibility strings as "samsung, exynosxxx-pmu", "syscon",
>         once we enable MFD_SYSCON config option, current "syscon" driver probe
>         gets called and PMU probe never gets called. So modified PMU
>         initialization code to scan DT and match against supported compatiblity
>         string in driver code, and once we get matching node use that for
>         accessing PMU regmap handle using "syscon_early_regmap_lookup_by_phandle".
>         If there is any better solution please suggest.
>
>
> Pankaj Dubey (4):
>   ARM: EXYNOS: Add support for mapping PMU base address via DT
>   ARM: EXYNOS: Refactored code for using PMU address via DT
>   ARM: EXYNOS: Add platform driver support for Exynos PMU
>   ARM: EXYNOS: Move PMU specific definitions from common.h
>
>  arch/arm/mach-exynos/Kconfig                 |    1 +
>  arch/arm/mach-exynos/common.h                |   28 +-
>  arch/arm/mach-exynos/exynos-pmu.h            |   24 ++
>  arch/arm/mach-exynos/exynos.c                |   49 ++-
>  arch/arm/mach-exynos/include/mach/map.h      |    3 -
>  arch/arm/mach-exynos/mcpm-exynos.c           |    8 +-
>  arch/arm/mach-exynos/platsmp.c               |    4 +-
>  arch/arm/mach-exynos/pm.c                    |   77 ++--
>  arch/arm/mach-exynos/pmu.c                   |  225 ++++++++---
>  arch/arm/mach-exynos/regs-pmu.h              |  522 +++++++++++++-------------
>  arch/arm/plat-samsung/include/plat/map-s5p.h |    1 -
>  11 files changed, 555 insertions(+), 387 deletions(-)
>  create mode 100644 arch/arm/mach-exynos/exynos-pmu.h
>
> --
> 1.7.9.5
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-samsung-soc" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Shine bright,
(: Nav :)
