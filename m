Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755788AbaEAJ5v (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2014 05:57:51 -0400
Received: from mail-wi0-f175.google.com ([209.85.212.175]:45203 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755715AbaEAJ5q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2014 05:57:46 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: computersforpeace@gmail.com, linux-mtd@lists.infradead.org,
        kernel@stlinux.com, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 19/47] mtd: nand: stm_nand_bch: ensure configuration is compatible with this driver
Date: Thu,  1 May 2014 10:56:26 +0100
Message-Id: <1398938214-17847-20-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1398938214-17847-1-git-send-email-lee.jones@linaro.org>
References: <1398938214-17847-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some chip characteristics have known incompatibilities with the function
of this driver. Here we check for this characteristics and refuse to run
if they are present.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/mtd/nand/stm_nand_bch.c | 39 ++++++++++++++++++++++++++++++++++++++-
 1 file changed, 38 insertions(+), 1 deletion(-)

diff --git a/drivers/mtd/nand/stm_nand_bch.c b/drivers/mtd/nand/stm_nand_bch.c
index 31864e5..66ff99d 100644
--- a/drivers/mtd/nand/stm_nand_bch.c
+++ b/drivers/mtd/nand/stm_nand_bch.c
@@ -309,6 +309,36 @@ static void nandi_disable_interrupts(struct nandi_controller *nandi,
 	writel(val, nandi->base + NANDBCH_INT_EN);
 }
 
+/*
+ * Initialisation
+ */
+static int bch_check_compatibility(struct nandi_controller *nandi,
+				   struct mtd_info *mtd,
+				   struct nand_chip *chip)
+{
+	if (chip->bits_per_cell > 1)
+		dev_warn(nandi->dev, "MLC NAND not fully supported\n");
+
+	if (chip->options & NAND_BUSWIDTH_16) {
+		dev_err(nandi->dev, "x16 NAND not supported\n");
+		return false;
+	}
+
+	if (nandi->blocks_per_device / 4 > mtd->writesize) {
+		/* Need to implement multi-page BBT support... */
+		dev_err(nandi->dev, "BBT too big to fit in single page\n");
+		return false;
+	}
+
+	if (bch_ecc_sizes[nandi->bch_ecc_mode] * nandi->sectors_per_page >
+	    mtd->oobsize) {
+		dev_err(nandi->dev, "insufficient OOB for selected ECC\n");
+		return false;
+	}
+
+	return true;
+}
+
 /* Select strongest ECC scheme compatible with OOB size */
 static int bch_set_ecc_auto(struct nandi_controller *nandi,
 			    struct mtd_info *mtd)
@@ -886,7 +916,7 @@ static int stm_nand_bch_probe(struct platform_device *pdev)
 	struct nandi_info *info;
 	struct nand_chip *chip;
 	struct mtd_info *mtd;
-	int err;
+	int compatible, err;
 
 	if (!np) {
 		dev_err(&pdev->dev, "DT node found\n");
@@ -982,6 +1012,13 @@ static int stm_nand_bch_probe(struct platform_device *pdev)
 	info->ecclayout.eccbytes =
 		nandi->sectors_per_page * bch_ecc_sizes[nandi->bch_ecc_mode];
 
+	compatible = bch_check_compatibility(nandi, mtd, chip);
+	if (!compatible) {
+		dev_err(nandi->dev,
+			"NAND device incompatible with NANDi/BCH Controller\n");
+		return -EINVAL;
+	}
+
 	return 0;
 }
 
-- 
1.8.3.2

