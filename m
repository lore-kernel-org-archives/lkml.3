Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753254Ab3AUKOB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 05:14:01 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:52606 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753127Ab3AUKKA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 05:10:00 -0500
From: Thierry Reding <thierry.reding@avionic-design.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>, Wolfram Sang <w.sang@pengutronix.de>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 21/33] pinctrl: Convert to devm_ioremap_resource()
Date: Mon, 21 Jan 2013 11:09:14 +0100
Message-Id: <1358762966-20791-22-git-send-email-thierry.reding@avionic-design.de>
X-Mailer: git-send-email 1.8.1.1
In-Reply-To: <1358762966-20791-1-git-send-email-thierry.reding@avionic-design.de>
References: <1358762966-20791-1-git-send-email-thierry.reding@avionic-design.de>
X-Provags-ID: V02:K0:Aqy1i5dszA+uQQbypeD8q9rglVwqs9BPehcy5MvVgFp
 uDS/6iZ97X2UYLtERBaGNojouy4ehjvBbMTnle/rxnK2KDUBI7
 I3tHRA0teWugE7M+3yAJXwa6ar0fyoAEUXGVVPX9pWFELBDfrt
 /HAI3vddtiYnIV7kHelesZ1Mlgy6jksniYP8HePz3SNTA1Pxor
 RrRiosBDqGUYwHCDU49j/sE9wjY3lNirINH5F528OHHA+xcUn0
 3XPUUTCS0CJjcZ0cB88Lvh/HnyuD7k4AuWjczmpdCel+ghKQ1b
 GcoK8mrEC6vd9THaIlVowU0zYqCAKTDIaMzNls3ku0XWR5FxUl
 1CK1ZjPx84v9s69amdM6mJgXy3KkE+B35dgpde40wAv1fIsVDb
 /0+KG5WZUHlemYzPTn+QcPocYvmbkd4jieMKjIt3VduO5A9bWT
 LiSW9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert all uses of devm_request_and_ioremap() to the newly introduced
devm_ioremap_resource() which provides more consistent error handling.

devm_ioremap_resource() provides its own error messages so all explicit
error messages can be removed from the failure code paths.

Signed-off-by: Thierry Reding <thierry.reding@avionic-design.de>
Cc: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/pinctrl/pinctrl-at91.c         |  7 +++----
 drivers/pinctrl/pinctrl-bcm2835.c      |  6 +++---
 drivers/pinctrl/pinctrl-coh901.c       |  8 +++-----
 drivers/pinctrl/pinctrl-exynos5440.c   |  8 +++-----
 drivers/pinctrl/pinctrl-falcon.c       | 13 +++++--------
 drivers/pinctrl/pinctrl-imx.c          |  6 +++---
 drivers/pinctrl/pinctrl-nomadik.c      |  6 +++---
 drivers/pinctrl/pinctrl-pxa3xx.c       |  7 ++++---
 drivers/pinctrl/pinctrl-samsung.c      |  8 +++-----
 drivers/pinctrl/pinctrl-u300.c         |  6 +++---
 drivers/pinctrl/pinctrl-xway.c         |  9 ++++-----
 drivers/pinctrl/spear/pinctrl-plgpio.c |  8 +++-----
 12 files changed, 40 insertions(+), 52 deletions(-)

diff --git a/drivers/pinctrl/pinctrl-at91.c b/drivers/pinctrl/pinctrl-at91.c
index 471c71f..75933a6 100644
--- a/drivers/pinctrl/pinctrl-at91.c
+++ b/drivers/pinctrl/pinctrl-at91.c
@@ -1503,10 +1503,9 @@ static int at91_gpio_probe(struct platform_device *pdev)
 		goto err;
 	}
 
-	at91_chip->regbase = devm_request_and_ioremap(&pdev->dev, res);
-	if (!at91_chip->regbase) {
-		dev_err(&pdev->dev, "failed to map registers, ignoring.\n");
-		ret = -EBUSY;
+	at91_chip->regbase = devm_ioremap_resource(&pdev->dev, res);
+	if (IS_ERR(at91_chip->regbase)) {
+		ret = PTR_ERR(at91_chip->regbase);
 		goto err;
 	}
 
diff --git a/drivers/pinctrl/pinctrl-bcm2835.c b/drivers/pinctrl/pinctrl-bcm2835.c
index d347b9f..4eb6d2c 100644
--- a/drivers/pinctrl/pinctrl-bcm2835.c
+++ b/drivers/pinctrl/pinctrl-bcm2835.c
@@ -959,9 +959,9 @@ static int bcm2835_pinctrl_probe(struct platform_device *pdev)
 		return err;
 	}
 
-	pc->base = devm_request_and_ioremap(dev, &iomem);
-	if (!pc->base)
-		return -EADDRNOTAVAIL;
+	pc->base = devm_ioremap_resource(dev, &iomem);
+	if (IS_ERR(pc->base))
+		return PTR_ERR(pc->base);
 
 	pc->gpio_chip = bcm2835_gpio_chip;
 	pc->gpio_chip.dev = dev;
