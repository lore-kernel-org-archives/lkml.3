Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755927Ab3HWPyd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 11:54:33 -0400
Received: from mail-pd0-f174.google.com ([209.85.192.174]:54718 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755482Ab3HWPyb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 11:54:31 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Viresh Kumar <viresh.kumar@linaro.org>,
        Kukjin Kim <kgene.kim@samsung.com>
Subject: [PATCH 12/16] cpufreq: s3c: use cpufreq_generic_get() routine
Date: Fri, 23 Aug 2013 21:20:47 +0530
Message-Id: <651e5cf5ca16072cd111c15d7853e14ec79c645f.1377272740.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1377272740.git.viresh.kumar@linaro.org>
References: <cover.1377272740.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1377272740.git.viresh.kumar@linaro.org>
References: <cover.1377272740.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We have common infrastructure available with us for getting a CPUs clk rate.
Lets use it for this driver.

We don't need a global variable to hold clock anymore.

Cc: Kukjin Kim <kgene.kim@samsung.com>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/cpufreq/s3c24xx-cpufreq.c | 10 +++-------
 drivers/cpufreq/s3c64xx-cpufreq.c | 33 ++++++++++++---------------------
 2 files changed, 15 insertions(+), 28 deletions(-)

diff --git a/drivers/cpufreq/s3c24xx-cpufreq.c b/drivers/cpufreq/s3c24xx-cpufreq.c
index 4850882..7be6c2d 100644
--- a/drivers/cpufreq/s3c24xx-cpufreq.c
+++ b/drivers/cpufreq/s3c24xx-cpufreq.c
@@ -355,11 +355,6 @@ static int s3c_cpufreq_target(struct cpufreq_policy *policy,
 	return -EINVAL;
 }
 
-static unsigned int s3c_cpufreq_get(unsigned int cpu)
-{
-	return clk_get_rate(clk_arm) / 1000;
-}
-
 struct clk *s3c_cpufreq_clk_get(struct device *dev, const char *name)
 {
 	struct clk *clk;
@@ -373,6 +368,7 @@ struct clk *s3c_cpufreq_clk_get(struct device *dev, const char *name)
 
 static int s3c_cpufreq_init(struct cpufreq_policy *policy)
 {
+	policy->clk = clk_arm;
 	return cpufreq_generic_init(policy, ftab, cpu_cur.info->latency);
 }
 
@@ -408,7 +404,7 @@ static int s3c_cpufreq_suspend(struct cpufreq_policy *policy)
 {
 	suspend_pll.frequency = clk_get_rate(_clk_mpll);
 	suspend_pll.driver_data = __raw_readl(S3C2410_MPLLCON);
-	suspend_freq = s3c_cpufreq_get(0) * 1000;
+	suspend_freq = clk_get_rate(clk_arm);
 
 	return 0;
 }
@@ -450,7 +446,7 @@ static int s3c_cpufreq_resume(struct cpufreq_policy *policy)
 static struct cpufreq_driver s3c24xx_driver = {
 	.flags		= CPUFREQ_STICKY,
 	.target		= s3c_cpufreq_target,
-	.get		= s3c_cpufreq_get,
+	.get		= cpufreq_generic_get,
 	.init		= s3c_cpufreq_init,
 	.suspend	= s3c_cpufreq_suspend,
 	.resume		= s3c_cpufreq_resume,
diff --git a/drivers/cpufreq/s3c64xx-cpufreq.c b/drivers/cpufreq/s3c64xx-cpufreq.c
index 8b49a06..5b0089a 100644
--- a/drivers/cpufreq/s3c64xx-cpufreq.c
+++ b/drivers/cpufreq/s3c64xx-cpufreq.c
@@ -19,7 +19,6 @@
 #include <linux/regulator/consumer.h>
 #include <linux/module.h>
 
-static struct clk *armclk;
 static struct regulator *vddarm;
 static unsigned long regulator_latency;
 
@@ -54,14 +53,6 @@ static struct cpufreq_frequency_table s3c64xx_freq_table[] = {
 };
 #endif
 
-static unsigned int s3c64xx_cpufreq_get_speed(unsigned int cpu)
-{
-	if (cpu != 0)
-		return 0;
-
-	return clk_get_rate(armclk) / 1000;
-}
-
 static int s3c64xx_cpufreq_set_target(struct cpufreq_policy *policy,
 				      unsigned int index)
 {
@@ -69,7 +60,7 @@ static int s3c64xx_cpufreq_set_target(struct cpufreq_policy *policy,
 	unsigned int old_freq, new_freq;
 	int ret;
 
-	old_freq = clk_get_rate(armclk) / 1000;
+	old_freq = clk_get_rate(policy->clk) / 1000;
 	new_freq = s3c64xx_freq_table[index].frequency;
 	dvfs = &s3c64xx_dvfs_table[s3c64xx_freq_table[index].driver_data];
 
@@ -86,7 +77,7 @@ static int s3c64xx_cpufreq_set_target(struct cpufreq_policy *policy,
 	}
 #endif
 
-	ret = clk_set_rate(armclk, new_freq * 1000);
+	ret = clk_set_rate(policy->clk, new_freq * 1000);
 	if (ret < 0) {
 		pr_err("Failed to set rate %dkHz: %d\n",
 		       new_freq, ret);
@@ -101,7 +92,7 @@ static int s3c64xx_cpufreq_set_target(struct cpufreq_policy *policy,
 		if (ret != 0) {
 			pr_err("Failed to set VDDARM for %dkHz: %d\n",
 			       new_freq, ret);
-			if (clk_set_rate(armclk, old_freq * 1000) < 0)
+			if (clk_set_rate(policy->clk, old_freq * 1000) < 0)
 				pr_err("Failed to restore original clock rate\n");
 
 			return ret;
@@ -110,7 +101,7 @@ static int s3c64xx_cpufreq_set_target(struct cpufreq_policy *policy,
 #endif
 
 	pr_debug("Set actual frequency %lukHz\n",
-		 clk_get_rate(armclk) / 1000);
+		 clk_get_rate(policy->clk) / 1000);
 
 	return 0;
 }
@@ -169,11 +160,11 @@ static int s3c64xx_cpufreq_driver_init(struct cpufreq_policy *policy)
 		return -ENODEV;
 	}
 
-	armclk = clk_get(NULL, "armclk");
-	if (IS_ERR(armclk)) {
+	policy->clk = clk_get(NULL, "armclk");
+	if (IS_ERR(policy->clk)) {
 		pr_err("Unable to obtain ARMCLK: %ld\n",
-		       PTR_ERR(armclk));
-		return PTR_ERR(armclk);
+		       PTR_ERR(policy->clk));
+		return PTR_ERR(policy->clk);
 	}
 
 #ifdef CONFIG_REGULATOR
@@ -193,7 +184,7 @@ static int s3c64xx_cpufreq_driver_init(struct cpufreq_policy *policy)
 		unsigned long r;
 
 		/* Check for frequencies we can generate */
-		r = clk_round_rate(armclk, freq->frequency * 1000);
+		r = clk_round_rate(policy->clk, freq->frequency * 1000);
 		r /= 1000;
 		if (r != freq->frequency) {
 			pr_debug("%dkHz unsupported by clock\n",
@@ -203,7 +194,7 @@ static int s3c64xx_cpufreq_driver_init(struct cpufreq_policy *policy)
 
 		/* If we have no regulator then assume startup
 		 * frequency is the maximum we can support. */
-		if (!vddarm && freq->frequency > s3c64xx_cpufreq_get_speed(0))
+		if (!vddarm && freq->frequency > clk_get_rate(policy->clk) / 1000)
 			freq->frequency = CPUFREQ_ENTRY_INVALID;
 
 		freq++;
@@ -219,7 +210,7 @@ static int s3c64xx_cpufreq_driver_init(struct cpufreq_policy *policy)
 		pr_err("Failed to configure frequency table: %d\n",
 		       ret);
 		regulator_put(vddarm);
-		clk_put(armclk);
+		clk_put(policy->clk);
 	}
 
 	return ret;
@@ -229,7 +220,7 @@ static struct cpufreq_driver s3c64xx_cpufreq_driver = {
 	.flags          = 0,
 	.verify		= cpufreq_generic_frequency_table_verify,
 	.target_index	= s3c64xx_cpufreq_set_target,
-	.get		= s3c64xx_cpufreq_get_speed,
+	.get		= cpufreq_generic_get,
 	.init		= s3c64xx_cpufreq_driver_init,
 	.name		= "s3c",
 };
-- 
1.7.12.rc2.18.g61b472e

