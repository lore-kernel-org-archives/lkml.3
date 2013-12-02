Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753127Ab3LBFxz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 00:53:55 -0500
Received: from mail-qe0-f52.google.com ([209.85.128.52]:40928 "EHLO
	mail-qe0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752955Ab3LBFw5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 00:52:57 -0500
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@rjwysocki.net
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, nm@ti.com, swarren@wwwdotorg.org,
        kgene.kim@samsung.com, linux-samsung-soc@vger.kernel.org,
        linux-tegra@vger.kernel.org, tianyu.lan@intel.com,
        jhbird.choi@samsung.com, Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH V4 4/6] cpufreq: exynos: Use cpufreq_generic_suspend()
Date: Mon,  2 Dec 2013 11:22:34 +0530
Message-Id: <653a95bc01de9f02f04a10fcea496fda221a1fb3.1385962528.git.viresh.kumar@linaro.org>
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

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/cpufreq/exynos-cpufreq.c | 96 +++-------------------------------------
 1 file changed, 7 insertions(+), 89 deletions(-)

diff --git a/drivers/cpufreq/exynos-cpufreq.c b/drivers/cpufreq/exynos-cpufreq.c
index 0b3689c..ded4cf8 100644
--- a/drivers/cpufreq/exynos-cpufreq.c
+++ b/drivers/cpufreq/exynos-cpufreq.c
@@ -16,19 +16,14 @@
 #include <linux/slab.h>
 #include <linux/regulator/consumer.h>
 #include <linux/cpufreq.h>
-#include <linux/suspend.h>
 
 #include <plat/cpu.h>
 
 #include "exynos-cpufreq.h"
 
 static struct exynos_dvfs_info *exynos_info;
-
 static struct regulator *arm_regulator;
-
 static unsigned int locking_frequency;
-static bool frequency_locked;
-static DEFINE_MUTEX(cpufreq_lock);
 
 static int exynos_cpufreq_get_index(unsigned int freq)
 {
@@ -133,83 +128,13 @@ out:
 
 static int exynos_target(struct cpufreq_policy *policy, unsigned int index)
 {
-	struct cpufreq_frequency_table *freq_table = exynos_info->freq_table;
-	int ret = 0;
-
-	mutex_lock(&cpufreq_lock);
-
-	if (frequency_locked)
-		goto out;
-
-	ret = exynos_cpufreq_scale(freq_table[index].frequency);
-
-out:
-	mutex_unlock(&cpufreq_lock);
-
-	return ret;
-}
-
-#ifdef CONFIG_PM
-static int exynos_cpufreq_suspend(struct cpufreq_policy *policy)
-{
-	return 0;
-}
-
-static int exynos_cpufreq_resume(struct cpufreq_policy *policy)
-{
-	return 0;
-}
-#endif
-
-/**
- * exynos_cpufreq_pm_notifier - block CPUFREQ's activities in suspend-resume
- *			context
- * @notifier
- * @pm_event
- * @v
- *
- * While frequency_locked == true, target() ignores every frequency but
- * locking_frequency. The locking_frequency value is the initial frequency,
- * which is set by the bootloader. In order to eliminate possible
- * inconsistency in clock values, we save and restore frequencies during
- * suspend and resume and block CPUFREQ activities. Note that the standard
- * suspend/resume cannot be used as they are too deep (syscore_ops) for
- * regulator actions.
- */
-static int exynos_cpufreq_pm_notifier(struct notifier_block *notifier,
-				       unsigned long pm_event, void *v)
-{
-	int ret;
-
-	switch (pm_event) {
-	case PM_SUSPEND_PREPARE:
-		mutex_lock(&cpufreq_lock);
-		frequency_locked = true;
-		mutex_unlock(&cpufreq_lock);
-
-		ret = exynos_cpufreq_scale(locking_frequency);
-		if (ret < 0)
-			return NOTIFY_BAD;
-
-		break;
-
-	case PM_POST_SUSPEND:
-		mutex_lock(&cpufreq_lock);
-		frequency_locked = false;
-		mutex_unlock(&cpufreq_lock);
-		break;
-	}
-
-	return NOTIFY_OK;
+	return exynos_cpufreq_scale(exynos_info->freq_table[index].frequency);
 }
 
-static struct notifier_block exynos_cpufreq_nb = {
-	.notifier_call = exynos_cpufreq_pm_notifier,
-};
-
 static int exynos_cpufreq_cpu_init(struct cpufreq_policy *policy)
 {
 	policy->clk = exynos_info->cpu_clk;
+	policy->suspend_freq = locking_frequency;
 	return cpufreq_generic_init(policy, exynos_info->freq_table, 100000);
 }
 
@@ -223,8 +148,7 @@ static struct cpufreq_driver exynos_driver = {
 	.name		= "exynos_cpufreq",
 	.attr		= cpufreq_generic_attr,
 #ifdef CONFIG_PM
-	.suspend	= exynos_cpufreq_suspend,
-	.resume		= exynos_cpufreq_resume,
+	.suspend	= cpufreq_generic_suspend,
 #endif
 };
 
@@ -259,19 +183,13 @@ static int __init exynos_cpufreq_init(void)
 		goto err_vdd_arm;
 	}
 
+	/* Done here as we want to capture boot frequency */
 	locking_frequency = clk_get_rate(exynos_info->cpu_clk) / 1000;
 
-	register_pm_notifier(&exynos_cpufreq_nb);
-
-	if (cpufreq_register_driver(&exynos_driver)) {
-		pr_err("%s: failed to register cpufreq driver\n", __func__);
-		goto err_cpufreq;
-	}
-
-	return 0;
-err_cpufreq:
-	unregister_pm_notifier(&exynos_cpufreq_nb);
+	if (!cpufreq_register_driver(&exynos_driver))
+		return 0;
 
+	pr_err("%s: failed to register cpufreq driver\n", __func__);
 	regulator_put(arm_regulator);
 err_vdd_arm:
 	kfree(exynos_info);
-- 
1.7.12.rc2.18.g61b472e

