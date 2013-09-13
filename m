Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932911Ab3IMNMo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 09:12:44 -0400
Received: from mail-pb0-f50.google.com ([209.85.160.50]:44557 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932369Ab3IMNMh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 09:12:37 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Kukjin Kim <kgene.kim@samsung.com>
Subject: [PATCH 081/228] cpufreq: s3cx4xx: Use generic cpufreq routines
Date: Fri, 13 Sep 2013 18:30:27 +0530
Message-Id: <3a1d015b579bcf55bf1f2926fffff99cf9ee8f4f.1379063063.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1379063063.git.viresh.kumar@linaro.org>
References: <cover.1379063063.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1379063063.git.viresh.kumar@linaro.org>
References: <cover.1379063063.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Most of the CPUFreq drivers do similar things in .exit() and .verify() routines
and .attr. So its better if we have generic routines for them which can be used
by cpufreq drivers then.

This patch uses these generic routines for this driver.

Cc: Kukjin Kim <kgene.kim@samsung.com>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/cpufreq/s3c2416-cpufreq.c | 19 ++-----------------
 drivers/cpufreq/s3c24xx-cpufreq.c |  9 ---------
 drivers/cpufreq/s3c64xx-cpufreq.c | 10 +---------
 3 files changed, 3 insertions(+), 35 deletions(-)

diff --git a/drivers/cpufreq/s3c2416-cpufreq.c b/drivers/cpufreq/s3c2416-cpufreq.c
index a7a4c61..8c57f10 100644
--- a/drivers/cpufreq/s3c2416-cpufreq.c
+++ b/drivers/cpufreq/s3c2416-cpufreq.c
@@ -87,16 +87,6 @@ static struct cpufreq_frequency_table s3c2450_freq_table[] = {
 	{ 0, CPUFREQ_TABLE_END },
 };
 
-static int s3c2416_cpufreq_verify_speed(struct cpufreq_policy *policy)
-{
-	struct s3c2416_data *s3c_freq = &s3c2416_cpufreq;
-
-	if (policy->cpu != 0)
-		return -EINVAL;
-
-	return cpufreq_frequency_table_verify(policy, s3c_freq->freq_table);
-}
-
 static unsigned int s3c2416_cpufreq_get_speed(unsigned int cpu)
 {
 	struct s3c2416_data *s3c_freq = &s3c2416_cpufreq;
@@ -516,19 +506,14 @@ err_hclk:
 	return ret;
 }
 
-static struct freq_attr *s3c2416_cpufreq_attr[] = {
-	&cpufreq_freq_attr_scaling_available_freqs,
-	NULL,
-};
-
 static struct cpufreq_driver s3c2416_cpufreq_driver = {
 	.flags          = 0,
-	.verify		= s3c2416_cpufreq_verify_speed,
+	.verify		= cpufreq_generic_frequency_table_verify,
 	.target		= s3c2416_cpufreq_set_target,
 	.get		= s3c2416_cpufreq_get_speed,
 	.init		= s3c2416_cpufreq_driver_init,
 	.name		= "s3c2416",
-	.attr		= s3c2416_cpufreq_attr,
+	.attr		= cpufreq_generic_attr,
 };
 
 static int __init s3c2416_cpufreq_init(void)
diff --git a/drivers/cpufreq/s3c24xx-cpufreq.c b/drivers/cpufreq/s3c24xx-cpufreq.c
index 73856d1..027dec1 100644
--- a/drivers/cpufreq/s3c24xx-cpufreq.c
+++ b/drivers/cpufreq/s3c24xx-cpufreq.c
@@ -416,14 +416,6 @@ static int __init s3c_cpufreq_initclks(void)
 	return 0;
 }
 
-static int s3c_cpufreq_verify(struct cpufreq_policy *policy)
-{
-	if (policy->cpu != 0)
-		return -EINVAL;
-
-	return 0;
-}
-
 #ifdef CONFIG_PM
 static struct cpufreq_frequency_table suspend_pll;
 static unsigned int suspend_freq;
@@ -473,7 +465,6 @@ static int s3c_cpufreq_resume(struct cpufreq_policy *policy)
 
 static struct cpufreq_driver s3c24xx_driver = {
 	.flags		= CPUFREQ_STICKY,
-	.verify		= s3c_cpufreq_verify,
 	.target		= s3c_cpufreq_target,
 	.get		= s3c_cpufreq_get,
 	.init		= s3c_cpufreq_init,
diff --git a/drivers/cpufreq/s3c64xx-cpufreq.c b/drivers/cpufreq/s3c64xx-cpufreq.c
index 872f74d..99fbc49 100644
--- a/drivers/cpufreq/s3c64xx-cpufreq.c
+++ b/drivers/cpufreq/s3c64xx-cpufreq.c
@@ -54,14 +54,6 @@ static struct cpufreq_frequency_table s3c64xx_freq_table[] = {
 };
 #endif
 
-static int s3c64xx_cpufreq_verify_speed(struct cpufreq_policy *policy)
-{
-	if (policy->cpu != 0)
-		return -EINVAL;
-
-	return cpufreq_frequency_table_verify(policy, s3c64xx_freq_table);
-}
-
 static unsigned int s3c64xx_cpufreq_get_speed(unsigned int cpu)
 {
 	if (cpu != 0)
@@ -264,7 +256,7 @@ static int s3c64xx_cpufreq_driver_init(struct cpufreq_policy *policy)
 
 static struct cpufreq_driver s3c64xx_cpufreq_driver = {
 	.flags          = 0,
-	.verify		= s3c64xx_cpufreq_verify_speed,
+	.verify		= cpufreq_generic_frequency_table_verify,
 	.target		= s3c64xx_cpufreq_set_target,
 	.get		= s3c64xx_cpufreq_get_speed,
 	.init		= s3c64xx_cpufreq_driver_init,
-- 
1.7.12.rc2.18.g61b472e

