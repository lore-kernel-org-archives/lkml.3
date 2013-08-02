Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755474Ab3HBRij (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 13:38:39 -0400
Received: from mga09.intel.com ([134.134.136.24]:2503 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753743Ab3HBRgi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 13:36:38 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,802,1367996400"; 
   d="scan'208";a="356385711"
From: Jon Mason <jon.mason@intel.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 11/15] NTB: NTB-RP support
Date: Fri,  2 Aug 2013 10:35:40 -0700
Message-Id: <1375464944-27914-12-git-send-email-jon.mason@intel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1375464944-27914-1-git-send-email-jon.mason@intel.com>
References: <1375464944-27914-1-git-send-email-jon.mason@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for Non-Transparent Bridge connected to a PCI-E Root Port on
the remote system (also known as NTB-RP mode).  This allows for a NTB
enabled system to be connected to a non-NTB enabled system/slot.

Modifications to the registers and BARs/MWs on the Secondary side by the
remote system are reflected into registers on the Primary side for the
local system.  Similarly, modifications of registers and BARs/MWs on
Primary side by the local system are reflected into registers on the
Secondary side for the Remote System.  This allows communication between
the 2 sides via these registers and BARs/MWs.

Note: there is not a fix for the Xeon Errata (that was already worked
around in NTB-B2B mode) for NTB-RP mode.  Due to this limitation, NTB-RP
will not work on the Secondary side with the Xeon Errata workaround
enabled.  To get around this, disable the workaround via the
xeon_errata_workaround=0 modparm.  However, this can cause the hang
described in the errata.

Signed-off-by: Jon Mason <jon.mason@intel.com>
---
 drivers/ntb/ntb_hw.c   |  239 +++++++++++++++++++++++++++++-------------------
 drivers/ntb/ntb_regs.h |    5 +-
 2 files changed, 150 insertions(+), 94 deletions(-)

diff --git a/drivers/ntb/ntb_hw.c b/drivers/ntb/ntb_hw.c
index e7cbb44..371b65e 100644
--- a/drivers/ntb/ntb_hw.c
+++ b/drivers/ntb/ntb_hw.c
@@ -69,7 +69,7 @@ module_param(xeon_errata_workaround, bool, 0644);
 MODULE_PARM_DESC(xeon_errata_workaround, "Workaround for the Xeon Errata");
 
 enum {
-	NTB_CONN_CLASSIC = 0,
+	NTB_CONN_TRANSPARENT = 0,
 	NTB_CONN_B2B,
 	NTB_CONN_RP,
 };
@@ -509,7 +509,8 @@ static void ntb_link_event(struct ntb_device *ndev, int link_state)
 		ndev->link_status = NTB_LINK_UP;
 		event = NTB_EVENT_HW_LINK_UP;
 
-		if (ndev->hw_type == BWD_HW)
+		if (ndev->hw_type == BWD_HW ||
+		    ndev->conn_type == NTB_CONN_TRANSPARENT)
 			status = readw(ndev->reg_ofs.lnk_stat);
 		else {
 			int rc = pci_read_config_word(ndev->pdev,
@@ -649,109 +650,161 @@ static int ntb_xeon_setup(struct ntb_device *ndev)
 	if (rc)
 		return rc;
 
-	switch (val & SNB_PPD_CONN_TYPE) {
-	case NTB_CONN_B2B:
-		ndev->conn_type = NTB_CONN_B2B;
-		break;
-	case NTB_CONN_CLASSIC:
-	case NTB_CONN_RP:
-	default:
-		dev_err(&ndev->pdev->dev, "Only B2B supported at this time\n");
-		return -EINVAL;
-	}
-
 	if (val & SNB_PPD_DEV_TYPE)
 		ndev->dev_type = NTB_DEV_USD;
 	else
 		ndev->dev_type = NTB_DEV_DSD;
 
-	ndev->reg_ofs.ldb = ndev->reg_base + SNB_PDOORBELL_OFFSET;
-	ndev->reg_ofs.ldb_mask = ndev->reg_base + SNB_PDBMSK_OFFSET;
-	ndev->reg_ofs.bar2_xlat = ndev->reg_base + SNB_SBAR2XLAT_OFFSET;
-	ndev->reg_ofs.bar4_xlat = ndev->reg_base + SNB_SBAR4XLAT_OFFSET;
-	ndev->reg_ofs.lnk_cntl = ndev->reg_base + SNB_NTBCNTL_OFFSET;
-	ndev->reg_ofs.lnk_stat = ndev->reg_base + SNB_LINK_STATUS_OFFSET;
-	ndev->reg_ofs.spad_read = ndev->reg_base + SNB_SPAD_OFFSET;
-	ndev->reg_ofs.spci_cmd = ndev->reg_base + SNB_PCICMD_OFFSET;
-
-	/* There is a Xeon hardware errata related to writes to
-	 * SDOORBELL or B2BDOORBELL in conjunction with inbound access
-	 * to NTB MMIO Space, which may hang the system.  To workaround
-	 * this use the second memory window to access the interrupt and
-	 * scratch pad registers on the remote system.
-	 */
-	if (xeon_errata_workaround) {
-		if (!ndev->mw[1].bar_sz)
-			return -EINVAL;
-
-		ndev->limits.max_mw = SNB_ERRATA_MAX_MW;
-		ndev->reg_ofs.spad_write = ndev->mw[1].vbase +
-					   SNB_SPAD_OFFSET;
-		ndev->reg_ofs.rdb = ndev->mw[1].vbase +
-				    SNB_PDOORBELL_OFFSET;
-
-		/* Set the Limit register to 4k, the minimum size, to
-		 * prevent an illegal access
+	switch (val & SNB_PPD_CONN_TYPE) {
+	case NTB_CONN_B2B:
+		dev_info(&ndev->pdev->dev, "Conn Type = B2B\n");
+		ndev->conn_type = NTB_CONN_B2B;
+		ndev->reg_ofs.ldb = ndev->reg_base + SNB_PDOORBELL_OFFSET;
+		ndev->reg_ofs.ldb_mask = ndev->reg_base + SNB_PDBMSK_OFFSET;
+		ndev->reg_ofs.spad_read = ndev->reg_base + SNB_SPAD_OFFSET;
+		ndev->reg_ofs.bar2_xlat = ndev->reg_base + SNB_SBAR2XLAT_OFFSET;
+		ndev->reg_ofs.bar4_xlat = ndev->reg_base + SNB_SBAR4XLAT_OFFSET;
+		ndev->limits.max_spads = SNB_MAX_B2B_SPADS;
+
+		/* There is a Xeon hardware errata related to writes to
+		 * SDOORBELL or B2BDOORBELL in conjunction with inbound access
+		 * to NTB MMIO Space, which may hang the system.  To workaround
+		 * this use the second memory window to access the interrupt and
+		 * scratch pad registers on the remote system.
 		 */
-		writeq(ndev->mw[1].bar_sz + 0x1000, ndev->reg_base +
-		       SNB_PBAR4LMT_OFFSET);
-	} else {
-		ndev->limits.max_mw = SNB_MAX_MW;
-		ndev->reg_ofs.spad_write = ndev->reg_base +
-					   SNB_B2B_SPAD_OFFSET;
-		ndev->reg_ofs.rdb = ndev->reg_base +
-				    SNB_B2B_DOORBELL_OFFSET;
+		if (xeon_errata_workaround) {
+			if (!ndev->mw[1].bar_sz)
+				return -EINVAL;
+
+			ndev->limits.max_mw = SNB_ERRATA_MAX_MW;
+			ndev->reg_ofs.spad_write = ndev->mw[1].vbase +
+						   SNB_SPAD_OFFSET;
+			ndev->reg_ofs.rdb = ndev->mw[1].vbase +
+					    SNB_PDOORBELL_OFFSET;
+
+			/* Set the Limit register to 4k, the minimum size, to
+			 * prevent an illegal access
+			 */
+			writeq(ndev->mw[1].bar_sz + 0x1000, ndev->reg_base +
+			       SNB_PBAR4LMT_OFFSET);
+		} else {
+			ndev->limits.max_mw = SNB_MAX_MW;
+			ndev->reg_ofs.spad_write = ndev->reg_base +
+						   SNB_B2B_SPAD_OFFSET;
+			ndev->reg_ofs.rdb = ndev->reg_base +
+					    SNB_B2B_DOORBELL_OFFSET;
+
+			/* Disable the Limit register, just incase it is set to
+			 * something silly
+			 */
+			writeq(0, ndev->reg_base + SNB_PBAR4LMT_OFFSET);
+		}
 
-		/* Disable the Limit register, just incase it is set to
-		 * something silly
+		/* The Xeon errata workaround requires setting SBAR Base
+		 * addresses to known values, so that the PBAR XLAT can be
+		 * pointed at SBAR0 of the remote system.
 		 */
-		writeq(0, ndev->reg_base + SNB_PBAR4LMT_OFFSET);
-	}
+		if (ndev->dev_type == NTB_DEV_USD) {
+			writeq(SNB_MBAR23_DSD_ADDR, ndev->reg_base +
+			       SNB_PBAR2XLAT_OFFSET);
+			if (xeon_errata_workaround)
+				writeq(SNB_MBAR01_DSD_ADDR, ndev->reg_base +
+				       SNB_PBAR4XLAT_OFFSET);
+			else {
+				writeq(SNB_MBAR45_DSD_ADDR, ndev->reg_base +
+				       SNB_PBAR4XLAT_OFFSET);
+				writeq(SNB_MBAR01_DSD_ADDR, ndev->reg_base +
+				       SNB_B2B_XLAT_OFFSET);
+			}
 
-	/* The Xeon errata workaround requires setting SBAR Base
-	 * addresses to known values, so that the PBAR XLAT can be
-	 * pointed at SBAR0 of the remote system.
-	 */
-	if (ndev->dev_type == NTB_DEV_USD) {
-		writeq(SNB_MBAR23_DSD_ADDR, ndev->reg_base +
-		       SNB_PBAR2XLAT_OFFSET);
-		if (xeon_errata_workaround)
+			writeq(SNB_MBAR01_USD_ADDR, ndev->reg_base +
+			       SNB_SBAR0BASE_OFFSET);
+			writeq(SNB_MBAR23_USD_ADDR, ndev->reg_base +
+			       SNB_SBAR2BASE_OFFSET);
+			writeq(SNB_MBAR45_USD_ADDR, ndev->reg_base +
+			       SNB_SBAR4BASE_OFFSET);
+		} else {
+			writeq(SNB_MBAR23_USD_ADDR, ndev->reg_base +
+			       SNB_PBAR2XLAT_OFFSET);
+			if (xeon_errata_workaround)
+				writeq(SNB_MBAR01_USD_ADDR, ndev->reg_base +
+				       SNB_PBAR4XLAT_OFFSET);
+			else {
+				writeq(SNB_MBAR45_USD_ADDR, ndev->reg_base +
+				       SNB_PBAR4XLAT_OFFSET);
+				writeq(SNB_MBAR01_USD_ADDR, ndev->reg_base +
+				       SNB_B2B_XLAT_OFFSET);
+			}
 			writeq(SNB_MBAR01_DSD_ADDR, ndev->reg_base +
-			       SNB_PBAR4XLAT_OFFSET);
-		else {
+			       SNB_SBAR0BASE_OFFSET);
+			writeq(SNB_MBAR23_DSD_ADDR, ndev->reg_base +
+			       SNB_SBAR2BASE_OFFSET);
 			writeq(SNB_MBAR45_DSD_ADDR, ndev->reg_base +
-			       SNB_PBAR4XLAT_OFFSET);
-			writeq(SNB_MBAR01_DSD_ADDR, ndev->reg_base +
-			       SNB_B2B_XLAT_OFFSET);
+			       SNB_SBAR4BASE_OFFSET);
 		}
+		break;
+	case NTB_CONN_RP:
+		dev_info(&ndev->pdev->dev, "Conn Type = RP\n");
+		ndev->conn_type = NTB_CONN_RP;
 
-		writeq(SNB_MBAR01_USD_ADDR, ndev->reg_base +
-		       SNB_SBAR0BASE_OFFSET);
-		writeq(SNB_MBAR23_USD_ADDR, ndev->reg_base +
-		       SNB_SBAR2BASE_OFFSET);
-		writeq(SNB_MBAR45_USD_ADDR, ndev->reg_base +
-		       SNB_SBAR4BASE_OFFSET);
-	} else {
-		writeq(SNB_MBAR23_USD_ADDR, ndev->reg_base +
-		       SNB_PBAR2XLAT_OFFSET);
 		if (xeon_errata_workaround)
-			writeq(SNB_MBAR01_USD_ADDR, ndev->reg_base +
-			       SNB_PBAR4XLAT_OFFSET);
-		else {
-			writeq(SNB_MBAR45_USD_ADDR, ndev->reg_base +
-			       SNB_PBAR4XLAT_OFFSET);
-			writeq(SNB_MBAR01_USD_ADDR, ndev->reg_base +
-			       SNB_B2B_XLAT_OFFSET);
-		}
-		writeq(SNB_MBAR01_DSD_ADDR, ndev->reg_base +
-		       SNB_SBAR0BASE_OFFSET);
-		writeq(SNB_MBAR23_DSD_ADDR, ndev->reg_base +
-		       SNB_SBAR2BASE_OFFSET);
-		writeq(SNB_MBAR45_DSD_ADDR, ndev->reg_base +
-		       SNB_SBAR4BASE_OFFSET);
+			return -EINVAL;
+
+		/* Scratch pads need to have exclusive access from the primary
+		 * or secondary side.  Halve the num spads so that each side can
+		 * have an equal amount.
+		 */
+		ndev->limits.max_spads = SNB_MAX_COMPAT_SPADS / 2;
+		/* Note: The SDOORBELL is the cause of the errata.  You REALLY
+		 * don't want to touch it.
+		 */
+		ndev->reg_ofs.rdb = ndev->reg_base + SNB_SDOORBELL_OFFSET;
+		ndev->reg_ofs.ldb = ndev->reg_base + SNB_PDOORBELL_OFFSET;
+		ndev->reg_ofs.ldb_mask = ndev->reg_base + SNB_PDBMSK_OFFSET;
+		/* Offset the start of the spads to correspond to whether it is
+		 * primary or secondary
+		 */
+		ndev->reg_ofs.spad_write = ndev->reg_base + SNB_SPAD_OFFSET +
+					   ndev->limits.max_spads * 4;
+		ndev->reg_ofs.spad_read = ndev->reg_base + SNB_SPAD_OFFSET;
+		ndev->reg_ofs.bar2_xlat = ndev->reg_base + SNB_SBAR2XLAT_OFFSET;
+		ndev->reg_ofs.bar4_xlat = ndev->reg_base + SNB_SBAR4XLAT_OFFSET;
+		ndev->limits.max_mw = SNB_MAX_MW;
+		break;
+	case NTB_CONN_TRANSPARENT:
+		dev_info(&ndev->pdev->dev, "Conn Type = TRANSPARENT\n");
+		ndev->conn_type = NTB_CONN_TRANSPARENT;
+		/* Scratch pads need to have exclusive access from the primary
+		 * or secondary side.  Halve the num spads so that each side can
+		 * have an equal amount.
+		 */
+		ndev->limits.max_spads = SNB_MAX_COMPAT_SPADS / 2;
+		ndev->reg_ofs.rdb = ndev->reg_base + SNB_PDOORBELL_OFFSET;
+		ndev->reg_ofs.ldb = ndev->reg_base + SNB_SDOORBELL_OFFSET;
+		ndev->reg_ofs.ldb_mask = ndev->reg_base + SNB_SDBMSK_OFFSET;
+		ndev->reg_ofs.spad_write = ndev->reg_base + SNB_SPAD_OFFSET;
+		/* Offset the start of the spads to correspond to whether it is
+		 * primary or secondary
+		 */
+		ndev->reg_ofs.spad_read = ndev->reg_base + SNB_SPAD_OFFSET +
+					  ndev->limits.max_spads * 4;
+		ndev->reg_ofs.bar2_xlat = ndev->reg_base + SNB_PBAR2XLAT_OFFSET;
+		ndev->reg_ofs.bar4_xlat = ndev->reg_base + SNB_PBAR4XLAT_OFFSET;
+
+		ndev->limits.max_mw = SNB_MAX_MW;
+		break;
+	default:
+		/* Most likely caused by the remote NTB-RP device not being
+		 * configured
+		 */
+		dev_err(&ndev->pdev->dev, "Unknown PPD %x\n", val);
+		return -EINVAL;
 	}
 
-	ndev->limits.max_spads = SNB_MAX_B2B_SPADS;
+	ndev->reg_ofs.lnk_cntl = ndev->reg_base + SNB_NTBCNTL_OFFSET;
+	ndev->reg_ofs.lnk_stat = ndev->reg_base + SNB_SLINK_STATUS_OFFSET;
+	ndev->reg_ofs.spci_cmd = ndev->reg_base + SNB_PCICMD_OFFSET;
+
 	ndev->limits.max_db_bits = SNB_MAX_DB_BITS;
 	ndev->limits.msix_cnt = SNB_MSIX_CNT;
 	ndev->bits_per_vector = SNB_DB_BITS_PER_VEC;
@@ -855,8 +908,10 @@ static int ntb_device_setup(struct ntb_device *ndev)
 	dev_info(&ndev->pdev->dev, "Device Type = %s\n",
 		 ndev->dev_type == NTB_DEV_USD ? "USD/DSP" : "DSD/USP");
 
-	/* Enable Bus Master and Memory Space on the secondary side */
-	writew(PCI_COMMAND_MEMORY | PCI_COMMAND_MASTER, ndev->reg_ofs.spci_cmd);
+	if (ndev->conn_type == NTB_CONN_B2B)
+		/* Enable Bus Master and Memory Space on the secondary side */
+		writew(PCI_COMMAND_MEMORY | PCI_COMMAND_MASTER,
+		       ndev->reg_ofs.spci_cmd);
 
 	return 0;
 }
@@ -1350,7 +1405,7 @@ static void ntb_pci_remove(struct pci_dev *pdev)
 
 	/* Bring NTB link down */
 	ntb_cntl = readl(ndev->reg_ofs.lnk_cntl);
-	ntb_cntl |= NTB_LINK_DISABLE;
+	ntb_cntl |= NTB_CNTL_LINK_DISABLE;
 	writel(ntb_cntl, ndev->reg_ofs.lnk_cntl);
 
 	ntb_transport_free(ndev->ntb_transport);
diff --git a/drivers/ntb/ntb_regs.h b/drivers/ntb/ntb_regs.h
index 8f3f903..910d5e9 100644
--- a/drivers/ntb/ntb_regs.h
+++ b/drivers/ntb/ntb_regs.h
@@ -46,8 +46,6 @@
  * Jon Mason <jon.mason@intel.com>
  */
 
-#define NTB_LINK_ENABLE		0x0000
-#define NTB_LINK_DISABLE	0x0002
 #define NTB_LINK_STATUS_ACTIVE	0x2000
 #define NTB_LINK_SPEED_MASK	0x000f
 #define NTB_LINK_WIDTH_MASK	0x03f0
@@ -65,6 +63,7 @@
 
 #define SNB_PCICMD_OFFSET	0x0504
 #define SNB_DEVCTRL_OFFSET	0x0598
+#define SNB_SLINK_STATUS_OFFSET	0x05A2
 #define SNB_LINK_STATUS_OFFSET	0x01A2
 
 #define SNB_PBAR2LMT_OFFSET	0x0000
@@ -146,6 +145,8 @@
 #define BWD_LTSSMSTATEJMP_FORCEDETECT	(1 << 2)
 #define BWD_IBIST_ERR_OFLOW	0x7FFF7FFF
 
+#define NTB_CNTL_CFG_LOCK	(1 << 0)
+#define NTB_CNTL_LINK_DISABLE	(1 << 1)
 #define NTB_CNTL_BAR23_SNOOP	(1 << 2)
 #define NTB_CNTL_BAR45_SNOOP	(1 << 6)
 #define BWD_CNTL_LINK_DOWN	(1 << 16)
-- 
1.7.9.5

