Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758538AbaGAQe5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 12:34:57 -0400
Received: from mail-pa0-f47.google.com ([209.85.220.47]:53872 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758518AbaGAQez (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 12:34:55 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@rjwysocki.net, shawn.guo@linaro.org
Cc: linaro-kernel@lists.linaro.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, arvind.chauhan@arm.com,
        sboyd@codeaurora.org, linux-arm-msm@vger.kernel.org,
        spk.linux@gmail.com, thomas.ab@samsung.com, nm@ti.com,
        t.figa@samsung.com, Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 09/14] cpufreq: cpu0: Move per-cluster initialization code to ->init()
Date: Tue,  1 Jul 2014 22:02:38 +0530
Message-Id: <b26946cc4573904cd1ef0212ad053a983b547c23.1404231535.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 2.0.0.rc2
In-Reply-To: <cover.1404231535.git.viresh.kumar@linaro.org>
References: <cover.1404231535.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1404231535.git.viresh.kumar@linaro.org>
References: <cover.1404231535.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently this driver only support platforms on which all CPUs share clock &
voltage lines and there is requirement to support platforms which have separate
clock & voltage lines for CPUs, like Qualcomm's Krait and ARM's big LITTLE.

Each group of CPUs sharing clock/voltage lines are represented by 'struct
cpufreq_policy' in cpufreq framework. And core calls ->init() once for each
policy.

Currently we do all initialization/allocation from probe() which wouldn't work
for above scenario. To make it work for these platforms, the first step is to
move all initialization/allocation to ->init() and add ->exit() to do the
reverse of it.

Also, remove all global variables and allocate space for them at runtime.

This patch creates 'struct private_data' for keeping all such information and
a pointer to that would be stored in policy->driver_data.

The changed probe() routine now tries to see if regulator/clocks are available
or we need to defer probe. In case they are available, it registers cpufreq
driver. Otherwise, returns with -EPROBE_DEFER.

We still *don't* support platforms with separate clock/voltage lines for CPUs.
This would be done in a separate patch.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/cpufreq/cpufreq-cpu0.c | 189 +++++++++++++++++++++++++++++------------
 1 file changed, 136 insertions(+), 53 deletions(-)

diff --git a/drivers/cpufreq/cpufreq-cpu0.c b/drivers/cpufreq/cpufreq-cpu0.c
index 2b7b0ea..15b8e7a 100644
--- a/drivers/cpufreq/cpufreq-cpu0.c
+++ b/drivers/cpufreq/cpufreq-cpu0.c
@@ -28,18 +28,21 @@
 #include <linux/slab.h>
 #include <linux/thermal.h>
 
-static unsigned int transition_latency;
-static unsigned int voltage_tolerance; /* in percentage */
-
-static struct device *cpu_dev;
-static struct clk *cpu_clk;
-static struct regulator *cpu_reg;
-static struct cpufreq_frequency_table *freq_table;
-static struct thermal_cooling_device *cdev;
+struct private_data {
+	struct device *cpu_dev;
+	struct regulator *cpu_reg;
+	struct thermal_cooling_device *cdev;
+	unsigned int voltage_tolerance; /* in percentage */
+};
 
 static int cpu0_set_target(struct cpufreq_policy *policy, unsigned int index)
 {
 	struct dev_pm_opp *opp;
+	struct cpufreq_frequency_table *freq_table = policy->freq_table;
+	struct clk *cpu_clk = policy->clk;
+	struct private_data *priv = policy->driver_data;
+	struct device *cpu_dev = priv->cpu_dev;
+	struct regulator *cpu_reg = priv->cpu_reg;
 	unsigned long volt = 0, volt_old = 0, tol = 0;
 	unsigned int old_freq, new_freq;
 	long freq_Hz, freq_exact;
@@ -64,7 +67,7 @@ static int cpu0_set_target(struct cpufreq_policy *policy, unsigned int index)
 		}
 		volt = dev_pm_opp_get_voltage(opp);
 		rcu_read_unlock();
-		tol = volt * voltage_tolerance / 100;
+		tol = volt * priv->voltage_tolerance / 100;
 		volt_old = regulator_get_voltage(cpu_reg);
 	}
 
