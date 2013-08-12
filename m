Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754055Ab3HLRvS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 13:51:18 -0400
Received: from mail-pd0-f181.google.com ([209.85.192.181]:52890 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753317Ab3HLRvN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 13:51:13 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Viresh Kumar <viresh.kumar@linaro.org>,
        Shawn Guo <shawn.guo@linaro.org>
Subject: [PATCH 14/31] cpufreq: imx6q: Covert to light weight ->target() routine
Date: Mon, 12 Aug 2013 23:18:50 +0530
Message-Id: <0de81d2f94cd90c8b4c35c0d4bb2483fc35a1e87.1376329128.git.viresh.kumar@linaro.org>
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

Cc: Shawn Guo <shawn.guo@linaro.org>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/cpufreq/imx6q-cpufreq.c | 17 ++---------------
 1 file changed, 2 insertions(+), 15 deletions(-)

diff --git a/drivers/cpufreq/imx6q-cpufreq.c b/drivers/cpufreq/imx6q-cpufreq.c
index d6e3e7e..f416066 100644
--- a/drivers/cpufreq/imx6q-cpufreq.c
+++ b/drivers/cpufreq/imx6q-cpufreq.c
@@ -39,30 +39,17 @@ static unsigned int imx6q_get_speed(unsigned int cpu)
 	return clk_get_rate(arm_clk) / 1000;
 }
 
-static int imx6q_set_target(struct cpufreq_policy *policy,
-			    unsigned int target_freq, unsigned int relation)
+static int imx6q_set_target(struct cpufreq_policy *policy, unsigned int index)
 {
 	struct cpufreq_freqs freqs;
 	struct opp *opp;
 	unsigned long freq_hz, volt, volt_old;
-	unsigned int index;
 	int ret;
 
-	ret = cpufreq_frequency_table_target(policy, freq_table, target_freq,
-					     relation, &index);
-	if (ret) {
-		dev_err(cpu_dev, "failed to match target frequency %d: %d\n",
-			target_freq, ret);
-		return ret;
-	}
-
 	freqs.new = freq_table[index].frequency;
 	freq_hz = freqs.new * 1000;
 	freqs.old = clk_get_rate(arm_clk) / 1000;
 
-	if (freqs.old == freqs.new)
-		return 0;
-
 	rcu_read_lock();
 	opp = opp_find_freq_ceil(cpu_dev, &freq_hz);
 	if (IS_ERR(opp)) {
@@ -187,7 +174,7 @@ static int imx6q_cpufreq_init(struct cpufreq_policy *policy)
 
 static struct cpufreq_driver imx6q_cpufreq_driver = {
 	.verify = cpufreq_generic_frequency_table_verify,
-	.target_old = imx6q_set_target,
+	.target = imx6q_set_target,
 	.get = imx6q_get_speed,
 	.init = imx6q_cpufreq_init,
 	.exit = cpufreq_generic_exit,
-- 
1.7.12.rc2.18.g61b472e

