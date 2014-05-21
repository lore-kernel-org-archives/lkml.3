Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751782AbaEUDYm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 23:24:42 -0400
Received: from mail-pd0-f178.google.com ([209.85.192.178]:50082 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751067AbaEUDYk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 23:24:40 -0400
From: Tushar Behera <tushar.behera@linaro.org>
To: linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org,
        linux-samsung-soc@vger.kernel.org
Cc: tiwai@suse.de, perex@perex.cz, broonie@kernel.org, lgirdwood@gmail.com,
        sbkim73@samsung.com, kgene.kim@samsung.com
Subject: [PATCH 2/4] ASoC: samsung: Use devm_snd_soc_register_platform
Date: Wed, 21 May 2014 08:52:18 +0530
Message-Id: <1400642540-24375-3-git-send-email-tushar.behera@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1400642540-24375-1-git-send-email-tushar.behera@linaro.org>
References: <1400642540-24375-1-git-send-email-tushar.behera@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replaced snd_soc_register_platform with devm_snd_soc_register_platform
in samsung_asoc_dma_platform_register(). This makes the function
samsung_asoc_dma_platform_unregister() redundant. This is removed and
all its users are updated.

Signed-off-by: Tushar Behera <tushar.behera@linaro.org>
---
 sound/soc/samsung/ac97.c        |    1 -
 sound/soc/samsung/dma.c         |    8 +-------
 sound/soc/samsung/dma.h         |    1 -
 sound/soc/samsung/dmaengine.c   |   13 ++++---------
 sound/soc/samsung/i2s.c         |    2 --
 sound/soc/samsung/idma.c        |    9 +--------
 sound/soc/samsung/pcm.c         |    1 -
 sound/soc/samsung/s3c2412-i2s.c |    1 -
 sound/soc/samsung/s3c24xx-i2s.c |    1 -
 sound/soc/samsung/spdif.c       |    1 -
 10 files changed, 6 insertions(+), 32 deletions(-)

diff --git a/sound/soc/samsung/ac97.c b/sound/soc/samsung/ac97.c
index 76b072b..fbce03b 100644
--- a/sound/soc/samsung/ac97.c
+++ b/sound/soc/samsung/ac97.c
@@ -461,7 +461,6 @@ static int s3c_ac97_remove(struct platform_device *pdev)
 {
 	struct resource *irq_res;
 
-	samsung_asoc_dma_platform_unregister(&pdev->dev);
 	snd_soc_unregister_component(&pdev->dev);
 
 	irq_res = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
diff --git a/sound/soc/samsung/dma.c b/sound/soc/samsung/dma.c
index dc09b71..d9dc7bc 100644
--- a/sound/soc/samsung/dma.c
+++ b/sound/soc/samsung/dma.c
@@ -445,16 +445,10 @@ EXPORT_SYMBOL_GPL(samsung_asoc_init_dma_data);
 
 int samsung_asoc_dma_platform_register(struct device *dev)
 {
-	return snd_soc_register_platform(dev, &samsung_asoc_platform);
+	return devm_snd_soc_register_platform(dev, &samsung_asoc_platform);
 }
 EXPORT_SYMBOL_GPL(samsung_asoc_dma_platform_register);
 
-void samsung_asoc_dma_platform_unregister(struct device *dev)
-{
-	snd_soc_unregister_platform(dev);
-}
-EXPORT_SYMBOL_GPL(samsung_asoc_dma_platform_unregister);
-
 MODULE_AUTHOR("Ben Dooks, <ben@simtec.co.uk>");
 MODULE_DESCRIPTION("Samsung ASoC DMA Driver");
 MODULE_LICENSE("GPL");
diff --git a/sound/soc/samsung/dma.h b/sound/soc/samsung/dma.h
index ad7c0f0..070ab0f 100644
--- a/sound/soc/samsung/dma.h
+++ b/sound/soc/samsung/dma.h
@@ -33,6 +33,5 @@ void samsung_asoc_init_dma_data(struct snd_soc_dai *dai,
 				struct s3c_dma_params *playback,
 				struct s3c_dma_params *capture);
 int samsung_asoc_dma_platform_register(struct device *dev);
-void samsung_asoc_dma_platform_unregister(struct device *dev);
 
 #endif
diff --git a/sound/soc/samsung/dmaengine.c b/sound/soc/samsung/dmaengine.c
index 750ce58..a0e4e79 100644
--- a/sound/soc/samsung/dmaengine.c
+++ b/sound/soc/samsung/dmaengine.c
@@ -66,18 +66,13 @@ EXPORT_SYMBOL_GPL(samsung_asoc_init_dma_data);
 
 int samsung_asoc_dma_platform_register(struct device *dev)
 {
-	return snd_dmaengine_pcm_register(dev, &samsung_dmaengine_pcm_config,
-					  SND_DMAENGINE_PCM_FLAG_CUSTOM_CHANNEL_NAME |
-					  SND_DMAENGINE_PCM_FLAG_COMPAT);
+	return devm_snd_dmaengine_pcm_register(dev,
+			&samsung_dmaengine_pcm_config,
+			SND_DMAENGINE_PCM_FLAG_CUSTOM_CHANNEL_NAME |
+			SND_DMAENGINE_PCM_FLAG_COMPAT);
 }
 EXPORT_SYMBOL_GPL(samsung_asoc_dma_platform_register);
 
-void samsung_asoc_dma_platform_unregister(struct device *dev)
-{
-	return snd_dmaengine_pcm_unregister(dev);
-}
-EXPORT_SYMBOL_GPL(samsung_asoc_dma_platform_unregister);
-
 MODULE_AUTHOR("Mark Brown <broonie@linaro.org>");
 MODULE_DESCRIPTION("Samsung dmaengine ASoC driver");
 MODULE_LICENSE("GPL");
diff --git a/sound/soc/samsung/i2s.c b/sound/soc/samsung/i2s.c
index 6e61db7..f6e2842 100644
--- a/sound/soc/samsung/i2s.c
+++ b/sound/soc/samsung/i2s.c
@@ -1291,8 +1291,6 @@ static int samsung_i2s_remove(struct platform_device *pdev)
 	i2s->pri_dai = NULL;
 	i2s->sec_dai = NULL;
 
-	samsung_asoc_dma_platform_unregister(&pdev->dev);
-
 	return 0;
 }
 
diff --git a/sound/soc/samsung/idma.c b/sound/soc/samsung/idma.c
index e9891b4..8cc5770 100644
--- a/sound/soc/samsung/idma.c
+++ b/sound/soc/samsung/idma.c
@@ -413,13 +413,7 @@ static int asoc_idma_platform_probe(struct platform_device *pdev)
 	if (idma_irq < 0)
 		return idma_irq;
 
-	return snd_soc_register_platform(&pdev->dev, &asoc_idma_platform);
-}
-
-static int asoc_idma_platform_remove(struct platform_device *pdev)
-{
-	snd_soc_unregister_platform(&pdev->dev);
-	return 0;
+	return devm_snd_soc_register_platform(&pdev->dev, &asoc_idma_platform);
 }
 
 static struct platform_driver asoc_idma_driver = {
@@ -429,7 +423,6 @@ static struct platform_driver asoc_idma_driver = {
 	},
 
 	.probe = asoc_idma_platform_probe,
-	.remove = asoc_idma_platform_remove,
 };
 
 module_platform_driver(asoc_idma_driver);
