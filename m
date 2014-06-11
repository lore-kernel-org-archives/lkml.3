Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932677AbaFKJJN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 05:09:13 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:56311 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755628AbaFKI6K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 04:58:10 -0400
From: Roger Quadros <rogerq@ti.com>
To: <tony@atomide.com>, <dwmw2@infradead.org>, <computersforpeace@gmail.com>
CC: <kyungmin.park@samsung.com>, <pekon@ti.com>,
        <ezequiel.garcia@free-electrons.com>, <javier@dowhile0.org>,
        <nsekhar@ti.com>, <linux-omap@vger.kernel.org>,
        <linux-mtd@lists.infradead.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Roger Quadros <rogerq@ti.com>
Subject: [PATCH 16/36] mtd: onenand: omap: Remove regulator management code
Date: Wed, 11 Jun 2014 11:56:21 +0300
Message-ID: <1402477001-31132-17-git-send-email-rogerq@ti.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1402477001-31132-1-git-send-email-rogerq@ti.com>
References: <1402477001-31132-1-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

None of the OMAP platforms are suppying the "regulator_can_sleep"
parameter via platform data. Regulator management is generic
enough to be done in onenand_base driver if required.

Mark the "regulator_can_sleep" platform data parameter as deprecated.

Signed-off-by: Roger Quadros <rogerq@ti.com>
---
 drivers/mtd/onenand/omap2.c                     | 42 +------------------------
 include/linux/platform_data/mtd-onenand-omap2.h |  3 +-
 2 files changed, 3 insertions(+), 42 deletions(-)

diff --git a/drivers/mtd/onenand/omap2.c b/drivers/mtd/onenand/omap2.c
index d945473..a5f5ad8 100644
--- a/drivers/mtd/onenand/omap2.c
+++ b/drivers/mtd/onenand/omap2.c
@@ -34,7 +34,6 @@
 #include <linux/dma-mapping.h>
 #include <linux/io.h>
 #include <linux/slab.h>
-#include <linux/regulator/consumer.h>
 
 #include <asm/mach/flash.h>
 #include <linux/platform_data/mtd-onenand-omap2.h>
@@ -59,7 +58,6 @@ struct omap2_onenand {
 	int dma_channel;
 	int freq;
 	int (*setup)(void __iomem *base, int *freq_ptr);
-	struct regulator *regulator;
 	u8 flags;
 };
 
@@ -583,30 +581,6 @@ static void omap2_onenand_shutdown(struct platform_device *pdev)
 	memset((__force void *)c->onenand.base, 0, ONENAND_BUFRAM_SIZE);
 }
 
-static int omap2_onenand_enable(struct mtd_info *mtd)
-{
-	int ret;
-	struct omap2_onenand *c = container_of(mtd, struct omap2_onenand, mtd);
-
-	ret = regulator_enable(c->regulator);
-	if (ret != 0)
-		dev_err(&c->pdev->dev, "can't enable regulator\n");
-
-	return ret;
-}
-
-static int omap2_onenand_disable(struct mtd_info *mtd)
-{
-	int ret;
-	struct omap2_onenand *c = container_of(mtd, struct omap2_onenand, mtd);
-
-	ret = regulator_disable(c->regulator);
-	if (ret != 0)
-		dev_err(&c->pdev->dev, "can't disable regulator\n");
-
-	return ret;
-}
-
 static int omap2_onenand_probe(struct platform_device *pdev)
 {
 	struct omap_onenand_platform_data *pdata;
@@ -728,22 +702,11 @@ static int omap2_onenand_probe(struct platform_device *pdev)
 		}
 	}
 
-	if (pdata->regulator_can_sleep) {
-		c->regulator = regulator_get(&pdev->dev, "vonenand");
-		if (IS_ERR(c->regulator)) {
-			dev_err(&pdev->dev,  "Failed to get regulator\n");
-			r = PTR_ERR(c->regulator);
-			goto err_release_dma;
-		}
-		c->onenand.enable = omap2_onenand_enable;
-		c->onenand.disable = omap2_onenand_disable;
-	}
-
 	if (pdata->skip_initial_unlocking)
 		this->options |= ONENAND_SKIP_INITIAL_UNLOCKING;
 
 	if ((r = onenand_scan(&c->mtd, 1)) < 0)
-		goto err_release_regulator;
+		goto err_release_dma;
 
 	ppdata.of_node = pdata->of_node;
 	r = mtd_device_parse_register(&c->mtd, NULL, &ppdata,
@@ -758,8 +721,6 @@ static int omap2_onenand_probe(struct platform_device *pdev)
 
 err_release_onenand:
 	onenand_release(&c->mtd);
-err_release_regulator:
-	regulator_put(c->regulator);
 err_release_dma:
 	if (c->dma_channel != -1)
 		omap_free_dma(c->dma_channel);
@@ -783,7 +744,6 @@ static int omap2_onenand_remove(struct platform_device *pdev)
 	struct omap2_onenand *c = dev_get_drvdata(&pdev->dev);
 
 	onenand_release(&c->mtd);
-	regulator_put(c->regulator);
 	if (c->dma_channel != -1)
 		omap_free_dma(c->dma_channel);
 	omap2_onenand_shutdown(pdev);
diff --git a/include/linux/platform_data/mtd-onenand-omap2.h b/include/linux/platform_data/mtd-onenand-omap2.h
index 56ff0e6..445b41e 100644
--- a/include/linux/platform_data/mtd-onenand-omap2.h
+++ b/include/linux/platform_data/mtd-onenand-omap2.h
@@ -25,10 +25,11 @@ struct omap_onenand_platform_data {
 	int			(*onenand_setup)(void __iomem *, int *freq_ptr);
 	int			dma_channel;
 	u8			flags;
-	u8			regulator_can_sleep;
 	u8			skip_initial_unlocking;
 
 	/* for passing the partitions */
 	struct device_node	*of_node;
+
+	u8			regulator_can_sleep;	/* deprecated */
 };
 #endif
-- 
1.8.3.2

