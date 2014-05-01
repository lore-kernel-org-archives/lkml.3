Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756526AbaEAKAc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2014 06:00:32 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:53042 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756095AbaEAJ6b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2014 05:58:31 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: computersforpeace@gmail.com, linux-mtd@lists.infradead.org,
        kernel@stlinux.com, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 42/47] mtd: nand: stm_nand_bch: MTD mark and check for bad blocks (BCH)
Date: Thu,  1 May 2014 10:56:49 +0100
Message-Id: <1398938214-17847-43-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1398938214-17847-1-git-send-email-lee.jones@linaro.org>
References: <1398938214-17847-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the local BBM helpers to check for and mark bad blocks.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/mtd/nand/stm_nand_bch.c | 49 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 49 insertions(+)

diff --git a/drivers/mtd/nand/stm_nand_bch.c b/drivers/mtd/nand/stm_nand_bch.c
index 11735ee..046e435 100644
--- a/drivers/mtd/nand/stm_nand_bch.c
+++ b/drivers/mtd/nand/stm_nand_bch.c
@@ -1275,6 +1275,53 @@ static int bch_scan_bbt(struct mtd_info *mtd)
 	return 0;
 }
 
+static int bch_block_isbad(struct mtd_info *mtd, loff_t offs, int getchip)
+{
+	struct nand_chip *chip = mtd->priv;
+	struct nandi_controller *nandi = chip->priv;
+
+	uint32_t block;
+
+	/* Check for invalid offset */
+	if (offs > mtd->size)
+		return -EINVAL;
+
+	block = offs >> nandi->block_shift;
+
+	/* Protect blocks reserved for BBTs */
+	if (block >= (nandi->blocks_per_device - NAND_IBBT_NBLOCKS))
+		return 1;
+
+	return bbt_is_block_bad(nandi->info.bbt_info.bbt, block);
+}
+
+static int bch_block_markbad(struct mtd_info *mtd, loff_t offs)
+{
+	struct nand_chip *chip = mtd->priv;
+	struct nandi_controller *nandi = chip->priv;
+
+	uint32_t block;
+	int ret;
+
+	/* Is block already considered bad? (will also catch invalid offsets) */
+	ret = mtd_block_isbad(mtd, offs);
+	if (ret < 0)
+		return ret;
+	if (ret == 1)
+		return 0;
+
+	/* Mark bad */
+	block = offs >> nandi->block_shift;
+	bbt_set_block_mark(nandi->info.bbt_info.bbt, block, BBT_MARK_BAD_WEAR);
+
+	/* Update BBTs, incrementing bbt_vers */
+	ret = bch_update_bbts(nandi, &nandi->info.bbt_info,
+			      NAND_IBBT_UPDATE_BOTH,
+			      nandi->info.bbt_info.bbt_vers[0] + 1);
+
+	return ret;
+}
+
 static void nandi_dump_bad_blocks(struct nandi_controller *nandi)
 {
 	int bad_count = 0;
@@ -1383,6 +1430,8 @@ static void nandi_set_mtd_defaults(struct nandi_controller *nandi,
 	chip->erase = bch_erase;
 
 	chip->scan_bbt = bch_scan_bbt;
+	chip->block_bad = bch_block_isbad;
+	chip->block_markbad = bch_block_markbad;
 }
 
 /*
-- 
1.8.3.2

