Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757946Ab3HAWQp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 18:16:45 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:39831 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757640Ab3HAWQm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 18:16:42 -0400
In-Reply-To: <20130801213420.GL23006@n2100.arm.linux.org.uk>
References: <20130801213420.GL23006@n2100.arm.linux.org.uk>
From: Russell King <rmk+kernel@arm.linux.org.uk>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH RFC 42/51] DMA-API: usb: musb: use
 platform_device_register_full() to avoid directly
 messing with dma masks
Message-Id: <E1V51AL-0006tr-8k@rmk-PC.arm.linux.org.uk>
Date: Thu, 01 Aug 2013 23:16:13 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use platform_device_register_full() for those drivers which can, to
avoid messing directly with DMA masks.  This can only be done when
the driver does not need to access the allocated musb platform device
from within its callbacks, which may be called during the musb
device probing.

Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
---
 drivers/usb/musb/am35x.c    |   50 ++++++++++++++----------------------------
 drivers/usb/musb/da8xx.c    |   49 ++++++++++++++---------------------------
 drivers/usb/musb/davinci.c  |   48 ++++++++++++++--------------------------
 drivers/usb/musb/tusb6010.c |   49 ++++++++++++++---------------------------
 4 files changed, 68 insertions(+), 128 deletions(-)

diff --git a/drivers/usb/musb/am35x.c b/drivers/usb/musb/am35x.c
index 2231850..a8d3eb3 100644
--- a/drivers/usb/musb/am35x.c
+++ b/drivers/usb/musb/am35x.c
@@ -89,7 +89,6 @@ struct am35x_glue {
 	struct clk		*phy_clk;
 	struct clk		*clk;
 };
