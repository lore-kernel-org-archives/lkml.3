Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751899AbaDADqq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 23:46:46 -0400
Received: from mail-pb0-f48.google.com ([209.85.160.48]:44176 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751636AbaDADqo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 23:46:44 -0400
Message-ID: <1396323999.15053.2.camel@phoenix>
Subject: [PATCH 2/2] bus: omap_l3_smx: Use devm_* managed allocators
From: Axel Lin <axel.lin@ingics.com>
To: Olof Johansson <olof@lixom.net>
Cc: Arnd Bergmann <arnd@arndb.de>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Lokesh Vutla <lokeshvutla@ti.com>, linux-kernel@vger.kernel.org
Date: Tue, 01 Apr 2014 11:46:39 +0800
In-Reply-To: <1396323961.15053.1.camel@phoenix>
References: <1396323961.15053.1.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This simplifies error and cleanup code paths.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/bus/omap_l3_smx.c | 53 +++++++++++------------------------------------
 1 file changed, 12 insertions(+), 41 deletions(-)

diff --git a/drivers/bus/omap_l3_smx.c b/drivers/bus/omap_l3_smx.c
index acc2164..90840cf 100644
--- a/drivers/bus/omap_l3_smx.c
+++ b/drivers/bus/omap_l3_smx.c
@@ -217,68 +217,39 @@ static int __init omap3_l3_probe(struct platform_device *pdev)
 	struct resource *res;
 	int ret;
 
-	l3 = kzalloc(sizeof(*l3), GFP_KERNEL);
+	l3 = devm_kzalloc(&pdev->dev, sizeof(*l3), GFP_KERNEL);
 	if (!l3)
 		return -ENOMEM;
 
 	platform_set_drvdata(pdev, l3);
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (!res) {
-		dev_err(&pdev->dev, "couldn't find resource\n");
-		ret = -ENODEV;
-		goto err0;
-	}
-	l3->rt = ioremap(res->start, resource_size(res));
-	if (!l3->rt) {
-		dev_err(&pdev->dev, "ioremap failed\n");
-		ret = -ENOMEM;
-		goto err0;
-	}
+	l3->rt = devm_ioremap_resource(&pdev->dev, res);
+	if (IS_ERR(l3->rt))
+		return PTR_ERR(l3->rt);
 
 	l3->debug_irq = platform_get_irq(pdev, 0);
-	ret = request_irq(l3->debug_irq, omap3_l3_app_irq,
-		IRQF_DISABLED | IRQF_TRIGGER_RISING,
-		"l3-debug-irq", l3);
+	ret = devm_request_irq(&pdev->dev, l3->debug_irq, omap3_l3_app_irq,
+			       IRQF_DISABLED | IRQF_TRIGGER_RISING,
+			       "l3-debug-irq", l3);
 	if (ret) {
 		dev_err(&pdev->dev, "couldn't request debug irq\n");
-		goto err1;
+		return ret;
 	}
 
 	l3->app_irq = platform_get_irq(pdev, 1);
-	ret = request_irq(l3->app_irq, omap3_l3_app_irq,
-		IRQF_DISABLED | IRQF_TRIGGER_RISING,
-		"l3-app-irq", l3);
+	ret = devm_request_irq(&pdev->dev, l3->app_irq, omap3_l3_app_irq,
+			       IRQF_DISABLED | IRQF_TRIGGER_RISING,
+			       "l3-app-irq", l3);
 	if (ret) {
 		dev_err(&pdev->dev, "couldn't request app irq\n");
-		goto err2;
+		return ret;
 	}
 
 	return 0;
-
-err2:
-	free_irq(l3->debug_irq, l3);
-err1:
-	iounmap(l3->rt);
-err0:
-	kfree(l3);
-	return ret;
-}
-
-static int __exit omap3_l3_remove(struct platform_device *pdev)
-{
-	struct omap3_l3         *l3 = platform_get_drvdata(pdev);
-
-	free_irq(l3->app_irq, l3);
-	free_irq(l3->debug_irq, l3);
-	iounmap(l3->rt);
-	kfree(l3);
-
-	return 0;
 }
 
 static struct platform_driver omap3_l3_driver = {
-	.remove         = __exit_p(omap3_l3_remove),
 	.driver         = {
 	.name   = "omap_l3_smx",
 	},
-- 
1.8.3.2



