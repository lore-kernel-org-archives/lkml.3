Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932224AbaIEMfM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 08:35:12 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:60747 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751672AbaIEMfJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 08:35:09 -0400
X-AuditID: cbfec7f4-b7f156d0000063c7-45-5409adfbb25c
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Russell King <linux@arm.linux.org.uk>, Kukjin Kim <kgene.kim@samsung.com>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Sachin Kamat <sachin.kamat@linaro.org>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH v5 RESEND 1/3] ARM: EXYNOS: Move code from hotplug.c to
 platsmp.c
Date: Fri, 05 Sep 2014 14:34:53 +0200
Message-id: <1409920495-16533-1-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrFJMWRmVeSWpSXmKPExsVy+t/xK7q/13KGGJy4JmyxccZ6Vot5n2Ut
	Xr8wtOhdcJXN4mzTG3aLTY+vsVpc3jWHzWLG+X1MFrcv81qsPXKX3eLkn15Gi1W7/jA68Hi0
	NPeweeycdZfd4861PWwem5fUe/RtWcXo8XmTXABbFJdNSmpOZllqkb5dAlfGoxn32ApaLSum
	3D/A0sD4UreLkZNDQsBE4ujRvUwQtpjEhXvr2boYuTiEBJYySly/eYkRwuljkti5o50NpIpN
	wFhi8/IlYFUiAjsYJZbfu8wO4jALHGGSWHZiM9gsYYFgiS3HDzCD2CwCqhK/X7eBxXkF3CXm
	vV7DDLFPTuLkscmsExi5FzAyrGIUTS1NLihOSs811CtOzC0uzUvXS87P3cQICa8vOxgXH7M6
	xCjAwajEw/vCiDNEiDWxrLgy9xCjBAezkgiv+xSgEG9KYmVValF+fFFpTmrxIUYmDk6pBsY1
	Tewtew/mTuTKfL11R0WvuTf7zT6db23JBx6opDgoOlZYrOYUak/bmscQMFXLpjC75e9tp8/l
	wekRD1a56KnXhpbobxb+oZ2/UFH+KKPz280lEvXb7qXt2dUjKz9t2s7P5wuypPl+KVu737b+
	GBqnddZP+GJqdWGspu6cqsm/7uxQzVfiU2Ipzkg01GIuKk4EAF/I3zsNAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cleanup a little the SMP/hotplug code for Exynos by:
1. Moving completely all functions from hotplug.c into the platsmp.c;
2. Deleting the hotplug.c file.

After recent cleanups (e.g. 75ad2ab28f0f "ARM: EXYNOS: use
v7_exit_coherency_flush macro for cache disabling") there was only CPU
power down related code in hotplug.c file.

Rationale behind the code movement and benefits:
1. The file platsmp.c is the only user of code located in hotplug.c.
   Keeping code in hotplug.c required declaring exynos_cpu_die() in common.h.
   Such dependencies and mentioned exynos_cpu_die() declaration can be
   removed.
2. In next patches exynos_set_delayed_reset_assertion() will be
   introduced. This function will be called by:
    - cpu_leave_power (hotplug.c),
    - platform_do_lowpower (hotplug.c),
    - exynos_boot_secondary (platsmp.c).

Merging hotplug.c into platsmp.c leads to simpler and cleaner code with
less dependencies between files.

The commit only moves code around with one additional observable change:
the hotplug.c was compiled with custom CFLAGS (-march=armv7-a). These
CFLAGS are not necessary any more.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Reviewed-by: Tomasz Figa <t.figa@samsung.com>

---
Changes since v4:
1. Rebase on linux-next-20140804.
2. Add Reviewed-by Tomasz Figa.
---
 arch/arm/mach-exynos/Makefile  |  3 --
 arch/arm/mach-exynos/common.h  |  2 -
 arch/arm/mach-exynos/hotplug.c | 91 ------------------------------------------
 arch/arm/mach-exynos/platsmp.c | 74 ++++++++++++++++++++++++++++++++++
 4 files changed, 74 insertions(+), 96 deletions(-)
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
index 47b904b3b973..3d3e6af9d015 100644
--- a/arch/arm/mach-exynos/common.h
+++ b/arch/arm/mach-exynos/common.h
@@ -130,8 +130,6 @@ extern void exynos_cpu_resume(void);
 
 extern struct smp_operations exynos_smp_ops;
 
-extern void exynos_cpu_die(unsigned int cpu);
-
 /* PMU(Power Management Unit) support */
 
 #define PMU_TABLE_END	(-1U)
diff --git a/arch/arm/mach-exynos/hotplug.c b/arch/arm/mach-exynos/hotplug.c
deleted file mode 100644
index 4d86961a7957..000000000000
--- a/arch/arm/mach-exynos/hotplug.c
+++ /dev/null
@@ -1,91 +0,0 @@
-/*
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
index a9f1cf759949..a809f76c8160 100644
--- a/arch/arm/mach-exynos/platsmp.c
+++ b/arch/arm/mach-exynos/platsmp.c
@@ -22,6 +22,7 @@
 #include <linux/of_address.h>
 
 #include <asm/cacheflush.h>
+#include <asm/cp15.h>
 #include <asm/smp_plat.h>
 #include <asm/smp_scu.h>
 #include <asm/firmware.h>
@@ -33,6 +34,54 @@
 
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
 /**
  * exynos_core_power_down : power down the specified cpu
  * @cpu : the cpu to power down
@@ -318,6 +367,31 @@ static void __init exynos_smp_prepare_cpus(unsigned int max_cpus)
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

