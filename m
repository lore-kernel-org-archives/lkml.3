Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932308Ab3HMNfx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 09:35:53 -0400
Received: from mail-pd0-f171.google.com ([209.85.192.171]:55315 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932257Ab3HMNfr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 09:35:47 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Viresh Kumar <viresh.kumar@linaro.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH V2 21/35] cpufreq: p4: Covert to light weight ->target_index() routine
Date: Tue, 13 Aug 2013 19:02:34 +0530
Message-Id: <bc02ad23b806d7d82eecd148809eb99e41b8bf64.1376392602.git.viresh.kumar@linaro.org>
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

Cc: David S. Miller <davem@davemloft.net>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/cpufreq/p4-clockmod.c | 18 ++++--------------
 1 file changed, 4 insertions(+), 14 deletions(-)

diff --git a/drivers/cpufreq/p4-clockmod.c b/drivers/cpufreq/p4-clockmod.c
index 4fe6d4c..5a6263e 100644
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
-	.target		= cpufreq_p4_target,
+	.target_index	= cpufreq_p4_target,
 	.init		= cpufreq_p4_cpu_init,
 	.exit		= cpufreq_generic_exit,
 	.get		= cpufreq_p4_get,
-- 
1.7.12.rc2.18.g61b472e

