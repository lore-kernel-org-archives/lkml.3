Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968476Ab3HJGvk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Aug 2013 02:51:40 -0400
Received: from mail-pa0-f50.google.com ([209.85.220.50]:60143 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S968462Ab3HJGvf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Aug 2013 02:51:35 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 31/44] cpufreq: powernow: Use generic cpufreq routines
Date: Sat, 10 Aug 2013 12:14:27 +0530
Message-Id: <401cbb7894bfc84ab2b398e262a4538532f59aac.1376116345.git.viresh.kumar@linaro.org>
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

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/cpufreq/powernow-k6.c | 22 ++--------------------
 drivers/cpufreq/powernow-k7.c | 14 ++------------
 drivers/cpufreq/powernow-k8.c | 20 ++------------------
 3 files changed, 6 insertions(+), 50 deletions(-)

diff --git a/drivers/cpufreq/powernow-k6.c b/drivers/cpufreq/powernow-k6.c
index ab1de0d..ff05d28 100644
--- a/drivers/cpufreq/powernow-k6.c
+++ b/drivers/cpufreq/powernow-k6.c
@@ -105,19 +105,6 @@ static void powernow_k6_set_state(struct cpufreq_policy *policy,
 
 
 /**
- * powernow_k6_verify - verifies a new CPUfreq policy
- * @policy: new policy
- *
- * Policy must be within lowest and highest possible CPU Frequency,
- * and at least one possible state must be within min and max.
- */
-static int powernow_k6_verify(struct cpufreq_policy *policy)
-{
-	return cpufreq_frequency_table_verify(policy, &clock_ratio[0]);
-}
-
-
-/**
  * powernow_k6_setpolicy - sets a new CPUFreq policy
  * @policy: new policy
  * @target_freq: the target frequency
@@ -188,19 +175,14 @@ static unsigned int powernow_k6_get(unsigned int cpu)
 	return ret;
 }
 
-static struct freq_attr *powernow_k6_attr[] = {
-	&cpufreq_freq_attr_scaling_available_freqs,
-	NULL,
-};
-
 static struct cpufreq_driver powernow_k6_driver = {
-	.verify		= powernow_k6_verify,
+	.verify		= cpufreq_generic_frequency_table_verify,
 	.target		= powernow_k6_target,
 	.init		= powernow_k6_cpu_init,
 	.exit		= powernow_k6_cpu_exit,
 	.get		= powernow_k6_get,
 	.name		= "powernow-k6",
-	.attr		= powernow_k6_attr,
+	.attr		= cpufreq_generic_attr,
 };
 
 static const struct x86_cpu_id powernow_k6_ids[] = {
diff --git a/drivers/cpufreq/powernow-k7.c b/drivers/cpufreq/powernow-k7.c
index c863c13..14cd98f 100644
--- a/drivers/cpufreq/powernow-k7.c
+++ b/drivers/cpufreq/powernow-k7.c
@@ -549,11 +549,6 @@ static int powernow_target(struct cpufreq_policy *policy,
 }
 
 
-static int powernow_verify(struct cpufreq_policy *policy)
-{
-	return cpufreq_frequency_table_verify(policy, powernow_table);
-}
-
 /*
  * We use the fact that the bus frequency is somehow
  * a multiple of 100000/3 khz, then we compute sgtc according
@@ -699,13 +694,8 @@ static int powernow_cpu_exit(struct cpufreq_policy *policy)
 	return 0;
 }
 
-static struct freq_attr *powernow_table_attr[] = {
-	&cpufreq_freq_attr_scaling_available_freqs,
-	NULL,
-};
-
 static struct cpufreq_driver powernow_driver = {
-	.verify		= powernow_verify,
+	.verify		= cpufreq_generic_frequency_table_verify,
 	.target		= powernow_target,
 	.get		= powernow_get,
 #ifdef CONFIG_X86_POWERNOW_K7_ACPI
@@ -714,7 +704,7 @@ static struct cpufreq_driver powernow_driver = {
 	.init		= powernow_cpu_init,
 	.exit		= powernow_cpu_exit,
 	.name		= "powernow-k7",
-	.attr		= powernow_table_attr,
+	.attr		= cpufreq_generic_attr,
 };
 
 static int __init powernow_init(void)
diff --git a/drivers/cpufreq/powernow-k8.c b/drivers/cpufreq/powernow-k8.c
index 8d4114a..1e6f68a 100644
--- a/drivers/cpufreq/powernow-k8.c
+++ b/drivers/cpufreq/powernow-k8.c
@@ -1053,17 +1053,6 @@ static int powernowk8_target(struct cpufreq_policy *pol,
 	return work_on_cpu(pol->cpu, powernowk8_target_fn, &pta);
 }
 
-/* Driver entry point to verify the policy and range of frequencies */
-static int powernowk8_verify(struct cpufreq_policy *pol)
-{
-	struct powernow_k8_data *data = per_cpu(powernow_data, pol->cpu);
-
-	if (!data)
-		return -EINVAL;
-
-	return cpufreq_frequency_table_verify(pol, data->powernow_table);
-}
-
 struct init_on_cpu {
 	struct powernow_k8_data *data;
 	int rc;
@@ -1225,20 +1214,15 @@ out:
 	return khz;
 }
 
-static struct freq_attr *powernow_k8_attr[] = {
-	&cpufreq_freq_attr_scaling_available_freqs,
-	NULL,
-};
-
 static struct cpufreq_driver cpufreq_amd64_driver = {
-	.verify		= powernowk8_verify,
+	.verify		= cpufreq_generic_frequency_table_verify,
 	.target		= powernowk8_target,
 	.bios_limit	= acpi_processor_get_bios_limit,
 	.init		= powernowk8_cpu_init,
 	.exit		= powernowk8_cpu_exit,
 	.get		= powernowk8_get,
 	.name		= "powernow-k8",
-	.attr		= powernow_k8_attr,
+	.attr		= cpufreq_generic_attr,
 };
 
 static void __request_acpi_cpufreq(void)
-- 
1.7.12.rc2.18.g61b472e

