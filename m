Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754994AbaHENKD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 09:10:03 -0400
Received: from relay1.mentorg.com ([192.94.38.131]:44878 "EHLO
	relay1.mentorg.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754896AbaHENJ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 09:09:59 -0400
From: Vignesh Raman <Vignesh_Raman@mentor.com>
To: <vinod.koul@intel.com>, <dan.j.williams@intel.com>,
        <dmaengine@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: <Jiada_Wang@mentor.com>
Subject: [PATCH v2 2/2] dma: imx-sdma: Adding tasklet_kill() in sdma_remove function.
Date: Tue, 5 Aug 2014 18:39:42 +0530
Message-ID: <1407244182-27302-3-git-send-email-Vignesh_Raman@mentor.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1407244182-27302-1-git-send-email-Vignesh_Raman@mentor.com>
References: <1407244182-27302-1-git-send-email-Vignesh_Raman@mentor.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginalArrivalTime: 05 Aug 2014 13:09:59.0036 (UTC) FILETIME=[8F33ABC0:01CFB0AE]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Several dma drivers calls tasklet_kill() in remove function. This is done
because all running tasklets should be killed on remove. This is missing
in imx sdma driver, so adding tasklet_kill() in sdma_remove function.

Signed-off-by: Vignesh Raman <Vignesh_Raman@mentor.com>
---
 drivers/dma/imx-sdma.c |    7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/dma/imx-sdma.c b/drivers/dma/imx-sdma.c
index 5cefc7d..3961c72 100644
--- a/drivers/dma/imx-sdma.c
+++ b/drivers/dma/imx-sdma.c
@@ -1638,12 +1638,19 @@ static int sdma_remove(struct platform_device *pdev)
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

