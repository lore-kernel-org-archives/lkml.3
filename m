Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754738Ab3J3Wwc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 18:52:32 -0400
Received: from mail-oa0-f54.google.com ([209.85.219.54]:49928 "EHLO
	mail-oa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754384Ab3J3Ww3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 18:52:29 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, viresh.kumar@linaro.org
Subject: [PATCH V2 Resend 08/16] cpufreq: loongson2: use cpufreq_generic_get() routine
Date: Thu, 31 Oct 2013 04:22:06 +0530
Message-Id: <a8347b281454fbc186027a9b92ae949858cfb32f.1383173230.git.viresh.kumar@linaro.org>
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

Cc: John Crispin <blogic@openwrt.org>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/cpufreq/loongson2_cpufreq.c | 15 +++++----------
 1 file changed, 5 insertions(+), 10 deletions(-)

diff --git a/drivers/cpufreq/loongson2_cpufreq.c b/drivers/cpufreq/loongson2_cpufreq.c
index a436092..b6581ab 100644
--- a/drivers/cpufreq/loongson2_cpufreq.c
+++ b/drivers/cpufreq/loongson2_cpufreq.c
@@ -24,8 +24,6 @@
 
 static uint nowait;
 
-static struct clk *cpuclk;
-
 static void (*saved_cpu_wait) (void);
 
 static int loongson2_cpu_freq_notifier(struct notifier_block *nb,
@@ -44,11 +42,6 @@ static int loongson2_cpu_freq_notifier(struct notifier_block *nb,
 	return 0;
 }
 
-static unsigned int loongson2_cpufreq_get(unsigned int cpu)
-{
-	return clk_get_rate(cpuclk);
-}
-
 /*
  * Here we notify other drivers of the proposed change and the final change.
  */
@@ -69,13 +62,14 @@ static int loongson2_cpufreq_target(struct cpufreq_policy *policy,
 	set_cpus_allowed_ptr(current, &cpus_allowed);
 
 	/* setting the cpu frequency */
-	clk_set_rate(cpuclk, freq);
+	clk_set_rate(policy->clk, freq);
 
 	return 0;
 }
 
 static int loongson2_cpufreq_cpu_init(struct cpufreq_policy *policy)
 {
+	static struct clk *cpuclk;
 	int i;
 	unsigned long rate;
 	int ret;
@@ -104,13 +98,14 @@ static int loongson2_cpufreq_cpu_init(struct cpufreq_policy *policy)
 		return ret;
 	}
 
+	policy->clk = cpuclk;
 	return cpufreq_generic_init(policy, &loongson2_clockmod_table[0], 0);
 }
 
 static int loongson2_cpufreq_exit(struct cpufreq_policy *policy)
 {
 	cpufreq_frequency_table_put_attr(policy->cpu);
-	clk_put(cpuclk);
+	clk_put(policy->clk);
 	return 0;
 }
 
@@ -119,7 +114,7 @@ static struct cpufreq_driver loongson2_cpufreq_driver = {
 	.init = loongson2_cpufreq_cpu_init,
 	.verify = cpufreq_generic_frequency_table_verify,
 	.target_index = loongson2_cpufreq_target,
-	.get = loongson2_cpufreq_get,
+	.get = cpufreq_generic_get,
 	.exit = loongson2_cpufreq_exit,
 	.attr = cpufreq_generic_attr,
 };
-- 
1.7.12.rc2.18.g61b472e

