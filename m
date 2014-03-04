Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756198AbaCDDBD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 22:01:03 -0500
Received: from mail-pb0-f51.google.com ([209.85.160.51]:46317 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756179AbaCDDBA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 22:01:00 -0500
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@rjwysocki.net
Cc: linaro-kernel@lists.linaro.org, cpufreq@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org, nm@ti.com,
        swarren@wwwdotorg.org, kgene.kim@samsung.com, jinchoi@broadcom.com,
        tianyu.lan@intel.com, sebastian.capella@linaro.org,
        jhbird.choi@samsung.com, Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH V6 Resend 4/5] cpufreq: s5pv210: Use cpufreq_generic_suspend()
Date: Tue,  4 Mar 2014 11:00:29 +0800
Message-Id: <bc47ce6362ce5b0ceda88c34715458c2671c2ffc.1393901906.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <b37f304efa4a007c0c53d9e8a33e11b7977cb0a4.1393901906.git.viresh.kumar@linaro.org>
References: <b37f304efa4a007c0c53d9e8a33e11b7977cb0a4.1393901906.git.viresh.kumar@linaro.org>
In-Reply-To: <b37f304efa4a007c0c53d9e8a33e11b7977cb0a4.1393901906.git.viresh.kumar@linaro.org>
References: <b37f304efa4a007c0c53d9e8a33e11b7977cb0a4.1393901906.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently we have implemented PM notifiers to disable/enable ->target() routines
functionality during suspend/resume.

Now we have support present in cpufreq core, lets use it.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/cpufreq/s5pv210-cpufreq.c | 49 +++------------------------------------
 1 file changed, 3 insertions(+), 46 deletions(-)

diff --git a/drivers/cpufreq/s5pv210-cpufreq.c b/drivers/cpufreq/s5pv210-cpufreq.c
index 55a8e9f..7242153 100644
--- a/drivers/cpufreq/s5pv210-cpufreq.c
+++ b/drivers/cpufreq/s5pv210-cpufreq.c
@@ -18,7 +18,6 @@
 #include <linux/cpufreq.h>
 #include <linux/reboot.h>
 #include <linux/regulator/consumer.h>
-#include <linux/suspend.h>
 
 #include <mach/map.h>
 #include <mach/regs-clock.h>
@@ -435,18 +434,6 @@ exit:
 	return ret;
 }
 
-#ifdef CONFIG_PM
-static int s5pv210_cpufreq_suspend(struct cpufreq_policy *policy)
-{
-	return 0;
-}
-
-static int s5pv210_cpufreq_resume(struct cpufreq_policy *policy)
-{
-	return 0;
-}
-#endif
-
 static int check_mem_type(void __iomem *dmc_reg)
 {
 	unsigned long val;
@@ -502,6 +489,7 @@ static int __init s5pv210_cpu_init(struct cpufreq_policy *policy)
 	s5pv210_dram_conf[1].refresh = (__raw_readl(S5P_VA_DMC1 + 0x30) * 1000);
 	s5pv210_dram_conf[1].freq = clk_get_rate(dmc1_clk);
 
+	policy->suspend_freq = SLEEP_FREQ;
 	return cpufreq_generic_init(policy, s5pv210_freq_table, 40000);
 
 out_dmc1:
@@ -511,32 +499,6 @@ out_dmc0:
 	return ret;
 }
 
-static int s5pv210_cpufreq_notifier_event(struct notifier_block *this,
-					  unsigned long event, void *ptr)
-{
-	int ret;
-
-	switch (event) {
-	case PM_SUSPEND_PREPARE:
-		ret = cpufreq_driver_target(cpufreq_cpu_get(0), SLEEP_FREQ, 0);
-		if (ret < 0)
-			return NOTIFY_BAD;
-
-		/* Disable updation of cpu frequency */
-		no_cpufreq_access = true;
-		return NOTIFY_OK;
-	case PM_POST_RESTORE:
-	case PM_POST_SUSPEND:
-		/* Enable updation of cpu frequency */
-		no_cpufreq_access = false;
-		cpufreq_driver_target(cpufreq_cpu_get(0), SLEEP_FREQ, 0);
-
-		return NOTIFY_OK;
-	}
-
-	return NOTIFY_DONE;
-}
-
 static int s5pv210_cpufreq_reboot_notifier_event(struct notifier_block *this,
 						 unsigned long event, void *ptr)
 {
@@ -558,15 +520,11 @@ static struct cpufreq_driver s5pv210_driver = {
 	.init		= s5pv210_cpu_init,
 	.name		= "s5pv210",
 #ifdef CONFIG_PM
-	.suspend	= s5pv210_cpufreq_suspend,
-	.resume		= s5pv210_cpufreq_resume,
+	.suspend	= cpufreq_generic_suspend,
+	.resume		= cpufreq_generic_suspend, /* We need to set SLEEP FREQ again */
 #endif
 };
 
-static struct notifier_block s5pv210_cpufreq_notifier = {
-	.notifier_call = s5pv210_cpufreq_notifier_event,
-};
-
 static struct notifier_block s5pv210_cpufreq_reboot_notifier = {
 	.notifier_call = s5pv210_cpufreq_reboot_notifier_event,
 };
@@ -586,7 +544,6 @@ static int __init s5pv210_cpufreq_init(void)
 		return PTR_ERR(int_regulator);
 	}
 
-	register_pm_notifier(&s5pv210_cpufreq_notifier);
 	register_reboot_notifier(&s5pv210_cpufreq_reboot_notifier);
 
 	return cpufreq_register_driver(&s5pv210_driver);
-- 
1.7.12.rc2.18.g61b472e

