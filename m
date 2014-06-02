Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753610AbaFBKjJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 06:39:09 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:32947 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752784AbaFBKjH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 06:39:07 -0400
X-AuditID: cbfec7f5-b7f626d000004b39-7f-538c54473e59
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Russell King <linux@arm.linux.org.uk>, Kukjin Kim <kgene.kim@samsung.com>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Tomasz Figa <t.figa@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH v2] ARM: exynos4: hotplug: Fix CPU idle clock down after CPU off
Date: Mon, 02 Jun 2014 12:38:45 +0200
Message-id: <1401705525-8678-1-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrKJMWRmVeSWpSXmKPExsVy+t/xy7ruIT3BBv13tSw2zljPavH6haFF
	74KrbBZnm96wW2x6fI3V4vKuOWwWM87vY7K4fZnXYu2Ru+wW62e8ZnHg8mhp7mHz2Lyk3qNv
	yypGj8+b5AJYorhsUlJzMstSi/TtErgypn5VKGiVrbg77w5bA+Mj8S5GTg4JAROJ0xdnskDY
	YhIX7q1n62Lk4hASWMoocXfSe0YIp49JYvGsLcwgVWwCxhKbly8BqxIR2MEosfzeZXaQBLPA
	c0aJp9/DQWxhgQCJPx0T2EBsFgFViQltyxhBbF4BN4nJWx+xQ6yTkzh5bDLrBEbuBYwMqxhF
	U0uTC4qT0nON9IoTc4tL89L1kvNzNzFCgubrDsalx6wOMQpwMCrx8Cp49wQLsSaWFVfmHmKU
	4GBWEuFdagEU4k1JrKxKLcqPLyrNSS0+xMjEwSnVwLhi/7SNhyZl5x3e6X8no+opb/+uE++m
	lNoLd29a+cY+JnZ3RMX8rVdqGUWtuLK7/jaKv1q35e7PWq7iK8KxPI67vCLmPGU7tDXx56aY
	573u85j2SizK35LXU1rw03vqjsnFUw+4NewuZ5uddEpiBcOxjQv2rRLMz3gT9/RdXkKbyT2G
	PxttphsqsRRnJBpqMRcVJwIAu6ZMkvgBAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Exynos4 USE_DELAYED_RESET_ASSERTION must be set in
ARM_COREx_OPTION register during CPU power down. This is the proper way
of powering down CPU.

Additionally without this the CPU clock down won't work after powering
down some other CPU and online CPUs will work at full frequency chosen
by CPUfreq governor.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>

---
Changes since v1:
1. Use delayed reset assertion on all Exynos4 family and all cores, not
   only on core 1 of Exynos4212.
2. Rebase on Tomasz Figa's patch:
   ARM: EXYNOS: Fix core ID used by platsmp and hotplug code
   http://www.spinics.net/lists/linux-samsung-soc/msg31604.html
---
 arch/arm/mach-exynos/hotplug.c  | 27 +++++++++++++++++++++++++--
 arch/arm/mach-exynos/regs-pmu.h |  3 +++
 2 files changed, 28 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mach-exynos/hotplug.c b/arch/arm/mach-exynos/hotplug.c
index 920a4baa53cd..f2521bc53869 100644
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
+			 * global idle state when CPU1 is off.
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

