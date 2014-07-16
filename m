Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759864AbaGPMID (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 08:08:03 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:56888 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751409AbaGPMIB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 08:08:01 -0400
X-AuditID: cbfec7f4-b7fac6d000006cfe-ed-53c66b1e8c84
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Russell King <linux@arm.linux.org.uk>, Kukjin Kim <kgene.kim@samsung.com>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Tomasz Figa <t.figa@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH v3] ARM: exynos4: hotplug: Fix CPU idle clock down after CPU off
Date: Wed, 16 Jul 2014 14:07:47 +0200
Message-id: <1405512467-27269-1-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrGJMWRmVeSWpSXmKPExsVy+t/xy7py2ceCDabcN7TYOGM9q8XrF4YW
	vQuuslmcbXrDbrHp8TVWi8u75rBZzDi/j8ni9mVei7VH7rJbrJ/xmsWBy6OluYfNY/OSeo++
	LasYPT5vkgtgieKySUnNySxLLdK3S+DKeHN9K1vBSt2KpROWsDQwblDtYuTkkBAwkdgy/ww7
	hC0mceHeerYuRi4OIYGljBKH1p9nh3D6mCSev98IVsUmYCyxefkSsCoRgR2MEsvvXQZLMAs8
	Z5R4+j0cxBYWCJB4/2wDG4jNIqAqcfzVB1YQm1fAXWLPn7lsEOvkJE4em8w6gZF7ASPDKkbR
	1NLkguKk9FxDveLE3OLSvHS95PzcTYyQsPmyg3HxMatDjAIcjEo8vAyzjwYLsSaWFVfmHmKU
	4GBWEuF18D8WLMSbklhZlVqUH19UmpNafIiRiYNTqoFR7cCRxBv+xb51ZzdMTRLvfXMpa5PL
	zbld3wolRd7cPuTsz+a0OXXCW3XjLg6bFWbKqU/v3o+ct2i9VGRVadp5t5Uu/jfcExZyMLYa
	m38+wh+Zeicl5am3Z9+HjR+qrqk+Y2fbyqgyNbmRTbjmnPX3tULPfOS9uX265zilKoXE9Mq/
	Xx3qIaPEUpyRaKjFXFScCAD/xcOP+QEAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Exynos4 USE_DELAYED_RESET_ASSERTION must be set in
ARM_COREx_OPTION register during CPU power down. This is the proper way
of powering down CPU on Exynos4.

Additionally on Exynos4212 without this the CPU clock down feature won't
work after powering down some CPU and the online CPUs will work at full
frequency chosen by CPUfreq governor.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>

---
Changes since v2:
1. Add missing disable of the "use delayed reset assertion" feature
   when starting secondary CPU (suggested by Tomasz Figa).

Changes since v1:
1. Use delayed reset assertion on all Exynos4 family and all cores, not
   only on core 1 of Exynos4212.
2. Rebase on Tomasz Figa's patch:
   ARM: EXYNOS: Fix core ID used by platsmp and hotplug code
   http://www.spinics.net/lists/linux-samsung-soc/msg31604.html
   Tomasz's patch is currently applied to Kukjin's v3.16-samsung-fixes-4
---
 arch/arm/mach-exynos/common.h   |  4 ++++
 arch/arm/mach-exynos/hotplug.c  | 21 +++++++++++++++++++--
 arch/arm/mach-exynos/platsmp.c  | 24 ++++++++++++++++++++++++
 arch/arm/mach-exynos/regs-pmu.h |  3 +++
 4 files changed, 50 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mach-exynos/common.h b/arch/arm/mach-exynos/common.h
index 1ee91763fa7c..2e08fa793aff 100644
--- a/arch/arm/mach-exynos/common.h
+++ b/arch/arm/mach-exynos/common.h
@@ -137,6 +137,10 @@ extern void __init exynos_pm_init(void);
 static inline void exynos_pm_init(void) {}
 #endif
 
+#ifdef CONFIG_SMP
+extern void exynos_clear_delayed_reset_assertion(u32 core_id);
+#endif
+
 extern void exynos_cpu_resume(void);
 
 extern struct smp_operations exynos_smp_ops;
diff --git a/arch/arm/mach-exynos/hotplug.c b/arch/arm/mach-exynos/hotplug.c
index 920a4baa53cd..c58aa0f161bf 100644
--- a/arch/arm/mach-exynos/hotplug.c
+++ b/arch/arm/mach-exynos/hotplug.c
@@ -22,7 +22,7 @@
 #include "common.h"
 #include "regs-pmu.h"
 
-static inline void cpu_leave_lowpower(void)
+static inline void cpu_leave_lowpower(u32 core_id)
 {
 	unsigned int v;
 
@@ -36,6 +36,8 @@ static inline void cpu_leave_lowpower(void)
 	  : "=&r" (v)
 	  : "Ir" (CR_C), "Ir" (0x40)
 	  : "cc");
+
+	exynos_clear_delayed_reset_assertion(core_id);
 }
 
 static inline void platform_do_lowpower(unsigned int cpu, int *spurious)
