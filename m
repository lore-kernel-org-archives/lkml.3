Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932944Ab3IMNM7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 09:12:59 -0400
Received: from mail-pa0-f53.google.com ([209.85.220.53]:54640 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932908Ab3IMNMv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 09:12:51 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 083/228] cpufreq: sa11x0: Use generic cpufreq routines
Date: Fri, 13 Sep 2013 18:30:29 +0530
Message-Id: <773540c3d88ebdf24415774b0cfd31cb025c684c.1379063063.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1379063063.git.viresh.kumar@linaro.org>
References: <cover.1379063063.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1379063063.git.viresh.kumar@linaro.org>
References: <cover.1379063063.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Most of the CPUFreq drivers do similar things in .exit() and .verify() routines
and .attr. So its better if we have generic routines for them which can be used
by cpufreq drivers then.

This patch uses these generic routines for this driver.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 arch/arm/mach-sa1100/generic.c   | 22 ----------------------
 arch/arm/mach-sa1100/generic.h   |  1 -
 drivers/cpufreq/sa1100-cpufreq.c |  2 +-
 drivers/cpufreq/sa1110-cpufreq.c |  2 +-
 4 files changed, 2 insertions(+), 25 deletions(-)

diff --git a/arch/arm/mach-sa1100/generic.c b/arch/arm/mach-sa1100/generic.c
index 5c8167b..cb4b2ca 100644
--- a/arch/arm/mach-sa1100/generic.c
+++ b/arch/arm/mach-sa1100/generic.c
@@ -82,28 +82,6 @@ unsigned int sa11x0_ppcr_to_freq(unsigned int idx)
 	return freq;
 }
 
-
-/* make sure that only the "userspace" governor is run -- anything else wouldn't make sense on
- * this platform, anyway.
- */
-int sa11x0_verify_speed(struct cpufreq_policy *policy)
-{
-	unsigned int tmp;
-	if (policy->cpu)
-		return -EINVAL;
-
-	cpufreq_verify_within_limits(policy, policy->cpuinfo.min_freq, policy->cpuinfo.max_freq);
-
-	/* make sure that at least one frequency is within the policy */
-	tmp = sa11x0_freq_table[sa11x0_freq_to_ppcr(policy->min)].frequency;
-	if (tmp > policy->max)
-		policy->max = tmp;
-
-	cpufreq_verify_within_limits(policy, policy->cpuinfo.min_freq, policy->cpuinfo.max_freq);
-
-	return 0;
-}
-
 unsigned int sa11x0_getspeed(unsigned int cpu)
 {
 	if (cpu)
diff --git a/arch/arm/mach-sa1100/generic.h b/arch/arm/mach-sa1100/generic.h
index f5214ce..39d56a67 100644
--- a/arch/arm/mach-sa1100/generic.h
+++ b/arch/arm/mach-sa1100/generic.h
@@ -23,7 +23,6 @@ struct cpufreq_policy;
 
 extern struct cpufreq_frequency_table sa11x0_freq_table[];
 extern unsigned int sa11x0_freq_to_ppcr(unsigned int khz);
-extern int sa11x0_verify_speed(struct cpufreq_policy *policy);
 extern unsigned int sa11x0_getspeed(unsigned int cpu);
 extern unsigned int sa11x0_ppcr_to_freq(unsigned int idx);
 
diff --git a/drivers/cpufreq/sa1100-cpufreq.c b/drivers/cpufreq/sa1100-cpufreq.c
index 37fce2f..80a4fde 100644
--- a/drivers/cpufreq/sa1100-cpufreq.c
+++ b/drivers/cpufreq/sa1100-cpufreq.c
@@ -228,7 +228,7 @@ static int __init sa1100_cpu_init(struct cpufreq_policy *policy)
 
 static struct cpufreq_driver sa1100_driver __refdata = {
 	.flags		= CPUFREQ_STICKY,
-	.verify		= sa11x0_verify_speed,
+	.verify		= cpufreq_generic_frequency_table_verify,
 	.target		= sa1100_target,
 	.get		= sa11x0_getspeed,
 	.init		= sa1100_cpu_init,
diff --git a/drivers/cpufreq/sa1110-cpufreq.c b/drivers/cpufreq/sa1110-cpufreq.c
index 13760fc..a38d904 100644
--- a/drivers/cpufreq/sa1110-cpufreq.c
+++ b/drivers/cpufreq/sa1110-cpufreq.c
@@ -344,7 +344,7 @@ static int __init sa1110_cpu_init(struct cpufreq_policy *policy)
  * it with cpufreq_register_driver() */
 static struct cpufreq_driver sa1110_driver __refdata = {
 	.flags		= CPUFREQ_STICKY,
-	.verify		= sa11x0_verify_speed,
+	.verify		= cpufreq_generic_frequency_table_verify,
 	.target		= sa1110_target,
 	.get		= sa11x0_getspeed,
 	.init		= sa1110_cpu_init,
-- 
1.7.12.rc2.18.g61b472e

