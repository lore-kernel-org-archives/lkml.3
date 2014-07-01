Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758573AbaGAQfV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 12:35:21 -0400
Received: from mail-pa0-f42.google.com ([209.85.220.42]:38825 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758540AbaGAQfP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 12:35:15 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@rjwysocki.net, shawn.guo@linaro.org
Cc: linaro-kernel@lists.linaro.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, arvind.chauhan@arm.com,
        sboyd@codeaurora.org, linux-arm-msm@vger.kernel.org,
        spk.linux@gmail.com, thomas.ab@samsung.com, nm@ti.com,
        t.figa@samsung.com, Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 11/14] cpufreq: cpu0: Make allocate_resources() work for any CPU
Date: Tue,  1 Jul 2014 22:02:40 +0530
Message-Id: <a05014a959751c1fdd413a2553faf93e443aa5dc.1404231535.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 2.0.0.rc2
In-Reply-To: <cover.1404231535.git.viresh.kumar@linaro.org>
References: <cover.1404231535.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1404231535.git.viresh.kumar@linaro.org>
References: <cover.1404231535.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently allocate_resources() supports only CPU0 and it would need to allocate
resources for any CPU going forward.

Add another argument to it, i.e. cpu, and update code accordingly.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/cpufreq/cpufreq-cpu0.c | 30 +++++++++++++++++-------------
 1 file changed, 17 insertions(+), 13 deletions(-)

diff --git a/drivers/cpufreq/cpufreq-cpu0.c b/drivers/cpufreq/cpufreq-cpu0.c
index 17001a8..44633f6 100644
--- a/drivers/cpufreq/cpufreq-cpu0.c
+++ b/drivers/cpufreq/cpufreq-cpu0.c
@@ -106,7 +106,7 @@ static int cpu0_set_target(struct cpufreq_policy *policy, unsigned int index)
 	return ret;
 }
 
-static int allocate_resources(struct device **cdev,
+static int allocate_resources(int cpu, struct device **cdev,
 			      struct regulator **creg, struct clk **cclk)
 {
 	struct device *cpu_dev;
@@ -115,24 +115,28 @@ static int allocate_resources(struct device **cdev,
 	int ret = 0;
 	char *reg_cpu0 = "cpu0", *reg_cpu = "cpu", *reg;
 
-	cpu_dev = get_cpu_device(0);
+	cpu_dev = get_cpu_device(cpu);
 	if (!cpu_dev) {
-		pr_err("failed to get cpu0 device\n");
+		pr_err("failed to get cpu%d device\n", cpu);
 		return -ENODEV;
 	}
 
 	/* Try "cpu0" for older DTs */
-	reg = reg_cpu0;
+	if (!cpu)
+		reg = reg_cpu0;
+	else
+		reg = reg_cpu;
 
 try_again:
 	cpu_reg = regulator_get_optional(cpu_dev, reg);
 	if (IS_ERR(cpu_reg)) {
 		/*
-		 * If cpu0 regulator supply node is present, but regulator is
+		 * If cpu's regulator supply node is present, but regulator is
 		 * not yet registered, we should try defering probe.
 		 */
 		if (PTR_ERR(cpu_reg) == -EPROBE_DEFER) {
-			dev_err(cpu_dev, "cpu0 regulator not ready, retry\n");
+			dev_err(cpu_dev, "cpu%d regulator not ready, retry\n",
+				cpu);
 			return -EPROBE_DEFER;
 		}
 
@@ -142,8 +146,8 @@ try_again:
 			goto try_again;
 		}
 
-		dev_warn(cpu_dev, "failed to get cpu0 regulator: %ld\n",
-			 PTR_ERR(cpu_reg));
+		dev_warn(cpu_dev, "failed to get cpu%d regulator: %ld\n",
+			 cpu, PTR_ERR(cpu_reg));
 	}
 
 	cpu_clk = clk_get(cpu_dev, NULL);
@@ -157,11 +161,12 @@ try_again:
 		 * registered, we should try defering probe.
 		 */
 		if (PTR_ERR(cpu_clk) == -EPROBE_DEFER) {
-			dev_err(cpu_dev, "cpu0 clock not ready, retry\n");
+			dev_err(cpu_dev, "cpu%d clock not ready, retry\n", cpu);
 			ret = -EPROBE_DEFER;
 		} else {
 			ret = PTR_ERR(cpu_clk);
-			dev_err(cpu_dev, "failed to get cpu0 clock: %d\n", ret);
+			dev_err(cpu_dev, "failed to get cpu%d clock: %d\n", ret,
+				cpu);
 		}
 	} else {
 		*cdev = cpu_dev;
@@ -184,8 +189,7 @@ static int cpu0_cpufreq_init(struct cpufreq_policy *policy)
 	unsigned int transition_latency;
 	int ret;
 
-	/* We only support cpu0 currently */
-	ret = allocate_resources(&cpu_dev, &cpu_reg, &cpu_clk);
+	ret = allocate_resources(policy->cpu, &cpu_dev, &cpu_reg, &cpu_clk);
 	if (ret) {
 		pr_err("%s: Failed to allocate resources\n: %d", __func__, ret);
 		return ret;
@@ -322,7 +326,7 @@ static int cpu0_cpufreq_probe(struct platform_device *pdev)
 	 *
 	 * FIXME: Is checking this only for CPU0 sufficient ?
 	 */
-	ret = allocate_resources(&cpu_dev, &cpu_reg, &cpu_clk);
+	ret = allocate_resources(0, &cpu_dev, &cpu_reg, &cpu_clk);
 	if (ret)
 		return ret;
 
-- 
2.0.0.rc2

