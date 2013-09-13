Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934051Ab3IMNX4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 09:23:56 -0400
Received: from mail-pa0-f45.google.com ([209.85.220.45]:63516 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934038Ab3IMNXv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 09:23:51 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Russell King <linux@arm.linux.org.uk>
Subject: [PATCH 175/228] cpufreq: sa11x0: Convert to light weight ->target_index() routine
Date: Fri, 13 Sep 2013 18:32:01 +0530
Message-Id: <84ed2fae0095e526e0665f5859d39d3ff22c7613.1379063063.git.viresh.kumar@linaro.org>
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

Some existing routines are no more required and so are removed now.

Cc: Russell King <linux@arm.linux.org.uk>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 arch/arm/mach-sa1100/generic.c   | 20 --------------------
 arch/arm/mach-sa1100/generic.h   |  2 --
 drivers/cpufreq/sa1100-cpufreq.c | 24 ++++--------------------
 drivers/cpufreq/sa1110-cpufreq.c | 26 ++++----------------------
 4 files changed, 8 insertions(+), 64 deletions(-)

diff --git a/arch/arm/mach-sa1100/generic.c b/arch/arm/mach-sa1100/generic.c
index cb4b2ca..d4ea142 100644
--- a/arch/arm/mach-sa1100/generic.c
+++ b/arch/arm/mach-sa1100/generic.c
@@ -62,26 +62,6 @@ struct cpufreq_frequency_table sa11x0_freq_table[NR_FREQS+1] = {
 	{ .frequency = CPUFREQ_TABLE_END, },
 };
 
-/* rounds up(!)  */
-unsigned int sa11x0_freq_to_ppcr(unsigned int khz)
-{
-	int i;
-
-	for (i = 0; i < NR_FREQS; i++)
-		if (sa11x0_freq_table[i].frequency >= khz)
-			break;
-
-	return i;
-}
-
-unsigned int sa11x0_ppcr_to_freq(unsigned int idx)
-{
-	unsigned int freq = 0;
-	if (idx < NR_FREQS)
-		freq = sa11x0_freq_table[idx].frequency;
-	return freq;
-}
-
 unsigned int sa11x0_getspeed(unsigned int cpu)
 {
 	if (cpu)
diff --git a/arch/arm/mach-sa1100/generic.h b/arch/arm/mach-sa1100/generic.h
index 39d56a67..84505d5 100644
--- a/arch/arm/mach-sa1100/generic.h
+++ b/arch/arm/mach-sa1100/generic.h
@@ -22,9 +22,7 @@ extern void sa1110_mb_disable(void);
 struct cpufreq_policy;
 
 extern struct cpufreq_frequency_table sa11x0_freq_table[];
-extern unsigned int sa11x0_freq_to_ppcr(unsigned int khz);
 extern unsigned int sa11x0_getspeed(unsigned int cpu);
-extern unsigned int sa11x0_ppcr_to_freq(unsigned int idx);
 
 struct flash_platform_data;
 struct resource;
diff --git a/drivers/cpufreq/sa1100-cpufreq.c b/drivers/cpufreq/sa1100-cpufreq.c
index b282cea..b0da1fe 100644
--- a/drivers/cpufreq/sa1100-cpufreq.c
+++ b/drivers/cpufreq/sa1100-cpufreq.c
@@ -177,36 +177,20 @@ static void sa1100_update_dram_timings(int current_speed, int new_speed)
 	}
 }
 
