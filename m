Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755123Ab3ILLZe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 07:25:34 -0400
Received: from hqemgate15.nvidia.com ([216.228.121.64]:10149 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754955Ab3ILLZb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 07:25:31 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Thu, 12 Sep 2013 04:22:23 -0700
From: Bill Huang <bilhuang@nvidia.com>
To: <rjw@sisk.pl>, <viresh.kumar@linaro.org>, <swarren@wwwdotorg.org>
CC: <linux@arm.linux.org.uk>, <linux-arm-kernel@lists.infradead.org>,
        <linux-tegra@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <cpufreq@vger.kernel.org>, <linux-pm@vger.kernel.org>,
        Bill Huang <bilhuang@nvidia.com>
Subject: [PATCH v2 3/4] cpufreq: tegra: Re-model Tegra cpufreq driver
Date: Thu, 12 Sep 2013 04:24:50 -0700
Message-ID: <1378985091-9447-4-git-send-email-bilhuang@nvidia.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1378985091-9447-1-git-send-email-bilhuang@nvidia.com>
References: <1378985091-9447-1-git-send-email-bilhuang@nvidia.com>
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
 drivers/cpufreq/Kconfig.arm       |    8 +-
 drivers/cpufreq/Makefile          |    1 +
 drivers/cpufreq/tegra-cpufreq.c   |  176 +++++++++++++++++++------------------
 drivers/cpufreq/tegra-cpufreq.h   |   42 +++++++++
 drivers/cpufreq/tegra20-cpufreq.c |  138 +++++++++++++++++++++++++++++
 5 files changed, 278 insertions(+), 87 deletions(-)
 create mode 100644 drivers/cpufreq/tegra-cpufreq.h
 create mode 100644 drivers/cpufreq/tegra20-cpufreq.c

diff --git a/drivers/cpufreq/Kconfig.arm b/drivers/cpufreq/Kconfig.arm
index 0fa204b..09a80a4 100644
--- a/drivers/cpufreq/Kconfig.arm
+++ b/drivers/cpufreq/Kconfig.arm
@@ -232,6 +232,12 @@ config ARM_TEGRA_CPUFREQ
 	bool "TEGRA CPUFreq support"
 	depends on ARCH_TEGRA
 	select CPU_FREQ_TABLE
+
+config ARM_TEGRA20_CPUFREQ
+	bool "NVIDIA TEGRA20"
+	depends on ARM_TEGRA_CPUFREQ && ARCH_TEGRA_2x_SOC
 	default y
 	help
-	  This adds the CPUFreq driver support for TEGRA SOCs.
+	  This adds the CPUFreq driver for NVIDIA TEGRA20 SoC.
+
+	  If in doubt, say N.
diff --git a/drivers/cpufreq/Makefile b/drivers/cpufreq/Makefile
index ad5866c..22a85f0 100644
--- a/drivers/cpufreq/Makefile
+++ b/drivers/cpufreq/Makefile
@@ -77,6 +77,7 @@ obj-$(CONFIG_ARM_SA1100_CPUFREQ)	+= sa1100-cpufreq.o
 obj-$(CONFIG_ARM_SA1110_CPUFREQ)	+= sa1110-cpufreq.o
 obj-$(CONFIG_ARM_SPEAR_CPUFREQ)		+= spear-cpufreq.o
 obj-$(CONFIG_ARM_TEGRA_CPUFREQ)		+= tegra-cpufreq.o
+obj-$(CONFIG_ARM_TEGRA20_CPUFREQ)	+= tegra20-cpufreq.o
 
 ##################################################################################
 # PowerPC platform drivers
diff --git a/drivers/cpufreq/tegra-cpufreq.c b/drivers/cpufreq/tegra-cpufreq.c
index c2d2910..8616f6f 100644
--- a/drivers/cpufreq/tegra-cpufreq.c
+++ b/drivers/cpufreq/tegra-cpufreq.c
@@ -1,4 +1,5 @@
 /*
+ * Copyright (c) 2013, NVIDIA Corporation.
  * Copyright (C) 2010 Google, Inc.
  *
  * Author:
@@ -22,25 +23,16 @@
 #include <linux/err.h>
 #include <linux/clk.h>
 #include <linux/suspend.h>
+#include <linux/cpu.h>
+#include <linux/platform_device.h>
+#include <linux/of.h>
 
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
+#include "tegra-cpufreq.h"
 
 #define MAX_CPUS	4
 
-static struct clk *cpu_clk;
-static struct clk *pll_x_clk;
-static struct clk *pll_p_clk;
-static struct clk *emc_clk;
+static struct tegra_cpufreq_data *tegra_data;
+static const struct tegra_cpufreq_config *soc_config;
 
 static unsigned long target_cpu_speed[MAX_CPUS];
 static DEFINE_MUTEX(tegra_cpu_lock);
@@ -48,53 +40,17 @@ static bool is_suspended;
 
 static int tegra_verify_speed(struct cpufreq_policy *policy)
 {
-	return cpufreq_frequency_table_verify(policy, freq_table);
+	return cpufreq_frequency_table_verify(policy, tegra_data->freq_table);
 }
 
 static unsigned int tegra_getspeed(unsigned int cpu)
 {
 	unsigned long rate;
 
-	rate = clk_get_rate(cpu_clk) / 1000;
+	rate = clk_get_rate(tegra_data->cpu_clk) / 1000;
 	return rate;
 }
 
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
 static int tegra_update_cpu_speed(struct cpufreq_policy *policy,
 		unsigned long rate)
 {
@@ -111,12 +67,8 @@ static int tegra_update_cpu_speed(struct cpufreq_policy *policy,
 	 * Vote on memory bus frequency based on cpu frequency
 	 * This sets the minimum frequency, display or avp may request higher
 	 */
-	if (rate >= 816000)
-		clk_set_rate(emc_clk, 600000000); /* cpu 816 MHz, emc max */
-	else if (rate >= 456000)
-		clk_set_rate(emc_clk, 300000000); /* cpu 456 MHz, emc 150Mhz */
-	else
-		clk_set_rate(emc_clk, 100000000);  /* emc 50Mhz */
+	if (soc_config->vote_emc_on_cpu_rate)
+		soc_config->vote_emc_on_cpu_rate(rate);
 
 	cpufreq_notify_transition(policy, &freqs, CPUFREQ_PRECHANGE);
 
@@ -125,7 +77,7 @@ static int tegra_update_cpu_speed(struct cpufreq_policy *policy,
 	       freqs.old, freqs.new);
 #endif
 
-	ret = tegra_cpu_clk_set_rate(freqs.new * 1000);
+	ret = soc_config->cpu_clk_set_rate(freqs.new * 1000);
 	if (ret) {
 		pr_err("cpu-tegra: Failed to set cpu frequency to %d kHz\n",
 			freqs.new);
@@ -151,6 +103,7 @@ static int tegra_target(struct cpufreq_policy *policy,
 		       unsigned int target_freq,
 		       unsigned int relation)
 {
+	struct cpufreq_frequency_table *freq_table = tegra_data->freq_table;
 	unsigned int idx;
 	unsigned int freq;
 	int ret = 0;
@@ -162,8 +115,8 @@ static int tegra_target(struct cpufreq_policy *policy,
 		goto out;
 	}
 
-	cpufreq_frequency_table_target(policy, freq_table, target_freq,
-		relation, &idx);
+	cpufreq_frequency_table_target(policy, freq_table,
+			target_freq, relation, &idx);
 
 	freq = freq_table[idx].frequency;
 
@@ -179,6 +132,8 @@ out:
 static int tegra_pm_notify(struct notifier_block *nb, unsigned long event,
 	void *dummy)
 {
+	struct cpufreq_frequency_table *freq_table = tegra_data->freq_table;
+
 	mutex_lock(&tegra_cpu_lock);
 	if (event == PM_SUSPEND_PREPARE) {
 		struct cpufreq_policy *policy = cpufreq_cpu_get(0);
@@ -201,11 +156,11 @@ static struct notifier_block tegra_cpu_pm_notifier = {
 
 static int tegra_cpu_init(struct cpufreq_policy *policy)
 {
-	clk_prepare_enable(emc_clk);
-	clk_prepare_enable(cpu_clk);
+	if (soc_config->cpufreq_clk_init)
+		soc_config->cpufreq_clk_init();
 
-	cpufreq_frequency_table_cpuinfo(policy, freq_table);
-	cpufreq_frequency_table_get_attr(freq_table, policy->cpu);
+	cpufreq_frequency_table_cpuinfo(policy, tegra_data->freq_table);
+	cpufreq_frequency_table_get_attr(tegra_data->freq_table, policy->cpu);
 	policy->cur = tegra_getspeed(policy->cpu);
 	target_cpu_speed[policy->cpu] = policy->cur;
 
@@ -222,8 +177,9 @@ static int tegra_cpu_init(struct cpufreq_policy *policy)
 
 static int tegra_cpu_exit(struct cpufreq_policy *policy)
 {
-	cpufreq_frequency_table_cpuinfo(policy, freq_table);
-	clk_disable_unprepare(emc_clk);
+	cpufreq_frequency_table_cpuinfo(policy, tegra_data->freq_table);
+	if (soc_config->cpufreq_clk_exit)
+		soc_config->cpufreq_clk_exit();
 	return 0;
 }
 
@@ -242,27 +198,75 @@ static struct cpufreq_driver tegra_cpufreq_driver = {
 	.attr		= tegra_cpufreq_attr,
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
+	}
+	if (i == ARRAY_SIZE(tegra_init_funcs))
+		goto out;
+
+	ret = cpufreq_register_driver(&tegra_cpufreq_driver);
+	if (ret) {
+		dev_err(tegra_data->dev,
+			"%s: failed to register cpufreq driver\n", __func__);
+		goto out;
 	}
 
-	return cpufreq_register_driver(&tegra_cpufreq_driver);
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
+
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
index 0000000..820d5b1
--- /dev/null
+++ b/drivers/cpufreq/tegra-cpufreq.h
@@ -0,0 +1,42 @@
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
+ * You should have received a copy of the GNU General Public License
+ * along with this program.  If not, see <http://www.gnu.org/licenses/>.
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
index 0000000..9cf75a2
--- /dev/null
+++ b/drivers/cpufreq/tegra20-cpufreq.c
@@ -0,0 +1,138 @@
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
+ * You should have received a copy of the GNU General Public License
+ * along with this program.  If not, see <http://www.gnu.org/licenses/>.
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

