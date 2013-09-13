Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757742Ab3IMN1X (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 09:27:23 -0400
Received: from mail-pa0-f52.google.com ([209.85.220.52]:48637 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757723Ab3IMN1S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 09:27:18 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Kukjin Kim <kgene.kim@samsung.com>
Subject: [PATCH 204/228] cpufreq: s3c: remove calls to cpufreq_notify_transition()
Date: Fri, 13 Sep 2013 18:32:30 +0530
Message-Id: <91d71b130f7a7e499852cf56de49f9f422e73da5.1379063063.git.viresh.kumar@linaro.org>
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
 drivers/cpufreq/s3c2416-cpufreq.c | 21 ++++-------------
 drivers/cpufreq/s3c64xx-cpufreq.c | 48 +++++++++++++--------------------------
 2 files changed, 20 insertions(+), 49 deletions(-)

diff --git a/drivers/cpufreq/s3c2416-cpufreq.c b/drivers/cpufreq/s3c2416-cpufreq.c
index 4188acc..8d904a0 100644
--- a/drivers/cpufreq/s3c2416-cpufreq.c
+++ b/drivers/cpufreq/s3c2416-cpufreq.c
@@ -220,7 +220,7 @@ static int s3c2416_cpufreq_set_target(struct cpufreq_policy *policy,
 				      unsigned int index)
 {
 	struct s3c2416_data *s3c_freq = &s3c2416_cpufreq;
-	struct cpufreq_freqs freqs;
+	unsigned int new_freq;
 	int idx, ret, to_dvs = 0;
 
 	mutex_lock(&cpufreq_lock);
@@ -237,25 +237,14 @@ static int s3c2416_cpufreq_set_target(struct cpufreq_policy *policy,
 		goto out;
 	}
 
-	freqs.flags = 0;
-	freqs.old = s3c_freq->is_dvs ? FREQ_DVS
-				     : clk_get_rate(s3c_freq->armclk) / 1000;
-
 	/* When leavin dvs mode, always switch the armdiv to the hclk rate
 	 * The S3C2416 has stability issues when switching directly to
 	 * higher frequencies.
 	 */
-	freqs.new = (s3c_freq->is_dvs && !to_dvs)
+	new_freq = (s3c_freq->is_dvs && !to_dvs)
 				? clk_get_rate(s3c_freq->hclk) / 1000
 				: s3c_freq->freq_table[index].frequency;
 
-	pr_debug("cpufreq: Transition %d-%dkHz\n", freqs.old, freqs.new);
-
-	if (!to_dvs && freqs.old == freqs.new)
-		goto out;
-
-	cpufreq_notify_transition(policy, &freqs, CPUFREQ_PRECHANGE);
-
 	if (to_dvs) {
 		pr_debug("cpufreq: enter dvs\n");
 		ret = s3c2416_cpufreq_enter_dvs(s3c_freq, idx);
@@ -263,12 +252,10 @@ static int s3c2416_cpufreq_set_target(struct cpufreq_policy *policy,
 		pr_debug("cpufreq: leave dvs\n");
 		ret = s3c2416_cpufreq_leave_dvs(s3c_freq, idx);
 	} else {
-		pr_debug("cpufreq: change armdiv to %dkHz\n", freqs.new);
-		ret = s3c2416_cpufreq_set_armdiv(s3c_freq, freqs.new);
+		pr_debug("cpufreq: change armdiv to %dkHz\n", new_freq);
+		ret = s3c2416_cpufreq_set_armdiv(s3c_freq, new_freq);
 	}
 
-	cpufreq_notify_transition(policy, &freqs, CPUFREQ_POSTCHANGE);
-
 out:
 	mutex_unlock(&cpufreq_lock);
 
diff --git a/drivers/cpufreq/s3c64xx-cpufreq.c b/drivers/cpufreq/s3c64xx-cpufreq.c
index 34ae66b..8b49a06 100644
--- a/drivers/cpufreq/s3c64xx-cpufreq.c
+++ b/drivers/cpufreq/s3c64xx-cpufreq.c
@@ -65,54 +65,46 @@ static unsigned int s3c64xx_cpufreq_get_speed(unsigned int cpu)
 static int s3c64xx_cpufreq_set_target(struct cpufreq_policy *policy,
 				      unsigned int index)
 {
-	int ret;
-	struct cpufreq_freqs freqs;
 	struct s3c64xx_dvfs *dvfs;
+	unsigned int old_freq, new_freq;
+	int ret;
 
-	freqs.old = clk_get_rate(armclk) / 1000;
-	freqs.new = s3c64xx_freq_table[index].frequency;
-	freqs.flags = 0;
+	old_freq = clk_get_rate(armclk) / 1000;
+	new_freq = s3c64xx_freq_table[index].frequency;
 	dvfs = &s3c64xx_dvfs_table[s3c64xx_freq_table[index].driver_data];
 
-	pr_debug("Transition %d-%dkHz\n", freqs.old, freqs.new);
-
-	cpufreq_notify_transition(policy, &freqs, CPUFREQ_PRECHANGE);
-
 #ifdef CONFIG_REGULATOR
-	if (vddarm && freqs.new > freqs.old) {
+	if (vddarm && new_freq > old_freq) {
 		ret = regulator_set_voltage(vddarm,
 					    dvfs->vddarm_min,
 					    dvfs->vddarm_max);
 		if (ret != 0) {
 			pr_err("Failed to set VDDARM for %dkHz: %d\n",
-			       freqs.new, ret);
-			freqs.new = freqs.old;
-			goto post_notify;
+			       new_freq, ret);
+			return ret;
 		}
 	}
 #endif
 
-	ret = clk_set_rate(armclk, freqs.new * 1000);
+	ret = clk_set_rate(armclk, new_freq * 1000);
 	if (ret < 0) {
 		pr_err("Failed to set rate %dkHz: %d\n",
-		       freqs.new, ret);
-		freqs.new = freqs.old;
+		       new_freq, ret);
+		return ret;
 	}
 
-post_notify:
-	cpufreq_notify_transition(policy, &freqs, CPUFREQ_POSTCHANGE);
-	if (ret)
-		goto err;
-
 #ifdef CONFIG_REGULATOR
-	if (vddarm && freqs.new < freqs.old) {
+	if (vddarm && new_freq < old_freq) {
 		ret = regulator_set_voltage(vddarm,
 					    dvfs->vddarm_min,
 					    dvfs->vddarm_max);
 		if (ret != 0) {
 			pr_err("Failed to set VDDARM for %dkHz: %d\n",
-			       freqs.new, ret);
-			goto err_clk;
+			       new_freq, ret);
+			if (clk_set_rate(armclk, old_freq * 1000) < 0)
+				pr_err("Failed to restore original clock rate\n");
+
+			return ret;
 		}
 	}
 #endif
@@ -121,14 +113,6 @@ post_notify:
 		 clk_get_rate(armclk) / 1000);
 
 	return 0;
-
-err_clk:
-	if (clk_set_rate(armclk, freqs.old * 1000) < 0)
-		pr_err("Failed to restore original clock rate\n");
-err:
-	cpufreq_notify_transition(policy, &freqs, CPUFREQ_POSTCHANGE);
-
-	return ret;
 }
 
 #ifdef CONFIG_REGULATOR
-- 
1.7.12.rc2.18.g61b472e

