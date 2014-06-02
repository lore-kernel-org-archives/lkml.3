Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753394AbaFBJVN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 05:21:13 -0400
Received: from top.free-electrons.com ([176.31.233.9]:38026 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753032AbaFBJVJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 05:21:09 -0400
From: =?UTF-8?q?Antoine=20T=C3=A9nart?= 
	<antoine.tenart@free-electrons.com>
To: sebastian.hesselbarth@gmail.com
Cc: =?UTF-8?q?Antoine=20T=C3=A9nart?= 
	<antoine.tenart@free-electrons.com>,
        alexandre.belloni@free-electrons.com,
        thomas.petazzoni@free-electrons.com, zmxu@marvell.com,
        jszhang@marvell.com, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/5] ARM: berlin: add SMP support
Date: Mon,  2 Jun 2014 11:21:02 +0200
Message-Id: <1401700866-24804-2-git-send-email-antoine.tenart@free-electrons.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1401700866-24804-1-git-send-email-antoine.tenart@free-electrons.com>
References: <1401700866-24804-1-git-send-email-antoine.tenart@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adds SMP support for Berlin SoCs. Secondary CPUs are reseted, then
execute the instruction we put in the reset exception register, setting
the pc at the address contained in the software reset address register,
which is the physical address of the Berlin secondary startup.

This implementation avoid using the pen lock mechanism.

Signed-off-by: Antoine Ténart <antoine.tenart@free-electrons.com>
---
 arch/arm/mach-berlin/Kconfig   |  3 ++
 arch/arm/mach-berlin/Makefile  |  3 +-
 arch/arm/mach-berlin/headsmp.S | 30 +++++++++++++
 arch/arm/mach-berlin/platsmp.c | 99 ++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 134 insertions(+), 1 deletion(-)
 create mode 100644 arch/arm/mach-berlin/headsmp.S
 create mode 100644 arch/arm/mach-berlin/platsmp.c

diff --git a/arch/arm/mach-berlin/Kconfig b/arch/arm/mach-berlin/Kconfig
index d3c5f14dc142..e3733692f67a 100644
--- a/arch/arm/mach-berlin/Kconfig
+++ b/arch/arm/mach-berlin/Kconfig
@@ -4,6 +4,7 @@ config ARCH_BERLIN
 	select GENERIC_IRQ_CHIP
 	select DW_APB_ICTL
 	select DW_APB_TIMER_OF
+	select SMP
 
 if ARCH_BERLIN
 
@@ -13,6 +14,7 @@ config MACH_BERLIN_BG2
 	bool "Marvell Armada 1500 (BG2)"
 	select CACHE_L2X0
 	select CPU_PJ4B
+	select HAVE_ARM_SCU if SMP
 	select HAVE_ARM_TWD if SMP
 
 config MACH_BERLIN_BG2CD
@@ -24,6 +26,7 @@ config MACH_BERLIN_BG2Q
 	bool "Marvell Armada 1500 Pro (BG2-Q)"
 	select CACHE_L2X0
 	select CPU_V7
+	select HAVE_ARM_SCU if SMP
 	select HAVE_ARM_TWD if SMP
 	select HAVE_SMP
 
