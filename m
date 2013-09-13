Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933003Ab3IMNVD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 09:21:03 -0400
Received: from mail-pb0-f42.google.com ([209.85.160.42]:44717 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932976Ab3IMNU5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 09:20:57 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Shawn Guo <shawn.guo@linaro.org>
Subject: [PATCH 152/228] cpufreq: cpu0: Convert to light weight ->target_index() routine
Date: Fri, 13 Sep 2013 18:31:38 +0530
Message-Id: <a9f8fdbf8a241ed804ec3a581893d7d4f72d5f41.1379063063.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1379063063.git.viresh.kumar@linaro.org>
References: <cover.1379063063.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1379063063.git.viresh.kumar@linaro.org>
References: <cover.1379063063.git.viresh.kumar@linaro.org>
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
 drivers/cpufreq/cpufreq-cpu0.c | 17 ++---------------
 1 file changed, 2 insertions(+), 15 deletions(-)

diff --git a/drivers/cpufreq/cpufreq-cpu0.c b/drivers/cpufreq/cpufreq-cpu0.c
index d8756e7..22a358f 100644
--- a/drivers/cpufreq/cpufreq-cpu0.c
+++ b/drivers/cpufreq/cpufreq-cpu0.c
@@ -34,24 +34,14 @@ static unsigned int cpu0_get_speed(unsigned int cpu)
 	return clk_get_rate(cpu_clk) / 1000;
 }
 
-static int cpu0_set_target(struct cpufreq_policy *policy,
-			   unsigned int target_freq, unsigned int relation)
+static int cpu0_set_target(struct cpufreq_policy *policy, unsigned int index)
 {
 	struct cpufreq_freqs freqs;
 	struct opp *opp;
 	unsigned long volt = 0, volt_old = 0, tol = 0;
 	long freq_Hz, freq_exact;
-	unsigned int index;
 	int ret;
 
-	ret = cpufreq_frequency_table_target(policy, freq_table, target_freq,
-					     relation, &index);
-	if (ret) {
-		pr_err("failed to match target freqency %d: %d\n",
-		       target_freq, ret);
-		return ret;
-	}
-
 	freq_Hz = clk_round_rate(cpu_clk, freq_table[index].frequency * 1000);
 	if (freq_Hz < 0)
 		freq_Hz = freq_table[index].frequency * 1000;
@@ -59,9 +49,6 @@ static int cpu0_set_target(struct cpufreq_policy *policy,
 	freqs.new = freq_Hz / 1000;
 	freqs.old = clk_get_rate(cpu_clk) / 1000;
 
-	if (freqs.old == freqs.new)
-		return 0;
-
 	cpufreq_notify_transition(policy, &freqs, CPUFREQ_PRECHANGE);
 
 	if (!IS_ERR(cpu_reg)) {
@@ -127,7 +114,7 @@ static int cpu0_cpufreq_init(struct cpufreq_policy *policy)
 static struct cpufreq_driver cpu0_cpufreq_driver = {
 	.flags = CPUFREQ_STICKY,
 	.verify = cpufreq_generic_frequency_table_verify,
-	.target = cpu0_set_target,
+	.target_index = cpu0_set_target,
 	.get = cpu0_get_speed,
 	.init = cpu0_cpufreq_init,
 	.exit = cpufreq_generic_exit,
-- 
1.7.12.rc2.18.g61b472e

