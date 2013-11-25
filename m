Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757667Ab3KYOM6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 09:12:58 -0500
Received: from mail-pb0-f48.google.com ([209.85.160.48]:59761 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754994Ab3KYOMu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 09:12:50 -0500
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@rjwysocki.net
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, nm@ti.com, swarren@wwwdotorg.org,
        kgene.kim@samsung.com, linux-samsung-soc@vger.kernel.org,
        linux-tegra@vger.kernel.org, jinchoi@broadcom.com,
        tianyu.lan@intel.com, sebastian.capella@linaro.org,
        jhbird.choi@samsung.com, Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH V3 6/6] cpufreq: Tegra: Use cpufreq_generic_suspend()
Date: Mon, 25 Nov 2013 19:41:46 +0530
Message-Id: <d6b2668d6326b2279ff36086e2eb6ae1b334f496.1385374822.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1385374819.git.viresh.kumar@linaro.org>
References: <cover.1385374819.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1385374819.git.viresh.kumar@linaro.org>
References: <cover.1385374819.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently we have implemented PM notifiers to disable/enable ->target() routines
functionality during suspend/resume.

Now we have support present in cpufreq core, lets use it.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/cpufreq/tegra-cpufreq.c | 54 +++++------------------------------------
 1 file changed, 6 insertions(+), 48 deletions(-)

diff --git a/drivers/cpufreq/tegra-cpufreq.c b/drivers/cpufreq/tegra-cpufreq.c
index f42df7e..336368b 100644
--- a/drivers/cpufreq/tegra-cpufreq.c
+++ b/drivers/cpufreq/tegra-cpufreq.c
@@ -26,7 +26,6 @@
 #include <linux/err.h>
 #include <linux/clk.h>
 #include <linux/io.h>
-#include <linux/suspend.h>
 
 static struct cpufreq_frequency_table freq_table[] = {
 	{ .frequency = 216000 },
@@ -48,8 +47,6 @@ static struct clk *pll_p_clk;
 static struct clk *emc_clk;
 
 static unsigned long target_cpu_speed[NUM_CPUS];
-static DEFINE_MUTEX(tegra_cpu_lock);
-static bool is_suspended;
 
 static unsigned int tegra_getspeed(unsigned int cpu)
 {
@@ -137,50 +134,10 @@ static unsigned long tegra_cpu_highest_speed(void)
 
 static int tegra_target(struct cpufreq_policy *policy, unsigned int index)
 {
-	unsigned int freq;
-	int ret = 0;
-
-	mutex_lock(&tegra_cpu_lock);
-
-	if (is_suspended) {
-		ret = -EBUSY;
-		goto out;
-	}
-
-	freq = freq_table[index].frequency;
-
-	target_cpu_speed[policy->cpu] = freq;
-
-	ret = tegra_update_cpu_speed(policy, tegra_cpu_highest_speed());
-
-out:
-	mutex_unlock(&tegra_cpu_lock);
-	return ret;
+	target_cpu_speed[policy->cpu] = freq_table[index].frequency;
+	return tegra_update_cpu_speed(policy, tegra_cpu_highest_speed());
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
-		tegra_update_cpu_speed(policy, freq_table[0].frequency);
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
@@ -192,6 +149,7 @@ static int tegra_cpu_init(struct cpufreq_policy *policy)
 	clk_prepare_enable(cpu_clk);
 
 	target_cpu_speed[policy->cpu] = tegra_getspeed(policy->cpu);
+	policy->suspend_freq = freq_table[0].frequency;
 
 	/* FIXME: what's the actual transition time? */
 	ret = cpufreq_generic_init(policy, freq_table, 300 * 1000);
@@ -201,9 +159,6 @@ static int tegra_cpu_init(struct cpufreq_policy *policy)
 		return ret;
 	}
 
-	if (policy->cpu == 0)
-		register_pm_notifier(&tegra_cpu_pm_notifier);
-
 	return 0;
 }
 
@@ -223,6 +178,9 @@ static struct cpufreq_driver tegra_cpufreq_driver = {
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

