Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752814AbaIIWMo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 18:12:44 -0400
Received: from mail-pd0-f178.google.com ([209.85.192.178]:41267 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752758AbaIIWMm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 18:12:42 -0400
From: Ashwin Chaugule <ashwin.chaugule@linaro.org>
To: dirk.j.brandewie@intel.com
Cc: rjw@rjwysocki.net, linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linaro-acpi@lists.linaro.org,
        Ashwin Chaugule <ashwin.chaugule@linaro.org>
Subject: [PATCH 6/6] PID: Add CPPC (Collaborative Processor Performance) backend driver
Date: Tue,  9 Sep 2014 18:12:08 -0400
Message-Id: <1410300728-26637-7-git-send-email-ashwin.chaugule@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1410300728-26637-1-git-send-email-ashwin.chaugule@linaro.org>
References: <1410300728-26637-1-git-send-email-ashwin.chaugule@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CPPC (Collaborative Processor Performance Control) is defined
in the ACPI 5.0+ spec. It is a method for controlling CPU performance
on a continuous scale using performance feedback registers. The PID
governor concepts of CPU performance management map cleanly onto CPPC.
This patch implements the PID backend interfaces using CPPC semantics.

Signed-off-by: Ashwin Chaugule <ashwin.chaugule@linaro.org>
---
 drivers/cpufreq/Kconfig         |  10 +
 drivers/cpufreq/Makefile        |   1 +
 drivers/cpufreq/cppc_pid_ctrl.c | 406 ++++++++++++++++++++++++++++++++++++++++
 3 files changed, 417 insertions(+)
 create mode 100644 drivers/cpufreq/cppc_pid_ctrl.c

diff --git a/drivers/cpufreq/Kconfig b/drivers/cpufreq/Kconfig
index bbc19ac..90b71d3 100644
--- a/drivers/cpufreq/Kconfig
+++ b/drivers/cpufreq/Kconfig
@@ -205,6 +205,16 @@ config PID_CTRL
 		governor requires platform specific backend drivers to access
 		counters. See Documentation/cpu-freq/pid_ctrl.txt
 
+config CPPC_PID_CTRL
+	bool "PID CPPC backend driver"
+	depends on ACPI_PCC && PID_CTRL
+	help
+		CPPC is Collaborative Processor Performance Control. It allows the OS
+		to request CPU performance with an abstract metric and lets the platform
+		(e.g. BMC) interpret and optimize it for power and performance in a
+		platform specific manner. This driver implements the backend interfaces
+		using CPPC semantics for the PID governor.
+
 menu "x86 CPU frequency scaling drivers"
 depends on X86
 source "drivers/cpufreq/Kconfig.x86"
diff --git a/drivers/cpufreq/Makefile b/drivers/cpufreq/Makefile
index 6d1a4d0..0778013 100644
--- a/drivers/cpufreq/Makefile
+++ b/drivers/cpufreq/Makefile
@@ -41,6 +41,7 @@ obj-$(CONFIG_X86_P4_CLOCKMOD)		+= p4-clockmod.o
 obj-$(CONFIG_X86_CPUFREQ_NFORCE2)	+= cpufreq-nforce2.o
 obj-$(CONFIG_PID_CTRL)				+= pid_ctrl.o
 obj-$(CONFIG_X86_INTEL_PSTATE)		+= intel_pid_ctrl.o
+obj-$(CONFIG_CPPC_PID_CTRL)				+= cppc_pid_ctrl.o
 obj-$(CONFIG_X86_AMD_FREQ_SENSITIVITY)	+= amd_freq_sensitivity.o
 
 ##################################################################################
diff --git a/drivers/cpufreq/cppc_pid_ctrl.c b/drivers/cpufreq/cppc_pid_ctrl.c
new file mode 100644
index 0000000..53ea5e0
--- /dev/null
+++ b/drivers/cpufreq/cppc_pid_ctrl.c
@@ -0,0 +1,406 @@
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
+#include <linux/cpu.h>
+#include <linux/types.h>
+#include <linux/acpi.h>
+#include <linux/errno.h>
+
+#include <acpi/processor.h>
+#include <acpi/actypes.h>
+
+#include "pid_ctrl.h"
+
+#define CPPC_EN				1
+#define PCC_CMD_COMPLETE	1
+#define MAX_CPC_REG_ENT 	19
+
+static u64 pcc_comm_base_addr;
+static void __iomem *comm_base_addr;
+static s8 pcc_subspace_idx = -1;
+extern int get_pcc_comm_channel(u32 ss_idx, u64* addr, int *len);
+extern u16 send_pcc_cmd(u8 cmd, u8 sci, u32 ss_idx, u64 * __iomem base_addr);
+
+/* PCC Commands used by CPPC */
+enum cppc_ppc_cmds {
+	PCC_CMD_READ,
+	PCC_CMD_WRITE,
+	RESERVED,
+};
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
+static struct cpc_register_resource {
+	u8 descriptor;
+	u16 length;
+	u8 space_id;
+	u8 bit_width;
+	u8 bit_offset;
+	u8 access_width;
+	u64 __iomem address;
+} __attribute__ ((packed));
+
+static struct cpc_desc {
+	unsigned int num_entries;
+	unsigned int version;
+	struct cpc_register_resource cpc_regs[MAX_CPC_REG_ENT];
+};
+static DEFINE_PER_CPU(struct cpc_desc *, cpc_desc_ptr);
+
+struct perf_limits limits = {
+	.no_turbo = 0,
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
+	for_each_possible_cpu(cpu) {
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
+static void cppc_get_pstates(struct cpudata *cpu)
+{
+	unsigned int cpunum = cpu->cpu;
+	struct cpc_desc *cpc_desc = per_cpu(cpc_desc_ptr, cpunum);
+	struct cpc_register_resource *highest_reg, *lowest_reg;
+	int status;
+
+	if (!cpc_desc) {
+		pr_err("No CPC descriptor for CPU:%d\n", cpunum);
+		return;
+	}
+
+	pr_debug("Sending PCC READ to update COMM space\n");
+	status = send_pcc_cmd(PCC_CMD_READ, 0, pcc_subspace_idx,
+			comm_base_addr);
+
+	if (!(status & PCC_CMD_COMPLETE)) {
+		pr_err("Err updating PCC comm space\n");
+		return;
+	}
+
+	highest_reg = &cpc_desc->cpc_regs[HIGHEST_PERF];
+	lowest_reg = &cpc_desc->cpc_regs[LOWEST_PERF];
+
+	cpu->pstate.max_pstate = cpc_read64(highest_reg, comm_base_addr);
+	cpu->pstate.min_pstate = cpc_read64(lowest_reg, comm_base_addr);
+
+	if (!cpu->pstate.max_pstate || !cpu->pstate.min_pstate) {
+		pr_err("Err reading CPU performance limits\n");
+		return;
+	}
+
+	cpu->pstate.turbo_pstate = cpu->pstate.max_pstate;
+}
+
+static void cppc_get_sample(struct cpudata *cpu)
+{
+	unsigned int cpunum = cpu->cpu;
+	struct cpc_desc *cpc_desc = per_cpu(cpc_desc_ptr, cpunum);
+	struct cpc_register_resource *delivered_reg, *reference_reg;
+	int status;
+	u64 delivered, reference;
+
+	if (!cpc_desc) {
+		pr_err("No CPC descriptor for CPU:%d\n", cpunum);
+		return;
+	}
+
+	pr_debug("Sending PCC READ to update COMM space\n");
+	status = send_pcc_cmd(PCC_CMD_READ, 0, pcc_subspace_idx,
+			comm_base_addr);
+
+	if (!(status & PCC_CMD_COMPLETE)) {
+		pr_err("Err updating PCC comm space\n");
+		return;
+	}
+
+	delivered_reg = &cpc_desc->cpc_regs[DELIVERED_CTR];
+	reference_reg = &cpc_desc->cpc_regs[REFERENCE_CTR];
+
+	delivered = cpc_read64(delivered_reg, comm_base_addr);
+	reference = cpc_read64(reference_reg, comm_base_addr);
+
+	if (!delivered || !reference) {
+		pr_err("Err reading CPU counters\n");
+		return;
+	}
+
+	delivered = delivered >> FRAC_BITS;
+	reference = reference >> FRAC_BITS;
+
+	cpu->sample.delivered = delivered;
+	cpu->sample.reference = reference;
+
+	cpu->sample.delivered -= cpu->prev_delivered;
+	cpu->sample.reference -= cpu->prev_reference;
+
+	cpu->prev_delivered = delivered;
+	cpu->prev_reference = reference;
+}
+
+static void cppc_set_pstate(struct cpudata *cpudata, int pstate)
+{
+	unsigned int cpu = cpudata->cpu;
+	struct cpc_desc *cpc_desc = per_cpu(cpc_desc_ptr, cpu);
+	struct cpc_register_resource *desired_reg;
+	int status;
+
+	if (!cpc_desc) {
+		pr_err("No CPC descriptor for CPU:%d\n", cpu);
+		return;
+	}
+
+	desired_reg = &cpc_desc->cpc_regs[DESIRED_PERF];
+	cpc_write64(pstate, desired_reg, comm_base_addr);
+
+	pr_debug("Sending PCC WRITE to update COMM space\n");
+	status = send_pcc_cmd(PCC_CMD_WRITE, 0, pcc_subspace_idx,
+			comm_base_addr);
+
+	if (!(status & PCC_CMD_COMPLETE)) {
+		pr_err("Err updating PCC comm space\n");
+		return;
+	}
+}
+
+static struct cpu_defaults cppc_params = {
+	.pid_policy = {
+		.sample_rate_ms = 10,
+		.deadband = 0,
+		.setpoint = 97,
+		.p_gain_pct = 14,
+		.d_gain_pct = 0,
+		.i_gain_pct = 4,
+	},
+	.funcs = {
+		.get_sample = cppc_get_sample,
+		.get_pstates = cppc_get_pstates,
+		.set = cppc_set_pstate,
+	},
+};
+
+static int __init cppc_init(void)
+{
+	if(acpi_disabled || cppc_processor_probe()) {
+		pr_err("Err initializing CPC structures or ACPI is disabled\n");
+		return -ENODEV;
+	}
+
+	pr_info("CPPC PID driver initializing.\n");
+
+	register_pid_params(&cppc_params.pid_policy);
+	register_cpu_funcs(&cppc_params.funcs);
+
+	return 0;
+}
+device_initcall(cppc_init);
+
-- 
1.9.1

