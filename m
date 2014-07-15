Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751466AbaGOOZq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 10:25:46 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:26665 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753575AbaGOOZn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 10:25:43 -0400
X-AuditID: cbfec7f4-b7fac6d000006cfe-7c-53c539daecfc
From: Tomasz Figa <t.figa@samsung.com>
To: linux-samsung-soc@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Kukjin Kim <kgene.kim@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Abhilash Kesavan <kesavan.abhilash@gmail.com>,
        Chander Kashyap <k.chander@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Tomasz Figa <tomasz.figa@gmail.com>, Tomasz Figa <t.figa@samsung.com>
Subject: [PATCH v3] ARM: EXYNOS: Fix suspend/resume sequences
Date: Tue, 15 Jul 2014 16:24:47 +0200
Message-id: <1405434287-22710-1-git-send-email-t.figa@samsung.com>
X-Mailer: git-send-email 1.9.3
In-reply-to: <53C51B57.9040404@samsung.com>
References: <53C51B57.9040404@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrLJMWRmVeSWpSXmKPExsVy+t/xa7q3LI8GGxzulLTYOGM9q8WqDUtY
	LNb8VbLoXXCVzWLT42usFpd3zWGzmHF+H5PF2iN32S3Wz3jNYrFq1x9GBy6PnbPusntsXlLv
	0bdlFaPH501yASxRXDYpqTmZZalF+nYJXBnHeiwKDlpVPN/+nLmBcbZBFyMnh4SAicSZ3Y8Y
	IWwxiQv31rN1MXJxCAksZZQ4veoeE4TTxyRxp2sDG0gVm4CaxOeGR2C2iICqxOe2BewgRcwC
	P5gkfr9eztzFyMEhLGArMe9RBEgNC1DNkhXPWEFsXgEniZOnf7BBbJOT6N32hhnE5hTQlri8
	+is7iC0koCWx/tpPxgmMvAsYGVYxiqaWJhcUJ6XnGuoVJ+YWl+al6yXn525ihATZlx2Mi49Z
	HWIU4GBU4uGtEDscLMSaWFZcmXuIUYKDWUmEV9LkaLAQb0piZVVqUX58UWlOavEhRiYOTqkG
	RnfT1e+8Vt+xvCr19YnurqNn1/D39jGazFwsK7Y+8vdqkz26XTzHYkr2lXdcPV+0cMqKh2q5
	M78k3WZint369VPSX2OOWX/8z32686u8zSBV/sJMjoLOhETuQ9lmEeoKki9Yo+u7j6iUc/YZ
	1n3VaNzY7eleIL/bwPeHieV5bsdItTcZHX9mKLEUZyQaajEXFScCAJVwmUsQAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Due to recent consolidation of Exynos suspend and cpuidle code, some
parts of suspend and resume sequences are executed two times, once from
exynos_pm_syscore_ops and then from exynos_cpu_pm_notifier() and thus it
breaks suspend, at least on Exynos4-based boards. In addition, simple
core power down from a cpuidle driver could, in case of CPU 0 could
result in calling functions that are specific to suspend and deeper idle
states.

This patch fixes the issue by moving those operations outside the CPU PM
notifier into suspend and AFTR code paths. This leads to a bit of code
duplication, but allows additional code simplification, so in the end
more code is removed than added.

Signed-off-by: Tomasz Figa <t.figa@samsung.com>
---
 arch/arm/mach-exynos/pm.c        | 164 ++++++++++++++++++---------------------
 drivers/cpuidle/cpuidle-exynos.c |  25 +-----
 2 files changed, 80 insertions(+), 109 deletions(-)

diff --git a/arch/arm/mach-exynos/pm.c b/arch/arm/mach-exynos/pm.c
index 202ca73..e3b04b4 100644
--- a/arch/arm/mach-exynos/pm.c
+++ b/arch/arm/mach-exynos/pm.c
@@ -176,26 +176,6 @@ int exynos_cluster_power_state(int cluster)
 #define S5P_CHECK_AFTR  0xFCBA0D10
 #define S5P_CHECK_SLEEP 0x00000BAD
 
