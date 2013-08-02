Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754181Ab3HBRga (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 13:36:30 -0400
Received: from mga03.intel.com ([143.182.124.21]:4478 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752983Ab3HBRg3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 13:36:29 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,802,1367996400"; 
   d="scan'208";a="340802443"
From: Jon Mason <jon.mason@intel.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 10/15] NTB: Rename Variables for NTB-RP
Date: Fri,  2 Aug 2013 10:35:39 -0700
Message-Id: <1375464944-27914-11-git-send-email-jon.mason@intel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1375464944-27914-1-git-send-email-jon.mason@intel.com>
References: <1375464944-27914-1-git-send-email-jon.mason@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Many variable names in the NTB driver refer to the primary or secondary
side.  However, these variables will be used to access the reverse case
when in NTB-RP mode.  Make these names more generic in anticipation of
NTB-RP support.

Signed-off-by: Jon Mason <jon.mason@intel.com>
---
 drivers/ntb/ntb_hw.c        |   83 +++++++++++++++++++++----------------------
 drivers/ntb/ntb_hw.h        |   12 +++----
 drivers/ntb/ntb_transport.c |    2 +-
 3 files changed, 48 insertions(+), 49 deletions(-)

diff --git a/drivers/ntb/ntb_hw.c b/drivers/ntb/ntb_hw.c
index 014222c..e7cbb44 100644
--- a/drivers/ntb/ntb_hw.c
+++ b/drivers/ntb/ntb_hw.c
@@ -167,9 +167,9 @@ int ntb_register_db_callback(struct ntb_device *ndev, unsigned int idx,
 	ndev->db_cb[idx].data = data;
 
 	/* unmask interrupt */
-	mask = readw(ndev->reg_ofs.pdb_mask);
+	mask = readw(ndev->reg_ofs.ldb_mask);
 	clear_bit(idx * ndev->bits_per_vector, &mask);
-	writew(mask, ndev->reg_ofs.pdb_mask);
+	writew(mask, ndev->reg_ofs.ldb_mask);
 
 	return 0;
 }
@@ -189,9 +189,9 @@ void ntb_unregister_db_callback(struct ntb_device *ndev, unsigned int idx)
 	if (idx >= ndev->max_cbs || !ndev->db_cb[idx].callback)
 		return;
 
-	mask = readw(ndev->reg_ofs.pdb_mask);
+	mask = readw(ndev->reg_ofs.ldb_mask);
 	set_bit(idx * ndev->bits_per_vector, &mask);
-	writew(mask, ndev->reg_ofs.pdb_mask);
+	writew(mask, ndev->reg_ofs.ldb_mask);
 
 	ndev->db_cb[idx].callback = NULL;
 }
@@ -423,16 +423,16 @@ void ntb_set_mw_addr(struct ntb_device *ndev, unsigned int mw, u64 addr)
 
 	switch (MW_TO_BAR(mw)) {
 	case NTB_BAR_23:
-		writeq(addr, ndev->reg_ofs.sbar2_xlat);
+		writeq(addr, ndev->reg_ofs.bar2_xlat);
 		break;
 	case NTB_BAR_45:
-		writeq(addr, ndev->reg_ofs.sbar4_xlat);
+		writeq(addr, ndev->reg_ofs.bar4_xlat);
 		break;
 	}
 }
 
 /**
- * ntb_ring_sdb() - Set the doorbell on the secondary/external side
+ * ntb_ring_doorbell() - Set the doorbell on the secondary/external side
  * @ndev: pointer to ntb_device instance
  * @db: doorbell to ring
  *
@@ -441,15 +441,15 @@ void ntb_set_mw_addr(struct ntb_device *ndev, unsigned int mw, u64 addr)
  *
  * RETURNS: An appropriate -ERRNO error value on error, or zero for success.
  */
