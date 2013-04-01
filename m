Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757983Ab3DAM7K (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 08:59:10 -0400
Received: from mail-pa0-f43.google.com ([209.85.220.43]:40545 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757909Ab3DAM7H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 08:59:07 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl
Cc: cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 8/9] cpufreq: drivers: Remove unnecessary assignments of policy-> members
Date: Mon,  1 Apr 2013 18:27:48 +0530
Message-Id: <589c264e34b383a44940ad84e2f79c28c0f78404.1364820621.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1364820620.git.viresh.kumar@linaro.org>
References: <cover.1364820620.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1364820620.git.viresh.kumar@linaro.org>
References: <cover.1364820620.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some assignments of policy-> min/max/cur/cpuinfo.min_freq/cpuinfo.max_freq
aren't required as part of it is done by cpufreq driver or cpufreq core.

Remove them.

At some places we merge multiple lines together too.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Acked-by: Sekhar Nori <nsekhar@ti.com>
---
 Documentation/cpu-freq/cpu-drivers.txt |  5 +++--
 arch/arm/mach-davinci/cpufreq.c        | 21 ++++++++-------------
 arch/arm/mach-imx/cpufreq.c            |  3 ---
 arch/sh/kernel/cpufreq.c               |  9 +++------
 drivers/cpufreq/cpufreq-nforce2.c      |  6 ++----
 drivers/cpufreq/omap-cpufreq.c         |  4 +---
 6 files changed, 17 insertions(+), 31 deletions(-)

diff --git a/Documentation/cpu-freq/cpu-drivers.txt b/Documentation/cpu-freq/cpu-drivers.txt
index 7c7721d..a3585ea 100644
--- a/Documentation/cpu-freq/cpu-drivers.txt
+++ b/Documentation/cpu-freq/cpu-drivers.txt
@@ -108,8 +108,9 @@ policy->governor		must contain the "default policy" for
 				cpufreq_driver.target is called with
 				these values.
 
-For setting some of these values, the frequency table helpers might be
-helpful. See the section 2 for more information on them.
+For setting some of these values (cpuinfo.min[max]_freq, policy->min[max]), the
+frequency table helpers might be helpful. See the section 2 for more information
+on them.
 
 SMP systems normally have same clock source for a group of cpus. For these the
 .init() would be called only once for the first online cpu. Here the .init()
diff --git a/arch/arm/mach-davinci/cpufreq.c b/arch/arm/mach-davinci/cpufreq.c
index 8fb0c2a..7c2e943 100644
--- a/arch/arm/mach-davinci/cpufreq.c
+++ b/arch/arm/mach-davinci/cpufreq.c
@@ -137,21 +137,16 @@ static int davinci_cpu_init(struct cpufreq_policy *policy)
 			return result;
 	}
 
