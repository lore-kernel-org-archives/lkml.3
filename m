Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933437AbaEMOMx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 10:12:53 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:14999 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932564AbaEMOMv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 10:12:51 -0400
X-AuditID: cbfec7f5-b7fae6d000004d6d-3e-537228602963
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Russell King <linux@arm.linux.org.uk>, Kukjin Kim <kgene.kim@samsung.com>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Tomasz Figa <t.figa@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH] ARM: exynos4212: hotplug: Fix CPU idle clock down after CPU1
 off
Date: Tue, 13 May 2014 16:12:58 +0200
Message-id: <1399990378-7023-1-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrKJMWRmVeSWpSXmKPExsVy+t/xy7oJGkXBBhObeS02zljPavH6haFF
	74KrbBZnm96wW2x6fI3V4vKuOWwWM87vY7K4fZnXYu2Ru+wW62e8ZnHg8mhp7mHz2Lyk3qNv
	yypGj8+b5AJYorhsUlJzMstSi/TtErgyfv57zlpwWqLixZF7jA2MX4S7GDk5JARMJN40tDJB
	2GISF+6tZ+ti5OIQEljKKPFr529GCKePSeLGh/usIFVsAsYSm5cvAasSEdjBKLH83mV2kASz
	wHNGiaffw0FsYYFgiWlN88EaWARUJfrb/7N0MXJw8Aq4STw8KACxTU7i5LHJrBMYuRcwMqxi
	FE0tTS4oTkrPNdIrTswtLs1L10vOz93ECAmarzsYlx6zOsQowMGoxMPrwVwQLMSaWFZcmXuI
	UYKDWUmEV1alKFiINyWxsiq1KD++qDQntfgQIxMHp1QDo28c14LPf2W/58ecUdeyz0tcttLm
	e/N7rhC7PMMMN3Nd90zTmZKzo8SY/BbdKHjTwxz+SP2pkarwZIlzF+f7Pjrz4Gf2izjVvl1p
	7X0aPlcsPu0T5/7pbrw61CDhzi75BO0+I0233g+eN3QerZ8mJ6b4Ztdiv+6LgoIBRh+XG3vm
	e025tTBAiaU4I9FQi7moOBEAykuyVfgBAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Exynos4212 USE_DELAYED_RESET_ASSERTION must be set in
ARM_CORE1_OPTION register during CPU power down. This is the proper way
of powering down CPU. Additionally without this the CPU clock down won't
work after powering down CPU1 and CPU will work at full frequency chosen
by CPUfreq governor.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
---
 arch/arm/mach-exynos/hotplug.c  | 28 +++++++++++++++++++++++++---
 arch/arm/mach-exynos/regs-pmu.h |  2 ++
 2 files changed, 27 insertions(+), 3 deletions(-)

diff --git a/arch/arm/mach-exynos/hotplug.c b/arch/arm/mach-exynos/hotplug.c
index 5eead530c6f8..59b813e74558 100644
--- a/arch/arm/mach-exynos/hotplug.c
+++ b/arch/arm/mach-exynos/hotplug.c
@@ -74,7 +74,7 @@ static inline void cpu_enter_lowpower_a15(void)
 	dsb();
 }
 
-static inline void cpu_leave_lowpower(void)
+static inline void cpu_leave_lowpower(unsigned int cpu)
 {
 	unsigned int v;
 
@@ -88,6 +88,14 @@ static inline void cpu_leave_lowpower(void)
 	  : "=&r" (v)
 	  : "Ir" (CR_C), "Ir" (0x40)
 	  : "cc");
+
+	if (cpu == 1 && soc_is_exynos4212()) {
+		unsigned int tmp;
+
+		tmp = __raw_readl(S5P_ARM_CORE1_OPTION);
+		tmp &= ~(S5P_USE_DELAYED_RESET_ASSERTION);
+		__raw_writel(tmp, S5P_ARM_CORE1_OPTION);
+	}
 }
 
 static inline void platform_do_lowpower(unsigned int cpu, int *spurious)
@@ -95,8 +103,22 @@ static inline void platform_do_lowpower(unsigned int cpu, int *spurious)
 	for (;;) {
 
 		/* make cpu1 to be turned off at next WFI command */
-		if (cpu == 1)
+		if (cpu == 1) {
+			if (soc_is_exynos4212()) {
+				unsigned int tmp;
+
+				/*
+				 * Exynos 4212 requires setting
+				 * USE_DELAYED_RESET_ASSERTION so the CPU idle
+				 * clock down feature could properly detect
+				 * global idle state when CPU1 is off.
+				 */
+				tmp = __raw_readl(S5P_ARM_CORE1_OPTION);
+				tmp |= S5P_USE_DELAYED_RESET_ASSERTION;
+				__raw_writel(tmp, S5P_ARM_CORE1_OPTION);
+			}
 			__raw_writel(0, S5P_ARM_CORE1_CONFIGURATION);
+		}
 
 		/*
 		 * here's the WFI
@@ -152,7 +174,7 @@ void __ref exynos_cpu_die(unsigned int cpu)
 	 * bring this CPU back into the world of cache
 	 * coherency, and then restore interrupts
 	 */
-	cpu_leave_lowpower();
+	cpu_leave_lowpower(cpu);
 
 	if (spurious)
 		pr_warn("CPU%u: %u spurious wakeup calls\n", cpu, spurious);
diff --git a/arch/arm/mach-exynos/regs-pmu.h b/arch/arm/mach-exynos/regs-pmu.h
index 4f6a2560d022..1a3da4ef0e22 100644
--- a/arch/arm/mach-exynos/regs-pmu.h
+++ b/arch/arm/mach-exynos/regs-pmu.h
@@ -25,6 +25,7 @@
 
 #define S5P_USE_STANDBY_WFI0			(1 << 16)
 #define S5P_USE_STANDBY_WFE0			(1 << 24)
+#define S5P_USE_DELAYED_RESET_ASSERTION		BIT(12)
 
 #define EXYNOS_SWRESET				S5P_PMUREG(0x0400)
 #define EXYNOS5440_SWRESET			S5P_PMUREG(0x00C4)
@@ -107,6 +108,7 @@
 
 #define S5P_ARM_CORE1_CONFIGURATION		S5P_PMUREG(0x2080)
 #define S5P_ARM_CORE1_STATUS			S5P_PMUREG(0x2084)
+#define S5P_ARM_CORE1_OPTION			S5P_PMUREG(0x2088)
 
 #define S5P_PAD_RET_MAUDIO_OPTION		S5P_PMUREG(0x3028)
 #define S5P_PAD_RET_GPIO_OPTION			S5P_PMUREG(0x3108)
-- 
1.9.1

