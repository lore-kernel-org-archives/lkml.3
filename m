Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755155Ab3HPC2z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Aug 2013 22:28:55 -0400
Received: from mail-pd0-f173.google.com ([209.85.192.173]:36762 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755107Ab3HPC2v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Aug 2013 22:28:51 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 24/34] cpufreq: powernow: remove calls to cpufreq_notify_transition()
Date: Fri, 16 Aug 2013 07:55:21 +0530
Message-Id: <68dee0a7584dcc2ee8a8afa2cb29e6af80cf99a4.1376619363.git.viresh.kumar@linaro.org>
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

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/cpufreq/powernow-k6.c |  8 --------
 drivers/cpufreq/powernow-k7.c | 11 +----------
 drivers/cpufreq/powernow-k8.c | 15 +--------------
 3 files changed, 2 insertions(+), 32 deletions(-)

diff --git a/drivers/cpufreq/powernow-k6.c b/drivers/cpufreq/powernow-k6.c
index 643e795..fedbe87 100644
--- a/drivers/cpufreq/powernow-k6.c
+++ b/drivers/cpufreq/powernow-k6.c
@@ -73,18 +73,12 @@ static int powernow_k6_target(struct cpufreq_policy *policy,
 {
 	unsigned long outvalue = 0, invalue = 0;
 	unsigned long msrval;
-	struct cpufreq_freqs freqs;
 
 	if (clock_ratio[best_i].driver_data > max_multiplier) {
 		printk(KERN_ERR PFX "invalid target frequency\n");
 		return -EINVAL;
 	}
 
-	freqs.old = busfreq * powernow_k6_get_cpu_multiplier();
-	freqs.new = busfreq * clock_ratio[best_i].driver_data;
-
-	cpufreq_notify_transition(policy, &freqs, CPUFREQ_PRECHANGE);
-
 	/* we now need to transform best_i to the BVC format, see AMD#23446 */
 
 	outvalue = (1<<12) | (1<<10) | (1<<9) | (best_i<<5);
@@ -98,8 +92,6 @@ static int powernow_k6_target(struct cpufreq_policy *policy,
 	msrval = POWERNOW_IOPORT + 0x0;
 	wrmsr(MSR_K6_EPMR, msrval, 0); /* disable it again */
 
-	cpufreq_notify_transition(policy, &freqs, CPUFREQ_POSTCHANGE);
-
 	return 0;
 }
 
diff --git a/drivers/cpufreq/powernow-k7.c b/drivers/cpufreq/powernow-k7.c
index 946708a..8e52463 100644
--- a/drivers/cpufreq/powernow-k7.c
+++ b/drivers/cpufreq/powernow-k7.c
@@ -251,7 +251,6 @@ static void change_VID(int vid)
 static int powernow_target(struct cpufreq_policy *policy, unsigned int index)
 {
 	u8 fid, vid;
-	struct cpufreq_freqs freqs;
 	union msr_fidvidstatus fidvidstatus;
 	int cfid;
 
@@ -265,18 +264,13 @@ static int powernow_target(struct cpufreq_policy *policy, unsigned int index)
 
 	rdmsrl(MSR_K7_FID_VID_STATUS, fidvidstatus.val);
 	cfid = fidvidstatus.bits.CFID;
-	freqs.old = fsb * fid_codes[cfid] / 10;
-
-	freqs.new = powernow_table[index].frequency;
-
-	cpufreq_notify_transition(policy, &freqs, CPUFREQ_PRECHANGE);
 
 	/* Now do the magic poking into the MSRs.  */
 
 	if (have_a0 == 1)	/* A0 errata 5 */
 		local_irq_disable();
 
-	if (freqs.old > freqs.new) {
+	if (fsb * fid_codes[cfid] / 10 > powernow_table[index].frequency) {
 		/* Going down, so change FID first */
 		change_FID(fid);
 		change_VID(vid);
@@ -286,12 +280,9 @@ static int powernow_target(struct cpufreq_policy *policy, unsigned int index)
 		change_FID(fid);
 	}
 
-
 	if (have_a0 == 1)
 		local_irq_enable();
 
-	cpufreq_notify_transition(policy, &freqs, CPUFREQ_POSTCHANGE);
-
 	return 0;
 }
 
diff --git a/drivers/cpufreq/powernow-k8.c b/drivers/cpufreq/powernow-k8.c
index 62a1ce4..b00eabe 100644
--- a/drivers/cpufreq/powernow-k8.c
+++ b/drivers/cpufreq/powernow-k8.c
@@ -931,8 +931,6 @@ static int transition_frequency_fidvid(struct powernow_k8_data *data,
 	struct cpufreq_policy *policy;
 	u32 fid = 0;
 	u32 vid = 0;
-	int res;
-	struct cpufreq_freqs freqs;
 
 	pr_debug("cpu %d transition to index %u\n", smp_processor_id(), index);
 
@@ -957,22 +955,11 @@ static int transition_frequency_fidvid(struct powernow_k8_data *data,
 
 	pr_debug("cpu %d, changing to fid 0x%x, vid 0x%x\n",
 		smp_processor_id(), fid, vid);
-	freqs.old = find_khz_freq_from_fid(data->currfid);
-	freqs.new = find_khz_freq_from_fid(fid);
 
 	policy = cpufreq_cpu_get(smp_processor_id());
 	cpufreq_cpu_put(policy);
 
-	cpufreq_notify_transition(policy, &freqs, CPUFREQ_PRECHANGE);
-
-	res = transition_fid_vid(data, fid, vid);
-	if (res)
-		freqs.new = freqs.old;
-	else
-		freqs.new = find_khz_freq_from_fid(data->currfid);
-
-	cpufreq_notify_transition(policy, &freqs, CPUFREQ_POSTCHANGE);
-	return res;
+	return transition_fid_vid(data, fid, vid);
 }
 
 struct powernowk8_target_arg {
-- 
1.7.12.rc2.18.g61b472e

