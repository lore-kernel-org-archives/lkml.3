Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755724Ab3HWPwk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 11:52:40 -0400
Received: from mail-pb0-f43.google.com ([209.85.160.43]:35288 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755717Ab3HWPwh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 11:52:37 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Viresh Kumar <viresh.kumar@linaro.org>,
        Sekhar Nori <nsekhar@ti.com>
Subject: [PATCH 05/16] cpufreq: davinci: use cpufreq_generic_get() routine
Date: Fri, 23 Aug 2013 21:20:40 +0530
Message-Id: <a40b7efacf85362c8d6714b5449d1dd2f130ecbb.1377272740.git.viresh.kumar@linaro.org>
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

Cc: Sekhar Nori <nsekhar@ti.com>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/cpufreq/davinci-cpufreq.c | 13 +++----------
 1 file changed, 3 insertions(+), 10 deletions(-)

diff --git a/drivers/cpufreq/davinci-cpufreq.c b/drivers/cpufreq/davinci-cpufreq.c
index 7fcae0c..c07883f 100644
--- a/drivers/cpufreq/davinci-cpufreq.c
+++ b/drivers/cpufreq/davinci-cpufreq.c
@@ -60,14 +60,6 @@ static int davinci_verify_speed(struct cpufreq_policy *policy)
 	return 0;
 }
 
-static unsigned int davinci_getspeed(unsigned int cpu)
-{
-	if (cpu)
-		return 0;
-
-	return clk_get_rate(cpufreq.armclk) / 1000;
-}
-
 static int davinci_target(struct cpufreq_policy *policy, unsigned int idx)
 {
 	struct davinci_cpufreq_config *pdata = cpufreq.dev->platform_data;
@@ -75,7 +67,7 @@ static int davinci_target(struct cpufreq_policy *policy, unsigned int idx)
 	unsigned int old_freq, new_freq;
 	int ret = 0;
 
-	old_freq = davinci_getspeed(0);
+	old_freq = policy->cur;
 	new_freq = pdata->freq_table[idx].frequency;
 
 	/* if moving to higher frequency, up the voltage beforehand */
@@ -132,6 +124,7 @@ static int davinci_cpu_init(struct cpufreq_policy *policy)
 	 * to pre/post change notification list.
 	 */
 	policy->cpuinfo.transition_latency = 2000 * 1000;
+	policy->clk = cpufreq.armclk;
 	return 0;
 }
 
@@ -139,7 +132,7 @@ static struct cpufreq_driver davinci_driver = {
 	.flags		= CPUFREQ_STICKY,
 	.verify		= davinci_verify_speed,
 	.target_index	= davinci_target,
-	.get		= davinci_getspeed,
+	.get		= cpufreq_generic_get,
 	.init		= davinci_cpu_init,
 	.exit		= cpufreq_generic_exit,
 	.name		= "davinci",
-- 
1.7.12.rc2.18.g61b472e

