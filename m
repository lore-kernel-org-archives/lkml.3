Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756107AbaEAJ6c (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2014 05:58:32 -0400
Received: from mail-wi0-f182.google.com ([209.85.212.182]:56892 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756056AbaEAJ6Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2014 05:58:25 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: computersforpeace@gmail.com, linux-mtd@lists.infradead.org,
        kernel@stlinux.com, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 38/47] mtd: nand: stm_nand_bch: dump bad blocks
Date: Thu,  1 May 2014 10:56:45 +0100
Message-Id: <1398938214-17847-39-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1398938214-17847-1-git-send-email-lee.jones@linaro.org>
References: <1398938214-17847-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Inform the user of any known bad blocks during initialisation.
Conversely, if there aren't any known bad blocks, let the user know
the good news.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/mtd/nand/stm_nand_bch.c | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/drivers/mtd/nand/stm_nand_bch.c b/drivers/mtd/nand/stm_nand_bch.c
index a06dca8..6aaa118 100644
--- a/drivers/mtd/nand/stm_nand_bch.c
+++ b/drivers/mtd/nand/stm_nand_bch.c
@@ -1259,6 +1259,28 @@ static int bch_scan_bbt(struct mtd_info *mtd)
 	return 0;
 }
 
+static void nandi_dump_bad_blocks(struct nandi_controller *nandi)
+{
+	int bad_count = 0;
+	uint32_t block;
+	uint8_t *bbt = nandi->info.bbt_info.bbt;
+	uint8_t mark;
+
+	pr_info("BBT:\n");
+	for (block = 0; block < nandi->blocks_per_device; block++) {
+		mark = bbt_get_block_mark(bbt, block);
+		if (mark != BBT_MARK_GOOD) {
+			pr_info("\t\tBlock 0x%08x [%05u] marked bad [%s]\n",
+				block << nandi->block_shift, block,
+				(mark == BBT_MARK_BAD_FACTORY) ?
+				"Factory" : "Wear");
+			bad_count++;
+		}
+	}
+	if (bad_count == 0)
+		pr_info("\t\tNo bad blocks listed in BBT\n");
+}
+
 /*
  * Initialisation
  */
@@ -2021,6 +2043,8 @@ static int stm_nand_bch_probe(struct platform_device *pdev)
 	if (err)
 		return err;
 
+	nandi_dump_bad_blocks(nandi);
+
 	return 0;
 }
 
-- 
1.8.3.2

