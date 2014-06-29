Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752396AbaF2Gnv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jun 2014 02:43:51 -0400
Received: from mail-pa0-f41.google.com ([209.85.220.41]:48111 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752318AbaF2Gnu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jun 2014 02:43:50 -0400
Date: Sun, 29 Jun 2014 12:13:43 +0530
From: Himangi Saraogi <himangi774@gmail.com>
To: Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: julia.lawall@lip6.fr
Subject: [PATCH] usb: host: ohci-tmio: Use managed interfaces for resource
 allocation
Message-ID: <20140629064342.GA15330@himangi-Dell>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch moves resources allocated using ioremap or
dma_declare_coherent_memory to the corresponding managed interface. The
function calls to free the allocated resources are removed in the probe
and remove functions as they are no longer required. Also, some labels
are done away with and a new label err added to make it less specific to
the context.

Signed-off-by: Himangi Saraogi <himangi774@gmail.com>
Acked-by: Julia Lawall <julia.lawall@lip6.fr>
---
 drivers/usb/host/ohci-tmio.c | 36 ++++++++++++------------------------
 1 file changed, 12 insertions(+), 24 deletions(-)

diff --git a/drivers/usb/host/ohci-tmio.c b/drivers/usb/host/ohci-tmio.c
index bb40958..1a6034f 100644
--- a/drivers/usb/host/ohci-tmio.c
+++ b/drivers/usb/host/ohci-tmio.c
@@ -203,10 +203,8 @@ static int ohci_hcd_tmio_drv_probe(struct platform_device *dev)
 		return -EINVAL;
 
 	hcd = usb_create_hcd(&ohci_tmio_hc_driver, &dev->dev, dev_name(&dev->dev));
-	if (!hcd) {
-		ret = -ENOMEM;
-		goto err_usb_create_hcd;
-	}
+	if (!hcd)
+		return -ENOMEM;
 
 	hcd->rsrc_start = regs->start;
 	hcd->rsrc_len = resource_size(regs);
@@ -215,30 +213,31 @@ static int ohci_hcd_tmio_drv_probe(struct platform_device *dev)
 
 	spin_lock_init(&tmio->lock);
 
-	tmio->ccr = ioremap(config->start, resource_size(config));
+	tmio->ccr = devm_ioremap(&dev->dev, config->start,
+				 resource_size(config));
 	if (!tmio->ccr) {
 		ret = -ENOMEM;
-		goto err_ioremap_ccr;
+		goto err;
 	}
 
-	hcd->regs = ioremap(hcd->rsrc_start, hcd->rsrc_len);
+	hcd->regs = devm_ioremap(&dev->dev, hcd->rsrc_start, hcd->rsrc_len);
 	if (!hcd->regs) {
 		ret = -ENOMEM;
-		goto err_ioremap_regs;
+		goto err;
 	}
 
-	if (!dma_declare_coherent_memory(&dev->dev, sram->start,
+	if (!dmam_declare_coherent_memory(&dev->dev, sram->start,
 				sram->start,
 				resource_size(sram),
 				DMA_MEMORY_MAP | DMA_MEMORY_EXCLUSIVE)) {
 		ret = -EBUSY;
-		goto err_dma_declare;
+		goto err;
 	}
 
 	if (cell->enable) {
 		ret = cell->enable(dev);
 		if (ret)
-			goto err_enable;
+			goto err;
 	}
 
 	tmio_start_hc(dev);
@@ -259,16 +258,8 @@ err_add_hcd:
 	tmio_stop_hc(dev);
 	if (cell->disable)
 		cell->disable(dev);
-err_enable:
-	dma_release_declared_memory(&dev->dev);
-err_dma_declare:
-	iounmap(hcd->regs);
-err_ioremap_regs:
-	iounmap(tmio->ccr);
-err_ioremap_ccr:
-	usb_put_hcd(hcd);
-err_usb_create_hcd:
-
+err:
+	usb_put_hcr(hcd);
 	return ret;
 }
 
@@ -282,9 +273,6 @@ static int ohci_hcd_tmio_drv_remove(struct platform_device *dev)
 	tmio_stop_hc(dev);
 	if (cell->disable)
 		cell->disable(dev);
-	dma_release_declared_memory(&dev->dev);
-	iounmap(hcd->regs);
-	iounmap(tmio->ccr);
 	usb_put_hcd(hcd);
 
 	return 0;
-- 
1.9.1

