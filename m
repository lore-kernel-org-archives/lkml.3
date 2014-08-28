Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752580AbaH1Uxw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 16:53:52 -0400
Received: from mga14.intel.com ([192.55.52.115]:37273 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752492AbaH1Uxt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 16:53:49 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,420,1406617200"; 
   d="scan'208";a="473593744"
Subject: [PATCH 5/6] ntb: Adding split BAR support for Haswell platforms
From: Dave Jiang <dave.jiang@intel.com>
To: jdmason@kudzu.us
Cc: linux-kernel@vger.kernel.org
Date: Thu, 28 Aug 2014 13:53:23 -0700
Message-ID: <20140828205323.165750.95511.stgit@djiang5-desk2.amr.corp.intel.com>
In-Reply-To: <20140828204947.165750.64364.stgit@djiang5-desk2.amr.corp.intel.com>
References: <20140828204947.165750.64364.stgit@djiang5-desk2.amr.corp.intel.com>
User-Agent: StGit/0.17-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On the Haswell platform, a split BAR option to allow creation of 2
32bit BARs (4 and 5) from the 64bit BAR 4. Adding support for this
new option.

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Jon Mason <jdmason@gmail.com>
---
 drivers/ntb/ntb_hw.c   |  217 ++++++++++++++++++++++++++++++++++++++----------
 drivers/ntb/ntb_hw.h   |   14 ++-
 drivers/ntb/ntb_regs.h |   31 +++++--
 3 files changed, 202 insertions(+), 60 deletions(-)

diff --git a/drivers/ntb/ntb_hw.c b/drivers/ntb/ntb_hw.c
index 471c847..cef9d8a 100644
--- a/drivers/ntb/ntb_hw.c
+++ b/drivers/ntb/ntb_hw.c
@@ -84,8 +84,8 @@ static struct dentry *debugfs_dir;
 
 #define BWD_LINK_RECOVERY_TIME	500
 
-/* Translate memory window 0,1 to BAR 2,4 */
-#define MW_TO_BAR(mw)	(mw * NTB_MAX_NUM_MW + 2)
+/* Translate memory window 0,1,2 to BAR 2,4,5 */
+#define MW_TO_BAR(mw)	(mw == 0 ? 2 : (mw == 1 ? 4 : 5))
 
 static const struct pci_device_id ntb_pci_tbl[] = {
 	{PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_NTB_B2B_BWD)},
@@ -506,8 +506,14 @@ void ntb_set_mw_addr(struct ntb_device *ndev, unsigned int mw, u64 addr)
 	case NTB_BAR_23:
 		writeq(addr, ndev->reg_ofs.bar2_xlat);
 		break;
-	case NTB_BAR_45:
-		writeq(addr, ndev->reg_ofs.bar4_xlat);
+	case NTB_BAR_4:
+		if (ndev->split_bar)
+			writel(addr, ndev->reg_ofs.bar4_xlat);
+		else
+			writeq(addr, ndev->reg_ofs.bar4_xlat);
+		break;
+	case NTB_BAR_5:
+		writel(addr, ndev->reg_ofs.bar5_xlat);
 		break;
 	}
 }
@@ -729,6 +735,9 @@ static int ntb_xeon_setup(struct ntb_device *ndev)
 		ndev->reg_ofs.spad_read = ndev->reg_base + SNB_SPAD_OFFSET;
 		ndev->reg_ofs.bar2_xlat = ndev->reg_base + SNB_SBAR2XLAT_OFFSET;
 		ndev->reg_ofs.bar4_xlat = ndev->reg_base + SNB_SBAR4XLAT_OFFSET;
