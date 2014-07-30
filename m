Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753278AbaG3NLZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 09:11:25 -0400
Received: from relay1.mentorg.com ([192.94.38.131]:37826 "EHLO
	relay1.mentorg.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752555AbaG3NLW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 09:11:22 -0400
From: Vignesh Raman <Vignesh_Raman@mentor.com>
To: <vinod.koul@intel.com>, <dan.j.williams@intel.com>,
        <dmaengine@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: <Jiada_Wang@mentor.com>
Subject: [PATCH 1/2] dma: imx-sdma: use module_platform_driver for SDMA driver
Date: Wed, 30 Jul 2014 18:41:14 +0530
Message-ID: <1406725875-9171-2-git-send-email-Vignesh_Raman@mentor.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1406725875-9171-1-git-send-email-Vignesh_Raman@mentor.com>
References: <1406725875-9171-1-git-send-email-Vignesh_Raman@mentor.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginalArrivalTime: 30 Jul 2014 13:11:21.0436 (UTC) FILETIME=[C1D669C0:01CFABF7]
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
 drivers/dma/imx-sdma.c |   16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff --git a/drivers/dma/imx-sdma.c b/drivers/dma/imx-sdma.c
index 14867e3..1360b9d 100644
--- a/drivers/dma/imx-sdma.c
+++ b/drivers/dma/imx-sdma.c
@@ -1633,7 +1633,21 @@ err_irq:
 
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
+
+	dev_info(&pdev->dev, "Removed...\n");
+	return 0;
 }
 
 static struct platform_driver sdma_driver = {
-- 
1.7.9.5