-void ntb_ring_sdb(struct ntb_device *ndev, unsigned int db)
+void ntb_ring_doorbell(struct ntb_device *ndev, unsigned int db)
 {
 	dev_dbg(&ndev->pdev->dev, "%s: ringing doorbell %d\n", __func__, db);
 
 	if (ndev->hw_type == BWD_HW)
-		writeq((u64) 1 << db, ndev->reg_ofs.sdb);
+		writeq((u64) 1 << db, ndev->reg_ofs.rdb);
 	else
 		writew(((1 << ndev->bits_per_vector) - 1) <<
-		       (db * ndev->bits_per_vector), ndev->reg_ofs.sdb);
+		       (db * ndev->bits_per_vector), ndev->reg_ofs.rdb);
 }
 
 static void bwd_recover_link(struct ntb_device *ndev)
@@ -665,10 +665,10 @@ static int ntb_xeon_setup(struct ntb_device *ndev)
 	else
 		ndev->dev_type = NTB_DEV_DSD;
 
-	ndev->reg_ofs.pdb = ndev->reg_base + SNB_PDOORBELL_OFFSET;
-	ndev->reg_ofs.pdb_mask = ndev->reg_base + SNB_PDBMSK_OFFSET;
-	ndev->reg_ofs.sbar2_xlat = ndev->reg_base + SNB_SBAR2XLAT_OFFSET;
-	ndev->reg_ofs.sbar4_xlat = ndev->reg_base + SNB_SBAR4XLAT_OFFSET;
+	ndev->reg_ofs.ldb = ndev->reg_base + SNB_PDOORBELL_OFFSET;
+	ndev->reg_ofs.ldb_mask = ndev->reg_base + SNB_PDBMSK_OFFSET;
+	ndev->reg_ofs.bar2_xlat = ndev->reg_base + SNB_SBAR2XLAT_OFFSET;
+	ndev->reg_ofs.bar4_xlat = ndev->reg_base + SNB_SBAR4XLAT_OFFSET;
 	ndev->reg_ofs.lnk_cntl = ndev->reg_base + SNB_NTBCNTL_OFFSET;
 	ndev->reg_ofs.lnk_stat = ndev->reg_base + SNB_LINK_STATUS_OFFSET;
 	ndev->reg_ofs.spad_read = ndev->reg_base + SNB_SPAD_OFFSET;
@@ -687,7 +687,7 @@ static int ntb_xeon_setup(struct ntb_device *ndev)
 		ndev->limits.max_mw = SNB_ERRATA_MAX_MW;
 		ndev->reg_ofs.spad_write = ndev->mw[1].vbase +
 					   SNB_SPAD_OFFSET;
-		ndev->reg_ofs.sdb = ndev->mw[1].vbase +
+		ndev->reg_ofs.rdb = ndev->mw[1].vbase +
 				    SNB_PDOORBELL_OFFSET;
 
 		/* Set the Limit register to 4k, the minimum size, to
@@ -699,7 +699,7 @@ static int ntb_xeon_setup(struct ntb_device *ndev)
 		ndev->limits.max_mw = SNB_MAX_MW;
 		ndev->reg_ofs.spad_write = ndev->reg_base +
 					   SNB_B2B_SPAD_OFFSET;
-		ndev->reg_ofs.sdb = ndev->reg_base +
+		ndev->reg_ofs.rdb = ndev->reg_base +
 				    SNB_B2B_DOORBELL_OFFSET;
 
 		/* Disable the Limit register, just incase it is set to
@@ -791,21 +791,21 @@ static int ntb_bwd_setup(struct ntb_device *ndev)
 	if (rc)
 		return rc;
 
-	ndev->reg_ofs.pdb = ndev->reg_base + BWD_PDOORBELL_OFFSET;
-	ndev->reg_ofs.pdb_mask = ndev->reg_base + BWD_PDBMSK_OFFSET;
-	ndev->reg_ofs.sbar2_xlat = ndev->reg_base + BWD_SBAR2XLAT_OFFSET;
-	ndev->reg_ofs.sbar4_xlat = ndev->reg_base + BWD_SBAR4XLAT_OFFSET;
+	ndev->reg_ofs.ldb = ndev->reg_base + BWD_PDOORBELL_OFFSET;
+	ndev->reg_ofs.ldb_mask = ndev->reg_base + BWD_PDBMSK_OFFSET;
+	ndev->reg_ofs.bar2_xlat = ndev->reg_base + BWD_SBAR2XLAT_OFFSET;
+	ndev->reg_ofs.bar4_xlat = ndev->reg_base + BWD_SBAR4XLAT_OFFSET;
 	ndev->reg_ofs.lnk_cntl = ndev->reg_base + BWD_NTBCNTL_OFFSET;
 	ndev->reg_ofs.lnk_stat = ndev->reg_base + BWD_LINK_STATUS_OFFSET;
 	ndev->reg_ofs.spad_read = ndev->reg_base + BWD_SPAD_OFFSET;
 	ndev->reg_ofs.spci_cmd = ndev->reg_base + BWD_PCICMD_OFFSET;
 
 	if (ndev->conn_type == NTB_CONN_B2B) {
-		ndev->reg_ofs.sdb = ndev->reg_base + BWD_B2B_DOORBELL_OFFSET;
+		ndev->reg_ofs.rdb = ndev->reg_base + BWD_B2B_DOORBELL_OFFSET;
 		ndev->reg_ofs.spad_write = ndev->reg_base + BWD_B2B_SPAD_OFFSET;
 		ndev->limits.max_spads = BWD_MAX_SPADS;
 	} else {
-		ndev->reg_ofs.sdb = ndev->reg_base + BWD_PDOORBELL_OFFSET;
+		ndev->reg_ofs.rdb = ndev->reg_base + BWD_PDOORBELL_OFFSET;
 		ndev->reg_ofs.spad_write = ndev->reg_base + BWD_SPAD_OFFSET;
 		ndev->limits.max_spads = BWD_MAX_COMPAT_SPADS;
 	}
@@ -885,7 +885,7 @@ static irqreturn_t bwd_callback_msix_irq(int irq, void *data)
 	 */
 	ndev->last_ts = jiffies;
 
