Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754360Ab3HLRvy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 13:51:54 -0400
Received: from mail-pa0-f41.google.com ([209.85.220.41]:53515 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754512Ab3HLRvs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 13:51:48 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Viresh Kumar <viresh.kumar@linaro.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>
Subject: [PATCH 19/31] cpufreq: omap: Covert to light weight ->target() routine
Date: Mon, 12 Aug 2013 23:18:55 +0530
Message-Id: <8e4f5327604cc916e3f6563bb91d389b0f98b863.1376329128.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1376329128.git.viresh.kumar@linaro.org>
References: <cover.1376329128.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1376329128.git.viresh.kumar@linaro.org>
References: <cover.1376329128.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch converts existing .target_old() to newly defined light weight
.target() routine for this driver.

CPUFreq core will call cpufreq_frequency_table_target() before calling this
routine and will pass index to it.

Cc: Santosh Shilimkar <santosh.shilimkar@ti.com>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/cpufreq/omap-cpufreq.c | 31 +++----------------------------
 1 file changed, 3 insertions(+), 28 deletions(-)

diff --git a/drivers/cpufreq/omap-cpufreq.c b/drivers/cpufreq/omap-cpufreq.c
index 86b2910..99a9d0c 100644
--- a/drivers/cpufreq/omap-cpufreq.c
+++ b/drivers/cpufreq/omap-cpufreq.c
@@ -51,40 +51,15 @@ static unsigned int omap_getspeed(unsigned int cpu)
 	return rate;
 }
 
-static int omap_target(struct cpufreq_policy *policy,
-		       unsigned int target_freq,
-		       unsigned int relation)
+static int omap_target(struct cpufreq_policy *policy, unsigned int index)
 {
-	unsigned int i;
 	int r, ret = 0;
 	struct cpufreq_freqs freqs;
 	struct opp *opp;
 	unsigned long freq, volt = 0, volt_old = 0, tol = 0;
 
-	if (!freq_table) {
-		dev_err(mpu_dev, "%s: cpu%d: no freq table!\n", __func__,
-				policy->cpu);
-		return -EINVAL;
-	}
-
-	ret = cpufreq_frequency_table_target(policy, freq_table, target_freq,
-			relation, &i);
-	if (ret) {
-		dev_dbg(mpu_dev, "%s: cpu%d: no freq match for %d(ret=%d)\n",
-			__func__, policy->cpu, target_freq, ret);
-		return ret;
-	}
-	freqs.new = freq_table[i].frequency;
-	if (!freqs.new) {
-		dev_err(mpu_dev, "%s: cpu%d: no match for freq %d\n", __func__,
-			policy->cpu, target_freq);
-		return -EINVAL;
-	}
-
 	freqs.old = omap_getspeed(policy->cpu);
-
-	if (freqs.old == freqs.new && policy->cur == freqs.new)
-		return ret;
+	freqs.new = freq_table[index].frequency;
 
 	freq = freqs.new * 1000;
 	ret = clk_round_rate(mpu_clk, freq);
@@ -223,7 +198,7 @@ static int omap_cpu_exit(struct cpufreq_policy *policy)
 static struct cpufreq_driver omap_driver = {
 	.flags		= CPUFREQ_STICKY,
 	.verify		= cpufreq_generic_frequency_table_verify,
-	.target_old	= omap_target,
+	.target		= omap_target,
 	.get		= omap_getspeed,
 	.init		= omap_cpu_init,
 	.exit		= omap_cpu_exit,
-- 
1.7.12.rc2.18.g61b472e