+		if (ndev->split_bar)
+			ndev->reg_ofs.bar5_xlat =
+				ndev->reg_base + SNB_SBAR5XLAT_OFFSET;
 		ndev->limits.max_spads = SNB_MAX_B2B_SPADS;
 
 		/* There is a Xeon hardware errata related to writes to
@@ -738,15 +747,16 @@ static int ntb_xeon_setup(struct ntb_device *ndev)
 		 * scratch pad registers on the remote system.
 		 */
 		if (ndev->wa_flags & WA_SNB_ERR) {
-			if (!ndev->mw[1].bar_sz)
+			if (!ndev->mw[ndev->limits.max_mw - 1].bar_sz)
 				return -EINVAL;
 
-			ndev->limits.max_mw = SNB_ERRATA_MAX_MW;
 			ndev->limits.max_db_bits = SNB_MAX_DB_BITS;
-			ndev->reg_ofs.spad_write = ndev->mw[1].vbase +
-						   SNB_SPAD_OFFSET;
-			ndev->reg_ofs.rdb = ndev->mw[1].vbase +
-					    SNB_PDOORBELL_OFFSET;
+			ndev->reg_ofs.spad_write =
+				ndev->mw[ndev->limits.max_mw - 1].vbase +
+				SNB_SPAD_OFFSET;
+			ndev->reg_ofs.rdb =
+				ndev->mw[ndev->limits.max_mw - 1].vbase +
+				SNB_PDOORBELL_OFFSET;
 
 			/* Set the Limit register to 4k, the minimum size, to
 			 * prevent an illegal access
@@ -759,9 +769,9 @@ static int ntb_xeon_setup(struct ntb_device *ndev)
 			 * the driver defaults, but write the Limit registers
 			 * first just in case.
 			 */
-		} else {
-			ndev->limits.max_mw = SNB_MAX_MW;
 
+			ndev->limits.max_mw = SNB_ERRATA_MAX_MW;
+		} else {
 			/* HW Errata on bit 14 of b2bdoorbell register.  Writes
 			 * will not be mirrored to the remote system.  Shrink
 			 * the number of bits by one, since bit 14 is the last
@@ -774,7 +784,8 @@ static int ntb_xeon_setup(struct ntb_device *ndev)
 					    SNB_B2B_DOORBELL_OFFSET;
 
 			/* Disable the Limit register, just incase it is set to
-			 * something silly
+			 * something silly. A 64bit write should handle it
+			 * regardless of whether it has a split BAR or not.
 			 */
 			writeq(0, ndev->reg_base + SNB_PBAR4LMT_OFFSET);
 			/* HW errata on the Limit registers.  They can only be
@@ -783,6 +794,10 @@ static int ntb_xeon_setup(struct ntb_device *ndev)
 			 * the driver defaults, but write the Limit registers
 			 * first just in case.
 			 */
+			if (ndev->split_bar)
+				ndev->limits.max_mw = HSX_SPLITBAR_MAX_MW;
+			else
+				ndev->limits.max_mw = SNB_MAX_MW;
 		}
 
 		/* The Xeon errata workaround requires setting SBAR Base
@@ -796,8 +811,15 @@ static int ntb_xeon_setup(struct ntb_device *ndev)
 				writeq(SNB_MBAR01_DSD_ADDR, ndev->reg_base +
 				       SNB_PBAR4XLAT_OFFSET);
 			else {
-				writeq(SNB_MBAR45_DSD_ADDR, ndev->reg_base +
-				       SNB_PBAR4XLAT_OFFSET);
+				if (ndev->split_bar) {
+					writel(SNB_MBAR4_DSD_ADDR,
+					       ndev->reg_base + SNB_PBAR4XLAT_OFFSET);
+					writel(SNB_MBAR5_DSD_ADDR,
+					       ndev->reg_base + SNB_PBAR5XLAT_OFFSET);
+				} else
+					writeq(SNB_MBAR4_DSD_ADDR,
+					       ndev->reg_base + SNB_PBAR4XLAT_OFFSET);
+
 				/* B2B_XLAT_OFFSET is a 64bit register, but can
 				 * only take 32bit writes
 				 */
@@ -811,8 +833,14 @@ static int ntb_xeon_setup(struct ntb_device *ndev)
 			       SNB_SBAR0BASE_OFFSET);
 			writeq(SNB_MBAR23_USD_ADDR, ndev->reg_base +
 			       SNB_SBAR2BASE_OFFSET);