-	writeq((u64) 1 << db_cb->db_num, ndev->reg_ofs.pdb);
+	writeq((u64) 1 << db_cb->db_num, ndev->reg_ofs.ldb);
 
 	return IRQ_HANDLED;
 }
@@ -907,7 +907,7 @@ static irqreturn_t xeon_callback_msix_irq(int irq, void *data)
 	 * interrupts.
 	 */
 	writew(((1 << ndev->bits_per_vector) - 1) <<
-	       (db_cb->db_num * ndev->bits_per_vector), ndev->reg_ofs.pdb);
+	       (db_cb->db_num * ndev->bits_per_vector), ndev->reg_ofs.ldb);
 
 	return IRQ_HANDLED;
 }
@@ -925,7 +925,7 @@ static irqreturn_t xeon_event_msix_irq(int irq, void *dev)
 		dev_err(&ndev->pdev->dev, "Error determining link status\n");
 
 	/* bit 15 is always the link bit */
-	writew(1 << ndev->limits.max_db_bits, ndev->reg_ofs.pdb);
+	writew(1 << ndev->limits.max_db_bits, ndev->reg_ofs.ldb);
 
 	return IRQ_HANDLED;
 }
@@ -936,29 +936,28 @@ static irqreturn_t ntb_interrupt(int irq, void *dev)
 	unsigned int i = 0;
 
 	if (ndev->hw_type == BWD_HW) {
-		u64 pdb = readq(ndev->reg_ofs.pdb);
+		u64 ldb = readq(ndev->reg_ofs.ldb);
 
-		dev_dbg(&ndev->pdev->dev, "irq %d - pdb = %Lx\n", irq, pdb);
+		dev_dbg(&ndev->pdev->dev, "irq %d - ldb = %Lx\n", irq, ldb);
 
-		while (pdb) {
-			i = __ffs(pdb);
-			pdb &= pdb - 1;
+		while (ldb) {
+			i = __ffs(ldb);
+			ldb &= ldb - 1;
 			bwd_callback_msix_irq(irq, &ndev->db_cb[i]);
 		}
 	} else {
-		u16 pdb = readw(ndev->reg_ofs.pdb);
+		u16 ldb = readw(ndev->reg_ofs.ldb);
 
-		dev_dbg(&ndev->pdev->dev, "irq %d - pdb = %x sdb %x\n", irq,
-			pdb, readw(ndev->reg_ofs.sdb));
+		dev_dbg(&ndev->pdev->dev, "irq %d - ldb = %x\n", irq, ldb);
 
-		if (pdb & SNB_DB_HW_LINK) {
+		if (ldb & SNB_DB_HW_LINK) {
 			xeon_event_msix_irq(irq, dev);
-			pdb &= ~SNB_DB_HW_LINK;
+			ldb &= ~SNB_DB_HW_LINK;
 		}
 
-		while (pdb) {
-			i = __ffs(pdb);
-			pdb &= pdb - 1;
+		while (ldb) {
+			i = __ffs(ldb);
+			ldb &= ldb - 1;
 			xeon_callback_msix_irq(irq, &ndev->db_cb[i]);
 		}
 	}
@@ -1116,10 +1115,10 @@ static int ntb_setup_interrupts(struct ntb_device *ndev)
 	 * Interrupt.  The rest will be unmasked as callbacks are registered.
 	 */
 	if (ndev->hw_type == BWD_HW)
-		writeq(~0, ndev->reg_ofs.pdb_mask);
+		writeq(~0, ndev->reg_ofs.ldb_mask);
 	else
 		writew(~(1 << ndev->limits.max_db_bits),
-		       ndev->reg_ofs.pdb_mask);
+		       ndev->reg_ofs.ldb_mask);
 
 	rc = ntb_setup_msix(ndev);
 	if (!rc)
@@ -1148,9 +1147,9 @@ static void ntb_free_interrupts(struct ntb_device *ndev)
 
 	/* mask interrupts */
 	if (ndev->hw_type == BWD_HW)
-		writeq(~0, ndev->reg_ofs.pdb_mask);
+		writeq(~0, ndev->reg_ofs.ldb_mask);
 	else
-		writew(~0, ndev->reg_ofs.pdb_mask);
+		writew(~0, ndev->reg_ofs.ldb_mask);
 
 	if (ndev->num_msix) {
 		struct msix_entry *msix;
diff --git a/drivers/ntb/ntb_hw.h b/drivers/ntb/ntb_hw.h
index ab5f768..4b69f2e 100644
--- a/drivers/ntb/ntb_hw.h
+++ b/drivers/ntb/ntb_hw.h
@@ -124,11 +124,11 @@ struct ntb_device {
 		unsigned char msix_cnt;
 	} limits;
 	struct {
-		void __iomem *pdb;
-		void __iomem *pdb_mask;
-		void __iomem *sdb;
-		void __iomem *sbar2_xlat;
-		void __iomem *sbar4_xlat;
+		void __iomem *ldb;
+		void __iomem *ldb_mask;
+		void __iomem *rdb;
+		void __iomem *bar2_xlat;
+		void __iomem *bar4_xlat;
 		void __iomem *spad_write;
 		void __iomem *spad_read;
 		void __iomem *lnk_cntl;
@@ -243,7 +243,7 @@ int ntb_read_remote_spad(struct ntb_device *ndev, unsigned int idx, u32 *val);
 resource_size_t ntb_get_mw_base(struct ntb_device *ndev, unsigned int mw);
 void __iomem *ntb_get_mw_vbase(struct ntb_device *ndev, unsigned int mw);
 u64 ntb_get_mw_size(struct ntb_device *ndev, unsigned int mw);
-void ntb_ring_sdb(struct ntb_device *ndev, unsigned int idx);
+void ntb_ring_doorbell(struct ntb_device *ndev, unsigned int idx);
 void *ntb_find_transport(struct pci_dev *pdev);
 
 int ntb_transport_init(struct pci_dev *pdev);
diff --git a/drivers/ntb/ntb_transport.c b/drivers/ntb/ntb_transport.c
index 73a35e4..f206842 100644
--- a/drivers/ntb/ntb_transport.c
+++ b/drivers/ntb/ntb_transport.c
@@ -1197,7 +1197,7 @@ static void ntb_tx_copy_callback(void *data)
 	wmb();
 	iowrite32(entry->flags | DESC_DONE_FLAG, &hdr->flags);
 
-	ntb_ring_sdb(qp->ndev, qp->qp_num);
+	ntb_ring_doorbell(qp->ndev, qp->qp_num);
 
 	/* The entry length can only be zero if the packet is intended to be a
 	 * "link down" or similar.  Since no payload is being sent in these
-- 
1.7.9.5

