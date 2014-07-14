Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751787AbaGNHri (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 03:47:38 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:11905 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750731AbaGNHrb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 03:47:31 -0400
X-AuditID: cbfec7f5-b7f626d000004b39-f5-53c38b08a9a1
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Russell King <linux@arm.linux.org.uk>, Kukjin Kim <kgene.kim@samsung.com>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Tomasz Figa <t.figa@samsung.com>,
        Sachin Kamat <sachin.kamat@samsung.com>,
        Olof Johansson <olof@lixom.net>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH v2] ARM: EXYNOS: Fix build with PM_SLEEP=n
Date: Mon, 14 Jul 2014 09:45:53 +0200
Message-id: <1405323953-25954-1-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrGJMWRmVeSWpSXmKPExsVy+t/xK7oc3YeDDTZOlbXYOGM9q8XrF4YW
	vQuuslmcbXrDbrHp8TVWi8u75rBZzDi/j8ni9mVei7VH7rJbnLr+mc3iyqVTbBbrZ7xmceDx
	aGnuYfPYvKTe48qJJlaPvi2rGD0+b5ILYI3isklJzcksSy3St0vgyti4YTNLwSmNiuVP/zM1
	MB5R7GLk5JAQMJF4uPUYG4QtJnHh3nogm4tDSGApo8Tyu08ZIZw+JolZi6cwglSxCRhLbF6+
	BKxKRGAHUNW9y+wgDrPAZiaJnq/nmEGqhAWsJN59OssKYrMIqEos+bCaBcTmFXCXuHHnBQvE
	PjmJk8cms05g5F7AyLCKUTS1NLmgOCk910ivODG3uDQvXS85P3cTIySsvu5gXHrM6hCjAAej
	Eg9vAf/hYCHWxLLiytxDjBIczEoivOFuQCHelMTKqtSi/Pii0pzU4kOMTBycUg2MU2bvid1x
	eOYkpdt7rPdkNDK+fTf99Jfqz7by8xfuzHqbuPeyW13YtO4dxc/sQxsP8T/qYJqV8CW8Vm7V
	5JIF3xeySDQXGh2KcTogGn5zi7LGrnVfqr5GPb1jK73poO6qk6oKkld+lsc4THnNLrHus7xl
	6TqO72W7d1690/R6v7lX+FXlvx4tHkosxRmJhlrMRcWJAEqW4fwJAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix building of exynos defconfig with disabled PM_SLEEP:
CONFIG_PM_SLEEP=n
CONFIG_PM_SLEEP_SMP=n
CONFIG_SUSPEND=n
by moving functions for power up/down of CPU and cluster to platsmp.c

The build error messages:
arch/arm/mach-exynos/built-in.o: In function `exynos_boot_secondary':
arch/arm/mach-exynos/platsmp.c:111: undefined reference to `exynos_cpu_power_state'
arch/arm/mach-exynos/platsmp.c:112: undefined reference to `exynos_cpu_power_up'
arch/arm/mach-exynos/platsmp.c:116: undefined reference to `exynos_cpu_power_state'
make: *** [vmlinux] Error 1

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>

---
Changes since v1:
1. Use different solution - just move the power up/down functions to a
   common place instead of adding stubs in common.h. Suggested by Tomasz
   Figa.
---
 arch/arm/mach-exynos/platsmp.c | 66 ++++++++++++++++++++++++++++++++++++++++++
 arch/arm/mach-exynos/pm.c      | 66 ------------------------------------------
 2 files changed, 66 insertions(+), 66 deletions(-)

diff --git a/arch/arm/mach-exynos/platsmp.c b/arch/arm/mach-exynos/platsmp.c
index b15ea30faa7c..d435175671e0 100644
--- a/arch/arm/mach-exynos/platsmp.c
+++ b/arch/arm/mach-exynos/platsmp.c
@@ -31,6 +31,72 @@
 
 extern void exynos4_secondary_startup(void);
 
