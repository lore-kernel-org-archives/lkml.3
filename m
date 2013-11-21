Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755475Ab3KUAYE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 19:24:04 -0500
Received: from mga11.intel.com ([192.55.52.93]:60838 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754207Ab3KUAVi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 19:21:38 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,740,1378882800"; 
   d="scan'208";a="436974384"
From: Jon Mason <jon.mason@intel.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 1/9] NTB: Xeon Doorbell errata workaround
Date: Wed, 20 Nov 2013 17:21:22 -0700
Message-Id: <1384993290-10107-2-git-send-email-jon.mason@intel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1384993290-10107-1-git-send-email-jon.mason@intel.com>
References: <1384993290-10107-1-git-send-email-jon.mason@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Modifications to the 14th bit of the B2BDOORBELL register will not be
mirrored to the remote system due to a hardware issue.  To get around
the issue, shrink the number of available doorbell bits by 1.  The max
number of doorbells was being used as a way to referencing the Link
Doorbell bit.  Since this would no longer work, the driver must now
explicitly reference that bit.

This does not affect the xeon_errata_workaround case, as it is not using
the b2bdoorbell register.

Signed-off-by: Jon Mason <jon.mason@intel.com>
---
 drivers/ntb/ntb_hw.c   |   20 +++++++++++++++-----
 drivers/ntb/ntb_regs.h |    1 +
 2 files changed, 16 insertions(+), 5 deletions(-)

diff --git a/drivers/ntb/ntb_hw.c b/drivers/ntb/ntb_hw.c
index 1cb6e51..6c9d733 100644
--- a/drivers/ntb/ntb_hw.c
+++ b/drivers/ntb/ntb_hw.c
@@ -678,6 +678,7 @@ static int ntb_xeon_setup(struct ntb_device *ndev)
 				return -EINVAL;
 
 			ndev->limits.max_mw = SNB_ERRATA_MAX_MW;
+			ndev->limits.max_db_bits = SNB_MAX_DB_BITS;
 			ndev->reg_ofs.spad_write = ndev->mw[1].vbase +
 						   SNB_SPAD_OFFSET;
 			ndev->reg_ofs.rdb = ndev->mw[1].vbase +
@@ -690,6 +691,13 @@ static int ntb_xeon_setup(struct ntb_device *ndev)
 			       SNB_PBAR4LMT_OFFSET);
 		} else {
 			ndev->limits.max_mw = SNB_MAX_MW;
+
+			/* HW Errata on bit 14 of b2bdoorbell register.  Writes
+			 * will not be mirrored to the remote system.  Shrink
+			 * the number of bits by one, since bit 14 is the last
+			 * bit.
+			 */
+			ndev->limits.max_db_bits = SNB_MAX_DB_BITS - 1;
 			ndev->reg_ofs.spad_write = ndev->reg_base +
 						   SNB_B2B_SPAD_OFFSET;
 			ndev->reg_ofs.rdb = ndev->reg_base +
@@ -769,6 +777,7 @@ static int ntb_xeon_setup(struct ntb_device *ndev)
 		 * have an equal amount.
 		 */
 		ndev->limits.max_spads = SNB_MAX_COMPAT_SPADS / 2;
+		ndev->limits.max_db_bits = SNB_MAX_DB_BITS;
 		/* Note: The SDOORBELL is the cause of the errata.  You REALLY
 		 * don't want to touch it.
 		 */
@@ -793,6 +802,7 @@ static int ntb_xeon_setup(struct ntb_device *ndev)
 		 * have an equal amount.
 		 */
 		ndev->limits.max_spads = SNB_MAX_COMPAT_SPADS / 2;
+		ndev->limits.max_db_bits = SNB_MAX_DB_BITS;
 		ndev->reg_ofs.rdb = ndev->reg_base + SNB_PDOORBELL_OFFSET;
 		ndev->reg_ofs.ldb = ndev->reg_base + SNB_SDOORBELL_OFFSET;
 		ndev->reg_ofs.ldb_mask = ndev->reg_base + SNB_SDBMSK_OFFSET;
@@ -819,7 +829,6 @@ static int ntb_xeon_setup(struct ntb_device *ndev)
 	ndev->reg_ofs.lnk_stat = ndev->reg_base + SNB_SLINK_STATUS_OFFSET;
 	ndev->reg_ofs.spci_cmd = ndev->reg_base + SNB_PCICMD_OFFSET;
 
-	ndev->limits.max_db_bits = SNB_MAX_DB_BITS;
 	ndev->limits.msix_cnt = SNB_MSIX_CNT;
 	ndev->bits_per_vector = SNB_DB_BITS_PER_VEC;
 
@@ -986,7 +995,7 @@ static irqreturn_t xeon_event_msix_irq(int irq, void *dev)
 		dev_err(&ndev->pdev->dev, "Error determining link status\n");
 
 	/* bit 15 is always the link bit */
-	writew(1 << ndev->limits.max_db_bits, ndev->reg_ofs.ldb);
+	writew(1 << SNB_LINK_DB, ndev->reg_ofs.ldb);
 
 	return IRQ_HANDLED;
 }
@@ -1176,9 +1185,10 @@ static int ntb_setup_interrupts(struct ntb_device *ndev)
 	 */
 	if (ndev->hw_type == BWD_HW)
 		writeq(~0, ndev->reg_ofs.ldb_mask);
-	else
-		writew(~(1 << ndev->limits.max_db_bits),
-		       ndev->reg_ofs.ldb_mask);
+	else {
+		u16 var = 1 << SNB_LINK_DB;
+		writew(~var, ndev->reg_ofs.ldb_mask);
+	}
 
 	rc = ntb_setup_msix(ndev);
 	if (!rc)
diff --git a/drivers/ntb/ntb_regs.h b/drivers/ntb/ntb_regs.h
index aa4bdd3..5381b65 100644
--- a/drivers/ntb/ntb_regs.h
+++ b/drivers/ntb/ntb_regs.h
@@ -55,6 +55,7 @@
 #define SNB_MAX_COMPAT_SPADS	16
 /* Reserve the uppermost bit for link interrupt */
 #define SNB_MAX_DB_BITS		15
+#define SNB_LINK_DB		15
 #define SNB_DB_BITS_PER_VEC	5
 #define SNB_MAX_MW		2
 #define SNB_ERRATA_MAX_MW	1
-- 
1.7.9.5

