Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753872Ab3JAPnQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Oct 2013 11:43:16 -0400
Received: from mail-pd0-f173.google.com ([209.85.192.173]:43953 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753694Ab3JAPnN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Oct 2013 11:43:13 -0400
From: Fan Rong <cinifr@gmail.com>
To: coosty@163.com, maxime.ripard@free-electrons.com,
        daniel.lezcano@linaro.org, linux@arm.linux.org.uk, tglx@linutronix.de,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        mark.rutland@arm.com, pawel.moll@arm.com, rob.herring@calxeda.com,
        linux-sunxi@googlegroups.com
Cc: Fan Rong <cinifr@gmail.com>
Subject: [Add SMP support for Allwinner A20: PATCH V4 1/3] Add smp support for Allwinner A20(sunxi 7i).
Date: Tue,  1 Oct 2013 23:42:23 +0800
Message-Id: <1380642145-17295-2-git-send-email-cinifr@gmail.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1380642145-17295-1-git-send-email-cinifr@gmail.com>
References: <1380642145-17295-1-git-send-email-cinifr@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Fan Rong <cinifr@gmail.com>
---
 arch/arm/mach-sunxi/Makefile  |   2 +
 arch/arm/mach-sunxi/headsmp.S |  18 +++++++
 arch/arm/mach-sunxi/platsmp.c | 114 ++++++++++++++++++++++++++++++++++++++++++
 arch/arm/mach-sunxi/sunxi.c   |   3 ++
 4 files changed, 137 insertions(+)
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
index 0000000..48c9d33
--- /dev/null
+++ b/arch/arm/mach-sunxi/headsmp.S
@@ -0,0 +1,18 @@
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
+.section ".text.head", "ax"
+ENTRY(sun7i_secondary_startup)
+	msr cpsr_fsxc,#0xd3
+	b secondary_startup
+ENDPROC(sun7i_secondary_startup)
diff --git a/arch/arm/mach-sunxi/platsmp.c b/arch/arm/mach-sunxi/platsmp.c
new file mode 100644
index 0000000..fa5adde
--- /dev/null
+++ b/arch/arm/mach-sunxi/platsmp.c
@@ -0,0 +1,114 @@
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
+#include <linux/of_address.h>
+#include <linux/of_irq.h>
+#include <linux/of_platform.h>
+
+/*
+ * CPU Configure module support
+ * 1: Software reset for smp cpus
+ * 2: Configure for smp cpus including boot.
+ * 3: Three 64-bit idle counters and two 64-bit common counters
+ * it is needed for smp cpus
+ */
+void __iomem *sun7i_cc_base; /*CPU Configure Base*/
+extern void sun7i_secondary_startup(void);
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
+static struct of_device_id sun7i_cc_ids[] = {
+	{ .compatible = "allwinner,sun7i-a20-cpuconfig"},
+	{ /*sentinel*/ }
+};
+
+static int sun7i_boot_secondary(unsigned int cpu, struct task_struct *idle)
+{
+	long paddr;
+	uint32_t pwr_reg;
+	uint32_t j = 0xff << 1;
+	if (!sun7i_cc_base) {
+		pr_debug("error map cpu configure\n");
+		return -ENOSYS;
+	}
+	/* Set boot addr */
+	paddr = virt_to_phys(sun7i_secondary_startup);
+	writel(paddr, sun7i_cc_base + SUN7I_CPUCFG_BOOTADDR);
+
+	/* Assert cpu core reset */
+	writel(0, sun7i_cc_base + SUN7I_CPUX_RESET_CTL(cpu));
+
+	/* Ensure CPU reset also invalidates L1 caches */
+	pwr_reg = readl(sun7i_cc_base + SUN7I_CPUCFG_GENCTL);
+	pwr_reg &= ~BIT(cpu);
+	writel(pwr_reg, sun7i_cc_base + SUN7I_CPUCFG_GENCTL);
+
+	/* DBGPWRDUP hold low */
+	pwr_reg = readl(sun7i_cc_base + SUN7I_CPUCFG_DBGCTL1);
+	pwr_reg &= ~BIT(cpu);
+	writel(pwr_reg, sun7i_cc_base + SUN7I_CPUCFG_DBGCTL1);
+
+	/* Ramp up power to CPU1 */
+	do {
+		writel(j, sun7i_cc_base + SUN7I_CPU1_PWR_CLAMP);
+		j = j >> 1;
+	} while (j != 0);
+
+	mdelay(10);
+
+	pwr_reg = readl(sun7i_cc_base + SUN7I_CPU1_PWROFF_REG);
+	pwr_reg &= ~1;
+	writel(pwr_reg, sun7i_cc_base + SUN7I_CPU1_PWROFF_REG);
+	mdelay(1);
+
+	/* Release CPU reset */
+	writel(3, sun7i_cc_base + SUN7I_CPUX_RESET_CTL(cpu));
+
+	/* Unlock CPU */
+	pwr_reg = readl(sun7i_cc_base + SUN7I_CPUCFG_DBGCTL1);
+	pwr_reg |= BIT(cpu);
+	writel(pwr_reg, sun7i_cc_base + SUN7I_CPUCFG_DBGCTL1);
+
+	return 0;
+}
+
+static void __init sun7i_init_cpuconfig_map(unsigned int max_cpus)
+{
+	struct device_node *np;
+	np = of_find_matching_node(NULL, sun7i_cc_ids);
+	if (WARN(!np, "unable to setup cup configure"))
+		return;
+	sun7i_cc_base = of_iomap(np, 0);
+	if (WARN(!sun7i_cc_base, "failed to map cup configure base address"))
+		return;
+}
+
+struct smp_operations sun7i_smp_ops __initdata = {
+	.smp_boot_secondary = sun7i_boot_secondary,
+	.smp_prepare_cpus = sun7i_init_cpuconfig_map,
+};
diff --git a/arch/arm/mach-sunxi/sunxi.c b/arch/arm/mach-sunxi/sunxi.c
index e79fb34..b2e6eff 100644
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
@@ -139,6 +141,7 @@ static const char * const sunxi_board_dt_compat[] = {
 };
 
 DT_MACHINE_START(SUNXI_DT, "Allwinner A1X (Device Tree)")
+	.smp	= smp_ops(sun7i_smp_ops),
 	.init_machine	= sunxi_dt_init,
 	.init_time	= sunxi_timer_init,
 	.dt_compat	= sunxi_board_dt_compat,
-- 
1.8.1.2

