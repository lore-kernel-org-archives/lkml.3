Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755755AbaGIMii (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 08:38:38 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:36368 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753456AbaGIMie (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 08:38:34 -0400
From: Roger Quadros <rogerq@ti.com>
To: <tony@atomide.com>, <computersforpeace@gmail.com>
CC: <javier@dowhile0.org>, <pekon@ti.com>,
        <ezequiel.garcia@free-electrons.com>, <dwmw2@infradead.org>,
        <jg1.han@samsung.com>, <nsekhar@ti.com>,
        <linux-mtd@lists.infradead.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Roger Quadros <rogerq@ti.com>
Subject: [RFC PATCH 02/10] mtd: nand: omap: Always use chip->ecc.steps for BCH sector count
Date: Wed, 9 Jul 2014 15:37:22 +0300
Message-ID: <1404909450-11970-3-git-send-email-rogerq@ti.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1404909450-11970-1-git-send-email-rogerq@ti.com>
References: <1404909450-11970-1-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of hardcoding use the pre-calculated chip->ecc.steps for
configuring number of sectors to process with the BCH algorithm.

This also avoids unnecessary access to the ECC_CONFIG register in
omap_calculate_ecc_bch().

Signed-off-by: Roger Quadros <rogerq@ti.com>
---
 drivers/mtd/nand/omap2.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/mtd/nand/omap2.c b/drivers/mtd/nand/omap2.c
index 5b8739c..6f3d7cd 100644
--- a/drivers/mtd/nand/omap2.c
+++ b/drivers/mtd/nand/omap2.c
@@ -1066,10 +1066,10 @@ static void __maybe_unused omap_enable_hwecc_bch(struct mtd_info *mtd, int mode)
 	unsigned int ecc_size1, ecc_size0;
 
 	/* GPMC configurations for calculating ECC */
+	nsectors = chip->ecc.steps;
 	switch (ecc_opt) {
 	case OMAP_ECC_BCH4_CODE_HW_DETECTION_SW:
 		bch_type = 0;
-		nsectors = 1;
 		if (mode == NAND_ECC_READ) {
 			wr_mode	  = BCH_WRAPMODE_6;
 			ecc_size0 = BCH_ECC_SIZE0;
@@ -1082,7 +1082,6 @@ static void __maybe_unused omap_enable_hwecc_bch(struct mtd_info *mtd, int mode)
 		break;
 	case OMAP_ECC_BCH4_CODE_HW:
 		bch_type = 0;
-		nsectors = chip->ecc.steps;
 		if (mode == NAND_ECC_READ) {
 			wr_mode	  = BCH_WRAPMODE_1;
 			ecc_size0 = BCH4R_ECC_SIZE0;
@@ -1095,7 +1094,6 @@ static void __maybe_unused omap_enable_hwecc_bch(struct mtd_info *mtd, int mode)
 		break;
 	case OMAP_ECC_BCH8_CODE_HW_DETECTION_SW:
 		bch_type = 1;
-		nsectors = 1;
 		if (mode == NAND_ECC_READ) {
 			wr_mode	  = BCH_WRAPMODE_6;
 			ecc_size0 = BCH_ECC_SIZE0;
@@ -1108,7 +1106,6 @@ static void __maybe_unused omap_enable_hwecc_bch(struct mtd_info *mtd, int mode)
 		break;
 	case OMAP_ECC_BCH8_CODE_HW:
 		bch_type = 1;
-		nsectors = chip->ecc.steps;
 		if (mode == NAND_ECC_READ) {
 			wr_mode	  = BCH_WRAPMODE_1;
 			ecc_size0 = BCH8R_ECC_SIZE0;
@@ -1121,7 +1118,6 @@ static void __maybe_unused omap_enable_hwecc_bch(struct mtd_info *mtd, int mode)
 		break;
 	case OMAP_ECC_BCH16_CODE_HW:
 		bch_type = 0x2;
-		nsectors = chip->ecc.steps;
 		if (mode == NAND_ECC_READ) {
 			wr_mode	  = 0x01;
 			ecc_size0 = 52; /* ECC bits in nibbles per sector */
@@ -1176,6 +1172,7 @@ static int __maybe_unused omap_calculate_ecc_bch(struct mtd_info *mtd,
 {
 	struct omap_nand_info *info = container_of(mtd, struct omap_nand_info,
 						   mtd);
+	struct nand_chip *chip = mtd->priv;
 	int eccbytes	= info->nand.ecc.bytes;
 	struct gpmc_nand_regs	*gpmc_regs = &info->reg;
 	u8 *ecc_code;
@@ -1183,7 +1180,7 @@ static int __maybe_unused omap_calculate_ecc_bch(struct mtd_info *mtd,
 	u32 val;
 	int i, j;
 
-	nsectors = ((readl(info->reg.gpmc_ecc_config) >> 4) & 0x7) + 1;
+	nsectors = chip->ecc.steps;
 	for (i = 0; i < nsectors; i++) {
 		ecc_code = ecc_calc;
 		switch (info->ecc_opt) {
-- 
1.8.3.2

