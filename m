Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756051Ab3HMG3v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 02:29:51 -0400
Received: from mga03.intel.com ([143.182.124.21]:4062 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755925Ab3HMG3t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 02:29:49 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,867,1367996400"; 
   d="scan'208";a="345514415"
From: "Yan, Zheng" <zheng.z.yan@intel.com>
To: linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, eranian@google.com, ak@linux.intel.com,
        "Yan, Zheng" <zheng.z.yan@intel.com>
Subject: [PATCH 2/3] perf, uncore: add filter support for QPI boxes
Date: Tue, 13 Aug 2013 14:29:41 +0800
Message-Id: <1376375382-21350-3-git-send-email-zheng.z.yan@intel.com>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1376375382-21350-1-git-send-email-zheng.z.yan@intel.com>
References: <1376375382-21350-1-git-send-email-zheng.z.yan@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Yan, Zheng" <zheng.z.yan@intel.com>

The QPI uncore boxes have two pairs of MATCH/MASK registers that
used to filter packet traffic serviced by QPI link layer. These
registers are in auxiliary PCI devices.

This patch adds the auxiliary PCI devices to snbep_uncore_pci_ids
and adds field definitions for the MATCH/MASK registers.

Signed-off-by: Yan, Zheng <zheng.z.yan@intel.com>
---
 arch/x86/kernel/cpu/perf_event_intel_uncore.c | 139 ++++++++++++++++++++++----
 arch/x86/kernel/cpu/perf_event_intel_uncore.h |   2 +-
 2 files changed, 123 insertions(+), 18 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_intel_uncore.c b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
index 7ce9b35..6b8b9c9 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_uncore.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
@@ -47,6 +47,24 @@ DEFINE_UNCORE_FORMAT_ATTR(filter_band0, filter_band0, "config1:0-7");
 DEFINE_UNCORE_FORMAT_ATTR(filter_band1, filter_band1, "config1:8-15");
 DEFINE_UNCORE_FORMAT_ATTR(filter_band2, filter_band2, "config1:16-23");
 DEFINE_UNCORE_FORMAT_ATTR(filter_band3, filter_band3, "config1:24-31");
+DEFINE_UNCORE_FORMAT_ATTR(match_rds, match_rds, "config1:48-51");
+DEFINE_UNCORE_FORMAT_ATTR(match_rnid30, match_rnid30, "config1:32-35");
+DEFINE_UNCORE_FORMAT_ATTR(match_rnid4, match_rnid4, "config1:31");
+DEFINE_UNCORE_FORMAT_ATTR(match_dnid, match_dnid, "config1:13-17");
+DEFINE_UNCORE_FORMAT_ATTR(match_mc, match_mc, "config1:9-12");
+DEFINE_UNCORE_FORMAT_ATTR(match_opc, match_opc, "config1:5-8");
+DEFINE_UNCORE_FORMAT_ATTR(match_vnw, match_vnw, "config1:3-4");
+DEFINE_UNCORE_FORMAT_ATTR(match0, match0, "config1:0-31");
+DEFINE_UNCORE_FORMAT_ATTR(match1, match1, "config1:32-63");
+DEFINE_UNCORE_FORMAT_ATTR(mask_rds, mask_rds, "config2:48-51");
+DEFINE_UNCORE_FORMAT_ATTR(mask_rnid30, mask_rnid30, "config2:32-35");
+DEFINE_UNCORE_FORMAT_ATTR(mask_rnid4, mask_rnid4, "config2:31");
+DEFINE_UNCORE_FORMAT_ATTR(mask_dnid, mask_dnid, "config2:13-17");
+DEFINE_UNCORE_FORMAT_ATTR(mask_mc, mask_mc, "config2:9-12");
+DEFINE_UNCORE_FORMAT_ATTR(mask_opc, mask_opc, "config2:5-8");
+DEFINE_UNCORE_FORMAT_ATTR(mask_vnw, mask_vnw, "config2:3-4");
+DEFINE_UNCORE_FORMAT_ATTR(mask0, mask0, "config2:0-31");
+DEFINE_UNCORE_FORMAT_ATTR(mask1, mask1, "config2:32-63");
 
 static u64 uncore_msr_read_counter(struct intel_uncore_box *box, struct perf_event *event)
 {
@@ -303,6 +321,24 @@ static struct attribute *snbep_uncore_qpi_formats_attr[] = {
 	&format_attr_edge.attr,
 	&format_attr_inv.attr,
 	&format_attr_thresh8.attr,
+	&format_attr_match_rds.attr,
+	&format_attr_match_rnid30.attr,
+	&format_attr_match_rnid4.attr,
+	&format_attr_match_dnid.attr,
+	&format_attr_match_mc.attr,
+	&format_attr_match_opc.attr,
+	&format_attr_match_vnw.attr,
+	&format_attr_match0.attr,
+	&format_attr_match1.attr,
+	&format_attr_mask_rds.attr,
+	&format_attr_mask_rnid30.attr,
+	&format_attr_mask_rnid4.attr,
+	&format_attr_mask_dnid.attr,
+	&format_attr_mask_mc.attr,
+	&format_attr_mask_opc.attr,
+	&format_attr_mask_vnw.attr,
+	&format_attr_mask0.attr,
+	&format_attr_mask1.attr,
 	NULL,
 };
 
@@ -358,13 +394,16 @@ static struct intel_uncore_ops snbep_uncore_msr_ops = {
 	SNBEP_UNCORE_MSR_OPS_COMMON_INIT(),
 };
 
+#define SNBEP_UNCORE_PCI_OPS_COMMON_INIT()			\
+	.init_box	= snbep_uncore_pci_init_box,		\
+	.disable_box	= snbep_uncore_pci_disable_box,		\
+	.enable_box	= snbep_uncore_pci_enable_box,		\
+	.disable_event	= snbep_uncore_pci_disable_event,	\
+	.read_counter	= snbep_uncore_pci_read_counter
+
 static struct intel_uncore_ops snbep_uncore_pci_ops = {
-	.init_box	= snbep_uncore_pci_init_box,
-	.disable_box	= snbep_uncore_pci_disable_box,
-	.enable_box	= snbep_uncore_pci_enable_box,
-	.disable_event	= snbep_uncore_pci_disable_event,
-	.enable_event	= snbep_uncore_pci_enable_event,
-	.read_counter	= snbep_uncore_pci_read_counter,
+	SNBEP_UNCORE_PCI_OPS_COMMON_INIT(),
+	.enable_event	= snbep_uncore_pci_enable_event,	\
 };
 
 static struct event_constraint snbep_uncore_cbox_constraints[] = {
@@ -728,6 +767,61 @@ static struct intel_uncore_type *snbep_msr_uncores[] = {
 	NULL,
 };
 
+enum {
+	SNBEP_PCI_QPI_PORT0_FILTER,
+	SNBEP_PCI_QPI_PORT1_FILTER,
+};
+
+static int snbep_qpi_hw_config(struct intel_uncore_box *box, struct perf_event *event)
+{
+	struct hw_perf_event *hwc = &event->hw;
+	struct hw_perf_event_extra *reg1 = &hwc->extra_reg;
+	struct hw_perf_event_extra *reg2 = &hwc->branch_reg;
+
+	if ((hwc->config & SNBEP_PMON_CTL_EV_SEL_MASK) == 0x38) {
+		reg1->idx = 0;
+		reg1->reg = SNBEP_Q_Py_PCI_PMON_PKT_MATCH0;
+		reg1->config = event->attr.config1;
+		reg2->reg = SNBEP_Q_Py_PCI_PMON_PKT_MASK0;
+		reg2->config = event->attr.config2;
+	}
+	return 0;
+}
+
+static void snbep_qpi_enable_event(struct intel_uncore_box *box, struct perf_event *event)
+{
+	struct pci_dev *pdev = box->pci_dev;
+	struct hw_perf_event *hwc = &event->hw;
+	struct hw_perf_event_extra *reg1 = &hwc->extra_reg;
+	struct hw_perf_event_extra *reg2 = &hwc->branch_reg;
+
+	if (reg1->idx != EXTRA_REG_NONE) {
+		int idx = box->pmu->pmu_idx + SNBEP_PCI_QPI_PORT0_FILTER;
+		struct pci_dev *filter_pdev = extra_pci_dev[box->phys_id][idx];
+		WARN_ON_ONCE(!filter_pdev);
+		if (filter_pdev) {
+			pci_write_config_dword(filter_pdev, reg1->reg,
+						(u32)reg1->config);
+			pci_write_config_dword(filter_pdev, reg1->reg + 4,
+						(u32)(reg1->config >> 32));
+			pci_write_config_dword(filter_pdev, reg2->reg,
+						(u32)reg2->config);
+			pci_write_config_dword(filter_pdev, reg2->reg + 4,
+						(u32)(reg2->config >> 32));
+		}
+	}
+
+	pci_write_config_dword(pdev, hwc->config_base, hwc->config | SNBEP_PMON_CTL_EN);
+}
+
+static struct intel_uncore_ops snbep_uncore_qpi_ops = {
+	SNBEP_UNCORE_PCI_OPS_COMMON_INIT(),
+	.enable_event		= snbep_qpi_enable_event,
+	.hw_config		= snbep_qpi_hw_config,
+	.get_constraint		= uncore_get_constraint,
+	.put_constraint		= uncore_put_constraint,
+};
+
 #define SNBEP_UNCORE_PCI_COMMON_INIT()				\
 	.perf_ctr	= SNBEP_PCI_PMON_CTR0,			\
 	.event_ctl	= SNBEP_PCI_PMON_CTL0,			\
@@ -757,17 +851,18 @@ static struct intel_uncore_type snbep_uncore_imc = {
 };
 
 static struct intel_uncore_type snbep_uncore_qpi = {
-	.name		= "qpi",
-	.num_counters   = 4,
-	.num_boxes	= 2,
-	.perf_ctr_bits	= 48,
-	.perf_ctr	= SNBEP_PCI_PMON_CTR0,
-	.event_ctl	= SNBEP_PCI_PMON_CTL0,
-	.event_mask	= SNBEP_QPI_PCI_PMON_RAW_EVENT_MASK,
-	.box_ctl	= SNBEP_PCI_PMON_BOX_CTL,
-	.ops		= &snbep_uncore_pci_ops,
-	.event_descs	= snbep_uncore_qpi_events,
-	.format_group	= &snbep_uncore_qpi_format_group,
+	.name			= "qpi",
+	.num_counters		= 4,
+	.num_boxes		= 2,
+	.perf_ctr_bits		= 48,
+	.perf_ctr		= SNBEP_PCI_PMON_CTR0,
+	.event_ctl		= SNBEP_PCI_PMON_CTL0,
+	.event_mask		= SNBEP_QPI_PCI_PMON_RAW_EVENT_MASK,
+	.box_ctl		= SNBEP_PCI_PMON_BOX_CTL,
+	.num_shared_regs	= 1,
+	.ops			= &snbep_uncore_qpi_ops,
+	.event_descs		= snbep_uncore_qpi_events,
+	.format_group		= &snbep_uncore_qpi_format_group,
 };
 
 
@@ -847,6 +942,16 @@ static DEFINE_PCI_DEVICE_TABLE(snbep_uncore_pci_ids) = {
 		PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_UNC_R3QPI1),
 		.driver_data = UNCORE_PCI_DEV_DATA(SNBEP_PCI_UNCORE_R3QPI, 1),
 	},
+	{ /* QPI Port 0 filter  */
+		PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0x3c86),
+		.driver_data = UNCORE_PCI_DEV_DATA(UNCORE_EXTRA_PCI_DEV,
+						   SNBEP_PCI_QPI_PORT0_FILTER),
+	},
+	{ /* QPI Port 0 filter  */
+		PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0x3c96),
+		.driver_data = UNCORE_PCI_DEV_DATA(UNCORE_EXTRA_PCI_DEV,
+						   SNBEP_PCI_QPI_PORT1_FILTER),
+	},
 	{ /* end: all zeroes */ }
 };
 
diff --git a/arch/x86/kernel/cpu/perf_event_intel_uncore.h b/arch/x86/kernel/cpu/perf_event_intel_uncore.h
index ede5a8c..628500e 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_uncore.h
+++ b/arch/x86/kernel/cpu/perf_event_intel_uncore.h
@@ -16,7 +16,7 @@
 #define UNCORE_PCI_DEV_TYPE(data)	((data >> 8) & 0xff)
 #define UNCORE_PCI_DEV_IDX(data)	(data & 0xff)
 #define UNCORE_EXTRA_PCI_DEV		0xff
-#define UNCORE_EXTRA_PCI_DEV_MAX	0
+#define UNCORE_EXTRA_PCI_DEV_MAX	2
 
 /* support up to 8 sockets */
 #define UNCORE_SOCKET_MAX		8
-- 
1.8.1.4

