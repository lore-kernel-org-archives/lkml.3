Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758509AbaGAQes (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 12:34:48 -0400
Received: from mail-pd0-f181.google.com ([209.85.192.181]:57101 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758489AbaGAQep (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 12:34:45 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@rjwysocki.net, shawn.guo@linaro.org
Cc: linaro-kernel@lists.linaro.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, arvind.chauhan@arm.com,
        sboyd@codeaurora.org, linux-arm-msm@vger.kernel.org,
        spk.linux@gmail.com, thomas.ab@samsung.com, nm@ti.com,
        t.figa@samsung.com, Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 08/14] cpufreq: cpu0: use dev_{err|warn|dbg} instead of pr_{err|warn|debug}
Date: Tue,  1 Jul 2014 22:02:37 +0530
Message-Id: <3d66efb77d0f191e142b9fedda4efa3c31c098e9.1404231535.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 2.0.0.rc2
In-Reply-To: <cover.1404231535.git.viresh.kumar@linaro.org>
References: <cover.1404231535.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1404231535.git.viresh.kumar@linaro.org>
References: <cover.1404231535.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We already have cpu_dev and is used at multiple places for printing errors using
dev_*(). But some prints are still using pr_*(). Lets make it consistent and
replace those pr_*() macros with dev_*() macros.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/cpufreq/cpufreq-cpu0.c | 32 ++++++++++++++++++--------------
 1 file changed, 18 insertions(+), 14 deletions(-)

diff --git a/drivers/cpufreq/cpufreq-cpu0.c b/drivers/cpufreq/cpufreq-cpu0.c
index f47f703..2b7b0ea 100644
--- a/drivers/cpufreq/cpufreq-cpu0.c
+++ b/drivers/cpufreq/cpufreq-cpu0.c
@@ -58,7 +58,8 @@ static int cpu0_set_target(struct cpufreq_policy *policy, unsigned int index)
 		opp = dev_pm_opp_find_freq_ceil(cpu_dev, &freq_Hz);
 		if (IS_ERR(opp)) {
 			rcu_read_unlock();
-			pr_err("failed to find OPP for %ld\n", freq_Hz);
+			dev_err(cpu_dev, "failed to find OPP for %ld\n",
+				freq_Hz);
 			return PTR_ERR(opp);
 		}
 		volt = dev_pm_opp_get_voltage(opp);
@@ -67,22 +68,23 @@ static int cpu0_set_target(struct cpufreq_policy *policy, unsigned int index)
 		volt_old = regulator_get_voltage(cpu_reg);
 	}
 
-	pr_debug("%u MHz, %ld mV --> %u MHz, %ld mV\n",
-		 old_freq / 1000, volt_old ? volt_old / 1000 : -1,
-		 new_freq / 1000, volt ? volt / 1000 : -1);
+	dev_dbg(cpu_dev, "%u MHz, %ld mV --> %u MHz, %ld mV\n",
+		old_freq / 1000, volt_old ? volt_old / 1000 : -1,
+		new_freq / 1000, volt ? volt / 1000 : -1);
 
 	/* scaling up?  scale voltage before frequency */
 	if (!IS_ERR(cpu_reg) && new_freq > old_freq) {
 		ret = regulator_set_voltage_tol(cpu_reg, volt, tol);
 		if (ret) {
-			pr_err("failed to scale voltage up: %d\n", ret);
+			dev_err(cpu_dev, "failed to scale voltage up: %d\n",
+				ret);
 			return ret;
 		}
 	}
 
 	ret = clk_set_rate(cpu_clk, freq_exact);
 	if (ret) {
-		pr_err("failed to set clock rate: %d\n", ret);
+		dev_err(cpu_dev, "failed to set clock rate: %d\n", ret);
 		if (!IS_ERR(cpu_reg))
 			regulator_set_voltage_tol(cpu_reg, volt_old, tol);
 		return ret;
@@ -92,7 +94,8 @@ static int cpu0_set_target(struct cpufreq_policy *policy, unsigned int index)
 	if (!IS_ERR(cpu_reg) && new_freq < old_freq) {
 		ret = regulator_set_voltage_tol(cpu_reg, volt, tol);
 		if (ret) {
-			pr_err("failed to scale voltage down: %d\n", ret);
+			dev_err(cpu_dev, "failed to scale voltage down: %d\n",
+				ret);
 			clk_set_rate(cpu_clk, old_freq * 1000);
 		}
 	}
@@ -129,7 +132,7 @@ static int cpu0_cpufreq_probe(struct platform_device *pdev)
 
 	np = of_node_get(cpu_dev->of_node);
 	if (!np) {
-		pr_err("failed to find cpu0 node\n");
+		dev_err(cpu_dev, "failed to find cpu0 node\n");
 		return -ENOENT;
 	}
 
@@ -144,8 +147,8 @@ static int cpu0_cpufreq_probe(struct platform_device *pdev)
 			ret = -EPROBE_DEFER;
 			goto out_put_node;
 		}
-		pr_warn("failed to get cpu0 regulator: %ld\n",
-			PTR_ERR(cpu_reg));
+		dev_warn(cpu_dev, "failed to get cpu0 regulator: %ld\n",
+			 PTR_ERR(cpu_reg));
 	}
 
 	cpu_clk = clk_get(cpu_dev, NULL);
@@ -169,7 +172,7 @@ static int cpu0_cpufreq_probe(struct platform_device *pdev)
 
 	ret = dev_pm_opp_init_cpufreq_table(cpu_dev, &freq_table);
 	if (ret) {
-		pr_err("failed to init cpufreq table: %d\n", ret);
+		dev_err(cpu_dev, "failed to init cpufreq table: %d\n", ret);
 		goto out_put_clk;
 	}
 
@@ -205,7 +208,7 @@ static int cpu0_cpufreq_probe(struct platform_device *pdev)
 
 	ret = cpufreq_register_driver(&cpu0_cpufreq_driver);
 	if (ret) {
-		pr_err("failed register driver: %d\n", ret);
+		dev_err(cpu_dev, "failed to register driver: %d\n", ret);
 		goto out_free_table;
 	}
 
@@ -216,8 +219,9 @@ static int cpu0_cpufreq_probe(struct platform_device *pdev)
 	if (of_find_property(np, "#cooling-cells", NULL)) {
 		cdev = of_cpufreq_cooling_register(np, cpu_present_mask);
 		if (IS_ERR(cdev))
-			pr_err("running cpufreq without cooling device: %ld\n",
-			       PTR_ERR(cdev));
+			dev_err(cpu_dev,
+				"running cpufreq without cooling device: %ld\n",
+				PTR_ERR(cdev));
 	}
 
 	of_node_put(np);
-- 
2.0.0.rc2

