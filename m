Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932348Ab3HMNgH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 09:36:07 -0400
Received: from mail-pb0-f45.google.com ([209.85.160.45]:57564 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932328Ab3HMNgB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 09:36:01 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH V2 23/35] cpufreq: pmac32: Covert to light weight ->target_index() routine
Date: Tue, 13 Aug 2013 19:02:36 +0530
Message-Id: <e5c8fa9d9395d5dda599a4725eb8b9801c255cd2.1376392602.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1376392602.git.viresh.kumar@linaro.org>
References: <cover.1376392602.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1376392602.git.viresh.kumar@linaro.org>
References: <cover.1376392602.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch converts existing .target() to newly defined light weight
.target_index() routine for this driver.

CPUFreq core will call cpufreq_frequency_table_target() before calling this
routine and will pass index to it.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/cpufreq/pmac32-cpufreq.c | 12 +++---------
 drivers/cpufreq/pmac64-cpufreq.c | 17 ++++-------------
 2 files changed, 7 insertions(+), 22 deletions(-)

diff --git a/drivers/cpufreq/pmac32-cpufreq.c b/drivers/cpufreq/pmac32-cpufreq.c
index 3f8efd2..b1ba708 100644
--- a/drivers/cpufreq/pmac32-cpufreq.c
+++ b/drivers/cpufreq/pmac32-cpufreq.c
@@ -373,17 +373,11 @@ static unsigned int pmac_cpufreq_get_speed(unsigned int cpu)
 }
 
 static int pmac_cpufreq_target(	struct cpufreq_policy *policy,
-					unsigned int target_freq,
-					unsigned int relation)
+					unsigned int index)
 {
-	unsigned int    newstate = 0;
 	int		rc;
 
-	if (cpufreq_frequency_table_target(policy, pmac_cpu_freqs,
-			target_freq, relation, &newstate))
-		return -EINVAL;
-
-	rc = do_set_cpu_speed(policy, newstate, 1);
+	rc = do_set_cpu_speed(policy, index, 1);
 
 	ppc_proc_freq = cur_freq * 1000ul;
 	return rc;
@@ -458,7 +452,7 @@ static int pmac_cpufreq_resume(struct cpufreq_policy *policy)
 
 static struct cpufreq_driver pmac_cpufreq_driver = {
 	.verify 	= cpufreq_generic_frequency_table_verify,
-	.target 	= pmac_cpufreq_target,
+	.target_index 	= pmac_cpufreq_target,
 	.get		= pmac_cpufreq_get_speed,
 	.init		= pmac_cpufreq_cpu_init,
 	.suspend	= pmac_cpufreq_suspend,
diff --git a/drivers/cpufreq/pmac64-cpufreq.c b/drivers/cpufreq/pmac64-cpufreq.c
index 0eb9313..7679990 100644
--- a/drivers/cpufreq/pmac64-cpufreq.c
+++ b/drivers/cpufreq/pmac64-cpufreq.c
@@ -311,27 +311,18 @@ static int g5_pfunc_query_freq(void)
  * Common interface to the cpufreq core
  */
 
-static int g5_cpufreq_target(struct cpufreq_policy *policy,
-	unsigned int target_freq, unsigned int relation)
+static int g5_cpufreq_target(struct cpufreq_policy *policy, unsigned int index)
 {
-	unsigned int newstate = 0;
 	struct cpufreq_freqs freqs;
 	int rc;
 
-	if (cpufreq_frequency_table_target(policy, g5_cpu_freqs,
-			target_freq, relation, &newstate))
-		return -EINVAL;
-
-	if (g5_pmode_cur == newstate)
-		return 0;
-
 	mutex_lock(&g5_switch_mutex);
 
 	freqs.old = g5_cpu_freqs[g5_pmode_cur].frequency;
-	freqs.new = g5_cpu_freqs[newstate].frequency;
+	freqs.new = g5_cpu_freqs[index].frequency;
 
 	cpufreq_notify_transition(policy, &freqs, CPUFREQ_PRECHANGE);
-	rc = g5_switch_freq(newstate);
+	rc = g5_switch_freq(index);
 	cpufreq_notify_transition(policy, &freqs, CPUFREQ_POSTCHANGE);
 
 	mutex_unlock(&g5_switch_mutex);
@@ -362,7 +353,7 @@ static struct cpufreq_driver g5_cpufreq_driver = {
 	.flags		= CPUFREQ_CONST_LOOPS,
 	.init		= g5_cpufreq_cpu_init,
 	.verify		= cpufreq_generic_frequency_table_verify,
-	.target		= g5_cpufreq_target,
+	.target_index	= g5_cpufreq_target,
 	.get		= g5_cpufreq_get_speed,
 	.attr 		= cpufreq_generic_attr,
 };
-- 
1.7.12.rc2.18.g61b472e

