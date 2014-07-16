Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934561AbaGPOU3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 10:20:29 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:25623 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934275AbaGPOU1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 10:20:27 -0400
X-AuditID: cbfec7f4-b7fac6d000006cfe-01-53c68a283562
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Russell King <linux@arm.linux.org.uk>, Kukjin Kim <kgene.kim@samsung.com>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Tomasz Figa <t.figa@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH 1/3] ARM: EXYNOS: Move code from hotplug.c to platsmp.c
Date: Wed, 16 Jul 2014 16:20:15 +0200
Message-id: <1405520417-15027-1-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrMJMWRmVeSWpSXmKPExsVy+t/xK7oaXceCDZ5fU7LYOGM9q8XrF4YW
	vQuuslmcbXrDbrHp8TVWi8u75rBZzDi/j8ni9mVei7VH7rJbrJ/xmsWBy6OluYfNY/OSeo++
	LasYPT5vkgtgieKySUnNySxLLdK3S+DKmHlhK1PBN+OK5eeiGhjvaXYxcnJICJhI/N/+lQXC
	FpO4cG89WxcjF4eQwFJGiTO7djJDOH1MEj0nj4FVsQkYS2xevgSsSkRgB6PE8nuX2UESzALP
	GSWefg/vYuTgEBZwl7jxVQgkzCKgKrHm8U4WkDAvUHjinxqIZXISJ49NZp3AyL2AkWEVo2hq
	aXJBcVJ6rqFecWJucWleul5yfu4mRkjAfNnBuPiY1SFGAQ5GJR5ehtlHg4VYE8uKK3MPMUpw
	MCuJ8Dr4HwsW4k1JrKxKLcqPLyrNSS0+xMjEwSnVwFgtWHlbhnved/etnalzsrVnVPTnvXrH
	fY+3ra3w9d8590NDfCbWC2T85iv7N/fptUfiAXz7js2JM8h/nF/2Wp1Fn1P5rae69kWb62w7
	AtM/beSSC+II19l6NZZprwW35UlBd8+3IpVH/0fNXfh//mWWtjMlxdlnu3a2HljNbdPIKfbu
	zYlzO5RYijMSDbWYi4oTAQwNWvn2AQAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cleanup a little the SMP/hotplug code for Exynos by:
1. Moving completely all functions from hotplug.c into the platsmp.c;
2. Deleting the hotplug.c file.