-#define glue_to_musb(g)		platform_get_drvdata(g->musb)
 
 /*
  * am35x_musb_enable - enable interrupts
@@ -452,14 +451,18 @@ static const struct musb_platform_ops am35x_ops = {
 	.set_vbus	= am35x_musb_set_vbus,
 };
 
-static u64 am35x_dmamask = DMA_BIT_MASK(32);
+static const struct platform_device_info am35x_dev_info = {
+	.name		= "musb-hdrc",
+	.id		= PLATFORM_DEVID_AUTO,
+	.dma_mask	= DMA_BIT_MASK(32),
+};
 
 static int am35x_probe(struct platform_device *pdev)
 {
 	struct musb_hdrc_platform_data	*pdata = pdev->dev.platform_data;
 	struct platform_device		*musb;
 	struct am35x_glue		*glue;
-
+	struct platform_device_info	pinfo;
 	struct clk			*phy_clk;
 	struct clk			*clk;
 
@@ -471,12 +474,6 @@ static int am35x_probe(struct platform_device *pdev)
 		goto err0;
 	}
 
-	musb = platform_device_alloc("musb-hdrc", PLATFORM_DEVID_AUTO);
-	if (!musb) {
-		dev_err(&pdev->dev, "failed to allocate musb device\n");
-		goto err1;
-	}
-
 	phy_clk = clk_get(&pdev->dev, "fck");
 	if (IS_ERR(phy_clk)) {
 		dev_err(&pdev->dev, "failed to get PHY clock\n");
@@ -503,12 +500,7 @@ static int am35x_probe(struct platform_device *pdev)
 		goto err6;
 	}
 
-	musb->dev.parent		= &pdev->dev;
-	musb->dev.dma_mask		= &am35x_dmamask;
-	musb->dev.coherent_dma_mask	= am35x_dmamask;
-
 	glue->dev			= &pdev->dev;
-	glue->musb			= musb;
 	glue->phy_clk			= phy_clk;
 	glue->clk			= clk;
 
@@ -516,22 +508,17 @@ static int am35x_probe(struct platform_device *pdev)
 
 	platform_set_drvdata(pdev, glue);
 
-	ret = platform_device_add_resources(musb, pdev->resource,
-			pdev->num_resources);
-	if (ret) {
-		dev_err(&pdev->dev, "failed to add resources\n");
-		goto err7;
-	}
-
-	ret = platform_device_add_data(musb, pdata, sizeof(*pdata));
-	if (ret) {
-		dev_err(&pdev->dev, "failed to add platform_data\n");
-		goto err7;
-	}
-
-	ret = platform_device_add(musb);
-	if (ret) {
-		dev_err(&pdev->dev, "failed to register musb device\n");
+	pinfo = am35x_dev_info;
+	pinfo.parent = &pdev->dev;
+	pinfo.res = pdev->resource;
+	pinfo.num_res = pdev->num_resources;
+	pinfo.data = pdata;
+	pinfo.size_data = sizeof(*pdata);
+
+	glue->musb = musb = platform_device_register_full(&pinfo);
+	if (IS_ERR(musb)) {
+		ret = PTR_ERR(musb);
+		dev_err(&pdev->dev, "failed to register musb device: %d\n", ret);
 		goto err7;
 	}
 
@@ -550,9 +537,6 @@ static int am35x_probe(struct platform_device *pdev)
 	clk_put(phy_clk);
 
 err3:
-	platform_device_put(musb);
-
-err1:
 	kfree(glue);
 
 err0:
diff --git a/drivers/usb/musb/da8xx.c b/drivers/usb/musb/da8xx.c
index 0da6f64..57402e3 100644
--- a/drivers/usb/musb/da8xx.c
+++ b/drivers/usb/musb/da8xx.c
@@ -472,7 +472,11 @@ static const struct musb_platform_ops da8xx_ops = {
 	.set_vbus	= da8xx_musb_set_vbus,
 };
 
-static u64 da8xx_dmamask = DMA_BIT_MASK(32);
+static const struct platform_device_info da8xx_dev_info = {
+	.name		= "musb-hdrc",
+	.id		= PLATFORM_DEVID_AUTO,
+	.dma_mask	= DMA_BIT_MASK(32),
+};
 
 static int da8xx_probe(struct platform_device *pdev)
 {
@@ -480,7 +484,7 @@ static int da8xx_probe(struct platform_device *pdev)
 	struct musb_hdrc_platform_data	*pdata = pdev->dev.platform_data;
 	struct platform_device		*musb;
 	struct da8xx_glue		*glue;
-
+	struct platform_device_info	pinfo;
 	struct clk			*clk;
 
 	int				ret = -ENOMEM;
@@ -491,12 +495,6 @@ static int da8xx_probe(struct platform_device *pdev)
 		goto err0;
 	}
 
-	musb = platform_device_alloc("musb-hdrc", PLATFORM_DEVID_AUTO);
-	if (!musb) {
-		dev_err(&pdev->dev, "failed to allocate musb device\n");
-		goto err1;
-	}
-
 	clk = clk_get(&pdev->dev, "usb20");
 	if (IS_ERR(clk)) {
 		dev_err(&pdev->dev, "failed to get clock\n");
@@ -510,12 +508,7 @@ static int da8xx_probe(struct platform_device *pdev)
 		goto err4;
 	}
 
-	musb->dev.parent		= &pdev->dev;
-	musb->dev.dma_mask		= &da8xx_dmamask;
-	musb->dev.coherent_dma_mask	= da8xx_dmamask;
-
 	glue->dev			= &pdev->dev;
-	glue->musb			= musb;
 	glue->clk			= clk;
 
 	pdata->platform_ops		= &da8xx_ops;
@@ -535,22 +528,17 @@ static int da8xx_probe(struct platform_device *pdev)
 	musb_resources[1].end = pdev->resource[1].end;
 	musb_resources[1].flags = pdev->resource[1].flags;
 
-	ret = platform_device_add_resources(musb, musb_resources,
-			ARRAY_SIZE(musb_resources));
-	if (ret) {
-		dev_err(&pdev->dev, "failed to add resources\n");
-		goto err5;
-	}
-
-	ret = platform_device_add_data(musb, pdata, sizeof(*pdata));
-	if (ret) {
-		dev_err(&pdev->dev, "failed to add platform_data\n");
-		goto err5;
-	}
-
-	ret = platform_device_add(musb);
-	if (ret) {
-		dev_err(&pdev->dev, "failed to register musb device\n");
+	pinfo = da8xx_dev_info;
+	pinfo.parent = &pdev->dev;
+	pinfo.res = musb_resources;
+	pinfo.num_res = ARRAY_SIZE(musb_resources);
+	pinfo.data = pdata;
+	pinfo.size_data = sizeof(*pdata);
+
+	glue->musb = musb = platform_device_register_full(&pinfo);
+	if (IS_ERR(musb)) {
+		ret = PTR_ERR(musb);
+		dev_err(&pdev->dev, "failed to register musb device: %d\n", ret);
 		goto err5;
 	}
 
@@ -563,9 +551,6 @@ static int da8xx_probe(struct platform_device *pdev)
 	clk_put(clk);
 
 err3:
-	platform_device_put(musb);
-
-err1:
 	kfree(glue);
 
 err0:
diff --git a/drivers/usb/musb/davinci.c b/drivers/usb/musb/davinci.c
index f8aeaf2..a55f2e3 100644
--- a/drivers/usb/musb/davinci.c
+++ b/drivers/usb/musb/davinci.c
@@ -505,7 +505,11 @@ static const struct musb_platform_ops davinci_ops = {
 	.set_vbus	= davinci_musb_set_vbus,
 };
 
-static u64 davinci_dmamask = DMA_BIT_MASK(32);
+static const struct platform_device_info davinci_dev_info = {
+	.name		= "musb-hdrc",
+	.id		= PLATFORM_DEVID_AUTO,
+	.dma_mask	= DMA_BIT_MASK(32),
+};
 
 static int davinci_probe(struct platform_device *pdev)
 {
@@ -513,6 +517,7 @@ static int davinci_probe(struct platform_device *pdev)
 	struct musb_hdrc_platform_data	*pdata = pdev->dev.platform_data;
 	struct platform_device		*musb;
 	struct davinci_glue		*glue;
+	struct platform_device_info	pinfo;
 	struct clk			*clk;
 
 	int				ret = -ENOMEM;
@@ -523,12 +528,6 @@ static int davinci_probe(struct platform_device *pdev)
 		goto err0;
 	}
 
-	musb = platform_device_alloc("musb-hdrc", PLATFORM_DEVID_AUTO);
-	if (!musb) {
-		dev_err(&pdev->dev, "failed to allocate musb device\n");
-		goto err1;
-	}
-
 	clk = clk_get(&pdev->dev, "usb");
 	if (IS_ERR(clk)) {
 		dev_err(&pdev->dev, "failed to get clock\n");
@@ -542,12 +541,7 @@ static int davinci_probe(struct platform_device *pdev)
 		goto err4;
 	}
 
-	musb->dev.parent		= &pdev->dev;
-	musb->dev.dma_mask		= &davinci_dmamask;
-	musb->dev.coherent_dma_mask	= davinci_dmamask;
-
 	glue->dev			= &pdev->dev;
-	glue->musb			= musb;
 	glue->clk			= clk;
 
 	pdata->platform_ops		= &davinci_ops;
@@ -567,22 +561,17 @@ static int davinci_probe(struct platform_device *pdev)
 	musb_resources[1].end = pdev->resource[1].end;
 	musb_resources[1].flags = pdev->resource[1].flags;
 
-	ret = platform_device_add_resources(musb, musb_resources,
-			ARRAY_SIZE(musb_resources));
-	if (ret) {
-		dev_err(&pdev->dev, "failed to add resources\n");
-		goto err5;
-	}
-
-	ret = platform_device_add_data(musb, pdata, sizeof(*pdata));
-	if (ret) {
-		dev_err(&pdev->dev, "failed to add platform_data\n");
-		goto err5;
-	}
-
-	ret = platform_device_add(musb);
-	if (ret) {
-		dev_err(&pdev->dev, "failed to register musb device\n");
+	pinfo = davinci_dev_info;
+	pinfo.parent = &pdev->dev;
+	pinfo.res = musb_resources;
+	pinfo.num_res = ARRAY_SIZE(musb_resources);
+	pinfo.data = pdata;
+	pinfo.size_data = sizeof(*pdata);
+
+	glue->musb = musb = platform_device_register_full(&pinfo);
+	if (IS_ERR(musb)) {
+		ret = PTR_ERR(musb);
+		dev_err(&pdev->dev, "failed to register musb device: %d\n", ret);
 		goto err5;
 	}
 
@@ -595,9 +584,6 @@ static int davinci_probe(struct platform_device *pdev)
 	clk_put(clk);
 
 err3:
-	platform_device_put(musb);
-
-err1:
 	kfree(glue);
 
 err0:
diff --git a/drivers/usb/musb/tusb6010.c b/drivers/usb/musb/tusb6010.c
index 2c06a89..021c00e8 100644
--- a/drivers/usb/musb/tusb6010.c
+++ b/drivers/usb/musb/tusb6010.c
@@ -1152,7 +1152,11 @@ static const struct musb_platform_ops tusb_ops = {
 	.set_vbus	= tusb_musb_set_vbus,
 };
 
-static u64 tusb_dmamask = DMA_BIT_MASK(32);
+static const struct platform_device_info tusb_dev_info = {
+	.name		= "musb-hdrc",
+	.id		= PLATFORM_DEVID_AUTO,
+	.dma_mask	= DMA_BIT_MASK(32),
+};
 
 static int tusb_probe(struct platform_device *pdev)
 {
@@ -1160,7 +1164,7 @@ static int tusb_probe(struct platform_device *pdev)
 	struct musb_hdrc_platform_data	*pdata = pdev->dev.platform_data;
 	struct platform_device		*musb;
 	struct tusb6010_glue		*glue;
-
+	struct platform_device_info	pinfo;
 	int				ret = -ENOMEM;
 
 	glue = kzalloc(sizeof(*glue), GFP_KERNEL);
@@ -1169,18 +1173,7 @@ static int tusb_probe(struct platform_device *pdev)
 		goto err0;
 	}
 
-	musb = platform_device_alloc("musb-hdrc", PLATFORM_DEVID_AUTO);
-	if (!musb) {
-		dev_err(&pdev->dev, "failed to allocate musb device\n");
-		goto err1;
-	}
-
-	musb->dev.parent		= &pdev->dev;
-	musb->dev.dma_mask		= &tusb_dmamask;
-	musb->dev.coherent_dma_mask	= tusb_dmamask;
-
 	glue->dev			= &pdev->dev;
-	glue->musb			= musb;
 
 	pdata->platform_ops		= &tusb_ops;
 
@@ -1199,31 +1192,23 @@ static int tusb_probe(struct platform_device *pdev)
 	musb_resources[1].end = pdev->resource[1].end;
 	musb_resources[1].flags = pdev->resource[1].flags;
 
-	ret = platform_device_add_resources(musb, musb_resources,
-			ARRAY_SIZE(musb_resources));
-	if (ret) {
-		dev_err(&pdev->dev, "failed to add resources\n");
-		goto err3;
-	}
-
-	ret = platform_device_add_data(musb, pdata, sizeof(*pdata));
-	if (ret) {
-		dev_err(&pdev->dev, "failed to add platform_data\n");
-		goto err3;
-	}
-
-	ret = platform_device_add(musb);
-	if (ret) {
-		dev_err(&pdev->dev, "failed to register musb device\n");
+	pinfo = tusb_dev_info;
+	pinfo.parent = &pdev->dev;
+	pinfo.res = musb_resources;
+	pinfo.num_res = ARRAY_SIZE(musb_resources);
+	pinfo.data = pdata;
+	pinfo.size_data = sizeof(*pdata);
+
+	glue->musb = musb = platform_device_register_full(&pinfo);
+	if (IS_ERR(musb)) {
+		ret = PTR_ERR(musb);
+		dev_err(&pdev->dev, "failed to register musb device: %d\n", ret);
 		goto err3;
 	}
 
 	return 0;
 
 err3:
-	platform_device_put(musb);
-
-err1:
 	kfree(glue);
 
 err0:
-- 
1.7.4.4

