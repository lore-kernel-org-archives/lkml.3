Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752593AbaEVXcN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 19:32:13 -0400
Received: from mail-la0-f54.google.com ([209.85.215.54]:59624 "EHLO
	mail-la0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751363AbaEVXcM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 19:32:12 -0400
From: abdoulaye berthe <berthe.ab@gmail.com>
To: berthe.ab@gmail.com, linux-kernel@vger.kernel.org
Subject: [PATCH] bus: omap_l3_noc.c: use devm functions
Date: Fri, 23 May 2014 01:32:05 +0200
Message-Id: <1400801525-17536-1-git-send-email-berthe.ab@gmail.com>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This uses devm function to ease mem alloc

Signed-off-by: abdoulaye berthe <berthe.ab@gmail.com>
---
 drivers/bus/omap_l3_noc.c | 73 +++++++++++------------------------------------
 1 file changed, 17 insertions(+), 56 deletions(-)

diff --git a/drivers/bus/omap_l3_noc.c b/drivers/bus/omap_l3_noc.c
index feeecae..e8bcc8f 100644
--- a/drivers/bus/omap_l3_noc.c
+++ b/drivers/bus/omap_l3_noc.c
@@ -133,53 +133,28 @@ static int omap4_l3_probe(struct platform_device *pdev)
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
@@ -191,7 +166,8 @@ static int omap4_l3_probe(struct platform_device *pdev)
 	if (ret) {
 		pr_crit("L3: request_irq failed to register for 0x%x\n",
 						l3->debug_irq);
-		goto err3;
+		free_irq(l3->debug_irq, l3);
+		return ret;
 	}
 
 	l3->app_irq = platform_get_irq(pdev, 1);
@@ -201,22 +177,11 @@ static int omap4_l3_probe(struct platform_device *pdev)
 	if (ret) {
 		pr_crit("L3: request_irq failed to register for 0x%x\n",
 						l3->app_irq);
-		goto err4;
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

