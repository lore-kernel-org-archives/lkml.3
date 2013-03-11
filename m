Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754756Ab3CKXut (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 19:50:49 -0400
Received: from mail-ye0-f174.google.com ([209.85.213.174]:38123 "EHLO
	mail-ye0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754489Ab3CKXur (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 19:50:47 -0400
From: Fabio Estevam <festevam@gmail.com>
To: vinod.koul@intel.com
Cc: shawn.guo@linaro.org, linux-kernel@vger.kernel.org,
        Fabio Estevam <festevam@gmail.com>
Subject: [PATCH] dma: mxs-dma: Convert to devm_ioremap_resource()
Date: Mon, 11 Mar 2013 20:50:33 -0300
Message-Id: <1363045833-6690-1-git-send-email-festevam@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Converting to devm_ioremap_resource() can make the code cleaner and smaller.

Signed-off-by: Fabio Estevam <festevam@gmail.com>
---
 drivers/dma/mxs-dma.c |   18 ++++--------------
 1 file changed, 4 insertions(+), 14 deletions(-)

diff --git a/drivers/dma/mxs-dma.c b/drivers/dma/mxs-dma.c
index 8f6d30d..8a9939e4 100644
--- a/drivers/dma/mxs-dma.c
+++ b/drivers/dma/mxs-dma.c
@@ -689,16 +689,9 @@ static int __init mxs_dma_probe(struct platform_device *pdev)
 	mxs_dma->dev_id = dma_type->id;
 
 	iores = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-
-	if (!request_mem_region(iores->start, resource_size(iores),
-				pdev->name)) {
-		ret = -EBUSY;
-		goto err_request_region;
-	}
-
-	mxs_dma->base = ioremap(iores->start, resource_size(iores));
-	if (!mxs_dma->base) {
-		ret = -ENOMEM;
+	mxs_dma->base = devm_ioremap_resource(&pdev->dev, iores);
+	if (IS_ERR(mxs_dma->base)) {
+		ret = PTR_ERR(mxs_dma->base);
 		goto err_ioremap;
 	}
 
@@ -761,10 +754,7 @@ static int __init mxs_dma_probe(struct platform_device *pdev)
 err_init:
 	clk_put(mxs_dma->clk);
 err_clk:
-	iounmap(mxs_dma->base);
-err_ioremap:
-	release_mem_region(iores->start, resource_size(iores));
-err_request_region:
+err_ioremap:
 	kfree(mxs_dma);
 	return ret;
 }
-- 
1.7.9.5