-			writeq(SNB_MBAR45_USD_ADDR, ndev->reg_base +
-			       SNB_SBAR4BASE_OFFSET);
+			if (ndev->split_bar) {
+				writel(SNB_MBAR4_USD_ADDR, ndev->reg_base +
+				       SNB_SBAR4BASE_OFFSET);
+				writel(SNB_MBAR5_USD_ADDR, ndev->reg_base +
+				       SNB_SBAR5BASE_OFFSET);
+			} else
+				writeq(SNB_MBAR4_USD_ADDR, ndev->reg_base +
+				       SNB_SBAR4BASE_OFFSET);
 		} else {
 			writeq(SNB_MBAR23_USD_ADDR, ndev->reg_base +
 			       SNB_PBAR2XLAT_OFFSET);
@@ -820,9 +848,17 @@ static int ntb_xeon_setup(struct ntb_device *ndev)
 				writeq(SNB_MBAR01_USD_ADDR, ndev->reg_base +
 				       SNB_PBAR4XLAT_OFFSET);
 			else {
-				writeq(SNB_MBAR45_USD_ADDR, ndev->reg_base +
-				       SNB_PBAR4XLAT_OFFSET);
-				/* B2B_XLAT_OFFSET is a 64bit register, but can
+				if (ndev->split_bar) {
+					writel(SNB_MBAR4_USD_ADDR,
+					       ndev->reg_base + SNB_PBAR4XLAT_OFFSET);
+					writel(SNB_MBAR5_USD_ADDR,
+					       ndev->reg_base + SNB_PBAR5XLAT_OFFSET);
+				} else
+					writeq(SNB_MBAR4_USD_ADDR,
+					       ndev->reg_base + SNB_PBAR4XLAT_OFFSET);
+
+				/*
+				 * B2B_XLAT_OFFSET is a 64bit register, but can
 				 * only take 32bit writes
 				 */
 				writel(SNB_MBAR01_USD_ADDR & 0xffffffff,
@@ -834,8 +870,15 @@ static int ntb_xeon_setup(struct ntb_device *ndev)
 			       SNB_SBAR0BASE_OFFSET);
 			writeq(SNB_MBAR23_DSD_ADDR, ndev->reg_base +
 			       SNB_SBAR2BASE_OFFSET);
-			writeq(SNB_MBAR45_DSD_ADDR, ndev->reg_base +
-			       SNB_SBAR4BASE_OFFSET);
+			if (ndev->split_bar) {
+				writel(SNB_MBAR4_DSD_ADDR, ndev->reg_base +
+				       SNB_SBAR4BASE_OFFSET);
+				writel(SNB_MBAR5_DSD_ADDR, ndev->reg_base +
+				       SNB_SBAR5BASE_OFFSET);
+			} else
+				writeq(SNB_MBAR4_DSD_ADDR, ndev->reg_base +
+				       SNB_SBAR4BASE_OFFSET);
+
 		}
 		break;
 	case NTB_CONN_RP:
@@ -865,7 +908,12 @@ static int ntb_xeon_setup(struct ntb_device *ndev)
 		ndev->reg_ofs.spad_read = ndev->reg_base + SNB_SPAD_OFFSET;
 		ndev->reg_ofs.bar2_xlat = ndev->reg_base + SNB_SBAR2XLAT_OFFSET;
 		ndev->reg_ofs.bar4_xlat = ndev->reg_base + SNB_SBAR4XLAT_OFFSET;
-		ndev->limits.max_mw = SNB_MAX_MW;
+		if (ndev->split_bar) {
+			ndev->reg_ofs.bar5_xlat =
+				ndev->reg_base + SNB_SBAR5XLAT_OFFSET;
+			ndev->limits.max_mw = HSX_SPLITBAR_MAX_MW;
+		} else
+			ndev->limits.max_mw = SNB_MAX_MW;
 		break;
 	case NTB_CONN_TRANSPARENT:
 		if (ndev->wa_flags & WA_SNB_ERR) {
@@ -892,7 +940,12 @@ static int ntb_xeon_setup(struct ntb_device *ndev)
 		ndev->reg_ofs.bar2_xlat = ndev->reg_base + SNB_PBAR2XLAT_OFFSET;
 		ndev->reg_ofs.bar4_xlat = ndev->reg_base + SNB_PBAR4XLAT_OFFSET;
 
-		ndev->limits.max_mw = SNB_MAX_MW;
+		if (ndev->split_bar) {
+			ndev->reg_ofs.bar5_xlat =
+				ndev->reg_base + SNB_PBAR5XLAT_OFFSET;
+			ndev->limits.max_mw = HSX_SPLITBAR_MAX_MW;
+		} else
+			ndev->limits.max_mw = SNB_MAX_MW;
 		break;
 	default:
 		/*
@@ -1499,7 +1552,10 @@ static void ntb_hw_link_up(struct ntb_device *ndev)
 		ntb_cntl = readl(ndev->reg_ofs.lnk_cntl);
 		ntb_cntl &= ~(NTB_CNTL_LINK_DISABLE | NTB_CNTL_CFG_LOCK);
 		ntb_cntl |= NTB_CNTL_P2S_BAR23_SNOOP | NTB_CNTL_S2P_BAR23_SNOOP;
-		ntb_cntl |= NTB_CNTL_P2S_BAR45_SNOOP | NTB_CNTL_S2P_BAR45_SNOOP;
+		ntb_cntl |= NTB_CNTL_P2S_BAR4_SNOOP | NTB_CNTL_S2P_BAR4_SNOOP;
+		if (ndev->split_bar)
+			ntb_cntl |= NTB_CNTL_P2S_BAR5_SNOOP | NTB_CNTL_S2P_BAR5_SNOOP;
+
 		writel(ntb_cntl, ndev->reg_ofs.lnk_cntl);
 	}
 }
@@ -1516,14 +1572,25 @@ static void ntb_hw_link_down(struct ntb_device *ndev)
 	/* Bring NTB link down */
 	ntb_cntl = readl(ndev->reg_ofs.lnk_cntl);
 	ntb_cntl &= ~(NTB_CNTL_P2S_BAR23_SNOOP | NTB_CNTL_S2P_BAR23_SNOOP);
-	ntb_cntl &= ~(NTB_CNTL_P2S_BAR45_SNOOP | NTB_CNTL_S2P_BAR45_SNOOP);
+	ntb_cntl &= ~(NTB_CNTL_P2S_BAR4_SNOOP | NTB_CNTL_S2P_BAR4_SNOOP);
+	if (ndev->split_bar)
+		ntb_cntl &= ~(NTB_CNTL_P2S_BAR5_SNOOP | NTB_CNTL_S2P_BAR5_SNOOP);
 	ntb_cntl |= NTB_CNTL_LINK_DISABLE | NTB_CNTL_CFG_LOCK;
 	writel(ntb_cntl, ndev->reg_ofs.lnk_cntl);
 }
 
+static void ntb_max_mw_detect(struct ntb_device *ndev)
+{
+	if (ndev->split_bar)
+		ndev->limits.max_mw = HSX_SPLITBAR_MAX_MW;
+	else
+		ndev->limits.max_mw = SNB_MAX_MW;
+}
+
 static int ntb_xeon_detect(struct ntb_device *ndev)
 {
-	int rc;
+	int rc, bars_mask;
+	u32 bars;
 	u8 ppd;
 
 	ndev->hw_type = SNB_HW;
@@ -1537,6 +1604,8 @@ static int ntb_xeon_detect(struct ntb_device *ndev)
 	else
 		ndev->dev_type = NTB_DEV_DSD;
 
+	ndev->split_bar = (ppd & SNB_PPD_SPLIT_BAR) ? 1 : 0;
+
 	switch (ppd & SNB_PPD_CONN_TYPE) {
 	case NTB_CONN_B2B:
 		dev_info(&ndev->pdev->dev, "Conn Type = B2B\n");
@@ -1555,12 +1624,25 @@ static int ntb_xeon_detect(struct ntb_device *ndev)
 		 * NTB. We will just force correct here.
 		 */
 		ndev->dev_type = NTB_DEV_USD;
+
+		/*
+		 * This is a way for transparent BAR to figure out if we
+		 * are doing split BAR or not. There is no way for the hw
+		 * on the transparent side to know and set the PPD.
+		 */
+		bars_mask = pci_select_bars(ndev->pdev, IORESOURCE_MEM);
+		bars = hweight32(bars_mask);
+		if (bars == (HSX_SPLITBAR_MAX_MW + 1))
+			ndev->split_bar = 1;
+
 		break;
 	default:
 		dev_err(&ndev->pdev->dev, "Unknown PPD %x\n", ppd);
 		return -ENODEV;
 	}
 
+	ntb_max_mw_detect(ndev);
+
 	return 0;
 }
 
@@ -1638,22 +1720,50 @@ static int ntb_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	if (rc)
 		goto err;
 
-	rc = pci_request_selected_regions(pdev, NTB_BAR_MASK, KBUILD_MODNAME);
-	if (rc)
+	ndev->mw = kcalloc(sizeof(struct ntb_mw), ndev->limits.max_mw,
+			   GFP_KERNEL);
+	if (!ndev->mw) {
+		rc = -ENOMEM;
 		goto err1;
+	}
+
+	if (ndev->split_bar)
+		rc = pci_request_selected_regions(pdev, NTB_SPLITBAR_MASK,
+						  KBUILD_MODNAME);
+	else
+		rc = pci_request_selected_regions(pdev, NTB_BAR_MASK,
+						  KBUILD_MODNAME);
+
+	if (rc)
+		goto err2;
 
 	ndev->reg_base = pci_ioremap_bar(pdev, NTB_BAR_MMIO);
 	if (!ndev->reg_base) {
 		dev_warn(&pdev->dev, "Cannot remap BAR 0\n");
 		rc = -EIO;
-		goto err2;
+		goto err3;
 	}
 
-	for (i = 0; i < NTB_MAX_NUM_MW; i++) {
+	for (i = 0; i < ndev->limits.max_mw; i++) {
 		ndev->mw[i].bar_sz = pci_resource_len(pdev, MW_TO_BAR(i));
-		ndev->mw[i].vbase =
-		    ioremap_wc(pci_resource_start(pdev, MW_TO_BAR(i)),
-			       ndev->mw[i].bar_sz);
+
+		/*
+		 * with the errata we need to steal last of the memory
+		 * windows for workarounds and they point to MMIO registers.
+		 */
+		if ((ndev->wa_flags & WA_SNB_ERR) &&
+		    (i == (ndev->limits.max_mw - 1))) {
+			ndev->mw[i].vbase =
+				ioremap_nocache(pci_resource_start(pdev,
+							MW_TO_BAR(i)),
+						ndev->mw[i].bar_sz);
+		} else {
+			ndev->mw[i].vbase =
+				ioremap_wc(pci_resource_start(pdev,
+							MW_TO_BAR(i)),
+					   ndev->mw[i].bar_sz);
+		}
+
 		dev_info(&pdev->dev, "MW %d size %llu\n", i,
 			 (unsigned long long) ndev->mw[i].bar_sz);
 		if (!ndev->mw[i].vbase) {
@@ -1668,7 +1778,7 @@ static int ntb_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	if (rc) {
 		rc = pci_set_dma_mask(pdev, DMA_BIT_MASK(32));
 		if (rc)
-			goto err3;
+			goto err4;
 
 		dev_warn(&pdev->dev, "Cannot DMA highmem\n");
 	}
@@ -1677,22 +1787,22 @@ static int ntb_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	if (rc) {
 		rc = pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(32));
 		if (rc)
-			goto err3;
+			goto err4;
 
 		dev_warn(&pdev->dev, "Cannot DMA consistent highmem\n");
 	}
 
 	rc = ntb_device_setup(ndev);
 	if (rc)
-		goto err3;
+		goto err4;
 
 	rc = ntb_create_callbacks(ndev);
 	if (rc)
-		goto err4;
+		goto err5;
 
 	rc = ntb_setup_interrupts(ndev);
 	if (rc)
-		goto err5;
+		goto err6;
 
 	/* The scratchpad registers keep the values between rmmod/insmod,
 	 * blast them now
@@ -1704,24 +1814,29 @@ static int ntb_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 
 	rc = ntb_transport_init(pdev);
 	if (rc)
-		goto err6;
+		goto err7;
 
 	ntb_hw_link_up(ndev);
 
 	return 0;
 
-err6:
+err7:
 	ntb_free_interrupts(ndev);
-err5:
+err6:
 	ntb_free_callbacks(ndev);
-err4:
+err5:
 	ntb_device_free(ndev);
-err3:
+err4:
 	for (i--; i >= 0; i--)
 		iounmap(ndev->mw[i].vbase);
 	iounmap(ndev->reg_base);
+err3:
+	if (ndev->split_bar)
+		pci_release_selected_regions(pdev, NTB_SPLITBAR_MASK);
+	else
+		pci_release_selected_regions(pdev, NTB_BAR_MASK);
 err2:
-	pci_release_selected_regions(pdev, NTB_BAR_MASK);
+	kfree(ndev->mw);
 err1:
 	pci_disable_device(pdev);
 err:
@@ -1745,11 +1860,19 @@ static void ntb_pci_remove(struct pci_dev *pdev)
 	ntb_free_callbacks(ndev);
 	ntb_device_free(ndev);
 
-	for (i = 0; i < NTB_MAX_NUM_MW; i++)
+	/* need to reset max_mw limits so we can unmap properly */
+	if (ndev->hw_type == SNB_HW)
+		ntb_max_mw_detect(ndev);
+
+	for (i = 0; i < ndev->limits.max_mw; i++)
 		iounmap(ndev->mw[i].vbase);
 
+	kfree(ndev->mw);
 	iounmap(ndev->reg_base);
-	pci_release_selected_regions(pdev, NTB_BAR_MASK);
+	if (ndev->split_bar)
+		pci_release_selected_regions(pdev, NTB_SPLITBAR_MASK);
+	else
+		pci_release_selected_regions(pdev, NTB_BAR_MASK);
 	pci_disable_device(pdev);
 	ntb_free_debugfs(ndev);
 	kfree(ndev);
diff --git a/drivers/ntb/ntb_hw.h b/drivers/ntb/ntb_hw.h
index 5380ca1..96de5fc 100644
--- a/drivers/ntb/ntb_hw.h
+++ b/drivers/ntb/ntb_hw.h
@@ -78,14 +78,16 @@ static inline void writeq(u64 val, void __iomem *addr)
 
 #define NTB_BAR_MMIO		0
 #define NTB_BAR_23		2
-#define NTB_BAR_45		4
+#define NTB_BAR_4		4
+#define NTB_BAR_5		5
+
 #define NTB_BAR_MASK		((1 << NTB_BAR_MMIO) | (1 << NTB_BAR_23) |\
-				 (1 << NTB_BAR_45))
+				 (1 << NTB_BAR_4))
+#define NTB_SPLITBAR_MASK	((1 << NTB_BAR_MMIO) | (1 << NTB_BAR_23) |\
+				 (1 << NTB_BAR_4) | (1 << NTB_BAR_5))
 
 #define NTB_HB_TIMEOUT		msecs_to_jiffies(1000)
 
