Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753160Ab3IVMWx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Sep 2013 08:22:53 -0400
Received: from mail-pd0-f169.google.com ([209.85.192.169]:43968 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753129Ab3IVMWv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Sep 2013 08:22:51 -0400
From: Fan Rong <cinifr@gmail.com>
To: coosty@163.com, maxime.ripard@free-electrons.com,
        daniel.lezcano@linaro.org, linux@arm.linux.org.uk, tglx@linutronix.de,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        mark.rutland@arm.com, pawel.moll@arm.co, rob.herring@calxeda.com,
        linux-sunxi@googlegroups.com
Cc: Fan Rong <cinifr@gmail.com>
Subject: [PATCH V3: Add Smp support for Allwinner A20. 1/3] Add smp support for Allwinner A20(sunxi 7i).
Date: Sun, 22 Sep 2013 20:21:26 +0800
Message-Id: <1379852488-32147-2-git-send-email-cinifr@gmail.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1379852488-32147-1-git-send-email-cinifr@gmail.com>
References: <1379852488-32147-1-git-send-email-cinifr@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Fan Rong <cinifr@gmail.com>
---
 arch/arm/mach-sunxi/Makefile  |  2 +
 arch/arm/mach-sunxi/headsmp.S | 17 +++++++++
 arch/arm/mach-sunxi/platsmp.c | 86 +++++++++++++++++++++++++++++++++++++++++++
 arch/arm/mach-sunxi/sunxi.c   | 31 ++++++++++++++++
 4 files changed, 136 insertions(+)
 create mode 100644 arch/arm/mach-sunxi/headsmp.S
 create mode 100644 arch/arm/mach-sunxi/platsmp.c

diff --git a/arch/arm/mach-sunxi/Makefile b/arch/arm/mach-sunxi/Makefile
index 93bebfc..d7f1ef4 100644
--- a/arch/arm/mach-sunxi/Makefile
+++ b/arch/arm/mach-sunxi/Makefile
@@ -1 +1,3 @@
 obj-$(CONFIG_ARCH_SUNXI) += sunxi.o
+obj-$(CONFIG_ARCH_SUNXI) += platsmp.o
+obj-$(CONFIG_ARCH_SUNXI) += headsmp.o
diff --git a/arch/arm/mach-sunxi/headsmp.S b/arch/arm/mach-sunxi/headsmp.S
new file mode 100644
index 0000000..5899399
--- /dev/null
+++ b/arch/arm/mach-sunxi/headsmp.S
@@ -0,0 +1,17 @@
+/*
+ * SMP support for A20
+ *
+ *  Copyright (C) 2013 Fan Rong <cinifr@gmail.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/linkage.h>
+#include <linux/init.h>
+
+.section ".text.head", "ax" ENTRY(sun7i_secondary_startup)
+msr cpsr_fsxc,
+#0xd3
+b secondary_startup ENDPROC(sun7i_secondary_startup)
diff --git a/arch/arm/mach-sunxi/platsmp.c b/arch/arm/mach-sunxi/platsmp.c
new file mode 100644
index 0000000..5e3e994
--- /dev/null
+++ b/arch/arm/mach-sunxi/platsmp.c
@@ -0,0 +1,86 @@
+/*
+ *  linux/arch/arm/mach-sun7i/platsmp.c
+ *
+ *  Copyright (C) 2013 Fan Rong <cinifr@gmail.com>
+ *  All Rights Reserved
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+#include <linux/init.h>
+#include <linux/errno.h>
+#include <linux/smp.h>
+#include <linux/io.h>
+#include <linux/delay.h>
+#include <linux/smp.h>
+
+extern void __iomem *sunxi7i_cc_base;
+void sun7i_secondary_startup(void);
+
+/*
+ * CPUCFG
+ */
+#define SUN7I_CPUCFG_BOOTADDR	0x01a4
+
+#define SUN7I_CPUCFG_GENCTL	0x0184
+#define SUN7I_CPUCFG_DBGCTL0	0x01e0
+#define SUN7I_CPUCFG_DBGCTL1	0x01e4
+
+#define SUN7I_CPU1_PWR_CLAMP	0x01b0
+#define SUN7I_CPU1_PWROFF_REG	0x01b4
+#define SUN7I_CPUX_RESET_CTL(x)	(0x40 + (x)*0x40)
+
+static int sun7i_boot_secondary(unsigned int cpu, struct task_struct *idle)
+{
+	long paddr;
+	uint32_t pwr_reg;
+	uint32_t j = 0xff << 1;
+	if (!sunxi7i_cc_base) {
+		pr_debug("error map cpu configure\n");
+		return -ENOSYS;
+	}
+	/* Set boot addr */
+	paddr = virt_to_phys(sun7i_secondary_startup);
+	writel(paddr, sunxi7i_cc_base + SUN7I_CPUCFG_BOOTADDR);
+
+	/* Assert cpu core reset */
+	writel(0, sunxi7i_cc_base + SUN7I_CPUX_RESET_CTL(cpu));
+
+	/* Ensure CPU reset also invalidates L1 caches */
+	pwr_reg = readl(sunxi7i_cc_base + SUN7I_CPUCFG_GENCTL);
+	pwr_reg &= ~ BIT(cpu);
+	writel(pwr_reg, sunxi7i_cc_base + SUN7I_CPUCFG_GENCTL);
+
+	/* DBGPWRDUP hold low */
+	pwr_reg = readl(sunxi7i_cc_base + SUN7I_CPUCFG_DBGCTL1);
+	pwr_reg &= ~ BIT(cpu);
+	writel(pwr_reg, sunxi7i_cc_base + SUN7I_CPUCFG_DBGCTL1);
+
+	/* Ramp up power to CPU1 */
+	do {
+		writel(j, sunxi7i_cc_base + SUN7I_CPU1_PWR_CLAMP);
+		j = j >> 1;
+	} while (j != 0);
+
+	mdelay(10);
+
+	pwr_reg = readl(sunxi7i_cc_base + SUN7I_CPU1_PWROFF_REG);
+	pwr_reg &= ~1;
+	writel(pwr_reg, sunxi7i_cc_base + SUN7I_CPU1_PWROFF_REG);
+	mdelay(1);
+
+	/* Release CPU reset */
+	writel(3, sunxi7i_cc_base + SUN7I_CPUX_RESET_CTL(cpu));
+
+	/* Unlock CPU */
+	pwr_reg = readl(sunxi7i_cc_base + SUN7I_CPUCFG_DBGCTL1);
+	pwr_reg |= BIT(cpu);
+	writel(pwr_reg, sunxi7i_cc_base + SUN7I_CPUCFG_DBGCTL1);
+
+	return 0;
+}
+
+struct smp_operations sun7i_smp_ops __initdata = {
+	.smp_boot_secondary = sun7i_boot_secondary,
+};
diff --git a/arch/arm/mach-sunxi/sunxi.c b/arch/arm/mach-sunxi/sunxi.c
index e79fb34..a692350 100644
--- a/arch/arm/mach-sunxi/sunxi.c
+++ b/arch/arm/mach-sunxi/sunxi.c
@@ -26,6 +26,8 @@
 #include <asm/mach/map.h>
 #include <asm/system_misc.h>
 
+extern struct smp_operations sun7i_smp_ops;
+
 #define SUN4I_WATCHDOG_CTRL_REG		0x00
 #define SUN4I_WATCHDOG_CTRL_RESTART		BIT(0)
 #define SUN4I_WATCHDOG_MODE_REG		0x04
@@ -42,6 +44,14 @@
 #define SUN6I_WATCHDOG1_MODE_ENABLE		BIT(0)
 
 static void __iomem *wdt_base;
+/*
+ * CPU Configure module support
+ * 1: Software reset for smp cpus
+ * 2: Configure for smp cpus including boot.
+ * 3: Three 64-bit idle counters and two 64-bit common counters
+ * it is needed for smp cpus
+ */
+void __iomem *sunxi7i_cc_base; /*CPU Configure Base*/
 
 static void sun4i_restart(enum reboot_mode mode, const char *cmd)
 {
@@ -98,6 +108,11 @@ static struct of_device_id sunxi_restart_ids[] = {
 	{ /*sentinel*/ }
 };
 
+static struct of_device_id sunxi_cc_ids[] = {
+	{ .compatible = "allwinner,sun7i-a20-cpuconfig"},
+	{ /*sentinel*/ }
+};
+
 static void sunxi_setup_restart(void)
 {
 	const struct of_device_id *of_id;
@@ -138,7 +153,23 @@ static const char * const sunxi_board_dt_compat[] = {
 	NULL,
 };
 
+static int __init sunxi_init_cpuconfig_map(void)
+{
+	struct device_node *np;
+
+	np = of_find_matching_node(NULL, sunxi_cc_ids);
+	if (WARN(!np, "unable to setup cup configure"))
+		return -ENOSYS;
+	sunxi7i_cc_base = of_iomap(np, 0);
+	if (WARN(!sunxi7i_cc_base, "failed to map cup configure base address"))
+		return -ENOSYS;
+	return 0;
+}
+
+early_initcall(sunxi_init_cpuconfig_map);
+
 DT_MACHINE_START(SUNXI_DT, "Allwinner A1X (Device Tree)")
+	.smp	= smp_ops(sun7i_smp_ops),
 	.init_machine	= sunxi_dt_init,
 	.init_time	= sunxi_timer_init,
 	.dt_compat	= sunxi_board_dt_compat,
-- 
1.8.1.2

