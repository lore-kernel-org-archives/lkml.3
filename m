Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753973Ab3CKK53 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 06:57:29 -0400
Received: from mail-ie0-f173.google.com ([209.85.223.173]:36228 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753826Ab3CKK51 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 06:57:27 -0400
From: Amit Daniel Kachhap <amit.daniel@samsung.com>
To: linux-samsung-soc@vger.kernel.org, Kukjin Kim <kgene.kim@samsung.com>
Cc: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Kukjin Kim <kgene.kim@samsung.com>
Subject: [PATCH 2/2] ARM: EXYNOS: Support CPU hotplug for exynos5440
Date: Mon, 11 Mar 2013 16:27:02 +0530
Message-Id: <1362999422-24655-2-git-send-email-amit.daniel@samsung.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1362999422-24655-1-git-send-email-amit.daniel@samsung.com>
References: <1362999422-24655-1-git-send-email-amit.daniel@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds support for CPU hotlpug for the 3 secondary cores
of the exynos5440 SOC. The command to hotplug out/in is,
echo 0 > /sys/devices/system/cpu/cpu[1-3]/online
echo 1 > /sys/devices/system/cpu/cpu[1-3]/online

Cc: Kukjin Kim <kgene.kim@samsung.com>
Signed-off-by: Amit Daniel Kachhap <amit.daniel@samsung.com>
---
 arch/arm/mach-exynos/hotplug.c |   14 +++++++++++---
 arch/arm/mach-exynos/platsmp.c |   26 +++++++++++++++++++++++++-
 2 files changed, 36 insertions(+), 4 deletions(-)

diff --git a/arch/arm/mach-exynos/hotplug.c b/arch/arm/mach-exynos/hotplug.c
index c3f825b..fbee967 100644
--- a/arch/arm/mach-exynos/hotplug.c
+++ b/arch/arm/mach-exynos/hotplug.c
@@ -93,11 +93,19 @@ static inline void cpu_leave_lowpower(void)
 
 static inline void platform_do_lowpower(unsigned int cpu, int *spurious)
 {
+	unsigned int val;
 	for (;;) {
 
-		/* make cpu1 to be turned off at next WFI command */
-		if (cpu == 1)
-			__raw_writel(0, S5P_ARM_CORE1_CONFIGURATION);
+		/* make cpu to be turned off at next WFI command */
+		if (soc_is_exynos5440()) {
+			void __iomem *pmu_ctrl2_reg = S5P_VA_CHIPID + 0xc4;
+			val = __raw_readl(pmu_ctrl2_reg);
+			val |= (1 << (cpu + 8));
+			__raw_writel(val, pmu_ctrl2_reg);
+		} else {
+			if (cpu == 1)
+				__raw_writel(0, S5P_ARM_CORE1_CONFIGURATION);
+		}
 
 		/*
 		 * here's the WFI
diff --git a/arch/arm/mach-exynos/platsmp.c b/arch/arm/mach-exynos/platsmp.c
index 087b73f..8a5eb80 100644
--- a/arch/arm/mach-exynos/platsmp.c
+++ b/arch/arm/mach-exynos/platsmp.c
@@ -101,6 +101,7 @@ static int __cpuinit exynos_boot_secondary(unsigned int cpu, struct task_struct
 {
 	unsigned long timeout;
 	unsigned long phys_cpu = cpu_logical_map(cpu);
+	unsigned int val;
 
 	/*
 	 * Set synchronisation state between this boot processor
@@ -119,7 +120,30 @@ static int __cpuinit exynos_boot_secondary(unsigned int cpu, struct task_struct
 	write_pen_release(phys_cpu);
 
 	timeout = 10;
-	if (!soc_is_exynos5440()) {
+	if (soc_is_exynos5440()) {
+		void __iomem *pmu_status_reg = S5P_VA_CHIPID + 0xbc;
+		void __iomem *pmu_ctrl_reg = S5P_VA_CHIPID + 0xc0;
+		void __iomem *pmu_ctrl2_reg = S5P_VA_CHIPID + 0xc4;
+
+		if (!(__raw_readl(pmu_status_reg) & (1 << cpu))) {
+			val = __raw_readl(pmu_ctrl_reg);
+			val |= (1 << cpu);
+			__raw_writel(val, pmu_ctrl_reg);
+			/* wait max 10 ms until cpu1 is on */
+			while (!(__raw_readl(pmu_status_reg) & (1 << cpu))) {
+				if (timeout-- == 0)
+					break;
+
+				mdelay(1);
+			}
+		}
+		/* clear the ctrl2 powerdown */
+		val = __raw_readl(pmu_ctrl2_reg);
+		if (val & (1 << (cpu + 8))) {
+			val &= ~(1 << (cpu + 8));
+			__raw_writel(val, pmu_ctrl2_reg);
+		}
+	} else {
 		if (!(__raw_readl(S5P_ARM_CORE1_STATUS) &
 					S5P_CORE_LOCAL_PWR_EN)) {
 
-- 
1.7.1

