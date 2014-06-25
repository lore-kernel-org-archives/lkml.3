Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756165AbaFYInR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 04:43:17 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:64924 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756143AbaFYInK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 04:43:10 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@rjwysocki.net, sboyd@codeaurora.org, shawn.guo@linaro.org
Cc: linaro-kernel@lists.linaro.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, arvind.chauhan@arm.com,
        mturquette@linaro.org, linux-arm-kernel@lists.infradead.org,
        linux-arm-msm@vger.kernel.org, spk.linux@gmail.com,
        thomas.ab@samsung.com, nm@ti.com, t.figa@samsung.com,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 2/2] cpufreq: cpu0: Extend support beyond CPU0
Date: Wed, 25 Jun 2014 14:12:29 +0530
Message-Id: <e9c0eef07745e561b9d12dcb50c3e2f7eb3e8880.1403684824.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 2.0.0.rc2
In-Reply-To: <cover.1403684824.git.viresh.kumar@linaro.org>
References: <cover.1403684824.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1403684824.git.viresh.kumar@linaro.org>
References: <cover.1403684824.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cpufreq-cpu0 driver supports only platforms which have single clock line shared
among all CPUs.

We already have platforms where this limitation doesn't hold true.For example on
Qualcomm's KRAIT all CPUs have separate clock line and so have separate
policies.

