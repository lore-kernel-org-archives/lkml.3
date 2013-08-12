Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755422Ab3HLRxT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 13:53:19 -0400
Received: from mail-pd0-f169.google.com ([209.85.192.169]:57709 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755274Ab3HLRxF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 13:53:05 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Viresh Kumar <viresh.kumar@linaro.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 30/31] cpufreq: speedstep: Covert to light weight ->target() routine
Date: Mon, 12 Aug 2013 23:19:06 +0530
Message-Id: <d703d0a530a90b197f6e81d49000a262b13d5c76.1376329128.git.viresh.kumar@linaro.org>
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

Cc: David S. Miller <davem@davemloft.net>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/cpufreq/speedstep-centrino.c | 26 +++++++-------------------
 drivers/cpufreq/speedstep-ich.c      | 24 ++++++------------------
 drivers/cpufreq/speedstep-smi.c      | 20 +++++---------------
 3 files changed, 18 insertions(+), 52 deletions(-)

diff --git a/drivers/cpufreq/speedstep-centrino.c b/drivers/cpufreq/speedstep-centrino.c
index 4fa5779..9993f52 100644
--- a/drivers/cpufreq/speedstep-centrino.c
+++ b/drivers/cpufreq/speedstep-centrino.c
@@ -422,21 +422,17 @@ static int centrino_cpu_exit(struct cpufreq_policy *policy)
 /**
  * centrino_setpolicy - set a new CPUFreq policy
  * @policy: new policy
- * @target_freq: the target frequency
- * @relation: how that frequency relates to achieved frequency
- *	(CPUFREQ_RELATION_L or CPUFREQ_RELATION_H)
+ * @index: index of target frequency
  *
  * Sets a new CPUFreq policy.
  */
