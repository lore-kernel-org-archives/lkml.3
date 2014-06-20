Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967134AbaFTUke (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 16:40:34 -0400
Received: from mail-pd0-f182.google.com ([209.85.192.182]:47738 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752863AbaFTUkc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 16:40:32 -0400
Date: Sat, 21 Jun 2014 02:10:25 +0530
From: Himangi Saraogi <himangi774@gmail.com>
To: Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: julia.lawall@lip6.fr
Subject: [PATCH] usb: musb: ux500: use devm_ functions
Message-ID: <20140620204025.GA14754@himangi-Dell>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch introduces the use of managed interfaces for clk_get and
kzalloc and removes the corresponding free function calls in the probe
and remove functions.

Signed-off-by: Himangi Saraogi <himangi774@gmail.com>
Acked-by: Julia Lawall <julia.lawall@lip6.fr>
---
 drivers/usb/musb/ux500.c | 28 ++++++++++------------------
 1 file changed, 10 insertions(+), 18 deletions(-)

diff --git a/drivers/usb/musb/ux500.c b/drivers/usb/musb/ux500.c
index c2e45e6..10c9cb0 100644
--- a/drivers/usb/musb/ux500.c
+++ b/drivers/usb/musb/ux500.c
@@ -246,7 +246,7 @@ static int ux500_probe(struct platform_device *pdev)
 		}
 	}
 
-	glue = kzalloc(sizeof(*glue), GFP_KERNEL);
+	glue = devm_kzalloc(&pdev->dev, sizeof(*glue), GFP_KERNEL);
 	if (!glue) {
 		dev_err(&pdev->dev, "failed to allocate glue context\n");
 		goto err0;
@@ -255,20 +255,20 @@ static int ux500_probe(struct platform_device *pdev)
 	musb = platform_device_alloc("musb-hdrc", PLATFORM_DEVID_AUTO);
 	if (!musb) {
 		dev_err(&pdev->dev, "failed to allocate musb device\n");
-		goto err1;
+		goto err0;
 	}
 
-	clk = clk_get(&pdev->dev, NULL);
+	clk = devm_clk_get(&pdev->dev, NULL);
 	if (IS_ERR(clk)) {
 		dev_err(&pdev->dev, "failed to get clock\n");
 		ret = PTR_ERR(clk);
-		goto err3;
+		goto err1;
 	}
 
 	ret = clk_prepare_enable(clk);
 	if (ret) {
 		dev_err(&pdev->dev, "failed to enable clock\n");
-		goto err4;
+		goto err1;
 	}
 
 	musb->dev.parent		= &pdev->dev;
@@ -302,34 +302,28 @@ static int ux500_probe(struct platform_device *pdev)
 			ARRAY_SIZE(musb_resources));
 	if (ret) {
 		dev_err(&pdev->dev, "failed to add resources\n");
-		goto err5;
+		goto err2;
 	}
 
 	ret = platform_device_add_data(musb, pdata, sizeof(*pdata));
 	if (ret) {
 		dev_err(&pdev->dev, "failed to add platform_data\n");
-		goto err5;
+		goto err2;
 	}
 
 	ret = platform_device_add(musb);
 	if (ret) {
 		dev_err(&pdev->dev, "failed to register musb device\n");
-		goto err5;
+		goto err2;
 	}
 
 	return 0;
 
-err5:
+err2:
 	clk_disable_unprepare(clk);
 
-err4:
-	clk_put(clk);
-
-err3:
-	platform_device_put(musb);
-
 err1:
-	kfree(glue);
+	platform_device_put(musb);
 
 err0:
 	return ret;
@@ -341,8 +335,6 @@ static int ux500_remove(struct platform_device *pdev)
 
 	platform_device_unregister(glue->musb);
 	clk_disable_unprepare(glue->clk);
-	clk_put(glue->clk);
-	kfree(glue);
 
 	return 0;
 }
-- 
1.9.1

