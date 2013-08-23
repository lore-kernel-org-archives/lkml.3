Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755634Ab3HWPwN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 11:52:13 -0400
Received: from mail-pd0-f180.google.com ([209.85.192.180]:52278 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755592Ab3HWPwI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 11:52:08 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 02/16] cpufreq: arm_big_little: use cpufreq_generic_get() routine
Date: Fri, 23 Aug 2013 21:20:37 +0530
Message-Id: <82b4537e5d949f81c565057e7738068ecb819b43.1377272740.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1377272740.git.viresh.kumar@linaro.org>
References: <cover.1377272740.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1377272740.git.viresh.kumar@linaro.org>
References: <cover.1377272740.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We have common infrastructure available with us for getting a CPUs clk rate.
Lets use it for this driver.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/cpufreq/arm_big_little.c | 10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

diff --git a/drivers/cpufreq/arm_big_little.c b/drivers/cpufreq/arm_big_little.c
index e3e8f25..f48430b 100644
--- a/drivers/cpufreq/arm_big_little.c
+++ b/drivers/cpufreq/arm_big_little.c
@@ -40,13 +40,6 @@ static struct clk *clk[MAX_CLUSTERS];
 static struct cpufreq_frequency_table *freq_table[MAX_CLUSTERS];
 static atomic_t cluster_usage[MAX_CLUSTERS] = {ATOMIC_INIT(0), ATOMIC_INIT(0)};
 
-static unsigned int bL_cpufreq_get(unsigned int cpu)
-{
-	u32 cur_cluster = cpu_to_cluster(cpu);
-
-	return clk_get_rate(clk[cur_cluster]) / 1000;
-}
-
 /* Set clock frequency */
 static int bL_cpufreq_set_target(struct cpufreq_policy *policy,
 		unsigned int index)
@@ -145,6 +138,7 @@ static int bL_cpufreq_init(struct cpufreq_policy *policy)
 	else
 		policy->cpuinfo.transition_latency = CPUFREQ_ETERNAL;
 
+	policy->clk = clk[cur_cluster];
 	cpumask_copy(policy->cpus, topology_core_cpumask(policy->cpu));
 
 	dev_info(cpu_dev, "%s: CPU %d initialized\n", __func__, policy->cpu);
@@ -174,7 +168,7 @@ static struct cpufreq_driver bL_cpufreq_driver = {
 	.flags			= CPUFREQ_STICKY,
 	.verify			= cpufreq_generic_frequency_table_verify,
 	.target_index		= bL_cpufreq_set_target,
-	.get			= bL_cpufreq_get,
+	.get			= cpufreq_generic_get,
 	.init			= bL_cpufreq_init,
 	.exit			= bL_cpufreq_exit,
 	.have_governor_per_policy = true,
-- 
1.7.12.rc2.18.g61b472e

