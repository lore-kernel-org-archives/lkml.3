Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933988Ab3IMNXY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 09:23:24 -0400
Received: from mail-pd0-f181.google.com ([209.85.192.181]:55300 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933374Ab3IMNXO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 09:23:14 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 170/228] cpufreq: ppc: Convert to light weight ->target_index() routine
Date: Fri, 13 Sep 2013 18:31:56 +0530
Message-Id: <e63f94c1261cdb530341ab05d71b801c8829f976.1379063063.git.viresh.kumar@linaro.org>
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

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/cpufreq/ppc-corenet-cpufreq.c | 15 ++++-----------
 drivers/cpufreq/ppc_cbe_cpufreq.c     | 12 ++----------
 2 files changed, 6 insertions(+), 21 deletions(-)

diff --git a/drivers/cpufreq/ppc-corenet-cpufreq.c b/drivers/cpufreq/ppc-corenet-cpufreq.c
index a0f562c..79d8e9c 100644
--- a/drivers/cpufreq/ppc-corenet-cpufreq.c
+++ b/drivers/cpufreq/ppc-corenet-cpufreq.c
@@ -251,27 +251,20 @@ static int __exit corenet_cpufreq_cpu_exit(struct cpufreq_policy *policy)
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
@@ -288,7 +281,7 @@ static struct cpufreq_driver ppc_corenet_cpufreq_driver = {
 	.init		= corenet_cpufreq_cpu_init,
 	.exit		= __exit_p(corenet_cpufreq_cpu_exit),
 	.verify		= cpufreq_generic_frequency_table_verify,
-	.target		= corenet_cpufreq_target,
+	.target_index	= corenet_cpufreq_target,
 	.get		= corenet_cpufreq_get_speed,
 	.attr		= cpufreq_generic_attr,
 };
diff --git a/drivers/cpufreq/ppc_cbe_cpufreq.c b/drivers/cpufreq/ppc_cbe_cpufreq.c
index 38540d1..52f707d 100644
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
-	.target		= cbe_cpufreq_target,
+	.target_index	= cbe_cpufreq_target,
 	.init		= cbe_cpufreq_cpu_init,
 	.exit		= cpufreq_generic_exit,
 	.name		= "cbe-cpufreq",
-- 
1.7.12.rc2.18.g61b472e

