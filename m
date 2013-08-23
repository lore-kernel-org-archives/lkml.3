Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756004Ab3HWPzp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 11:55:45 -0400
Received: from mail-pa0-f43.google.com ([209.85.220.43]:50266 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755989Ab3HWPzi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 11:55:38 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 16/16] cpufreq: unicore2: use cpufreq_generic_get() routine
Date: Fri, 23 Aug 2013 21:20:51 +0530
Message-Id: <15af21fe81a3bb3507f1832d3482c1df5ca0a3f7.1377272740.git.viresh.kumar@linaro.org>
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

We also do clk_get() once instead of doing it again and again in target & init.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/cpufreq/unicore2-cpufreq.c | 21 ++++++++-------------
 1 file changed, 8 insertions(+), 13 deletions(-)

diff --git a/drivers/cpufreq/unicore2-cpufreq.c b/drivers/cpufreq/unicore2-cpufreq.c
index 79ca32e..5f7b393 100644
--- a/drivers/cpufreq/unicore2-cpufreq.c
+++ b/drivers/cpufreq/unicore2-cpufreq.c
@@ -11,6 +11,7 @@
  * published by the Free Software Foundation.
  */
 
+#include <linux/err.h>
 #include <linux/kernel.h>
 #include <linux/types.h>
 #include <linux/init.h>
@@ -35,26 +36,16 @@ static int ucv2_verify_speed(struct cpufreq_policy *policy)
 	return 0;
 }
 
-static unsigned int ucv2_getspeed(unsigned int cpu)
-{
-	struct clk *mclk = clk_get(NULL, "MAIN_CLK");
-
-	if (cpu)
-		return 0;
-	return clk_get_rate(mclk)/1000;
-}
-
 static int ucv2_target(struct cpufreq_policy *policy,
 			 unsigned int target_freq,
 			 unsigned int relation)
 {
-	unsigned int cur = ucv2_getspeed(0);
+	unsigned int cur = policy->cur;
 	struct cpufreq_freqs freqs;
-	struct clk *mclk = clk_get(NULL, "MAIN_CLK");
 
 	cpufreq_notify_transition(policy, &freqs, CPUFREQ_PRECHANGE);
 
-	if (!clk_set_rate(mclk, target_freq * 1000)) {
+	if (!clk_set_rate(policy->clk, target_freq * 1000)) {
 		freqs.old = cur;
 		freqs.new = target_freq;
 	}
@@ -68,9 +59,13 @@ static int __init ucv2_cpu_init(struct cpufreq_policy *policy)
 {
 	if (policy->cpu != 0)
 		return -EINVAL;
+
 	policy->min = policy->cpuinfo.min_freq = 250000;
 	policy->max = policy->cpuinfo.max_freq = 1000000;
 	policy->cpuinfo.transition_latency = CPUFREQ_ETERNAL;
+	policy->clk = clk_get(NULL, "MAIN_CLK");
+	if (IS_ERR(policy->clk))
+		return PTR_ERR(policy->clk);
 	return 0;
 }
 
@@ -78,7 +73,7 @@ static struct cpufreq_driver ucv2_driver = {
 	.flags		= CPUFREQ_STICKY,
 	.verify		= ucv2_verify_speed,
 	.target		= ucv2_target,
-	.get		= ucv2_getspeed,
+	.get		= cpufreq_generic_get,
 	.init		= ucv2_cpu_init,
 	.name		= "UniCore-II",
 };
-- 
1.7.12.rc2.18.g61b472e

