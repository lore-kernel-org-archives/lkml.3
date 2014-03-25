Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753287AbaCYIVj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2014 04:21:39 -0400
Received: from mail-we0-f173.google.com ([74.125.82.173]:62231 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753132AbaCYIVh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2014 04:21:37 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: lee.jones@linaro.org, kernel@stlinux.com, computersforpeace@gmail.com,
        linux-mtd@lists.infradead.org, dwmw2@infradead.org, angus.clark@st.com,
        pekon@ti.com
Subject: [RFC 41/47] mtd: nand: stm_nand_bch: MTD mark and check for bad blocks (BCH)
Date: Tue, 25 Mar 2014 08:19:58 +0000
Message-Id: <1395735604-26706-42-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1395735604-26706-1-git-send-email-lee.jones@linaro.org>
References: <1395735604-26706-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the local BBM helpers to check for and mark bad blocks.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/mtd/nand/stm_nand_bch.c | 51 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 51 insertions(+)

diff --git a/drivers/mtd/nand/stm_nand_bch.c b/drivers/mtd/nand/stm_nand_bch.c
index 55f4a4c..38658b8 100644
--- a/drivers/mtd/nand/stm_nand_bch.c
+++ b/drivers/mtd/nand/stm_nand_bch.c
@@ -1218,6 +1218,55 @@ static int flex_do_write_ops(struct nandi_controller *nandi,
 	return 0;
 }
 
+static int bch_mtd_block_isbad(struct mtd_info *mtd, loff_t offs)
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
+static int bch_mtd_block_markbad(struct mtd_info *mtd, loff_t offs)
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
+	nand_get_device(mtd, FL_WRITING);
+	ret = bch_update_bbts(nandi, &nandi->info.bbt_info,
+			      NAND_IBBT_UPDATE_BOTH,
+			      nandi->info.bbt_info.bbt_vers[0] + 1);
+	nand_release_device(mtd);
+
+	return ret;
+}
+
 static int bch_mtd_erase(struct mtd_info *mtd, struct erase_info *instr)
 {
 	struct nand_chip *chip = mtd->priv;
@@ -1405,6 +1454,8 @@ static void nandi_set_mtd_defaults(struct nandi_controller *nandi,
 	mtd->subpage_sft = 0;
 
 	mtd->_erase = bch_mtd_erase;
+	mtd->_block_isbad = bch_mtd_block_isbad;
+	mtd->_block_markbad = bch_mtd_block_markbad;
 
 	mtd->_point = NULL;
 	mtd->_unpoint = NULL;
-- 
1.8.3.2

