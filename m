Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934358Ab3IMN1C (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 09:27:02 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:40675 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757068Ab3IMN05 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 09:26:57 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 201/228] cpufreq: pmac: remove calls to cpufreq_notify_transition()
Date: Fri, 13 Sep 2013 18:32:27 +0530
Message-Id: <b71491eda5d2799d704c3d5953f857a392b8881e.1379063063.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1379063063.git.viresh.kumar@linaro.org>
References: <cover.1379063063.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1379063063.git.viresh.kumar@linaro.org>
References: <cover.1379063063.git.viresh.kumar@linaro.org>
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
index 9137fa9..476fc4a 100644
--- a/drivers/cpufreq/pmac32-cpufreq.c
+++ b/drivers/cpufreq/pmac32-cpufreq.c
@@ -331,21 +331,11 @@ static int pmu_set_cpu_speed(int low_speed)
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
@@ -361,8 +351,6 @@ static int do_set_cpu_speed(struct cpufreq_policy *policy, int speed_mode,
 		if ((prev_l3cr & L3CR_L3E) && l3cr != prev_l3cr)
 			_set_L3CR(prev_l3cr);
 	}
-	if (notify)
-		cpufreq_notify_transition(policy, &freqs, CPUFREQ_POSTCHANGE);
 	cur_freq = (speed_mode == CPUFREQ_HIGH) ? hi_freq : low_freq;
 
 	return 0;
@@ -378,7 +366,7 @@ static int pmac_cpufreq_target(	struct cpufreq_policy *policy,
 {
 	int		rc;
 
-	rc = do_set_cpu_speed(policy, index, 1);
+	rc = do_set_cpu_speed(policy, index);
 
 	ppc_proc_freq = cur_freq * 1000ul;
 	return rc;
@@ -420,7 +408,7 @@ static int pmac_cpufreq_suspend(struct cpufreq_policy *policy)
 	no_schedule = 1;
 	sleep_freq = cur_freq;
 	if (cur_freq == low_freq && !is_pmu_based)
-		do_set_cpu_speed(policy, CPUFREQ_HIGH, 0);
+		do_set_cpu_speed(policy, CPUFREQ_HIGH);
 	return 0;
 }
 
@@ -437,7 +425,7 @@ static int pmac_cpufreq_resume(struct cpufreq_policy *policy)
 	 * probably high speed due to our suspend() routine
 	 */
 	do_set_cpu_speed(policy, sleep_freq == low_freq ?
-			 CPUFREQ_LOW : CPUFREQ_HIGH, 0);
+			 CPUFREQ_LOW : CPUFREQ_HIGH);
 
 	ppc_proc_freq = cur_freq * 1000ul;
 
diff --git a/drivers/cpufreq/pmac64-cpufreq.c b/drivers/cpufreq/pmac64-cpufreq.c
index af970b7..07ef0ee 100644
--- a/drivers/cpufreq/pmac64-cpufreq.c
+++ b/drivers/cpufreq/pmac64-cpufreq.c
@@ -79,8 +79,6 @@ static void (*g5_switch_volt)(int speed_mode);
 static int (*g5_switch_freq)(int speed_mode);
 static int (*g5_query_freq)(void);
 
-static DEFINE_MUTEX(g5_switch_mutex);
-
 static unsigned long transition_latency;
 
 #ifdef CONFIG_PMAC_SMU
@@ -314,21 +312,7 @@ static int g5_pfunc_query_freq(void)
 
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

