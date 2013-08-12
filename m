Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754880Ab3HLRw3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 13:52:29 -0400
Received: from mail-pb0-f48.google.com ([209.85.160.48]:39579 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754821Ab3HLRwW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 13:52:22 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 24/31] cpufreq: ppc: Covert to light weight ->target() routine
Date: Mon, 12 Aug 2013 23:19:00 +0530
Message-Id: <7711bf09ff1684c68d019084befe6d46a54c5258.1376329128.git.viresh.kumar@linaro.org>
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

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/cpufreq/ppc-corenet-cpufreq.c | 15 ++++-----------
 drivers/cpufreq/ppc_cbe_cpufreq.c     | 12 ++----------
 2 files changed, 6 insertions(+), 21 deletions(-)

diff --git a/drivers/cpufreq/ppc-corenet-cpufreq.c b/drivers/cpufreq/ppc-corenet-cpufreq.c
index 0d174f5..2a991e9 100644
--- a/drivers/cpufreq/ppc-corenet-cpufreq.c
+++ b/drivers/cpufreq/ppc-corenet-cpufreq.c
@@ -253,27 +253,20 @@ static int __exit corenet_cpufreq_cpu_exit(struct cpufreq_policy *policy)
 }
 
 static int corenet_cpufreq_target(struct cpufreq_policy *policy,
-		unsigned int target_freq, unsigned int relation)
+		unsigned int index)
 {
 	struct cpufreq_freqs freqs;
-	unsigned int new;
 	struct clk *parent;
 	int ret;
 	struct cpu_data *data = per_cpu(cpu_data, policy->cpu);
 
-	cpufreq_frequency_table_target(policy, data->table,
-			target_freq, relation, &new);
-
-	if (policy->cur == data->table[new].frequency)
-		return 0;
-
 	freqs.old = policy->cur;
-	freqs.new = data->table[new].frequency;
+	freqs.new = data->table[index].frequency;
 
 	mutex_lock(&cpufreq_lock);
 	cpufreq_notify_transition(policy, &freqs, CPUFREQ_PRECHANGE);
 
-	parent = of_clk_get(data->parent, data->table[new].driver_data);
+	parent = of_clk_get(data->parent, data->table[index].driver_data);
 	ret = clk_set_parent(data->clk, parent);
 	if (ret)
 		freqs.new = freqs.old;
@@ -290,7 +283,7 @@ static struct cpufreq_driver ppc_corenet_cpufreq_driver = {
 	.init		= corenet_cpufreq_cpu_init,
 	.exit		= __exit_p(corenet_cpufreq_cpu_exit),
 	.verify		= cpufreq_generic_frequency_table_verify,
-	.target_old	= corenet_cpufreq_target,
+	.target		= corenet_cpufreq_target,
 	.get		= corenet_cpufreq_get_speed,
 	.attr		= cpufreq_generic_attr,
 };
diff --git a/drivers/cpufreq/ppc_cbe_cpufreq.c b/drivers/cpufreq/ppc_cbe_cpufreq.c
index f3783af..50161d5 100644
--- a/drivers/cpufreq/ppc_cbe_cpufreq.c
+++ b/drivers/cpufreq/ppc_cbe_cpufreq.c
@@ -129,18 +129,10 @@ static int cbe_cpufreq_cpu_init(struct cpufreq_policy *policy)
 }
 
 static int cbe_cpufreq_target(struct cpufreq_policy *policy,
-			      unsigned int target_freq,
-			      unsigned int relation)
+			      unsigned int cbe_pmode_new)
 {
 	int rc;
 	struct cpufreq_freqs freqs;
-	unsigned int cbe_pmode_new;
-
-	cpufreq_frequency_table_target(policy,
-				       cbe_freqs,
-				       target_freq,
-				       relation,
-				       &cbe_pmode_new);
 
 	freqs.old = policy->cur;
 	freqs.new = cbe_freqs[cbe_pmode_new].frequency;
@@ -164,7 +156,7 @@ static int cbe_cpufreq_target(struct cpufreq_policy *policy,
 
 static struct cpufreq_driver cbe_cpufreq_driver = {
 	.verify		= cpufreq_generic_frequency_table_verify,
-	.target_old	= cbe_cpufreq_target,
+	.target		= cbe_cpufreq_target,
 	.init		= cbe_cpufreq_cpu_init,
 	.exit		= cpufreq_generic_exit,
 	.name		= "cbe-cpufreq",
-- 
1.7.12.rc2.18.g61b472e

