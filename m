Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755825AbaGIMjE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 08:39:04 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:38274 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755762AbaGIMjA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 08:39:00 -0400
From: Roger Quadros <rogerq@ti.com>
To: <tony@atomide.com>, <computersforpeace@gmail.com>
CC: <javier@dowhile0.org>, <pekon@ti.com>,
        <ezequiel.garcia@free-electrons.com>, <dwmw2@infradead.org>,
        <jg1.han@samsung.com>, <nsekhar@ti.com>,
        <linux-mtd@lists.infradead.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Roger Quadros <rogerq@ti.com>
Subject: [RFC PATCH 09/10] mtd: nand: omap: Use GPMC APIs for accessing ECC/BCH engine
Date: Wed, 9 Jul 2014 15:37:29 +0300
Message-ID: <1404909450-11970-10-git-send-email-rogerq@ti.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1404909450-11970-1-git-send-email-rogerq@ti.com>
References: <1404909450-11970-1-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Don't access the ECC/BCH engine registers directly as they belong
to the GPMC controller's register space. Use the relevant
GPMC APIs instead.

Signed-off-by: Roger Quadros <rogerq@ti.com>
---
 drivers/mtd/nand/omap2.c | 191 +++++++++++++++++++----------------------------
 1 file changed, 76 insertions(+), 115 deletions(-)

