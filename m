Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756673AbaEAKDA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2014 06:03:00 -0400
Received: from mail-wi0-f173.google.com ([209.85.212.173]:39102 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755897AbaEAJ6M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2014 05:58:12 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: computersforpeace@gmail.com, linux-mtd@lists.infradead.org,
        kernel@stlinux.com, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 31/47] mtd: nand: stm_nand_bch: update flash-resident BBT(s)
Date: Thu,  1 May 2014 10:56:38 +0100
Message-Id: <1398938214-17847-32-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1398938214-17847-1-git-send-email-lee.jones@linaro.org>
References: <1398938214-17847-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Search for suitable block, erase and write table data to flash. If any
errors occur on selected block, mark it as bad and select another one.
Keep trying until both the Primary and Mirror BBTs are a) synced and
b) written successfully to flash.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/mtd/nand/stm_nand_bch.c | 143 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 143 insertions(+)

diff --git a/drivers/mtd/nand/stm_nand_bch.c b/drivers/mtd/nand/stm_nand_bch.c
index 8b70a36..e909d80 100644
--- a/drivers/mtd/nand/stm_nand_bch.c
+++ b/drivers/mtd/nand/stm_nand_bch.c
@@ -59,6 +59,11 @@ static uint8_t ibbt_sigs[2][NAND_IBBT_SIGLEN] = {
 	{'1', 't', 'b', 'B'},
 };
 
+static char *bbt_strs[] = {
+	"primary",
+	"mirror",
+};
+
 /* IBBT header */
 struct nand_ibbt_header {
 	uint8_t	signature[4];		/* "Bbt0" or "1tbB" signature */
@@ -787,6 +792,144 @@ static int bch_write_bbt_data(struct nandi_controller *nandi,
 	return 0;
 }
 
+/*
+ * Update Flash-resident BBT:
+ *   erase/search suitable block, and write table data to Flash
+ */
+static int bch_update_bbt(struct nandi_controller *nandi,
+			 struct nandi_bbt_info *bbt_info,
+			 int bak, uint8_t vers)
+{
+	loff_t offs;
+	uint32_t block;
+	uint32_t block_lower;
+	uint32_t block_other;
+
+	block_other = bbt_info->bbt_block[(bak+1)%2];
+	block_lower = nandi->blocks_per_device - NAND_IBBT_NBLOCKS;
+
+	for (block = bbt_info->bbt_block[bak]; block >= block_lower;  block--) {
+		offs = (loff_t)block << nandi->block_shift;
+
+		/* Skip if block used by other table */
+		if (block == block_other)
+			continue;
+
+		/* Skip if block is marked bad */
+		if (bbt_is_block_bad(bbt_info->bbt, block))
+			continue;
+
+		/* Erase block, mark bad and skip on failure */
+		if (bch_erase_block(nandi, offs) & NAND_STATUS_FAIL) {
+			dev_info(nandi->dev,
+				 "failed to erase block [%u:0x%012llx] while updating BBT\n",
+				 block, offs);
+			vers++;
+			bbt_set_block_mark(bbt_info->bbt, block,
+					   BBT_MARK_BAD_WEAR);
+			continue;
+		}
+
+		/* Write BBT, mark bad and skip on failure */
+		if (bch_write_bbt_data(nandi, bbt_info, block, bak, vers)) {
+			dev_info(nandi->dev,
+				 "failed to write BBT to block [%u:0x%012llx]\n",
+				 block, offs);
+			vers++;
+			bbt_set_block_mark(bbt_info->bbt, block,
+					   BBT_MARK_BAD_WEAR);
+			continue;
+		}
+
+		/* Success */
+		bbt_info->bbt_block[bak] = block;
+		bbt_info->bbt_vers[bak] = vers;
+		break;
+	}
+
+	/* No space in BBT area */
+	if (block < block_lower) {
+		dev_err(nandi->dev, "no space left in BBT area\n");
+		dev_err(nandi->dev, "failed to update %s BBT\n", bbt_strs[bak]);
+		return -ENOSPC;
+	}
+
+	dev_info(nandi->dev, "wrote BBT [%s:%u] at 0x%012llx [%u]\n",
+		 bbt_strs[bak], vers, offs, block);
+
+	return 0;
+}
+
+#define NAND_IBBT_UPDATE_PRIMARY	0x1
+#define NAND_IBBT_UPDATE_MIRROR		0x2
+#define NAND_IBBT_UPDATE_BOTH		(NAND_IBBT_UPDATE_PRIMARY | \
+					 NAND_IBBT_UPDATE_MIRROR)
+static char *bbt_update_strs[] = {
+	"",
+	"primary",
+	"mirror",
+	"both",
+};
+
+/*
+ * Update Flash-resident BBT(s):
+ *   incrementing 'vers' number if required, and ensuring Primary
+ *   and Mirror are kept in sync
+ */
+static int bch_update_bbts(struct nandi_controller *nandi,
+			   struct nandi_bbt_info *bbt_info,
+			   unsigned int update, uint8_t vers)
+{
+	int err;
+
+	dev_info(nandi->dev, "updating %s BBT(s)\n", bbt_update_strs[update]);
+
+	do {
+		/* Update Primary if specified */
+		if (update & NAND_IBBT_UPDATE_PRIMARY) {
+			err = bch_update_bbt(nandi, bbt_info, NAND_IBBT_PRIMARY,
+					     vers);
+			/* Bail out on error (e.g. no space left in BBT area) */
+			if (err)
+				return err;
+
+			/*
+			 * If update resulted in a new BBT version
+			 * (e.g. Erase/Write fail on BBT block) update version
+			 * here, and force update of other table.
+			 */
+			if (bbt_info->bbt_vers[NAND_IBBT_PRIMARY] != vers) {
+				vers = bbt_info->bbt_vers[NAND_IBBT_PRIMARY];
+				update = NAND_IBBT_UPDATE_MIRROR;
+			}
+		}
+
+		/* Update Mirror if specified */
+		if (update & NAND_IBBT_UPDATE_MIRROR) {
+			err = bch_update_bbt(nandi, bbt_info, NAND_IBBT_MIRROR,
+					     vers);
+			/* Bail out on error (e.g. no space left in BBT area) */
+			if (err)
+				return err;
+
+			/*
+			 * If update resulted in a new BBT version
+			 * (e.g. Erase/Write fail on BBT block) update version
+			 * here, and force update of other table.
+			 */
+			if (bbt_info->bbt_vers[NAND_IBBT_MIRROR] != vers) {
+				vers = bbt_info->bbt_vers[NAND_IBBT_MIRROR];
+				update = NAND_IBBT_UPDATE_PRIMARY;
+			}
+		}
+
+		/* Continue, until Primary and Mirror versions are in sync */
+	} while (bbt_info->bbt_vers[NAND_IBBT_PRIMARY] !=
+		 bbt_info->bbt_vers[NAND_IBBT_MIRROR]);
+
+	return 0;
+}
+
 /* Scan block for IBBT signature */
 static int bch_find_ibbt_sig(struct nandi_controller *nandi,
 			     uint32_t block, int *bak, uint8_t *vers,
-- 
1.8.3.2

