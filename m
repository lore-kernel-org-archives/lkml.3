Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751336Ab3JATzb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Oct 2013 15:55:31 -0400
Received: from mail-qe0-f45.google.com ([209.85.128.45]:41229 "EHLO
	mail-qe0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750994Ab3JATz2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Oct 2013 15:55:28 -0400
Date: Tue, 1 Oct 2013 15:55:24 -0400 (EDT)
From: Nicolas Pitre <nicolas.pitre@linaro.org>
To: Vyacheslav Tyrtov <v.tyrtov@samsung.com>
cc: linux-kernel@vger.kernel.org, Rob Herring <rob.herring@calxeda.com>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>, Kukjin Kim <kgene.kim@samsung.com>,
        Russell King <linux@arm.linux.org.uk>, Ben Dooks <ben-linux@fluff.org>,
        Mike Turquette <mturquette@linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>, Heiko Stuebner <heiko@sntech.de>,
        Naour Romain <romain.naour@openwide.fr>, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org,
        Tarek Dakhran <t.dakhran@samsung.com>
Subject: Re: [PATCH 3/6] ARM: EXYNOS: add Exynos Dual Cluster Support
In-Reply-To: <1380644227-12244-4-git-send-email-v.tyrtov@samsung.com>
Message-ID: <alpine.LFD.2.03.1310011451390.21228@syhkavp.arg>
References: <1380644227-12244-1-git-send-email-v.tyrtov@samsung.com> <1380644227-12244-4-git-send-email-v.tyrtov@samsung.com>
User-Agent: Alpine 2.03 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 1 Oct 2013, Vyacheslav Tyrtov wrote:

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
> @@ -34,3 +34,5 @@ AFLAGS_exynos-smc.o		:=-Wa,-march=armv7-a$(plus_sec)
>  
>  obj-$(CONFIG_MACH_EXYNOS4_DT)		+= mach-exynos4-dt.o
>  obj-$(CONFIG_MACH_EXYNOS5_DT)		+= mach-exynos5-dt.o
> +
> +obj-$(CONFIG_ARM_CCI)		+= edcs.o	edcs_status.o
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

Why do you need a vexpress include?

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

The "kfs_" prefix looks like a remnant of ancient code which stood for 
"Kingfisher" before it was renamed to "DCSCB".  :-)

You might consider using "edcs_" instead.  Same thing for exynos_lock 
above which is rather generic a name.  Maybe edcs_lock would be better.

Also please define your own constant such as EDCS_CPUS_PER_CLUSTER 
instead of using MAX_CPUS_PER_CLUSTER as the later is related to the 
code limit and not the actual hardware topology, and it could change in 
the future.