-	policy->cur = policy->min = policy->max = davinci_getspeed(0);
-
-	if (freq_table) {
-		result = cpufreq_frequency_table_cpuinfo(policy, freq_table);
-		if (!result)
-			cpufreq_frequency_table_get_attr(freq_table,
-							policy->cpu);
-	} else {
-		policy->cpuinfo.min_freq = policy->min;
-		policy->cpuinfo.max_freq = policy->max;
+	policy->cur = davinci_getspeed(0);
+
+	result = cpufreq_frequency_table_cpuinfo(policy, freq_table);
+	if (result) {
+		pr_err("%s: cpufreq_frequency_table_cpuinfo() failed",
+				__func__);
+		return result;
 	}
 
-	policy->min = policy->cpuinfo.min_freq;
-	policy->max = policy->cpuinfo.max_freq;
-	policy->cur = davinci_getspeed(0);
+	cpufreq_frequency_table_get_attr(freq_table, policy->cpu);
 
 	/*
 	 * Time measurement across the target() function yields ~1500-1800us
diff --git a/arch/arm/mach-imx/cpufreq.c b/arch/arm/mach-imx/cpufreq.c
index cfce5e3..387dc4c 100644
--- a/arch/arm/mach-imx/cpufreq.c
+++ b/arch/arm/mach-imx/cpufreq.c
@@ -144,14 +144,11 @@ static int mxc_cpufreq_init(struct cpufreq_policy *policy)
 	imx_freq_table[i].frequency = CPUFREQ_TABLE_END;
 
 	policy->cur = clk_get_rate(cpu_clk) / 1000;
-	policy->min = policy->cpuinfo.min_freq = cpu_freq_khz_min;
-	policy->max = policy->cpuinfo.max_freq = cpu_freq_khz_max;
 
 	/* Manual states, that PLL stabilizes in two CLK32 periods */
 	policy->cpuinfo.transition_latency = 2 * NANOSECOND / CLK32_FREQ;
 
 	ret = cpufreq_frequency_table_cpuinfo(policy, imx_freq_table);
-
 	if (ret < 0) {
 		printk(KERN_ERR "%s: failed to register i.MXC CPUfreq with error code %d\n",
 		       __func__, ret);
diff --git a/arch/sh/kernel/cpufreq.c b/arch/sh/kernel/cpufreq.c
index 0fdf64b..88c8fee 100644
--- a/arch/sh/kernel/cpufreq.c
+++ b/arch/sh/kernel/cpufreq.c
@@ -116,7 +116,7 @@ static int sh_cpufreq_cpu_init(struct cpufreq_policy *policy)
 		return PTR_ERR(cpuclk);
 	}
 
-	policy->cur = policy->min = policy->max = sh_cpufreq_get(cpu);
+	policy->cur = sh_cpufreq_get(cpu);
 
 	freq_table = cpuclk->nr_freqs ? cpuclk->freq_table : NULL;
 	if (freq_table) {
@@ -129,15 +129,12 @@ static int sh_cpufreq_cpu_init(struct cpufreq_policy *policy)
 		dev_notice(dev, "no frequency table found, falling back "
 			   "to rate rounding.\n");
 
-		policy->cpuinfo.min_freq =
+		policy->min = policy->cpuinfo.min_freq =
 			(clk_round_rate(cpuclk, 1) + 500) / 1000;
-		policy->cpuinfo.max_freq =
+		policy->max = policy->cpuinfo.max_freq =
 			(clk_round_rate(cpuclk, ~0UL) + 500) / 1000;
 	}
 
-	policy->min = policy->cpuinfo.min_freq;
-	policy->max = policy->cpuinfo.max_freq;
-
 	policy->cpuinfo.transition_latency = CPUFREQ_ETERNAL;
 
 	dev_info(dev, "CPU Frequencies - Minimum %u.%03u MHz, "
diff --git a/drivers/cpufreq/cpufreq-nforce2.c b/drivers/cpufreq/cpufreq-nforce2.c
index 224a478..af1542d 100644
--- a/drivers/cpufreq/cpufreq-nforce2.c
+++ b/drivers/cpufreq/cpufreq-nforce2.c
@@ -359,12 +359,10 @@ static int nforce2_cpu_init(struct cpufreq_policy *policy)
 		min_fsb = NFORCE2_MIN_FSB;
 
 	/* cpuinfo and default policy values */
-	policy->cpuinfo.min_freq = min_fsb * fid * 100;
-	policy->cpuinfo.max_freq = max_fsb * fid * 100;
+	policy->min = policy->cpuinfo.min_freq = min_fsb * fid * 100;
+	policy->max = policy->cpuinfo.max_freq = max_fsb * fid * 100;
 	policy->cpuinfo.transition_latency = CPUFREQ_ETERNAL;
 	policy->cur = nforce2_get(policy->cpu);
-	policy->min = policy->cpuinfo.min_freq;
-	policy->max = policy->cpuinfo.max_freq;
 
 	return 0;
 }
diff --git a/drivers/cpufreq/omap-cpufreq.c b/drivers/cpufreq/omap-cpufreq.c
index b610edd..ad7549c 100644
--- a/drivers/cpufreq/omap-cpufreq.c
+++ b/drivers/cpufreq/omap-cpufreq.c
@@ -177,7 +177,7 @@ static int __cpuinit omap_cpu_init(struct cpufreq_policy *policy)
 		goto fail_ck;
 	}
 
-	policy->cur = policy->min = policy->max = omap_getspeed(policy->cpu);
+	policy->cur = omap_getspeed(policy->cpu);
 
 	if (!freq_table)
 		result = opp_init_cpufreq_table(mpu_dev, &freq_table);
@@ -196,8 +196,6 @@ static int __cpuinit omap_cpu_init(struct cpufreq_policy *policy)
 
 	cpufreq_frequency_table_get_attr(freq_table, policy->cpu);
 
-	policy->min = policy->cpuinfo.min_freq;
-	policy->max = policy->cpuinfo.max_freq;
 	policy->cur = omap_getspeed(policy->cpu);
 
 	/*
-- 
1.7.12.rc2.18.g61b472e

