Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754614Ab3HLRwB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 13:52:01 -0400
Received: from mail-pa0-f45.google.com ([209.85.220.45]:44166 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754551Ab3HLRvy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 13:51:54 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Viresh Kumar <viresh.kumar@linaro.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 20/31] cpufreq: p4: Covert to light weight ->target() routine
Date: Mon, 12 Aug 2013 23:18:56 +0530
Message-Id: <b74967b2fc1d27b96a97ceadd88db2547f73a98b.1376329128.git.viresh.kumar@linaro.org>
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

Cc: David S. Miller <davem@davemloft.net>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/cpufreq/p4-clockmod.c | 18 ++++--------------
 1 file changed, 4 insertions(+), 14 deletions(-)

diff --git a/drivers/cpufreq/p4-clockmod.c b/drivers/cpufreq/p4-clockmod.c
index e34857a..f4a193d 100644
--- a/drivers/cpufreq/p4-clockmod.c
+++ b/drivers/cpufreq/p4-clockmod.c
@@ -105,23 +105,13 @@ static struct cpufreq_frequency_table p4clockmod_table[] = {
 };
 
 
-static int cpufreq_p4_target(struct cpufreq_policy *policy,
-			     unsigned int target_freq,
-			     unsigned int relation)
+static int cpufreq_p4_target(struct cpufreq_policy *policy, unsigned int index)
 {
-	unsigned int    newstate = DC_RESV;
 	struct cpufreq_freqs freqs;
 	int i;
 
-	if (cpufreq_frequency_table_target(policy, &p4clockmod_table[0],
-				target_freq, relation, &newstate))
-		return -EINVAL;
-
 	freqs.old = cpufreq_p4_get(policy->cpu);
-	freqs.new = stock_freq * p4clockmod_table[newstate].driver_data / 8;
-
-	if (freqs.new == freqs.old)
-		return 0;
+	freqs.new = stock_freq * p4clockmod_table[index].driver_data / 8;
 
 	/* notifiers */
 	cpufreq_notify_transition(policy, &freqs, CPUFREQ_PRECHANGE);
@@ -131,7 +121,7 @@ static int cpufreq_p4_target(struct cpufreq_policy *policy,
 	 * Developer's Manual, Volume 3
 	 */
 	for_each_cpu(i, policy->cpus)
-		cpufreq_p4_setdc(i, p4clockmod_table[newstate].driver_data);
+		cpufreq_p4_setdc(i, p4clockmod_table[index].driver_data);
 
 	/* notifiers */
 	cpufreq_notify_transition(policy, &freqs, CPUFREQ_POSTCHANGE);
@@ -256,7 +246,7 @@ static unsigned int cpufreq_p4_get(unsigned int cpu)
 
 static struct cpufreq_driver p4clockmod_driver = {
 	.verify		= cpufreq_generic_frequency_table_verify,
-	.target_old	= cpufreq_p4_target,
+	.target		= cpufreq_p4_target,
 	.init		= cpufreq_p4_cpu_init,
 	.exit		= cpufreq_generic_exit,
 	.get		= cpufreq_p4_get,
-- 
1.7.12.rc2.18.g61b472e

