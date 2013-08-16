Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754880Ab3HPC2r (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Aug 2013 22:28:47 -0400
Received: from mail-pb0-f45.google.com ([209.85.160.45]:46739 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755063Ab3HPC2n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Aug 2013 22:28:43 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 23/34] cpufreq: pmac: remove calls to cpufreq_notify_transition()
Date: Fri, 16 Aug 2013 07:55:20 +0530
Message-Id: <673811dacec594f14dd42197450f4a5b62e9b20c.1376619363.git.viresh.kumar@linaro.org>
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
 drivers/cpufreq/pmac32-cpufreq.c | 20 ++++----------------
 drivers/cpufreq/pmac64-cpufreq.c | 18 +-----------------
 2 files changed, 5 insertions(+), 33 deletions(-)

diff --git a/drivers/cpufreq/pmac32-cpufreq.c b/drivers/cpufreq/pmac32-cpufreq.c
index 47c227c..c8f5d2c 100644
--- a/drivers/cpufreq/pmac32-cpufreq.c
+++ b/drivers/cpufreq/pmac32-cpufreq.c
@@ -330,21 +330,11 @@ static int pmu_set_cpu_speed(int low_speed)
 	return 0;
 }
 
-static int do_set_cpu_speed(struct cpufreq_policy *policy, int speed_mode,
-		int notify)
+static int do_set_cpu_speed(struct cpufreq_policy *policy, int speed_mode)
 {
-	struct cpufreq_freqs freqs;
 	unsigned long l3cr;
 	static unsigned long prev_l3cr;
 
-	freqs.old = cur_freq;
-	freqs.new = (speed_mode == CPUFREQ_HIGH) ? hi_freq : low_freq;
-
-	if (freqs.old == freqs.new)
-		return 0;
-
-	if (notify)
-		cpufreq_notify_transition(policy, &freqs, CPUFREQ_PRECHANGE);
 	if (speed_mode == CPUFREQ_LOW &&
 	    cpu_has_feature(CPU_FTR_L3CR)) {
 		l3cr = _get_L3CR();
@@ -360,8 +350,6 @@ static int do_set_cpu_speed(struct cpufreq_policy *policy, int speed_mode,
 		if ((prev_l3cr & L3CR_L3E) && l3cr != prev_l3cr)
 			_set_L3CR(prev_l3cr);
 	}
-	if (notify)
-		cpufreq_notify_transition(policy, &freqs, CPUFREQ_POSTCHANGE);
 	cur_freq = (speed_mode == CPUFREQ_HIGH) ? hi_freq : low_freq;
 
 	return 0;
@@ -377,7 +365,7 @@ static int pmac_cpufreq_target(	struct cpufreq_policy *policy,
 {
 	int		rc;
 
-	rc = do_set_cpu_speed(policy, index, 1);
+	rc = do_set_cpu_speed(policy, index);
 
 	ppc_proc_freq = cur_freq * 1000ul;
 	return rc;
@@ -424,7 +412,7 @@ static int pmac_cpufreq_suspend(struct cpufreq_policy *policy)
 	no_schedule = 1;
 	sleep_freq = cur_freq;
 	if (cur_freq == low_freq && !is_pmu_based)
-		do_set_cpu_speed(policy, CPUFREQ_HIGH, 0);
+		do_set_cpu_speed(policy, CPUFREQ_HIGH);
 	return 0;
 }
 
@@ -441,7 +429,7 @@ static int pmac_cpufreq_resume(struct cpufreq_policy *policy)
 	 * probably high speed due to our suspend() routine
 	 */
 	do_set_cpu_speed(policy, sleep_freq == low_freq ?
-			 CPUFREQ_LOW : CPUFREQ_HIGH, 0);
+			 CPUFREQ_LOW : CPUFREQ_HIGH);
 
 	ppc_proc_freq = cur_freq * 1000ul;
 
diff --git a/drivers/cpufreq/pmac64-cpufreq.c b/drivers/cpufreq/pmac64-cpufreq.c
index 63f9642..2557f16 100644
--- a/drivers/cpufreq/pmac64-cpufreq.c
+++ b/drivers/cpufreq/pmac64-cpufreq.c
@@ -78,8 +78,6 @@ static void (*g5_switch_volt)(int speed_mode);
 static int (*g5_switch_freq)(int speed_mode);
 static int (*g5_query_freq)(void);
 
-static DEFINE_MUTEX(g5_switch_mutex);
-
 static unsigned long transition_latency;
 
 #ifdef CONFIG_PMAC_SMU
@@ -313,21 +311,7 @@ static int g5_pfunc_query_freq(void)
 
 static int g5_cpufreq_target(struct cpufreq_policy *policy, unsigned int index)
 {
-	struct cpufreq_freqs freqs;
-	int rc;
-
-	mutex_lock(&g5_switch_mutex);
-
-	freqs.old = g5_cpu_freqs[g5_pmode_cur].frequency;
-	freqs.new = g5_cpu_freqs[index].frequency;
-
-	cpufreq_notify_transition(policy, &freqs, CPUFREQ_PRECHANGE);
-	rc = g5_switch_freq(index);
-	cpufreq_notify_transition(policy, &freqs, CPUFREQ_POSTCHANGE);
-
-	mutex_unlock(&g5_switch_mutex);
-
-	return rc;
+	return g5_switch_freq(index);
 }
 
 static unsigned int g5_cpufreq_get_speed(unsigned int cpu)
-- 
1.7.12.rc2.18.g61b472e

