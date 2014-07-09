Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756042AbaGIVVX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 17:21:23 -0400
Received: from mail-pd0-f169.google.com ([209.85.192.169]:60681 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755850AbaGIVVU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 17:21:20 -0400
Date: Thu, 10 Jul 2014 02:51:12 +0530
From: Himangi Saraogi <himangi774@gmail.com>
To: Peter Ujfalusi <peter.ujfalusi@ti.com>,
        Jarkko Nikula <jarkko.nikula@bitmer.com>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        linux-omap@vger.kernel.org, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Cc: julia.lawall@lip6.fr
Subject: [PATCH] ASoC: omap-dmic: use managed interfaces
Message-ID: <20140709212112.GA11848@himangi-Dell>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch moves data allocated using clk_put and
snd_soc_register_component to the corresponding managed interfaces and
does away with the functions to free memory in the probe and remove
functions. The probe function is no longer required and is completely
removed.

Signed-off-by: Himangi Saraogi <himangi774@gmail.com>
Acked-by: Julia Lawall <julia.lawall@lip6.fr>
---
 sound/soc/omap/omap-dmic.c | 35 ++++++++---------------------------
 1 file changed, 8 insertions(+), 27 deletions(-)

diff --git a/sound/soc/omap/omap-dmic.c b/sound/soc/omap/omap-dmic.c
index 6925d71..b315b27 100644
--- a/sound/soc/omap/omap-dmic.c
+++ b/sound/soc/omap/omap-dmic.c
@@ -466,7 +466,7 @@ static int asoc_dmic_probe(struct platform_device *pdev)
 
 	mutex_init(&dmic->mutex);
 
-	dmic->fclk = clk_get(dmic->dev, "fck");
+	dmic->fclk = devm_clk_get(dmic->dev, "fck");
 	if (IS_ERR(dmic->fclk)) {
 		dev_err(dmic->dev, "cant get fck\n");
 		return -ENODEV;
@@ -475,8 +475,7 @@ static int asoc_dmic_probe(struct platform_device *pdev)
 	res = platform_get_resource_byname(pdev, IORESOURCE_MEM, "dma");
 	if (!res) {
 		dev_err(dmic->dev, "invalid dma memory resource\n");
-		ret = -ENODEV;
-		goto err_put_clk;
+		return -ENODEV;
 	}
 	dmic->dma_data.addr = res->start + OMAP_DMIC_DATA_REG;
 
@@ -484,34 +483,17 @@ static int asoc_dmic_probe(struct platform_device *pdev)
 
 	res = platform_get_resource_byname(pdev, IORESOURCE_MEM, "mpu");
 	dmic->io_base = devm_ioremap_resource(&pdev->dev, res);
-	if (IS_ERR(dmic->io_base)) {
-		ret = PTR_ERR(dmic->io_base);
-		goto err_put_clk;
-	}
-
+	if (IS_ERR(dmic->io_base))
+		return PTR_ERR(dmic->io_base);
 
-	ret = snd_soc_register_component(&pdev->dev, &omap_dmic_component,
-					 &omap_dmic_dai, 1);
+	ret = devm_snd_soc_register_component(&pdev->dev, &omap_dmic_component,
+					      &omap_dmic_dai, 1);
 	if (ret)
-		goto err_put_clk;
+		return ret;
 
 	ret = omap_pcm_platform_register(&pdev->dev);
 	if (ret)
-		goto err_put_clk;
-
-	return 0;
-
-err_put_clk:
-	clk_put(dmic->fclk);
-	return ret;
-}
-
-static int asoc_dmic_remove(struct platform_device *pdev)
-{
-	struct omap_dmic *dmic = platform_get_drvdata(pdev);
-
-	snd_soc_unregister_component(&pdev->dev);
-	clk_put(dmic->fclk);
+		return ret;
 
 	return 0;
 }
@@ -529,7 +511,6 @@ static struct platform_driver asoc_dmic_driver = {
 		.of_match_table = omap_dmic_of_match,
 	},
 	.probe = asoc_dmic_probe,
-	.remove = asoc_dmic_remove,
 };
 
 module_platform_driver(asoc_dmic_driver);
-- 
1.9.1

