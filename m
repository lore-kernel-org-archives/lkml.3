Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754807Ab3HLRwV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 13:52:21 -0400
Received: from mail-pd0-f172.google.com ([209.85.192.172]:60115 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754723Ab3HLRwP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 13:52:15 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 23/31] cpufreq: powernow: Covert to light weight ->target() routine
Date: Mon, 12 Aug 2013 23:18:59 +0530
Message-Id: <346358ee8aad6e1c0eb570d24b801fe5f600fce0.1376329128.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1376329128.git.viresh.kumar@linaro.org>
References: <cover.1376329128.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1376329128.git.viresh.kumar@linaro.org>
References: <cover.1376329128.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch converts existing .target_old() to newly defined light weight
.target() routine for this driver.

CPUFreq core will call cpufreq_frequency_table_target() before calling this
routine and will pass index to it.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/cpufreq/powernow-k6.c | 35 +++++------------------------------
 drivers/cpufreq/powernow-k7.c | 22 ++++------------------
 drivers/cpufreq/powernow-k8.c | 24 ++++++++----------------
 3 files changed, 17 insertions(+), 64 deletions(-)

diff --git a/drivers/cpufreq/powernow-k6.c b/drivers/cpufreq/powernow-k6.c
index 5e8db02..427f362 100644
--- a/drivers/cpufreq/powernow-k6.c
+++ b/drivers/cpufreq/powernow-k6.c
@@ -63,12 +63,12 @@ static int powernow_k6_get_cpu_multiplier(void)
 
 
 /**
- * powernow_k6_set_state - set the PowerNow! multiplier
+ * powernow_k6_target - set the PowerNow! multiplier
  * @best_i: clock_ratio[best_i] is the target multiplier
  *
  *   Tries to change the PowerNow! multiplier
  */
