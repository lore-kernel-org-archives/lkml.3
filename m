Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752864AbaKGSBa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 13:01:30 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:27548 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752623AbaKGSB0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 13:01:26 -0500
X-AuditID: cbfee61a-f79c06d000004e71-8e-545d08f4c4d4
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Kukjin Kim <kgene.kim@samsung.com>
Cc: Daniel Lezcano <daniel.lezcano@linaro.org>,
        Tomasz Figa <tomasz.figa@gmail.com>, Colin Cross <ccross@google.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-samsung-soc@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        b.zolnierkie@samsung.com
Subject: [PATCH 2/2] cpuidle: exynos: add coupled cpuidle support for Exynos4210
Date: Fri, 07 Nov 2014 19:00:51 +0100
Message-id: <1415383252-20118-3-git-send-email-b.zolnierkie@samsung.com>
X-Mailer: git-send-email 1.7.10.4
In-reply-to: <1415383252-20118-1-git-send-email-b.zolnierkie@samsung.com>
References: <1415383252-20118-1-git-send-email-b.zolnierkie@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrJLMWRmVeSWpSXmKPExsVy+t9jQd0vHLEhBo+261psnLGe1WLBjHZm
	i3mfZS1evzC06F1wlc3ibNMbdov3h54xW1zeNYfN4nPvEUaLGef3MVms2vWH0YHbY+esu+we
	CzaVety5tofN4/a/x8wefVtWMXp83iQXwBbFZZOSmpNZllqkb5fAlbHx9zbWgi9hFWd+/mFp
	YPzl1sXIwSEhYCLxdkdAFyMnkCkmceHeerYuRi4OIYHpjBK3V61mBkkICXQxSfzebQtiswlY
	SUxsX8UIYosIqEn0LN7KCNLALPCWSWL7q0dMIAlhgQCJ7knPwWwWAVWJi19msYLYvAIeEof2
	HWKG2KYo0f1sAhuIzSngKfHn7jR2iGUeEkefnGWewMi7gJFhFaNoakFyQXFSeq6hXnFibnFp
	Xrpecn7uJkZwAD6T2sG4ssHiEKMAB6MSD+9N3pgQIdbEsuLK3EOMEhzMSiK85qyxIUK8KYmV
	ValF+fFFpTmpxYcYpTlYlMR5D7RaBwoJpCeWpGanphakFsFkmTg4pRoYdTi+lEx9knCe45ey
	Rv0vz4rm+eem205wZv/loS8S1NO6L18zY0bCskdfbPfN47o7+/2em1yb3nfd0DzifkZ7Y49P
	nb3Q1UkT+JOcspb1/rfw/vfaVW393rxYl4nb1t8rn/9g74/ag0cf3gqM/pIqdbcvsfhdeZt4
	13aHl+/XcgrcPrKn9hb/LiWW4oxEQy3mouJEAPtO1/w8AgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following patch adds coupled cpuidle support for Exynos4210 to
an existing cpuidle-exynos driver.  As a result it enables AFTR mode
to be used by default on Exynos4210 without the need to hot unplug
CPU1 first.

The patch is heavily based on earlier cpuidle-exynos4210 driver from
Daniel Lezcano:

http://www.spinics.net/lists/linux-samsung-soc/msg28134.html

Changes from Daniel's code include:
- porting code to current kernels
- fixing it to work on my setup (by using S5P_INFORM register
  instead of S5P_VA_SYSRAM one on Revison 1.1 and retrying poking
  CPU1 out of the BOOT ROM if necessary)
