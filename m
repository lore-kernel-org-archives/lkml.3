Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752027AbaEMQm2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 12:42:28 -0400
Received: from mail-wi0-f176.google.com ([209.85.212.176]:62566 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750916AbaEMQmV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 12:42:21 -0400
From: abdoulaye berthe <berthe.ab@gmail.com>
To: berthe.ab@gmail.com, linus.walleij@linaro.org, gnurou@gmail.com,
        linux-gpio@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] gpio: janzttl: use devm function
Date: Tue, 13 May 2014 18:42:12 +0200
Message-Id: <1399999332-23279-1-git-send-email-berthe.ab@gmail.com>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This uses dem function for mem allocation

Signed-off-by: abdoulaye berthe <berthe.ab@gmail.com>
---
 drivers/gpio/gpio-janz-ttl.c | 34 +++++++---------------------------
 1 file changed, 7 insertions(+), 27 deletions(-)

diff --git a/drivers/gpio/gpio-janz-ttl.c b/drivers/gpio/gpio-janz-ttl.c
index 2ecd3a0..daa79e1 100644
--- a/drivers/gpio/gpio-janz-ttl.c
+++ b/drivers/gpio/gpio-janz-ttl.c
@@ -152,15 +152,13 @@ static int ttl_probe(struct platform_device *pdev)
 	pdata = dev_get_platdata(&pdev->dev);
 	if (!pdata) {
 		dev_err(dev, "no platform data\n");
-		ret = -ENXIO;
-		goto out_return;
+		return -ENXIO;
 	}
 
-	mod = kzalloc(sizeof(*mod), GFP_KERNEL);
+	mod = devm_kzalloc(dev, sizeof(struct ttl_module), GFP_KERNEL);
 	if (!mod) {
 		dev_err(dev, "unable to allocate private data\n");
-		ret = -ENOMEM;
-		goto out_return;
+		return -ENOMEM;
 	}
 
 	platform_set_drvdata(pdev, mod);
@@ -168,18 +166,9 @@ static int ttl_probe(struct platform_device *pdev)
 
 	/* get access to the MODULbus registers for this module */
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (!res) {
-		dev_err(dev, "MODULbus registers not found\n");
-		ret = -ENODEV;
-		goto out_free_mod;
-	}
-
-	mod->regs = ioremap(res->start, resource_size(res));
-	if (!mod->regs) {
-		dev_err(dev, "MODULbus registers not ioremap\n");
-		ret = -ENOMEM;
-		goto out_free_mod;
-	}
+	mod->regs = devm_ioremap_resource(dev, res);
+	if (IS_ERR(mod->regs))
+		return PTR_ERR(mod->regs);
 
 	ttl_setup_device(mod);
 
@@ -198,17 +187,10 @@ static int ttl_probe(struct platform_device *pdev)
 	ret = gpiochip_add(gpio);
 	if (ret) {
 		dev_err(dev, "unable to add GPIO chip\n");
-		goto out_iounmap_regs;
+		return ret;
 	}
 
 	return 0;
-
-out_iounmap_regs:
-	iounmap(mod->regs);
-out_free_mod:
-	kfree(mod);
-out_return:
-	return ret;
 }
 
 static int ttl_remove(struct platform_device *pdev)
@@ -223,8 +205,6 @@ static int ttl_remove(struct platform_device *pdev)
 		return ret;
 	}
 
-	iounmap(mod->regs);
-	kfree(mod);
 	return 0;
 }
 
-- 
1.8.3.2

