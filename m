Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752703Ab3JYKGn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Oct 2013 06:06:43 -0400
Received: from mail-la0-f48.google.com ([209.85.215.48]:34030 "EHLO
	mail-la0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752328Ab3JYKGj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Oct 2013 06:06:39 -0400
Date: Fri, 25 Oct 2013 13:06:33 +0300
From: Aliaksei Katovich <aliaksei.katovich@gmail.com>
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
Subject: Re: [PATCH v2 3/4] ARM: EXYNOS: add Exynos Dual Cluster Support
Message-ID: <20131025100633.GN3061@cat.local>
References: <1381763305-7085-1-git-send-email-v.tyrtov@samsung.com>
 <1381763305-7085-4-git-send-email-v.tyrtov@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1381763305-7085-4-git-send-email-v.tyrtov@samsung.com>
X-Operating-System: GNU/Linux
X-Kernel: Linux 3.12.0-rc1+
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi Vyacheslav;

> From: Tarek Dakhran <t.dakhran@samsung.com>
> 
> Add EDCS(Exynos Dual Cluster Support) for Samsung Exynos5410 SoC.
> This enables all 8 cores, 4 x A7 and 4 x A15 run at the same time.
> 
> Signed-off-by: Tarek Dakhran <t.dakhran@samsung.com>
> Signed-off-by: Vyacheslav Tyrtov <v.tyrtov@samsung.com>
> ---
>  arch/arm/mach-exynos/Makefile |   2 +
>  arch/arm/mach-exynos/edcs.c   | 270 ++++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 272 insertions(+)
>  create mode 100644 arch/arm/mach-exynos/edcs.c
> 
> diff --git a/arch/arm/mach-exynos/Makefile b/arch/arm/mach-exynos/Makefile
> index 5369615..ba6efdb 100644
> --- a/arch/arm/mach-exynos/Makefile
> +++ b/arch/arm/mach-exynos/Makefile
> @@ -34,3 +34,5 @@ AFLAGS_exynos-smc.o		:=-Wa,-march=armv7-a$(plus_sec)
>  
>  obj-$(CONFIG_MACH_EXYNOS4_DT)		+= mach-exynos4-dt.o
>  obj-$(CONFIG_MACH_EXYNOS5_DT)		+= mach-exynos5-dt.o
> +
> +obj-$(CONFIG_SOC_EXYNOS5410)		+= edcs.o
> diff --git a/arch/arm/mach-exynos/edcs.c b/arch/arm/mach-exynos/edcs.c
> new file mode 100644
> index 0000000..e304bd9
> --- /dev/null
> +++ b/arch/arm/mach-exynos/edcs.c
> @@ -0,0 +1,270 @@
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
> +#include <linux/init.h>
> +#include <linux/io.h>
> +#include <linux/of_address.h>
> +#include <linux/spinlock.h>
> +#include <linux/errno.h>
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
> +#define EDCS_CPUS_PER_CLUSTER	4
> +#define EDCS_CLUSTERS		2
> +
> +/* Exynos5410 power management registers */
> +#define EDCS_CORE_CONFIGURATION(_nr)	(S5P_ARM_CORE0_CONFIGURATION	\
> +						+ ((_nr) * 0x80))
> +#define EDCS_CORE_STATUS(_nr)		(EDCS_CORE_CONFIGURATION(_nr) + 0x4)
> +#define EDCS_CORE_OPTION(_nr)		(EDCS_CORE_CONFIGURATION(_nr) + 0x8)
> +
> +#define REG_CPU_STATE_ADDR0		(S5P_VA_SYSRAM_NS + 0x28)
> +#define REG_CPU_STATE_ADDR(_nr)		(REG_CPU_STATE_ADDR0 +	\
> +						 _nr * EDCS_CPUS_PER_CLUSTER)
> +
> +static arch_spinlock_t edcs_lock = __ARCH_SPIN_LOCK_UNLOCKED;
> +
> +static int edcs_use_count[EDCS_CPUS_PER_CLUSTER][EDCS_CLUSTERS];
> +static int core_count[EDCS_CLUSTERS];
> +
> +static void exynos_core_power_control(unsigned int cpu, unsigned int cluster,
> +				bool enable)
> +{
> +	unsigned int offset = cluster * EDCS_CPUS_PER_CLUSTER + cpu;
> +	int value = enable ? S5P_CORE_LOCAL_PWR_EN : 0;
> +
> +	if ((__raw_readl(EDCS_CORE_STATUS(offset)) & 0x3) != value)
> +		__raw_writel(value, EDCS_CORE_CONFIGURATION(offset));
> +}
> +
> +static void exynos_core_power_up(unsigned int cpu, unsigned int cluster)
> +{
> +	exynos_core_power_control(cpu, cluster, true);
> +}
> +
> +static void exynos_core_power_down(unsigned int cpu, unsigned int cluster)
> +{
> +	exynos_core_power_control(cpu, cluster, false);
> +}
> +
> +void set_boot_flag(unsigned int cpu, unsigned int mode)
> +{
> +	__raw_writel(mode, REG_CPU_STATE_ADDR(cpu));
> +}
> +
> +static int exynos_power_up(unsigned int cpu, unsigned int cluster)
> +{
> +	pr_debug("%s: cpu %u cluster %u\n", __func__, cpu, cluster);
> +	BUG_ON(cpu >= EDCS_CPUS_PER_CLUSTER || cluster >= EDCS_CLUSTERS);
> +
> +	local_irq_disable();
> +	arch_spin_lock(&edcs_lock);
> +
> +	edcs_use_count[cpu][cluster]++;
> +	if (edcs_use_count[cpu][cluster] == 1) {
> +		++core_count[cluster];
> +		set_boot_flag(cpu, 0x2);
> +		exynos_core_power_up(cpu, cluster);
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
> +static void exynos_power_down(void)
> +{
> +	unsigned int mpidr, cpu, cluster;
> +	bool last_man = false, skip_wfi = false;
> +
> +	mpidr = read_cpuid_mpidr();
> +	cpu = MPIDR_AFFINITY_LEVEL(mpidr, 0);
> +	cluster = MPIDR_AFFINITY_LEVEL(mpidr, 1);
> +
> +	pr_debug("%s: cpu %u cluster %u\n", __func__, cpu, cluster);
> +	BUG_ON(cpu >= EDCS_CPUS_PER_CLUSTER  || cluster >= EDCS_CLUSTERS);
> +
> +	__mcpm_cpu_going_down(cpu, cluster);
> +
> +	arch_spin_lock(&edcs_lock);
> +	BUG_ON(__mcpm_cluster_state(cluster) != CLUSTER_UP);
> +	edcs_use_count[cpu][cluster]--;
> +	if (edcs_use_count[cpu][cluster] == 0) {
> +		--core_count[cluster];
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
> +		 */
> +		asm volatile(
> +		"str	fp, [sp, #-4]!\n\t"
> +		"mrc	p15, 0, r0, c1, c0, 0	@ get CR\n\t"
> +		"bic	r0, r0, #"__stringify(CR_C)"\n\t"
> +		"mcr	p15, 0, r0, c1, c0, 0	@ set CR\n\t"
> +		"isb\n\t"
> +		"bl	v7_flush_dcache_all\n\t"
> +		"clrex\n\t"
> +		"mrc	p15, 0, r0, c1, c0, 1	@ get AUXCR\n\t"
> +		"bic	r0, r0, #(1 << 6)	@ disable local coherency\n\t"
> +		"mcr	p15, 0, r0, c1, c0, 1	@ set AUXCR\n\t"
> +		"isb\n\t"
> +		"dsb\n\t"
> +		"ldr	fp, [sp], #4"
> +		: : : "r0", "r1", "r2", "r3", "r4", "r5", "r6", "r7",
> +			"r9", "r10", "lr", "memory");
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
> +		asm volatile(
> +		"str	fp, [sp, #-4]!\n\t"
> +		"mrc	p15, 0, r0, c1, c0, 0	@ get CR\n\t"
> +		"bic	r0, r0, #"__stringify(CR_C)"\n\t"
> +		"mcr	p15, 0, r0, c1, c0, 0	@ set CR\n\t"
> +		"isb\n\t"
> +		"bl	v7_flush_dcache_louis\n\t"
> +		"clrex\n\t"
> +		"mrc	p15, 0, r0, c1, c0, 1	@ get AUXCR\n\t"
> +		"bic	r0, r0, #(1 << 6)	@ disable local coherency\n\t"
> +		"mcr	p15, 0, r0, c1, c0, 1	@ set AUXCR\n\t"
> +		"isb\n\t"
> +		"dsb\n\t"
> +		"ldr	fp, [sp], #4"
> +		: : : "r0", "r1", "r2", "r3", "r4", "r5", "r6", "r7",
> +		      "r9", "r10", "lr", "memory");
> +
> +	}
> +	__mcpm_cpu_down(cpu, cluster);
> +
> +	if (!skip_wfi) {
> +		exynos_core_power_down(cpu, cluster);
> +		wfi();
> +	}
> +}
> +
> +static const struct mcpm_platform_ops exynos_power_ops = {
> +	.power_up	= exynos_power_up,
> +	.power_down	= exynos_power_down,
> +};
> +
> +static void __init edcs_data_init(void)
> +{
> +	unsigned int mpidr, cpu, cluster;
> +
> +	mpidr = read_cpuid_mpidr();
> +	cpu = MPIDR_AFFINITY_LEVEL(mpidr, 0);
> +	cluster = MPIDR_AFFINITY_LEVEL(mpidr, 1);
> +
> +	pr_debug("%s: cpu %u cluster %u\n", __func__, cpu, cluster);
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

	This code breaks odroid-xu boot with NR_CPUS set to 8. Kernel panics
	like this:

%< -----------------------------------------------------------------------
[    5.315000] drivers/rtc/hctosys.c: unable to open rtc device (rtc0)
[    5.320000] Freeing unused kernel memory: 216K (c049b000 - c04d1000)
[    5.325000] Unhandled fault: imprecise external abort (0x1406) at 0x00000000
[    5.340000] Kernel panic - not syncing: Attempted to kill init! exitcode=0x00000007
[    5.340000] 
[    5.345000] mmc_host mmc0: Bus speed (slot 0) = 100000000Hz (slot req 200000Hz, actual 200000HZ div = 250)
[    5.355000] CPU: 3 PID: 1 Comm: init Not tainted 3.12.0-rc5-00006-g847e427-dirty #1
[    5.365000] [<c0014d40>] (unwind_backtrace+0x0/0xf8) from [<c00117cc>] (show_stack+0x10/0x14)
[    5.370000] [<c00117cc>] (show_stack+0x10/0x14) from [<c03633ac>] (dump_stack+0x6c/0xac)
[    5.380000] mmc_host mmc0: Bus speed (slot 0) = 100000000Hz (slot req 196079Hz, actual 196078HZ div = 255)
[    5.390000] [<c03633ac>] (dump_stack+0x6c/0xac) from [<c03609fc>] (panic+0x90/0x1e8)
[    5.395000] [<c03609fc>] (panic+0x90/0x1e8) from [<c002048c>] (do_exit+0x780/0x834)
[    5.405000] [<c002048c>] (do_exit+0x780/0x834) from [<c002062c>] (do_group_exit+0x3c/0xb0)
[    5.410000] [<c002062c>] (do_group_exit+0x3c/0xb0) from [<c002ae80>] (get_signal_to_deliver+0x1d4/0x534)
[    5.420000] [<c002ae80>] (get_signal_to_deliver+0x1d4/0x534) from [<c0010d08>] (do_signal+0x100/0x40c)
[    5.430000] [<c0010d08>] (do_signal+0x100/0x40c) from [<c0011348>] (do_work_pending+0x68/0xa8)
[    5.430000] mmc_host mmc1: Bus speed (slot 0) = 100000000Hz (slot req 50000000Hz, actual 50000000HZ div = 1)
[    5.430000] mmc1: new high speed SDHC card at address b368
[    5.435000] mmcblk0: mmc1:b368 USD   14.9 GiB 
[    5.440000]  mmcblk0: p1 p2 p3 < p5 p6 p7 >
[    5.455000] mmc_host mmc0: Bus speed (slot 0) = 100000000Hz (slot req 400000Hz, actual 400000HZ div = 125)
[    5.475000] [<c0011348>] (do_work_pending+0x68/0xa8) from [<c000e420>] (work_pending+0xc/0x20)
[    5.480000] CPU1: stopping
[    5.480000] CPU: 1 PID: 0 Comm: swapper/1 Not tainted 3.12.0-rc5-00006-g847e427-dirty #1
[    5.480000] [<c0014d40>] (unwind_backtrace+0x0/0xf8) from [<c00117cc>] (show_stack+0x10/0x14)
[    5.480000] [<c00117cc>] (show_stack+0x10/0x14) from [<c03633ac>] (dump_stack+0x6c/0xac)
[    5.480000] [<c03633ac>] (dump_stack+0x6c/0xac) from [<c0013604>] (handle_IPI+0xf8/0x11c)
[    5.480000] [<c0013604>] (handle_IPI+0xf8/0x11c) from [<c000851c>] (gic_handle_irq+0x60/0x68)
[    5.480000] [<c000851c>] (gic_handle_irq+0x60/0x68) from [<c00122c0>] (__irq_svc+0x40/0x70)
[    5.480000] Exception stack(0xef0a7f88 to 0xef0a7fd0)
[    5.480000] 7f80:                   00000001 00000000 008d20ff 00000001 00000000 00000000
[    5.480000] 7fa0: c04d07a0 60000113 010da000 412fc0f3 c15aa7a0 00000000 00000001 ef0a7fd0
[    5.480000] 7fc0: c0072d74 c0072d78 20000113 ffffffff
[    5.480000] [<c00122c0>] (__irq_svc+0x40/0x70) from [<c0072d78>] (rcu_idle_exit+0x68/0xb8)
[    5.480000] [<c0072d78>] (rcu_idle_exit+0x68/0xb8) from [<c00550a4>] (cpu_startup_entry+0x6c/0x148)
[    5.480000] [<c00550a4>] (cpu_startup_entry+0x6c/0x148) from [<400085c4>] (0x400085c4)
[    5.480000] CPU0: stopping
[    5.480000] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 3.12.0-rc5-00006-g847e427-dirty #1
[    5.480000] [<c0014d40>] (unwind_backtrace+0x0/0xf8) from [<c00117cc>] (show_stack+0x10/0x14)
[    5.480000] [<c00117cc>] (show_stack+0x10/0x14) from [<c03633ac>] (dump_stack+0x6c/0xac)
[    5.480000] [<c03633ac>] (dump_stack+0x6c/0xac) from [<c0013604>] (handle_IPI+0xf8/0x11c)
[    5.480000] [<c0013604>] (handle_IPI+0xf8/0x11c) from [<c000851c>] (gic_handle_irq+0x60/0x68)
[    5.480000] [<c000851c>] (gic_handle_irq+0x60/0x68) from [<c00122c0>] (__irq_svc+0x40/0x70)
[    5.480000] Exception stack(0xc04d3f70 to 0xc04d3fb8)
[    5.480000] SMP: failed to stop secondary CPUs
[    5.480000] 3f60:                                     00000000 00000000 00002190 00000000
[    5.480000] 3f80: c04d2000 c050a88f 00000001 c050a88f c04da44c 412fc0f3 c036a960 00000000
[    5.480000] 3fa0: 00000020 c04d3fb8 c000f5d4 c000f5d8 60000113 ffffffff
[    5.480000] [<c00122c0>] (__irq_svc+0x40/0x70) from [<c000f5d8>] (arch_cpu_idle+0x28/0x30)
[    5.480000] [<c000f5d8>] (arch_cpu_idle+0x28/0x30) from [<c0055094>] (cpu_startup_entry+0x5c/0x148)
[    5.480000] [<c0055094>] (cpu_startup_entry+0x5c/0x148) from [<c049ba9c>] (start_kernel+0x32c/0x384)
[    5.480000] CPU2: stopping
[    5.480000] CPU: 2 PID: 0 Comm: swapper/2 Not tainted 3.12.0-rc5-00006-g847e427-dirty #1
[    5.480000] [<c0014d40>] (unwind_backtrace+0x0/0xf8) from [<c00117cc>] (show_stack+0x10/0x14)
[    5.480000] [<c00117cc>] (show_stack+0x10/0x14) from [<c03633ac>] (dump_stack+0x6c/0xac)
[    5.480000] [<c03633ac>] (dump_stack+0x6c/0xac) from [<c0013604>] (handle_IPI+0xf8/0x11c)
[    5.480000] [<c0013604>] (handle_IPI+0xf8/0x11c) from [<c000851c>] (gic_handle_irq+0x60/0x68)
[    5.480000] [<c000851c>] (gic_handle_irq+0x60/0x68) from [<c00122c0>] (__irq_svc+0x40/0x70)
[    5.480000] Exception stack(0xef0a9fa0 to 0xef0a9fe8)
[    5.480000] 9fa0: 00000002 00000000 008e4858 00000000 ef0a8000 c050a88f 00000001 c050a88f
[    5.480000] 9fc0: c04da44c 412fc0f3 c036a960 00000000 00000001 ef0a9fe8 c000f5d4 c000f5d8
[    5.480000] 9fe0: 60000113 ffffffff
[    5.480000] [<c00122c0>] (__irq_svc+0x40/0x70) from [<c000f5d8>] (arch_cpu_idle+0x28/0x30)
[    5.480000] [<c000f5d8>] (arch_cpu_idle+0x28/0x30) from [<c0055094>] (cpu_startup_entry+0x5c/0x148)
[    5.480000] [<c0055094>] (cpu_startup_entry+0x5c/0x148) from [<400085c4>] (0x400085c4)
%< -----------------------------------------------------------------------

	I checked arch/arm/mach-vexpress/tc2_pm.c to see how CCI is enabled
	there an realized that you should follow same pattern, i.e.:

        asm volatile (" \n"
"       cmp     r0, #1 \n"
"       bxne    lr \n"
"       b       cci_enable_port_for_self ");

	In this case only one cluster (4 LITTLE cores for Exynos5410) will be
	initialized at boot time. And no panic.

--
Aliaksei

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
> +	__raw_writel(virt_to_phys(mcpm_entry_point),
> +				S5P_VA_SYSRAM_NS + 0x1c);
> +
> +	edcs_data_init();
> +	mcpm_smp_set_ops();
> +
> +	ret = mcpm_platform_register(&exynos_power_ops);
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
> 
