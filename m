Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753407AbaIXOUZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 10:20:25 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:21895 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751281AbaIXOUU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 10:20:20 -0400
X-AuditID: cbfee61a-f79c06d000004e71-c6-5422d321eefb
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Kukjin Kim <kgene.kim@samsung.com>
Cc: Daniel Lezcano <daniel.lezcano@linaro.org>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Sachin Kamat <sachin.kamat@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Olof Johansson <olof@lixom.net>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        b.zolnierkie@samsung.com
Subject: [PATCH v3 1/1] ARM: EXYNOS: Fix build with PM_SLEEP=n and
 ARM_EXYNOS_CPUIDLE=y
Date: Wed, 24 Sep 2014 16:20:02 +0200
Message-id: <1411568402-24561-2-git-send-email-b.zolnierkie@samsung.com>
X-Mailer: git-send-email 1.7.10.4
In-reply-to: <1411568402-24561-1-git-send-email-b.zolnierkie@samsung.com>
References: <1411568402-24561-1-git-send-email-b.zolnierkie@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrNLMWRmVeSWpSXmKPExsVy+t9jAV3Fy0ohBksWaltsnLGe1WLeZ1mL
	1y8MLXoXXGWzONv0ht1i0+NrrBaXd81hs5hxfh+Txdojd9ktTl3/zGax+cNLNosrl06xWaza
	9YfRgdejpbmHzWPnrLvsHneu7WHz2Lyk3uPKiSZWj74tqxg9Pm+SC2CP4rJJSc3JLEst0rdL
	4MpY2+NfMGcTY8XCl//ZGxgfTWHsYuTkkBAwkZg6eQ8LhC0mceHeerYuRi4OIYFFjBLXljQx
	QThdTBKz5i9hAqliE7CSmNi+CqxbREBNomfxVkaQImaBh8wSnedvsoIkhAUiJR4828gOYrMI
	qEoc6OkBa+AV8JCY9b8Zap2iRPezCWwgNqeAp8SmO31gC4SAato3tDNNYORdwMiwilE0tSC5
	oDgpPddQrzgxt7g0L10vOT93EyM4SJ9J7WBc2WBxiFGAg1GJh9dxk1KIEGtiWXFl7iFGCQ5m
	JRHeoxeAQrwpiZVVqUX58UWlOanFhxilOViUxHkPtFoHCgmkJ5akZqemFqQWwWSZODilGhiz
	ZPdO3mB1Y4/fhapt6mf+TClUv3CGcZ+PxJ+Ci+9+/RL+VH5h+lm/pym6J9I1Tr7ID6i90HD9
	XuKjI9FtPzU+fTPg1u1OObI1kUfoeW3FvaA5Abp319RYqG6oNA14q6744MzDf1ffBk5NX5O5
	66hOzzzuT2vP556MLrh92E+gzWmFQWfAC9bJSizFGYmGWsxFxYkA7af3q04CAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix building of exynos_defconfig with CONFIG_PM_SLEEP disabled and
CONFIG_ARM_EXYNOS_CPUIDLE enabled by:

* adding EXYNOS_CPU_SUSPEND config option
* always building sleep.o
* building pm.o if EXYNOS_CPU_SUSPEND is enabled
* moving suspend specific code from pm.c to suspend.c
* enabling pm-common.o build also for EXYNOS_CPU_SUSPEND option

[ Please note that there are no changes in the code moved from pm.c
  to suspend.c except making few functions non-static and cleaning
  up includes. ]

Also while at it update Copyright dates.

