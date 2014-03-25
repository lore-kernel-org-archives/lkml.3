Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753511AbaCYIYM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2014 04:24:12 -0400
Received: from mail-wi0-f181.google.com ([209.85.212.181]:62451 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753296AbaCYIVn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2014 04:21:43 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: lee.jones@linaro.org, kernel@stlinux.com, computersforpeace@gmail.com,
        linux-mtd@lists.infradead.org, dwmw2@infradead.org, angus.clark@st.com,
        pekon@ti.com
Subject: [RFC 44/47] mtd: nand: stm_nand_bch: MTD read and write (BCH)
Date: Tue, 25 Mar 2014 08:20:01 +0000
Message-Id: <1395735604-26706-45-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1395735604-26706-1-git-send-email-lee.jones@linaro.org>
References: <1395735604-26706-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

MTD interfaces: Standard set of callbacks for MTD functionality.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/mtd/nand/stm_nand_bch.c | 54 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 54 insertions(+)

diff --git a/drivers/mtd/nand/stm_nand_bch.c b/drivers/mtd/nand/stm_nand_bch.c
index bcaed32..f5b0a00 100644
--- a/drivers/mtd/nand/stm_nand_bch.c
+++ b/drivers/mtd/nand/stm_nand_bch.c
@@ -1226,6 +1226,58 @@ static int bch_load_bbt(struct nandi_controller *nandi,
 }
 
 /*
+ * MTD Interface: Standard set of callbacks for MTD functionality
+ */
+static int bch_mtd_read(struct mtd_info *mtd, loff_t from, size_t len,
+			size_t *retlen, uint8_t *buf)
+{
+	struct nand_chip *chip = mtd->priv;
+	struct nandi_controller *nandi = chip->priv;
+	int ret;
+
+	dev_dbg(nandi->dev, "%s: %llu @ 0x%012llx\n", __func__,
+		(unsigned long long)len, from);
+
+	nand_get_device(mtd, FL_READING);
+
+	ret = bch_read(nandi, from, len, retlen, buf);
+
+	nand_release_device(mtd);
+
+	return ret;
+}
+
+static int bch_mtd_write(struct mtd_info *mtd, loff_t to, size_t len,
+			 size_t *retlen, const uint8_t *buf)
+{
+	struct nand_chip *chip = mtd->priv;
+	struct nandi_controller *nandi = chip->priv;
+	uint32_t page_mask = mtd->writesize - 1;
+	int ret;
+
+	dev_dbg(nandi->dev, "%s: %llu @ 0x%012llx\n", __func__,
+		(unsigned long long)len, to);
+
+	if ((to & page_mask) || (len & page_mask)) {
+		dev_err(nandi->dev, "attempt to write non-page-aligned data\n");
+		return -EINVAL;
+	}
+
+	nand_get_device(mtd, FL_WRITING);
+
+	if (flex_check_wp(nandi)) {
+		dev_dbg(nandi->dev, "device is write-protected\n");
+		return -EIO;
+	}
+
+	ret = bch_write(nandi, to, len, retlen, buf);
+
+	nand_release_device(mtd);
+
+	return ret;
+}
+
+/*
  * Helper function for mtd_read_oob(): handles multi-page transfers
  * and mapping between BCH sectors and MTD page+OOB data.
  */
@@ -1701,6 +1753,8 @@ static void nandi_set_mtd_defaults(struct nandi_controller *nandi,
 	mtd->oobavail = 0;
 	mtd->subpage_sft = 0;
 
+	mtd->_read = bch_mtd_read;
+	mtd->_write = bch_mtd_write;
 	mtd->_erase = bch_mtd_erase;
 	mtd->_read_oob = bch_mtd_read_oob;
 	mtd->_write_oob = bch_mtd_write_oob;
-- 
1.8.3.2

