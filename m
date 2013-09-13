Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934333Ab3IMN0k (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 09:26:40 -0400
Received: from mail-pb0-f47.google.com ([209.85.160.47]:46648 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934320Ab3IMN0g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 09:26:36 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>
Subject: [PATCH 198/228] cpufreq: omap: remove calls to cpufreq_notify_transition()
Date: Fri, 13 Sep 2013 18:32:24 +0530
Message-Id: <460ac80ae0afb99ba681bedcbd3863c0ddae0ea8.1379063063.git.viresh.kumar@linaro.org>
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

Cc: Santosh Shilimkar <santosh.shilimkar@ti.com>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/cpufreq/omap-cpufreq.c | 39 ++++++++++++++-------------------------
 1 file changed, 14 insertions(+), 25 deletions(-)

diff --git a/drivers/cpufreq/omap-cpufreq.c b/drivers/cpufreq/omap-cpufreq.c
index 0653887..e92d72e 100644
--- a/drivers/cpufreq/omap-cpufreq.c
+++ b/drivers/cpufreq/omap-cpufreq.c
@@ -53,15 +53,15 @@ static unsigned int omap_getspeed(unsigned int cpu)
 
 static int omap_target(struct cpufreq_policy *policy, unsigned int index)
 {
-	int r, ret = 0;
-	struct cpufreq_freqs freqs;
+	int r, ret;
 	struct opp *opp;
 	unsigned long freq, volt = 0, volt_old = 0, tol = 0;
+	unsigned int old_freq, new_freq;
 
-	freqs.old = omap_getspeed(policy->cpu);
-	freqs.new = freq_table[index].frequency;
+	old_freq = omap_getspeed(policy->cpu);
+	new_freq = freq_table[index].frequency;
 
-	freq = freqs.new * 1000;
+	freq = new_freq * 1000;
 	ret = clk_round_rate(mpu_clk, freq);
 	if (IS_ERR_VALUE(ret)) {
 		dev_warn(mpu_dev,
@@ -77,7 +77,7 @@ static int omap_target(struct cpufreq_policy *policy, unsigned int index)
 		if (IS_ERR(opp)) {
 			rcu_read_unlock();
 			dev_err(mpu_dev, "%s: unable to find MPU OPP for %d\n",
-				__func__, freqs.new);
+				__func__, new_freq);
 			return -EINVAL;
 		}
 		volt = opp_get_voltage(opp);
@@ -87,43 +87,32 @@ static int omap_target(struct cpufreq_policy *policy, unsigned int index)
 	}
 
 	dev_dbg(mpu_dev, "cpufreq-omap: %u MHz, %ld mV --> %u MHz, %ld mV\n", 
-		freqs.old / 1000, volt_old ? volt_old / 1000 : -1,
-		freqs.new / 1000, volt ? volt / 1000 : -1);
-
-	/* notifiers */
-	cpufreq_notify_transition(policy, &freqs, CPUFREQ_PRECHANGE);
+		old_freq / 1000, volt_old ? volt_old / 1000 : -1,
+		new_freq / 1000, volt ? volt / 1000 : -1);
 
 	/* scaling up?  scale voltage before frequency */
-	if (mpu_reg && (freqs.new > freqs.old)) {
+	if (mpu_reg && (new_freq > old_freq)) {
 		r = regulator_set_voltage(mpu_reg, volt - tol, volt + tol);
 		if (r < 0) {
 			dev_warn(mpu_dev, "%s: unable to scale voltage up.\n",
 				 __func__);
-			freqs.new = freqs.old;
-			goto done;
+			return r;
 		}
 	}
 
-	ret = clk_set_rate(mpu_clk, freqs.new * 1000);
+	ret = clk_set_rate(mpu_clk, new_freq * 1000);
 
 	/* scaling down?  scale voltage after frequency */
-	if (mpu_reg && (freqs.new < freqs.old)) {
+	if (mpu_reg && (new_freq < old_freq)) {
 		r = regulator_set_voltage(mpu_reg, volt - tol, volt + tol);
 		if (r < 0) {
 			dev_warn(mpu_dev, "%s: unable to scale voltage down.\n",
 				 __func__);
-			ret = clk_set_rate(mpu_clk, freqs.old * 1000);
-			freqs.new = freqs.old;
-			goto done;
+			clk_set_rate(mpu_clk, old_freq * 1000);
+			return r;
 		}
 	}
 
-	freqs.new = omap_getspeed(policy->cpu);
-
-done:
-	/* notifiers */
-	cpufreq_notify_transition(policy, &freqs, CPUFREQ_POSTCHANGE);
-
 	return ret;
 }
 
-- 
1.7.12.rc2.18.g61b472e

