Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756494Ab3EQTrw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 15:47:52 -0400
Received: from [65.55.88.12] ([65.55.88.12]:26777 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753976Ab3EQTrt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 15:47:49 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-SpamScore: 4
X-BigFish: VPS4(z551bizc8kzz1f42h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ah1fc6hzz8275bhz2dh668h839hd24he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1d0ch1d2eh1d3fh1155h)
X-WSS-ID: 0MMYK90-01-D3O-02
X-M-MSG: 
From: <suravee.suthikulpanit@amd.com>
To: <linux-kernel@vger.kernel.org>, <a.p.zijlstra@chello.nl>,
        <mingo@redhat.com>, <iommu@lists.linux-foundation.org>,
        <joro@8bytes.org>
CC: Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Subject: [PATCH 2/2 V3] perf/x86/amd: AMD IOMMU PC PERF uncore PMU implementation
Date: Fri, 17 May 2013 14:43:32 -0500
Message-ID: <1368819813-6481-3-git-send-email-suravee.suthikulpanit@amd.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1368819813-6481-1-git-send-email-suravee.suthikulpanit@amd.com>
References: <1368819813-6481-1-git-send-email-suravee.suthikulpanit@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>

Implement a perf PMU to handle IOMMU performance counters and events.
The PMU only supports counting mode (e.g. perf stat). Since the counters
are shared across all cores, the PMU is implemented as "system-wide" mode.

To invoke the AMD IOMMU PMU, issue a perf tool command such as:

./perf stat -a -e amd_iommu/<events>/ <command>
or
./perf stat -a -e amd_iommu/config=<config-data>,config1=<config1-data>/ <command>

For example:

./perf stat -a -e amd_iommu/mem_trans_total/ <command>

The resulting count will be how many IOMMU total peripheral memory
operations were performed during the command execution window.

The IOMMU performance counter support is available starting in the 
AMD family15h model 0x30. For information regarding IOMMU performance 
counter configuration, please see the AMD IOMMU v2.5 specification.

Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
---
V3 Changes:
This version contain several changes:
	- Properly implement system-wide mode.
	- Add "amd_iommu/cpumask".
	- Add "amd_iommu/events"
	- Simplify "amd_iommu/format"
	- Add supports for devid, domid, and pasid filtering

 arch/x86/kernel/cpu/Makefile               |    2 +-
 arch/x86/kernel/cpu/perf_event_amd_iommu.c |  498 ++++++++++++++++++++++++++++
 arch/x86/kernel/cpu/perf_event_amd_iommu.h |   40 +++
 3 files changed, 539 insertions(+), 1 deletion(-)
 create mode 100644 arch/x86/kernel/cpu/perf_event_amd_iommu.c
 create mode 100644 arch/x86/kernel/cpu/perf_event_amd_iommu.h

diff --git a/arch/x86/kernel/cpu/Makefile b/arch/x86/kernel/cpu/Makefile
index b0684e4..fcbd3b8 100644
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
index 0000000..fad04f2
--- /dev/null
+++ b/arch/x86/kernel/cpu/perf_event_amd_iommu.c
@@ -0,0 +1,498 @@
+/*
+ * Copyright (C) 2013 Advanced Micro Devices, Inc.
+ *
+ * Author: Steven Kinney <Steven.Kinney@amd.com>
+ * Author: Suravee Suthikulpanit <Suraveee.Suthikulpanit@amd.com>
+ *
+ * Perf: amd_iommu - AMD IOMMU Performance Counter PMU implementation
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/perf_event.h>
+#include <linux/module.h>
+#include <linux/cpumask.h>
+#include <linux/slab.h>
+
+#include "perf_event.h"
+#include "perf_event_amd_iommu.h"
+
+#define _GET_BANK(ev)       ((u8)(ev->hw.extra_reg.reg >> 8))
+#define _GET_CNTR(ev)       ((u8)(ev->hw.extra_reg.reg))
+
+/* iommu pmu config masks */
+#define _GET_CSOURCE(ev)    ((ev->hw.config & 0xFFULL))
+#define _GET_DEVID(ev)      ((ev->hw.config >> 8)  & 0xFFFFULL)
+#define _GET_PASID(ev)      ((ev->hw.config >> 24) & 0xFFFFULL)
+#define _GET_DOMID(ev)      ((ev->hw.config >> 40) & 0xFFFFULL)
+#define _GET_DEVID_MASK(ev) ((ev->hw.extra_reg.config)  & 0xFFFFULL)
+#define _GET_PASID_MASK(ev) ((ev->hw.extra_reg.config >> 16) & 0xFFFFULL)
+#define _GET_DOMID_MASK(ev) ((ev->hw.extra_reg.config >> 32) & 0xFFFFULL)
+
+static struct perf_amd_iommu __perf_iommu;
+
+struct perf_amd_iommu {
+	struct pmu pmu;
+	u8 max_banks;
+	u8 max_counters;
+	u64 cntr_assign_mask;
+	raw_spinlock_t lock;
+	const struct attribute_group *attr_groups[4];
+};
+
+#define format_group	attr_groups[0]
+#define cpumask_group	attr_groups[1]
+#define events_group	attr_groups[2]
+#define null_group	attr_groups[3]
+
+/*---------------------------------------------
+ * sysfs format attributes
+ *---------------------------------------------*/
+PMU_FORMAT_ATTR(csource,    "config:0-7");
+PMU_FORMAT_ATTR(devid,      "config:8-23");
+PMU_FORMAT_ATTR(pasid,      "config:24-39");
+PMU_FORMAT_ATTR(domid,      "config:40-55");
+PMU_FORMAT_ATTR(devid_mask, "config1:0-15");
+PMU_FORMAT_ATTR(pasid_mask, "config1:16-31");
+PMU_FORMAT_ATTR(domid_mask, "config1:32-47");
+
+static struct attribute *iommu_format_attrs[] = {
+	&format_attr_csource.attr,
+	&format_attr_devid.attr,
+	&format_attr_pasid.attr,
+	&format_attr_domid.attr,
+	&format_attr_devid_mask.attr,
+	&format_attr_pasid_mask.attr,
+	&format_attr_domid_mask.attr,
+	NULL,
+};
+
+static struct attribute_group amd_iommu_format_group = {
+	.name = "format",
+	.attrs = iommu_format_attrs,
+};
+
+/*---------------------------------------------
+ * sysfs events attributes
+ *---------------------------------------------*/
+struct amd_iommu_event_desc {
+	struct kobj_attribute attr;
+	const char *event;
+};
+
+static ssize_t _iommu_event_show(struct kobject *kobj,
+				struct kobj_attribute *attr, char *buf)
+{
+	struct amd_iommu_event_desc *event =
+		container_of(attr, struct amd_iommu_event_desc, attr);
+	return sprintf(buf, "%s\n", event->event);
+}
+
+#define AMD_IOMMU_EVENT_DESC(_name, _event)			\
+{								\
+	.attr  = __ATTR(_name, 0444, _iommu_event_show, NULL),	\
+	.event = _event,					\
+}
+
+static struct amd_iommu_event_desc amd_iommu_v2_event_descs[] = {
+	AMD_IOMMU_EVENT_DESC(mem_pass_untrans,        "csource=0x01"),
+	AMD_IOMMU_EVENT_DESC(mem_pass_pretrans,       "csource=0x02"),
+	AMD_IOMMU_EVENT_DESC(mem_pass_excl,           "csource=0x03"),
+	AMD_IOMMU_EVENT_DESC(mem_target_abort,        "csource=0x04"),
+	AMD_IOMMU_EVENT_DESC(mem_trans_total,         "csource=0x05"),
+	AMD_IOMMU_EVENT_DESC(mem_iommu_tlb_pte_hit,   "csource=0x06"),
+	AMD_IOMMU_EVENT_DESC(mem_iommu_tlb_pte_mis,   "csource=0x07"),
+	AMD_IOMMU_EVENT_DESC(mem_iommu_tlb_pde_hit,   "csource=0x08"),
+	AMD_IOMMU_EVENT_DESC(mem_iommu_tlb_pde_mis,   "csource=0x09"),
+	AMD_IOMMU_EVENT_DESC(mem_dte_hit,             "csource=0x0a"),
+	AMD_IOMMU_EVENT_DESC(mem_dte_mis,             "csource=0x0b"),
+	AMD_IOMMU_EVENT_DESC(page_tbl_read_tot,       "csource=0x0c"),
+	AMD_IOMMU_EVENT_DESC(page_tbl_read_nst,       "csource=0x0d"),
+	AMD_IOMMU_EVENT_DESC(page_tbl_read_gst,       "csource=0x0e"),
+	AMD_IOMMU_EVENT_DESC(int_dte_hit,             "csource=0x0f"),
+	AMD_IOMMU_EVENT_DESC(int_dte_mis,             "csource=0x10"),
+	AMD_IOMMU_EVENT_DESC(cmd_processed,           "csource=0x11"),
+	AMD_IOMMU_EVENT_DESC(cmd_processed_inv,       "csource=0x12"),
+	AMD_IOMMU_EVENT_DESC(tlb_inv,                 "csource=0x13"),
+	{ /* end: all zeroes */ },
+};
+
+/*---------------------------------------------
+ * sysfs cpumask attributes
+ *---------------------------------------------*/
+static cpumask_t iommu_cpumask;
+
+static ssize_t _iommu_cpumask_show(struct device *dev,
+				   struct device_attribute *attr,
+				   char *buf)
+{
+	int n = cpulist_scnprintf(buf, PAGE_SIZE - 2, &iommu_cpumask);
+	buf[n++] = '\n';
+	buf[n] = '\0';
+	return n;
+}
+static DEVICE_ATTR(cpumask, S_IRUGO, _iommu_cpumask_show, NULL);
+
+static struct attribute *iommu_cpumask_attrs[] = {
+	&dev_attr_cpumask.attr,
+	NULL,
+};
+
+static struct attribute_group amd_iommu_cpumask_group = {
+	.attrs = iommu_cpumask_attrs,
+};
+
+/*---------------------------------------------*/
+
+static int get_next_avail_iommu_bnk_cntr(struct perf_amd_iommu *perf_iommu)
+{
+	unsigned long flags;
+	int shift, bank, cntr, retval;
+	int max_banks = perf_iommu->max_banks;
+	int max_cntrs = perf_iommu->max_counters;
+
+	raw_spin_lock_irqsave(&perf_iommu->lock, flags);
+
+	for (bank = 0, shift = 0; bank < max_banks; bank++) {
+		for (cntr = 0; cntr < max_cntrs; cntr++) {
+			shift = bank + (bank*3) + cntr;
+			if (perf_iommu->cntr_assign_mask & (1ULL<<shift)) {
+				continue;
+			} else {
+				perf_iommu->cntr_assign_mask |= (1ULL<<shift);
+				retval = ((u16)((u16)bank<<8) | (u8)(cntr));
+				goto out;
+			}
+		}
+	}
+	retval = -ENOSPC;
+out:
+	raw_spin_unlock_irqrestore(&perf_iommu->lock, flags);
+	return retval;
+}
+
+static int clear_avail_iommu_bnk_cntr(struct perf_amd_iommu *perf_iommu,
+					u8 bank, u8 cntr)
+{
+	unsigned long flags;
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
+
+	raw_spin_lock_irqsave(&perf_iommu->lock, flags);
+	perf_iommu->cntr_assign_mask &= ~(1ULL<<shift);
+	raw_spin_unlock_irqrestore(&perf_iommu->lock, flags);
+
+	return 0;
+}
+
+static int perf_iommu_event_init(struct perf_event *event)
+{
+	struct hw_perf_event *hwc = &event->hw;
+	struct perf_amd_iommu *perf_iommu;
+	u64 config, config1;
+
+	/* test the event attr type check for PMU enumeration */
+	if (event->attr.type != event->pmu->type)
+		return -ENOENT;
+
+	/*
+	 * IOMMU counters are shared across all cores.
+	 * Therefore, it does not support per-process mode.
+	 * Also, it does not support event sampling mode.
+	 */
+	if (is_sampling_event(event) || event->attach_state & PERF_ATTACH_TASK)
+		return -EINVAL;
+
+	/* IOMMU counters do not have usr/os/guest/host bits */
+	if (event->attr.exclude_user || event->attr.exclude_kernel ||
+	    event->attr.exclude_host || event->attr.exclude_guest)
+		return -EINVAL;
+
+	if (event->cpu < 0)
+		return -EINVAL;
+
+	perf_iommu = &__perf_iommu;
+
+	if (event->pmu != &perf_iommu->pmu)
+		return -ENOENT;
+
+	if (perf_iommu) {
+		config = event->attr.config;
+		config1 = event->attr.config1;
+	} else {
+		return -EINVAL;
+	}
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
+static void perf_iommu_enable_event(struct perf_event *ev)
+{
+	u8 csource = _GET_CSOURCE(ev);
+	u16 devid = _GET_DEVID(ev);
+	u64 reg = 0ULL;
+
+	reg = csource;
+	amd_iommu_pc_get_set_reg_val(devid,
+			_GET_BANK(ev), _GET_CNTR(ev) ,
+			 IOMMU_PC_COUNTER_SRC_REG, &reg, true);
+
+	reg = 0ULL | devid | (_GET_DEVID_MASK(ev) << 32);
+	if (reg)
+		reg |= (1UL << 31);
+	amd_iommu_pc_get_set_reg_val(devid,
+			_GET_BANK(ev), _GET_CNTR(ev) ,
+			 IOMMU_PC_DEVID_MATCH_REG, &reg, true);
+
+	reg = 0ULL | _GET_PASID(ev) | (_GET_PASID_MASK(ev) << 32);
+	if (reg)
+		reg |= (1UL << 31);
+	amd_iommu_pc_get_set_reg_val(devid,
+			_GET_BANK(ev), _GET_CNTR(ev) ,
+			 IOMMU_PC_PASID_MATCH_REG, &reg, true);
+
+	reg = 0ULL | _GET_DOMID(ev) | (_GET_DOMID_MASK(ev) << 32);
+	if (reg)
+		reg |= (1UL << 31);
+	amd_iommu_pc_get_set_reg_val(devid,
+			_GET_BANK(ev), _GET_CNTR(ev) ,
+			 IOMMU_PC_DOMID_MATCH_REG, &reg, true);
+}
+
+static void perf_iommu_disable_event(struct perf_event *event)
+{
+	u64 reg = 0ULL;
+
+	amd_iommu_pc_get_set_reg_val(_GET_DEVID(event),
+			_GET_BANK(event), _GET_CNTR(event),
+			IOMMU_PC_COUNTER_SRC_REG, &reg, true);
+}
+
+static void perf_iommu_start(struct perf_event *event, int flags)
+{
+	struct hw_perf_event *hwc = &event->hw;
+
+	pr_debug("perf: amd_iommu:perf_iommu_start\n");
+	if (WARN_ON_ONCE(!(hwc->state & PERF_HES_STOPPED)))
+		return;
+
+	WARN_ON_ONCE(!(hwc->state & PERF_HES_UPTODATE));
+	hwc->state = 0;
+
+	if (flags & PERF_EF_RELOAD) {
+		u64 prev_raw_count =  local64_read(&hwc->prev_count);
+		amd_iommu_pc_get_set_reg_val(_GET_DEVID(event),
+				_GET_BANK(event), _GET_CNTR(event),
+				IOMMU_PC_COUNTER_REG, &prev_raw_count, true);
+	}
+
+	perf_iommu_enable_event(event);
+	perf_event_update_userpage(event);
+
+}
+
+static void perf_iommu_read(struct perf_event *event)
+{
+	u64 count = 0ULL;
+	u64 prev_raw_count = 0ULL;
+	u64 delta = 0ULL;
+	struct hw_perf_event *hwc = &event->hw;
+	pr_debug("perf: amd_iommu:perf_iommu_read\n");
+
+	amd_iommu_pc_get_set_reg_val(_GET_DEVID(event),
+				_GET_BANK(event), _GET_CNTR(event),
+				IOMMU_PC_COUNTER_REG, &count, false);
+
+	/* IOMMU pc counter register is only 48 bits */
+	count &= 0xFFFFFFFFFFFFULL;
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
+static void perf_iommu_stop(struct perf_event *event, int flags)
+{
+	struct hw_perf_event *hwc = &event->hw;
+	u64 config;
+
+	pr_debug("perf: amd_iommu:perf_iommu_stop\n");
+
+	if (hwc->state & PERF_HES_UPTODATE)
+		return;
+
+	perf_iommu_disable_event(event);
+	WARN_ON_ONCE(hwc->state & PERF_HES_STOPPED);
+	hwc->state |= PERF_HES_STOPPED;
+
+	if (hwc->state & PERF_HES_UPTODATE)
+		return;
+
+	config = hwc->config;
+	perf_iommu_read(event);
+	hwc->state |= PERF_HES_UPTODATE;
+}
+
+static int perf_iommu_add(struct perf_event *event, int flags)
+{
+	int retval;
+	struct perf_amd_iommu *perf_iommu =
+			container_of(event->pmu, struct perf_amd_iommu, pmu);
+
+	pr_debug("perf: amd_iommu:perf_iommu_add\n");
+	event->hw.state = PERF_HES_UPTODATE | PERF_HES_STOPPED;
+
+	/* request an iommu bank/counter */
+	retval = get_next_avail_iommu_bnk_cntr(perf_iommu);
+	if (retval != -ENOSPC)
+		event->hw.extra_reg.reg = (u16)retval;
+	else
+		return retval;
+
+	if (flags & PERF_EF_START)
+		perf_iommu_start(event, PERF_EF_RELOAD);
+
+	return 0;
+}
+
+static void perf_iommu_del(struct perf_event *event, int flags)
+{
+	struct perf_amd_iommu *perf_iommu =
+			container_of(event->pmu, struct perf_amd_iommu, pmu);
+
+	pr_debug("perf: amd_iommu:perf_iommu_del\n");
+	perf_iommu_stop(event, PERF_EF_UPDATE);
+
+	/* clear the assigned iommu bank/counter */
+	clear_avail_iommu_bnk_cntr(perf_iommu,
+				     _GET_BANK(event),
+				     _GET_CNTR(event));
+
+	perf_event_update_userpage(event);
+}
+
+static __init int _init_events_attrs(struct perf_amd_iommu *perf_iommu)
+{
+	struct attribute **attrs;
+	struct attribute_group *attr_group;
+	int i = 0, j;
+
+	while (amd_iommu_v2_event_descs[i].attr.attr.name)
+		i++;
+
+	attr_group = kzalloc(sizeof(struct attribute *)
+		* (i + 1) + sizeof(*attr_group), GFP_KERNEL);
+	if (!attr_group)
+		return -ENOMEM;
+
+	attrs = (struct attribute **)(attr_group + 1);
+	for (j = 0; j < i; j++)
+		attrs[j] = &amd_iommu_v2_event_descs[j].attr.attr;
+
+	attr_group->name = "events";
+	attr_group->attrs = attrs;
+	perf_iommu->events_group = attr_group;
+
+	return 0;
+}
+
+static __init void amd_iommu_pc_exit(void)
+{
+	if (__perf_iommu.events_group != NULL) {
+		kfree(__perf_iommu.events_group);
+		__perf_iommu.events_group = NULL;
+	}
+}
+
+static __init int _init_perf_amd_iommu(
+	struct perf_amd_iommu *perf_iommu, char *name)
+{
+	int ret;
+
+	raw_spin_lock_init(&perf_iommu->lock);
+
+	/* Init format attributes */
+	perf_iommu->format_group = &amd_iommu_format_group;
+
+	/* Init cpumask attributes to only core 0 */
+	cpumask_set_cpu(0, &iommu_cpumask);
+	perf_iommu->cpumask_group = &amd_iommu_cpumask_group;
+
+	/* Init events attributes */
+	if (_init_events_attrs(perf_iommu) != 0)
+		pr_err("perf: amd_iommu: Only support raw events.\n");
+
+	/* Init null attributes */
+	perf_iommu->null_group = NULL;
+	perf_iommu->pmu.attr_groups = perf_iommu->attr_groups;
+
+	ret = perf_pmu_register(&perf_iommu->pmu, name, -1);
+	if (ret) {
+		pr_err("perf: amd_iommu: Failed to initialized.\n");
+		amd_iommu_pc_exit();
+	} else {
+		pr_info("perf: amd_iommu: Detected. (%d banks, %d counters/bank)\n",
+			amd_iommu_pc_get_max_banks(IOMMU_BASE_DEVID),
+			amd_iommu_pc_get_max_counters(IOMMU_BASE_DEVID));
+	}
+
+	return ret;
+}
+
+static struct perf_amd_iommu __perf_iommu = {
+	.pmu = {
+		.event_init	= perf_iommu_event_init,
+		.add		= perf_iommu_add,
+		.del		= perf_iommu_del,
+		.start		= perf_iommu_start,
+		.stop		= perf_iommu_stop,
+		.read		= perf_iommu_read,
+	},
+	.max_banks		= 0x00,
+	.max_counters		= 0x00,
+	.cntr_assign_mask	= 0ULL,
+	.format_group		= NULL,
+	.cpumask_group		= NULL,
+	.events_group		= NULL,
+	.null_group		= NULL,
+};
+
+static __init int amd_iommu_pc_init(void)
+{
+	/* Make sure the IOMMU PC resource is available */
+	if (!amd_iommu_pc_supported()) {
+		pr_err("perf: amd_iommu PMU not installed. No support!\n");
+		return -ENODEV;
+	}
+
+	_init_perf_amd_iommu(&__perf_iommu, "amd_iommu");
+
+	return 0;
+}
+
+device_initcall(amd_iommu_pc_init);
diff --git a/arch/x86/kernel/cpu/perf_event_amd_iommu.h b/arch/x86/kernel/cpu/perf_event_amd_iommu.h
new file mode 100644
index 0000000..845d173
--- /dev/null
+++ b/arch/x86/kernel/cpu/perf_event_amd_iommu.h
@@ -0,0 +1,40 @@
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
+#define IOMMU_PC_DOMID_MATCH_REG		0x18
+#define IOMMU_PC_DEVID_MATCH_REG		0x20
+#define IOMMU_PC_COUNTER_REPORT_REG		0x28
+
+/* maximun specified bank/counters */
+#define PC_MAX_SPEC_BNKS			64
+#define PC_MAX_SPEC_CNTRS			16
+
+/* iommu pc reg masks*/
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
+			u8 fxn, u64 *value, bool is_write);
+
+#endif /*_PERF_EVENT_AMD_IOMMU_H_*/
-- 
1.7.10.4


