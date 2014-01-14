Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752309AbaANXt6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 18:49:58 -0500
Received: from mail-qc0-f175.google.com ([209.85.216.175]:45677 "EHLO
	mail-qc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751912AbaANXt4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 18:49:56 -0500
From: Marc Carino <marc.ceeeee@gmail.com>
To: Christian Daudt <bcm@fixthebug.org>, Arnd Bergmann <arnd@arndb.de>
Cc: Florian Fainelli <f.fainelli@gmail.com>,
        Matt Porter <matt.porter@linaro.org>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, Marc Carino <marc.ceeeee@gmail.com>
Subject: [PATCH v3 1/7] ARM: brcmstb: add infrastructure for ARM-based Broadcom STB SoCs
Date: Tue, 14 Jan 2014 15:48:47 -0800
Message-Id: <1389743333-16741-2-git-send-email-marc.ceeeee@gmail.com>
X-Mailer: git-send-email 1.8.4.4
In-Reply-To: <1389743333-16741-1-git-send-email-marc.ceeeee@gmail.com>
References: <1389743333-16741-1-git-send-email-marc.ceeeee@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The BCM7xxx series of Broadcom SoCs are used primarily in set-top boxes.

This patch adds machine support for the ARM-based Broadcom SoCs.

Signed-off-by: Marc Carino <marc.ceeeee@gmail.com>
Acked-by: Florian Fainelli <f.fainelli@gmail.com>
---
 arch/arm/configs/multi_v7_defconfig |    1 +
 arch/arm/mach-bcm/Kconfig           |   14 ++
 arch/arm/mach-bcm/Makefile          |    4 +
 arch/arm/mach-bcm/brcmstb.c         |  146 ++++++++++++++++++++
 arch/arm/mach-bcm/brcmstb.h         |   46 +++++++
 arch/arm/mach-bcm/headsmp-brcmstb.S |   34 +++++
 arch/arm/mach-bcm/hotplug-brcmstb.c |  252 +++++++++++++++++++++++++++++++++++
 7 files changed, 497 insertions(+), 0 deletions(-)
 create mode 100644 arch/arm/mach-bcm/brcmstb.c
 create mode 100644 arch/arm/mach-bcm/brcmstb.h
 create mode 100644 arch/arm/mach-bcm/headsmp-brcmstb.S
 create mode 100644 arch/arm/mach-bcm/hotplug-brcmstb.c

diff --git a/arch/arm/configs/multi_v7_defconfig b/arch/arm/configs/multi_v7_defconfig
index c1df4e9..7028d11 100644
--- a/arch/arm/configs/multi_v7_defconfig
+++ b/arch/arm/configs/multi_v7_defconfig
@@ -7,6 +7,7 @@ CONFIG_MACH_ARMADA_370=y
 CONFIG_MACH_ARMADA_XP=y
 CONFIG_ARCH_BCM=y
 CONFIG_ARCH_BCM_MOBILE=y
+CONFIG_ARCH_BRCMSTB=y
 CONFIG_GPIO_PCA953X=y
 CONFIG_ARCH_HIGHBANK=y
 CONFIG_ARCH_KEYSTONE=y
diff --git a/arch/arm/mach-bcm/Kconfig b/arch/arm/mach-bcm/Kconfig
index 9fe6d88..2c1ae83 100644
--- a/arch/arm/mach-bcm/Kconfig
+++ b/arch/arm/mach-bcm/Kconfig
@@ -31,6 +31,20 @@ config ARCH_BCM_MOBILE
 	  BCM11130, BCM11140, BCM11351, BCM28145 and
 	  BCM28155 variants.
 
+config ARCH_BRCMSTB
+	bool "Broadcom BCM7XXX based boards" if ARCH_MULTI_V7
+	depends on MMU
+	select ARM_GIC
+	select MIGHT_HAVE_PCI
+	select HAVE_SMP
+	select HAVE_ARM_ARCH_TIMER
+	help
+	  Say Y if you intend to run the kernel on a Broadcom ARM-based STB
+	  chipset.
+
+	  This enables support for Broadcom ARM-based set-top box chipsets,
+	  including the 7445 family of chips.
+
 endmenu
 
 endif
diff --git a/arch/arm/mach-bcm/Makefile b/arch/arm/mach-bcm/Makefile
index c2ccd5a..b744a12 100644
--- a/arch/arm/mach-bcm/Makefile
+++ b/arch/arm/mach-bcm/Makefile
@@ -13,3 +13,7 @@
 obj-$(CONFIG_ARCH_BCM_MOBILE)	:= board_bcm281xx.o bcm_kona_smc.o bcm_kona_smc_asm.o kona.o
 plus_sec := $(call as-instr,.arch_extension sec,+sec)
 AFLAGS_bcm_kona_smc_asm.o	:=-Wa,-march=armv7-a$(plus_sec)
+
+obj-$(CONFIG_ARCH_BRCMSTB)	:= brcmstb.o
+obj-$(CONFIG_SMP)		+= headsmp-brcmstb.o
+obj-$(CONFIG_HOTPLUG_CPU)	+= hotplug-brcmstb.o
diff --git a/arch/arm/mach-bcm/brcmstb.c b/arch/arm/mach-bcm/brcmstb.c
new file mode 100644
index 0000000..eb9de26
--- /dev/null
+++ b/arch/arm/mach-bcm/brcmstb.c
@@ -0,0 +1,146 @@
+/*
+ * Copyright (C) 2013 Broadcom Corporation
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation version 2.
+ *
+ * This program is distributed "as is" WITHOUT ANY WARRANTY of any
+ * kind, whether express or implied; without even the implied warranty
+ * of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#include <linux/clk-provider.h>
+#include <linux/console.h>
+#include <linux/clocksource.h>
+#include <linux/delay.h>
+#include <linux/device.h>
+#include <linux/errno.h>
+#include <linux/init.h>
+#include <linux/io.h>
+#include <linux/jiffies.h>
+#include <linux/of_address.h>
+#include <linux/of_irq.h>
+#include <linux/of_platform.h>
+#include <linux/platform_device.h>
+#include <linux/printk.h>
+#include <linux/smp.h>
+
+#include <asm/cacheflush.h>
+#include <asm/mach-types.h>
+#include <asm/mach/arch.h>
+#include <asm/mach/map.h>
+#include <asm/mach/time.h>
+
+#include "brcmstb.h"
+
+/***********************************************************************
+ * STB CPU (main application processor)
+ ***********************************************************************/
+
+static const char *brcmstb_match[] __initconst = {
+	"brcm,brcmstb-7445",
+	NULL
+};
+
+static void brcmstb_restart(enum reboot_mode mode, const char *cmd)
+{
+	struct device_node *np;
+	char *name;
+	void __iomem *rst_src_en;
+	void __iomem *sw_mstr_rst;
+
+	name = "brcm,brcmstb-gen-ctrl-v1";
+	np = of_find_compatible_node(NULL, NULL, name);
+	if (!np) {
+		pr_err("cannot find node %s\n", name);
+		return;
+	}
+
+	rst_src_en = of_iomap(np, GEN_CTRL_V1_RST_SRC_EN);
+	if (!rst_src_en) {
+		pr_err("can't iomap rst_src_en\n");
+		return;
+	}
+
+	sw_mstr_rst = of_iomap(np, GEN_CTRL_V1_SW_MSTR_RST);
+	if (!sw_mstr_rst) {
+		pr_err("can't iomap sw_mstr_rst\n");
+		return;
+	}
+
+	writel_relaxed(1, rst_src_en);
+	readl_relaxed(rst_src_en);
+
+	writel_relaxed(1, sw_mstr_rst);
+	readl_relaxed(sw_mstr_rst);
+
+	while (1)
+		;
+}
+
+static void __init brcmstb_init_early(void)
+{
+	add_preferred_console("ttyS", 0, "115200");
+}
+
+/***********************************************************************
+ * SMP boot
+ ***********************************************************************/
+
+#ifdef CONFIG_SMP
+static DEFINE_SPINLOCK(boot_lock);
+
+static void __cpuinit brcmstb_secondary_init(unsigned int cpu)
+{
+	/*
+	 * Synchronise with the boot thread.
+	 */
+	spin_lock(&boot_lock);
+	spin_unlock(&boot_lock);
+}
+
+static int __cpuinit brcmstb_boot_secondary(unsigned int cpu,
+					    struct task_struct *idle)
+{
+	/*
+	 * set synchronisation state between this boot processor
+	 * and the secondary one
+	 */
+	spin_lock(&boot_lock);
+
+	/* Bring up power to the core if necessary */
+	if (brcmstb_cpu_get_power_state(cpu) == 0)
+		brcmstb_cpu_power_on(cpu);
+
+	brcmstb_cpu_boot(cpu);
+
+	/*
+	 * now the secondary core is starting up let it run its
+	 * calibrations, then wait for it to finish
+	 */
+	spin_unlock(&boot_lock);
+
+	return 0;
+}
+
+struct smp_operations brcmstb_smp_ops __initdata = {
+	.smp_prepare_cpus	= brcmstb_cpu_ctrl_setup,
+	.smp_secondary_init	= brcmstb_secondary_init,
+	.smp_boot_secondary	= brcmstb_boot_secondary,
+#ifdef CONFIG_HOTPLUG_CPU
+	.cpu_kill		= brcmstb_cpu_kill,
+	.cpu_die		= brcmstb_cpu_die,
+#endif
+};
+#endif
+
+DT_MACHINE_START(BRCMSTB, "Broadcom STB (Flattened Device Tree)")
+	.dt_compat	= brcmstb_match,
+	.restart	= brcmstb_restart,
+#ifdef CONFIG_SMP
+	.smp		= smp_ops(brcmstb_smp_ops),
+#endif
+	.init_early	= brcmstb_init_early,
+MACHINE_END
diff --git a/arch/arm/mach-bcm/brcmstb.h b/arch/arm/mach-bcm/brcmstb.h
new file mode 100644
index 0000000..9012afb
--- /dev/null
+++ b/arch/arm/mach-bcm/brcmstb.h
@@ -0,0 +1,46 @@
+/*
+ * Copyright (C) 2013 Broadcom Corporation
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation version 2.
+ *
+ * This program is distributed "as is" WITHOUT ANY WARRANTY of any
+ * kind, whether express or implied; without even the implied warranty
+ * of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#ifndef __BRCMSTB_H__
+#define __BRCMSTB_H__
+
+#if !defined(__ASSEMBLY__)
+#include <linux/smp.h>
+#endif
+
+#if !defined(__ASSEMBLY__)
+extern void brcmstb_secondary_startup(void);
+extern void brcmstb_cpu_boot(unsigned int cpu);
+extern void brcmstb_cpu_power_on(unsigned int cpu);
+extern int brcmstb_cpu_get_power_state(unsigned int cpu);
+extern struct smp_operations brcmstb_smp_ops;
+#ifdef CONFIG_HOTPLUG_CPU
+extern void brcmstb_cpu_die(unsigned int cpu);
+extern int brcmstb_cpu_kill(unsigned int cpu);
+void __init brcmstb_cpu_ctrl_setup(unsigned int max_cpus);
+#else
+static inline void brcmstb_cpu_die(unsigned int cpu) {}
+static inline int brcmstb_cpu_kill(unsigned int cpu) {}
+static inline void __init brcmstb_cpu_ctrl_setup(unsigned int max_cpus) {}
+#endif
+#endif
+
+enum {
+	GEN_CTRL_V1_RST_SRC_EN = 0,
+	GEN_CTRL_V1_SW_MSTR_RST,
+	GEN_CTRL_V1_CPU_RST_CFG,
+	GEN_CTRL_V1_CPU_PWR_ZONE_CTRL,
+	GEN_CTRL_V1_STB_BOOT_HI_ADDR0,
+};
+
+#endif /* __BRCMSTB_H__ */
diff --git a/arch/arm/mach-bcm/headsmp-brcmstb.S b/arch/arm/mach-bcm/headsmp-brcmstb.S
new file mode 100644
index 0000000..57ec438
--- /dev/null
+++ b/arch/arm/mach-bcm/headsmp-brcmstb.S
@@ -0,0 +1,34 @@
+/*
+ * SMP boot code for secondary CPUs
+ * Based on arch/arm/mach-tegra/headsmp.S
+ *
+ * Copyright (C) 2010 NVIDIA, Inc.
+ * Copyright (C) 2013 Broadcom Corporation
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation version 2.
+ *
+ * This program is distributed "as is" WITHOUT ANY WARRANTY of any
+ * kind, whether express or implied; without even the implied warranty
+ * of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#include <asm/assembler.h>
+#include <linux/linkage.h>
+#include <linux/init.h>
+
+        .section ".text.head", "ax"
+	__CPUINIT
+
+ENTRY(brcmstb_secondary_startup)
+        /*
+         * Ensure CPU is in a sane state by disabling all IRQs and switching
+         * into SVC mode.
+         */
+        setmode	PSR_I_BIT | PSR_F_BIT | SVC_MODE, r0
+
+        bl      v7_invalidate_l1
+        b       secondary_startup
+ENDPROC(brcmstb_secondary_startup)
diff --git a/arch/arm/mach-bcm/hotplug-brcmstb.c b/arch/arm/mach-bcm/hotplug-brcmstb.c
new file mode 100644
index 0000000..00de2ed
--- /dev/null
+++ b/arch/arm/mach-bcm/hotplug-brcmstb.c
@@ -0,0 +1,252 @@
+/*
+ * Broadcom STB CPU hotplug support for ARM
+ *
+ * Copyright (C) 2013 Broadcom Corporation
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation version 2.
+ *
+ * This program is distributed "as is" WITHOUT ANY WARRANTY of any
+ * kind, whether express or implied; without even the implied warranty
+ * of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#include <linux/delay.h>
+#include <linux/device.h>
+#include <linux/errno.h>
+#include <linux/init.h>
+#include <linux/io.h>
+#include <linux/jiffies.h>
+#include <linux/of_address.h>
+#include <linux/of_irq.h>
+#include <linux/of_platform.h>
+#include <linux/printk.h>
+#include <linux/smp.h>
+
+#include <asm/cacheflush.h>
+#include <asm/mach-types.h>
+
+#include "brcmstb.h"
+
+enum {
+	ZONE_MAN_CLKEN_MASK		= BIT(0),
+	ZONE_MAN_RESET_CNTL_MASK	= BIT(1),
+	ZONE_MAN_MEM_PWR_MASK		= BIT(4),
+	ZONE_RESERVED_1_MASK		= BIT(5),
+	ZONE_MAN_ISO_CNTL_MASK		= BIT(6),
+	ZONE_MANUAL_CONTROL_MASK	= BIT(7),
+	ZONE_PWR_DN_REQ_MASK		= BIT(9),
+	ZONE_PWR_UP_REQ_MASK		= BIT(10),
+	ZONE_BLK_RST_ASSERT_MASK	= BIT(10),
+	ZONE_PWR_OFF_STATE_MASK		= BIT(26),
+	ZONE_PWR_ON_STATE_MASK		= BIT(26),
+	ZONE_DPG_PWR_STATE_MASK		= BIT(28),
+	ZONE_MEM_PWR_STATE_MASK		= BIT(29),
+	ZONE_RESET_STATE_MASK		= BIT(31),
+};
+
+static void __iomem *cpu_rst_cfg_reg;
+static void __iomem *cpu0_pwr_zone_ctrl_reg;
+static void __iomem *hif_cont_reg;
+
+DEFINE_PER_CPU(int, per_cpu_sw_state);
+
+static void __iomem *pwr_ctrl_get_base(unsigned int cpu)
+{
+	void __iomem *base = cpu0_pwr_zone_ctrl_reg;
+	base += (cpu * 4);
+	return base;
+}
+
+static u32 pwr_ctrl_rd(unsigned int cpu)
+{
+	void __iomem *base = pwr_ctrl_get_base(cpu);
+	return readl_relaxed(base);
+}
+
+static void pwr_ctrl_wr(unsigned int cpu, u32 val)
+{
+	void __iomem *base = pwr_ctrl_get_base(cpu);
+	writel(val, base);
+}
+
+void brcmstb_cpu_boot(unsigned int cpu)
+{
+	unsigned long boot_vector;
+	const int reg_ofs = cpu * 8;
+	u32 val;
+
+	pr_info("SMP: Booting CPU%d...\n", cpu);
+
+	/*
+	* set the reset vector to point to the secondary_startup
+	* routine
+	*/
+	boot_vector = virt_to_phys(brcmstb_secondary_startup);
+	writel_relaxed(0, hif_cont_reg + reg_ofs);
+	writel_relaxed(boot_vector, hif_cont_reg + 4 + reg_ofs);
+
+	flush_cache_all();
+
+	/* unhalt the cpu */
+	val = readl_relaxed(cpu_rst_cfg_reg);
+	val &= ~BIT(cpu);
+	writel_relaxed(val, cpu_rst_cfg_reg);
+}
+
+void brcmstb_cpu_power_on(unsigned int cpu)
+{
+	/*
+	 * The secondary cores power was cut, so we must go through
+	 * power-on initialization.
+	 */
+	u32 tmp;
+
+	pr_info("SMP: Powering up CPU%d...\n", cpu);
+
+	/* Request zone power up */
+	pwr_ctrl_wr(cpu, ZONE_PWR_UP_REQ_MASK);
+
+	/* Wait for the power up FSM to complete */
+	do {
+		tmp = pwr_ctrl_rd(cpu);
+	} while (!(tmp & ZONE_PWR_ON_STATE_MASK));
+
+	per_cpu(per_cpu_sw_state, cpu) = 1;
+}
+
+int brcmstb_cpu_get_power_state(unsigned int cpu)
+{
+	int tmp = pwr_ctrl_rd(cpu);
+	return (tmp & ZONE_RESET_STATE_MASK) ? 0 : 1;
+}
+
+void __ref brcmstb_cpu_die(unsigned int cpu)
+{
+	/* Derived from misc_bpcm_arm.c */
+
+	/* Clear SCTLR.C bit */
+	__asm__(
+		"mrc	p15, 0, r0, c1, c0, 0\n"
+		"bic	r0, r0, #(1 << 2)\n"
+		"mcr	p15, 0, r0, c1, c0, 0\n"
+		: /* no output */
+		: /* no input */
+		: "r0"	/* clobber r0 */
+	);
+
+	/*
+	 * Instruction barrier to ensure cache is really disabled before
+	 * cleaning/invalidating the caches
+	 */
+	isb();
+
+	flush_cache_all();
+
+	/* Invalidate all instruction caches to PoU (ICIALLU) */
+	/* Data sync. barrier to ensure caches have emptied out */
+	__asm__("mcr	p15, 0, r0, c7, c5, 0\n" : : : "r0");
+	dsb();
+
+	/*
+	 * Clear ACTLR.SMP bit to prevent broadcast TLB messages from reaching
+	 * this core
+	 */
+	__asm__(
+		"mrc	p15, 0, r0, c1, c0, 1\n"
+		"bic	r0, r0, #(1 << 6)\n"
+		"mcr	p15, 0, r0, c1, c0, 1\n"
+		: /* no output */
+		: /* no input */
+		: "r0"	/* clobber r0 */
+	);
+
+	/* Disable all IRQs for this CPU */
+	arch_local_irq_disable();
+
+	per_cpu(per_cpu_sw_state, cpu) = 0;
+
+	/*
+	 * Final full barrier to ensure everything before this instruction has
+	 * quiesced.
+	 */
+	isb();
+	dsb();
+
+	/* Sit and wait to die */
+	wfi();
+
+	/* We should never get here... */
+	nop();
+	panic("Spurious interrupt on CPU %d received!\n", cpu);
+}
+
+int brcmstb_cpu_kill(unsigned int cpu)
+{
+	u32 tmp;
+	u32 val;
+
+	pr_info("SMP: Powering down CPU%d...\n", cpu);
+
+	while (per_cpu(per_cpu_sw_state, cpu))
+		;
+
+	/* Program zone reset */
+	pwr_ctrl_wr(cpu, ZONE_RESET_STATE_MASK | ZONE_BLK_RST_ASSERT_MASK |
+			      ZONE_PWR_DN_REQ_MASK);
+
+	/* Verify zone reset */
+	tmp = pwr_ctrl_rd(cpu);
+	if (!(tmp & ZONE_RESET_STATE_MASK))
+		pr_err("%s: Zone reset bit for CPU %d not asserted!\n",
+			__func__, cpu);
+
+	/* Wait for power down */
+	do {
+		tmp = pwr_ctrl_rd(cpu);
+	} while (!(tmp & ZONE_PWR_OFF_STATE_MASK));
+
+	/* Settle-time from Broadcom-internal DVT reference code */
+	udelay(7);
+
+	/* Assert reset on the CPU */
+	val = readl_relaxed(cpu_rst_cfg_reg);
+	val |= BIT(cpu);
+	writel_relaxed(val, cpu_rst_cfg_reg);
+
+	return 1;
+}
+
+void __init brcmstb_cpu_ctrl_setup(unsigned int max_cpus)
+{
+	struct device_node *np;
+	char *name;
+
+	name = "brcm,brcmstb-gen-ctrl-v1";
+	np = of_find_compatible_node(NULL, NULL, name);
+	if (!np) {
+		pr_err("can't find compatible node %s\n", name);
+		return;
+	}
+
+	cpu_rst_cfg_reg = of_iomap(np, GEN_CTRL_V1_CPU_RST_CFG);
+	if (!cpu_rst_cfg_reg) {
+		pr_err("iomap failed for cpu_rst_cfg_reg\n");
+		return;
+	}
+
+	cpu0_pwr_zone_ctrl_reg = of_iomap(np, GEN_CTRL_V1_CPU_PWR_ZONE_CTRL);
+	if (!cpu0_pwr_zone_ctrl_reg) {
+		pr_err("iomap failed for cpu0_pwr_zone_ctrl_reg\n");
+		return;
+	}
+
+	hif_cont_reg = of_iomap(np, GEN_CTRL_V1_STB_BOOT_HI_ADDR0);
+	if (!hif_cont_reg) {
+		pr_err("iomap failed for hif_cont_reg\n");
+		return;
+	}
+}
+
-- 
1.7.1

