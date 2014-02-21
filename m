Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756208AbaBUN6c (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 08:58:32 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:46773 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755787AbaBUMtd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 07:49:33 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Brennan Shacklett <bpshacklett@gmail.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        "Zhang, Xiong Y" <xiong.y.zhang@intel.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 017/121] intel_pstate: Improve accuracy by not truncating until final result
Date: Fri, 21 Feb 2014 12:47:21 +0000
Message-Id: <1392986945-9693-18-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1392986945-9693-1-git-send-email-luis.henriques@canonical.com>
References: <1392986945-9693-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.5 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Brennan Shacklett <brennan@genyes.org>

commit d253d2a52676cfa3d89b8f0737a08ce7db665207 upstream.

This patch addresses Bug 60727
(https://bugzilla.kernel.org/show_bug.cgi?id=60727)
which was due to the truncation of intermediate values in the
calculations, which causes the code to consistently underestimate the
current cpu frequency, specifically 100% cpu utilization was truncated
down to the setpoint of 97%. This patch fixes the problem by keeping
the results of all intermediate calculations as fixed point numbers
rather scaling them back and forth between integers and fixed point.

References: https://bugzilla.kernel.org/show_bug.cgi?id=60727
Signed-off-by: Brennan Shacklett <bpshacklett@gmail.com>
Acked-by: Dirk Brandewie <dirk.j.brandewie@intel.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Cc: Zhang, Xiong Y <xiong.y.zhang@intel.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/cpufreq/intel_pstate.c | 33 +++++++++++++++------------------
 1 file changed, 15 insertions(+), 18 deletions(-)

diff --git a/drivers/cpufreq/intel_pstate.c b/drivers/cpufreq/intel_pstate.c
index c61fd64..50392ac 100644
--- a/drivers/cpufreq/intel_pstate.c
+++ b/drivers/cpufreq/intel_pstate.c
@@ -48,7 +48,7 @@ static inline int32_t div_fp(int32_t x, int32_t y)
 }
 
 struct sample {
-	int core_pct_busy;
+	int32_t core_pct_busy;
 	u64 aperf;
 	u64 mperf;
 	int freq;
@@ -68,7 +68,7 @@ struct _pid {
 	int32_t i_gain;
 	int32_t d_gain;
 	int deadband;
-	int last_err;
+	int32_t last_err;
 };
 
 struct cpudata {
@@ -153,16 +153,15 @@ static inline void pid_d_gain_set(struct _pid *pid, int percent)
 	pid->d_gain = div_fp(int_tofp(percent), int_tofp(100));
 }
 
-static signed int pid_calc(struct _pid *pid, int busy)
+static signed int pid_calc(struct _pid *pid, int32_t busy)
 {
-	signed int err, result;
+	signed int result;
 	int32_t pterm, dterm, fp_error;
 	int32_t integral_limit;
 
-	err = pid->setpoint - busy;
-	fp_error = int_tofp(err);
+	fp_error = int_tofp(pid->setpoint) - busy;
 
-	if (abs(err) <= pid->deadband)
+	if (abs(fp_error) <= int_tofp(pid->deadband))
 		return 0;
 
 	pterm = mul_fp(pid->p_gain, fp_error);
@@ -176,8 +175,8 @@ static signed int pid_calc(struct _pid *pid, int busy)
 	if (pid->integral < -integral_limit)
 		pid->integral = -integral_limit;
 
-	dterm = mul_fp(pid->d_gain, (err - pid->last_err));
-	pid->last_err = err;
+	dterm = mul_fp(pid->d_gain, fp_error - pid->last_err);
+	pid->last_err = fp_error;
 
 	result = pterm + mul_fp(pid->integral, pid->i_gain) + dterm;
 
@@ -436,8 +435,9 @@ static inline void intel_pstate_calc_busy(struct cpudata *cpu,
 					struct sample *sample)
 {
 	u64 core_pct;
-	core_pct = div64_u64(sample->aperf * 100, sample->mperf);
-	sample->freq = cpu->pstate.max_pstate * core_pct * 1000;
+	core_pct = div64_u64(int_tofp(sample->aperf * 100),
+			     sample->mperf);
+	sample->freq = fp_toint(cpu->pstate.max_pstate * core_pct * 1000);
 
 	sample->core_pct_busy = core_pct;
 }
@@ -469,22 +469,19 @@ static inline void intel_pstate_set_sample_time(struct cpudata *cpu)
 	mod_timer_pinned(&cpu->timer, jiffies + delay);
 }
 
-static inline int intel_pstate_get_scaled_busy(struct cpudata *cpu)
+static inline int32_t intel_pstate_get_scaled_busy(struct cpudata *cpu)
 {
-	int32_t busy_scaled;
 	int32_t core_busy, max_pstate, current_pstate;
 
-	core_busy = int_tofp(cpu->samples[cpu->sample_ptr].core_pct_busy);
+	core_busy = cpu->samples[cpu->sample_ptr].core_pct_busy;
 	max_pstate = int_tofp(cpu->pstate.max_pstate);
 	current_pstate = int_tofp(cpu->pstate.current_pstate);
-	busy_scaled = mul_fp(core_busy, div_fp(max_pstate, current_pstate));
-
-	return fp_toint(busy_scaled);
+	return mul_fp(core_busy, div_fp(max_pstate, current_pstate));
 }
 
 static inline void intel_pstate_adjust_busy_pstate(struct cpudata *cpu)
 {
-	int busy_scaled;
+	int32_t busy_scaled;
 	struct _pid *pid;
 	signed int ctl = 0;
 	int steps;
-- 
1.9.0

