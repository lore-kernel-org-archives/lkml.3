Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754265AbaCYImn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2014 04:42:43 -0400
Received: from mail-wi0-f176.google.com ([209.85.212.176]:52685 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753149AbaCYIVZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2014 04:21:25 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: lee.jones@linaro.org, kernel@stlinux.com, computersforpeace@gmail.com,
        linux-mtd@lists.infradead.org, dwmw2@infradead.org, angus.clark@st.com,
        pekon@ti.com
Subject: [RFC 35/47] mtd: nand: stm_nand_bch: dump bad blocks
Date: Tue, 25 Mar 2014 08:19:52 +0000
Message-Id: <1395735604-26706-36-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1395735604-26706-1-git-send-email-lee.jones@linaro.org>
References: <1395735604-26706-1-git-send-email-lee.jones@linaro.org>
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
index 6698b1f..abbb4d9 100644
--- a/drivers/mtd/nand/stm_nand_bch.c
+++ b/drivers/mtd/nand/stm_nand_bch.c
@@ -1060,6 +1060,28 @@ static int bch_load_bbt(struct nandi_controller *nandi,
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
@@ -1849,6 +1871,8 @@ static int stm_nand_bch_probe(struct platform_device *pdev)
 			return err;
 	}
 
+	nandi_dump_bad_blocks(nandi);
+
 	return 0;
 }
 
-- 
1.8.3.2

