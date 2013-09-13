Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933050Ab3IMNOJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 09:14:09 -0400
Received: from mail-pb0-f49.google.com ([209.85.160.49]:56861 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933021Ab3IMNOB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 09:14:01 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 093/228] cpufreq: at32ap: don't initialize part of policy that is set by core too
Date: Fri, 13 Sep 2013 18:30:39 +0530
Message-Id: <555cf20f110c47446ee8a2850703862d6fa88e6b.1379063063.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1379063063.git.viresh.kumar@linaro.org>
References: <cover.1379063063.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1379063063.git.viresh.kumar@linaro.org>
References: <cover.1379063063.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Many common initializations of struct policy are moved to core now and hence
this driver doesn't need to do it. This patch removes such code.

Most recent of those changes is to call ->get() in the core after calling
->init().

Acked-by: Hans-Christian Egtvedt <egtvedt@samfundet.no>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/cpufreq/at32ap-cpufreq.c | 12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff --git a/drivers/cpufreq/at32ap-cpufreq.c b/drivers/cpufreq/at32ap-cpufreq.c
index 788f7e7..7439ded 100644
--- a/drivers/cpufreq/at32ap-cpufreq.c
+++ b/drivers/cpufreq/at32ap-cpufreq.c
@@ -77,7 +77,7 @@ static int at32_set_target(struct cpufreq_policy *policy,
 
 static int __init at32_cpufreq_driver_init(struct cpufreq_policy *policy)
 {
-	unsigned int frequency, rate;
+	unsigned int frequency, rate, min_freq;
 	int retval, steps, i;
 
 	if (policy->cpu != 0)
@@ -90,12 +90,9 @@ static int __init at32_cpufreq_driver_init(struct cpufreq_policy *policy)
 		goto out_err;
 	}
 
-	policy->cpuinfo.min_freq = (clk_round_rate(cpuclk, 1) + 500) / 1000;
-	policy->cpuinfo.max_freq = (clk_round_rate(cpuclk, ~0UL) + 500) / 1000;
+	min_freq = (clk_round_rate(cpuclk, 1) + 500) / 1000;
+	frequency = (clk_round_rate(cpuclk, ~0UL) + 500) / 1000;
 	policy->cpuinfo.transition_latency = 0;
-	policy->cur = at32_get_speed(0);
-	policy->min = policy->cpuinfo.min_freq;
-	policy->max = policy->cpuinfo.max_freq;
 
 	/*
 	 * AVR32 CPU frequency rate scales in power of two between maximum and
@@ -104,7 +101,7 @@ static int __init at32_cpufreq_driver_init(struct cpufreq_policy *policy)
 	 * Further validate that the frequency is usable, and append it to the
 	 * frequency table.
 	 */
-	steps = fls(policy->cpuinfo.max_freq / policy->cpuinfo.min_freq) + 1;
+	steps = fls(frequency / min_freq) + 1;
 	freq_table = kzalloc(steps * sizeof(struct cpufreq_frequency_table),
 			GFP_KERNEL);
 	if (!freq_table) {
@@ -112,7 +109,6 @@ static int __init at32_cpufreq_driver_init(struct cpufreq_policy *policy)
 		goto out_err_put_clk;
 	}
 
-	frequency = policy->cpuinfo.max_freq;
 	for (i = 0; i < (steps - 1); i++) {
 		rate = clk_round_rate(cpuclk, frequency * 1000) / 1000;
 
-- 
1.7.12.rc2.18.g61b472e

