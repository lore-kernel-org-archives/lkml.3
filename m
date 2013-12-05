Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753352Ab3LEHov (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 02:44:51 -0500
Received: from hqemgate14.nvidia.com ([216.228.121.143]:15461 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752622Ab3LEHoh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 02:44:37 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Wed, 04 Dec 2013 23:37:56 -0800
From: Bill Huang <bilhuang@nvidia.com>
To: <rjw@rjwysocki.net>, <viresh.kumar@linaro.org>, <swarren@wwwdotorg.org>,
        <thierry.reding@gmail.com>
CC: <linux-kernel@vger.kernel.org>, <cpufreq@vger.kernel.org>,
        <linux-pm@vger.kernel.org>, <linux-tegra@vger.kernel.org>,
        Bill Huang <bilhuang@nvidia.com>
Subject: [PATCH v3 2/2] cpufreq: tegra: Re-model Tegra cpufreq driver
Date: Thu, 5 Dec 2013 15:44:22 +0800
Message-ID: <1386229462-3474-3-git-send-email-bilhuang@nvidia.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1386229462-3474-1-git-send-email-bilhuang@nvidia.com>
References: <1386229462-3474-1-git-send-email-bilhuang@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Re-model Tegra cpufreq driver to support all Tegra series of SoCs.

* Make tegra-cpufreq.c a generic Tegra cpufreq driver.
* Move Tegra20 specific codes into tegra20-cpufreq.c.
* Bind Tegra cpufreq dirver with a fake device so defer probe would work
  when we're going to get regulator in the driver to support voltage
  scaling (DVFS).

Signed-off-by: Bill Huang <bilhuang@nvidia.com>
---
 drivers/cpufreq/Kconfig.arm       |   12 +++
 drivers/cpufreq/Makefile          |    1 +
 drivers/cpufreq/tegra-cpufreq.c   |  185 ++++++++++++++++++-------------------
 drivers/cpufreq/tegra-cpufreq.h   |   40 ++++++++
 drivers/cpufreq/tegra20-cpufreq.c |  136 +++++++++++++++++++++++++++
 5 files changed, 278 insertions(+), 96 deletions(-)
 create mode 100644 drivers/cpufreq/tegra-cpufreq.h
 create mode 100644 drivers/cpufreq/tegra20-cpufreq.c

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
index ae1c0f1..5f19c18 100644
--- a/drivers/cpufreq/tegra-cpufreq.c
+++ b/drivers/cpufreq/tegra-cpufreq.c
@@ -1,5 +1,6 @@
 /*
  * Copyright (C) 2010 Google, Inc.
+ * Copyright (c) 2013, NVIDIA Corporation.
  *
  * Author:
  *	Colin Cross <ccross@google.com>
@@ -18,69 +19,17 @@
 
 #include <linux/kernel.h>
 #include <linux/module.h>
-#include <linux/types.h>
-#include <linux/sched.h>
 #include <linux/cpufreq.h>
-#include <linux/delay.h>
-#include <linux/init.h>
 #include <linux/err.h>
 #include <linux/clk.h>
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
-};
-
-#define NUM_CPUS	2
+#include <linux/cpu.h>
+#include <linux/platform_device.h>
+#include <linux/of.h>
 
-static struct clk *cpu_clk;
-static struct clk *pll_x_clk;
-static struct clk *pll_p_clk;
-static struct clk *emc_clk;
-
-static int tegra_cpu_clk_set_rate(unsigned long rate)
-{
-	int ret;
+#include "tegra-cpufreq.h"
 
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
+static struct tegra_cpufreq_data *tegra_data;
+static const struct tegra_cpufreq_config *soc_config;
 
 static int tegra_update_cpu_speed(struct cpufreq_policy *policy,
 		unsigned long rate)
@@ -91,14 +40,10 @@ static int tegra_update_cpu_speed(struct cpufreq_policy *policy,
 	 * Vote on memory bus frequency based on cpu frequency
 	 * This sets the minimum frequency, display or avp may request higher
 	 */
-	if (rate >= 816000)
-		clk_set_rate(emc_clk, 600000000); /* cpu 816 MHz, emc max */
-	else if (rate >= 456000)
-		clk_set_rate(emc_clk, 300000000); /* cpu 456 MHz, emc 150Mhz */
-	else
-		clk_set_rate(emc_clk, 100000000);  /* emc 50Mhz */
-
-	ret = tegra_cpu_clk_set_rate(rate * 1000);
+	if (soc_config->vote_emc_on_cpu_rate)
+		soc_config->vote_emc_on_cpu_rate(rate);
+
+	ret = soc_config->cpu_clk_set_rate(rate * 1000);
 	if (ret)
 		pr_err("cpu-tegra: Failed to set cpu frequency to %lu kHz\n",
 			rate);
@@ -108,6 +53,8 @@ static int tegra_update_cpu_speed(struct cpufreq_policy *policy,
 
 static int tegra_target(struct cpufreq_policy *policy, unsigned int index)
 {
+	struct cpufreq_frequency_table *freq_table = tegra_data->freq_table;
+
 	return tegra_update_cpu_speed(policy, freq_table[index].frequency);
 }
 
@@ -115,29 +62,27 @@ static int tegra_cpu_init(struct cpufreq_policy *policy)
 {
 	int ret;
 
-	if (policy->cpu >= NUM_CPUS)
-		return -EINVAL;
-
-	clk_prepare_enable(emc_clk);
-	clk_prepare_enable(cpu_clk);
+	if (soc_config->cpufreq_clk_init)
+		soc_config->cpufreq_clk_init();
 
 	/* FIXME: what's the actual transition time? */
-	ret = cpufreq_generic_init(policy, freq_table, 300 * 1000);
+	ret = cpufreq_generic_init(policy, tegra_data->freq_table, 300 * 1000);
 	if (ret) {
-		clk_disable_unprepare(cpu_clk);
-		clk_disable_unprepare(emc_clk);
+		if (soc_config->cpufreq_clk_exit)
+			soc_config->cpufreq_clk_exit();
 		return ret;
 	}
 
-	policy->clk = cpu_clk;
-	policy->suspend_freq = freq_table[0].frequency;
+	policy->clk = tegra_data->cpu_clk;
+	policy->suspend_freq = tegra_data->freq_table[0].frequency;
 	return 0;
 }
 
 static int tegra_cpu_exit(struct cpufreq_policy *policy)
 {
-	clk_disable_unprepare(cpu_clk);
-	clk_disable_unprepare(emc_clk);
+	cpufreq_frequency_table_cpuinfo(policy, tegra_data->freq_table);
+	if (soc_config->cpufreq_clk_exit)
+		soc_config->cpufreq_clk_exit();
 	return 0;
 }
 
@@ -155,27 +100,75 @@ static struct cpufreq_driver tegra_cpufreq_driver = {
 #endif
 };
 
-int __init tegra_cpufreq_init(void)
+static struct {
+	char *compat;
+	int (*init)(struct tegra_cpufreq_data *,
+			const struct tegra_cpufreq_config **);
+} tegra_init_funcs[] = {
+	{ "nvidia,tegra20", tegra20_cpufreq_init },
+};
+
+static int tegra_cpufreq_probe(struct platform_device *pdev)
 {
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
+	int i;
+	int ret = -EINVAL;
+
+	tegra_data = devm_kzalloc(&pdev->dev,
+			sizeof(*tegra_data), GFP_KERNEL);
+	if (!tegra_data) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	tegra_data->dev = &pdev->dev;
+
+	for (i = 0; i < ARRAY_SIZE(tegra_init_funcs); i++) {
+		if (of_machine_is_compatible(tegra_init_funcs[i].compat)) {
+			ret = tegra_init_funcs[i].init(tegra_data, &soc_config);
+			if (!ret)
+				break;
+			else
+				goto out;
+		}
 	}
+	if (i == ARRAY_SIZE(tegra_init_funcs))
+		goto out;
+
+	ret = cpufreq_register_driver(&tegra_cpufreq_driver);
+	if (ret) {
+		dev_err(tegra_data->dev,
+			"%s: failed to register cpufreq driver\n", __func__);
+		goto out;
+	}
+
+	return 0;
+out:
+	return ret;
+}
+
+static int tegra_cpufreq_remove(struct platform_device *pdev)
+{
+	cpufreq_unregister_driver(&tegra_cpufreq_driver);
+	return 0;
+}
 
-	return cpufreq_register_driver(&tegra_cpufreq_driver);
+static struct platform_driver tegra_cpufreq_platdrv = {
+	.driver = {
+		.name	= "tegra-cpufreq",
+		.owner	= THIS_MODULE,
+	},
+	.probe		= tegra_cpufreq_probe,
+	.remove		= tegra_cpufreq_remove,
+};
+module_platform_driver(tegra_cpufreq_platdrv);
+
+int __init tegra_cpufreq_init(void)
+{
+	struct platform_device_info devinfo = { .name = "tegra-cpufreq", };
+
+	platform_device_register_full(&devinfo);
+
+	return 0;
 }
 EXPORT_SYMBOL(tegra_cpufreq_init);
 
diff --git a/drivers/cpufreq/tegra-cpufreq.h b/drivers/cpufreq/tegra-cpufreq.h
new file mode 100644
index 0000000..0556354
--- /dev/null
+++ b/drivers/cpufreq/tegra-cpufreq.h
@@ -0,0 +1,40 @@
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
+ *
+ */
+
+#ifndef __LINUX_TEGRA_CPUFREQ_H
+#define __LINUX_TEGRA_CPUFREQ_H
+
+struct tegra_cpufreq_config {
+	void (*vote_emc_on_cpu_rate)(unsigned long);
+	int (*cpu_clk_set_rate)(unsigned long);
+	void (*cpufreq_clk_init)(void);
+	void (*cpufreq_clk_exit)(void);
+};
+
+struct tegra_cpufreq_data {
+	struct device	*dev;
+	struct clk	*cpu_clk;
+	struct cpufreq_frequency_table	*freq_table;
+};
+
+#ifdef CONFIG_ARM_TEGRA20_CPUFREQ
+int tegra20_cpufreq_init(struct tegra_cpufreq_data *data,
+		const struct tegra_cpufreq_config **config);
+#else
+static inline int tegra20_cpufreq_init(struct tegra_cpufreq_data *data,
+		const struct tegra_cpufreq_config **config)
+{ return -EINVAL; }
+#endif
+
+#endif /* __LINUX_TEGRA_CPUFREQ_H_ */
diff --git a/drivers/cpufreq/tegra20-cpufreq.c b/drivers/cpufreq/tegra20-cpufreq.c
new file mode 100644
index 0000000..b5b4e95
--- /dev/null
+++ b/drivers/cpufreq/tegra20-cpufreq.c
@@ -0,0 +1,136 @@
+/*
+ * Copyright (c) 2013, NVIDIA CORPORATION.  All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/cpufreq.h>
+#include <linux/err.h>
+#include <linux/clk.h>
+#include <linux/suspend.h>
+#include <linux/cpu.h>
+#include <linux/platform_device.h>
+#include <linux/of.h>
+
+#include "tegra-cpufreq.h"
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
+static void tegra20_vote_emc_on_cpu_rate(unsigned long rate)
+{
+	if (rate >= 816000)
+		clk_set_rate(emc_clk, 600000000); /* cpu 816 MHz, emc max */
+	else if (rate >= 456000)
+		clk_set_rate(emc_clk, 300000000); /* cpu 456 MHz, emc 150Mhz */
+	else
+		clk_set_rate(emc_clk, 100000000);  /* emc 50Mhz */
+}
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
+static void tegra20_cpufreq_clk_init(void)
+{
+	clk_prepare_enable(emc_clk);
+	clk_prepare_enable(cpu_clk);
+}
+
+static void tegra20_cpufreq_clk_exit(void)
+{
+	clk_disable_unprepare(cpu_clk);
+	clk_disable_unprepare(emc_clk);
+}
+
+static const struct tegra_cpufreq_config tegra20_cpufreq_config = {
+	.vote_emc_on_cpu_rate = tegra20_vote_emc_on_cpu_rate,
+	.cpu_clk_set_rate = tegra20_cpu_clk_set_rate,
+	.cpufreq_clk_init = tegra20_cpufreq_clk_init,
+	.cpufreq_clk_exit = tegra20_cpufreq_clk_exit,
+};
+
+int tegra20_cpufreq_init(struct tegra_cpufreq_data *data,
+		const struct tegra_cpufreq_config **soc_config)
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
+	data->cpu_clk = cpu_clk;
+	data->freq_table = freq_table;
+	*soc_config = &tegra20_cpufreq_config;
+
+	return 0;
+}
+EXPORT_SYMBOL(tegra20_cpufreq_init);
-- 
1.7.9.5

