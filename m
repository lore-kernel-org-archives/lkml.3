Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752924AbaCYIU5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2014 04:20:57 -0400
Received: from mail-wi0-f180.google.com ([209.85.212.180]:50656 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752610AbaCYIUv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2014 04:20:51 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: lee.jones@linaro.org, kernel@stlinux.com, computersforpeace@gmail.com,
        linux-mtd@lists.infradead.org, dwmw2@infradead.org, angus.clark@st.com,
        pekon@ti.com
Subject: [RFC 17/47] mtd: nand: stm_nand_bch: automatically set EEC mode if requested
Date: Tue, 25 Mar 2014 08:19:34 +0000
Message-Id: <1395735604-26706-18-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1395735604-26706-1-git-send-email-lee.jones@linaro.org>
References: <1395735604-26706-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here we automatically select the strongest ECC scheme compatible with
the size of the OOB.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/mtd/nand/stm_nand_bch.c | 40 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 40 insertions(+)

diff --git a/drivers/mtd/nand/stm_nand_bch.c b/drivers/mtd/nand/stm_nand_bch.c
index f5a3e80..60a7800 100644
--- a/drivers/mtd/nand/stm_nand_bch.c
+++ b/drivers/mtd/nand/stm_nand_bch.c
@@ -32,6 +32,13 @@
 /* NANDi BCH Controller properties */
 #define NANDI_BCH_SECTOR_SIZE			1024
 
+/* BCH ECC sizes */
+static int bch_ecc_sizes[] = {
+	[BCH_18BIT_ECC] = 32,
+	[BCH_30BIT_ECC] = 54,
+	[BCH_NO_ECC] = 0,
+};
+
 /* Bad Block Table (BBT) */
 struct nandi_bbt_info {
 	uint32_t	bbt_size;		/* Size of bad-block table */
@@ -135,6 +142,25 @@ static void nandi_disable_interrupts(struct nandi_controller *nandi,
 	writel(val, nandi->base + NANDBCH_INT_EN);
 }
 
+/* Select strongest ECC scheme compatible with OOB size */
+static int bch_set_ecc_auto(struct nandi_controller *nandi,
+			    struct mtd_info *mtd)
+{
+	int oob_bytes_per_sector = mtd->oobsize / nandi->sectors_per_page;
+	int try_ecc_modes[] = { BCH_30BIT_ECC, BCH_18BIT_ECC, -1 };
+	int m, ecc_mode;
+
+	for (m = 0; try_ecc_modes[m] >= 0; m++) {
+		ecc_mode = try_ecc_modes[m];
+		if (oob_bytes_per_sector >= bch_ecc_sizes[ecc_mode]) {
+			nandi->bch_ecc_mode = ecc_mode;
+			return 0;
+		}
+	}
+
+	return -EINVAL;
+}
+
 static void nandi_set_mtd_defaults(struct nandi_controller *nandi,
 				   struct mtd_info *mtd, struct nand_chip *chip)
 {
@@ -792,6 +818,20 @@ static int stm_nand_bch_probe(struct platform_device *pdev)
 			     0x10000) ? true : false;
 	mtd->writebufsize = mtd->writesize;
 
+	/* Set ECC mode */
+	if (pdata->bch_ecc_cfg == BCH_ECC_AUTO) {
+		err = bch_set_ecc_auto(nandi, mtd);
+		if (err) {
+			dev_err(nandi->dev, "insufficient OOB for BCH ECC\n");
+			return err;
+		}
+	} else {
+		nandi->bch_ecc_mode = pdata->bch_ecc_cfg;
+	}
+
+	info->ecclayout.eccbytes =
+		nandi->sectors_per_page * bch_ecc_sizes[nandi->bch_ecc_mode];
+
 	return 0;
 }
 
-- 
1.8.3.2