-static int centrino_target (struct cpufreq_policy *policy,
-			    unsigned int target_freq,
-			    unsigned int relation)
+static int centrino_target(struct cpufreq_policy *policy, unsigned int index)
 {
-	unsigned int    newstate = 0;
 	unsigned int	msr, oldmsr = 0, h = 0, cpu = policy->cpu;
 	struct cpufreq_freqs	freqs;
 	int			retval = 0;
 	unsigned int		j, first_cpu, tmp;
+	struct cpufreq_frequency_table *op_points;
 	cpumask_var_t covered_cpus;
 
 	if (unlikely(!zalloc_cpumask_var(&covered_cpus, GFP_KERNEL)))
@@ -447,16 +443,8 @@ static int centrino_target (struct cpufreq_policy *policy,
 		goto out;
 	}
 
-	if (unlikely(cpufreq_frequency_table_target(policy,
-			per_cpu(centrino_model, cpu)->op_points,
-			target_freq,
-			relation,
-			&newstate))) {
-		retval = -EINVAL;
-		goto out;
-	}
-
 	first_cpu = 1;
+	op_points = &per_cpu(centrino_model, cpu)->op_points[index];
 	for_each_cpu(j, policy->cpus) {
 		int good_cpu;
 
@@ -480,7 +468,7 @@ static int centrino_target (struct cpufreq_policy *policy,
 			break;
 		}
 
-		msr = per_cpu(centrino_model, cpu)->op_points[newstate].driver_data;
+		msr = op_points->driver_data;
 
 		if (first_cpu) {
 			rdmsr_on_cpu(good_cpu, MSR_IA32_PERF_CTL, &oldmsr, &h);
@@ -495,7 +483,7 @@ static int centrino_target (struct cpufreq_policy *policy,
 			freqs.new = extract_clock(msr, cpu, 0);
 
 			pr_debug("target=%dkHz old=%d new=%d msr=%04x\n",
-				target_freq, freqs.old, freqs.new, msr);
+				op_points->frequency, freqs.old, freqs.new, msr);
 
 			cpufreq_notify_transition(policy, &freqs,
 					CPUFREQ_PRECHANGE);
@@ -546,7 +534,7 @@ static struct cpufreq_driver centrino_driver = {
 	.init		= centrino_cpu_init,
 	.exit		= centrino_cpu_exit,
 	.verify		= cpufreq_generic_frequency_table_verify,
-	.target_old	= centrino_target,
+	.target		= centrino_target,
 	.get		= get_cur_freq,
 	.attr		= cpufreq_generic_attr,
 };
diff --git a/drivers/cpufreq/speedstep-ich.c b/drivers/cpufreq/speedstep-ich.c
index d6ff71e..9ac5586 100644
--- a/drivers/cpufreq/speedstep-ich.c
+++ b/drivers/cpufreq/speedstep-ich.c
@@ -251,36 +251,24 @@ static unsigned int speedstep_get(unsigned int cpu)
 /**
  * speedstep_target - set a new CPUFreq policy
  * @policy: new policy
- * @target_freq: the target frequency
- * @relation: how that frequency relates to achieved frequency
- *	(CPUFREQ_RELATION_L or CPUFREQ_RELATION_H)
+ * @index: index of target frequency
  *
  * Sets a new CPUFreq policy.
  */
-static int speedstep_target(struct cpufreq_policy *policy,
-			     unsigned int target_freq,
-			     unsigned int relation)
+static int speedstep_target(struct cpufreq_policy *policy, unsigned int index)
 {
-	unsigned int newstate = 0, policy_cpu;
+	unsigned int policy_cpu;
 	struct cpufreq_freqs freqs;
 
-	if (cpufreq_frequency_table_target(policy, &speedstep_freqs[0],
-				target_freq, relation, &newstate))
-		return -EINVAL;
-
 	policy_cpu = cpumask_any_and(policy->cpus, cpu_online_mask);
 	freqs.old = speedstep_get(policy_cpu);
-	freqs.new = speedstep_freqs[newstate].frequency;
+	freqs.new = speedstep_freqs[index].frequency;
 
 	pr_debug("transiting from %u to %u kHz\n", freqs.old, freqs.new);
 
-	/* no transition necessary */
-	if (freqs.old == freqs.new)
-		return 0;
-
 	cpufreq_notify_transition(policy, &freqs, CPUFREQ_PRECHANGE);
 
-	smp_call_function_single(policy_cpu, _speedstep_set_state, &newstate,
+	smp_call_function_single(policy_cpu, _speedstep_set_state, &index,
 				 true);
 
 	cpufreq_notify_transition(policy, &freqs, CPUFREQ_POSTCHANGE);
@@ -343,7 +331,7 @@ static int speedstep_cpu_init(struct cpufreq_policy *policy)
 static struct cpufreq_driver speedstep_driver = {
 	.name	= "speedstep-ich",
 	.verify	= cpufreq_generic_frequency_table_verify,
-	.target_old = speedstep_target,
+	.target	= speedstep_target,
 	.init	= speedstep_cpu_init,
 	.exit	= cpufreq_generic_exit,
 	.get	= speedstep_get,
diff --git a/drivers/cpufreq/speedstep-smi.c b/drivers/cpufreq/speedstep-smi.c
index fd8ad6e..8e219ef 100644
--- a/drivers/cpufreq/speedstep-smi.c
+++ b/drivers/cpufreq/speedstep-smi.c
@@ -235,29 +235,19 @@ static void speedstep_set_state(unsigned int state)
 /**
  * speedstep_target - set a new CPUFreq policy
  * @policy: new policy
- * @target_freq: new freq
- * @relation:
+ * @index: index of new freq
  *
  * Sets a new CPUFreq policy/freq.
  */
-static int speedstep_target(struct cpufreq_policy *policy,
-			unsigned int target_freq, unsigned int relation)
+static int speedstep_target(struct cpufreq_policy *policy, unsigned int index)
 {
-	unsigned int newstate = 0;
 	struct cpufreq_freqs freqs;
 
-	if (cpufreq_frequency_table_target(policy, &speedstep_freqs[0],
-				target_freq, relation, &newstate))
-		return -EINVAL;
-
 	freqs.old = speedstep_freqs[speedstep_get_state()].frequency;
-	freqs.new = speedstep_freqs[newstate].frequency;
-
-	if (freqs.old == freqs.new)
-		return 0;
+	freqs.new = speedstep_freqs[index].frequency;
 
 	cpufreq_notify_transition(policy, &freqs, CPUFREQ_PRECHANGE);
-	speedstep_set_state(newstate);
+	speedstep_set_state(index);
 	cpufreq_notify_transition(policy, &freqs, CPUFREQ_POSTCHANGE);
 
 	return 0;
@@ -340,7 +330,7 @@ static int speedstep_resume(struct cpufreq_policy *policy)
 static struct cpufreq_driver speedstep_driver = {
 	.name		= "speedstep-smi",
 	.verify		= cpufreq_generic_frequency_table_verify,
-	.target_old	= speedstep_target,
+	.target		= speedstep_target,
 	.init		= speedstep_cpu_init,
 	.exit		= cpufreq_generic_exit,
 	.get		= speedstep_get,
-- 
1.7.12.rc2.18.g61b472e

