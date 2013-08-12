Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754389Ab3HLRvi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 13:51:38 -0400
Received: from mail-pa0-f47.google.com ([209.85.220.47]:57938 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752591Ab3HLRvd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 13:51:33 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Viresh Kumar <viresh.kumar@linaro.org>,
        John Crispin <blogic@openwrt.org>
Subject: [PATCH 17/31] cpufreq: loongson2: Covert to light weight ->target() routine
Date: Mon, 12 Aug 2013 23:18:53 +0530
Message-Id: <531a63246cdcba02ec21378d06891fc9a8fe587c.1376329128.git.viresh.kumar@linaro.org>
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

Cc: John Crispin <blogic@openwrt.org>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/cpufreq/loongson2_cpufreq.c | 21 +++++----------------
 1 file changed, 5 insertions(+), 16 deletions(-)

diff --git a/drivers/cpufreq/loongson2_cpufreq.c b/drivers/cpufreq/loongson2_cpufreq.c
index afdece4..a9e6e35 100644
--- a/drivers/cpufreq/loongson2_cpufreq.c
+++ b/drivers/cpufreq/loongson2_cpufreq.c
@@ -53,11 +53,9 @@ static unsigned int loongson2_cpufreq_get(unsigned int cpu)
  * Here we notify other drivers of the proposed change and the final change.
  */
 static int loongson2_cpufreq_target(struct cpufreq_policy *policy,
-				     unsigned int target_freq,
-				     unsigned int relation)
+				     unsigned int index)
 {
 	unsigned int cpu = policy->cpu;
-	unsigned int newstate = 0;
 	cpumask_t cpus_allowed;
 	struct cpufreq_freqs freqs;
 	unsigned int freq;
@@ -65,26 +63,17 @@ static int loongson2_cpufreq_target(struct cpufreq_policy *policy,
 	cpus_allowed = current->cpus_allowed;
 	set_cpus_allowed_ptr(current, cpumask_of(cpu));
 
-	if (cpufreq_frequency_table_target
-	    (policy, &loongson2_clockmod_table[0], target_freq, relation,
-	     &newstate))
-		return -EINVAL;
-
 	freq =
 	    ((cpu_clock_freq / 1000) *
-	     loongson2_clockmod_table[newstate].driver_data) / 8;
-	if (freq < policy->min || freq > policy->max)
-		return -EINVAL;
+	     loongson2_clockmod_table[index].driver_data) / 8;
 
-	pr_debug("cpufreq: requested frequency %u Hz\n", target_freq * 1000);
+	pr_debug("cpufreq: requested frequency %u Hz\n",
+			loongson2_clockmod_table[index].frequency * 1000);
 
 	freqs.old = loongson2_cpufreq_get(cpu);
 	freqs.new = freq;
 	freqs.flags = 0;
 
-	if (freqs.new == freqs.old)
-		return 0;
-
 	/* notifiers */
 	cpufreq_notify_transition(policy, &freqs, CPUFREQ_PRECHANGE);
 
@@ -148,7 +137,7 @@ static struct cpufreq_driver loongson2_cpufreq_driver = {
 	.name = "loongson2",
 	.init = loongson2_cpufreq_cpu_init,
 	.verify = cpufreq_generic_frequency_table_verify,
-	.target_old = loongson2_cpufreq_target,
+	.target = loongson2_cpufreq_target,
 	.get = loongson2_cpufreq_get,
 	.exit = loongson2_cpufreq_exit,
 	.attr = cpufreq_generic_attr,
-- 
1.7.12.rc2.18.g61b472e

