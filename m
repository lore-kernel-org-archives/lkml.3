Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755545Ab3JROCD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Oct 2013 10:02:03 -0400
Received: from mail-pb0-f52.google.com ([209.85.160.52]:60250 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753370Ab3JROCA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Oct 2013 10:02:00 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Viresh Kumar <viresh.kumar@linaro.org>,
        Shawn Guo <shawn.guo@linaro.org>
Subject: [PATCH V2 Resend 14/34] cpufreq: imx6q: Convert to light weight ->target_index() routine
Date: Fri, 18 Oct 2013 19:29:37 +0530
Message-Id: <e0187f63fba961634c03c56cccc02ed3040779f4.1382104515.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1382104514.git.viresh.kumar@linaro.org>
References: <cover.1382104514.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1382104514.git.viresh.kumar@linaro.org>
References: <cover.1382104514.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch converts existing .target() to newly defined light weight
.target_index() routine for this driver.

CPUFreq core will call cpufreq_frequency_table_target() before calling this
routine and will pass index to it.

Cc: Shawn Guo <shawn.guo@linaro.org>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/cpufreq/imx6q-cpufreq.c | 17 ++---------------
 1 file changed, 2 insertions(+), 15 deletions(-)

diff --git a/drivers/cpufreq/imx6q-cpufreq.c b/drivers/cpufreq/imx6q-cpufreq.c
index be23892..07af3b0 100644
--- a/drivers/cpufreq/imx6q-cpufreq.c
+++ b/drivers/cpufreq/imx6q-cpufreq.c
@@ -40,30 +40,17 @@ static unsigned int imx6q_get_speed(unsigned int cpu)
 	return clk_get_rate(arm_clk) / 1000;
 }
 
-static int imx6q_set_target(struct cpufreq_policy *policy,
-			    unsigned int target_freq, unsigned int relation)
+static int imx6q_set_target(struct cpufreq_policy *policy, unsigned int index)
 {
 	struct cpufreq_freqs freqs;
 	struct dev_pm_opp *opp;
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
 	opp = dev_pm_opp_find_freq_ceil(cpu_dev, &freq_hz);
 	if (IS_ERR(opp)) {
@@ -159,7 +146,7 @@ static int imx6q_cpufreq_init(struct cpufreq_policy *policy)
 
 static struct cpufreq_driver imx6q_cpufreq_driver = {
 	.verify = cpufreq_generic_frequency_table_verify,
-	.target = imx6q_set_target,
+	.target_index = imx6q_set_target,
 	.get = imx6q_get_speed,
 	.init = imx6q_cpufreq_init,
 	.exit = cpufreq_generic_exit,
-- 
1.7.12.rc2.18.g61b472e