@@ -103,26 +106,13 @@ static int cpu0_set_target(struct cpufreq_policy *policy, unsigned int index)
 	return ret;
 }
 
-static int cpu0_cpufreq_init(struct cpufreq_policy *policy)
-{
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
+static int allocate_resources(struct device **cdev,
+			      struct regulator **creg, struct clk **cclk)
 {
-	struct device_node *np;
-	int ret;
+	struct device *cpu_dev;
+	struct regulator *cpu_reg;
+	struct clk *cpu_clk;
+	int ret = 0;
 
 	cpu_dev = get_cpu_device(0);
 	if (!cpu_dev) {
@@ -130,12 +120,6 @@ static int cpu0_cpufreq_probe(struct platform_device *pdev)
 		return -ENODEV;
 	}
 
-	np = of_node_get(cpu_dev->of_node);
-	if (!np) {
-		dev_err(cpu_dev, "failed to find cpu0 node\n");
-		return -ENOENT;
-	}
-
 	cpu_reg = regulator_get_optional(cpu_dev, "cpu0");
 	if (IS_ERR(cpu_reg)) {
 		/*
@@ -144,8 +128,7 @@ static int cpu0_cpufreq_probe(struct platform_device *pdev)
 		 */
 		if (PTR_ERR(cpu_reg) == -EPROBE_DEFER) {
 			dev_err(cpu_dev, "cpu0 regulator not ready, retry\n");
-			ret = -EPROBE_DEFER;
-			goto out_put_node;
+			return -EPROBE_DEFER;
 		}
 		dev_warn(cpu_dev, "failed to get cpu0 regulator: %ld\n",
 			 PTR_ERR(cpu_reg));
@@ -153,6 +136,10 @@ static int cpu0_cpufreq_probe(struct platform_device *pdev)
 
 	cpu_clk = clk_get(cpu_dev, NULL);
 	if (IS_ERR(cpu_clk)) {
+		/* put regulator */
+		if (!IS_ERR(cpu_reg))
+			regulator_put(cpu_reg);
+
 		/*
 		 * If cpu's clk node is present, but clock is not yet
 		 * registered, we should try defering probe.
@@ -164,7 +151,39 @@ static int cpu0_cpufreq_probe(struct platform_device *pdev)
 			ret = PTR_ERR(cpu_clk);
 			dev_err(cpu_dev, "failed to get cpu0 clock: %d\n", ret);
 		}
-		goto out_put_reg;
+	} else {
+		*cdev = cpu_dev;
+		*creg = cpu_reg;
+		*cclk = cpu_clk;
+	}
+
+	return ret;
+}
+
+static int cpu0_cpufreq_init(struct cpufreq_policy *policy)
+{
+	struct cpufreq_frequency_table *freq_table;
+	struct thermal_cooling_device *cdev;
+	struct device_node *np;
+	struct private_data *priv;
+	struct device *cpu_dev;
+	struct regulator *cpu_reg;
+	struct clk *cpu_clk;
+	unsigned int transition_latency;
+	int ret;
+
+	/* We only support cpu0 currently */
+	ret = allocate_resources(&cpu_dev, &cpu_reg, &cpu_clk);
+	if (ret) {
+		pr_err("%s: Failed to allocate resources\n: %d", __func__, ret);
+		return ret;
+	}
+
+	np = of_node_get(cpu_dev->of_node);
+	if (!np) {
+		dev_err(cpu_dev, "failed to find cpu%d node\n", policy->cpu);
+		ret = -ENOENT;
+		goto out_put_reg_clk;
 	}
 
 	/* OPPs might be populated at runtime, don't check for error here */
@@ -173,10 +192,16 @@ static int cpu0_cpufreq_probe(struct platform_device *pdev)
 	ret = dev_pm_opp_init_cpufreq_table(cpu_dev, &freq_table);
 	if (ret) {
 		dev_err(cpu_dev, "failed to init cpufreq table: %d\n", ret);
-		goto out_put_clk;
+		goto out_put_node;
+	}
+
+	priv = kzalloc(sizeof(*priv), GFP_KERNEL);
+	if (!priv) {
+		ret = -ENOMEM;
+		goto out_free_table;
 	}
 
-	of_property_read_u32(np, "voltage-tolerance", &voltage_tolerance);
+	of_property_read_u32(np, "voltage-tolerance", &priv->voltage_tolerance);
 
 	if (of_property_read_u32(np, "clock-latency", &transition_latency))
 		transition_latency = CPUFREQ_ETERNAL;
@@ -206,12 +231,6 @@ static int cpu0_cpufreq_probe(struct platform_device *pdev)
 			transition_latency += ret * 1000;
 	}
 
-	ret = cpufreq_register_driver(&cpu0_cpufreq_driver);
-	if (ret) {
-		dev_err(cpu_dev, "failed to register driver: %d\n", ret);
-		goto out_free_table;
-	}
-
 	/*
 	 * For now, just loading the cooling device;
 	 * thermal DT code takes care of matching them.
@@ -223,28 +242,92 @@ static int cpu0_cpufreq_probe(struct platform_device *pdev)
 				"running cpufreq without cooling device: %ld\n",
 				PTR_ERR(cdev));
 	}
-
 	of_node_put(np);
+
+	priv->cdev = cdev;
+	priv->cpu_dev = cpu_dev;
+	priv->cpu_reg = cpu_reg;
+	policy->driver_data = priv;
+
+	policy->clk = cpu_clk;
+	ret = cpufreq_generic_init(policy, freq_table, transition_latency);
+	if (ret)
+		goto out_cooling_unregister;
+
 	return 0;
 
+out_cooling_unregister:
+	cpufreq_cooling_unregister(priv->cdev);
+	kfree(priv);
 out_free_table:
 	dev_pm_opp_free_cpufreq_table(cpu_dev, &freq_table);
-out_put_clk:
+out_put_node:
+	of_node_put(np);
+out_put_reg_clk:
 	clk_put(cpu_clk);
-out_put_reg:
 	if (!IS_ERR(cpu_reg))
 		regulator_put(cpu_reg);
-out_put_node:
-	of_node_put(np);
+
+	return ret;
+}
+
+static int cpu0_cpufreq_exit(struct cpufreq_policy *policy)
+{
+	struct private_data *priv = policy->driver_data;
+
+	cpufreq_cooling_unregister(priv->cdev);
+	dev_pm_opp_free_cpufreq_table(priv->cpu_dev, &policy->freq_table);
+	clk_put(policy->clk);
+	if (!IS_ERR(priv->cpu_reg))
+		regulator_put(priv->cpu_reg);
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
+	struct device *cpu_dev;
+	struct regulator *cpu_reg;
+	struct clk *cpu_clk;
+	int ret;
+
+	/*
+	 * All per-cluster (CPUs sharing clock/voltages) initialization is done
+	 * from ->init(). In probe(), we just need to make sure that clk and
+	 * regulators are available. Else defer probe and retry.
+	 *
+	 * FIXME: Is checking this only for CPU0 sufficient ?
+	 */
+	ret = allocate_resources(&cpu_dev, &cpu_reg, &cpu_clk);
+	if (ret)
+		return ret;
+
+	clk_put(cpu_clk);
+	if (!IS_ERR(cpu_reg))
+		regulator_put(cpu_reg);
+
+	ret = cpufreq_register_driver(&cpu0_cpufreq_driver);
+	if (ret)
+		dev_err(cpu_dev, "failed register driver: %d\n", ret);
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