-static void powernow_k6_set_state(struct cpufreq_policy *policy,
+static int powernow_k6_target(struct cpufreq_policy *policy,
 		unsigned int best_i)
 {
 	unsigned long outvalue = 0, invalue = 0;
@@ -77,7 +77,7 @@ static void powernow_k6_set_state(struct cpufreq_policy *policy,
 
 	if (clock_ratio[best_i].driver_data > max_multiplier) {
 		printk(KERN_ERR PFX "invalid target frequency\n");
-		return;
+		return -EINVAL;
 	}
 
 	freqs.old = busfreq * powernow_k6_get_cpu_multiplier();
@@ -100,31 +100,6 @@ static void powernow_k6_set_state(struct cpufreq_policy *policy,
 
 	cpufreq_notify_transition(policy, &freqs, CPUFREQ_POSTCHANGE);
 
-	return;
-}
-
-
-/**
- * powernow_k6_setpolicy - sets a new CPUFreq policy
- * @policy: new policy
- * @target_freq: the target frequency
- * @relation: how that frequency relates to achieved frequency
- *  (CPUFREQ_RELATION_L or CPUFREQ_RELATION_H)
- *
- * sets a new CPUFreq policy
- */
-static int powernow_k6_target(struct cpufreq_policy *policy,
-			       unsigned int target_freq,
-			       unsigned int relation)
-{
-	unsigned int newstate = 0;
-
-	if (cpufreq_frequency_table_target(policy, &clock_ratio[0],
-				target_freq, relation, &newstate))
-		return -EINVAL;
-
-	powernow_k6_set_state(policy, newstate);
-
 	return 0;
 }
 
@@ -162,7 +137,7 @@ static int powernow_k6_cpu_exit(struct cpufreq_policy *policy)
 	unsigned int i;
 	for (i = 0; i < 8; i++) {
 		if (i == max_multiplier)
-			powernow_k6_set_state(policy, i);
+			powernow_k6_target(policy, i);
 	}
 	cpufreq_frequency_table_put_attr(policy->cpu);
 	return 0;
@@ -177,7 +152,7 @@ static unsigned int powernow_k6_get(unsigned int cpu)
 
 static struct cpufreq_driver powernow_k6_driver = {
 	.verify		= cpufreq_generic_frequency_table_verify,
-	.target_old	= powernow_k6_target,
+	.target		= powernow_k6_target,
 	.init		= powernow_k6_cpu_init,
 	.exit		= powernow_k6_cpu_exit,
 	.get		= powernow_k6_get,
diff --git a/drivers/cpufreq/powernow-k7.c b/drivers/cpufreq/powernow-k7.c
index 320b96a..f90737a 100644
--- a/drivers/cpufreq/powernow-k7.c
+++ b/drivers/cpufreq/powernow-k7.c
@@ -248,7 +248,7 @@ static void change_VID(int vid)
 }
 
 
-static void change_speed(struct cpufreq_policy *policy, unsigned int index)
+static int powernow_target(struct cpufreq_policy *policy, unsigned int index)
 {
 	u8 fid, vid;
 	struct cpufreq_freqs freqs;
@@ -291,6 +291,8 @@ static void change_speed(struct cpufreq_policy *policy, unsigned int index)
 		local_irq_enable();
 
 	cpufreq_notify_transition(policy, &freqs, CPUFREQ_POSTCHANGE);
+
+	return 0;
 }
 
 
@@ -533,22 +535,6 @@ static int powernow_decode_bios(int maxfid, int startvid)
 }
 
 
-static int powernow_target(struct cpufreq_policy *policy,
-			    unsigned int target_freq,
-			    unsigned int relation)
-{
-	unsigned int newstate;
-
-	if (cpufreq_frequency_table_target(policy, powernow_table, target_freq,
-				relation, &newstate))
-		return -EINVAL;
-
-	change_speed(policy, newstate);
-
-	return 0;
-}
-
-
 /*
  * We use the fact that the bus frequency is somehow
  * a multiple of 100000/3 khz, then we compute sgtc according
@@ -696,7 +682,7 @@ static int powernow_cpu_exit(struct cpufreq_policy *policy)
 
 static struct cpufreq_driver powernow_driver = {
 	.verify		= cpufreq_generic_frequency_table_verify,
-	.target_old	= powernow_target,
+	.target		= powernow_target,
 	.get		= powernow_get,
 #ifdef CONFIG_X86_POWERNOW_K7_ACPI
 	.bios_limit	= acpi_processor_get_bios_limit,
diff --git a/drivers/cpufreq/powernow-k8.c b/drivers/cpufreq/powernow-k8.c
index 053a0ce..3f70d23 100644
--- a/drivers/cpufreq/powernow-k8.c
+++ b/drivers/cpufreq/powernow-k8.c
@@ -977,20 +977,17 @@ static int transition_frequency_fidvid(struct powernow_k8_data *data,
 
 struct powernowk8_target_arg {
 	struct cpufreq_policy		*pol;
-	unsigned			targfreq;
-	unsigned			relation;
+	unsigned			newstate;
 };
 
 static long powernowk8_target_fn(void *arg)
 {
 	struct powernowk8_target_arg *pta = arg;
 	struct cpufreq_policy *pol = pta->pol;
-	unsigned targfreq = pta->targfreq;
-	unsigned relation = pta->relation;
+	unsigned newstate = pta->newstate;
 	struct powernow_k8_data *data = per_cpu(powernow_data, pol->cpu);
 	u32 checkfid;
 	u32 checkvid;
-	unsigned int newstate;
 	int ret;
 
 	if (!data)
@@ -1004,8 +1001,9 @@ static long powernowk8_target_fn(void *arg)
 		return -EIO;
 	}
 
-	pr_debug("targ: cpu %d, %d kHz, min %d, max %d, relation %d\n",
-		pol->cpu, targfreq, pol->min, pol->max, relation);
+	pr_debug("targ: cpu %d, %d kHz, min %d, max %d\n",
+		pol->cpu, data->powernow_table[newstate].frequency, pol->min,
+		pol->max);
 
 	if (query_current_values_with_pending_wait(data))
 		return -EIO;
@@ -1021,10 +1019,6 @@ static long powernowk8_target_fn(void *arg)
 		       checkvid, data->currvid);
 	}
 
-	if (cpufreq_frequency_table_target(pol, data->powernow_table,
-				targfreq, relation, &newstate))
-		return -EIO;
-
 	mutex_lock(&fidvid_mutex);
 
 	powernow_k8_acpi_pst_values(data, newstate);
@@ -1044,11 +1038,9 @@ static long powernowk8_target_fn(void *arg)
 }
 
 /* Driver entry point to switch to the target frequency */
-static int powernowk8_target(struct cpufreq_policy *pol,
-		unsigned targfreq, unsigned relation)
+static int powernowk8_target(struct cpufreq_policy *pol, unsigned index)
 {
-	struct powernowk8_target_arg pta = { .pol = pol, .targfreq = targfreq,
-					     .relation = relation };
+	struct powernowk8_target_arg pta = { .pol = pol, .newstate = index };
 
 	return work_on_cpu(pol->cpu, powernowk8_target_fn, &pta);
 }
@@ -1216,7 +1208,7 @@ out:
 
 static struct cpufreq_driver cpufreq_amd64_driver = {
 	.verify		= cpufreq_generic_frequency_table_verify,
-	.target_old	= powernowk8_target,
+	.target		= powernowk8_target,
 	.bios_limit	= acpi_processor_get_bios_limit,
 	.init		= powernowk8_cpu_init,
 	.exit		= powernowk8_cpu_exit,
-- 
1.7.12.rc2.18.g61b472e

