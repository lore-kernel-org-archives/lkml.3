Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753483Ab3ETGdZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 02:33:25 -0400
Received: from mail-pa0-f53.google.com ([209.85.220.53]:49143 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753024Ab3ETGdU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 02:33:20 -0400
From: Sanjay Singh Rawat <sanjay.rawat@linaro.org>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, linaro-dev@lists.linaro.org,
        Sanjay Singh Rawat <sanjay.rawat@linaro.org>
Subject: [RFC PATCH 1/6] ARM: cpuhotplug: move common hotplug related functions to core
Date: Mon, 20 May 2013 12:03:23 +0530
Message-Id: <1369031608-27347-2-git-send-email-sanjay.rawat@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1369031608-27347-1-git-send-email-sanjay.rawat@linaro.org>
References: <1369031608-27347-1-git-send-email-sanjay.rawat@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add function which prepare arm processors to enter the low power for hotplug
functionality and handle the return path.

Signed-off-by: Sanjay Singh Rawat <sanjay.rawat@linaro.org>
---
 arch/arm/include/asm/hotplug.h |   24 +++++++++++++++
 arch/arm/kernel/Makefile       |    1 +
 arch/arm/kernel/cpuhotplug.c   |   64 ++++++++++++++++++++++++++++++++++++++++
 3 files changed, 89 insertions(+)
 create mode 100644 arch/arm/include/asm/hotplug.h
 create mode 100644 arch/arm/kernel/cpuhotplug.c

diff --git a/arch/arm/include/asm/hotplug.h b/arch/arm/include/asm/hotplug.h
new file mode 100644
index 0000000..ae80f0e
--- /dev/null
+++ b/arch/arm/include/asm/hotplug.h
@@ -0,0 +1,24 @@
+/*
+ * arch/arm/include/asm/hotplug.h
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifdef CONFIG_HOTPLUG_CPU
+
+extern inline void cpu_enter_lowpower(void);
+extern inline void cpu_leave_lowpower(void);
+
+#else
+static inline void cpu_enter_lowpower(void)
+{
+	return -ENODEV;
+}
+static inline void cpu_leave_lowpower(void)
+{
+	return -ENODEV;
+}
+
+#endif
diff --git a/arch/arm/kernel/Makefile b/arch/arm/kernel/Makefile
index 5f3338e..9bd370b 100644
--- a/arch/arm/kernel/Makefile
+++ b/arch/arm/kernel/Makefile
@@ -33,6 +33,7 @@ obj-$(CONFIG_ISA_DMA)		+= dma-isa.o
 obj-$(CONFIG_PCI)		+= bios32.o isa.o
 obj-$(CONFIG_ARM_CPU_SUSPEND)	+= sleep.o suspend.o
 obj-$(CONFIG_SMP)		+= smp.o smp_tlb.o
+obj-$(CONFIG_HOTPLUG_CPU)	+= cpuhotplug.o
 obj-$(CONFIG_HAVE_ARM_SCU)	+= smp_scu.o
 obj-$(CONFIG_HAVE_ARM_TWD)	+= smp_twd.o
 obj-$(CONFIG_ARM_ARCH_TIMER)	+= arch_timer.o
diff --git a/arch/arm/kernel/cpuhotplug.c b/arch/arm/kernel/cpuhotplug.c
new file mode 100644
index 0000000..8651b96
--- /dev/null
+++ b/arch/arm/kernel/cpuhotplug.c
@@ -0,0 +1,64 @@
+/*
+ * Copyright (C) 2002 ARM Ltd.
+ * All Rights Reserved
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/kernel.h>
+#include <asm/cp15.h>
+
+/*
+ * For Cortex-A9 processor
+ */
+static inline void ca9_enter_lowpower(void)
+{
+	unsigned int v;
+
+	asm volatile(
+	"	mcr	p15, 0, %1, c7, c5, 0\n"
+	"	mcr	p15, 0, %1, c7, c10, 4\n"
+	/*
+	 * Turn off coherency
+	 */
+	"	mrc	p15, 0, %0, c1, c0, 1\n"
+	"	bic	%0, %0, %3\n"
+	"	mcr	p15, 0, %0, c1, c0, 1\n"
+	"	mrc	p15, 0, %0, c1, c0, 0\n"
+	"	bic	%0, %0, %2\n"
+	"	mcr	p15, 0, %0, c1, c0, 0\n"
+	  : "=&r" (v)
+	  : "r" (0), "Ir" (CR_C), "Ir" (0x40)
+	  : "cc");
+}
+
+inline void cpu_leave_lowpower(void)
+{
+	unsigned int v;
+
+	asm volatile(
+	"mrc	p15, 0, %0, c1, c0, 0\n"
+	"	orr	%0, %0, %1\n"
+	"	mcr	p15, 0, %0, c1, c0, 0\n"
+	"	mrc	p15, 0, %0, c1, c0, 1\n"
+	"	orr	%0, %0, %2\n"
+	"	mcr	p15, 0, %0, c1, c0, 1\n"
+	  : "=&r" (v)
+	  : "Ir" (CR_C), "Ir" (0x40)
+	  : "cc");
+}
+
+void cpu_enter_lowpower(void)
+{
+	int id = 0;
+
+	/* check the cpuid */
+	asm("mrc p15, 0, %0, c0, c0, 0" : "=r"(id) : : "cc");
+
+	if ((id & 0xffffffff) == 0x411fc090)
+		ca9_enter_lowpower();
+	else
+		pr_warn(KERN_WARNING "Unknown CPU type\n");
+}
-- 
1.7.9.5

