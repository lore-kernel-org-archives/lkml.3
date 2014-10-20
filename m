Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753136AbaJTIzS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 04:55:18 -0400
Received: from down.free-electrons.com ([37.187.137.238]:47858 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752994AbaJTIzO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 04:55:14 -0400
X-Greylist: delayed 512 seconds by postgrey-1.27 at vger.kernel.org; Mon, 20 Oct 2014 04:55:14 EDT
From: Boris Brezillon <boris.brezillon@free-electrons.com>
To: David Woodhouse <dwmw2@infradead.org>,
        Brian Norris <computersforpeace@gmail.com>,
        linux-mtd@lists.infradead.org, Huang Shijie <shijie8@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Mike Voytovich <mvoytovich@paypal.com>, Roy Lee <roylee@paypal.com>,
        Boris Brezillon <boris.brezillon@free-electrons.com>
Subject: [PATCH v4 4/4] mtd: nand: gpmi: add raw oob access functions
Date: Mon, 20 Oct 2014 10:46:17 +0200
Message-Id: <1413794777-32220-5-git-send-email-boris.brezillon@free-electrons.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1413794777-32220-1-git-send-email-boris.brezillon@free-electrons.com>
References: <1413794777-32220-1-git-send-email-boris.brezillon@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Implement raw OOB access functions to retrieve OOB bytes when accessing the
NAND in raw mode.

Signed-off-by: Boris Brezillon <boris.brezillon@free-electrons.com>
---
 drivers/mtd/nand/gpmi-nand/gpmi-nand.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/drivers/mtd/nand/gpmi-nand/gpmi-nand.c b/drivers/mtd/nand/gpmi-nand/gpmi-nand.c
index bd4dedc..d7c483a 100644
--- a/drivers/mtd/nand/gpmi-nand/gpmi-nand.c
+++ b/drivers/mtd/nand/gpmi-nand/gpmi-nand.c
@@ -1473,6 +1473,22 @@ static int gpmi_ecc_write_page_raw(struct mtd_info *mtd,
 	return 0;
 }
 
+static int gpmi_ecc_read_oob_raw(struct mtd_info *mtd, struct nand_chip *chip,
+				 int page)
+{
+	chip->cmdfunc(mtd, NAND_CMD_READ0, 0, page);
+
+	return gpmi_ecc_read_page_raw(mtd, chip, NULL, 1, page);
+}
+
+static int gpmi_ecc_write_oob_raw(struct mtd_info *mtd, struct nand_chip *chip,
+				 int page)
+{
+	chip->cmdfunc(mtd, NAND_CMD_SEQIN, 0, page);
+
+	return gpmi_ecc_write_page_raw(mtd, chip, NULL, 1);
+}
+
 static int gpmi_block_markbad(struct mtd_info *mtd, loff_t ofs)
 {
 	struct nand_chip *chip = mtd->priv;
@@ -1792,6 +1808,8 @@ static int gpmi_init_last(struct gpmi_nand_data *this)
 	ecc->write_oob	= gpmi_ecc_write_oob;
 	ecc->read_page_raw = gpmi_ecc_read_page_raw;
 	ecc->write_page_raw = gpmi_ecc_write_page_raw;
+	ecc->read_oob_raw = gpmi_ecc_read_oob_raw;
+	ecc->write_oob_raw = gpmi_ecc_write_oob_raw;
 	ecc->mode	= NAND_ECC_HW;
 	ecc->size	= bch_geo->ecc_chunk_size;
 	ecc->strength	= bch_geo->ecc_strength;
-- 
1.9.1

