Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753424AbaAQTT7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jan 2014 14:19:59 -0500
Received: from mail-ie0-f175.google.com ([209.85.223.175]:51060 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752592AbaAQTT4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jan 2014 14:19:56 -0500
From: Marc Carino <marc.ceeeee@gmail.com>
To: Christian Daudt <bcm@fixthebug.org>, Arnd Bergmann <arnd@arndb.de>
Cc: Florian Fainelli <f.fainelli@gmail.com>,
        Matt Porter <matt.porter@linaro.org>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, Marc Carino <marc.ceeeee@gmail.com>
Subject: [PATCH v4 1/8] ARM: brcmstb: add infrastructure for ARM-based Broadcom STB SoCs
Date: Fri, 17 Jan 2014 11:19:20 -0800
Message-Id: <1389986367-4010-2-git-send-email-marc.ceeeee@gmail.com>
X-Mailer: git-send-email 1.8.4.4
In-Reply-To: <1389986367-4010-1-git-send-email-marc.ceeeee@gmail.com>
References: <1389986367-4010-1-git-send-email-marc.ceeeee@gmail.com>
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
 arch/arm/mach-bcm/brcmstb.c         |  110 ++++++++++++
 arch/arm/mach-bcm/brcmstb.h         |   38 ++++
 arch/arm/mach-bcm/headsmp-brcmstb.S |   34 ++++
 arch/arm/mach-bcm/hotplug-brcmstb.c |  334 +++++++++++++++++++++++++++++++++++
 7 files changed, 535 insertions(+), 0 deletions(-)
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
index 0000000..7a6093d
--- /dev/null
+++ b/arch/arm/mach-bcm/brcmstb.c
@@ -0,0 +1,110 @@
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
+	"brcm,bcm7445",
+	"brcm,brcmstb",
+	NULL
+};
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
+#ifdef CONFIG_SMP
+	.smp		= smp_ops(brcmstb_smp_ops),
+#endif
+	.init_early	= brcmstb_init_early,
+MACHINE_END
diff --git a/arch/arm/mach-bcm/brcmstb.h b/arch/arm/mach-bcm/brcmstb.h
new file mode 100644
index 0000000..e49bde6
--- /dev/null
+++ b/arch/arm/mach-bcm/brcmstb.h
@@ -0,0 +1,38 @@
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
+#if defined(CONFIG_HOTPLUG_CPU)
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
index 0000000..ff4a732
--- /dev/null
+++ b/arch/arm/mach-bcm/hotplug-brcmstb.c
@@ -0,0 +1,334 @@
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
+#include <linux/regmap.h>
+#include <linux/smp.h>
+#include <linux/mfd/syscon.h>
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
+static void __iomem *cpubiuctrl_block;
+static void __iomem *hif_cont_block;
+static u32 cpu0_pwr_zone_ctrl_reg;
+static u32 cpu_rst_cfg_reg;
+static u32 hif_cont_reg;
+DEFINE_PER_CPU(int, per_cpu_sw_state);
+
+static void __iomem *pwr_ctrl_get_base(unsigned int cpu)
+{
+	void __iomem *base = cpubiuctrl_block + cpu0_pwr_zone_ctrl_reg;
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
+static void cpu_rst_cfg_set(int cpu, int set)
+{
+	u32 val;
+	val = readl_relaxed(cpubiuctrl_block + cpu_rst_cfg_reg);
+	if (set)
+		val |= BIT(cpu);
+	else
+		val &= ~BIT(cpu);
+	writel_relaxed(val, cpubiuctrl_block + cpu_rst_cfg_reg);
+}
+
+static void cpu_set_boot_addr(int cpu, unsigned long boot_addr)
+{
+	const int reg_ofs = cpu * 8;
+	writel_relaxed(0, hif_cont_block + hif_cont_reg + reg_ofs);
+	writel_relaxed(boot_addr, hif_cont_block + hif_cont_reg + 4 + reg_ofs);
+}
+
+void brcmstb_cpu_boot(unsigned int cpu)
+{
+	pr_info("SMP: Booting CPU%d...\n", cpu);
+
+	/*
+	* set the reset vector to point to the secondary_startup
+	* routine
+	*/
+	cpu_set_boot_addr(cpu, virt_to_phys(brcmstb_secondary_startup));
+
+	flush_cache_all();
+
+	/* unhalt the cpu */
+	cpu_rst_cfg_set(cpu, 0);
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
+	cpu_rst_cfg_set(cpu, 1);
+
+	return 1;
+}
+
+static int __init setup_hifcpubiuctrl_regs(struct device_node *np)
+{
+	int rc = 0;
+	char *name;
+	int index;
+	struct device_node *syscon_np = NULL;
+
+	name = "syscon-cpu";
+
+	syscon_np = of_parse_phandle(np, name, 0);
+	if (!syscon_np) {
+		pr_err("can't find phandle %s\n", name);
+		rc = -EINVAL;
+		goto cleanup;
+	}
+
+	cpubiuctrl_block = of_iomap(syscon_np, 0);
+	if (!cpubiuctrl_block) {
+		pr_err("iomap failed for cpubiuctrl_block\n");
+		rc = -EINVAL;
+		goto cleanup;
+	}
+
+	index = 1;
+	rc = of_property_read_u32_index(np, name, index,
+					&cpu0_pwr_zone_ctrl_reg);
+	if (rc) {
+		pr_err("failed to read %d from %s property (%d)\n", index, name,
+			rc);
+		rc = -EINVAL;
+		goto cleanup;
+	}
+
+	index = 2;
+	rc = of_property_read_u32_index(np, name, index, &cpu_rst_cfg_reg);
+	if (rc) {
+		pr_err("failed to read %d from %s property (%d)\n", index, name,
+			rc);
+		rc = -EINVAL;
+		goto cleanup;
+	}
+
+cleanup:
+	if (syscon_np)
+		of_node_put(syscon_np);
+
+	return rc;
+}
+
+static int __init setup_hifcont_regs(struct device_node *np)
+{
+	int rc = 0;
+	char *name;
+	struct device_node *syscon_np = NULL;
+
+	name = "syscon-cont";
+
+	syscon_np = of_parse_phandle(np, name, 0);
+	if (!syscon_np) {
+		pr_err("can't find phandle %s\n", name);
+		rc = -EINVAL;
+		goto cleanup;
+	}
+
+	hif_cont_block = of_iomap(syscon_np, 0);
+	if (!hif_cont_block) {
+		pr_err("iomap failed for hif_cont_block\n");
+		rc = -EINVAL;
+		goto cleanup;
+	}
+
+	/* offset is at top of hif_cont_block */
+	hif_cont_reg = 0;
+
+cleanup:
+	if (syscon_np)
+		of_node_put(syscon_np);
+
+	return rc;
+}
+
+void __init brcmstb_cpu_ctrl_setup(unsigned int max_cpus)
+{
+	int rc;
+	struct device_node *np;
+	char *name;
+
+	name = "brcm,brcmstb-smpboot";
+	np = of_find_compatible_node(NULL, NULL, name);
+	if (!np) {
+		pr_err("can't find compatible node %s\n", name);
+		return;
+	}
+
+	rc = setup_hifcpubiuctrl_regs(np);
+	if (rc)
+		return;
+
+	rc = setup_hifcont_regs(np);
+	if (rc)
+		return;
+}
+
-- 
1.7.1

