Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752853AbaA2OgB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jan 2014 09:36:01 -0500
Received: from mail-ea0-f172.google.com ([209.85.215.172]:46600 "EHLO
	mail-ea0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752449AbaA2Oe4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jan 2014 09:34:56 -0500
From: Boris BREZILLON <b.brezillon.dev@gmail.com>
To: Maxime Ripard <maxime.ripard@free-electrons.com>,
        Rob Landley <rob@landley.net>, Russell King <linux@arm.linux.org.uk>,
        David Woodhouse <dwmw2@infradead.org>,
        Grant Likely <grant.likely@linaro.org>,
        Brian Norris <computersforpeace@gmail.com>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Arnd Bergmann <arnd@arndb.de>
Cc: Boris BREZILLON <b.brezillon.dev@gmail.com>, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-mtd@lists.infradead.org,
        dev@linux-sunxi.org
Subject: [RFC PATCH v2 13/14] mtd: nand: add sunxi HW ECC support
Date: Wed, 29 Jan 2014 15:34:23 +0100
Message-Id: <1391006064-28890-14-git-send-email-b.brezillon.dev@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1391006064-28890-1-git-send-email-b.brezillon.dev@gmail.com>
References: <1391006064-28890-1-git-send-email-b.brezillon.dev@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add HW ECC support for the sunxi NAND Flash Controller.

Signed-off-by: Boris BREZILLON <b.brezillon.dev@gmail.com>
---
 drivers/mtd/nand/sunxi_nand.c |  279 +++++++++++++++++++++++++++++++++++++++--
 1 file changed, 266 insertions(+), 13 deletions(-)

diff --git a/drivers/mtd/nand/sunxi_nand.c b/drivers/mtd/nand/sunxi_nand.c
index d3da810..7e1cefc 100644
--- a/drivers/mtd/nand/sunxi_nand.c
+++ b/drivers/mtd/nand/sunxi_nand.c
@@ -163,6 +163,11 @@ struct sunxi_nand_chip_sel {
 #define DEFAULT_NAME_FORMAT	"nand@%d"
 #define MAX_NAME_SIZE		(sizeof("nand@") + 2)
 
+struct sunxi_nand_hw_ecc {
+	int mode;
+	struct nand_ecclayout layout;
+};
+
 struct sunxi_nand_chip {
 	struct list_head node;
 	struct nand_chip nand;
@@ -402,6 +407,126 @@ static void sunxi_nfc_cmd_ctrl(struct mtd_info *mtd, int dat,
 	sunxi_nfc_wait_int(nfc, NFC_CMD_INT_FLAG, 0);
 }
 
+static int sunxi_nfc_hwecc_read_page(struct mtd_info *mtd,
+				     struct nand_chip *chip, uint8_t *buf,
+				     int oob_required, int page)
+{
+	struct sunxi_nand_chip *sunxi_nand = to_sunxi_nand(mtd);
+	struct sunxi_nfc *nfc = to_sunxi_nfc(sunxi_nand->nand.controller);
+	struct nand_ecc_ctrl *ecc = &chip->ecc;
+	struct nand_ecclayout *layout = ecc->layout;
+	struct sunxi_nand_hw_ecc *data = ecc->priv;
+	unsigned int max_bitflips = 0;
+	int offset;
+	u32 tmp;
+	int i;
+
+	tmp = readl(nfc->regs + NFC_REG_ECC_CTL);
+	tmp &= ~(NFC_ECC_MODE | NFC_ECC_PIPELINE | NFC_ECC_BLOCK_SIZE |
+		 NFC_ECC_BLOCK_SIZE);
+	tmp |= NFC_ECC_EN | (data->mode << NFC_ECC_MODE_SHIFT);
+	writel(tmp, nfc->regs + NFC_REG_ECC_CTL);
+
+	for (i = 0; i < mtd->writesize / ecc->size; i++) {
+		if (i)
+			chip->cmdfunc(mtd, NAND_CMD_RNDOUT, i * ecc->size, -1);
+		chip->read_buf(mtd, NULL, chip->ecc.size);
+		offset = mtd->writesize + layout->eccpos[i * ecc->bytes] - 4;
+		chip->cmdfunc(mtd, NAND_CMD_RNDOUT, offset, -1);
+		while ((readl(nfc->regs + NFC_REG_ST) & NFC_CMD_FIFO_STATUS))
+			;
+		tmp = NFC_DATA_TRANS | NFC_DATA_SWAP_METHOD | (1 << 30);
+		writel(tmp, nfc->regs + NFC_REG_CMD);
+		sunxi_nfc_wait_int(nfc, NFC_CMD_INT_FLAG, 0);
+		memcpy_fromio(buf + (i * ecc->size), nfc->regs + NFC_RAM0_BASE,
+			      chip->ecc.size);
+
+		if (readl(nfc->regs + NFC_REG_ECC_ST) & 0x1) {
+			mtd->ecc_stats.failed++;
+		} else {
+			tmp = readl(nfc->regs + NFC_REG_ECC_CNT0) & 0xff;
+			mtd->ecc_stats.corrected += tmp;
+			max_bitflips = max_t(unsigned int, max_bitflips, tmp);
+		}
+	}
+
+	if (oob_required) {
+		chip->cmdfunc(mtd, NAND_CMD_RNDOUT, mtd->writesize, -1);
+		chip->read_buf(mtd, chip->oob_poi, mtd->oobsize);
+	}
+
+	tmp = readl(nfc->regs + NFC_REG_ECC_CTL);
+	tmp &= ~NFC_ECC_EN;
+
+	writel(tmp, nfc->regs + NFC_REG_ECC_CTL);
+
+	return max_bitflips;
+}
+
+static int sunxi_nfc_hwecc_write_page(struct mtd_info *mtd,
+				      struct nand_chip *chip,
+				      const uint8_t *buf,
+				      int oob_required)
+{
+	struct sunxi_nand_chip *sunxi_nand = to_sunxi_nand(mtd);
+	struct sunxi_nfc *nfc = to_sunxi_nfc(sunxi_nand->nand.controller);
+	struct nand_ecc_ctrl *ecc = &chip->ecc;
+	struct nand_ecclayout *layout = ecc->layout;
+	struct sunxi_nand_hw_ecc *data = ecc->priv;
+	int offset;
+	u32 tmp;
+	int i;
+	int j;
+
+	tmp = readl(nfc->regs + NFC_REG_ECC_CTL);
+	tmp &= ~(NFC_ECC_MODE | NFC_ECC_PIPELINE | NFC_ECC_BLOCK_SIZE |
+		 NFC_ECC_BLOCK_SIZE);
+	tmp |= NFC_ECC_EN | (data->mode << NFC_ECC_MODE_SHIFT);
+
+	writel(tmp, nfc->regs + NFC_REG_ECC_CTL);
+
+	for (i = 0; i < mtd->writesize / ecc->size; i++) {
+		if (i)
+			chip->cmdfunc(mtd, NAND_CMD_RNDIN, i * ecc->size, -1);
+
+		chip->write_buf(mtd, buf + (i * ecc->size), ecc->size);
+		offset = mtd->writesize + layout->eccpos[i * ecc->bytes] - 4;
+		chip->cmdfunc(mtd, NAND_CMD_RNDIN, offset, -1);
+		while ((readl(nfc->regs + NFC_REG_ST) & NFC_CMD_FIFO_STATUS))
+			;
+
+		/* Fill OOB data in */
+		for (j = 0; j < 4; j++) {
+			if (oob_required) {
+				offset = layout->eccpos[i * ecc->size] - 4;
+				writeb(chip->oob_poi[offset + j],
+				       nfc->regs + NFC_REG_USER_DATA_BASE + j);
+			} else {
+				writeb(0xff,
+				       nfc->regs + NFC_REG_USER_DATA_BASE + j);
+			}
+		}
+
+		tmp = NFC_DATA_TRANS | NFC_DATA_SWAP_METHOD |
+		      NFC_ACCESS_DIR | (1 << 30);
+		writel(tmp, nfc->regs + NFC_REG_CMD);
+		sunxi_nfc_wait_int(nfc, NFC_CMD_INT_FLAG, 0);
+	}
+
+	if (oob_required && chip->ecc.layout->oobfree[0].length > 2) {
+		chip->cmdfunc(mtd, NAND_CMD_RNDIN, mtd->writesize, -1);
+		chip->write_buf(mtd, chip->oob_poi,
+				chip->ecc.layout->oobfree[0].length - 2);
+	}
+
+	tmp = readl(nfc->regs + NFC_REG_ECC_CTL);
+	tmp &= ~(NFC_ECC_EN | NFC_ECC_PIPELINE);
+
+	writel(tmp, nfc->regs + NFC_REG_ECC_CTL);
+
+	return 0;
+}
+
 static int sunxi_nand_chip_init_timings(struct sunxi_nand_chip *chip,
 					struct device_node *np)
 {
@@ -502,6 +627,144 @@ static int sunxi_nand_chip_init_timings(struct sunxi_nand_chip *chip,
 	return 0;
 }
 
+static int sunxi_nand_chip_hwecc_init(struct device *dev,
+				      struct sunxi_nand_chip *chip,
+				      struct mtd_info *mtd,
+				      struct device_node *np)
+{
+	struct nand_chip *nand = &chip->nand;
+	struct nand_ecc_ctrl *ecc = &nand->ecc;
+	struct sunxi_nand_hw_ecc *data;
+	struct nand_ecclayout *layout;
+	int nsectors;
+	int i;
+	int j;
+
+	data = devm_kzalloc(dev, sizeof(*data), GFP_KERNEL);
+	if (!data)
+		return -ENOMEM;
+
+	ecc->read_page = sunxi_nfc_hwecc_read_page;
+	ecc->write_page = sunxi_nfc_hwecc_write_page;
+
+	if (nand->ecc_strength_ds <= 16) {
+		nand->ecc_strength_ds = 16;
+		data->mode = 0;
+	} else if (nand->ecc_strength_ds <= 24) {
+		nand->ecc_strength_ds = 24;
+		data->mode = 1;
+	} else if (nand->ecc_strength_ds <= 28) {
+		nand->ecc_strength_ds = 28;
+		data->mode = 2;
+	} else if (nand->ecc_strength_ds <= 32) {
+		nand->ecc_strength_ds = 32;
+		data->mode = 3;
+	} else if (nand->ecc_strength_ds <= 40) {
+		nand->ecc_strength_ds = 40;
+		data->mode = 4;
+	} else if (nand->ecc_strength_ds <= 48) {
+		nand->ecc_strength_ds = 48;
+		data->mode = 5;
+	} else if (nand->ecc_strength_ds <= 56) {
+		nand->ecc_strength_ds = 56;
+		data->mode = 6;
+	} else if (nand->ecc_strength_ds <= 60) {
+		nand->ecc_strength_ds = 60;
+		data->mode = 7;
+	} else if (nand->ecc_strength_ds <= 64) {
+		nand->ecc_strength_ds = 64;
+		data->mode = 8;
+	} else {
+		dev_err(dev, "unsupported strength\n");
+		return -ENOTSUPP;
+	}
+
+	/* HW ECC always request ECC bytes for 1024 bytes blocks */
+	ecc->bytes = ((nand->ecc_strength_ds * fls(8 * 1024)) + 7) / 8;
+
+	/* HW ECC always work with even numbers of ECC bytes */
+	if (ecc->bytes % 2)
+		ecc->bytes++;
+	ecc->strength = nand->ecc_strength_ds;
+	ecc->size = nand->ecc_step_ds;
+
+	layout = &data->layout;
+	nsectors = mtd->writesize / ecc->size;
+
+	if (mtd->oobsize < ((ecc->bytes + 4) * nsectors))
+		return -EINVAL;
+
+	layout->eccbytes = (ecc->bytes * nsectors);
+
+	/*
+	 * The first 2 bytes are used for BB markers.
+	 * We merge the 4 user available bytes from HW ECC with this
+	 * first section, hence why the + 2 operation (- 2 + 4).
+	 */
+	layout->oobfree[0].length = mtd->oobsize + 2 -
+				    ((ecc->bytes + 4) * nsectors);
+	layout->oobfree[0].offset = 2;
+	for (i = 0; i < nsectors; i++) {
+		/*
+		 * The first 4 ECC block bytes are already counted in the first
+		 * obbfree entry.
+		 */
+		if (i) {
+			layout->oobfree[i].offset =
+				layout->oobfree[i - 1].offset +
+				layout->oobfree[i - 1].length +
+				ecc->bytes;
+			layout->oobfree[i].length = 4;
+		}
+
+		for (j = 0; j < ecc->bytes; j++)
+			layout->eccpos[(ecc->bytes * i) + j] =
+					layout->oobfree[i].offset +
+					layout->oobfree[i].length + j;
+	}
+
+	ecc->layout = layout;
+	ecc->priv = data;
+
+	return 0;
+}
+
+static int sunxi_nand_chip_ecc_init(struct device *dev,
+				    struct sunxi_nand_chip *chip,
+				    struct mtd_info *mtd,
+				    struct device_node *np)
+{
+	struct nand_chip *nand = &chip->nand;
+	u32 strength;
+	u32 blk_size;
+	int ret;
+
+	nand->ecc.mode = of_get_nand_ecc_mode(np);
+
+	if (!of_get_nand_ecc_level(np, &strength, &blk_size)) {
+		nand->ecc_step_ds = blk_size;
+		nand->ecc_strength_ds = strength;
+	}
+
+	switch (nand->ecc.mode) {
+	case NAND_ECC_SOFT_BCH:
+		nand->ecc.size = nand->ecc_step_ds;
+		nand->ecc.bytes = ((nand->ecc_strength_ds *
+				    fls(8 * nand->ecc_step_ds)) + 7) / 8;
+		break;
+	case NAND_ECC_HW:
+		ret = sunxi_nand_chip_hwecc_init(dev, chip, mtd, np);
+		if (ret)
+			return ret;
+		break;
+	case NAND_ECC_NONE:
+	default:
+		break;
+	}
+
+	return 0;
+}
+
 static int sunxi_nand_chip_init(struct device *dev, struct sunxi_nfc *nfc,
 				struct device_node *np)
 {
@@ -509,8 +772,6 @@ static int sunxi_nand_chip_init(struct device *dev, struct sunxi_nfc *nfc,
 	struct mtd_part_parser_data ppdata;
 	struct mtd_info *mtd;
 	struct nand_chip *nand;
-	u32 strength;
-	u32 blk_size;
 	int nsels;
 	int ret;
 	int i;
@@ -576,7 +837,6 @@ static int sunxi_nand_chip_init(struct device *dev, struct sunxi_nfc *nfc,
 	nand->write_buf = sunxi_nfc_write_buf;
 	nand->read_byte = sunxi_nfc_read_byte;
 
-	nand->ecc.mode = of_get_nand_ecc_mode(np);
 	if (of_get_nand_on_flash_bbt(np))
 		nand->bbt_options |= NAND_BBT_USE_FLASH;
 
@@ -588,16 +848,9 @@ static int sunxi_nand_chip_init(struct device *dev, struct sunxi_nfc *nfc,
 	if (ret)
 		return ret;
 
-	if (nand->ecc.mode == NAND_ECC_SOFT_BCH) {
-		if (!of_get_nand_ecc_level(np, &strength, &blk_size)) {
-			nand->ecc_step_ds = blk_size;
-			nand->ecc_strength_ds = strength;
-		}
-
-		nand->ecc.size = nand->ecc_step_ds;
-		nand->ecc.bytes = (((nand->ecc_strength_ds *
-				     fls(8 * nand->ecc_step_ds)) + 7) / 8);
-	}
+	ret = sunxi_nand_chip_ecc_init(dev, chip, mtd, np);
+	if (ret)
+		return ret;
 
 	ret = nand_scan_tail(mtd);
 	if (ret)
-- 
1.7.9.5

