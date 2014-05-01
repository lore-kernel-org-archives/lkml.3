Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755974AbaEAJ6P (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2014 05:58:15 -0400
Received: from mail-wi0-f182.google.com ([209.85.212.182]:39797 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755941AbaEAJ6K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2014 05:58:10 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: computersforpeace@gmail.com, linux-mtd@lists.infradead.org,
        kernel@stlinux.com, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 30/47] mtd: nand: stm_nand_bch: write IBBT to Flash
Date: Thu,  1 May 2014 10:56:37 +0100
Message-Id: <1398938214-17847-31-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1398938214-17847-1-git-send-email-lee.jones@linaro.org>
References: <1398938214-17847-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Write BBT contents to the first page of a specified block, then
update the IBBT header and write it to last page of the same block.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/mtd/nand/stm_nand_bch.c | 29 +++++++++++++++++++++++++++++
 1 file changed, 29 insertions(+)

diff --git a/drivers/mtd/nand/stm_nand_bch.c b/drivers/mtd/nand/stm_nand_bch.c
index bf8669b..8b70a36 100644
--- a/drivers/mtd/nand/stm_nand_bch.c
+++ b/drivers/mtd/nand/stm_nand_bch.c
@@ -758,6 +758,35 @@ static void bch_fill_ibbt_header(struct nandi_controller *nandi,
 	memcpy(ibbt_header->author, author, sizeof(author));
 }
 
+/* Write IBBT to Flash */
+static int bch_write_bbt_data(struct nandi_controller *nandi,
+			      struct nandi_bbt_info *bbt_info,
+			      uint32_t block, int bak, uint8_t vers)
+{
+	uint32_t page_size = nandi->info.mtd.writesize;
+	uint32_t block_size = nandi->info.mtd.erasesize;
+	struct nand_ibbt_bch_header *ibbt_header =
+		(struct nand_ibbt_bch_header *)nandi->page_buf;
+	loff_t offs;
+
+	nandi->cached_page = -1;
+
+	/* Write BBT contents to first page of block */
+	offs = (loff_t)block << nandi->block_shift;
+	if (bch_write_page(nandi, offs, bbt_info->bbt) & NAND_STATUS_FAIL)
+		return 1;
+
+	/* Update IBBT header and write to last page of block */
+	memset(ibbt_header, 0xff, nandi->info.mtd.writesize);
+	bch_fill_ibbt_header(nandi, ibbt_header, bak, vers);
+	offs += block_size - page_size;
+	if (bch_write_page(nandi, offs, (uint8_t *)ibbt_header) &
+	    NAND_STATUS_FAIL)
+		return 1;
+
+	return 0;
+}
+
 /* Scan block for IBBT signature */
 static int bch_find_ibbt_sig(struct nandi_controller *nandi,
 			     uint32_t block, int *bak, uint8_t *vers,
-- 
1.8.3.2