diff --git a/sound/soc/samsung/pcm.c b/sound/soc/samsung/pcm.c
index ab54e29..38df2a8 100644
--- a/sound/soc/samsung/pcm.c
+++ b/sound/soc/samsung/pcm.c
@@ -624,7 +624,6 @@ static int s3c_pcm_dev_remove(struct platform_device *pdev)
 	struct s3c_pcm_info *pcm = &s3c_pcm[pdev->id];
 	struct resource *mem_res;
 
-	samsung_asoc_dma_platform_unregister(&pdev->dev);
 	snd_soc_unregister_component(&pdev->dev);
 
 	pm_runtime_disable(&pdev->dev);
diff --git a/sound/soc/samsung/s3c2412-i2s.c b/sound/soc/samsung/s3c2412-i2s.c
index e9bb5d7..f42da8d 100644
--- a/sound/soc/samsung/s3c2412-i2s.c
+++ b/sound/soc/samsung/s3c2412-i2s.c
@@ -192,7 +192,6 @@ err:
 
 static int s3c2412_iis_dev_remove(struct platform_device *pdev)
 {
-	samsung_asoc_dma_platform_unregister(&pdev->dev);
 	snd_soc_unregister_component(&pdev->dev);
 	return 0;
 }
diff --git a/sound/soc/samsung/s3c24xx-i2s.c b/sound/soc/samsung/s3c24xx-i2s.c
index d7b8457..8380443 100644
--- a/sound/soc/samsung/s3c24xx-i2s.c
+++ b/sound/soc/samsung/s3c24xx-i2s.c
@@ -496,7 +496,6 @@ err:
 
 static int s3c24xx_iis_dev_remove(struct platform_device *pdev)
 {
-	samsung_asoc_dma_platform_unregister(&pdev->dev);
 	snd_soc_unregister_component(&pdev->dev);
 	return 0;
 }
diff --git a/sound/soc/samsung/spdif.c b/sound/soc/samsung/spdif.c
index cfe63b7..7d89d01 100644
--- a/sound/soc/samsung/spdif.c
+++ b/sound/soc/samsung/spdif.c
@@ -467,7 +467,6 @@ static int spdif_remove(struct platform_device *pdev)
 	struct samsung_spdif_info *spdif = &spdif_info;
 	struct resource *mem_res;
 
-	samsung_asoc_dma_platform_unregister(&pdev->dev);
 	snd_soc_unregister_component(&pdev->dev);
 
 	iounmap(spdif->regs);
-- 
1.7.9.5