-#define NTB_MAX_NUM_MW		2
-
 enum ntb_hw_event {
 	NTB_EVENT_SW_EVENT0 = 0,
 	NTB_EVENT_SW_EVENT1,
@@ -115,7 +117,7 @@ struct ntb_device {
 	struct pci_dev *pdev;
 	struct msix_entry *msix_entries;
 	void __iomem *reg_base;
-	struct ntb_mw mw[NTB_MAX_NUM_MW];
+	struct ntb_mw *mw;
 	struct {
 		unsigned char max_mw;
 		unsigned char max_spads;
@@ -128,6 +130,7 @@ struct ntb_device {
 		void __iomem *rdb;
 		void __iomem *bar2_xlat;
 		void __iomem *bar4_xlat;
+		void __iomem *bar5_xlat;
 		void __iomem *spad_write;
 		void __iomem *spad_read;
 		void __iomem *lnk_cntl;
@@ -147,6 +150,7 @@ struct ntb_device {
 	unsigned char link_width;
 	unsigned char link_speed;
 	unsigned char link_status;
+	unsigned char split_bar;
 
 	struct delayed_work hb_timer;
 	unsigned long last_ts;
diff --git a/drivers/ntb/ntb_regs.h b/drivers/ntb/ntb_regs.h
index 0787205..f028ff8 100644
--- a/drivers/ntb/ntb_regs.h
+++ b/drivers/ntb/ntb_regs.h
@@ -57,6 +57,7 @@
 #define SNB_MAX_DB_BITS		15
 #define SNB_LINK_DB		15
 #define SNB_DB_BITS_PER_VEC	5
+#define HSX_SPLITBAR_MAX_MW	3
 #define SNB_MAX_MW		2
 #define SNB_ERRATA_MAX_MW	1
 
@@ -72,15 +73,20 @@
 
 #define SNB_PBAR2LMT_OFFSET	0x0000
 #define SNB_PBAR4LMT_OFFSET	0x0008
+#define SNB_PBAR5LMT_OFFSET	0x000C
 #define SNB_PBAR2XLAT_OFFSET	0x0010
 #define SNB_PBAR4XLAT_OFFSET	0x0018
+#define SNB_PBAR5XLAT_OFFSET	0x001C
 #define SNB_SBAR2LMT_OFFSET	0x0020
 #define SNB_SBAR4LMT_OFFSET	0x0028
+#define SNB_SBAR5LMT_OFFSET	0x002C
 #define SNB_SBAR2XLAT_OFFSET	0x0030
 #define SNB_SBAR4XLAT_OFFSET	0x0038
+#define SNB_SBAR5XLAT_OFFSET	0x003C
 #define SNB_SBAR0BASE_OFFSET	0x0040
 #define SNB_SBAR2BASE_OFFSET	0x0048
 #define SNB_SBAR4BASE_OFFSET	0x0050
+#define SNB_SBAR5BASE_OFFSET	0x0054
 #define SNB_NTBCNTL_OFFSET	0x0058
 #define SNB_SBDF_OFFSET		0x005C
 #define SNB_PDOORBELL_OFFSET	0x0060
@@ -96,12 +102,18 @@
 #define SNB_B2B_XLAT_OFFSETL	0x0144
 #define SNB_B2B_XLAT_OFFSETU	0x0148
 
-#define SNB_MBAR01_USD_ADDR	0x000000210000000CULL
-#define SNB_MBAR23_USD_ADDR	0x000000410000000CULL
-#define SNB_MBAR45_USD_ADDR	0x000000810000000CULL
-#define SNB_MBAR01_DSD_ADDR	0x000000200000000CULL
-#define SNB_MBAR23_DSD_ADDR	0x000000400000000CULL
-#define SNB_MBAR45_DSD_ADDR	0x000000800000000CULL
+/*
+ * The addresses are setup so the 32bit BARs can function. Thus
+ * the addresses are all in 32bit space
+ */
+#define SNB_MBAR01_USD_ADDR	0x000000002100000CULL
+#define SNB_MBAR23_USD_ADDR	0x000000004100000CULL
+#define SNB_MBAR4_USD_ADDR	0x000000008100000CULL
+#define SNB_MBAR5_USD_ADDR	0x00000000A100000CULL
+#define SNB_MBAR01_DSD_ADDR	0x000000002000000CULL
+#define SNB_MBAR23_DSD_ADDR	0x000000004000000CULL
+#define SNB_MBAR4_DSD_ADDR	0x000000008000000CULL
+#define SNB_MBAR5_DSD_ADDR	0x00000000A000000CULL
 
 #define BWD_MSIX_CNT		34
 #define BWD_MAX_SPADS		16
@@ -150,13 +162,16 @@
 #define NTB_CNTL_LINK_DISABLE		(1 << 1)
 #define NTB_CNTL_S2P_BAR23_SNOOP	(1 << 2)
 #define NTB_CNTL_P2S_BAR23_SNOOP	(1 << 4)
-#define NTB_CNTL_S2P_BAR45_SNOOP	(1 << 6)
-#define NTB_CNTL_P2S_BAR45_SNOOP	(1 << 8)
+#define NTB_CNTL_S2P_BAR4_SNOOP	(1 << 6)
+#define NTB_CNTL_P2S_BAR4_SNOOP	(1 << 8)
+#define NTB_CNTL_S2P_BAR5_SNOOP	(1 << 12)
+#define NTB_CNTL_P2S_BAR5_SNOOP	(1 << 14)
 #define BWD_CNTL_LINK_DOWN		(1 << 16)
 
 #define NTB_PPD_OFFSET		0x00D4
 #define SNB_PPD_CONN_TYPE	0x0003
 #define SNB_PPD_DEV_TYPE	0x0010
+#define SNB_PPD_SPLIT_BAR	(1 << 6)
 #define BWD_PPD_INIT_LINK	0x0008
 #define BWD_PPD_CONN_TYPE	0x0300
 #define BWD_PPD_DEV_TYPE	0x1000

