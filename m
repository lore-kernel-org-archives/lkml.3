Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753158Ab3AUKS4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 05:18:56 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:62927 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752654Ab3AUKJi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 05:09:38 -0500
From: Thierry Reding <thierry.reding@avionic-design.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>, Wolfram Sang <w.sang@pengutronix.de>,
        Ben Dooks <ben-linux@fluff.org>, linux-i2c@vger.kernel.org
Subject: [PATCH 10/33] i2c: Convert to devm_ioremap_resource()
Date: Mon, 21 Jan 2013 11:09:03 +0100
Message-Id: <1358762966-20791-11-git-send-email-thierry.reding@avionic-design.de>
X-Mailer: git-send-email 1.8.1.1
In-Reply-To: <1358762966-20791-1-git-send-email-thierry.reding@avionic-design.de>
References: <1358762966-20791-1-git-send-email-thierry.reding@avionic-design.de>
X-Provags-ID: V02:K0:SRv4bEbpK5n/NgM2LmYdhsmJHS+LWDiEn2AheiGOaH/
 lCn8Zmwatu5q7xI+xMM6vnhd8XmMPx6W6MJ15CzwZXYvy9hlcL
 YhFF4BkoUJDL+zBw2we2agRuk7EyPTMotwg5pWhI8JTijsStQE
 7/8IaksCTBWbGPqSeAU5GoIvU6mzHmxnmxhmUaEZvIf1n4nr1S
 wL075yjGWCAxKnNH9vOLPlKUY3jFjiCfHTsdTJawO9iugwbjCL
 ehhfN9CFy10l9AM9y+OI5Ze5wBuuXD4vwwYZon65PzLfH4POWl
 lOpu5Endhj8Nw4j/C6i3k/XGTV9a54FiN+NH+MxsmUn6OYgsxO
 p9Izt7Nkz3ivCM4dXU5Oqm10cQ8hIYFoLCxo0IYnVNUz1OXsH+
 FOmho50y2GVig8Dc4j1aMzJpjqhcNVKXLF52yGVmak5vWQ5Sx/
 pTpQu
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert all uses of devm_request_and_ioremap() to the newly introduced
devm_ioremap_resource() which provides more consistent error handling.

devm_ioremap_resource() provides its own error messages so all explicit
error messages can be removed from the failure code paths.

Signed-off-by: Thierry Reding <thierry.reding@avionic-design.de>
Cc: Wolfram Sang <w.sang@pengutronix.de>
Cc: Ben Dooks <ben-linux@fluff.org>
Cc: linux-i2c@vger.kernel.org
---
 drivers/i2c/busses/i2c-at91.c    | 6 +++---
 drivers/i2c/busses/i2c-imx.c     | 6 +++---
 drivers/i2c/busses/i2c-ocores.c  | 7 ++++---
 drivers/i2c/busses/i2c-omap.c    | 8 +++-----
 drivers/i2c/busses/i2c-rcar.c    | 8 +++-----
 drivers/i2c/busses/i2c-s3c2410.c | 7 +++----
 drivers/i2c/busses/i2c-sirf.c    | 7 +++----
 drivers/i2c/busses/i2c-stu300.c  | 6 +++---
 drivers/i2c/busses/i2c-tegra.c   | 8 +++-----
 drivers/i2c/busses/i2c-xlr.c     | 9 ++++-----
 10 files changed, 32 insertions(+), 40 deletions(-)

diff --git a/drivers/i2c/busses/i2c-at91.c b/drivers/i2c/busses/i2c-at91.c
index 2bfc04d..ebc2241 100644
--- a/drivers/i2c/busses/i2c-at91.c
+++ b/drivers/i2c/busses/i2c-at91.c
@@ -723,9 +723,9 @@ static int at91_twi_probe(struct platform_device *pdev)
 	if (!dev->pdata)
 		return -ENODEV;
 
-	dev->base = devm_request_and_ioremap(&pdev->dev, mem);
-	if (!dev->base)
-		return -EBUSY;
+	dev->base = devm_ioremap_resource(&pdev->dev, mem);
+	if (IS_ERR(dev->base))
+		return PTR_ERR(dev->base);
 
 	dev->irq = platform_get_irq(pdev, 0);
 	if (dev->irq < 0)
