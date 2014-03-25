Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753097AbaCYIVQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2014 04:21:16 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:37941 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752791AbaCYIVL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2014 04:21:11 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: lee.jones@linaro.org, kernel@stlinux.com, computersforpeace@gmail.com,
        linux-mtd@lists.infradead.org, dwmw2@infradead.org, angus.clark@st.com,
        pekon@ti.com
Subject: [RFC 27/47] mtd: nand: stm_nand_bch: write IBBT to Flash
Date: Tue, 25 Mar 2014 08:19:44 +0000
Message-Id: <1395735604-26706-28-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1395735604-26706-1-git-send-email-lee.jones@linaro.org>
References: <1395735604-26706-1-git-send-email-lee.jones@linaro.org>
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
index 2d03113..76ed99b 100644
--- a/drivers/mtd/nand/stm_nand_bch.c
+++ b/drivers/mtd/nand/stm_nand_bch.c
@@ -541,6 +541,35 @@ static void bch_fill_ibbt_header(struct nandi_controller *nandi,
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

