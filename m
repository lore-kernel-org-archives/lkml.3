Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755225Ab3GYJO0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 05:14:26 -0400
Received: from smtp6-g21.free.fr ([212.27.42.6]:48375 "EHLO smtp6-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753142Ab3GYJOV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 05:14:21 -0400
Date: Thu, 25 Jul 2013 11:14:28 +0200
From: Jean-Francois Moine <moinejf@free.fr>
To: Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        Rob Herring <rob.herring@calxeda.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: [PATCH 3/4] ASoc: kirkwood: merge kirkwood-i2c and kirkwood-dma
Message-ID: <20130725111428.419ee278@armhf>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; arm-unknown-linux-gnueabihf)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To avoid the declaration of a 'kirkwood-pcm-audio' device in the DT,
this patch merges the kirkwood-i2c and kirkwood-dma drivers into one
module.

Signed-off-by: Jean-Francois Moine <moinejf@free.fr>
---
 arch/arm/mach-kirkwood/common.c      |  6 ------
 sound/soc/kirkwood/Kconfig           |  5 -----
 sound/soc/kirkwood/Makefile          |  4 +---
 sound/soc/kirkwood/kirkwood-dma.c    | 30 +-----------------------------
 sound/soc/kirkwood/kirkwood-i2s.c    |  5 +++++
 sound/soc/kirkwood/kirkwood-openrd.c |  2 +-
 sound/soc/kirkwood/kirkwood-t5325.c  |  2 +-
 sound/soc/kirkwood/kirkwood.h        |  1 +
 8 files changed, 10 insertions(+), 45 deletions(-)

diff --git a/arch/arm/mach-kirkwood/common.c b/arch/arm/mach-kirkwood/common.c
index e9238b5..fd02f1b 100644
--- a/arch/arm/mach-kirkwood/common.c
+++ b/arch/arm/mach-kirkwood/common.c
@@ -587,15 +587,9 @@ static struct platform_device kirkwood_i2s_device = {
 	},
 };
 
