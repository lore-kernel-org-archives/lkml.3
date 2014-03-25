Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753331AbaCYIVo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2014 04:21:44 -0400
Received: from mail-wg0-f45.google.com ([74.125.82.45]:56649 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753274AbaCYIVk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2014 04:21:40 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: lee.jones@linaro.org, kernel@stlinux.com, computersforpeace@gmail.com,
        linux-mtd@lists.infradead.org, dwmw2@infradead.org, angus.clark@st.com,
        pekon@ti.com
Subject: [RFC 42/47] mtd: nand: stm_nand_bch: add read and write OOB (BCH)
Date: Tue, 25 Mar 2014 08:19:59 +0000
Message-Id: <1395735604-26706-43-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1395735604-26706-1-git-send-email-lee.jones@linaro.org>
References: <1395735604-26706-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Provide functions to read and write to the Out-Of-Bounds (OOB) area.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/mtd/nand/stm_nand_bch.c | 107 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 107 insertions(+)

diff --git a/drivers/mtd/nand/stm_nand_bch.c b/drivers/mtd/nand/stm_nand_bch.c
index 38658b8..389ccee 100644
--- a/drivers/mtd/nand/stm_nand_bch.c
+++ b/drivers/mtd/nand/stm_nand_bch.c
@@ -1218,6 +1218,111 @@ static int flex_do_write_ops(struct nandi_controller *nandi,
 	return 0;
 }
 
+static char *mtd_oob_mode_strs[] = {"PLACE", "AUTO", "RAW"};
+
+static int bch_mtd_read_and_write_oob(struct mtd_info *mtd, loff_t tofrom,
+				      struct mtd_oob_ops *ops,
+				      bool read)
+{
+	struct nand_chip *chip = mtd->priv;
+	struct nandi_controller *nandi = chip->priv;
+	uint32_t page_mask = mtd->writesize - 1;
+	int ret;
+
+	dev_dbg(nandi->dev, "%s: 0x%012llx [page = %u, oob = %u mode = %s]\n",
+		__func__, tofrom,
+		(ops->datbuf ? ops->len : 0),
+		(ops->oobbuf ? ops->ooblen : 0),
+		mtd_oob_mode_strs[ops->mode]);
+
+	if (!ops->oobbuf && ops->mode != MTD_OPS_RAW) {
+		if (read)
+			return mtd_read(mtd, tofrom, ops->len,
+					&ops->retlen, ops->datbuf);
+		else
+			return mtd_write(mtd, tofrom, ops->len,
+					 &ops->retlen, ops->datbuf);
+	}
+
+	ops->oobretlen = 0;
+	ops->retlen = 0;
+
+	/*
+	 * We report OOB as unavailable (i.e. oobavail = 0), therefore nothing
+	 * should call this
+	 */
+	if (ops->oobbuf && ops->mode == MTD_OPS_AUTO_OOB)
+		return -ENOTSUPP;
+
+	/* Not currently supported by MTD */
+	if (ops->datbuf && ops->oobbuf && ops->mode == MTD_OPS_PLACE_OOB)
+		return -ENOTSUPP;
+
+	/* Do not allow oob reads with ooboffs */
+	if (ops->oobbuf && ops->ooboffs)
+		return -ENOTSUPP;
+
+	/* Do not allow reads past end of device */
+	if (ops->datbuf && (tofrom + ops->len) > mtd->size) {
+		dev_err(nandi->dev, "attempt %s beyond end of device\n",
+			read ? "read" : "write");
+		return -EINVAL;
+	}
+
+	if (ops->oobbuf &&
+	    (tofrom + mtd->writesize * (ops->ooblen / mtd->oobsize))
+	    > mtd->size) {
+		dev_err(nandi->dev, "attempt %s beyond end of device\n",
+			read ? "read" : "write");
+		return -EINVAL;
+	}
+
+	/* Do not allow non-aligned reads/writes */
+	if ((tofrom & page_mask) ||
+	    (ops->datbuf && (ops->len & page_mask)) ||
+	    (ops->oobbuf && (ops->ooblen % mtd->oobsize))) {
+		dev_err(nandi->dev, "attempt to %s non-aligned data\n",
+			read ? "read" : "write");
+		return -EINVAL;
+	}
+
+	/* Do not allow inconsistent data and oob lengths */
+	if (ops->datbuf && ops->oobbuf &&
+	    (ops->len / mtd->writesize != ops->ooblen / mtd->oobsize)) {
+		dev_err(nandi->dev,
+			"data length inconsistent with oob length\n");
+		return -EINVAL;
+	}
+
+	nand_get_device(mtd, read ? FL_READING : FL_WRITING);
+
+	if (!read && flex_check_wp(nandi)) {
+		dev_dbg(nandi->dev, "device is write-protected\n");
+		return -EIO;
+	}
+
+	if (read)
+		ret = flex_do_read_ops(nandi, tofrom, ops);
+	else
+		ret = flex_do_write_ops(nandi, tofrom, ops);
+
+	nand_release_device(mtd);
+
+	return ret;
+}
+
+static int bch_mtd_read_oob(struct mtd_info *mtd, loff_t from,
+			    struct mtd_oob_ops *ops)
+{
+	return bch_mtd_read_and_write_oob(mtd, from, ops, true);
+}
+
+static int bch_mtd_write_oob(struct mtd_info *mtd, loff_t to,
+			     struct mtd_oob_ops *ops)
+{
+	return bch_mtd_read_and_write_oob(mtd, to, ops, false);
+}
+
 static int bch_mtd_block_isbad(struct mtd_info *mtd, loff_t offs)
 {
 	struct nand_chip *chip = mtd->priv;
@@ -1454,6 +1559,8 @@ static void nandi_set_mtd_defaults(struct nandi_controller *nandi,
 	mtd->subpage_sft = 0;
 
 	mtd->_erase = bch_mtd_erase;
+	mtd->_read_oob = bch_mtd_read_oob;
+	mtd->_write_oob = bch_mtd_write_oob;
 	mtd->_block_isbad = bch_mtd_block_isbad;
 	mtd->_block_markbad = bch_mtd_block_markbad;
 
-- 
1.8.3.2

