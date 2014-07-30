Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753335AbaG3NLe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 09:11:34 -0400
Received: from relay1.mentorg.com ([192.94.38.131]:37832 "EHLO
	relay1.mentorg.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753120AbaG3NLY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 09:11:24 -0400
From: Vignesh Raman <Vignesh_Raman@mentor.com>
To: <vinod.koul@intel.com>, <dan.j.williams@intel.com>,
        <dmaengine@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: <Jiada_Wang@mentor.com>
Subject: [PATCH 2/2] dma: imx-sdma: Adding tasklet_kill() in sdma_remove function.
Date: Wed, 30 Jul 2014 18:41:15 +0530
Message-ID: <1406725875-9171-3-git-send-email-Vignesh_Raman@mentor.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1406725875-9171-1-git-send-email-Vignesh_Raman@mentor.com>
References: <1406725875-9171-1-git-send-email-Vignesh_Raman@mentor.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginalArrivalTime: 30 Jul 2014 13:11:23.0934 (UTC) FILETIME=[C35393E0:01CFABF7]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Several dma drivers calls tasklet_kill() in remove function. This is missing in
imx driver, so adding tasklet_kill() in sdma_remove function.

Signed-off-by: Vignesh Raman <Vignesh_Raman@mentor.com>
---
 drivers/dma/imx-sdma.c |    7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/dma/imx-sdma.c b/drivers/dma/imx-sdma.c
index 1360b9d..974337f 100644
--- a/drivers/dma/imx-sdma.c
+++ b/drivers/dma/imx-sdma.c
@@ -1636,12 +1636,19 @@ static int sdma_remove(struct platform_device *pdev)
 	struct sdma_engine *sdma = platform_get_drvdata(pdev);
 	struct resource *iores = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	int irq = platform_get_irq(pdev, 0);
+	int i;
 
 	dma_async_device_unregister(&sdma->dma_device);
 	kfree(sdma->script_addrs);
 	free_irq(irq, sdma);
 	iounmap(sdma->regs);
 	release_mem_region(iores->start, resource_size(iores));
+	/* Kill the tasklet */
+	for (i = 0; i < MAX_DMA_CHANNELS; i++) {
+		struct sdma_channel *sdmac = &sdma->channel[i];
+
+		tasklet_kill(&sdmac->tasklet);
+	}
 	kfree(sdma);
 
 	platform_set_drvdata(pdev, NULL);
-- 
1.7.9.5