-/* Ext-GIC nIRQ/nFIQ is the only wakeup source in AFTR */
-static void exynos_set_wakeupmask(long mask)
-{
-	__raw_writel(mask, S5P_WAKEUP_MASK);
-}
-
-static void exynos_cpu_set_boot_vector(long flags)
-{
-	__raw_writel(virt_to_phys(exynos_cpu_resume), EXYNOS_BOOT_VECTOR_ADDR);
-	__raw_writel(flags, EXYNOS_BOOT_VECTOR_FLAG);
-}
-
-void exynos_enter_aftr(void)
-{
-	exynos_set_wakeupmask(0x0000ff3e);
-	exynos_cpu_set_boot_vector(S5P_CHECK_AFTR);
-	/* Set value of power down register for aftr mode */
-	exynos_sys_powerdown_conf(SYS_AFTR);
-}
-
 /* For Cortex-A9 Diagnostic and Power control register */
 static unsigned int save_arm_register[2];
 
@@ -235,6 +215,82 @@ static void exynos_cpu_restore_register(void)
 		      : "cc");
 }
 
+static void exynos_pm_central_suspend(void)
+{
+	unsigned long tmp;
+
+	/* Setting Central Sequence Register for power down mode */
+	tmp = __raw_readl(S5P_CENTRAL_SEQ_CONFIGURATION);
+	tmp &= ~S5P_CENTRAL_LOWPWR_CFG;
+	__raw_writel(tmp, S5P_CENTRAL_SEQ_CONFIGURATION);
+}
+
+static int exynos_pm_central_resume(void)
+{
+	unsigned long tmp;
+
+	/*
+	 * If PMU failed while entering sleep mode, WFI will be
+	 * ignored by PMU and then exiting cpu_do_idle().
+	 * S5P_CENTRAL_LOWPWR_CFG bit will not be set automatically
+	 * in this situation.
+	 */
+	tmp = __raw_readl(S5P_CENTRAL_SEQ_CONFIGURATION);
+	if (!(tmp & S5P_CENTRAL_LOWPWR_CFG)) {
+		tmp |= S5P_CENTRAL_LOWPWR_CFG;
+		__raw_writel(tmp, S5P_CENTRAL_SEQ_CONFIGURATION);
+		/* clear the wakeup state register */
+		__raw_writel(0x0, S5P_WAKEUP_STAT);
+		/* No need to perform below restore code */
+		return -1;
+	}
+
+	return 0;
+}
+
+/* Ext-GIC nIRQ/nFIQ is the only wakeup source in AFTR */
+static void exynos_set_wakeupmask(long mask)
+{
+	__raw_writel(mask, S5P_WAKEUP_MASK);
+}
+
+static void exynos_cpu_set_boot_vector(long flags)
+{
+	__raw_writel(virt_to_phys(exynos_cpu_resume), EXYNOS_BOOT_VECTOR_ADDR);
+	__raw_writel(flags, EXYNOS_BOOT_VECTOR_FLAG);
+}
+
+static int exynos_aftr_finisher(unsigned long flags)
+{
+	exynos_set_wakeupmask(0x0000ff3e);
+	exynos_cpu_set_boot_vector(S5P_CHECK_AFTR);
+	/* Set value of power down register for aftr mode */
+	exynos_sys_powerdown_conf(SYS_AFTR);
+	cpu_do_idle();
+
+	return 0;
+}
+
+void exynos_enter_aftr(void)
+{
+	cpu_pm_enter();
+
+	exynos_pm_central_suspend();
+	if (read_cpuid_part_number() == ARM_CPU_PART_CORTEX_A9)
+		exynos_cpu_save_register();
+
+	cpu_suspend(0, exynos_aftr_finisher);
+
+	if (read_cpuid_part_number() == ARM_CPU_PART_CORTEX_A9) {
+		scu_enable(S5P_VA_SCU);
+		exynos_cpu_restore_register();
+	}
+
+	exynos_pm_central_resume();
+
+	cpu_pm_exit();
+}
+
 static int exynos_cpu_suspend(unsigned long arg)
 {
 #ifdef CONFIG_CACHE_L2X0
@@ -279,16 +335,6 @@ static void exynos_pm_prepare(void)
 	__raw_writel(virt_to_phys(exynos_cpu_resume), S5P_INFORM0);
 }
 
