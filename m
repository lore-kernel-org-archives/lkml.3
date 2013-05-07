Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757631Ab3EGPVp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 11:21:45 -0400
Received: from mail-pd0-f173.google.com ([209.85.192.173]:37681 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757138Ab3EGPUy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 11:20:54 -0400
From: dirk.brandewie@gmail.com
To: rjw@sisk.pl, linux-kernel@vger.kernel.org, cpufreq@vger.kernel.org
Cc: Dirk Brandewie <dirk.j.brandewie@intel.com>
Subject: [PATCH 4/6] cpufreq/intel_pstate: Remove idle mode PID
Date: Tue,  7 May 2013 08:20:28 -0700
Message-Id: <1367940030-19311-5-git-send-email-dirk.j.brandewie@gmail.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1367940030-19311-1-git-send-email-dirk.j.brandewie@gmail.com>
References: <1367940030-19311-1-git-send-email-dirk.j.brandewie@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dirk Brandewie <dirk.j.brandewie@intel.com>

Remove dead code from the driver.

Signed-off-by: Dirk Brandewie <dirk.j.brandewie@intel.com>
---
 drivers/cpufreq/intel_pstate.c |   49 ----------------------------------------
 1 files changed, 0 insertions(+), 49 deletions(-)

diff --git a/drivers/cpufreq/intel_pstate.c b/drivers/cpufreq/intel_pstate.c
index 97fbac2..fc9b187 100644
--- a/drivers/cpufreq/intel_pstate.c
+++ b/drivers/cpufreq/intel_pstate.c
@@ -81,10 +81,8 @@ struct cpudata {
 	struct pstate_adjust_policy *pstate_policy;
 	struct pstate_data pstate;
 	struct _pid pid;
-	struct _pid idle_pid;
 
 	int min_pstate_count;
-	int idle_mode;
 
 	u64	prev_aperf;
 	u64	prev_mperf;
@@ -199,19 +197,6 @@ static inline void intel_pstate_busy_pid_reset(struct cpudata *cpu)
 		0);
 }
 
-static inline void intel_pstate_idle_pid_reset(struct cpudata *cpu)
-{
-	pid_p_gain_set(&cpu->idle_pid, cpu->pstate_policy->p_gain_pct);
-	pid_d_gain_set(&cpu->idle_pid, cpu->pstate_policy->d_gain_pct);
-	pid_i_gain_set(&cpu->idle_pid, cpu->pstate_policy->i_gain_pct);
-
-	pid_reset(&cpu->idle_pid,
-		75,
-		50,
-		cpu->pstate_policy->deadband,
-		0);
-}
-
 static inline void intel_pstate_reset_all_pid(void)
 {
 	unsigned int cpu;
@@ -481,16 +466,6 @@ static inline void intel_pstate_set_sample_time(struct cpudata *cpu)
 	mod_timer_pinned(&cpu->timer, jiffies + delay);
 }
 
-static inline void intel_pstate_idle_mode(struct cpudata *cpu)
-{
-	cpu->idle_mode = 1;
-}
-
-static inline void intel_pstate_normal_mode(struct cpudata *cpu)
-{
-	cpu->idle_mode = 0;
-}
-
 static inline int intel_pstate_get_scaled_busy(struct cpudata *cpu)
 {
 	int32_t busy_scaled;
@@ -523,29 +498,6 @@ static inline void intel_pstate_adjust_busy_pstate(struct cpudata *cpu)
 		intel_pstate_pstate_decrease(cpu, steps);
 }
 
-static inline void intel_pstate_adjust_idle_pstate(struct cpudata *cpu)
-{
-	int busy_scaled;
-	struct _pid *pid;
-	int ctl = 0;
-	int steps;
-
-	pid = &cpu->idle_pid;
-
-	busy_scaled = intel_pstate_get_scaled_busy(cpu);
-
-	ctl = pid_calc(pid, 100 - busy_scaled);
-
-	steps = abs(ctl);
-	if (ctl < 0)
-		intel_pstate_pstate_decrease(cpu, steps);
-	else
-		intel_pstate_pstate_increase(cpu, steps);
-
-	if (cpu->pstate.current_pstate == cpu->pstate.min_pstate)
-		intel_pstate_normal_mode(cpu);
-}
-
 static void intel_pstate_timer_func(unsigned long __data)
 {
 	struct cpudata *cpu = (struct cpudata *) __data;
@@ -602,7 +554,6 @@ static int intel_pstate_init_cpu(unsigned int cpunum)
 		(unsigned long)cpu;
 	cpu->timer.expires = jiffies + HZ/100;
 	intel_pstate_busy_pid_reset(cpu);
-	intel_pstate_idle_pid_reset(cpu);
 	intel_pstate_sample(cpu);
 	intel_pstate_set_pstate(cpu, cpu->pstate.max_pstate);
 
-- 
1.7.7.6

