Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752888AbaIYWMz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 18:12:55 -0400
Received: from mail-pa0-f42.google.com ([209.85.220.42]:57973 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751805AbaIYWMy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 18:12:54 -0400
Message-ID: <54249351.2020103@gmail.com>
Date: Thu, 25 Sep 2014 15:12:33 -0700
From: Florian Fainelli <f.fainelli@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.2
MIME-Version: 1.0
To: Brian Norris <computersforpeace@gmail.com>, Arnd Bergmann <arnd@arndb.de>
CC: Matt Porter <mporter@linaro.org>, Marc Carino <marc.ceeeee@gmail.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org,
        Russell King <linux@arm.linux.org.uk>,
        Rob Herring <robherring2@gmail.com>
Subject: Re: [PATCH v10] ARM: brcmstb: reintroduce SMP support
References: <1409959864-21594-1-git-send-email-computersforpeace@gmail.com>
In-Reply-To: <1409959864-21594-1-git-send-email-computersforpeace@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd,

Do you want us to send a pull request which contains this patch and the
one that adds DEBUG_LL support to brcmstb?

Thanks!

On 09/05/2014 04:31 PM, Brian Norris wrote:
> Support for SMP bringup of the B15 CPUs on Broadcom STB chips was added
> in commit 4fbe66d9903425156c193ae44c81c0f7557755c4 but was reverted in
> commit fc3e825fa91636a5d1b992e769b2d8279877bfad to address some late
> review comments. This reintroduces SMP support.
> 
> Signed-off-by: Marc Carino <marc.ceeeee@gmail.com>
> Signed-off-by: Brian Norris <computersforpeace@gmail.com>
> ---
> This is v10, as there were 9 revision before this was merged for the first
> time. This patch now stands alone.
> 
> Changes since v9:
>   - Compile platsmp-brcmstb.c only for ARMv7 (v6 doesn't support
>     v7_exit_coherency_flush())
>   - Add a few comments about the hand-rolled per-CPU state polling
>     * There were some objections to this previously, but I don't see a clear,
>       correct, and better solution
>   - Remove / fix ordering of a few barriers
>   - Drop duplicated print messages
>   - Don't repeat core irq_disable()
>   - Add error checking for missing DT info
>   - Drop unnecssary 'boot_lock'
>   - Replace magic delay with barrier
>   - Don't call panic() in non-SMP context
> 
>  arch/arm/mach-bcm/Makefile          |   2 +
>  arch/arm/mach-bcm/brcmstb.h         |  19 +++
>  arch/arm/mach-bcm/headsmp-brcmstb.S |  33 ++++
>  arch/arm/mach-bcm/platsmp-brcmstb.c | 329 ++++++++++++++++++++++++++++++++++++
>  4 files changed, 383 insertions(+)
>  create mode 100644 arch/arm/mach-bcm/brcmstb.h
>  create mode 100644 arch/arm/mach-bcm/headsmp-brcmstb.S
>  create mode 100644 arch/arm/mach-bcm/platsmp-brcmstb.c
> 
> diff --git a/arch/arm/mach-bcm/Makefile b/arch/arm/mach-bcm/Makefile
> index b19a39652545..59ef0f80119f 100644
> --- a/arch/arm/mach-bcm/Makefile
> +++ b/arch/arm/mach-bcm/Makefile
> @@ -35,5 +35,7 @@ obj-$(CONFIG_ARCH_BCM2835)	+= board_bcm2835.o
>  obj-$(CONFIG_ARCH_BCM_5301X)	+= bcm_5301x.o
>  
>  ifeq ($(CONFIG_ARCH_BRCMSTB),y)
> +CFLAGS_platsmp-brcmstb.o	+= -march=armv7-a
>  obj-y				+= brcmstb.o
> +obj-$(CONFIG_SMP)		+= headsmp-brcmstb.o platsmp-brcmstb.o
>  endif
> diff --git a/arch/arm/mach-bcm/brcmstb.h b/arch/arm/mach-bcm/brcmstb.h
> new file mode 100644
> index 000000000000..ec0c3d112b36
> --- /dev/null
> +++ b/arch/arm/mach-bcm/brcmstb.h
> @@ -0,0 +1,19 @@
> +/*
> + * Copyright (C) 2013-2014 Broadcom Corporation
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public License as
> + * published by the Free Software Foundation version 2.
> + *
> + * This program is distributed "as is" WITHOUT ANY WARRANTY of any
> + * kind, whether express or implied; without even the implied warranty
> + * of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + */
> +
> +#ifndef __BRCMSTB_H__
> +#define __BRCMSTB_H__
> +
> +void brcmstb_secondary_startup(void);
> +
> +#endif /* __BRCMSTB_H__ */
> diff --git a/arch/arm/mach-bcm/headsmp-brcmstb.S b/arch/arm/mach-bcm/headsmp-brcmstb.S
> new file mode 100644
> index 000000000000..199c1ea58248
> --- /dev/null
> +++ b/arch/arm/mach-bcm/headsmp-brcmstb.S
> @@ -0,0 +1,33 @@
> +/*
> + * SMP boot code for secondary CPUs
> + * Based on arch/arm/mach-tegra/headsmp.S
> + *
> + * Copyright (C) 2010 NVIDIA, Inc.
> + * Copyright (C) 2013-2014 Broadcom Corporation
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public License as
> + * published by the Free Software Foundation version 2.
> + *
> + * This program is distributed "as is" WITHOUT ANY WARRANTY of any
> + * kind, whether express or implied; without even the implied warranty
> + * of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + */
> +
> +#include <asm/assembler.h>
> +#include <linux/linkage.h>
> +#include <linux/init.h>
> +
> +        .section ".text.head", "ax"
> +
> +ENTRY(brcmstb_secondary_startup)
> +        /*
> +         * Ensure CPU is in a sane state by disabling all IRQs and switching
> +         * into SVC mode.
> +         */
> +        setmode	PSR_I_BIT | PSR_F_BIT | SVC_MODE, r0
> +
> +        bl      v7_invalidate_l1
> +        b       secondary_startup
> +ENDPROC(brcmstb_secondary_startup)
> diff --git a/arch/arm/mach-bcm/platsmp-brcmstb.c b/arch/arm/mach-bcm/platsmp-brcmstb.c
> new file mode 100644
> index 000000000000..31c87a284a34
> --- /dev/null
> +++ b/arch/arm/mach-bcm/platsmp-brcmstb.c
> @@ -0,0 +1,329 @@
> +/*
> + * Broadcom STB CPU SMP and hotplug support for ARM
> + *
> + * Copyright (C) 2013-2014 Broadcom Corporation
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public License as
> + * published by the Free Software Foundation version 2.
> + *
> + * This program is distributed "as is" WITHOUT ANY WARRANTY of any
> + * kind, whether express or implied; without even the implied warranty
> + * of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + */
> +
> +#include <linux/delay.h>
> +#include <linux/errno.h>
> +#include <linux/init.h>
> +#include <linux/io.h>
> +#include <linux/of_address.h>
> +#include <linux/of_platform.h>
> +#include <linux/printk.h>
> +#include <linux/regmap.h>
> +#include <linux/smp.h>
> +#include <linux/mfd/syscon.h>
> +
> +#include <asm/cacheflush.h>
> +#include <asm/cp15.h>
> +#include <asm/mach-types.h>
> +#include <asm/smp_plat.h>
> +
> +#include "brcmstb.h"
> +
> +enum {
> +	ZONE_MAN_CLKEN_MASK		= BIT(0),
> +	ZONE_MAN_RESET_CNTL_MASK	= BIT(1),
> +	ZONE_MAN_MEM_PWR_MASK		= BIT(4),
> +	ZONE_RESERVED_1_MASK		= BIT(5),
> +	ZONE_MAN_ISO_CNTL_MASK		= BIT(6),
> +	ZONE_MANUAL_CONTROL_MASK	= BIT(7),
> +	ZONE_PWR_DN_REQ_MASK		= BIT(9),
> +	ZONE_PWR_UP_REQ_MASK		= BIT(10),
> +	ZONE_BLK_RST_ASSERT_MASK	= BIT(12),
> +	ZONE_PWR_OFF_STATE_MASK		= BIT(25),
> +	ZONE_PWR_ON_STATE_MASK		= BIT(26),
> +	ZONE_DPG_PWR_STATE_MASK		= BIT(28),
> +	ZONE_MEM_PWR_STATE_MASK		= BIT(29),
> +	ZONE_RESET_STATE_MASK		= BIT(31),
> +	CPU0_PWR_ZONE_CTRL_REG		= 1,
> +	CPU_RESET_CONFIG_REG		= 2,
> +};
> +
> +static void __iomem *cpubiuctrl_block;
> +static void __iomem *hif_cont_block;
> +static u32 cpu0_pwr_zone_ctrl_reg;
> +static u32 cpu_rst_cfg_reg;
> +static u32 hif_cont_reg;
> +
> +#ifdef CONFIG_HOTPLUG_CPU
> +/*
> + * We must quiesce a dying CPU before it can be killed by the boot CPU. Because
> + * one or more cache may be disabled, we must flush to ensure coherency. We
> + * cannot use traditionl completion structures or spinlocks as they rely on
> + * coherency.
> + */
> +static DEFINE_PER_CPU_ALIGNED(int, per_cpu_sw_state);
> +
> +static int per_cpu_sw_state_rd(u32 cpu)
> +{
> +	sync_cache_r(SHIFT_PERCPU_PTR(&per_cpu_sw_state, per_cpu_offset(cpu)));
> +	return per_cpu(per_cpu_sw_state, cpu);
> +}
> +
> +static void per_cpu_sw_state_wr(u32 cpu, int val)
> +{
> +	dmb();
> +	per_cpu(per_cpu_sw_state, cpu) = val;
> +	sync_cache_w(SHIFT_PERCPU_PTR(&per_cpu_sw_state, per_cpu_offset(cpu)));
> +}
> +#else
> +static inline void per_cpu_sw_state_wr(u32 cpu, int val) { }
> +#endif
> +
> +static void __iomem *pwr_ctrl_get_base(u32 cpu)
> +{
> +	void __iomem *base = cpubiuctrl_block + cpu0_pwr_zone_ctrl_reg;
> +	base += (cpu_logical_map(cpu) * 4);
> +	return base;
> +}
> +
> +static u32 pwr_ctrl_rd(u32 cpu)
> +{
> +	void __iomem *base = pwr_ctrl_get_base(cpu);
> +	return readl_relaxed(base);
> +}
> +
> +static void pwr_ctrl_wr(u32 cpu, u32 val)
> +{
> +	void __iomem *base = pwr_ctrl_get_base(cpu);
> +	writel(val, base);
> +}
> +
> +static void cpu_rst_cfg_set(u32 cpu, int set)
> +{
> +	u32 val;
> +	val = readl_relaxed(cpubiuctrl_block + cpu_rst_cfg_reg);
> +	if (set)
> +		val |= BIT(cpu_logical_map(cpu));
> +	else
> +		val &= ~BIT(cpu_logical_map(cpu));
> +	writel_relaxed(val, cpubiuctrl_block + cpu_rst_cfg_reg);
> +}
> +
> +static void cpu_set_boot_addr(u32 cpu, unsigned long boot_addr)
> +{
> +	const int reg_ofs = cpu_logical_map(cpu) * 8;
> +	writel_relaxed(0, hif_cont_block + hif_cont_reg + reg_ofs);
> +	writel_relaxed(boot_addr, hif_cont_block + hif_cont_reg + 4 + reg_ofs);
> +}
> +
> +static void brcmstb_cpu_boot(u32 cpu)
> +{
> +	/* Mark this CPU as "up" */
> +	per_cpu_sw_state_wr(cpu, 1);
> +
> +	/*
> +	 * Set the reset vector to point to the secondary_startup
> +	 * routine
> +	 */
> +	cpu_set_boot_addr(cpu, virt_to_phys(brcmstb_secondary_startup));
> +
> +	/* Unhalt the cpu */
> +	cpu_rst_cfg_set(cpu, 0);
> +}
> +
> +static void brcmstb_cpu_power_on(u32 cpu)
> +{
> +	/*
> +	 * The secondary cores power was cut, so we must go through
> +	 * power-on initialization.
> +	 */
> +	u32 tmp;
> +
> +	/* Request zone power up */
> +	pwr_ctrl_wr(cpu, ZONE_PWR_UP_REQ_MASK);
> +
> +	/* Wait for the power up FSM to complete */
> +	do {
> +		tmp = pwr_ctrl_rd(cpu);
> +	} while (!(tmp & ZONE_PWR_ON_STATE_MASK));
> +}
> +
> +static int brcmstb_cpu_get_power_state(u32 cpu)
> +{
> +	int tmp = pwr_ctrl_rd(cpu);
> +	return (tmp & ZONE_RESET_STATE_MASK) ? 0 : 1;
> +}
> +
> +#ifdef CONFIG_HOTPLUG_CPU
> +
> +static void brcmstb_cpu_die(u32 cpu)
> +{
> +	v7_exit_coherency_flush(all);
> +
> +	per_cpu_sw_state_wr(cpu, 0);
> +
> +	/* Sit and wait to die */
> +	wfi();
> +
> +	/* We should never get here... */
> +	while (1)
> +		;
> +}
> +
> +static int brcmstb_cpu_kill(u32 cpu)
> +{
> +	u32 tmp;
> +
> +	while (per_cpu_sw_state_rd(cpu))
> +		;
> +
> +	/* Program zone reset */
> +	pwr_ctrl_wr(cpu, ZONE_RESET_STATE_MASK | ZONE_BLK_RST_ASSERT_MASK |
> +			      ZONE_PWR_DN_REQ_MASK);
> +
> +	/* Verify zone reset */
> +	tmp = pwr_ctrl_rd(cpu);
> +	if (!(tmp & ZONE_RESET_STATE_MASK))
> +		pr_err("%s: Zone reset bit for CPU %d not asserted!\n",
> +			__func__, cpu);
> +
> +	/* Wait for power down */
> +	do {
> +		tmp = pwr_ctrl_rd(cpu);
> +	} while (!(tmp & ZONE_PWR_OFF_STATE_MASK));
> +
> +	/* Flush pipeline before resetting CPU */
> +	mb();
> +
> +	/* Assert reset on the CPU */
> +	cpu_rst_cfg_set(cpu, 1);
> +
> +	return 1;
> +}
> +
> +#endif /* CONFIG_HOTPLUG_CPU */
> +
> +static int __init setup_hifcpubiuctrl_regs(struct device_node *np)
> +{
> +	int rc = 0;
> +	char *name;
> +	struct device_node *syscon_np = NULL;
> +
> +	name = "syscon-cpu";
> +
> +	syscon_np = of_parse_phandle(np, name, 0);
> +	if (!syscon_np) {
> +		pr_err("can't find phandle %s\n", name);
> +		rc = -EINVAL;
> +		goto cleanup;
> +	}
> +
> +	cpubiuctrl_block = of_iomap(syscon_np, 0);
> +	if (!cpubiuctrl_block) {
> +		pr_err("iomap failed for cpubiuctrl_block\n");
> +		rc = -EINVAL;
> +		goto cleanup;
> +	}
> +
> +	rc = of_property_read_u32_index(np, name, CPU0_PWR_ZONE_CTRL_REG,
> +					&cpu0_pwr_zone_ctrl_reg);
> +	if (rc) {
> +		pr_err("failed to read 1st entry from %s property (%d)\n", name,
> +			rc);
> +		rc = -EINVAL;
> +		goto cleanup;
> +	}
> +
> +	rc = of_property_read_u32_index(np, name, CPU_RESET_CONFIG_REG,
> +					&cpu_rst_cfg_reg);
> +	if (rc) {
> +		pr_err("failed to read 2nd entry from %s property (%d)\n", name,
> +			rc);
> +		rc = -EINVAL;
> +		goto cleanup;
> +	}
> +
> +cleanup:
> +	of_node_put(syscon_np);
> +	return rc;
> +}
> +
> +static int __init setup_hifcont_regs(struct device_node *np)
> +{
> +	int rc = 0;
> +	char *name;
> +	struct device_node *syscon_np = NULL;
> +
> +	name = "syscon-cont";
> +
> +	syscon_np = of_parse_phandle(np, name, 0);
> +	if (!syscon_np) {
> +		pr_err("can't find phandle %s\n", name);
> +		rc = -EINVAL;
> +		goto cleanup;
> +	}
> +
> +	hif_cont_block = of_iomap(syscon_np, 0);
> +	if (!hif_cont_block) {
> +		pr_err("iomap failed for hif_cont_block\n");
> +		rc = -EINVAL;
> +		goto cleanup;
> +	}
> +
> +	/* Offset is at top of hif_cont_block */
> +	hif_cont_reg = 0;
> +
> +cleanup:
> +	of_node_put(syscon_np);
> +	return rc;
> +}
> +
> +static void __init brcmstb_cpu_ctrl_setup(unsigned int max_cpus)
> +{
> +	int rc;
> +	struct device_node *np;
> +	char *name;
> +
> +	name = "brcm,brcmstb-smpboot";
> +	np = of_find_compatible_node(NULL, NULL, name);
> +	if (!np) {
> +		pr_err("can't find compatible node %s\n", name);
> +		return;
> +	}
> +
> +	rc = setup_hifcpubiuctrl_regs(np);
> +	if (rc)
> +		return;
> +
> +	rc = setup_hifcont_regs(np);
> +	if (rc)
> +		return;
> +}
> +
> +static int brcmstb_boot_secondary(unsigned int cpu, struct task_struct *idle)
> +{
> +	/* Missing the brcm,brcmstb-smpboot DT node? */
> +	if (!cpubiuctrl_block || !hif_cont_block)
> +		return -ENODEV;
> +
> +	/* Bring up power to the core if necessary */
> +	if (brcmstb_cpu_get_power_state(cpu) == 0)
> +		brcmstb_cpu_power_on(cpu);
> +
> +	brcmstb_cpu_boot(cpu);
> +
> +	return 0;
> +}
> +
> +static struct smp_operations brcmstb_smp_ops __initdata = {
> +	.smp_prepare_cpus	= brcmstb_cpu_ctrl_setup,
> +	.smp_boot_secondary	= brcmstb_boot_secondary,
> +#ifdef CONFIG_HOTPLUG_CPU
> +	.cpu_kill		= brcmstb_cpu_kill,
> +	.cpu_die		= brcmstb_cpu_die,
> +#endif
> +};
> +
> +CPU_METHOD_OF_DECLARE(brcmstb_smp, "brcm,brahma-b15", &brcmstb_smp_ops);
> 

