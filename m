Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758078Ab3HMNbb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 09:31:31 -0400
Received: from mail-pd0-f180.google.com ([209.85.192.180]:58317 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758059Ab3HMNb2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 09:31:28 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux@arm.linux.org.uk,
        linux-arm-kernel@lists.infradead.org,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 1/3] cpufreq: sa11x0: Expose frequency table
Date: Tue, 13 Aug 2013 19:01:05 +0530
Message-Id: <919d210b08b23daf2565b5b39fc9af59733ac56c.1376392060.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1376392060.git.viresh.kumar@linaro.org>
References: <cover.1376392060.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1376392060.git.viresh.kumar@linaro.org>
References: <cover.1376392060.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch exposes sa11x0's frequency table to cpufreq core. It always existed
but not as an array frequencies and not in the format cpufreq core wants it to.
Also it was present in the unit of 100kHz earlier which is made consistent with
cpufreq core now, i.e. kHz.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 arch/arm/mach-sa1100/generic.c   | 45 ++++++++++++++++++++--------------------
 arch/arm/mach-sa1100/generic.h   |  1 +
 drivers/cpufreq/sa1100-cpufreq.c |  3 ++-
 drivers/cpufreq/sa1110-cpufreq.c |  3 ++-
 4 files changed, 27 insertions(+), 25 deletions(-)

diff --git a/arch/arm/mach-sa1100/generic.c b/arch/arm/mach-sa1100/generic.c
index f25b611..5c8167b 100644
--- a/arch/arm/mach-sa1100/generic.c
+++ b/arch/arm/mach-sa1100/generic.c
@@ -42,23 +42,24 @@ EXPORT_SYMBOL(reset_status);
 /*
  * This table is setup for a 3.6864MHz Crystal.
  */
