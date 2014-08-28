Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752655AbaH1Uyg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 16:54:36 -0400
Received: from mga14.intel.com ([192.55.52.115]:2160 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752386AbaH1Uxr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 16:53:47 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,420,1406617200"; 
   d="scan'208";a="473593735"
Subject: [PATCH 4/6] ntb: use errata flag set via DID to implement workaround
From: Dave Jiang <dave.jiang@intel.com>
To: jdmason@kudzu.us
Cc: linux-kernel@vger.kernel.org
Date: Thu, 28 Aug 2014 13:53:18 -0700
Message-ID: <20140828205318.165750.98876.stgit@djiang5-desk2.amr.corp.intel.com>
In-Reply-To: <20140828204947.165750.64364.stgit@djiang5-desk2.amr.corp.intel.com>
References: <20140828204947.165750.64364.stgit@djiang5-desk2.amr.corp.intel.com>
User-Agent: StGit/0.17-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of using a module parameter, we should detect the errata via
PCI DID and then set an appropriate flag. This will be used for additional
errata later on.

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---
 drivers/ntb/ntb_hw.c |   47 ++++++++++++++++++++++++++++++++++++++---------
 drivers/ntb/ntb_hw.h |    4 ++++
 2 files changed, 42 insertions(+), 9 deletions(-)

diff --git a/drivers/ntb/ntb_hw.c b/drivers/ntb/ntb_hw.c
index d6f4268..471c847 100644
--- a/drivers/ntb/ntb_hw.c
+++ b/drivers/ntb/ntb_hw.c
@@ -64,10 +64,6 @@ MODULE_VERSION(NTB_VER);
 MODULE_LICENSE("Dual BSD/GPL");
 MODULE_AUTHOR("Intel Corporation");
 
-static bool xeon_errata_workaround = true;
-module_param(xeon_errata_workaround, bool, 0644);
-MODULE_PARM_DESC(xeon_errata_workaround, "Workaround for the Xeon Errata");
-
 enum {
 	NTB_CONN_TRANSPARENT = 0,
 	NTB_CONN_B2B,
@@ -144,6 +140,30 @@ static int is_ntb_atom(struct ntb_device *ndev)
 	return 0;
 }
 
+static void ntb_set_errata_flags(struct ntb_device *ndev)
+{
+	switch (ndev->pdev->device) {
+	/*
+	 * this workaround applies to all platform up to IvyBridge
+	 * Haswell has splitbar support and use a different workaround
+	 */
+	case PCI_DEVICE_ID_INTEL_NTB_SS_JSF:
+	case PCI_DEVICE_ID_INTEL_NTB_SS_SNB:
+	case PCI_DEVICE_ID_INTEL_NTB_SS_IVT:
+	case PCI_DEVICE_ID_INTEL_NTB_SS_HSX:
+	case PCI_DEVICE_ID_INTEL_NTB_PS_JSF:
+	case PCI_DEVICE_ID_INTEL_NTB_PS_SNB:
+	case PCI_DEVICE_ID_INTEL_NTB_PS_IVT:
+	case PCI_DEVICE_ID_INTEL_NTB_PS_HSX:
+	case PCI_DEVICE_ID_INTEL_NTB_B2B_JSF:
+	case PCI_DEVICE_ID_INTEL_NTB_B2B_SNB:
+	case PCI_DEVICE_ID_INTEL_NTB_B2B_IVT:
+	case PCI_DEVICE_ID_INTEL_NTB_B2B_HSX:
+		ndev->wa_flags |= WA_SNB_ERR;
+		break;
+	}
+}
+
 /**
  * ntb_register_event_callback() - register event callback
  * @ndev: pointer to ntb_device instance
@@ -717,7 +737,7 @@ static int ntb_xeon_setup(struct ntb_device *ndev)
 		 * this use the second memory window to access the interrupt and
 		 * scratch pad registers on the remote system.
 		 */
-		if (xeon_errata_workaround) {
+		if (ndev->wa_flags & WA_SNB_ERR) {
 			if (!ndev->mw[1].bar_sz)
 				return -EINVAL;
 
@@ -772,7 +792,7 @@ static int ntb_xeon_setup(struct ntb_device *ndev)
 		if (ndev->dev_type == NTB_DEV_USD) {
 			writeq(SNB_MBAR23_DSD_ADDR, ndev->reg_base +
 			       SNB_PBAR2XLAT_OFFSET);
-			if (xeon_errata_workaround)
+			if (ndev->wa_flags & WA_SNB_ERR)
 				writeq(SNB_MBAR01_DSD_ADDR, ndev->reg_base +
 				       SNB_PBAR4XLAT_OFFSET);
 			else {
@@ -796,7 +816,7 @@ static int ntb_xeon_setup(struct ntb_device *ndev)
 		} else {
 			writeq(SNB_MBAR23_USD_ADDR, ndev->reg_base +
 			       SNB_PBAR2XLAT_OFFSET);
-			if (xeon_errata_workaround)
+			if (ndev->wa_flags & WA_SNB_ERR)
 				writeq(SNB_MBAR01_USD_ADDR, ndev->reg_base +
 				       SNB_PBAR4XLAT_OFFSET);
 			else {
@@ -819,9 +839,9 @@ static int ntb_xeon_setup(struct ntb_device *ndev)
 		}
 		break;
 	case NTB_CONN_RP:
-		if (xeon_errata_workaround) {
+		if (ndev->wa_flags & WA_SNB_ERR) {
 			dev_err(&ndev->pdev->dev,
-				"NTB-RP disabled due to hardware errata.  To disregard this warning and potentially lock-up the system, add the parameter 'xeon_errata_workaround=0'.\n");
+				"NTB-RP disabled due to hardware errata. To disregard this warning and potentially lock-up the system\n");
 			return -EINVAL;
 		}
 
@@ -848,6 +868,12 @@ static int ntb_xeon_setup(struct ntb_device *ndev)
 		ndev->limits.max_mw = SNB_MAX_MW;
 		break;
 	case NTB_CONN_TRANSPARENT:
+		if (ndev->wa_flags & WA_SNB_ERR) {
+			dev_err(&ndev->pdev->dev,
+				"NTB-TRANSPARENT disabled due to hardware errata. To disregard this warning and potentially lock-up the system\n");
+			return -EINVAL;
+		}
+
 		/* Scratch pads need to have exclusive access from the primary
 		 * or secondary side.  Halve the num spads so that each side can
 		 * have an equal amount.
@@ -1595,6 +1621,9 @@ static int ntb_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 		return -ENOMEM;
 
 	ndev->pdev = pdev;
+
+	ntb_set_errata_flags(ndev);
+
 	ndev->link_status = NTB_LINK_DOWN;
 	pci_set_drvdata(pdev, ndev);
 	ntb_setup_debugfs(ndev);
diff --git a/drivers/ntb/ntb_hw.h b/drivers/ntb/ntb_hw.h
index ddbcbfd..5380ca1 100644
--- a/drivers/ntb/ntb_hw.h
+++ b/drivers/ntb/ntb_hw.h
@@ -109,6 +109,8 @@ struct ntb_db_cb {
 	struct tasklet_struct irq_work;
 };
 
+#define WA_SNB_ERR	0x00000001
+
 struct ntb_device {
 	struct pci_dev *pdev;
 	struct msix_entry *msix_entries;
@@ -153,6 +155,8 @@ struct ntb_device {
 
 	struct dentry *debugfs_dir;
 	struct dentry *debugfs_info;
+
+	unsigned int wa_flags;
 };
 
 /**

