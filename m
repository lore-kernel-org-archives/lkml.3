Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932104AbaHNT6A (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2014 15:58:00 -0400
Received: from mail-yk0-f176.google.com ([209.85.160.176]:46268 "EHLO
	mail-yk0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754348AbaHNT55 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2014 15:57:57 -0400
From: Ashwin Chaugule <ashwin.chaugule@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: catalin.marinas@arm.com, mike.turquette@linaro.org,
        morten.rasmussen@arm.com, arjan@linux.intel.com, mingo@kernel.org,
        peterz@infradead.org, len.brown@intel.com, rjw@rjwysocki.ne,
        linaro-acpi@lists.linaro.org, arnd@arndb.de,
        linux-acpi@vger.kernel.org, cpufreq@vger.kernel.org,
        patches@linaro.org, Ashwin Chaugule <ashwin.chaugule@linaro.org>
Subject: [RFC 2/3] CPPC: Add support for Collaborative Processor Performance Control
Date: Thu, 14 Aug 2014 15:57:09 -0400
Message-Id: <1408046230-16439-3-git-send-email-ashwin.chaugule@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1408046230-16439-1-git-send-email-ashwin.chaugule@linaro.org>
References: <1408046230-16439-1-git-send-email-ashwin.chaugule@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for parsing the CPC tables as described in the
ACPI 5.1+ CPPC specification. When successfully parsed along
with low level register accessors, then enable the PID
(proportional-intergral-derivative) controller based algorithm
to manage CPU performance.

Signed-off-by: Ashwin Chaugule <ashwin.chaugule@linaro.org>
---
 drivers/acpi/pcc.c       | 109 ++++++
 drivers/cpufreq/Kconfig  |  10 +
 drivers/cpufreq/Makefile |   1 +
 drivers/cpufreq/cppc.c   | 874 +++++++++++++++++++++++++++++++++++++++++++++++
 drivers/cpufreq/cppc.h   | 181 ++++++++++
 5 files changed, 1175 insertions(+)
 create mode 100644 drivers/cpufreq/cppc.c
 create mode 100644 drivers/cpufreq/cppc.h

diff --git a/drivers/acpi/pcc.c b/drivers/acpi/pcc.c
index 105e11a..7743f12 100644
--- a/drivers/acpi/pcc.c
+++ b/drivers/acpi/pcc.c
@@ -31,6 +31,12 @@
 #define PCC_CMD_COMPLETE	0x1
 #define PCC_VERSION			"0.1"
 
+#define PCC_HACK 1
+
+#ifdef PCC_HACK
+static void *pcc_comm_addr;
+#endif
+
 struct pcc_ss_desc {
 	struct acpi_pcct_subspace *pcc_ss_ptr;
 	raw_spinlock_t lock;
@@ -51,8 +57,13 @@ int get_pcc_comm_channel(u32 ss_idx, u64 __iomem *addr, int *len)
 	struct acpi_pcct_subspace *pcct_subspace = pcc_ss_arr[ss_idx].pcc_ss_ptr;
 
 	if (pcct_subspace) {
+#ifndef PCC_HACK
 		*addr = pcct_subspace->base_address;
 		*len = pcct_subspace->length;
+#else
+		*addr = (u64 *)pcc_comm_addr;
+		*len = PAGE_SIZE;
+#endif
 	} else
 		return -EINVAL;
 
@@ -61,6 +72,7 @@ int get_pcc_comm_channel(u32 ss_idx, u64 __iomem *addr, int *len)
 	return 0;
 }
 
+#ifndef PCC_HACK
 /* Send PCC cmd on behalf of this (subspace id) PCC client */
 u16 send_pcc_cmd(u8 cmd, u8 sci, u32 ss_idx, u64 __iomem *base_addr)
 {
@@ -114,6 +126,93 @@ u16 send_pcc_cmd(u8 cmd, u8 sci, u32 ss_idx, u64 __iomem *base_addr)
 	return generic_comm_base->status;
 }
 
+#else
+
+#include <asm/msr.h>
+
+/* These offsets are from the SSDT9.asl table on the Thinkpad X240 */
+
+/* These are offsets per CPU from which its CPC table begins. */
+int cpu_base[] = {0, 0x64, 0xC8, 0x12C, 0x190, 0x1F4, 0x258, 0x2BC};
+
+/* These are offsets of the registers in each CPC table. */
+#define HIGHEST_PERF_OFFSET 0x0
+#define LOWEST_PERF_OFFSET	0xc
+#define DESIRED_PERF_OFFSET 0x14
+
+static int core_get_min(void)
+{
+	u64 val;
+	rdmsrl(MSR_PLATFORM_INFO, val);
+	return (val >> 40) & 0xff;
+}
+
+static int core_get_max(void)
+{
+	u64 val;
+	rdmsrl(MSR_PLATFORM_INFO, val);
+	return (val >> 8) & 0xff;
+}
+
+static int core_get_turbo(void)
+{
+	u64 value;
+	int nont, ret;
+
+	rdmsrl(MSR_NHM_TURBO_RATIO_LIMIT, value);
+	nont = core_get_max();
+	ret = ((value) & 255);
+	if (ret <= nont)
+		ret = nont;
+	return ret;
+}
+
+u16 send_pcc_cmd(u8 cmd, u8 sci, u32 ss_idx, u64 __iomem *base_addr)
+{
+	unsigned int cpu;
+	u64 desired_val;
+
+	raw_spin_lock(&pcc_ss_arr[ss_idx].lock);
+	/*XXX: Instead of waiting for platform to consume the cmd,
+	 * just do what the platform would've done.
+	 */
+	switch (cmd) {
+		case 0:	//PCC_CMD_READ
+
+			/* XXX: Normally the Platform would need to update all the other CPPC registers as well.
+			 * But for this experiment, since we're not really using all of them, we'll only update
+			 * what we use.
+			 */
+			for_each_possible_cpu(cpu) {
+				*(char*)(pcc_comm_addr + cpu_base[cpu] + HIGHEST_PERF_OFFSET) = core_get_turbo();
+				*(char*)(pcc_comm_addr + cpu_base[cpu] + LOWEST_PERF_OFFSET) = core_get_min();
+			}
+			break;
+		case 1:  //PCC_CMD_WRITE
+
+			/* XXX: All this hackery is very X86 Thinkpad X240 specific.
+			 * Normally, the cpc_write64() would have all the info on
+			 * how, where and what to write.
+			 */
+			for_each_possible_cpu(cpu) {
+				desired_val = *(u64*)(pcc_comm_addr + cpu_base[cpu] + DESIRED_PERF_OFFSET);
+
+				if (desired_val) {
+					wrmsrl_on_cpu(cpu, MSR_IA32_PERF_CTL, desired_val << 8);
+					*(u64*)(pcc_comm_addr + cpu_base[cpu] + DESIRED_PERF_OFFSET) = 0;
+				}
+			}
+			break;
+		default:
+			pr_err("Unknown PCC cmd from the OS\n");
+			return 0;
+	}
+
+	raw_spin_unlock(&pcc_ss_arr[ss_idx].lock);
+	return 1;
+}
+#endif
+
 static int parse_pcc_subspace(struct acpi_subtable_header *header,
 		const unsigned long end)
 {
@@ -185,6 +284,16 @@ static int __init pcc_init(void)
 		return -EINVAL;
 	}
 
+#ifdef PCC_HACK
+	pcc_comm_addr = kzalloc(PAGE_SIZE, GFP_KERNEL);
+
+	if (!pcc_comm_addr) {
+		pr_err("Could not allocate mem for pcc hack\n");
+		return -ENOMEM;
+	}
+
+#endif
+
 	return ret;
 }
 device_initcall(pcc_init);
diff --git a/drivers/cpufreq/Kconfig b/drivers/cpufreq/Kconfig
index ffe350f..d8e8335 100644
--- a/drivers/cpufreq/Kconfig
+++ b/drivers/cpufreq/Kconfig
@@ -196,6 +196,16 @@ config GENERIC_CPUFREQ_CPU0
 
 	  If in doubt, say N.
 
+config CPPC_CPUFREQ
+	bool "CPPC CPUFreq driver"
+	depends on ACPI && ACPI_PCC
+	default n
+	help
+	CPPC is Collaborative Processor Performance Control. It allows the OS
+	to request CPU performance with an abstract metric and lets the platform
+	(e.g. BMC) interpret and optimize it for power and performance in a
+	platform specific manner.
+
 menu "x86 CPU frequency scaling drivers"
 depends on X86
 source "drivers/cpufreq/Kconfig.x86"
diff --git a/drivers/cpufreq/Makefile b/drivers/cpufreq/Makefile
index db6d9a2..b392c8c 100644
--- a/drivers/cpufreq/Makefile
+++ b/drivers/cpufreq/Makefile
@@ -14,6 +14,7 @@ obj-$(CONFIG_CPU_FREQ_GOV_CONSERVATIVE)	+= cpufreq_conservative.o
 obj-$(CONFIG_CPU_FREQ_GOV_COMMON)		+= cpufreq_governor.o
 
 obj-$(CONFIG_GENERIC_CPUFREQ_CPU0)	+= cpufreq-cpu0.o
+obj-$(CONFIG_CPPC_CPUFREQ)	+= cppc.o
 
 ##################################################################################
 # x86 drivers.
diff --git a/drivers/cpufreq/cppc.c b/drivers/cpufreq/cppc.c
new file mode 100644
index 0000000..6917ce0
--- /dev/null
+++ b/drivers/cpufreq/cppc.c
@@ -0,0 +1,874 @@
+/*
+ *	Copyright (C) 2014 Linaro Ltd.
+ *	Author:	Ashwin Chaugule <ashwin.chaugule@linaro.org>
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License as published by
+ *  the Free Software Foundation; either version 2 of the License, or
+ *  (at your option) any later version.
+ *
+ *  This program is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *  GNU General Public License for more details.
+ *
+ *  PID algo bits are from intel_pstate.c and modified to use CPPC
+ *  accessors.
+ *
+ */
+
+#define pr_fmt(fmt) KBUILD_MODNAME	": " fmt
+
+#include <linux/kernel_stat.h>
+#include <linux/module.h>
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
+#include <linux/acpi.h>
+#include <linux/errno.h>
+
+#include <acpi/processor.h>
+#include <acpi/actypes.h>
+
+#include <trace/events/power.h>
+
+#include <asm/div64.h>
+#include <asm/msr.h>
+
+#include "cppc.h"
+
+#define FRAC_BITS 8
+#define int_tofp(X) ((int64_t)(X) << FRAC_BITS)
+#define fp_toint(X) ((X) >> FRAC_BITS)
+
+#define CPPC_EN					1
+#define PCC_CMD_COMPLETE		1
+
+/* There is one CPC descriptor per CPU */
+static DEFINE_PER_CPU(struct cpc_desc *, cpc_desc_ptr);
+
+/* PCC client specifics for the CPPC structure */
+/* Returned by the PCCT Subspace structure */
+static u64 pcc_comm_base_addr;
+
+/* ioremap the pcc_comm_base_addr*/
+static void __iomem *comm_base_addr;
+
+/* The PCC subspace used by the CPC table */
+static s8 pcc_subspace_idx = -1;
+
+extern int get_pcc_comm_channel(u32 ss_idx, u64* addr, int *len);
+extern u16 send_pcc_cmd(u8 cmd, u8 sci, u32 ss_idx, u64 * __iomem base_addr);
+
+/*
+ * The low level platform specific accessors 
+ * to the registers defined in the CPC table 
+ */
+struct cpc_funcs *cppc_func_ops;
+
+static struct cpudata **all_cpu_data;
+static struct pstate_adjust_policy pid_params;
+
+/* PCC Commands used by CPPC */
+enum cppc_ppc_cmds {
+	PCC_CMD_READ,
+	PCC_CMD_WRITE,
+	RESERVED,
+};
+
+static struct perf_limits limits = {
+	.max_perf_pct = 100,
+	.max_perf = int_tofp(1),
+	.min_perf_pct = 0,
+	.min_perf = 0,
+	.max_policy_pct = 100,
+	.max_sysfs_pct = 100,
+};
+
+u64 cpc_read64(struct cpc_register_resource *reg, void __iomem *base_addr)
+{
+	u64 err = 0;
+	u64 val;
+
+	switch (reg->space_id) {
+		case ACPI_ADR_SPACE_PLATFORM_COMM:
+			err = readq((void *) (reg->address + *(u64 *)base_addr));
+			break;
+		case ACPI_ADR_SPACE_FIXED_HARDWARE:
+			rdmsrl(reg->address, val);
+			return val;
+			break;
+		default:
+			pr_err("unknown space_id detected in cpc reg: %d\n", reg->space_id);
+			break;
+	}
+
+	return err;
+}
+
+int cpc_write64(u64 val, struct cpc_register_resource *reg, void __iomem *base_addr)
+{
+	unsigned int err = 0;
+
+	switch (reg->space_id) {
+		case ACPI_ADR_SPACE_PLATFORM_COMM:
+			writeq(val, (void *)(reg->address + *(u64 *)base_addr));
+			break;
+		case ACPI_ADR_SPACE_FIXED_HARDWARE:
+			wrmsrl(reg->address, val);
+			break;
+		default:
+			pr_err("unknown space_id detected in cpc reg: %d\n", reg->space_id);
+			break;
+	}
+
+	return err;
+}
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
+static inline void pid_reset(struct _pid *pid, int setpoint, int busy,
+			int deadband, int integral) {
+	pid->setpoint = setpoint;
+	pid->deadband  = deadband;
+	pid->integral  = int_tofp(integral);
+	pid->last_err  = int_tofp(setpoint) - int_tofp(busy);
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
+	pid->d_gain = div_fp(int_tofp(percent), int_tofp(100));
+}
+
+static signed int pid_calc(struct _pid *pid, int32_t busy)
+{
+	signed int result;
+	int32_t pterm, dterm, fp_error;
+	int32_t integral_limit;
+
+	fp_error = int_tofp(pid->setpoint) - busy;
+
+	if (abs(fp_error) <= int_tofp(pid->deadband))
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
+	dterm = mul_fp(pid->d_gain, fp_error - pid->last_err);
+	pid->last_err = fp_error;
+
+	result = pterm + mul_fp(pid->integral, pid->i_gain) + dterm;
+	result = result + (1 << (FRAC_BITS-1));
+	return (signed int)fp_toint(result);
+}
+
+static inline void pstate_busy_pid_reset(struct cpudata *cpu)
+{
+	pid_p_gain_set(&cpu->pid, pid_params.p_gain_pct);
+	pid_d_gain_set(&cpu->pid, pid_params.d_gain_pct);
+	pid_i_gain_set(&cpu->pid, pid_params.i_gain_pct);
+
+	pid_reset(&cpu->pid,
+		pid_params.setpoint,
+		100,
+		pid_params.deadband,
+		0);
+}
+
+static inline void pstate_reset_all_pid(void)
+{
+	unsigned int cpu;
+	for_each_online_cpu(cpu) {
+		if (all_cpu_data[cpu])
+			pstate_busy_pid_reset(all_cpu_data[cpu]);
+	}
+}
+
+/************************** debugfs begin ************************/
+static int pid_param_set(void *data, u64 val)
+{
+	*(u32 *)data = val;
+	pstate_reset_all_pid();
+	return 0;
+}
+
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
+	{"sample_rate_ms", &pid_params.sample_rate_ms},
+	{"d_gain_pct", &pid_params.d_gain_pct},
+	{"i_gain_pct", &pid_params.i_gain_pct},
+	{"deadband", &pid_params.deadband},
+	{"setpoint", &pid_params.setpoint},
+	{"p_gain_pct", &pid_params.p_gain_pct},
+	{NULL, NULL}
+};
+
+static struct dentry *debugfs_parent;
+static void cppc_pstate_debug_expose_params(void)
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
+}
+
+/************************** debugfs end ************************/
+
+/************************** sysfs begin ************************/
+#define show_one(file_name, object)					\
+	static ssize_t show_##file_name					\
+	(struct kobject *kobj, struct attribute *attr, char *buf)	\
+	{								\
+		return sprintf(buf, "%u\n", limits.object);		\
+	}
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
+	limits.max_sysfs_pct = clamp_t(int, input, 0 , 100);
+	limits.max_perf_pct = min(limits.max_policy_pct, limits.max_sysfs_pct);
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
+show_one(max_perf_pct, max_perf_pct);
+show_one(min_perf_pct, min_perf_pct);
+
+define_one_global_rw(max_perf_pct);
+define_one_global_rw(min_perf_pct);
+
+static struct attribute *cppc_pstate_attributes[] = {
+	&max_perf_pct.attr,
+	&min_perf_pct.attr,
+	NULL
+};
+
+static struct attribute_group cppc_pstate_attr_group = {
+	.attrs = cppc_pstate_attributes,
+};
+static struct kobject *cppc_pstate_kobject;
+
+static void cppc_pstate_sysfs_expose_params(void)
+{
+	int rc;
+
+	cppc_pstate_kobject = kobject_create_and_add("cppc_pstate",
+						&cpu_subsys.dev_root->kobj);
+	BUG_ON(!cppc_pstate_kobject);
+	rc = sysfs_create_group(cppc_pstate_kobject,
+				&cppc_pstate_attr_group);
+	BUG_ON(rc);
+}
+
+/************************** sysfs end ************************/
+
+static inline void pstate_calc_busy(struct cpudata *cpu)
+{
+	struct sample *sample = &cpu->sample;
+	int64_t core_pct;
+	int32_t rem;
+
+	core_pct = int_tofp(sample->delivered) * int_tofp(100);
+	core_pct = div_u64_rem(core_pct, int_tofp(sample->reference), &rem);
+
+	if ((rem << 1) >= int_tofp(sample->reference))
+		core_pct += 1;
+
+	sample->freq = fp_toint(
+		mul_fp(int_tofp(cpu->pstate.max_pstate * 1000), core_pct));
+
+	sample->core_pct_busy = (int32_t)core_pct;
+}
+
+static inline void pstate_sample(struct cpudata *cpu)
+{
+	u64 delivered, reference;
+	unsigned int status;
+	/*
+	 * If this platform has a PCCT, then 
+	 * send a command to the platform to update
+	 * all PCC registers.
+	 */
+	if (comm_base_addr) {
+		pr_debug("Sending PCC READ to update COMM space\n");
+		status = send_pcc_cmd(PCC_CMD_READ, 0, pcc_subspace_idx,
+				comm_base_addr);
+
+		if (!(status & PCC_CMD_COMPLETE)) {
+				pr_err("Err updating PCC comm space\n");
+				return;
+		}
+	}
+
+	reference = cppc_func_ops->get_ref_perf_ctr(cpu);
+	delivered = cppc_func_ops->get_delivered_ctr(cpu);
+
+	delivered = delivered >> FRAC_BITS;
+	reference = reference >> FRAC_BITS;
+
+	cpu->last_sample_time = cpu->sample.time;
+	cpu->sample.time = ktime_get();
+	cpu->sample.delivered = delivered;
+	cpu->sample.reference = reference;
+	cpu->sample.delivered -= cpu->prev_delivered;
+	cpu->sample.reference -= cpu->prev_reference;
+
+	pstate_calc_busy(cpu);
+
+	cpu->prev_delivered = delivered;
+	cpu->prev_reference = reference;
+}
+
+static inline int32_t pstate_get_scaled_busy(struct cpudata *cpu)
+{
+	int32_t core_busy, max_pstate, current_pstate, sample_ratio;
+	u32 duration_us;
+	u32 sample_time;
+
+	core_busy = cpu->sample.core_pct_busy;
+	max_pstate = int_tofp(cpu->pstate.max_pstate);
+	current_pstate = int_tofp(cpu->pstate.current_pstate);
+	core_busy = mul_fp(core_busy, div_fp(max_pstate, current_pstate));
+
+	sample_time = (pid_params.sample_rate_ms  * USEC_PER_MSEC);
+	duration_us = (u32) ktime_us_delta(cpu->sample.time,
+					cpu->last_sample_time);
+	if (duration_us > sample_time * 3) {
+		sample_ratio = div_fp(int_tofp(sample_time),
+				int_tofp(duration_us));
+		core_busy = mul_fp(core_busy, sample_ratio);
+	}
+
+	return core_busy;
+}
+
+static inline void pstate_set_sample_time(struct cpudata *cpu)
+{
+	int sample_time, delay;
+
+	sample_time = pid_params.sample_rate_ms;
+	delay = msecs_to_jiffies(sample_time);
+	mod_timer_pinned(&cpu->timer, jiffies + delay);
+}
+
+static void pstate_get_min_max(struct cpudata *cpu, int *min, int *max)
+{
+	int max_perf = cpu->pstate.max_pstate;
+	int max_perf_adj;
+	int min_perf;
+
+	max_perf_adj = fp_toint(mul_fp(int_tofp(max_perf), limits.max_perf));
+	*max = clamp_t(int, max_perf_adj,
+			cpu->pstate.min_pstate, cpu->pstate.max_pstate);
+
+	min_perf = fp_toint(mul_fp(int_tofp(max_perf), limits.min_perf));
+	*min = clamp_t(int, min_perf,
+			cpu->pstate.min_pstate, max_perf);
+}
+
+static void set_pstate(struct cpudata *cpu, int pstate)
+{
+	int max_perf, min_perf;
+	unsigned int status;
+
+	pstate_get_min_max(cpu, &min_perf, &max_perf);
+
+	pstate = clamp_t(int, pstate, min_perf, max_perf);
+
+	if (pstate == cpu->pstate.current_pstate)
+		return;
+
+	trace_cpu_frequency(pstate * 100000, cpu->cpu);
+
+	cpu->pstate.current_pstate = pstate;
+
+	cppc_func_ops->set_desired_perf(cpu, pstate);
+
+	/*
+	 * Send a Write command to tell the platform that
+	 * there is new data in the PCC registers.
+	 */
+	if (comm_base_addr) {
+		pr_debug("Sending PCC WRITE to update COMM space\n");
+		status = send_pcc_cmd(PCC_CMD_WRITE, 0, pcc_subspace_idx,
+				comm_base_addr);
+
+		if (!(status & PCC_CMD_COMPLETE)) {
+			pr_err("Err updating PCC comm space\n");
+			return;
+		}
+	}
+}
+
+static inline void pstate_pstate_increase(struct cpudata *cpu, int steps)
+{
+	int target;
+	target = cpu->pstate.current_pstate + steps;
+
+	set_pstate(cpu, target);
+}
+
+static inline void pstate_pstate_decrease(struct cpudata *cpu, int steps)
+{
+	int target;
+	target = cpu->pstate.current_pstate - steps;
+	set_pstate(cpu, target);
+}
+
+static inline void pstate_adjust_busy_pstate(struct cpudata *cpu)
+{
+	int32_t busy_scaled;
+	struct _pid *pid;
+	signed int ctl = 0;
+	int steps;
+
+	pid = &cpu->pid;
+	busy_scaled = pstate_get_scaled_busy(cpu);
+
+	ctl = pid_calc(pid, busy_scaled);
+
+	steps = abs(ctl);
+
+	if (ctl < 0)
+		pstate_pstate_increase(cpu, steps);
+	else
+		pstate_pstate_decrease(cpu, steps);
+}
+
+static void pstate_timer_func(unsigned long __data)
+{
+	struct cpudata *cpu = (struct cpudata *) __data;
+	struct sample *sample;
+
+	pstate_sample(cpu);
+
+	sample = &cpu->sample;
+
+	pstate_adjust_busy_pstate(cpu);
+
+	trace_pstate_sample(fp_toint(sample->core_pct_busy),
+			fp_toint(pstate_get_scaled_busy(cpu)),
+			cpu->pstate.current_pstate,
+			sample->reference,
+			sample->delivered,
+			sample->freq);
+
+	pstate_set_sample_time(cpu);
+}
+
+static int cppc_cpufreq_init(struct cpufreq_policy *policy)
+{
+	struct cpudata *cpu;
+	unsigned int cpunum = policy->cpu;
+	unsigned int status;
+	struct cpc_desc *current_cpu_cpc = per_cpu(cpc_desc_ptr, cpunum);
+
+	all_cpu_data[cpunum] = kzalloc(sizeof(struct cpudata), GFP_KERNEL);
+	if (!all_cpu_data[cpunum])
+		return -ENOMEM;
+
+	cpu = all_cpu_data[cpunum];
+
+	cpu->cpu = cpunum;
+
+	if (!cppc_func_ops) {
+		pr_err("CPPC is not supported on this platform\n");
+		return -ENOTSUPP;
+	}
+
+	if (!current_cpu_cpc) {
+		pr_err("Undefined CPC descriptor for CPU:%d\n", cpunum);
+		return -ENODEV;
+	}
+
+	/*
+	 * If this platform has a PCCT, then
+	 * send a command to the platform to update
+	 * all PCC registers.
+	 */
+	if (comm_base_addr) {
+		pr_debug("Sending PCC READ to update COMM space\n");
+		status = send_pcc_cmd(PCC_CMD_READ, 0, pcc_subspace_idx,
+				comm_base_addr);
+
+		if (!(status & PCC_CMD_COMPLETE)) {
+				pr_err("Err updating PCC comm space\n");
+				return -EIO;
+		}
+	}
+
+	cpu->cpc_desc = current_cpu_cpc;
+	cpu->pcc_comm_address = comm_base_addr;
+	cpu->pstate.min_pstate = cppc_func_ops->get_lowest_perf(cpu);
+	cpu->pstate.max_pstate = cppc_func_ops->get_highest_perf(cpu);
+	/* PCC reads/writes are made to offsets from this base address.*/
+
+	set_pstate(cpu, cpu->pstate.min_pstate);
+
+	init_timer_deferrable(&cpu->timer);
+	cpu->timer.function = pstate_timer_func;
+	cpu->timer.data =
+		(unsigned long)cpu;
+	cpu->timer.expires = jiffies + HZ/100;
+	pstate_busy_pid_reset(cpu);
+	pstate_sample(cpu);
+
+	add_timer_on(&cpu->timer, cpunum);
+
+	pr_info("CPPC PID pstate controlling: cpu %d\n", cpunum);
+
+	if (limits.min_perf_pct == 100 && limits.max_perf_pct == 100)
+		policy->policy = CPUFREQ_POLICY_PERFORMANCE;
+	else
+		policy->policy = CPUFREQ_POLICY_POWERSAVE;
+
+	policy->min = cpu->pstate.min_pstate * 100000;
+	policy->max = cpu->pstate.max_pstate * 100000;
+
+	/* cpuinfo and default policy values */
+	policy->cpuinfo.min_freq = cpu->pstate.min_pstate * 100000;
+	policy->cpuinfo.max_freq = cpu->pstate.max_pstate * 100000;
+	policy->cpuinfo.transition_latency = CPUFREQ_ETERNAL;
+	cpumask_set_cpu(policy->cpu, policy->cpus);
+
+	return 0;
+}
+
+static void cppc_stop_cpu(struct cpufreq_policy *policy)
+{
+	int cpu_num = policy->cpu;
+	struct cpudata *cpu = all_cpu_data[cpu_num];
+
+	pr_info("CPPC PID controller CPU %d exiting\n", cpu_num);
+
+	del_timer_sync(&all_cpu_data[cpu_num]->timer);
+	set_pstate(cpu, cpu->pstate.min_pstate);
+	kfree(all_cpu_data[cpu_num]);
+	all_cpu_data[cpu_num] = NULL;
+	kfree(cpu->cpc_desc);
+}
+
+static int cppc_verify_policy(struct cpufreq_policy *policy)
+{
+	cpufreq_verify_within_cpu_limits(policy);
+
+	if ((policy->policy != CPUFREQ_POLICY_POWERSAVE) &&
+		(policy->policy != CPUFREQ_POLICY_PERFORMANCE))
+		return -EINVAL;
+
+	return 0;
+}
+
+static int cppc_set_policy(struct cpufreq_policy *policy)
+{
+	struct cpudata *cpu;
+
+	cpu = all_cpu_data[policy->cpu];
+
+	if (!policy->cpuinfo.max_freq)
+		return -ENODEV;
+
+	if (policy->policy == CPUFREQ_POLICY_PERFORMANCE) {
+		limits.min_perf_pct = 100;
+		limits.min_perf = int_tofp(1);
+		limits.max_perf_pct = 100;
+		limits.max_perf = int_tofp(1);
+		return 0;
+	}
+	limits.min_perf_pct = (policy->min * 100) / policy->cpuinfo.max_freq;
+	limits.min_perf_pct = clamp_t(int, limits.min_perf_pct, 0 , 100);
+	limits.min_perf = div_fp(int_tofp(limits.min_perf_pct), int_tofp(100));
+
+	limits.max_policy_pct = policy->max * 100 / policy->cpuinfo.max_freq;
+	limits.max_policy_pct = clamp_t(int, limits.max_policy_pct, 0 , 100);
+	limits.max_perf_pct = min(limits.max_policy_pct, limits.max_sysfs_pct);
+	limits.max_perf = div_fp(int_tofp(limits.max_perf_pct), int_tofp(100));
+
+	return 0;
+}
+
+static unsigned int cppc_get(unsigned int cpu_num)
+{
+	struct sample *sample;
+	struct cpudata *cpu;
+
+	cpu = all_cpu_data[cpu_num];
+	if (!cpu)
+		return 0;
+	sample = &cpu->sample;
+	return sample->freq;
+}
+
+static struct cpufreq_driver cppc_cpufreq = {
+	.flags		=	CPUFREQ_CONST_LOOPS,
+	.verify		=	cppc_verify_policy,
+	.setpolicy	=	cppc_set_policy,
+	.get		=	cppc_get,
+	.init		=	cppc_cpufreq_init,
+	.stop_cpu	=	cppc_stop_cpu,
+	.name		=	"cppc_cpufreq",
+};
+
+static int cppc_processor_probe(void)
+{
+	struct acpi_buffer output = {ACPI_ALLOCATE_BUFFER, NULL};
+	union acpi_object *out_obj, *cpc_obj;
+	struct cpc_desc *current_cpu_cpc;
+	struct cpc_register_resource *gas_t;
+	char proc_name[11];
+	unsigned int num_ent, ret = 0, i, cpu, len;
+	acpi_handle handle;
+	acpi_status status;
+
+	/*Parse the ACPI _CPC table for each CPU. */
+	for_each_online_cpu(cpu) {
+		sprintf(proc_name, "\\_PR.CPU%d", cpu);
+
+		status = acpi_get_handle(NULL, proc_name, &handle);
+		if (ACPI_FAILURE(status)) {
+			ret = -ENODEV;
+			goto out_free;
+		}
+
+		if (!acpi_has_method(handle, "_CPC")) {
+			ret = -ENODEV;
+			goto out_free;
+		}
+
+		status = acpi_evaluate_object(handle, "_CPC", NULL, &output);
+		if (ACPI_FAILURE(status)) {
+			ret = -ENODEV;
+			goto out_free;
+		}
+
+		out_obj = (union acpi_object *) output.pointer;
+		if (out_obj->type != ACPI_TYPE_PACKAGE) {
+			ret = -ENODEV;
+			goto out_free;
+		}
+
+		current_cpu_cpc = kzalloc(sizeof(struct cpc_desc), GFP_KERNEL);
+		if (!current_cpu_cpc) {
+			pr_err("Could not allocate per cpu CPC descriptors\n");
+			return -ENOMEM;
+		}
+		num_ent = out_obj->package.count;
+		current_cpu_cpc->num_entries = num_ent;
+
+		pr_debug("num_ent in CPC table:%d\n", num_ent);
+
+		/* Iterate through each entry in _CPC */
+		for (i = 2; i < num_ent; i++) {
+			cpc_obj = &out_obj->package.elements[i];
+
+			if (cpc_obj->type != ACPI_TYPE_BUFFER) {
+				pr_err("Malformed PCC entry in CPC table\n");
+				ret = -EINVAL;
+				goto out_free;
+			}
+
+			gas_t = (struct cpc_register_resource *) cpc_obj->buffer.pointer;
+
+			if (gas_t->space_id == ACPI_ADR_SPACE_PLATFORM_COMM) {
+				if (pcc_subspace_idx < 0)
+					pcc_subspace_idx = gas_t->access_width;
+			}
+
+			current_cpu_cpc->cpc_regs[i-2] = (struct cpc_register_resource) {
+					.space_id		= gas_t->space_id,
+					.length			= gas_t->length,
+					.bit_width		= gas_t->bit_width,
+					.bit_offset		= gas_t->bit_offset,
+					.address		= gas_t->address,
+					.access_width 	= gas_t->access_width,
+			};
+		}
+		per_cpu(cpc_desc_ptr, cpu) = current_cpu_cpc;
+	}
+
+	pr_debug("Completed parsing , now onto PCC init\n");
+
+	if (pcc_subspace_idx >= 0) {
+		ret = get_pcc_comm_channel(pcc_subspace_idx, &pcc_comm_base_addr, &len);
+		if (ret) {
+			pr_err("No PCC Communication Channel found\n");
+			ret = -ENODEV;
+			goto out_free;
+		}
+
+		//XXX: PCC HACK: The PCC hack in drivers/acpi/pcc.c just
+		//returns a kmallocd address, so no point in ioremapping 
+		//it here. Instead we'll just use it directly.
+		//Normally, we'd ioremap the address specified in the PCCT
+		//header for this PCC subspace.
+
+		comm_base_addr = &pcc_comm_base_addr;
+
+		//	comm_base_addr = ioremap_nocache(pcc_comm_base_addr, len);
+
+		//	if (!comm_base_addr) {
+		//		pr_err("ioremapping pcc comm space failed\n");
+		//		ret = -ENOMEM;
+		//		goto out_free;
+		//	}
+		pr_debug("PCC ioremapd space:%p, PCCT addr: %lld\n", comm_base_addr, pcc_comm_base_addr);
+
+	} else {
+		pr_err("No PCC subspace detected in any CPC structure!\n");
+		ret = -EINVAL;
+		goto out_free;
+	}
+
+	/* Everything looks okay */
+	pr_info("Successfully parsed all CPC structs\n");
+	pr_debug("Enable CPPC_EN\n");
+	/*XXX: Send write cmd to enable CPPC */
+
+	kfree(output.pointer);
+	return 0;
+
+out_free:
+	for_each_online_cpu(cpu) {
+		current_cpu_cpc = per_cpu(cpc_desc_ptr, cpu);
+		if (current_cpu_cpc)
+			kfree(current_cpu_cpc);
+	}
+
+	kfree(output.pointer);
+	return -ENODEV;
+}
+
+static void copy_pid_params(struct pstate_adjust_policy *policy)
+{
+	pid_params.sample_rate_ms = policy->sample_rate_ms;
+	pid_params.p_gain_pct = policy->p_gain_pct;
+	pid_params.i_gain_pct = policy->i_gain_pct;
+	pid_params.d_gain_pct = policy->d_gain_pct;
+	pid_params.deadband = policy->deadband;
+	pid_params.setpoint = policy->setpoint;
+}
+
+static int __init cppc_init(void)
+{
+	int ret = 0;
+	unsigned int cpu;
+
+	/*
+	 * Platform specific low level accessors should be
+	 * initialized by now if CPPC is supported.
+	 */
+	if (!cppc_func_ops) {
+		pr_err("No CPPC low level accessors found\n");
+		return -ENODEV;
+	}
+
+	if(acpi_disabled || cppc_processor_probe()) {
+		pr_err("Err initializing CPC structures or ACPI is disabled\n");
+		return -ENODEV;
+	}
+
+	copy_pid_params(&cppc_func_ops->pid_policy);
+
+	pr_info("CPPC PID driver initializing.\n");
+
+	all_cpu_data = vzalloc(sizeof(void *) * num_possible_cpus());
+	if (!all_cpu_data)
+		return -ENOMEM;
+
+	/* Now register with CPUfreq */
+	ret = cpufreq_register_driver(&cppc_cpufreq);
+	if (ret)
+		goto out;
+
+	cppc_pstate_debug_expose_params();
+	cppc_pstate_sysfs_expose_params();
+
+	return ret;
+
+out:
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
+	return -ENODEV;
+}
+device_initcall(cppc_init);
diff --git a/drivers/cpufreq/cppc.h b/drivers/cpufreq/cppc.h
new file mode 100644
index 0000000..3adbd3d
--- /dev/null
+++ b/drivers/cpufreq/cppc.h
@@ -0,0 +1,181 @@
+/*
+ *	Copyright (C) 2014 Linaro Ltd.
+ *	Author:	Ashwin Chaugule <ashwin.chaugule@linaro.org>
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License as published by
+ *  the Free Software Foundation; either version 2 of the License, or
+ *  (at your option) any later version.
+ *
+ *  This program is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *  GNU General Public License for more details.
+ *
+ *  PID algo bits are from intel_pstate.c and modified to use CPPC
+ *  accessors.
+ *
+ */
+
+#ifndef _CPPC_H
+#define _CPPC_H
+
+#include <linux/kernel.h>
+#include <linux/types.h>
+#include <linux/ktime.h>
+#include <linux/hrtimer.h>
+/*
+ * The max number of Register entries
+ * in the CPC table
+ */
+#define MAX_CPC_REG_ENT 19
+
+/* These are indexes into the per-cpu cpc_regs[]. Order is important. */
+enum cppc_pcc_regs {
+	HIGHEST_PERF,			/* Highest Performance						*/
+	NOMINAL_PERF,			/* Nominal Performance						*/
+	LOW_NON_LINEAR_PERF,	/* Lowest Nonlinear Performance				*/
+	LOWEST_PERF,			/* Lowest Performance						*/
+	GUARANTEED_PERF,		/* Guaranteed Performance Register			*/
+	DESIRED_PERF,			/* Desired Performance Register				*/
+	MIN_PERF,				/* Minimum Performance Register				*/
+	MAX_PERF,				/* Maximum Performance Register				*/
+	PERF_REDUC_TOLERANCE,	/* Performance Reduction Tolerance Register	*/
+	TIME_WINDOW, 			/* Time Window Register						*/
+	CTR_WRAP_TIME, 			/* Counter Wraparound Time					*/
+	REFERENCE_CTR, 			/* Reference Counter Register				*/
+	DELIVERED_CTR, 			/* Delivered Counter Register				*/
+	PERF_LIMITED, 			/* Performance Limited Register				*/
+	ENABLE,					/* Enable Register							*/
+	AUTO_SEL_ENABLE,		/* Autonomous Selection Enable				*/
+	AUTO_ACT_WINDOW,		/* Autonomous Activity Window				*/
+	ENERGY_PERF,			/* Energy Performance Preference Register	*/
+	REFERENCE_PERF,			/* Reference Performance					*/
+};
+
+/* Each register in the CPC table has the following format */
+struct cpc_register_resource {
+	u8 descriptor;
+	u16 length;
+	u8 space_id;
+	u8 bit_width;
+	u8 bit_offset;
+	u8 access_width;
+	u64 __iomem address;
+} __attribute__ ((packed));
+
+struct cpc_desc {
+	unsigned int num_entries;
+	unsigned int version;
+	struct cpc_register_resource cpc_regs[MAX_CPC_REG_ENT];
+};
+
+struct _pid {
+	int setpoint;
+	int32_t integral;
+	int32_t p_gain;
+	int32_t i_gain;
+	int32_t d_gain;
+	int deadband;
+	int32_t last_err;
+};
+
+struct sample {
+	int32_t core_pct_busy;
+	u64 delivered;
+	u64 reference;
+	int freq;
+	ktime_t time;
+};
+
+struct pstate_data {
+	int	current_pstate;
+	int	min_pstate;
+	int	max_pstate;
+};
+
+struct cpudata {
+	int cpu;
+
+	struct timer_list timer;
+
+	struct pstate_data pstate;
+	struct _pid pid;
+
+	ktime_t last_sample_time;
+	u64	prev_delivered;
+	u64	prev_reference;
+	struct sample sample;
+	struct cpc_desc *cpc_desc;
+	void __iomem *pcc_comm_address;
+};
+
+struct perf_limits {
+	int max_perf_pct;
+	int min_perf_pct;
+	int32_t max_perf;
+	int32_t min_perf;
+	int max_policy_pct;
+	int max_sysfs_pct;
+};
+
+struct pstate_adjust_policy {
+	int sample_rate_ms;
+	int deadband;
+	int setpoint;
+	int p_gain_pct;
+	int d_gain_pct;
+	int i_gain_pct;
+};
+
+struct cpc_funcs {
+	struct pstate_adjust_policy pid_policy;
+
+	u32 (*get_highest_perf)(struct cpudata *);
+	u32 (*get_nominal_perf)(struct cpudata *);
+	u64 (*get_ref_perf_ctr)(struct cpudata *);
+	u32 (*get_lowest_nonlinear_perf)(struct cpudata *);
+	u32 (*get_lowest_perf)(struct cpudata *);
+	u32 (*get_guaranteed_perf)(struct cpudata *);
+
+	u32 (*get_desired_perf)(struct cpudata *);
+	void (*set_desired_perf)(struct cpudata *, u32 val);
+
+	u64 (*get_delivered_ctr)(struct cpudata *);
+
+	/* Optional */
+	u32 (*get_max_perf)(struct cpudata *);
+	void (*set_max_perf)(struct cpudata *, u32 val);
+
+	u32 (*get_min_perf)(struct cpudata *);
+	void (*set_min_perf)(struct cpudata *, u32 val);
+
+	u32 (*get_perf_reduc)(struct cpudata *);
+	void (*set_perf_reduc)(struct cpudata *, u32 val);
+
+	u32 (*get_time_window)(struct cpudata *);
+	void (*set_time_window)(struct cpudata *, u32 msecs);
+
+	u64 (*get_ctr_wraparound)(struct cpudata *);
+	void (*set_ctr_wraparound)(struct cpudata *, u32 secs);
+
+	u8 (*get_perf_limit)(struct cpudata *);
+	void (*set_perf_limit)(struct cpudata *);
+
+	void (*set_cppc_enable)(struct cpudata *);
+
+	u8 (*get_auto_sel_en)(struct cpudata *);
+	void (*set_auto_sel_en)(struct cpudata *);
+
+	void (*set_auto_activity)(struct cpudata *, u32 val);
+
+	void (*set_energy_pref)(struct cpudata *, u32 val);
+
+	u32 (*get_ref_perf_rate)(struct cpudata *);
+};
+
+extern struct cpc_funcs *cppc_func_ops;
+extern u64 cpc_read64(struct cpc_register_resource *reg);
+extern int cpc_write64(u64 val, struct cpc_register_resource *reg);
+
+#endif /* _CPPC_H */
-- 
1.9.1

