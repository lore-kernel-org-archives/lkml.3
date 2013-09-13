Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933894Ab3IMNVo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 09:21:44 -0400
Received: from mail-pb0-f41.google.com ([209.85.160.41]:49167 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933884Ab3IMNVj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 09:21:39 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Kukjin Kim <kgene.kim@samsung.com>
Subject: [PATCH 158/228] cpufreq: exynos: Convert to light weight ->target_index() routine
Date: Fri, 13 Sep 2013 18:31:44 +0530
Message-Id: <336fc7d3f04db2dec8972414e6ece8aea0c6bdc8.1379063063.git.viresh.kumar@linaro.org>
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

Cc: Kukjin Kim <kgene.kim@samsung.com>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/cpufreq/exynos-cpufreq.c     | 21 +++------------------
 drivers/cpufreq/exynos5440-cpufreq.c | 25 +++++++------------------
 2 files changed, 10 insertions(+), 36 deletions(-)

diff --git a/drivers/cpufreq/exynos-cpufreq.c b/drivers/cpufreq/exynos-cpufreq.c
index b96fcc8..c178e73 100644
--- a/drivers/cpufreq/exynos-cpufreq.c
+++ b/drivers/cpufreq/exynos-cpufreq.c
@@ -65,9 +65,6 @@ static int exynos_cpufreq_scale(unsigned int target_freq)
 	freqs.old = policy->cur;
 	freqs.new = target_freq;
 
-	if (freqs.new == freqs.old)
-		goto out;
-
 	/*
 	 * The policy max have been changed so that we cannot get proper
 	 * old_index with cpufreq_frequency_table_target(). Thus, ignore
@@ -151,13 +148,9 @@ out:
 	return ret;
 }
 
-static int exynos_target(struct cpufreq_policy *policy,
-			  unsigned int target_freq,
-			  unsigned int relation)
+static int exynos_target(struct cpufreq_policy *policy, unsigned int index)
 {
 	struct cpufreq_frequency_table *freq_table = exynos_info->freq_table;
-	unsigned int index;
-	unsigned int new_freq;
 	int ret = 0;
 
 	mutex_lock(&cpufreq_lock);
@@ -165,15 +158,7 @@ static int exynos_target(struct cpufreq_policy *policy,
 	if (frequency_locked)
 		goto out;
 
-	if (cpufreq_frequency_table_target(policy, freq_table,
-					   target_freq, relation, &index)) {
-		ret = -EINVAL;
-		goto out;
-	}
-
-	new_freq = freq_table[index].frequency;
-
-	ret = exynos_cpufreq_scale(new_freq);
+	ret = exynos_cpufreq_scale(freq_table[index].frequency);
 
 out:
 	mutex_unlock(&cpufreq_lock);
@@ -247,7 +232,7 @@ static int exynos_cpufreq_cpu_init(struct cpufreq_policy *policy)
 static struct cpufreq_driver exynos_driver = {
 	.flags		= CPUFREQ_STICKY,
 	.verify		= cpufreq_generic_frequency_table_verify,
-	.target		= exynos_target,
+	.target_index	= exynos_target,
 	.get		= exynos_getspeed,
 	.init		= exynos_cpufreq_cpu_init,
 	.exit		= cpufreq_generic_exit,
diff --git a/drivers/cpufreq/exynos5440-cpufreq.c b/drivers/cpufreq/exynos5440-cpufreq.c
index e6fae7f..340b53e 100644
--- a/drivers/cpufreq/exynos5440-cpufreq.c
+++ b/drivers/cpufreq/exynos5440-cpufreq.c
@@ -214,27 +214,17 @@ static unsigned int exynos_getspeed(unsigned int cpu)
 	return dvfs_info->cur_frequency;
 }
 
-static int exynos_target(struct cpufreq_policy *policy,
-			  unsigned int target_freq,
-			  unsigned int relation)
+static int exynos_target(struct cpufreq_policy *policy, unsigned int index)
 {
-	unsigned int index, tmp;
-	int ret = 0, i;
+	unsigned int tmp;
+	int i;
 	struct cpufreq_frequency_table *freq_table = dvfs_info->freq_table;
 
 	mutex_lock(&cpufreq_lock);
 
-	ret = cpufreq_frequency_table_target(policy, freq_table,
-					   target_freq, relation, &index);
-	if (ret)
-		goto out;
-
 	freqs.old = dvfs_info->cur_frequency;
 	freqs.new = freq_table[index].frequency;
 
-	if (freqs.old == freqs.new)
-		goto out;
-
 	cpufreq_notify_transition(policy, &freqs, CPUFREQ_PRECHANGE);
 
 	/* Set the target frequency in all C0_3_PSTATE register */
@@ -246,11 +236,10 @@ static int exynos_target(struct cpufreq_policy *policy,
 		__raw_writel(tmp, dvfs_info->base + XMU_C0_3_PSTATE + i * 4);
 	}
 
-	/* Mark transition as In-progress */
-	ret = -EINPROGRESS;
-out:
 	mutex_unlock(&cpufreq_lock);
-	return ret;
+
+	/* Mark transition as In-progress */
+	return -EINPROGRESS;
 }
 
 static void exynos_cpufreq_work(struct work_struct *work)
@@ -328,7 +317,7 @@ static int exynos_cpufreq_cpu_init(struct cpufreq_policy *policy)
 static struct cpufreq_driver exynos_driver = {
 	.flags		= CPUFREQ_STICKY | CPUFREQ_ASYNC_NOTIFICATION,
 	.verify		= cpufreq_generic_frequency_table_verify,
-	.target		= exynos_target,
+	.target_index	= exynos_target,
 	.get		= exynos_getspeed,
 	.init		= exynos_cpufreq_cpu_init,
 	.exit		= cpufreq_generic_exit,
-- 
1.7.12.rc2.18.g61b472e

