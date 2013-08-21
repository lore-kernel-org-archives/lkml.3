Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751740Ab3HUKdp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 06:33:45 -0400
Received: from mail-pd0-f169.google.com ([209.85.192.169]:46064 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751677Ab3HUKdm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 06:33:42 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl, swarren@nvidia.com
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH] cpufreq: Tegra: remove target_cpu_speed[] array
Date: Wed, 21 Aug 2013 16:01:52 +0530
Message-Id: <896370a3ad0db9e85f8776d923fcd5129d4e4d56.1377080903.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tegra's cpufreq driver was maintaining requested target frequencies in an array:
target_cpu_speed. And then finally setting the highest requested freq in the
core. This was probably done because both cores share clock line and logically
we want to set both cores to the max frequency requested..

But this wasn't required to be done in individual CPUFreq drivers, its already
taken care of by CPUFreq governors. They evaluate load for all CPUs and finally
call target only for the frequency corresponding to max load.

So, get rid of this stuff from Tegra's cpufreq driver.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
Hi Stephen,

Its only build tested and depends on lots of stuff that I have already sent for
cpufreq core and its drivers. All of that is pushed here:
https://git.linaro.org/gitweb?p=people/vireshk/linux.git;a=shortlog;h=refs/heads/for-v3.13

And only Tegra+cpufreq-core patches are pushed here (only 13 patches):
https://git.linaro.org/gitweb?p=people/vireshk/linux.git;a=shortlog;h=refs/heads/cpufreq-next-tegra

You can probably try cpufreq-next-tegra branch for testing on some real
hardware.

 drivers/cpufreq/tegra-cpufreq.c | 35 ++++++-----------------------------
 1 file changed, 6 insertions(+), 29 deletions(-)

diff --git a/drivers/cpufreq/tegra-cpufreq.c b/drivers/cpufreq/tegra-cpufreq.c
index b376b67..3f25ab6 100644
--- a/drivers/cpufreq/tegra-cpufreq.c
+++ b/drivers/cpufreq/tegra-cpufreq.c
@@ -47,7 +47,6 @@ static struct clk *pll_x_clk;
 static struct clk *pll_p_clk;
 static struct clk *emc_clk;
 
-static unsigned long target_cpu_speed[NUM_CPUS];
 static DEFINE_MUTEX(tegra_cpu_lock);
 static bool is_suspended;
 
@@ -103,9 +102,6 @@ static int tegra_update_cpu_speed(struct cpufreq_policy *policy,
 {
 	int ret = 0;
 
-	if (tegra_getspeed(0) == rate)
-		return ret;
-
 	/*
 	 * Vote on memory bus frequency based on cpu frequency
 	 * This sets the minimum frequency, display or avp may request higher
@@ -125,35 +121,16 @@ static int tegra_update_cpu_speed(struct cpufreq_policy *policy,
 	return ret;
 }
 
-static unsigned long tegra_cpu_highest_speed(void)
-{
-	unsigned long rate = 0;
-	int i;
-
-	for_each_online_cpu(i)
-		rate = max(rate, target_cpu_speed[i]);
-	return rate;
-}
-
 static int tegra_target(struct cpufreq_policy *policy, unsigned int index)
 {
-	unsigned int freq;
-	int ret = 0;
+	int ret = -EBUSY;
 
 	mutex_lock(&tegra_cpu_lock);
 
-	if (is_suspended) {
-		ret = -EBUSY;
-		goto out;
-	}
-
-	freq = freq_table[index].frequency;
+	if (!is_suspended)
+		ret = tegra_update_cpu_speed(policy,
+				freq_table[index].frequency);
 
-	target_cpu_speed[policy->cpu] = freq;
-
-	ret = tegra_update_cpu_speed(policy, tegra_cpu_highest_speed());
-
-out:
 	mutex_unlock(&tegra_cpu_lock);
 	return ret;
 }
@@ -167,7 +144,8 @@ static int tegra_pm_notify(struct notifier_block *nb, unsigned long event,
 		is_suspended = true;
 		pr_info("Tegra cpufreq suspend: setting frequency to %d kHz\n",
 			freq_table[0].frequency);
-		tegra_update_cpu_speed(policy, freq_table[0].frequency);
+		if (tegra_getspeed(0) != freq_table[0].frequency)
+			tegra_update_cpu_speed(policy, freq_table[0].frequency);
 		cpufreq_cpu_put(policy);
 	} else if (event == PM_POST_SUSPEND) {
 		is_suspended = false;
@@ -190,7 +168,6 @@ static int tegra_cpu_init(struct cpufreq_policy *policy)
 	clk_prepare_enable(cpu_clk);
 
 	cpufreq_table_validate_and_show(policy, freq_table);
-	target_cpu_speed[policy->cpu] = tegra_getspeed(policy->cpu);
 
 	/* FIXME: what's the actual transition time? */
 	policy->cpuinfo.transition_latency = 300 * 1000;
-- 
1.7.12.rc2.18.g61b472e

