Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757103AbaEEX5X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 19:57:23 -0400
Received: from sema.semaphore.gr ([78.46.194.137]:48531 "EHLO
	sema.semaphore.gr" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752613AbaEEX5V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 19:57:21 -0400
Message-ID: <5368255D.3090207@semaphore.gr>
Date: Tue, 06 May 2014 02:57:17 +0300
From: Stratos Karafotis <stratosk@semaphore.gr>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Dirk Brandewie <dirk.j.brandewie@intel.com>
CC: Dirk Brandewie <dirk.brandewie@gmail.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [RFC PATCH] cpufreq: intel_pstate: Change the calculation of next
 pstate
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently the driver calculates the next pstate proportional to
core_busy factor, scaled by the ratio max_pstate / current_pstate.

Using the scaled load (core_busy) to calculate the next pstate
is not always correct, because there are cases that the load is
independent from current pstate. For example, a tight 'for' loop
through many sampling intervals will cause a load of 100% in
every pstate.

So, change the above method and calculate the next pstate with
the assumption that the next pstate should not depend on the
current pstate. The next pstate should only be proportional
to measured load. Use the linear function to calculate the load:

Next P-state = A + B * load

where A = min_state and B = (max_pstate - min_pstate) / 100
If turbo is enabled the B = (turbo_pstate - min_pstate) / 100
The load is calculated using the kernel time functions.

Also remove the unused pid_calc function and pid structure and
related helper functions. 

Tested on Intel i7-3770 CPU @ 3.40GHz.
Phoronix benchmark of Linux Kernel Compilation 3.1 test (CPU busy 86%)
shows an increase ~1.35% in performance and a decrease by ~0.22% in
energy consumption. When turbo was disabled there was an increase by
~0.94% and a decrease by ~0.37% in energy consumption.

Phoronix Apache benchmark shows more interesting results.
With a CPU busy ~32% there was an increase in performance by ~46.84%
and a decrease in energy consumption by ~4.78%
When turbo was disabled, the performance boost was ~38.56 and
the decrease in energy consumption ~7.96%

Signed-off-by: Stratos Karafotis <stratosk@semaphore.gr>
---

Detailed test results can be found in this link:
https://docs.google.com/spreadsheets/d/1xiw8FOswoNFA8seNMz0nYUdhjPPvJ8J2S54kG02dOP8/edit?usp=sharing

 drivers/cpufreq/intel_pstate.c | 208 +++++++----------------------------------
 1 file changed, 35 insertions(+), 173 deletions(-)

diff --git a/drivers/cpufreq/intel_pstate.c b/drivers/cpufreq/intel_pstate.c
index 0999673..124c675 100644
--- a/drivers/cpufreq/intel_pstate.c
+++ b/drivers/cpufreq/intel_pstate.c
@@ -32,8 +32,6 @@
 #include <asm/msr.h>
 #include <asm/cpu_device_id.h>
 
-#define SAMPLE_COUNT		3
-
 #define BYT_RATIOS		0x66a
 #define BYT_VIDS		0x66b
 #define BYT_TURBO_RATIOS	0x66c
@@ -55,10 +53,11 @@ static inline int32_t div_fp(int32_t x, int32_t y)
 }
 
 struct sample {
-	int32_t core_pct_busy;
+	unsigned int core_pct_busy;
+	unsigned int duration_us;
+	unsigned int idletime_us;
 	u64 aperf;
 	u64 mperf;
-	unsigned long long tsc;
 	int freq;
 };
 
@@ -75,16 +74,6 @@ struct vid_data {
 	int32_t ratio;
 };
 