Instead of adding another driver for this (Stephen just tried that:
https://lkml.org/lkml/2014/6/24/918), we must reuse cpufreq-cpu0 driver.

cpufreq-cpu0 must be updated to break the assumption on which it is based (all
cores sharing clock line) and this patch tries to do exactly that.

As we don't have standard DT bindings to mention CPUs sharing clock-line, i.e.
affected_cpus, this patch also have few limitations. Though easy to fix once we
have proper bindings.

Limitation: We only supports two types of platforms:
- All CPUs sharing same clock line, existing user platforms
- All CPUs have separate clock lines, KRAIT

And so platforms which have multiple clusters with multiple CPUs per cluster
aren't supported yet. We need proper bindings for that first.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 .../devicetree/bindings/cpufreq/cpufreq-cpu0.txt   |   8 +-
 drivers/cpufreq/Kconfig                            |   5 +-
 drivers/cpufreq/cpufreq-cpu0.c                     | 280 +++++++++++++--------
 3 files changed, 190 insertions(+), 103 deletions(-)

diff --git a/Documentation/devicetree/bindings/cpufreq/cpufreq-cpu0.txt b/Documentation/devicetree/bindings/cpufreq/cpufreq-cpu0.txt
index f055515..fa8861e 100644
--- a/Documentation/devicetree/bindings/cpufreq/cpufreq-cpu0.txt
+++ b/Documentation/devicetree/bindings/cpufreq/cpufreq-cpu0.txt
@@ -1,15 +1,17 @@
 Generic CPU0 cpufreq driver
 
-It is a generic cpufreq driver for CPU0 frequency management.  It
+It is a generic cpufreq driver for CPU frequency management.  It
 supports both uniprocessor (UP) and symmetric multiprocessor (SMP)
-systems which share clock and voltage across all CPUs.
+systems which share clock and voltage across all CPUs OR have separate
+clock and voltage for all CPUs.
 
 Both required and optional properties listed below must be defined
 under node /cpus/cpu@0.
 
 Required properties:
 - operating-points: Refer to Documentation/devicetree/bindings/power/opp.txt
-  for details
+  for details. This should either be present only in cpu@0, if CPUs share clock
+  line OR should be present in all cpu nodes, if they have separate clock lines.
 
 Optional properties:
 - clock-latency: Specify the possible maximum transition latency for clock,
diff --git a/drivers/cpufreq/Kconfig b/drivers/cpufreq/Kconfig
index ffe350f..0e8d983 100644
--- a/drivers/cpufreq/Kconfig
+++ b/drivers/cpufreq/Kconfig
@@ -190,9 +190,10 @@ config GENERIC_CPUFREQ_CPU0
 	depends on !CPU_THERMAL || THERMAL
 	select PM_OPP
 	help
-	  This adds a generic cpufreq driver for CPU0 frequency management.
+	  This adds a generic cpufreq driver for CPU frequency management.
 	  It supports both uniprocessor (UP) and symmetric multiprocessor (SMP)
-	  systems which share clock and voltage across all CPUs.
+	  systems which share clock and voltage across all CPUs OR have separate
+	  clock and voltage for all CPUs.
 
 	  If in doubt, say N.
 
diff --git a/drivers/cpufreq/cpufreq-cpu0.c b/drivers/cpufreq/cpufreq-cpu0.c
index ee1ae30..d29f6a0 100644
--- a/drivers/cpufreq/cpufreq-cpu0.c
+++ b/drivers/cpufreq/cpufreq-cpu0.c
@@ -25,34 +25,43 @@
 #include <linux/slab.h>
 #include <linux/thermal.h>
 
-static unsigned int transition_latency;
-static unsigned int voltage_tolerance; /* in percentage */
+struct private_data {
+	struct device *cpu_dev;
+	struct regulator *cpu_reg;
+	struct thermal_cooling_device *cdev;
+	unsigned int voltage_tolerance; /* in percentage */
+};
 
-static struct device *cpu_dev;
-static struct clk *cpu_clk;
-static struct regulator *cpu_reg;
-static struct cpufreq_frequency_table *freq_table;
-static struct thermal_cooling_device *cdev;
+/*
+ * Currently this driver supports only two types of platforms:
+ * - All CPUs sharing same clock line, clock_per_cpu == false
+ * - All CPUs having separate clock lines, clock_per_cpu == true
+ *
+ * TODO: Scan affected/related CPUs from proper DT bindings
+ */
+bool clock_per_cpu = false;
 
 static int cpu0_set_target(struct cpufreq_policy *policy, unsigned int index)
 {
 	struct dev_pm_opp *opp;
+	struct private_data *priv = policy->driver_data;
 	unsigned long volt = 0, volt_old = 0, tol = 0;
 	unsigned int old_freq, new_freq;
 	long freq_Hz, freq_exact;
 	int ret;
 
-	freq_Hz = clk_round_rate(cpu_clk, freq_table[index].frequency * 1000);
+	freq_Hz = clk_round_rate(policy->clk,
+				 policy->freq_table[index].frequency * 1000);
 	if (freq_Hz <= 0)
-		freq_Hz = freq_table[index].frequency * 1000;
+		freq_Hz = policy->freq_table[index].frequency * 1000;
 
 	freq_exact = freq_Hz;
 	new_freq = freq_Hz / 1000;
-	old_freq = clk_get_rate(cpu_clk) / 1000;
+	old_freq = clk_get_rate(policy->clk) / 1000;
 
-	if (!IS_ERR(cpu_reg)) {
+	if (!IS_ERR(priv->cpu_reg)) {
 		rcu_read_lock();
-		opp = dev_pm_opp_find_freq_ceil(cpu_dev, &freq_Hz);
+		opp = dev_pm_opp_find_freq_ceil(priv->cpu_dev, &freq_Hz);
 		if (IS_ERR(opp)) {
 			rcu_read_unlock();
 			pr_err("failed to find OPP for %ld\n", freq_Hz);
@@ -60,8 +69,8 @@ static int cpu0_set_target(struct cpufreq_policy *policy, unsigned int index)
 		}
 		volt = dev_pm_opp_get_voltage(opp);
 		rcu_read_unlock();
-		tol = volt * voltage_tolerance / 100;
-		volt_old = regulator_get_voltage(cpu_reg);
+		tol = volt * priv->voltage_tolerance / 100;
+		volt_old = regulator_get_voltage(priv->cpu_reg);
 	}
 
 	pr_debug("%u MHz, %ld mV --> %u MHz, %ld mV\n",
@@ -69,28 +78,28 @@ static int cpu0_set_target(struct cpufreq_policy *policy, unsigned int index)
 		 new_freq / 1000, volt ? volt / 1000 : -1);
 
 	/* scaling up?  scale voltage before frequency */
-	if (!IS_ERR(cpu_reg) && new_freq > old_freq) {
-		ret = regulator_set_voltage_tol(cpu_reg, volt, tol);
+	if (!IS_ERR(priv->cpu_reg) && new_freq > old_freq) {
+		ret = regulator_set_voltage_tol(priv->cpu_reg, volt, tol);
 		if (ret) {
 			pr_err("failed to scale voltage up: %d\n", ret);
 			return ret;
 		}
 	}
 
-	ret = clk_set_rate(cpu_clk, freq_exact);
+	ret = clk_set_rate(policy->clk, freq_exact);
 	if (ret) {
 		pr_err("failed to set clock rate: %d\n", ret);
-		if (!IS_ERR(cpu_reg))
-			regulator_set_voltage_tol(cpu_reg, volt_old, tol);
+		if (!IS_ERR(priv->cpu_reg))
+			regulator_set_voltage_tol(priv->cpu_reg, volt_old, tol);
 		return ret;
 	}
 
 	/* scaling down?  scale voltage after frequency */
-	if (!IS_ERR(cpu_reg) && new_freq < old_freq) {
-		ret = regulator_set_voltage_tol(cpu_reg, volt, tol);
+	if (!IS_ERR(priv->cpu_reg) && new_freq < old_freq) {
+		ret = regulator_set_voltage_tol(priv->cpu_reg, volt, tol);
 		if (ret) {
 			pr_err("failed to scale voltage down: %d\n", ret);
-			clk_set_rate(cpu_clk, old_freq * 1000);
+			clk_set_rate(policy->clk, old_freq * 1000);
 		}
 	}
 
@@ -99,77 +108,70 @@ static int cpu0_set_target(struct cpufreq_policy *policy, unsigned int index)
 
 static int cpu0_cpufreq_init(struct cpufreq_policy *policy)
 {
-	policy->clk = cpu_clk;
-	return cpufreq_generic_init(policy, freq_table, transition_latency);
-}
-
-static struct cpufreq_driver cpu0_cpufreq_driver = {
-	.flags = CPUFREQ_STICKY | CPUFREQ_NEED_INITIAL_FREQ_CHECK,
-	.verify = cpufreq_generic_frequency_table_verify,
-	.target_index = cpu0_set_target,
-	.get = cpufreq_generic_get,
-	.init = cpu0_cpufreq_init,
-	.name = "generic_cpu0",
-	.attr = cpufreq_generic_attr,
-};
-
-static int cpu0_cpufreq_probe(struct platform_device *pdev)
-{
+	struct cpufreq_frequency_table *freq_table;
+	struct private_data *priv;
 	struct device_node *np;
-	int ret;
+	char name[] = "cpuX";
+	int ret, cpu = policy->cpu;
 
-	cpu_dev = get_cpu_device(0);
-	if (!cpu_dev) {
-		pr_err("failed to get cpu0 device\n");
-		return -ENODEV;
+	priv = kzalloc(sizeof(*priv), GFP_KERNEL);
+	if (!priv) {
+		pr_err("%s: Memory allocation failed\n", __func__);
+		return -ENOMEM;
 	}
 
-	np = of_node_get(cpu_dev->of_node);
-	if (!np) {
-		pr_err("failed to find cpu0 node\n");
-		return -ENOENT;
-	}
+	/* Below calls can't fail from here */
+	priv->cpu_dev = get_cpu_device(cpu);
+	np = of_node_get(priv->cpu_dev->of_node);
 
-	cpu_reg = regulator_get_optional(cpu_dev, "cpu0");
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
+	policy->clk = clk_get(priv->cpu_dev, NULL);
+	if (IS_ERR(policy->clk)) {
+		ret = PTR_ERR(policy->clk);
+		pr_err("%s: failed to get cpu%d clock: %d\n", __func__, cpu,
+		       ret);
+		goto out_put_node;
 	}
 
-	cpu_clk = clk_get(cpu_dev, NULL);
-	if (IS_ERR(cpu_clk)) {
-		ret = PTR_ERR(cpu_clk);
-		pr_err("failed to get cpu0 clock: %d\n", ret);
-		goto out_put_reg;
+	ret = of_init_opp_table(priv->cpu_dev);
+	if (ret) {
+		pr_err("%s: failed to init OPP table for cpu%d: %d\n", __func__,
+		       cpu, ret);
+		goto out_put_clk;
 	}
 
-	ret = of_init_opp_table(cpu_dev);
+	ret = dev_pm_opp_init_cpufreq_table(priv->cpu_dev, &freq_table);
 	if (ret) {
-		pr_err("failed to init OPP table: %d\n", ret);
+		pr_err("%s: failed to init cpufreq table for cpu%d: %d\n",
+		       __func__, cpu, ret);
 		goto out_put_clk;
 	}
 
-	ret = dev_pm_opp_init_cpufreq_table(cpu_dev, &freq_table);
+	ret = cpufreq_table_validate_and_show(policy, freq_table);
 	if (ret) {
-		pr_err("failed to init cpufreq table: %d\n", ret);
-		goto out_put_clk;
+		pr_err("%s: invalid frequency table for cpu%d: %d\n", __func__,
+		       cpu, ret);
+		goto out_put_reg;
 	}
 
-	of_property_read_u32(np, "voltage-tolerance", &voltage_tolerance);
+	/* Set mask of CPUs sharing clock line with policy->cpu */
+	if (!clock_per_cpu)
+		cpumask_setall(policy->cpus);
 
-	if (of_property_read_u32(np, "clock-latency", &transition_latency))
-		transition_latency = CPUFREQ_ETERNAL;
+	of_property_read_u32(np, "voltage-tolerance", &priv->voltage_tolerance);
 
-	if (!IS_ERR(cpu_reg)) {
+	if (of_property_read_u32(np, "clock-latency",
+				 &policy->cpuinfo.transition_latency))
+		policy->cpuinfo.transition_latency = CPUFREQ_ETERNAL;
+
+	/* NOTE: Supports only 10 CPUs: 0-9 */
+	WARN_ONCE(cpu > 9, "cpu: %d", cpu);
+
+	name[3] = '0' + cpu;
+	priv->cpu_reg = regulator_get_optional(priv->cpu_dev, name);
+	if (IS_ERR(priv->cpu_reg)) {
+		pr_warn("%s: failed to get cpu%d's regulator: %ld\n", __func__,
+			cpu, PTR_ERR(priv->cpu_reg));
+	} else {
 		struct dev_pm_opp *opp;
 		unsigned long min_uV, max_uV;
 		int i;
@@ -182,22 +184,16 @@ static int cpu0_cpufreq_probe(struct platform_device *pdev)
 		for (i = 0; freq_table[i].frequency != CPUFREQ_TABLE_END; i++)
 			;
 		rcu_read_lock();
-		opp = dev_pm_opp_find_freq_exact(cpu_dev,
+		opp = dev_pm_opp_find_freq_exact(priv->cpu_dev,
 				freq_table[0].frequency * 1000, true);
 		min_uV = dev_pm_opp_get_voltage(opp);
-		opp = dev_pm_opp_find_freq_exact(cpu_dev,
+		opp = dev_pm_opp_find_freq_exact(priv->cpu_dev,
 				freq_table[i-1].frequency * 1000, true);
 		max_uV = dev_pm_opp_get_voltage(opp);
 		rcu_read_unlock();
-		ret = regulator_set_voltage_time(cpu_reg, min_uV, max_uV);
+		ret = regulator_set_voltage_time(priv->cpu_reg, min_uV, max_uV);
 		if (ret > 0)
-			transition_latency += ret * 1000;
-	}
-
-	ret = cpufreq_register_driver(&cpu0_cpufreq_driver);
-	if (ret) {
-		pr_err("failed register driver: %d\n", ret);
-		goto out_free_table;
+			policy->cpuinfo.transition_latency += ret * 1000;
 	}
 
 	/*
@@ -205,34 +201,122 @@ static int cpu0_cpufreq_probe(struct platform_device *pdev)
 	 * thermal DT code takes care of matching them.
 	 */
 	if (of_find_property(np, "#cooling-cells", NULL)) {
-		cdev = of_cpufreq_cooling_register(np, cpu_present_mask);
-		if (IS_ERR(cdev))
+		priv->cdev = of_cpufreq_cooling_register(np, policy->cpus);
+		if (IS_ERR(priv->cdev))
 			pr_err("running cpufreq without cooling device: %ld\n",
-			       PTR_ERR(cdev));
+			       PTR_ERR(priv->cdev));
 	}
 
+	policy->driver_data = priv;
 	of_node_put(np);
 	return 0;
 
-out_free_table:
-	dev_pm_opp_free_cpufreq_table(cpu_dev, &freq_table);
-out_put_clk:
-	if (!IS_ERR(cpu_clk))
-		clk_put(cpu_clk);
 out_put_reg:
-	if (!IS_ERR(cpu_reg))
-		regulator_put(cpu_reg);
+	if (!IS_ERR(priv->cpu_reg))
+		regulator_put(priv->cpu_reg);
+	dev_pm_opp_free_cpufreq_table(priv->cpu_dev, &freq_table);
+out_put_clk:
+	clk_put(policy->clk);
 out_put_node:
 	of_node_put(np);
+	kfree(priv);
+	return ret;
+}
+
+static int cpu0_cpufreq_exit(struct cpufreq_policy *policy)
+{
+	struct private_data *priv = policy->driver_data;
+
+	cpufreq_cooling_unregister(priv->cdev);
+	if (!IS_ERR(priv->cpu_reg))
+		regulator_put(priv->cpu_reg);
+	dev_pm_opp_free_cpufreq_table(priv->cpu_dev, &policy->freq_table);
+	clk_put(policy->clk);
+	kfree(priv);
+
+	return 0;
+}
+
+static struct cpufreq_driver cpu0_cpufreq_driver = {
+	.flags = CPUFREQ_STICKY | CPUFREQ_NEED_INITIAL_FREQ_CHECK,
+	.verify = cpufreq_generic_frequency_table_verify,
+	.target_index = cpu0_set_target,
+	.get = cpufreq_generic_get,
+	.init = cpu0_cpufreq_init,
+	.exit = cpu0_cpufreq_exit,
+	.name = "generic_cpu0",
+	.attr = cpufreq_generic_attr,
+};
+
+static int cpu0_cpufreq_probe(struct platform_device *pdev)
+{
+	const struct property *prop;
+	struct device *cpu_dev;
+	struct regulator *cpu_reg;
+	int ret, cpu, count = 0;
+
+	/* Optimization for regulator's -EPROBE_DEFER case */
+	if (unlikely(clock_per_cpu))
+		goto scan_regulator;
+
+	/*
+	 * Scan all CPU nodes to set clock_per_cpu
+	 *
+	 * FIXME: Scan affected-CPUs from DT and remove this loop.
+	 */
+	for_each_possible_cpu(cpu) {
+		cpu_dev = get_cpu_device(cpu);
+		if (!cpu_dev) {
+			pr_err("%s: failed to get cpu%d device\n", __func__,
+			       cpu);
+			return -ENODEV;
+		}
+
+		/* Count how many CPU nodes have defined operating-points */
+		prop = of_find_property(cpu_dev->of_node, "operating-points",
+					NULL);
+		if (prop) {
+			count++;
+		} else if (cpu == 0) {
+			pr_err("%s: operating-points missing: cpu%d\n",
+			       __func__, cpu);
+			return -ENOENT;
+		}
+	}
+
+	/* Either one or all CPUs must have operating-points property */
+	if (count == cpu + 1) {
+		clock_per_cpu = true;
+	} else if (count != 1) {
+		pr_err("%s: operating-points missing for few CPUs\n", __func__);
+		return -ENOENT;
+	}
+
+scan_regulator:
+	/* Check only CPU0's regulator for EPROBE_DEFER */
+	cpu_dev = get_cpu_device(0); /* Can't fail now */
+	cpu_reg = regulator_get_optional(cpu_dev, "cpu0");
+	if (!IS_ERR(cpu_reg)) {
+		regulator_put(cpu_reg);
+	} else if (PTR_ERR(cpu_reg) == -EPROBE_DEFER) {
+		/*
+		 * If cpu0 regulator supply node is present, but regulator is
+		 * not yet registered, we should try defering probe.
+		 */
+		dev_err(cpu_dev, "cpu0 regulator not ready, retry\n");
+		return -EPROBE_DEFER;
+	}
+
+	ret = cpufreq_register_driver(&cpu0_cpufreq_driver);
+	if (ret)
+		pr_err("failed register driver: %d\n", ret);
+
 	return ret;
 }
 
 static int cpu0_cpufreq_remove(struct platform_device *pdev)
 {
-	cpufreq_cooling_unregister(cdev);
 	cpufreq_unregister_driver(&cpu0_cpufreq_driver);
-	dev_pm_opp_free_cpufreq_table(cpu_dev, &freq_table);
-
 	return 0;
 }
 
-- 
2.0.0.rc2

