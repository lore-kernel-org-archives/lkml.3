Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752838AbaESGSQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 02:18:16 -0400
Received: from mail-wi0-f181.google.com ([209.85.212.181]:63078 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752811AbaESGSM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 02:18:12 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@rjwysocki.net
Cc: linaro-kernel@lists.linaro.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, arvind.chauhan@arm.com,
        inderpal.s@samsung.com, pavel@ucw.cz, nm@ti.com,
        chander.kashyap@linaro.org, Viresh Kumar <viresh.kumar@linaro.org>,
        Sudeep Holla <sudeep.holla@arm.com>
Subject: [PATCH 2/5] cpufreq: arm_big_little: don't initialize opp table
Date: Mon, 19 May 2014 11:47:22 +0530
Message-Id: <93612a01af60d392a685e37d4d47ed80997412dc.1400480033.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 2.0.0.rc2
In-Reply-To: <cover.1400480033.git.viresh.kumar@linaro.org>
References: <cover.1400480033.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1400480033.git.viresh.kumar@linaro.org>
References: <cover.1400480033.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

OPP tables are already initialized for all CPUs by cpufreq core and so we don't
need to reinitialize them from arm_big_little_dt driver.

Also, as the arm_big_little_dt driver doesn't have a .init_opp_table() callback
anymore, make it optional in arm_big_little driver.

Cc: Sudeep Holla <sudeep.holla@arm.com>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/cpufreq/arm_big_little.c    | 12 +++++++-----
 drivers/cpufreq/arm_big_little_dt.c | 18 ------------------
 2 files changed, 7 insertions(+), 23 deletions(-)

diff --git a/drivers/cpufreq/arm_big_little.c b/drivers/cpufreq/arm_big_little.c
index 1f4d4e3..561261e 100644
--- a/drivers/cpufreq/arm_big_little.c
+++ b/drivers/cpufreq/arm_big_little.c
@@ -325,11 +325,13 @@ static int _get_cluster_clk_and_freq_table(struct device *cpu_dev)
 	if (freq_table[cluster])
 		return 0;
 
-	ret = arm_bL_ops->init_opp_table(cpu_dev);
-	if (ret) {
-		dev_err(cpu_dev, "%s: init_opp_table failed, cpu: %d, err: %d\n",
+	if (arm_bL_ops->init_opp_table) {
+		ret = arm_bL_ops->init_opp_table(cpu_dev);
+		if (ret) {
+			dev_err(cpu_dev, "%s: init_opp_table failed, cpu: %d, err: %d\n",
 				__func__, cpu_dev->id, ret);
-		goto out;
+			goto out;
+		}
 	}
 
 	ret = dev_pm_opp_init_cpufreq_table(cpu_dev, &freq_table[cluster]);
@@ -542,7 +544,7 @@ int bL_cpufreq_register(struct cpufreq_arm_bL_ops *ops)
 		return -EBUSY;
 	}
 
-	if (!ops || !strlen(ops->name) || !ops->init_opp_table) {
+	if (!ops || !strlen(ops->name)) {
 		pr_err("%s: Invalid arm_bL_ops, exiting\n", __func__);
 		return -ENODEV;
 	}
diff --git a/drivers/cpufreq/arm_big_little_dt.c b/drivers/cpufreq/arm_big_little_dt.c
index 8d9d591..502182d 100644
--- a/drivers/cpufreq/arm_big_little_dt.c
+++ b/drivers/cpufreq/arm_big_little_dt.c
@@ -43,23 +43,6 @@ static struct device_node *get_cpu_node_with_valid_op(int cpu)
 	return np;
 }
 
-static int dt_init_opp_table(struct device *cpu_dev)
-{
-	struct device_node *np;
-	int ret;
-
-	np = of_node_get(cpu_dev->of_node);
-	if (!np) {
-		pr_err("failed to find cpu%d node\n", cpu_dev->id);
-		return -ENOENT;
-	}
-
-	ret = of_init_opp_table(cpu_dev);
-	of_node_put(np);
-
-	return ret;
-}
-
 static int dt_get_transition_latency(struct device *cpu_dev)
 {
 	struct device_node *np;
@@ -81,7 +64,6 @@ static int dt_get_transition_latency(struct device *cpu_dev)
 static struct cpufreq_arm_bL_ops dt_bL_ops = {
 	.name	= "dt-bl",
 	.get_transition_latency = dt_get_transition_latency,
-	.init_opp_table = dt_init_opp_table,
 };
 
 static int generic_bL_probe(struct platform_device *pdev)
-- 
2.0.0.rc2

