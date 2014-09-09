Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752783AbaIIWMm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 18:12:42 -0400
Received: from mail-pa0-f49.google.com ([209.85.220.49]:41893 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752733AbaIIWMh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 18:12:37 -0400
From: Ashwin Chaugule <ashwin.chaugule@linaro.org>
To: dirk.j.brandewie@intel.com
Cc: rjw@rjwysocki.net, linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linaro-acpi@lists.linaro.org,
        Ashwin Chaugule <ashwin.chaugule@linaro.org>
Subject: [PATCH 4/6] PID: Add new function pointers to read multiple registers
Date: Tue,  9 Sep 2014 18:12:06 -0400
Message-Id: <1410300728-26637-5-git-send-email-ashwin.chaugule@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1410300728-26637-1-git-send-email-ashwin.chaugule@linaro.org>
References: <1410300728-26637-1-git-send-email-ashwin.chaugule@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are cases where it is more efficient to read multiple
counters or registers at once. To enable such reads, add new
function pointers for the backend drivers. This is especially
useful when the registers are memory mapped (e.g. in PCC) and
the platform is signalled via a Doorbell to update multiple
registers at once. In contrast, we'd have to ring the Doorbell
for every register Read.

Signed-off-by: Ashwin Chaugule <ashwin.chaugule@linaro.org>
---
 drivers/cpufreq/intel_pid_ctrl.c | 49 ++++++++++++++++++++++++++++++++++------
 drivers/cpufreq/pid_ctrl.c       | 34 ++++++----------------------
 drivers/cpufreq/pid_ctrl.h       |  2 ++
 3 files changed, 51 insertions(+), 34 deletions(-)

diff --git a/drivers/cpufreq/intel_pid_ctrl.c b/drivers/cpufreq/intel_pid_ctrl.c
index a858981..73faaf8 100644
--- a/drivers/cpufreq/intel_pid_ctrl.c
+++ b/drivers/cpufreq/intel_pid_ctrl.c
@@ -37,6 +37,7 @@ struct vid_data {
 };
 
 static struct vid_data vid_data;
+static struct cpu_defaults *cpuinfo;
 
 struct perf_limits limits = {
 	.no_turbo = 0,
@@ -171,6 +172,37 @@ static void core_set_pstate(struct cpudata *cpudata, int pstate)
 	wrmsrl_on_cpu(cpudata->cpu, MSR_IA32_PERF_CTL, val);
 }
 
+static void intel_get_pstates(struct cpudata *cpu)
+{
+	cpu->pstate.min_pstate = cpuinfo->funcs.get_min();
+	cpu->pstate.max_pstate = cpuinfo->funcs.get_max();
+
+	if (cpuinfo->funcs.get_turbo)
+		cpu->pstate.turbo_pstate = cpuinfo->funcs.get_turbo();
+	else
+		cpu->pstate.turbo_pstate = cpu->pstate.max_pstate;
+}
+
+static void intel_get_sample(struct cpudata *cpu)
+{
+	u64 aperf, mperf;
+
+	rdmsrl(MSR_IA32_APERF, aperf);
+	rdmsrl(MSR_IA32_MPERF, mperf);
+
+	aperf = aperf >> FRAC_BITS;
+	mperf = mperf >> FRAC_BITS;
+
+	cpu->sample.aperf = aperf;
+	cpu->sample.mperf = mperf;
+
+	cpu->sample.aperf -= cpu->prev_aperf;
+	cpu->sample.mperf -= cpu->prev_mperf;
+
+	cpu->prev_aperf = aperf;
+	cpu->prev_mperf = mperf;
+}
+
 static struct cpu_defaults core_params = {
 	.pid_policy = {
 		.sample_rate_ms = 10,
@@ -181,9 +213,11 @@ static struct cpu_defaults core_params = {
 		.i_gain_pct = 0,
 	},
 	.funcs = {
+		.get_turbo = core_get_turbo_pstate,
+		.get_sample = intel_get_sample,
+		.get_pstates = intel_get_pstates,
 		.get_max = core_get_max_pstate,
 		.get_min = core_get_min_pstate,
-		.get_turbo = core_get_turbo_pstate,
 		.set = core_set_pstate,
 	},
 };
@@ -198,9 +232,11 @@ static struct cpu_defaults byt_params = {
 		.i_gain_pct = 4,
 	},
 	.funcs = {
+		.get_turbo = byt_get_turbo_pstate,
+		.get_sample = intel_get_sample,
+		.get_pstates = intel_get_pstates,
 		.get_max = byt_get_max_pstate,
 		.get_min = byt_get_min_pstate,
-		.get_turbo = byt_get_turbo_pstate,
 		.set = byt_set_pstate,
 	},
 };
@@ -327,7 +363,6 @@ static inline bool intel_pid_ctrl_platform_pwr_mgmt_exists(void)
 static int __init intel_pid_ctrl_init(void)
 {
 	const struct x86_cpu_id *id;
-	struct cpu_defaults *cpu_info;
 
 	if (no_load)
 		return -ENODEV;
@@ -343,15 +378,15 @@ static int __init intel_pid_ctrl_init(void)
 	if (intel_pid_ctrl_platform_pwr_mgmt_exists())
 		return -ENODEV;
 
-	cpu_info = (struct cpu_defaults *)id->driver_data;
+	cpuinfo = (struct cpu_defaults *)id->driver_data;
 
-	if (intel_pid_ctrl_msrs_not_valid(cpu_info))
+	if (intel_pid_ctrl_msrs_not_valid(cpuinfo))
 		return -ENODEV;
 
 	pr_info("Intel PID controller driver initializing.\n");
 
-	register_pid_params(&cpu_info->pid_policy);
-	register_cpu_funcs(&cpu_info->funcs);
+	register_pid_params(&cpuinfo->pid_policy);
+	register_cpu_funcs(&cpuinfo->funcs);
 
 	return 0;
 }
diff --git a/drivers/cpufreq/pid_ctrl.c b/drivers/cpufreq/pid_ctrl.c
index 8eb9739..a011f05 100644
--- a/drivers/cpufreq/pid_ctrl.c
+++ b/drivers/cpufreq/pid_ctrl.c
@@ -311,14 +311,7 @@ static inline void pid_ctrl_pstate_decrease(struct cpudata *cpu, int steps)
 
 static void pid_ctrl_get_cpu_pstates(struct cpudata *cpu)
 {
-	cpu->pstate.min_pstate = pstate_funcs.get_min();
-	cpu->pstate.max_pstate = pstate_funcs.get_max();
-
-	if (pstate_funcs.get_turbo)
-		cpu->pstate.turbo_pstate = pstate_funcs.get_turbo();
-	else
-		cpu->pstate.turbo_pstate = cpu->pstate.max_pstate;
-
+	pstate_funcs.get_pstates(cpu);
 	pid_ctrl_set_pstate(cpu, cpu->pstate.min_pstate);
 }
 
@@ -342,25 +335,12 @@ static inline void pid_ctrl_calc_busy(struct cpudata *cpu)
 
 static inline void pid_ctrl_sample(struct cpudata *cpu)
 {
-	u64 aperf, mperf;
-
-	rdmsrl(MSR_IA32_APERF, aperf);
-	rdmsrl(MSR_IA32_MPERF, mperf);
-
-	aperf = aperf >> FRAC_BITS;
-	mperf = mperf >> FRAC_BITS;
-
 	cpu->last_sample_time = cpu->sample.time;
 	cpu->sample.time = ktime_get();
-	cpu->sample.aperf = aperf;
-	cpu->sample.mperf = mperf;
-	cpu->sample.aperf -= cpu->prev_aperf;
-	cpu->sample.mperf -= cpu->prev_mperf;
 
-	pid_ctrl_calc_busy(cpu);
+	pstate_funcs.get_sample(cpu);
 
-	cpu->prev_aperf = aperf;
-	cpu->prev_mperf = mperf;
+	pid_ctrl_calc_busy(cpu);
 }
 
 static inline void pid_ctrl_set_sample_time(struct cpudata *cpu)
@@ -585,8 +565,8 @@ EXPORT_SYMBOL_GPL(register_pid_params);
 
 void register_cpu_funcs(struct pstate_funcs *funcs)
 {
-	pstate_funcs.get_max   = funcs->get_max;
-	pstate_funcs.get_min   = funcs->get_min;
+	pstate_funcs.get_pstates = funcs->get_pstates;
+	pstate_funcs.get_sample = funcs->get_sample;
 	pstate_funcs.get_turbo = funcs->get_turbo;
 	pstate_funcs.set       = funcs->set;
 }
@@ -596,8 +576,8 @@ static int __init pid_ctrl_init(void)
 {
 	int cpu, rc = 0;
 
-	if (!pstate_funcs.get_max ||
-			!pstate_funcs.get_min ||
+	if (!pstate_funcs.get_pstates ||
+			!pstate_funcs.get_sample ||
 			!pstate_funcs.set ||
 			!pid_params.sample_rate_ms) {
 		pr_err("Err registering pstate func accessors\n");
diff --git a/drivers/cpufreq/pid_ctrl.h b/drivers/cpufreq/pid_ctrl.h
index 40b352a..7f732e6 100644
--- a/drivers/cpufreq/pid_ctrl.h
+++ b/drivers/cpufreq/pid_ctrl.h
@@ -73,6 +73,8 @@ struct cpudata {
 struct pstate_funcs {
 	int (*get_max)(void);
 	int (*get_min)(void);
+	void (*get_pstates)(struct cpudata *);
+	void (*get_sample)(struct cpudata *);
 	int (*get_turbo)(void);
 	void (*set)(struct cpudata*, int pstate);
 };
-- 
1.9.1