diff --git a/drivers/pinctrl/pinctrl-coh901.c b/drivers/pinctrl/pinctrl-coh901.c
index fbb3715..8b7e7bc 100644
--- a/drivers/pinctrl/pinctrl-coh901.c
+++ b/drivers/pinctrl/pinctrl-coh901.c
@@ -715,11 +715,9 @@ static int __init u300_gpio_probe(struct platform_device *pdev)
 		return -ENODEV;
 	}
 
-	gpio->base = devm_request_and_ioremap(&pdev->dev, memres);
-	if (!gpio->base) {
-		dev_err(gpio->dev, "could not get remap memory\n");
-		return -ENOMEM;
-	}
+	gpio->base = devm_ioremap_resource(&pdev->dev, memres);
+	if (IS_ERR(gpio->base))
+		return PTR_ERR(gpio->base);
 
 	gpio->clk = devm_clk_get(gpio->dev, NULL);
 	if (IS_ERR(gpio->clk)) {
diff --git a/drivers/pinctrl/pinctrl-exynos5440.c b/drivers/pinctrl/pinctrl-exynos5440.c
index de05b64..5e77242 100644
--- a/drivers/pinctrl/pinctrl-exynos5440.c
+++ b/drivers/pinctrl/pinctrl-exynos5440.c
@@ -866,11 +866,9 @@ static int exynos5440_pinctrl_probe(struct platform_device *pdev)
 		return -ENOENT;
 	}
 
-	priv->reg_base = devm_request_and_ioremap(&pdev->dev, res);
-	if (!priv->reg_base) {
-		dev_err(dev, "ioremap failed\n");
-		return -ENODEV;
-	}
+	priv->reg_base = devm_ioremap_resource(&pdev->dev, res);
+	if (IS_ERR(priv->reg_base))
+		return PTR_ERR(priv->reg_base);
 
 	ret = exynos5440_gpiolib_register(pdev, priv);
 	if (ret)
diff --git a/drivers/pinctrl/pinctrl-falcon.c b/drivers/pinctrl/pinctrl-falcon.c
index 8ed20e8..a5d9d56 100644
--- a/drivers/pinctrl/pinctrl-falcon.c
+++ b/drivers/pinctrl/pinctrl-falcon.c
@@ -411,14 +411,11 @@ static int pinctrl_falcon_probe(struct platform_device *pdev)
 			dev_err(&ppdev->dev, "failed to get clock\n");
 			return PTR_ERR(falcon_info.clk[*bank]);
 		}
-		falcon_info.membase[*bank] =
-				devm_request_and_ioremap(&pdev->dev, &res);
-		if (!falcon_info.membase[*bank]) {
-			dev_err(&pdev->dev,
-				"Failed to remap memory for bank %d\n",
-				*bank);
-			return -ENOMEM;
-		}
+		falcon_info.membase[*bank] = devm_ioremap_resource(&pdev->dev,
+								   &res);
+		if (IS_ERR(falcon_info.membase[*bank]))
+			return PTR_ERR(falcon_info.membase[*bank]);
+		
 		avail = pad_r32(falcon_info.membase[*bank],
 					LTQ_PADC_AVAIL);
 		pins = fls(avail);
diff --git a/drivers/pinctrl/pinctrl-imx.c b/drivers/pinctrl/pinctrl-imx.c
index 43a6f1f..4cebb9c 100644
--- a/drivers/pinctrl/pinctrl-imx.c
+++ b/drivers/pinctrl/pinctrl-imx.c
@@ -584,9 +584,9 @@ int imx_pinctrl_probe(struct platform_device *pdev,
 	if (!res)
 		return -ENOENT;
 
-	ipctl->base = devm_request_and_ioremap(&pdev->dev, res);
-	if (!ipctl->base)
-		return -EBUSY;
+	ipctl->base = devm_ioremap_resource(&pdev->dev, res);
+	if (IS_ERR(ipctl->base))
+		return PTR_ERR(ipctl->base);
 
 	imx_pinctrl_desc.name = dev_name(&pdev->dev);
 	imx_pinctrl_desc.pins = info->pins;
diff --git a/drivers/pinctrl/pinctrl-nomadik.c b/drivers/pinctrl/pinctrl-nomadik.c
index 1bb16ff..96e7cfb 100644
--- a/drivers/pinctrl/pinctrl-nomadik.c
+++ b/drivers/pinctrl/pinctrl-nomadik.c
@@ -1367,9 +1367,9 @@ static int nmk_gpio_probe(struct platform_device *dev)
 		goto out;
 	}
 
