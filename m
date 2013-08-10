Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161143Ab3HJGwv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Aug 2013 02:52:51 -0400
Received: from mail-pa0-f53.google.com ([209.85.220.53]:63572 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161129Ab3HJGwr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Aug 2013 02:52:47 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Viresh Kumar <viresh.kumar@linaro.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 41/44] cpufreq: speedstep: Use generic cpufreq routines
Date: Sat, 10 Aug 2013 12:14:37 +0530
Message-Id: <3e5741bde97d78aa2f738c4cecab7c40d77ce51b.1376116345.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1376116344.git.viresh.kumar@linaro.org>
References: <cover.1376116344.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1376116344.git.viresh.kumar@linaro.org>
References: <cover.1376116344.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Most of the CPUFreq drivers do similar things in .exit() and .verify() routines
and .attr. So its better if we have generic routines for them which can be used
by cpufreq drivers then.

This patch uses these generic routines for this driver.

Cc: David S. Miller <davem@davemloft.net>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/cpufreq/speedstep-centrino.c | 22 ++--------------------
 drivers/cpufreq/speedstep-ich.c      | 30 +++---------------------------
 drivers/cpufreq/speedstep-smi.c      | 30 +++---------------------------
 3 files changed, 8 insertions(+), 74 deletions(-)

diff --git a/drivers/cpufreq/speedstep-centrino.c b/drivers/cpufreq/speedstep-centrino.c
index f180561..c7c14ae 100644
--- a/drivers/cpufreq/speedstep-centrino.c
+++ b/drivers/cpufreq/speedstep-centrino.c
@@ -420,19 +420,6 @@ static int centrino_cpu_exit(struct cpufreq_policy *policy)
 }
 
 /**
- * centrino_verify - verifies a new CPUFreq policy
- * @policy: new policy
- *
- * Limit must be within this model's frequency range at least one
- * border included.
- */
-static int centrino_verify (struct cpufreq_policy *policy)
-{
-	return cpufreq_frequency_table_verify(policy,
-			per_cpu(centrino_model, policy->cpu)->op_points);
-}
-
-/**
  * centrino_setpolicy - set a new CPUFreq policy
  * @policy: new policy
  * @target_freq: the target frequency
@@ -553,20 +540,15 @@ out:
 	return retval;
 }
 
-static struct freq_attr* centrino_attr[] = {
-	&cpufreq_freq_attr_scaling_available_freqs,
-	NULL,
-};
-
 static struct cpufreq_driver centrino_driver = {
 	.name		= "centrino", /* should be speedstep-centrino,
 					 but there's a 16 char limit */
 	.init		= centrino_cpu_init,
 	.exit		= centrino_cpu_exit,
-	.verify		= centrino_verify,
+	.verify		= cpufreq_generic_frequency_table_verify,
 	.target		= centrino_target,
 	.get		= get_cur_freq,
-	.attr           = centrino_attr,
+	.attr		= cpufreq_generic_attr,
 };
 
 /*
diff --git a/drivers/cpufreq/speedstep-ich.c b/drivers/cpufreq/speedstep-ich.c
index 86a184e..929a4f0 100644
--- a/drivers/cpufreq/speedstep-ich.c
+++ b/drivers/cpufreq/speedstep-ich.c
@@ -289,18 +289,6 @@ static int speedstep_target(struct cpufreq_policy *policy,
 }
 
 
-/**
- * speedstep_verify - verifies a new CPUFreq policy
- * @policy: new policy
- *
- * Limit must be within speedstep_low_freq and speedstep_high_freq, with
- * at least one border included.
- */
-static int speedstep_verify(struct cpufreq_policy *policy)
-{
-	return cpufreq_frequency_table_verify(policy, &speedstep_freqs[0]);
-}
-
 struct get_freqs {
 	struct cpufreq_policy *policy;
 	int ret;
@@ -352,26 +340,14 @@ static int speedstep_cpu_init(struct cpufreq_policy *policy)
 }
 
 
-static int speedstep_cpu_exit(struct cpufreq_policy *policy)
-{
-	cpufreq_frequency_table_put_attr(policy->cpu);
-	return 0;
-}
-
-static struct freq_attr *speedstep_attr[] = {
-	&cpufreq_freq_attr_scaling_available_freqs,
-	NULL,
-};
-
-
 static struct cpufreq_driver speedstep_driver = {
 	.name	= "speedstep-ich",
-	.verify	= speedstep_verify,
+	.verify	= cpufreq_generic_frequency_table_verify,
 	.target	= speedstep_target,
 	.init	= speedstep_cpu_init,
-	.exit	= speedstep_cpu_exit,
+	.exit	= cpufreq_generic_exit,
 	.get	= speedstep_get,
-	.attr	= speedstep_attr,
+	.attr	= cpufreq_generic_attr,
 };
 
 static const struct x86_cpu_id ss_smi_ids[] = {
diff --git a/drivers/cpufreq/speedstep-smi.c b/drivers/cpufreq/speedstep-smi.c
index f4d0318..b3dfba0 100644
--- a/drivers/cpufreq/speedstep-smi.c
+++ b/drivers/cpufreq/speedstep-smi.c
@@ -264,19 +264,6 @@ static int speedstep_target(struct cpufreq_policy *policy,
 }
 
 
-/**
- * speedstep_verify - verifies a new CPUFreq policy
- * @policy: new policy
- *
- * Limit must be within speedstep_low_freq and speedstep_high_freq, with
- * at least one border included.
- */
-static int speedstep_verify(struct cpufreq_policy *policy)
-{
-	return cpufreq_frequency_table_verify(policy, &speedstep_freqs[0]);
-}
-
-
 static int speedstep_cpu_init(struct cpufreq_policy *policy)
 {
 	int result;
@@ -332,12 +319,6 @@ static int speedstep_cpu_init(struct cpufreq_policy *policy)
 	return cpufreq_table_validate_and_show(policy, speedstep_freqs);
 }
 
-static int speedstep_cpu_exit(struct cpufreq_policy *policy)
-{
-	cpufreq_frequency_table_put_attr(policy->cpu);
-	return 0;
-}
-
 static unsigned int speedstep_get(unsigned int cpu)
 {
 	if (cpu)
@@ -356,20 +337,15 @@ static int speedstep_resume(struct cpufreq_policy *policy)
 	return result;
 }
 
-static struct freq_attr *speedstep_attr[] = {
-	&cpufreq_freq_attr_scaling_available_freqs,
-	NULL,
-};
-
 static struct cpufreq_driver speedstep_driver = {
 	.name		= "speedstep-smi",
-	.verify		= speedstep_verify,
+	.verify		= cpufreq_generic_frequency_table_verify,
 	.target		= speedstep_target,
 	.init		= speedstep_cpu_init,
-	.exit		= speedstep_cpu_exit,
+	.exit		= cpufreq_generic_exit,
 	.get		= speedstep_get,
 	.resume		= speedstep_resume,
-	.attr		= speedstep_attr,
+	.attr		= cpufreq_generic_attr,
 };
 
 static const struct x86_cpu_id ss_smi_ids[] = {
-- 
1.7.12.rc2.18.g61b472e

