Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756661AbaAGByp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 20:54:45 -0500
Received: from mail-pb0-f52.google.com ([209.85.160.52]:35817 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756475AbaAGByl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 20:54:41 -0500
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@rjwysocki.net
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH V3 Resend] cpufreq: create cpufreq_generic_get() routine
Date: Tue,  7 Jan 2014 07:24:32 +0530
Message-Id: <d9239e0a5df99392647ff8343673342f89d09476.1389059568.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CPUFreq drivers that use clock frameworks interface,i.e. clk_get_rate(), to get
CPUs clk rate, has similar sort of code used for most of them.

This patch adds a generic ->get() which will do the same thing for them. All
those drivers are required to now is to set .get to cpufreq_generic_get() and
set their clk pointer in policy->clk during ->init().

Acked-by: Hans-Christian Egtvedt <egtvedt@samfundet.no>
Acked-by: Shawn Guo <shawn.guo@linaro.org>
Acked-by: Linus Walleij <linus.walleij@linaro.org>
Acked-by: Shawn Guo <shawn.guo@linaro.org>
Acked-by: Stephen Warren <swarren@nvidia.com>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
Rafael,

V2->V3: As asked by you earlier, I have merged all 23 patches here as they had
common log and were touching separate drivers. This is already acked by many
people.  Please see if looks okay for 3.14.

 drivers/cpufreq/at32ap-cpufreq.c      | 17 ++++---------
 drivers/cpufreq/cpufreq-cpu0.c        |  8 ++----
 drivers/cpufreq/cpufreq.c             | 26 ++++++++++++++-----
 drivers/cpufreq/davinci-cpufreq.c     | 14 +++-------
 drivers/cpufreq/dbx500-cpufreq.c      | 19 ++------------
 drivers/cpufreq/exynos-cpufreq.c      | 10 +++-----
 drivers/cpufreq/exynos5440-cpufreq.c  | 33 ++++++++++--------------
 drivers/cpufreq/imx6q-cpufreq.c       |  8 ++----
 drivers/cpufreq/loongson2_cpufreq.c   | 15 ++++-------
 drivers/cpufreq/omap-cpufreq.c        | 32 ++++++++---------------
 drivers/cpufreq/ppc-corenet-cpufreq.c | 17 +++----------
 drivers/cpufreq/s3c24xx-cpufreq.c     | 10 +++-----
 drivers/cpufreq/s3c64xx-cpufreq.c     | 33 +++++++++---------------
 drivers/cpufreq/s5pv210-cpufreq.c     | 21 +++++----------
 drivers/cpufreq/spear-cpufreq.c       |  8 ++----
 drivers/cpufreq/tegra-cpufreq.c       | 48 ++++++-----------------------------
 drivers/cpufreq/unicore2-cpufreq.c    | 19 +++++---------
 include/linux/cpufreq.h               |  3 +++
 18 files changed, 112 insertions(+), 229 deletions(-)

diff --git a/drivers/cpufreq/at32ap-cpufreq.c b/drivers/cpufreq/at32ap-cpufreq.c
index 7c03dd8..a1c79f5 100644
--- a/drivers/cpufreq/at32ap-cpufreq.c
+++ b/drivers/cpufreq/at32ap-cpufreq.c
@@ -21,17 +21,8 @@
 #include <linux/export.h>
 #include <linux/slab.h>
 
-static struct clk *cpuclk;
 static struct cpufreq_frequency_table *freq_table;
 
-static unsigned int at32_get_speed(unsigned int cpu)
-{
-	/* No SMP support */
-	if (cpu)
-		return 0;
-	return (unsigned int)((clk_get_rate(cpuclk) + 500) / 1000);
-}
-
 static unsigned int	ref_freq;
 static unsigned long	loops_per_jiffy_ref;
 