+/**
+ * exynos_core_power_down : power down the specified cpu
+ * @cpu : the cpu to power down
+ *
+ * Power down the specified cpu. The sequence must be finished by a
+ * call to cpu_do_idle()
+ *
+ */
+void exynos_cpu_power_down(int cpu)
+{
+	__raw_writel(0, EXYNOS_ARM_CORE_CONFIGURATION(cpu));
+}
+
+/**
+ * exynos_cpu_power_up : power up the specified cpu
+ * @cpu : the cpu to power up
+ *
+ * Power up the specified cpu
+ */
+void exynos_cpu_power_up(int cpu)
+{
+	__raw_writel(S5P_CORE_LOCAL_PWR_EN,
+		     EXYNOS_ARM_CORE_CONFIGURATION(cpu));
+}
+
+/**
+ * exynos_cpu_power_state : returns the power state of the cpu
+ * @cpu : the cpu to retrieve the power state from
+ *
+ */
+int exynos_cpu_power_state(int cpu)
+{
+	return (__raw_readl(EXYNOS_ARM_CORE_STATUS(cpu)) &
+			S5P_CORE_LOCAL_PWR_EN);
+}
+
+/**
+ * exynos_cluster_power_down : power down the specified cluster
+ * @cluster : the cluster to power down
+ */
+void exynos_cluster_power_down(int cluster)
+{
+	__raw_writel(0, EXYNOS_COMMON_CONFIGURATION(cluster));
+}
+
+/**
+ * exynos_cluster_power_up : power up the specified cluster
+ * @cluster : the cluster to power up
+ */
+void exynos_cluster_power_up(int cluster)
+{
+	__raw_writel(S5P_CORE_LOCAL_PWR_EN,
+		     EXYNOS_COMMON_CONFIGURATION(cluster));
+}
+
+/**
+ * exynos_cluster_power_state : returns the power state of the cluster
+ * @cluster : the cluster to retrieve the power state from
+ *
+ */
+int exynos_cluster_power_state(int cluster)
+{
+	return (__raw_readl(EXYNOS_COMMON_STATUS(cluster)) &
+			S5P_CORE_LOCAL_PWR_EN);
+}
+
 static inline void __iomem *cpu_boot_reg_base(void)
 {
 	if (soc_is_exynos4210() && samsung_rev() == EXYNOS4210_REV_1_1)
diff --git a/arch/arm/mach-exynos/pm.c b/arch/arm/mach-exynos/pm.c
index fa7218a99580..6ab68a068e93 100644
--- a/arch/arm/mach-exynos/pm.c
+++ b/arch/arm/mach-exynos/pm.c
@@ -101,72 +101,6 @@ static int exynos_irq_set_wake(struct irq_data *data, unsigned int state)
 	return -ENOENT;
 }
 
-/**
- * exynos_core_power_down : power down the specified cpu
- * @cpu : the cpu to power down
- *
- * Power down the specified cpu. The sequence must be finished by a
- * call to cpu_do_idle()
- *
- */
-void exynos_cpu_power_down(int cpu)
-{
-	__raw_writel(0, EXYNOS_ARM_CORE_CONFIGURATION(cpu));
-}
-
-/**
- * exynos_cpu_power_up : power up the specified cpu
- * @cpu : the cpu to power up
- *
- * Power up the specified cpu
- */
-void exynos_cpu_power_up(int cpu)
-{
-	__raw_writel(S5P_CORE_LOCAL_PWR_EN,
-		     EXYNOS_ARM_CORE_CONFIGURATION(cpu));
-}
-
-/**
- * exynos_cpu_power_state : returns the power state of the cpu
- * @cpu : the cpu to retrieve the power state from
- *
- */
-int exynos_cpu_power_state(int cpu)
-{
-	return (__raw_readl(EXYNOS_ARM_CORE_STATUS(cpu)) &
-			S5P_CORE_LOCAL_PWR_EN);
-}
-
-/**
- * exynos_cluster_power_down : power down the specified cluster
- * @cluster : the cluster to power down
- */
-void exynos_cluster_power_down(int cluster)
-{
-	__raw_writel(0, EXYNOS_COMMON_CONFIGURATION(cluster));
-}
-
-/**
- * exynos_cluster_power_up : power up the specified cluster
- * @cluster : the cluster to power up
- */
-void exynos_cluster_power_up(int cluster)
-{
-	__raw_writel(S5P_CORE_LOCAL_PWR_EN,
-		     EXYNOS_COMMON_CONFIGURATION(cluster));
-}
-
-/**
- * exynos_cluster_power_state : returns the power state of the cluster
- * @cluster : the cluster to retrieve the power state from
- *
- */
-int exynos_cluster_power_state(int cluster)
-{
-	return (__raw_readl(EXYNOS_COMMON_STATUS(cluster)) &
-			S5P_CORE_LOCAL_PWR_EN);
-}
-
 #define EXYNOS_BOOT_VECTOR_ADDR	(samsung_rev() == EXYNOS4210_REV_1_1 ? \
 			S5P_INFORM7 : (samsung_rev() == EXYNOS4210_REV_1_0 ? \
 			(sysram_base_addr + 0x24) : S5P_INFORM0))
-- 
1.9.1

