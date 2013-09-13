Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934080Ab3IMNYN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 09:24:13 -0400
Received: from mail-pd0-f179.google.com ([209.85.192.179]:44516 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934067Ab3IMNYG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 09:24:06 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Viresh Kumar <viresh.kumar@linaro.org>,
        "David S. Miller" <davem@davemloft.net>, sparclinux@vger.kernel.org
Subject: [PATCH 177/228] cpufreq: sparc: Convert to light weight ->target_index() routine
Date: Fri, 13 Sep 2013 18:32:03 +0530
Message-Id: <b062bbe668243a5d093830096eda9d7f2e410e05.1379063063.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1379063063.git.viresh.kumar@linaro.org>
References: <cover.1379063063.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1379063063.git.viresh.kumar@linaro.org>
References: <cover.1379063063.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch converts existing .target() to newly defined light weight
.target_index() routine for this driver.

CPUFreq core will call cpufreq_frequency_table_target() before calling this
routine and will pass index to it.

Cc: David S. Miller <davem@davemloft.net>
Cc: sparclinux@vger.kernel.org
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/cpufreq/sparc-us2e-cpufreq.c | 21 +++------------------
 drivers/cpufreq/sparc-us3-cpufreq.c  | 23 +++--------------------
 2 files changed, 6 insertions(+), 38 deletions(-)

diff --git a/drivers/cpufreq/sparc-us2e-cpufreq.c b/drivers/cpufreq/sparc-us2e-cpufreq.c
index 291688c..3bf5b8f 100644
--- a/drivers/cpufreq/sparc-us2e-cpufreq.c
+++ b/drivers/cpufreq/sparc-us2e-cpufreq.c
@@ -245,8 +245,7 @@ static unsigned int us2e_freq_get(unsigned int cpu)
 	return clock_tick / estar_to_divisor(estar);
 }
 
-static void us2e_set_cpu_divider_index(struct cpufreq_policy *policy,
-		unsigned int index)
+static int us2e_freq_target(struct cpufreq_policy *policy, unsigned int index)
 {
 	unsigned int cpu = policy->cpu;
 	unsigned long new_bits, new_freq;
@@ -277,20 +276,6 @@ static void us2e_set_cpu_divider_index(struct cpufreq_policy *policy,
 	cpufreq_notify_transition(policy, &freqs, CPUFREQ_POSTCHANGE);
 
 	set_cpus_allowed_ptr(current, &cpus_allowed);
-}
-
-static int us2e_freq_target(struct cpufreq_policy *policy,
-			  unsigned int target_freq,
-			  unsigned int relation)
-{
-	unsigned int new_index = 0;
-
-	if (cpufreq_frequency_table_target(policy,
-					   &us2e_freq_table[policy->cpu].table[0],
-					   target_freq, relation, &new_index))
-		return -EINVAL;
-
-	us2e_set_cpu_divider_index(policy, new_index);
 
 	return 0;
 }
@@ -325,7 +310,7 @@ static int us2e_freq_cpu_exit(struct cpufreq_policy *policy)
 {
 	if (cpufreq_us2e_driver) {
 		cpufreq_frequency_table_put_attr(policy->cpu);
-		us2e_set_cpu_divider_index(policy, 0);
+		us2e_freq_target(policy, 0);
 	}
 
 	return 0;
@@ -358,7 +343,7 @@ static int __init us2e_freq_init(void)
 
 		driver->init = us2e_freq_cpu_init;
 		driver->verify = cpufreq_generic_frequency_table_verify;
-		driver->target = us2e_freq_target;
+		driver->target_index = us2e_freq_target;
 		driver->get = us2e_freq_get;
 		driver->exit = us2e_freq_cpu_exit;
 		strcpy(driver->name, "UltraSPARC-IIe");
diff --git a/drivers/cpufreq/sparc-us3-cpufreq.c b/drivers/cpufreq/sparc-us3-cpufreq.c
index 9b3dbd3..2e54d55 100644
--- a/drivers/cpufreq/sparc-us3-cpufreq.c
+++ b/drivers/cpufreq/sparc-us3-cpufreq.c
@@ -93,8 +93,7 @@ static unsigned int us3_freq_get(unsigned int cpu)
 	return ret;
 }
 
-static void us3_set_cpu_divider_index(struct cpufreq_policy *policy,
-		unsigned int index)
+static int us3_freq_target(struct cpufreq_policy *policy, unsigned int index)
 {
 	unsigned int cpu = policy->cpu;
 	unsigned long new_bits, new_freq, reg;
@@ -136,22 +135,6 @@ static void us3_set_cpu_divider_index(struct cpufreq_policy *policy,
 	cpufreq_notify_transition(policy, &freqs, CPUFREQ_POSTCHANGE);
 
 	set_cpus_allowed_ptr(current, &cpus_allowed);
-}
-
-static int us3_freq_target(struct cpufreq_policy *policy,
-			  unsigned int target_freq,
-			  unsigned int relation)
-{
-	unsigned int new_index = 0;
-
-	if (cpufreq_frequency_table_target(policy,
-					   &us3_freq_table[policy->cpu].table[0],
-					   target_freq,
-					   relation,
-					   &new_index))
-		return -EINVAL;
-
-	us3_set_cpu_divider_index(policy, new_index);
 
 	return 0;
 }
@@ -182,7 +165,7 @@ static int us3_freq_cpu_exit(struct cpufreq_policy *policy)
 {
 	if (cpufreq_us3_driver) {
 		cpufreq_frequency_table_put_attr(policy->cpu);
-		us3_set_cpu_divider_index(policy, 0);
+		us3_freq_target(policy, 0);
 	}
 
 	return 0;
@@ -219,7 +202,7 @@ static int __init us3_freq_init(void)
 
 		driver->init = us3_freq_cpu_init;
 		driver->verify = cpufreq_generic_frequency_table_verify;
-		driver->target = us3_freq_target;
+		driver->target_index = us3_freq_target;
 		driver->get = us3_freq_get;
 		driver->exit = us3_freq_cpu_exit;
 		strcpy(driver->name, "UltraSPARC-III");
-- 
1.7.12.rc2.18.g61b472e

