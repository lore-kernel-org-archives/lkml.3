Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753361Ab3AUKMf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 05:12:35 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:51867 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753107Ab3AUKKT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 05:10:19 -0500
From: Thierry Reding <thierry.reding@avionic-design.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>, Wolfram Sang <w.sang@pengutronix.de>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, alsa-devel@alsa-project.org
Subject: [PATCH 33/33] ASoC: Convert to devm_ioremap_resource()
Date: Mon, 21 Jan 2013 11:09:26 +0100
Message-Id: <1358762966-20791-34-git-send-email-thierry.reding@avionic-design.de>
X-Mailer: git-send-email 1.8.1.1
In-Reply-To: <1358762966-20791-1-git-send-email-thierry.reding@avionic-design.de>
References: <1358762966-20791-1-git-send-email-thierry.reding@avionic-design.de>
X-Provags-ID: V02:K0:q4f8IYfKK2jxBdor6IsoqMiaWlxyCZowZ8rkLRpuy69
 weZgYcOH13iI9OqM6MOcfqhF0XfUxORsxX+0/uIqGRd/rd1kdO
 ezySQTB3tCRsbfshpFoAYzDsMV14rtZET9QR8/8HDKBWXSieas
 fnH1urXJFJ332g2tNEf9lBhea3XthOkY5ZE38YFR53HGyXWTwe
 WYiIRqcLVBv+tstn6VbM5xvXbeKbil3XPVNMMbgY2+VMBxdCge
 cnP+RZIbA/sVooL1B2RV3zeLNkG71wKQtlAR3aaTDgjHmIuVnY
 nQSYdWEB/tAv1EKH5yNOWNzanxnHhBCGMdp2S4McSSNXXSy08y
 Ky0h+hb7Quoywx43nYRjraLKcjIyCKV/YKSInZmo2rS76kPMx8
 +UfvrQXqRhBz9l9EK5AisffXJjPUahbjTsIVwqYfm0OByFCD5W
 ZIAlP
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert all uses of devm_request_and_ioremap() to the newly introduced
devm_ioremap_resource() which provides more consistent error handling.

devm_ioremap_resource() provides its own error messages so all explicit
error messages can be removed from the failure code paths.

Signed-off-by: Thierry Reding <thierry.reding@avionic-design.de>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Liam Girdwood <lrg@ti.com>
Cc: alsa-devel@alsa-project.org
---
 sound/soc/cirrus/ep93xx-ac97.c    | 7 ++++---
 sound/soc/cirrus/ep93xx-i2s.c     | 6 +++---
 sound/soc/codecs/jz4740.c         | 6 +++---
 sound/soc/fsl/imx-audmux.c        | 6 +++---
 sound/soc/fsl/imx-ssi.c           | 7 +++----
 sound/soc/kirkwood/kirkwood-i2s.c | 8 +++-----
 sound/soc/mxs/mxs-saif.c          | 8 +++-----
 sound/soc/pxa/mmp-sspa.c          | 6 +++---
 8 files changed, 25 insertions(+), 29 deletions(-)

diff --git a/sound/soc/cirrus/ep93xx-ac97.c b/sound/soc/cirrus/ep93xx-ac97.c
index f3f50e6..1738d28 100644
--- a/sound/soc/cirrus/ep93xx-ac97.c
+++ b/sound/soc/cirrus/ep93xx-ac97.c
@@ -11,6 +11,7 @@
  */
 
 #include <linux/delay.h>
+#include <linux/err.h>
 #include <linux/io.h>
 #include <linux/init.h>
 #include <linux/module.h>
@@ -367,9 +368,9 @@ static int ep93xx_ac97_probe(struct platform_device *pdev)
 	if (!res)
 		return -ENODEV;
 
-	info->regs = devm_request_and_ioremap(&pdev->dev, res);
-	if (!info->regs)
-		return -ENXIO;
+	info->regs = devm_ioremap_resource(&pdev->dev, res);
+	if (IS_ERR(info->regs))
+		return PTR_ERR(info->regs);
 
 	irq = platform_get_irq(pdev, 0);
 	if (!irq)
diff --git a/sound/soc/cirrus/ep93xx-i2s.c b/sound/soc/cirrus/ep93xx-i2s.c
index 3365d4e..323ed69 100644
--- a/sound/soc/cirrus/ep93xx-i2s.c
+++ b/sound/soc/cirrus/ep93xx-i2s.c
@@ -380,9 +380,9 @@ static int ep93xx_i2s_probe(struct platform_device *pdev)
 	if (!res)
 		return -ENODEV;
 
