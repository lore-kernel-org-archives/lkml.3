Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753077Ab3LBFx2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 00:53:28 -0500
Received: from mail-qe0-f54.google.com ([209.85.128.54]:35754 "EHLO
	mail-qe0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753005Ab3LBFxF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 00:53:05 -0500
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@rjwysocki.net
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, nm@ti.com, swarren@wwwdotorg.org,
        kgene.kim@samsung.com, linux-samsung-soc@vger.kernel.org,
        linux-tegra@vger.kernel.org, tianyu.lan@intel.com,
        jhbird.choi@samsung.com, Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH V4 6/6] cpufreq: Tegra: Use cpufreq_generic_suspend()
Date: Mon,  2 Dec 2013 11:22:36 +0530
Message-Id: <3880db2c7dd85ec91339118b3279c57cbe7e1c0d.1385962528.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1385962528.git.viresh.kumar@linaro.org>
References: <cover.1385962528.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1385962528.git.viresh.kumar@linaro.org>
References: <cover.1385962528.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently we have implemented PM notifiers to disable/enable ->target() routines
functionality during suspend/resume.

Now we have support present in cpufreq core, lets use it.

Acked-and-tested-by: Stephen Warren <swarren@nvidia.com>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/cpufreq/tegra-cpufreq.c | 46 +++++------------------------------------
 1 file changed, 5 insertions(+), 41 deletions(-)

diff --git a/drivers/cpufreq/tegra-cpufreq.c b/drivers/cpufreq/tegra-cpufreq.c
index 360d1a7..9e4f0a2b 100644
--- a/drivers/cpufreq/tegra-cpufreq.c
+++ b/drivers/cpufreq/tegra-cpufreq.c
@@ -26,7 +26,6 @@
 #include <linux/err.h>
 #include <linux/clk.h>
 #include <linux/io.h>
-#include <linux/suspend.h>
 
 static struct cpufreq_frequency_table freq_table[] = {
 	{ .frequency = 216000 },
@@ -47,9 +46,6 @@ static struct clk *pll_x_clk;
 static struct clk *pll_p_clk;
 static struct clk *emc_clk;
 
-static DEFINE_MUTEX(tegra_cpu_lock);
-static bool is_suspended;
-
 static int tegra_cpu_clk_set_rate(unsigned long rate)
 {
 	int ret;
@@ -112,42 +108,9 @@ static int tegra_update_cpu_speed(struct cpufreq_policy *policy,
 
 static int tegra_target(struct cpufreq_policy *policy, unsigned int index)
 {
-	int ret = -EBUSY;
-
-	mutex_lock(&tegra_cpu_lock);
-
-	if (!is_suspended)
-		ret = tegra_update_cpu_speed(policy,
-				freq_table[index].frequency);
-
-	mutex_unlock(&tegra_cpu_lock);
-	return ret;
+	return tegra_update_cpu_speed(policy, freq_table[index].frequency);
 }
 
-static int tegra_pm_notify(struct notifier_block *nb, unsigned long event,
-	void *dummy)
-{
-	mutex_lock(&tegra_cpu_lock);
-	if (event == PM_SUSPEND_PREPARE) {
-		struct cpufreq_policy *policy = cpufreq_cpu_get(0);
-		is_suspended = true;
-		pr_info("Tegra cpufreq suspend: setting frequency to %d kHz\n",
-			freq_table[0].frequency);
-		if (clk_get_rate(cpu_clk) / 1000 != freq_table[0].frequency)
-			tegra_update_cpu_speed(policy, freq_table[0].frequency);
-		cpufreq_cpu_put(policy);
-	} else if (event == PM_POST_SUSPEND) {
-		is_suspended = false;
-	}
-	mutex_unlock(&tegra_cpu_lock);
-
-	return NOTIFY_OK;
-}
-
-static struct notifier_block tegra_cpu_pm_notifier = {
-	.notifier_call = tegra_pm_notify,
-};
-
 static int tegra_cpu_init(struct cpufreq_policy *policy)
 {
 	int ret;
@@ -166,10 +129,8 @@ static int tegra_cpu_init(struct cpufreq_policy *policy)
 		return ret;
 	}
 
-	if (policy->cpu == 0)
-		register_pm_notifier(&tegra_cpu_pm_notifier);
-
 	policy->clk = cpu_clk;
+	policy->suspend_freq = freq_table[0].frequency;
 	return 0;
 }
 
@@ -189,6 +150,9 @@ static struct cpufreq_driver tegra_cpufreq_driver = {
 	.exit		= tegra_cpu_exit,
 	.name		= "tegra",
 	.attr		= cpufreq_generic_attr,
+#ifdef CONFIG_PM
+	.suspend	= cpufreq_generic_suspend,
+#endif
 };
 
 static int __init tegra_cpufreq_init(void)
-- 
1.7.12.rc2.18.g61b472e

