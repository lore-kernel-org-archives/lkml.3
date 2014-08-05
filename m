Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754923AbaHENJ7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 09:09:59 -0400
Received: from relay1.mentorg.com ([192.94.38.131]:44875 "EHLO
	relay1.mentorg.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753041AbaHENJ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 09:09:56 -0400
From: Vignesh Raman <Vignesh_Raman@mentor.com>
To: <vinod.koul@intel.com>, <dan.j.williams@intel.com>,
        <dmaengine@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: <Jiada_Wang@mentor.com>
Subject: [PATCH v2 1/2] dma: imx-sdma: use module_platform_driver for SDMA driver
Date: Tue, 5 Aug 2014 18:39:41 +0530
Message-ID: <1407244182-27302-2-git-send-email-Vignesh_Raman@mentor.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1407244182-27302-1-git-send-email-Vignesh_Raman@mentor.com>
References: <1407244182-27302-1-git-send-email-Vignesh_Raman@mentor.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginalArrivalTime: 05 Aug 2014 13:09:56.0110 (UTC) FILETIME=[8D7532E0:01CFB0AE]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently there is no module_exit declared in SDMA driver, so that once
sdma module is inserted, it's shown with permanent attribute by lsmod,
and it can't be removed.
Use module_platform_driver to register/unregister SDMA driver and modify
SDMA's remove operation, to make SDMA driver possible to be removed.

Signed-off-by: Jiada Wang <jiada_wang@mentor.com>
---
 drivers/dma/imx-sdma.c |   24 ++++++++++++++++++------
 1 file changed, 18 insertions(+), 6 deletions(-)

diff --git a/drivers/dma/imx-sdma.c b/drivers/dma/imx-sdma.c
index 14867e3..5cefc7d 100644
--- a/drivers/dma/imx-sdma.c
+++ b/drivers/dma/imx-sdma.c
@@ -1596,6 +1596,8 @@ static int __init sdma_probe(struct platform_device *pdev)
 	sdma->dma_device.dev->dma_parms = &sdma->dma_parms;
 	dma_set_max_seg_size(sdma->dma_device.dev, 65535);
 
+	platform_set_drvdata(pdev, sdma);
+
 	ret = dma_async_device_register(&sdma->dma_device);
 	if (ret) {
 		dev_err(&pdev->dev, "unable to register\n");
@@ -1633,7 +1635,20 @@ err_irq:
 
 static int sdma_remove(struct platform_device *pdev)
 {
-	return -EBUSY;
+	struct sdma_engine *sdma = platform_get_drvdata(pdev);
+	struct resource *iores = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	int irq = platform_get_irq(pdev, 0);
+
+	dma_async_device_unregister(&sdma->dma_device);
+	kfree(sdma->script_addrs);
+	free_irq(irq, sdma);
+	iounmap(sdma->regs);
+	release_mem_region(iores->start, resource_size(iores));
+	kfree(sdma);
+
+	platform_set_drvdata(pdev, NULL);
+	dev_info(&pdev->dev, "Removed...\n");
+	return 0;
 }
 
 static struct platform_driver sdma_driver = {
@@ -1643,13 +1658,10 @@ static struct platform_driver sdma_driver = {
 	},
 	.id_table	= sdma_devtypes,
 	.remove		= sdma_remove,
+	.probe		= sdma_probe,
 };
 
-static int __init sdma_module_init(void)
-{
-	return platform_driver_probe(&sdma_driver, sdma_probe);
-}
-module_init(sdma_module_init);
+module_platform_driver(sdma_driver);
 
 MODULE_AUTHOR("Sascha Hauer, Pengutronix <s.hauer@pengutronix.de>");
 MODULE_DESCRIPTION("i.MX SDMA driver");
-- 
1.7.9.5

