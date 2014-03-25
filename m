Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753905AbaCYIuM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2014 04:50:12 -0400
Received: from mail-we0-f173.google.com ([74.125.82.173]:63822 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752825AbaCYIUx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2014 04:20:53 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: lee.jones@linaro.org, kernel@stlinux.com, computersforpeace@gmail.com,
        linux-mtd@lists.infradead.org, dwmw2@infradead.org, angus.clark@st.com,
        pekon@ti.com
Subject: [RFC 18/47] mtd: nand: stm_nand_bch: ensure configuration is compatible with this driver
Date: Tue, 25 Mar 2014 08:19:35 +0000
Message-Id: <1395735604-26706-19-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1395735604-26706-1-git-send-email-lee.jones@linaro.org>
References: <1395735604-26706-1-git-send-email-lee.jones@linaro.org>
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
index 60a7800..365a73b 100644
--- a/drivers/mtd/nand/stm_nand_bch.c
+++ b/drivers/mtd/nand/stm_nand_bch.c
@@ -142,6 +142,36 @@ static void nandi_disable_interrupts(struct nandi_controller *nandi,
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
@@ -737,7 +767,7 @@ static int stm_nand_bch_probe(struct platform_device *pdev)
 	struct nandi_info *info;
 	struct nand_chip *chip;
 	struct mtd_info *mtd;
-	int err;
+	int compatible, err;
 
 	if (!pdata) {
 		if (!np) {
@@ -832,6 +862,13 @@ static int stm_nand_bch_probe(struct platform_device *pdev)
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

