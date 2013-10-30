Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754340Ab3J3WwX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 18:52:23 -0400
Received: from mail-oa0-f51.google.com ([209.85.219.51]:45846 "EHLO
	mail-oa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754069Ab3J3WwU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 18:52:20 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, viresh.kumar@linaro.org
Subject: [PATCH V2 Resend 02/16] cpufreq: at32ap: use cpufreq_generic_get() routine
Date: Thu, 31 Oct 2013 04:22:00 +0530
Message-Id: <5f0068423d041bcdd6e64de8d1481a501873f9a9.1383173230.git.viresh.kumar@linaro.org>
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

Acked-by: Hans-Christian Egtvedt <egtvedt@samfundet.no>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/cpufreq/at32ap-cpufreq.c | 17 +++++------------
 1 file changed, 5 insertions(+), 12 deletions(-)

diff --git a/drivers/cpufreq/at32ap-cpufreq.c b/drivers/cpufreq/at32ap-cpufreq.c
index 856ad80..869c0b5 100644
--- a/drivers/cpufreq/at32ap-cpufreq.c
+++ b/drivers/cpufreq/at32ap-cpufreq.c
@@ -21,17 +21,8 @@
 #include <linux/export.h>
 #include <linux/slab.h>
 
-static struct clk *cpuclk;
 static struct cpufreq_frequency_table *freq_table;
 
-static unsigned int at32_get_speed(unsigned int cpu)
-{
-	/* No SMP support */
-	if (cpu)
-		return 0;
-	return (unsigned int)((clk_get_rate(cpuclk) + 500) / 1000);
-}
-
 static unsigned int	ref_freq;
 static unsigned long	loops_per_jiffy_ref;
 
@@ -39,7 +30,7 @@ static int at32_set_target(struct cpufreq_policy *policy, unsigned int index)
 {
 	unsigned int old_freq, new_freq;
 
-	old_freq = at32_get_speed(0);
+	old_freq = policy->cur;
 	new_freq = freq_table[index].frequency;
 
 	if (!ref_freq) {
@@ -50,7 +41,7 @@ static int at32_set_target(struct cpufreq_policy *policy, unsigned int index)
 	if (old_freq < new_freq)
 		boot_cpu_data.loops_per_jiffy = cpufreq_scale(
 				loops_per_jiffy_ref, ref_freq, new_freq);
-	clk_set_rate(cpuclk, new_freq * 1000);
+	clk_set_rate(policy->clk, new_freq * 1000);
 	if (new_freq < old_freq)
 		boot_cpu_data.loops_per_jiffy = cpufreq_scale(
 				loops_per_jiffy_ref, ref_freq, new_freq);
@@ -61,6 +52,7 @@ static int at32_set_target(struct cpufreq_policy *policy, unsigned int index)
 static int __init at32_cpufreq_driver_init(struct cpufreq_policy *policy)
 {
 	unsigned int frequency, rate, min_freq;
+	static struct clk *cpuclk;
 	int retval, steps, i;
 
 	if (policy->cpu != 0)
@@ -103,6 +95,7 @@ static int __init at32_cpufreq_driver_init(struct cpufreq_policy *policy)
 		frequency /= 2;
 	}
 
+	policy->clk = cpuclk;
 	freq_table[steps - 1].frequency = CPUFREQ_TABLE_END;
 
 	retval = cpufreq_table_validate_and_show(policy, freq_table);
@@ -123,7 +116,7 @@ static struct cpufreq_driver at32_driver = {
 	.init		= at32_cpufreq_driver_init,
 	.verify		= cpufreq_generic_frequency_table_verify,
 	.target_index	= at32_set_target,
-	.get		= at32_get_speed,
+	.get		= cpufreq_generic_get,
 	.flags		= CPUFREQ_STICKY,
 };
 
-- 
1.7.12.rc2.18.g61b472e

