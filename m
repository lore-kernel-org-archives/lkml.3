Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932089Ab3HMNeU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 09:34:20 -0400
Received: from mail-pd0-f176.google.com ([209.85.192.176]:49706 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758215Ab3HMNeQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 09:34:16 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Viresh Kumar <viresh.kumar@linaro.org>, Sekhar Nori <nsekhar@ti.com>
Subject: [PATCH V2 09/35] cpufreq: davinci: Covert to light weight ->target_index() routine
Date: Tue, 13 Aug 2013 19:02:22 +0530
Message-Id: <85dcef4ab5e76cc011f09804c5472dff8ccd3d48.1376392602.git.viresh.kumar@linaro.org>
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

Cc: Sekhar Nori <nsekhar@ti.com>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/cpufreq/davinci-cpufreq.c | 16 +++-------------
 1 file changed, 3 insertions(+), 13 deletions(-)

diff --git a/drivers/cpufreq/davinci-cpufreq.c b/drivers/cpufreq/davinci-cpufreq.c
index 33e9460..822100b 100644
--- a/drivers/cpufreq/davinci-cpufreq.c
+++ b/drivers/cpufreq/davinci-cpufreq.c
@@ -68,28 +68,18 @@ static unsigned int davinci_getspeed(unsigned int cpu)
 	return clk_get_rate(cpufreq.armclk) / 1000;
 }
 
-static int davinci_target(struct cpufreq_policy *policy,
-				unsigned int target_freq, unsigned int relation)
+static int davinci_target(struct cpufreq_policy *policy, unsigned int idx)
 {
 	int ret = 0;
-	unsigned int idx;
 	struct cpufreq_freqs freqs;
 	struct davinci_cpufreq_config *pdata = cpufreq.dev->platform_data;
 	struct clk *armclk = cpufreq.armclk;
 
 	freqs.old = davinci_getspeed(0);
-	freqs.new = clk_round_rate(armclk, target_freq * 1000) / 1000;
-
-	if (freqs.old == freqs.new)
-		return ret;
+	freqs.new = pdata->freq_table[idx].frequency;
 
 	dev_dbg(cpufreq.dev, "transition: %u --> %u\n", freqs.old, freqs.new);
 
-	ret = cpufreq_frequency_table_target(policy, pdata->freq_table,
-						freqs.new, relation, &idx);
-	if (ret)
-		return -EINVAL;
-
 	cpufreq_notify_transition(policy, &freqs, CPUFREQ_PRECHANGE);
 
 	/* if moving to higher frequency, up the voltage beforehand */
@@ -160,7 +150,7 @@ static int davinci_cpu_init(struct cpufreq_policy *policy)
 static struct cpufreq_driver davinci_driver = {
 	.flags		= CPUFREQ_STICKY,
 	.verify		= davinci_verify_speed,
-	.target		= davinci_target,
+	.target_index	= davinci_target,
 	.get		= davinci_getspeed,
 	.init		= davinci_cpu_init,
 	.exit		= cpufreq_generic_exit,
-- 
1.7.12.rc2.18.g61b472e

