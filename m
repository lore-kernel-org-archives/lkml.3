Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031830Ab3HJGt2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Aug 2013 02:49:28 -0400
Received: from mail-pd0-f180.google.com ([209.85.192.180]:33275 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932705Ab3HJGtX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Aug 2013 02:49:23 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Viresh Kumar <viresh.kumar@linaro.org>,
        Shawn Guo <shawn.guo@linaro.org>
Subject: [PATCH 13/44] cpufreq: cpu0: Use generic cpufreq routines
Date: Sat, 10 Aug 2013 12:14:09 +0530
Message-Id: <3978525eb8c4b042fd399bb506d3d59960680538.1376116345.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1376116344.git.viresh.kumar@linaro.org>
References: <cover.1376116344.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1376116344.git.viresh.kumar@linaro.org>
References: <cover.1376116344.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Most of the CPUFreq drivers do similar things in .exit() and .verify() routines
and .attr. So its better if we have generic routines for them which can be used
by cpufreq drivers then.

This patch uses these generic routines for this driver.

Cc: Shawn Guo <shawn.guo@linaro.org>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/cpufreq/cpufreq-cpu0.c | 23 +++--------------------
 1 file changed, 3 insertions(+), 20 deletions(-)

diff --git a/drivers/cpufreq/cpufreq-cpu0.c b/drivers/cpufreq/cpufreq-cpu0.c
index 65d70a3..3d24e7b 100644
--- a/drivers/cpufreq/cpufreq-cpu0.c
+++ b/drivers/cpufreq/cpufreq-cpu0.c
@@ -29,11 +29,6 @@ static struct clk *cpu_clk;
 static struct regulator *cpu_reg;
 static struct cpufreq_frequency_table *freq_table;
 
-static int cpu0_verify_speed(struct cpufreq_policy *policy)
-{
-	return cpufreq_frequency_table_verify(policy, freq_table);
-}
-
 static unsigned int cpu0_get_speed(unsigned int cpu)
 {
 	return clk_get_rate(cpu_clk) / 1000;
@@ -147,27 +142,15 @@ static int cpu0_cpufreq_init(struct cpufreq_policy *policy)
 	return 0;
 }
 
-static int cpu0_cpufreq_exit(struct cpufreq_policy *policy)
-{
-	cpufreq_frequency_table_put_attr(policy->cpu);
-
-	return 0;
-}
-
-static struct freq_attr *cpu0_cpufreq_attr[] = {
-	&cpufreq_freq_attr_scaling_available_freqs,
-	NULL,
-};
-
 static struct cpufreq_driver cpu0_cpufreq_driver = {
 	.flags = CPUFREQ_STICKY,
-	.verify = cpu0_verify_speed,
+	.verify = cpufreq_generic_frequency_table_verify,
 	.target = cpu0_set_target,
 	.get = cpu0_get_speed,
 	.init = cpu0_cpufreq_init,
-	.exit = cpu0_cpufreq_exit,
+	.exit = cpufreq_generic_exit,
 	.name = "generic_cpu0",
-	.attr = cpu0_cpufreq_attr,
+	.attr = cpufreq_generic_attr,
 };
 
 static int cpu0_cpufreq_probe(struct platform_device *pdev)
-- 
1.7.12.rc2.18.g61b472e

