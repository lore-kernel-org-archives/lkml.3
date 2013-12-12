Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751475Ab3LLJcJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 04:32:09 -0500
Received: from hqemgate14.nvidia.com ([216.228.121.143]:4551 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751191Ab3LLJcE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 04:32:04 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Thu, 12 Dec 2013 01:33:43 -0800
From: Bill Huang <bilhuang@nvidia.com>
To: <swarren@wwwdotorg.org>, <rjw@rjwysocki.net>, <viresh.kumar@linario.org>,
        <thierry.reding@gmail.com>
CC: <linux-kernel@vger.kernel.org>, <cpufreq@vger.kernel.org>,
        <linux-pm@vger.kernel.org>, <linux-tegra@vger.kernel.org>,
        Bill Huang <bilhuang@nvidia.com>
Subject: [PATCH v4 1/1] cpufreq: tegra: Re-model Tegra20 cpufreq driver
Date: Thu, 12 Dec 2013 17:32:07 +0800
Message-ID: <1386840727-28716-1-git-send-email-bilhuang@nvidia.com>
X-Mailer: git-send-email 1.7.9.5
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Re-model Tegra20 cpufreq driver as below.

* Rename tegra-cpufreq.c to tegra20-cpufreq.c since this file supports
  only Tegra20.
* Add probe function so defer probe can be used when we're going to
  support DVFS.
* Create a fake cpufreq platform device with its name being
  "${root_compatible}-cpufreq" so SoC cpufreq driver can bind to it
  accordingly.

Signed-off-by: Bill Huang <bilhuang@nvidia.com>
---

This patch remodel Tegra cpufreq driver to make it more easy to add new
SoC support, in addition to that, adding probe function in the driver to
let probe defer can be used to control init sequence when we are going
to support DVFS.

Changes since v3:

- Create separate driver for each SoCs instead of a central driver indirect
  call to different SoC functions.

Changes since v2:

- Fix Kconfig.
- Rebase on top of branch 'cpufreq-next' on git://git.linaro.org/people/vireshk/linux.git.

Changes since v1:

- Split up patches.
- Split configuration-time data out of structure "tegra_cpufreq_data".
- Bug fixes.

---
 arch/arm/mach-tegra/tegra.c       |    2 +
 drivers/cpufreq/Kconfig.arm       |   12 +++
 drivers/cpufreq/Makefile          |    1 +
 drivers/cpufreq/tegra-cpufreq.c   |  214 ++++++-------------------------------
 drivers/cpufreq/tegra20-cpufreq.c |  192 +++++++++++++++++++++++++++++++++
 include/linux/tegra-cpufreq.h     |   24 +++++
 6 files changed, 265 insertions(+), 180 deletions(-)
 create mode 100644 drivers/cpufreq/tegra20-cpufreq.c
 create mode 100644 include/linux/tegra-cpufreq.h

diff --git a/arch/arm/mach-tegra/tegra.c b/arch/arm/mach-tegra/tegra.c
index 7336817..a9b23e9 100644
--- a/arch/arm/mach-tegra/tegra.c
+++ b/arch/arm/mach-tegra/tegra.c
@@ -34,6 +34,7 @@
 #include <linux/usb/tegra_usb_phy.h>
 #include <linux/clk/tegra.h>
 #include <linux/irqchip.h>
+#include <linux/tegra-cpufreq.h>
 
 #include <asm/hardware/cache-l2x0.h>
 #include <asm/mach-types.h>
@@ -160,6 +161,7 @@ static void __init tegra_dt_init_late(void)
 {
 	int i;
 
+	tegra_cpufreq_init();
 	tegra_init_suspend();
 	tegra_cpuidle_init();
 	tegra_powergate_debugfs_init();
diff --git a/drivers/cpufreq/Kconfig.arm b/drivers/cpufreq/Kconfig.arm
index ce52ed9..1cc9213 100644
--- a/drivers/cpufreq/Kconfig.arm
+++ b/drivers/cpufreq/Kconfig.arm
@@ -225,6 +225,18 @@ config ARM_TEGRA_CPUFREQ
 	help
 	  This adds the CPUFreq driver support for TEGRA SOCs.
 
+config ARM_TEGRA20_CPUFREQ
+	bool "NVIDIA TEGRA20"
+	depends on ARM_TEGRA_CPUFREQ && ARCH_TEGRA_2x_SOC
+	default y
+	help
+	  This enables Tegra20 cpufreq functionality, it adds
+	  Tegra20 CPU frequency ladder and the call back functions
+	  to set CPU rate. All the non-SoC dependant codes are
+	  controlled by the config ARM_TEGRA20_CPUFREQ.
+
+	  If in doubt, say N.
+
 config ARM_VEXPRESS_SPC_CPUFREQ
         tristate "Versatile Express SPC based CPUfreq driver"
         select ARM_BIG_LITTLE_CPUFREQ
diff --git a/drivers/cpufreq/Makefile b/drivers/cpufreq/Makefile
index 7494565..331964b 100644
--- a/drivers/cpufreq/Makefile
+++ b/drivers/cpufreq/Makefile
@@ -74,6 +74,7 @@ obj-$(CONFIG_ARM_SA1100_CPUFREQ)	+= sa1100-cpufreq.o
 obj-$(CONFIG_ARM_SA1110_CPUFREQ)	+= sa1110-cpufreq.o
 obj-$(CONFIG_ARM_SPEAR_CPUFREQ)		+= spear-cpufreq.o
 obj-$(CONFIG_ARM_TEGRA_CPUFREQ)		+= tegra-cpufreq.o
+obj-$(CONFIG_ARM_TEGRA20_CPUFREQ)	+= tegra20-cpufreq.o
 obj-$(CONFIG_ARM_VEXPRESS_SPC_CPUFREQ)	+= vexpress-spc-cpufreq.o
 
 ##################################################################################
diff --git a/drivers/cpufreq/tegra-cpufreq.c b/drivers/cpufreq/tegra-cpufreq.c
index 63f0059..a4be7c4 100644
--- a/drivers/cpufreq/tegra-cpufreq.c
+++ b/drivers/cpufreq/tegra-cpufreq.c
@@ -1,193 +1,47 @@
 /*
- * Copyright (C) 2010 Google, Inc.
+ * Copyright (c) 2013, NVIDIA Corporation. All rights reserved.
  *
- * Author:
- *	Colin Cross <ccross@google.com>
- *	Based on arch/arm/plat-omap/cpu-omap.c, (C) 2005 Nokia Corporation
- *
- * This software is licensed under the terms of the GNU General Public
- * License version 2, as published by the Free Software Foundation, and
- * may be copied, distributed, and modified under those terms.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
  *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
  */
 
 #include <linux/kernel.h>
-#include <linux/module.h>
-#include <linux/types.h>
-#include <linux/sched.h>
-#include <linux/cpufreq.h>
-#include <linux/delay.h>
-#include <linux/init.h>
-#include <linux/err.h>
-#include <linux/clk.h>
-#include <linux/io.h>
-
-static struct cpufreq_frequency_table freq_table[] = {
-	{ .frequency = 216000 },
-	{ .frequency = 312000 },
-	{ .frequency = 456000 },
-	{ .frequency = 608000 },
-	{ .frequency = 760000 },
-	{ .frequency = 816000 },
-	{ .frequency = 912000 },
-	{ .frequency = 1000000 },
-	{ .frequency = CPUFREQ_TABLE_END },
+#include <linux/platform_device.h>
+#include <linux/of.h>
+#include <linux/tegra-cpufreq.h>
+
+static const char * const tegra_soc_compat[] = {
+	"nvidia,tegra124",
+	"nvidia,tegra114",
+	"nvidia,tegra30",
+	"nvidia,tegra20",
+	NULL
 };
 
-#define NUM_CPUS	2
-
-static struct clk *cpu_clk;
-static struct clk *pll_x_clk;
-static struct clk *pll_p_clk;
-static struct clk *emc_clk;
-
-static int tegra_cpu_clk_set_rate(unsigned long rate)
-{
-	int ret;
-
-	/*
-	 * Take an extra reference to the main pll so it doesn't turn
-	 * off when we move the cpu off of it
-	 */
-	clk_prepare_enable(pll_x_clk);
-
-	ret = clk_set_parent(cpu_clk, pll_p_clk);
-	if (ret) {
-		pr_err("Failed to switch cpu to clock pll_p\n");
-		goto out;
-	}
-
-	if (rate == clk_get_rate(pll_p_clk))
-		goto out;
-
-	ret = clk_set_rate(pll_x_clk, rate);
-	if (ret) {
-		pr_err("Failed to change pll_x to %lu\n", rate);
-		goto out;
-	}
-
-	ret = clk_set_parent(cpu_clk, pll_x_clk);
-	if (ret) {
-		pr_err("Failed to switch cpu to clock pll_x\n");
-		goto out;
-	}
-
-out:
-	clk_disable_unprepare(pll_x_clk);
-	return ret;
-}
-
-static int tegra_update_cpu_speed(struct cpufreq_policy *policy,
-		unsigned long rate)
-{
-	int ret = 0;
-
-	/*
-	 * Vote on memory bus frequency based on cpu frequency
-	 * This sets the minimum frequency, display or avp may request higher
-	 */
-	if (rate >= 816000)
-		clk_set_rate(emc_clk, 600000000); /* cpu 816 MHz, emc max */
-	else if (rate >= 456000)
-		clk_set_rate(emc_clk, 300000000); /* cpu 456 MHz, emc 150Mhz */
-	else
-		clk_set_rate(emc_clk, 100000000);  /* emc 50Mhz */
-
-	ret = tegra_cpu_clk_set_rate(rate * 1000);
-	if (ret)
-		pr_err("cpu-tegra: Failed to set cpu frequency to %lu kHz\n",
-			rate);
-
-	return ret;
-}
-
-static int tegra_target(struct cpufreq_policy *policy, unsigned int index)
-{
-	return tegra_update_cpu_speed(policy, freq_table[index].frequency);
-}
-
-static int tegra_cpu_init(struct cpufreq_policy *policy)
+int __init tegra_cpufreq_init(void)
 {
-	int ret;
-
-	if (policy->cpu >= NUM_CPUS)
-		return -EINVAL;
-
-	clk_prepare_enable(emc_clk);
-	clk_prepare_enable(cpu_clk);
-
-	/* FIXME: what's the actual transition time? */
-	ret = cpufreq_generic_init(policy, freq_table, 300 * 1000);
-	if (ret) {
-		clk_disable_unprepare(cpu_clk);
-		clk_disable_unprepare(emc_clk);
-		return ret;
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(tegra_soc_compat); i++) {
+		if (of_machine_is_compatible(tegra_soc_compat[i])) {
+			struct platform_device_info devinfo;
+			char buf[40];
+
+			memset(&devinfo, 0, sizeof(devinfo));
+			strcpy(buf, tegra_soc_compat[i]);
+			strcat(buf, "-cpufreq");
+			devinfo.name = buf;
+			platform_device_register_full(&devinfo);
+			break;
+		}
 	}
 
-	policy->clk = cpu_clk;
-	policy->suspend_freq = freq_table[0].frequency;
-	return 0;
-}
-
-static int tegra_cpu_exit(struct cpufreq_policy *policy)
-{
-	clk_disable_unprepare(cpu_clk);
-	clk_disable_unprepare(emc_clk);
 	return 0;
 }
-
-static struct cpufreq_driver tegra_cpufreq_driver = {
-	.flags		= CPUFREQ_NEED_INITIAL_FREQ_CHECK,
-	.verify		= cpufreq_generic_frequency_table_verify,
-	.target_index	= tegra_target,
-	.get		= cpufreq_generic_get,
-	.init		= tegra_cpu_init,
-	.exit		= tegra_cpu_exit,
-	.name		= "tegra",
-	.attr		= cpufreq_generic_attr,
-#ifdef CONFIG_PM
-	.suspend	= cpufreq_generic_suspend,
-#endif
-};
-
-static int __init tegra_cpufreq_init(void)
-{
-	cpu_clk = clk_get_sys(NULL, "cclk");
-	if (IS_ERR(cpu_clk))
-		return PTR_ERR(cpu_clk);
-
-	pll_x_clk = clk_get_sys(NULL, "pll_x");
-	if (IS_ERR(pll_x_clk))
-		return PTR_ERR(pll_x_clk);
-
-	pll_p_clk = clk_get_sys(NULL, "pll_p");
-	if (IS_ERR(pll_p_clk))
-		return PTR_ERR(pll_p_clk);
-
-	emc_clk = clk_get_sys("cpu", "emc");
-	if (IS_ERR(emc_clk)) {
-		clk_put(cpu_clk);
-		return PTR_ERR(emc_clk);
-	}
-
-	return cpufreq_register_driver(&tegra_cpufreq_driver);
-}
-
-static void __exit tegra_cpufreq_exit(void)
-{
-        cpufreq_unregister_driver(&tegra_cpufreq_driver);
-	clk_put(emc_clk);
-	clk_put(cpu_clk);
-}
-
-
-MODULE_AUTHOR("Colin Cross <ccross@android.com>");
-MODULE_DESCRIPTION("cpufreq driver for Nvidia Tegra2");
-MODULE_LICENSE("GPL");
-module_init(tegra_cpufreq_init);
-module_exit(tegra_cpufreq_exit);
+EXPORT_SYMBOL(tegra_cpufreq_init);
diff --git a/drivers/cpufreq/tegra20-cpufreq.c b/drivers/cpufreq/tegra20-cpufreq.c
new file mode 100644
index 0000000..a430701
--- /dev/null
+++ b/drivers/cpufreq/tegra20-cpufreq.c
@@ -0,0 +1,192 @@
+/*
+ * Copyright (C) 2010 Google, Inc.
+ *
+ * Author:
+ *	Colin Cross <ccross@google.com>
+ *	Based on arch/arm/plat-omap/cpu-omap.c, (C) 2005 Nokia Corporation
+ *
+ * This software is licensed under the terms of the GNU General Public
+ * License version 2, as published by the Free Software Foundation, and
+ * may be copied, distributed, and modified under those terms.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/cpufreq.h>
+#include <linux/err.h>
+#include <linux/clk.h>
+#include <linux/io.h>
+#include <linux/cpu.h>
+#include <linux/platform_device.h>
+
+static struct cpufreq_frequency_table freq_table[] = {
+	{ .frequency = 216000 },
+	{ .frequency = 312000 },
+	{ .frequency = 456000 },
+	{ .frequency = 608000 },
+	{ .frequency = 760000 },
+	{ .frequency = 816000 },
+	{ .frequency = 912000 },
+	{ .frequency = 1000000 },
+	{ .frequency = CPUFREQ_TABLE_END },
+};
+
+static struct clk *cpu_clk;
+static struct clk *pll_x_clk;
+static struct clk *pll_p_clk;
+static struct clk *emc_clk;
+
+static int tegra20_cpu_clk_set_rate(unsigned long rate)
+{
+	int ret;
+
+	/*
+	 * Take an extra reference to the main pll so it doesn't turn
+	 * off when we move the cpu off of it
+	 */
+	clk_prepare_enable(pll_x_clk);
+
+	ret = clk_set_parent(cpu_clk, pll_p_clk);
+	if (ret) {
+		pr_err("Failed to switch cpu to clock pll_p\n");
+		goto out;
+	}
+
+	if (rate == clk_get_rate(pll_p_clk))
+		goto out;
+
+	ret = clk_set_rate(pll_x_clk, rate);
+	if (ret) {
+		pr_err("Failed to change pll_x to %lu\n", rate);
+		goto out;
+	}
+
+	ret = clk_set_parent(cpu_clk, pll_x_clk);
+	if (ret) {
+		pr_err("Failed to switch cpu to clock pll_x\n");
+		goto out;
+	}
+
+out:
+	clk_disable_unprepare(pll_x_clk);
+	return ret;
+}
+
+static int tegra20_update_cpu_speed(struct cpufreq_policy *policy,
+		unsigned long rate)
+{
+	int ret = 0;
+
+	/*
+	 * Vote on memory bus frequency based on cpu frequency
+	 * This sets the minimum frequency, display or avp may request higher
+	 */
+	if (rate >= 816000)
+		clk_set_rate(emc_clk, 600000000); /* cpu 816 MHz, emc max */
+	else if (rate >= 456000)
+		clk_set_rate(emc_clk, 300000000); /* cpu 456 MHz, emc 150Mhz */
+	else
+		clk_set_rate(emc_clk, 100000000);  /* emc 50Mhz */
+
+	ret = tegra20_cpu_clk_set_rate(rate * 1000);
+	if (ret)
+		pr_err("cpu-tegra20: Failed to set cpu frequency to %lu kHz\n",
+			rate);
+
+	return ret;
+}
+
+static int tegra20_target(struct cpufreq_policy *policy, unsigned int index)
+{
+	return tegra20_update_cpu_speed(policy, freq_table[index].frequency);
+}
+
+static int tegra20_cpu_init(struct cpufreq_policy *policy)
+{
+	int ret;
+
+	clk_prepare_enable(emc_clk);
+	clk_prepare_enable(cpu_clk);
+
+	/* FIXME: what's the actual transition time? */
+	ret = cpufreq_generic_init(policy, freq_table, 300 * 1000);
+	if (ret) {
+		clk_disable_unprepare(cpu_clk);
+		clk_disable_unprepare(emc_clk);
+		return ret;
+	}
+
+	policy->clk = cpu_clk;
+	policy->suspend_freq = freq_table[0].frequency;
+	return 0;
+}
+
+static int tegra20_cpu_exit(struct cpufreq_policy *policy)
+{
+	clk_disable_unprepare(cpu_clk);
+	clk_disable_unprepare(emc_clk);
+	return 0;
+}
+
+static struct cpufreq_driver tegra20_cpufreq_driver = {
+	.flags		= CPUFREQ_NEED_INITIAL_FREQ_CHECK,
+	.verify		= cpufreq_generic_frequency_table_verify,
+	.target_index	= tegra20_target,
+	.get		= cpufreq_generic_get,
+	.init		= tegra20_cpu_init,
+	.exit		= tegra20_cpu_exit,
+	.name		= "tegra",
+	.attr		= cpufreq_generic_attr,
+#ifdef CONFIG_PM
+	.suspend	= cpufreq_generic_suspend,
+#endif
+};
+
+static int tegra20_cpufreq_probe(struct platform_device *pdev)
+{
+	cpu_clk = clk_get_sys(NULL, "cclk");
+	if (IS_ERR(cpu_clk))
+		return PTR_ERR(cpu_clk);
+
+	pll_x_clk = clk_get_sys(NULL, "pll_x");
+	if (IS_ERR(pll_x_clk))
+		return PTR_ERR(pll_x_clk);
+
+	pll_p_clk = clk_get_sys(NULL, "pll_p");
+	if (IS_ERR(pll_p_clk))
+		return PTR_ERR(pll_p_clk);
+
+	emc_clk = clk_get_sys("cpu", "emc");
+	if (IS_ERR(emc_clk)) {
+		clk_put(cpu_clk);
+		return PTR_ERR(emc_clk);
+	}
+
+	return cpufreq_register_driver(&tegra20_cpufreq_driver);
+}
+
+static int tegra20_cpufreq_remove(struct platform_device *pdev)
+{
+	cpufreq_unregister_driver(&tegra20_cpufreq_driver);
+	return 0;
+}
+
+static struct platform_driver tegra_cpufreq_platdrv = {
+	.driver = {
+		.name	= "nvidia,tegra20-cpufreq",
+		.owner	= THIS_MODULE,
+	},
+	.probe		= tegra20_cpufreq_probe,
+	.remove		= tegra20_cpufreq_remove,
+};
+module_platform_driver(tegra_cpufreq_platdrv);
+
+MODULE_AUTHOR("Colin Cross <ccross@android.com>");
+MODULE_DESCRIPTION("cpufreq driver for Nvidia Tegra2");
+MODULE_LICENSE("GPL");
diff --git a/include/linux/tegra-cpufreq.h b/include/linux/tegra-cpufreq.h
new file mode 100644
index 0000000..d7643e0
--- /dev/null
+++ b/include/linux/tegra-cpufreq.h
@@ -0,0 +1,24 @@
+/*
+ * Copyright (c) 2013, NVIDIA Corporation. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ */
+
+#ifndef __LINUX_TEGRA_CPUFREQ_H
+#define __LINUX_TEGRA_CPUFREQ_H
+
+#ifdef CONFIG_ARM_TEGRA_CPUFREQ
+int tegra_cpufreq_init(void);
+#else
+static inline int tegra_cpufreq_init(void)
+{ return; }
+#endif
+
+#endif /* __LINUX_TEGRA_CPUFREQ_H_ */
-- 
1.7.9.5

