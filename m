Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755377Ab3HPC3f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Aug 2013 22:29:35 -0400
Received: from mail-pd0-f178.google.com ([209.85.192.178]:53048 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754997Ab3HPC33 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Aug 2013 22:29:29 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Russell King <linux@arm.linux.org.uk>
Subject: [PATCH 29/34] cpufreq: sa11x0: remove calls to cpufreq_notify_transition()
Date: Fri, 16 Aug 2013 07:55:26 +0530
Message-Id: <d5201184e4b090e3be5fc55917b1c7565df4c878.1376619363.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1376619363.git.viresh.kumar@linaro.org>
References: <cover.1376619363.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1376619363.git.viresh.kumar@linaro.org>
References: <cover.1376619363.git.viresh.kumar@linaro.org>
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

Cc: Russell King <linux@arm.linux.org.uk>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/cpufreq/sa1100-cpufreq.c | 17 ++++++-----------
 drivers/cpufreq/sa1110-cpufreq.c | 12 ++----------
 2 files changed, 8 insertions(+), 21 deletions(-)

diff --git a/drivers/cpufreq/sa1100-cpufreq.c b/drivers/cpufreq/sa1100-cpufreq.c
index aa49a08..a89c47b 100644
--- a/drivers/cpufreq/sa1100-cpufreq.c
+++ b/drivers/cpufreq/sa1100-cpufreq.c
@@ -180,22 +180,17 @@ static void sa1100_update_dram_timings(int current_speed, int new_speed)
 static int sa1100_target(struct cpufreq_policy *policy, unsigned int ppcr)
 {
 	unsigned int cur = sa11x0_getspeed(0);
-	struct cpufreq_freqs freqs;
+	unsigned int new_freq;
 
-	freqs.old = cur;
-	freqs.new = sa11x0_freq_table[ppcr].frequency;
+	new_freq = sa11x0_freq_table[ppcr].frequency;
 
-	cpufreq_notify_transition(policy, &freqs, CPUFREQ_PRECHANGE);
-
-	if (freqs.new > cur)
-		sa1100_update_dram_timings(cur, freqs.new);
+	if (new_freq > cur)
+		sa1100_update_dram_timings(cur, new_freq);
 
 	PPCR = ppcr;
 
-	if (freqs.new < cur)
-		sa1100_update_dram_timings(cur, freqs.new);
-
-	cpufreq_notify_transition(policy, &freqs, CPUFREQ_POSTCHANGE);
+	if (new_freq < cur)
+		sa1100_update_dram_timings(cur, new_freq);
 
 	return 0;
 }
diff --git a/drivers/cpufreq/sa1110-cpufreq.c b/drivers/cpufreq/sa1110-cpufreq.c
index c00cf2b..0e52e80 100644
--- a/drivers/cpufreq/sa1110-cpufreq.c
+++ b/drivers/cpufreq/sa1110-cpufreq.c
@@ -232,15 +232,11 @@ sdram_update_refresh(u_int cpu_khz, struct sdram_params *sdram)
 static int sa1110_target(struct cpufreq_policy *policy, unsigned int ppcr)
 {
 	struct sdram_params *sdram = &sdram_params;
-	struct cpufreq_freqs freqs;
 	struct sdram_info sd;
 	unsigned long flags;
 	unsigned int unused;
 
-	freqs.old = sa11x0_getspeed(0);
-	freqs.new = sa11x0_freq_table[ppcr].frequency;
-
-	sdram_calculate_timing(&sd, freqs.new, sdram);
+	sdram_calculate_timing(&sd, sa11x0_freq_table[ppcr].frequency, sdram);
 
 #if 0
 	/*
@@ -259,8 +255,6 @@ static int sa1110_target(struct cpufreq_policy *policy, unsigned int ppcr)
 	sd.mdcas[2] = 0xaaaaaaaa;
 #endif
 
-	cpufreq_notify_transition(policy, &freqs, CPUFREQ_PRECHANGE);
-
 	/*
 	 * The clock could be going away for some time.  Set the SDRAMs
 	 * to refresh rapidly (every 64 memory clock cycles).  To get
@@ -305,9 +299,7 @@ static int sa1110_target(struct cpufreq_policy *policy, unsigned int ppcr)
 	/*
 	 * Now, return the SDRAM refresh back to normal.
 	 */
-	sdram_update_refresh(freqs.new, sdram);
-
-	cpufreq_notify_transition(policy, &freqs, CPUFREQ_POSTCHANGE);
+	sdram_update_refresh(sa11x0_freq_table[ppcr].frequency, sdram);
 
 	return 0;
 }
-- 
1.7.12.rc2.18.g61b472e

