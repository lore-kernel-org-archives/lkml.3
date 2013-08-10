Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968460Ab3HJGvd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Aug 2013 02:51:33 -0400
Received: from mail-pb0-f52.google.com ([209.85.160.52]:57969 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S968448Ab3HJGv2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Aug 2013 02:51:28 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 30/44] cpufreq: pmac: Use generic cpufreq routines
Date: Sat, 10 Aug 2013 12:14:26 +0530
Message-Id: <d063b45bd52ce7b3e164d712555e39c00f16269f.1376116345.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1376116344.git.viresh.kumar@linaro.org>
References: <cover.1376116344.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1376116344.git.viresh.kumar@linaro.org>
References: <cover.1376116344.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Most of the CPUFreq drivers do similar things in .exit() and .verify() routines
and .attr. So its better if we have generic routines for them which can be used
by cpufreq drivers then.

This patch uses these generic routines for this driver.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/cpufreq/pmac32-cpufreq.c | 14 ++------------
 drivers/cpufreq/pmac64-cpufreq.c | 14 ++------------
 2 files changed, 4 insertions(+), 24 deletions(-)

diff --git a/drivers/cpufreq/pmac32-cpufreq.c b/drivers/cpufreq/pmac32-cpufreq.c
index 0b3efdb..3f8efd2 100644
--- a/drivers/cpufreq/pmac32-cpufreq.c
+++ b/drivers/cpufreq/pmac32-cpufreq.c
@@ -85,11 +85,6 @@ static struct cpufreq_frequency_table pmac_cpu_freqs[] = {
 	{0,			CPUFREQ_TABLE_END},
 };
 
-static struct freq_attr* pmac_cpu_freqs_attr[] = {
-	&cpufreq_freq_attr_scaling_available_freqs,
-	NULL,
-};
-
 static inline void local_delay(unsigned long ms)
 {
 	if (no_schedule)
@@ -377,11 +372,6 @@ static unsigned int pmac_cpufreq_get_speed(unsigned int cpu)
 	return cur_freq;
 }
 
-static int pmac_cpufreq_verify(struct cpufreq_policy *policy)
-{
-	return cpufreq_frequency_table_verify(policy, pmac_cpu_freqs);
-}
-
 static int pmac_cpufreq_target(	struct cpufreq_policy *policy,
 					unsigned int target_freq,
 					unsigned int relation)
@@ -467,14 +457,14 @@ static int pmac_cpufreq_resume(struct cpufreq_policy *policy)
 }
 
 static struct cpufreq_driver pmac_cpufreq_driver = {
-	.verify 	= pmac_cpufreq_verify,
+	.verify 	= cpufreq_generic_frequency_table_verify,
 	.target 	= pmac_cpufreq_target,
 	.get		= pmac_cpufreq_get_speed,
 	.init		= pmac_cpufreq_cpu_init,
 	.suspend	= pmac_cpufreq_suspend,
 	.resume		= pmac_cpufreq_resume,
 	.flags		= CPUFREQ_PM_NO_WARN,
-	.attr		= pmac_cpu_freqs_attr,
+	.attr		= cpufreq_generic_attr,
 	.name		= "powermac",
 };
 
diff --git a/drivers/cpufreq/pmac64-cpufreq.c b/drivers/cpufreq/pmac64-cpufreq.c
index 366be61..0eb9313 100644
--- a/drivers/cpufreq/pmac64-cpufreq.c
+++ b/drivers/cpufreq/pmac64-cpufreq.c
@@ -69,11 +69,6 @@ static struct cpufreq_frequency_table g5_cpu_freqs[] = {
 	{0,			CPUFREQ_TABLE_END},
 };
 
-static struct freq_attr* g5_cpu_freqs_attr[] = {
-	&cpufreq_freq_attr_scaling_available_freqs,
-	NULL,
-};
-
 /* Power mode data is an array of the 32 bits PCR values to use for
  * the various frequencies, retrieved from the device-tree
  */
@@ -316,11 +311,6 @@ static int g5_pfunc_query_freq(void)
  * Common interface to the cpufreq core
  */
 
-static int g5_cpufreq_verify(struct cpufreq_policy *policy)
-{
-	return cpufreq_frequency_table_verify(policy, g5_cpu_freqs);
-}
-
 static int g5_cpufreq_target(struct cpufreq_policy *policy,
 	unsigned int target_freq, unsigned int relation)
 {
@@ -371,10 +361,10 @@ static struct cpufreq_driver g5_cpufreq_driver = {
 	.name		= "powermac",
 	.flags		= CPUFREQ_CONST_LOOPS,
 	.init		= g5_cpufreq_cpu_init,
-	.verify		= g5_cpufreq_verify,
+	.verify		= cpufreq_generic_frequency_table_verify,
 	.target		= g5_cpufreq_target,
 	.get		= g5_cpufreq_get_speed,
-	.attr 		= g5_cpu_freqs_attr,
+	.attr 		= cpufreq_generic_attr,
 };
 
 
-- 
1.7.12.rc2.18.g61b472e

