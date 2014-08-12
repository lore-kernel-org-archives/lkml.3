Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753524AbaHLPNA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2014 11:13:00 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:62717 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753141AbaHLPM6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2014 11:12:58 -0400
X-AuditID: cbfee61b-f79f86d00000144c-3d-53ea2ef73fcc
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Kukjin Kim <kgene.kim@samsung.com>
Cc: Daniel Lezcano <daniel.lezcano@linaro.org>,
        Tomasz Figa <t.figa@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Sachin Kamat <sachin.kamat@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Olof Johansson <olof@lixom.net>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        b.zolnierkie@samsung.com
Subject: [PATCH v2 3/3] ARM: EXYNOS: Fix build with PM_SLEEP=n and
 ARM_EXYNOS_CPUIDLE=y
Date: Tue, 12 Aug 2014 17:11:57 +0200
Message-id: <1407856317-2457-4-git-send-email-b.zolnierkie@samsung.com>
X-Mailer: git-send-email 1.7.10.4
In-reply-to: <1407856317-2457-1-git-send-email-b.zolnierkie@samsung.com>
References: <1407856317-2457-1-git-send-email-b.zolnierkie@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrGLMWRmVeSWpSXmKPExsVy+t9jAd0feq+CDeY+Y7fYOGM9q8W8z7IW
	r18YWvQuuMpmcbbpDbvFpsfXWC0u75rDZjHj/D4mi7VH7rJbnLr+mc1i84eXbBZXLp1is1g/
	4zWLA69HS3MPm8eda3vYPDYvqfe4cqKJ1aNvyypGj8+b5ALYorhsUlJzMstSi/TtErgyHh9b
	w1rQNpmx4tG9+UwNjDequhg5OSQETCTOTG5kgbDFJC7cW8/WxcjFISSwiFGi53QPO4TTxSTx
	eNJ2sCo2ASuJie2rGEFsEQE1iZ7FWxlBipgF7jBLvNq7F6xIWCBSYvPsb8wgNouAqsSvQ9vB
	GngF3CXebt7DCrFOUaL72QQ2EJtTwEPi/eR3YPVCQDVd+44yT2DkXcDIsIpRNLUguaA4KT3X
	SK84Mbe4NC9dLzk/dxMjODSfSe9gXNVgcYhRgINRiYf3Av+rYCHWxLLiytxDjBIczEoivIK3
	XwYL8aYkVlalFuXHF5XmpBYfYpTmYFES5z3Yah0oJJCeWJKanZpakFoEk2Xi4JRqYKxluC/D
	1H1wvciD/Jnnt+a5+z629GfzO5wW1GYnmHbsas3FoI0Pq91TJ6b6LWT+a/T0cK7G7YP6HW+6
	TE6lSMU7nDEONbo4zbi1V9TwiOFXS53EHpedZ79HHzhTUhP2P8VWqrzkShH/H1U9zb0CJ/Lb
	Txv/3GQ1T14sdpPMk4Zfr3Zeqxa4pcRSnJFoqMVcVJwIABtjPCxJAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix building of exynos_defconfig with CONFIG_PM_SLEEP disabled and
CONFIG_ARM_EXYNOS_CPUIDLE enabled by:

* adding EXYNOS_CPU_SUSPEND config option
* building pm.o and sleep.o if EXYNOS_CPU_SUSPEND is enabled
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
 arch/arm/mach-exynos/Makefile  |   3 +-
 arch/arm/mach-exynos/common.h  |   4 +
 arch/arm/mach-exynos/pm.c      | 262 +-------------------------------------
 arch/arm/mach-exynos/suspend.c | 279 +++++++++++++++++++++++++++++++++++++++++
 arch/arm/plat-samsung/Makefile |   1 +
 6 files changed, 296 insertions(+), 258 deletions(-)
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
index 788f26d..b78980f 100644
--- a/arch/arm/mach-exynos/Makefile
+++ b/arch/arm/mach-exynos/Makefile
@@ -16,7 +16,8 @@ obj-				:=
 
 obj-$(CONFIG_ARCH_EXYNOS)	+= exynos.o pmu.o exynos-smc.o firmware.o
 
-obj-$(CONFIG_PM_SLEEP)		+= pm.o sleep.o
+obj-$(CONFIG_EXYNOS_CPU_SUSPEND) += pm.o sleep.o
+obj-$(CONFIG_PM_SLEEP)		+= suspend.o
 obj-$(CONFIG_PM_GENERIC_DOMAINS) += pm_domains.o
 
 obj-$(CONFIG_SMP)		+= platsmp.o headsmp.o
