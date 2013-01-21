Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756626Ab3AUUV3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 15:21:29 -0500
Received: from co9ehsobe005.messaging.microsoft.com ([207.46.163.28]:41601
	"EHLO co9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752797Ab3AUUV0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 15:21:26 -0500
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VPS0(zzzz1ee6h1de0h1202h1e76h1d1ah1d2ahzz84d07h8275bhz2dh668h839hd24he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1155h)
X-WSS-ID: 0MGZSJI-01-3FU-02
X-M-MSG: 
From: "Steven L. Kinney" <steven.kinney@amd.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, <x86@kernel.org>,
        Joerg Roedel <joro@8bytes.org>
CC: Bjorn Helgaas <bhelgaas@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sebastian Andrzej Siewior <sebastian@breakpoint.cc>,
        Myron Stowe <myron.stowe@redhat.com>, Hiroshi DOYU <hdoyu@nvidia.com>,
        Stephen Warren <swarren@wwwdotorg.org>, Jiri Kosina <jkosina@suse.cz>,
        Kukjin Kim <kgene.kim@samsung.com>, <linux-kernel@vger.kernel.org>,
        <iommu@lists.linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Thomas Renninger <trenn@suse.de>, Andi Kleen <ak@linux.intel.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        "Steven L. Kinney" <steven.kinney@amd.com>
Subject: [PATCH 3/3] AMD IOMMUv2 PC perf PMU implementation
Date: Mon, 21 Jan 2013 14:20:58 -0600
Message-ID: <1358799658-6236-4-git-send-email-steven.kinney@amd.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1358799658-6236-1-git-send-email-steven.kinney@amd.com>
References: <1358799658-6236-1-git-send-email-steven.kinney@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Steven L. Kinney" <steven.kinney@amd.com>

Implement a perf PMU to handle IOMMUv2 PC perf events.  This PMU will handle
static counter perf events relative to the AMD IOMMUv2 Performance Counters.

To invoke the AMD IOMMUv2 PMU issue a perf tool command such as:

./perf stat -e iommuv2/config=<config-data>,config1=<config1-data>/u <command>

For example:

./perf stat -e iommuv2/config=08000000000000005,config1=0/u <command>

The resulting count will be how many IOMMUv2 totsal peripheral memory
operations were performed during the command execution window.

Signed-off-by: Steven L. Kinney <steven.kinney@amd.com>
---
 arch/x86/kernel/cpu/Makefile                 |    1 +
 arch/x86/kernel/cpu/perf_event_amd_iommuv2.c |  429 ++++++++++++++++++++++++++
 arch/x86/kernel/cpu/perf_event_amd_iommuv2.h |   42 +++
 3 files changed, 472 insertions(+)
 create mode 100644 arch/x86/kernel/cpu/perf_event_amd_iommuv2.c
 create mode 100644 arch/x86/kernel/cpu/perf_event_amd_iommuv2.h

diff --git a/arch/x86/kernel/cpu/Makefile b/arch/x86/kernel/cpu/Makefile
index a0e067d..4872b99 100644
--- a/arch/x86/kernel/cpu/Makefile
+++ b/arch/x86/kernel/cpu/Makefile
@@ -32,6 +32,7 @@ obj-$(CONFIG_PERF_EVENTS)		+= perf_event.o
 
 ifdef CONFIG_PERF_EVENTS
 obj-$(CONFIG_CPU_SUP_AMD)		+= perf_event_amd.o
+obj-$(CONFIG_AMD_IOMMU_V2_PC)           += perf_event_amd_iommuv2.o
 obj-$(CONFIG_CPU_SUP_INTEL)		+= perf_event_p6.o perf_event_knc.o perf_event_p4.o
 obj-$(CONFIG_CPU_SUP_INTEL)		+= perf_event_intel_lbr.o perf_event_intel_ds.o perf_event_intel.o
 obj-$(CONFIG_CPU_SUP_INTEL)		+= perf_event_intel_uncore.o
diff --git a/arch/x86/kernel/cpu/perf_event_amd_iommuv2.c b/arch/x86/kernel/cpu/perf_event_amd_iommuv2.c
new file mode 100644
index 0000000..7c7b3ff
--- /dev/null
+++ b/arch/x86/kernel/cpu/perf_event_amd_iommuv2.c
@@ -0,0 +1,429 @@
+ /*
+ * Performance events - AMD IOMMUv2
+ *
+ * Copyright (x) 2012 Advanced Micro Devices, Inc., Steven Kinney
+ *
+ * For licensing details see kernel-base/COPYING
+ */
+#include <linux/perf_event.h>
+#include <linux/module.h>
+#include <linux/pci.h>
+#include <linux/ptrace.h>
+
+#include "perf_event.h"
+#include "perf_event_amd_iommuv2.h"
+
+static u64 cntr_assign_mask;
+
+#if defined(CONFIG_PERF_EVENTS) && defined(CONFIG_AMD_IOMMU_V2_PC)
+
+/* define iommuv2 states based on ibs, add states if needed */
+enum iommuv2_states {
+	IOMMU_V2_PC_ENABLED	= 0,
+	IOMMU_V2_PC_STARTED	= 1,
+	IOMMU_V2_PC_STOPPING	= 2,
+
+	IOMMU_V2_PC_MAX_STATES,
+};
+
+
+struct cpu_perf_iommuv2 {
+	struct perf_event	*event;
+	unsigned long		state[BITS_TO_LONGS(IOMMU_V2_PC_MAX_STATES)];
+};
+
+
+struct perf_iommuv2 {
+	struct pmu	pmu;
+	struct attribute **format_attrs;
+	struct attribute_group format_group;
+	const struct attribute_group *attr_groups[11];
+	u16		iommuv2_devid;
+	u8		max_banks;
+	u8		max_counters;
+
+	struct cpu_perf_iommuv2  __percpu *pcpu;
+};
+
+
+PMU_FORMAT_ATTR(iommuv2_raw, "config:63");
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
+static struct attribute *iommuv2_fetch_format_attrs[] = {
+	&format_attr_iommuv2_raw.attr,
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
+static struct perf_iommuv2 perf_iommuv2_fetch;
+
+
+static u64 read_iommu_v2_pc_icounter(u16 devid, u8 bank, u8 counter)
+{
+	long long val = 0;
+
+	/* modify to calculate pc offsets within this level */
+	amd_iommu_v2_get_set_pc_reg_val(devid,
+					bank,
+					counter,
+					IOMMUV2_PC_COUNTER_REG,
+					&val,
+					false);
+
+	return val;
+}
+
+
+static u16 get_next_avail_iommuv2_bnk_cntr(struct perf_iommuv2 *perf_iommuv2)
+{
+	int bank_index, cntr_index;
+	int max_banks, max_cntrs;
+	int shift = 0;
+	int bank_offset = 0;
+	u16 retval;
+
+	max_banks = perf_iommuv2->max_banks;
+	max_cntrs = perf_iommuv2->max_counters;
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
+static int clear_avail_iommuv2_bnk_cntr(struct perf_iommuv2 *perf_iommuv2,
+					u8 bank,
+					u8 cntr)
+{
+	int max_banks, max_cntrs;
+	int shift = 0;
+
+	max_banks = perf_iommuv2->max_banks;
+	max_cntrs = perf_iommuv2->max_counters;
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
+static int perf_iommuv2_init(struct perf_event *event)
+{
+	struct hw_perf_event *hwc = &event->hw;
+	struct perf_iommuv2 *perf_iommuv2;
+	u64 config, config1;
+
+	/* initialize the cntr_assign_mask */
+	cntr_assign_mask = 0;
+
+	/* test the event attr type check for PMU enumeration */
+	if (event->attr.type != event->pmu->type)
+		return -ENOENT;
+
+	perf_iommuv2 = &perf_iommuv2_fetch;
+
+	if (perf_iommuv2) {
+		config = event->attr.config;
+		config1 = event->attr.config1;
+	} else
+		return -EINVAL;
+
+	if (event->pmu != &perf_iommuv2->pmu)
+		return -ENOENT;
+
+	/* make sure the event->attr.config is raw (vendor specific) */
+	if (!(config & IOMMU_V2_PC_RAW_CONFIG_MASK))
+		return -EINVAL;
+
+	/* integrate with iommu base devid (0000), assume one iommu */
+	perf_iommuv2->max_banks =
+		amd_iommu_v2_get_max_pc_banks(IOMMU_V2_BASE_DEVID);
+	perf_iommuv2->max_counters =
+		amd_iommu_v2_get_max_pc_counters(IOMMU_V2_BASE_DEVID);
+
+	/* update the hw_perf_event struct with the iommuv2 config data */
+	hwc->config = config;
+	hwc->extra_reg.config = config1;
+
+	return 0;
+}
+
+
+static void perf_iommuv2_event_update(struct perf_event *event, u64 *config,
+				      u16 *bank_cntr)
+{
+	u64 count;
+	u16 devid;
+	u8  bank, cntr;
+	u64 prev_raw_count;
+	u64 delta;
+	struct hw_perf_event *hwc = &event->hw;
+
+	devid = (u16)(*config & IOMMU_V2_PC_DEVICEID_MATCH)>>8;
+	bank  = (u8)*bank_cntr >> 8;
+	cntr  = (u8)*bank_cntr;
+
+	count = read_iommu_v2_pc_icounter(devid, bank, cntr);
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
+static void perf_iommuv2_enable_event(struct hw_perf_event *hwc)
+{
+	u16 devid;
+	u8  bank, cntr, csource;
+	long long val;
+
+	devid   = (u16)(hwc->config & IOMMU_V2_PC_DEVICEID_MATCH)>>8;
+	bank    = (u8)hwc->extra_reg.reg >> 8;
+	cntr    = (u8)hwc->extra_reg.reg;
+	csource = (u8)(hwc->config & IOMMU_V2_PC_CSOURCE);
+
+	val = csource;
+
+	amd_iommu_v2_get_set_pc_reg_val(devid,
+					 bank,
+					 cntr,
+					 IOMMUV2_PC_COUNTER_SRC_REG,
+					 &val,
+					 true);
+}
+
+
+static void perf_iommuv2_disable_event(struct hw_perf_event *hwc)
+{
+	u16 devid;
+	u8  bank, cntr;
+	long long val;
+
+	devid = (u16)(hwc->config & IOMMU_V2_PC_DEVICEID_MATCH)>>8;
+	bank  = (u8)hwc->extra_reg.reg>>8;
+	cntr  = (u8)hwc->extra_reg.reg;
+
+	val = PC_CSOURCE_DISABLE_CNT;
+
+	amd_iommu_v2_get_set_pc_reg_val(devid,
+					 bank,
+					 cntr,
+					 IOMMUV2_PC_COUNTER_SRC_REG,
+					 &val,
+					 true);
+}
+
+
+static void perf_iommuv2_start(struct perf_event *event, int flags)
+{
+	struct hw_perf_event *hwc = &event->hw;
+	struct perf_iommuv2 *perf_iommuv2 =
+			container_of(event->pmu, struct perf_iommuv2, pmu);
+	struct cpu_perf_iommuv2 *pcpu = this_cpu_ptr(perf_iommuv2->pcpu);
+
+	if (WARN_ON_ONCE(!(hwc->state & PERF_HES_STOPPED)))
+		return;
+
+	WARN_ON_ONCE(!(hwc->state & PERF_HES_UPTODATE));
+	hwc->state = 0;
+
+	set_bit(IOMMU_V2_PC_STARTED, pcpu->state);
+	perf_iommuv2_enable_event(hwc);
+	perf_event_update_userpage(event);
+}
+
+
+static void perf_iommuv2_stop(struct perf_event *event, int flags)
+{
+	struct hw_perf_event *hwc = &event->hw;
+	struct perf_iommuv2 *perf_iommuv2 =
+			container_of(event->pmu, struct perf_iommuv2, pmu);
+	struct cpu_perf_iommuv2 *pcpu = this_cpu_ptr(perf_iommuv2->pcpu);
+	int stopping;
+	u16 bank_cntr;
+	u64 config;
+
+	stopping = test_and_clear_bit(IOMMU_V2_PC_STARTED, pcpu->state);
+
+	if (!stopping && (hwc->state & PERF_HES_UPTODATE))
+		return;
+
+	if (stopping) {
+		set_bit(IOMMU_V2_PC_STOPPING, pcpu->state);
+		perf_iommuv2_disable_event(hwc);
+		WARN_ON_ONCE(hwc->state & PERF_HES_STOPPED);
+		hwc->state |= PERF_HES_STOPPED;
+	}
+
+	if (hwc->state & PERF_HES_UPTODATE)
+		return;
+
+	config = hwc->config;
+	bank_cntr = (u16)hwc->extra_reg.reg;
+	perf_iommuv2_event_update(event, &config, &bank_cntr);
+	hwc->state |= PERF_HES_UPTODATE;
+}
+
+
+static int perf_iommuv2_add(struct perf_event *event, int flags)
+{
+	struct perf_iommuv2 *perf_iommuv2 =
+			container_of(event->pmu, struct perf_iommuv2, pmu);
+	struct cpu_perf_iommuv2 *pcpu = this_cpu_ptr(perf_iommuv2->pcpu);
+	u16 bank_cntr;
+
+	if (test_and_set_bit(IOMMU_V2_PC_ENABLED, pcpu->state))
+		return -ENOSPC;
+
+	event->hw.state = PERF_HES_UPTODATE | PERF_HES_STOPPED;
+
+	pcpu->event = event;
+
+	/* request an iommuv2 bank/counter */
+	bank_cntr = get_next_avail_iommuv2_bnk_cntr(perf_iommuv2);
+	event->hw.extra_reg.reg = bank_cntr;
+
+	if (flags & PERF_EF_START)
+		perf_iommuv2_start(event, PERF_EF_RELOAD);
+
+	return 0;
+}
+
+
+static void perf_iommuv2_del(struct perf_event *event, int flags)
+{
+	struct perf_iommuv2 *perf_iommuv2 =
+			container_of(event->pmu, struct perf_iommuv2, pmu);
+	struct cpu_perf_iommuv2 *pcpu = this_cpu_ptr(perf_iommuv2->pcpu);
+	u8 bank, cntr;
+
+	if (!test_and_clear_bit(IOMMU_V2_PC_ENABLED, pcpu->state))
+		return;
+
+	perf_iommuv2_stop(event, PERF_EF_UPDATE);
+
+	/* clear the assigned iommuv2 bank/counter */
+	bank = (u8)event->hw.extra_reg.reg >> 8;
+	cntr = (u8)event->hw.extra_reg.reg;
+	clear_avail_iommuv2_bnk_cntr(perf_iommuv2,
+				     bank,
+				     cntr);
+	pcpu->event = NULL;
+
+	perf_event_update_userpage(event);
+}
+
+
+static void perf_iommuv2_read(struct perf_event *event)
+{
+	pr_debug("AMD IOMMUv2: perf_iommuv2_read called\n");
+}
+
+
+static struct perf_iommuv2 perf_iommuv2_fetch = {
+	.pmu = {
+		.event_init	= perf_iommuv2_init,
+		.add		= perf_iommuv2_add,
+		.del		= perf_iommuv2_del,
+		.start		= perf_iommuv2_start,
+		.stop		= perf_iommuv2_stop,
+		.read		= perf_iommuv2_read,
+	},
+	.format_attrs		= iommuv2_fetch_format_attrs,
+	.max_banks		= 0x00,
+	.max_counters		= 0x00,
+};
+
+
+static __init int perf_iommuv2_pmu_init(struct perf_iommuv2 *perf_iommuv2,
+					char *name)
+{
+	struct cpu_perf_iommuv2 __percpu *pcpu;
+	int ret;
+
+	pcpu = alloc_percpu(struct cpu_perf_iommuv2);
+	if (!pcpu)
+		return -ENOMEM;
+
+	perf_iommuv2->pcpu = pcpu;
+
+	/* allocate and register atttributes */
+	if (perf_iommuv2->format_attrs[0]) {
+		memset(&perf_iommuv2->format_group, 0,
+			sizeof(perf_iommuv2->format_group));
+		perf_iommuv2->format_group.name = "format";
+		perf_iommuv2->format_group.attrs = perf_iommuv2->format_attrs;
+		memset(&perf_iommuv2->attr_groups, 0,
+			sizeof(perf_iommuv2->attr_groups));
+		perf_iommuv2->attr_groups[0] = &perf_iommuv2->format_group;
+		perf_iommuv2->pmu.attr_groups = perf_iommuv2->attr_groups;
+	}
+
+	ret = perf_pmu_register(&perf_iommuv2->pmu, name, -1);
+	if (ret) {
+		pr_info("AMD IOMMUv2 PMU - ERROR Registering IOMMUv2 Perf PMU\n");
+		perf_iommuv2->pcpu = NULL;
+		free_percpu(pcpu);
+	}
+
+	return ret;
+}
+
+static __init int amd_iommuv2_init(void)
+{
+	/* Make sure the IOMMUv2 PC resource is available */
+	if (!amd_iommu_v2_pc_supported()) {
+		pr_info("Perf IOMMUv2 - PMU not installed no support!\n");
+		return -ENODEV;
+	}
+
+	perf_iommuv2_pmu_init(&perf_iommuv2_fetch, "iommuv2");
+
+	return 0;
+}
+
+device_initcall(amd_iommuv2_init);
+#endif
diff --git a/arch/x86/kernel/cpu/perf_event_amd_iommuv2.h b/arch/x86/kernel/cpu/perf_event_amd_iommuv2.h
new file mode 100644
index 0000000..10d341e
--- /dev/null
+++ b/arch/x86/kernel/cpu/perf_event_amd_iommuv2.h
@@ -0,0 +1,42 @@
+
+/* iommuv2 pc mmio region register indexes */
+#define IOMMUV2_PC_COUNTER_REG			0x00
+#define IOMMUV2_PC_COUNTER_SRC_REG		0x08
+#define IOMMUV2_PC_PASID_MATCH_REG		0x10
+#define IOMMUV2_PC_DOMAIN_MATCH_REG		0x18
+#define IOMMUV2_PC_DEVICEID_MATCH_REG		0x20
+#define IOMMUV2_PC_COUNTER_REPORT_REG		0x28
+
+/* iommuv2 pc csource register values */
+#define PC_CSOURCE_DISABLE_CNT			0x00
+
+/* maximun specified bank/counters */
+#define PC_MAX_SPEC_BNKS			64
+#define PC_MAX_SPEC_CNTRS			16
+
+/* iommuv2 pmu config masks */
+#define IOMMU_V2_PC_RAW_CONFIG_MASK		(1ULL << 63)
+#define IOMMU_V2_PC_CSOURCE			(0xFFULL << 0)
+#define IOMMU_V2_PC_DEVICEID_MATCH		(0xFFFFULL << 8)
+#define IOMMU_V2_PC_PASID_MATCH			(0xFFFFULL << 24)
+#define IOMMU_V2_PC_DOMAIN_MATCH		(0xFFFFULL << 40)
+#define IOMMU_V2_PC_EN_DEVICEID			(1ULL << 56)
+#define IOMMU_V2_PC_EN_PASID			(1ULL << 57)
+#define IOMMU_V2_PC_EN_DOMAIN			(1ULL << 58)
+#define IOMMU_V2_PC_DEVICEID_MASK		(0xFFFFULL << 0)
+#define IOMMU_V2_PC_PASID_MASK			(0xFFFFULL << 16)
+#define IOMMU_V2_PC_DOMAIN_MASK			(0xFFFFULL << 32)
+
+#define IOMMU_V2_BASE_DEVID			0x0000
+
+/* amd_iommu_init.c external support functions */
+extern bool amd_iommu_v2_pc_supported(void);
+extern u8 amd_iommu_v2_get_max_pc_banks(u16 devid);
+extern u8 amd_iommu_v2_get_max_pc_counters(u16 devid);
+extern int amd_iommu_v2_get_set_pc_reg_val(
+					u16 devid,
+					u8 bank,
+					u8 cntr,
+					u8 fxn,
+					long long *value,
+					bool is_write);
-- 
1.7.9.5


