Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752271AbaE0L0p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 07:26:45 -0400
Received: from mail-we0-f170.google.com ([74.125.82.170]:62013 "EHLO
	mail-we0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752154AbaE0L0j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 07:26:39 -0400
MIME-Version: 1.0
In-Reply-To: <1399704998-13321-1-git-send-email-pankaj.dubey@samsung.com>
References: <1399704998-13321-1-git-send-email-pankaj.dubey@samsung.com>
Date: Tue, 27 May 2014 16:56:37 +0530
X-Google-Sender-Auth: 6O2tgUPO1C4SDYJgFr6sGuBzTpM
Message-ID: <CAGm_ybjW6SAxsqmnBCGnZ0nEPLhBxgzeZS4dtLwwjW4PtuWJWg@mail.gmail.com>
Subject: Re: [PATCH v4 00/11] ARM: Exynos: PMU cleanup and refactoring for
 using DT
From: Vikas Sajjan <vikas.sajjan@samsung.com>
To: Tomasz Figa <t.figa@samsung.com>
Cc: linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        linux-kernel@vger.kernel.org,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Kukjin Kim <kgene.kim@samsung.com>, linux@arm.linux.org.uk,
        chow.kim@samsung.com, Young-Gun Jang <yg1004.jang@samsung.com>,
        Pankaj Dubey <pankaj.dubey@samsung.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Any comments on this series?


On Sat, May 10, 2014 at 12:26 PM, Pankaj Dubey <pankaj.dubey@samsung.com> wrote:
> This patch series, does some minor cleanup of exynos machine files.
> It also modifies Exynos Power Management Unit (PMU) related code for
> converting it into a platform_driver. This is also preparation for moving
> PMU related code out of machine folder into a either "drivers/mfd", or
> "drivers/power" or some other suitable place so that ARM64 based SoC can
> utilize common piece of code.
>
> These patches require change in Exynos4 SoC dtsi files, which has been
> posted as separate patch series.
>
> These patches are created on top of Kukjin Kim's for-next (v3.15-rc1 tag)
> branch and on top of Daniel Lezcano's Exynos cpuidle refactor patches [2].
>
> These patches depends on following three patch series:
> [1] mfd: syscon: Support early initialization
>     https://lkml.org/lkml/2014/4/8/239
> [2] Daniel Lezcano's Exynos cpuidle refactor patches
>     http://thread.gmane.org/gmane.linux.kernel.samsung-soc/29085
> [3] Allow NULL property in syscon_early_regmap_lookup_by_phandle
>     https://lkml.org/lkml/2014/5/10/10 and
>     https://lkml.org/lkml/2014/4/29/661
>
> We have tested these patches on SMDK5250 board for System boot and
> Arndale (Exynos5250) board for System boot and PMU initialization and S2R.
>
> For testing on Arndale (Exynos5250) board:
> Tested-by: Pankaj Dubey <pankaj.dubey@samsung.com>
>
> Changes Since v3:
>  - Addressed build fail issue in exynos.c as reported by Sachin Kamat.
>  - Optimized exynos_pmu_probe function by removing exynos_pmu_data_init
>    as suggested by Vikas Sajjan.
>  - Rebased on top of Sysram patches by Sachin Kamat.
>  - Modified syscon_early_regmap_lookup_by_phandle and
>    syscon_regmap_lookup_by_phandle function call to pass property as NULL.
>
> Changes Since v2:
>  - Rebased on top of Daniel Lezcano's Exynos cpuidle refactor patches.
>  - Removed exynos_cpuidle_init and exynos_cpufreq_init code as suggested
>    by Tomasz Figa.
>  - Removed early mapping of PMU base address from exynos.c and removed
>    "get_exynos_pmuaddr" function. Instead of this added code in platsmp.c
>    to get PMU base address using of_iomap as suggested by Tomasz Figa.
>  - Converted PMU implementation into platform_driver by using static
>    platform_device method.
>
> Changes Since v1:
>  - Rebased on latest for-next of Kukjin Kim's tree.
>  - Added patch: "Make exynos machine_ops as static".
>         For making more cleanup in "mach-exynos/common.h"
>         as suggested by Tomasz Figa.
>  - Addressed comments of Tomasz Figa for cleaning "mach-exynos/common.h".
>  - Updated patch: Remove file path from comment section
>         As suggested by Michel Simek, instead of updating file path
>         lets remove them from each file under "mach-exynos".
>         Even though Kukjin pointed out that there is similar patch pending from
>         Sachin/Tushar but since I could not find I have included this here. If
>         I have missed something please point to any existing such patch.
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
>  - Added patch: Remove "linux/bug.h" from pmu.c.
>  - Updated patch: Refactored code for PMU register mapping via DT
>         - Modified to use regmap_read/write when using regmap handle.
>  - Added patch: Move "mach/map.h" inclusion from regs-pmu.h to platsmp.c
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
> Pankaj Dubey (7):
>   ARM: EXYNOS: Make exynos machine_ops as static
>   ARM: EXYNOS: Move cpufreq and cpuidle device registration to
>     init_machine
>   ARM: EXYNOS: Remove file path from comment section
>   ARM: EXYNOS: Remove "linux/bug.h" from pmu.c
>   ARM: EXYNOS: Refactored code for using PMU address via DT
>   ARM: EXYNOS: Move "mach/map.h" inclusion from regs-pmu.h to platsmp.c
>   ARM: EXYNOS: Add platform driver support for Exynos PMU.
>
> Young-Gun Jang (4):
>   ARM: EXYNOS: Move SYSREG definition into sys-reg specific file.
>   ARM: EXYNOS: Remove regs-pmu.h header dependency from pm_domain
>   ARM: EXYNOS: Add support for mapping PMU base address via DT
>   ARM: EXYNOS: Move PMU specific definitions from common.h
>
>  arch/arm/Kconfig                             |    1 +
>  arch/arm/mach-exynos/common.h                |   27 +-
>  arch/arm/mach-exynos/exynos-pmu.h            |   31 ++
>  arch/arm/mach-exynos/exynos.c                |   84 +++--
>  arch/arm/mach-exynos/headsmp.S               |    2 -
>  arch/arm/mach-exynos/hotplug.c               |    7 +-
>  arch/arm/mach-exynos/include/mach/map.h      |    3 -
>  arch/arm/mach-exynos/include/mach/memory.h   |    3 +-
>  arch/arm/mach-exynos/platsmp.c               |   42 ++-
>  arch/arm/mach-exynos/pm.c                    |   79 ++--
>  arch/arm/mach-exynos/pm_domains.c            |    8 +-
>  arch/arm/mach-exynos/pmu.c                   |  271 +++++++++++---
>  arch/arm/mach-exynos/regs-pmu.h              |  512 +++++++++++++-------------
>  arch/arm/mach-exynos/regs-sys.h              |   22 ++
>  arch/arm/plat-samsung/include/plat/map-s5p.h |    1 -
>  15 files changed, 665 insertions(+), 428 deletions(-)
>  create mode 100644 arch/arm/mach-exynos/exynos-pmu.h
>  create mode 100644 arch/arm/mach-exynos/regs-sys.h
>
> --
> 1.7.10.4
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-samsung-soc" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
