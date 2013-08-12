Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754505Ab3HLRvq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 13:51:46 -0400
Received: from mail-pb0-f48.google.com ([209.85.160.48]:50144 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754414Ab3HLRvk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 13:51:40 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Viresh Kumar <viresh.kumar@linaro.org>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
Subject: [PATCH 18/31] cpufreq: maple: Covert to light weight ->target() routine
Date: Mon, 12 Aug 2013 23:18:54 +0530
Message-Id: <2a0c90a15113539d3a9f3077e5ddd196e5d17301.1376329128.git.viresh.kumar@linaro.org>
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

Cc: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/cpufreq/maple-cpufreq.c | 16 ++++------------
 1 file changed, 4 insertions(+), 12 deletions(-)

diff --git a/drivers/cpufreq/maple-cpufreq.c b/drivers/cpufreq/maple-cpufreq.c
index 7f84a66..10ec535 100644
--- a/drivers/cpufreq/maple-cpufreq.c
+++ b/drivers/cpufreq/maple-cpufreq.c
@@ -131,26 +131,18 @@ static int maple_scom_query_freq(void)
  */
 
 static int maple_cpufreq_target(struct cpufreq_policy *policy,
-	unsigned int target_freq, unsigned int relation)
+	unsigned int index)
 {
-	unsigned int newstate = 0;
 	struct cpufreq_freqs freqs;
 	int rc;
 
-	if (cpufreq_frequency_table_target(policy, maple_cpu_freqs,
-			target_freq, relation, &newstate))
-		return -EINVAL;
-
-	if (maple_pmode_cur == newstate)
-		return 0;
-
 	mutex_lock(&maple_switch_mutex);
 
 	freqs.old = maple_cpu_freqs[maple_pmode_cur].frequency;
-	freqs.new = maple_cpu_freqs[newstate].frequency;
+	freqs.new = maple_cpu_freqs[index].frequency;
 
 	cpufreq_notify_transition(policy, &freqs, CPUFREQ_PRECHANGE);
-	rc = maple_scom_switch_freq(newstate);
+	rc = maple_scom_switch_freq(index);
 	cpufreq_notify_transition(policy, &freqs, CPUFREQ_POSTCHANGE);
 
 	mutex_unlock(&maple_switch_mutex);
@@ -181,7 +173,7 @@ static struct cpufreq_driver maple_cpufreq_driver = {
 	.flags		= CPUFREQ_CONST_LOOPS,
 	.init		= maple_cpufreq_cpu_init,
 	.verify		= cpufreq_generic_frequency_table_verify,
-	.target_old	= maple_cpufreq_target,
+	.target		= maple_cpufreq_target,
 	.get		= maple_cpufreq_get_speed,
 	.attr		= cpufreq_generic_attr,
 };
-- 
1.7.12.rc2.18.g61b472e

