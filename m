Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752689Ab3JaFhK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Oct 2013 01:37:10 -0400
Received: from mga02.intel.com ([134.134.136.20]:25166 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750762Ab3JaFhB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Oct 2013 01:37:01 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,535,1378882800"; 
   d="scan'208";a="401351350"
From: "Yan, Zheng" <zheng.z.yan@intel.com>
To: linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, ak@linux.intel.com, eranian@google.com,
        "Yan, Zheng" <zheng.z.yan@intel.com>
Subject: [PATCH 2/2] perf/x86/intel: Add Ivy Bridge-EP uncore IRP box support
Date: Thu, 31 Oct 2013 13:36:55 +0800
Message-Id: <1383197815-17706-2-git-send-email-zheng.z.yan@intel.com>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1383197815-17706-1-git-send-email-zheng.z.yan@intel.com>
References: <1383197815-17706-1-git-send-email-zheng.z.yan@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Yan, Zheng" <zheng.z.yan@intel.com>

Unlike other uncore boxes, IRP boxes live in PCI buses with no UBOX
device. For PCI bus without UBOX device, we find the next bus that
has UBOX device and use its 'bus to socket' mapping.

Besides the counter/control registers in IRP boxes are not properly
aligned

Signed-off-by: Yan, Zheng <zheng.z.yan@intel.com>
---
 arch/x86/kernel/cpu/perf_event_intel_uncore.c | 73 +++++++++++++++++++++++++++
 1 file changed, 73 insertions(+)

diff --git a/arch/x86/kernel/cpu/perf_event_intel_uncore.c b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
index 6da3999..29c2487 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_uncore.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
@@ -997,6 +997,20 @@ static int snbep_pci2phy_map_init(int devid)
 		}
 	}
 
+	if (!err) {
+		/*
+		 * For PCI bus with no UBOX device, find the next bus
+		 * that has UBOX device and use its mapping.
+		 */
+		i = -1;
+		for (bus = 255; bus >= 0; bus--) {
+			if (pcibus_to_physid[bus] >= 0)
+				i = pcibus_to_physid[bus];
+			else
+				pcibus_to_physid[bus] = i;
+		}
+	}
+
 	if (ubox_dev)
 		pci_dev_put(ubox_dev);
 
@@ -1330,6 +1344,59 @@ static struct intel_uncore_type ivt_uncore_imc = {
 	IVT_UNCORE_PCI_COMMON_INIT(),
 };
 
+/* registers in IRP boxes are not properly aligned */
+static unsigned ivt_uncore_irp_ctls[] = {0xd8, 0xdc, 0xe0, 0xe4};
+static unsigned ivt_uncore_irp_ctrs[] = {0xa0, 0xb0, 0xb8, 0xc0};
+
+static void ivt_uncore_irp_enable_event(struct intel_uncore_box *box, struct perf_event *event)
+{
+	struct pci_dev *pdev = box->pci_dev;
+	struct hw_perf_event *hwc = &event->hw;
+
+	pci_write_config_dword(pdev, ivt_uncore_irp_ctls[hwc->idx],
+			       hwc->config | SNBEP_PMON_CTL_EN);
+}
+
+static void ivt_uncore_irp_disable_event(struct intel_uncore_box *box, struct perf_event *event)
+{
+	struct pci_dev *pdev = box->pci_dev;
+	struct hw_perf_event *hwc = &event->hw;
+
+	pci_write_config_dword(pdev, ivt_uncore_irp_ctls[hwc->idx], hwc->config);
+}
+
+static u64 ivt_uncore_irp_read_counter(struct intel_uncore_box *box, struct perf_event *event)
+{
+	struct pci_dev *pdev = box->pci_dev;
+	struct hw_perf_event *hwc = &event->hw;
+	u64 count = 0;
+
+	pci_read_config_dword(pdev, ivt_uncore_irp_ctrs[hwc->idx], (u32 *)&count);
+	pci_read_config_dword(pdev, ivt_uncore_irp_ctrs[hwc->idx] + 4, (u32 *)&count + 1);
+
+	return count;
+}
+
+static struct intel_uncore_ops ivt_uncore_irp_ops = {
+	.init_box	= ivt_uncore_pci_init_box,
+	.disable_box	= snbep_uncore_pci_disable_box,
+	.enable_box	= snbep_uncore_pci_enable_box,
+	.disable_event	= ivt_uncore_irp_disable_event,
+	.enable_event	= ivt_uncore_irp_enable_event,
+	.read_counter	= ivt_uncore_irp_read_counter,
+};
+
+static struct intel_uncore_type ivt_uncore_irp = {
+	.name			= "irp",
+	.num_counters		= 4,
+	.num_boxes		= 1,
+	.perf_ctr_bits		= 48,
+	.event_mask		= IVT_PMON_RAW_EVENT_MASK,
+	.box_ctl		= SNBEP_PCI_PMON_BOX_CTL,
+	.ops			= &ivt_uncore_irp_ops,
+	.format_group		= &ivt_uncore_format_group,
+};
+
 static struct intel_uncore_ops ivt_uncore_qpi_ops = {
 	.init_box	= ivt_uncore_pci_init_box,
 	.disable_box	= snbep_uncore_pci_disable_box,
@@ -1377,6 +1444,7 @@ static struct intel_uncore_type ivt_uncore_r3qpi = {
 enum {
 	IVT_PCI_UNCORE_HA,
 	IVT_PCI_UNCORE_IMC,
+	IVT_PCI_UNCORE_IRP,
 	IVT_PCI_UNCORE_QPI,
 	IVT_PCI_UNCORE_R2PCIE,
 	IVT_PCI_UNCORE_R3QPI,
@@ -1385,6 +1453,7 @@ enum {
 static struct intel_uncore_type *ivt_pci_uncores[] = {
 	[IVT_PCI_UNCORE_HA]	= &ivt_uncore_ha,
 	[IVT_PCI_UNCORE_IMC]	= &ivt_uncore_imc,
+	[IVT_PCI_UNCORE_IRP]	= &ivt_uncore_irp,
 	[IVT_PCI_UNCORE_QPI]	= &ivt_uncore_qpi,
 	[IVT_PCI_UNCORE_R2PCIE]	= &ivt_uncore_r2pcie,
 	[IVT_PCI_UNCORE_R3QPI]	= &ivt_uncore_r3qpi,
@@ -1432,6 +1501,10 @@ static DEFINE_PCI_DEVICE_TABLE(ivt_uncore_pci_ids) = {
 		PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0xef1),
 		.driver_data = UNCORE_PCI_DEV_DATA(IVT_PCI_UNCORE_IMC, 7),
 	},
+	{ /* IRP */
+		PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0xe39),
+		.driver_data = UNCORE_PCI_DEV_DATA(IVT_PCI_UNCORE_IRP, 0),
+	},
 	{ /* QPI0 Port 0 */
 		PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0xe32),
 		.driver_data = UNCORE_PCI_DEV_DATA(IVT_PCI_UNCORE_QPI, 0),
-- 
1.8.1.4