@@ -47,6 +49,19 @@ static inline void platform_do_lowpower(unsigned int cpu, int *spurious)
 
 		/* Turn the CPU off on next WFI instruction. */
 		exynos_cpu_power_down(core_id);
+		if (soc_is_exynos4()) {
+			unsigned int tmp;
+
+			/*
+			 * Exynos 4 SoCs require setting
+			 * USE_DELAYED_RESET_ASSERTION so the CPU idle
+			 * clock down feature could properly detect
+			 * global idle state when CPUx is off.
+			 */
+			tmp = __raw_readl(EXYNOS_ARM_CORE_OPTION(core_id));
+			tmp |= S5P_USE_DELAYED_RESET_ASSERTION;
+			__raw_writel(tmp, EXYNOS_ARM_CORE_OPTION(core_id));
+		}
 
 		wfi();
 
@@ -76,6 +91,8 @@ static inline void platform_do_lowpower(unsigned int cpu, int *spurious)
 void __ref exynos_cpu_die(unsigned int cpu)
 {
 	int spurious = 0;
+	u32 mpidr = cpu_logical_map(cpu);
+	u32 core_id = MPIDR_AFFINITY_LEVEL(mpidr, 0);
 
 	v7_exit_coherency_flush(louis);
 
@@ -85,7 +102,7 @@ void __ref exynos_cpu_die(unsigned int cpu)
 	 * bring this CPU back into the world of cache
 	 * coherency, and then restore interrupts
 	 */
-	cpu_leave_lowpower();
+	cpu_leave_lowpower(core_id);
 
 	if (spurious)
 		pr_warn("CPU%u: %u spurious wakeup calls\n", cpu, spurious);
diff --git a/arch/arm/mach-exynos/platsmp.c b/arch/arm/mach-exynos/platsmp.c
index 50b9aad5e27b..9ce0567fbe87 100644
--- a/arch/arm/mach-exynos/platsmp.c
+++ b/arch/arm/mach-exynos/platsmp.c
@@ -32,6 +32,27 @@
 
 extern void exynos4_secondary_startup(void);
 
+/*
+ * Clear the USE_DELAYED_RESET_ASSERTION option, set on Exynos4 SoCs
+ * during hot-unplugging CPUx.
+ *
+ * It won't harm if this is called during first boot of secondary CPU.
+ *
+ * Exynos4 SoCs require setting USE_DELAYED_RESET_ASSERTION so the CPU idle
+ * clock down feature could properly detect global idle state when
+ * CPUx is off.
+ */
+void exynos_clear_delayed_reset_assertion(u32 core_id)
+{
+	if (soc_is_exynos4()) {
+		unsigned int tmp;
+
+		tmp = __raw_readl(EXYNOS_ARM_CORE_OPTION(core_id));
+		tmp &= ~(S5P_USE_DELAYED_RESET_ASSERTION);
+		__raw_writel(tmp, EXYNOS_ARM_CORE_OPTION(core_id));
+	}
+}
+
 static inline void __iomem *cpu_boot_reg_base(void)
 {
 	if (soc_is_exynos4210() && samsung_rev() == EXYNOS4210_REV_1_1)
@@ -170,6 +191,9 @@ static int exynos_boot_secondary(unsigned int cpu, struct task_struct *idle)
 		udelay(10);
 	}
 
+	/* No harm if this is called during first boot of secondary CPU */
+	exynos_clear_delayed_reset_assertion(core_id);
+
 	/*
 	 * now the secondary core is starting up let it run its
 	 * calibrations, then wait for it to finish
diff --git a/arch/arm/mach-exynos/regs-pmu.h b/arch/arm/mach-exynos/regs-pmu.h
index 1d13b08708f0..59bd92112842 100644
--- a/arch/arm/mach-exynos/regs-pmu.h
+++ b/arch/arm/mach-exynos/regs-pmu.h
@@ -25,6 +25,7 @@
 
 #define S5P_USE_STANDBY_WFI0			(1 << 16)
 #define S5P_USE_STANDBY_WFE0			(1 << 24)
+#define S5P_USE_DELAYED_RESET_ASSERTION		BIT(12)
 
 #define EXYNOS_SWRESET				S5P_PMUREG(0x0400)
 #define EXYNOS5440_SWRESET			S5P_PMUREG(0x00C4)
@@ -111,6 +112,8 @@
 			(EXYNOS_ARM_CORE0_CONFIGURATION + (0x80 * (_nr)))
 #define EXYNOS_ARM_CORE_STATUS(_nr)		\
 			(EXYNOS_ARM_CORE_CONFIGURATION(_nr) + 0x4)
+#define EXYNOS_ARM_CORE_OPTION(_nr)		\
+			(EXYNOS_ARM_CORE_CONFIGURATION(_nr) + 0x8)
 
 #define EXYNOS_ARM_COMMON_CONFIGURATION		S5P_PMUREG(0x2500)
 #define EXYNOS_COMMON_CONFIGURATION(_nr)	\
-- 
1.9.1

