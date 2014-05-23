Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752252AbaEWNID (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 09:08:03 -0400
Received: from mail-la0-f46.google.com ([209.85.215.46]:44193 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751113AbaEWNIB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 09:08:01 -0400
From: abdoulaye berthe <berthe.ab@gmail.com>
To: berthe.ab@gmail.com, linux-kernel@vger.kernel.org
Subject: [PATCH] bus: omap_l3_noc.c: use devm functions
Date: Fri, 23 May 2014 15:07:42 +0200
Message-Id: <1400850462-21192-1-git-send-email-berthe.ab@gmail.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1400801525-17536-1-git-send-email-berthe.ab@gmail.com>
References: <1400801525-17536-1-git-send-email-berthe.ab@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This uses devm function to ease mem alloc

Signed-off-by: abdoulaye berthe <berthe.ab@gmail.com>
---
 drivers/bus/omap_l3_noc.c | 85 +++++++++++++----------------------------------
 1 file changed, 23 insertions(+), 62 deletions(-)

diff --git a/drivers/bus/omap_l3_noc.c b/drivers/bus/omap_l3_noc.c
index feeecae..b496d3d 100644
--- a/drivers/bus/omap_l3_noc.c
+++ b/drivers/bus/omap_l3_noc.c
@@ -133,90 +133,55 @@ static int omap4_l3_probe(struct platform_device *pdev)
 	static struct omap4_l3 *l3;
 	struct resource	*res;
 	int ret;
+	struct device *dev = &pdev->dev;
 
-	l3 = kzalloc(sizeof(*l3), GFP_KERNEL);
+	l3 = devm_kzalloc(dev, sizeof(struct omap4_l3), GFP_KERNEL);
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
+	l3->l3_base[0] = devm_ioremap(dev, res->start, resource_size(res));
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
+	l3->l3_base[1] = devm_ioremap(dev, res->start, resource_size(res));
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
+	l3->l3_base[2] = devm_ioremap(dev, res->start, resource_size(res));
+	if (IS_ERR(l3->l3_base[2]))
+		return PTR_ERR(l3->l3_base[2]);
 
 	/*
 	 * Setup interrupt Handlers
 	 */
 	l3->debug_irq = platform_get_irq(pdev, 0);
 	ret = request_irq(l3->debug_irq,
-			l3_interrupt_handler,
-			IRQF_DISABLED, "l3-dbg-irq", l3);
+			  l3_interrupt_handler,
+			  IRQF_DISABLED, "l3-dbg-irq", l3);
 	if (ret) {
 		pr_crit("L3: request_irq failed to register for 0x%x\n",
-						l3->debug_irq);
-		goto err3;
+			l3->debug_irq);
+		free_irq(l3->debug_irq, l3);
+		return ret;
 	}
 
 	l3->app_irq = platform_get_irq(pdev, 1);
 	ret = request_irq(l3->app_irq,
-			l3_interrupt_handler,
-			IRQF_DISABLED, "l3-app-irq", l3);
+			  l3_interrupt_handler,
+			  IRQF_DISABLED, "l3-app-irq", l3);
 	if (ret) {
 		pr_crit("L3: request_irq failed to register for 0x%x\n",
-						l3->app_irq);
-		goto err4;
+			l3->app_irq);
+		free_irq(l3->app_irq, l3);
+		free_irq(l3->debug_irq, l3);
+		return ret;
 	}
-
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
 }
 
 static int omap4_l3_remove(struct platform_device *pdev)
@@ -225,10 +190,6 @@ static int omap4_l3_remove(struct platform_device *pdev)
 
 	free_irq(l3->app_irq, l3);
 	free_irq(l3->debug_irq, l3);
-	iounmap(l3->l3_base[0]);
-	iounmap(l3->l3_base[1]);
-	iounmap(l3->l3_base[2]);
-	kfree(l3);
 
 	return 0;
 }
-- 
1.8.3.2

