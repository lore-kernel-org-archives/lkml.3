Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753363AbaCYIVq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2014 04:21:46 -0400
Received: from mail-we0-f176.google.com ([74.125.82.176]:41871 "EHLO
	mail-we0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753285AbaCYIVk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2014 04:21:40 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: lee.jones@linaro.org, kernel@stlinux.com, computersforpeace@gmail.com,
        linux-mtd@lists.infradead.org, dwmw2@infradead.org, angus.clark@st.com,
        pekon@ti.com
Subject: [RFC 40/47] mtd: nand: stm_nand_bch: MTD erase (BCH)
Date: Tue, 25 Mar 2014 08:19:57 +0000
Message-Id: <1395735604-26706-41-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1395735604-26706-1-git-send-email-lee.jones@linaro.org>
References: <1395735604-26706-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Carry out the normal checks, then attempt to erase a given block.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/mtd/nand/stm_nand_bch.c | 85 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 85 insertions(+)

diff --git a/drivers/mtd/nand/stm_nand_bch.c b/drivers/mtd/nand/stm_nand_bch.c
index 75c5c9b..55f4a4c 100644
--- a/drivers/mtd/nand/stm_nand_bch.c
+++ b/drivers/mtd/nand/stm_nand_bch.c
@@ -1218,6 +1218,89 @@ static int flex_do_write_ops(struct nandi_controller *nandi,
 	return 0;
 }
 
+static int bch_mtd_erase(struct mtd_info *mtd, struct erase_info *instr)
+{
+	struct nand_chip *chip = mtd->priv;
+	struct nandi_controller *nandi = chip->priv;
+	uint64_t block_mask = mtd->erasesize - 1;
+	uint64_t offs_cached;
+	loff_t offs = instr->addr;
+	size_t len = instr->len;
+	uint8_t status;
+	int ret;
+
+	dev_dbg(nandi->dev, "%s: 0x%012llx @ 0x%012llx\n", __func__,
+		(unsigned long long)len, offs);
+
+	if (offs & block_mask) {
+		dev_err(nandi->dev,
+			"attempt to erase from non-block-aligned offset\n");
+		return -EINVAL;
+	}
+
+	if (len & block_mask) {
+		dev_err(nandi->dev,
+			"attempt to erase non-block-aligned length\n");
+		return -EINVAL;
+	}
+
+	if ((offs + len) > mtd->size) {
+		dev_err(nandi->dev, "attempt to erase past end of device\n");
+		return -EINVAL;
+	}
+
+	nand_get_device(mtd, FL_ERASING);
+	instr->fail_addr = MTD_FAIL_ADDR_UNKNOWN;
+
+	if (flex_check_wp(nandi)) {
+		dev_dbg(nandi->dev, "device is write-protected\n");
+		instr->state = MTD_ERASE_FAILED;
+		goto erase_exit;
+	}
+
+	/* Offset of block containing cached page */
+	offs_cached = ((uint64_t)nandi->cached_page << nandi->page_shift) &
+		~block_mask;
+
+	instr->state = MTD_ERASING;
+	while (len) {
+		if (mtd_block_isbad(mtd, offs)) {
+			dev_err(nandi->dev,
+				"attempt to erase a bad block at 0x%012llx\n",
+				offs);
+			instr->state = MTD_ERASE_FAILED;
+			instr->fail_addr = offs;
+			goto erase_exit;
+		}
+
+		if (offs == offs_cached)
+			nandi->cached_page = -1;
+
+		status = bch_erase_block(nandi, offs);
+
+		if (status & NAND_STATUS_FAIL) {
+			dev_err(nandi->dev,
+				"failed to erase block at 0x%012llx\n", offs);
+			instr->state = MTD_ERASE_FAILED;
+			instr->fail_addr = offs;
+			goto erase_exit;
+		}
+
+		len -= mtd->erasesize;
+		offs += mtd->erasesize;
+	}
+	instr->state = MTD_ERASE_DONE;
+
+ erase_exit:
+	nand_release_device(mtd);
+
+	ret = instr->state == MTD_ERASE_DONE ? 0 : -EIO;
+	if (ret == 0)
+		mtd_erase_callback(instr);
+
+	return ret;
+}
+
 static void nandi_dump_bad_blocks(struct nandi_controller *nandi)
 {
 	int bad_count = 0;
@@ -1321,6 +1404,8 @@ static void nandi_set_mtd_defaults(struct nandi_controller *nandi,
 	mtd->oobavail = 0;
 	mtd->subpage_sft = 0;
 
+	mtd->_erase = bch_mtd_erase;
+
 	mtd->_point = NULL;
 	mtd->_unpoint = NULL;
 	mtd->_lock = NULL;
-- 
1.8.3.2