-static const unsigned short cclk_frequency_100khz[NR_FREQS] = {
-	 590,	/*  59.0 MHz */
-	 737,	/*  73.7 MHz */
-	 885,	/*  88.5 MHz */
-	1032,	/* 103.2 MHz */
-	1180,	/* 118.0 MHz */
-	1327,	/* 132.7 MHz */
-	1475,	/* 147.5 MHz */
-	1622,	/* 162.2 MHz */
-	1769,	/* 176.9 MHz */
-	1917,	/* 191.7 MHz */
-	2064,	/* 206.4 MHz */
-	2212,	/* 221.2 MHz */
-	2359,	/* 235.9 MHz */
-	2507,	/* 250.7 MHz */
-	2654,	/* 265.4 MHz */
-	2802	/* 280.2 MHz */
+struct cpufreq_frequency_table sa11x0_freq_table[NR_FREQS+1] = {
+	{ .frequency = 59000,	/*  59.0 MHz */},
+	{ .frequency = 73700,	/*  73.7 MHz */},
+	{ .frequency = 88500,	/*  88.5 MHz */},
+	{ .frequency = 103200,	/* 103.2 MHz */},
+	{ .frequency = 118000,	/* 118.0 MHz */},
+	{ .frequency = 132700,	/* 132.7 MHz */},
+	{ .frequency = 147500,	/* 147.5 MHz */},
+	{ .frequency = 162200,	/* 162.2 MHz */},
+	{ .frequency = 176900,	/* 176.9 MHz */},
+	{ .frequency = 191700,	/* 191.7 MHz */},
+	{ .frequency = 206400,	/* 206.4 MHz */},
+	{ .frequency = 221200,	/* 221.2 MHz */},
+	{ .frequency = 235900,	/* 235.9 MHz */},
+	{ .frequency = 250700,	/* 250.7 MHz */},
+	{ .frequency = 265400,	/* 265.4 MHz */},
+	{ .frequency = 280200,	/* 280.2 MHz */},
+	{ .frequency = CPUFREQ_TABLE_END, },
 };
 
 /* rounds up(!)  */
@@ -66,10 +67,8 @@ unsigned int sa11x0_freq_to_ppcr(unsigned int khz)
 {
 	int i;
 
-	khz /= 100;
-
 	for (i = 0; i < NR_FREQS; i++)
-		if (cclk_frequency_100khz[i] >= khz)
+		if (sa11x0_freq_table[i].frequency >= khz)
 			break;
 
 	return i;
@@ -79,7 +78,7 @@ unsigned int sa11x0_ppcr_to_freq(unsigned int idx)
 {
 	unsigned int freq = 0;
 	if (idx < NR_FREQS)
-		freq = cclk_frequency_100khz[idx] * 100;
+		freq = sa11x0_freq_table[idx].frequency;
 	return freq;
 }
 
@@ -96,7 +95,7 @@ int sa11x0_verify_speed(struct cpufreq_policy *policy)
 	cpufreq_verify_within_limits(policy, policy->cpuinfo.min_freq, policy->cpuinfo.max_freq);
 
 	/* make sure that at least one frequency is within the policy */
-	tmp = cclk_frequency_100khz[sa11x0_freq_to_ppcr(policy->min)] * 100;
+	tmp = sa11x0_freq_table[sa11x0_freq_to_ppcr(policy->min)].frequency;
 	if (tmp > policy->max)
 		policy->max = tmp;
 
@@ -109,7 +108,7 @@ unsigned int sa11x0_getspeed(unsigned int cpu)
 {
 	if (cpu)
 		return 0;
-	return cclk_frequency_100khz[PPCR & 0xf] * 100;
+	return sa11x0_freq_table[PPCR & 0xf].frequency;
 }
 
 /*
diff --git a/arch/arm/mach-sa1100/generic.h b/arch/arm/mach-sa1100/generic.h
index 9a33695..f5214ce 100644
--- a/arch/arm/mach-sa1100/generic.h
+++ b/arch/arm/mach-sa1100/generic.h
@@ -21,6 +21,7 @@ extern void sa1110_mb_disable(void);
 
 struct cpufreq_policy;
 
+extern struct cpufreq_frequency_table sa11x0_freq_table[];
 extern unsigned int sa11x0_freq_to_ppcr(unsigned int khz);
 extern int sa11x0_verify_speed(struct cpufreq_policy *policy);
 extern unsigned int sa11x0_getspeed(unsigned int cpu);
diff --git a/drivers/cpufreq/sa1100-cpufreq.c b/drivers/cpufreq/sa1100-cpufreq.c
index cff18e8..1323a69 100644
--- a/drivers/cpufreq/sa1100-cpufreq.c
+++ b/drivers/cpufreq/sa1100-cpufreq.c
@@ -224,7 +224,8 @@ static int __init sa1100_cpu_init(struct cpufreq_policy *policy)
 	policy->cpuinfo.min_freq = 59000;
 	policy->cpuinfo.max_freq = 287000;
 	policy->cpuinfo.transition_latency = CPUFREQ_ETERNAL;
-	return 0;
+
+	return cpufreq_table_validate_and_show(policy, sa11x0_freq_table);
 }
 
 static struct cpufreq_driver sa1100_driver __refdata = {
diff --git a/drivers/cpufreq/sa1110-cpufreq.c b/drivers/cpufreq/sa1110-cpufreq.c
index 39c90b6..adb0524 100644
--- a/drivers/cpufreq/sa1110-cpufreq.c
+++ b/drivers/cpufreq/sa1110-cpufreq.c
@@ -338,7 +338,8 @@ static int __init sa1110_cpu_init(struct cpufreq_policy *policy)
 	policy->cpuinfo.min_freq = 59000;
 	policy->cpuinfo.max_freq = 287000;
 	policy->cpuinfo.transition_latency = CPUFREQ_ETERNAL;
-	return 0;
+
+	return cpufreq_table_validate_and_show(policy, sa11x0_freq_table);
 }
 
 /* sa1110_driver needs __refdata because it must remain after init registers
-- 
1.7.12.rc2.18.g61b472e

