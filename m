Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756034AbaGNOo5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 10:44:57 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:16158 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754847AbaGNOob (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 10:44:31 -0400
X-AuditID: cbfee61a-f79e46d00000134f-08-53c3ecccb21c
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Kukjin Kim <kgene.kim@samsung.com>
Cc: Daniel Lezcano <daniel.lezcano@linaro.org>,
        Tomasz Figa <t.figa@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Sachin Kamat <sachin.kamat@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Olof Johansson <olof@lixom.net>, linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        b.zolnierkie@samsung.com
Subject: [PATCH 2/2] ARM: EXYNOS: Fix build with PM_SLEEP=n and
 ARM_EXYNOS_CPUIDLE=y
Date: Mon, 14 Jul 2014 16:44:00 +0200
Message-id: <1405349040-5265-3-git-send-email-b.zolnierkie@samsung.com>
X-Mailer: git-send-email 1.7.10.4
In-reply-to: <1405349040-5265-1-git-send-email-b.zolnierkie@samsung.com>
References: <1405349040-5265-1-git-send-email-b.zolnierkie@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrBLMWRmVeSWpSXmKPExsVy+t9jAd0zbw4HG/R3GVpsnLGe1WLeZ1mL
	1y8MLXoXXGWzONv0ht1i0+NrrBaXd81hs5hxfh+Txdojd9ktTl3/zGZx5dIpNov1M16zOPB4
	3Lm2h81j85J6jysnmlg9+rasYvT4vEkugDWKyyYlNSezLLVI3y6BK+PqlJnMBaeKK2Yfns3Y
	wPg0vouRg0NCwETi0GymLkZOIFNM4sK99WxdjFwcQgKLGCW2PDnICOF0MUlcmvyeDaSKTcBK
	YmL7KkYQW0RATaJn8VawImaBdcwSO7f9BysSFgiT6H16DMxmEVCV6Jt8jBlkG6+Au8T6N/oQ
	2xQlup9NACvhFPCQ6Or8B1YiBFRycZn8BEbeBYwMqxhFUwuSC4qT0nMN9YoTc4tL89L1kvNz
	NzGCw++Z1A7GlQ0WhxgFOBiVeHgzOA4HC7EmlhVX5h5ilOBgVhLh9bgBFOJNSaysSi3Kjy8q
	zUktPsQozcGiJM57oNU6UEggPbEkNTs1tSC1CCbLxMEp1cBo+8BYrHVd+TKRDVsd/OqKdCZx
	n8wQiCzdZXlVO6z8vM6F3WWXBB5x3uf+y7PJ5/u270/604yPNqzKuNGy4OWuTy+6Ohg+er+4
	qKDYI6odHWqWOXHvKWPBWYELQr9EHHvheFU85+iv3UunvVzCWds+z8Mrf+0WBQYXh/1S7ieb
	/PsEK25NMT6sxFKckWioxVxUnAgAAF50wTsCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix building of exynos_defconfig with CONFIG_PM_SLEEP disabled and
CONFIG_ARM_EXYNOS_CPUIDLE enabled by:

* adding EXYNOS_CPU_SUSPEND config option
* building pm.o and sleep.o if EXYNOS_CPU_SUSPEND is enabled
* moving suspend specific code from pm.c to suspend.c
* enabling pm-common.o build also for EXYNOS_CPU_SUSPEND option

The build error messages:
drivers/built-in.o: In function `exynos_enter_core0_aftr':
/home/bzolnier/linux/drivers/cpuidle/cpuidle-exynos.c:36: undefined reference to `cpu_suspend'
arch/arm/mach-exynos/built-in.o:(.data+0x74): undefined reference to `exynos_enter_aftr'
make: *** [vmlinux] Error 1

Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 arch/arm/mach-exynos/Kconfig   |   5 +
 arch/arm/mach-exynos/Makefile  |   3 +-
 arch/arm/mach-exynos/common.h  |   7 ++
 arch/arm/mach-exynos/pm.c      | 178 +-----------------------------------
 arch/arm/mach-exynos/suspend.c | 203 +++++++++++++++++++++++++++++++++++++++++
 arch/arm/plat-samsung/Makefile |   1 +
 6 files changed, 222 insertions(+), 175 deletions(-)
 create mode 100644 arch/arm/mach-exynos/suspend.c

diff --git a/arch/arm/mach-exynos/Kconfig b/arch/arm/mach-exynos/Kconfig
index 8f9b66c..e42e725 100644
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
index f8daa9c..780d53b 100644
--- a/arch/arm/mach-exynos/common.h
+++ b/arch/arm/mach-exynos/common.h
@@ -121,6 +121,12 @@ void exynos_firmware_init(void);
 extern u32 exynos_get_eint_wake_mask(void);
 
 #ifdef CONFIG_PM_SLEEP
+extern void __init exynos_pm_suspend_init(void);
+#else
+static inline void exynos_pm_suspend_init(void) {}
+#endif
+
+#ifdef CONFIG_EXYNOS_CPU_SUSPEND
 extern void __init exynos_pm_init(void);
 #else
 static inline void exynos_pm_init(void) {}
@@ -155,6 +161,7 @@ extern int  exynos_cpu_power_state(int cpu);
 extern void exynos_cluster_power_down(int cluster);
 extern void exynos_cluster_power_up(int cluster);
 extern int  exynos_cluster_power_state(int cluster);
+extern void exynos_pm_do_save(void);
 extern void exynos_enter_aftr(void);
 
 extern void s5p_init_cpu(void __iomem *cpuid_addr);
diff --git a/arch/arm/mach-exynos/pm.c b/arch/arm/mach-exynos/pm.c
index 6581d15..4198c4b 100644
--- a/arch/arm/mach-exynos/pm.c
+++ b/arch/arm/mach-exynos/pm.c
@@ -1,5 +1,5 @@
 /*
- * Copyright (c) 2011-2012 Samsung Electronics Co., Ltd.
+ * Copyright (c) 2011-2014 Samsung Electronics Co., Ltd.
  *		http://www.samsung.com
  *
  * EXYNOS - Power Management support
@@ -14,39 +14,19 @@
 */
 
 #include <linux/init.h>
-#include <linux/suspend.h>
-#include <linux/syscore_ops.h>
 #include <linux/cpu_pm.h>
 #include <linux/io.h>
-#include <linux/irqchip/arm-gic.h>
 #include <linux/err.h>
-#include <linux/clk.h>
 
-#include <asm/cacheflush.h>
-#include <asm/hardware/cache-l2x0.h>
 #include <asm/smp_scu.h>
-#include <asm/suspend.h>
 
 #include <plat/pm-common.h>
-#include <plat/pll.h>
 #include <plat/regs-srom.h>
 
-#include <mach/map.h>
-
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
 static struct sleep_save exynos5_sys_save[] = {
 	SAVE_ITEM(EXYNOS5_SYS_I2C_CFG),
 };
@@ -60,47 +40,6 @@ static struct sleep_save exynos_core_save[] = {
 	SAVE_ITEM(S5P_SROM_BC3),
 };
 
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
 			S5P_INFORM7 : (samsung_rev() == EXYNOS4210_REV_1_0 ? \
 			(sysram_base_addr + 0x24) : S5P_INFORM0))
@@ -109,7 +48,6 @@ static int exynos_irq_set_wake(struct irq_data *data, unsigned int state)
 			(sysram_base_addr + 0x20) : S5P_INFORM1))
 
 #define S5P_CHECK_AFTR  0xFCBA0D10
-#define S5P_CHECK_SLEEP 0x00000BAD
 
 /* Ext-GIC nIRQ/nFIQ is the only wakeup source in AFTR */
 static void exynos_set_wakeupmask(long mask)
@@ -170,48 +108,12 @@ static void exynos_cpu_restore_register(void)
 		      : "cc");
 }
 
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
+void exynos_pm_do_save(void)
 {
-	unsigned int tmp;
-
-	/* Set wake-up mask registers */
-	__raw_writel(exynos_get_eint_wake_mask(), S5P_EINT_WAKEUP_MASK);
-	__raw_writel(exynos_irqwake_intmask & ~(1 << 31), S5P_WAKEUP_MASK);
-
 	s3c_pm_do_save(exynos_core_save, ARRAY_SIZE(exynos_core_save));
 
-	if (soc_is_exynos5250()) {
+	if (soc_is_exynos5250())
 		s3c_pm_do_save(exynos5_sys_save, ARRAY_SIZE(exynos5_sys_save));
-		/* Disable USE_RETENTION of JPEG_MEM_OPTION */
-		tmp = __raw_readl(EXYNOS5_JPEG_MEM_OPTION);
-		tmp &= ~EXYNOS5_OPTION_USE_RETENTION;
-		__raw_writel(tmp, EXYNOS5_JPEG_MEM_OPTION);
-	}
-
-	/* Set value of power down register for sleep mode */
-
-	exynos_sys_powerdown_conf(SYS_SLEEP);
-	__raw_writel(S5P_CHECK_SLEEP, S5P_INFORM1);
-
-	/* ensure at least INFORM0 has the resume address */
-
-	__raw_writel(virt_to_phys(exynos_cpu_resume), S5P_INFORM0);
 }
 
 static void exynos_pm_central_suspend(void)
@@ -299,68 +201,6 @@ early_wakeup:
 	return;
 }
 
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
-			__raw_readl(S5P_WAKEUP_STAT));
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
 static int exynos_cpu_pm_notifier(struct notifier_block *self,
 				  unsigned long cmd, void *v)
 {
@@ -387,17 +227,7 @@ static struct notifier_block exynos_cpu_pm_notifier_block = {
 
 void __init exynos_pm_init(void)
 {
-	u32 tmp;
-
 	cpu_pm_register_notifier(&exynos_cpu_pm_notifier_block);
 
-	/* Platform-specific GIC callback */
-	gic_arch_extn.irq_set_wake = exynos_irq_set_wake;
-
-	/* All wakeup disable */
-	tmp = __raw_readl(S5P_WAKEUP_MASK);
-	tmp |= ((0xFF << 8) | (0x1F << 1));
-	__raw_writel(tmp, S5P_WAKEUP_MASK);
-
-	suspend_set_ops(&exynos_suspend_ops);
+	exynos_pm_suspend_init();
 }
diff --git a/arch/arm/mach-exynos/suspend.c b/arch/arm/mach-exynos/suspend.c
new file mode 100644
index 0000000..6651eda
--- /dev/null
+++ b/arch/arm/mach-exynos/suspend.c
@@ -0,0 +1,203 @@
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
+#include <linux/cpu_pm.h>
+#include <linux/io.h>
+#include <linux/irqchip/arm-gic.h>
+#include <linux/err.h>
+
+#include <asm/cacheflush.h>
+#include <asm/hardware/cache-l2x0.h>
+#include <asm/suspend.h>
+
+#include <plat/pm-common.h>
+
+#include "common.h"
+#include "regs-pmu.h"
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
+static void exynos_pm_prepare(void)
+{
+	unsigned int tmp;
+
+	/* Set wake-up mask registers */
+	__raw_writel(exynos_get_eint_wake_mask(), S5P_EINT_WAKEUP_MASK);
+	__raw_writel(exynos_irqwake_intmask & ~(1 << 31), S5P_WAKEUP_MASK);
+
+	exynos_pm_do_save();
+
+	if (soc_is_exynos5250()) {
+		/* Disable USE_RETENTION of JPEG_MEM_OPTION */
+		tmp = __raw_readl(EXYNOS5_JPEG_MEM_OPTION);
+		tmp &= ~EXYNOS5_OPTION_USE_RETENTION;
+		__raw_writel(tmp, EXYNOS5_JPEG_MEM_OPTION);
+	}
+
+	/* Set value of power down register for sleep mode */
+
+	exynos_sys_powerdown_conf(SYS_SLEEP);
+	__raw_writel(S5P_CHECK_SLEEP, S5P_INFORM1);
+
+	/* ensure at least INFORM0 has the resume address */
+
+	__raw_writel(virt_to_phys(exynos_cpu_resume), S5P_INFORM0);
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
+			__raw_readl(S5P_WAKEUP_STAT));
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
+void __init exynos_pm_suspend_init(void)
+{
+	u32 tmp;
+
+	/* Platform-specific GIC callback */
+	gic_arch_extn.irq_set_wake = exynos_irq_set_wake;
+
+	/* All wakeup disable */
+	tmp = __raw_readl(S5P_WAKEUP_MASK);
+	tmp |= ((0xFF << 8) | (0x1F << 1));
+	__raw_writel(tmp, S5P_WAKEUP_MASK);
+
+	suspend_set_ops(&exynos_suspend_ops);
+}
diff --git a/arch/arm/plat-samsung/Makefile b/arch/arm/plat-samsung/Makefile
index 5e5beaa..607cde4 100644
--- a/arch/arm/plat-samsung/Makefile
+++ b/arch/arm/plat-samsung/Makefile
@@ -51,6 +51,7 @@ obj-$(CONFIG_SAMSUNG_DMADEV)	+= dma-ops.o
 # PM support
 
 obj-$(CONFIG_PM_SLEEP)		+= pm-common.o
+obj-$(CONFIG_EXYNOS_CPU_SUSPEND) += pm-common.o
 obj-$(CONFIG_SAMSUNG_PM)	+= pm.o
 obj-$(CONFIG_SAMSUNG_PM_GPIO)	+= pm-gpio.o
 obj-$(CONFIG_SAMSUNG_PM_CHECK)	+= pm-check.o
-- 
1.8.2.3

