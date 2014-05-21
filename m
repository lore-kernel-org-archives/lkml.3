Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751825AbaEUDYq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 23:24:46 -0400
Received: from mail-pa0-f51.google.com ([209.85.220.51]:53338 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751630AbaEUDYo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 23:24:44 -0400
From: Tushar Behera <tushar.behera@linaro.org>
To: linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org,
        linux-samsung-soc@vger.kernel.org
Cc: tiwai@suse.de, perex@perex.cz, broonie@kernel.org, lgirdwood@gmail.com,
        sbkim73@samsung.com, kgene.kim@samsung.com
Subject: [PATCH 3/4] ASoC: samsung: Use devm_snd_soc_register_component
Date: Wed, 21 May 2014 08:52:19 +0530
Message-Id: <1400642540-24375-4-git-send-email-tushar.behera@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1400642540-24375-1-git-send-email-tushar.behera@linaro.org>
References: <1400642540-24375-1-git-send-email-tushar.behera@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replaced snd_soc_register_component with its devres equivalent,
devm_snd_soc_register_component.

Signed-off-by: Tushar Behera <tushar.behera@linaro.org>
---
 sound/soc/samsung/ac97.c        |    8 ++------
 sound/soc/samsung/goni_wm8994.c |    9 +++------
 sound/soc/samsung/pcm.c         |    8 ++------
 sound/soc/samsung/s3c-i2s-v2.c  |    2 +-
 sound/soc/samsung/s3c2412-i2s.c |   14 +-------------
 sound/soc/samsung/s3c24xx-i2s.c |   18 +++---------------
 sound/soc/samsung/spdif.c       |   10 +++-------
 7 files changed, 15 insertions(+), 54 deletions(-)

diff --git a/sound/soc/samsung/ac97.c b/sound/soc/samsung/ac97.c
index fbce03b..68d9303 100644
--- a/sound/soc/samsung/ac97.c
+++ b/sound/soc/samsung/ac97.c
@@ -433,7 +433,7 @@ static int s3c_ac97_probe(struct platform_device *pdev)
 		goto err4;
 	}
 
