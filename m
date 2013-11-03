Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753204Ab3KCJfv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Nov 2013 04:35:51 -0500
Received: from top.free-electrons.com ([176.31.233.9]:59056 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752331Ab3KCJfH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Nov 2013 04:35:07 -0500
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: linux-arm-kernel@lists.infradead.org,
        Russell King <linux@arm.linux.org.uk>
Cc: kevin.z.m.zh@gmail.com, sunny@allwinnertech.com, shuge@allwinnertech.com,
        zhuzhenhua@allwinnertech.com, linux-sunxi@googlegroups.com,
        linux-kernel@vger.kernel.org,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: [PATCH 2/2] ARM: sun6i: Add SMP support for the Allwinner A31
Date: Sun,  3 Nov 2013 10:30:13 +0100
Message-Id: <1383471013-21695-3-git-send-email-maxime.ripard@free-electrons.com>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1383471013-21695-1-git-send-email-maxime.ripard@free-electrons.com>
References: <1383471013-21695-1-git-send-email-maxime.ripard@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The A31 is a quad Cortex-A7. Add the logic to use the IPs used to
control the CPU configuration and the CPU power so that we can bring up
secondary CPUs at boot.

Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
---
 arch/arm/mach-sunxi/Makefile  |   1 +
 arch/arm/mach-sunxi/common.h  |  19 +++++++
 arch/arm/mach-sunxi/headsmp.S |  11 ++++
 arch/arm/mach-sunxi/platsmp.c | 115 ++++++++++++++++++++++++++++++++++++++++++
 arch/arm/mach-sunxi/sunxi.c   |   3 ++
 5 files changed, 149 insertions(+)
 create mode 100644 arch/arm/mach-sunxi/common.h
 create mode 100644 arch/arm/mach-sunxi/headsmp.S
 create mode 100644 arch/arm/mach-sunxi/platsmp.c

diff --git a/arch/arm/mach-sunxi/Makefile b/arch/arm/mach-sunxi/Makefile
index 93bebfc3ff9f..d9397202d6ec 100644
--- a/arch/arm/mach-sunxi/Makefile
+++ b/arch/arm/mach-sunxi/Makefile
@@ -1 +1,2 @@
 obj-$(CONFIG_ARCH_SUNXI) += sunxi.o
+obj-$(CONFIG_SMP) += platsmp.o headsmp.o
diff --git a/arch/arm/mach-sunxi/common.h b/arch/arm/mach-sunxi/common.h
new file mode 100644
index 000000000000..9e5ac4756cbb
--- /dev/null
+++ b/arch/arm/mach-sunxi/common.h
@@ -0,0 +1,19 @@
+/*
+ * Core functions for Allwinner SoCs
+ *
+ * Copyright (C) 2013 Maxime Ripard
+ *
+ * Maxime Ripard <maxime.ripard@free-electrons.com>
+ *
+ * This file is licensed under the terms of the GNU General Public
+ * License version 2.  This program is licensed "as is" without any
+ * warranty of any kind, whether express or implied.
+ */
+
+#ifndef __ARCH_SUNXI_COMMON_H_
+#define __ARCH_SUNXI_COMMON_H_
+
+void sun6i_secondary_startup(void);
+extern struct smp_operations sun6i_smp_ops;
+
+#endif /* __ARCH_SUNXI_COMMON_H_ */
diff --git a/arch/arm/mach-sunxi/headsmp.S b/arch/arm/mach-sunxi/headsmp.S
new file mode 100644
index 000000000000..f5ff05e0e6a3
--- /dev/null
+++ b/arch/arm/mach-sunxi/headsmp.S
@@ -0,0 +1,11 @@
+#include <linux/linkage.h>
+#include <linux/init.h>
+
+        .section ".text.head", "ax"
+	__CPUINIT
+
+ENTRY(sun6i_secondary_startup)
+	msr	cpsr_fsxc, #0xd3
+	b	secondary_startup
+ENDPROC(sun6i_secondary_startup)
+
diff --git a/arch/arm/mach-sunxi/platsmp.c b/arch/arm/mach-sunxi/platsmp.c
new file mode 100644
index 000000000000..90045700c429
--- /dev/null
+++ b/arch/arm/mach-sunxi/platsmp.c
@@ -0,0 +1,115 @@
+/*
+ * SMP support for Allwinner SoCs
+ *
+ * Copyright (C) 2013 Maxime Ripard
+ *
+ * Maxime Ripard <maxime.ripard@free-electrons.com>
+ *
+ * Based on code
+ *  Copyright (C) 2012-2013 Allwinner Ltd.
+ *
+ * This file is licensed under the terms of the GNU General Public
+ * License version 2.  This program is licensed "as is" without any
+ * warranty of any kind, whether express or implied.
+ */
+
+#include <linux/delay.h>
+#include <linux/init.h>
+#include <linux/io.h>
+#include <linux/memory.h>
+#include <linux/of.h>
+#include <linux/of_address.h>
+#include <linux/smp.h>
+
+#include "common.h"
+
+#define CPUCFG_CPU_PWR_CLAMP_STATUS_REG(cpu)	((cpu) * 0x40 + 0x64)
+#define CPUCFG_CPU_RST_CTRL_REG(cpu)		(((cpu) + 1) * 0x40)
+#define CPUCFG_CPU_CTRL_REG(cpu)		(((cpu) + 1) * 0x40 + 0x04)
+#define CPUCFG_CPU_STATUS_REG(cpu)		(((cpu) + 1) * 0x40 + 0x08)
+#define CPUCFG_GEN_CTRL_REG			0x184
+#define CPUCFG_PRIVATE0_REG			0x1a4
+#define CPUCFG_PRIVATE1_REG			0x1a8
+#define CPUCFG_DBG_CTL0_REG			0x1e0
+#define CPUCFG_DBG_CTL1_REG			0x1e4
+
+#define PRCM_CPU_PWROFF_REG			0x100
+#define PRCM_CPU_PWR_CLAMP_REG(cpu)		(((cpu) * 4) + 0x140)
+
+static void __iomem *cpucfg_membase;
+static void __iomem *prcm_membase;
+
+static DEFINE_SPINLOCK(cpu_lock);
+
+static void __init sun6i_smp_prepare_cpus(unsigned int max_cpus)
+{
+	struct device_node *node;
+
+	node = of_find_compatible_node(NULL, NULL, "allwinner,sun6i-a31-prcm");
+	if (!node)
+		panic("Missing A31 PRCM node in the device tree\n");
+
+	prcm_membase = of_iomap(node, 0);
+	if (!prcm_membase)
+		panic("Couldn't map A31 PRCM registers\n");
+
+	node = of_find_compatible_node(NULL, NULL,
+				       "allwinner,sun6i-a31-cpuconfig");
+	if (!node)
+		panic("Missing A31 CPU config node in the device tree\n");
+
+	cpucfg_membase = of_iomap(node, 0);
+	if (!cpucfg_membase)
+		panic("Couldn't map A31 CPU config registers\n");
+
+}
+
+static int sun6i_smp_boot_secondary(unsigned int cpu,
+				    struct task_struct *idle)
+{
+	u32 reg;
+	int i;
+
+	spin_lock(&cpu_lock);
+
+	/* Set CPU boot address */
+	writel(virt_to_phys(sun6i_secondary_startup),
+	       cpucfg_membase + CPUCFG_PRIVATE0_REG);
+
+	/* Assert the CPU core in reset */
+	writel(0, cpucfg_membase + CPUCFG_CPU_RST_CTRL_REG(cpu));
+
+	/* Assert the L1 cache in reset */
+	reg = readl(cpucfg_membase + CPUCFG_GEN_CTRL_REG);
+	writel(reg & ~BIT(cpu), cpucfg_membase + CPUCFG_GEN_CTRL_REG);
+
+	/* Disable external debug access */
+	reg = readl(cpucfg_membase + CPUCFG_DBG_CTL1_REG);
+	writel(reg & ~BIT(cpu), cpucfg_membase + CPUCFG_DBG_CTL1_REG);
+
+	/* Power up the CPU */
+	for (i = 0; i <= 8; i++)
+		writel(0xff >> i, prcm_membase + PRCM_CPU_PWR_CLAMP_REG(cpu));
+	mdelay(10);
+
+	/* Clear CPU power-off gating */
+	reg = readl(prcm_membase + PRCM_CPU_PWROFF_REG);
+	writel(reg & ~BIT(cpu), prcm_membase + PRCM_CPU_PWROFF_REG);
+	mdelay(1);
+
+	/* Deassert the CPU core reset */
+	writel(3, cpucfg_membase + CPUCFG_CPU_RST_CTRL_REG(cpu));
+
+	/* Enable back the external debug accesses */
+	reg = readl(cpucfg_membase + CPUCFG_DBG_CTL1_REG);
+	writel(reg | BIT(cpu), cpucfg_membase + CPUCFG_DBG_CTL1_REG);
+
+	spin_unlock(&cpu_lock);
+
+	return 0;
+}
+
+struct smp_operations sun6i_smp_ops __initdata = {
+	.smp_prepare_cpus	= sun6i_smp_prepare_cpus,
+	.smp_boot_secondary	= sun6i_smp_boot_secondary,
+};
diff --git a/arch/arm/mach-sunxi/sunxi.c b/arch/arm/mach-sunxi/sunxi.c
index f184f6c2fa33..b2e570253a8f 100644
--- a/arch/arm/mach-sunxi/sunxi.c
+++ b/arch/arm/mach-sunxi/sunxi.c
@@ -26,6 +26,8 @@
 #include <asm/mach/map.h>
 #include <asm/system_misc.h>
 
+#include "common.h"
+
 #define SUN4I_WATCHDOG_CTRL_REG		0x00
 #define SUN4I_WATCHDOG_CTRL_RESTART		BIT(0)
 #define SUN4I_WATCHDOG_MODE_REG		0x04
@@ -147,6 +149,7 @@ DT_MACHINE_START(SUN6I_DT, "Allwinner sun6i (A31) Family")
 	.init_time	= sunxi_timer_init,
 	.dt_compat	= sun6i_board_dt_compat,
 	.restart	= sun6i_restart,
+	.smp		= smp_ops(sun6i_smp_ops),
 MACHINE_END
 
 static const char * const sun7i_board_dt_compat[] = {
-- 
1.8.4

