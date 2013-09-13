Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934263Ab3IMNZ6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 09:25:58 -0400
Received: from mail-pa0-f47.google.com ([209.85.220.47]:46194 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934248Ab3IMNZv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 09:25:51 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Kukjin Kim <kgene.kim@samsung.com>
Subject: [PATCH 192/228] cpufreq: exynos: remove calls to cpufreq_notify_transition()
Date: Fri, 13 Sep 2013 18:32:18 +0530
Message-Id: <94a34642c0c66642a7da2ec8c4c147b6fbd0ecf1.1379063063.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1379063063.git.viresh.kumar@linaro.org>
References: <cover.1379063063.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1379063063.git.viresh.kumar@linaro.org>
References: <cover.1379063063.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Most of the drivers do following in their ->target_index() routines:

	struct cpufreq_freqs freqs;
	freqs.old = old freq...
	freqs.new = new freq...

	cpufreq_notify_transition(policy, &freqs, CPUFREQ_PRECHANGE);

	/* Change rate here */

	cpufreq_notify_transition(policy, &freqs, CPUFREQ_POSTCHANGE);

This is replicated over all cpufreq drivers today and there doesn't exists a
good enough reason why this shouldn't be moved to cpufreq core instead.

Earlier patches have added support in cpufreq core to do cpufreq notification on
frequency change, this one removes it from this driver.

Some related minor cleanups are also done along with it.

Cc: Kukjin Kim <kgene.kim@samsung.com>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/cpufreq/exynos-cpufreq.c | 28 ++++++++--------------------
 1 file changed, 8 insertions(+), 20 deletions(-)

diff --git a/drivers/cpufreq/exynos-cpufreq.c b/drivers/cpufreq/exynos-cpufreq.c
index c178e73..c9ae7e6 100644
--- a/drivers/cpufreq/exynos-cpufreq.c
+++ b/drivers/cpufreq/exynos-cpufreq.c
@@ -25,7 +25,6 @@
 static struct exynos_dvfs_info *exynos_info;
 
 static struct regulator *arm_regulator;
-static struct cpufreq_freqs freqs;
 
 static unsigned int locking_frequency;
 static bool frequency_locked;
@@ -59,18 +58,18 @@ static int exynos_cpufreq_scale(unsigned int target_freq)
 	struct cpufreq_policy *policy = cpufreq_cpu_get(0);
 	unsigned int arm_volt, safe_arm_volt = 0;
 	unsigned int mpll_freq_khz = exynos_info->mpll_freq_khz;
+	unsigned int old_freq;
 	int index, old_index;
 	int ret = 0;
 
-	freqs.old = policy->cur;
-	freqs.new = target_freq;
+	old_freq = policy->cur;
 
 	/*
 	 * The policy max have been changed so that we cannot get proper
 	 * old_index with cpufreq_frequency_table_target(). Thus, ignore
 	 * policy and get the index from the raw freqeuncy table.
 	 */
-	old_index = exynos_cpufreq_get_index(freqs.old);
+	old_index = exynos_cpufreq_get_index(old_freq);
 	if (old_index < 0) {
 		ret = old_index;
 		goto out;
@@ -95,17 +94,14 @@ static int exynos_cpufreq_scale(unsigned int target_freq)
 	}
 	arm_volt = volt_table[index];
 
-	cpufreq_notify_transition(policy, &freqs, CPUFREQ_PRECHANGE);
-
 	/* When the new frequency is higher than current frequency */
-	if ((freqs.new > freqs.old) && !safe_arm_volt) {
+	if ((target_freq > old_freq) && !safe_arm_volt) {
 		/* Firstly, voltage up to increase frequency */
 		ret = regulator_set_voltage(arm_regulator, arm_volt, arm_volt);
 		if (ret) {
 			pr_err("%s: failed to set cpu voltage to %d\n",
 				__func__, arm_volt);
-			freqs.new = freqs.old;
-			goto post_notify;
+			return ret;
 		}
 	}
 
@@ -115,22 +111,15 @@ static int exynos_cpufreq_scale(unsigned int target_freq)
 		if (ret) {
 			pr_err("%s: failed to set cpu voltage to %d\n",
 				__func__, safe_arm_volt);
-			freqs.new = freqs.old;
-			goto post_notify;
+			return ret;
 		}
 	}
 
 	exynos_info->set_freq(old_index, index);
 
-post_notify:
-	cpufreq_notify_transition(policy, &freqs, CPUFREQ_POSTCHANGE);
-
-	if (ret)
-		goto out;
-
 	/* When the new frequency is lower than current frequency */
-	if ((freqs.new < freqs.old) ||
-	   ((freqs.new > freqs.old) && safe_arm_volt)) {
+	if ((target_freq < old_freq) ||
+	   ((target_freq > old_freq) && safe_arm_volt)) {
 		/* down the voltage after frequency change */
 		regulator_set_voltage(arm_regulator, arm_volt,
 				arm_volt);
@@ -142,7 +131,6 @@ post_notify:
 	}
 
 out:
-
 	cpufreq_cpu_put(policy);
 
 	return ret;
-- 
1.7.12.rc2.18.g61b472e