The build error messages:
drivers/built-in.o: In function `exynos_enter_core0_aftr':
/home/bzolnier/linux/drivers/cpuidle/cpuidle-exynos.c:36: undefined reference to `cpu_suspend'
arch/arm/mach-exynos/built-in.o:(.data+0x74): undefined reference to `exynos_enter_aftr'
make: *** [vmlinux] Error 1

This patch has been tested on Exynos4210 based Origen board.

Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 arch/arm/mach-exynos/Kconfig   |   5 +
 arch/arm/mach-exynos/Makefile  |   5 +-
 arch/arm/mach-exynos/common.h  |   4 +
 arch/arm/mach-exynos/pm.c      | 338 +-------------------------------------
 arch/arm/mach-exynos/suspend.c | 356 +++++++++++++++++++++++++++++++++++++++++
 arch/arm/plat-samsung/Makefile |   1 +
 6 files changed, 374 insertions(+), 335 deletions(-)
 create mode 100644 arch/arm/mach-exynos/suspend.c

diff --git a/arch/arm/mach-exynos/Kconfig b/arch/arm/mach-exynos/Kconfig
index 2d0240f..46f3c0d 100644
--- a/arch/arm/mach-exynos/Kconfig
+++ b/arch/arm/mach-exynos/Kconfig
@@ -123,4 +123,9 @@ config EXYNOS5420_MCPM
 	  This is needed to provide CPU and cluster power management
 	  on Exynos5420 implementing big.LITTLE.
 
+config EXYNOS_CPU_SUSPEND
+	bool
+	select ARM_CPU_SUSPEND
+	default PM_SLEEP || ARM_EXYNOS_CPUIDLE
+
 endif
diff --git a/arch/arm/mach-exynos/Makefile b/arch/arm/mach-exynos/Makefile
index e7d1774..9f3c8ee 100644
--- a/arch/arm/mach-exynos/Makefile
+++ b/arch/arm/mach-exynos/Makefile
@@ -14,9 +14,10 @@ obj-				:=
 
 # Core
 
-obj-$(CONFIG_ARCH_EXYNOS)	+= exynos.o pmu.o exynos-smc.o firmware.o
+obj-$(CONFIG_ARCH_EXYNOS)	+= exynos.o pmu.o exynos-smc.o firmware.o sleep.o
 
-obj-$(CONFIG_PM_SLEEP)		+= pm.o sleep.o
+obj-$(CONFIG_EXYNOS_CPU_SUSPEND) += pm.o
+obj-$(CONFIG_PM_SLEEP)		+= suspend.o
 obj-$(CONFIG_PM_GENERIC_DOMAINS) += pm_domains.o
 
 obj-$(CONFIG_SMP)		+= platsmp.o headsmp.o
diff --git a/arch/arm/mach-exynos/common.h b/arch/arm/mach-exynos/common.h
index 2d830df..ef95cb1 100644
--- a/arch/arm/mach-exynos/common.h
+++ b/arch/arm/mach-exynos/common.h
@@ -164,6 +164,10 @@ extern int  exynos_cpu_power_state(int cpu);
 extern void exynos_cluster_power_down(int cluster);
 extern void exynos_cluster_power_up(int cluster);
 extern int  exynos_cluster_power_state(int cluster);
+extern void exynos_cpu_save_register(void);
+extern void exynos_cpu_restore_register(void);
+extern void exynos_pm_central_suspend(void);
+extern int exynos_pm_central_resume(void);
 extern void exynos_enter_aftr(void);
 
 extern void s5p_init_cpu(void __iomem *cpuid_addr);
diff --git a/arch/arm/mach-exynos/pm.c b/arch/arm/mach-exynos/pm.c
index 16c5c32..4f10fa6 100644
--- a/arch/arm/mach-exynos/pm.c
+++ b/arch/arm/mach-exynos/pm.c
@@ -1,5 +1,5 @@
 /*
- * Copyright (c) 2011-2012 Samsung Electronics Co., Ltd.
+ * Copyright (c) 2011-2014 Samsung Electronics Co., Ltd.
  *		http://www.samsung.com
  *
  * EXYNOS - Power Management support
@@ -15,119 +15,20 @@
 
 #include <linux/init.h>
 #include <linux/suspend.h>
-#include <linux/syscore_ops.h>
 #include <linux/cpu_pm.h>
 #include <linux/io.h>
-#include <linux/irqchip/arm-gic.h>
 #include <linux/err.h>
-#include <linux/clk.h>
 
-#include <asm/cacheflush.h>
 #include <asm/firmware.h>
-#include <asm/hardware/cache-l2x0.h>
 #include <asm/smp_scu.h>
 #include <asm/suspend.h>
 
 #include <plat/pm-common.h>
-#include <plat/regs-srom.h>
-
-#include <mach/map.h>
 
 #include "common.h"
 #include "regs-pmu.h"
 #include "regs-sys.h"
 
-#define REG_TABLE_END (-1U)
-
-/**
- * struct exynos_wkup_irq - Exynos GIC to PMU IRQ mapping
- * @hwirq: Hardware IRQ signal of the GIC
- * @mask: Mask in PMU wake-up mask register
- */
-struct exynos_wkup_irq {
-	unsigned int hwirq;
-	u32 mask;
-};
-
-static struct sleep_save exynos5_sys_save[] = {
-	SAVE_ITEM(EXYNOS5_SYS_I2C_CFG),
-};
-
-static struct sleep_save exynos_core_save[] = {
-	/* SROM side */
-	SAVE_ITEM(S5P_SROM_BW),
-	SAVE_ITEM(S5P_SROM_BC0),
-	SAVE_ITEM(S5P_SROM_BC1),
-	SAVE_ITEM(S5P_SROM_BC2),
-	SAVE_ITEM(S5P_SROM_BC3),
-};
-
-struct exynos_pm_data {
-	const struct exynos_wkup_irq *wkup_irq;
-	struct sleep_save *extra_save;
-	int num_extra_save;
-	unsigned int wake_disable_mask;
-	unsigned int *release_ret_regs;
-
-	void (*pm_prepare)(void);
-	void (*pm_resume)(void);
-	int (*pm_suspend)(void);
-	int (*cpu_suspend)(unsigned long);
-};
-
-struct exynos_pm_data *pm_data;
-
-/*
- * GIC wake-up support
- */
-
-static u32 exynos_irqwake_intmask = 0xffffffff;
-
-static const struct exynos_wkup_irq exynos4_wkup_irq[] = {
-	{ 76, BIT(1) }, /* RTC alarm */
-	{ 77, BIT(2) }, /* RTC tick */
-	{ /* sentinel */ },
-};
-
-static const struct exynos_wkup_irq exynos5250_wkup_irq[] = {
-	{ 75, BIT(1) }, /* RTC alarm */
-	{ 76, BIT(2) }, /* RTC tick */
-	{ /* sentinel */ },
-};
-
-unsigned int exynos_release_ret_regs[] = {
-	S5P_PAD_RET_MAUDIO_OPTION,
-	S5P_PAD_RET_GPIO_OPTION,
-	S5P_PAD_RET_UART_OPTION,
-	S5P_PAD_RET_MMCA_OPTION,
-	S5P_PAD_RET_MMCB_OPTION,
-	S5P_PAD_RET_EBIA_OPTION,
-	S5P_PAD_RET_EBIB_OPTION,
-	REG_TABLE_END,
-};
-
-static int exynos_irq_set_wake(struct irq_data *data, unsigned int state)
-{
-	const struct exynos_wkup_irq *wkup_irq;
-
-	if (!pm_data->wkup_irq)
-		return -ENOENT;
-	wkup_irq = pm_data->wkup_irq;
-
-	while (wkup_irq->mask) {
-		if (wkup_irq->hwirq == data->hwirq) {
-			if (!state)
-				exynos_irqwake_intmask |= wkup_irq->mask;
-			else
-				exynos_irqwake_intmask &= ~wkup_irq->mask;
-			return 0;
-		}
-		++wkup_irq;
-	}
-
-	return -ENOENT;
-}
-
 static inline void __iomem *exynos_boot_vector_addr(void)
 {
 	if (samsung_rev() == EXYNOS4210_REV_1_1)
@@ -147,12 +48,11 @@ static inline void __iomem *exynos_boot_vector_flag(void)
 }
 
 #define S5P_CHECK_AFTR  0xFCBA0D10
-#define S5P_CHECK_SLEEP 0x00000BAD
 
 /* For Cortex-A9 Diagnostic and Power control register */
 static unsigned int save_arm_register[2];
 
-static void exynos_cpu_save_register(void)
+void exynos_cpu_save_register(void)
 {
 	unsigned long tmp;
 
@@ -169,7 +69,7 @@ static void exynos_cpu_save_register(void)
 	save_arm_register[1] = tmp;
 }
 
-static void exynos_cpu_restore_register(void)
+void exynos_cpu_restore_register(void)
 {
 	unsigned long tmp;
 
@@ -188,7 +88,7 @@ static void exynos_cpu_restore_register(void)
 		      : "cc");
 }
 
-static void exynos_pm_central_suspend(void)
+void exynos_pm_central_suspend(void)
 {
 	unsigned long tmp;
 
@@ -202,7 +102,7 @@ static void exynos_pm_central_suspend(void)
 		       S5P_CENTRAL_SEQ_OPTION);
 }
 
-static int exynos_pm_central_resume(void)
+int exynos_pm_central_resume(void)
 {
 	unsigned long tmp;
 
@@ -275,231 +175,3 @@ void exynos_enter_aftr(void)
 
 	cpu_pm_exit();
 }
-
-static int exynos_cpu_do_idle(void)
-{
-	/* issue the standby signal into the pm unit. */
-	cpu_do_idle();
-
-	pr_info("Failed to suspend the system\n");
-	return 1; /* Aborting suspend */
-}
-
-static int exynos_cpu_suspend(unsigned long arg)
-{
-	flush_cache_all();
-	outer_flush_all();
-	return exynos_cpu_do_idle();
-}
-
-static void exynos_pm_set_wakeup_mask(void)
-{
-	/* Set wake-up mask registers */
-	pmu_raw_writel(exynos_get_eint_wake_mask(), S5P_EINT_WAKEUP_MASK);
-	pmu_raw_writel(exynos_irqwake_intmask & ~(1 << 31), S5P_WAKEUP_MASK);
-}
-
-static void exynos_pm_enter_sleep_mode(void)
-{
-	/* Set value of power down register for sleep mode */
-	exynos_sys_powerdown_conf(SYS_SLEEP);
-	pmu_raw_writel(S5P_CHECK_SLEEP, S5P_INFORM1);
-
-	/* ensure at least INFORM0 has the resume address */
-	pmu_raw_writel(virt_to_phys(exynos_cpu_resume), S5P_INFORM0);
-}
-
-static void exynos_pm_prepare(void)
-{
-	/* Set wake-up mask registers */
-	exynos_pm_set_wakeup_mask();
-
-	s3c_pm_do_save(exynos_core_save, ARRAY_SIZE(exynos_core_save));
-
-	 if (pm_data->extra_save)
-		s3c_pm_do_save(pm_data->extra_save,
-				pm_data->num_extra_save);
-
-	exynos_pm_enter_sleep_mode();
-}
-
-static int exynos_pm_suspend(void)
-{
-	exynos_pm_central_suspend();
-
-	if (read_cpuid_part() == ARM_CPU_PART_CORTEX_A9)
-		exynos_cpu_save_register();
-
-	return 0;
-}
-
-static void exynos_pm_release_retention(void)
-{
-	unsigned int i;
-
-	for (i = 0; (pm_data->release_ret_regs[i] != REG_TABLE_END); i++)
-		pmu_raw_writel(EXYNOS_WAKEUP_FROM_LOWPWR,
-				pm_data->release_ret_regs[i]);
-}
-
-static void exynos_pm_resume(void)
-{
-	u32 cpuid = read_cpuid_part();
-
-	if (exynos_pm_central_resume())
-		goto early_wakeup;
-
-	/* For release retention */
-	exynos_pm_release_retention();
-
-	if (pm_data->extra_save)
-		s3c_pm_do_restore_core(pm_data->extra_save,
-					pm_data->num_extra_save);
-
-	s3c_pm_do_restore_core(exynos_core_save, ARRAY_SIZE(exynos_core_save));
-
-	if (cpuid == ARM_CPU_PART_CORTEX_A9)
-		scu_enable(S5P_VA_SCU);
-
-	if (call_firmware_op(resume) == -ENOSYS
-	    && cpuid == ARM_CPU_PART_CORTEX_A9)
-		exynos_cpu_restore_register();
-
-early_wakeup:
-
-	/* Clear SLEEP mode set in INFORM1 */
-	pmu_raw_writel(0x0, S5P_INFORM1);
-}
-
-/*
- * Suspend Ops
- */
-
-static int exynos_suspend_enter(suspend_state_t state)
-{
-	int ret;
-
-	s3c_pm_debug_init();
-
-	S3C_PMDBG("%s: suspending the system...\n", __func__);
-
-	S3C_PMDBG("%s: wakeup masks: %08x,%08x\n", __func__,
-			exynos_irqwake_intmask, exynos_get_eint_wake_mask());
-
-	if (exynos_irqwake_intmask == -1U
-	    && exynos_get_eint_wake_mask() == -1U) {
-		pr_err("%s: No wake-up sources!\n", __func__);
-		pr_err("%s: Aborting sleep\n", __func__);
-		return -EINVAL;
-	}
-
-	s3c_pm_save_uarts();
-	if (pm_data->pm_prepare)
-		pm_data->pm_prepare();
-	flush_cache_all();
-	s3c_pm_check_store();
-
-	ret = call_firmware_op(suspend);
-	if (ret == -ENOSYS)
-		ret = cpu_suspend(0, pm_data->cpu_suspend);
-	if (ret)
-		return ret;
-
-	s3c_pm_restore_uarts();
-
-	S3C_PMDBG("%s: wakeup stat: %08x\n", __func__,
-			pmu_raw_readl(S5P_WAKEUP_STAT));
-
-	s3c_pm_check_restore();
-
-	S3C_PMDBG("%s: resuming the system...\n", __func__);
-
-	return 0;
-}
-
-static int exynos_suspend_prepare(void)
-{
-	s3c_pm_check_prepare();
-
-	return 0;
-}
-
-static void exynos_suspend_finish(void)
-{
-	s3c_pm_check_cleanup();
-}
-
-static const struct platform_suspend_ops exynos_suspend_ops = {
-	.enter		= exynos_suspend_enter,
-	.prepare	= exynos_suspend_prepare,
-	.finish		= exynos_suspend_finish,
-	.valid		= suspend_valid_only_mem,
-};
-
-static const struct exynos_pm_data exynos4_pm_data = {
-	.wkup_irq	= exynos4_wkup_irq,
-	.wake_disable_mask = ((0xFF << 8) | (0x1F << 1)),
-	.release_ret_regs = exynos_release_ret_regs,
-	.pm_suspend	= exynos_pm_suspend,
-	.pm_resume	= exynos_pm_resume,
-	.pm_prepare	= exynos_pm_prepare,
-	.cpu_suspend	= exynos_cpu_suspend,
-};
-
-static const struct exynos_pm_data exynos5250_pm_data = {
-	.wkup_irq	= exynos5250_wkup_irq,
-	.wake_disable_mask = ((0xFF << 8) | (0x1F << 1)),
-	.release_ret_regs = exynos_release_ret_regs,
-	.extra_save	= exynos5_sys_save,
-	.num_extra_save	= ARRAY_SIZE(exynos5_sys_save),
-	.pm_suspend	= exynos_pm_suspend,
-	.pm_resume	= exynos_pm_resume,
-	.pm_prepare	= exynos_pm_prepare,
-	.cpu_suspend	= exynos_cpu_suspend,
-};
-
-static struct of_device_id exynos_pmu_of_device_ids[] = {
-	{
-		.compatible = "samsung,exynos4210-pmu",
-		.data = &exynos4_pm_data,
-	}, {
-		.compatible = "samsung,exynos4212-pmu",
-		.data = &exynos4_pm_data,
-	}, {
-		.compatible = "samsung,exynos4412-pmu",
-		.data = &exynos4_pm_data,
-	}, {
-		.compatible = "samsung,exynos5250-pmu",
-		.data = &exynos5250_pm_data,
-	},
-	{ /*sentinel*/ },
-};
-
-static struct syscore_ops exynos_pm_syscore_ops;
-
-void __init exynos_pm_init(void)
-{
-	const struct of_device_id *match;
-	u32 tmp;
-
-	of_find_matching_node_and_match(NULL, exynos_pmu_of_device_ids, &match);
-	if (!match) {
-		pr_err("Failed to find PMU node\n");
-		return;
-	}
-	pm_data = (struct exynos_pm_data *) match->data;
-
-	/* Platform-specific GIC callback */
-	gic_arch_extn.irq_set_wake = exynos_irq_set_wake;
-
-	/* All wakeup disable */
-	tmp = pmu_raw_readl(S5P_WAKEUP_MASK);
-	tmp |= pm_data->wake_disable_mask;
-	pmu_raw_writel(tmp, S5P_WAKEUP_MASK);
-
-	exynos_pm_syscore_ops.suspend	= pm_data->pm_suspend;
-	exynos_pm_syscore_ops.resume	= pm_data->pm_resume;
-
-	register_syscore_ops(&exynos_pm_syscore_ops);
-	suspend_set_ops(&exynos_suspend_ops);
-}
diff --git a/arch/arm/mach-exynos/suspend.c b/arch/arm/mach-exynos/suspend.c
new file mode 100644
index 0000000..f5d9773
--- /dev/null
+++ b/arch/arm/mach-exynos/suspend.c
@@ -0,0 +1,356 @@
+/*
+ * Copyright (c) 2011-2014 Samsung Electronics Co., Ltd.
+ *		http://www.samsung.com
+ *
+ * EXYNOS - Suspend support
+ *
+ * Based on arch/arm/mach-s3c2410/pm.c
+ * Copyright (c) 2006 Simtec Electronics
+ *	Ben Dooks <ben@simtec.co.uk>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/init.h>
+#include <linux/suspend.h>
+#include <linux/syscore_ops.h>
+#include <linux/cpu_pm.h>
+#include <linux/io.h>
+#include <linux/irqchip/arm-gic.h>
+#include <linux/err.h>
+
+#include <asm/cacheflush.h>
+#include <asm/hardware/cache-l2x0.h>
+#include <asm/firmware.h>
+#include <asm/smp_scu.h>
+#include <asm/suspend.h>
+
+#include <plat/pm-common.h>
+#include <plat/regs-srom.h>
+
+#include "common.h"
+#include "regs-pmu.h"
+#include "regs-sys.h"
+
+#define S5P_CHECK_SLEEP 0x00000BAD
+
+#define REG_TABLE_END (-1U)
+
+/**
+ * struct exynos_wkup_irq - Exynos GIC to PMU IRQ mapping
+ * @hwirq: Hardware IRQ signal of the GIC
+ * @mask: Mask in PMU wake-up mask register
+ */
+struct exynos_wkup_irq {
+	unsigned int hwirq;
+	u32 mask;
+};
+
+static struct sleep_save exynos5_sys_save[] = {
+	SAVE_ITEM(EXYNOS5_SYS_I2C_CFG),
+};
+
+static struct sleep_save exynos_core_save[] = {
+	/* SROM side */
+	SAVE_ITEM(S5P_SROM_BW),
+	SAVE_ITEM(S5P_SROM_BC0),
+	SAVE_ITEM(S5P_SROM_BC1),
+	SAVE_ITEM(S5P_SROM_BC2),
+	SAVE_ITEM(S5P_SROM_BC3),
+};
+
+struct exynos_pm_data {
+	const struct exynos_wkup_irq *wkup_irq;
+	struct sleep_save *extra_save;
+	int num_extra_save;
+	unsigned int wake_disable_mask;
+	unsigned int *release_ret_regs;
+
+	void (*pm_prepare)(void);
+	void (*pm_resume)(void);
+	int (*pm_suspend)(void);
+	int (*cpu_suspend)(unsigned long);
+};
+
+struct exynos_pm_data *pm_data;
+
+/*
+ * GIC wake-up support
+ */
+
+static u32 exynos_irqwake_intmask = 0xffffffff;
+
+static const struct exynos_wkup_irq exynos4_wkup_irq[] = {
+	{ 76, BIT(1) }, /* RTC alarm */
+	{ 77, BIT(2) }, /* RTC tick */
+	{ /* sentinel */ },
+};
+
+static const struct exynos_wkup_irq exynos5250_wkup_irq[] = {
+	{ 75, BIT(1) }, /* RTC alarm */
+	{ 76, BIT(2) }, /* RTC tick */
+	{ /* sentinel */ },
+};
+
+unsigned int exynos_release_ret_regs[] = {
+	S5P_PAD_RET_MAUDIO_OPTION,
+	S5P_PAD_RET_GPIO_OPTION,
+	S5P_PAD_RET_UART_OPTION,
+	S5P_PAD_RET_MMCA_OPTION,
+	S5P_PAD_RET_MMCB_OPTION,
+	S5P_PAD_RET_EBIA_OPTION,
+	S5P_PAD_RET_EBIB_OPTION,
+	REG_TABLE_END,
+};
+
+static int exynos_irq_set_wake(struct irq_data *data, unsigned int state)
+{
+	const struct exynos_wkup_irq *wkup_irq;
+
+	if (!pm_data->wkup_irq)
+		return -ENOENT;
+	wkup_irq = pm_data->wkup_irq;
+
+	while (wkup_irq->mask) {
+		if (wkup_irq->hwirq == data->hwirq) {
+			if (!state)
+				exynos_irqwake_intmask |= wkup_irq->mask;
+			else
+				exynos_irqwake_intmask &= ~wkup_irq->mask;
+			return 0;
+		}
+		++wkup_irq;
+	}
+
+	return -ENOENT;
+}
+
+static int exynos_cpu_do_idle(void)
+{
+	/* issue the standby signal into the pm unit. */
+	cpu_do_idle();
+
+	pr_info("Failed to suspend the system\n");
+	return 1; /* Aborting suspend */
+}
+
+static int exynos_cpu_suspend(unsigned long arg)
+{
+	flush_cache_all();
+	outer_flush_all();
+	return exynos_cpu_do_idle();
+}
+
+static void exynos_pm_set_wakeup_mask(void)
+{
+	/* Set wake-up mask registers */
+	pmu_raw_writel(exynos_get_eint_wake_mask(), S5P_EINT_WAKEUP_MASK);
+	pmu_raw_writel(exynos_irqwake_intmask & ~(1 << 31), S5P_WAKEUP_MASK);
+}
+
+static void exynos_pm_enter_sleep_mode(void)
+{
+	/* Set value of power down register for sleep mode */
+	exynos_sys_powerdown_conf(SYS_SLEEP);
+	pmu_raw_writel(S5P_CHECK_SLEEP, S5P_INFORM1);
+
+	/* ensure at least INFORM0 has the resume address */
+	pmu_raw_writel(virt_to_phys(exynos_cpu_resume), S5P_INFORM0);
+}
+
+static void exynos_pm_prepare(void)
+{
+	/* Set wake-up mask registers */
+	exynos_pm_set_wakeup_mask();
+
+	s3c_pm_do_save(exynos_core_save, ARRAY_SIZE(exynos_core_save));
+
+	 if (pm_data->extra_save)
+		s3c_pm_do_save(pm_data->extra_save,
+				pm_data->num_extra_save);
+
+	exynos_pm_enter_sleep_mode();
+}
+
+static int exynos_pm_suspend(void)
+{
+	exynos_pm_central_suspend();
+
+	if (read_cpuid_part() == ARM_CPU_PART_CORTEX_A9)
+		exynos_cpu_save_register();
+
+	return 0;
+}
+
+static void exynos_pm_release_retention(void)
+{
+	unsigned int i;
+
+	for (i = 0; (pm_data->release_ret_regs[i] != REG_TABLE_END); i++)
+		pmu_raw_writel(EXYNOS_WAKEUP_FROM_LOWPWR,
+				pm_data->release_ret_regs[i]);
+}
+
+static void exynos_pm_resume(void)
+{
+	u32 cpuid = read_cpuid_part();
+
+	if (exynos_pm_central_resume())
+		goto early_wakeup;
+
+	/* For release retention */
+	exynos_pm_release_retention();
+
+	if (pm_data->extra_save)
+		s3c_pm_do_restore_core(pm_data->extra_save,
+					pm_data->num_extra_save);
+
+	s3c_pm_do_restore_core(exynos_core_save, ARRAY_SIZE(exynos_core_save));
+
+	if (cpuid == ARM_CPU_PART_CORTEX_A9)
+		scu_enable(S5P_VA_SCU);
+
+	if (call_firmware_op(resume) == -ENOSYS
+	    && cpuid == ARM_CPU_PART_CORTEX_A9)
+		exynos_cpu_restore_register();
+
+early_wakeup:
+
+	/* Clear SLEEP mode set in INFORM1 */
+	pmu_raw_writel(0x0, S5P_INFORM1);
+}
+
+/*
+ * Suspend Ops
+ */
+
+static int exynos_suspend_enter(suspend_state_t state)
+{
+	int ret;
+
+	s3c_pm_debug_init();
+
+	S3C_PMDBG("%s: suspending the system...\n", __func__);
+
+	S3C_PMDBG("%s: wakeup masks: %08x,%08x\n", __func__,
+			exynos_irqwake_intmask, exynos_get_eint_wake_mask());
+
+	if (exynos_irqwake_intmask == -1U
+	    && exynos_get_eint_wake_mask() == -1U) {
+		pr_err("%s: No wake-up sources!\n", __func__);
+		pr_err("%s: Aborting sleep\n", __func__);
+		return -EINVAL;
+	}
+
+	s3c_pm_save_uarts();
+	if (pm_data->pm_prepare)
+		pm_data->pm_prepare();
+	flush_cache_all();
+	s3c_pm_check_store();
+
+	ret = call_firmware_op(suspend);
+	if (ret == -ENOSYS)
+		ret = cpu_suspend(0, pm_data->cpu_suspend);
+	if (ret)
+		return ret;
+
+	s3c_pm_restore_uarts();
+
+	S3C_PMDBG("%s: wakeup stat: %08x\n", __func__,
+			pmu_raw_readl(S5P_WAKEUP_STAT));
+
+	s3c_pm_check_restore();
+
+	S3C_PMDBG("%s: resuming the system...\n", __func__);
+
+	return 0;
+}
+
+static int exynos_suspend_prepare(void)
+{
+	s3c_pm_check_prepare();
+
+	return 0;
+}
+
+static void exynos_suspend_finish(void)
+{
+	s3c_pm_check_cleanup();
+}
+
+static const struct platform_suspend_ops exynos_suspend_ops = {
+	.enter		= exynos_suspend_enter,
+	.prepare	= exynos_suspend_prepare,
+	.finish		= exynos_suspend_finish,
+	.valid		= suspend_valid_only_mem,
+};
+
+static const struct exynos_pm_data exynos4_pm_data = {
+	.wkup_irq	= exynos4_wkup_irq,
+	.wake_disable_mask = ((0xFF << 8) | (0x1F << 1)),
+	.release_ret_regs = exynos_release_ret_regs,
+	.pm_suspend	= exynos_pm_suspend,
+	.pm_resume	= exynos_pm_resume,
+	.pm_prepare	= exynos_pm_prepare,
+	.cpu_suspend	= exynos_cpu_suspend,
+};
+
+static const struct exynos_pm_data exynos5250_pm_data = {
+	.wkup_irq	= exynos5250_wkup_irq,
+	.wake_disable_mask = ((0xFF << 8) | (0x1F << 1)),
+	.release_ret_regs = exynos_release_ret_regs,
+	.extra_save	= exynos5_sys_save,
+	.num_extra_save	= ARRAY_SIZE(exynos5_sys_save),
+	.pm_suspend	= exynos_pm_suspend,
+	.pm_resume	= exynos_pm_resume,
+	.pm_prepare	= exynos_pm_prepare,
+	.cpu_suspend	= exynos_cpu_suspend,
+};
+
+static struct of_device_id exynos_pmu_of_device_ids[] = {
+	{
+		.compatible = "samsung,exynos4210-pmu",
+		.data = &exynos4_pm_data,
+	}, {
+		.compatible = "samsung,exynos4212-pmu",
+		.data = &exynos4_pm_data,
+	}, {
+		.compatible = "samsung,exynos4412-pmu",
+		.data = &exynos4_pm_data,
+	}, {
+		.compatible = "samsung,exynos5250-pmu",
+		.data = &exynos5250_pm_data,
+	},
+	{ /*sentinel*/ },
+};
+
+static struct syscore_ops exynos_pm_syscore_ops;
+
+void __init exynos_pm_init(void)
+{
+	const struct of_device_id *match;
+	u32 tmp;
+
+	of_find_matching_node_and_match(NULL, exynos_pmu_of_device_ids, &match);
+	if (!match) {
+		pr_err("Failed to find PMU node\n");
+		return;
+	}
+	pm_data = (struct exynos_pm_data *) match->data;
+
+	/* Platform-specific GIC callback */
+	gic_arch_extn.irq_set_wake = exynos_irq_set_wake;
+
+	/* All wakeup disable */
+	tmp = pmu_raw_readl(S5P_WAKEUP_MASK);
+	tmp |= pm_data->wake_disable_mask;
+	pmu_raw_writel(tmp, S5P_WAKEUP_MASK);
+
+	exynos_pm_syscore_ops.suspend	= pm_data->pm_suspend;
+	exynos_pm_syscore_ops.resume	= pm_data->pm_resume;
+
+	register_syscore_ops(&exynos_pm_syscore_ops);
+	suspend_set_ops(&exynos_suspend_ops);
+}
diff --git a/arch/arm/plat-samsung/Makefile b/arch/arm/plat-samsung/Makefile
index 5fe1750..4075f01 100644
--- a/arch/arm/plat-samsung/Makefile
+++ b/arch/arm/plat-samsung/Makefile
@@ -40,6 +40,7 @@ obj-$(CONFIG_SAMSUNG_DMADEV)	+= dma-ops.o
 # PM support
 
 obj-$(CONFIG_PM_SLEEP)		+= pm-common.o
+obj-$(CONFIG_EXYNOS_CPU_SUSPEND) += pm-common.o
 obj-$(CONFIG_SAMSUNG_PM)	+= pm.o
 obj-$(CONFIG_SAMSUNG_PM_GPIO)	+= pm-gpio.o
 obj-$(CONFIG_SAMSUNG_PM_CHECK)	+= pm-check.o
-- 
1.8.2.3