After recent cleanups (e.g. 75ad2ab28f0f "ARM: EXYNOS: use
v7_exit_coherency_flush macro for cache disabling") there was only CPU
power down related code in hotplug.c file. Keeping this file does not
give any benefits.

The commit only moves code around with one additional observable change:
the hotplug.c was compiled with custom CFLAGS (-march=armv7-a). These
CFLAGS are not necessary any more.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
---
 arch/arm/mach-exynos/Makefile  |  3 --
 arch/arm/mach-exynos/common.h  |  2 -
 arch/arm/mach-exynos/hotplug.c | 92 ------------------------------------------
 arch/arm/mach-exynos/platsmp.c | 74 +++++++++++++++++++++++++++++++++
 4 files changed, 74 insertions(+), 97 deletions(-)
 delete mode 100644 arch/arm/mach-exynos/hotplug.c

diff --git a/arch/arm/mach-exynos/Makefile b/arch/arm/mach-exynos/Makefile
index 788f26d21141..0095de99d703 100644
--- a/arch/arm/mach-exynos/Makefile
+++ b/arch/arm/mach-exynos/Makefile
@@ -21,9 +21,6 @@ obj-$(CONFIG_PM_GENERIC_DOMAINS) += pm_domains.o
 
 obj-$(CONFIG_SMP)		+= platsmp.o headsmp.o
 
-obj-$(CONFIG_HOTPLUG_CPU)	+= hotplug.o
-CFLAGS_hotplug.o		+= -march=armv7-a
-
 plus_sec := $(call as-instr,.arch_extension sec,+sec)
 AFLAGS_exynos-smc.o		:=-Wa,-march=armv7-a$(plus_sec)
 
diff --git a/arch/arm/mach-exynos/common.h b/arch/arm/mach-exynos/common.h
index 1ee91763fa7c..907349d20c25 100644
--- a/arch/arm/mach-exynos/common.h
+++ b/arch/arm/mach-exynos/common.h
@@ -141,8 +141,6 @@ extern void exynos_cpu_resume(void);
 
 extern struct smp_operations exynos_smp_ops;
 
-extern void exynos_cpu_die(unsigned int cpu);
-
 /* PMU(Power Management Unit) support */
 
 #define PMU_TABLE_END	NULL
diff --git a/arch/arm/mach-exynos/hotplug.c b/arch/arm/mach-exynos/hotplug.c
deleted file mode 100644
index 920a4baa53cd..000000000000
--- a/arch/arm/mach-exynos/hotplug.c
+++ /dev/null
@@ -1,92 +0,0 @@
-/* linux arch/arm/mach-exynos4/hotplug.c
- *
- *  Cloned from linux/arch/arm/mach-realview/hotplug.c
- *
- *  Copyright (C) 2002 ARM Ltd.
- *  All Rights Reserved
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
-*/
-
-#include <linux/kernel.h>
-#include <linux/errno.h>
-#include <linux/smp.h>
-#include <linux/io.h>
-
-#include <asm/cacheflush.h>
-#include <asm/cp15.h>
-#include <asm/smp_plat.h>
-
-#include "common.h"
-#include "regs-pmu.h"
-
-static inline void cpu_leave_lowpower(void)
-{
-	unsigned int v;
-
-	asm volatile(
-	"mrc	p15, 0, %0, c1, c0, 0\n"
-	"	orr	%0, %0, %1\n"
-	"	mcr	p15, 0, %0, c1, c0, 0\n"
-	"	mrc	p15, 0, %0, c1, c0, 1\n"
-	"	orr	%0, %0, %2\n"
-	"	mcr	p15, 0, %0, c1, c0, 1\n"
-	  : "=&r" (v)
-	  : "Ir" (CR_C), "Ir" (0x40)
-	  : "cc");
-}
-
-static inline void platform_do_lowpower(unsigned int cpu, int *spurious)
-{
-	u32 mpidr = cpu_logical_map(cpu);
-	u32 core_id = MPIDR_AFFINITY_LEVEL(mpidr, 0);
-
-	for (;;) {
-
-		/* Turn the CPU off on next WFI instruction. */
-		exynos_cpu_power_down(core_id);
-
-		wfi();
-
-		if (pen_release == core_id) {
-			/*
-			 * OK, proper wakeup, we're done
-			 */
-			break;
-		}
-
-		/*
-		 * Getting here, means that we have come out of WFI without
-		 * having been woken up - this shouldn't happen
-		 *
-		 * Just note it happening - when we're woken, we can report
-		 * its occurrence.
-		 */
-		(*spurious)++;
-	}
-}
-
-/*
- * platform-specific code to shutdown a CPU
- *
- * Called with IRQs disabled
- */
-void __ref exynos_cpu_die(unsigned int cpu)
-{
-	int spurious = 0;
-
-	v7_exit_coherency_flush(louis);
-
-	platform_do_lowpower(cpu, &spurious);
-
-	/*
-	 * bring this CPU back into the world of cache
-	 * coherency, and then restore interrupts
-	 */
-	cpu_leave_lowpower();
-
-	if (spurious)
-		pr_warn("CPU%u: %u spurious wakeup calls\n", cpu, spurious);
-}
diff --git a/arch/arm/mach-exynos/platsmp.c b/arch/arm/mach-exynos/platsmp.c
index 50b9aad5e27b..b0679b6d5161 100644
--- a/arch/arm/mach-exynos/platsmp.c
+++ b/arch/arm/mach-exynos/platsmp.c
@@ -23,6 +23,7 @@
 #include <linux/of_address.h>
 
 #include <asm/cacheflush.h>
+#include <asm/cp15.h>
 #include <asm/smp_plat.h>
 #include <asm/smp_scu.h>
 #include <asm/firmware.h>
@@ -32,6 +33,54 @@
 
 extern void exynos4_secondary_startup(void);
 
+#ifdef CONFIG_HOTPLUG_CPU
+static inline void cpu_leave_lowpower(void)
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
+static inline void platform_do_lowpower(unsigned int cpu, int *spurious)
+{
+	u32 mpidr = cpu_logical_map(cpu);
+	u32 core_id = MPIDR_AFFINITY_LEVEL(mpidr, 0);
+
+	for (;;) {
+
+		/* Turn the CPU off on next WFI instruction. */
+		exynos_cpu_power_down(core_id);
+
+		wfi();
+
+		if (pen_release == core_id) {
+			/*
+			 * OK, proper wakeup, we're done
+			 */
+			break;
+		}
+
+		/*
+		 * Getting here, means that we have come out of WFI without
+		 * having been woken up - this shouldn't happen
+		 *
+		 * Just note it happening - when we're woken, we can report
+		 * its occurrence.
+		 */
+		(*spurious)++;
+	}
+}
+#endif /* CONFIG_HOTPLUG_CPU */
+
 static inline void __iomem *cpu_boot_reg_base(void)
 {
 	if (soc_is_exynos4210() && samsung_rev() == EXYNOS4210_REV_1_1)
@@ -251,6 +300,31 @@ static void __init exynos_smp_prepare_cpus(unsigned int max_cpus)
 	}
 }
 
+#ifdef CONFIG_HOTPLUG_CPU
+/*
+ * platform-specific code to shutdown a CPU
+ *
+ * Called with IRQs disabled
+ */
+static void __ref exynos_cpu_die(unsigned int cpu)
+{
+	int spurious = 0;
+
+	v7_exit_coherency_flush(louis);
+
+	platform_do_lowpower(cpu, &spurious);
+
+	/*
+	 * bring this CPU back into the world of cache
+	 * coherency, and then restore interrupts
+	 */
+	cpu_leave_lowpower();
+
+	if (spurious)
+		pr_warn("CPU%u: %u spurious wakeup calls\n", cpu, spurious);
+}
+#endif /* CONFIG_HOTPLUG_CPU */
+
 struct smp_operations exynos_smp_ops __initdata = {
 	.smp_init_cpus		= exynos_smp_init_cpus,
 	.smp_prepare_cpus	= exynos_smp_prepare_cpus,
-- 
1.9.1