diff --git a/drivers/i2c/busses/i2c-imx.c b/drivers/i2c/busses/i2c-imx.c
index b973474..a71ece6 100644
--- a/drivers/i2c/busses/i2c-imx.c
+++ b/drivers/i2c/busses/i2c-imx.c
@@ -511,9 +511,9 @@ static int __init i2c_imx_probe(struct platform_device *pdev)
 		return -ENOENT;
 	}
 
-	base = devm_request_and_ioremap(&pdev->dev, res);
-	if (!base)
-		return -EBUSY;
+	base = devm_ioremap_resource(&pdev->dev, res);
+	if (IS_ERR(base))
+		return PTR_ERR(base);
 
 	i2c_imx = devm_kzalloc(&pdev->dev, sizeof(struct imx_i2c_struct),
 				GFP_KERNEL);
diff --git a/drivers/i2c/busses/i2c-ocores.c b/drivers/i2c/busses/i2c-ocores.c
index a873d0a..a337d08 100644
--- a/drivers/i2c/busses/i2c-ocores.c
+++ b/drivers/i2c/busses/i2c-ocores.c
@@ -12,6 +12,7 @@
  * kind, whether express or implied.
  */
 
+#include <linux/err.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/init.h>
@@ -364,9 +365,9 @@ static int ocores_i2c_probe(struct platform_device *pdev)
 	if (!i2c)
 		return -ENOMEM;
 
-	i2c->base = devm_request_and_ioremap(&pdev->dev, res);
-	if (!i2c->base)
-		return -EADDRNOTAVAIL;
+	i2c->base = devm_ioremap_resource(&pdev->dev, res);
+	if (IS_ERR(i2c->base))
+		return PTR_ERR(i2c->base);
 
 	pdata = pdev->dev.platform_data;
 	if (pdata) {
diff --git a/drivers/i2c/busses/i2c-omap.c b/drivers/i2c/busses/i2c-omap.c
index 20d41bf..a9bf4ca 100644
--- a/drivers/i2c/busses/i2c-omap.c
+++ b/drivers/i2c/busses/i2c-omap.c
@@ -1103,11 +1103,9 @@ omap_i2c_probe(struct platform_device *pdev)
 		return -ENOMEM;
 	}
 
-	dev->base = devm_request_and_ioremap(&pdev->dev, mem);
-	if (!dev->base) {
-		dev_err(&pdev->dev, "I2C region already claimed\n");
-		return -ENOMEM;
-	}
+	dev->base = devm_ioremap_resource(&pdev->dev, mem);
+	if (IS_ERR(dev->base))
+		return PTR_ERR(dev->base);
 
 	match = of_match_device(of_match_ptr(omap_i2c_of_match), &pdev->dev);
 	if (match) {
diff --git a/drivers/i2c/busses/i2c-rcar.c b/drivers/i2c/busses/i2c-rcar.c
index 9bd4d73..4ba4a95 100644
--- a/drivers/i2c/busses/i2c-rcar.c
+++ b/drivers/i2c/busses/i2c-rcar.c
@@ -642,11 +642,9 @@ static int rcar_i2c_probe(struct platform_device *pdev)
 	if (ret < 0)
 		return ret;
 
-	priv->io = devm_request_and_ioremap(dev, res);
-	if (!priv->io) {
-		dev_err(dev, "cannot ioremap\n");
-		return -ENODEV;
-	}
+	priv->io = devm_ioremap_resource(dev, res);
+	if (IS_ERR(priv->io))
+		return PTR_ERR(priv->io);
 
 	priv->irq = platform_get_irq(pdev, 0);
 	init_waitqueue_head(&priv->wait);
diff --git a/drivers/i2c/busses/i2c-s3c2410.c b/drivers/i2c/busses/i2c-s3c2410.c
index a290d08..c807a6d 100644
--- a/drivers/i2c/busses/i2c-s3c2410.c
+++ b/drivers/i2c/busses/i2c-s3c2410.c
@@ -1042,11 +1042,10 @@ static int s3c24xx_i2c_probe(struct platform_device *pdev)
 		goto err_clk;
 	}
 
-	i2c->regs = devm_request_and_ioremap(&pdev->dev, res);
+	i2c->regs = devm_ioremap_resource(&pdev->dev, res);
 
