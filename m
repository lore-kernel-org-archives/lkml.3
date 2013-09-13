Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934375Ab3IMN1I (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 09:27:08 -0400
Received: from mail-pd0-f182.google.com ([209.85.192.182]:36142 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934363Ab3IMN1E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 09:27:04 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 202/228] cpufreq: ppc: remove calls to cpufreq_notify_transition()
Date: Fri, 13 Sep 2013 18:32:28 +0530
Message-Id: <5625ce6c229d9c1b96f8c7dd7ee1a8b72493e3d8.1379063063.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1379063063.git.viresh.kumar@linaro.org>
References: <cover.1379063063.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1379063063.git.viresh.kumar@linaro.org>
References: <cover.1379063063.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Most of the drivers do following in their ->target_index() routines:

	struct cpufreq_freqs freqs;
	freqs.old = old freq...
	freqs.new = new freq...

	cpufreq_notify_transition(policy, &freqs, CPUFREQ_PRECHANGE);

	/* Change rate here */

	cpufreq_notify_transition(policy, &freqs, CPUFREQ_POSTCHANGE);

This is replicated over all cpufreq drivers today and there doesn't exists a
good enough reason why this shouldn't be moved to cpufreq core instead.

Earlier patches have added support in cpufreq core to do cpufreq notification on
frequency change, this one removes it from this driver.

Some related minor cleanups are also done along with it.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/cpufreq/ppc-corenet-cpufreq.c | 19 +------------------
 drivers/cpufreq/ppc_cbe_cpufreq.c     | 19 +------------------
 2 files changed, 2 insertions(+), 36 deletions(-)

diff --git a/drivers/cpufreq/ppc-corenet-cpufreq.c b/drivers/cpufreq/ppc-corenet-cpufreq.c
index 79d8e9c..3f7be46 100644
--- a/drivers/cpufreq/ppc-corenet-cpufreq.c
+++ b/drivers/cpufreq/ppc-corenet-cpufreq.c
@@ -69,8 +69,6 @@ static const struct soc_data sdata[] = {
 static u32 min_cpufreq;
 static const u32 *fmask;
 
-/* serialize frequency changes  */
-static DEFINE_MUTEX(cpufreq_lock);
 static DEFINE_PER_CPU(struct cpu_data *, cpu_data);
 
 /* cpumask in a cluster */
@@ -253,26 +251,11 @@ static int __exit corenet_cpufreq_cpu_exit(struct cpufreq_policy *policy)
 static int corenet_cpufreq_target(struct cpufreq_policy *policy,
 		unsigned int index)
 {
-	struct cpufreq_freqs freqs;
 	struct clk *parent;
-	int ret;
 	struct cpu_data *data = per_cpu(cpu_data, policy->cpu);
 
-	freqs.old = policy->cur;
-	freqs.new = data->table[index].frequency;
-
-	mutex_lock(&cpufreq_lock);
-	cpufreq_notify_transition(policy, &freqs, CPUFREQ_PRECHANGE);
-
 	parent = of_clk_get(data->parent, data->table[index].driver_data);
-	ret = clk_set_parent(data->clk, parent);
-	if (ret)
-		freqs.new = freqs.old;
-
-	cpufreq_notify_transition(policy, &freqs, CPUFREQ_POSTCHANGE);
-	mutex_unlock(&cpufreq_lock);
-
-	return ret;
+	return clk_set_parent(data->clk, parent);
 }
 
 static struct cpufreq_driver ppc_corenet_cpufreq_driver = {
diff --git a/drivers/cpufreq/ppc_cbe_cpufreq.c b/drivers/cpufreq/ppc_cbe_cpufreq.c
index 52f707d..e42ca9c 100644
--- a/drivers/cpufreq/ppc_cbe_cpufreq.c
+++ b/drivers/cpufreq/ppc_cbe_cpufreq.c
@@ -30,9 +30,6 @@
 
 #include "ppc_cbe_cpufreq.h"
 
-static DEFINE_MUTEX(cbe_switch_mutex);
-
-
 /* the CBE supports an 8 step frequency scaling */
 static struct cpufreq_frequency_table cbe_freqs[] = {
 	{1,	0},
@@ -131,27 +128,13 @@ static int cbe_cpufreq_cpu_init(struct cpufreq_policy *policy)
 static int cbe_cpufreq_target(struct cpufreq_policy *policy,
 			      unsigned int cbe_pmode_new)
 {
-	int rc;
-	struct cpufreq_freqs freqs;
-
-	freqs.old = policy->cur;
-	freqs.new = cbe_freqs[cbe_pmode_new].frequency;
-
-	mutex_lock(&cbe_switch_mutex);
-	cpufreq_notify_transition(policy, &freqs, CPUFREQ_PRECHANGE);
-
 	pr_debug("setting frequency for cpu %d to %d kHz, " \
 		 "1/%d of max frequency\n",
 		 policy->cpu,
 		 cbe_freqs[cbe_pmode_new].frequency,
 		 cbe_freqs[cbe_pmode_new].driver_data);
 
-	rc = set_pmode(policy->cpu, cbe_pmode_new);
-
-	cpufreq_notify_transition(policy, &freqs, CPUFREQ_POSTCHANGE);
-	mutex_unlock(&cbe_switch_mutex);
-
-	return rc;
+	return set_pmode(policy->cpu, cbe_pmode_new);
 }
 
 static struct cpufreq_driver cbe_cpufreq_driver = {
-- 
1.7.12.rc2.18.g61b472e

