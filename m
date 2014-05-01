Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751920AbaEABK2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 21:10:28 -0400
Received: from mail-ee0-f41.google.com ([74.125.83.41]:65247 "EHLO
	mail-ee0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751507AbaEABKX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 21:10:23 -0400
From: Boris BREZILLON <b.brezillon.dev@gmail.com>
To: Brian Norris <computersforpeace@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>
Cc: Maxime Ripard <maxime.ripard@free-electrons.com>,
        linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        Boris BREZILLON <b.brezillon.dev@gmail.com>
Subject: [RFC PATCH 3/3] mtd: nand: add sunxi randomizer support
Date: Thu,  1 May 2014 03:09:52 +0200
Message-Id: <1398906592-24677-4-git-send-email-b.brezillon.dev@gmail.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1398906592-24677-1-git-send-email-b.brezillon.dev@gmail.com>
References: <1398906592-24677-1-git-send-email-b.brezillon.dev@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for the HW randomizer available in the sunxi IP.

Signed-off-by: Boris BREZILLON <b.brezillon.dev@gmail.com>
---
 drivers/mtd/nand/sunxi_nand.c | 511 +++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 500 insertions(+), 11 deletions(-)

diff --git a/drivers/mtd/nand/sunxi_nand.c b/drivers/mtd/nand/sunxi_nand.c
index 54d3ebd..2f76912 100644
--- a/drivers/mtd/nand/sunxi_nand.c
+++ b/drivers/mtd/nand/sunxi_nand.c
@@ -171,6 +171,7 @@ struct sunxi_nand_hw_ecc {
 struct sunxi_nand_part {
 	struct nand_part part;
 	struct nand_ecc_ctrl ecc;
+	struct nand_rnd_ctrl rnd;
 };
 
 static inline struct sunxi_nand_part *
@@ -179,6 +180,17 @@ to_sunxi_nand_part(struct nand_part *part)
 	return container_of(part, struct sunxi_nand_part, part);
 }
 
+struct sunxi_nand_hw_rnd {
+	int page;
+	int column;
+	int nseeds;
+	u16 *seeds;
+	u16 *subseeds;
+	u16 (*step)(struct mtd_info *mtd, u16 state, int column, int *left);
+	int left;
+	u16 state;
+};
+
 struct sunxi_nand_chip {
 	struct list_head node;
 	struct nand_chip nand;
@@ -380,6 +392,175 @@ static void sunxi_nfc_write_buf(struct mtd_info *mtd, const uint8_t *buf,
 	}
 }
 
+static u16 sunxi_nfc_hwrnd_step(struct sunxi_nand_hw_rnd *rnd, u16 state,
+				int count)
+{
+	state &= 0x7fff;
+	count *= 8;
+	while (count--)
+		state = ((state >> 1) |
+			 ((((state >> 0) ^ (state >> 1)) & 1) << 14)) & 0x7fff;
+
+	return state;
+}
+
+static int sunxi_nfc_hwrnd_config(struct mtd_info *mtd, int page, int column,
+				  enum nand_rnd_action action)
+{
+	struct nand_chip *nand = mtd->priv;
+	struct sunxi_nand_hw_rnd *rnd = nand->cur_rnd->priv;
+	u16 state;
+
+	if (page < 0 && column < 0) {
+		rnd->page = -1;
+		rnd->column = -1;
+		return 0;
+	}
+
+	if (column < 0)
+		column = 0;
+	if (page < 0)
+		page = rnd->page;
+
+	if (page < 0)
+		return -EINVAL;
+
+	if (page != rnd->page && action == NAND_RND_READ) {
+		int status;
+
+		status = nand_page_get_status(mtd, page);
+		if (status == NAND_PAGE_STATUS_UNKNOWN) {
+			nand->cmdfunc(mtd, NAND_CMD_RNDOUT, 0, -1);
+			sunxi_nfc_read_buf(mtd, nand->buffers->databuf,
+					   mtd->writesize + mtd->oobsize);
+
+			if (nand_page_is_empty(mtd))
+				status = NAND_PAGE_EMPTY;
+			else
+				status = NAND_PAGE_FILLED;
+
+			nand_page_set_status(mtd, page, status);
+			nand->cmdfunc(mtd, NAND_CMD_RNDOUT, column, -1);
+		}
+	}
+
+	state = rnd->seeds[page % rnd->nseeds];
+	rnd->page = page;
+	rnd->column = column;
+
+	if (rnd->step) {
+		rnd->state = rnd->step(mtd, state, column, &rnd->left);
+	} else {
+		rnd->state = sunxi_nfc_hwrnd_step(rnd, state, column % 4096);
+		rnd->left = mtd->oobsize + mtd->writesize - column;
+	}
+
+	return 0;
+}
+
+static void sunxi_nfc_hwrnd_write_buf(struct mtd_info *mtd, const uint8_t *buf,
+				      int len)
+{
+	struct nand_chip *nand = mtd->priv;
+	struct sunxi_nfc *nfc = to_sunxi_nfc(nand->controller);
+	struct sunxi_nand_hw_rnd *rnd = nand->cur_rnd->priv;
+	u32 tmp = readl(nfc->regs + NFC_REG_ECC_CTL);
+	int cnt;
+	int offs = 0;
+	int rndactiv;
+
+	tmp &= ~(NFC_RANDOM_DIRECTION | NFC_RANDOM_SEED | NFC_RANDOM_EN);
+	writel(tmp, nfc->regs + NFC_REG_ECC_CTL);
+
+	if (rnd->page < 0) {
+		sunxi_nfc_write_buf(mtd, buf, len);
+		return;
+	}
+
+	while (len > offs) {
+		cnt = len - offs;
+		if (cnt > 1024)
+			cnt = 1024;
+
+		rndactiv = nand_rnd_is_activ(mtd, rnd->page, rnd->column,
+					     &cnt);
+		if (rndactiv > 0) {
+			writel(tmp | NFC_RANDOM_EN | (rnd->state << 16),
+			       nfc->regs + NFC_REG_ECC_CTL);
+			if (rnd->left < cnt)
+				cnt = rnd->left;
+		}
+
+		sunxi_nfc_write_buf(mtd, buf + offs, cnt);
+
+		if (rndactiv > 0)
+			writel(tmp & ~NFC_RANDOM_EN,
+			       nfc->regs + NFC_REG_ECC_CTL);
+
+		offs += cnt;
+		if (len <= offs)
+			break;
+
+		sunxi_nfc_hwrnd_config(mtd, -1, rnd->column + cnt,
+				       NAND_RND_WRITE);
+	}
+}
+
+static void sunxi_nfc_hwrnd_read_buf(struct mtd_info *mtd, uint8_t *buf,
+				     int len)
+{
+	struct nand_chip *nand = mtd->priv;
+	struct sunxi_nfc *nfc = to_sunxi_nfc(nand->controller);
+	struct sunxi_nand_hw_rnd *rnd = nand->cur_rnd->priv;
+	u32 tmp = readl(nfc->regs + NFC_REG_ECC_CTL);
+	int cnt;
+	int offs = 0;
+	int rndactiv;
+
+	tmp &= ~(NFC_RANDOM_DIRECTION | NFC_RANDOM_SEED | NFC_RANDOM_EN);
+	writel(tmp, nfc->regs + NFC_REG_ECC_CTL);
+
+	if (rnd->page < 0) {
+		sunxi_nfc_read_buf(mtd, buf, len);
+		return;
+	}
+
+	while (len > offs) {
+		cnt = len - offs;
+		if (cnt > 1024)
+			cnt = 1024;
+
+		if (nand_page_get_status(mtd, rnd->page) != NAND_PAGE_EMPTY &&
+		    nand_rnd_is_activ(mtd, rnd->page, rnd->column, &cnt) > 0)
+			rndactiv = 1;
+		else
+			rndactiv = 0;
+
+		if (rndactiv > 0) {
+			writel(tmp | NFC_RANDOM_EN | (rnd->state << 16),
+			       nfc->regs + NFC_REG_ECC_CTL);
+			if (rnd->left < cnt)
+				cnt = rnd->left;
+		}
+
+		if (buf)
+			sunxi_nfc_read_buf(mtd, buf + offs, cnt);
+		else
+			sunxi_nfc_read_buf(mtd, NULL, cnt);
+
+		if (rndactiv > 0)
+			writel(tmp & ~NFC_RANDOM_EN,
+			       nfc->regs + NFC_REG_ECC_CTL);
+
+		offs += cnt;
+		if (len <= offs)
+			break;
+
+		sunxi_nfc_hwrnd_config(mtd, -1, rnd->column + cnt,
+				       NAND_RND_READ);
+	}
+}
+
 static uint8_t sunxi_nfc_read_byte(struct mtd_info *mtd)
 {
 	uint8_t ret;
@@ -432,11 +613,35 @@ static int sunxi_nfc_hw_ecc_read_page(struct mtd_info *mtd,
 	struct sunxi_nand_hw_ecc *data = ecc->priv;
 	int steps = mtd->writesize / ecc->size;
 	unsigned int max_bitflips = 0;
+	int status;
 	int offset;
 	u32 tmp;
 	int i;
 	int cnt;
 
+	status = nand_page_get_status(mtd, page);
+	if (status == NAND_PAGE_STATUS_UNKNOWN) {
+		chip->cmdfunc(mtd, NAND_CMD_RNDOUT, 0, -1);
+		sunxi_nfc_read_buf(mtd, chip->buffers->databuf,
+				   mtd->writesize + mtd->oobsize);
+
+		if (nand_page_is_empty(mtd)) {
+			status = NAND_PAGE_EMPTY;
+		} else {
+			status = NAND_PAGE_FILLED;
+			chip->cmdfunc(mtd, NAND_CMD_RNDOUT, 0, -1);
+		}
+
+		nand_page_set_status(mtd, page, status);
+	}
+
+	if (status == NAND_PAGE_EMPTY) {
+		memset(buf, 0xff, mtd->writesize);
+		if (oob_required)
+			memset(chip->oob_poi, 0xff, mtd->oobsize);
+		return 0;
+	}
+
 	tmp = readl(nfc->regs + NFC_REG_ECC_CTL);
 	tmp &= ~(NFC_ECC_MODE | NFC_ECC_PIPELINE | NFC_ECC_BLOCK_SIZE |
 		 NFC_ECC_BLOCK_SIZE);
@@ -450,18 +655,31 @@ static int sunxi_nfc_hw_ecc_read_page(struct mtd_info *mtd,
 
 		offset = mtd->writesize + layout->eccpos[i * ecc->bytes] - 4;
 
-		chip->read_buf(mtd, NULL, ecc->size);
+		nand_rnd_config(mtd, page, i * ecc->size, NAND_RND_READ);
+		nand_rnd_read_buf(mtd, NULL, ecc->size);
 
 		chip->cmdfunc(mtd, NAND_CMD_RNDOUT, offset, -1);
 		while ((readl(nfc->regs + NFC_REG_ST) & NFC_CMD_FIFO_STATUS))
 			;
 
+		cnt = ecc->bytes + 4;
+		if (nand_rnd_is_activ(mtd, page, offset, &cnt) > 0 &&
+		    cnt == ecc->bytes + 4) {
+			tmp = readl(nfc->regs + NFC_REG_ECC_CTL);
+			tmp &= ~NFC_RANDOM_DIRECTION;
+			tmp |= NFC_RANDOM_EN;
+			writel(tmp, nfc->regs + NFC_REG_ECC_CTL);
+		}
+
 		tmp = NFC_DATA_TRANS | NFC_DATA_SWAP_METHOD | (1 << 30);
 		writel(tmp, nfc->regs + NFC_REG_CMD);
 		sunxi_nfc_wait_int(nfc, NFC_CMD_INT_FLAG, 0);
 		memcpy_fromio(buf + (i * ecc->size),
 			      nfc->regs + NFC_RAM0_BASE, ecc->size);
 
+		writel(readl(nfc->regs + NFC_REG_ECC_CTL) & ~NFC_RANDOM_EN,
+		       nfc->regs + NFC_REG_ECC_CTL);
+
 		if (readl(nfc->regs + NFC_REG_ECC_ST) & 0x1) {
 			mtd->ecc_stats.failed++;
 		} else {
@@ -475,9 +693,10 @@ static int sunxi_nfc_hw_ecc_read_page(struct mtd_info *mtd,
 			while ((readl(nfc->regs + NFC_REG_ST) &
 			       NFC_CMD_FIFO_STATUS))
 				;
+			nand_rnd_config(mtd, -1, offset, NAND_RND_READ);
 			offset -= mtd->writesize;
-			chip->read_buf(mtd, chip->oob_poi + offset,
-				      ecc->bytes + 4);
+			nand_rnd_read_buf(mtd, chip->oob_poi + offset,
+					  ecc->bytes + 4);
 		}
 	}
 
@@ -486,10 +705,14 @@ static int sunxi_nfc_hw_ecc_read_page(struct mtd_info *mtd,
 		if (cnt > 0) {
 			chip->cmdfunc(mtd, NAND_CMD_RNDOUT, mtd->writesize,
 				      -1);
-			chip->read_buf(mtd, chip->oob_poi, cnt);
+			nand_rnd_config(mtd, -1, mtd->writesize,
+					NAND_RND_READ);
+			nand_rnd_read_buf(mtd, chip->oob_poi, cnt);
 		}
 	}
 
+	nand_rnd_config(mtd, -1, -1, NAND_RND_READ);
+
 	tmp = readl(nfc->regs + NFC_REG_ECC_CTL);
 	tmp &= ~NFC_ECC_EN;
 
@@ -506,6 +729,7 @@ static int sunxi_nfc_hw_ecc_write_page(struct mtd_info *mtd,
 	struct nand_ecc_ctrl *ecc = chip->cur_ecc;
 	struct nand_ecclayout *layout = ecc->layout;
 	struct sunxi_nand_hw_ecc *data = ecc->priv;
+	struct sunxi_nand_hw_rnd *rnd = chip->cur_rnd->priv;
 	int offset;
 	u32 tmp;
 	int i;
@@ -522,7 +746,8 @@ static int sunxi_nfc_hw_ecc_write_page(struct mtd_info *mtd,
 		if (i)
 			chip->cmdfunc(mtd, NAND_CMD_RNDIN, i * ecc->size, -1);
 
-		chip->write_buf(mtd, buf + (i * ecc->size), ecc->size);
+		nand_rnd_config(mtd, -1, i * ecc->size, NAND_RND_WRITE);
+		nand_rnd_write_buf(mtd, buf + (i * ecc->size), ecc->size);
 
 		offset = layout->eccpos[i * ecc->bytes] - 4 + mtd->writesize;
 
@@ -537,6 +762,16 @@ static int sunxi_nfc_hw_ecc_write_page(struct mtd_info *mtd,
 				    4);
 		}
 
+		cnt = ecc->bytes + 4;
+		if (rnd &&
+		    nand_rnd_is_activ(mtd, rnd->page, offset, &cnt) > 0 &&
+		    cnt == ecc->bytes + 4) {
+			tmp = readl(nfc->regs + NFC_REG_ECC_CTL);
+			tmp &= ~NFC_RANDOM_DIRECTION;
+			tmp |= NFC_RANDOM_EN;
+			writel(tmp, nfc->regs + NFC_REG_ECC_CTL);
+		}
+
 		chip->cmdfunc(mtd, NAND_CMD_RNDIN, offset, -1);
 		while ((readl(nfc->regs + NFC_REG_ST) &
 		       NFC_CMD_FIFO_STATUS))
@@ -546,16 +781,23 @@ static int sunxi_nfc_hw_ecc_write_page(struct mtd_info *mtd,
 		      (1 << 30);
 		writel(tmp, nfc->regs + NFC_REG_CMD);
 		sunxi_nfc_wait_int(nfc, NFC_CMD_INT_FLAG, 0);
+
+		writel(readl(nfc->regs + NFC_REG_ECC_CTL) & ~NFC_RANDOM_EN,
+		       nfc->regs + NFC_REG_ECC_CTL);
 	}
 
 	if (oob_required) {
 		cnt = ecc->layout->oobfree[0].length - 4;
 		if (cnt > 0) {
 			chip->cmdfunc(mtd, NAND_CMD_RNDIN, mtd->writesize, -1);
-			chip->write_buf(mtd, chip->oob_poi, cnt);
+			nand_rnd_config(mtd, -1, mtd->writesize,
+					NAND_RND_WRITE);
+			nand_rnd_write_buf(mtd, chip->oob_poi, cnt);
 		}
 	}
 
+	nand_rnd_config(mtd, -1, -1, NAND_RND_WRITE);
+
 	tmp = readl(nfc->regs + NFC_REG_ECC_CTL);
 	tmp &= ~(NFC_ECC_EN | NFC_ECC_PIPELINE);
 
@@ -564,6 +806,34 @@ static int sunxi_nfc_hw_ecc_write_page(struct mtd_info *mtd,
 	return 0;
 }
 
+static u16 sunxi_nfc_hw_ecc_rnd_steps(struct mtd_info *mtd, u16 state,
+				      int column, int *left)
+{
+	struct nand_chip *chip = mtd->priv;
+	struct nand_ecc_ctrl *ecc = chip->cur_ecc;
+	struct sunxi_nand_hw_rnd *rnd = chip->cur_rnd->priv;
+	int modsize = ecc->size;
+	int steps;
+
+	if (column < mtd->writesize) {
+		steps = column % modsize;
+		*left = modsize - steps;
+	} else if (column < (mtd->writesize +
+			     ecc->layout->oobfree[0].length - 4)) {
+		steps = column % 4096;
+		column -= mtd->writesize;
+		*left = ecc->layout->oobfree[0].length - 4 - column;
+	} else {
+		column -= (mtd->writesize +
+			   ecc->layout->oobfree[0].length - 4);
+		steps = column % (ecc->bytes + ecc->prepad);
+		*left = ecc->bytes + ecc->prepad - steps;
+		state = rnd->subseeds[rnd->page % rnd->nseeds];
+	}
+
+	return sunxi_nfc_hwrnd_step(rnd, state, steps);
+}
+
 static int sunxi_nfc_hw_syndrome_ecc_read_page(struct mtd_info *mtd,
 					       struct nand_chip *chip,
 					       uint8_t *buf, int oob_required,
@@ -576,10 +846,34 @@ static int sunxi_nfc_hw_syndrome_ecc_read_page(struct mtd_info *mtd,
 	unsigned int max_bitflips = 0;
 	uint8_t *oob = chip->oob_poi;
 	int offset = 0;
+	int status;
 	int cnt;
 	u32 tmp;
 	int i;
 
+	status = nand_page_get_status(mtd, page);
+	if (status == NAND_PAGE_STATUS_UNKNOWN) {
+		chip->cmdfunc(mtd, NAND_CMD_RNDOUT, 0, -1);
+		sunxi_nfc_read_buf(mtd, chip->buffers->databuf,
+				   mtd->writesize + mtd->oobsize);
+
+		if (nand_page_is_empty(mtd)) {
+			status = NAND_PAGE_EMPTY;
+		} else {
+			status = NAND_PAGE_FILLED;
+			chip->cmdfunc(mtd, NAND_CMD_RNDOUT, 0, -1);
+		}
+
+		nand_page_set_status(mtd, page, status);
+	}
+
+	if (status == NAND_PAGE_EMPTY) {
+		memset(buf, 0xff, mtd->writesize);
+		if (oob_required)
+			memset(chip->oob_poi, 0xff, mtd->oobsize);
+		return 0;
+	}
+
 	tmp = readl(nfc->regs + NFC_REG_ECC_CTL);
 	tmp &= ~(NFC_ECC_MODE | NFC_ECC_PIPELINE | NFC_ECC_BLOCK_SIZE |
 		 NFC_ECC_BLOCK_SIZE);
@@ -588,7 +882,17 @@ static int sunxi_nfc_hw_syndrome_ecc_read_page(struct mtd_info *mtd,
 	writel(tmp, nfc->regs + NFC_REG_ECC_CTL);
 
 	for (i = 0; i < steps; i++) {
-		chip->read_buf(mtd, NULL, ecc->size);
+		nand_rnd_config(mtd, page, offset, NAND_RND_READ);
+		nand_rnd_read_buf(mtd, NULL, ecc->size);
+
+		cnt = ecc->bytes + 4;
+		if (nand_rnd_is_activ(mtd, page, offset, &cnt) > 0 &&
+		    cnt == ecc->bytes + 4) {
+			tmp = readl(nfc->regs + NFC_REG_ECC_CTL);
+			tmp &= ~NFC_RANDOM_DIRECTION;
+			tmp |= NFC_RANDOM_EN;
+			writel(tmp, nfc->regs + NFC_REG_ECC_CTL);
+		}
 
 		tmp = NFC_DATA_TRANS | NFC_DATA_SWAP_METHOD | (1 << 30);
 		writel(tmp, nfc->regs + NFC_REG_CMD);
@@ -597,6 +901,9 @@ static int sunxi_nfc_hw_syndrome_ecc_read_page(struct mtd_info *mtd,
 		buf += ecc->size;
 		offset += ecc->size;
 
+		writel(readl(nfc->regs + NFC_REG_ECC_CTL) & ~NFC_RANDOM_EN,
+		       nfc->regs + NFC_REG_ECC_CTL);
+
 		if (readl(nfc->regs + NFC_REG_ECC_ST) & 0x1) {
 			mtd->ecc_stats.failed++;
 		} else {
@@ -607,7 +914,8 @@ static int sunxi_nfc_hw_syndrome_ecc_read_page(struct mtd_info *mtd,
 
 		if (oob_required) {
 			chip->cmdfunc(mtd, NAND_CMD_RNDOUT, offset, -1);
-			chip->read_buf(mtd, oob, ecc->bytes + ecc->prepad);
+			nand_rnd_config(mtd, -1, offset, NAND_RND_READ);
+			nand_rnd_read_buf(mtd, oob, ecc->bytes + ecc->prepad);
 			oob += ecc->bytes + ecc->prepad;
 		}
 
@@ -618,10 +926,13 @@ static int sunxi_nfc_hw_syndrome_ecc_read_page(struct mtd_info *mtd,
 		cnt = mtd->oobsize - (oob - chip->oob_poi);
 		if (cnt > 0) {
 			chip->cmdfunc(mtd, NAND_CMD_RNDOUT, offset, -1);
-			chip->read_buf(mtd, oob, cnt);
+			nand_rnd_config(mtd, page, offset, NAND_RND_READ);
+			nand_rnd_read_buf(mtd, oob, cnt);
 		}
 	}
 
+	nand_rnd_config(mtd, -1, -1, NAND_RND_READ);
+
 	writel(readl(nfc->regs + NFC_REG_ECC_CTL) & ~NFC_ECC_EN,
 	       nfc->regs + NFC_REG_ECC_CTL);
 
@@ -636,6 +947,7 @@ static int sunxi_nfc_hw_syndrome_ecc_write_page(struct mtd_info *mtd,
 	struct sunxi_nfc *nfc = to_sunxi_nfc(chip->controller);
 	struct nand_ecc_ctrl *ecc = chip->cur_ecc;
 	struct sunxi_nand_hw_ecc *data = ecc->priv;
+	struct sunxi_nand_hw_rnd *rnd = chip->cur_rnd->priv;
 	int steps = mtd->writesize / ecc->size;
 	uint8_t *oob = chip->oob_poi;
 	int offset = 0;
@@ -651,7 +963,8 @@ static int sunxi_nfc_hw_syndrome_ecc_write_page(struct mtd_info *mtd,
 	writel(tmp, nfc->regs + NFC_REG_ECC_CTL);
 
 	for (i = 0; i < steps; i++) {
-		chip->write_buf(mtd, buf + (i * ecc->size), ecc->size);
+		nand_rnd_config(mtd, -1, offset, NAND_RND_WRITE);
+		nand_rnd_write_buf(mtd, buf + (i * ecc->size), ecc->size);
 		offset += ecc->size;
 
 		/* Fill OOB data in */
@@ -664,11 +977,24 @@ static int sunxi_nfc_hw_syndrome_ecc_write_page(struct mtd_info *mtd,
 				    4);
 		}
 
+		cnt = ecc->bytes + 4;
+		if (rnd &&
+		    nand_rnd_is_activ(mtd, rnd->page, offset, &cnt) > 0 &&
+		    cnt == ecc->bytes + 4) {
+			tmp = readl(nfc->regs + NFC_REG_ECC_CTL);
+			tmp &= ~NFC_RANDOM_DIRECTION;
+			tmp |= NFC_RANDOM_EN;
+			writel(tmp, nfc->regs + NFC_REG_ECC_CTL);
+		}
+
 		tmp = NFC_DATA_TRANS | NFC_DATA_SWAP_METHOD | NFC_ACCESS_DIR |
 		      (1 << 30);
 		writel(tmp, nfc->regs + NFC_REG_CMD);
 		sunxi_nfc_wait_int(nfc, NFC_CMD_INT_FLAG, 0);
 
+		writel(readl(nfc->regs + NFC_REG_ECC_CTL) & ~NFC_RANDOM_EN,
+		       nfc->regs + NFC_REG_ECC_CTL);
+
 		offset += ecc->bytes + ecc->prepad;
 		oob += ecc->bytes + ecc->prepad;
 	}
@@ -677,9 +1003,11 @@ static int sunxi_nfc_hw_syndrome_ecc_write_page(struct mtd_info *mtd,
 		cnt = mtd->oobsize - (oob - chip->oob_poi);
 		if (cnt > 0) {
 			chip->cmdfunc(mtd, NAND_CMD_RNDIN, offset, -1);
-			chip->write_buf(mtd, oob, cnt);
+			nand_rnd_config(mtd, -1, offset, NAND_RND_WRITE);
+			nand_rnd_write_buf(mtd, oob, cnt);
 		}
 	}
+	nand_rnd_config(mtd, -1, -1, NAND_RND_WRITE);
 
 	tmp = readl(nfc->regs + NFC_REG_ECC_CTL);
 	tmp &= ~(NFC_ECC_EN | NFC_ECC_PIPELINE);
@@ -689,6 +1017,123 @@ static int sunxi_nfc_hw_syndrome_ecc_write_page(struct mtd_info *mtd,
 	return 0;
 }
 
+static u16 sunxi_nfc_hw_syndrome_ecc_rnd_steps(struct mtd_info *mtd, u16 state,
+					       int column, int *left)
+{
+	struct nand_chip *chip = mtd->priv;
+	struct nand_ecc_ctrl *ecc = chip->cur_ecc;
+	struct sunxi_nand_hw_rnd *rnd = chip->cur_rnd->priv;
+	int eccsteps = mtd->writesize / ecc->size;
+	int modsize = ecc->size + ecc->prepad + ecc->bytes;
+	int steps;
+
+	if (column < (eccsteps * modsize)) {
+		steps = column % modsize;
+		*left = modsize - steps;
+		if (steps >= ecc->size) {
+			steps -= ecc->size;
+			state = rnd->subseeds[rnd->page % rnd->nseeds];
+		}
+	} else {
+		steps = column % 4096;
+		*left = mtd->writesize + mtd->oobsize - column;
+	}
+
+	return sunxi_nfc_hwrnd_step(rnd, state, steps);
+}
+
+static u16 default_seeds[] = {0x4a80};
+
+static void sunxi_nand_rnd_ctrl_cleanup(struct nand_rnd_ctrl *rnd)
+{
+	struct sunxi_nand_hw_rnd *hwrnd = rnd->priv;
+
+	if (hwrnd->seeds != default_seeds)
+		kfree(hwrnd->seeds);
+	kfree(hwrnd->subseeds);
+	kfree(rnd->layout);
+	kfree(hwrnd);
+}
+
+static int sunxi_nand_rnd_ctrl_init(struct mtd_info *mtd,
+				    struct nand_rnd_ctrl *rnd,
+				    struct nand_ecc_ctrl *ecc,
+				    struct device_node *np)
+{
+	struct sunxi_nand_hw_rnd *hwrnd;
+	struct nand_rnd_layout *layout = NULL;
+	int ret;
+
+	hwrnd = kzalloc(sizeof(*hwrnd), GFP_KERNEL);
+	if (!hwrnd)
+		return -ENOMEM;
+
+	hwrnd->seeds = default_seeds;
+	hwrnd->nseeds = ARRAY_SIZE(default_seeds);
+
+	if (of_get_property(np, "nand-randomizer-seeds", &ret)) {
+		hwrnd->nseeds = ret / sizeof(*hwrnd->seeds);
+		hwrnd->seeds = kzalloc(hwrnd->nseeds * sizeof(*hwrnd->seeds),
+				       GFP_KERNEL);
+		if (!hwrnd->seeds) {
+			ret = -ENOMEM;
+			goto err;
+		}
+
+		ret = of_property_read_u16_array(np, "nand-randomizer-seeds",
+						 hwrnd->seeds, hwrnd->nseeds);
+		if (ret)
+			goto err;
+	}
+
+	if (ecc->mode == NAND_ECC_HW_SYNDROME) {
+		hwrnd->step = sunxi_nfc_hw_syndrome_ecc_rnd_steps;
+	} else {
+		layout = kzalloc(sizeof(*layout) + sizeof(struct nand_rndfree),
+				 GFP_KERNEL);
+		if (!layout) {
+			ret = -ENOMEM;
+			goto err;
+		}
+		layout->nranges = 1;
+		layout->ranges[0].offset = mtd->writesize;
+		layout->ranges[0].length = 2;
+		rnd->layout = layout;
+		if (ecc->mode == NAND_ECC_HW)
+			hwrnd->step = sunxi_nfc_hw_ecc_rnd_steps;
+	}
+
+	if (ecc->mode == NAND_ECC_HW_SYNDROME || ecc->mode == NAND_ECC_HW) {
+		int i;
+
+		hwrnd->subseeds = kzalloc(hwrnd->nseeds *
+					  sizeof(*hwrnd->subseeds),
+					  GFP_KERNEL);
+		if (!hwrnd->subseeds) {
+			ret = -ENOMEM;
+			goto err;
+		}
+
+		for (i = 0; i < hwrnd->nseeds; i++)
+			hwrnd->subseeds[i] = sunxi_nfc_hwrnd_step(hwrnd,
+							hwrnd->seeds[i],
+							ecc->size);
+	}
+
+	rnd->config = sunxi_nfc_hwrnd_config;
+	rnd->read_buf = sunxi_nfc_hwrnd_read_buf;
+	rnd->write_buf = sunxi_nfc_hwrnd_write_buf;
+	rnd->priv = hwrnd;
+
+	return 0;
+
+err:
+	kfree(hwrnd);
+	kfree(layout);
+
+	return ret;
+}
+
 static int sunxi_nand_chip_set_timings(struct sunxi_nand_chip *chip,
 				       const struct nand_sdr_timings *timings)
 {
@@ -962,6 +1407,34 @@ static int sunxi_nand_hw_syndrome_ecc_ctrl_init(struct mtd_info *mtd,
 	return 0;
 }
 
+static void sunxi_nand_rnd_cleanup(struct nand_rnd_ctrl *rnd)
+{
+	switch (rnd->mode) {
+	case NAND_RND_HW:
+		sunxi_nand_rnd_ctrl_cleanup(rnd);
+		break;
+	default:
+		break;
+	}
+}
+
+static int sunxi_nand_rnd_init(struct mtd_info *mtd,
+			       struct nand_rnd_ctrl *rnd,
+			       struct nand_ecc_ctrl *ecc,
+			       struct device_node *np)
+{
+	rnd->mode = of_get_nand_rnd_mode(np);
+
+	switch (rnd->mode) {
+	case NAND_RND_HW:
+		return sunxi_nand_rnd_ctrl_init(mtd, rnd, ecc, np);
+	default:
+		break;
+	}
+
+	return 0;
+}
+
 static void sunxi_nand_ecc_cleanup(struct nand_ecc_ctrl *ecc)
 {
 	switch (ecc->mode) {
@@ -1041,7 +1514,14 @@ struct nand_part *sunxi_ofnandpart_parse(void *priv, struct mtd_info *master,
 	if (ret)
 		goto err;
 
+	ret = sunxi_nand_rnd_init(master, &part->rnd, &part->ecc, pp);
+	if (ret) {
+		sunxi_nand_ecc_cleanup(&part->ecc);
+		goto err;
+	}
+
 	part->part.ecc = &part->ecc;
+	part->part.rnd = &part->rnd;
 
 	return &part->part;
 
@@ -1146,10 +1626,18 @@ static int sunxi_nand_chip_init(struct device *dev, struct sunxi_nfc *nfc,
 	if (ret)
 		return ret;
 
+	ret = nand_pst_create(mtd);
+	if (ret)
+		return ret;
+
 	ret = sunxi_nand_ecc_init(mtd, &nand->ecc, np);
 	if (ret)
 		return ret;
 
+	ret = sunxi_nand_rnd_init(mtd, &nand->rnd, &nand->ecc, np);
+	if (ret)
+		return ret;
+
 	ret = nand_scan_tail(mtd);
 	if (ret)
 		return ret;
@@ -1204,6 +1692,7 @@ static void sunxi_nand_chips_cleanup(struct sunxi_nfc *nfc)
 					node);
 		nand_release(&chip->mtd);
 		sunxi_nand_ecc_cleanup(&chip->nand.ecc);
+		sunxi_nand_rnd_cleanup(&chip->nand.rnd);
 	}
 }
 
-- 
1.8.3.2

