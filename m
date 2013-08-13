Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932433Ab3HMNgg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 09:36:36 -0400
Received: from mail-pd0-f176.google.com ([209.85.192.176]:57763 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932413Ab3HMNgb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 09:36:31 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Kukjin Kim <kgene.kim@samsung.com>
Subject: [PATCH V2 27/35] cpufreq: s3c2416: Covert to light weight ->target_index() routine
Date: Tue, 13 Aug 2013 19:02:40 +0530
Message-Id: <dcc6d57f4c2fe7fb915607d571d644b4a68321c9.1376392602.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1376392602.git.viresh.kumar@linaro.org>
References: <cover.1376392602.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1376392602.git.viresh.kumar@linaro.org>
References: <cover.1376392602.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch converts existing .target() to newly defined light weight
.target_index() routine for this driver.

CPUFreq core will call cpufreq_frequency_table_target() before calling this
routine and will pass index to it.

Cc: Kukjin Kim <kgene.kim@samsung.com>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/cpufreq/s3c2416-cpufreq.c | 17 ++++-------------
 1 file changed, 4 insertions(+), 13 deletions(-)

diff --git a/drivers/cpufreq/s3c2416-cpufreq.c b/drivers/cpufreq/s3c2416-cpufreq.c
index 8c57f10..90efbf5 100644
--- a/drivers/cpufreq/s3c2416-cpufreq.c
+++ b/drivers/cpufreq/s3c2416-cpufreq.c
@@ -217,24 +217,15 @@ static int s3c2416_cpufreq_leave_dvs(struct s3c2416_data *s3c_freq, int idx)
 }
 
 static int s3c2416_cpufreq_set_target(struct cpufreq_policy *policy,
-				      unsigned int target_freq,
-				      unsigned int relation)
+				      unsigned int index)
 {
 	struct s3c2416_data *s3c_freq = &s3c2416_cpufreq;
 	struct cpufreq_freqs freqs;
 	int idx, ret, to_dvs = 0;
-	unsigned int i;
 
 	mutex_lock(&cpufreq_lock);
 
-	pr_debug("cpufreq: to %dKHz, relation %d\n", target_freq, relation);
-
-	ret = cpufreq_frequency_table_target(policy, s3c_freq->freq_table,
-					     target_freq, relation, &i);
-	if (ret != 0)
-		goto out;
-
-	idx = s3c_freq->freq_table[i].driver_data;
+	idx = s3c_freq->freq_table[index].driver_data;
 
 	if (idx == SOURCE_HCLK)
 		to_dvs = 1;
@@ -256,7 +247,7 @@ static int s3c2416_cpufreq_set_target(struct cpufreq_policy *policy,
 	 */
 	freqs.new = (s3c_freq->is_dvs && !to_dvs)
 				? clk_get_rate(s3c_freq->hclk) / 1000
-				: s3c_freq->freq_table[i].frequency;
+				: s3c_freq->freq_table[index].frequency;
 
 	pr_debug("cpufreq: Transition %d-%dkHz\n", freqs.old, freqs.new);
 
@@ -509,7 +500,7 @@ err_hclk:
 static struct cpufreq_driver s3c2416_cpufreq_driver = {
 	.flags          = 0,
 	.verify		= cpufreq_generic_frequency_table_verify,
-	.target		= s3c2416_cpufreq_set_target,
+	.target_index	= s3c2416_cpufreq_set_target,
 	.get		= s3c2416_cpufreq_get_speed,
 	.init		= s3c2416_cpufreq_driver_init,
 	.name		= "s3c2416",
-- 
1.7.12.rc2.18.g61b472e