-static void exynos_pm_central_suspend(void)
-{
-	unsigned long tmp;
-
-	/* Setting Central Sequence Register for power down mode */
-	tmp = __raw_readl(S5P_CENTRAL_SEQ_CONFIGURATION);
-	tmp &= ~S5P_CENTRAL_LOWPWR_CFG;
-	__raw_writel(tmp, S5P_CENTRAL_SEQ_CONFIGURATION);
-}
-
 static int exynos_pm_suspend(void)
 {
 	unsigned long tmp;
@@ -306,29 +352,6 @@ static int exynos_pm_suspend(void)
 	return 0;
 }
 
-static int exynos_pm_central_resume(void)
-{
-	unsigned long tmp;
-
-	/*
-	 * If PMU failed while entering sleep mode, WFI will be
-	 * ignored by PMU and then exiting cpu_do_idle().
-	 * S5P_CENTRAL_LOWPWR_CFG bit will not be set automatically
-	 * in this situation.
-	 */
-	tmp = __raw_readl(S5P_CENTRAL_SEQ_CONFIGURATION);
-	if (!(tmp & S5P_CENTRAL_LOWPWR_CFG)) {
-		tmp |= S5P_CENTRAL_LOWPWR_CFG;
-		__raw_writel(tmp, S5P_CENTRAL_SEQ_CONFIGURATION);
-		/* clear the wakeup state register */
-		__raw_writel(0x0, S5P_WAKEUP_STAT);
-		/* No need to perform below restore code */
-		return -1;
-	}
-
-	return 0;
-}
-
 static void exynos_pm_resume(void)
 {
 	if (exynos_pm_central_resume())
@@ -431,45 +454,10 @@ static const struct platform_suspend_ops exynos_suspend_ops = {
 	.valid		= suspend_valid_only_mem,
 };
 
-static int exynos_cpu_pm_notifier(struct notifier_block *self,
-				  unsigned long cmd, void *v)
-{
-	int cpu = smp_processor_id();
-
-	switch (cmd) {
-	case CPU_PM_ENTER:
-		if (cpu == 0) {
-			exynos_pm_central_suspend();
-			if (read_cpuid_part_number() == ARM_CPU_PART_CORTEX_A9)
-				exynos_cpu_save_register();
-		}
-		break;
-
-	case CPU_PM_EXIT:
-		if (cpu == 0) {
-			if (read_cpuid_part_number() ==
-					ARM_CPU_PART_CORTEX_A9) {
-				scu_enable(S5P_VA_SCU);
-				exynos_cpu_restore_register();
-			}
-			exynos_pm_central_resume();
-		}
-		break;
-	}
-
-	return NOTIFY_OK;
-}
-
-static struct notifier_block exynos_cpu_pm_notifier_block = {
-	.notifier_call = exynos_cpu_pm_notifier,
-};
-
 void __init exynos_pm_init(void)
 {
 	u32 tmp;
 
-	cpu_pm_register_notifier(&exynos_cpu_pm_notifier_block);
-
 	/* Platform-specific GIC callback */
 	gic_arch_extn.irq_set_wake = exynos_irq_set_wake;
 
diff --git a/drivers/cpuidle/cpuidle-exynos.c b/drivers/cpuidle/cpuidle-exynos.c
index 7c01512..ba9b34b 100644
--- a/drivers/cpuidle/cpuidle-exynos.c
+++ b/drivers/cpuidle/cpuidle-exynos.c
@@ -20,25 +20,6 @@
 
 static void (*exynos_enter_aftr)(void);
 
-static int idle_finisher(unsigned long flags)
-{
-	exynos_enter_aftr();
-	cpu_do_idle();
-
-	return 1;
-}
-
-static int exynos_enter_core0_aftr(struct cpuidle_device *dev,
-				struct cpuidle_driver *drv,
-				int index)
-{
-	cpu_pm_enter();
-	cpu_suspend(0, idle_finisher);
-	cpu_pm_exit();
-
-	return index;
-}
-
 static int exynos_enter_lowpower(struct cpuidle_device *dev,
 				struct cpuidle_driver *drv,
 				int index)
@@ -51,8 +32,10 @@ static int exynos_enter_lowpower(struct cpuidle_device *dev,
 
 	if (new_index == 0)
 		return arm_cpuidle_simple_enter(dev, drv, new_index);
-	else
-		return exynos_enter_core0_aftr(dev, drv, new_index);
+
+	exynos_enter_aftr();
+
+	return new_index;
 }
 
 static struct cpuidle_driver exynos_idle_driver = {
-- 
1.9.3