-	if (i2c->regs == NULL) {
-		dev_err(&pdev->dev, "cannot map IO\n");
-		ret = -ENXIO;
+	if (IS_ERR(i2c->regs)) {
+		ret = PTR_ERR(i2c->regs);
 		goto err_clk;
 	}
 
diff --git a/drivers/i2c/busses/i2c-sirf.c b/drivers/i2c/busses/i2c-sirf.c
index 3f1818b..183cf05 100644
--- a/drivers/i2c/busses/i2c-sirf.c
+++ b/drivers/i2c/busses/i2c-sirf.c
@@ -308,10 +308,9 @@ static int i2c_sirfsoc_probe(struct platform_device *pdev)
 		goto out;
 	}
 
-	siic->base = devm_request_and_ioremap(&pdev->dev, mem_res);
-	if (siic->base == NULL) {
-		dev_err(&pdev->dev, "IO remap failed!\n");
-		err = -ENOMEM;
+	siic->base = devm_ioremap_resource(&pdev->dev, mem_res);
+	if (IS_ERR(siic->base)) {
+		err = PTR_ERR(siic->base);
 		goto out;
 	}
 
diff --git a/drivers/i2c/busses/i2c-stu300.c b/drivers/i2c/busses/i2c-stu300.c
index 580a0c0..60195b5 100644
--- a/drivers/i2c/busses/i2c-stu300.c
+++ b/drivers/i2c/busses/i2c-stu300.c
@@ -888,11 +888,11 @@ stu300_probe(struct platform_device *pdev)
 	if (!res)
 		return -ENOENT;
 
-	dev->virtbase = devm_request_and_ioremap(&pdev->dev, res);
+	dev->virtbase = devm_ioremap_resource(&pdev->dev, res);
 	dev_dbg(&pdev->dev, "initialize bus device I2C%d on virtual "
 		"base %p\n", bus_nr, dev->virtbase);
-	if (!dev->virtbase)
-		return -ENOMEM;
+	if (IS_ERR(dev->virtbase))
+		return PTR_ERR(dev->virtbase);
 
 	dev->irq = platform_get_irq(pdev, 0);
 	ret = devm_request_irq(&pdev->dev, dev->irq, stu300_irh, 0, NAME, dev);
diff --git a/drivers/i2c/busses/i2c-tegra.c b/drivers/i2c/busses/i2c-tegra.c
index 7b38877..1fb3009 100644
--- a/drivers/i2c/busses/i2c-tegra.c
+++ b/drivers/i2c/busses/i2c-tegra.c
@@ -669,11 +669,9 @@ static int tegra_i2c_probe(struct platform_device *pdev)
 		return -EINVAL;
 	}
 
-	base = devm_request_and_ioremap(&pdev->dev, res);
-	if (!base) {
-		dev_err(&pdev->dev, "Cannot request/ioremap I2C registers\n");
-		return -EADDRNOTAVAIL;
-	}
+	base = devm_ioremap_resource(&pdev->dev, res);
+	if (IS_ERR(base))
+		return PTR_ERR(base);
 
 	res = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
 	if (!res) {
diff --git a/drivers/i2c/busses/i2c-xlr.c b/drivers/i2c/busses/i2c-xlr.c
index a005265..93f029e 100644
--- a/drivers/i2c/busses/i2c-xlr.c
+++ b/drivers/i2c/busses/i2c-xlr.c
@@ -7,6 +7,7 @@
  * warranty of any kind, whether express or implied.
  */
 
+#include <linux/err.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/slab.h>
@@ -225,11 +226,9 @@ static int xlr_i2c_probe(struct platform_device *pdev)
 		return -ENOMEM;
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	priv->iobase = devm_request_and_ioremap(&pdev->dev, res);
-	if (!priv->iobase) {
-		dev_err(&pdev->dev, "devm_request_and_ioremap failed\n");
-		return -EBUSY;
-	}
+	priv->iobase = devm_ioremap_resource(&pdev->dev, res);
+	if (IS_ERR(priv->iobase))
+		return PTR_ERR(priv->iobase);
 
 	priv->adap.dev.parent = &pdev->dev;
 	priv->adap.owner	= THIS_MODULE;
-- 
1.8.1.1

