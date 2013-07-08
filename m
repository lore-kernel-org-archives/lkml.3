Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753468Ab3GHBpI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Jul 2013 21:45:08 -0400
Received: from mail-pa0-f44.google.com ([209.85.220.44]:44608 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753404Ab3GHBoy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Jul 2013 21:44:54 -0400
From: Mike Turquette <mturquette@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, linux-pm@vger.kernel.org,
        Mike Turquette <mturquette@linaro.org>
Subject: [PATCH RFC 3/3] cpufreq: cpufreq-cpu0: clk rate-change notifiers
Date: Sun,  7 Jul 2013 18:44:28 -0700
Message-Id: <1373247868-21444-4-git-send-email-mturquette@linaro.org>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1373247868-21444-1-git-send-email-mturquette@linaro.org>
References: <1373247868-21444-1-git-send-email-mturquette@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removes direct handling of OPP tables and voltage regulators by calling
of_clk_cpufreq_notifier_handler, introduced by commit "clk: cpufreq
helper for voltage scaling".

In the future this can help consolidate code found across similar
CPUfreq drivers.

Signed-off-by: Mike Turquette <mturquette@linaro.org>
---
 drivers/cpufreq/cpufreq-cpu0.c | 125 ++++++++---------------------------------
 1 file changed, 22 insertions(+), 103 deletions(-)

diff --git a/drivers/cpufreq/cpufreq-cpu0.c b/drivers/cpufreq/cpufreq-cpu0.c
index ad1fde2..1e8f928 100644
--- a/drivers/cpufreq/cpufreq-cpu0.c
+++ b/drivers/cpufreq/cpufreq-cpu0.c
@@ -16,18 +16,15 @@
 #include <linux/err.h>
 #include <linux/module.h>
 #include <linux/of.h>
-#include <linux/opp.h>
 #include <linux/platform_device.h>
-#include <linux/regulator/consumer.h>
 #include <linux/slab.h>
 
 static unsigned int transition_latency;
-static unsigned int voltage_tolerance; /* in percentage */
 
 static struct device *cpu_dev;
 static struct clk *cpu_clk;
-static struct regulator *cpu_reg;
 static struct cpufreq_frequency_table *freq_table;
+static struct notifier_block *clk_nb;
 
 static int cpu0_verify_speed(struct cpufreq_policy *policy)
 {
@@ -43,8 +40,7 @@ static int cpu0_set_target(struct cpufreq_policy *policy,
 			   unsigned int target_freq, unsigned int relation)
 {
 	struct cpufreq_freqs freqs;
-	struct opp *opp;
-	unsigned long volt = 0, volt_old = 0, tol = 0;
+	unsigned long volt = 0, volt_old = 0;
 	long freq_Hz, freq_exact;
 	unsigned int index;
 	int ret;
@@ -69,56 +65,16 @@ static int cpu0_set_target(struct cpufreq_policy *policy,
 
 	cpufreq_notify_transition(policy, &freqs, CPUFREQ_PRECHANGE);
 
-	if (cpu_reg) {
-		rcu_read_lock();
-		opp = opp_find_freq_ceil(cpu_dev, &freq_Hz);
-		if (IS_ERR(opp)) {
-			rcu_read_unlock();
-			pr_err("failed to find OPP for %ld\n", freq_Hz);
-			freqs.new = freqs.old;
-			ret = PTR_ERR(opp);
-			goto post_notify;
-		}
-		volt = opp_get_voltage(opp);
-		rcu_read_unlock();
-		tol = volt * voltage_tolerance / 100;
-		volt_old = regulator_get_voltage(cpu_reg);
-	}
-
 	pr_debug("%u MHz, %ld mV --> %u MHz, %ld mV\n",
 		 freqs.old / 1000, volt_old ? volt_old / 1000 : -1,
 		 freqs.new / 1000, volt ? volt / 1000 : -1);
 
-	/* scaling up?  scale voltage before frequency */
-	if (cpu_reg && freqs.new > freqs.old) {
-		ret = regulator_set_voltage_tol(cpu_reg, volt, tol);
-		if (ret) {
-			pr_err("failed to scale voltage up: %d\n", ret);
-			freqs.new = freqs.old;
-			goto post_notify;
-		}
-	}
-
 	ret = clk_set_rate(cpu_clk, freq_exact);
 	if (ret) {
 		pr_err("failed to set clock rate: %d\n", ret);
-		if (cpu_reg)
-			regulator_set_voltage_tol(cpu_reg, volt_old, tol);
 		freqs.new = freqs.old;
-		goto post_notify;
-	}
-
-	/* scaling down?  scale voltage after frequency */
-	if (cpu_reg && freqs.new < freqs.old) {
-		ret = regulator_set_voltage_tol(cpu_reg, volt, tol);
-		if (ret) {
-			pr_err("failed to scale voltage down: %d\n", ret);
-			clk_set_rate(cpu_clk, freqs.old * 1000);
-			freqs.new = freqs.old;
-		}
 	}
 
-post_notify:
 	cpufreq_notify_transition(policy, &freqs, CPUFREQ_POSTCHANGE);
 
 	return ret;
@@ -175,6 +131,7 @@ static struct cpufreq_driver cpu0_cpufreq_driver = {
 static int cpu0_cpufreq_probe(struct platform_device *pdev)
 {
 	struct device_node *np, *parent;
+	unsigned int voltage_latency;
 	int ret;
 
 	parent = of_find_node_by_path("/cpus");
@@ -197,22 +154,6 @@ static int cpu0_cpufreq_probe(struct platform_device *pdev)
 	cpu_dev = &pdev->dev;
 	cpu_dev->of_node = np;
 
-	cpu_reg = devm_regulator_get(cpu_dev, "cpu0");
-	if (IS_ERR(cpu_reg)) {
-		/*
-		 * If cpu0 regulator supply node is present, but regulator is
-		 * not yet registered, we should try defering probe.
-		 */
-		if (PTR_ERR(cpu_reg) == -EPROBE_DEFER) {
-			dev_err(cpu_dev, "cpu0 regulator not ready, retry\n");
-			ret = -EPROBE_DEFER;
-			goto out_put_node;
-		}
-		pr_warn("failed to get cpu0 regulator: %ld\n",
-			PTR_ERR(cpu_reg));
-		cpu_reg = NULL;
-	}
-
 	cpu_clk = devm_clk_get(cpu_dev, NULL);
 	if (IS_ERR(cpu_clk)) {
 		ret = PTR_ERR(cpu_clk);
@@ -220,60 +161,38 @@ static int cpu0_cpufreq_probe(struct platform_device *pdev)
 		goto out_put_node;
 	}
 
-	ret = of_init_opp_table(cpu_dev);
-	if (ret) {
-		pr_err("failed to init OPP table: %d\n", ret);
-		goto out_put_node;
-	}
-
-	ret = opp_init_cpufreq_table(cpu_dev, &freq_table);
-	if (ret) {
-		pr_err("failed to init cpufreq table: %d\n", ret);
-		goto out_put_node;
-	}
-
-	of_property_read_u32(np, "voltage-tolerance", &voltage_tolerance);
-
 	if (of_property_read_u32(np, "clock-latency", &transition_latency))
 		transition_latency = CPUFREQ_ETERNAL;
 
-	if (cpu_reg) {
-		struct opp *opp;
-		unsigned long min_uV, max_uV;
-		int i;
-
-		/*
-		 * OPP is maintained in order of increasing frequency, and
-		 * freq_table initialised from OPP is therefore sorted in the
-		 * same order.
-		 */
-		for (i = 0; freq_table[i].frequency != CPUFREQ_TABLE_END; i++)
-			;
-		rcu_read_lock();
-		opp = opp_find_freq_exact(cpu_dev,
-				freq_table[0].frequency * 1000, true);
-		min_uV = opp_get_voltage(opp);
-		opp = opp_find_freq_exact(cpu_dev,
-				freq_table[i-1].frequency * 1000, true);
-		max_uV = opp_get_voltage(opp);
-		rcu_read_unlock();
-		ret = regulator_set_voltage_time(cpu_reg, min_uV, max_uV);
-		if (ret > 0)
-			transition_latency += ret * 1000;
+	clk_nb = of_clk_cpufreq_notifier_register(cpu_dev, np, cpu_clk, "cpu0",
+			&freq_table, &voltage_latency);
+
+	if (IS_ERR(clk_nb)) {
+		ret = PTR_ERR(clk_nb);
+		/* defer probe if regulator is not yet registered */
+		if (ret == -EPROBE_DEFER)
+			dev_err(cpu_dev, "cpu0 clock notifier not ready, retry\n");
+		else
+			dev_err(cpu_dev, "failed to register cpu0 clock notifier: %d\n",
+					ret);
+		goto out_put_node;
 	}
 
+	if (voltage_latency > 0)
+		transition_latency += voltage_latency;
+
 	ret = cpufreq_register_driver(&cpu0_cpufreq_driver);
 	if (ret) {
 		pr_err("failed register driver: %d\n", ret);
-		goto out_free_table;
+		goto out_notifier_unregister;
 	}
 
 	of_node_put(np);
 	of_node_put(parent);
 	return 0;
 
-out_free_table:
-	opp_free_cpufreq_table(cpu_dev, &freq_table);
+out_notifier_unregister:
+	of_clk_cpufreq_notifier_unregister(clk_nb, freq_table);
 out_put_node:
 	of_node_put(np);
 out_put_parent:
@@ -283,8 +202,8 @@ out_put_parent:
 
 static int cpu0_cpufreq_remove(struct platform_device *pdev)
 {
+	of_clk_cpufreq_notifier_unregister(clk_nb, freq_table);
 	cpufreq_unregister_driver(&cpu0_cpufreq_driver);
-	opp_free_cpufreq_table(cpu_dev, &freq_table);
 
 	return 0;
 }
-- 
1.8.1.2

