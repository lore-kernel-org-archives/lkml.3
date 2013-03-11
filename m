Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754724Ab3CKX7U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 19:59:20 -0400
Received: from mail-gg0-f181.google.com ([209.85.161.181]:53522 "EHLO
	mail-gg0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754205Ab3CKX7T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 19:59:19 -0400
From: Fabio Estevam <festevam@gmail.com>
To: FlorianSchandinat@gmx.de
Cc: akpm@linux-foundation.org, shawn.guo@linaro.org,
        linux-kernel@vger.kernel.org,
        Fabio Estevam <fabio.estevam@freescale.com>
Subject: [PATCH] video: mxsfb: Convert to devm_ioremap_resource()
Date: Mon, 11 Mar 2013 20:52:17 -0300
Message-Id: <1363045937-6740-1-git-send-email-festevam@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Fabio Estevam <fabio.estevam@freescale.com>

Converting to devm_ioremap_resource() can make the code cleaner and smaller.

Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
---
 drivers/video/mxsfb.c |   19 ++++---------------
 1 file changed, 4 insertions(+), 15 deletions(-)

diff --git a/drivers/video/mxsfb.c b/drivers/video/mxsfb.c
index 755556c..26cbc56 100644
--- a/drivers/video/mxsfb.c
+++ b/drivers/video/mxsfb.c
@@ -801,22 +801,17 @@ static int mxsfb_probe(struct platform_device *pdev)
 		return -ENODEV;
 	}
 
-	if (!request_mem_region(res->start, resource_size(res), pdev->name))
-		return -EBUSY;
-
 	fb_info = framebuffer_alloc(sizeof(struct mxsfb_info), &pdev->dev);
 	if (!fb_info) {
 		dev_err(&pdev->dev, "Failed to allocate fbdev\n");
-		ret = -ENOMEM;
-		goto error_alloc_info;
+		return -ENOMEM;
 	}
 
 	host = to_imxfb_host(fb_info);
 
-	host->base = ioremap(res->start, resource_size(res));
-	if (!host->base) {
-		dev_err(&pdev->dev, "ioremap failed\n");
-		ret = -ENOMEM;
+	host->base = devm_ioremap_resource(&pdev->dev, res);
+	if (IS_ERR(host->base)) {
+		return PTR_ERR(host->base);
 		goto error_ioremap;
 	}
 
@@ -904,11 +899,8 @@ error_panel_enable:
 	clk_put(host->clk);
 error_getclock:
 error_getpin:
-	iounmap(host->base);
 error_ioremap:
 	framebuffer_release(fb_info);
-error_alloc_info:
-	release_mem_region(res->start, resource_size(res));
 
 	return ret;
 }
@@ -917,7 +909,6 @@ static int mxsfb_remove(struct platform_device *pdev)
 {
 	struct fb_info *fb_info = platform_get_drvdata(pdev);
 	struct mxsfb_info *host = to_imxfb_host(fb_info);
-	struct resource *res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 
 	if (host->enabled)
 		mxsfb_disable_controller(fb_info);
@@ -925,11 +916,9 @@ static int mxsfb_remove(struct platform_device *pdev)
 	unregister_framebuffer(fb_info);
 	kfree(fb_info->pseudo_palette);
 	mxsfb_free_videomem(host);
-	iounmap(host->base);
 	clk_put(host->clk);
 
 	framebuffer_release(fb_info);
-	release_mem_region(res->start, resource_size(res));
 
 	platform_set_drvdata(pdev, NULL);
 
-- 
1.7.9.5

