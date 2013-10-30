Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754892Ab3J3Wwq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 18:52:46 -0400
Received: from mail-ob0-f171.google.com ([209.85.214.171]:58720 "EHLO
	mail-ob0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754854Ab3J3Wwm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 18:52:42 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, viresh.kumar@linaro.org
Subject: [PATCH V2 Resend 14/16] cpufreq: tegra: remove target_cpu_speed[] array
Date: Thu, 31 Oct 2013 04:22:12 +0530
Message-Id: <bdb887025675d0c358c5107b537c7afd427c144f.1383173230.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1383173230.git.viresh.kumar@linaro.org>
References: <cover.1383173230.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1383173230.git.viresh.kumar@linaro.org>
References: <cover.1383173230.git.viresh.kumar@linaro.org>
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

Acked-by: Stephen Warren <swarren@nvidia.com>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/cpufreq/tegra-cpufreq.c | 36 ++++++------------------------------
 1 file changed, 6 insertions(+), 30 deletions(-)

diff --git a/drivers/cpufreq/tegra-cpufreq.c b/drivers/cpufreq/tegra-cpufreq.c
index f42df7e..7d36b54 100644
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
-
-	target_cpu_speed[policy->cpu] = freq;
+	if (!is_suspended)
+		ret = tegra_update_cpu_speed(policy,
+				freq_table[index].frequency);
 
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
@@ -191,8 +169,6 @@ static int tegra_cpu_init(struct cpufreq_policy *policy)
 	clk_prepare_enable(emc_clk);
 	clk_prepare_enable(cpu_clk);
 
-	target_cpu_speed[policy->cpu] = tegra_getspeed(policy->cpu);
-
 	/* FIXME: what's the actual transition time? */
 	ret = cpufreq_generic_init(policy, freq_table, 300 * 1000);
 	if (ret) {
-- 
1.7.12.rc2.18.g61b472e

