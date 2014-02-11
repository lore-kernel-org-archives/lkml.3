Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753748AbaBKVrS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 16:47:18 -0500
Received: from mail-ee0-f48.google.com ([74.125.83.48]:34929 "EHLO
	mail-ee0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752869AbaBKVrP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 16:47:15 -0500
From: Boris BREZILLON <b.brezillon.dev@gmail.com>
To: David Woodhouse <dwmw2@infradead.org>,
        Brian Norris <computersforpeace@gmail.com>
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        Gupta Pekon <pekon@ti.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        Boris BREZILLON <b.brezillon.dev@gmail.com>
Subject: [RFC PATCH v2 1/4] mtd: nand: take nand_ecc_ctrl initialization out of nand_scan_tail
Date: Tue, 11 Feb 2014 22:46:46 +0100
Message-Id: <1392155209-14495-2-git-send-email-b.brezillon.dev@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1392155209-14495-1-git-send-email-b.brezillon.dev@gmail.com>
References: <1392155209-14495-1-git-send-email-b.brezillon.dev@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Take ECC initialization code portion out of nand_scan_tail so that we can
re-use this implementation.

Signed-off-by: Boris BREZILLON <b.brezillon.dev@gmail.com>
---
 drivers/mtd/nand/nand_base.c |   72 +++++++++++++++++++++++++++---------------
 1 file changed, 46 insertions(+), 26 deletions(-)

diff --git a/drivers/mtd/nand/nand_base.c b/drivers/mtd/nand/nand_base.c
index f59a465..f2e9312 100644
--- a/drivers/mtd/nand/nand_base.c
+++ b/drivers/mtd/nand/nand_base.c
@@ -3582,32 +3582,14 @@ int nand_scan_ident(struct mtd_info *mtd, int maxchips,
 }
 EXPORT_SYMBOL(nand_scan_ident);
 
-
-/**
- * nand_scan_tail - [NAND Interface] Scan for the NAND device
- * @mtd: MTD device structure
- *
- * This is the second phase of the normal nand_scan() function. It fills out
- * all the uninitialized function pointers with the defaults and scans for a
- * bad block table if appropriate.
+/*
+ * Initialize ECC struct:
+ *  - fill ECC struct with default function/values when these ones are undefined
+ *  - fill ECC infos based on MTD device
  */
-int nand_scan_tail(struct mtd_info *mtd)
+static int nand_ecc_ctrl_init(struct mtd_info *mtd, struct nand_ecc_ctrl *ecc)
 {
 	int i;
-	struct nand_chip *chip = mtd->priv;
-	struct nand_ecc_ctrl *ecc = &chip->ecc;
-
-	/* New bad blocks should be marked in OOB, flash-based BBT, or both */
-	BUG_ON((chip->bbt_options & NAND_BBT_NO_OOB_BBM) &&
-			!(chip->bbt_options & NAND_BBT_USE_FLASH));
-
-	if (!(chip->options & NAND_OWN_BUFFERS))
-		chip->buffers = kmalloc(sizeof(*chip->buffers), GFP_KERNEL);
-	if (!chip->buffers)
-		return -ENOMEM;
-
-	/* Set the internal oob buffer location, just after the page data */
-	chip->oob_poi = chip->buffers->databuf + mtd->writesize;
 
 	/*
 	 * If no default placement scheme is given, select an appropriate one.
@@ -3633,9 +3615,6 @@ int nand_scan_tail(struct mtd_info *mtd)
 		}
 	}
 
-	if (!chip->write_page)
-		chip->write_page = nand_write_page;
-
 	/*
 	 * Check ECC mode, default to software if 3byte/512byte hardware ECC is
 	 * selected and we have 256 byte pagesize fallback to software ECC
@@ -3802,6 +3781,47 @@ int nand_scan_tail(struct mtd_info *mtd)
 	}
 	ecc->total = ecc->steps * ecc->bytes;
 
+	return 0;
+}
+
+/**
+ * nand_scan_tail - [NAND Interface] Scan for the NAND device
+ * @mtd: MTD device structure
+ *
+ * This is the second phase of the normal nand_scan() function. It fills out
+ * all the uninitialized function pointers with the defaults and scans for a
+ * bad block table if appropriate.
+ */
+int nand_scan_tail(struct mtd_info *mtd)
+{
+	int ret;
+	struct nand_chip *chip = mtd->priv;
+	struct nand_ecc_ctrl *ecc = &chip->ecc;
+
+	/* New bad blocks should be marked in OOB, flash-based BBT, or both */
+	BUG_ON((chip->bbt_options & NAND_BBT_NO_OOB_BBM) &&
+			!(chip->bbt_options & NAND_BBT_USE_FLASH));
+
+	if (!(chip->options & NAND_OWN_BUFFERS))
+		chip->buffers = kmalloc(sizeof(*chip->buffers), GFP_KERNEL);
+	if (!chip->buffers)
+		return -ENOMEM;
+
+	/* Set the internal oob buffer location, just after the page data */
+	chip->oob_poi = chip->buffers->databuf + mtd->writesize;
+
+	if (!chip->write_page)
+		chip->write_page = nand_write_page;
+
+	/* Initialize ECC struct */
+	ret = nand_ecc_ctrl_init(mtd, ecc);
+	if (ret) {
+		if (!(chip->options & NAND_OWN_BUFFERS))
+			kfree(chip->buffers);
+
+		return ret;
+	}
+
 	/* Allow subpage writes up to ecc.steps. Not possible for MLC flash */
 	if (!(chip->options & NAND_NO_SUBPAGE_WRITE) && nand_is_slc(chip)) {
 		switch (ecc->steps) {
-- 
1.7.9.5