- fixing rare lockup caused by waiting for CPU1 to get stuck in
  the BOOT ROM (CPU hotplug code in arch/arm/mach-exynos/platsmp.c
  doesn't require this and works fine)
- moving Exynos specific code to arch/arm/mach-exynos/pm.c
- using cpu_boot_reg_base() helper instead of BOOT_VECTOR macro
- using exynos_cpu_*() helpers instead of accessing registers
  directly
- using arch_send_wakeup_ipi_mask() instead of dsb_sev()
  (this matches CPU hotplug code in arch/arm/mach-exynos/platsmp.c)
- integrating separate exynos4210-cpuidle driver into existing
  exynos-cpuidle one

Cc: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: Colin Cross <ccross@google.com>
Cc: Kukjin Kim <kgene.kim@samsung.com>
Cc: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Tomasz Figa <tomasz.figa@gmail.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 arch/arm/mach-exynos/common.h                |   4 +
 arch/arm/mach-exynos/exynos.c                |   4 +
 arch/arm/mach-exynos/platsmp.c               |   2 +-
 arch/arm/mach-exynos/pm.c                    | 122 +++++++++++++++++++++++++++
 drivers/cpuidle/Kconfig.arm                  |   1 +
 drivers/cpuidle/cpuidle-exynos.c             |  62 ++++++++++++--
 include/linux/platform_data/cpuidle-exynos.h |  20 +++++
 7 files changed, 209 insertions(+), 6 deletions(-)
 create mode 100644 include/linux/platform_data/cpuidle-exynos.h

diff --git a/arch/arm/mach-exynos/common.h b/arch/arm/mach-exynos/common.h
index d4d09bc..f208a60 100644
--- a/arch/arm/mach-exynos/common.h
+++ b/arch/arm/mach-exynos/common.h
@@ -14,6 +14,7 @@
 
 #include <linux/reboot.h>
 #include <linux/of.h>
+#include <linux/platform_data/cpuidle-exynos.h>
 
 #define EXYNOS3250_SOC_ID	0xE3472000
 #define EXYNOS3_SOC_MASK	0xFFFFF000
@@ -168,8 +169,11 @@ extern void exynos_pm_central_suspend(void);
 extern int exynos_pm_central_resume(void);
 extern void exynos_enter_aftr(void);
 
+extern struct cpuidle_exynos_data cpuidle_coupled_exynos_data;
+
 extern void s5p_init_cpu(void __iomem *cpuid_addr);
 extern unsigned int samsung_rev(void);
+extern void __iomem *cpu_boot_reg_base(void);
 
 static inline void pmu_raw_writel(u32 val, u32 offset)
 {
diff --git a/arch/arm/mach-exynos/exynos.c b/arch/arm/mach-exynos/exynos.c
index a487e59..4f4eb9e 100644
--- a/arch/arm/mach-exynos/exynos.c
+++ b/arch/arm/mach-exynos/exynos.c
@@ -317,6 +317,10 @@ static void __init exynos_dt_machine_init(void)
 	if (!IS_ENABLED(CONFIG_SMP))
 		exynos_sysram_init();
 
+#ifdef CONFIG_ARM_EXYNOS_CPUIDLE
+	if (of_machine_is_compatible("samsung,exynos4210"))
+		exynos_cpuidle.dev.platform_data = &cpuidle_coupled_exynos_data;
+#endif
 	if (of_machine_is_compatible("samsung,exynos4210") ||
 	    of_machine_is_compatible("samsung,exynos4212") ||
 	    (of_machine_is_compatible("samsung,exynos4412") &&
diff --git a/arch/arm/mach-exynos/platsmp.c b/arch/arm/mach-exynos/platsmp.c
index adb36a8..0e3ffc9 100644
--- a/arch/arm/mach-exynos/platsmp.c
+++ b/arch/arm/mach-exynos/platsmp.c
@@ -182,7 +182,7 @@ int exynos_cluster_power_state(int cluster)
 		S5P_CORE_LOCAL_PWR_EN);
 }
 
-static inline void __iomem *cpu_boot_reg_base(void)
+void __iomem *cpu_boot_reg_base(void)
 {
 	if (soc_is_exynos4210() && samsung_rev() == EXYNOS4210_REV_1_1)
 		return pmu_base_addr + S5P_INFORM5;
diff --git a/arch/arm/mach-exynos/pm.c b/arch/arm/mach-exynos/pm.c
index 4b36ab5..44cc08a 100644
--- a/arch/arm/mach-exynos/pm.c
+++ b/arch/arm/mach-exynos/pm.c
@@ -178,3 +178,125 @@ void exynos_enter_aftr(void)
 
 	cpu_pm_exit();
 }
+
+static atomic_t cpu1_wakeup = ATOMIC_INIT(0);
+
+static int exynos_cpu0_enter_aftr(void)
+{
+	int ret = -1;
+
+	/*
+	 * If the other cpu is powered on, we have to power it off, because
+	 * the AFTR state won't work otherwise
+	 */
+	if (cpu_online(1)) {
+		/*
+		 * We reach a sync point with the coupled idle state, we know
+		 * the other cpu will power down itself or will abort the
+		 * sequence, let's wait for one of these to happen
+		 */
+		while (exynos_cpu_power_state(1)) {
+			/*
+			 * The other cpu may skip idle and boot back
+			 * up again
+			 */
+			if (atomic_read(&cpu1_wakeup))
+				goto abort;
+
+			/*
+			 * The other cpu may bounce through idle and
+			 * boot back up again, getting stuck in the
+			 * boot rom code
+			 */
+			if (__raw_readl(cpu_boot_reg_base()) == 0)
+				goto abort;
+
+			cpu_relax();
+		}
+	}
+
+	exynos_enter_aftr();
+	ret = 0;
+
+abort:
+	if (cpu_online(1)) {
+		/*
+		 * Set the boot vector to something non-zero
+		 */
+		__raw_writel(virt_to_phys(exynos_cpu_resume),
+			     cpu_boot_reg_base());
+		dsb();
+
+		/*
+		 * Turn on cpu1 and wait for it to be on
+		 */
+		exynos_cpu_power_up(1);
+		while (exynos_cpu_power_state(1) != S5P_CORE_LOCAL_PWR_EN)
+			cpu_relax();
+
+		while (!atomic_read(&cpu1_wakeup)) {
+			/*
+			 * Poke cpu1 out of the boot rom
+			 */
+			__raw_writel(virt_to_phys(exynos_cpu_resume),
+				     cpu_boot_reg_base());
+
+			arch_send_wakeup_ipi_mask(cpumask_of(1));
+		}
+	}
+
+	return ret;
+}
+
+static int exynos_wfi_finisher(unsigned long flags)
+{
+	cpu_do_idle();
+
+	return -1;
+}
+
+static int exynos_cpu1_powerdown(void)
+{
+	int ret = -1;
+
+	/*
+	 * Idle sequence for cpu1
+	 */
+	if (cpu_pm_enter())
+		goto cpu1_aborted;
+
+	/*
+	 * Turn off cpu 1
+	 */
+	exynos_cpu_power_down(1);
+
+	ret = cpu_suspend(0, exynos_wfi_finisher);
+
+	cpu_pm_exit();
+
+cpu1_aborted:
+	dsb();
+	/*
+	 * Notify cpu 0 that cpu 1 is awake
+	 */
+	atomic_set(&cpu1_wakeup, 1);
+
+	return ret;
+}
+
+static void exynos_pre_enter_aftr(void)
+{
+	__raw_writel(virt_to_phys(exynos_cpu_resume), cpu_boot_reg_base());
+}
+
+static void exynos_post_enter_aftr(void)
+{
+	atomic_set(&cpu1_wakeup, 0);
+}
+
+struct cpuidle_exynos_data cpuidle_coupled_exynos_data = {
+	.cpu0_enter_aftr		= exynos_cpu0_enter_aftr,
+	.cpu1_powerdown		= exynos_cpu1_powerdown,
+	.pre_enter_aftr		= exynos_pre_enter_aftr,
+	.post_enter_aftr		= exynos_post_enter_aftr,
+};
diff --git a/drivers/cpuidle/Kconfig.arm b/drivers/cpuidle/Kconfig.arm
index 8c16ab2..8e07c94 100644
--- a/drivers/cpuidle/Kconfig.arm
+++ b/drivers/cpuidle/Kconfig.arm
@@ -55,6 +55,7 @@ config ARM_AT91_CPUIDLE
 config ARM_EXYNOS_CPUIDLE
 	bool "Cpu Idle Driver for the Exynos processors"
 	depends on ARCH_EXYNOS
+	select ARCH_NEEDS_CPU_IDLE_COUPLED if SMP
 	help
 	  Select this to enable cpuidle for Exynos processors
 
diff --git a/drivers/cpuidle/cpuidle-exynos.c b/drivers/cpuidle/cpuidle-exynos.c
index ba9b34b..4700d5d 100644
--- a/drivers/cpuidle/cpuidle-exynos.c
+++ b/drivers/cpuidle/cpuidle-exynos.c
@@ -1,8 +1,11 @@
-/* linux/arch/arm/mach-exynos/cpuidle.c
- *
- * Copyright (c) 2011 Samsung Electronics Co., Ltd.
+/*
+ * Copyright (c) 2011-2014 Samsung Electronics Co., Ltd.
  *		http://www.samsung.com
  *
+ * Coupled cpuidle support based on the work of:
+ *	Colin Cross <ccross@android.com>
+ *	Daniel Lezcano <daniel.lezcano@linaro.org>
+ *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
  * published by the Free Software Foundation.
@@ -13,13 +16,49 @@
 #include <linux/export.h>
 #include <linux/module.h>
 #include <linux/platform_device.h>
+#include <linux/of.h>
+#include <linux/platform_data/cpuidle-exynos.h>
 
 #include <asm/proc-fns.h>
 #include <asm/suspend.h>
 #include <asm/cpuidle.h>
 
+static atomic_t exynos_idle_barrier;
+
+static struct cpuidle_exynos_data *exynos_cpuidle_pdata;
 static void (*exynos_enter_aftr)(void);
 
+static int exynos_enter_coupled_lowpower(struct cpuidle_device *dev,
+					 struct cpuidle_driver *drv,
+					 int index)
+{
+	int ret;
+
+	exynos_cpuidle_pdata->pre_enter_aftr();
+
+	/*
+	 * Waiting all cpus to reach this point at the same moment
+	 */
+	cpuidle_coupled_parallel_barrier(dev, &exynos_idle_barrier);
+
+	/*
+	 * Both cpus will reach this point at the same time
+	 */
+	ret = dev->cpu ? exynos_cpuidle_pdata->cpu1_powerdown()
+		       : exynos_cpuidle_pdata->cpu0_enter_aftr();
+	if (ret)
+		index = ret;
+
+	/*
+	 * Waiting all cpus to finish the power sequence before going further
+	 */
+	cpuidle_coupled_parallel_barrier(dev, &exynos_idle_barrier);
+
+	exynos_cpuidle_pdata->post_enter_aftr();
+
+	return index;
+}
+
 static int exynos_enter_lowpower(struct cpuidle_device *dev,
 				struct cpuidle_driver *drv,
 				int index)
@@ -58,11 +97,24 @@ static struct cpuidle_driver exynos_idle_driver = {
 
 static int exynos_cpuidle_probe(struct platform_device *pdev)
 {
+	const struct cpumask *coupled_cpus = NULL;
 	int ret;
 
-	exynos_enter_aftr = (void *)(pdev->dev.platform_data);
+	if (of_machine_is_compatible("samsung,exynos4210")) {
+		exynos_cpuidle_pdata = pdev->dev.platform_data;
+
+		exynos_idle_driver.states[1].enter =
+						exynos_enter_coupled_lowpower;
+		exynos_idle_driver.states[1].exit_latency = 5000;
+		exynos_idle_driver.states[1].target_residency = 10000;
+		exynos_idle_driver.states[1].flags |= CPUIDLE_FLAG_COUPLED |
+						      CPUIDLE_FLAG_TIMER_STOP;
+
+		coupled_cpus = cpu_possible_mask;
+	} else
+		exynos_enter_aftr = (void *)(pdev->dev.platform_data);
 
-	ret = cpuidle_register(&exynos_idle_driver, NULL);
+	ret = cpuidle_register(&exynos_idle_driver, coupled_cpus);
 	if (ret) {
 		dev_err(&pdev->dev, "failed to register cpuidle driver\n");
 		return ret;
diff --git a/include/linux/platform_data/cpuidle-exynos.h b/include/linux/platform_data/cpuidle-exynos.h
new file mode 100644
index 0000000..bfa40e4
--- /dev/null
+++ b/include/linux/platform_data/cpuidle-exynos.h
@@ -0,0 +1,20 @@
+/*
+ * Copyright (c) 2014 Samsung Electronics Co., Ltd.
+ *              http://www.samsung.com
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+*/
+
+#ifndef __CPUIDLE_EXYNOS_H
+#define __CPUIDLE_EXYNOS_H
+
+struct cpuidle_exynos_data {
+	int (*cpu0_enter_aftr)(void);
+	int (*cpu1_powerdown)(void);
+	void (*pre_enter_aftr)(void);
+	void (*post_enter_aftr)(void);
+};
+
+#endif
-- 
1.8.2.3