-static int sa1100_target(struct cpufreq_policy *policy,
-			 unsigned int target_freq,
-			 unsigned int relation)
+static int sa1100_target(struct cpufreq_policy *policy, unsigned int ppcr)
 {
 	unsigned int cur = sa11x0_getspeed(0);
-	unsigned int new_ppcr;
 	struct cpufreq_freqs freqs;
 
-	new_ppcr = sa11x0_freq_to_ppcr(target_freq);
-	switch (relation) {
-	case CPUFREQ_RELATION_L:
-		if (sa11x0_ppcr_to_freq(new_ppcr) > policy->max)
-			new_ppcr--;
-		break;
-	case CPUFREQ_RELATION_H:
-		if ((sa11x0_ppcr_to_freq(new_ppcr) > target_freq) &&
-		    (sa11x0_ppcr_to_freq(new_ppcr - 1) >= policy->min))
-			new_ppcr--;
-		break;
-	}
-
 	freqs.old = cur;
-	freqs.new = sa11x0_ppcr_to_freq(new_ppcr);
+	freqs.new = sa11x0_freq_table[ppcr].frequency;
 
 	cpufreq_notify_transition(policy, &freqs, CPUFREQ_PRECHANGE);
 
 	if (freqs.new > cur)
 		sa1100_update_dram_timings(cur, freqs.new);
 
-	PPCR = new_ppcr;
+	PPCR = ppcr;
 
 	if (freqs.new < cur)
 		sa1100_update_dram_timings(cur, freqs.new);
@@ -224,7 +208,7 @@ static int __init sa1100_cpu_init(struct cpufreq_policy *policy)
 static struct cpufreq_driver sa1100_driver __refdata = {
 	.flags		= CPUFREQ_STICKY,
 	.verify		= cpufreq_generic_frequency_table_verify,
-	.target		= sa1100_target,
+	.target_index	= sa1100_target,
 	.get		= sa11x0_getspeed,
 	.init		= sa1100_cpu_init,
 	.name		= "sa1100",
diff --git a/drivers/cpufreq/sa1110-cpufreq.c b/drivers/cpufreq/sa1110-cpufreq.c
index bca04c0..55b1818c 100644
--- a/drivers/cpufreq/sa1110-cpufreq.c
+++ b/drivers/cpufreq/sa1110-cpufreq.c
@@ -229,34 +229,16 @@ sdram_update_refresh(u_int cpu_khz, struct sdram_params *sdram)
 /*
  * Ok, set the CPU frequency.
  */
-static int sa1110_target(struct cpufreq_policy *policy,
-			 unsigned int target_freq,
-			 unsigned int relation)
+static int sa1110_target(struct cpufreq_policy *policy, unsigned int ppcr)
 {
 	struct sdram_params *sdram = &sdram_params;
 	struct cpufreq_freqs freqs;
 	struct sdram_info sd;
 	unsigned long flags;
-	unsigned int ppcr, unused;
-
-	switch (relation) {
-	case CPUFREQ_RELATION_L:
-		ppcr = sa11x0_freq_to_ppcr(target_freq);
-		if (sa11x0_ppcr_to_freq(ppcr) > policy->max)
-			ppcr--;
-		break;
-	case CPUFREQ_RELATION_H:
-		ppcr = sa11x0_freq_to_ppcr(target_freq);
-		if (ppcr && (sa11x0_ppcr_to_freq(ppcr) > target_freq) &&
-		    (sa11x0_ppcr_to_freq(ppcr-1) >= policy->min))
-			ppcr--;
-		break;
-	default:
-		return -EINVAL;
-	}
+	unsigned int unused;
 
 	freqs.old = sa11x0_getspeed(0);
-	freqs.new = sa11x0_ppcr_to_freq(ppcr);
+	freqs.new = sa11x0_freq_table[ppcr].frequency;
 
 	sdram_calculate_timing(&sd, freqs.new, sdram);
 
@@ -340,7 +322,7 @@ static int __init sa1110_cpu_init(struct cpufreq_policy *policy)
 static struct cpufreq_driver sa1110_driver __refdata = {
 	.flags		= CPUFREQ_STICKY,
 	.verify		= cpufreq_generic_frequency_table_verify,
-	.target		= sa1110_target,
+	.target_index	= sa1110_target,
 	.get		= sa11x0_getspeed,
 	.init		= sa1110_cpu_init,
 	.name		= "sa1110",
-- 
1.7.12.rc2.18.g61b472e

