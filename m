Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756062AbaEAJ6Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2014 05:58:25 -0400
Received: from mail-wi0-f181.google.com ([209.85.212.181]:37475 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755941AbaEAJ6R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2014 05:58:17 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: computersforpeace@gmail.com, linux-mtd@lists.infradead.org,
        kernel@stlinux.com, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 34/47] mtd: nand: stm_nand_bch: scan block for BBM(s) according to specified BBT options
Date: Thu,  1 May 2014 10:56:41 +0100
Message-Id: <1398938214-17847-35-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1398938214-17847-1-git-send-email-lee.jones@linaro.org>
References: <1398938214-17847-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Search the specified (first and, second or last) page in a block for
the BBT. Support Hamming or Advanced Flex Mode (AFM) BBMs too.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/mtd/nand/stm_nand_bch.c | 62 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 62 insertions(+)

diff --git a/drivers/mtd/nand/stm_nand_bch.c b/drivers/mtd/nand/stm_nand_bch.c
index 32d2211..7d242ad 100644
--- a/drivers/mtd/nand/stm_nand_bch.c
+++ b/drivers/mtd/nand/stm_nand_bch.c
@@ -818,6 +818,66 @@ static int bbt_is_block_bad(uint8_t *bbt, uint32_t block)
 	return bbt_get_block_mark(bbt, block) == BBT_MARK_GOOD ? 0 : 1;
 }
 
+/* Scan page for BBM(s), according to specified BBT options */
+static int nandi_scan_bad_block_markers_page(struct nandi_controller *nandi,
+					     uint32_t page)
+{
+	struct mtd_info *mtd = &nandi->info.mtd;
+	struct nand_chip *chip = mtd->priv;
+	uint8_t *oob_buf = nandi->oob_buf;
+	int i, e;
+
+	/* Read the OOB area */
+	flex_read_raw(nandi, page, mtd->writesize, oob_buf, mtd->oobsize);
+
+	if (oob_buf[chip->badblockpos] == 0xff)
+		return 0;
+
+	/* Tolerate 'alien' Hamming Boot Mode ECC */
+	e = 0;
+	for (i = 0; i < mtd->oobsize; i += 16)
+		e += hweight8(oob_buf[i + 3] ^ 'B');
+	if (e <= 1)
+		return 0;
+
+	/* Tolerate 'alien' Hamming AFM ECC */
+	e = 0;
+	for (i = 0; i < mtd->oobsize; i += 16) {
+		e += hweight8(oob_buf[i + 3] ^ 'A');
+		e += hweight8(oob_buf[i + 4] ^ 'F');
+		e += hweight8(oob_buf[i + 5] ^ 'M');
+		if (e <= 1)
+			return 0;
+	}
+
+	return 1;
+}
+
+/* Scan block for BBM(s), according to specified BBT options */
+static int nandi_scan_bad_block_markers_block(struct nandi_controller *nandi,
+					      uint32_t block)
+
+{
+	struct mtd_info *mtd = &nandi->info.mtd;
+	struct nand_chip *chip = mtd->priv;
+	uint32_t pages_per_block = mtd->erasesize >> nandi->page_shift;
+	uint32_t page = block << (nandi->block_shift - nandi->page_shift);
+
+	if (nandi_scan_bad_block_markers_page(nandi, page))
+		return 1;
+
+	if ((chip->bbt_options & NAND_BBT_SCAN2NDPAGE) &&
+	    nandi_scan_bad_block_markers_page(nandi, page + 1))
+		return 1;
+
+	if ((chip->bbt_options & NAND_BBT_SCANLASTPAGE) &&
+	    nandi_scan_bad_block_markers_page(nandi,
+					      page + pages_per_block - 1))
+		return 1;
+
+	return 0;
+}
+
 /* Populate IBBT BCH Header */
 static void bch_fill_ibbt_header(struct nandi_controller *nandi,
 				 struct nand_ibbt_bch_header *ibbt_header,
@@ -1133,6 +1193,8 @@ static void nandi_set_mtd_defaults(struct nandi_controller *nandi,
 	chip->ecc.layout = &info->ecclayout;
 	chip->options |= NAND_NO_SUBPAGE_WRITE;
 
+	chip->bbt_options |= NAND_BBT_USE_FLASH;
+
 	/* mtd_info */
 	mtd->owner = THIS_MODULE;
 	mtd->type = MTD_NANDFLASH;
-- 
1.8.3.2