-struct _pid {
-	int setpoint;
-	int32_t integral;
-	int32_t p_gain;
-	int32_t i_gain;
-	int32_t d_gain;
-	int deadband;
-	int32_t last_err;
-};
-
 struct cpudata {
 	int cpu;
 
@@ -94,22 +83,17 @@ struct cpudata {
 
 	struct pstate_data pstate;
 	struct vid_data vid;
-	struct _pid pid;
 
+	ktime_t prev_sample;
+	u64	prev_idle_time_us;
 	u64	prev_aperf;
 	u64	prev_mperf;
-	unsigned long long prev_tsc;
 	struct sample sample;
 };
 
 static struct cpudata **all_cpu_data;
 struct pstate_adjust_policy {
 	int sample_rate_ms;
-	int deadband;
-	int setpoint;
-	int p_gain_pct;
-	int d_gain_pct;
-	int i_gain_pct;
 };
 
 struct pstate_funcs {
@@ -148,87 +132,10 @@ static struct perf_limits limits = {
 	.max_sysfs_pct = 100,
 };
 
-static inline void pid_reset(struct _pid *pid, int setpoint, int busy,
-			int deadband, int integral) {
-	pid->setpoint = setpoint;
-	pid->deadband  = deadband;
-	pid->integral  = int_tofp(integral);
-	pid->last_err  = int_tofp(setpoint) - int_tofp(busy);
-}
-
-static inline void pid_p_gain_set(struct _pid *pid, int percent)
-{
-	pid->p_gain = div_fp(int_tofp(percent), int_tofp(100));
-}
-
-static inline void pid_i_gain_set(struct _pid *pid, int percent)
-{
-	pid->i_gain = div_fp(int_tofp(percent), int_tofp(100));
-}
-
-static inline void pid_d_gain_set(struct _pid *pid, int percent)
-{
-
-	pid->d_gain = div_fp(int_tofp(percent), int_tofp(100));
-}
-
-static signed int pid_calc(struct _pid *pid, int32_t busy)
-{
-	signed int result;
-	int32_t pterm, dterm, fp_error;
-	int32_t integral_limit;
-
-	fp_error = int_tofp(pid->setpoint) - busy;
-
-	if (abs(fp_error) <= int_tofp(pid->deadband))
-		return 0;
-
-	pterm = mul_fp(pid->p_gain, fp_error);
-
-	pid->integral += fp_error;
-
-	/* limit the integral term */
-	integral_limit = int_tofp(30);
-	if (pid->integral > integral_limit)
-		pid->integral = integral_limit;
-	if (pid->integral < -integral_limit)
-		pid->integral = -integral_limit;
-
-	dterm = mul_fp(pid->d_gain, fp_error - pid->last_err);
-	pid->last_err = fp_error;
-
-	result = pterm + mul_fp(pid->integral, pid->i_gain) + dterm;
-
-	return (signed int)fp_toint(result);
-}
-
-static inline void intel_pstate_busy_pid_reset(struct cpudata *cpu)
-{
-	pid_p_gain_set(&cpu->pid, pid_params.p_gain_pct);
-	pid_d_gain_set(&cpu->pid, pid_params.d_gain_pct);
-	pid_i_gain_set(&cpu->pid, pid_params.i_gain_pct);
-
-	pid_reset(&cpu->pid,
-		pid_params.setpoint,
-		100,
-		pid_params.deadband,
-		0);
-}
-
-static inline void intel_pstate_reset_all_pid(void)
-{
-	unsigned int cpu;
-	for_each_online_cpu(cpu) {
-		if (all_cpu_data[cpu])
-			intel_pstate_busy_pid_reset(all_cpu_data[cpu]);
-	}
-}
-
 /************************** debugfs begin ************************/
 static int pid_param_set(void *data, u64 val)
 {
 	*(u32 *)data = val;
-	intel_pstate_reset_all_pid();
 	return 0;
 }
 static int pid_param_get(void *data, u64 *val)
@@ -246,11 +153,6 @@ struct pid_param {
 
 static struct pid_param pid_files[] = {
 	{"sample_rate_ms", &pid_params.sample_rate_ms},
-	{"d_gain_pct", &pid_params.d_gain_pct},
-	{"i_gain_pct", &pid_params.i_gain_pct},
-	{"deadband", &pid_params.deadband},
-	{"setpoint", &pid_params.setpoint},
-	{"p_gain_pct", &pid_params.p_gain_pct},
 	{NULL, NULL}
 };
 
@@ -452,11 +354,6 @@ static void core_set_pstate(struct cpudata *cpudata, int pstate)
 static struct cpu_defaults core_params = {
 	.pid_policy = {
 		.sample_rate_ms = 10,
-		.deadband = 0,
-		.setpoint = 97,
-		.p_gain_pct = 20,
-		.d_gain_pct = 0,
-		.i_gain_pct = 0,
 	},
 	.funcs = {
 		.get_max = core_get_max_pstate,
@@ -469,11 +366,6 @@ static struct cpu_defaults core_params = {
 static struct cpu_defaults byt_params = {
 	.pid_policy = {
 		.sample_rate_ms = 10,
-		.deadband = 0,
-		.setpoint = 97,
-		.p_gain_pct = 14,
-		.d_gain_pct = 0,
-		.i_gain_pct = 4,
 	},
 	.funcs = {
 		.get_max = byt_get_max_pstate,
@@ -520,21 +412,6 @@ static void intel_pstate_set_pstate(struct cpudata *cpu, int pstate)
 	pstate_funcs.set(cpu, pstate);
 }
 
-static inline void intel_pstate_pstate_increase(struct cpudata *cpu, int steps)
-{
-	int target;
-	target = cpu->pstate.current_pstate + steps;
-
-	intel_pstate_set_pstate(cpu, target);
-}
-
-static inline void intel_pstate_pstate_decrease(struct cpudata *cpu, int steps)
-{
-	int target;
-	target = cpu->pstate.current_pstate - steps;
-	intel_pstate_set_pstate(cpu, target);
-}
-
 static void intel_pstate_get_cpu_pstates(struct cpudata *cpu)
 {
 	sprintf(cpu->name, "Intel 2nd generation core");
@@ -553,50 +430,55 @@ static void intel_pstate_get_cpu_pstates(struct cpudata *cpu)
 	intel_pstate_set_pstate(cpu, cpu->pstate.max_pstate);
 }
 
-static inline void intel_pstate_calc_busy(struct cpudata *cpu,
-					struct sample *sample)
+static inline void intel_pstate_calc_busy(struct cpudata *cpu)
 {
+	struct sample *sample = &cpu->sample;
 	int32_t core_pct;
-	int32_t c0_pct;
 
-	core_pct = div_fp(int_tofp((sample->aperf)),
-			int_tofp((sample->mperf)));
+	sample->core_pct_busy = 100 *
+				(sample->duration_us - sample->idletime_us) /
+				sample->duration_us;
+
+	core_pct = div_fp(int_tofp(sample->aperf), int_tofp(sample->mperf));
 	core_pct = mul_fp(core_pct, int_tofp(100));
 	FP_ROUNDUP(core_pct);
 
-	c0_pct = div_fp(int_tofp(sample->mperf), int_tofp(sample->tsc));
-
 	sample->freq = fp_toint(
 		mul_fp(int_tofp(cpu->pstate.max_pstate * 1000), core_pct));
 
-	sample->core_pct_busy = mul_fp(core_pct, c0_pct);
+	pr_debug("%s: core_pct_busy = %u", __func__, sample->core_pct_busy);
 }
 
 static inline void intel_pstate_sample(struct cpudata *cpu)
 {
+	ktime_t now;
+	u64 idle_time_us;
 	u64 aperf, mperf;
-	unsigned long long tsc;
+
+	now = ktime_get();
+	idle_time_us = get_cpu_idle_time_us(cpu->cpu, NULL);
 
 	rdmsrl(MSR_IA32_APERF, aperf);
 	rdmsrl(MSR_IA32_MPERF, mperf);
-	tsc = native_read_tsc();
 
 	aperf = aperf >> FRAC_BITS;
 	mperf = mperf >> FRAC_BITS;
-	tsc = tsc >> FRAC_BITS;
 
 	cpu->sample.aperf = aperf;
 	cpu->sample.mperf = mperf;
-	cpu->sample.tsc = tsc;
 	cpu->sample.aperf -= cpu->prev_aperf;
 	cpu->sample.mperf -= cpu->prev_mperf;
-	cpu->sample.tsc -= cpu->prev_tsc;
+	cpu->sample.duration_us = (unsigned int)ktime_us_delta(now,
+							cpu->prev_sample);
+	cpu->sample.idletime_us = (unsigned int)(idle_time_us -
+						 cpu->prev_idle_time_us);
 
-	intel_pstate_calc_busy(cpu, &cpu->sample);
+	intel_pstate_calc_busy(cpu);
 
+	cpu->prev_sample = now;
+	cpu->prev_idle_time_us = idle_time_us;
 	cpu->prev_aperf = aperf;
 	cpu->prev_mperf = mperf;
-	cpu->prev_tsc = tsc;
 }
 
 static inline void intel_pstate_set_sample_time(struct cpudata *cpu)
@@ -608,35 +490,21 @@ static inline void intel_pstate_set_sample_time(struct cpudata *cpu)
 	mod_timer_pinned(&cpu->timer, jiffies + delay);
 }
 
-static inline int32_t intel_pstate_get_scaled_busy(struct cpudata *cpu)
-{
-	int32_t core_busy, max_pstate, current_pstate;
-
-	core_busy = cpu->sample.core_pct_busy;
-	max_pstate = int_tofp(cpu->pstate.max_pstate);
-	current_pstate = int_tofp(cpu->pstate.current_pstate);
-	core_busy = mul_fp(core_busy, div_fp(max_pstate, current_pstate));
-	return FP_ROUNDUP(core_busy);
-}
-
 static inline void intel_pstate_adjust_busy_pstate(struct cpudata *cpu)
 {
-	int32_t busy_scaled;
-	struct _pid *pid;
-	signed int ctl = 0;
-	int steps;
+	int max_pstate, min_pstate, pstate;
+	unsigned int busy;
 
-	pid = &cpu->pid;
-	busy_scaled = intel_pstate_get_scaled_busy(cpu);
+	busy = cpu->sample.core_pct_busy;
+	max_pstate = limits.no_turbo ? cpu->pstate.max_pstate :
+				       cpu->pstate.turbo_pstate;
+	min_pstate = cpu->pstate.min_pstate;
 
-	ctl = pid_calc(pid, busy_scaled);
+	pstate = min_pstate + (max_pstate - min_pstate) * busy / 100;
 
-	steps = abs(ctl);
+	intel_pstate_set_pstate(cpu, pstate);
 
-	if (ctl < 0)
-		intel_pstate_pstate_increase(cpu, steps);
-	else
-		intel_pstate_pstate_decrease(cpu, steps);
+	pr_debug("%s, busy = %u, pstate = %u", __func__, busy, pstate);
 }
 
 static void intel_pstate_timer_func(unsigned long __data)
@@ -651,7 +519,7 @@ static void intel_pstate_timer_func(unsigned long __data)
 	intel_pstate_adjust_busy_pstate(cpu);
 
 	trace_pstate_sample(fp_toint(sample->core_pct_busy),
-			fp_toint(intel_pstate_get_scaled_busy(cpu)),
+			0,
 			cpu->pstate.current_pstate,
 			sample->mperf,
 			sample->aperf,
@@ -708,7 +576,6 @@ static int intel_pstate_init_cpu(unsigned int cpunum)
 	cpu->timer.data =
 		(unsigned long)cpu;
 	cpu->timer.expires = jiffies + HZ/100;
-	intel_pstate_busy_pid_reset(cpu);
 	intel_pstate_sample(cpu);
 	intel_pstate_set_pstate(cpu, cpu->pstate.max_pstate);
 
@@ -852,11 +719,6 @@ static int intel_pstate_msrs_not_valid(void)
 static void copy_pid_params(struct pstate_adjust_policy *policy)
 {
 	pid_params.sample_rate_ms = policy->sample_rate_ms;
-	pid_params.p_gain_pct = policy->p_gain_pct;
-	pid_params.i_gain_pct = policy->i_gain_pct;
-	pid_params.d_gain_pct = policy->d_gain_pct;
-	pid_params.deadband = policy->deadband;
-	pid_params.setpoint = policy->setpoint;
 }
 
 static void copy_cpu_funcs(struct pstate_funcs *funcs)
-- 
1.9.0
