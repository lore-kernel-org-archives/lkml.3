Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751647AbaHaNdX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Aug 2014 09:33:23 -0400
Received: from smtp2-g21.free.fr ([212.27.42.2]:8888 "EHLO smtp2-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751528AbaHaNdU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Aug 2014 09:33:20 -0400
X-Mailbox-Line: From 080616c48997c53a14910f05a0fcf3f995412315 Mon Sep 17 00:00:00 2001
Message-Id: <080616c48997c53a14910f05a0fcf3f995412315.1409490122.git.moinejf@free.fr>
In-Reply-To: <cover.1409490122.git.moinejf@free.fr>
References: <cover.1409490122.git.moinejf@free.fr>
From: Jean-Francois Moine <moinejf@free.fr>
Date: Sun, 31 Aug 2014 12:45:39 +0200
Subject: [PATCH v4 1/2] ASoC:codecs: Add a generic HDMI audio CODEC
To: Mark Brown <broonie@kernel.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Andrew Jackson <Andrew.Jackson@arm.com>, alsa-devel@alsa-project.org,
        devicetree@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a generic audio CODEC function to HDMI transmitters.

The CODEC is implemented as a library in a kernel module.

It handles both I2S and S/PDIF input, maintaining the audio format
and rates constraints according to the HDMI device parameters (EDID).

Audio source input switch is offered to the HDMI driver on start/stop
of audio streaming.

Signed-off-by: Jean-Francois Moine <moinejf@free.fr>
---
 Documentation/devicetree/bindings/sound/hdmi2.txt |  32 ++++
 include/sound/hdmi2.h                             |  24 +++
 sound/soc/codecs/Kconfig                          |   3 +
 sound/soc/codecs/Makefile                         |   2 +
 sound/soc/codecs/hdmi2.c                          | 204 ++++++++++++++++++++++
 5 files changed, 265 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/sound/hdmi2.txt
 create mode 100644 include/sound/hdmi2.h
 create mode 100644 sound/soc/codecs/hdmi2.c

diff --git a/Documentation/devicetree/bindings/sound/hdmi2.txt b/Documentation/devicetree/bindings/sound/hdmi2.txt
new file mode 100644
index 0000000..5776370
--- /dev/null
+++ b/Documentation/devicetree/bindings/sound/hdmi2.txt
@@ -0,0 +1,32 @@
+Device-Tree bindings for the generic HDMI2 CODEC
+
+The HDMI2 CODEC describes how the audio controller is connected to the
+HDMI transmitter.
+These definitions are included in the HDMI transmiter description.
+
+Required properties:
+
+  - audio-ports: must contain one or two HDMI transmitter dependant
+	values identifying the audio sources.
+	The source type is given by the corresponding entry in
+	the audio-port-names property.
+
+  - audio-port-names: must contain entries matching the entries in
+	the audio-ports property.
+	Each value may be "i2s" or "spdif", giving the type of
+	the associated audio port.
+
+  - #sound-dai-cells: must be set to <1> for use with the simple-card.
+	The DAI 0 is the I2S input and the DAI 1 is the S/PDIF input.
+
+Example:
+
+	hdmi: hdmi-encoder {
+		compatible = "nxp,tda998x";
+		reg = <0x70>;
+		...
+
+		audio-ports = <0x03>, <0x04>;
+		audio-port-names = "i2s", "spdif";
+		#sound-dai-cells = <1>;
+	};
diff --git a/include/sound/hdmi2.h b/include/sound/hdmi2.h
new file mode 100644
index 0000000..59e4148
--- /dev/null
+++ b/include/sound/hdmi2.h
@@ -0,0 +1,24 @@
+#ifndef SND_HDMI2_H
+#define SND_HDMI2_H
+/* hdmi2 codec data */
+struct hdmi2_codec {
+	u8 ports[2];
+	u16 source;			/* audio DAI = index to ports[] */
+#define HDMI2_I2S 0
+#define HDMI2_SPDIF 1
+
+	unsigned sample_rate;		/* current streaming values */
+	int sample_format;
+
+	u64 formats;			/* HDMI (EDID) values */
+	unsigned max_channels;
+	struct snd_pcm_hw_constraint_list rate_constraints;
+
+	void (*start)(struct hdmi2_codec *audio, int full);
+	void (*stop)(struct hdmi2_codec *audio);
+};
+
+/* hdmi device -> hdmi2 codec */
+int hdmi2_codec_register(struct device *dev);
+void hdmi2_codec_unregister(struct device *dev);
+#endif
diff --git a/sound/soc/codecs/Kconfig b/sound/soc/codecs/Kconfig
index 8ab1547..1b8d81e 100644
--- a/sound/soc/codecs/Kconfig
+++ b/sound/soc/codecs/Kconfig
@@ -424,6 +424,9 @@ config SND_SOC_ES8328_SPI
 	tristate
 	select SND_SOC_ES8328
 
+config SND_SOC_HDMI2
+	tristate
+
 config SND_SOC_ISABELLE
         tristate
 
diff --git a/sound/soc/codecs/Makefile b/sound/soc/codecs/Makefile
index afba944..f59b1e6 100644
--- a/sound/soc/codecs/Makefile
+++ b/sound/soc/codecs/Makefile
@@ -53,6 +53,7 @@ snd-soc-dmic-objs := dmic.o
 snd-soc-es8328-objs := es8328.o
 snd-soc-es8328-i2c-objs := es8328-i2c.o
 snd-soc-es8328-spi-objs := es8328-spi.o
+snd-soc-hdmi2-objs := hdmi2.o
 snd-soc-isabelle-objs := isabelle.o
 snd-soc-jz4740-codec-objs := jz4740.o
 snd-soc-l3-objs := l3.o
@@ -228,6 +229,7 @@ obj-$(CONFIG_SND_SOC_DMIC)	+= snd-soc-dmic.o
 obj-$(CONFIG_SND_SOC_ES8328)	+= snd-soc-es8328.o
 obj-$(CONFIG_SND_SOC_ES8328_I2C)+= snd-soc-es8328-i2c.o
 obj-$(CONFIG_SND_SOC_ES8328_SPI)+= snd-soc-es8328-spi.o
+obj-$(CONFIG_SND_SOC_HDMI2)	+= snd-soc-hdmi2.o
 obj-$(CONFIG_SND_SOC_ISABELLE)	+= snd-soc-isabelle.o
 obj-$(CONFIG_SND_SOC_JZ4740_CODEC)	+= snd-soc-jz4740-codec.o
 obj-$(CONFIG_SND_SOC_L3)	+= snd-soc-l3.o
diff --git a/sound/soc/codecs/hdmi2.c b/sound/soc/codecs/hdmi2.c
new file mode 100644
index 0000000..8ba8ba6
--- /dev/null
+++ b/sound/soc/codecs/hdmi2.c
@@ -0,0 +1,204 @@
+/*
+ * ALSA SoC generic HDMI CODEC
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
+#include <sound/pcm_params.h>
+#include <linux/of.h>
+#include <linux/i2c.h>
+#include <sound/hdmi2.h>
+
+#define HDMI2_FORMATS	(SNDRV_PCM_FMTBIT_S16_LE | \
+			SNDRV_PCM_FMTBIT_S20_3LE | \
+			SNDRV_PCM_FMTBIT_S24_LE | \
+			SNDRV_PCM_FMTBIT_S32_LE)
+
+static int hdmi2_startup(struct snd_pcm_substream *substream,
+			struct snd_soc_dai *dai)
+{
+	struct hdmi2_codec *audio = snd_soc_codec_get_drvdata(dai->codec);
+	struct snd_pcm_runtime *runtime = substream->runtime;
+
+	/* set the constraints */
+	snd_pcm_hw_constraint_list(runtime, 0,
+					SNDRV_PCM_HW_PARAM_RATE,
+					&audio->rate_constraints);
+	snd_pcm_hw_constraint_mask64(runtime,
+				SNDRV_PCM_HW_PARAM_FORMAT,
+				audio->formats);
+
+	snd_pcm_hw_constraint_minmax(runtime,
+				SNDRV_PCM_HW_PARAM_CHANNELS,
+				1, audio->max_channels);
+	return 0;
+}
+
+static int hdmi2_hw_params(struct snd_pcm_substream *substream,
+			struct snd_pcm_hw_params *params,
+			struct snd_soc_dai *dai)
+{
+	struct hdmi2_codec *audio = snd_soc_codec_get_drvdata(dai->codec);
+
+	/* if same input and same parameters, do not do a full switch */
+	if (dai->id == audio->source &&
+	    params_format(params) == audio->sample_format &&
+	    params_rate(params) == audio->sample_rate) {
+		audio->start(audio, 0);
+		return 0;
+	}
+
+	audio->source = dai->id;
+	audio->sample_format = params_format(params);
+	audio->sample_rate = params_rate(params);
+	audio->start(audio, 1);
+	return 0;
+}
+
+static void hdmi2_shutdown(struct snd_pcm_substream *substream,
+			struct snd_soc_dai *dai)
+{
+	struct hdmi2_codec *audio = snd_soc_codec_get_drvdata(dai->codec);
+
+	audio->stop(audio);
+}
+
+static const struct snd_soc_dai_ops hdmi2_ops = {
+	.startup = hdmi2_startup,
+	.hw_params = hdmi2_hw_params,
+	.shutdown = hdmi2_shutdown,
+};
+
+static struct snd_soc_dai_driver hdmi2_dai[] = {
+	{
+		.name = "i2s-hifi",
+		.id = HDMI2_I2S,
+		.playback = {
+			.stream_name	= "HDMI I2S Playback",
+			.channels_min	= 1,
+			.channels_max	= 8,
+			.rates		= SNDRV_PCM_RATE_CONTINUOUS,
+			.rate_min	= 5512,
+			.rate_max	= 192000,
+			.formats	= HDMI2_FORMATS,
+		},
+		.ops = &hdmi2_ops,
+	},
+	{
+		.name = "spdif-hifi",
+		.id = HDMI2_SPDIF,
+		.playback = {
+			.stream_name	= "HDMI SPDIF Playback",
+			.channels_min	= 1,
+			.channels_max	= 2,
+			.rates		= SNDRV_PCM_RATE_CONTINUOUS,
+			.rate_min	= 22050,
+			.rate_max	= 192000,
+			.formats	= HDMI2_FORMATS,
+		},
+		.ops = &hdmi2_ops,
+	},
+};
+
+static const struct snd_soc_dapm_widget hdmi2_widgets[] = {
+	SND_SOC_DAPM_OUTPUT("hdmi-out"),
+};
+static const struct snd_soc_dapm_route hdmi2_routes[] = {
+	{ "hdmi-out", NULL, "HDMI I2S Playback" },
+	{ "hdmi-out", NULL, "HDMI SPDIF Playback" },
+};
+
+/*
+ * The HDMI driver must set the i2c client data to the hdmi2_codec
+ */
+static int hdmi2_probe(struct snd_soc_codec *codec)
+{
+	struct i2c_client *i2c_client = to_i2c_client(codec->dev);
+	struct hdmi2_codec *audio = i2c_get_clientdata(i2c_client);
+	struct device_node *np = codec->dev->of_node;
+	int i, j, ret;
+	const char *p;
+
+	if (!audio)
+		return -ENODEV;
+	snd_soc_codec_set_drvdata(codec, audio);
+
+	if (!np)
+		return 0;
+
+	/* get the audio input ports*/
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
+		ret = of_property_read_string_index(np, "audio-port-names",
+						i, &p);
+		if (ret) {
+			dev_err(codec->dev,
+				"missing audio-port-names[%d]\n", i);
+			break;
+		}
+		if (strcmp(p, "i2s") == 0) {
+			j = 0;
+		} else if (strcmp(p, "spdif") == 0) {
+			j = 1;
+		} else {
+			dev_err(codec->dev,
+				"bad audio-port-names '%s'\n", p);
+			break;
+		}
+		audio->ports[j] = port;
+	}
+	return 0;
+}
+
+static const struct snd_soc_codec_driver soc_codec_hdmi2 = {
+	.probe = hdmi2_probe,
+	.dapm_widgets = hdmi2_widgets,
+	.num_dapm_widgets = ARRAY_SIZE(hdmi2_widgets),
+	.dapm_routes = hdmi2_routes,
+	.num_dapm_routes = ARRAY_SIZE(hdmi2_routes),
+};
+
+int hdmi2_codec_register(struct device *dev)
+{
+	return snd_soc_register_codec(dev,
+				&soc_codec_hdmi2,
+				hdmi2_dai, ARRAY_SIZE(hdmi2_dai));
+}
+EXPORT_SYMBOL(hdmi2_codec_register);
+
+void hdmi2_codec_unregister(struct device *dev)
+{
+	snd_soc_unregister_codec(dev);
+}
+EXPORT_SYMBOL(hdmi2_codec_unregister);
+
+/* -- module insert / remove -- */
+MODULE_AUTHOR("Jean-Francois Moine <moinejf@free.fr>");
+MODULE_DESCRIPTION("HDMI2 CODEC");
+MODULE_LICENSE("GPL");
+
+static int __init hdmi2_codec_init(void)
+{
+	return 0;
+}
+static void __exit hdmi2_codec_exit(void)
+{
+}
+
+module_init(hdmi2_codec_init);
+module_exit(hdmi2_codec_exit);
-- 
2.1.0

