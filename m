Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756715AbaEAKDq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2014 06:03:46 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:43416 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755768AbaEAJ6H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2014 05:58:07 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: computersforpeace@gmail.com, linux-mtd@lists.infradead.org,
        kernel@stlinux.com, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 28/47] mtd: nand: stm_nand_bch: bad block marking helpers
Date: Thu,  1 May 2014 10:56:35 +0100
Message-Id: <1398938214-17847-29-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1398938214-17847-1-git-send-email-lee.jones@linaro.org>
References: <1398938214-17847-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bad Block Markers (BBMs) keep track of unusable/unsuitable memory
blocks which can prevent unnecessary data loss. These helpers aid in
reading and writing to/from the Bad Block Tables (BBTs) where the BBMs
are stored.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/mtd/nand/stm_nand_bch.c | 29 +++++++++++++++++++++++++++++
 1 file changed, 29 insertions(+)

diff --git a/drivers/mtd/nand/stm_nand_bch.c b/drivers/mtd/nand/stm_nand_bch.c
index 83faffe..27a87a3 100644
--- a/drivers/mtd/nand/stm_nand_bch.c
+++ b/drivers/mtd/nand/stm_nand_bch.c
@@ -712,6 +712,35 @@ static int bch_write(struct mtd_info *mtd, struct nand_chip *chip,
 	return 0;
 }
 
+/*
+ * Bad Block Tables/Bad Block Markers
+ */
+#define BBT_MARK_BAD_FACTORY	0x0
+#define BBT_MARK_BAD_WEAR	0x1
+#define BBT_MARK_GOOD		0x3
+
+static void bbt_set_block_mark(uint8_t *bbt, uint32_t block, uint8_t mark)
+{
+	unsigned int byte = block >> 2;
+	unsigned int shift = (block & 0x3) << 1;
+
+	bbt[byte] &= ~(0x3 << shift);
+	bbt[byte] |= ((mark & 0x3) << shift);
+}
+
+static uint8_t bbt_get_block_mark(uint8_t *bbt, uint32_t block)
+{
+	unsigned int byte = block >> 2;
+	unsigned int shift = (block & 0x3) << 1;
+
+	return (bbt[byte] >> shift) & 0x3;
+}
+
+static int bbt_is_block_bad(uint8_t *bbt, uint32_t block)
+{
+	return bbt_get_block_mark(bbt, block) == BBT_MARK_GOOD ? 0 : 1;
+}
+
 /* Scan block for IBBT signature */
 static int bch_find_ibbt_sig(struct nandi_controller *nandi,
 			     uint32_t block, int *bak, uint8_t *vers,
-- 
1.8.3.2

