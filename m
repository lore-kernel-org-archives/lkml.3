Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756210AbaEAJ6j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2014 05:58:39 -0400
Received: from mail-we0-f169.google.com ([74.125.82.169]:58904 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755941AbaEAJ62 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2014 05:58:28 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: computersforpeace@gmail.com, linux-mtd@lists.infradead.org,
        kernel@stlinux.com, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 40/47] mtd: nand: stm_nand_bch: fetch the bit-flips threshold
Date: Thu,  1 May 2014 10:56:47 +0100
Message-Id: <1398938214-17847-41-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1398938214-17847-1-git-send-email-lee.jones@linaro.org>
References: <1398938214-17847-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If none is provided by the platform, the default ECC mode will be used.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/mtd/nand/stm_nand_bch.c | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/drivers/mtd/nand/stm_nand_bch.c b/drivers/mtd/nand/stm_nand_bch.c
index 0f96f75..e742655 100644
--- a/drivers/mtd/nand/stm_nand_bch.c
+++ b/drivers/mtd/nand/stm_nand_bch.c
@@ -44,6 +44,12 @@ static int bch_ecc_sizes[] = {
 	[BCH_NO_ECC] = 0,
 };
 
+static int bch_ecc_strength[] = {
+	[BCH_18BIT_ECC] = 18,
+	[BCH_30BIT_ECC] = 30,
+	[BCH_NO_ECC] = 0,
+};
+
 /*
  * Inband Bad Block Table (IBBT)
  */
@@ -2030,6 +2036,21 @@ static int stm_nand_bch_probe(struct platform_device *pdev)
 	info->ecclayout.eccbytes =
 		nandi->sectors_per_page * bch_ecc_sizes[nandi->bch_ecc_mode];
 
+	/*
+	 * Get bit-flips threshold. A value of '0' is interpreted as
+	 * <ecc_strength>.
+	 */
+	if (pdata->bch_bitflip_threshold) {
+		nandi->bitflip_threshold = pdata->bch_bitflip_threshold;
+	} else {
+		dev_warn(nandi->dev,
+			 "WARNING: bit-flips threshold not specified.\n"
+			 "         Defaulting to ECC strength [%d]\n",
+			 bch_ecc_strength[nandi->bch_ecc_mode]);
+		nandi->bitflip_threshold =
+			bch_ecc_strength[nandi->bch_ecc_mode];
+	}
+
 	compatible = bch_check_compatibility(nandi, mtd, chip);
 	if (!compatible) {
 		dev_err(nandi->dev,
-- 
1.8.3.2

