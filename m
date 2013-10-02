Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753673Ab3JBOmb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 10:42:31 -0400
Received: from fw-tnat.cambridge.arm.com ([217.140.96.21]:54799 "EHLO
	cam-smtp0.cambridge.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753138Ab3JBOm3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 10:42:29 -0400
Date: Wed, 2 Oct 2013 13:55:05 +0100
From: Dave Martin <Dave.Martin@arm.com>
To: Vyacheslav Tyrtov <v.tyrtov@samsung.com>
Cc: linux-kernel@vger.kernel.org, Mark Rutland <mark.rutland@arm.com>,
        devicetree@vger.kernel.org, Kukjin Kim <kgene.kim@samsung.com>,
        Russell King <linux@arm.linux.org.uk>, Ben Dooks <ben-linux@fluff.org>,
        Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Stephen Warren <swarren@wwwdotorg.org>, linux-doc@vger.kernel.org,
        Rob Herring <rob.herring@calxeda.com>,
        Tarek Dakhran <t.dakhran@samsung.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        linux-samsung-soc@vger.kernel.org, Rob Landley <rob@landley.net>,
        Mike Turquette <mturquette@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Naour Romain <romain.naour@openwide.fr>,
        linux-arm-kernel@lists.infradead.org, Heiko Stuebner <heiko@sntech.de>
Subject: Re: [PATCH 3/6] ARM: EXYNOS: add Exynos Dual Cluster Support
Message-ID: <20131002125458.GA3407@localhost.localdomain>
References: <1380644227-12244-1-git-send-email-v.tyrtov@samsung.com>
 <1380644227-12244-4-git-send-email-v.tyrtov@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1380644227-12244-4-git-send-email-v.tyrtov@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 01, 2013 at 08:17:04PM +0400, Vyacheslav Tyrtov wrote:
> From: Tarek Dakhran <t.dakhran@samsung.com>
>
> Add EDCS(Exynos Dual Cluster Support) for Samsung Exynos5410 SoC.
> This enables all 8 cores, 4 x A7 and 4 x A15 run at the same time.
>
> Signed-off-by: Tarek Dakhran <t.dakhran@samsung.com>
> Signed-off-by: Vyacheslav Tyrtov <v.tyrtov@samsung.com>
> ---
>  arch/arm/mach-exynos/Makefile      |   2 +
>  arch/arm/mach-exynos/edcs.c        | 217 +++++++++++++++++++++++++++++++++++++
>  arch/arm/mach-exynos/edcs.h        |  41 +++++++
>  arch/arm/mach-exynos/edcs_status.c | 110 +++++++++++++++++++
>  4 files changed, 370 insertions(+)
>  create mode 100644 arch/arm/mach-exynos/edcs.c
>  create mode 100644 arch/arm/mach-exynos/edcs.h
>  create mode 100644 arch/arm/mach-exynos/edcs_status.c
>
> diff --git a/arch/arm/mach-exynos/Makefile b/arch/arm/mach-exynos/Makefile
> index 5369615..18e6162 100644
> --- a/arch/arm/mach-exynos/Makefile
> +++ b/arch/arm/mach-exynos/Makefile
> @@ -34,3 +34,5 @@ AFLAGS_exynos-smc.o         :=-Wa,-march=armv7-a$(plus_sec)
>
>  obj-$(CONFIG_MACH_EXYNOS4_DT)                += mach-exynos4-dt.o
>  obj-$(CONFIG_MACH_EXYNOS5_DT)                += mach-exynos5-dt.o
> +
> +obj-$(CONFIG_ARM_CCI)                += edcs.o       edcs_status.o
> diff --git a/arch/arm/mach-exynos/edcs.c b/arch/arm/mach-exynos/edcs.c
> new file mode 100644
> index 0000000..34b4e4b
> --- /dev/null
> +++ b/arch/arm/mach-exynos/edcs.c
> @@ -0,0 +1,217 @@
> +/*
> + * Copyright (c) 2013 Samsung Electronics Co., Ltd.
> + * Author: Tarek Dakhran <t.dakhran@samsung.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + *
> + * EDCS(EXYNOS dual cluster support) for Exynos5410 SoC.
> + */
> +
> +#include <linux/kernel.h>
> +#include <linux/spinlock.h>
> +#include <linux/errno.h>
> +#include <linux/vexpress.h>
> +#include <asm/mcpm.h>
> +#include <asm/proc-fns.h>
> +#include <asm/cacheflush.h>
> +#include <asm/cputype.h>
> +#include <asm/cp15.h>
> +
> +#include "edcs.h"
> +
> +static arch_spinlock_t exynos_lock = __ARCH_SPIN_LOCK_UNLOCKED;
> +static int kfs_use_count[MAX_CPUS_PER_CLUSTER][MAX_NR_CLUSTERS];
> +static int core_count[MAX_NR_CLUSTERS];
> +
> +static int exynos_core_power_control(unsigned int cpu, unsigned int cluster,
> +                             int enable)
> +{
> +     unsigned long timeout = jiffies + msecs_to_jiffies(10);
> +     unsigned int offset = cluster * MAX_CPUS_PER_CLUSTER + cpu;
> +     int value = enable ? S5P_CORE_LOCAL_PWR_EN : 0;
> +
> +     if ((__raw_readl(EXYNOS5410_CORE_STATUS(offset)) & 0x3) == value)
> +             return 0;
> +
> +     __raw_writel(value, EXYNOS5410_CORE_CONFIGURATION(offset));
> +     do {
> +             if ((__raw_readl(EXYNOS5410_CORE_STATUS(offset)) & 0x3)
> +                             == value)
> +                     return 0;
> +     } while (time_before(jiffies, timeout));
> +
> +     return -EDEADLK;

Are you sure you need to wait here?  In MCPM, the power_up() and
power_down() methods are expected to trigger the requested operation,
but they aren't required to wait for it to complete.

Waiting may just burn energy and add pointless latency -- particularly
bad for power_up() with IKS, because the calling CPU could go off and do
something useful in the meantime.


For CPU hotplug and kexec, it is neecssary to wait for a CPU really to
be halted or powered down, so a new power_down_wait() method will need
to be implemented.

See this series (which includes an implementation example for TC2):

http://lists.infradead.org/pipermail/linux-arm-kernel/2013-October/201618.html

If Russell accepts the patches, they will likely be in 3.13.


Your wait loop may be relevant to this, but for power_down_finish() the
loop should be more relaxed to avoid thrashing the bus and power
controller unnecessarily.

Without a power_down_wait() method, the kernel will build OK, but will
BUG() if hotplug or kexec is attempted.


> +}
> +static int exynos_cluster_power_control(unsigned int cluster, int enable)
> +{
> +     unsigned long timeout = jiffies + msecs_to_jiffies(10);
> +     int value = enable ? S5P_CORE_LOCAL_PWR_EN : 0;
> +
> +     if ((__raw_readl(EXYNOS5410_COMMON_STATUS(cluster)) & 0x3)
> +                     == value)
> +             return 0;
> +
> +     __raw_writel(value, EXYNOS5410_COMMON_CONFIGURATION(cluster));
> +     do {
> +             if ((__raw_readl(EXYNOS5410_COMMON_STATUS(cluster)) &
> +                     __raw_readl(EXYNOS5410_L2_STATUS(cluster)) & 0x3)
> +                             == value)
> +                     return 0;
> +     } while (time_before(jiffies, timeout));
> +
> +     return -EDEADLK;
> +}

The same comment about waiting applies here, unless we must really wait
for this to finish before exynos_core_power_up() will work.  This might
be the case if the EXYNOS5410_CORE_CONFIGURATION() registers are implemented
in the cluster-local power domains, but it doesn't look that way.

For example, can you set the target core's PWR_EN bit first and then set
the PWR_UP bit for the cluster, so that the target CPU is brought up as
soon as the cluster comes online?  The correct way to do this, and whether
it's possible at all, depend on the hardware...

> +
> +static int exynos_core_power_up(unsigned int cpu, unsigned int cluster)
> +{
> +     return exynos_core_power_control(cpu, cluster, 1);
> +}
> +
> +static int exynos_core_power_down(unsigned int cpu, unsigned int cluster)
> +{
> +     return exynos_core_power_control(cpu, cluster, 0);
> +}
> +
> +static int exynos_cluster_power_up(unsigned int cluster)
> +{
> +     return exynos_cluster_power_control(cluster, 1);
> +}

No exynos_cluster_power_down()?

> +
> +static int exynos_power_up(unsigned int cpu, unsigned int cluster)
> +{
> +     int ret;
> +     local_irq_disable();

Should there be a local_fiq_disable() here also?

We actually don't have this for TC2 either.  Linux on TC2 doesn't make
use of FIQs, but it would be better to have it for completeness, unless
FIQ is already masked for some reason.

Nico might have a view on this -- if local_fiq_disable() is needed here,
we should add it in the TC2 code too.

> +     arch_spin_lock(&exynos_lock);
> +
> +     pr_info("A%d CORE%d\n", 15 - cluster * 8, cpu);

Minor nits: in addition to Nico's comment, please add some context (like
"%s:", ... __func__).

The rest of the MCPM stack uses the "cpu, cluster" convention in most
places for its messages, so it's best to follow that convention for
consistency.

Some boards allow the cluster numbers to be swapped via DIP switches or
other config.  I don't know whether this applies to EXYNOS5410, but
unnecessary assumptions should be avoided.  Nothing else in this file
cares which cluster is A15 and which is A7, if I understand correctly.

> +     kfs_use_count[cpu][cluster]++;
> +     if (kfs_use_count[cpu][cluster] == 1) {
> +             ++core_count[cluster];
> +             if (core_count[cluster] == 1) {
> +                     ret = exynos_cluster_power_up(cluster);
> +                     if (ret) {
> +                             pr_err("%s: cluster %u power up error\n",
> +                                     __func__, cluster);
> +                             return ret;
> +                     }
> +                     __cci_control_port_by_index(MAX_NR_CLUSTERS
> +                                      - cluster, true);
> +             }
> +             ret = exynos_core_power_up(cpu, cluster);
> +             if (ret) {
> +                     pr_err("%s: cpu %u cluster %u power up error\n",
> +                             __func__, cpu, cluster);
> +                     return ret;

All these "return ret" in the middle of the function will leave local
IRQs masked, and exynos_lock will remain locked, leading to future
deadlocks.

> +             }
> +     } else if (kfs_use_count[cpu][cluster] != 2) {
> +             /*
> +              * The only possible values are:
> +              * 0 = CPU down
> +              * 1 = CPU (still) up
> +              * 2 = CPU requested to be up before it had a chance
> +              *     to actually make itself down.
> +              * Any other value is a bug.
> +              */
> +             BUG();
> +     }

If this function might return prematurely on error, then I suggest you
put a label here, and goto it on errors, with "return ret" in place of
"return 0".  ret should be initialised to zero if you do that.

> +     arch_spin_unlock(&exynos_lock);
> +     local_irq_enable();
> +     return 0;
> +}
> +static void exynos_power_down(void)
> +{
> +     unsigned int mpidr, cpu, cluster;
> +     bool last_man = false, skip_wfi = false;
> +     mpidr = read_cpuid_mpidr();
> +     cpu = MPIDR_AFFINITY_LEVEL(mpidr, 0);
> +     cluster = MPIDR_AFFINITY_LEVEL(mpidr, 1);
> +
> +     pr_info("A%d CORE%d\n", 15 - cluster * 8, cpu);
> +     BUG_ON(cpu >= MAX_CPUS_PER_CLUSTER  || cluster >= MAX_NR_CLUSTERS);
> +     __mcpm_cpu_going_down(cpu, cluster);
> +     arch_spin_lock(&exynos_lock);
> +     BUG_ON(__mcpm_cluster_state(cluster) != CLUSTER_UP);
> +     kfs_use_count[cpu][cluster]--;
> +
> +     if (kfs_use_count[cpu][cluster] == 0) {
> +             exynos_core_power_down(cpu, cluster);
> +             --core_count[cluster];
> +             if (core_count[cluster] == 0)
> +                     last_man = true;
> +
> +     } else if (kfs_use_count[cpu][cluster] == 1) {
> +             skip_wfi = true;
> +     } else
> +             BUG();
> +     if (last_man && __mcpm_outbound_enter_critical(cpu, cluster)) {
> +             arch_spin_unlock(&exynos_lock);
> +             flush_cache_all();
> +             set_cr(get_cr() & ~CR_C);
> +             flush_cache_all();
> +             outer_flush_all();
> +             set_auxcr(get_auxcr() & ~(1 << 6));
> +             cci_disable_port_by_cpu(mpidr);
> +             __mcpm_outbound_leave_critical(cluster, CLUSTER_DOWN);

How does the cluster get powered down?  Does the power controller always
do that automatically when there are no powered-up CPUs left in a
cluster?

> +     } else {
> +             arch_spin_unlock(&exynos_lock);
> +             flush_cache_louis();
> +             set_cr(get_cr() & ~CR_C);
> +             flush_cache_louis();
> +             set_auxcr(get_auxcr() & ~(1 << 6));
> +     }
> +     __mcpm_cpu_down(cpu, cluster);
> +
> +     dsb();

You don't need this dsb, because __mcpm_cpu_down() contains one already.
This is not just coincidence, because __mcpm_cpu_down() is a signalling
operation, which kicks CPUs waiting in __mcpm_outbound_enter_critical()
or in mcpm_head.S.

> +     if (!skip_wfi)
> +             wfi();
> +}
> +static const struct mcpm_platform_ops exynos_power_ops = {
> +     .power_up       = exynos_power_up,
> +     .power_down     = exynos_power_down,

What about .suspend ?

> +};
> +
> +static void __init edcs_data_init(void)
> +{
> +     unsigned int mpidr, cpu, cluster;
> +
> +     mpidr = read_cpuid_mpidr();
> +     cpu = MPIDR_AFFINITY_LEVEL(mpidr, 0);
> +     cluster = MPIDR_AFFINITY_LEVEL(mpidr, 1);
> +     pr_debug("%s: cpu %u cluster %u\n", __func__, cpu, cluster);
> +     BUG_ON(cpu >= 4 || cluster >= 2);
> +     kfs_use_count[cpu][cluster] = 1;
> +     ++core_count[cluster];
> +     __cci_control_port_by_index(MAX_NR_CLUSTERS - cluster, true);
> +}
> +
> +
> +static int __init edcs_init(void)
> +{
> +     struct device_node *node;
> +
> +     if (!cci_probed())
> +             return -ENODEV;
> +
> +     node = of_find_compatible_node(NULL, NULL, "samsung,edcs");
> +     if (!node)
> +             return -ENODEV;
> +     edcs_data_init();
> +     mcpm_smp_set_ops();
> +     mcpm_platform_register(&exynos_power_ops);
> +
> +     /*
> +      * Future entries into the kernel can now go
> +      * through the cluster entry vectors.
> +      */
> +
> +     __raw_writel(virt_to_phys(mcpm_entry_point),
> +                     S5P_VA_SYSRAM_NS + 0x1c);
> +
> +     pr_info("EDCS: EXYNOS5410 DUAL CLUSTER SUPPORT installed\n");
> +
> +     return 0;
> +}
> +
> +early_initcall(edcs_init);
> diff --git a/arch/arm/mach-exynos/edcs.h b/arch/arm/mach-exynos/edcs.h
> new file mode 100644
> index 0000000..dd3e204
> --- /dev/null
> +++ b/arch/arm/mach-exynos/edcs.h
> @@ -0,0 +1,41 @@
> +/*
> + * Copyright (c) 2013 Samsung Electronics Co., Ltd.
> + * Author: Tarek Dakhran <t.dakhran@samsung.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + *
> + * EDCS(EXYNOS dual cluster support) for Exynos5410 SoC.
> + */
> +
> +#include <linux/arm-cci.h>
> +#include <linux/of_address.h>
> +#include <linux/init.h>
> +#include <linux/io.h>
> +#include <mach/regs-pmu.h>
> +
> +#define EXYNOS5410_ARM_COMMON_CONFIGURATION     S5P_PMUREG(0x2500)
> +#define EXYNOS5410_COMMON_CONFIGURATION(_nr)        \
> +     (EXYNOS5410_ARM_COMMON_CONFIGURATION + ((_nr) * 0x80))
> +#define EXYNOS5410_COMMON_STATUS(_nr)               \
> +     (EXYNOS5410_COMMON_CONFIGURATION(_nr) + 0x4)
> +#define EXYNOS5410_COMMON_OPTION(_nr)               \
> +     (EXYNOS5410_COMMON_CONFIGURATION(_nr) + 0x8)
> +
> +#define EXYNOS5410_ARM_L2_CONFIGURATION         S5P_PMUREG(0x2600)
> +#define EXYNOS5410_L2_CONFIGURATION(_nr)    \
> +     (EXYNOS5410_ARM_L2_CONFIGURATION + ((_nr) * 0x80))
> +#define EXYNOS5410_L2_STATUS(_nr)           \
> +     (EXYNOS5410_L2_CONFIGURATION(_nr) + 0x4)
> +#define EXYNOS5410_L2_OPTION(_nr)           \
> +     (EXYNOS5410_L2_CONFIGURATION(_nr) + 0x8)
> +
> +#define EXYNOS5410_CORE_CONFIGURATION(_nr)        \
> +     (S5P_ARM_CORE0_CONFIGURATION + ((_nr) * 0x80))
> +#define EXYNOS5410_CORE_STATUS(_nr)               \
> +     (EXYNOS5410_CORE_CONFIGURATION(_nr) + 0x4)
> +#define EXYNOS5410_CORE_OPTION(_nr)               \
> +     (EXYNOS5410_CORE_CONFIGURATION(_nr) + 0x8)
> +
> +#define EXYNOS5_PA_CCI                  0x10D20000

This physical address should be discovered from the DT by the arm-cci
driver.  If the arm-cci driver and arm,cci-400 binding are insufficient
for your needs, that needs discussion.

If querying the CCI status is necessary, interfaces should be added to
the arm-cci driver to allow that instead of poking it directly.


[...]

Cheers
---Dave

