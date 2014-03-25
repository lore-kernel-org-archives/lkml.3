Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752717AbaCYIUo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2014 04:20:44 -0400
Received: from mail-wg0-f46.google.com ([74.125.82.46]:55095 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752509AbaCYIUg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2014 04:20:36 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: lee.jones@linaro.org, kernel@stlinux.com, computersforpeace@gmail.com,
        linux-mtd@lists.infradead.org, dwmw2@infradead.org, angus.clark@st.com,
        pekon@ti.com
Subject: [RFC 09/47] mtd: nand: stm_nand_bch: introduce and initialise some important data structures
Date: Tue, 25 Mar 2014 08:19:26 +0000
Message-Id: <1395735604-26706-10-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1395735604-26706-1-git-send-email-lee.jones@linaro.org>
References: <1395735604-26706-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Provide some more in-depth structures which will be used heavily within
the driver. We also add a convenience function, used to set the default
values.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/mtd/nand/stm_nand_bch.c | 76 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 76 insertions(+)

diff --git a/drivers/mtd/nand/stm_nand_bch.c b/drivers/mtd/nand/stm_nand_bch.c
index cc0159e..7333ad6 100644
--- a/drivers/mtd/nand/stm_nand_bch.c
+++ b/drivers/mtd/nand/stm_nand_bch.c
@@ -21,10 +21,30 @@
 #include <linux/device.h>
 #include <linux/platform_device.h>
 #include <linux/completion.h>
+#include <linux/mtd/nand.h>
 #include <linux/mtd/stm_nand.h>
 
 #include "stm_nand_regs.h"
 
+/* Bad Block Table (BBT) */
+struct nandi_bbt_info {
+	uint32_t	bbt_size;		/* Size of bad-block table */
+	uint32_t	bbt_vers[2];		/* Version (Primary/Mirror) */
+	uint32_t	bbt_block[2];		/* Block No. (Primary/Mirror) */
+	uint8_t		*bbt;			/* Table data */
+};
+
+/* Collection of MTD/NAND device information */
+struct nandi_info {
+	struct mtd_info		mtd;		/* MTD info */
+	struct nand_chip	chip;		/* NAND chip info */
+
+	struct nand_ecclayout	ecclayout;	/* MTD ECC layout */
+	struct nandi_bbt_info	bbt_info;	/* Bad Block Table */
+	int			nr_parts;	/* Number of MTD partitions */
+	struct	mtd_partition	*parts;		/* MTD partitions */
+};
+
 /* NANDi Controller (Hamming/BCH) */
 struct nandi_controller {
 	void __iomem		*base;		/* Controller base*/
@@ -60,6 +80,8 @@ struct nandi_controller {
 
 	int			cached_page;	/* page number of page in */
 						/* 'page_buf'             */
+
+	struct nandi_info	info;		/* NAND device info */
 };
 
 /*
@@ -107,6 +129,46 @@ static void nandi_disable_interrupts(struct nandi_controller *nandi,
 	writel(val, nandi->base + NANDBCH_INT_EN);
 }
 
+static void nandi_set_mtd_defaults(struct nandi_controller *nandi,
+				   struct mtd_info *mtd, struct nand_chip *chip)
+{
+	struct nandi_info *info = &nandi->info;
+	int i;
+
+	/* ecclayout */
+	info->ecclayout.eccbytes = mtd->oobsize;
+	for (i = 0; i < 64; i++)
+		info->ecclayout.eccpos[i] = i;
+	info->ecclayout.oobfree[0].offset = 0;
+	info->ecclayout.oobfree[0].length = 0;
+	info->ecclayout.oobavail = 0;
+
+	/* nand_chip */
+	chip->controller = &chip->hwcontrol;
+	spin_lock_init(&chip->controller->lock);
+	init_waitqueue_head(&chip->controller->wq);
+	chip->state = FL_READY;
+	chip->priv = nandi;
+	chip->ecc.layout = &info->ecclayout;
+
+	/* mtd_info */
+	mtd->owner = THIS_MODULE;
+	mtd->type = MTD_NANDFLASH;
+	mtd->flags = MTD_CAP_NANDFLASH;
+	mtd->ecclayout = &info->ecclayout;
+	mtd->oobavail = 0;
+	mtd->subpage_sft = 0;
+
+	mtd->_point = NULL;
+	mtd->_unpoint = NULL;
+	mtd->_lock = NULL;
+	mtd->_unlock = NULL;
+
+	mtd->_sync = nand_sync;
+	mtd->_suspend = nand_suspend;
+	mtd->_resume = nand_resume;
+}
+
 static void nandi_clk_enable(struct nandi_controller *nandi)
 {
 	if (nandi->emi_clk)
@@ -271,7 +333,11 @@ static int stm_nand_bch_probe(struct platform_device *pdev)
 {
 	struct stm_plat_nand_bch_data *pdata = pdev->dev.platform_data;
 	struct stm_nand_bank_data *bank;
+	struct nandi_bbt_info *bbt_info;
 	struct nandi_controller *nandi;
+	struct nandi_info *info;
+	struct nand_chip *chip;
+	struct mtd_info *mtd;
 
 	if (!pdata) {
 		dev_err(&pdev->dev, "no platform data found\n");
@@ -291,6 +357,16 @@ static int stm_nand_bch_probe(struct platform_device *pdev)
 	if (bank)
 		nandi_init_controller(nandi, bank->csn);
 
+	info            = &nandi->info;
+	chip            = &info->chip;
+	bbt_info        = &info->bbt_info;
+	mtd             = &info->mtd;
+	mtd->priv       = chip;
+	mtd->name       = dev_name(&pdev->dev);
+	mtd->dev.parent = &pdev->dev;
+
+	nandi_set_mtd_defaults(nandi, mtd, chip);
+
 	return 0;
 }
 
-- 
1.8.3.2

