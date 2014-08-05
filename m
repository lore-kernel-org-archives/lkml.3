Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754759AbaHEMnh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 08:43:37 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:59088 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753017AbaHEMng (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 08:43:36 -0400
X-AuditID: cbfee61a-f79e46d00000134f-5d-53e0d16f9ea4
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Kukjin Kim <kgene.kim@samsung.com>
Cc: linux-samsung-soc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Tomasz Figa <t.figa@samsung.com>, Arnd Bergmann <arnd@arndb.de>,
        Olof Johansson <olof@lixom.net>, arm@kernel.org
Subject: [PATCH v5][next-20140804] ARM: EXYNOS: Fix suspend/resume sequences
Date: Tue, 05 Aug 2014 14:43:10 +0200
Message-id: <6342975.PHG2cX2jjn@amdc1032>
User-Agent: KMail/4.8.4 (Linux/3.2.0-54-generic-pae; KDE/4.8.5; i686; ; )
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=us-ascii
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrILMWRmVeSWpSXmKPExsVy+t9jQd38iw+CDV6081gc+7KFzeLvpGPs
	Fr0LrrJZbHp8jdXi8q45bBYzzu9jslh75C67xanrn9ks1s94zeLA6fH71yRGj02rOtk8Ni+p
	97hyoonVo2/LKkaPz5vkAtiiuGxSUnMyy1KL9O0SuDK+zLzLXtBuX/FqXR9TA+Nyky5GTg4J
	AROJ002L2SFsMYkL99azgdhCAtMZJU7MLOli5AKyW5gkmqd0gyXYBKwkJravYgSxRQTUJHoW
	b2UEKWIW6GOSmDalCywhLOAj8XnRe9YuRg4OFgFVidPrpEHCvAKaEguubGcGsUUFPCV2bF/J
	BhEXlPgx+R4LiM0sIC+xb/9UVghbS2L9zuNMExj5ZiEpm4WkbBaSsgWMzKsYRVMLkguKk9Jz
	DfWKE3OLS/PS9ZLzczcxggP6mdQOxpUNFocYBTgYlXh4BdTuBwuxJpYVV+YeYpTgYFYS4Z1w
	/kGwEG9KYmVValF+fFFpTmrxIUZpDhYlcd4DrdaBQgLpiSWp2ampBalFMFkmDk6pBkbldIHc
	wCNv+h09ZYJfuC70nbEk69CxVNZlW6a9lKlynXd/pUD6ikt1sumNvbNs7boXclR757x0L/d2
	UV598sbRaUUumvaXle8rljQe4u0QL/QzYA5Ne3cxqKPoRqbc3AkKDFa92qy9RZ81n1cHrJq9
	xVe9KW2q5NptidUvjuhk6JbeUrrCp8RSnJFoqMVcVJwIAEYUrd9kAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tomasz Figa <t.figa@samsung.com>

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

Fixes: 85f9f90808b4 ("ARM: EXYNOS: Use the cpu_pm notifier for pm")
Cc: Kukjin Kim <kgene.kim@samsung.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Olof Johansson <olof@lixom.net>
Cc: arm@kernel.org
Signed-off-by: Tomasz Figa <t.figa@samsung.com>
[b.zolnierkie: ported patch over current changes]
[b.zolnierkie: fixed exynos_aftr_finisher() return value]
Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
---
 arch/arm/mach-exynos/pm.c        |  163 ++++++++++++++++++---------------------
 drivers/cpuidle/cpuidle-exynos.c |   25 -----
 2 files changed, 80 insertions(+), 108 deletions(-)

v5:
- use read_cpuid_part() instead of the deprecated read_cpuid_part_number()

Index: b/arch/arm/mach-exynos/pm.c
===================================================================
--- a/arch/arm/mach-exynos/pm.c	2014-08-05 14:14:29.605182233 +0200
+++ b/arch/arm/mach-exynos/pm.c	2014-08-05 14:30:41.713207901 +0200
@@ -114,26 +114,6 @@ static int exynos_irq_set_wake(struct ir
 #define S5P_CHECK_AFTR  0xFCBA0D10
 #define S5P_CHECK_SLEEP 0x00000BAD
 
-/* Ext-GIC nIRQ/nFIQ is the only wakeup source in AFTR */
-static void exynos_set_wakeupmask(long mask)
-{
-	pmu_raw_writel(mask, S5P_WAKEUP_MASK);
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
 
@@ -173,6 +153,82 @@ static void exynos_cpu_restore_register(
 		      : "cc");
 }
 
+static void exynos_pm_central_suspend(void)
+{
+	unsigned long tmp;
+
+	/* Setting Central Sequence Register for power down mode */
+	tmp = pmu_raw_readl(S5P_CENTRAL_SEQ_CONFIGURATION);
+	tmp &= ~S5P_CENTRAL_LOWPWR_CFG;
+	pmu_raw_writel(tmp, S5P_CENTRAL_SEQ_CONFIGURATION);
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
+	tmp = pmu_raw_readl(S5P_CENTRAL_SEQ_CONFIGURATION);
+	if (!(tmp & S5P_CENTRAL_LOWPWR_CFG)) {
+		tmp |= S5P_CENTRAL_LOWPWR_CFG;
+		pmu_raw_writel(tmp, S5P_CENTRAL_SEQ_CONFIGURATION);
+		/* clear the wakeup state register */
+		pmu_raw_writel(0x0, S5P_WAKEUP_STAT);
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
+	pmu_raw_writel(mask, S5P_WAKEUP_MASK);
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
+	return 1;
+}
+
+void exynos_enter_aftr(void)
+{
+	cpu_pm_enter();
+
+	exynos_pm_central_suspend();
+	if (read_cpuid_part() == ARM_CPU_PART_CORTEX_A9)
+		exynos_cpu_save_register();
+
+	cpu_suspend(0, exynos_aftr_finisher);
+
+	if (read_cpuid_part() == ARM_CPU_PART_CORTEX_A9) {
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
@@ -217,16 +273,6 @@ static void exynos_pm_prepare(void)
 	pmu_raw_writel(virt_to_phys(exynos_cpu_resume), S5P_INFORM0);
 }
 
-static void exynos_pm_central_suspend(void)
-{
-	unsigned long tmp;
-
-	/* Setting Central Sequence Register for power down mode */
-	tmp = pmu_raw_readl(S5P_CENTRAL_SEQ_CONFIGURATION);
-	tmp &= ~S5P_CENTRAL_LOWPWR_CFG;
-	pmu_raw_writel(tmp, S5P_CENTRAL_SEQ_CONFIGURATION);
-}
-
 static int exynos_pm_suspend(void)
 {
 	unsigned long tmp;
@@ -244,29 +290,6 @@ static int exynos_pm_suspend(void)
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
-	tmp = pmu_raw_readl(S5P_CENTRAL_SEQ_CONFIGURATION);
-	if (!(tmp & S5P_CENTRAL_LOWPWR_CFG)) {
-		tmp |= S5P_CENTRAL_LOWPWR_CFG;
-		pmu_raw_writel(tmp, S5P_CENTRAL_SEQ_CONFIGURATION);
-		/* clear the wakeup state register */
-		pmu_raw_writel(0x0, S5P_WAKEUP_STAT);
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
@@ -369,44 +392,10 @@ static const struct platform_suspend_ops
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
-			if (read_cpuid_part() == ARM_CPU_PART_CORTEX_A9)
-				exynos_cpu_save_register();
-		}
-		break;
-
-	case CPU_PM_EXIT:
-		if (cpu == 0) {
-			if (read_cpuid_part() == ARM_CPU_PART_CORTEX_A9) {
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
 
Index: b/drivers/cpuidle/cpuidle-exynos.c
===================================================================
--- a/drivers/cpuidle/cpuidle-exynos.c	2014-08-05 14:14:29.641182236 +0200
+++ b/drivers/cpuidle/cpuidle-exynos.c	2014-08-05 14:16:54.037186047 +0200
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
@@ -51,8 +32,10 @@ static int exynos_enter_lowpower(struct
 
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

