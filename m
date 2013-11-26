Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757273Ab3KZPcB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 10:32:01 -0500
Received: from fw-tnat.cambridge.arm.com ([217.140.96.21]:51844 "EHLO
	cam-smtp0.cambridge.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756969Ab3KZPb6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 10:31:58 -0500
Date: Tue, 26 Nov 2013 15:30:26 +0000
From: Dave Martin <Dave.Martin@arm.com>
To: Vyacheslav Tyrtov <v.tyrtov@samsung.com>
Cc: linux-kernel@vger.kernel.org, Mark Rutland <mark.rutland@arm.com>,
        nicolas.pitre@linaro.org, Daniel Lezcano <daniel.lezcano@linaro.org>,
        Heiko Stuebner <heiko@sntech.de>, linux-doc@vger.kernel.org,
        tomasz.figa@gmail.com, Naour Romain <romain.naour@openwide.fr>,
        Tarek Dakhran <t.dakhran@samsung.com>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Russell King <linux@arm.linux.org.uk>,
        Stephen Warren <swarren@wwwdotorg.org>, devicetree@vger.kernel.org,
        Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Herring <rob.herring@calxeda.com>,
        linux-samsung-soc@vger.kernel.org, Ben Dooks <ben-linux@fluff.org>,
        Mike Turquette <mturquette@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-arm-kernel@lists.infradead.org, Rob Landley <rob@landley.net>
Subject: Re: [PATCH v4 4/4] ARM: EXYNOS: add Exynos Dual Cluster Support
Message-ID: <20131126153026.GB2355@e103592.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 26, 2013 at 12:58:08PM +0400, Vyacheslav Tyrtov wrote:
> From: Tarek Dakhran <t.dakhran@samsung.com>
> 
> Add EDCS(Exynos Dual Cluster Support) for Samsung Exynos5410 SoC.
> This enables all 8 cores, 4 x A7 and 4 x A15 run at the same time.
> 
> Signed-off-by: Tarek Dakhran <t.dakhran@samsung.com>
> Signed-off-by: Vyacheslav Tyrtov <v.tyrtov@samsung.com>
> ---
>  arch/arm/mach-exynos/Makefile |   2 +
>  arch/arm/mach-exynos/edcs.c   | 297 ++++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 299 insertions(+)
>  create mode 100644 arch/arm/mach-exynos/edcs.c
> 
> diff --git a/arch/arm/mach-exynos/Makefile b/arch/arm/mach-exynos/Makefile
> index 8930b66..bc1f7f9 100644
> --- a/arch/arm/mach-exynos/Makefile
> +++ b/arch/arm/mach-exynos/Makefile
> @@ -34,3 +34,5 @@ AFLAGS_exynos-smc.o		:=-Wa,-march=armv7-a$(plus_sec)
>  
>  obj-$(CONFIG_ARCH_EXYNOS4)	+= mach-exynos4-dt.o
>  obj-$(CONFIG_ARCH_EXYNOS5)	+= mach-exynos5-dt.o
> +
> +obj-$(CONFIG_SOC_EXYNOS5410)	+= edcs.o
> diff --git a/arch/arm/mach-exynos/edcs.c b/arch/arm/mach-exynos/edcs.c
> new file mode 100644
> index 0000000..29f0bdd
> --- /dev/null
> +++ b/arch/arm/mach-exynos/edcs.c
> @@ -0,0 +1,297 @@
> +/*
> + * arch/arm/mach-exynos/edcs.c - exynos dual cluster power management support
> + *
> + * Copyright (c) 2013 Samsung Electronics Co., Ltd.
> + * Author: Tarek Dakhran <t.dakhran@samsung.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + *
> + * EDCS(exynos dual cluster support) for Exynos5410 SoC.
> + */
> +
> +#define pr_fmt(fmt)	"%s: " fmt, __func__
> +
> +#include <linux/init.h>
> +#include <linux/io.h>
> +#include <linux/of_address.h>
> +#include <linux/spinlock.h>
> +#include <linux/errno.h>
> +#include <linux/irqchip/arm-gic.h>
> +#include <linux/delay.h>
> +
> +#include <asm/mcpm.h>
> +#include <asm/proc-fns.h>
> +#include <asm/cacheflush.h>
> +#include <asm/cputype.h>
> +#include <asm/cp15.h>
> +
> +#include <linux/arm-cci.h>
> +#include <mach/regs-pmu.h>
> +
> +#define EDCS_CPUS_PER_CLUSTER		4
> +#define EDCS_CLUSTERS			2
> +
> +/* Exynos5410 power management registers */
> +#define EDCS_CORE_CONFIGURATION(_nr)	(S5P_ARM_CORE0_CONFIGURATION	\
> +						+ ((_nr) * 0x80))
> +#define EDCS_CORE_STATUS(_nr)		(EDCS_CORE_CONFIGURATION(_nr) + 0x4)
> +#define EDCS_CORE_OPTION(_nr)		(EDCS_CORE_CONFIGURATION(_nr) + 0x8)
> +
> +#define REG_CPU_STATE_ADDR0		(S5P_VA_SYSRAM_NS + 0x28)
> +#define REG_CPU_STATE_ADDR(_nr)		(REG_CPU_STATE_ADDR0 +	\
> +						 (_nr) * EDCS_CPUS_PER_CLUSTER)
> +
> +#define SECONDARY_RESET			(1 << 1)
> +#define REG_ENTRY_ADDR			(S5P_VA_SYSRAM_NS + 0x1c)
> +
> +#define EDCS_CORE_PWR_ON		0x3
> +#define EDCS_CORE_PWR_OFF		0x0
> +#define CORE_PWR_STATE_MASK		0x3
> +
> +static arch_spinlock_t edcs_lock = __ARCH_SPIN_LOCK_UNLOCKED;
> +
> +static int edcs_use_count[EDCS_CPUS_PER_CLUSTER][EDCS_CLUSTERS];
> +static int core_count[EDCS_CLUSTERS];
> +
> +/*
> + * this_core_to_pcpu reads mpidr and defines cluster and cpu.
> + */
> +static void this_core_to_pcpu(unsigned int *pcpu, unsigned int *pcluster)
> +{
> +	unsigned int mpidr;
> +
> +	mpidr = read_cpuid_mpidr();
> +	*pcpu = MPIDR_AFFINITY_LEVEL(mpidr, 0);
> +	*pcluster = MPIDR_AFFINITY_LEVEL(mpidr, 1);
> +}
> +
> +/*
> + * core_power_state is used to get core power state.
> + * returns:
> + *        0x0 - powered off;
> + *        0x3 - powered on;
> + *        other values - in process;
> + */
> +static int core_power_state(unsigned int cpu, unsigned int cluster)
> +{
> +	unsigned int offset = cluster * EDCS_CPUS_PER_CLUSTER + cpu;
> +	int status = readl_relaxed(EDCS_CORE_STATUS(offset));
> +
> +	return status & CORE_PWR_STATE_MASK;
> +}
> +
> +static void edcs_core_power_up(unsigned int cpu, unsigned int cluster)
> +{
> +	unsigned int offset = cluster * EDCS_CPUS_PER_CLUSTER + cpu;
> +	if (core_power_state(cpu, cluster) == EDCS_CORE_PWR_OFF) {

This still looks racy.

edcs_core_power_up and edcs_core_power_down are both called with
edcs_lock held, and cluster/cpu ref counting is done before we
get here.  So we know that the power state *change* is really supposed
to happen.

*If* my assumption is correct that there is a delay between requesting a
new power state, and the change being reported as completed in
EDCS_CORE_STATUS:


For edcs_core_power_up(), there may be a pending power-down
request which is not visible in the EDCS_CORE_STATUS registers yet.

I think this may mean that a power-up request will simply be missed
if the core status does not read as EDCS_CORE_PWR_OFF yet.  If that
can happen, then you need to wait -- calling the power_down_finish
method may be the right thing to do.

However, we cannot sleep here because edcs_lock is held and IRQs
are masked.  It may make sense to factor the status check out of
power_down_finish and make it a separate function, then make
edcs_core_power_up() return an error code to edcs_power_up() to
indicate success or failure.

edcs_power_up() can respond to the error code by temporarily
releasing edcs_lock and re-enabling interrupts while it sleeps.

edcs_power_up() should return an appropriate error code if you time out.


Maybe my assumptions are wrong, but if the above is not required,
it would be good to see an explanation of why.


> +		/* boot flag should be written before powering up */
> +		wmb();
> +		writel_relaxed(EDCS_CORE_PWR_ON,
> +				 EDCS_CORE_CONFIGURATION(offset));
> +	}
> +}
> +
> +static void edcs_core_power_down(unsigned int cpu, unsigned int cluster)
> +{
> +	unsigned int offset = cluster * EDCS_CPUS_PER_CLUSTER + cpu;
> +	if (core_power_state(cpu, cluster) == EDCS_CORE_PWR_ON)

This check doesn't seem to make sense.  edcs_core_power_down() should
only ever be called on the CPU being powered down.

So, if the above if() condition is false, then the CPU executing it is
actually powered off??  That's a pretty neat trick for power-saving, but
it sounds unlikely...

This check should perhaps be a BUG_ON( ... != EDCS_CORE_PWR_ON), or
removed completely.

> +		writel_relaxed(EDCS_CORE_PWR_OFF,
> +				 EDCS_CORE_CONFIGURATION(offset));
> +}
> +
> +void set_boot_flag(unsigned int cpu, unsigned int mode)
> +{
> +	writel_relaxed(mode, REG_CPU_STATE_ADDR(cpu));
> +}
> +
> +static int edcs_power_up(unsigned int cpu, unsigned int cluster)
> +{
> +	pr_debug("cpu %u cluster %u\n", cpu, cluster);
> +	BUG_ON(cpu >= EDCS_CPUS_PER_CLUSTER || cluster >= EDCS_CLUSTERS);
> +
> +	local_irq_disable();
> +	arch_spin_lock(&edcs_lock);
> +
> +	edcs_use_count[cpu][cluster]++;
> +	if (edcs_use_count[cpu][cluster] == 1) {
> +		++core_count[cluster];
> +		set_boot_flag(cpu, SECONDARY_RESET);
> +		edcs_core_power_up(cpu, cluster);
> +	} else if (edcs_use_count[cpu][cluster] != 2) {
> +		/*
> +		 * The only possible values are:
> +		 * 0 = CPU down
> +		 * 1 = CPU (still) up
> +		 * 2 = CPU requested to be up before it had a chance
> +		 *     to actually make itself down.
> +		 * Any other value is a bug.
> +		 */
> +		BUG();
> +	}
> +
> +	arch_spin_unlock(&edcs_lock);
> +	local_irq_enable();
> +
> +	return 0;
> +}
> +static void edcs_power_down(void)
> +{
> +	unsigned int mpidr, cpu, cluster;
> +	bool last_man = false, skip_wfi = false;
> +
> +	this_core_to_pcpu(&cpu, &cluster);
> +	mpidr = read_cpuid_mpidr();
> +
> +	pr_debug("cpu %u cluster %u\n", cpu, cluster);
> +	BUG_ON(cpu >= EDCS_CPUS_PER_CLUSTER  || cluster >= EDCS_CLUSTERS);
> +
> +	__mcpm_cpu_going_down(cpu, cluster);
> +
> +	arch_spin_lock(&edcs_lock);
> +	BUG_ON(__mcpm_cluster_state(cluster) != CLUSTER_UP);
> +	edcs_use_count[cpu][cluster]--;
> +	if (edcs_use_count[cpu][cluster] == 0) {
> +		--core_count[cluster];
> +		edcs_core_power_down(cpu, cluster);
> +		if (core_count[cluster] == 0)
> +			last_man = true;
> +	} else if (edcs_use_count[cpu][cluster] == 1) {
> +		/*
> +		 * A power_up request went ahead of us.
> +		 * Even if we do not want to shut this CPU down,
> +		 * the caller expects a certain state as if the WFI
> +		 * was aborted.  So let's continue with cache cleaning.
> +		 */
> +		skip_wfi = true;
> +	} else
> +		BUG();
> +
> +	if (!skip_wfi)
> +		gic_cpu_if_down();
> +
> +	if (last_man && __mcpm_outbound_enter_critical(cpu, cluster)) {
> +		arch_spin_unlock(&edcs_lock);
> +
> +		if (read_cpuid_part_number() == ARM_CPU_PART_CORTEX_A15) {
> +			/*
> +			 * On the Cortex-A15 we need to disable
> +			 * L2 prefetching before flushing the cache.
> +			 */
> +			asm volatile(
> +			"mcr	p15, 1, %0, c15, c0, 3\n\t"
> +			"isb\n\t"
> +			"dsb"
> +			: : "r" (0x400));
> +		}
> +
> +		/*
> +		 * We need to disable and flush the whole (L1 and L2) cache.
> +		 * Let's do it in the safest possible way i.e. with
> +		 * no memory access within the following sequence
> +		 * including the stack.
> +		 *
> +		 * Note: fp is preserved to the stack explicitly prior doing
> +		 * this since adding it to the clobber list is incompatible
> +		 * with having CONFIG_FRAME_POINTER=y.

The above comments are not necessary now.  They are replaced by the
comments for v7_exit_coherency_flush() in cacheflush.h.

> +		 */
> +		v7_exit_coherency_flush(all);
> +
> +		cci_disable_port_by_cpu(mpidr);
> +
> +		__mcpm_outbound_leave_critical(cluster, CLUSTER_DOWN);
> +
> +	} else {
> +		arch_spin_unlock(&edcs_lock);
> +		/*
> +			* We need to disable and flush only the L1 cache.
> +			* Let's do it in the safest possible way as above.
> +		*/
> +		v7_exit_coherency_flush(louis);
> +
> +	}
> +	__mcpm_cpu_down(cpu, cluster);
> +
> +	if (!skip_wfi)
> +		wfi();
> +}
> +
> +static int edcs_power_down_finish(unsigned int cpu, unsigned int cluster)
> +{
> +	unsigned int timeout = 1000;
> +	unsigned int sleep_time = 10;
> +
> +	pr_debug("cpu %u cluster %u\n", cpu, cluster);
> +	BUG_ON(cpu >= EDCS_CPUS_PER_CLUSTER  || cluster >= EDCS_CLUSTERS);
> +
> +	do {
> +		if (ACCESS_ONCE(edcs_use_count[cpu][cluster]) == 0) {
> +			/* checking if core powered down */
> +			if (core_power_state(cpu, cluster) == EDCS_CORE_PWR_OFF)
> +				return 0;
> +		}
> +		msleep(sleep_time);
> +		timeout -= sleep_time;
> +	} while (timeout);

This looks OK.  Note that if timeout % sleep_time != 0, the loop
may not terminate.  This is not really a problem unless someone
breaks that assumption during maintenance in the future.

This is a minor nit, but the risk can be avoided by making sleep_time
*and* timeout of type int (not unsigned int), and ending the loop with:

	} while (timeout > 0);


