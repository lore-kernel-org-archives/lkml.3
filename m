Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755398Ab3IKLT4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 07:19:56 -0400
Received: from hqemgate15.nvidia.com ([216.228.121.64]:11835 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754813Ab3IKLTx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 07:19:53 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Wed, 11 Sep 2013 04:19:52 -0700
From: Bill Huang <bilhuang@nvidia.com>
To: <rjw@sisk.pl>, <viresh.kumar@linaro.org>, <swarren@wwwdotorg.org>
CC: <linux@arm.linux.org.uk>, <linux-arm-kernel@lists.infradead.org>,
        <linux-tegra@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <cpufreq@vger.kernel.org>, <linux-pm@vger.kernel.org>,
        Bill Huang <bilhuang@nvidia.com>
Subject: [PATCH 2/2] cpufreq: tegra: Re-model Tegra cpufreq driver
Date: Wed, 11 Sep 2013 04:19:14 -0700
Message-ID: <1378898355-31290-3-git-send-email-bilhuang@nvidia.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1378898355-31290-1-git-send-email-bilhuang@nvidia.com>
References: <1378898355-31290-1-git-send-email-bilhuang@nvidia.com>
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
* Call tegra_cpufreq_init() in Tegra machine code specifically so it
  won't be called in multi-platform kernel which is not running on Tegra
  SoCs.

Signed-off-by: Bill Huang <bilhuang@nvidia.com>
---
 arch/arm/mach-tegra/common.c      |    2 +
 drivers/cpufreq/Kconfig.arm       |   16 +++-
 drivers/cpufreq/Makefile          |    1 +
 drivers/cpufreq/tegra-cpufreq.c   |  178 ++++++++++++++++++-------------------
 drivers/cpufreq/tegra-cpufreq.h   |   37 ++++++++
 drivers/cpufreq/tegra20-cpufreq.c |  133 +++++++++++++++++++++++++++
 include/linux/tegra-soc.h         |   11 ++-
 7 files changed, 281 insertions(+), 97 deletions(-)
 create mode 100644 drivers/cpufreq/tegra-cpufreq.h
 create mode 100644 drivers/cpufreq/tegra20-cpufreq.c

diff --git a/arch/arm/mach-tegra/common.c b/arch/arm/mach-tegra/common.c
index 94a119a..db4414e 100644
--- a/arch/arm/mach-tegra/common.c
+++ b/arch/arm/mach-tegra/common.c
@@ -25,6 +25,7 @@
 #include <linux/reboot.h>
 #include <linux/irqchip.h>
 #include <linux/clk-provider.h>
+#include <linux/tegra-soc.h>
 
 #include <asm/hardware/cache-l2x0.h>
 
@@ -109,6 +110,7 @@ void __init tegra_init_early(void)
 
 void __init tegra_init_late(void)
 {
+	tegra_cpufreq_init();
 	tegra_init_suspend();
 	tegra_cpuidle_init();
 	tegra_powergate_debugfs_init();
diff --git a/drivers/cpufreq/Kconfig.arm b/drivers/cpufreq/Kconfig.arm
index 0fa204b..d62902a 100644
--- a/drivers/cpufreq/Kconfig.arm
+++ b/drivers/cpufreq/Kconfig.arm
@@ -229,9 +229,19 @@ config ARM_SPEAR_CPUFREQ
 	  This adds the CPUFreq driver support for SPEAr SOCs.
 
 config ARM_TEGRA_CPUFREQ
-	bool "TEGRA CPUFreq support"
-	depends on ARCH_TEGRA
+	bool
+	select CPU_FREQ_TABLE
+
+config ARM_EXYNOS_CPUFREQ
+	bool
 	select CPU_FREQ_TABLE
+
+config ARM_TEGRA20_CPUFREQ
+	bool "NVIDIA TEGRA20"
+	depends on ARCH_TEGRA
 	default y
+	select ARM_TEGRA_CPUFREQ
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
index 6eb3dd8..d40428a 100644
--- a/drivers/cpufreq/tegra-cpufreq.c
+++ b/drivers/cpufreq/tegra-cpufreq.c
@@ -23,25 +23,15 @@
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
 
-#define NUM_CPUS	2
+#define NUM_CPUS	4
 
-static struct clk *cpu_clk;
-static struct clk *pll_x_clk;
-static struct clk *pll_p_clk;
-static struct clk *emc_clk;
+static struct tegra_cpufreq_data *tegra_data;
 
 static unsigned long target_cpu_speed[NUM_CPUS];
 static DEFINE_MUTEX(tegra_cpu_lock);
@@ -49,53 +39,17 @@ static bool is_suspended;
 
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
@@ -112,12 +66,8 @@ static int tegra_update_cpu_speed(struct cpufreq_policy *policy,
 	 * Vote on memory bus frequency based on cpu frequency
 	 * This sets the minimum frequency, display or avp may request higher
 	 */
-	if (rate >= 816000)
-		clk_set_rate(emc_clk, 600000000); /* cpu 816 MHz, emc max */
-	else if (rate >= 456000)
-		clk_set_rate(emc_clk, 300000000); /* cpu 456 MHz, emc 150Mhz */
-	else
-		clk_set_rate(emc_clk, 100000000);  /* emc 50Mhz */
+	if (tegra_data->vote_emc_on_cpu_rate)
+		tegra_data->vote_emc_on_cpu_rate(rate);
 
 	cpufreq_notify_transition(policy, &freqs, CPUFREQ_PRECHANGE);
 
@@ -126,7 +76,7 @@ static int tegra_update_cpu_speed(struct cpufreq_policy *policy,
 	       freqs.old, freqs.new);
 #endif
 
-	ret = tegra_cpu_clk_set_rate(freqs.new * 1000);
+	ret = tegra_data->cpu_clk_set_rate(freqs.new * 1000);
 	if (ret) {
 		pr_err("cpu-tegra: Failed to set cpu frequency to %d kHz\n",
 			freqs.new);
@@ -152,6 +102,7 @@ static int tegra_target(struct cpufreq_policy *policy,
 		       unsigned int target_freq,
 		       unsigned int relation)
 {
+	struct cpufreq_frequency_table *freq_table = tegra_data->freq_table;
 	unsigned int idx;
 	unsigned int freq;
 	int ret = 0;
@@ -163,8 +114,8 @@ static int tegra_target(struct cpufreq_policy *policy,
 		goto out;
 	}
 
-	cpufreq_frequency_table_target(policy, freq_table, target_freq,
-		relation, &idx);
+	cpufreq_frequency_table_target(policy, freq_table,
+			target_freq, relation, &idx);
 
 	freq = freq_table[idx].frequency;
 
@@ -180,6 +131,8 @@ out:
 static int tegra_pm_notify(struct notifier_block *nb, unsigned long event,
 	void *dummy)
 {
+	struct cpufreq_frequency_table *freq_table = tegra_data->freq_table;
+
 	mutex_lock(&tegra_cpu_lock);
 	if (event == PM_SUSPEND_PREPARE) {
 		struct cpufreq_policy *policy = cpufreq_cpu_get(0);
@@ -202,11 +155,11 @@ static struct notifier_block tegra_cpu_pm_notifier = {
 
 static int tegra_cpu_init(struct cpufreq_policy *policy)
 {
-	clk_prepare_enable(emc_clk);
-	clk_prepare_enable(cpu_clk);
+	if (tegra_data->cpufreq_clk_init)
+		tegra_data->cpufreq_clk_init();
 
-	cpufreq_frequency_table_cpuinfo(policy, freq_table);
-	cpufreq_frequency_table_get_attr(freq_table, policy->cpu);
+	cpufreq_frequency_table_cpuinfo(policy, tegra_data->freq_table);
+	cpufreq_frequency_table_get_attr(tegra_data->freq_table, policy->cpu);
 	policy->cur = tegra_getspeed(policy->cpu);
 	target_cpu_speed[policy->cpu] = policy->cur;
 
@@ -223,8 +176,9 @@ static int tegra_cpu_init(struct cpufreq_policy *policy)
 
 static int tegra_cpu_exit(struct cpufreq_policy *policy)
 {
-	cpufreq_frequency_table_cpuinfo(policy, freq_table);
-	clk_disable_unprepare(emc_clk);
+	cpufreq_frequency_table_cpuinfo(policy, tegra_data->freq_table);
+	if (tegra_data->cpufreq_clk_exit)
+		tegra_data->cpufreq_clk_exit();
 	return 0;
 }
 
@@ -243,39 +197,77 @@ static struct cpufreq_driver tegra_cpufreq_driver = {
 	.attr		= tegra_cpufreq_attr,
 };
 
-static int __init tegra_cpufreq_init(void)
+static struct {
+	char *compat;
+	int (*init)(struct tegra_cpufreq_data *);
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
+			ret = tegra_init_funcs[i].init(tegra_data);
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
 }
 
-static void __exit tegra_cpufreq_exit(void)
+static int tegra_cpufreq_remove(struct platform_device *pdev)
 {
-        cpufreq_unregister_driver(&tegra_cpufreq_driver);
-	clk_put(emc_clk);
-	clk_put(cpu_clk);
+	cpufreq_unregister_driver(&tegra_cpufreq_driver);
+	return 0;
 }
 
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
+}
+EXPORT_SYMBOL(tegra_cpufreq_init);
 
 MODULE_AUTHOR("Colin Cross <ccross@android.com>");
 MODULE_DESCRIPTION("cpufreq driver for Nvidia Tegra2");
 MODULE_LICENSE("GPL");
-module_init(tegra_cpufreq_init);
-module_exit(tegra_cpufreq_exit);
diff --git a/drivers/cpufreq/tegra-cpufreq.h b/drivers/cpufreq/tegra-cpufreq.h
new file mode 100644
index 0000000..4de091f
--- /dev/null
+++ b/drivers/cpufreq/tegra-cpufreq.h
@@ -0,0 +1,37 @@
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
+struct tegra_cpufreq_data {
+	struct device *dev;
+	struct clk	*cpu_clk;
+	struct cpufreq_frequency_table	*freq_table;
+	void (*vote_emc_on_cpu_rate)(unsigned long);
+	int (*cpu_clk_set_rate)(unsigned long);
+	void (*cpufreq_clk_init)(void);
+	void (*cpufreq_clk_exit)(void);
+};
+
+#ifdef CONFIG_ARM_TEGRA20_CPUFREQ
+int tegra20_cpufreq_init(struct tegra_cpufreq_data *data);
+#else
+static inline int tegra20_cpufreq_init(struct tegra_cpufreq_data *data)
+{ return -EOPNOTSUPP; }
+#endif
+
+#endif /* __LINUX_TEGRA_CPUFREQ_H_ */
diff --git a/drivers/cpufreq/tegra20-cpufreq.c b/drivers/cpufreq/tegra20-cpufreq.c
new file mode 100644
index 0000000..ffc2ba6
--- /dev/null
+++ b/drivers/cpufreq/tegra20-cpufreq.c
@@ -0,0 +1,133 @@
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
+int tegra20_cpufreq_init(struct tegra_cpufreq_data *data)
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
+	data->vote_emc_on_cpu_rate = tegra20_vote_emc_on_cpu_rate;
+	data->cpu_clk_set_rate = tegra20_cpu_clk_set_rate;
+	data->cpufreq_clk_init = tegra20_cpufreq_clk_init;
+	data->cpufreq_clk_exit = tegra20_cpufreq_clk_exit;
+
+	return 0;
+}
+EXPORT_SYMBOL(tegra20_cpufreq_init);
diff --git a/include/linux/tegra-soc.h b/include/linux/tegra-soc.h
index 95f611d..015b905 100644
--- a/include/linux/tegra-soc.h
+++ b/include/linux/tegra-soc.h
@@ -1,5 +1,5 @@
 /*
- * Copyright (c) 2012, NVIDIA CORPORATION.  All rights reserved.
+ * Copyright (c) 2012,2013, NVIDIA CORPORATION.  All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms and conditions of the GNU General Public License,
@@ -19,4 +19,13 @@
 
 u32 tegra_read_chipid(void);
 
+#ifdef CONFIG_ARM_TEGRA_CPUFREQ
+int tegra_cpufreq_init(void);
+#else
+static inline int tegra_cpufreq_init(void)
+{
+	retrun EOPNOTSUPP;
+}
+#endif
+
 #endif /* __LINUX_TEGRA_SOC_H_ */
-- 
1.7.9.5