@@ -39,7 +30,7 @@ static int at32_set_target(struct cpufreq_policy *policy, unsigned int index)
 {
 	unsigned int old_freq, new_freq;
 
-	old_freq = at32_get_speed(0);
+	old_freq = policy->cur;
 	new_freq = freq_table[index].frequency;
 
 	if (!ref_freq) {
@@ -50,7 +41,7 @@ static int at32_set_target(struct cpufreq_policy *policy, unsigned int index)
 	if (old_freq < new_freq)
 		boot_cpu_data.loops_per_jiffy = cpufreq_scale(
 				loops_per_jiffy_ref, ref_freq, new_freq);
-	clk_set_rate(cpuclk, new_freq * 1000);
+	clk_set_rate(policy->clk, new_freq * 1000);
 	if (new_freq < old_freq)
 		boot_cpu_data.loops_per_jiffy = cpufreq_scale(
 				loops_per_jiffy_ref, ref_freq, new_freq);
@@ -61,6 +52,7 @@ static int at32_set_target(struct cpufreq_policy *policy, unsigned int index)
 static int at32_cpufreq_driver_init(struct cpufreq_policy *policy)
 {
 	unsigned int frequency, rate, min_freq;
+	static struct clk *cpuclk;
 	int retval, steps, i;
 
 	if (policy->cpu != 0)
@@ -103,6 +95,7 @@ static int at32_cpufreq_driver_init(struct cpufreq_policy *policy)
 		frequency /= 2;
 	}
 
+	policy->clk = cpuclk;
 	freq_table[steps - 1].frequency = CPUFREQ_TABLE_END;
 
 	retval = cpufreq_table_validate_and_show(policy, freq_table);
@@ -123,7 +116,7 @@ static struct cpufreq_driver at32_driver = {
 	.init		= at32_cpufreq_driver_init,
 	.verify		= cpufreq_generic_frequency_table_verify,
 	.target_index	= at32_set_target,
-	.get		= at32_get_speed,
+	.get		= cpufreq_generic_get,
 	.flags		= CPUFREQ_STICKY,
 };
 
diff --git a/drivers/cpufreq/cpufreq-cpu0.c b/drivers/cpufreq/cpufreq-cpu0.c
index 0faf756..bb7b308 100644
--- a/drivers/cpufreq/cpufreq-cpu0.c
+++ b/drivers/cpufreq/cpufreq-cpu0.c
@@ -30,11 +30,6 @@ static struct clk *cpu_clk;
 static struct regulator *cpu_reg;
 static struct cpufreq_frequency_table *freq_table;
 
-static unsigned int cpu0_get_speed(unsigned int cpu)
-{
-	return clk_get_rate(cpu_clk) / 1000;
-}
-
 static int cpu0_set_target(struct cpufreq_policy *policy, unsigned int index)
 {
 	struct dev_pm_opp *opp;
@@ -100,6 +95,7 @@ static int cpu0_set_target(struct cpufreq_policy *policy, unsigned int index)
 
 static int cpu0_cpufreq_init(struct cpufreq_policy *policy)
 {
+	policy->clk = cpu_clk;
 	return cpufreq_generic_init(policy, freq_table, transition_latency);
 }
 
@@ -107,7 +103,7 @@ static struct cpufreq_driver cpu0_cpufreq_driver = {
 	.flags = CPUFREQ_STICKY,
 	.verify = cpufreq_generic_frequency_table_verify,
 	.target_index = cpu0_set_target,
-	.get = cpu0_get_speed,
+	.get = cpufreq_generic_get,
 	.init = cpu0_cpufreq_init,
 	.exit = cpufreq_generic_exit,
 	.name = "generic_cpu0",
diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index 3509ca0..b7e366d 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -176,6 +176,20 @@ int cpufreq_generic_init(struct cpufreq_policy *policy,
 }
 EXPORT_SYMBOL_GPL(cpufreq_generic_init);
 
+unsigned int cpufreq_generic_get(unsigned int cpu)
+{
+	struct cpufreq_policy *policy = per_cpu(cpufreq_cpu_data, cpu);
+
+	if (!policy || IS_ERR(policy->clk)) {
+		pr_err("%s: No %s associated to cpu: %d\n", __func__,
+				policy ? "clk" : "policy", cpu);
+		return 0;
+	}
+
+	return clk_get_rate(policy->clk) / 1000;
+}
+EXPORT_SYMBOL_GPL(cpufreq_generic_get);
+
 struct cpufreq_policy *cpufreq_cpu_get(unsigned int cpu)
 {
 	struct cpufreq_policy *policy = NULL;
@@ -1065,6 +1079,11 @@ static int __cpufreq_add_dev(struct device *dev, struct subsys_interface *sif,
 		goto err_set_policy_cpu;
 	}
 
+	write_lock_irqsave(&cpufreq_driver_lock, flags);
+	for_each_cpu(j, policy->cpus)
+		per_cpu(cpufreq_cpu_data, j) = policy;
+	write_unlock_irqrestore(&cpufreq_driver_lock, flags);
+
 	if (cpufreq_driver->get) {
 		policy->cur = cpufreq_driver->get(policy->cpu);
 		if (!policy->cur) {
@@ -1139,11 +1158,6 @@ static int __cpufreq_add_dev(struct device *dev, struct subsys_interface *sif,
 	}
 #endif
 
-	write_lock_irqsave(&cpufreq_driver_lock, flags);
-	for_each_cpu(j, policy->cpus)
-		per_cpu(cpufreq_cpu_data, j) = policy;
-	write_unlock_irqrestore(&cpufreq_driver_lock, flags);
-
 	if (!frozen) {
 		ret = cpufreq_add_dev_interface(policy, dev);
 		if (ret)
@@ -1169,12 +1183,12 @@ static int __cpufreq_add_dev(struct device *dev, struct subsys_interface *sif,
 	return 0;
 
 err_out_unregister:
+err_get_freq:
 	write_lock_irqsave(&cpufreq_driver_lock, flags);
 	for_each_cpu(j, policy->cpus)
 		per_cpu(cpufreq_cpu_data, j) = NULL;
 	write_unlock_irqrestore(&cpufreq_driver_lock, flags);
 
-err_get_freq:
 	if (cpufreq_driver->exit)
 		cpufreq_driver->exit(policy);
 err_set_policy_cpu:
diff --git a/drivers/cpufreq/davinci-cpufreq.c b/drivers/cpufreq/davinci-cpufreq.c
index 04f3390..2cf3384 100644
--- a/drivers/cpufreq/davinci-cpufreq.c
+++ b/drivers/cpufreq/davinci-cpufreq.c
@@ -58,14 +58,6 @@ static int davinci_verify_speed(struct cpufreq_policy *policy)
 	return 0;
 }
 
-static unsigned int davinci_getspeed(unsigned int cpu)
-{
-	if (cpu)
-		return 0;
-
-	return clk_get_rate(cpufreq.armclk) / 1000;
-}
-
 static int davinci_target(struct cpufreq_policy *policy, unsigned int idx)
 {
 	struct davinci_cpufreq_config *pdata = cpufreq.dev->platform_data;
@@ -73,7 +65,7 @@ static int davinci_target(struct cpufreq_policy *policy, unsigned int idx)
 	unsigned int old_freq, new_freq;
 	int ret = 0;
 
-	old_freq = davinci_getspeed(0);
+	old_freq = policy->cur;
 	new_freq = pdata->freq_table[idx].frequency;
 
 	/* if moving to higher frequency, up the voltage beforehand */
@@ -116,6 +108,8 @@ static int davinci_cpu_init(struct cpufreq_policy *policy)
 			return result;
 	}
 
+	policy->clk = cpufreq.armclk;
+
 	/*
 	 * Time measurement across the target() function yields ~1500-1800us
 	 * time taken with no drivers on notification list.
@@ -129,7 +123,7 @@ static struct cpufreq_driver davinci_driver = {
 	.flags		= CPUFREQ_STICKY | CPUFREQ_NEED_INITIAL_FREQ_CHECK,
 	.verify		= davinci_verify_speed,
 	.target_index	= davinci_target,
-	.get		= davinci_getspeed,
+	.get		= cpufreq_generic_get,
 	.init		= davinci_cpu_init,
 	.exit		= cpufreq_generic_exit,
 	.name		= "davinci",
diff --git a/drivers/cpufreq/dbx500-cpufreq.c b/drivers/cpufreq/dbx500-cpufreq.c
index 21d9898..412a78b 100644
--- a/drivers/cpufreq/dbx500-cpufreq.c
+++ b/drivers/cpufreq/dbx500-cpufreq.c
@@ -26,24 +26,9 @@ static int dbx500_cpufreq_target(struct cpufreq_policy *policy,
 	return clk_set_rate(armss_clk, freq_table[index].frequency * 1000);
 }
 
-static unsigned int dbx500_cpufreq_getspeed(unsigned int cpu)
-{
-	int i = 0;
-	unsigned long freq = clk_get_rate(armss_clk) / 1000;
-
-	/* The value is rounded to closest frequency in the defined table. */
-	while (freq_table[i + 1].frequency != CPUFREQ_TABLE_END) {
-		if (freq < freq_table[i].frequency +
-		   (freq_table[i + 1].frequency - freq_table[i].frequency) / 2)
-			return freq_table[i].frequency;
-		i++;
-	}
-
-	return freq_table[i].frequency;
-}
-
 static int dbx500_cpufreq_init(struct cpufreq_policy *policy)
 {
+	policy->clk = armss_clk;
 	return cpufreq_generic_init(policy, freq_table, 20 * 1000);
 }
 
@@ -52,7 +37,7 @@ static struct cpufreq_driver dbx500_cpufreq_driver = {
 			CPUFREQ_NEED_INITIAL_FREQ_CHECK,
 	.verify = cpufreq_generic_frequency_table_verify,
 	.target_index = dbx500_cpufreq_target,
-	.get    = dbx500_cpufreq_getspeed,
+	.get    = cpufreq_generic_get,
 	.init   = dbx500_cpufreq_init,
 	.name   = "DBX500",
 	.attr   = cpufreq_generic_attr,
diff --git a/drivers/cpufreq/exynos-cpufreq.c b/drivers/cpufreq/exynos-cpufreq.c
index f7c322c..4ee3804 100644
--- a/drivers/cpufreq/exynos-cpufreq.c
+++ b/drivers/cpufreq/exynos-cpufreq.c
@@ -31,11 +31,6 @@ static unsigned int locking_frequency;
 static bool frequency_locked;
 static DEFINE_MUTEX(cpufreq_lock);
 
-static unsigned int exynos_getspeed(unsigned int cpu)
-{
-	return clk_get_rate(exynos_info->cpu_clk) / 1000;
-}
-
 static int exynos_cpufreq_get_index(unsigned int freq)
 {
 	struct cpufreq_frequency_table *freq_table = exynos_info->freq_table;
@@ -215,6 +210,7 @@ static struct notifier_block exynos_cpufreq_nb = {
 
 static int exynos_cpufreq_cpu_init(struct cpufreq_policy *policy)
 {
+	policy->clk = exynos_info->cpu_clk;
 	return cpufreq_generic_init(policy, exynos_info->freq_table, 100000);
 }
 
@@ -222,7 +218,7 @@ static struct cpufreq_driver exynos_driver = {
 	.flags		= CPUFREQ_STICKY | CPUFREQ_NEED_INITIAL_FREQ_CHECK,
 	.verify		= cpufreq_generic_frequency_table_verify,
 	.target_index	= exynos_target,
-	.get		= exynos_getspeed,
+	.get		= cpufreq_generic_get,
 	.init		= exynos_cpufreq_cpu_init,
 	.exit		= cpufreq_generic_exit,
 	.name		= "exynos_cpufreq",
@@ -264,7 +260,7 @@ static int exynos_cpufreq_probe(struct platform_device *pdev)
 		goto err_vdd_arm;
 	}
 
-	locking_frequency = exynos_getspeed(0);
+	locking_frequency = clk_get_rate(exynos_info->cpu_clk) / 1000;
 
 	register_pm_notifier(&exynos_cpufreq_nb);
 
diff --git a/drivers/cpufreq/exynos5440-cpufreq.c b/drivers/cpufreq/exynos5440-cpufreq.c
index ffe6fae..49b75601 100644
--- a/drivers/cpufreq/exynos5440-cpufreq.c
+++ b/drivers/cpufreq/exynos5440-cpufreq.c
@@ -100,7 +100,6 @@ struct exynos_dvfs_data {
 	struct resource *mem;
 	int irq;
 	struct clk *cpu_clk;
-	unsigned int cur_frequency;
 	unsigned int latency;
 	struct cpufreq_frequency_table *freq_table;
 	unsigned int freq_count;
@@ -165,7 +164,7 @@ static int init_div_table(void)
 	return 0;
 }
 
-static void exynos_enable_dvfs(void)
+static void exynos_enable_dvfs(unsigned int cur_frequency)
 {
 	unsigned int tmp, i, cpu;
 	struct cpufreq_frequency_table *freq_table = dvfs_info->freq_table;
@@ -184,18 +183,18 @@ static void exynos_enable_dvfs(void)
 
 	/* Set initial performance index */
 	for (i = 0; freq_table[i].frequency != CPUFREQ_TABLE_END; i++)
-		if (freq_table[i].frequency == dvfs_info->cur_frequency)
+		if (freq_table[i].frequency == cur_frequency)
 			break;
 
 	if (freq_table[i].frequency == CPUFREQ_TABLE_END) {
 		dev_crit(dvfs_info->dev, "Boot up frequency not supported\n");
 		/* Assign the highest frequency */
 		i = 0;
-		dvfs_info->cur_frequency = freq_table[i].frequency;
+		cur_frequency = freq_table[i].frequency;
 	}
 
 	dev_info(dvfs_info->dev, "Setting dvfs initial frequency = %uKHZ",
-						dvfs_info->cur_frequency);
+						cur_frequency);
 
 	for (cpu = 0; cpu < CONFIG_NR_CPUS; cpu++) {
 		tmp = __raw_readl(dvfs_info->base + XMU_C0_3_PSTATE + cpu * 4);
@@ -209,11 +208,6 @@ static void exynos_enable_dvfs(void)
 				dvfs_info->base + XMU_DVFS_CTRL);
 }
 
-static unsigned int exynos_getspeed(unsigned int cpu)
-{
-	return dvfs_info->cur_frequency;
-}
-
 static int exynos_target(struct cpufreq_policy *policy, unsigned int index)
 {
 	unsigned int tmp;
@@ -222,7 +216,7 @@ static int exynos_target(struct cpufreq_policy *policy, unsigned int index)
 
 	mutex_lock(&cpufreq_lock);
 
-	freqs.old = dvfs_info->cur_frequency;
+	freqs.old = policy->cur;
 	freqs.new = freq_table[index].frequency;
 
 	cpufreq_notify_transition(policy, &freqs, CPUFREQ_PRECHANGE);
@@ -250,7 +244,7 @@ static void exynos_cpufreq_work(struct work_struct *work)
 		goto skip_work;
 
 	mutex_lock(&cpufreq_lock);
-	freqs.old = dvfs_info->cur_frequency;
+	freqs.old = policy->cur;
 
 	cur_pstate = __raw_readl(dvfs_info->base + XMU_P_STATUS);
 	if (cur_pstate >> C0_3_PSTATE_VALID_SHIFT & 0x1)
@@ -260,10 +254,9 @@ static void exynos_cpufreq_work(struct work_struct *work)
 
 	if (likely(index < dvfs_info->freq_count)) {
 		freqs.new = freq_table[index].frequency;
-		dvfs_info->cur_frequency = freqs.new;
 	} else {
 		dev_crit(dvfs_info->dev, "New frequency out of range\n");
-		freqs.new = dvfs_info->cur_frequency;
+		freqs.new = freqs.old;
 	}
 	cpufreq_notify_transition(policy, &freqs, CPUFREQ_POSTCHANGE);
 
@@ -307,6 +300,7 @@ static void exynos_sort_descend_freq_table(void)
 
 static int exynos_cpufreq_cpu_init(struct cpufreq_policy *policy)
 {
+	policy->clk = dvfs_info->cpu_clk;
 	return cpufreq_generic_init(policy, dvfs_info->freq_table,
 			dvfs_info->latency);
 }
@@ -316,7 +310,7 @@ static struct cpufreq_driver exynos_driver = {
 				CPUFREQ_NEED_INITIAL_FREQ_CHECK,
 	.verify		= cpufreq_generic_frequency_table_verify,
 	.target_index	= exynos_target,
-	.get		= exynos_getspeed,
+	.get		= cpufreq_generic_get,
 	.init		= exynos_cpufreq_cpu_init,
 	.exit		= cpufreq_generic_exit,
 	.name		= CPUFREQ_NAME,
@@ -336,6 +330,7 @@ static int exynos_cpufreq_probe(struct platform_device *pdev)
 	int ret = -EINVAL;
 	struct device_node *np;
 	struct resource res;
+	unsigned int cur_frequency;
 
 	np =  pdev->dev.of_node;
 	if (!np)
@@ -392,13 +387,13 @@ static int exynos_cpufreq_probe(struct platform_device *pdev)
 		goto err_free_table;
 	}
 
-	dvfs_info->cur_frequency = clk_get_rate(dvfs_info->cpu_clk);
-	if (!dvfs_info->cur_frequency) {
+	cur_frequency = clk_get_rate(dvfs_info->cpu_clk);
+	if (!cur_frequency) {
 		dev_err(dvfs_info->dev, "Failed to get clock rate\n");
 		ret = -EINVAL;
 		goto err_free_table;
 	}
-	dvfs_info->cur_frequency /= 1000;
+	cur_frequency /= 1000;
 
 	INIT_WORK(&dvfs_info->irq_work, exynos_cpufreq_work);
 	ret = devm_request_irq(dvfs_info->dev, dvfs_info->irq,
@@ -415,7 +410,7 @@ static int exynos_cpufreq_probe(struct platform_device *pdev)
 		goto err_free_table;
 	}
 
-	exynos_enable_dvfs();
+	exynos_enable_dvfs(cur_frequency);
 	ret = cpufreq_register_driver(&exynos_driver);
 	if (ret) {
 		dev_err(dvfs_info->dev,
diff --git a/drivers/cpufreq/imx6q-cpufreq.c b/drivers/cpufreq/imx6q-cpufreq.c
index 2938257..ce69059 100644
--- a/drivers/cpufreq/imx6q-cpufreq.c
+++ b/drivers/cpufreq/imx6q-cpufreq.c
@@ -38,11 +38,6 @@ static unsigned int transition_latency;
 static u32 *imx6_soc_volt;
 static u32 soc_opp_count;
 
-static unsigned int imx6q_get_speed(unsigned int cpu)
-{
-	return clk_get_rate(arm_clk) / 1000;
-}
-
 static int imx6q_set_target(struct cpufreq_policy *policy, unsigned int index)
 {
 	struct dev_pm_opp *opp;
@@ -139,6 +134,7 @@ static int imx6q_set_target(struct cpufreq_policy *policy, unsigned int index)
 
 static int imx6q_cpufreq_init(struct cpufreq_policy *policy)
 {
+	policy->clk = arm_clk;
 	return cpufreq_generic_init(policy, freq_table, transition_latency);
 }
 
@@ -146,7 +142,7 @@ static struct cpufreq_driver imx6q_cpufreq_driver = {
 	.flags = CPUFREQ_NEED_INITIAL_FREQ_CHECK,
 	.verify = cpufreq_generic_frequency_table_verify,
 	.target_index = imx6q_set_target,
-	.get = imx6q_get_speed,
+	.get = cpufreq_generic_get,
 	.init = imx6q_cpufreq_init,
 	.exit = cpufreq_generic_exit,
 	.name = "imx6q-cpufreq",
diff --git a/drivers/cpufreq/loongson2_cpufreq.c b/drivers/cpufreq/loongson2_cpufreq.c
index a436092..b6581ab 100644
--- a/drivers/cpufreq/loongson2_cpufreq.c
+++ b/drivers/cpufreq/loongson2_cpufreq.c
@@ -24,8 +24,6 @@
 
 static uint nowait;
 
-static struct clk *cpuclk;
-
 static void (*saved_cpu_wait) (void);
 
 static int loongson2_cpu_freq_notifier(struct notifier_block *nb,
@@ -44,11 +42,6 @@ static int loongson2_cpu_freq_notifier(struct notifier_block *nb,
 	return 0;
 }
 
-static unsigned int loongson2_cpufreq_get(unsigned int cpu)
-{
-	return clk_get_rate(cpuclk);
-}
-
 /*
  * Here we notify other drivers of the proposed change and the final change.
  */
@@ -69,13 +62,14 @@ static int loongson2_cpufreq_target(struct cpufreq_policy *policy,
 	set_cpus_allowed_ptr(current, &cpus_allowed);
 
 	/* setting the cpu frequency */
-	clk_set_rate(cpuclk, freq);
+	clk_set_rate(policy->clk, freq);
 
 	return 0;
 }
 
 static int loongson2_cpufreq_cpu_init(struct cpufreq_policy *policy)
 {
+	static struct clk *cpuclk;
 	int i;
 	unsigned long rate;
 	int ret;
@@ -104,13 +98,14 @@ static int loongson2_cpufreq_cpu_init(struct cpufreq_policy *policy)
 		return ret;
 	}
 
+	policy->clk = cpuclk;
 	return cpufreq_generic_init(policy, &loongson2_clockmod_table[0], 0);
 }
 
 static int loongson2_cpufreq_exit(struct cpufreq_policy *policy)
 {
 	cpufreq_frequency_table_put_attr(policy->cpu);
-	clk_put(cpuclk);
+	clk_put(policy->clk);
 	return 0;
 }
 
@@ -119,7 +114,7 @@ static struct cpufreq_driver loongson2_cpufreq_driver = {
 	.init = loongson2_cpufreq_cpu_init,
 	.verify = cpufreq_generic_frequency_table_verify,
 	.target_index = loongson2_cpufreq_target,
-	.get = loongson2_cpufreq_get,
+	.get = cpufreq_generic_get,
 	.exit = loongson2_cpufreq_exit,
 	.attr = cpufreq_generic_attr,
 };
diff --git a/drivers/cpufreq/omap-cpufreq.c b/drivers/cpufreq/omap-cpufreq.c
index 5de1e5f..590f5b6 100644
--- a/drivers/cpufreq/omap-cpufreq.c
+++ b/drivers/cpufreq/omap-cpufreq.c
@@ -36,21 +36,9 @@
 
 static struct cpufreq_frequency_table *freq_table;
 static atomic_t freq_table_users = ATOMIC_INIT(0);
-static struct clk *mpu_clk;
 static struct device *mpu_dev;
 static struct regulator *mpu_reg;
 
-static unsigned int omap_getspeed(unsigned int cpu)
-{
-	unsigned long rate;
-
-	if (cpu >= NR_CPUS)
-		return 0;
-
-	rate = clk_get_rate(mpu_clk) / 1000;
-	return rate;
-}
-
 static int omap_target(struct cpufreq_policy *policy, unsigned int index)
 {
 	int r, ret;
@@ -58,11 +46,11 @@ static int omap_target(struct cpufreq_policy *policy, unsigned int index)
 	unsigned long freq, volt = 0, volt_old = 0, tol = 0;
 	unsigned int old_freq, new_freq;
 
-	old_freq = omap_getspeed(policy->cpu);
+	old_freq = policy->cur;
 	new_freq = freq_table[index].frequency;
 
 	freq = new_freq * 1000;
-	ret = clk_round_rate(mpu_clk, freq);
+	ret = clk_round_rate(policy->clk, freq);
 	if (IS_ERR_VALUE(ret)) {
 		dev_warn(mpu_dev,
 			 "CPUfreq: Cannot find matching frequency for %lu\n",
@@ -100,7 +88,7 @@ static int omap_target(struct cpufreq_policy *policy, unsigned int index)
 		}
 	}
 
-	ret = clk_set_rate(mpu_clk, new_freq * 1000);
+	ret = clk_set_rate(policy->clk, new_freq * 1000);
 
 	/* scaling down?  scale voltage after frequency */
 	if (mpu_reg && (new_freq < old_freq)) {
@@ -108,7 +96,7 @@ static int omap_target(struct cpufreq_policy *policy, unsigned int index)
 		if (r < 0) {
 			dev_warn(mpu_dev, "%s: unable to scale voltage down.\n",
 				 __func__);
-			clk_set_rate(mpu_clk, old_freq * 1000);
+			clk_set_rate(policy->clk, old_freq * 1000);
 			return r;
 		}
 	}
@@ -126,9 +114,9 @@ static int omap_cpu_init(struct cpufreq_policy *policy)
 {
 	int result;
 
-	mpu_clk = clk_get(NULL, "cpufreq_ck");
-	if (IS_ERR(mpu_clk))
-		return PTR_ERR(mpu_clk);
+	policy->clk = clk_get(NULL, "cpufreq_ck");
+	if (IS_ERR(policy->clk))
+		return PTR_ERR(policy->clk);
 
 	if (!freq_table) {
 		result = dev_pm_opp_init_cpufreq_table(mpu_dev, &freq_table);
@@ -149,7 +137,7 @@ static int omap_cpu_init(struct cpufreq_policy *policy)
 
 	freq_table_free();
 fail:
-	clk_put(mpu_clk);
+	clk_put(policy->clk);
 	return result;
 }
 
@@ -157,7 +145,7 @@ static int omap_cpu_exit(struct cpufreq_policy *policy)
 {
 	cpufreq_frequency_table_put_attr(policy->cpu);
 	freq_table_free();
-	clk_put(mpu_clk);
+	clk_put(policy->clk);
 	return 0;
 }
 
@@ -165,7 +153,7 @@ static struct cpufreq_driver omap_driver = {
 	.flags		= CPUFREQ_STICKY | CPUFREQ_NEED_INITIAL_FREQ_CHECK,
 	.verify		= cpufreq_generic_frequency_table_verify,
 	.target_index	= omap_target,
-	.get		= omap_getspeed,
+	.get		= cpufreq_generic_get,
 	.init		= omap_cpu_init,
 	.exit		= omap_cpu_exit,
 	.name		= "omap",
diff --git a/drivers/cpufreq/ppc-corenet-cpufreq.c b/drivers/cpufreq/ppc-corenet-cpufreq.c
index 3f7be46..051000f 100644
--- a/drivers/cpufreq/ppc-corenet-cpufreq.c
+++ b/drivers/cpufreq/ppc-corenet-cpufreq.c
@@ -24,12 +24,10 @@
 
 /**
  * struct cpu_data - per CPU data struct
- * @clk: the clk of CPU
  * @parent: the parent node of cpu clock
  * @table: frequency table
  */
 struct cpu_data {
-	struct clk *clk;
 	struct device_node *parent;
 	struct cpufreq_frequency_table *table;
 };
@@ -81,13 +79,6 @@ static inline const struct cpumask *cpu_core_mask(int cpu)
 }
 #endif
 
-static unsigned int corenet_cpufreq_get_speed(unsigned int cpu)
-{
-	struct cpu_data *data = per_cpu(cpu_data, cpu);
-
-	return clk_get_rate(data->clk) / 1000;
-}
-
 /* reduce the duplicated frequencies in frequency table */
 static void freq_table_redup(struct cpufreq_frequency_table *freq_table,
 		int count)
@@ -158,8 +149,8 @@ static int corenet_cpufreq_cpu_init(struct cpufreq_policy *policy)
 		goto err_np;
 	}
 
-	data->clk = of_clk_get(np, 0);
-	if (IS_ERR(data->clk)) {
+	policy->clk = of_clk_get(np, 0);
+	if (IS_ERR(policy->clk)) {
 		pr_err("%s: no clock information\n", __func__);
 		goto err_nomem2;
 	}
@@ -255,7 +246,7 @@ static int corenet_cpufreq_target(struct cpufreq_policy *policy,
 	struct cpu_data *data = per_cpu(cpu_data, policy->cpu);
 
 	parent = of_clk_get(data->parent, data->table[index].driver_data);
-	return clk_set_parent(data->clk, parent);
+	return clk_set_parent(policy->clk, parent);
 }
 
 static struct cpufreq_driver ppc_corenet_cpufreq_driver = {
@@ -265,7 +256,7 @@ static struct cpufreq_driver ppc_corenet_cpufreq_driver = {
 	.exit		= __exit_p(corenet_cpufreq_cpu_exit),
 	.verify		= cpufreq_generic_frequency_table_verify,
 	.target_index	= corenet_cpufreq_target,
-	.get		= corenet_cpufreq_get_speed,
+	.get		= cpufreq_generic_get,
 	.attr		= cpufreq_generic_attr,
 };
 
diff --git a/drivers/cpufreq/s3c24xx-cpufreq.c b/drivers/cpufreq/s3c24xx-cpufreq.c
index 6a1bf96..2506974 100644
--- a/drivers/cpufreq/s3c24xx-cpufreq.c
+++ b/drivers/cpufreq/s3c24xx-cpufreq.c
@@ -355,11 +355,6 @@ static int s3c_cpufreq_target(struct cpufreq_policy *policy,
 	return -EINVAL;
 }
 
-static unsigned int s3c_cpufreq_get(unsigned int cpu)
-{
-	return clk_get_rate(clk_arm) / 1000;
-}
-
 struct clk *s3c_cpufreq_clk_get(struct device *dev, const char *name)
 {
 	struct clk *clk;
@@ -373,6 +368,7 @@ struct clk *s3c_cpufreq_clk_get(struct device *dev, const char *name)
 
 static int s3c_cpufreq_init(struct cpufreq_policy *policy)
 {
+	policy->clk = clk_arm;
 	return cpufreq_generic_init(policy, ftab, cpu_cur.info->latency);
 }
 
@@ -408,7 +404,7 @@ static int s3c_cpufreq_suspend(struct cpufreq_policy *policy)
 {
 	suspend_pll.frequency = clk_get_rate(_clk_mpll);
 	suspend_pll.driver_data = __raw_readl(S3C2410_MPLLCON);
-	suspend_freq = s3c_cpufreq_get(0) * 1000;
+	suspend_freq = clk_get_rate(clk_arm);
 
 	return 0;
 }
@@ -450,7 +446,7 @@ static int s3c_cpufreq_resume(struct cpufreq_policy *policy)
 static struct cpufreq_driver s3c24xx_driver = {
 	.flags		= CPUFREQ_STICKY | CPUFREQ_NEED_INITIAL_FREQ_CHECK,
 	.target		= s3c_cpufreq_target,
-	.get		= s3c_cpufreq_get,
+	.get		= cpufreq_generic_get,
 	.init		= s3c_cpufreq_init,
 	.suspend	= s3c_cpufreq_suspend,
 	.resume		= s3c_cpufreq_resume,
diff --git a/drivers/cpufreq/s3c64xx-cpufreq.c b/drivers/cpufreq/s3c64xx-cpufreq.c
index 8435f45..c4226de 100644
--- a/drivers/cpufreq/s3c64xx-cpufreq.c
+++ b/drivers/cpufreq/s3c64xx-cpufreq.c
@@ -19,7 +19,6 @@
 #include <linux/regulator/consumer.h>
 #include <linux/module.h>
 
-static struct clk *armclk;
 static struct regulator *vddarm;
 static unsigned long regulator_latency;
 
@@ -54,14 +53,6 @@ static struct cpufreq_frequency_table s3c64xx_freq_table[] = {
 };
 #endif
 
-static unsigned int s3c64xx_cpufreq_get_speed(unsigned int cpu)
-{
-	if (cpu != 0)
-		return 0;
-
-	return clk_get_rate(armclk) / 1000;
-}
-
 static int s3c64xx_cpufreq_set_target(struct cpufreq_policy *policy,
 				      unsigned int index)
 {
@@ -69,7 +60,7 @@ static int s3c64xx_cpufreq_set_target(struct cpufreq_policy *policy,
 	unsigned int old_freq, new_freq;
 	int ret;
 
-	old_freq = clk_get_rate(armclk) / 1000;
+	old_freq = clk_get_rate(policy->clk) / 1000;
 	new_freq = s3c64xx_freq_table[index].frequency;
 	dvfs = &s3c64xx_dvfs_table[s3c64xx_freq_table[index].driver_data];
 
@@ -86,7 +77,7 @@ static int s3c64xx_cpufreq_set_target(struct cpufreq_policy *policy,
 	}
 #endif
 
-	ret = clk_set_rate(armclk, new_freq * 1000);
+	ret = clk_set_rate(policy->clk, new_freq * 1000);
 	if (ret < 0) {
 		pr_err("Failed to set rate %dkHz: %d\n",
 		       new_freq, ret);
@@ -101,7 +92,7 @@ static int s3c64xx_cpufreq_set_target(struct cpufreq_policy *policy,
 		if (ret != 0) {
 			pr_err("Failed to set VDDARM for %dkHz: %d\n",
 			       new_freq, ret);
-			if (clk_set_rate(armclk, old_freq * 1000) < 0)
+			if (clk_set_rate(policy->clk, old_freq * 1000) < 0)
 				pr_err("Failed to restore original clock rate\n");
 
 			return ret;
@@ -110,7 +101,7 @@ static int s3c64xx_cpufreq_set_target(struct cpufreq_policy *policy,
 #endif
 
 	pr_debug("Set actual frequency %lukHz\n",
-		 clk_get_rate(armclk) / 1000);
+		 clk_get_rate(policy->clk) / 1000);
 
 	return 0;
 }
@@ -169,11 +160,11 @@ static int s3c64xx_cpufreq_driver_init(struct cpufreq_policy *policy)
 		return -ENODEV;
 	}
 
-	armclk = clk_get(NULL, "armclk");
-	if (IS_ERR(armclk)) {
+	policy->clk = clk_get(NULL, "armclk");
+	if (IS_ERR(policy->clk)) {
 		pr_err("Unable to obtain ARMCLK: %ld\n",
-		       PTR_ERR(armclk));
-		return PTR_ERR(armclk);
+		       PTR_ERR(policy->clk));
+		return PTR_ERR(policy->clk);
 	}
 
 #ifdef CONFIG_REGULATOR
@@ -193,7 +184,7 @@ static int s3c64xx_cpufreq_driver_init(struct cpufreq_policy *policy)
 		unsigned long r;
 
 		/* Check for frequencies we can generate */
-		r = clk_round_rate(armclk, freq->frequency * 1000);
+		r = clk_round_rate(policy->clk, freq->frequency * 1000);
 		r /= 1000;
 		if (r != freq->frequency) {
 			pr_debug("%dkHz unsupported by clock\n",
@@ -203,7 +194,7 @@ static int s3c64xx_cpufreq_driver_init(struct cpufreq_policy *policy)
 
 		/* If we have no regulator then assume startup
 		 * frequency is the maximum we can support. */
-		if (!vddarm && freq->frequency > s3c64xx_cpufreq_get_speed(0))
+		if (!vddarm && freq->frequency > clk_get_rate(policy->clk) / 1000)
 			freq->frequency = CPUFREQ_ENTRY_INVALID;
 
 		freq++;
@@ -219,7 +210,7 @@ static int s3c64xx_cpufreq_driver_init(struct cpufreq_policy *policy)
 		pr_err("Failed to configure frequency table: %d\n",
 		       ret);
 		regulator_put(vddarm);
-		clk_put(armclk);
+		clk_put(policy->clk);
 	}
 
 	return ret;
@@ -229,7 +220,7 @@ static struct cpufreq_driver s3c64xx_cpufreq_driver = {
 	.flags		= CPUFREQ_NEED_INITIAL_FREQ_CHECK,
 	.verify		= cpufreq_generic_frequency_table_verify,
 	.target_index	= s3c64xx_cpufreq_set_target,
-	.get		= s3c64xx_cpufreq_get_speed,
+	.get		= cpufreq_generic_get,
 	.init		= s3c64xx_cpufreq_driver_init,
 	.name		= "s3c",
 };
diff --git a/drivers/cpufreq/s5pv210-cpufreq.c b/drivers/cpufreq/s5pv210-cpufreq.c
index ccd548c..55a8e9f 100644
--- a/drivers/cpufreq/s5pv210-cpufreq.c
+++ b/drivers/cpufreq/s5pv210-cpufreq.c
@@ -23,7 +23,6 @@
 #include <mach/map.h>
 #include <mach/regs-clock.h>
 
-static struct clk *cpu_clk;
 static struct clk *dmc0_clk;
 static struct clk *dmc1_clk;
 static DEFINE_MUTEX(set_freq_lock);
@@ -164,14 +163,6 @@ static void s5pv210_set_refresh(enum s5pv210_dmc_port ch, unsigned long freq)
 	__raw_writel(tmp1, reg);
 }
 
-static unsigned int s5pv210_getspeed(unsigned int cpu)
-{
-	if (cpu)
-		return 0;
-
-	return clk_get_rate(cpu_clk) / 1000;
-}
-
 static int s5pv210_target(struct cpufreq_policy *policy, unsigned int index)
 {
 	unsigned long reg;
@@ -193,7 +184,7 @@ static int s5pv210_target(struct cpufreq_policy *policy, unsigned int index)
 		goto exit;
 	}
 
-	old_freq = s5pv210_getspeed(0);
+	old_freq = policy->cur;
 	new_freq = s5pv210_freq_table[index].frequency;
 
 	/* Finding current running level index */
@@ -471,9 +462,9 @@ static int __init s5pv210_cpu_init(struct cpufreq_policy *policy)
 	unsigned long mem_type;
 	int ret;
 
-	cpu_clk = clk_get(NULL, "armclk");
-	if (IS_ERR(cpu_clk))
-		return PTR_ERR(cpu_clk);
+	policy->clk = clk_get(NULL, "armclk");
+	if (IS_ERR(policy->clk))
+		return PTR_ERR(policy->clk);
 
 	dmc0_clk = clk_get(NULL, "sclk_dmc0");
 	if (IS_ERR(dmc0_clk)) {
@@ -516,7 +507,7 @@ static int __init s5pv210_cpu_init(struct cpufreq_policy *policy)
 out_dmc1:
 	clk_put(dmc0_clk);
 out_dmc0:
-	clk_put(cpu_clk);
+	clk_put(policy->clk);
 	return ret;
 }
 
@@ -563,7 +554,7 @@ static struct cpufreq_driver s5pv210_driver = {
 	.flags		= CPUFREQ_STICKY | CPUFREQ_NEED_INITIAL_FREQ_CHECK,
 	.verify		= cpufreq_generic_frequency_table_verify,
 	.target_index	= s5pv210_target,
-	.get		= s5pv210_getspeed,
+	.get		= cpufreq_generic_get,
 	.init		= s5pv210_cpu_init,
 	.name		= "s5pv210",
 #ifdef CONFIG_PM
diff --git a/drivers/cpufreq/spear-cpufreq.c b/drivers/cpufreq/spear-cpufreq.c
index c7525fe..5c86e3f 100644
--- a/drivers/cpufreq/spear-cpufreq.c
+++ b/drivers/cpufreq/spear-cpufreq.c
@@ -30,11 +30,6 @@ static struct {
 	u32 cnt;
 } spear_cpufreq;
 
-static unsigned int spear_cpufreq_get(unsigned int cpu)
-{
-	return clk_get_rate(spear_cpufreq.clk) / 1000;
-}
-
 static struct clk *spear1340_cpu_get_possible_parent(unsigned long newfreq)
 {
 	struct clk *sys_pclk;
@@ -156,6 +151,7 @@ static int spear_cpufreq_target(struct cpufreq_policy *policy,
 
 static int spear_cpufreq_init(struct cpufreq_policy *policy)
 {
+	policy->clk = spear_cpufreq.clk;
 	return cpufreq_generic_init(policy, spear_cpufreq.freq_tbl,
 			spear_cpufreq.transition_latency);
 }
@@ -165,7 +161,7 @@ static struct cpufreq_driver spear_cpufreq_driver = {
 	.flags		= CPUFREQ_STICKY | CPUFREQ_NEED_INITIAL_FREQ_CHECK,
 	.verify		= cpufreq_generic_frequency_table_verify,
 	.target_index	= spear_cpufreq_target,
-	.get		= spear_cpufreq_get,
+	.get		= cpufreq_generic_get,
 	.init		= spear_cpufreq_init,
 	.exit		= cpufreq_generic_exit,
 	.attr		= cpufreq_generic_attr,
diff --git a/drivers/cpufreq/tegra-cpufreq.c b/drivers/cpufreq/tegra-cpufreq.c
index 01b5578..e652c1b 100644
--- a/drivers/cpufreq/tegra-cpufreq.c
+++ b/drivers/cpufreq/tegra-cpufreq.c
@@ -47,21 +47,9 @@ static struct clk *pll_x_clk;
 static struct clk *pll_p_clk;
 static struct clk *emc_clk;
 
-static unsigned long target_cpu_speed[NUM_CPUS];
 static DEFINE_MUTEX(tegra_cpu_lock);
 static bool is_suspended;
 
-static unsigned int tegra_getspeed(unsigned int cpu)
-{
-	unsigned long rate;
-
-	if (cpu >= NUM_CPUS)
-		return 0;
-
-	rate = clk_get_rate(cpu_clk) / 1000;
-	return rate;
-}
-
 static int tegra_cpu_clk_set_rate(unsigned long rate)
 {
 	int ret;
@@ -103,9 +91,6 @@ static int tegra_update_cpu_speed(struct cpufreq_policy *policy,
 {
 	int ret = 0;
 
-	if (tegra_getspeed(0) == rate)
-		return ret;
-
 	/*
 	 * Vote on memory bus frequency based on cpu frequency
 	 * This sets the minimum frequency, display or avp may request higher
@@ -125,33 +110,16 @@ static int tegra_update_cpu_speed(struct cpufreq_policy *policy,
 	return ret;
 }
 
-static unsigned long tegra_cpu_highest_speed(void)
-{
-	unsigned long rate = 0;
-	int i;
-
-	for_each_online_cpu(i)
-		rate = max(rate, target_cpu_speed[i]);
-	return rate;
-}
-
 static int tegra_target(struct cpufreq_policy *policy, unsigned int index)
 {
-	unsigned int freq;
-	int ret = 0;
+	int ret = -EBUSY;
 
 	mutex_lock(&tegra_cpu_lock);
 
-	if (is_suspended)
-		goto out;
-
-	freq = freq_table[index].frequency;
+	if (!is_suspended)
+		ret = tegra_update_cpu_speed(policy,
+				freq_table[index].frequency);
 
-	target_cpu_speed[policy->cpu] = freq;
-
-	ret = tegra_update_cpu_speed(policy, tegra_cpu_highest_speed());
-
-out:
 	mutex_unlock(&tegra_cpu_lock);
 	return ret;
 }
@@ -165,7 +133,8 @@ static int tegra_pm_notify(struct notifier_block *nb, unsigned long event,
 		is_suspended = true;
 		pr_info("Tegra cpufreq suspend: setting frequency to %d kHz\n",
 			freq_table[0].frequency);
-		tegra_update_cpu_speed(policy, freq_table[0].frequency);
+		if (clk_get_rate(cpu_clk) / 1000 != freq_table[0].frequency)
+			tegra_update_cpu_speed(policy, freq_table[0].frequency);
 		cpufreq_cpu_put(policy);
 	} else if (event == PM_POST_SUSPEND) {
 		is_suspended = false;
@@ -189,8 +158,6 @@ static int tegra_cpu_init(struct cpufreq_policy *policy)
 	clk_prepare_enable(emc_clk);
 	clk_prepare_enable(cpu_clk);
 
-	target_cpu_speed[policy->cpu] = tegra_getspeed(policy->cpu);
-
 	/* FIXME: what's the actual transition time? */
 	ret = cpufreq_generic_init(policy, freq_table, 300 * 1000);
 	if (ret) {
@@ -202,6 +169,7 @@ static int tegra_cpu_init(struct cpufreq_policy *policy)
 	if (policy->cpu == 0)
 		register_pm_notifier(&tegra_cpu_pm_notifier);
 
+	policy->clk = cpu_clk;
 	return 0;
 }
 
@@ -217,7 +185,7 @@ static struct cpufreq_driver tegra_cpufreq_driver = {
 	.flags		= CPUFREQ_NEED_INITIAL_FREQ_CHECK,
 	.verify		= cpufreq_generic_frequency_table_verify,
 	.target_index	= tegra_target,
-	.get		= tegra_getspeed,
+	.get		= cpufreq_generic_get,
 	.init		= tegra_cpu_init,
 	.exit		= tegra_cpu_exit,
 	.name		= "tegra",
diff --git a/drivers/cpufreq/unicore2-cpufreq.c b/drivers/cpufreq/unicore2-cpufreq.c
index 86f6cfe..36cc330 100644
--- a/drivers/cpufreq/unicore2-cpufreq.c
+++ b/drivers/cpufreq/unicore2-cpufreq.c
@@ -11,6 +11,7 @@
  * published by the Free Software Foundation.
  */
 
+#include <linux/err.h>
 #include <linux/kernel.h>
 #include <linux/types.h>
 #include <linux/init.h>
@@ -33,28 +34,18 @@ static int ucv2_verify_speed(struct cpufreq_policy *policy)
 	return 0;
 }
 
-static unsigned int ucv2_getspeed(unsigned int cpu)
-{
-	struct clk *mclk = clk_get(NULL, "MAIN_CLK");
-
-	if (cpu)
-		return 0;
-	return clk_get_rate(mclk)/1000;
-}
-
 static int ucv2_target(struct cpufreq_policy *policy,
 			 unsigned int target_freq,
 			 unsigned int relation)
 {
 	struct cpufreq_freqs freqs;
-	struct clk *mclk = clk_get(NULL, "MAIN_CLK");
 	int ret;
 
 	freqs.old = policy->cur;
 	freqs.new = target_freq;
 
 	cpufreq_notify_transition(policy, &freqs, CPUFREQ_PRECHANGE);
-	ret = clk_set_rate(mclk, target_freq * 1000);
+	ret = clk_set_rate(policy->mclk, target_freq * 1000);
 	cpufreq_notify_post_transition(policy, &freqs, ret);
 
 	return ret;
@@ -64,9 +55,13 @@ static int __init ucv2_cpu_init(struct cpufreq_policy *policy)
 {
 	if (policy->cpu != 0)
 		return -EINVAL;
+
 	policy->min = policy->cpuinfo.min_freq = 250000;
 	policy->max = policy->cpuinfo.max_freq = 1000000;
 	policy->cpuinfo.transition_latency = CPUFREQ_ETERNAL;
+	policy->clk = clk_get(NULL, "MAIN_CLK");
+	if (IS_ERR(policy->clk))
+		return PTR_ERR(policy->clk);
 	return 0;
 }
 
@@ -74,7 +69,7 @@ static struct cpufreq_driver ucv2_driver = {
 	.flags		= CPUFREQ_STICKY,
 	.verify		= ucv2_verify_speed,
 	.target		= ucv2_target,
-	.get		= ucv2_getspeed,
+	.get		= cpufreq_generic_get,
 	.init		= ucv2_cpu_init,
 	.name		= "UniCore-II",
 };
diff --git a/include/linux/cpufreq.h b/include/linux/cpufreq.h
index aaf800e..af72aba 100644
--- a/include/linux/cpufreq.h
+++ b/include/linux/cpufreq.h
@@ -11,6 +11,7 @@
 #ifndef _LINUX_CPUFREQ_H
 #define _LINUX_CPUFREQ_H
 
+#include <linux/clk.h>
 #include <linux/cpumask.h>
 #include <linux/completion.h>
 #include <linux/kobject.h>
@@ -66,6 +67,7 @@ struct cpufreq_policy {
 	unsigned int		cpu;    /* cpu nr of CPU managing this policy */
 	unsigned int		last_cpu; /* cpu nr of previous CPU that managed
 					   * this policy */
+	struct clk		*clk;
 	struct cpufreq_cpuinfo	cpuinfo;/* see above */
 
 	unsigned int		min;    /* in kHz */
@@ -468,6 +470,7 @@ void cpufreq_frequency_table_put_attr(unsigned int cpu);
 int cpufreq_table_validate_and_show(struct cpufreq_policy *policy,
 				      struct cpufreq_frequency_table *table);
 
+unsigned int cpufreq_generic_get(unsigned int cpu);
 int cpufreq_generic_init(struct cpufreq_policy *policy,
 		struct cpufreq_frequency_table *table,
 		unsigned int transition_latency);
-- 
1.7.12.rc2.18.g61b472e

