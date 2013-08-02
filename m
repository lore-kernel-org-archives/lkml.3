Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754811Ab3HBRgo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 13:36:44 -0400
Received: from mga01.intel.com ([192.55.52.88]:15731 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752983Ab3HBRgm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 13:36:42 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,802,1367996400"; 
   d="scan'208";a="380308470"
From: Jon Mason <jon.mason@intel.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 07/15] NTB: Update Device IDs
Date: Fri,  2 Aug 2013 10:35:36 -0700
Message-Id: <1375464944-27914-8-git-send-email-jon.mason@intel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1375464944-27914-1-git-send-email-jon.mason@intel.com>
References: <1375464944-27914-1-git-send-email-jon.mason@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for new Intel NTB devices on upcoming Xeon hardware.  Since
the Xeon hardware design is already in place in the driver, all that is
needed are the new device ids.

Remove the device IDs for NTB devs running in Transparent Bridge mode,
as this driver is not being used for those devices.

Rename the device IDs for NTB devs running in NTB-RP mode to better
identify their usage model.  "PS" to denote the Primary Side of NTB, and
"SS" to denote the secondary side.  The primary side is the interface
exposed to the local system, and the secondary side is the interface
exposed to the remote system.

Signed-off-by: Jon Mason <jon.mason@intel.com>
---
 drivers/ntb/ntb_hw.c |   29 ++++++++++++++++++++---------
 drivers/ntb/ntb_hw.h |   15 ++++++++++-----
 2 files changed, 30 insertions(+), 14 deletions(-)

diff --git a/drivers/ntb/ntb_hw.c b/drivers/ntb/ntb_hw.c
index d259d41..fc6b19d 100644
--- a/drivers/ntb/ntb_hw.c
+++ b/drivers/ntb/ntb_hw.c
@@ -94,11 +94,17 @@ struct dentry *debugfs_dir;
 static DEFINE_PCI_DEVICE_TABLE(ntb_pci_tbl) = {
 	{PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_NTB_B2B_BWD)},
 	{PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_NTB_B2B_JSF)},
-	{PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_NTB_CLASSIC_JSF)},
-	{PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_NTB_RP_JSF)},
-	{PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_NTB_RP_SNB)},
 	{PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_NTB_B2B_SNB)},
-	{PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_NTB_CLASSIC_SNB)},
+	{PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_NTB_B2B_IVT)},
+	{PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_NTB_B2B_HSX)},
+	{PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_NTB_PS_JSF)},
+	{PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_NTB_PS_SNB)},
+	{PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_NTB_PS_IVT)},
+	{PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_NTB_PS_HSX)},
+	{PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_NTB_SS_JSF)},
+	{PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_NTB_SS_SNB)},
+	{PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_NTB_SS_IVT)},
+	{PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_NTB_SS_HSX)},
 	{0}
 };
 MODULE_DEVICE_TABLE(pci, ntb_pci_tbl);
@@ -805,13 +811,18 @@ static int ntb_device_setup(struct ntb_device *ndev)
 	int rc;
 
 	switch (ndev->pdev->device) {
-	case PCI_DEVICE_ID_INTEL_NTB_2ND_SNB:
-	case PCI_DEVICE_ID_INTEL_NTB_RP_JSF:
-	case PCI_DEVICE_ID_INTEL_NTB_RP_SNB:
-	case PCI_DEVICE_ID_INTEL_NTB_CLASSIC_JSF:
-	case PCI_DEVICE_ID_INTEL_NTB_CLASSIC_SNB:
+	case PCI_DEVICE_ID_INTEL_NTB_SS_JSF:
+	case PCI_DEVICE_ID_INTEL_NTB_SS_SNB:
+	case PCI_DEVICE_ID_INTEL_NTB_SS_IVT:
+	case PCI_DEVICE_ID_INTEL_NTB_SS_HSX:
+	case PCI_DEVICE_ID_INTEL_NTB_PS_JSF:
+	case PCI_DEVICE_ID_INTEL_NTB_PS_SNB:
+	case PCI_DEVICE_ID_INTEL_NTB_PS_IVT:
+	case PCI_DEVICE_ID_INTEL_NTB_PS_HSX:
 	case PCI_DEVICE_ID_INTEL_NTB_B2B_JSF:
 	case PCI_DEVICE_ID_INTEL_NTB_B2B_SNB:
+	case PCI_DEVICE_ID_INTEL_NTB_B2B_IVT:
+	case PCI_DEVICE_ID_INTEL_NTB_B2B_HSX:
 		rc = ntb_xeon_setup(ndev);
 		break;
 	case PCI_DEVICE_ID_INTEL_NTB_B2B_BWD:
diff --git a/drivers/ntb/ntb_hw.h b/drivers/ntb/ntb_hw.h
index 3a15d49..591d4ff 100644
--- a/drivers/ntb/ntb_hw.h
+++ b/drivers/ntb/ntb_hw.h
@@ -47,12 +47,17 @@
  */
 
 #define PCI_DEVICE_ID_INTEL_NTB_B2B_JSF		0x3725
-#define PCI_DEVICE_ID_INTEL_NTB_CLASSIC_JSF	0x3726
-#define PCI_DEVICE_ID_INTEL_NTB_RP_JSF		0x3727
-#define PCI_DEVICE_ID_INTEL_NTB_RP_SNB		0x3C08
+#define PCI_DEVICE_ID_INTEL_NTB_PS_JSF		0x3726
+#define PCI_DEVICE_ID_INTEL_NTB_SS_JSF		0x3727
 #define PCI_DEVICE_ID_INTEL_NTB_B2B_SNB		0x3C0D
-#define PCI_DEVICE_ID_INTEL_NTB_CLASSIC_SNB	0x3C0E
-#define PCI_DEVICE_ID_INTEL_NTB_2ND_SNB		0x3C0F
+#define PCI_DEVICE_ID_INTEL_NTB_PS_SNB		0x3C0E
+#define PCI_DEVICE_ID_INTEL_NTB_SS_SNB		0x3C0F
+#define PCI_DEVICE_ID_INTEL_NTB_B2B_IVT		0x0E0D
+#define PCI_DEVICE_ID_INTEL_NTB_PS_IVT		0x0E0E
+#define PCI_DEVICE_ID_INTEL_NTB_SS_IVT		0x0E0F
+#define PCI_DEVICE_ID_INTEL_NTB_B2B_HSX		0x2F0D
+#define PCI_DEVICE_ID_INTEL_NTB_PS_HSX		0x2F0E
+#define PCI_DEVICE_ID_INTEL_NTB_SS_HSX		0x2F0F
 #define PCI_DEVICE_ID_INTEL_NTB_B2B_BWD		0x0C4E
 
 #define msix_table_size(control)	((control & PCI_MSIX_FLAGS_QSIZE)+1)
-- 
1.7.9.5

