Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756363AbaHYRfr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 13:35:47 -0400
Received: from mail-pa0-f50.google.com ([209.85.220.50]:40238 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756336AbaHYRfq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 13:35:46 -0400
Date: Mon, 25 Aug 2014 10:35:42 -0700
From: Brian Norris <computersforpeace@gmail.com>
To: Matt Porter <mporter@linaro.org>, Olof Johansson <olof@lixom.net>
Cc: linux-arm-kernel@lists.infradead.org,
        Florian Fainelli <f.fainelli@gmail.com>,
        Marc Carino <marc.ceeeee@gmail.com>,
        Gregory Fong <gregory.0xf0@gmail.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ARM: brcmstb: revert SMP support
Message-ID: <20140825173542.GX18411@ld-irv-0074>
References: <1407960049-1591-1-git-send-email-computersforpeace@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1407960049-1591-1-git-send-email-computersforpeace@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Matt, Olof,

Can this go into 3.17? Besides the other improvements that need to be
made to this code, more people are noticing the build errors Russell
noticed previously.

  http://article.gmane.org/gmane.linux.ports.arm.kernel/350226

I meant to have put [PATCH -3.17] in the subject, in case that would
help it get the attention it deserved.

Brian

On Wed, Aug 13, 2014 at 01:00:49PM -0700, Brian Norris wrote:
> There were several issues (of varying degree of importance) pointed out
> with this code late in the review cycle, yet the code was still merged.
> Let's rip it out for now and look at resubmitting at a later time.
> 
> This reverts most of commit 4fbe66d9903425156c193ae44c81c0f7557755c4.
> 
> Signed-off-by: Brian Norris <computersforpeace@gmail.com>
> ---
>  arch/arm/mach-bcm/Makefile          |   1 -
>  arch/arm/mach-bcm/brcmstb.h         |  19 --
>  arch/arm/mach-bcm/headsmp-brcmstb.S |  33 ----
>  arch/arm/mach-bcm/platsmp-brcmstb.c | 363 ------------------------------------
>  4 files changed, 416 deletions(-)
>  delete mode 100644 arch/arm/mach-bcm/brcmstb.h
>  delete mode 100644 arch/arm/mach-bcm/headsmp-brcmstb.S
>  delete mode 100644 arch/arm/mach-bcm/platsmp-brcmstb.c
> 
> diff --git a/arch/arm/mach-bcm/Makefile b/arch/arm/mach-bcm/Makefile
> index 67c492aabf4d..b19a39652545 100644
> --- a/arch/arm/mach-bcm/Makefile
> +++ b/arch/arm/mach-bcm/Makefile
> @@ -36,5 +36,4 @@ obj-$(CONFIG_ARCH_BCM_5301X)	+= bcm_5301x.o
>  
>  ifeq ($(CONFIG_ARCH_BRCMSTB),y)
>  obj-y				+= brcmstb.o
> -obj-$(CONFIG_SMP)		+= headsmp-brcmstb.o platsmp-brcmstb.o
>  endif
> diff --git a/arch/arm/mach-bcm/brcmstb.h b/arch/arm/mach-bcm/brcmstb.h
> deleted file mode 100644
> index ec0c3d112b36..000000000000
> --- a/arch/arm/mach-bcm/brcmstb.h
> +++ /dev/null
> @@ -1,19 +0,0 @@
> -/*
> - * Copyright (C) 2013-2014 Broadcom Corporation
> - *
> - * This program is free software; you can redistribute it and/or
> - * modify it under the terms of the GNU General Public License as
> - * published by the Free Software Foundation version 2.
> - *
> - * This program is distributed "as is" WITHOUT ANY WARRANTY of any
> - * kind, whether express or implied; without even the implied warranty
> - * of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> - * GNU General Public License for more details.
> - */
> -
> -#ifndef __BRCMSTB_H__
> -#define __BRCMSTB_H__
> -
> -void brcmstb_secondary_startup(void);
> -
> -#endif /* __BRCMSTB_H__ */
> diff --git a/arch/arm/mach-bcm/headsmp-brcmstb.S b/arch/arm/mach-bcm/headsmp-brcmstb.S
> deleted file mode 100644
> index 199c1ea58248..000000000000
> --- a/arch/arm/mach-bcm/headsmp-brcmstb.S
> +++ /dev/null
> @@ -1,33 +0,0 @@
> -/*
> - * SMP boot code for secondary CPUs
> - * Based on arch/arm/mach-tegra/headsmp.S
> - *
> - * Copyright (C) 2010 NVIDIA, Inc.
> - * Copyright (C) 2013-2014 Broadcom Corporation
> - *
> - * This program is free software; you can redistribute it and/or
> - * modify it under the terms of the GNU General Public License as
> - * published by the Free Software Foundation version 2.
> - *
> - * This program is distributed "as is" WITHOUT ANY WARRANTY of any
> - * kind, whether express or implied; without even the implied warranty
> - * of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> - * GNU General Public License for more details.
> - */
> -
> -#include <asm/assembler.h>
> -#include <linux/linkage.h>
> -#include <linux/init.h>
> -
> -        .section ".text.head", "ax"
> -
> -ENTRY(brcmstb_secondary_startup)
> -        /*
> -         * Ensure CPU is in a sane state by disabling all IRQs and switching
> -         * into SVC mode.
> -         */
> -        setmode	PSR_I_BIT | PSR_F_BIT | SVC_MODE, r0
> -
> -        bl      v7_invalidate_l1
> -        b       secondary_startup
> -ENDPROC(brcmstb_secondary_startup)
> diff --git a/arch/arm/mach-bcm/platsmp-brcmstb.c b/arch/arm/mach-bcm/platsmp-brcmstb.c
> deleted file mode 100644
> index af780e9c23a6..000000000000
> --- a/arch/arm/mach-bcm/platsmp-brcmstb.c
> +++ /dev/null
> @@ -1,363 +0,0 @@
> -/*
> - * Broadcom STB CPU SMP and hotplug support for ARM
> - *
> - * Copyright (C) 2013-2014 Broadcom Corporation
> - *
> - * This program is free software; you can redistribute it and/or
> - * modify it under the terms of the GNU General Public License as
> - * published by the Free Software Foundation version 2.
> - *
> - * This program is distributed "as is" WITHOUT ANY WARRANTY of any
> - * kind, whether express or implied; without even the implied warranty
> - * of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> - * GNU General Public License for more details.
> - */
> -
> -#include <linux/delay.h>
> -#include <linux/errno.h>
> -#include <linux/init.h>
> -#include <linux/io.h>
> -#include <linux/of_address.h>
> -#include <linux/of_platform.h>
> -#include <linux/printk.h>
> -#include <linux/regmap.h>
> -#include <linux/smp.h>
> -#include <linux/mfd/syscon.h>
> -#include <linux/spinlock.h>
> -
> -#include <asm/cacheflush.h>
> -#include <asm/cp15.h>
> -#include <asm/mach-types.h>
> -#include <asm/smp_plat.h>
> -
> -#include "brcmstb.h"
> -
> -enum {
> -	ZONE_MAN_CLKEN_MASK		= BIT(0),
> -	ZONE_MAN_RESET_CNTL_MASK	= BIT(1),
> -	ZONE_MAN_MEM_PWR_MASK		= BIT(4),
> -	ZONE_RESERVED_1_MASK		= BIT(5),
> -	ZONE_MAN_ISO_CNTL_MASK		= BIT(6),
> -	ZONE_MANUAL_CONTROL_MASK	= BIT(7),
> -	ZONE_PWR_DN_REQ_MASK		= BIT(9),
> -	ZONE_PWR_UP_REQ_MASK		= BIT(10),
> -	ZONE_BLK_RST_ASSERT_MASK	= BIT(12),
> -	ZONE_PWR_OFF_STATE_MASK		= BIT(25),
> -	ZONE_PWR_ON_STATE_MASK		= BIT(26),
> -	ZONE_DPG_PWR_STATE_MASK		= BIT(28),
> -	ZONE_MEM_PWR_STATE_MASK		= BIT(29),
> -	ZONE_RESET_STATE_MASK		= BIT(31),
> -	CPU0_PWR_ZONE_CTRL_REG		= 1,
> -	CPU_RESET_CONFIG_REG		= 2,
> -};
> -
> -static void __iomem *cpubiuctrl_block;
> -static void __iomem *hif_cont_block;
> -static u32 cpu0_pwr_zone_ctrl_reg;
> -static u32 cpu_rst_cfg_reg;
> -static u32 hif_cont_reg;
> -
> -#ifdef CONFIG_HOTPLUG_CPU
> -static DEFINE_PER_CPU_ALIGNED(int, per_cpu_sw_state);
> -
> -static int per_cpu_sw_state_rd(u32 cpu)
> -{
> -	sync_cache_r(SHIFT_PERCPU_PTR(&per_cpu_sw_state, per_cpu_offset(cpu)));
> -	return per_cpu(per_cpu_sw_state, cpu);
> -}
> -
> -static void per_cpu_sw_state_wr(u32 cpu, int val)
> -{
> -	per_cpu(per_cpu_sw_state, cpu) = val;
> -	dmb();
> -	sync_cache_w(SHIFT_PERCPU_PTR(&per_cpu_sw_state, per_cpu_offset(cpu)));
> -	dsb_sev();
> -}
> -#else
> -static inline void per_cpu_sw_state_wr(u32 cpu, int val) { }
> -#endif
> -
> -static void __iomem *pwr_ctrl_get_base(u32 cpu)
> -{
> -	void __iomem *base = cpubiuctrl_block + cpu0_pwr_zone_ctrl_reg;
> -	base += (cpu_logical_map(cpu) * 4);
> -	return base;
> -}
> -
> -static u32 pwr_ctrl_rd(u32 cpu)
> -{
> -	void __iomem *base = pwr_ctrl_get_base(cpu);
> -	return readl_relaxed(base);
> -}
> -
> -static void pwr_ctrl_wr(u32 cpu, u32 val)
> -{
> -	void __iomem *base = pwr_ctrl_get_base(cpu);
> -	writel(val, base);
> -}
> -
> -static void cpu_rst_cfg_set(u32 cpu, int set)
> -{
> -	u32 val;
> -	val = readl_relaxed(cpubiuctrl_block + cpu_rst_cfg_reg);
> -	if (set)
> -		val |= BIT(cpu_logical_map(cpu));
> -	else
> -		val &= ~BIT(cpu_logical_map(cpu));
> -	writel_relaxed(val, cpubiuctrl_block + cpu_rst_cfg_reg);
> -}
> -
> -static void cpu_set_boot_addr(u32 cpu, unsigned long boot_addr)
> -{
> -	const int reg_ofs = cpu_logical_map(cpu) * 8;
> -	writel_relaxed(0, hif_cont_block + hif_cont_reg + reg_ofs);
> -	writel_relaxed(boot_addr, hif_cont_block + hif_cont_reg + 4 + reg_ofs);
> -}
> -
> -static void brcmstb_cpu_boot(u32 cpu)
> -{
> -	pr_info("SMP: Booting CPU%d...\n", cpu);
> -
> -	/*
> -	 * set the reset vector to point to the secondary_startup
> -	 * routine
> -	 */
> -	cpu_set_boot_addr(cpu, virt_to_phys(brcmstb_secondary_startup));
> -
> -	/* unhalt the cpu */
> -	cpu_rst_cfg_set(cpu, 0);
> -}
> -
> -static void brcmstb_cpu_power_on(u32 cpu)
> -{
> -	/*
> -	 * The secondary cores power was cut, so we must go through
> -	 * power-on initialization.
> -	 */
> -	u32 tmp;
> -
> -	pr_info("SMP: Powering up CPU%d...\n", cpu);
> -
> -	/* Request zone power up */
> -	pwr_ctrl_wr(cpu, ZONE_PWR_UP_REQ_MASK);
> -
> -	/* Wait for the power up FSM to complete */
> -	do {
> -		tmp = pwr_ctrl_rd(cpu);
> -	} while (!(tmp & ZONE_PWR_ON_STATE_MASK));
> -
> -	per_cpu_sw_state_wr(cpu, 1);
> -}
> -
> -static int brcmstb_cpu_get_power_state(u32 cpu)
> -{
> -	int tmp = pwr_ctrl_rd(cpu);
> -	return (tmp & ZONE_RESET_STATE_MASK) ? 0 : 1;
> -}
> -
> -#ifdef CONFIG_HOTPLUG_CPU
> -
> -static void brcmstb_cpu_die(u32 cpu)
> -{
> -	v7_exit_coherency_flush(all);
> -
> -	/* Prevent all interrupts from reaching this CPU. */
> -	arch_local_irq_disable();
> -
> -	/*
> -	 * Final full barrier to ensure everything before this instruction has
> -	 * quiesced.
> -	 */
> -	isb();
> -	dsb();
> -
> -	per_cpu_sw_state_wr(cpu, 0);
> -
> -	/* Sit and wait to die */
> -	wfi();
> -
> -	/* We should never get here... */
> -	panic("Spurious interrupt on CPU %d received!\n", cpu);
> -}
> -
> -static int brcmstb_cpu_kill(u32 cpu)
> -{
> -	u32 tmp;
> -
> -	pr_info("SMP: Powering down CPU%d...\n", cpu);
> -
> -	while (per_cpu_sw_state_rd(cpu))
> -		;
> -
> -	/* Program zone reset */
> -	pwr_ctrl_wr(cpu, ZONE_RESET_STATE_MASK | ZONE_BLK_RST_ASSERT_MASK |
> -			      ZONE_PWR_DN_REQ_MASK);
> -
> -	/* Verify zone reset */
> -	tmp = pwr_ctrl_rd(cpu);
> -	if (!(tmp & ZONE_RESET_STATE_MASK))
> -		pr_err("%s: Zone reset bit for CPU %d not asserted!\n",
> -			__func__, cpu);
> -
> -	/* Wait for power down */
> -	do {
> -		tmp = pwr_ctrl_rd(cpu);
> -	} while (!(tmp & ZONE_PWR_OFF_STATE_MASK));
> -
> -	/* Settle-time from Broadcom-internal DVT reference code */
> -	udelay(7);
> -
> -	/* Assert reset on the CPU */
> -	cpu_rst_cfg_set(cpu, 1);
> -
> -	return 1;
> -}
> -
> -#endif /* CONFIG_HOTPLUG_CPU */
> -
> -static int __init setup_hifcpubiuctrl_regs(struct device_node *np)
> -{
> -	int rc = 0;
> -	char *name;
> -	struct device_node *syscon_np = NULL;
> -
> -	name = "syscon-cpu";
> -
> -	syscon_np = of_parse_phandle(np, name, 0);
> -	if (!syscon_np) {
> -		pr_err("can't find phandle %s\n", name);
> -		rc = -EINVAL;
> -		goto cleanup;
> -	}
> -
> -	cpubiuctrl_block = of_iomap(syscon_np, 0);
> -	if (!cpubiuctrl_block) {
> -		pr_err("iomap failed for cpubiuctrl_block\n");
> -		rc = -EINVAL;
> -		goto cleanup;
> -	}
> -
> -	rc = of_property_read_u32_index(np, name, CPU0_PWR_ZONE_CTRL_REG,
> -					&cpu0_pwr_zone_ctrl_reg);
> -	if (rc) {
> -		pr_err("failed to read 1st entry from %s property (%d)\n", name,
> -			rc);
> -		rc = -EINVAL;
> -		goto cleanup;
> -	}
> -
> -	rc = of_property_read_u32_index(np, name, CPU_RESET_CONFIG_REG,
> -					&cpu_rst_cfg_reg);
> -	if (rc) {
> -		pr_err("failed to read 2nd entry from %s property (%d)\n", name,
> -			rc);
> -		rc = -EINVAL;
> -		goto cleanup;
> -	}
> -
> -cleanup:
> -	if (syscon_np)
> -		of_node_put(syscon_np);
> -
> -	return rc;
> -}
> -
> -static int __init setup_hifcont_regs(struct device_node *np)
> -{
> -	int rc = 0;
> -	char *name;
> -	struct device_node *syscon_np = NULL;
> -
> -	name = "syscon-cont";
> -
> -	syscon_np = of_parse_phandle(np, name, 0);
> -	if (!syscon_np) {
> -		pr_err("can't find phandle %s\n", name);
> -		rc = -EINVAL;
> -		goto cleanup;
> -	}
> -
> -	hif_cont_block = of_iomap(syscon_np, 0);
> -	if (!hif_cont_block) {
> -		pr_err("iomap failed for hif_cont_block\n");
> -		rc = -EINVAL;
> -		goto cleanup;
> -	}
> -
> -	/* offset is at top of hif_cont_block */
> -	hif_cont_reg = 0;
> -
> -cleanup:
> -	if (syscon_np)
> -		of_node_put(syscon_np);
> -
> -	return rc;
> -}
> -
> -static void __init brcmstb_cpu_ctrl_setup(unsigned int max_cpus)
> -{
> -	int rc;
> -	struct device_node *np;
> -	char *name;
> -
> -	name = "brcm,brcmstb-smpboot";
> -	np = of_find_compatible_node(NULL, NULL, name);
> -	if (!np) {
> -		pr_err("can't find compatible node %s\n", name);
> -		return;
> -	}
> -
> -	rc = setup_hifcpubiuctrl_regs(np);
> -	if (rc)
> -		return;
> -
> -	rc = setup_hifcont_regs(np);
> -	if (rc)
> -		return;
> -}
> -
> -static DEFINE_SPINLOCK(boot_lock);
> -
> -static void brcmstb_secondary_init(unsigned int cpu)
> -{
> -	/*
> -	 * Synchronise with the boot thread.
> -	 */
> -	spin_lock(&boot_lock);
> -	spin_unlock(&boot_lock);
> -}
> -
> -static int brcmstb_boot_secondary(unsigned int cpu, struct task_struct *idle)
> -{
> -	/*
> -	 * set synchronisation state between this boot processor
> -	 * and the secondary one
> -	 */
> -	spin_lock(&boot_lock);
> -
> -	/* Bring up power to the core if necessary */
> -	if (brcmstb_cpu_get_power_state(cpu) == 0)
> -		brcmstb_cpu_power_on(cpu);
> -
> -	brcmstb_cpu_boot(cpu);
> -
> -	/*
> -	 * now the secondary core is starting up let it run its
> -	 * calibrations, then wait for it to finish
> -	 */
> -	spin_unlock(&boot_lock);
> -
> -	return 0;
> -}
> -
> -static struct smp_operations brcmstb_smp_ops __initdata = {
> -	.smp_prepare_cpus	= brcmstb_cpu_ctrl_setup,
> -	.smp_secondary_init	= brcmstb_secondary_init,
> -	.smp_boot_secondary	= brcmstb_boot_secondary,
> -#ifdef CONFIG_HOTPLUG_CPU
> -	.cpu_kill		= brcmstb_cpu_kill,
> -	.cpu_die		= brcmstb_cpu_die,
> -#endif
> -};
> -
> -CPU_METHOD_OF_DECLARE(brcmstb_smp, "brcm,brahma-b15", &brcmstb_smp_ops);
> -- 
> 1.9.1
> 