Cheers
---Dave

> +
> +	return -ETIMEDOUT; /* timeout */
> +}
> +
> +static const struct mcpm_platform_ops edcs_power_ops = {
> +	.power_up		= edcs_power_up,
> +	.power_down		= edcs_power_down,
> +	.power_down_finish	= edcs_power_down_finish,
> +};
> +
> +static void __init edcs_data_init(void)
> +{
> +	unsigned int cpu, cluster;
> +
> +	this_core_to_pcpu(&cpu, &cluster);
> +
> +	pr_debug("cpu %u cluster %u\n", cpu, cluster);
> +	BUG_ON(cpu >= EDCS_CPUS_PER_CLUSTER  || cluster >= EDCS_CLUSTERS);
> +	edcs_use_count[cpu][cluster] = 1;
> +	++core_count[cluster];
> +}
> +
> +/*
> + * Enable cluster-level coherency, in preparation for turning on the MMU.
> + */
> +static void __naked edcs_power_up_setup(unsigned int affinity_level)
> +{
> +	asm volatile ("\n"
> +	"b	cci_enable_port_for_self");
> +}
> +
> +static int __init edcs_init(void)
> +{
> +	int ret;
> +	struct device_node *node;
> +
> +	node = of_find_compatible_node(NULL, NULL, "samsung,exynos5410");
> +	if (!node)
> +		return -ENODEV;
> +
> +	if (!cci_probed())
> +		return -ENODEV;
> +
> +	/*
> +	 * Future entries into the kernel can now go
> +	 * through the cluster entry vectors.
> +	 */
> +	writel_relaxed(virt_to_phys(mcpm_entry_point), REG_ENTRY_ADDR);
> +
> +	edcs_data_init();
> +	mcpm_smp_set_ops();
> +
> +	ret = mcpm_platform_register(&edcs_power_ops);
> +	if (!ret) {
> +		mcpm_sync_init(edcs_power_up_setup);
> +		pr_info("EDCS power management initialized\n");
> +	}
> +	return ret;
> +}
> +
> +early_initcall(edcs_init);
> -- 
> 1.8.1.5
> 
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
