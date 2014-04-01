Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751549AbaDADqJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 23:46:09 -0400
Received: from mail-pd0-f181.google.com ([209.85.192.181]:60688 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750777AbaDADqH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 23:46:07 -0400
Message-ID: <1396323961.15053.1.camel@phoenix>
Subject: [PATCH 1/2] bus: omap_l3_noc: Use devm_* managed allocators
From: Axel Lin <axel.lin@ingics.com>
To: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>
Cc: Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Lokesh Vutla <lokeshvutla@ti.com>, linux-kernel@vger.kernel.org
Date: Tue, 01 Apr 2014 11:46:01 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This simplifies error and cleanup code paths.
Also uses of_match_ptr() around of_match_table.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/bus/omap_l3_noc.c | 94 ++++++++++-------------------------------------
 1 file changed, 19 insertions(+), 75 deletions(-)

diff --git a/drivers/bus/omap_l3_noc.c b/drivers/bus/omap_l3_noc.c
index feeecae..47b0496 100644
--- a/drivers/bus/omap_l3_noc.c
+++ b/drivers/bus/omap_l3_noc.c
@@ -23,6 +23,7 @@
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/io.h>
+#include <linux/of.h>
 #include <linux/platform_device.h>
 #include <linux/interrupt.h>
 #include <linux/kernel.h>
@@ -134,103 +135,49 @@ static int omap4_l3_probe(struct platform_device *pdev)
 	struct resource	*res;
 	int ret;
 
-	l3 = kzalloc(sizeof(*l3), GFP_KERNEL);
+	l3 = devm_kzalloc(&pdev->dev, sizeof(*l3), GFP_KERNEL);
 	if (!l3)
 		return -ENOMEM;
 
 	platform_set_drvdata(pdev, l3);
-	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (!res) {
-		dev_err(&pdev->dev, "couldn't find resource 0\n");
-		ret = -ENODEV;
-		goto err0;
-	}
 
-	l3->l3_base[0] = ioremap(res->start, resource_size(res));
-	if (!l3->l3_base[0]) {
-		dev_err(&pdev->dev, "ioremap failed\n");
-		ret = -ENOMEM;
-		goto err0;
-	}
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	l3->l3_base[0] = devm_ioremap_resource(&pdev->dev, res);
+	if (IS_ERR(l3->l3_base[0]))
+		return PTR_ERR(l3->l3_base[0]);
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 1);
-	if (!res) {
-		dev_err(&pdev->dev, "couldn't find resource 1\n");
-		ret = -ENODEV;
-		goto err1;
-	}
-
-	l3->l3_base[1] = ioremap(res->start, resource_size(res));
-	if (!l3->l3_base[1]) {
-		dev_err(&pdev->dev, "ioremap failed\n");
-		ret = -ENOMEM;
-		goto err1;
-	}
+	l3->l3_base[1] = devm_ioremap_resource(&pdev->dev, res);
+	if (IS_ERR(l3->l3_base[1]))
+		return PTR_ERR(l3->l3_base[1]);
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 2);
-	if (!res) {
-		dev_err(&pdev->dev, "couldn't find resource 2\n");
-		ret = -ENODEV;
-		goto err2;
-	}
-
-	l3->l3_base[2] = ioremap(res->start, resource_size(res));
-	if (!l3->l3_base[2]) {
-		dev_err(&pdev->dev, "ioremap failed\n");
-		ret = -ENOMEM;
-		goto err2;
-	}
+	l3->l3_base[2] = devm_ioremap_resource(&pdev->dev, res);
+	if (IS_ERR(l3->l3_base[2]))
+		return PTR_ERR(l3->l3_base[2]);
 
 	/*
 	 * Setup interrupt Handlers
 	 */
 	l3->debug_irq = platform_get_irq(pdev, 0);
-	ret = request_irq(l3->debug_irq,
-			l3_interrupt_handler,
-			IRQF_DISABLED, "l3-dbg-irq", l3);
+	ret = devm_request_irq(&pdev->dev, l3->debug_irq, l3_interrupt_handler,
+			       IRQF_DISABLED, "l3-dbg-irq", l3);
 	if (ret) {
 		pr_crit("L3: request_irq failed to register for 0x%x\n",
 						l3->debug_irq);
-		goto err3;
+		return ret;
 	}
 
 	l3->app_irq = platform_get_irq(pdev, 1);
-	ret = request_irq(l3->app_irq,
-			l3_interrupt_handler,
-			IRQF_DISABLED, "l3-app-irq", l3);
+	ret = devm_request_irq(&pdev->dev, l3->app_irq, l3_interrupt_handler,
+			       IRQF_DISABLED, "l3-app-irq", l3);
 	if (ret) {
 		pr_crit("L3: request_irq failed to register for 0x%x\n",
 						l3->app_irq);
-		goto err4;
+		return ret;
 	}
 
 	return 0;
-
-err4:
-	free_irq(l3->debug_irq, l3);
-err3:
-	iounmap(l3->l3_base[2]);
-err2:
-	iounmap(l3->l3_base[1]);
-err1:
-	iounmap(l3->l3_base[0]);
-err0:
-	kfree(l3);
-	return ret;
-}
-
-static int omap4_l3_remove(struct platform_device *pdev)
-{
-	struct omap4_l3 *l3 = platform_get_drvdata(pdev);
-
-	free_irq(l3->app_irq, l3);
-	free_irq(l3->debug_irq, l3);
-	iounmap(l3->l3_base[0]);
-	iounmap(l3->l3_base[1]);
-	iounmap(l3->l3_base[2]);
-	kfree(l3);
-
-	return 0;
 }
 
 #if defined(CONFIG_OF)
@@ -239,17 +186,14 @@ static const struct of_device_id l3_noc_match[] = {
 	{},
 };
 MODULE_DEVICE_TABLE(of, l3_noc_match);
-#else
-#define l3_noc_match NULL
 #endif
 
 static struct platform_driver omap4_l3_driver = {
 	.probe		= omap4_l3_probe,
-	.remove		= omap4_l3_remove,
 	.driver		= {
 		.name		= "omap_l3_noc",
 		.owner		= THIS_MODULE,
-		.of_match_table = l3_noc_match,
+		.of_match_table = of_match_ptr(l3_noc_match),
 	},
 };
 
-- 
1.8.3.2



