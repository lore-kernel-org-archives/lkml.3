Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753960AbbATToU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 14:44:20 -0500
Received: from smtp6-g21.free.fr ([212.27.42.6]:23998 "EHLO smtp6-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753880AbbATToP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 14:44:15 -0500
X-Mailbox-Line: From 43faf019d1ebdcfb8c62cd9e8ddae4fdb9389af2 Mon Sep 17 00:00:00 2001
Message-Id: <43faf019d1ebdcfb8c62cd9e8ddae4fdb9389af2.1421782533.git.moinejf@free.fr>
In-Reply-To: <cover.1421782532.git.moinejf@free.fr>
References: <cover.1421782532.git.moinejf@free.fr>
From: Jean-Francois Moine <moinejf@free.fr>
Date: Tue, 20 Jan 2015 16:38:45 +0100
Subject: [PATCH v10 6/9] ASoC: tda998x: add a codec to the HDMI transmitter
To: Mark Brown <broonie@kernel.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Dave Airlie <airlied@gmail.com>, Andrew Jackson <Andrew.Jackson@arm.com>,
        Jyri Sarha <jsarha@ti.com>, alsa-devel@alsa-project.org,
        devicetree@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The tda998x CODEC maintains the audio format and rate constraints according
to the HDMI device parameters (EDID) and sets dynamically the input ports
in the TDA998x I2C driver on start/stop audio streaming.

Signed-off-by: Jean-Francois Moine <moinejf@free.fr>
---
 drivers/gpu/drm/i2c/tda998x_drv.c | 124 +++++++++++++++++++++++++++
 include/sound/tda998x.h           |  22 +++++
 sound/soc/codecs/Kconfig          |   5 ++
 sound/soc/codecs/Makefile         |   2 +
 sound/soc/codecs/tda998x.c        | 174 ++++++++++++++++++++++++++++++++++++++
 5 files changed, 327 insertions(+)
 create mode 100644 sound/soc/codecs/tda998x.c

diff --git a/drivers/gpu/drm/i2c/tda998x_drv.c b/drivers/gpu/drm/i2c/tda998x_drv.c
index b35f35f..a2cfc11 100644
--- a/drivers/gpu/drm/i2c/tda998x_drv.c
+++ b/drivers/gpu/drm/i2c/tda998x_drv.c
@@ -20,6 +20,7 @@
 #include <linux/module.h>
 #include <linux/irq.h>
 #include <sound/asoundef.h>
+#include <linux/platform_device.h>
 
 #include <drm/drmP.h>
 #include <drm/drm_crtc_helper.h>
@@ -730,6 +731,104 @@ tda998x_configure_audio(struct tda998x_priv *priv,
 	tda998x_write_aif(priv, p);
 }
 
+#if IS_ENABLED(CONFIG_SND_SOC_TDA998X)
+/* tda998x audio codec interface */
+
+/* return the audio parameters */
+static int tda998x_get_audio_var(struct device *dev,
+				struct tda998x_audio_s **tda998x_audio)
+{
+	struct tda998x_priv *priv = dev_get_drvdata(dev);
+
+	if (!priv->encoder->crtc
+	 || !priv->is_hdmi_sink)
+		return -ENODEV;
+
+	*tda998x_audio = &priv->audio;
+	return 0;
+}
+
+/* switch the audio port and initialize the audio parameters for streaming */
+static int tda998x_set_audio_input(struct device *dev,
+				int port_index,
+				unsigned sample_rate)
+{
+	struct tda998x_priv *priv = dev_get_drvdata(dev);
+	struct tda998x_encoder_params *p = &priv->params;
+
+	if (!priv->encoder->crtc)
+		return -ENODEV;
+
+	/* if no port, just disable the audio port */
+	if (port_index == PORT_NONE) {
+		reg_write(priv, REG_ENA_AP, 0);
+		return 0;
+	}
+
+	/* if same audio parameters, just enable the audio port */
+	if (p->audio_cfg == priv->audio.ports[port_index] &&
+	    p->audio_sample_rate == sample_rate) {
+		reg_write(priv, REG_ENA_AP, p->audio_cfg);
+		return 0;
+	}
+
+	p->audio_format = priv->audio.port_types[port_index];
+	p->audio_clk_cfg = p->audio_format == AFMT_SPDIF ? 0 : 1;
+	p->audio_cfg = priv->audio.ports[port_index];
+	p->audio_sample_rate = sample_rate;
+	tda998x_configure_audio(priv, &priv->encoder->crtc->hwmode, p);
+	return 0;
+}
+
+/* get the audio capabilities from the EDID */
+static void tda998x_get_audio_caps(struct tda998x_priv *priv,
+				struct drm_connector *connector)
+{
+	u8 *eld = connector->eld;
+	u8 *sad;
+	int sad_count;
+	unsigned eld_ver, mnl;
+	u8 max_channels, rate_mask, fmt;
+
+	/* adjust the hw params from the ELD (EDID) */
+	eld_ver = eld[DRM_ELD_VER] >> DRM_ELD_VER_SHIFT;
+	if (eld_ver != 2 && eld_ver != 31)
+		return;
+
+	mnl = drm_eld_mnl(eld);
+	if (mnl > 16)
+		return;
+
+	sad_count = drm_eld_sad_count(eld);
+	sad = eld + DRM_ELD_CEA_SAD(mnl, 0);
+
+	/* Start from the basic audio settings */
+	max_channels = 1;
+	rate_mask = 0;
+	fmt = 0;
+	while (sad_count--) {
+		switch (sad[0] & 0x78) {
+		case 0x08:			/* SAD uncompressed audio */
+			if ((sad[0] & 7) > max_channels)
+				max_channels = sad[0] & 7;
+			rate_mask |= sad[1];
+			fmt |= sad[2] & 0x07;
+			break;
+		}
+		sad += 3;
+	}
+
+	priv->audio.cea_sad.channels = max_channels;
+	priv->audio.cea_sad.freq = rate_mask;
+	priv->audio.cea_sad.format = fmt;
+}
+
+static struct tda998x_ops_s tda998x_codec_ops = {
+	.get_audio_var = tda998x_get_audio_var,
+	.set_audio_input = tda998x_set_audio_input,
+};
+#endif /* SND_SOC */
+
 /* DRM encoder functions */
 
 static void tda998x_encoder_set_config(struct tda998x_priv *priv,
@@ -749,6 +848,8 @@ static void tda998x_encoder_set_config(struct tda998x_priv *priv,
 			    (p->mirr_f ? VIP_CNTRL_2_MIRR_F : 0);
 
 	priv->params = *p;
+	priv->audio.port_types[0] = p->audio_format;
+	priv->audio.ports[0] = p->audio_cfg;
 }
 
 static void tda998x_encoder_dpms(struct tda998x_priv *priv, int mode)
@@ -1142,6 +1243,14 @@ tda998x_encoder_get_modes(struct tda998x_priv *priv,
 		drm_mode_connector_update_edid_property(connector, edid);
 		n = drm_add_edid_modes(connector, edid);
 		priv->is_hdmi_sink = drm_detect_hdmi_monitor(edid);
+
+#if IS_ENABLED(CONFIG_SND_SOC_TDA998X)
+		/* set the audio parameters from the EDID */
+		if (priv->is_hdmi_sink) {
+			drm_edid_to_eld(connector, edid);
+			tda998x_get_audio_caps(priv, connector);
+		}
+#endif
 		kfree(edid);
 	}
 
@@ -1176,6 +1285,11 @@ static void tda998x_destroy(struct tda998x_priv *priv)
 	if (priv->hdmi->irq)
 		free_irq(priv->hdmi->irq, priv);
 
+#if IS_ENABLED(CONFIG_SND_SOC_TDA998X)
+	if (priv->audio.ports[0])
+		tda9998x_codec_unregister(&priv->hdmi->dev);
+#endif
+
 	i2c_unregister_device(priv->cec);
 }
 
@@ -1311,6 +1425,9 @@ static int tda998x_create(struct i2c_client *client, struct tda998x_priv *priv)
 	priv->vip_cntrl_1 = VIP_CNTRL_1_SWAP_C(0) | VIP_CNTRL_1_SWAP_D(1);
 	priv->vip_cntrl_2 = VIP_CNTRL_2_SWAP_E(4) | VIP_CNTRL_2_SWAP_F(5);
 
+	priv->params.audio_frame[1] = 1;		/* channels - 1 */
+	priv->params.audio_sample_rate = 48000;		/* 48kHz */
+
 	priv->current_page = 0xff;
 	priv->hdmi = client;
 	priv->cec = i2c_new_dummy(client->adapter, 0x34);
@@ -1419,6 +1536,13 @@ static int tda998x_create(struct i2c_client *client, struct tda998x_priv *priv)
 				priv->params.audio_clk_cfg =
 					priv->params.audio_format ==
 							AFMT_SPDIF ? 0 : 1;
+
+#if IS_ENABLED(CONFIG_SND_SOC_TDA998X)
+				/* and create the audio CODEC */
+				tda9998x_codec_register(&client->dev,
+							&priv->audio,
+							&tda998x_codec_ops);
+#endif
 			}
 		} else {
 
diff --git a/include/sound/tda998x.h b/include/sound/tda998x.h
index 487a809..b4b747b 100644
--- a/include/sound/tda998x.h
+++ b/include/sound/tda998x.h
@@ -1,8 +1,30 @@
 #ifndef SND_TDA998X_H
 #define SND_TDA998X_H
 
+#include <drm/drm_edid.h>
+
+/* port index for audio stream stop */
+#define PORT_NONE (-1)
+
 struct tda998x_audio_s {
 	u8 ports[2];			/* AP value */
 	u8 port_types[2];		/* AFMT_xxx */
+#if IS_ENABLED(CONFIG_SND_SOC_TDA998X)
+	struct cea_sad cea_sad;		/* Short Audio Descriptor */
+	void *codec_priv;
+#endif
 };
+
+struct tda998x_ops_s {
+	int (*get_audio_var)(struct device *dev,
+			struct tda998x_audio_s **tda998x_audio);
+	int (*set_audio_input)(struct device *dev,
+			int port_index,
+			unsigned sample_rate);
+};
+
+int tda9998x_codec_register(struct device *dev,
+			struct tda998x_audio_s *tda998x_audio_i,
+			struct tda998x_ops_s *tda998x_ops);
+void tda9998x_codec_unregister(struct device *dev);
 #endif
diff --git a/sound/soc/codecs/Kconfig b/sound/soc/codecs/Kconfig
index 8349f98..d3b1db0 100644
--- a/sound/soc/codecs/Kconfig
+++ b/sound/soc/codecs/Kconfig
@@ -102,6 +102,7 @@ config SND_SOC_ALL_CODECS
 	select SND_SOC_STAC9766 if SND_SOC_AC97_BUS
 	select SND_SOC_TAS2552 if I2C
 	select SND_SOC_TAS5086 if I2C
+	select SND_SOC_TDA998X if DRM_I2C_NXP_TDA998X
 	select SND_SOC_TFA9879 if I2C
 	select SND_SOC_TLV320AIC23_I2C if I2C
 	select SND_SOC_TLV320AIC23_SPI if SPI_MASTER
@@ -600,6 +601,10 @@ config SND_SOC_TAS5086
 	tristate "Texas Instruments TAS5086 speaker amplifier"
 	depends on I2C
 
+config SND_SOC_TDA998X
+	def_tristate y
+	depends on DRM_I2C_NXP_TDA998X
+
 config SND_SOC_TFA9879
 	tristate "NXP Semiconductors TFA9879 amplifier"
 	depends on I2C
diff --git a/sound/soc/codecs/Makefile b/sound/soc/codecs/Makefile
index bbdfd1e..44b4fda 100644
--- a/sound/soc/codecs/Makefile
+++ b/sound/soc/codecs/Makefile
@@ -104,6 +104,7 @@ snd-soc-sta350-objs := sta350.o
 snd-soc-sta529-objs := sta529.o
 snd-soc-stac9766-objs := stac9766.o
 snd-soc-tas5086-objs := tas5086.o
+snd-soc-tda998x-objs := tda998x.o
 snd-soc-tfa9879-objs := tfa9879.o
 snd-soc-tlv320aic23-objs := tlv320aic23.o
 snd-soc-tlv320aic23-i2c-objs := tlv320aic23-i2c.o
@@ -282,6 +283,7 @@ obj-$(CONFIG_SND_SOC_STA529)   += snd-soc-sta529.o
 obj-$(CONFIG_SND_SOC_STAC9766)	+= snd-soc-stac9766.o
 obj-$(CONFIG_SND_SOC_TAS2552)	+= snd-soc-tas2552.o
 obj-$(CONFIG_SND_SOC_TAS5086)	+= snd-soc-tas5086.o
+obj-$(CONFIG_SND_SOC_TDA998X)	+= snd-soc-tda998x.o
 obj-$(CONFIG_SND_SOC_TFA9879)	+= snd-soc-tfa9879.o
 obj-$(CONFIG_SND_SOC_TLV320AIC23)	+= snd-soc-tlv320aic23.o
 obj-$(CONFIG_SND_SOC_TLV320AIC23_I2C)	+= snd-soc-tlv320aic23-i2c.o
diff --git a/sound/soc/codecs/tda998x.c b/sound/soc/codecs/tda998x.c
new file mode 100644
index 0000000..0a186e7
--- /dev/null
+++ b/sound/soc/codecs/tda998x.c
@@ -0,0 +1,174 @@
+/*
+ * ALSA SoC TDA998x CODEC
+ *
+ * Copyright (C) 2015 Jean-Francois Moine
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/module.h>
+#include <sound/soc.h>
+#include <linux/of.h>
+#include <linux/of_device.h>
+#include <sound/pcm_params.h>
+#include <drm/i2c/tda998x.h>
+#include <sound/tda998x.h>
+
+/* functions in tda998x_drv */
+static struct tda998x_ops_s *tda998x_ops;
+
+static int tda998x_codec_startup(struct snd_pcm_substream *substream,
+			struct snd_soc_dai *dai)
+{
+	struct snd_pcm_runtime *runtime = substream->runtime;
+	struct tda998x_audio_s *tda998x_audio;
+	struct snd_pcm_hw_constraint_list *rate_constraints;
+#define SAD_FMT_16 0x01		/* format values in the sad */
+#define SAD_FMT_20 0x02
+#define SAD_FMT_24 0x04
+	u64 formats;
+	int ret;
+	static const u32 hdmi_rates[] = {
+		32000, 44100, 48000, 88200, 96000, 176400, 192000
+	};
+
+	/* get the audio variables */
+	ret = tda998x_ops->get_audio_var(dai->dev, &tda998x_audio);
+	if (ret < 0)
+		return ret;			/* no screen */
+
+	/* convert the EDID values to audio constraints */
+	rate_constraints = tda998x_audio->codec_priv;
+	rate_constraints->list = hdmi_rates;
+	rate_constraints->count = ARRAY_SIZE(hdmi_rates);
+	rate_constraints->mask = tda998x_audio->cea_sad.freq;
+	snd_pcm_hw_constraint_list(runtime, 0,
+				   SNDRV_PCM_HW_PARAM_RATE,
+				   rate_constraints);
+
+	formats = 0;
+	if (tda998x_audio->cea_sad.format & SAD_FMT_16)
+		formats |= SNDRV_PCM_FMTBIT_S16_LE;
+	if (tda998x_audio->cea_sad.format & SAD_FMT_20)
+		formats |= SNDRV_PCM_FMTBIT_S20_3LE;
+	if (tda998x_audio->cea_sad.format & SAD_FMT_24)
+		formats |= SNDRV_PCM_FMTBIT_S24_LE |
+			   SNDRV_PCM_FMTBIT_S24_3LE |
+			   SNDRV_PCM_FMTBIT_S32_LE;
+	snd_pcm_hw_constraint_mask64(runtime,
+				SNDRV_PCM_HW_PARAM_FORMAT,
+				formats);
+
+	snd_pcm_hw_constraint_minmax(runtime,
+				SNDRV_PCM_HW_PARAM_CHANNELS,
+				1, tda998x_audio->cea_sad.channels + 1);
+	return 0;
+}
+
+/* ask the HDMI transmitter to activate the audio input port */
+static int tda998x_codec_hw_params(struct snd_pcm_substream *substream,
+				   struct snd_pcm_hw_params *params,
+				   struct snd_soc_dai *dai)
+{
+	return tda998x_ops->set_audio_input(dai->dev, dai->id,
+					params_rate(params));
+}
+
+static void tda998x_codec_shutdown(struct snd_pcm_substream *substream,
+				   struct snd_soc_dai *dai)
+{
+	tda998x_ops->set_audio_input(dai->dev, PORT_NONE, 0);
+}
+
+static const struct snd_soc_dai_ops tda998x_codec_ops = {
+	.startup = tda998x_codec_startup,
+	.hw_params = tda998x_codec_hw_params,
+	.shutdown = tda998x_codec_shutdown,
+};
+
+#define TDA998X_FORMATS	(SNDRV_PCM_FMTBIT_S16_LE | \
+			SNDRV_PCM_FMTBIT_S20_3LE | \
+			SNDRV_PCM_FMTBIT_S24_LE | \
+			SNDRV_PCM_FMTBIT_S32_LE)
+
+static struct snd_soc_dai_driver tda998x_dai_i2s = {
+	.name = "i2s-hifi",
+	.playback = {
+		.stream_name	= "HDMI I2S Playback",
+		.channels_min	= 1,
+		.channels_max	= 8,
+		.rates		= SNDRV_PCM_RATE_CONTINUOUS,
+		.rate_min	= 5512,
+		.rate_max	= 192000,
+		.formats	= TDA998X_FORMATS,
+	},
+	.ops = &tda998x_codec_ops,
+};
+
+static const struct snd_soc_dapm_widget tda998x_widgets[] = {
+	SND_SOC_DAPM_OUTPUT("hdmi-out"),
+};
+static const struct snd_soc_dapm_route tda998x_routes[] = {
+	{ "hdmi-out", NULL, "HDMI I2S Playback" },
+	{ "hdmi-out", NULL, "HDMI SPDIF Playback" },
+};
+
+static struct snd_soc_codec_driver tda998x_codec_drv = {
+	.dapm_widgets = tda998x_widgets,
+	.num_dapm_widgets = ARRAY_SIZE(tda998x_widgets),
+	.dapm_routes = tda998x_routes,
+	.num_dapm_routes = ARRAY_SIZE(tda998x_routes),
+	.ignore_pmdown_time = true,
+};
+
+int tda9998x_codec_register(struct device *dev,
+			struct tda998x_audio_s *tda998x_audio,
+			struct tda998x_ops_s *tda998x_ops_i)
+{
+	struct snd_pcm_hw_constraint_list *codec_priv;
+	struct snd_soc_dai_driver *dais, *p_dai;
+	int i, ndais;
+
+	tda998x_ops = tda998x_ops_i;
+
+	codec_priv = devm_kzalloc(dev, sizeof(*codec_priv), GFP_KERNEL);
+	if (!codec_priv)
+		return -ENOMEM;
+	tda998x_audio->codec_priv = codec_priv;
+
+	/* build the DAIs */
+	for (ndais = 0; ndais < ARRAY_SIZE(tda998x_audio->ports); ndais++) {
+		if (!tda998x_audio->ports[ndais])
+			break;
+	}
+	dais = devm_kzalloc(dev, sizeof(*dais) * ndais, GFP_KERNEL);
+	if (!dais)
+		return -ENOMEM;
+	for (i = 0, p_dai = dais; i < ndais ; i++, p_dai++) {
+		memcpy(p_dai, &tda998x_dai_i2s, sizeof(*p_dai));
+		p_dai->id = i;
+		if (tda998x_audio->port_types[i] == AFMT_SPDIF) {
+			p_dai->name = "spdif-hifi";
+			p_dai->playback.stream_name = "HDMI SPDIF Playback";
+			p_dai->playback.channels_max = 2;
+			p_dai->playback.rate_min = 22050;
+		}
+	}
+
+	return snd_soc_register_codec(dev,
+				&tda998x_codec_drv,
+				dais, ndais);
+}
+EXPORT_SYMBOL(tda9998x_codec_register);
+
+void tda9998x_codec_unregister(struct device *dev)
+{
+	snd_soc_unregister_codec(dev);
+}
+EXPORT_SYMBOL(tda9998x_codec_unregister);
+
+MODULE_AUTHOR("Jean-Francois Moine <moinejf@free.fr>");
+MODULE_DESCRIPTION("TDA998X CODEC");
+MODULE_LICENSE("GPL");
-- 
2.1.4

