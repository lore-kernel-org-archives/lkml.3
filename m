Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754916Ab3HLRwe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 13:52:34 -0400
Received: from mail-pa0-f48.google.com ([209.85.220.48]:46450 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754883Ab3HLRw3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 13:52:29 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Viresh Kumar <viresh.kumar@linaro.org>,
        Eric Miao <eric.y.miao@gmail.com>
Subject: [PATCH 25/31] cpufreq: pxa: Covert to light weight ->target() routine
Date: Mon, 12 Aug 2013 23:19:01 +0530
Message-Id: <41ec8b00a1b81ef8c8aadf0852d24da7a22a6d61.1376329128.git.viresh.kumar@linaro.org>
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

Cc: Eric Miao <eric.y.miao@gmail.com>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/cpufreq/pxa2xx-cpufreq.c | 13 ++-----------
 drivers/cpufreq/pxa3xx-cpufreq.c | 17 +++--------------
 2 files changed, 5 insertions(+), 25 deletions(-)

diff --git a/drivers/cpufreq/pxa2xx-cpufreq.c b/drivers/cpufreq/pxa2xx-cpufreq.c
index aff9800..fa5026b 100644
--- a/drivers/cpufreq/pxa2xx-cpufreq.c
+++ b/drivers/cpufreq/pxa2xx-cpufreq.c
@@ -267,14 +267,11 @@ static unsigned int pxa_cpufreq_get(unsigned int cpu)
 	return get_clk_frequency_khz(0);
 }
 
-static int pxa_set_target(struct cpufreq_policy *policy,
-			  unsigned int target_freq,
-			  unsigned int relation)
+static int pxa_set_target(struct cpufreq_policy *policy, unsigned int idx)
 {
 	struct cpufreq_frequency_table *pxa_freqs_table;
 	pxa_freqs_t *pxa_freq_settings;
 	struct cpufreq_freqs freqs;
-	unsigned int idx;
 	unsigned long flags;
 	unsigned int new_freq_cpu, new_freq_mem;
 	unsigned int unused, preset_mdrefr, postset_mdrefr, cclkcfg;
@@ -283,12 +280,6 @@ static int pxa_set_target(struct cpufreq_policy *policy,
 	/* Get the current policy */
 	find_freq_tables(&pxa_freqs_table, &pxa_freq_settings);
 
-	/* Lookup the next frequency */
-	if (cpufreq_frequency_table_target(policy, pxa_freqs_table,
-					   target_freq, relation, &idx)) {
-		return -EINVAL;
-	}
-
 	new_freq_cpu = pxa_freq_settings[idx].khz;
 	new_freq_mem = pxa_freq_settings[idx].membus;
 	freqs.old = policy->cur;
@@ -450,7 +441,7 @@ static int pxa_cpufreq_init(struct cpufreq_policy *policy)
 
 static struct cpufreq_driver pxa_cpufreq_driver = {
 	.verify	= cpufreq_generic_frequency_table_verify,
-	.target_old = pxa_set_target,
+	.target	= pxa_set_target,
 	.init	= pxa_cpufreq_init,
 	.exit	= cpufreq_generic_exit,
 	.get	= pxa_cpufreq_get,
diff --git a/drivers/cpufreq/pxa3xx-cpufreq.c b/drivers/cpufreq/pxa3xx-cpufreq.c
index 6cedfbf..58a904f 100644
--- a/drivers/cpufreq/pxa3xx-cpufreq.c
+++ b/drivers/cpufreq/pxa3xx-cpufreq.c
@@ -155,24 +155,16 @@ static unsigned int pxa3xx_cpufreq_get(unsigned int cpu)
 	return pxa3xx_get_clk_frequency_khz(0);
 }
 
-static int pxa3xx_cpufreq_set(struct cpufreq_policy *policy,
-			      unsigned int target_freq,
-			      unsigned int relation)
+static int pxa3xx_cpufreq_set(struct cpufreq_policy *policy, unsigned int index)
 {
 	struct pxa3xx_freq_info *next;
 	struct cpufreq_freqs freqs;
 	unsigned long flags;
-	int idx;
 
 	if (policy->cpu != 0)
 		return -EINVAL;
 
-	/* Lookup the next frequency */
-	if (cpufreq_frequency_table_target(policy, pxa3xx_freqs_table,
-				target_freq, relation, &idx))
-		return -EINVAL;
-
-	next = &pxa3xx_freqs[idx];
+	next = &pxa3xx_freqs[index];
 
 	freqs.old = policy->cur;
 	freqs.new = next->cpufreq_mhz * 1000;
@@ -181,9 +173,6 @@ static int pxa3xx_cpufreq_set(struct cpufreq_policy *policy,
 			freqs.old / 1000, freqs.new / 1000,
 			(freqs.old == freqs.new) ? " (skipped)" : "");
 
-	if (freqs.old == target_freq)
-		return 0;
-
 	cpufreq_notify_transition(policy, &freqs, CPUFREQ_PRECHANGE);
 
 	local_irq_save(flags);
@@ -224,7 +213,7 @@ static int pxa3xx_cpufreq_init(struct cpufreq_policy *policy)
 
 static struct cpufreq_driver pxa3xx_cpufreq_driver = {
 	.verify		= cpufreq_generic_frequency_table_verify,
-	.target_old	= pxa3xx_cpufreq_set,
+	.target		= pxa3xx_cpufreq_set,
 	.init		= pxa3xx_cpufreq_init,
 	.exit		= cpufreq_generic_exit,
 	.get		= pxa3xx_cpufreq_get,
-- 
1.7.12.rc2.18.g61b472e