-	base = devm_request_and_ioremap(&dev->dev, res);
-	if (!base) {
-		ret = -ENOMEM;
+	base = devm_ioremap_resource(&dev->dev, res);
+	if (IS_ERR(base)) {
+		ret = PTR_ERR(base);
 		goto out;
 	}
 
diff --git a/drivers/pinctrl/pinctrl-pxa3xx.c b/drivers/pinctrl/pinctrl-pxa3xx.c
index 51f8a38..1f49bb0 100644
--- a/drivers/pinctrl/pinctrl-pxa3xx.c
+++ b/drivers/pinctrl/pinctrl-pxa3xx.c
@@ -11,6 +11,7 @@
  *
  */
 
+#include <linux/err.h>
 #include <linux/module.h>
 #include <linux/device.h>
 #include <linux/io.h>
@@ -187,9 +188,9 @@ int pxa3xx_pinctrl_register(struct platform_device *pdev,
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	if (!res)
 		return -ENOENT;
-	info->virt_base = devm_request_and_ioremap(&pdev->dev, res);
-	if (!info->virt_base)
-		return -ENOMEM;
+	info->virt_base = devm_ioremap_resource(&pdev->dev, res);
+	if (IS_ERR(info->virt_base))
+		return PTR_ERR(info->virt_base);
 	info->pctrl = pinctrl_register(desc, &pdev->dev, info);
 	if (!info->pctrl) {
 		dev_err(&pdev->dev, "failed to register PXA pinmux driver\n");
diff --git a/drivers/pinctrl/pinctrl-samsung.c b/drivers/pinctrl/pinctrl-samsung.c
index fd7b24c..7e6669c 100644
--- a/drivers/pinctrl/pinctrl-samsung.c
+++ b/drivers/pinctrl/pinctrl-samsung.c
@@ -917,11 +917,9 @@ static int samsung_pinctrl_probe(struct platform_device *pdev)
 		return -ENOENT;
 	}
 
-	drvdata->virt_base = devm_request_and_ioremap(&pdev->dev, res);
-	if (!drvdata->virt_base) {
-		dev_err(dev, "ioremap failed\n");
-		return -ENODEV;
-	}
+	drvdata->virt_base = devm_ioremap_resource(&pdev->dev, res);
+	if (IS_ERR(drvdata->virt_base))
+		return PTR_ERR(drvdata->virt_base);
 
 	res = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
 	if (res)
diff --git a/drivers/pinctrl/pinctrl-u300.c b/drivers/pinctrl/pinctrl-u300.c
index 718ec57..2b57725 100644
--- a/drivers/pinctrl/pinctrl-u300.c
+++ b/drivers/pinctrl/pinctrl-u300.c
@@ -1078,9 +1078,9 @@ static int u300_pmx_probe(struct platform_device *pdev)
 	if (!res)
 		return -ENOENT;
 
-	upmx->virtbase = devm_request_and_ioremap(&pdev->dev, res);
-	if (!upmx->virtbase)
-		return -ENOMEM;
+	upmx->virtbase = devm_ioremap_resource(&pdev->dev, res);
+	if (IS_ERR(upmx->virtbase))
+		return PTR_ERR(upmx->virtbase);
 
 	upmx->pctl = pinctrl_register(&u300_pmx_desc, &pdev->dev, upmx);
 	if (!upmx->pctl) {
diff --git a/drivers/pinctrl/pinctrl-xway.c b/drivers/pinctrl/pinctrl-xway.c
index 5f0eb04..ae8f3a0 100644
--- a/drivers/pinctrl/pinctrl-xway.c
+++ b/drivers/pinctrl/pinctrl-xway.c
@@ -9,6 +9,7 @@
  *  Copyright (C) 2012 John Crispin <blogic@openwrt.org>
  */
 
+#include <linux/err.h>
 #include <linux/slab.h>
 #include <linux/module.h>
 #include <linux/of_platform.h>
@@ -687,11 +688,9 @@ static int pinmux_xway_probe(struct platform_device *pdev)
 		dev_err(&pdev->dev, "Failed to get resource\n");
 		return -ENOENT;
 	}
-	xway_info.membase[0] = devm_request_and_ioremap(&pdev->dev, res);
-	if (!xway_info.membase[0]) {
-		dev_err(&pdev->dev, "Failed to remap resource\n");
-		return -ENOMEM;
-	}
+	xway_info.membase[0] = devm_ioremap_resource(&pdev->dev, res);
+	if (IS_ERR(xway_info.membase[0]))
+		return PTR_ERR(xway_info.membase[0]);
 
 	match = of_match_device(xway_match, &pdev->dev);
 	if (match)
diff --git a/drivers/pinctrl/spear/pinctrl-plgpio.c b/drivers/pinctrl/spear/pinctrl-plgpio.c
index 3cf4ecd..295b349 100644
--- a/drivers/pinctrl/spear/pinctrl-plgpio.c
+++ b/drivers/pinctrl/spear/pinctrl-plgpio.c
@@ -540,11 +540,9 @@ static int plgpio_probe(struct platform_device *pdev)
 		return -ENOMEM;
 	}
 
-	plgpio->base = devm_request_and_ioremap(&pdev->dev, res);
-	if (!plgpio->base) {
-		dev_err(&pdev->dev, "request and ioremap fail\n");
-		return -ENOMEM;
-	}
+	plgpio->base = devm_ioremap_resource(&pdev->dev, res);
+	if (IS_ERR(plgpio->base))
+		return PTR_ERR(plgpio->base);
 
 	ret = plgpio_probe_dt(pdev, plgpio);
 	if (ret) {
-- 
1.8.1.1