diff --git a/arch/arm/mach-berlin/Makefile b/arch/arm/mach-berlin/Makefile
index ab69fe956f49..c0719ecd1890 100644
--- a/arch/arm/mach-berlin/Makefile
+++ b/arch/arm/mach-berlin/Makefile
@@ -1 +1,2 @@
-obj-y += berlin.o
+obj-y			+= berlin.o
+obj-$(CONFIG_SMP)	+= headsmp.o platsmp.o
diff --git a/arch/arm/mach-berlin/headsmp.S b/arch/arm/mach-berlin/headsmp.S
new file mode 100644
index 000000000000..d295b5185598
--- /dev/null
+++ b/arch/arm/mach-berlin/headsmp.S
@@ -0,0 +1,30 @@
+/*
+ * Copyright (C) 2014 Marvell Technology Group Ltd.
+ *
+ * Antoine Ténart <antoine.tenart@free-electrons.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/linkage.h>
+#include <linux/init.h>
+#include <asm/assembler.h>
+
+ENTRY(berlin_secondary_startup)
+ ARM_BE8(setend be)
+	bl	v7_invalidate_l1
+	b       secondary_startup
+ENDPROC(berlin_secondary_startup)
+
+/*
+ * If the following instruction is set in the reset exception register, CPUs
+ * will fetch the value of the software reset address register when being
+ * reseted.
+ */
+.global boot_inst
+boot_inst:
+	ldr	pc, [pc, #140]
+
+	.align
diff --git a/arch/arm/mach-berlin/platsmp.c b/arch/arm/mach-berlin/platsmp.c
new file mode 100644
index 000000000000..c04c90b81ae3
--- /dev/null
+++ b/arch/arm/mach-berlin/platsmp.c
@@ -0,0 +1,99 @@
+/*
+ * Copyright (C) 2014 Marvell Technology Group Ltd.
+ *
+ * Antoine Ténart <antoine.tenart@free-electrons.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/io.h>
+#include <linux/delay.h>
+#include <linux/of.h>
+#include <linux/of_address.h>
+
+#include <asm/cacheflush.h>
+#include <asm/smp_plat.h>
+#include <asm/smp_scu.h>
+
+#define CPU_RESET		0x00
+
+#define RESET_VECT		0x00
+#define SW_RESET_ADDR		0x94
+
+extern void berlin_secondary_startup(void);
+extern u32 boot_inst;
+
+static void __iomem *cpu_ctrl;
+
+static inline void berlin_reset_cpu(unsigned int cpu)
+{
+	u32 val;
+
+	val = readl(cpu_ctrl + CPU_RESET);
+	val |= BIT(cpu_logical_map(cpu));
+	writel(val, cpu_ctrl + CPU_RESET);
+}
+
+static int berlin_boot_secondary(unsigned int cpu, struct task_struct *idle)
+{
+	if (!cpu_ctrl)
+		return -EFAULT;
+
+	/*
+	 * Reset the CPU, making it to execute the instruction in the reset
+	 * exception register.
+	 */
+	berlin_reset_cpu(cpu);
+
+	return 0;
+}
+
+static void __init berlin_smp_prepare_cpus(unsigned int max_cpus)
+{
+	struct device_node *np;
+	void __iomem *scu_base;
+	void __iomem *vectors_base;
+
+	np = of_find_compatible_node(NULL, NULL, "arm,cortex-a9-scu");
+	scu_base = of_iomap(np, 0);
+	of_node_put(np);
+	if (!scu_base)
+		return;
+
+	np = of_find_compatible_node(NULL, NULL, "marvell,berlin-cpu-ctrl");
+	cpu_ctrl = of_iomap(np, 0);
+	of_node_put(np);
+	if (!cpu_ctrl)
+		goto unmap_scu;
+
+	vectors_base = ioremap(CONFIG_VECTORS_BASE, SZ_32K);
+	if (!vectors_base)
+		goto unmap_scu;
+
+	scu_enable(scu_base);
+	flush_cache_all();
+
+	/*
+	 * Write the first instruction the CPU will execute after being reseted
+	 * in the reset exception register.
+	 */
+	writel(boot_inst, vectors_base + RESET_VECT);
+
+	/*
+	 * Write the secondary startup address into the SW reset address
+	 * register. This is used by boot_inst.
+	 */
+	writel(virt_to_phys(berlin_secondary_startup), vectors_base + SW_RESET_ADDR);
+
+	iounmap(vectors_base);
+unmap_scu:
+	iounmap(scu_base);
+}
+
+static struct smp_operations berlin_smp_ops __initdata = {
+	.smp_prepare_cpus	= berlin_smp_prepare_cpus,
+	.smp_boot_secondary	= berlin_boot_secondary,
+};
+CPU_METHOD_OF_DECLARE(berlin_smp, "marvell,berlin-smp", &berlin_smp_ops);
-- 
1.9.1

