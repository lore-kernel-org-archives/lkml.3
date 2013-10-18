Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755026Ab3JROAn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Oct 2013 10:00:43 -0400
Received: from mail-pa0-f54.google.com ([209.85.220.54]:44217 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754945Ab3JROAi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Oct 2013 10:00:38 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH V2 Resend 04/34] cpufreq: at32ap: Convert to light weight ->target_index() routine
Date: Fri, 18 Oct 2013 19:29:27 +0530
Message-Id: <cd54b0789109806f71f4628d6dd8ff98ccffe853.1382104515.git.viresh.kumar@linaro.org>
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

Acked-by: Hans-Christian Egtvedt <egtvedt@samfundet.no>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/cpufreq/at32ap-cpufreq.c | 23 +++++------------------
 1 file changed, 5 insertions(+), 18 deletions(-)

diff --git a/drivers/cpufreq/at32ap-cpufreq.c b/drivers/cpufreq/at32ap-cpufreq.c
index 7439ded..81d0752 100644
--- a/drivers/cpufreq/at32ap-cpufreq.c
+++ b/drivers/cpufreq/at32ap-cpufreq.c
@@ -35,25 +35,12 @@ static unsigned int at32_get_speed(unsigned int cpu)
 static unsigned int	ref_freq;
 static unsigned long	loops_per_jiffy_ref;
 
-static int at32_set_target(struct cpufreq_policy *policy,
-			  unsigned int target_freq,
-			  unsigned int relation)
+static int at32_set_target(struct cpufreq_policy *policy, unsigned int index)
 {
 	struct cpufreq_freqs freqs;
-	long freq;
-
-	/* Convert target_freq from kHz to Hz */
-	freq = clk_round_rate(cpuclk, target_freq * 1000);
-
-	/* Check if policy->min <= new_freq <= policy->max */
-	if(freq < (policy->min * 1000) || freq > (policy->max * 1000))
-		return -EINVAL;
-
-	pr_debug("cpufreq: requested frequency %u Hz\n", target_freq * 1000);
 
 	freqs.old = at32_get_speed(0);
-	freqs.new = (freq + 500) / 1000;
-	freqs.flags = 0;
+	freqs.new = freq_table[index].frequency;
 
 	if (!ref_freq) {
 		ref_freq = freqs.old;
@@ -64,13 +51,13 @@ static int at32_set_target(struct cpufreq_policy *policy,
 	if (freqs.old < freqs.new)
 		boot_cpu_data.loops_per_jiffy = cpufreq_scale(
 				loops_per_jiffy_ref, ref_freq, freqs.new);
-	clk_set_rate(cpuclk, freq);
+	clk_set_rate(cpuclk, freqs.new * 1000);
 	if (freqs.new < freqs.old)
 		boot_cpu_data.loops_per_jiffy = cpufreq_scale(
 				loops_per_jiffy_ref, ref_freq, freqs.new);
 	cpufreq_notify_transition(policy, &freqs, CPUFREQ_POSTCHANGE);
 
-	pr_debug("cpufreq: set frequency %lu Hz\n", freq);
+	pr_debug("cpufreq: set frequency %u Hz\n", freqs.new * 1000);
 
 	return 0;
 }
@@ -139,7 +126,7 @@ static struct cpufreq_driver at32_driver = {
 	.name		= "at32ap",
 	.init		= at32_cpufreq_driver_init,
 	.verify		= cpufreq_generic_frequency_table_verify,
-	.target		= at32_set_target,
+	.target_index	= at32_set_target,
 	.get		= at32_get_speed,
 	.flags		= CPUFREQ_STICKY,
 };
-- 
1.7.12.rc2.18.g61b472e