-	ret = snd_soc_register_component(&pdev->dev, &s3c_ac97_component,
+	ret = devm_snd_soc_register_component(&pdev->dev, &s3c_ac97_component,
 					 s3c_ac97_dai, ARRAY_SIZE(s3c_ac97_dai));
 	if (ret)
 		goto err5;
@@ -441,12 +441,10 @@ static int s3c_ac97_probe(struct platform_device *pdev)
 	ret = samsung_asoc_dma_platform_register(&pdev->dev);
 	if (ret) {
 		dev_err(&pdev->dev, "failed to get register DMA: %d\n", ret);
-		goto err6;
+		goto err5;
 	}
 
 	return 0;
-err6:
-	snd_soc_unregister_component(&pdev->dev);
 err5:
 	free_irq(irq_res->start, NULL);
 err4:
@@ -461,8 +459,6 @@ static int s3c_ac97_remove(struct platform_device *pdev)
 {
 	struct resource *irq_res;
 
-	snd_soc_unregister_component(&pdev->dev);
-
 	irq_res = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
 	if (irq_res)
 		free_irq(irq_res->start, NULL);
diff --git a/sound/soc/samsung/goni_wm8994.c b/sound/soc/samsung/goni_wm8994.c
index 415ad81..9506d76 100644
--- a/sound/soc/samsung/goni_wm8994.c
+++ b/sound/soc/samsung/goni_wm8994.c
@@ -274,8 +274,8 @@ static int __init goni_init(void)
 		return -ENOMEM;
 
 	/* register voice DAI here */
-	ret = snd_soc_register_component(&goni_snd_device->dev, &voice_component,
-					 &voice_dai, 1);
+	ret = devm_snd_soc_register_component(&goni_snd_device->dev,
+			&voice_component, &voice_dai, 1);
 	if (ret) {
 		platform_device_put(goni_snd_device);
 		return ret;
@@ -284,17 +284,14 @@ static int __init goni_init(void)
 	platform_set_drvdata(goni_snd_device, &goni);
 	ret = platform_device_add(goni_snd_device);
 
-	if (ret) {
-		snd_soc_unregister_component(&goni_snd_device->dev);
+	if (ret)
 		platform_device_put(goni_snd_device);
-	}
 
 	return ret;
 }
 
 static void __exit goni_exit(void)
 {
-	snd_soc_unregister_component(&goni_snd_device->dev);
 	platform_device_unregister(goni_snd_device);
 }
 
diff --git a/sound/soc/samsung/pcm.c b/sound/soc/samsung/pcm.c
index 38df2a8..90fcd52 100644
--- a/sound/soc/samsung/pcm.c
+++ b/sound/soc/samsung/pcm.c
@@ -588,7 +588,7 @@ static int s3c_pcm_dev_probe(struct platform_device *pdev)
 
 	pm_runtime_enable(&pdev->dev);
 
-	ret = snd_soc_register_component(&pdev->dev, &s3c_pcm_component,
+	ret = devm_snd_soc_register_component(&pdev->dev, &s3c_pcm_component,
 					 &s3c_pcm_dai[pdev->id], 1);
 	if (ret != 0) {
 		dev_err(&pdev->dev, "failed to get register DAI: %d\n", ret);
@@ -598,13 +598,11 @@ static int s3c_pcm_dev_probe(struct platform_device *pdev)
 	ret = samsung_asoc_dma_platform_register(&pdev->dev);
 	if (ret) {
 		dev_err(&pdev->dev, "failed to get register DMA: %d\n", ret);
-		goto err6;
+		goto err5;
 	}
 
 	return 0;
 
-err6:
-	snd_soc_unregister_component(&pdev->dev);
 err5:
 	clk_disable_unprepare(pcm->pclk);
 	clk_put(pcm->pclk);
@@ -624,8 +622,6 @@ static int s3c_pcm_dev_remove(struct platform_device *pdev)
 	struct s3c_pcm_info *pcm = &s3c_pcm[pdev->id];
 	struct resource *mem_res;
 
-	snd_soc_unregister_component(&pdev->dev);
-
 	pm_runtime_disable(&pdev->dev);
 
 	iounmap(pcm->regs);
diff --git a/sound/soc/samsung/s3c-i2s-v2.c b/sound/soc/samsung/s3c-i2s-v2.c
index 79e7efb..77a2ae5 100644
--- a/sound/soc/samsung/s3c-i2s-v2.c
+++ b/sound/soc/samsung/s3c-i2s-v2.c
@@ -745,7 +745,7 @@ int s3c_i2sv2_register_component(struct device *dev, int id,
 	dai_drv->suspend = s3c2412_i2s_suspend;
 	dai_drv->resume = s3c2412_i2s_resume;
 
-	return snd_soc_register_component(dev, cmp_drv, dai_drv, 1);
+	return devm_snd_soc_register_component(dev, cmp_drv, dai_drv, 1);
 }
 EXPORT_SYMBOL_GPL(s3c_i2sv2_register_component);
 
diff --git a/sound/soc/samsung/s3c2412-i2s.c b/sound/soc/samsung/s3c2412-i2s.c
index f42da8d..843f315 100644
--- a/sound/soc/samsung/s3c2412-i2s.c
+++ b/sound/soc/samsung/s3c2412-i2s.c
@@ -179,26 +179,14 @@ static int s3c2412_iis_dev_probe(struct platform_device *pdev)
 	}
 
 	ret = samsung_asoc_dma_platform_register(&pdev->dev);
-	if (ret) {
+	if (ret)
 		pr_err("failed to register the DMA: %d\n", ret);
-		goto err;
-	}
 
-	return 0;
-err:
-	snd_soc_unregister_component(&pdev->dev);
 	return ret;
 }
 
-static int s3c2412_iis_dev_remove(struct platform_device *pdev)
-{
-	snd_soc_unregister_component(&pdev->dev);
-	return 0;
-}
-
 static struct platform_driver s3c2412_iis_driver = {
 	.probe  = s3c2412_iis_dev_probe,
-	.remove = s3c2412_iis_dev_remove,
 	.driver = {
 		.name = "s3c2412-iis",
 		.owner = THIS_MODULE,
diff --git a/sound/soc/samsung/s3c24xx-i2s.c b/sound/soc/samsung/s3c24xx-i2s.c
index 8380443..4a6d206 100644
--- a/sound/soc/samsung/s3c24xx-i2s.c
+++ b/sound/soc/samsung/s3c24xx-i2s.c
@@ -475,34 +475,22 @@ static int s3c24xx_iis_dev_probe(struct platform_device *pdev)
 {
 	int ret = 0;
 
-	ret = snd_soc_register_component(&pdev->dev, &s3c24xx_i2s_component,
-					 &s3c24xx_i2s_dai, 1);
+	ret = devm_snd_soc_register_component(&pdev->dev,
+			&s3c24xx_i2s_component, &s3c24xx_i2s_dai, 1);
 	if (ret) {
 		pr_err("failed to register the dai\n");
 		return ret;
 	}
 
 	ret = samsung_asoc_dma_platform_register(&pdev->dev);
-	if (ret) {
+	if (ret)
 		pr_err("failed to register the dma: %d\n", ret);
-		goto err;
-	}
 
-	return 0;
-err:
-	snd_soc_unregister_component(&pdev->dev);
 	return ret;
 }
 
-static int s3c24xx_iis_dev_remove(struct platform_device *pdev)
-{
-	snd_soc_unregister_component(&pdev->dev);
-	return 0;
-}
-
 static struct platform_driver s3c24xx_iis_driver = {
 	.probe  = s3c24xx_iis_dev_probe,
-	.remove = s3c24xx_iis_dev_remove,
 	.driver = {
 		.name = "s3c24xx-iis",
 		.owner = THIS_MODULE,
diff --git a/sound/soc/samsung/spdif.c b/sound/soc/samsung/spdif.c
index 7d89d01..e93a93e 100644
--- a/sound/soc/samsung/spdif.c
+++ b/sound/soc/samsung/spdif.c
@@ -427,8 +427,8 @@ static int spdif_probe(struct platform_device *pdev)
 
 	dev_set_drvdata(&pdev->dev, spdif);
 
-	ret = snd_soc_register_component(&pdev->dev, &samsung_spdif_component,
-					 &samsung_spdif_dai, 1);
+	ret = devm_snd_soc_register_component(&pdev->dev,
+			&samsung_spdif_component, &samsung_spdif_dai, 1);
 	if (ret != 0) {
 		dev_err(&pdev->dev, "fail to register dai\n");
 		goto err4;
@@ -444,12 +444,10 @@ static int spdif_probe(struct platform_device *pdev)
 	ret = samsung_asoc_dma_platform_register(&pdev->dev);
 	if (ret) {
 		dev_err(&pdev->dev, "failed to register DMA: %d\n", ret);
-		goto err5;
+		goto err4;
 	}
 
 	return 0;
-err5:
-	snd_soc_unregister_component(&pdev->dev);
 err4:
 	iounmap(spdif->regs);
 err3:
@@ -467,8 +465,6 @@ static int spdif_remove(struct platform_device *pdev)
 	struct samsung_spdif_info *spdif = &spdif_info;
 	struct resource *mem_res;
 
-	snd_soc_unregister_component(&pdev->dev);
-
 	iounmap(spdif->regs);
 
 	mem_res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-- 
1.7.9.5

