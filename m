Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932903Ab3IMNMf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 09:12:35 -0400
Received: from mail-pa0-f48.google.com ([209.85.220.48]:55108 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932868Ab3IMNM3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 09:12:29 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Eric Miao <eric.y.miao@gmail.com>
Subject: [PATCH 080/228] cpufreq: pxa: Use generic cpufreq routines
Date: Fri, 13 Sep 2013 18:30:26 +0530
Message-Id: <261b7d392095f4498f12a51c3ab64a43e7aa8493.1379063063.git.viresh.kumar@linaro.org>
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

Cc: Eric Miao <eric.y.miao@gmail.com>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/cpufreq/pxa2xx-cpufreq.c | 26 ++------------------------
 drivers/cpufreq/pxa3xx-cpufreq.c | 14 ++------------
 2 files changed, 4 insertions(+), 36 deletions(-)

diff --git a/drivers/cpufreq/pxa2xx-cpufreq.c b/drivers/cpufreq/pxa2xx-cpufreq.c
index 9e8a6b4..82905fe 100644
--- a/drivers/cpufreq/pxa2xx-cpufreq.c
+++ b/drivers/cpufreq/pxa2xx-cpufreq.c
@@ -262,23 +262,6 @@ static u32 mdrefr_dri(unsigned int freq)
 	return (interval - (cpu_is_pxa27x() ? 31 : 0)) / 32;
 }
 
-/* find a valid frequency point */
-static int pxa_verify_policy(struct cpufreq_policy *policy)
-{
-	struct cpufreq_frequency_table *pxa_freqs_table;
-	pxa_freqs_t *pxa_freqs;
-	int ret;
-
-	find_freq_tables(&pxa_freqs_table, &pxa_freqs);
-	ret = cpufreq_frequency_table_verify(policy, pxa_freqs_table);
-
-	if (freq_debug)
-		pr_debug("Verified CPU policy: %dKhz min to %dKhz max\n",
-			 policy->min, policy->max);
-
-	return ret;
-}
-
 static unsigned int pxa_cpufreq_get(unsigned int cpu)
 {
 	return get_clk_frequency_khz(0);
@@ -465,16 +448,11 @@ static int pxa_cpufreq_init(struct cpufreq_policy *policy)
 	return 0;
 }
 
-static int pxa_cpufreq_exit(struct cpufreq_policy *policy)
-{
-	cpufreq_frequency_table_put_attr(policy->cpu);
-}
-
 static struct cpufreq_driver pxa_cpufreq_driver = {
-	.verify	= pxa_verify_policy,
+	.verify	= cpufreq_generic_frequency_table_verify,
 	.target	= pxa_set_target,
 	.init	= pxa_cpufreq_init,
-	.exit	= pxa_cpufreq_exit,
+	.exit	= cpufreq_generic_exit,
 	.get	= pxa_cpufreq_get,
 	.name	= "PXA2xx",
 };
diff --git a/drivers/cpufreq/pxa3xx-cpufreq.c b/drivers/cpufreq/pxa3xx-cpufreq.c
index 085a27d..ae3ac08 100644
--- a/drivers/cpufreq/pxa3xx-cpufreq.c
+++ b/drivers/cpufreq/pxa3xx-cpufreq.c
@@ -150,11 +150,6 @@ static void __update_bus_freq(struct pxa3xx_freq_info *info)
 		cpu_relax();
 }
 
-static int pxa3xx_cpufreq_verify(struct cpufreq_policy *policy)
-{
-	return cpufreq_frequency_table_verify(policy, pxa3xx_freqs_table);
-}
-
 static unsigned int pxa3xx_cpufreq_get(unsigned int cpu)
 {
 	return pxa3xx_get_clk_frequency_khz(0);
@@ -229,16 +224,11 @@ static int pxa3xx_cpufreq_init(struct cpufreq_policy *policy)
 	return 0;
 }
 
-static int pxa3xx_cpufreq_exit(struct cpufreq_policy *policy)
-{
-	cpufreq_frequency_table_put_attr(policy->cpu);
-}
-
 static struct cpufreq_driver pxa3xx_cpufreq_driver = {
-	.verify		= pxa3xx_cpufreq_verify,
+	.verify		= cpufreq_generic_frequency_table_verify,
 	.target		= pxa3xx_cpufreq_set,
 	.init		= pxa3xx_cpufreq_init,
-	.exit		= pxa3xx_cpufreq_exit,
+	.exit		= cpufreq_generic_exit,
 	.get		= pxa3xx_cpufreq_get,
 	.name		= "pxa3xx-cpufreq",
 };
-- 
1.7.12.rc2.18.g61b472e

