Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753953Ab3CKK5Z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 06:57:25 -0400
Received: from mail-ie0-f176.google.com ([209.85.223.176]:54015 "EHLO
	mail-ie0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753735Ab3CKK5X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 06:57:23 -0400
From: Amit Daniel Kachhap <amit.daniel@samsung.com>
To: linux-samsung-soc@vger.kernel.org, Kukjin Kim <kgene.kim@samsung.com>
Cc: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Kukjin Kim <kgene.kim@samsung.com>
Subject: [PATCH 1/2] ARM: EXYNOS: enable all secondary cores for exynos5440
Date: Mon, 11 Mar 2013 16:27:01 +0530
Message-Id: <1362999422-24655-1-git-send-email-amit.daniel@samsung.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch enables four cores on exynos5440. Also this patch skips the non
exynos5440 pmu control changes.

Cc: Kukjin Kim <kgene.kim@samsung.com>
Signed-off-by: Kukjin Kim <kgene.kim@samsung.com>
Signed-off-by: Amit Daniel Kachhap <amit.daniel@samsung.com>
---
 arch/arm/mach-exynos/platsmp.c |   44 ++++++++++++++++++++++-----------------
 1 files changed, 25 insertions(+), 19 deletions(-)

diff --git a/arch/arm/mach-exynos/platsmp.c b/arch/arm/mach-exynos/platsmp.c
index 60f7c5b..087b73f 100644
--- a/arch/arm/mach-exynos/platsmp.c
+++ b/arch/arm/mach-exynos/platsmp.c
@@ -40,6 +40,8 @@ static inline void __iomem *cpu_boot_reg_base(void)
 {
 	if (soc_is_exynos4210() && samsung_rev() == EXYNOS4210_REV_1_1)
 		return S5P_INFORM5;
+	else if (soc_is_exynos5440())
+		return S5P_VA_CHIPID + 0x560;
 	return S5P_VA_SYSRAM;
 }
 
@@ -116,27 +118,29 @@ static int __cpuinit exynos_boot_secondary(unsigned int cpu, struct task_struct
 	 */
 	write_pen_release(phys_cpu);
 
-	if (!(__raw_readl(S5P_ARM_CORE1_STATUS) & S5P_CORE_LOCAL_PWR_EN)) {
-		__raw_writel(S5P_CORE_LOCAL_PWR_EN,
-			     S5P_ARM_CORE1_CONFIGURATION);
-
-		timeout = 10;
-
-		/* wait max 10 ms until cpu1 is on */
-		while ((__raw_readl(S5P_ARM_CORE1_STATUS)
-			& S5P_CORE_LOCAL_PWR_EN) != S5P_CORE_LOCAL_PWR_EN) {
-			if (timeout-- == 0)
-				break;
-
-			mdelay(1);
-		}
-
-		if (timeout == 0) {
-			printk(KERN_ERR "cpu1 power enable failed");
-			spin_unlock(&boot_lock);
-			return -ETIMEDOUT;
+	timeout = 10;
+	if (!soc_is_exynos5440()) {
+		if (!(__raw_readl(S5P_ARM_CORE1_STATUS) &
+					S5P_CORE_LOCAL_PWR_EN)) {
+
+			__raw_writel(S5P_CORE_LOCAL_PWR_EN,
+				     S5P_ARM_CORE1_CONFIGURATION);
+
+			/* wait max 10 ms until this cpu is on */
+			while (!(__raw_readl(S5P_ARM_CORE1_STATUS) &
+					S5P_CORE_LOCAL_PWR_EN)) {
+				if (timeout-- == 0)
+					break;
+				mdelay(1);
+			}
 		}
 	}
+	if (timeout == 0) {
+		pr_err("cpu%d power enable failed", cpu);
+		spin_unlock(&boot_lock);
+		return -ETIMEDOUT;
+	}
+
 	/*
 	 * Send the secondary CPU a soft interrupt, thereby causing
 	 * the boot monitor to read the system wide flags register,
@@ -178,6 +182,8 @@ static void __init exynos_smp_init_cpus(void)
 
 	if (soc_is_exynos5250())
 		ncores = 2;
+	else if (soc_is_exynos5440())
+		ncores = 4;
 	else
 		ncores = scu_base ? scu_get_core_count(scu_base) : 1;
 
-- 
1.7.1

