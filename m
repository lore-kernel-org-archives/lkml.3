Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753921Ab3HLRvH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 13:51:07 -0400
Received: from mail-pa0-f45.google.com ([209.85.220.45]:48490 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753641Ab3HLRu6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 13:50:58 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Viresh Kumar <viresh.kumar@linaro.org>,
        Kukjin Kim <kgene.kim@samsung.com>
Subject: [PATCH 12/31] cpufreq: exynos: Covert to light weight ->target() routine
Date: Mon, 12 Aug 2013 23:18:48 +0530
Message-Id: <ad757048eb41712f53e81d5183b0f34e1e095cc2.1376329128.git.viresh.kumar@linaro.org>
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

Cc: Kukjin Kim <kgene.kim@samsung.com>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/cpufreq/exynos-cpufreq.c     | 21 +++------------------
 drivers/cpufreq/exynos5440-cpufreq.c | 13 +++----------
 2 files changed, 6 insertions(+), 28 deletions(-)

diff --git a/drivers/cpufreq/exynos-cpufreq.c b/drivers/cpufreq/exynos-cpufreq.c
index 2be2136..475bb40 100644
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
@@ -254,7 +239,7 @@ static int exynos_cpufreq_cpu_init(struct cpufreq_policy *policy)
 static struct cpufreq_driver exynos_driver = {
 	.flags		= CPUFREQ_STICKY,
 	.verify		= cpufreq_generic_frequency_table_verify,
-	.target_old	= exynos_target,
+	.target		= exynos_target,
 	.get		= exynos_getspeed,
 	.init		= exynos_cpufreq_cpu_init,
 	.exit		= cpufreq_generic_exit,
diff --git a/drivers/cpufreq/exynos5440-cpufreq.c b/drivers/cpufreq/exynos5440-cpufreq.c
index 7ad813f..872b146 100644
--- a/drivers/cpufreq/exynos5440-cpufreq.c
+++ b/drivers/cpufreq/exynos5440-cpufreq.c
@@ -214,21 +214,14 @@ static unsigned int exynos_getspeed(unsigned int cpu)
 	return dvfs_info->cur_frequency;
 }
 
-static int exynos_target(struct cpufreq_policy *policy,
-			  unsigned int target_freq,
-			  unsigned int relation)
+static int exynos_target(struct cpufreq_policy *policy, unsigned int index)
 {
-	unsigned int index, tmp;
+	unsigned int tmp;
 	int ret = 0, i;
 	struct cpufreq_frequency_table *freq_table = dvfs_info->freq_table;
 
 	mutex_lock(&cpufreq_lock);
 
-	ret = cpufreq_frequency_table_target(policy, freq_table,
-					   target_freq, relation, &index);
-	if (ret)
-		goto out;
-
 	freqs.old = dvfs_info->cur_frequency;
 	freqs.new = freq_table[index].frequency;
 
@@ -333,7 +326,7 @@ static int exynos_cpufreq_cpu_init(struct cpufreq_policy *policy)
 static struct cpufreq_driver exynos_driver = {
 	.flags		= CPUFREQ_STICKY,
 	.verify		= cpufreq_generic_frequency_table_verify,
-	.target_old	= exynos_target,
+	.target		= exynos_target,
 	.get		= exynos_getspeed,
 	.init		= exynos_cpufreq_cpu_init,
 	.exit		= cpufreq_generic_exit,
-- 
1.7.12.rc2.18.g61b472e

