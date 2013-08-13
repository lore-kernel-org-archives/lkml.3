Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758260Ab3HMNoC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 09:44:02 -0400
Received: from mail-pd0-f174.google.com ([209.85.192.174]:33991 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758182Ab3HMNdi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 09:33:38 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH V2 04/35] cpufreq: arm_big_little: Covert to light weight ->target_index() routine
Date: Tue, 13 Aug 2013 19:02:17 +0530
Message-Id: <9875f25f50527a9f415851a324dafb260e302928.1376392602.git.viresh.kumar@linaro.org>
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
 drivers/cpufreq/arm_big_little.c | 17 +++++------------
 1 file changed, 5 insertions(+), 12 deletions(-)

diff --git a/drivers/cpufreq/arm_big_little.c b/drivers/cpufreq/arm_big_little.c
index 7e92586..4bba5ad 100644
--- a/drivers/cpufreq/arm_big_little.c
+++ b/drivers/cpufreq/arm_big_little.c
@@ -49,28 +49,21 @@ static unsigned int bL_cpufreq_get(unsigned int cpu)
 
 /* Set clock frequency */
 static int bL_cpufreq_set_target(struct cpufreq_policy *policy,
-		unsigned int target_freq, unsigned int relation)
+		unsigned int index)
 {
 	struct cpufreq_freqs freqs;
-	u32 cpu = policy->cpu, freq_tab_idx, cur_cluster;
+	u32 cpu = policy->cpu, cur_cluster;
 	int ret = 0;
 
 	cur_cluster = cpu_to_cluster(policy->cpu);
 
 	freqs.old = bL_cpufreq_get(policy->cpu);
-
-	/* Determine valid target frequency using freq_table */
-	cpufreq_frequency_table_target(policy, freq_table[cur_cluster],
-			target_freq, relation, &freq_tab_idx);
-	freqs.new = freq_table[cur_cluster][freq_tab_idx].frequency;
+	freqs.new = freq_table[cur_cluster][index].frequency;
 
 	pr_debug("%s: cpu: %d, cluster: %d, oldfreq: %d, target freq: %d, new freq: %d\n",
-			__func__, cpu, cur_cluster, freqs.old, target_freq,
+			__func__, cpu, cur_cluster, freqs.old, freqs.new,
 			freqs.new);
 
-	if (freqs.old == freqs.new)
-		return 0;
-
 	cpufreq_notify_transition(policy, &freqs, CPUFREQ_PRECHANGE);
 
 	ret = clk_set_rate(clk[cur_cluster], freqs.new * 1000);
@@ -201,7 +194,7 @@ static struct cpufreq_driver bL_cpufreq_driver = {
 	.name			= "arm-big-little",
 	.flags			= CPUFREQ_STICKY,
 	.verify			= cpufreq_generic_frequency_table_verify,
-	.target			= bL_cpufreq_set_target,
+	.target_index		= bL_cpufreq_set_target,
 	.get			= bL_cpufreq_get,
 	.init			= bL_cpufreq_init,
 	.exit			= bL_cpufreq_exit,
-- 
1.7.12.rc2.18.g61b472e

