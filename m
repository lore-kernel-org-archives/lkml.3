Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932383AbaFKJN7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 05:13:59 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:59763 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755530AbaFKI5k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 04:57:40 -0400
From: Roger Quadros <rogerq@ti.com>
To: <tony@atomide.com>, <dwmw2@infradead.org>, <computersforpeace@gmail.com>
CC: <kyungmin.park@samsung.com>, <pekon@ti.com>,
        <ezequiel.garcia@free-electrons.com>, <javier@dowhile0.org>,
        <nsekhar@ti.com>, <linux-omap@vger.kernel.org>,
        <linux-mtd@lists.infradead.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Roger Quadros <rogerq@ti.com>
Subject: [PATCH 08/36] mtd: nand: omap: Copy platform data parameters to omap_nand_info data
Date: Wed, 11 Jun 2014 11:56:13 +0300
Message-ID: <1402477001-31132-9-git-send-email-rogerq@ti.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1402477001-31132-1-git-send-email-rogerq@ti.com>
References: <1402477001-31132-1-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Copy all the platform data parameters to the driver's local data
structure 'omap_nand_info' and use it in the entire driver. This will
make it easer for device tree migration.

Signed-off-by: Roger Quadros <rogerq@ti.com>
---
 drivers/mtd/nand/omap2.c | 27 ++++++++++++++++++---------
 1 file changed, 18 insertions(+), 9 deletions(-)

diff --git a/drivers/mtd/nand/omap2.c b/drivers/mtd/nand/omap2.c
index bb41796..e205863 100644
--- a/drivers/mtd/nand/omap2.c
+++ b/drivers/mtd/nand/omap2.c
@@ -184,15 +184,19 @@ static struct nand_ecclayout omap_oobinfo;
 
 struct omap_nand_info {
 	struct nand_hw_control		controller;
-	struct omap_nand_platform_data	*pdata;
 	struct mtd_info			mtd;
 	struct nand_chip		nand;
 	struct platform_device		*pdev;
 
 	int				gpmc_cs;
+	bool				dev_ready;
+	enum nand_io			xfer_type;
+	int				devsize;
+	enum omap_ecc			ecc_opt;
+	struct device_node		*elm_of_node;
+
 	unsigned long			phys_base;
 	void __iomem			*gpmc_base;
-	enum omap_ecc			ecc_opt;
 	struct completion		comp;
 	struct dma_chan			*dma;
 	int				gpmc_irq;
@@ -1708,6 +1712,11 @@ static int omap_nand_probe(struct platform_device *pdev)
 	info->gpmc_cs		= pdata->cs;
 	info->of_node		= pdata->of_node;
 	info->ecc_opt		= pdata->ecc_opt;
+	info->dev_ready	= pdata->dev_ready;
+	info->xfer_type = pdata->xfer_type;
+	info->devsize = pdata->devsize;
+	info->elm_of_node = pdata->elm_of_node;
+
 	mtd			= &info->mtd;
 	mtd->priv		= &info->nand;
 	mtd->name		= dev_name(&pdev->dev);
@@ -1762,7 +1771,7 @@ static int omap_nand_probe(struct platform_device *pdev)
 	 * chip delay which is slightly more than tR (AC Timing) of the NAND
 	 * device and read status register until you get a failure or success
 	 */
-	if (pdata->dev_ready) {
+	if (info->dev_ready) {
 		nand_chip->dev_ready = omap_dev_ready;
 		nand_chip->chip_delay = 0;
 	} else {
@@ -1771,7 +1780,7 @@ static int omap_nand_probe(struct platform_device *pdev)
 	}
 
 	/* scan NAND device connected to chip controller */
-	nand_chip->options |= pdata->devsize & NAND_BUSWIDTH_16;
+	nand_chip->options |= info->devsize & NAND_BUSWIDTH_16;
 	if (nand_scan_ident(mtd, 1, NULL)) {
 		pr_err("nand device scan failed, may be bus-width mismatch\n");
 		err = -ENXIO;
@@ -1779,14 +1788,14 @@ static int omap_nand_probe(struct platform_device *pdev)
 	}
 
 	/* check for small page devices */
-	if ((mtd->oobsize < 64) && (pdata->ecc_opt != OMAP_ECC_HAM1_CODE_HW)) {
+	if ((mtd->oobsize < 64) && (info->ecc_opt != OMAP_ECC_HAM1_CODE_HW)) {
 		pr_err("small page devices are not supported\n");
 		err = -EINVAL;
 		goto return_error;
 	}
 
 	/* re-populate low-level callbacks based on xfer modes */
-	switch (pdata->xfer_type) {
+	switch (info->xfer_type) {
 	case NAND_OMAP_PREFETCH_POLLED:
 		nand_chip->read_buf   = omap_read_buf_pref;
 		nand_chip->write_buf  = omap_write_buf_pref;
@@ -1849,7 +1858,7 @@ static int omap_nand_probe(struct platform_device *pdev)
 
 	default:
 		dev_err(&pdev->dev,
-			"xfer_type(%d) not supported!\n", pdata->xfer_type);
+			"xfer_type(%d) not supported!\n", info->xfer_type);
 		err = -EINVAL;
 		goto return_error;
 	}
@@ -1945,7 +1954,7 @@ static int omap_nand_probe(struct platform_device *pdev)
 		ecclayout->oobfree->offset	=
 				ecclayout->eccpos[ecclayout->eccbytes - 1] + 1;
 		/* This ECC scheme requires ELM H/W block */
-		if (is_elm_present(info, pdata->elm_of_node, BCH4_ECC) < 0) {
+		if (is_elm_present(info, info->elm_of_node, BCH4_ECC) < 0) {
 			pr_err("nand: error: could not initialize ELM\n");
 			err = -ENODEV;
 			goto return_error;
@@ -2011,7 +2020,7 @@ static int omap_nand_probe(struct platform_device *pdev)
 		nand_chip->ecc.read_page	= omap_read_page_bch;
 		nand_chip->ecc.write_page	= omap_write_page_bch;
 		/* This ECC scheme requires ELM H/W block */
-		err = is_elm_present(info, pdata->elm_of_node, BCH8_ECC);
+		err = is_elm_present(info, info->elm_of_node, BCH8_ECC);
 		if (err < 0) {
 			pr_err("nand: error: could not initialize ELM\n");
 			goto return_error;
-- 
1.8.3.2

