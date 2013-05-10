Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753205Ab3EJIRE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 04:17:04 -0400
Received: from sauhun.de ([89.238.76.85]:60451 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753143Ab3EJIQ6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 04:16:58 -0400
From: Wolfram Sang <wsa@the-dreams.de>
To: linux-kernel@vger.kernel.org
Cc: Wolfram Sang <wsa@the-dreams.de>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        linux-arm-kernel@lists.infradead.org
Subject: [RFC 18/42] drivers/pinctrl: don't check resource with devm_ioremap_resource
Date: Fri, 10 May 2013 10:17:03 +0200
Message-Id: <1368173847-5661-19-git-send-email-wsa@the-dreams.de>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1368173847-5661-1-git-send-email-wsa@the-dreams.de>
References: <1368173847-5661-1-git-send-email-wsa@the-dreams.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

devm_ioremap_resource does sanity checks on the given resource. No need to
duplicate this in the driver.

Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
---
 drivers/pinctrl/pinctrl-at91.c       |    7 +------
 drivers/pinctrl/pinctrl-coh901.c     |    5 -----
 drivers/pinctrl/pinctrl-exynos5440.c |    5 -----
 drivers/pinctrl/pinctrl-samsung.c    |    5 -----
 drivers/pinctrl/pinctrl-xway.c       |    4 ----
 5 files changed, 1 insertion(+), 25 deletions(-)

diff --git a/drivers/pinctrl/pinctrl-at91.c b/drivers/pinctrl/pinctrl-at91.c
index 5d7529e..b90a3a0 100644
--- a/drivers/pinctrl/pinctrl-at91.c
+++ b/drivers/pinctrl/pinctrl-at91.c
@@ -1543,12 +1543,6 @@ static int at91_gpio_probe(struct platform_device *pdev)
 		goto err;
 	}
 
-	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (!res) {
-		ret = -ENOENT;
-		goto err;
-	}
-
 	irq = platform_get_irq(pdev, 0);
 	if (irq < 0) {
 		ret = irq;
@@ -1561,6 +1555,7 @@ static int at91_gpio_probe(struct platform_device *pdev)
 		goto err;
 	}
 
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	at91_chip->regbase = devm_ioremap_resource(&pdev->dev, res);
 	if (IS_ERR(at91_chip->regbase)) {
 		ret = PTR_ERR(at91_chip->regbase);
diff --git a/drivers/pinctrl/pinctrl-coh901.c b/drivers/pinctrl/pinctrl-coh901.c
index edde3ac..a67af41 100644
--- a/drivers/pinctrl/pinctrl-coh901.c
+++ b/drivers/pinctrl/pinctrl-coh901.c
@@ -713,11 +713,6 @@ static int __init u300_gpio_probe(struct platform_device *pdev)
 	gpio->dev = &pdev->dev;
 
 	memres = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (!memres) {
-		dev_err(gpio->dev, "could not get GPIO memory resource\n");
-		return -ENODEV;
-	}
-
 	gpio->base = devm_ioremap_resource(&pdev->dev, memres);
 	if (IS_ERR(gpio->base))
 		return PTR_ERR(gpio->base);
diff --git a/drivers/pinctrl/pinctrl-exynos5440.c b/drivers/pinctrl/pinctrl-exynos5440.c
index 6038503..32a48f4 100644
--- a/drivers/pinctrl/pinctrl-exynos5440.c
+++ b/drivers/pinctrl/pinctrl-exynos5440.c
@@ -1000,11 +1000,6 @@ static int exynos5440_pinctrl_probe(struct platform_device *pdev)
 	}
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (!res) {
-		dev_err(dev, "cannot find IO resource\n");
-		return -ENOENT;
-	}
-
 	priv->reg_base = devm_ioremap_resource(&pdev->dev, res);
 	if (IS_ERR(priv->reg_base))
 		return PTR_ERR(priv->reg_base);
diff --git a/drivers/pinctrl/pinctrl-samsung.c b/drivers/pinctrl/pinctrl-samsung.c
index 9763668..055d016 100644
--- a/drivers/pinctrl/pinctrl-samsung.c
+++ b/drivers/pinctrl/pinctrl-samsung.c
@@ -932,11 +932,6 @@ static int samsung_pinctrl_probe(struct platform_device *pdev)
 	drvdata->dev = dev;
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (!res) {
-		dev_err(dev, "cannot find IO resource\n");
-		return -ENOENT;
-	}
-
 	drvdata->virt_base = devm_ioremap_resource(&pdev->dev, res);
 	if (IS_ERR(drvdata->virt_base))
 		return PTR_ERR(drvdata->virt_base);
diff --git a/drivers/pinctrl/pinctrl-xway.c b/drivers/pinctrl/pinctrl-xway.c
index f2977cf..e92132c 100644
--- a/drivers/pinctrl/pinctrl-xway.c
+++ b/drivers/pinctrl/pinctrl-xway.c
@@ -716,10 +716,6 @@ static int pinmux_xway_probe(struct platform_device *pdev)
 
 	/* get and remap our register range */
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (!res) {
-		dev_err(&pdev->dev, "Failed to get resource\n");
-		return -ENOENT;
-	}
 	xway_info.membase[0] = devm_ioremap_resource(&pdev->dev, res);
 	if (IS_ERR(xway_info.membase[0]))
 		return PTR_ERR(xway_info.membase[0]);
-- 
1.7.10.4

