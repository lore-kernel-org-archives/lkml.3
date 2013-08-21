Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752482Ab3HUOn6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 10:43:58 -0400
Received: from mail-pb0-f48.google.com ([209.85.160.48]:50837 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752468Ab3HUOny (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 10:43:54 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Viresh Kumar <viresh.kumar@linaro.org>,
        Kukjin Kim <kgene.kim@samsung.com>
Subject: [PATCH 10/14] cpufreq: s3c: use cpufreq_generic_init() routine
Date: Wed, 21 Aug 2013 20:12:29 +0530
Message-Id: <f8d88a475f52e94a57d6b329e9993010200117fe.1377093938.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1377093938.git.viresh.kumar@linaro.org>
References: <cover.1377093938.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1377093938.git.viresh.kumar@linaro.org>
References: <cover.1377093938.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use generic cpufreq_generic_init() routine instead of replicating the same code
here.

Cc: Kukjin Kim <kgene.kim@samsung.com>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/cpufreq/s3c2416-cpufreq.c |  6 ++----
 drivers/cpufreq/s3c24xx-cpufreq.c | 13 +------------
 drivers/cpufreq/s3c64xx-cpufreq.c |  5 ++---
 3 files changed, 5 insertions(+), 19 deletions(-)

diff --git a/drivers/cpufreq/s3c2416-cpufreq.c b/drivers/cpufreq/s3c2416-cpufreq.c
index 0e13914..8d904a0 100644
--- a/drivers/cpufreq/s3c2416-cpufreq.c
+++ b/drivers/cpufreq/s3c2416-cpufreq.c
@@ -457,10 +457,8 @@ static int __init s3c2416_cpufreq_driver_init(struct cpufreq_policy *policy)
 	/* Datasheet says PLL stabalisation time must be at least 300us,
 	 * so but add some fudge. (reference in LOCKCON0 register description)
 	 */
-	policy->cpuinfo.transition_latency = (500 * 1000) +
-					     s3c_freq->regulator_latency;
-
-	ret = cpufreq_table_validate_and_show(policy, s3c_freq->freq_table);
+	ret = cpufreq_generic_init(policy, s3c_freq->freq_table,
+			(500 * 1000) + s3c_freq->regulator_latency);
 	if (ret)
 		goto err_freq_table;
 
diff --git a/drivers/cpufreq/s3c24xx-cpufreq.c b/drivers/cpufreq/s3c24xx-cpufreq.c
index e0fbaef..4850882 100644
--- a/drivers/cpufreq/s3c24xx-cpufreq.c
+++ b/drivers/cpufreq/s3c24xx-cpufreq.c
@@ -373,18 +373,7 @@ struct clk *s3c_cpufreq_clk_get(struct device *dev, const char *name)
 
 static int s3c_cpufreq_init(struct cpufreq_policy *policy)
 {
-	printk(KERN_INFO "%s: initialising policy %p\n", __func__, policy);
-
-	if (policy->cpu != 0)
-		return -EINVAL;
-
-	/* feed the latency information from the cpu driver */
-	policy->cpuinfo.transition_latency = cpu_cur.info->latency;
-
-	if (ftab)
-		return cpufreq_table_validate_and_show(policy, ftab);
-
-	return 0;
+	return cpufreq_generic_init(policy, ftab, cpu_cur.info->latency);
 }
 
 static int __init s3c_cpufreq_initclks(void)
diff --git a/drivers/cpufreq/s3c64xx-cpufreq.c b/drivers/cpufreq/s3c64xx-cpufreq.c
index a983559..8b49a06 100644
--- a/drivers/cpufreq/s3c64xx-cpufreq.c
+++ b/drivers/cpufreq/s3c64xx-cpufreq.c
@@ -213,9 +213,8 @@ static int s3c64xx_cpufreq_driver_init(struct cpufreq_policy *policy)
 	 * the PLLs, which we don't currently) is ~300us worst case,
 	 * but add some fudge.
 	 */
-	policy->cpuinfo.transition_latency = (500 * 1000) + regulator_latency;
-
-	ret = cpufreq_table_validate_and_show(policy, s3c64xx_freq_table);
+	ret = cpufreq_generic_init(policy, s3c64xx_freq_table,
+			(500 * 1000) + regulator_latency);
 	if (ret != 0) {
 		pr_err("Failed to configure frequency table: %d\n",
 		       ret);
-- 
1.7.12.rc2.18.g61b472e