> +static int core_count[MAX_NR_CLUSTERS]; > +
> +static int exynos_core_power_control(unsigned int cpu, unsigned int cluster,
> +				int enable)
> +{
> +	unsigned long timeout = jiffies + msecs_to_jiffies(10);
> +	unsigned int offset = cluster * MAX_CPUS_PER_CLUSTER + cpu;

Here's an example of where your code would break if MAX_CPUS_PER_CLUSTER 
changes.

> +	int value = enable ? S5P_CORE_LOCAL_PWR_EN : 0;
> +
> +	if ((__raw_readl(EXYNOS5410_CORE_STATUS(offset)) & 0x3) == value)
> +		return 0;
> +
> +	__raw_writel(value, EXYNOS5410_CORE_CONFIGURATION(offset));
> +	do {
> +		if ((__raw_readl(EXYNOS5410_CORE_STATUS(offset)) & 0x3)
> +				== value)
> +			return 0;
> +	} while (time_before(jiffies, timeout));
> +
> +	return -EDEADLK;
> +}
> +static int exynos_cluster_power_control(unsigned int cluster, int enable)
> +{
> +	unsigned long timeout = jiffies + msecs_to_jiffies(10);
> +	int value = enable ? S5P_CORE_LOCAL_PWR_EN : 0;
> +
> +	if ((__raw_readl(EXYNOS5410_COMMON_STATUS(cluster)) & 0x3)
> +			== value)

You could put the above if () all on the same line.

> +		return 0;
> +
> +	__raw_writel(value, EXYNOS5410_COMMON_CONFIGURATION(cluster));
> +	do {
> +		if ((__raw_readl(EXYNOS5410_COMMON_STATUS(cluster)) &
> +			__raw_readl(EXYNOS5410_L2_STATUS(cluster)) & 0x3)
> +				== value)
> +			return 0;
> +	} while (time_before(jiffies, timeout));
> +
> +	return -EDEADLK;
> +}
> +
> +static int exynos_core_power_up(unsigned int cpu, unsigned int cluster)
> +{
> +	return exynos_core_power_control(cpu, cluster, 1);
> +}
> +
> +static int exynos_core_power_down(unsigned int cpu, unsigned int cluster)
> +{
> +	return exynos_core_power_control(cpu, cluster, 0);
> +}
> +
> +static int exynos_cluster_power_up(unsigned int cluster)
> +{
> +	return exynos_cluster_power_control(cluster, 1);
> +}
> +
> +static int exynos_power_up(unsigned int cpu, unsigned int cluster)
> +{
> +	int ret;
> +	local_irq_disable();
> +	arch_spin_lock(&exynos_lock);
> +
> +	pr_info("A%d CORE%d\n", 15 - cluster * 8, cpu);

You should consider tuning this down to pr_debug.

> +	kfs_use_count[cpu][cluster]++;
> +	if (kfs_use_count[cpu][cluster] == 1) {
> +		++core_count[cluster];
> +		if (core_count[cluster] == 1) {
> +			ret = exynos_cluster_power_up(cluster);
> +			if (ret) {
> +				pr_err("%s: cluster %u power up error\n",
> +					__func__, cluster);
> +				return ret;
> +			}
> +			__cci_control_port_by_index(MAX_NR_CLUSTERS
> +					 - cluster, true);

This is wrong and very racy.  The state machine implemented in 
mcpm-head.S is there already to handle proper synchronization for you.  

You need to provide a tiny bit of code to mcpm_sync_init() in order to 
set things up properly.

Please have a look at arch/arm/mach-vexpress/tc2_pm.c in latest mainline 
kernel tree, in particular tc2_pm_power_up_setup().

> +		}
> +		ret = exynos_core_power_up(cpu, cluster);
> +		if (ret) {
> +			pr_err("%s: cpu %u cluster %u power up error\n",
> +				__func__, cpu, cluster);
> +			return ret;
> +		}
> +	} else if (kfs_use_count[cpu][cluster] != 2) {
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
> +	arch_spin_unlock(&exynos_lock);
> +	local_irq_enable();
> +	return 0;
> +}
> +static void exynos_power_down(void)
> +{
> +	unsigned int mpidr, cpu, cluster;
> +	bool last_man = false, skip_wfi = false;
> +	mpidr = read_cpuid_mpidr();
> +	cpu = MPIDR_AFFINITY_LEVEL(mpidr, 0);
> +	cluster = MPIDR_AFFINITY_LEVEL(mpidr, 1);
> +
> +	pr_info("A%d CORE%d\n", 15 - cluster * 8, cpu);
> +	BUG_ON(cpu >= MAX_CPUS_PER_CLUSTER  || cluster >= MAX_NR_CLUSTERS);
> +	__mcpm_cpu_going_down(cpu, cluster);
> +	arch_spin_lock(&exynos_lock);
> +	BUG_ON(__mcpm_cluster_state(cluster) != CLUSTER_UP);
> +	kfs_use_count[cpu][cluster]--;
> +
> +	if (kfs_use_count[cpu][cluster] == 0) {
> +		exynos_core_power_down(cpu, cluster);
> +		--core_count[cluster];
> +		if (core_count[cluster] == 0)
> +			last_man = true;
> +
> +	} else if (kfs_use_count[cpu][cluster] == 1) {
> +		skip_wfi = true;
> +	} else
> +		BUG();
> +	if (last_man && __mcpm_outbound_enter_critical(cpu, cluster)) {
> +		arch_spin_unlock(&exynos_lock);
> +		flush_cache_all();
> +		set_cr(get_cr() & ~CR_C);
> +		flush_cache_all();
> +		outer_flush_all();
> +		set_auxcr(get_auxcr() & ~(1 << 6));
> +		cci_disable_port_by_cpu(mpidr);
> +		__mcpm_outbound_leave_critical(cluster, CLUSTER_DOWN);
> +	} else {
> +		arch_spin_unlock(&exynos_lock);
> +		flush_cache_louis();
> +		set_cr(get_cr() & ~CR_C);
> +		flush_cache_louis();
> +		set_auxcr(get_auxcr() & ~(1 << 6));

This cache handling sequence is also buggy.  Please have a look at 
arch/arm/mach-vexpress/tc2_pm.c for an example of how it should be done.

This code sequence should also be abstracted into a common 
implementation eventually, but in the mean time the TC2 implementation 
is a good model to follow.

> + } + __mcpm_cpu_down(cpu, cluster); + + dsb(); + if (!skip_wfi) + 
> wfi(); +} +static const struct mcpm_platform_ops exynos_power_ops = { 
> + .power_up = exynos_power_up, + .power_down = exynos_power_down, +}; 
> + +static void __init edcs_data_init(void) +{ + unsigned int mpidr, 
> cpu, cluster; + + mpidr = read_cpuid_mpidr(); + cpu = 
> MPIDR_AFFINITY_LEVEL(mpidr, 0); + cluster = 
> MPIDR_AFFINITY_LEVEL(mpidr, 1); + pr_debug("%s: cpu %u cluster %u\n", 
> __func__, cpu, cluster); + BUG_ON(cpu >= 4 || cluster >= 2); + 
> kfs_use_count[cpu][cluster] = 1; + ++core_count[cluster]; + 
> __cci_control_port_by_index(MAX_NR_CLUSTERS - cluster, true); +} + + 
> +static int __init edcs_init(void) +{ + struct device_node *node; + + 
> if (!cci_probed()) + return -ENODEV; + + node = 
> of_find_compatible_node(NULL, NULL, "samsung,edcs"); + if (!node) + 
> return -ENODEV; + edcs_data_init(); + mcpm_smp_set_ops(); + 
> mcpm_platform_register(&exynos_power_ops);

You are lacking a call to mcpm_sync_init().

> +
> +	/*
> +	 * Future entries into the kernel can now go
> +	 * through the cluster entry vectors.
> +	 */
> +
> +	__raw_writel(virt_to_phys(mcpm_entry_point),
> +			S5P_VA_SYSRAM_NS + 0x1c);
> +
> +	pr_info("EDCS: EXYNOS5410 DUAL CLUSTER SUPPORT installed\n");
> +
> +	return 0;
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
> +	(EXYNOS5410_ARM_COMMON_CONFIGURATION + ((_nr) * 0x80))
> +#define EXYNOS5410_COMMON_STATUS(_nr)               \
> +	(EXYNOS5410_COMMON_CONFIGURATION(_nr) + 0x4)
> +#define EXYNOS5410_COMMON_OPTION(_nr)               \
> +	(EXYNOS5410_COMMON_CONFIGURATION(_nr) + 0x8)
> +
> +#define EXYNOS5410_ARM_L2_CONFIGURATION         S5P_PMUREG(0x2600)
> +#define EXYNOS5410_L2_CONFIGURATION(_nr)    \
> +	(EXYNOS5410_ARM_L2_CONFIGURATION + ((_nr) * 0x80))
> +#define EXYNOS5410_L2_STATUS(_nr)           \
> +	(EXYNOS5410_L2_CONFIGURATION(_nr) + 0x4)
> +#define EXYNOS5410_L2_OPTION(_nr)           \
> +	(EXYNOS5410_L2_CONFIGURATION(_nr) + 0x8)
> +
> +#define EXYNOS5410_CORE_CONFIGURATION(_nr)        \
> +	(S5P_ARM_CORE0_CONFIGURATION + ((_nr) * 0x80))
> +#define EXYNOS5410_CORE_STATUS(_nr)               \
> +	(EXYNOS5410_CORE_CONFIGURATION(_nr) + 0x4)
> +#define EXYNOS5410_CORE_OPTION(_nr)               \
> +	(EXYNOS5410_CORE_CONFIGURATION(_nr) + 0x8)
> +
> +#define EXYNOS5_PA_CCI                  0x10D20000
> diff --git a/arch/arm/mach-exynos/edcs_status.c b/arch/arm/mach-exynos/edcs_status.c
> new file mode 100644
> index 0000000..bff1e7f
> --- /dev/null
> +++ b/arch/arm/mach-exynos/edcs_status.c
> @@ -0,0 +1,110 @@
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
> +#include <linux/fs.h>
> +#include <linux/miscdevice.h>
> +#include <asm/uaccess.h>
> +
> +#include "edcs.h"
> +
> +int edcs_check_status(char *info)
[...]

What is the purpose of this driver?  What information does it provide?

In any case, creating a misc device for this is most likely not the best 
way to export that kind of information.


> +{
> +	size_t it = 30;
> +	int i;
> +
> +	void __iomem *cci_base;
> +
> +	cci_base = ioremap(EXYNOS5_PA_CCI, SZ_64K);
> +	if (!cci_base)
> +		return -ENOMEM;
> +
> +	if ((__raw_readl(EXYNOS5410_COMMON_STATUS(0)) & 0x3) == 3)
> +		info[it] = '1';
> +	it += 3;
> +
> +	for (i = 0; i < 4; i++) {
> +		if ((__raw_readl(EXYNOS5410_CORE_STATUS(i)) & 0x3) == 3)
> +			info[it] = '1';
> +		it += 3;
> +	}
> +
> +	if ((__raw_readl(EXYNOS5410_L2_STATUS(0)) & 0x3)	== 3)
> +		info[it] = '1';
> +	it += 3;
> +
> +	if ((readl(cci_base + 0x4000 + 1 * 0x1000) & 0x3) == 3)
> +		info[it] = '1';
> +
> +	it += 10;
> +
> +	if ((__raw_readl(EXYNOS5410_COMMON_STATUS(1)) & 0x3) == 3)
> +		info[it] = '1';
> +	it += 3;
> +
> +	for (i = 4; i < 8; i++) {
> +		if ((__raw_readl(EXYNOS5410_CORE_STATUS(i)) & 0x3) == 3)
> +			info[it] = '1';
> +		it += 3;
> +	}
> +
> +	if ((__raw_readl(EXYNOS5410_L2_STATUS(1)) & 0x3) == 3)
> +		info[it] = '1';
> +	it += 3;
> +
> +	if ((readl(cci_base + 0x4000 + 0 * 0x1000) & 0x3) == 3)
> +		info[it] = '1';
> +
> +	iounmap(cci_base);
> +	return 0;
> +}
> +
> +static ssize_t edcs_status_read(struct file *file, char __user *buf,
> +				size_t len, loff_t *pos)
> +{
> +
> +	char info[] = "\tC  0  1  2  3 L2 CCI\n"
> +		"[A15]   0  0  0  0  0  0  0\n"
> +		" [A7]   0  0  0  0  0  0  0\n";
> +	size_t count = sizeof(info);
> +	edcs_check_status(info);
> +	return simple_read_from_buffer(buf, len, pos, info, count);
> +}
> +
> +static const struct file_operations edcs_status_fops = {
> +	.read		= edcs_status_read,
> +	.owner		= THIS_MODULE,
> +};
> +static struct miscdevice edcs_status_device = {
> +	.name = "edcs_status",
> +	.minor = 255,
> +	.fops = &edcs_status_fops,
> +};
> +
> +static int __init edcs_dev_init(void)
> +{
> +	struct device_node *node;
> +	int ret;
> +	if (!cci_probed())
> +		return -ENODEV;
> +
> +	node = of_find_compatible_node(NULL, NULL, "samsung,edcs");
> +	if (!node)
> +		return -ENODEV;
> +
> +	ret = misc_register(&edcs_status_device);
> +	if (ret) {
> +		pr_err("EDCS: edcs_status device is not registered\n");
> +		return ret;
> +	}
> +	pr_info("EDCS: edcs_status device registered\n");
> +	return 0;
> +}
> +device_initcall(edcs_dev_init);
> -- 
> 1.8.1.5
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
