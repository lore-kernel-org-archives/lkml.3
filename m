Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755171Ab3J3Wz1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 18:55:27 -0400
Received: from mail-oa0-f54.google.com ([209.85.219.54]:54397 "EHLO
	mail-oa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754495Ab3J3Ww0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 18:52:26 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, viresh.kumar@linaro.org
Subject: [PATCH V2 Resend 06/16] cpufreq: exynos: use cpufreq_generic_get() routine
Date: Thu, 31 Oct 2013 04:22:04 +0530
Message-Id: <24c6716a38d2ecb6ed1b18e5408fd4f9bf387541.1383173230.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1383173230.git.viresh.kumar@linaro.org>
References: <cover.1383173230.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1383173230.git.viresh.kumar@linaro.org>
References: <cover.1383173230.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We have common infrastructure available with us for getting a CPUs clk rate.
Lets use it for this driver.

Cc: Amit Daniel Kachhap <amit.daniel@samsung.com>
Cc: Kukjin Kim <kgene.kim@samsung.com>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/cpufreq/exynos-cpufreq.c     | 10 +++-------
 drivers/cpufreq/exynos5440-cpufreq.c | 33 ++++++++++++++-------------------
 2 files changed, 17 insertions(+), 26 deletions(-)

diff --git a/drivers/cpufreq/exynos-cpufreq.c b/drivers/cpufreq/exynos-cpufreq.c
index 7b6dc06..bdba910 100644
--- a/drivers/cpufreq/exynos-cpufreq.c
+++ b/drivers/cpufreq/exynos-cpufreq.c
@@ -30,11 +30,6 @@ static unsigned int locking_frequency;
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
@@ -214,6 +209,7 @@ static struct notifier_block exynos_cpufreq_nb = {
 
 static int exynos_cpufreq_cpu_init(struct cpufreq_policy *policy)
 {
+	policy->clk = exynos_info->cpu_clk;
 	return cpufreq_generic_init(policy, exynos_info->freq_table, 100000);
 }
 
@@ -221,7 +217,7 @@ static struct cpufreq_driver exynos_driver = {
 	.flags		= CPUFREQ_STICKY,
 	.verify		= cpufreq_generic_frequency_table_verify,
 	.target_index	= exynos_target,
-	.get		= exynos_getspeed,
+	.get		= cpufreq_generic_get,
 	.init		= exynos_cpufreq_cpu_init,
 	.exit		= cpufreq_generic_exit,
 	.name		= "exynos_cpufreq",
@@ -263,7 +259,7 @@ static int __init exynos_cpufreq_init(void)
 		goto err_vdd_arm;
 	}
 
-	locking_frequency = exynos_getspeed(0);
+	locking_frequency = clk_get_rate(exynos_info->cpu_clk) / 1000;
 
 	register_pm_notifier(&exynos_cpufreq_nb);
 
diff --git a/drivers/cpufreq/exynos5440-cpufreq.c b/drivers/cpufreq/exynos5440-cpufreq.c
index 76bef8b..3a62447 100644
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
@@ -315,7 +309,7 @@ static struct cpufreq_driver exynos_driver = {
 	.flags		= CPUFREQ_STICKY | CPUFREQ_ASYNC_NOTIFICATION,
 	.verify		= cpufreq_generic_frequency_table_verify,
 	.target_index	= exynos_target,
-	.get		= exynos_getspeed,
+	.get		= cpufreq_generic_get,
 	.init		= exynos_cpufreq_cpu_init,
 	.exit		= cpufreq_generic_exit,
 	.name		= CPUFREQ_NAME,
@@ -335,6 +329,7 @@ static int exynos_cpufreq_probe(struct platform_device *pdev)
 	int ret = -EINVAL;
 	struct device_node *np;
 	struct resource res;
+	unsigned int cur_frequency;
 
 	np =  pdev->dev.of_node;
 	if (!np)
@@ -391,13 +386,13 @@ static int exynos_cpufreq_probe(struct platform_device *pdev)
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
@@ -414,7 +409,7 @@ static int exynos_cpufreq_probe(struct platform_device *pdev)
 		goto err_free_table;
 	}
 
-	exynos_enable_dvfs();
+	exynos_enable_dvfs(cur_frequency);
 	ret = cpufreq_register_driver(&exynos_driver);
 	if (ret) {
 		dev_err(dvfs_info->dev,
-- 
1.7.12.rc2.18.g61b472e

