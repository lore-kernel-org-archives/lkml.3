Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754811Ab3J3Wwi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 18:52:38 -0400
Received: from mail-oa0-f46.google.com ([209.85.219.46]:45862 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754648Ab3J3Wwf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 18:52:35 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, viresh.kumar@linaro.org
Subject: [PATCH V2 Resend 09/16] cpufreq: omap: use cpufreq_generic_get() routine
Date: Thu, 31 Oct 2013 04:22:07 +0530
Message-Id: <9f47e7f84d81272583215e6009ddf936bd8a669a.1383173230.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1383173230.git.viresh.kumar@linaro.org>
References: <cover.1383173230.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1383173230.git.viresh.kumar@linaro.org>
References: <cover.1383173230.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We have common infrastructure available with us for getting a CPUs clk rate.
Lets use it for this driver.

We don't need a global variable to hold clock anymore.

Cc: Santosh Shilimkar <santosh.shilimkar@ti.com>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/cpufreq/omap-cpufreq.c | 32 ++++++++++----------------------
 1 file changed, 10 insertions(+), 22 deletions(-)

diff --git a/drivers/cpufreq/omap-cpufreq.c b/drivers/cpufreq/omap-cpufreq.c
index be6d143..0c018dc 100644
--- a/drivers/cpufreq/omap-cpufreq.c
+++ b/drivers/cpufreq/omap-cpufreq.c
@@ -36,32 +36,20 @@
 
 static struct cpufreq_frequency_table *freq_table;
 static atomic_t freq_table_users = ATOMIC_INIT(0);
-static struct clk *mpu_clk;
 static struct device *mpu_dev;
 static struct regulator *mpu_reg;
 
-static unsigned int omap_getspeed(unsigned int cpu)
-{
-	unsigned long rate;
-
-	if (cpu >= NR_CPUS)
-		return 0;
-
-	rate = clk_get_rate(mpu_clk) / 1000;
-	return rate;
-}
-
 static int omap_target(struct cpufreq_policy *policy, unsigned int index)
 {
 	struct dev_pm_opp *opp;
 	unsigned long freq, volt = 0, volt_old = 0, tol = 0;
 	unsigned int old_freq, new_freq;
 
-	old_freq = omap_getspeed(policy->cpu);
+	old_freq = policy->cur;
 	new_freq = freq_table[index].frequency;
 
 	freq = new_freq * 1000;
-	ret = clk_round_rate(mpu_clk, freq);
+	ret = clk_round_rate(policy->clk, freq);
 	if (IS_ERR_VALUE(ret)) {
 		dev_warn(mpu_dev,
 			 "CPUfreq: Cannot find matching frequency for %lu\n",
@@ -99,7 +87,7 @@ static int omap_target(struct cpufreq_policy *policy, unsigned int index)
 		}
 	}
 
-	ret = clk_set_rate(mpu_clk, new_freq * 1000);
+	ret = clk_set_rate(policy->clk, new_freq * 1000);
 
 	/* scaling down?  scale voltage after frequency */
 	if (mpu_reg && (new_freq < old_freq)) {
@@ -107,7 +95,7 @@ static int omap_target(struct cpufreq_policy *policy, unsigned int index)
 		if (r < 0) {
 			dev_warn(mpu_dev, "%s: unable to scale voltage down.\n",
 				 __func__);
-			clk_set_rate(mpu_clk, old_freq * 1000);
+			clk_set_rate(policy->clk, old_freq * 1000);
 			return r;
 		}
 	}
@@ -125,9 +113,9 @@ static int omap_cpu_init(struct cpufreq_policy *policy)
 {
 	int result;
 
-	mpu_clk = clk_get(NULL, "cpufreq_ck");
-	if (IS_ERR(mpu_clk))
-		return PTR_ERR(mpu_clk);
+	policy->clk = clk_get(NULL, "cpufreq_ck");
+	if (IS_ERR(policy->clk))
+		return PTR_ERR(policy->clk);
 
 	if (!freq_table) {
 		result = dev_pm_opp_init_cpufreq_table(mpu_dev, &freq_table);
@@ -148,7 +136,7 @@ static int omap_cpu_init(struct cpufreq_policy *policy)
 
 	freq_table_free();
 fail:
-	clk_put(mpu_clk);
+	clk_put(policy->clk);
 	return result;
 }
 
@@ -156,7 +144,7 @@ static int omap_cpu_exit(struct cpufreq_policy *policy)
 {
 	cpufreq_frequency_table_put_attr(policy->cpu);
 	freq_table_free();
-	clk_put(mpu_clk);
+	clk_put(policy->clk);
 	return 0;
 }
 
@@ -164,7 +152,7 @@ static struct cpufreq_driver omap_driver = {
 	.flags		= CPUFREQ_STICKY,
 	.verify		= cpufreq_generic_frequency_table_verify,
 	.target_index	= omap_target,
-	.get		= omap_getspeed,
+	.get		= cpufreq_generic_get,
 	.init		= omap_cpu_init,
 	.exit		= omap_cpu_exit,
 	.name		= "omap",
-- 
1.7.12.rc2.18.g61b472e