-static struct platform_device kirkwood_pcm_device = {
-	.name		= "kirkwood-pcm-audio",
-	.id		= -1,
-};
-
 void __init kirkwood_audio_init(void)
 {
 	platform_device_register(&kirkwood_i2s_device);
-	platform_device_register(&kirkwood_pcm_device);
 }
 
 /*****************************************************************************
diff --git a/sound/soc/kirkwood/Kconfig b/sound/soc/kirkwood/Kconfig
index c62d715..b6917a7 100644
--- a/sound/soc/kirkwood/Kconfig
+++ b/sound/soc/kirkwood/Kconfig
@@ -6,14 +6,10 @@ config SND_KIRKWOOD_SOC
 	  the Kirkwood I2S interface. You will also need to select the
 	  audio interfaces to support below.
 
-config SND_KIRKWOOD_SOC_I2S
-	tristate
-
 config SND_KIRKWOOD_SOC_OPENRD
 	tristate "SoC Audio support for Kirkwood Openrd Client"
 	depends on SND_KIRKWOOD_SOC && (MACH_OPENRD_CLIENT || MACH_OPENRD_ULTIMATE)
 	depends on I2C
-	select SND_KIRKWOOD_SOC_I2S
 	select SND_SOC_CS42L51
 	help
 	  Say Y if you want to add support for SoC audio on
@@ -22,7 +18,6 @@ config SND_KIRKWOOD_SOC_OPENRD
 config SND_KIRKWOOD_SOC_T5325
 	tristate "SoC Audio support for HP t5325"
 	depends on SND_KIRKWOOD_SOC && MACH_T5325 && I2C
-	select SND_KIRKWOOD_SOC_I2S
 	select SND_SOC_ALC5623
 	help
 	  Say Y if you want to add support for SoC audio on
diff --git a/sound/soc/kirkwood/Makefile b/sound/soc/kirkwood/Makefile
index 3e62ae9..cf22ad3 100644
--- a/sound/soc/kirkwood/Makefile
+++ b/sound/soc/kirkwood/Makefile
@@ -1,8 +1,6 @@
-snd-soc-kirkwood-objs := kirkwood-dma.o
-snd-soc-kirkwood-i2s-objs := kirkwood-i2s.o
+snd-soc-kirkwood-objs := kirkwood-i2s.o kirkwood-dma.o
 
 obj-$(CONFIG_SND_KIRKWOOD_SOC) += snd-soc-kirkwood.o
-obj-$(CONFIG_SND_KIRKWOOD_SOC_I2S) += snd-soc-kirkwood-i2s.o
 
 snd-soc-openrd-objs := kirkwood-openrd.o
 snd-soc-t5325-objs := kirkwood-t5325.o
diff --git a/sound/soc/kirkwood/kirkwood-dma.c b/sound/soc/kirkwood/kirkwood-dma.c
index cef5277..9f4c595 100644
--- a/sound/soc/kirkwood/kirkwood-dma.c
+++ b/sound/soc/kirkwood/kirkwood-dma.c
@@ -364,36 +364,8 @@ static void kirkwood_dma_free_dma_buffers(struct snd_pcm *pcm)
 	}
 }
 
-static struct snd_soc_platform_driver kirkwood_soc_platform = {
+struct snd_soc_platform_driver kirkwood_soc_platform = {
 	.ops		= &kirkwood_dma_ops,
 	.pcm_new	= kirkwood_dma_new,
 	.pcm_free	= kirkwood_dma_free_dma_buffers,
 };
-
-static int kirkwood_soc_platform_probe(struct platform_device *pdev)
-{
-	return snd_soc_register_platform(&pdev->dev, &kirkwood_soc_platform);
-}
-
-static int kirkwood_soc_platform_remove(struct platform_device *pdev)
-{
-	snd_soc_unregister_platform(&pdev->dev);
-	return 0;
-}
-
-static struct platform_driver kirkwood_pcm_driver = {
-	.driver = {
-			.name = "kirkwood-pcm-audio",
-			.owner = THIS_MODULE,
-	},
-
-	.probe = kirkwood_soc_platform_probe,
-	.remove = kirkwood_soc_platform_remove,
-};
-
-module_platform_driver(kirkwood_pcm_driver);
-
-MODULE_AUTHOR("Arnaud Patard <arnaud.patard@rtp-net.org>");
-MODULE_DESCRIPTION("Marvell Kirkwood Audio DMA module");
-MODULE_LICENSE("GPL");
-MODULE_ALIAS("platform:kirkwood-pcm-audio");
diff --git a/sound/soc/kirkwood/kirkwood-i2s.c b/sound/soc/kirkwood/kirkwood-i2s.c
index d3e50af..3517784 100644
--- a/sound/soc/kirkwood/kirkwood-i2s.c
+++ b/sound/soc/kirkwood/kirkwood-i2s.c
@@ -459,6 +459,7 @@ static int kirkwood_i2s_dev_remove(struct platform_device *pdev)
 {
 	struct kirkwood_dma_data *priv = dev_get_drvdata(&pdev->dev);
 
+	snd_soc_unregister_platform(&pdev->dev);
 	snd_soc_unregister_component(&pdev->dev);
 
 	if (!IS_ERR(priv->extclk)) {
@@ -544,6 +545,10 @@ static int kirkwood_i2s_dev_probe(struct platform_device *pdev)
 		dev_err(&pdev->dev, "snd_soc_register_component failed\n");
 		goto fail;
 	}
+	err = snd_soc_register_platform(&pdev->dev, &kirkwood_soc_platform);;
+	if (err) {
+		dev_err(&pdev->dev, "snd_soc_register_platform failed\n");
+		goto fail;
 	return 0;
 
 fail:
diff --git a/sound/soc/kirkwood/kirkwood-openrd.c b/sound/soc/kirkwood/kirkwood-openrd.c
index b979c71..0fa3082 100644
--- a/sound/soc/kirkwood/kirkwood-openrd.c
+++ b/sound/soc/kirkwood/kirkwood-openrd.c
@@ -55,7 +55,7 @@ static struct snd_soc_dai_link openrd_client_dai[] = {
 	.name = "CS42L51",
 	.stream_name = "CS42L51 HiFi",
 	.cpu_dai_name = "kirkwood-i2s",
-	.platform_name = "kirkwood-pcm-audio",
+	.platform_name = "kirkwood-i2s",
 	.codec_dai_name = "cs42l51-hifi",
 	.codec_name = "cs42l51-codec.0-004a",
 	.dai_fmt = SND_SOC_DAIFMT_I2S | SND_SOC_DAIFMT_CBS_CFS,
diff --git a/sound/soc/kirkwood/kirkwood-t5325.c b/sound/soc/kirkwood/kirkwood-t5325.c
index 1d0ed6f..f48ebda 100644
--- a/sound/soc/kirkwood/kirkwood-t5325.c
+++ b/sound/soc/kirkwood/kirkwood-t5325.c
@@ -71,7 +71,7 @@ static struct snd_soc_dai_link t5325_dai[] = {
 	.name = "ALC5621",
 	.stream_name = "ALC5621 HiFi",
 	.cpu_dai_name = "kirkwood-i2s",
-	.platform_name = "kirkwood-pcm-audio",
+	.platform_name = "kirkwood-i2s",
 	.codec_dai_name = "alc5621-hifi",
 	.codec_name = "alc562x-codec.0-001a",
 	.dai_fmt = SND_SOC_DAIFMT_I2S | SND_SOC_DAIFMT_CBS_CFS,
diff --git a/sound/soc/kirkwood/kirkwood.h b/sound/soc/kirkwood/kirkwood.h
index 4d92637..f3de119 100644
--- a/sound/soc/kirkwood/kirkwood.h
+++ b/sound/soc/kirkwood/kirkwood.h
@@ -133,4 +133,5 @@ struct kirkwood_dma_data {
 	int burst;
 };
 
+extern struct snd_soc_platform_driver kirkwood_soc_platform;
 #endif
-- 
1.8.3.2



-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