-	info->regs = devm_request_and_ioremap(&pdev->dev, res);
-	if (!info->regs)
-		return -ENXIO;
+	info->regs = devm_ioremap_resource(&pdev->dev, res);
+	if (IS_ERR(info->regs))
+		return PTR_ERR(info->regs);
 
 	info->mclk = clk_get(&pdev->dev, "mclk");
 	if (IS_ERR(info->mclk)) {
diff --git a/sound/soc/codecs/jz4740.c b/sound/soc/codecs/jz4740.c
index d991529..5f607b3 100644
--- a/sound/soc/codecs/jz4740.c
+++ b/sound/soc/codecs/jz4740.c
@@ -361,9 +361,9 @@ static int jz4740_codec_probe(struct platform_device *pdev)
 		return -ENOMEM;
 
 	mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	base = devm_request_and_ioremap(&pdev->dev, mem);
-	if (!base)
-		return -EBUSY;
+	base = devm_ioremap_resource(&pdev->dev, mem);
+	if (IS_ERR(base))
+		return PTR_ERR(base);
 
 	jz4740_codec->regmap = devm_regmap_init_mmio(&pdev->dev, base,
 					    &jz4740_codec_regmap_config);
diff --git a/sound/soc/fsl/imx-audmux.c b/sound/soc/fsl/imx-audmux.c
index 251f4d9..c21ac9c 100644
--- a/sound/soc/fsl/imx-audmux.c
+++ b/sound/soc/fsl/imx-audmux.c
@@ -252,9 +252,9 @@ static int imx_audmux_probe(struct platform_device *pdev)
 			of_match_device(imx_audmux_dt_ids, &pdev->dev);
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	audmux_base = devm_request_and_ioremap(&pdev->dev, res);
-	if (!audmux_base)
-		return -EADDRNOTAVAIL;
+	audmux_base = devm_ioremap_resource(&pdev->dev, res);
+	if (IS_ERR(audmux_base))
+		return PTR_ERR(audmux_base);
 
 	pinctrl = devm_pinctrl_get_select_default(&pdev->dev);
 	if (IS_ERR(pinctrl)) {
diff --git a/sound/soc/fsl/imx-ssi.c b/sound/soc/fsl/imx-ssi.c
index 3b48042..55464a5 100644
--- a/sound/soc/fsl/imx-ssi.c
+++ b/sound/soc/fsl/imx-ssi.c
@@ -550,10 +550,9 @@ static int imx_ssi_probe(struct platform_device *pdev)
 		goto failed_get_resource;
 	}
 
-	ssi->base = devm_request_and_ioremap(&pdev->dev, res);
-	if (!ssi->base) {
-		dev_err(&pdev->dev, "ioremap failed\n");
-		ret = -ENODEV;
+	ssi->base = devm_ioremap_resource(&pdev->dev, res);
+	if (IS_ERR(ssi->base)) {
+		ret = PTR_ERR(ssi->base);
 		goto failed_register;
 	}
 
diff --git a/sound/soc/kirkwood/kirkwood-i2s.c b/sound/soc/kirkwood/kirkwood-i2s.c
index 282d8b1..c74c890 100644
--- a/sound/soc/kirkwood/kirkwood-i2s.c
+++ b/sound/soc/kirkwood/kirkwood-i2s.c
@@ -472,11 +472,9 @@ static int kirkwood_i2s_dev_probe(struct platform_device *pdev)
 		return -ENXIO;
 	}
 
-	priv->io = devm_request_and_ioremap(&pdev->dev, mem);
-	if (!priv->io) {
-		dev_err(&pdev->dev, "devm_request_and_ioremap failed\n");
-		return -ENOMEM;
-	}
+	priv->io = devm_ioremap_resource(&pdev->dev, mem);
+	if (IS_ERR(priv->io))
+		return PTR_ERR(priv->io);
 
 	priv->irq = platform_get_irq(pdev, 0);
 	if (priv->irq <= 0) {
diff --git a/sound/soc/mxs/mxs-saif.c b/sound/soc/mxs/mxs-saif.c
index 365d9d2..b327709 100644
--- a/sound/soc/mxs/mxs-saif.c
+++ b/sound/soc/mxs/mxs-saif.c
@@ -724,11 +724,9 @@ static int mxs_saif_probe(struct platform_device *pdev)
 
 	iores = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 
-	saif->base = devm_request_and_ioremap(&pdev->dev, iores);
-	if (!saif->base) {
-		dev_err(&pdev->dev, "ioremap failed\n");
-		return -ENODEV;
-	}
+	saif->base = devm_ioremap_resource(&pdev->dev, iores);
+	if (IS_ERR(saif->base))
+		return PTR_ERR(saif->base);
 
 	dmares = platform_get_resource(pdev, IORESOURCE_DMA, 0);
 	if (!dmares) {
diff --git a/sound/soc/pxa/mmp-sspa.c b/sound/soc/pxa/mmp-sspa.c
index 41c3a09..9140c4a 100644
--- a/sound/soc/pxa/mmp-sspa.c
+++ b/sound/soc/pxa/mmp-sspa.c
@@ -429,9 +429,9 @@ static int asoc_mmp_sspa_probe(struct platform_device *pdev)
 	if (res == NULL)
 		return -ENOMEM;
 
-	priv->sspa->mmio_base = devm_request_and_ioremap(&pdev->dev, res);
-	if (priv->sspa->mmio_base == NULL)
-		return -ENODEV;
+	priv->sspa->mmio_base = devm_ioremap_resource(&pdev->dev, res);
+	if (IS_ERR(priv->sspa->mmio_base))
+		return PTR_ERR(priv->sspa->mmio_base);
 
 	priv->sspa->clk = devm_clk_get(&pdev->dev, NULL);
 	if (IS_ERR(priv->sspa->clk))
-- 
1.8.1.1

