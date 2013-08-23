Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755986Ab3HWPzd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 11:55:33 -0400
Received: from mail-pd0-f169.google.com ([209.85.192.169]:36577 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755438Ab3HWPz3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 11:55:29 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Viresh Kumar <viresh.kumar@linaro.org>,
        Stephen Warren <swarren@nvidia.com>
Subject: [PATCH 15/16] cpufreq: tegra: use cpufreq_generic_get() routine
Date: Fri, 23 Aug 2013 21:20:50 +0530
Message-Id: <9fead70ef9d7c37298ff3c00ce31d41483d4e988.1377272740.git.viresh.kumar@linaro.org>
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

Cc: Stephen Warren <swarren@nvidia.com>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/cpufreq/tegra-cpufreq.c | 16 +++-------------
 1 file changed, 3 insertions(+), 13 deletions(-)

diff --git a/drivers/cpufreq/tegra-cpufreq.c b/drivers/cpufreq/tegra-cpufreq.c
index bc7c2a1..b2efad7 100644
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

