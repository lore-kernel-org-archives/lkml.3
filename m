Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934266AbaFSS3k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 14:29:40 -0400
Received: from mail-pa0-f52.google.com ([209.85.220.52]:55049 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933454AbaFSS3i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 14:29:38 -0400
Date: Thu, 19 Jun 2014 23:59:31 +0530
From: Himangi Saraogi <himangi774@gmail.com>
To: Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jan Andersson <jan@gaisler.com>
Cc: julia.lawall@lip6.fr
Subject: [PATCH v2] net/nxp/lpc_eth: use devm_ functions
Message-ID: <20140619182930.GA15152@himangi-Dell>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The various devm_ functions allocate memory that is released when a
driver detaches. This patch uses dmam_alloc_coherent, devm_ioremap
devm_clk_get etc. for data that is allocated in the probe function of
platform device and is only freed in the remove function. The
corresponding free functions are removed and many labels are done
away with. Also, linux/device.h is added to make sure the devm_*()
routine declarations are unambiguously available.

Signed-off-by: Himangi Saraogi <himangi774@gmail.com>
Acked-by: Julia Lawall <julia.lawall@lip6.fr>
---
v2: refreshed and sent again as failed to apply
 drivers/net/ethernet/nxp/lpc_eth.c | 32 +++++++++-----------------------
 1 file changed, 9 insertions(+), 23 deletions(-)

diff --git a/drivers/net/ethernet/nxp/lpc_eth.c b/drivers/net/ethernet/nxp/lpc_eth.c
index 8706c0d..8bb1a43 100644
--- a/drivers/net/ethernet/nxp/lpc_eth.c
+++ b/drivers/net/ethernet/nxp/lpc_eth.c
@@ -28,6 +28,7 @@
 #include <linux/errno.h>
 #include <linux/ioport.h>
 #include <linux/crc32.h>
+#include <linux/device.h>
 #include <linux/platform_device.h>
 #include <linux/spinlock.h>
 #include <linux/ethtool.h>
@@ -1350,7 +1351,7 @@ static int lpc_eth_drv_probe(struct platform_device *pdev)
 	ndev->irq = irq;
 
 	/* Get clock for the device */
-	pldat->clk = clk_get(&pdev->dev, NULL);
+	pldat->clk = devm_clk_get(&pdev->dev, NULL);
 	if (IS_ERR(pldat->clk)) {
 		dev_err(&pdev->dev, "error getting clock.\n");
 		ret = PTR_ERR(pldat->clk);
@@ -1361,7 +1362,8 @@ static int lpc_eth_drv_probe(struct platform_device *pdev)
 	__lpc_eth_clock_enable(pldat, true);
 
 	/* Map IO space */
-	pldat->net_base = ioremap(res->start, resource_size(res));
+	pldat->net_base = devm_ioremap(&pdev->dev, res->start,
+				       resource_size(res));
 	if (!pldat->net_base) {
 		dev_err(&pdev->dev, "failed to map registers\n");
 		ret = -ENOMEM;
@@ -1371,7 +1373,7 @@ static int lpc_eth_drv_probe(struct platform_device *pdev)
 			  ndev->name, ndev);
 	if (ret) {
 		dev_err(&pdev->dev, "error requesting interrupt.\n");
-		goto err_out_iounmap;
+		goto err_out_disable_clocks;
 	}
 
 	/* Fill in the fields of the device structure with ethernet values. */
@@ -1407,9 +1409,9 @@ static int lpc_eth_drv_probe(struct platform_device *pdev)
 		/* Allocate a chunk of memory for the DMA ethernet buffers
 		   and descriptors */
 		pldat->dma_buff_base_v =
-			dma_alloc_coherent(&pldat->pdev->dev,
-					   pldat->dma_buff_size, &dma_handle,
-					   GFP_KERNEL);
+			dmam_alloc_coherent(&pldat->pdev->dev,
+					    pldat->dma_buff_size, &dma_handle,
+					    GFP_KERNEL);
 		if (pldat->dma_buff_base_v == NULL) {
 			ret = -ENOMEM;
 			goto err_out_free_irq;
@@ -1463,7 +1465,7 @@ static int lpc_eth_drv_probe(struct platform_device *pdev)
 	ret = register_netdev(ndev);
 	if (ret) {
 		dev_err(&pdev->dev, "Cannot register net device, aborting.\n");
-		goto err_out_dma_unmap;
+		goto err_out_free_irq;
 	}
 	platform_set_drvdata(pdev, ndev);
 
@@ -1483,19 +1485,10 @@ static int lpc_eth_drv_probe(struct platform_device *pdev)
 
 err_out_unregister_netdev:
 	unregister_netdev(ndev);
-err_out_dma_unmap:
-	if (!use_iram_for_net(&pldat->pdev->dev) ||
-	    pldat->dma_buff_size > lpc32xx_return_iram_size())
-		dma_free_coherent(&pldat->pdev->dev, pldat->dma_buff_size,
-				  pldat->dma_buff_base_v,
-				  pldat->dma_buff_base_p);
 err_out_free_irq:
 	free_irq(ndev->irq, ndev);
-err_out_iounmap:
-	iounmap(pldat->net_base);
 err_out_disable_clocks:
 	clk_disable(pldat->clk);
-	clk_put(pldat->clk);
 err_out_free_dev:
 	free_netdev(ndev);
 err_exit:
@@ -1510,17 +1503,10 @@ static int lpc_eth_drv_remove(struct platform_device *pdev)
 
 	unregister_netdev(ndev);
 
-	if (!use_iram_for_net(&pldat->pdev->dev) ||
-	    pldat->dma_buff_size > lpc32xx_return_iram_size())
-		dma_free_coherent(&pldat->pdev->dev, pldat->dma_buff_size,
-				  pldat->dma_buff_base_v,
-				  pldat->dma_buff_base_p);
 	free_irq(ndev->irq, ndev);
-	iounmap(pldat->net_base);
 	mdiobus_unregister(pldat->mii_bus);
 	mdiobus_free(pldat->mii_bus);
 	clk_disable(pldat->clk);
-	clk_put(pldat->clk);
 	free_netdev(ndev);
 
 	return 0;
-- 
1.9.1

