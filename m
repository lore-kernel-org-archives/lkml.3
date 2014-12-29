Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752141AbaL2RVP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2014 12:21:15 -0500
Received: from mail-vc0-f181.google.com ([209.85.220.181]:33070 "EHLO
	mail-vc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751026AbaL2RVJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2014 12:21:09 -0500
From: Fabio Estevam <festevam@gmail.com>
To: vinod.koul@intel.com
Cc: linux-kernel@vger.kernel.org, shawn.guo@linaro.org, kernel@pengutronix.de,
        Fabio Estevam <fabio.estevam@freescale.com>
Subject: [PATCH 2/3] dmaengine: imx-sdma: Use devm functions
Date: Mon, 29 Dec 2014 15:20:52 -0200
Message-Id: <1419873653-14411-2-git-send-email-festevam@gmail.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1419873653-14411-1-git-send-email-festevam@gmail.com>
References: <1419873653-14411-1-git-send-email-festevam@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Fabio Estevam <fabio.estevam@freescale.com>

By using devm functions we can make the code shorter and cleaner.

Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
---
 drivers/dma/imx-sdma.c | 62 +++++++++++++-------------------------------------
 1 file changed, 16 insertions(+), 46 deletions(-)

diff --git a/drivers/dma/imx-sdma.c b/drivers/dma/imx-sdma.c
index facb4162..6ac61ba 100644
--- a/drivers/dma/imx-sdma.c
+++ b/drivers/dma/imx-sdma.c
@@ -1472,7 +1472,7 @@ static int sdma_probe(struct platform_device *pdev)
 	if (ret)
 		return ret;
 
-	sdma = kzalloc(sizeof(*sdma), GFP_KERNEL);
+	sdma = devm_kzalloc(&pdev->dev, sizeof(*sdma), GFP_KERNEL);
 	if (!sdma)
 		return -ENOMEM;
 
@@ -1481,48 +1481,34 @@ static int sdma_probe(struct platform_device *pdev)
 	sdma->dev = &pdev->dev;
 	sdma->drvdata = drvdata;
 
-	iores = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	irq = platform_get_irq(pdev, 0);
-	if (!iores || irq < 0) {
-		ret = -EINVAL;
-		goto err_irq;
-	}
+	if (irq < 0)
+		return -EINVAL;
 
-	if (!request_mem_region(iores->start, resource_size(iores), pdev->name)) {
-		ret = -EBUSY;
-		goto err_request_region;
-	}
+	iores = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	sdma->regs = devm_ioremap_resource(&pdev->dev, iores);
+	if (IS_ERR(sdma->regs))
+		return PTR_ERR(sdma->regs);
 
 	sdma->clk_ipg = devm_clk_get(&pdev->dev, "ipg");
-	if (IS_ERR(sdma->clk_ipg)) {
-		ret = PTR_ERR(sdma->clk_ipg);
-		goto err_clk;
-	}
+	if (IS_ERR(sdma->clk_ipg))
+		return PTR_ERR(sdma->clk_ipg);
 
 	sdma->clk_ahb = devm_clk_get(&pdev->dev, "ahb");
-	if (IS_ERR(sdma->clk_ahb)) {
-		ret = PTR_ERR(sdma->clk_ahb);
-		goto err_clk;
-	}
+	if (IS_ERR(sdma->clk_ahb))
+		return PTR_ERR(sdma->clk_ahb);
 
 	clk_prepare(sdma->clk_ipg);
 	clk_prepare(sdma->clk_ahb);
 
-	sdma->regs = ioremap(iores->start, resource_size(iores));
-	if (!sdma->regs) {
-		ret = -ENOMEM;
-		goto err_ioremap;
-	}
-
-	ret = request_irq(irq, sdma_int_handler, 0, "sdma", sdma);
+	ret = devm_request_irq(&pdev->dev, irq, sdma_int_handler, 0, "sdma",
+			       sdma);
 	if (ret)
-		goto err_request_irq;
+		return ret;
 
 	sdma->script_addrs = kzalloc(sizeof(*sdma->script_addrs), GFP_KERNEL);
-	if (!sdma->script_addrs) {
-		ret = -ENOMEM;
-		goto err_alloc;
-	}
+	if (!sdma->script_addrs)
+		return -ENOMEM;
 
 	/* initially no scripts available */
 	saddr_arr = (s32 *)sdma->script_addrs;
@@ -1627,38 +1613,22 @@ err_register:
 	dma_async_device_unregister(&sdma->dma_device);
 err_init:
 	kfree(sdma->script_addrs);
-err_alloc:
-	free_irq(irq, sdma);
-err_request_irq:
-	iounmap(sdma->regs);
-err_ioremap:
-err_clk:
-	release_mem_region(iores->start, resource_size(iores));
-err_request_region:
-err_irq:
-	kfree(sdma);
 	return ret;
 }
 
 static int sdma_remove(struct platform_device *pdev)
 {
 	struct sdma_engine *sdma = platform_get_drvdata(pdev);
-	struct resource *iores = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	int irq = platform_get_irq(pdev, 0);
 	int i;
 
 	dma_async_device_unregister(&sdma->dma_device);
 	kfree(sdma->script_addrs);
-	free_irq(irq, sdma);
-	iounmap(sdma->regs);
-	release_mem_region(iores->start, resource_size(iores));
 	/* Kill the tasklet */
 	for (i = 0; i < MAX_DMA_CHANNELS; i++) {
 		struct sdma_channel *sdmac = &sdma->channel[i];
 
 		tasklet_kill(&sdmac->tasklet);
 	}
-	kfree(sdma);
 
 	platform_set_drvdata(pdev, NULL);
 	dev_info(&pdev->dev, "Removed...\n");
-- 
1.9.1

