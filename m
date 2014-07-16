Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965179AbaGPOV3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 10:21:29 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:14350 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934205AbaGPOU2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 10:20:28 -0400
X-AuditID: cbfec7f5-b7f626d000004b39-c0-53c68a29f825
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Russell King <linux@arm.linux.org.uk>, Kukjin Kim <kgene.kim@samsung.com>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Tomasz Figa <t.figa@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH 3/3] ARM: exynos4: hotplug: Fix CPU idle clock down after CPU
 off
Date: Wed, 16 Jul 2014 16:20:17 +0200
Message-id: <1405520417-15027-3-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1405520417-15027-1-git-send-email-k.kozlowski@samsung.com>
References: <1405520417-15027-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrLJMWRmVeSWpSXmKPExsVy+t/xK7qaXceCDfbtULTYOGM9q8XrF4YW
	vQuuslmcbXrDbrHp8TVWi8u75rBZzDi/j8ni9mVei7VH7rJbrJ/xmsWBy6OluYfNY/OSeo++
	LasYPT5vkgtgieKySUnNySxLLdK3S+DK6P11jLXgi3rF7u9r2RoYLyh0MXJwSAiYSDSc0+li
	5AQyxSQu3FvP1sXIxSEksJRR4sSm51BOH5PE+sb7rCBVbALGEpuXLwFLiAjsYJRYfu8yO0iC
	WeA5o8TT7+EgtrBAsMSJ+4uZQWwWAVWJjTfOg9m8Au4SH+b8ZYJYJydx8thksKGcAh4S18//
	YwSxhYBqOpr2s09g5F3AyLCKUTS1NLmgOCk910ivODG3uDQvXS85P3cTIyTIvu5gXHrM6hCj
	AAejEg8vw+yjwUKsiWXFlbmHGCU4mJVEeB+0HwsW4k1JrKxKLcqPLyrNSS0+xMjEwSnVwNg9
	eW5sWuvt2NJFc118zcPOXeR35H92Om/Bgpvi+0W+pG18unexbHdRwd/gSbO+i72729ZwUzSG
	982UqyWzphq/Yz/iv3ynUOVdCefbMy49nBh1c5+llYuS0eRqb5bz7hE5s0tamjzfPVM55tHd
	Z9EYO0VkzjerooQDYsvjc26scHZLK4/v7VJiKc5INNRiLipOBACcj37TEAIAAA==
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
Changes since v3:
1. Remove declaration of exynos_clear_delayed_reset_assertion() in
   header as hotplug code is integrated into platsmp.c file. Suggested
   by Tomasz Figa.
2. Replace 'clear' helper with 'set' helper. Suggested by Tomasz Figa.

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
 arch/arm/mach-exynos/platsmp.c  | 43 +++++++++++++++++++++++++++++++++++++++--
 arch/arm/mach-exynos/regs-pmu.h |  3 +++
 2 files changed, 44 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mach-exynos/platsmp.c b/arch/arm/mach-exynos/platsmp.c
index 6a0de7591f73..393b1a00dbcb 100644
--- a/arch/arm/mach-exynos/platsmp.c
+++ b/arch/arm/mach-exynos/platsmp.c
@@ -33,8 +33,32 @@
 
 extern void exynos4_secondary_startup(void);
 
+/*
+ * Set or clear the USE_DELAYED_RESET_ASSERTION option, set on Exynos4 SoCs
+ * during hot-(un)plugging CPUx.
+ *
+ * The feature can be cleared safely during first boot of secondary CPU.
+ *
+ * Exynos4 SoCs require setting USE_DELAYED_RESET_ASSERTION during powering
+ * down a CPU so the CPU idle clock down feature could properly detect global
+ * idle state when CPUx is off.
+ */
+static void exynos_set_delayed_reset_assertion(u32 core_id, bool enable)
+{
+	if (soc_is_exynos4()) {
+		unsigned int tmp;
+
+		tmp = __raw_readl(EXYNOS_ARM_CORE_OPTION(core_id));
+		if (enable)
+			tmp |= S5P_USE_DELAYED_RESET_ASSERTION;
+		else
+			tmp &= ~(S5P_USE_DELAYED_RESET_ASSERTION);
+		__raw_writel(tmp, EXYNOS_ARM_CORE_OPTION(core_id));
+	}
+}
+
 #ifdef CONFIG_HOTPLUG_CPU
-static inline void cpu_leave_lowpower(void)
+static inline void cpu_leave_lowpower(u32 core_id)
 {
 	unsigned int v;
 
@@ -48,6 +72,8 @@ static inline void cpu_leave_lowpower(void)
 	  : "=&r" (v)
 	  : "Ir" (CR_C), "Ir" (0x40)
 	  : "cc");
+
+	 exynos_set_delayed_reset_assertion(core_id, false);
 }
 
 static inline void platform_do_lowpower(unsigned int cpu, int *spurious)
@@ -60,6 +86,14 @@ static inline void platform_do_lowpower(unsigned int cpu, int *spurious)
 		/* Turn the CPU off on next WFI instruction. */
 		exynos_cpu_power_down(core_id);
 
+		/*
+		 * Exynos4 SoCs require setting
+		 * USE_DELAYED_RESET_ASSERTION so the CPU idle
+		 * clock down feature could properly detect
+		 * global idle state when CPUx is off.
+		 */
+		exynos_set_delayed_reset_assertion(core_id, true);
+
 		wfi();
 
 		if (pen_release == core_id) {
@@ -219,6 +253,9 @@ static int exynos_boot_secondary(unsigned int cpu, struct task_struct *idle)
 		udelay(10);
 	}
 
+	/* No harm if this is called during first boot of secondary CPU */
+	exynos_set_delayed_reset_assertion(core_id, false);
+
 	/*
 	 * now the secondary core is starting up let it run its
 	 * calibrations, then wait for it to finish
@@ -309,6 +346,8 @@ static void __init exynos_smp_prepare_cpus(unsigned int max_cpus)
 static void exynos_cpu_die(unsigned int cpu)
 {
 	int spurious = 0;
+	u32 mpidr = cpu_logical_map(cpu);
+	u32 core_id = MPIDR_AFFINITY_LEVEL(mpidr, 0);
 
 	v7_exit_coherency_flush(louis);
 
@@ -318,7 +357,7 @@ static void exynos_cpu_die(unsigned int cpu)
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

