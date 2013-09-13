Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932844Ab3IMNUV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 09:20:21 -0400
Received: from mail-pb0-f43.google.com ([209.85.160.43]:46162 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933757Ab3IMNUP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 09:20:15 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 146/228] cpufreq: tegra: use cpufreq_generic_init() routine
Date: Fri, 13 Sep 2013 18:31:32 +0530
Message-Id: <14e1986c6418227f8c3c47ab9853eb7a65fad2f1.1379063063.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1379063063.git.viresh.kumar@linaro.org>
References: <cover.1379063063.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1379063063.git.viresh.kumar@linaro.org>
References: <cover.1379063063.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use generic cpufreq_generic_init() routine instead of replicating the same code
here.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/cpufreq/tegra-cpufreq.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/cpufreq/tegra-cpufreq.c b/drivers/cpufreq/tegra-cpufreq.c
index 9c32b23..32483ef 100644
--- a/drivers/cpufreq/tegra-cpufreq.c
+++ b/drivers/cpufreq/tegra-cpufreq.c
@@ -204,19 +204,23 @@ static struct notifier_block tegra_cpu_pm_notifier = {
 
 static int tegra_cpu_init(struct cpufreq_policy *policy)
 {
+	int ret;
+
 	if (policy->cpu >= NUM_CPUS)
 		return -EINVAL;
 
 	clk_prepare_enable(emc_clk);
 	clk_prepare_enable(cpu_clk);
 
-	cpufreq_table_validate_and_show(policy, freq_table);
 	target_cpu_speed[policy->cpu] = tegra_getspeed(policy->cpu);
 
 	/* FIXME: what's the actual transition time? */
-	policy->cpuinfo.transition_latency = 300 * 1000;
-
-	cpumask_copy(policy->cpus, cpu_possible_mask);
+	ret = cpufreq_generic_init(policy, freq_table, 300 * 1000);
+	if (ret) {
+		clk_disable_unprepare(cpu_clk);
+		clk_disable_unprepare(emc_clk);
+		return ret;
+	}
 
 	if (policy->cpu == 0)
 		register_pm_notifier(&tegra_cpu_pm_notifier);
@@ -227,6 +231,7 @@ static int tegra_cpu_init(struct cpufreq_policy *policy)
 static int tegra_cpu_exit(struct cpufreq_policy *policy)
 {
 	cpufreq_frequency_table_put_attr(policy->cpu);
+	clk_disable_unprepare(cpu_clk);
 	clk_disable_unprepare(emc_clk);
 	return 0;
 }
-- 
1.7.12.rc2.18.g61b472e

