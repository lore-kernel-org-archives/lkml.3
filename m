Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755409Ab3EMVoj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 17:44:39 -0400
Received: from am1ehsobe003.messaging.microsoft.com ([213.199.154.206]:3130
	"EHLO am1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755136Ab3EMVoh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 17:44:37 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-SpamScore: 3
X-BigFish: VPS3(zzc8kzz1f42h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ah1fc6hzz8275bh84d07hz2dh668h839hd24he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1d0ch1d2eh1d3fh1155h)
X-WSS-ID: 0MMRB1X-02-0XD-02
X-M-MSG: 
From: <steven.kinney@amd.com>
To: <linux-kernel@vger.kernel.org>, <a.p.zijlstra@chello.nl>,
        <mingo@redhat.com>, <iommu@lists.linux-foundation.org>,
        <joro@8bytes.org>
CC: <steven.kinney@amd.com>, Steven L Kinney <Steven.Kinney@amd.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Subject: [PATCH 2/2] IOMMU/AMD: IOMMU PC PERF uncore PMU implementation
Date: Mon, 13 May 2013 16:44:13 -0500
Message-ID: <1368481453-5657-1-git-send-email-steven.kinney@amd.com>
X-Mailer: git-send-email 1.7.10.4
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven L Kinney <Steven.Kinney@amd.com>

Implement a perf PMU to handle IOMMU PC perf events.  This PMU will handle
static counter perf events relative to the AMD IOMMU Performance Counters.

To invoke the AMD IOMMU PMU issue a perf tool command such as:

./perf stat -e amd_iommu/config=<config-data>,config1=<config1-data>/u <command>

For example:

./perf stat -e amd_iommu/config=0x8000000000000005,config1=0/u <command>

The resulting count will be how many IOMMU total peripheral memory
operations were performed during the command execution window.

Signed-off-by: Steven Kinney <steven.kinney@amd.com>
Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
---
 arch/x86/kernel/cpu/Makefile                 |    2 +-
 arch/x86/kernel/cpu/perf_event_amd_iommu.c |  409 ++++++++++++++++++++++++++
 arch/x86/kernel/cpu/perf_event_amd_iommu.h |   55 ++++
 3 files changed, 465 insertions(+), 1 deletion(-)
 create mode 100644 arch/x86/kernel/cpu/perf_event_amd_iommu.c
 create mode 100644 arch/x86/kernel/cpu/perf_event_amd_iommu.h

diff --git a/arch/x86/kernel/cpu/Makefile b/arch/x86/kernel/cpu/Makefile
index b0684e4..2a3b676 100644
--- a/arch/x86/kernel/cpu/Makefile
+++ b/arch/x86/kernel/cpu/Makefile
@@ -30,7 +30,7 @@ obj-$(CONFIG_CPU_SUP_UMC_32)		+= umc.o
 obj-$(CONFIG_PERF_EVENTS)		+= perf_event.o
 
 ifdef CONFIG_PERF_EVENTS
-obj-$(CONFIG_CPU_SUP_AMD)		+= perf_event_amd.o perf_event_amd_uncore.o
+obj-$(CONFIG_CPU_SUP_AMD)		+= perf_event_amd.o perf_event_amd_uncore.o perf_event_amd_iommu.o
 obj-$(CONFIG_CPU_SUP_INTEL)		+= perf_event_p6.o perf_event_knc.o perf_event_p4.o
 obj-$(CONFIG_CPU_SUP_INTEL)		+= perf_event_intel_lbr.o perf_event_intel_ds.o perf_event_intel.o
 obj-$(CONFIG_CPU_SUP_INTEL)		+= perf_event_intel_uncore.o
diff --git a/arch/x86/kernel/cpu/perf_event_amd_iommu.c b/arch/x86/kernel/cpu/perf_event_amd_iommu.c
new file mode 100644
index 0000000..117a9aa
--- /dev/null
+++ b/arch/x86/kernel/cpu/perf_event_amd_iommu.c
@@ -0,0 +1,409 @@
+/*
+ * Copyright (C) 2013 Advanced Micro Devices, Inc.
+ *
+ * Author: Steven Kinney <Steven.Kinney@amd.com>
+ * Author: Suravee Suthikulpanit <Suraveee.Suthikulpanit@amd.com>
+ *
+ * Performance event - AMD IOMMU Performance Counter
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/perf_event.h>
+#include <linux/module.h>
+#include <linux/pci.h>
+#include <linux/ptrace.h>
+
+#include "perf_event.h"
+#include "perf_event_amd_iommu.h"
+
+#define _GET_DEVID(ev) ((u16)((ev->hw.config \
+				& IOMMU_PC_DEVICEID_MATCH) >> 8))
+#define _GET_BANK(ev)  ((u8)(ev->hw.extra_reg.reg >> 8))
+#define _GET_CNTR(ev)  ((u8)(ev->hw.extra_reg.reg))
+
+/* define iommu pc states based on ibs, add states if needed */
+enum iommu_pc_states {
+	IOMMU_PC_ENABLED	= 0,
+	IOMMU_PC_STARTED	= 1,
+	IOMMU_PC_STOPPING	= 2,
+	IOMMU_PC_MAX_STATES,
+};
+
+
+struct cpu_perf_iommu {
+	struct perf_event	*event;
+	unsigned long		state[BITS_TO_LONGS(IOMMU_PC_MAX_STATES)];
+};
+
+
+struct perf_iommu {
+	struct pmu	pmu;
+	struct attribute **format_attrs;
+	struct attribute_group format_group;
+	const struct attribute_group *attr_groups[11];
+	u16		iommu_devid;
+	u8		max_banks;
+	u8		max_counters;
+
+	struct cpu_perf_iommu  __percpu *pcpu;
+};
+
+
+PMU_FORMAT_ATTR(iommu_raw, "config:63");
+PMU_FORMAT_ATTR(csource, "config:7-0");
+PMU_FORMAT_ATTR(deviceid, "config:23-8");
+PMU_FORMAT_ATTR(pasid, "config:39-24");
+PMU_FORMAT_ATTR(domain, "config:55-40");
+PMU_FORMAT_ATTR(en_deviceid_filter, "config:56");
+PMU_FORMAT_ATTR(en_pasid_filter, "config:57");
+PMU_FORMAT_ATTR(en_domain_filter, "config:58");
+PMU_FORMAT_ATTR(deviceid_mask, "config1:15-0");
+PMU_FORMAT_ATTR(pasid_mask, "config1:31-16");
+PMU_FORMAT_ATTR(domain_mask, "config1:47-32");
+
+
+static struct attribute *iommu_fetch_format_attrs[] = {
+	&format_attr_iommu_raw.attr,
+	&format_attr_csource.attr,
+	&format_attr_deviceid.attr,
+	&format_attr_pasid.attr,
+	&format_attr_domain.attr,
+	&format_attr_en_deviceid_filter.attr,
+	&format_attr_en_pasid_filter.attr,
+	&format_attr_en_domain_filter.attr,
+	&format_attr_deviceid_mask.attr,
+	&format_attr_pasid_mask.attr,
+	&format_attr_domain_mask.attr,
+	NULL,
+};
+
+
+static u64 cntr_assign_mask;
+
+static struct perf_iommu perf_iommu_fetch;
+
+
+static u16 get_next_avail_iommu_bnk_cntr(struct perf_iommu *perf_iommu)
+{
+	int bank_index, cntr_index;
+	int max_banks, max_cntrs;
+	int shift = 0;
+	int bank_offset = 0;
+	u16 retval;
+
+	max_banks = perf_iommu->max_banks;
+	max_cntrs = perf_iommu->max_counters;
+
+	for (bank_index = 0; bank_index < max_banks; bank_index++) {
+		for (cntr_index = 0; cntr_index < max_cntrs; cntr_index++) {
+			shift = bank_index + cntr_index + bank_offset;
+			if (cntr_assign_mask & (1ULL<<shift))
+				continue;
+			else {
+				cntr_assign_mask |= (1ULL<<shift);
+				retval = ((u16)((u16)bank_index<<8) |
+					  (u8)(cntr_index));
+				goto out;
+			}
+		}
+		bank_offset += 3;
+	}
+	retval = -EINVAL;
+out:
+	return retval;
+}
+
+
+static int clear_avail_iommu_bnk_cntr(struct perf_iommu *perf_iommu,
+					u8 bank, u8 cntr)
+{
+	int max_banks, max_cntrs;
+	int shift = 0;
+
+	max_banks = perf_iommu->max_banks;
+	max_cntrs = perf_iommu->max_counters;
+
+	if ((bank > max_banks) || (cntr > max_cntrs))
+		return -EINVAL;
+
+	shift = bank + cntr + (bank*3);
+	cntr_assign_mask &= ~(1ULL<<shift);
+
+	return 0;
+}
+
+
+static int perf_iommu_init(struct perf_event *event)
+{
+	struct hw_perf_event *hwc = &event->hw;
+	struct perf_iommu *perf_iommu;
+	u64 config, config1;
+
+	/* initialize the cntr_assign_mask */
+	cntr_assign_mask = 0;
+
+	/* test the event attr type check for PMU enumeration */
+	if (event->attr.type != event->pmu->type)
+		return -ENOENT;
+
+	perf_iommu = &perf_iommu_fetch;
+
+	if (perf_iommu) {
+		config = event->attr.config;
+		config1 = event->attr.config1;
+	} else
+		return -EINVAL;
+
+	if (event->pmu != &perf_iommu->pmu)
+		return -ENOENT;
+
+	/* make sure the event->attr.config is raw (vendor specific) */
+	if (!(config & IOMMU_PC_RAW_CONFIG_MASK))
+		return -EINVAL;
+
+	/* integrate with iommu base devid (0000), assume one iommu */
+	perf_iommu->max_banks =
+		amd_iommu_pc_get_max_banks(IOMMU_BASE_DEVID);
+	perf_iommu->max_counters =
+		amd_iommu_pc_get_max_counters(IOMMU_BASE_DEVID);
+
+	/* update the hw_perf_event struct with the iommu config data */
+	hwc->config = config;
+	hwc->extra_reg.config = config1;
+
+	return 0;
+}
+
+
+static void perf_iommu_enable_event(struct perf_event *event)
+{
+	u64 csource = (u64)(event->hw.config & IOMMU_PC_CSOURCE);
+
+	amd_iommu_pc_get_set_reg_val(_GET_DEVID(event),
+					_GET_BANK(event),
+					_GET_CNTR(event) ,
+					 IOMMU_PC_COUNTER_SRC_REG,
+					 &csource,
+					 true);
+}
+
+
+static void perf_iommu_start(struct perf_event *event, int flags)
+{
+	struct hw_perf_event *hwc = &event->hw;
+	struct perf_iommu *perf_iommu =
+			container_of(event->pmu, struct perf_iommu, pmu);
+	struct cpu_perf_iommu *pcpu = this_cpu_ptr(perf_iommu->pcpu);
+
+	if (WARN_ON_ONCE(!(hwc->state & PERF_HES_STOPPED)))
+		return;
+
+	WARN_ON_ONCE(!(hwc->state & PERF_HES_UPTODATE));
+	hwc->state = 0;
+
+	if (flags & PERF_EF_RELOAD) {
+		u64 prev_raw_count =  local64_read(&hwc->prev_count);
+
+		amd_iommu_pc_get_set_reg_val(_GET_DEVID(event),
+					_GET_BANK(event),
+					_GET_CNTR(event),
+					IOMMU_PC_COUNTER_REG,
+					&prev_raw_count,
+					true);
+	}
+
+	set_bit(IOMMU_PC_STARTED, pcpu->state);
+	perf_iommu_enable_event(event);
+	perf_event_update_userpage(event);
+
+}
+
+
+static void perf_iommu_event_update(struct perf_event *event)
+{
+	u64 count;
+	u64 prev_raw_count;
+	u64 delta;
+	struct hw_perf_event *hwc = &event->hw;
+
+	amd_iommu_pc_get_set_reg_val(_GET_DEVID(event),
+					_GET_BANK(event),
+					_GET_CNTR(event),
+					IOMMU_PC_COUNTER_REG,
+					&count,
+					false);
+
+	prev_raw_count =  local64_read(&hwc->prev_count);
+	if (local64_cmpxchg(&hwc->prev_count, prev_raw_count,
+					count) != prev_raw_count)
+		return;
+
+	delta = count - prev_raw_count;
+	local64_add(delta, &event->count);
+
+}
+
+
+static void perf_iommu_disable_event(struct perf_event *event)
+{
+	u64 val = PC_CSOURCE_DISABLE_CNT;
+
+	amd_iommu_pc_get_set_reg_val(_GET_DEVID(event),
+					_GET_BANK(event),
+					_GET_CNTR(event),
+					IOMMU_PC_COUNTER_SRC_REG,
+					&val,
+					true);
+}
+
+
+static void perf_iommu_stop(struct perf_event *event, int flags)
+{
+	struct hw_perf_event *hwc = &event->hw;
+	struct perf_iommu *perf_iommu =
+			container_of(event->pmu, struct perf_iommu, pmu);
+	struct cpu_perf_iommu *pcpu = this_cpu_ptr(perf_iommu->pcpu);
+	int stopping;
+	u64 config;
+
+	stopping = test_and_clear_bit(IOMMU_PC_STARTED, pcpu->state);
+
+	if (!stopping && (hwc->state & PERF_HES_UPTODATE))
+		return;
+
+	if (stopping) {
+		set_bit(IOMMU_PC_STOPPING, pcpu->state);
+		perf_iommu_disable_event(event);
+		WARN_ON_ONCE(hwc->state & PERF_HES_STOPPED);
+		hwc->state |= PERF_HES_STOPPED;
+	}
+
+	if (hwc->state & PERF_HES_UPTODATE)
+		return;
+
+	config = hwc->config;
+	perf_iommu_event_update(event);
+	hwc->state |= PERF_HES_UPTODATE;
+}
+
+
+static int perf_iommu_add(struct perf_event *event, int flags)
+{
+	struct perf_iommu *perf_iommu =
+			container_of(event->pmu, struct perf_iommu, pmu);
+	struct cpu_perf_iommu *pcpu = this_cpu_ptr(perf_iommu->pcpu);
+
+	if (test_and_set_bit(IOMMU_PC_ENABLED, pcpu->state))
+		return -ENOSPC;
+
+	event->hw.state = PERF_HES_UPTODATE | PERF_HES_STOPPED;
+
+	pcpu->event = event;
+
+	/* request an iommu bank/counter */
+	event->hw.extra_reg.reg = get_next_avail_iommu_bnk_cntr(perf_iommu);
+
+	if (flags & PERF_EF_START)
+		perf_iommu_start(event, PERF_EF_RELOAD);
+
+	return 0;
+}
+
+
+static void perf_iommu_del(struct perf_event *event, int flags)
+{
+	struct perf_iommu *perf_iommu =
+			container_of(event->pmu, struct perf_iommu, pmu);
+	struct cpu_perf_iommu *pcpu = this_cpu_ptr(perf_iommu->pcpu);
+
+	if (!test_and_clear_bit(IOMMU_PC_ENABLED, pcpu->state))
+		return;
+
+	perf_iommu_stop(event, PERF_EF_UPDATE);
+
+	/* clear the assigned iommu bank/counter */
+	clear_avail_iommu_bnk_cntr(perf_iommu,
+				     _GET_BANK(event),
+				     _GET_CNTR(event));
+	pcpu->event = NULL;
+
+	perf_event_update_userpage(event);
+}
+
+
+static void perf_iommu_read(struct perf_event *event)
+{
+	pr_debug("perf: AMD IOMMU: perf_iommu_read called\n");
+}
+
+
+static struct perf_iommu perf_iommu_fetch = {
+	.pmu = {
+		.event_init	= perf_iommu_init,
+		.add		= perf_iommu_add,
+		.del		= perf_iommu_del,
+		.start		= perf_iommu_start,
+		.stop		= perf_iommu_stop,
+		.read		= perf_iommu_read,
+	},
+	.format_attrs		= iommu_fetch_format_attrs,
+	.max_banks		= 0x00,
+	.max_counters		= 0x00,
+};
+
+
+static __init int perf_iommu_pmu_init(struct perf_iommu *perf_iommu,
+					char *name)
+{
+	struct cpu_perf_iommu __percpu *pcpu;
+	int ret;
+
+	pcpu = alloc_percpu(struct cpu_perf_iommu);
+	if (!pcpu)
+		return -ENOMEM;
+
+	perf_iommu->pcpu = pcpu;
+
+	/* allocate and register atttributes */
+	if (perf_iommu->format_attrs[0]) {
+		memset(&perf_iommu->format_group, 0,
+			sizeof(perf_iommu->format_group));
+		perf_iommu->format_group.name = "format";
+		perf_iommu->format_group.attrs = perf_iommu->format_attrs;
+		memset(&perf_iommu->attr_groups, 0,
+			sizeof(perf_iommu->attr_groups));
+		perf_iommu->attr_groups[0] = &perf_iommu->format_group;
+		perf_iommu->pmu.attr_groups = perf_iommu->attr_groups;
+	}
+
+	ret = perf_pmu_register(&perf_iommu->pmu, name, -1);
+	if (ret) {
+		pr_err("perf: AMD IOMMU PMU failed to initialized.\n");
+		perf_iommu->pcpu = NULL;
+		free_percpu(pcpu);
+	}
+
+	pr_info("perf: AMD IOMMU PMU detected. (%d banks, %d counters/bank)\n",
+		amd_iommu_pc_get_max_banks(IOMMU_BASE_DEVID),
+		amd_iommu_pc_get_max_counters(IOMMU_BASE_DEVID));
+
+	return ret;
+}
+
+static __init int amd_iommu_pmc_init(void)
+{
+	/* Make sure the IOMMU PC resource is available */
+	if (!amd_iommu_pc_supported()) {
+		pr_err("perf: AMD IOMMU PMU not installed. No support!\n");
+		return -ENODEV;
+	}
+
+	perf_iommu_pmu_init(&perf_iommu_fetch, "amd_iommu");
+
+	return 0;
+}
+
+device_initcall(amd_iommu_pmc_init);
diff --git a/arch/x86/kernel/cpu/perf_event_amd_iommu.h b/arch/x86/kernel/cpu/perf_event_amd_iommu.h
new file mode 100644
index 0000000..d832033
--- /dev/null
+++ b/arch/x86/kernel/cpu/perf_event_amd_iommu.h
@@ -0,0 +1,55 @@
+/*
+ * Copyright (C) 2013 Advanced Micro Devices, Inc.
+ *
+ * Author: Steven Kinney <Steven.Kinney@amd.com>
+ * Author: Suravee Suthikulpanit <Suraveee.Suthikulpanit@amd.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef _PERF_EVENT_AMD_IOMMU_H_
+#define _PERF_EVENT_AMD_IOMMU_H_
+
+/* iommu pc mmio region register indexes */
+#define IOMMU_PC_COUNTER_REG			0x00
+#define IOMMU_PC_COUNTER_SRC_REG		0x08
+#define IOMMU_PC_PASID_MATCH_REG		0x10
+#define IOMMU_PC_DOMAIN_MATCH_REG		0x18
+#define IOMMU_PC_DEVICEID_MATCH_REG		0x20
+#define IOMMU_PC_COUNTER_REPORT_REG		0x28
+
+/* iommu pc csource register values */
+#define PC_CSOURCE_DISABLE_CNT			0ULL
+
+/* maximun specified bank/counters */
+#define PC_MAX_SPEC_BNKS			64
+#define PC_MAX_SPEC_CNTRS			16
+
+/* iommu pmu config masks */
+#define IOMMU_PC_RAW_CONFIG_MASK		(1ULL << 63)
+#define IOMMU_PC_CSOURCE			(0xFFULL)
+#define IOMMU_PC_DEVICEID_MATCH			(0xFFFFULL << 8)
+#define IOMMU_PC_PASID_MATCH			(0xFFFFULL << 24)
+#define IOMMU_PC_DOMAIN_MATCH			(0xFFFFULL << 40)
+#define IOMMU_PC_EN_DEVICEID			(1ULL << 56)
+#define IOMMU_PC_EN_PASID			(1ULL << 57)
+#define IOMMU_PC_EN_DOMAIN			(1ULL << 58)
+#define IOMMU_PC_DEVICEID_MASK			(0xFFFFULL)
+#define IOMMU_PC_PASID_MASK			(0xFFFFULL << 16)
+#define IOMMU_PC_DOMAIN_MASK			(0xFFFFULL << 32)
+
+#define IOMMU_BASE_DEVID			0x0000
+
+/* amd_iommu_init.c external support functions */
+extern bool amd_iommu_pc_supported(void);
+
+extern u8 amd_iommu_pc_get_max_banks(u16 devid);
+
+extern u8 amd_iommu_pc_get_max_counters(u16 devid);
+
+extern int amd_iommu_pc_get_set_reg_val(u16 devid, u8 bank, u8 cntr,
+				u8 fxn, long long *value, bool is_write);
+
+#endif /*_PERF_EVENT_AMD_IOMMU_H_*/
-- 
1.7.10.4