diff --git a/arch/arm/mach-exynos/common.h b/arch/arm/mach-exynos/common.h
index 47b904b..b00456a 100644
--- a/arch/arm/mach-exynos/common.h
+++ b/arch/arm/mach-exynos/common.h
@@ -155,6 +155,10 @@ extern int  exynos_cpu_power_state(int cpu);
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
index 7bdb6d4..be82cf5 100644
--- a/arch/arm/mach-exynos/pm.c
+++ b/arch/arm/mach-exynos/pm.c
@@ -1,5 +1,5 @@
 /*
- * Copyright (c) 2011-2012 Samsung Electronics Co., Ltd.
+ * Copyright (c) 2011-2014 Samsung Electronics Co., Ltd.
  *		http://www.samsung.com
  *
  * EXYNOS - Power Management support
@@ -15,91 +15,19 @@
 
 #include <linux/init.h>
 #include <linux/suspend.h>
-#include <linux/syscore_ops.h>
 #include <linux/cpu_pm.h>
 #include <linux/io.h>
-#include <linux/irqchip/arm-gic.h>
 #include <linux/err.h>
-#include <linux/clk.h>
 
-#include <asm/cacheflush.h>
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
-static int exynos_irq_set_wake(struct irq_data *data, unsigned int state)
-{
-	const struct exynos_wkup_irq *wkup_irq;
-
-	if (soc_is_exynos5250())
-		wkup_irq = exynos5250_wkup_irq;
-	else
-		wkup_irq = exynos4_wkup_irq;
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
 #define EXYNOS_BOOT_VECTOR_ADDR	(samsung_rev() == EXYNOS4210_REV_1_1 ? \
 			pmu_base_addr + S5P_INFORM7 : \
 			(samsung_rev() == EXYNOS4210_REV_1_0 ? \
@@ -112,12 +40,11 @@ static int exynos_irq_set_wake(struct irq_data *data, unsigned int state)
 			pmu_base_addr + S5P_INFORM1))
 
 #define S5P_CHECK_AFTR  0xFCBA0D10
-#define S5P_CHECK_SLEEP 0x00000BAD
 
 /* For Cortex-A9 Diagnostic and Power control register */
 static unsigned int save_arm_register[2];
 
-static void exynos_cpu_save_register(void)
+void exynos_cpu_save_register(void)
 {
 	unsigned long tmp;
 
@@ -134,7 +61,7 @@ static void exynos_cpu_save_register(void)
 	save_arm_register[1] = tmp;
 }
 
-static void exynos_cpu_restore_register(void)
+void exynos_cpu_restore_register(void)
 {
 	unsigned long tmp;
 
@@ -153,7 +80,7 @@ static void exynos_cpu_restore_register(void)
 		      : "cc");
 }
 
-static void exynos_pm_central_suspend(void)
+void exynos_pm_central_suspend(void)
 {
 	unsigned long tmp;
 
@@ -163,7 +90,7 @@ static void exynos_pm_central_suspend(void)
 	pmu_raw_writel(tmp, S5P_CENTRAL_SEQ_CONFIGURATION);
 }
 
-static int exynos_pm_central_resume(void)
+int exynos_pm_central_resume(void)
 {
 	unsigned long tmp;
 
@@ -228,182 +155,3 @@ void exynos_enter_aftr(void)
 
 	cpu_pm_exit();
 }
