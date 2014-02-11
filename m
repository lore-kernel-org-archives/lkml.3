Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752266AbaBKWSD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 17:18:03 -0500
Received: from mx1.redhat.com ([209.132.183.28]:22169 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751347AbaBKWSA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 17:18:00 -0500
From: Denys Vlasenko <dvlasenk@redhat.com>
To: Dirk Brandewie <dirk.j.brandewie@intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Cc: Denys Vlasenko <dvlasenk@redhat.com>,
        Denys Vlasenko <vda.linux@googlemail.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] intel_pstate: deinline largish functions
Date: Tue, 11 Feb 2014 23:17:50 +0100
Message-Id: <1392157070-19184-1-git-send-email-dvlasenk@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No need to manually inline one-use functions, gcc does it automatically.

intel_pstate_busy_pid_reset() and intel_pstate_sample() aren't one-use
and expand into ~200 and ~400 bytes of duplicated code.

Result of this change:

   text	   data	    bss	    dec	    hex	filename
   6073	    517	    104	   6694	   1a26	intel_pstate.inline.o
   5542	    517	    104	   6163	   1813	intel_pstate.o

CC: Denys Vlasenko <vda.linux@googlemail.com>
CC: linux-kernel@vger.kernel.org
Signed-off-by: Denys Vlasenko <dvlasenk@redhat.com>
---
 drivers/cpufreq/intel_pstate.c | 16 +++++++---------
 1 file changed, 7 insertions(+), 9 deletions(-)

diff --git a/drivers/cpufreq/intel_pstate.c b/drivers/cpufreq/intel_pstate.c
index 79606f4..d058748 100644
--- a/drivers/cpufreq/intel_pstate.c
+++ b/drivers/cpufreq/intel_pstate.c
@@ -168,7 +168,6 @@ static inline void pid_i_gain_set(struct _pid *pid, int percent)
 
 static inline void pid_d_gain_set(struct _pid *pid, int percent)
 {
-
 	pid->d_gain = div_fp(int_tofp(percent), int_tofp(100));
 }
 
@@ -202,7 +201,7 @@ static signed int pid_calc(struct _pid *pid, int32_t busy)
 	return (signed int)fp_toint(result);
 }
 
-static inline void intel_pstate_busy_pid_reset(struct cpudata *cpu)
+static void intel_pstate_busy_pid_reset(struct cpudata *cpu)
 {
 	pid_p_gain_set(&cpu->pid, pid_params.p_gain_pct);
 	pid_d_gain_set(&cpu->pid, pid_params.d_gain_pct);
@@ -215,7 +214,7 @@ static inline void intel_pstate_busy_pid_reset(struct cpudata *cpu)
 		0);
 }
 
-static inline void intel_pstate_reset_all_pid(void)
+static void intel_pstate_reset_all_pid(void)
 {
 	unsigned int cpu;
 	for_each_online_cpu(cpu) {
@@ -546,7 +545,7 @@ static void intel_pstate_get_cpu_pstates(struct cpudata *cpu)
 	intel_pstate_set_pstate(cpu, cpu->pstate.max_pstate);
 }
 
-static inline void intel_pstate_calc_busy(struct cpudata *cpu,
+static void intel_pstate_calc_busy(struct cpudata *cpu,
 					struct sample *sample)
 {
 	u64 core_pct;
@@ -563,7 +562,7 @@ static inline void intel_pstate_calc_busy(struct cpudata *cpu,
 				div_fp(int_tofp(c0_pct + 1), int_tofp(100)));
 }
 
-static inline void intel_pstate_sample(struct cpudata *cpu)
+static void intel_pstate_sample(struct cpudata *cpu)
 {
 	u64 aperf, mperf;
 	unsigned long long tsc;
@@ -587,7 +586,7 @@ static inline void intel_pstate_sample(struct cpudata *cpu)
 	cpu->prev_tsc = tsc;
 }
 
-static inline void intel_pstate_set_sample_time(struct cpudata *cpu)
+static void intel_pstate_set_sample_time(struct cpudata *cpu)
 {
 	int sample_time, delay;
 
@@ -596,7 +595,7 @@ static inline void intel_pstate_set_sample_time(struct cpudata *cpu)
 	mod_timer_pinned(&cpu->timer, jiffies + delay);
 }
 
-static inline int32_t intel_pstate_get_scaled_busy(struct cpudata *cpu)
+static int32_t intel_pstate_get_scaled_busy(struct cpudata *cpu)
 {
 	int32_t core_busy, max_pstate, current_pstate;
 
@@ -606,7 +605,7 @@ static inline int32_t intel_pstate_get_scaled_busy(struct cpudata *cpu)
 	return mul_fp(core_busy, div_fp(max_pstate, current_pstate));
 }
 
-static inline void intel_pstate_adjust_busy_pstate(struct cpudata *cpu)
+static void intel_pstate_adjust_busy_pstate(struct cpudata *cpu)
 {
 	int32_t busy_scaled;
 	struct _pid *pid;
@@ -670,7 +669,6 @@ MODULE_DEVICE_TABLE(x86cpu, intel_pstate_cpu_ids);
 
 static int intel_pstate_init_cpu(unsigned int cpunum)
 {
-
 	const struct x86_cpu_id *id;
 	struct cpudata *cpu;
 
-- 
1.8.1.4

