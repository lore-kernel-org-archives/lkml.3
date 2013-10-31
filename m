Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752212Ab3JaFhB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Oct 2013 01:37:01 -0400
Received: from mga02.intel.com ([134.134.136.20]:25166 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750762Ab3JaFhA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Oct 2013 01:37:00 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,535,1378882800"; 
   d="scan'208";a="401351326"
From: "Yan, Zheng" <zheng.z.yan@intel.com>
To: linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, ak@linux.intel.com, eranian@google.com,
        "Yan, Zheng" <zheng.z.yan@intel.com>
Subject: [PATCH 1/2] perf/x86/intel/uncore: Add filter support for IvyBridge-EP QPI boxes
Date: Thu, 31 Oct 2013 13:36:54 +0800
Message-Id: <1383197815-17706-1-git-send-email-zheng.z.yan@intel.com>
X-Mailer: git-send-email 1.8.1.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Yan, Zheng" <zheng.z.yan@intel.com>

The encoding for filter registers of IvyBridge-EP uncore QPI boxes is
completely the same as SandyBridge-EP.

Signed-off-by: Yan, Zheng <zheng.z.yan@intel.com>
---
 arch/x86/kernel/cpu/perf_event_intel_uncore.c | 61 ++++++++++++++++++++++-----
 1 file changed, 51 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_intel_uncore.c b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
index 4118f9f..6da3999 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_uncore.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
@@ -1099,6 +1099,24 @@ static struct attribute *ivt_uncore_qpi_formats_attr[] = {
 	&format_attr_umask.attr,
 	&format_attr_edge.attr,
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
 
@@ -1312,17 +1330,30 @@ static struct intel_uncore_type ivt_uncore_imc = {
 	IVT_UNCORE_PCI_COMMON_INIT(),
 };
 
+static struct intel_uncore_ops ivt_uncore_qpi_ops = {
+	.init_box	= ivt_uncore_pci_init_box,
+	.disable_box	= snbep_uncore_pci_disable_box,
+	.enable_box	= snbep_uncore_pci_enable_box,
+	.disable_event	= snbep_uncore_pci_disable_event,
+	.enable_event	= snbep_qpi_enable_event,
+	.read_counter	= snbep_uncore_pci_read_counter,
+	.hw_config	= snbep_qpi_hw_config,
+	.get_constraint	= uncore_get_constraint,
+	.put_constraint	= uncore_put_constraint,
+};
+
 static struct intel_uncore_type ivt_uncore_qpi = {
-	.name		= "qpi",
-	.num_counters   = 4,
-	.num_boxes	= 3,
-	.perf_ctr_bits	= 48,
-	.perf_ctr	= SNBEP_PCI_PMON_CTR0,
-	.event_ctl	= SNBEP_PCI_PMON_CTL0,
-	.event_mask	= IVT_QPI_PCI_PMON_RAW_EVENT_MASK,
-	.box_ctl	= SNBEP_PCI_PMON_BOX_CTL,
-	.ops		= &ivt_uncore_pci_ops,
-	.format_group	= &ivt_uncore_qpi_format_group,
+	.name			= "qpi",
+	.num_counters		= 4,
+	.num_boxes		= 3,
+	.perf_ctr_bits		= 48,
+	.perf_ctr		= SNBEP_PCI_PMON_CTR0,
+	.event_ctl		= SNBEP_PCI_PMON_CTL0,
+	.event_mask		= IVT_QPI_PCI_PMON_RAW_EVENT_MASK,
+	.box_ctl		= SNBEP_PCI_PMON_BOX_CTL,
+	.num_shared_regs	= 1,
+	.ops			= &ivt_uncore_qpi_ops,
+	.format_group		= &ivt_uncore_qpi_format_group,
 };
 
 static struct intel_uncore_type ivt_uncore_r2pcie = {
@@ -1429,6 +1460,16 @@ static DEFINE_PCI_DEVICE_TABLE(ivt_uncore_pci_ids) = {
 		PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0xe3e),
 		.driver_data = UNCORE_PCI_DEV_DATA(IVT_PCI_UNCORE_R3QPI, 2),
 	},
+	{ /* QPI Port 0 filter  */
+		PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0xe86),
+		.driver_data = UNCORE_PCI_DEV_DATA(UNCORE_EXTRA_PCI_DEV,
+						   SNBEP_PCI_QPI_PORT0_FILTER),
+	},
+	{ /* QPI Port 0 filter  */
+		PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0xe96),
+		.driver_data = UNCORE_PCI_DEV_DATA(UNCORE_EXTRA_PCI_DEV,
+						   SNBEP_PCI_QPI_PORT1_FILTER),
+	},
 	{ /* end: all zeroes */ }
 };
 
-- 
1.8.1.4