-
-static int exynos_cpu_suspend(unsigned long arg)
-{
-#ifdef CONFIG_CACHE_L2X0
-	outer_flush_all();
-#endif
-
-	if (soc_is_exynos5250())
-		flush_cache_all();
-
-	/* issue the standby signal into the pm unit. */
-	cpu_do_idle();
-
-	pr_info("Failed to suspend the system\n");
-	return 1; /* Aborting suspend */
-}
-
-static void exynos_pm_prepare(void)
-{
-	unsigned int tmp;
-
-	/* Set wake-up mask registers */
-	pmu_raw_writel(exynos_get_eint_wake_mask(), S5P_EINT_WAKEUP_MASK);
-	pmu_raw_writel(exynos_irqwake_intmask & ~(1 << 31), S5P_WAKEUP_MASK);
-
-	s3c_pm_do_save(exynos_core_save, ARRAY_SIZE(exynos_core_save));
-
-	if (soc_is_exynos5250()) {
-		s3c_pm_do_save(exynos5_sys_save, ARRAY_SIZE(exynos5_sys_save));
-		/* Disable USE_RETENTION of JPEG_MEM_OPTION */
-		tmp = pmu_raw_readl(EXYNOS5_JPEG_MEM_OPTION);
-		tmp &= ~EXYNOS5_OPTION_USE_RETENTION;
-		pmu_raw_writel(tmp, EXYNOS5_JPEG_MEM_OPTION);
-	}
-
-	/* Set value of power down register for sleep mode */
-
-	exynos_sys_powerdown_conf(SYS_SLEEP);
-	pmu_raw_writel(S5P_CHECK_SLEEP, S5P_INFORM1);
-
-	/* ensure at least INFORM0 has the resume address */
-
-	pmu_raw_writel(virt_to_phys(exynos_cpu_resume), S5P_INFORM0);
-}
-
-static int exynos_pm_suspend(void)
-{
-	unsigned long tmp;
-
-	exynos_pm_central_suspend();
-
-	/* Setting SEQ_OPTION register */
-
-	tmp = (S5P_USE_STANDBY_WFI0 | S5P_USE_STANDBY_WFE0);
-	pmu_raw_writel(tmp, S5P_CENTRAL_SEQ_OPTION);
-
-	if (read_cpuid_part() == ARM_CPU_PART_CORTEX_A9)
-		exynos_cpu_save_register();
-
-	return 0;
-}
-
-static void exynos_pm_resume(void)
-{
-	if (exynos_pm_central_resume())
-		goto early_wakeup;
-
-	if (read_cpuid_part() == ARM_CPU_PART_CORTEX_A9)
-		exynos_cpu_restore_register();
-
-	/* For release retention */
-
-	pmu_raw_writel((1 << 28), S5P_PAD_RET_MAUDIO_OPTION);
-	pmu_raw_writel((1 << 28), S5P_PAD_RET_GPIO_OPTION);
-	pmu_raw_writel((1 << 28), S5P_PAD_RET_UART_OPTION);
-	pmu_raw_writel((1 << 28), S5P_PAD_RET_MMCA_OPTION);
-	pmu_raw_writel((1 << 28), S5P_PAD_RET_MMCB_OPTION);
-	pmu_raw_writel((1 << 28), S5P_PAD_RET_EBIA_OPTION);
-	pmu_raw_writel((1 << 28), S5P_PAD_RET_EBIB_OPTION);
-
-	if (soc_is_exynos5250())
-		s3c_pm_do_restore(exynos5_sys_save,
-			ARRAY_SIZE(exynos5_sys_save));
-
-	s3c_pm_do_restore_core(exynos_core_save, ARRAY_SIZE(exynos_core_save));
-
-	if (read_cpuid_part() == ARM_CPU_PART_CORTEX_A9)
-		scu_enable(S5P_VA_SCU);
-
-early_wakeup:
-
-	/* Clear SLEEP mode set in INFORM1 */
-	pmu_raw_writel(0x0, S5P_INFORM1);
-
-	return;
-}
-
-static struct syscore_ops exynos_pm_syscore_ops = {
-	.suspend	= exynos_pm_suspend,
-	.resume		= exynos_pm_resume,
-};
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
-	exynos_pm_prepare();
-	flush_cache_all();
-	s3c_pm_check_store();
-
-	ret = cpu_suspend(0, exynos_cpu_suspend);
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
-	.valid		= suspend_valid_only_deep,
-};
-
-void __init exynos_pm_init(void)
-{
-	u32 tmp;
-
-	/* Platform-specific GIC callback */
-	gic_arch_extn.irq_set_wake = exynos_irq_set_wake;
-
-	/* All wakeup disable */
-	tmp = pmu_raw_readl(S5P_WAKEUP_MASK);
-	tmp |= ((0xFF << 8) | (0x1F << 1));
-	pmu_raw_writel(tmp, S5P_WAKEUP_MASK);
-
-	register_syscore_ops(&exynos_pm_syscore_ops);
-	suspend_set_ops(&exynos_suspend_ops);
-}
diff --git a/arch/arm/mach-exynos/suspend.c b/arch/arm/mach-exynos/suspend.c
new file mode 100644
index 0000000..34a0723
--- /dev/null
+++ b/arch/arm/mach-exynos/suspend.c
@@ -0,0 +1,279 @@
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
+static int exynos_irq_set_wake(struct irq_data *data, unsigned int state)
+{
+	const struct exynos_wkup_irq *wkup_irq;
+
+	if (soc_is_exynos5250())
+		wkup_irq = exynos5250_wkup_irq;
+	else
+		wkup_irq = exynos4_wkup_irq;
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
+static int exynos_cpu_suspend(unsigned long arg)
+{
+#ifdef CONFIG_CACHE_L2X0
+	outer_flush_all();
+#endif
+
+	if (soc_is_exynos5250())
+		flush_cache_all();
+
+	/* issue the standby signal into the pm unit. */
+	cpu_do_idle();
+
+	pr_info("Failed to suspend the system\n");
+	return 1; /* Aborting suspend */
+}
+
+static void exynos_pm_prepare(void)
+{
+	unsigned int tmp;
+
+	/* Set wake-up mask registers */
+	pmu_raw_writel(exynos_get_eint_wake_mask(), S5P_EINT_WAKEUP_MASK);
+	pmu_raw_writel(exynos_irqwake_intmask & ~(1 << 31), S5P_WAKEUP_MASK);
+
+	s3c_pm_do_save(exynos_core_save, ARRAY_SIZE(exynos_core_save));
+
+	if (soc_is_exynos5250()) {
+		s3c_pm_do_save(exynos5_sys_save, ARRAY_SIZE(exynos5_sys_save));
+		/* Disable USE_RETENTION of JPEG_MEM_OPTION */
+		tmp = pmu_raw_readl(EXYNOS5_JPEG_MEM_OPTION);
+		tmp &= ~EXYNOS5_OPTION_USE_RETENTION;
+		pmu_raw_writel(tmp, EXYNOS5_JPEG_MEM_OPTION);
+	}
+
+	/* Set value of power down register for sleep mode */
+
+	exynos_sys_powerdown_conf(SYS_SLEEP);
+	pmu_raw_writel(S5P_CHECK_SLEEP, S5P_INFORM1);
+
+	/* ensure at least INFORM0 has the resume address */
+
+	pmu_raw_writel(virt_to_phys(exynos_cpu_resume), S5P_INFORM0);
+}
+
+static int exynos_pm_suspend(void)
+{
+	unsigned long tmp;
+
+	exynos_pm_central_suspend();
+
+	/* Setting SEQ_OPTION register */
+
+	tmp = (S5P_USE_STANDBY_WFI0 | S5P_USE_STANDBY_WFE0);
+	pmu_raw_writel(tmp, S5P_CENTRAL_SEQ_OPTION);
+
+	if (read_cpuid_part() == ARM_CPU_PART_CORTEX_A9)
+		exynos_cpu_save_register();
+
+	return 0;
+}
+
+static void exynos_pm_resume(void)
+{
+	if (exynos_pm_central_resume())
+		goto early_wakeup;
+
+	if (read_cpuid_part() == ARM_CPU_PART_CORTEX_A9)
+		exynos_cpu_restore_register();
+
+	/* For release retention */
+
+	pmu_raw_writel((1 << 28), S5P_PAD_RET_MAUDIO_OPTION);
+	pmu_raw_writel((1 << 28), S5P_PAD_RET_GPIO_OPTION);
+	pmu_raw_writel((1 << 28), S5P_PAD_RET_UART_OPTION);
+	pmu_raw_writel((1 << 28), S5P_PAD_RET_MMCA_OPTION);
+	pmu_raw_writel((1 << 28), S5P_PAD_RET_MMCB_OPTION);
+	pmu_raw_writel((1 << 28), S5P_PAD_RET_EBIA_OPTION);
+	pmu_raw_writel((1 << 28), S5P_PAD_RET_EBIB_OPTION);
+
+	if (soc_is_exynos5250())
+		s3c_pm_do_restore(exynos5_sys_save,
+			ARRAY_SIZE(exynos5_sys_save));
+
+	s3c_pm_do_restore_core(exynos_core_save, ARRAY_SIZE(exynos_core_save));
+
+	if (read_cpuid_part() == ARM_CPU_PART_CORTEX_A9)
+		scu_enable(S5P_VA_SCU);
+
+early_wakeup:
+
+	/* Clear SLEEP mode set in INFORM1 */
+	pmu_raw_writel(0x0, S5P_INFORM1);
+
+	return;
+}
+
+static struct syscore_ops exynos_pm_syscore_ops = {
+	.suspend	= exynos_pm_suspend,
+	.resume		= exynos_pm_resume,
+};
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
+	exynos_pm_prepare();
+	flush_cache_all();
+	s3c_pm_check_store();
+
+	ret = cpu_suspend(0, exynos_cpu_suspend);
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
+	.valid		= suspend_valid_only_deep,
+};
+
+void __init exynos_pm_init(void)
+{
+	u32 tmp;
+
+	/* Platform-specific GIC callback */
+	gic_arch_extn.irq_set_wake = exynos_irq_set_wake;
+
+	/* All wakeup disable */
+	tmp = pmu_raw_readl(S5P_WAKEUP_MASK);
+	tmp |= ((0xFF << 8) | (0x1F << 1));
+	pmu_raw_writel(tmp, S5P_WAKEUP_MASK);
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

