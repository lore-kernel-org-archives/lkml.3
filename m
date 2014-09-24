Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753919AbaIXK0G (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 06:26:06 -0400
Received: from smtp65.ord1c.emailsrvr.com ([108.166.43.65]:36222 "EHLO
	smtp65.ord1c.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752735AbaIXK0E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 06:26:04 -0400
X-Sender-Id: kiran.padwal@smartplayin.com
From: Kiran Padwal <kiran.padwal@smartplayin.com>
To: vinod.koul@intel.com, dan.j.williams@intel.com
Cc: dmaengine@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kiran Padwal <kiran.padwal@smartplayin.com>
Subject: [PATCH v2] dma: cppi41: Switch to using managed resource in probe
Date: Wed, 24 Sep 2014 15:53:46 +0530
Message-Id: <1411554226-32134-1-git-send-email-kiran.padwal@smartplayin.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This change uses managed resource APIs to allocate resources such as,
mem, irq in order to simplify the driver unload or failure cases

Signed-off-by: Kiran Padwal <kiran.padwal@smartplayin.com>
---
Changes since v1:
 - Used devm_free_irq

 drivers/dma/cppi41.c |   16 +++++-----------
 1 file changed, 5 insertions(+), 11 deletions(-)

diff --git a/drivers/dma/cppi41.c b/drivers/dma/cppi41.c
index 5921ce3..cf7633f 100644
--- a/drivers/dma/cppi41.c
+++ b/drivers/dma/cppi41.c
@@ -938,7 +938,7 @@ static int cppi41_dma_probe(struct platform_device *pdev)
 	if (!glue_info)
 		return -EINVAL;
 
-	cdd = kzalloc(sizeof(*cdd), GFP_KERNEL);
+	cdd = devm_kzalloc(&pdev->dev, sizeof(*cdd), GFP_KERNEL);
 	if (!cdd)
 		return -ENOMEM;
 
@@ -959,10 +959,8 @@ static int cppi41_dma_probe(struct platform_device *pdev)
 	cdd->qmgr_mem = of_iomap(dev->of_node, 3);
 
 	if (!cdd->usbss_mem || !cdd->ctrl_mem || !cdd->sched_mem ||
-			!cdd->qmgr_mem) {
-		ret = -ENXIO;
-		goto err_remap;
-	}
+			!cdd->qmgr_mem)
+		return -ENXIO;
 
 	pm_runtime_enable(dev);
 	ret = pm_runtime_get_sync(dev);
@@ -989,7 +987,7 @@ static int cppi41_dma_probe(struct platform_device *pdev)
 
 	cppi_writel(USBSS_IRQ_PD_COMP, cdd->usbss_mem + USBSS_IRQ_ENABLER);
 
-	ret = request_irq(irq, glue_info->isr, IRQF_SHARED,
+	ret = devm_request_irq(&pdev->dev, irq, glue_info->isr, IRQF_SHARED,
 			dev_name(dev), cdd);
 	if (ret)
 		goto err_irq;
@@ -1009,7 +1007,6 @@ static int cppi41_dma_probe(struct platform_device *pdev)
 err_of:
 	dma_async_device_unregister(&cdd->ddev);
 err_dma_reg:
-	free_irq(irq, cdd);
 err_irq:
 	cppi_writel(0, cdd->usbss_mem + USBSS_IRQ_CLEARR);
 	cleanup_chans(cdd);
@@ -1023,8 +1020,6 @@ err_get_sync:
 	iounmap(cdd->ctrl_mem);
 	iounmap(cdd->sched_mem);
 	iounmap(cdd->qmgr_mem);
-err_remap:
-	kfree(cdd);
 	return ret;
 }
 
@@ -1036,7 +1031,7 @@ static int cppi41_dma_remove(struct platform_device *pdev)
 	dma_async_device_unregister(&cdd->ddev);
 
 	cppi_writel(0, cdd->usbss_mem + USBSS_IRQ_CLEARR);
-	free_irq(cdd->irq, cdd);
+	devm_free_irq(&pdev->dev, cdd->irq, cdd);
 	cleanup_chans(cdd);
 	deinit_cppi41(&pdev->dev, cdd);
 	iounmap(cdd->usbss_mem);
@@ -1045,7 +1040,6 @@ static int cppi41_dma_remove(struct platform_device *pdev)
 	iounmap(cdd->qmgr_mem);
 	pm_runtime_put(&pdev->dev);
 	pm_runtime_disable(&pdev->dev);
-	kfree(cdd);
 	return 0;
 }
 
-- 
1.7.9.5