diff --git a/drivers/mtd/nand/omap2.c b/drivers/mtd/nand/omap2.c
index 420ef0b..6b0f953 100644
--- a/drivers/mtd/nand/omap2.c
+++ b/drivers/mtd/nand/omap2.c
@@ -865,16 +865,10 @@ static int omap_correct_data(struct mtd_info *mtd, u_char *dat,
 static int omap_calculate_ecc(struct mtd_info *mtd, const u_char *dat,
 				u_char *ecc_code)
 {
-	struct omap_nand_info *info = container_of(mtd, struct omap_nand_info,
-							mtd);
 	u32 val;
 
-	val = readl(info->reg.gpmc_ecc_config);
-	if (((val >> ECC_CONFIG_CS_SHIFT)  & ~CS_MASK) != info->gpmc_cs)
-		return -EINVAL;
-
 	/* read ecc result */
-	val = readl(info->reg.gpmc_ecc1_result);
+	omap_gpmc_ecc_get_result(1, &val);
 	*ecc_code++ = val;          /* P128e, ..., P1e */
 	*ecc_code++ = val >> 16;    /* P128o, ..., P1o */
 	/* P2048o, P1024o, P512o, P256o, P2048e, P1024e, P512e, P256e */
@@ -894,34 +888,22 @@ static void omap_enable_hwecc(struct mtd_info *mtd, int mode)
 							mtd);
 	struct nand_chip *chip = mtd->priv;
 	unsigned int dev_width = (chip->options & NAND_BUSWIDTH_16) ? 1 : 0;
-	u32 val;
-
-	/* clear ecc and enable bits */
-	val = ECCCLEAR | ECC1;
-	writel(val, info->reg.gpmc_ecc_control);
+	u32 ecc_size0;
 
-	/* program ecc and result sizes */
-	val = ((((info->nand.ecc.size >> 1) - 1) << ECCSIZE1_SHIFT) |
-			 ECC1RESULTSIZE);
-	writel(val, info->reg.gpmc_ecc_size_config);
+	ecc_size0 = (info->nand.ecc.size >> 1) - 1;
 
 	switch (mode) {
 	case NAND_ECC_READ:
 	case NAND_ECC_WRITE:
-		writel(ECCCLEAR | ECC1, info->reg.gpmc_ecc_control);
+		omap_gpmc_ecc_configure_enable(info->gpmc_cs, dev_width,
+					       ecc_size0, 0, false,
+					       0, 0, 0);
 		break;
 	case NAND_ECC_READSYN:
-		writel(ECCCLEAR, info->reg.gpmc_ecc_control);
-		break;
-	default:
-		dev_info(&info->pdev->dev,
-			"error: unrecognized Mode[%d]!\n", mode);
+		/* Disable the engine, but don't clear ECC results */
+		omap_gpmc_ecc_disable();
 		break;
 	}
-
-	/* (ECC 16 or 8 bit col) | ( CS  )  | ECC Enable */
-	val = (dev_width << 7) | (info->gpmc_cs << 1) | (0x1);
-	writel(val, info->reg.gpmc_ecc_config);
 }
 
 /**
@@ -993,20 +975,20 @@ static int omap_dev_ready(struct mtd_info *mtd)
  */
 static void __maybe_unused omap_enable_hwecc_bch(struct mtd_info *mtd, int mode)
 {
-	unsigned int bch_type;
+	enum omap_gpmc_bch_type bch_type;
 	unsigned int dev_width, nsectors;
 	struct omap_nand_info *info = container_of(mtd, struct omap_nand_info,
 						   mtd);
 	enum omap_ecc ecc_opt = info->ecc_opt;
 	struct nand_chip *chip = mtd->priv;
-	u32 val, wr_mode;
+	u32 wr_mode;
 	unsigned int ecc_size1, ecc_size0;
 
 	/* GPMC configurations for calculating ECC */
 	nsectors = chip->ecc.steps;
 	switch (ecc_opt) {
 	case OMAP_ECC_BCH4_CODE_HW_DETECTION_SW:
-		bch_type = 0;
+		bch_type = OMAP_GPMC_BCH4;
 		if (mode == NAND_ECC_READ) {
 			wr_mode	  = BCH_WRAPMODE_6;
 			ecc_size0 = BCH_ECC_SIZE0;
@@ -1018,7 +1000,7 @@ static void __maybe_unused omap_enable_hwecc_bch(struct mtd_info *mtd, int mode)
 		}
 		break;
 	case OMAP_ECC_BCH4_CODE_HW:
-		bch_type = 0;
+		bch_type = OMAP_GPMC_BCH4;
 		if (mode == NAND_ECC_READ) {
 			wr_mode	  = BCH_WRAPMODE_1;
 			ecc_size0 = BCH4R_ECC_SIZE0;
@@ -1030,7 +1012,7 @@ static void __maybe_unused omap_enable_hwecc_bch(struct mtd_info *mtd, int mode)
 		}
 		break;
 	case OMAP_ECC_BCH8_CODE_HW_DETECTION_SW:
-		bch_type = 1;
+		bch_type = OMAP_GPMC_BCH8;
 		if (mode == NAND_ECC_READ) {
 			wr_mode	  = BCH_WRAPMODE_6;
 			ecc_size0 = BCH_ECC_SIZE0;
@@ -1042,7 +1024,7 @@ static void __maybe_unused omap_enable_hwecc_bch(struct mtd_info *mtd, int mode)
 		}
 		break;
 	case OMAP_ECC_BCH8_CODE_HW:
-		bch_type = 1;
+		bch_type = OMAP_GPMC_BCH8;
 		if (mode == NAND_ECC_READ) {
 			wr_mode	  = BCH_WRAPMODE_1;
 			ecc_size0 = BCH8R_ECC_SIZE0;
@@ -1054,7 +1036,7 @@ static void __maybe_unused omap_enable_hwecc_bch(struct mtd_info *mtd, int mode)
 		}
 		break;
 	case OMAP_ECC_BCH16_CODE_HW:
-		bch_type = 0x2;
+		bch_type = OMAP_GPMC_BCH16;
 		if (mode == NAND_ECC_READ) {
 			wr_mode	  = 0x01;
 			ecc_size0 = 52; /* ECC bits in nibbles per sector */
@@ -1069,27 +1051,11 @@ static void __maybe_unused omap_enable_hwecc_bch(struct mtd_info *mtd, int mode)
 		return;
 	}
 
-	writel(ECC1, info->reg.gpmc_ecc_control);
-
-	/* Configure ecc size for BCH */
-	val = (ecc_size1 << ECCSIZE1_SHIFT) | (ecc_size0 << ECCSIZE0_SHIFT);
-	writel(val, info->reg.gpmc_ecc_size_config);
-
 	dev_width = (chip->options & NAND_BUSWIDTH_16) ? 1 : 0;
 
-	/* BCH configuration */
-	val = ((1                        << 16) | /* enable BCH */
-	       (bch_type		 << 12) | /* BCH4/BCH8/BCH16 */
-	       (wr_mode                  <<  8) | /* wrap mode */
-	       (dev_width                <<  7) | /* bus width */
-	       (((nsectors-1) & 0x7)     <<  4) | /* number of sectors */
-	       (info->gpmc_cs            <<  1) | /* ECC CS */
-	       (0x1));                            /* enable ECC */
-
-	writel(val, info->reg.gpmc_ecc_config);
-
-	/* Clear ecc and enable bits */
-	writel(ECCCLEAR | ECC1, info->reg.gpmc_ecc_control);
+	omap_gpmc_ecc_configure_enable(info->gpmc_cs, dev_width,
+				       ecc_size0, ecc_size1, true,
+				       bch_type, nsectors - 1, wr_mode);
 }
 
 static u8  bch4_polynomial[] = {0x28, 0x13, 0xcc, 0x39, 0x96, 0xac, 0x7f};
@@ -1111,11 +1077,10 @@ static int __maybe_unused omap_calculate_ecc_bch(struct mtd_info *mtd,
 						   mtd);
 	struct nand_chip *chip = mtd->priv;
 	int eccbytes	= info->nand.ecc.bytes;
-	struct gpmc_nand_regs	*gpmc_regs = &info->reg;
 	u8 *ecc_code;
-	unsigned long nsectors, bch_val1, bch_val2, bch_val3, bch_val4;
-	u32 val;
+	unsigned long nsectors;
 	int i, j;
+	u32 bch_val[7];
 
 	nsectors = chip->ecc.steps;
 	for (i = 0; i < nsectors; i++) {
@@ -1123,71 +1088,67 @@ static int __maybe_unused omap_calculate_ecc_bch(struct mtd_info *mtd,
 		switch (info->ecc_opt) {
 		case OMAP_ECC_BCH8_CODE_HW_DETECTION_SW:
 		case OMAP_ECC_BCH8_CODE_HW:
-			bch_val1 = readl(gpmc_regs->gpmc_bch_result0[i]);
-			bch_val2 = readl(gpmc_regs->gpmc_bch_result1[i]);
-			bch_val3 = readl(gpmc_regs->gpmc_bch_result2[i]);
-			bch_val4 = readl(gpmc_regs->gpmc_bch_result3[i]);
-			*ecc_code++ = (bch_val4 & 0xFF);
-			*ecc_code++ = ((bch_val3 >> 24) & 0xFF);
-			*ecc_code++ = ((bch_val3 >> 16) & 0xFF);
-			*ecc_code++ = ((bch_val3 >> 8) & 0xFF);
-			*ecc_code++ = (bch_val3 & 0xFF);
-			*ecc_code++ = ((bch_val2 >> 24) & 0xFF);
-			*ecc_code++ = ((bch_val2 >> 16) & 0xFF);
-			*ecc_code++ = ((bch_val2 >> 8) & 0xFF);
-			*ecc_code++ = (bch_val2 & 0xFF);
-			*ecc_code++ = ((bch_val1 >> 24) & 0xFF);
-			*ecc_code++ = ((bch_val1 >> 16) & 0xFF);
-			*ecc_code++ = ((bch_val1 >> 8) & 0xFF);
-			*ecc_code++ = (bch_val1 & 0xFF);
+			omap_gpmc_ecc_get_bch_result(4, i, bch_val);
+			*ecc_code++ = (bch_val[3] & 0xFF);
+			*ecc_code++ = ((bch_val[2] >> 24) & 0xFF);
+			*ecc_code++ = ((bch_val[2] >> 16) & 0xFF);
+			*ecc_code++ = ((bch_val[2] >> 8) & 0xFF);
+			*ecc_code++ = (bch_val[2] & 0xFF);
+			*ecc_code++ = ((bch_val[1] >> 24) & 0xFF);
+			*ecc_code++ = ((bch_val[1] >> 16) & 0xFF);
+			*ecc_code++ = ((bch_val[1] >> 8) & 0xFF);
+			*ecc_code++ = (bch_val[1] & 0xFF);
+			*ecc_code++ = ((bch_val[0] >> 24) & 0xFF);
+			*ecc_code++ = ((bch_val[0] >> 16) & 0xFF);
+			*ecc_code++ = ((bch_val[0] >> 8) & 0xFF);
+			*ecc_code++ = (bch_val[0] & 0xFF);
 			break;
 		case OMAP_ECC_BCH4_CODE_HW_DETECTION_SW:
 		case OMAP_ECC_BCH4_CODE_HW:
-			bch_val1 = readl(gpmc_regs->gpmc_bch_result0[i]);
-			bch_val2 = readl(gpmc_regs->gpmc_bch_result1[i]);
-			*ecc_code++ = ((bch_val2 >> 12) & 0xFF);
-			*ecc_code++ = ((bch_val2 >> 4) & 0xFF);
-			*ecc_code++ = ((bch_val2 & 0xF) << 4) |
-				((bch_val1 >> 28) & 0xF);
-			*ecc_code++ = ((bch_val1 >> 20) & 0xFF);
-			*ecc_code++ = ((bch_val1 >> 12) & 0xFF);
-			*ecc_code++ = ((bch_val1 >> 4) & 0xFF);
-			*ecc_code++ = ((bch_val1 & 0xF) << 4);
+			omap_gpmc_ecc_get_bch_result(2, i, bch_val);
+			*ecc_code++ = ((bch_val[1] >> 12) & 0xFF);
+			*ecc_code++ = ((bch_val[1] >> 4) & 0xFF);
+			*ecc_code++ = ((bch_val[1] & 0xF) << 4) |
+				((bch_val[0] >> 28) & 0xF);
+			*ecc_code++ = ((bch_val[0] >> 20) & 0xFF);
+			*ecc_code++ = ((bch_val[0] >> 12) & 0xFF);
+			*ecc_code++ = ((bch_val[0] >> 4) & 0xFF);
+			*ecc_code++ = ((bch_val[0] & 0xF) << 4);
 			break;
 		case OMAP_ECC_BCH16_CODE_HW:
-			val = readl(gpmc_regs->gpmc_bch_result6[i]);
-			ecc_code[0]  = ((val >>  8) & 0xFF);
-			ecc_code[1]  = ((val >>  0) & 0xFF);
-			val = readl(gpmc_regs->gpmc_bch_result5[i]);
-			ecc_code[2]  = ((val >> 24) & 0xFF);
-			ecc_code[3]  = ((val >> 16) & 0xFF);
-			ecc_code[4]  = ((val >>  8) & 0xFF);
-			ecc_code[5]  = ((val >>  0) & 0xFF);
-			val = readl(gpmc_regs->gpmc_bch_result4[i]);
-			ecc_code[6]  = ((val >> 24) & 0xFF);
-			ecc_code[7]  = ((val >> 16) & 0xFF);
-			ecc_code[8]  = ((val >>  8) & 0xFF);
-			ecc_code[9]  = ((val >>  0) & 0xFF);
-			val = readl(gpmc_regs->gpmc_bch_result3[i]);
-			ecc_code[10] = ((val >> 24) & 0xFF);
-			ecc_code[11] = ((val >> 16) & 0xFF);
-			ecc_code[12] = ((val >>  8) & 0xFF);
-			ecc_code[13] = ((val >>  0) & 0xFF);
-			val = readl(gpmc_regs->gpmc_bch_result2[i]);
-			ecc_code[14] = ((val >> 24) & 0xFF);
-			ecc_code[15] = ((val >> 16) & 0xFF);
-			ecc_code[16] = ((val >>  8) & 0xFF);
-			ecc_code[17] = ((val >>  0) & 0xFF);
-			val = readl(gpmc_regs->gpmc_bch_result1[i]);
-			ecc_code[18] = ((val >> 24) & 0xFF);
-			ecc_code[19] = ((val >> 16) & 0xFF);
-			ecc_code[20] = ((val >>  8) & 0xFF);
-			ecc_code[21] = ((val >>  0) & 0xFF);
-			val = readl(gpmc_regs->gpmc_bch_result0[i]);
-			ecc_code[22] = ((val >> 24) & 0xFF);
-			ecc_code[23] = ((val >> 16) & 0xFF);
-			ecc_code[24] = ((val >>  8) & 0xFF);
-			ecc_code[25] = ((val >>  0) & 0xFF);
+			omap_gpmc_ecc_get_bch_result(7, i, bch_val);
+			ecc_code[0]  = ((bch_val[6] >>  8) & 0xFF);
+			ecc_code[1]  = ((bch_val[6] >>  0) & 0xFF);
+
+			ecc_code[2]  = ((bch_val[5] >> 24) & 0xFF);
+			ecc_code[3]  = ((bch_val[5] >> 16) & 0xFF);
+			ecc_code[4]  = ((bch_val[5] >>  8) & 0xFF);
+			ecc_code[5]  = ((bch_val[5] >>  0) & 0xFF);
+
+			ecc_code[6]  = ((bch_val[4] >> 24) & 0xFF);
+			ecc_code[7]  = ((bch_val[4] >> 16) & 0xFF);
+			ecc_code[8]  = ((bch_val[4] >>  8) & 0xFF);
+			ecc_code[9]  = ((bch_val[4] >>  0) & 0xFF);
+
+			ecc_code[10] = ((bch_val[3] >> 24) & 0xFF);
+			ecc_code[11] = ((bch_val[3] >> 16) & 0xFF);
+			ecc_code[12] = ((bch_val[3] >>  8) & 0xFF);
+			ecc_code[13] = ((bch_val[3] >>  0) & 0xFF);
+
+			ecc_code[14] = ((bch_val[2] >> 24) & 0xFF);
+			ecc_code[15] = ((bch_val[2] >> 16) & 0xFF);
+			ecc_code[16] = ((bch_val[2] >>  8) & 0xFF);
+			ecc_code[17] = ((bch_val[2] >>  0) & 0xFF);
+
+			ecc_code[18] = ((bch_val[1] >> 24) & 0xFF);
+			ecc_code[19] = ((bch_val[1] >> 16) & 0xFF);
+			ecc_code[20] = ((bch_val[1] >>  8) & 0xFF);
+			ecc_code[21] = ((bch_val[1] >>  0) & 0xFF);
+
+			ecc_code[22] = ((bch_val[0] >> 24) & 0xFF);
+			ecc_code[23] = ((bch_val[0] >> 16) & 0xFF);
+			ecc_code[24] = ((bch_val[0] >>  8) & 0xFF);
+			ecc_code[25] = ((bch_val[0] >>  0) & 0xFF);
 			break;
 		default:
 			return -EINVAL;
-- 
1.8.3.2

