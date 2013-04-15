Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964842Ab3DOHFq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Apr 2013 03:05:46 -0400
Received: from mail-pa0-f49.google.com ([209.85.220.49]:46287 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935074Ab3DOHFn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Apr 2013 03:05:43 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl
Cc: cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, robin.randhawa@arm.com,
        Steve.Bannister@arm.com, Liviu.Dudau@arm.com,
        charles.garcia-tobin@arm.com, arvind.chauhan@arm.com,
        linaro-kernel@lists.linaro.org, patches@linaro.org,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 2/2] cpufreq: ARM big LITTLE: Adapt to latest cpufreq updates
Date: Mon, 15 Apr 2013 12:35:25 +0530
Message-Id: <c62439c62a0e8bf098a22a44cce0a48bfbddea39.1366009279.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <1ff24e0c044fb7a30b6244451dd440455efab43b.1366009279.git.viresh.kumar@linaro.org>
References: <1ff24e0c044fb7a30b6244451dd440455efab43b.1366009279.git.viresh.kumar@linaro.org>
In-Reply-To: <1ff24e0c044fb7a30b6244451dd440455efab43b.1366009279.git.viresh.kumar@linaro.org>
References: <1ff24e0c044fb7a30b6244451dd440455efab43b.1366009279.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This driver isn't updated to work with latest cpufreq core updates that happened
recently. Fix them.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
As original patch breaks compilation, its best to merge this patch with original
patch.

 drivers/cpufreq/arm_big_little.c | 10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/drivers/cpufreq/arm_big_little.c b/drivers/cpufreq/arm_big_little.c
index 1d29d1a..dbdf677 100644
--- a/drivers/cpufreq/arm_big_little.c
+++ b/drivers/cpufreq/arm_big_little.c
@@ -77,8 +77,6 @@ static int bL_cpufreq_set_target(struct cpufreq_policy *policy,
 			target_freq, relation, &freq_tab_idx);
 	freqs.new = freq_table[cur_cluster][freq_tab_idx].frequency;
 
-	freqs.cpu = policy->cpu;
-
 	pr_debug("%s: cpu: %d, cluster: %d, oldfreq: %d, target freq: %d, new freq: %d\n",
 			__func__, cpu, cur_cluster, freqs.old, target_freq,
 			freqs.new);
@@ -86,8 +84,7 @@ static int bL_cpufreq_set_target(struct cpufreq_policy *policy,
 	if (freqs.old == freqs.new)
 		return 0;
 
-	for_each_cpu(freqs.cpu, policy->cpus)
-		cpufreq_notify_transition(&freqs, CPUFREQ_PRECHANGE);
+	cpufreq_notify_transition(policy, &freqs, CPUFREQ_PRECHANGE);
 
 	ret = clk_set_rate(clk[cur_cluster], freqs.new * 1000);
 	if (ret) {
@@ -97,8 +94,7 @@ static int bL_cpufreq_set_target(struct cpufreq_policy *policy,
 
 	policy->cur = freqs.new;
 
-	for_each_cpu(freqs.cpu, policy->cpus)
-		cpufreq_notify_transition(&freqs, CPUFREQ_POSTCHANGE);
+	cpufreq_notify_transition(policy, &freqs, CPUFREQ_POSTCHANGE);
 
 	return ret;
 }
@@ -231,7 +227,7 @@ static struct cpufreq_driver bL_cpufreq_driver = {
 	.get			= bL_cpufreq_get,
 	.init			= bL_cpufreq_init,
 	.exit			= bL_cpufreq_exit,
-	.have_multiple_policies	= true,
+	.have_governor_per_policy = true,
 	.attr			= bL_cpufreq_attr,
 };
 
-- 
1.7.12.rc2.18.g61b472e

