Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934036Ab3IMNXt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 09:23:49 -0400
Received: from mail-pa0-f44.google.com ([209.85.220.44]:55741 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934023Ab3IMNXn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 09:23:43 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Kukjin Kim <kgene.kim@samsung.com>
Subject: [PATCH 174/228] cpufreq: s5pv210: Convert to light weight ->target_index() routine
Date: Fri, 13 Sep 2013 18:32:00 +0530
Message-Id: <e135268849e16d1c07bc53e84d212a65d6b0038b.1379063063.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1379063063.git.viresh.kumar@linaro.org>
References: <cover.1379063063.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1379063063.git.viresh.kumar@linaro.org>
References: <cover.1379063063.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch converts existing .target() to newly defined light weight
.target_index() routine for this driver.

CPUFreq core will call cpufreq_frequency_table_target() before calling this
routine and will pass index to it.

This drivers wasn't as straight forward as other ones. It was doing some funny
stuff to disable driver while going into suspend mode. This part is simplified
as well to get this converted to ->target_index().

Cc: Kukjin Kim <kgene.kim@samsung.com>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/cpufreq/s5pv210-cpufreq.c | 54 ++++++++++-----------------------------
 1 file changed, 14 insertions(+), 40 deletions(-)

diff --git a/drivers/cpufreq/s5pv210-cpufreq.c b/drivers/cpufreq/s5pv210-cpufreq.c
index 600b4f4..5978b94 100644
--- a/drivers/cpufreq/s5pv210-cpufreq.c
+++ b/drivers/cpufreq/s5pv210-cpufreq.c
@@ -36,16 +36,7 @@ static DEFINE_MUTEX(set_freq_lock);
 /* Use 800MHz when entering sleep mode */
 #define SLEEP_FREQ	(800 * 1000)
 
-/*
- * relation has an additional symantics other than the standard of cpufreq
- * DISALBE_FURTHER_CPUFREQ: disable further access to target
- * ENABLE_FURTUER_CPUFREQ: enable access to target
- */
-enum cpufreq_access {
-	DISABLE_FURTHER_CPUFREQ = 0x10,
-	ENABLE_FURTHER_CPUFREQ = 0x20,
-};
-
+/* Tracks if cpu freqency can be updated anymore */
 static bool no_cpufreq_access;
 
 /*
@@ -182,12 +173,10 @@ static unsigned int s5pv210_getspeed(unsigned int cpu)
 	return clk_get_rate(cpu_clk) / 1000;
 }
 
-static int s5pv210_target(struct cpufreq_policy *policy,
-			  unsigned int target_freq,
-			  unsigned int relation)
+static int s5pv210_target(struct cpufreq_policy *policy, unsigned int index)
 {
 	unsigned long reg;
-	unsigned int index, priv_index;
+	unsigned int priv_index;
 	unsigned int pll_changing = 0;
 	unsigned int bus_speed_changing = 0;
 	int arm_volt, int_volt;
@@ -195,9 +184,6 @@ static int s5pv210_target(struct cpufreq_policy *policy,
 
 	mutex_lock(&set_freq_lock);
 
-	if (relation & ENABLE_FURTHER_CPUFREQ)
-		no_cpufreq_access = false;
-
 	if (no_cpufreq_access) {
 #ifdef CONFIG_PM_VERBOSE
 		pr_err("%s:%d denied access to %s as it is disabled"
@@ -207,27 +193,13 @@ static int s5pv210_target(struct cpufreq_policy *policy,
 		goto exit;
 	}
 
-	if (relation & DISABLE_FURTHER_CPUFREQ)
-		no_cpufreq_access = true;
-
-	relation &= ~(ENABLE_FURTHER_CPUFREQ | DISABLE_FURTHER_CPUFREQ);
-
 	freqs.old = s5pv210_getspeed(0);
-
-	if (cpufreq_frequency_table_target(policy, s5pv210_freq_table,
-					   target_freq, relation, &index)) {
-		ret = -EINVAL;
-		goto exit;
-	}
-
 	freqs.new = s5pv210_freq_table[index].frequency;
 
-	if (freqs.new == freqs.old)
-		goto exit;
-
 	/* Finding current running level index */
 	if (cpufreq_frequency_table_target(policy, s5pv210_freq_table,
-					   freqs.old, relation, &priv_index)) {
+					   freqs.old, CPUFREQ_RELATION_H,
+					   &priv_index)) {
 		ret = -EINVAL;
 		goto exit;
 	}
@@ -559,16 +531,18 @@ static int s5pv210_cpufreq_notifier_event(struct notifier_block *this,
 
 	switch (event) {
 	case PM_SUSPEND_PREPARE:
-		ret = cpufreq_driver_target(cpufreq_cpu_get(0), SLEEP_FREQ,
-					    DISABLE_FURTHER_CPUFREQ);
+		ret = cpufreq_driver_target(cpufreq_cpu_get(0), SLEEP_FREQ, 0);
 		if (ret < 0)
 			return NOTIFY_BAD;
 
+		/* Disable updation of cpu frequency */
+		no_cpufreq_access = true;
 		return NOTIFY_OK;
 	case PM_POST_RESTORE:
 	case PM_POST_SUSPEND:
-		cpufreq_driver_target(cpufreq_cpu_get(0), SLEEP_FREQ,
-				      ENABLE_FURTHER_CPUFREQ);
+		/* Enable updation of cpu frequency */
+		no_cpufreq_access = false;
+		cpufreq_driver_target(cpufreq_cpu_get(0), SLEEP_FREQ, 0);
 
 		return NOTIFY_OK;
 	}
@@ -581,18 +555,18 @@ static int s5pv210_cpufreq_reboot_notifier_event(struct notifier_block *this,
 {
 	int ret;
 
-	ret = cpufreq_driver_target(cpufreq_cpu_get(0), SLEEP_FREQ,
-				    DISABLE_FURTHER_CPUFREQ);
+	ret = cpufreq_driver_target(cpufreq_cpu_get(0), SLEEP_FREQ, 0);
 	if (ret < 0)
 		return NOTIFY_BAD;
 
+	no_cpufreq_access = true;
 	return NOTIFY_DONE;
 }
 
 static struct cpufreq_driver s5pv210_driver = {
 	.flags		= CPUFREQ_STICKY,
 	.verify		= cpufreq_generic_frequency_table_verify,
-	.target		= s5pv210_target,
+	.target_index	= s5pv210_target,
 	.get		= s5pv210_getspeed,
 	.init		= s5pv210_cpu_init,
 	.name		= "s5pv210",
-- 
1.7.12.rc2.18.g61b472e

