Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758484AbaGPIXr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 04:23:47 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:50363 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751240AbaGPIXm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 04:23:42 -0400
X-AuditID: cbfec7f5-b7f626d000004b39-59-53c636873603
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Russell King <linux@arm.linux.org.uk>, Kukjin Kim <kgene.kim@samsung.com>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Tomasz Figa <t.figa@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [RESEND PATCH v2] ARM: exynos4: hotplug: Fix CPU idle clock down after
 CPU off
Date: Wed, 16 Jul 2014 10:23:23 +0200
Message-id: <1405499003-9975-1-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrGJMWRmVeSWpSXmKPExsVy+t/xy7rtZseCDV7tsbbYOGM9q8XrF4YW
	vQuuslmcbXrDbrHp8TVWi8u75rBZzDi/j8ni9mVei7VH7rJbrJ/xmsWBy6OluYfNY/OSeo++
	LasYPT5vkgtgieKySUnNySxLLdK3S+DKuPBrG2PBO9mKM1OuMDcw7pLoYuTkkBAwkVj/4T4b
	hC0mceHeeiCbi0NIYCmjxJSOr+wQTh+TRPPqLkaQKjYBY4nNy5eAVYkI7GCUWH7vMlgVs8BL
	RonZLy4BORwcwgKRErc/gK1gEVCV2LR3MQuIzSvgJvFm+QQmiHVyEiePTWadwMi9gJFhFaNo
	amlyQXFSeq6RXnFibnFpXrpecn7uJkZI2Hzdwbj0mNUhRgEORiUeXobZR4OFWBPLiitzDzFK
	cDArifCKsBwLFuJNSaysSi3Kjy8qzUktPsTIxMEp1cC4sy/R6XftMdaK7t56qwUHHvlwmzXx
	nN9V4rrt50/jGy/1kr7PNP6sKL7xzMTCQJUlF7eLnuIy9tbmUXWqTqucMd3hk4/ItcQdXbsn
	+9o8KchzT/zC21Q9af6spCMMVVfmr18mJMXq0nJZstqqIn32doek1TrGOab5R+44hPvp2ezt
	mPrkkIASS3FGoqEWc1FxIgCoKc+Q+QEAAA==
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
Changes since v1:
1. Use delayed reset assertion on all Exynos4 family and all cores, not
   only on core 1 of Exynos4212.
2. Rebase on Tomasz Figa's patch:
   ARM: EXYNOS: Fix core ID used by platsmp and hotplug code
   http://www.spinics.net/lists/linux-samsung-soc/msg31604.html
   Tomasz's patch is currently applied to Kukjin's v3.16-samsung-fixes-4
---
 arch/arm/mach-exynos/hotplug.c  | 27 +++++++++++++++++++++++++--
 arch/arm/mach-exynos/regs-pmu.h |  3 +++
 2 files changed, 28 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mach-exynos/hotplug.c b/arch/arm/mach-exynos/hotplug.c
index 920a4baa53cd..e6340b645f9d 100644
--- a/arch/arm/mach-exynos/hotplug.c
+++ b/arch/arm/mach-exynos/hotplug.c
@@ -22,7 +22,7 @@
 #include "common.h"
 #include "regs-pmu.h"
 
-static inline void cpu_leave_lowpower(void)
+static inline void cpu_leave_lowpower(u32 core_id)
 {
 	unsigned int v;
 
@@ -36,6 +36,14 @@ static inline void cpu_leave_lowpower(void)
 	  : "=&r" (v)
 	  : "Ir" (CR_C), "Ir" (0x40)
 	  : "cc");
+
+	if (soc_is_exynos4()) {
+		unsigned int tmp;
+
+		tmp = __raw_readl(EXYNOS_ARM_CORE_OPTION(core_id));
+		tmp &= ~(S5P_USE_DELAYED_RESET_ASSERTION);
+		__raw_writel(tmp, EXYNOS_ARM_CORE_OPTION(core_id));
+	}
 }
 
 static inline void platform_do_lowpower(unsigned int cpu, int *spurious)
@@ -47,6 +55,19 @@ static inline void platform_do_lowpower(unsigned int cpu, int *spurious)
 
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
 
@@ -76,6 +97,8 @@ static inline void platform_do_lowpower(unsigned int cpu, int *spurious)
 void __ref exynos_cpu_die(unsigned int cpu)
 {
 	int spurious = 0;
+	u32 mpidr = cpu_logical_map(cpu);
+	u32 core_id = MPIDR_AFFINITY_LEVEL(mpidr, 0);
 
 	v7_exit_coherency_flush(louis);
 
@@ -85,7 +108,7 @@ void __ref exynos_cpu_die(unsigned int cpu)
 	 * bring this CPU back into the world of cache
 	 * coherency, and then restore interrupts
 	 */
-	cpu_leave_lowpower();
+	cpu_leave_lowpower(core_id);
 
 	if (spurious)
 		pr_warn("CPU%u: %u spurious wakeup calls\n", cpu, spurious);
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

