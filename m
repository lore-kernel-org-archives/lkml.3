Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757158Ab3IMNVX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 09:21:23 -0400
Received: from mail-pb0-f48.google.com ([209.85.160.48]:60213 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933868Ab3IMNVS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 09:21:18 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 155/228] cpufreq: dbx500: Convert to light weight ->target_index() routine
Date: Fri, 13 Sep 2013 18:31:41 +0530
Message-Id: <e0ca159fa43ae01436c76818908539c49fa047ff.1379063063.git.viresh.kumar@linaro.org>
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

Acked-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/cpufreq/dbx500-cpufreq.c | 16 +++-------------
 1 file changed, 3 insertions(+), 13 deletions(-)

diff --git a/drivers/cpufreq/dbx500-cpufreq.c b/drivers/cpufreq/dbx500-cpufreq.c
index a60f769..238b169 100644
--- a/drivers/cpufreq/dbx500-cpufreq.c
+++ b/drivers/cpufreq/dbx500-cpufreq.c
@@ -20,23 +20,13 @@ static struct cpufreq_frequency_table *freq_table;
 static struct clk *armss_clk;
 
 static int dbx500_cpufreq_target(struct cpufreq_policy *policy,
-				unsigned int target_freq,
-				unsigned int relation)
+				unsigned int index)
 {
 	struct cpufreq_freqs freqs;
-	unsigned int idx;
 	int ret;
 
-	/* Lookup the next frequency */
-	if (cpufreq_frequency_table_target(policy, freq_table, target_freq,
-					relation, &idx))
-		return -EINVAL;
-
 	freqs.old = policy->cur;
-	freqs.new = freq_table[idx].frequency;
-
-	if (freqs.old == freqs.new)
-		return 0;
+	freqs.new = freq_table[index].frequency;
 
 	/* pre-change notification */
 	cpufreq_notify_transition(policy, &freqs, CPUFREQ_PRECHANGE);
@@ -80,7 +70,7 @@ static int dbx500_cpufreq_init(struct cpufreq_policy *policy)
 static struct cpufreq_driver dbx500_cpufreq_driver = {
 	.flags  = CPUFREQ_STICKY | CPUFREQ_CONST_LOOPS,
 	.verify = cpufreq_generic_frequency_table_verify,
-	.target = dbx500_cpufreq_target,
+	.target_index = dbx500_cpufreq_target,
 	.get    = dbx500_cpufreq_getspeed,
 	.init   = dbx500_cpufreq_init,
 	.name   = "DBX500",
-- 
1.7.12.rc2.18.g61b472e

