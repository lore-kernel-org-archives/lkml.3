Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932456Ab3HMNgo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 09:36:44 -0400
Received: from mail-pd0-f176.google.com ([209.85.192.176]:39217 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932438Ab3HMNgi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 09:36:38 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Kukjin Kim <kgene.kim@samsung.com>
Subject: [PATCH V2 28/35] cpufreq: s3c64xx: Covert to light weight ->target_index() routine
Date: Tue, 13 Aug 2013 19:02:41 +0530
Message-Id: <1d6e581b39e323b5b868cddba622e1fe371a8faf.1376392602.git.viresh.kumar@linaro.org>
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
 drivers/cpufreq/s3c64xx-cpufreq.c | 18 ++++--------------
 1 file changed, 4 insertions(+), 14 deletions(-)

diff --git a/drivers/cpufreq/s3c64xx-cpufreq.c b/drivers/cpufreq/s3c64xx-cpufreq.c
index 99fbc49..72f733b 100644
--- a/drivers/cpufreq/s3c64xx-cpufreq.c
+++ b/drivers/cpufreq/s3c64xx-cpufreq.c
@@ -63,26 +63,16 @@ static unsigned int s3c64xx_cpufreq_get_speed(unsigned int cpu)
 }
 
 static int s3c64xx_cpufreq_set_target(struct cpufreq_policy *policy,
-				      unsigned int target_freq,
-				      unsigned int relation)
+				      unsigned int index)
 {
 	int ret;
-	unsigned int i;
 	struct cpufreq_freqs freqs;
 	struct s3c64xx_dvfs *dvfs;
 
-	ret = cpufreq_frequency_table_target(policy, s3c64xx_freq_table,
-					     target_freq, relation, &i);
-	if (ret != 0)
-		return ret;
-
 	freqs.old = clk_get_rate(armclk) / 1000;
-	freqs.new = s3c64xx_freq_table[i].frequency;
+	freqs.new = s3c64xx_freq_table[index].frequency;
 	freqs.flags = 0;
-	dvfs = &s3c64xx_dvfs_table[s3c64xx_freq_table[i].driver_data];
-
-	if (freqs.old == freqs.new)
-		return 0;
+	dvfs = &s3c64xx_dvfs_table[s3c64xx_freq_table[index].driver_data];
 
 	pr_debug("Transition %d-%dkHz\n", freqs.old, freqs.new);
 
@@ -257,7 +247,7 @@ static int s3c64xx_cpufreq_driver_init(struct cpufreq_policy *policy)
 static struct cpufreq_driver s3c64xx_cpufreq_driver = {
 	.flags          = 0,
 	.verify		= cpufreq_generic_frequency_table_verify,
-	.target		= s3c64xx_cpufreq_set_target,
+	.target_index	= s3c64xx_cpufreq_set_target,
 	.get		= s3c64xx_cpufreq_get_speed,
 	.init		= s3c64xx_cpufreq_driver_init,
 	.name		= "s3c",
-- 
1.7.12.rc2.18.g61b472e

