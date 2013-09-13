Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934462Ab3IMNaU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 09:30:20 -0400
Received: from mail-pa0-f45.google.com ([209.85.220.45]:52638 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934422Ab3IMNaB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 09:30:01 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Stephen Warren <swarren@nvidia.com>
Subject: [PATCH 227/228] cpufreq: tegra: use cpufreq_generic_get() routine
Date: Fri, 13 Sep 2013 18:32:53 +0530
Message-Id: <4c538174b86604a7d9e5b9e0d2521b881704005e.1379063063.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1379063063.git.viresh.kumar@linaro.org>
References: <cover.1379063063.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1379063063.git.viresh.kumar@linaro.org>
References: <cover.1379063063.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We have common infrastructure available with us for getting a CPUs clk rate.
Lets use it for this driver.

Cc: Stephen Warren <swarren@nvidia.com>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/cpufreq/tegra-cpufreq.c | 16 +++-------------
 1 file changed, 3 insertions(+), 13 deletions(-)

diff --git a/drivers/cpufreq/tegra-cpufreq.c b/drivers/cpufreq/tegra-cpufreq.c
index 7d36b54..360d1a7 100644
--- a/drivers/cpufreq/tegra-cpufreq.c
+++ b/drivers/cpufreq/tegra-cpufreq.c
@@ -50,17 +50,6 @@ static struct clk *emc_clk;
 static DEFINE_MUTEX(tegra_cpu_lock);
 static bool is_suspended;
 
-static unsigned int tegra_getspeed(unsigned int cpu)
-{
-	unsigned long rate;
-
-	if (cpu >= NUM_CPUS)
-		return 0;
-
-	rate = clk_get_rate(cpu_clk) / 1000;
-	return rate;
-}
-
 static int tegra_cpu_clk_set_rate(unsigned long rate)
 {
 	int ret;
@@ -144,7 +133,7 @@ static int tegra_pm_notify(struct notifier_block *nb, unsigned long event,
 		is_suspended = true;
 		pr_info("Tegra cpufreq suspend: setting frequency to %d kHz\n",
 			freq_table[0].frequency);
-		if (tegra_getspeed(0) != freq_table[0].frequency)
+		if (clk_get_rate(cpu_clk) / 1000 != freq_table[0].frequency)
 			tegra_update_cpu_speed(policy, freq_table[0].frequency);
 		cpufreq_cpu_put(policy);
 	} else if (event == PM_POST_SUSPEND) {
@@ -180,6 +169,7 @@ static int tegra_cpu_init(struct cpufreq_policy *policy)
 	if (policy->cpu == 0)
 		register_pm_notifier(&tegra_cpu_pm_notifier);
 
+	policy->clk = cpu_clk;
 	return 0;
 }
 
@@ -194,7 +184,7 @@ static int tegra_cpu_exit(struct cpufreq_policy *policy)
 static struct cpufreq_driver tegra_cpufreq_driver = {
 	.verify		= cpufreq_generic_frequency_table_verify,
 	.target_index	= tegra_target,
-	.get		= tegra_getspeed,
+	.get		= cpufreq_generic_get,
 	.init		= tegra_cpu_init,
 	.exit		= tegra_cpu_exit,
 	.name		= "tegra",
-- 
1.7.12.rc2.18.g61b472e

