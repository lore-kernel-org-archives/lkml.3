Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755682Ab3BFRDS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 12:03:18 -0500
Received: from mail-pa0-f44.google.com ([209.85.220.44]:39000 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756227Ab3BFRCq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 12:02:46 -0500
From: dirk.brandewie@gmail.com
To: linux-kernel@vger.kernel.org, cpufreq@vger.kernel.org
Cc: Dirk Brandewie <dirk.brandewie@gmail.com>
Subject: [PATCH 5/5] cpufreq/x86: Add P-state driver for sandy bridge.
Date: Wed,  6 Feb 2013 09:02:13 -0800
Message-Id: <1360170133-5066-7-git-send-email-dirk.brandewie@gmail.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1360170133-5066-1-git-send-email-dirk.brandewie@gmail.com>
References: <1360170133-5066-1-git-send-email-dirk.brandewie@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dirk Brandewie <dirk.brandewie@gmail.com>

Add a P-state driver for the Intel Sandy bridge processor. In cpufreq
terminology this driver implements a  scaling driver with an internal
governor.

When built into the the kernel this driver will be the preferred
scaling driver for Sandy bridge processors.

In addition to the interfaces provided by the cpufreq subsystem for
controlling scaling drivers. The user may control the behavior of the
driver via three sysfs files located in
"/sys/devices/system/cpu/intel_pstate".

  max_perf_pct: limits the maximum P state that will be requested by
  the driver stated as a percentage of the avail performance.

  min_perf_pct: limits the minimum P state that will be  requested by
  the driver stated as a percentage of the avail performance.

  no_turbo: limits the driver to selecting P states below the turbo
  frequency range.

Signed-off-by: Dirk Brandewie <dirk.j.brandewie@intel.com>
---
 drivers/cpufreq/Kconfig.x86    |   18 +
 drivers/cpufreq/Makefile       |    1 +
 drivers/cpufreq/intel_pstate.c |  829 ++++++++++++++++++++++++++++++++++++++++
 3 files changed, 848 insertions(+), 0 deletions(-)
 create mode 100644 drivers/cpufreq/intel_pstate.c

diff --git a/drivers/cpufreq/Kconfig.x86 b/drivers/cpufreq/Kconfig.x86
index 7227cd7..6aa7053 100644
--- a/drivers/cpufreq/Kconfig.x86
+++ b/drivers/cpufreq/Kconfig.x86
@@ -2,6 +2,24 @@
 # x86 CPU Frequency scaling drivers
 #
 
+config X86_INTEL_PSTATE
+       tristate "Intel P state control"
+       depends on X86
+       help
+          This driver provides a P state for Intel core processors.
+	  The driver implements an internal governor and will become
+          the scaling driver and governor for Sandy bridge processors.
+
+	  When this driver is enabled it will become the perferred
+          scaling driver for Sandy bridge processors.
+
+	  Note: This driver should be built with the same settings as
+	  the other scaling drivers configured into the system
+	  (module/built-in) in order for the driver to register itself
+	  as the scaling driver on the system.
+
+	  If in doubt, say N.
+
 config X86_PCC_CPUFREQ
 	tristate "Processor Clocking Control interface driver"
 	depends on ACPI && ACPI_PROCESSOR
diff --git a/drivers/cpufreq/Makefile b/drivers/cpufreq/Makefile
index 93610b2..cd3d4ff 100644
--- a/drivers/cpufreq/Makefile
+++ b/drivers/cpufreq/Makefile
@@ -40,6 +40,7 @@ obj-$(CONFIG_X86_SPEEDSTEP_SMI)		+= speedstep-smi.o
 obj-$(CONFIG_X86_SPEEDSTEP_CENTRINO)	+= speedstep-centrino.o
 obj-$(CONFIG_X86_P4_CLOCKMOD)		+= p4-clockmod.o
 obj-$(CONFIG_X86_CPUFREQ_NFORCE2)	+= cpufreq-nforce2.o
+obj-$(CONFIG_X86_INTEL_PSTATE)		+= intel_pstate.o
 
 ##################################################################################
 # ARM SoC drivers
diff --git a/drivers/cpufreq/intel_pstate.c b/drivers/cpufreq/intel_pstate.c
new file mode 100644
index 0000000..21cee6a
--- /dev/null
+++ b/drivers/cpufreq/intel_pstate.c
@@ -0,0 +1,829 @@
+/*
+ * cpufreq_snb.c: Native P state management for Intel processors
+ *
+ * (C) Copyright 2012 Intel Corporation
+ * Author: Dirk Brandewie <dirk.j.brandewie@intel.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; version 2
+ * of the License.
+ */
+
+#include <linux/kernel.h>
+#include <linux/kernel_stat.h>
+#include <linux/module.h>
+#include <linux/ktime.h>
+#include <linux/hrtimer.h>
+#include <linux/tick.h>
+#include <linux/slab.h>
+#include <linux/sched.h>
+#include <linux/list.h>
+#include <linux/cpu.h>
+#include <linux/cpufreq.h>
+#include <linux/sysfs.h>
+#include <linux/types.h>
+#include <linux/fs.h>
+#include <linux/debugfs.h>
+#include <trace/events/power.h>
+
+#include <asm/div64.h>
+#include <asm/msr.h>
+#include <asm/cpu_device_id.h>
+
+#define SAMPLE_COUNT		3
+
+#define FRAC_BITS 8
+#define int_tofp(X) ((int64_t)(X) << FRAC_BITS)
+#define fp_toint(X) ((X) >> FRAC_BITS)
+
+static inline int32_t mul_fp(int32_t x, int32_t y)
+{
+	return ((int64_t)x * (int64_t)y) >> FRAC_BITS;
+}
+
+static inline int32_t div_fp(int32_t x, int32_t y)
+{
+	return div_s64((int64_t)x << FRAC_BITS, (int64_t)y);
+}
+
+struct sample {
+	ktime_t start_time;
+	ktime_t end_time;
+	int core_pct_busy;
+	int pstate_pct_busy;
+	u64 duration_us;
+	u64 idletime_us;
+	u64 aperf;
+	u64 mperf;
+	int freq;
+};
+
+struct pstate_data {
+	int	current_pstate;
+	int	min_pstate;
+	int	max_pstate;
+	int	turbo_pstate;
+};
+
+struct _pid {
+	int setpoint;
+	int32_t integral;
+	int32_t p_gain;
+	int32_t i_gain;
+	int32_t d_gain;
+	int deadband;
+	int last_err;
+};
+
+struct cpudata {
+	int cpu;
+
+	char name[64];
+
+	struct timer_list timer;
+
+	struct pstate_adjust_policy *pstate_policy;
+	struct pstate_data pstate;
+	struct _pid pid;
+	struct _pid idle_pid;
+
+	int min_pstate_count;
+	int idle_mode;
+
+	ktime_t prev_sample;
+	u64	prev_idle_time_us;
+	u64	prev_aperf;
+	u64	prev_mperf;
+	int	sample_ptr;
+	struct sample samples[SAMPLE_COUNT];
+};
+
+struct cpudata **all_cpu_data;
+struct pstate_adjust_policy {
+	int sample_rate_ms;
+	int deadband;
+	int setpoint;
+	int p_gain_pct;
+	int d_gain_pct;
+	int i_gain_pct;
+};
+
+static struct pstate_adjust_policy default_policy = {
+	.sample_rate_ms = 10,
+	.deadband = 0,
+	.setpoint = 109,
+	.p_gain_pct = 17,
+	.d_gain_pct = 0,
+	.i_gain_pct = 4,
+};
+
+struct perf_limits {
+	int no_turbo;
+	int max_perf_pct;
+	int min_perf_pct;
+	int32_t max_perf;
+	int32_t min_perf;
+};
+
+static struct perf_limits limits = {
+	.no_turbo = 0,
+	.max_perf_pct = 100,
+	.max_perf = int_tofp(1),
+	.min_perf_pct = 0,
+	.min_perf = 0,
+};
+
+static inline void pid_reset(struct _pid *pid, int setpoint, int busy,
+			int deadband, int integral) {
+	pid->setpoint = setpoint;
+	pid->deadband  = deadband;
+	pid->integral  = int_tofp(integral);
+	pid->last_err  = setpoint - busy;
+}
+
+static inline void pid_p_gain_set(struct _pid *pid, int percent)
+{
+	pid->p_gain = div_fp(int_tofp(percent), int_tofp(100));
+}
+
+static inline void pid_i_gain_set(struct _pid *pid, int percent)
+{
+	pid->i_gain = div_fp(int_tofp(percent), int_tofp(100));
+}
+
+static inline void pid_d_gain_set(struct _pid *pid, int percent)
+{
+
+	pid->d_gain = div_fp(int_tofp(percent), int_tofp(100));
+}
+
+static  signed int pid_calc(struct _pid *pid, int busy)
+{
+	signed int err, result;
+	int32_t pterm, dterm, fp_error;
+	int32_t integral_limit;
+
+
+	err = pid->setpoint - busy;
+	fp_error = int_tofp(err);
+
+	if (abs(err) <= pid->deadband)
+		return 0;
+
+	pterm = mul_fp(pid->p_gain, fp_error);
+
+	pid->integral += fp_error;
+
+	/* limit the integral term */
+	integral_limit = int_tofp(30);
+	if (pid->integral > integral_limit)
+		pid->integral = integral_limit;
+	if (pid->integral < -integral_limit)
+		pid->integral = -integral_limit;
+
+	dterm = mul_fp(pid->d_gain, (err - pid->last_err));
+	pid->last_err = err;
+
+	result = pterm + mul_fp(pid->integral, pid->i_gain) + dterm;
+
+	return (signed int)fp_toint(result);
+}
+
+
+static inline void intel_pstate_busy_pid_reset(struct cpudata *cpu)
+{
+	pid_p_gain_set(&cpu->pid, cpu->pstate_policy->p_gain_pct);
+	pid_d_gain_set(&cpu->pid, cpu->pstate_policy->d_gain_pct);
+	pid_i_gain_set(&cpu->pid, cpu->pstate_policy->i_gain_pct);
+
+	pid_reset(&cpu->pid,
+		cpu->pstate_policy->setpoint,
+		100,
+		cpu->pstate_policy->deadband,
+		0);
+
+}
+
+static inline void intel_pstate_idle_pid_reset(struct cpudata *cpu)
+{
+	pid_p_gain_set(&cpu->idle_pid, cpu->pstate_policy->p_gain_pct);
+	pid_d_gain_set(&cpu->idle_pid, cpu->pstate_policy->d_gain_pct);
+	pid_i_gain_set(&cpu->idle_pid, cpu->pstate_policy->i_gain_pct);
+
+	pid_reset(&cpu->idle_pid,
+		75,
+		50,
+		cpu->pstate_policy->deadband,
+		0);
+}
+
+static inline void intel_pstate_reset_all_pid(void)
+{
+	unsigned int cpu;
+	for_each_online_cpu(cpu) {
+		if (all_cpu_data[cpu])
+			intel_pstate_busy_pid_reset(all_cpu_data[cpu]);
+	}
+}
+
+/************************** debugfs begin ************************/
+static int pid_param_set(void *data, u64 val)
+{
+	*(u32 *)data = val;
+	intel_pstate_reset_all_pid();
+	return 0;
+}
+static int pid_param_get(void *data, u64 *val)
+{
+	*val = *(u32 *)data;
+	return 0;
+}
+DEFINE_SIMPLE_ATTRIBUTE(fops_pid_param, pid_param_get,
+			pid_param_set, "%llu\n");
+
+struct pid_param {
+	char *name;
+	void *value;
+};
+
+static struct pid_param pid_files[] = {
+	{"sample_rate_ms", &default_policy.sample_rate_ms},
+	{"d_gain_pct", &default_policy.d_gain_pct},
+	{"i_gain_pct", &default_policy.i_gain_pct},
+	{"deadband", &default_policy.deadband},
+	{"setpoint", &default_policy.setpoint},
+	{"p_gain_pct", &default_policy.p_gain_pct},
+	{NULL, NULL}
+};
+
+struct dentry *debugfs_parent;
+void intel_pstate_debug_expose_params(void)
+{
+	int i = 0;
+
+	debugfs_parent = debugfs_create_dir("pstate_snb", NULL);
+	if (IS_ERR_OR_NULL(debugfs_parent))
+		return;
+	while (pid_files[i].name) {
+		debugfs_create_file(pid_files[i].name, 0660,
+				debugfs_parent, pid_files[i].value,
+				&fops_pid_param);
+		i++;
+	}
+
+}
+
+/************************** debugfs end ************************/
+
+/************************** sysfs begin ************************/
+#define show_one(file_name, object)					\
+	static ssize_t show_##file_name					\
+	(struct kobject *kobj, struct attribute *attr, char *buf)	\
+	{								\
+		return sprintf(buf, "%u\n", limits.object);	\
+	}
+
+static ssize_t store_no_turbo(struct kobject *a, struct attribute *b,
+				const char *buf, size_t count)
+{
+	unsigned int input;
+	int ret;
+	ret = sscanf(buf, "%u", &input);
+	if (ret != 1)
+		return -EINVAL;
+	limits.no_turbo =  clamp_t(int, input, 0 , 1);
+
+	return count;
+}
+
+static ssize_t store_max_perf_pct(struct kobject *a, struct attribute *b,
+				const char *buf, size_t count)
+{
+	unsigned int input;
+	int ret;
+	ret = sscanf(buf, "%u", &input);
+	if (ret != 1)
+		return -EINVAL;
+
+	limits.max_perf_pct = clamp_t(int, input, 0 , 100);
+	limits.max_perf = div_fp(int_tofp(limits.max_perf_pct), int_tofp(100));
+	return count;
+}
+
+static ssize_t store_min_perf_pct(struct kobject *a, struct attribute *b,
+				const char *buf, size_t count)
+{
+	unsigned int input;
+	int ret;
+	ret = sscanf(buf, "%u", &input);
+	if (ret != 1)
+		return -EINVAL;
+	limits.min_perf_pct = clamp_t(int, input, 0 , 100);
+	limits.min_perf = div_fp(int_tofp(limits.min_perf_pct), int_tofp(100));
+
+	return count;
+}
+
+show_one(no_turbo, no_turbo);
+show_one(max_perf_pct, max_perf_pct);
+show_one(min_perf_pct, min_perf_pct);
+
+
+define_one_global_rw(no_turbo);
+define_one_global_rw(max_perf_pct);
+define_one_global_rw(min_perf_pct);
+
+
+static struct attribute *intel_pstate_attributes[] = {
+	&no_turbo.attr,
+	&max_perf_pct.attr,
+	&min_perf_pct.attr,
+	NULL
+};
+
+static struct attribute_group intel_pstate_attr_group = {
+	.attrs = intel_pstate_attributes,
+};
+static struct kobject *intel_pstate_kobject;
+
+void intel_pstate_sysfs_expose_params(void)
+{
+	int rc;
+
+	intel_pstate_kobject = kobject_create_and_add("intel_pstate",
+						&cpu_subsys.dev_root->kobj);
+	BUG_ON(!intel_pstate_kobject);
+	rc = sysfs_create_group(intel_pstate_kobject,
+				&intel_pstate_attr_group);
+	BUG_ON(rc);
+}
+
+
+/************************** sysfs end ************************/
+
+static int intel_pstate_min_pstate(void)
+{
+	u64 value;
+	rdmsrl(0xCE, value);
+	return (value >> 40) & 0xFF;
+}
+
+static int intel_pstate_max_pstate(void)
+{
+	u64 value;
+	rdmsrl(0xCE, value);
+	return (value >> 8) & 0xFF;
+}
+
+static int intel_pstate_turbo_pstate(void)
+{
+	u64 value;
+	int nont, ret;
+	rdmsrl(0x1AD, value);
+	nont = intel_pstate_max_pstate();
+	ret = ((value) & 255);
+	if (ret <= nont)
+		ret = nont;
+	return ret;
+}
+
+static void intel_pstate_get_min_max(struct cpudata *cpu, int *min, int *max)
+{
+	int max_perf = cpu->pstate.turbo_pstate;
+	int min_perf;
+	if (limits.no_turbo)
+		max_perf = cpu->pstate.max_pstate;
+
+	max_perf = fp_toint(mul_fp(int_tofp(max_perf), limits.max_perf));
+	*max = clamp_t(int, max_perf,
+			cpu->pstate.min_pstate, cpu->pstate.turbo_pstate);
+
+	min_perf = fp_toint(mul_fp(int_tofp(max_perf), limits.min_perf));
+	*min = clamp_t(int, min_perf,
+			cpu->pstate.min_pstate, max_perf);
+}
+
+
+static void intel_pstate_set_pstate(struct cpudata *cpu, int pstate)
+{
+	int max_perf, min_perf;
+
+	intel_pstate_get_min_max(cpu, &min_perf, &max_perf);
+
+	pstate = clamp_t(int, pstate, min_perf, max_perf);
+
+	if (pstate == cpu->pstate.current_pstate)
+		return;
+
+
+#ifndef MODULE
+	trace_cpu_frequency(pstate * 100000, cpu->cpu);
+#endif
+	cpu->pstate.current_pstate = pstate;
+	wrmsrl(MSR_IA32_PERF_CTL, pstate << 8);
+
+}
+
+static inline void intel_pstate_pstate_increase(struct cpudata *cpu, int steps)
+{
+	int target;
+	target = cpu->pstate.current_pstate + steps;
+
+	intel_pstate_set_pstate(cpu, target);
+}
+
+static inline void intel_pstate_pstate_decrease(struct cpudata *cpu, int steps)
+{
+	int target;
+	target = cpu->pstate.current_pstate - steps;
+	intel_pstate_set_pstate(cpu, target);
+}
+
+static void intel_pstate_get_cpu_pstates(struct cpudata *cpu)
+{
+	sprintf(cpu->name, "Intel 2nd generation core");
+
+	cpu->pstate.min_pstate = intel_pstate_min_pstate();
+	cpu->pstate.max_pstate = intel_pstate_max_pstate();
+	cpu->pstate.turbo_pstate = intel_pstate_turbo_pstate();
+
+	/* goto max pstate so we don't slow up boot if we are built-in
+	   if we are a module we will take care of it during normal
+	   operation
+	*/
+	intel_pstate_set_pstate(cpu, cpu->pstate.max_pstate);
+}
+
+
+static inline void intel_pstate_calc_busy(struct cpudata *cpu,
+					struct sample *sample)
+{
+	u64 core_pct;
+	sample->pstate_pct_busy = 100 - div64_u64(
+					sample->idletime_us * 100,
+					sample->duration_us);
+	core_pct = div64_u64(sample->aperf * 100, sample->mperf);
+	sample->freq = cpu->pstate.turbo_pstate * core_pct * 1000;
+
+	sample->core_pct_busy = sample->pstate_pct_busy * core_pct / 100;
+}
+
+static inline int intel_pstate_sample(struct cpudata *cpu)
+{
+	ktime_t now;
+	u64 idle_time_us;
+	u64 aperf, mperf;
+
+	now = ktime_get();
+	idle_time_us = get_cpu_idle_time_us(cpu->cpu, NULL);
+
+	rdmsrl(MSR_IA32_APERF, aperf);
+	rdmsrl(MSR_IA32_MPERF, mperf);
+	/* for the first sample, don't actually record a sample, just
+	 * set the baseline */
+	if (cpu->prev_idle_time_us > 0) {
+		cpu->sample_ptr = (cpu->sample_ptr + 1) % SAMPLE_COUNT;
+		cpu->samples[cpu->sample_ptr].start_time = cpu->prev_sample;
+		cpu->samples[cpu->sample_ptr].end_time = now;
+		cpu->samples[cpu->sample_ptr].duration_us =
+			ktime_us_delta(now, cpu->prev_sample);
+		cpu->samples[cpu->sample_ptr].idletime_us =
+			idle_time_us - cpu->prev_idle_time_us;
+
+		cpu->samples[cpu->sample_ptr].aperf = aperf;
+		cpu->samples[cpu->sample_ptr].mperf = mperf;
+		cpu->samples[cpu->sample_ptr].aperf -= cpu->prev_aperf;
+		cpu->samples[cpu->sample_ptr].mperf -= cpu->prev_mperf;
+
+		intel_pstate_calc_busy(cpu, &cpu->samples[cpu->sample_ptr]);
+	}
+
+	cpu->prev_sample = now;
+	cpu->prev_idle_time_us = idle_time_us;
+	cpu->prev_aperf = aperf;
+	cpu->prev_mperf = mperf;
+	return cpu->sample_ptr;
+}
+
+static inline void intel_pstate_set_sample_time(struct cpudata *cpu)
+{
+	int sample_time;
+	int delay;
+
+	sample_time = cpu->pstate_policy->sample_rate_ms;
+	delay = msecs_to_jiffies(sample_time);
+	delay -= jiffies % delay;
+	mod_timer_pinned(&cpu->timer, jiffies + delay);
+}
+
+static inline void intel_pstate_idle_mode(struct cpudata *cpu)
+{
+	cpu->idle_mode = 1;
+}
+
+static inline void intel_pstate_normal_mode(struct cpudata *cpu)
+{
+	cpu->idle_mode = 0;
+}
+
+static inline int intel_pstate_get_scaled_busy(struct cpudata *cpu)
+{
+	int32_t busy_scaled;
+	int32_t core_busy, turbo_pstate, current_pstate;
+
+	core_busy    = int_tofp(cpu->samples[cpu->sample_ptr].core_pct_busy);
+	turbo_pstate   = int_tofp(cpu->pstate.turbo_pstate);
+	current_pstate = int_tofp(cpu->pstate.current_pstate);
+	busy_scaled = mul_fp(core_busy, div_fp(turbo_pstate, current_pstate));
+
+
+	return fp_toint(busy_scaled);
+}
+
+static inline void intel_pstate_adjust_busy_pstate(struct cpudata *cpu)
+{
+	int busy_scaled;
+	struct _pid *pid;
+	signed int ctl = 0;
+	int steps;
+
+	pid = &cpu->pid;
+	busy_scaled =  intel_pstate_get_scaled_busy(cpu);
+
+	ctl = pid_calc(pid, busy_scaled);
+
+	steps = abs(ctl);
+	if (ctl < 0)
+		intel_pstate_pstate_increase(cpu, steps);
+	else
+		intel_pstate_pstate_decrease(cpu, steps);
+}
+
+static inline void intel_pstate_adjust_idle_pstate(struct cpudata *cpu)
+{
+	int busy_scaled;
+	struct _pid *pid;
+	int ctl = 0;
+	int steps;
+
+	pid = &cpu->idle_pid;
+
+	busy_scaled =  intel_pstate_get_scaled_busy(cpu);
+
+	ctl = pid_calc(pid, 100 - busy_scaled);
+
+	steps = abs(ctl);
+	if (ctl < 0)
+		intel_pstate_pstate_decrease(cpu, steps);
+	else
+		intel_pstate_pstate_increase(cpu, steps);
+
+	if (cpu->pstate.current_pstate == cpu->pstate.min_pstate)
+		intel_pstate_normal_mode(cpu);
+}
+
+static void intel_pstate_timer_func(unsigned long __data)
+{
+	struct cpudata *cpu = (struct cpudata *) __data;
+	int idx;
+
+
+	idx = intel_pstate_sample(cpu);
+
+
+	if (!cpu->idle_mode)
+		intel_pstate_adjust_busy_pstate(cpu);
+	else
+		intel_pstate_adjust_idle_pstate(cpu);
+
+#if defined(XPERF_FIX)
+	if (cpu->pstate.current_pstate == cpu->pstate.min_pstate) {
+		cpu->min_pstate_count++;
+		if (!(cpu->min_pstate_count % 5)) {
+			intel_pstate_set_pstate(cpu, cpu->pstate.max_pstate);
+			intel_pstate_idle_mode(cpu);
+		}
+	} else
+		cpu->min_pstate_count = 0;
+#endif
+	intel_pstate_set_sample_time(cpu);
+}
+
+#define ICPU(model, policy) \
+	{ X86_VENDOR_INTEL, 6, model, X86_FEATURE_ANY, (unsigned long)&policy }
+
+static const struct x86_cpu_id intel_pstate_cpu_ids[] = {
+	ICPU(0x2a, default_policy),
+	ICPU(0x2d, default_policy),
+	{}
+};
+MODULE_DEVICE_TABLE(x86cpu, intel_pstate_cpu_ids);
+
+static int intel_pstate_init_cpu(unsigned int cpunum)
+{
+
+	const struct x86_cpu_id *id;
+	struct cpudata *cpu;
+
+	id = x86_match_cpu(intel_pstate_cpu_ids);
+	if (!id)
+		return -ENODEV;
+
+	all_cpu_data[cpunum] = kzalloc(sizeof(struct cpudata), GFP_KERNEL);
+	if (!all_cpu_data[cpunum])
+		return -ENOMEM;
+
+	cpu = all_cpu_data[cpunum];
+
+	intel_pstate_get_cpu_pstates(cpu);
+
+	cpu->cpu = cpunum;
+	cpu->pstate_policy =
+		(struct pstate_adjust_policy *)id->driver_data;
+	init_timer_deferrable(&cpu->timer);
+	cpu->timer.function = intel_pstate_timer_func;
+	cpu->timer.data =
+		(unsigned long)cpu;
+	cpu->timer.expires = jiffies + HZ/100;
+	intel_pstate_busy_pid_reset(cpu);
+	intel_pstate_idle_pid_reset(cpu);
+	intel_pstate_sample(cpu);
+	intel_pstate_set_pstate(cpu, cpu->pstate.max_pstate);
+
+	add_timer_on(&cpu->timer, cpunum);
+
+	pr_info("Intel pstate controlling:  cpu %d\n", cpunum);
+
+	return 0;
+}
+
+unsigned int intel_pstate_get(unsigned int cpu_num)
+{
+	struct sample *sample;
+	struct cpudata *cpu;
+
+	cpu = all_cpu_data[cpu_num];
+	if (!cpu)
+		return 0;
+	sample = &cpu->samples[cpu->sample_ptr];
+	return sample->freq;
+}
+
+static int intel_pstate_set_policy(struct cpufreq_policy *policy)
+{
+	struct cpudata *cpu;
+	int min, max;
+
+	cpu = all_cpu_data[policy->cpu];
+
+	intel_pstate_get_min_max(cpu, &min, &max);
+
+	limits.min_perf_pct = (policy->min * 100) / policy->cpuinfo.max_freq;
+	limits.min_perf_pct = clamp_t(int, limits.min_perf_pct, 0 , 100);
+	limits.min_perf = div_fp(int_tofp(limits.min_perf_pct), int_tofp(100));
+
+
+	limits.max_perf_pct = policy->max * 100 / policy->cpuinfo.max_freq;
+	limits.max_perf_pct = clamp_t(int, limits.max_perf_pct, 0 , 100);
+	limits.max_perf = div_fp(int_tofp(limits.max_perf_pct), int_tofp(100));
+
+
+
+	if (policy->policy == CPUFREQ_POLICY_PERFORMANCE) {
+		limits.min_perf_pct = 100;
+		limits.min_perf = int_tofp(1);
+		limits.max_perf_pct = 100;
+		limits.max_perf = int_tofp(1);
+		limits.no_turbo = 0;
+	}
+
+	return 0;
+}
+
+static int intel_pstate_verify_policy(struct cpufreq_policy *policy)
+{
+	cpufreq_verify_within_limits(policy,
+				policy->cpuinfo.min_freq,
+				policy->cpuinfo.max_freq);
+
+	if ((policy->policy != CPUFREQ_POLICY_POWERSAVE) &&
+		(policy->policy != CPUFREQ_POLICY_PERFORMANCE))
+		return -EINVAL;
+
+	return 0;
+}
+
+static int __cpuinit intel_pstate_cpu_exit(struct cpufreq_policy *policy)
+{
+	int cpu = policy->cpu;
+
+	del_timer(&all_cpu_data[cpu]->timer);
+	kfree(all_cpu_data[cpu]);
+	all_cpu_data[cpu] = NULL;
+	return 0;
+}
+
+static int __cpuinit intel_pstate_cpu_init(struct cpufreq_policy *policy)
+{
+	int rc, min_pstate, max_pstate;
+	struct cpudata *cpu;
+
+	rc = intel_pstate_init_cpu(policy->cpu);
+	if (rc)
+		return rc;
+
+	cpu = all_cpu_data[policy->cpu];
+
+	if (!limits.no_turbo &&
+		limits.min_perf_pct == 100 && limits.max_perf_pct == 100)
+		policy->policy = CPUFREQ_POLICY_PERFORMANCE;
+	else
+		policy->policy = CPUFREQ_POLICY_POWERSAVE;
+
+	intel_pstate_get_min_max(cpu, &min_pstate, &max_pstate);
+	policy->min = min_pstate * 100000;
+	policy->max = max_pstate * 100000;
+
+	/* cpuinfo and default policy values */
+	policy->cpuinfo.min_freq = cpu->pstate.min_pstate * 100000;
+	policy->cpuinfo.max_freq = cpu->pstate.turbo_pstate * 100000;
+	policy->cpuinfo.transition_latency = CPUFREQ_ETERNAL;
+	cpumask_set_cpu(policy->cpu, policy->cpus);
+
+	return 0;
+}
+
+static struct cpufreq_driver intel_pstate_driver = {
+	.flags		= CPUFREQ_CONST_LOOPS,
+	.verify		= intel_pstate_verify_policy,
+	.setpolicy	= intel_pstate_set_policy,
+	.get		= intel_pstate_get,
+	.init		= intel_pstate_cpu_init,
+	.exit		= intel_pstate_cpu_exit,
+	.name		= "intel_pstate",
+	.owner		= THIS_MODULE,
+};
+
+
+static void intel_pstate_exit(void)
+{
+	int cpu;
+
+
+	sysfs_remove_group(intel_pstate_kobject,
+				&intel_pstate_attr_group);
+	debugfs_remove_recursive(debugfs_parent);
+
+	cpufreq_unregister_driver(&intel_pstate_driver);
+
+	if (!all_cpu_data)
+		return;
+
+	get_online_cpus();
+	for_each_online_cpu(cpu) {
+		if (all_cpu_data[cpu]) {
+			del_timer_sync(&all_cpu_data[cpu]->timer);
+			kfree(all_cpu_data[cpu]);
+		}
+	}
+
+	put_online_cpus();
+	vfree(all_cpu_data);
+}
+
+static int __init intel_pstate_init(void)
+{
+	int rc = 0;
+
+	const struct x86_cpu_id *id;
+
+	id = x86_match_cpu(intel_pstate_cpu_ids);
+	if (!id)
+		return -ENODEV;
+
+	pr_info("Intel P-state driver initializing.\n");
+
+	all_cpu_data = vmalloc(sizeof(void *) * num_possible_cpus());
+	if (!all_cpu_data)
+		return -ENOMEM;
+	memset(all_cpu_data, 0, sizeof(void *) * num_possible_cpus());
+
+	rc = cpufreq_register_driver(&intel_pstate_driver);
+	if (rc)
+		goto out;
+
+	intel_pstate_debug_expose_params();
+	intel_pstate_sysfs_expose_params();
+	return rc;
+out:
+	intel_pstate_exit();
+	return -ENODEV;
+}
+
+MODULE_AUTHOR("Dirk Brandewie <dirk.j.brandewie@intel.com>");
+MODULE_DESCRIPTION("'intel_pstate' - P state driver Intel Core processors");
+MODULE_LICENSE("GPL");
+
+device_initcall(intel_pstate_init);
+module_exit(intel_pstate_exit);
-- 
1.7.7.6

