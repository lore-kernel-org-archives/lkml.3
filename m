Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755909Ab3HWPyJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 11:54:09 -0400
Received: from mail-pd0-f176.google.com ([209.85.192.176]:63779 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755857Ab3HWPyF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 11:54:05 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 11/16] cpufreq: ppc: use cpufreq_generic_get() routine
Date: Fri, 23 Aug 2013 21:20:46 +0530
Message-Id: <e99f1b893f4ff3987b441e5f0116c8106bfd9deb.1377272740.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1377272740.git.viresh.kumar@linaro.org>
References: <cover.1377272740.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1377272740.git.viresh.kumar@linaro.org>
References: <cover.1377272740.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We have common infrastructure available with us for getting a CPUs clk rate.
Lets use it for this driver.

We don't need a variable to hold clock anymore in struct cpu_data.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/cpufreq/ppc-corenet-cpufreq.c | 17 ++++-------------
 1 file changed, 4 insertions(+), 13 deletions(-)

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
 
-- 
1.7.12.rc2.18.g61b472e

