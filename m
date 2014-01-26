Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753528AbaA0Jgi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 04:36:38 -0500
Received: from smtp6-g21.free.fr ([212.27.42.6]:48367 "EHLO smtp6-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751275AbaA0Jgg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 04:36:36 -0500
X-Mailbox-Line: From a62784e8778d06512d49a24dcf59ff9e45839902 Mon Sep 17 00:00:00 2001
Message-Id: <a62784e8778d06512d49a24dcf59ff9e45839902.1390813481.git.moinejf@free.fr>
In-Reply-To: <cover.1390813480.git.moinejf@free.fr>
References: <cover.1390813480.git.moinejf@free.fr>
From: Jean-Francois Moine <moinejf@free.fr>
Date: Sun, 26 Jan 2014 19:45:36 +0100
Subject: [PATCH 2/4] ASoC: tda998x: add a codec driver for TDA998x
To: alsa-devel@alsa-project.org
Cc: broonie@kernel.org, Dave Airlie <airlied@gmail.com>,
        dri-devel@lists.freedesktop.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Rob Clark <robdclark@gmail.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a CODEC driver for the NXP TDA998x HDMI transmitter.

The CODEC handles both I2S and S/PDIF input and does dynamic input
switch in the TDA998x I2C driver on audio streaming start/stop.

Signed-off-by: Jean-Francois Moine <moinejf@free.fr>
---
 sound/soc/codecs/Kconfig   |   7 ++
 sound/soc/codecs/Makefile  |   2 +
 sound/soc/codecs/tda998x.c | 227 +++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 236 insertions(+)
 create mode 100644 sound/soc/codecs/tda998x.c

diff --git a/sound/soc/codecs/Kconfig b/sound/soc/codecs/Kconfig
index b33b45d..7cec76e 100644
--- a/sound/soc/codecs/Kconfig
+++ b/sound/soc/codecs/Kconfig
@@ -71,6 +71,7 @@ config SND_SOC_ALL_CODECS
 	select SND_SOC_STA529 if I2C
 	select SND_SOC_STAC9766 if SND_SOC_AC97_BUS
 	select SND_SOC_TAS5086 if I2C
+	select SND_SOC_TDA998X if I2C
 	select SND_SOC_TLV320AIC23 if I2C
 	select SND_SOC_TLV320AIC26 if SPI_MASTER
 	select SND_SOC_TLV320AIC32X4 if I2C
@@ -352,6 +353,12 @@ config SND_SOC_STAC9766
 config SND_SOC_TAS5086
 	tristate
 
+config SND_SOC_TDA998X
+	tristate
+	depends on OF
+	default y if DRM_I2C_NXP_TDA998X=y
+	default m if DRM_I2C_NXP_TDA998X=m
+
 config SND_SOC_TLV320AIC23
 	tristate
 
diff --git a/sound/soc/codecs/Makefile b/sound/soc/codecs/Makefile
index bc12676..a53d09e 100644
--- a/sound/soc/codecs/Makefile
+++ b/sound/soc/codecs/Makefile
@@ -62,6 +62,7 @@ snd-soc-sta32x-objs := sta32x.o
 snd-soc-sta529-objs := sta529.o
 snd-soc-stac9766-objs := stac9766.o
 snd-soc-tas5086-objs := tas5086.o
+snd-soc-tda998x-objs := tda998x.o
 snd-soc-tlv320aic23-objs := tlv320aic23.o
 snd-soc-tlv320aic26-objs := tlv320aic26.o
 snd-soc-tlv320aic3x-objs := tlv320aic3x.o
@@ -192,6 +193,7 @@ obj-$(CONFIG_SND_SOC_STA32X)   += snd-soc-sta32x.o
 obj-$(CONFIG_SND_SOC_STA529)   += snd-soc-sta529.o
 obj-$(CONFIG_SND_SOC_STAC9766)	+= snd-soc-stac9766.o
 obj-$(CONFIG_SND_SOC_TAS5086)	+= snd-soc-tas5086.o
+obj-$(CONFIG_SND_SOC_TDA998X)	+= snd-soc-tda998x.o
 obj-$(CONFIG_SND_SOC_TLV320AIC23)	+= snd-soc-tlv320aic23.o
 obj-$(CONFIG_SND_SOC_TLV320AIC26)	+= snd-soc-tlv320aic26.o
 obj-$(CONFIG_SND_SOC_TLV320AIC3X)	+= snd-soc-tlv320aic3x.o
diff --git a/sound/soc/codecs/tda998x.c b/sound/soc/codecs/tda998x.c
new file mode 100644
index 0000000..d724f7d
--- /dev/null
+++ b/sound/soc/codecs/tda998x.c
@@ -0,0 +1,227 @@
+/*
+ * ALSA SoC TDA998X driver
+ *
+ * This driver is used by the NXP TDA998x HDMI transmitter.
+ *
+ * Copyright (C) 2014 Jean-Francois Moine
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/module.h>
+#include <sound/soc.h>
+#include <sound/pcm.h>
+#include <linux/of.h>
+#include <linux/i2c.h>
+#include <drm/drm_encoder_slave.h>
+#include <drm/i2c/tda998x.h>
+
+#define TDA998X_FORMATS	(SNDRV_PCM_FMTBIT_S16_LE | \
+			SNDRV_PCM_FMTBIT_S20_3LE | \
+			SNDRV_PCM_FMTBIT_S24_LE | \
+			SNDRV_PCM_FMTBIT_S32_LE)
+
+struct tda_priv {
+	struct i2c_client *i2c_client;
+	struct snd_soc_codec *codec;
+	u8 ports[2];
+	int dai_id;
+	u8 *eld;
+};
+
+static void tda_get_encoder(struct tda_priv *priv)
+{
+	struct snd_soc_codec *codec = priv->codec;
+	struct device_node *np;
+	struct i2c_client *i2c_client;
+	static const struct of_device_id tda_dt[] = {
+		{ .compatible = "nxp,tda998x" },
+		{ },
+	};
+
+	/* search the tda998x device */
+	np = of_find_matching_node_and_match(NULL, tda_dt, NULL);
+	if (!np || !of_device_is_available(np)) {
+		dev_err(codec->dev, "No tda998x in DT\n");
+		return;
+	}
+	i2c_client = of_find_i2c_device_by_node(np);
+	of_node_put(np);
+	if (!i2c_client) {
+		dev_err(codec->dev, "no tda998x i2c client\n");
+		return;
+	}
+	if (!i2c_get_clientdata(i2c_client)) {
+		dev_err(codec->dev, "tda998x not initialized\n");
+		return;
+	}
+
+	priv->i2c_client = i2c_client;
+}
+
+static int tda_start_stop(struct tda_priv *priv,
+			int start)
+{
+	int format, port;
+
+	if (!priv->i2c_client) {
+		tda_get_encoder(priv);
+		if (!priv->i2c_client)
+			return -EINVAL;
+	}
+
+	/* give the audio input type and ports to the HDMI encoder */
+	format = start ? priv->dai_id : 0;
+	switch (format) {
+	case AFMT_I2S:
+		port = priv->ports[0];
+		break;
+	default:
+	case AFMT_SPDIF:
+		port = priv->ports[1];
+		break;
+	}
+	tda998x_audio_update(priv->i2c_client, format, port);
+	return 0;
+}
+
+static int tda_startup(struct snd_pcm_substream *substream,
+			struct snd_soc_dai *dai)
+{
+	struct tda_priv *priv = snd_soc_codec_get_drvdata(dai->codec);
+
+	/* memorize the used DAI */
+	priv->dai_id = dai->id;
+
+	/* start the TDA998x audio */
+	return tda_start_stop(priv, 1);
+}
+
+static void tda_shutdown(struct snd_pcm_substream *substream,
+			struct snd_soc_dai *dai)
+{
+	struct tda_priv *priv = snd_soc_codec_get_drvdata(dai->codec);
+
+	priv->dai_id = 0;
+	tda_start_stop(priv, 0);
+}
+
+static const struct snd_soc_dai_ops tda_ops = {
+	.startup = tda_startup,
+	.shutdown = tda_shutdown,
+};
+
+static const struct snd_soc_dai_driver tda998x_dai[] = {
+    {
+	.name = "i2s-hifi",
+	.id = AFMT_I2S,
+	.playback = {
+		.stream_name	= "HDMI I2S Playback",
+		.channels_min	= 1,
+		.channels_max	= 8,
+		.rates		= SNDRV_PCM_RATE_CONTINUOUS,
+		.rate_min	= 5512,
+		.rate_max	= 192000,
+		.formats	= TDA998X_FORMATS,
+
+	},
+	.ops = &tda_ops,
+    },
+    {
+	.name = "spdif-hifi",
+	.id = AFMT_SPDIF,
+	.playback = {
+		.stream_name	= "HDMI SPDIF Playback",
+		.channels_min	= 1,
+		.channels_max	= 2,
+		.rates		= SNDRV_PCM_RATE_CONTINUOUS,
+		.rate_min	= 22050,
+		.rate_max	= 192000,
+		.formats	= TDA998X_FORMATS,
+	},
+	.ops = &tda_ops,
+    },
+};
+
+static const struct snd_soc_dapm_widget tda_widgets[] = {
+	SND_SOC_DAPM_OUTPUT("hdmi-out"),
+};
+static const struct snd_soc_dapm_route tda_routes[] = {
+	{ "hdmi-out", NULL, "HDMI I2S Playback" },
+	{ "hdmi-out", NULL, "HDMI SPDIF Playback" },
+};
+
+static int tda_probe(struct snd_soc_codec *codec)
+{
+	struct tda_priv *priv;
+	struct device_node *np;
+	int i, ret;
+
+	priv = devm_kzalloc(codec->dev, sizeof(*priv), GFP_KERNEL);
+	if (!priv)
+		return -ENOMEM;
+	snd_soc_codec_set_drvdata(codec, priv);
+	priv->codec = codec;
+
+	/* get the audio input ports (I2s and S/PDIF) */
+	np = codec->dev->of_node;
+	for (i = 0; i < 2; i++) {
+		u32 port;
+
+		ret = of_property_read_u32_index(np, "audio-ports", i, &port);
+		if (ret) {
+			if (i == 0)
+				dev_err(codec->dev,
+					"bad or missing audio-ports\n");
+			break;
+		}
+		priv->ports[i] = port;
+	}
+
+	return 0;
+}
+
+static const struct snd_soc_codec_driver soc_codec_tda998x = {
+	.probe = tda_probe,
+	.dapm_widgets = tda_widgets,
+	.num_dapm_widgets = ARRAY_SIZE(tda_widgets),
+	.dapm_routes = tda_routes,
+	.num_dapm_routes = ARRAY_SIZE(tda_routes),
+};
+
+static int tda998x_dev_probe(struct platform_device *pdev)
+{
+	return snd_soc_register_codec(&pdev->dev,
+				&soc_codec_tda998x,
+				tda998x_dai, ARRAY_SIZE(tda998x_dai));
+}
+
+static int tda998x_dev_remove(struct platform_device *pdev)
+{
+	snd_soc_unregister_codec(&pdev->dev);
+	return 0;
+}
+
+static const struct of_device_id tda998x_codec_ids[] = {
+	{ .compatible = "nxp,tda998x-codec", },
+	{ }
+};
+MODULE_DEVICE_TABLE(of, tda998x_codec_ids);
+
+static struct platform_driver tda998x_driver = {
+	.probe		= tda998x_dev_probe,
+	.remove		= tda998x_dev_remove,
+	.driver		= {
+		.name	= "tda998x-codec",
+		.owner	= THIS_MODULE,
+		.of_match_table = tda998x_codec_ids,
+	},
+};
+
+module_platform_driver(tda998x_driver);
+
+MODULE_AUTHOR("Jean-Francois Moine");
+MODULE_DESCRIPTION("TDA998x codec driver");
+MODULE_LICENSE("GPL");
-- 
1.8.5.3

