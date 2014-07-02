Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756326AbaGBQgu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 12:36:50 -0400
Received: from smtp5-g21.free.fr ([212.27.42.5]:51345 "EHLO smtp5-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751547AbaGBQgt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 12:36:49 -0400
X-Greylist: delayed 88452 seconds by postgrey-1.27 at vger.kernel.org; Wed, 02 Jul 2014 12:36:48 EDT
Date: Wed, 2 Jul 2014 18:38:41 +0200
From: Jean-Francois Moine <moinejf@free.fr>
To: Mark Brown <broonie@kernel.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: alsa-devel@alsa-project.org, lgirdwood@gmail.com,
        dri-devel@lists.freedesktop.org, Rob Clark <robdclark@gmail.com>,
        linux-arm-kernel@lists.infradead.org, Dave Airlie <airlied@gmail.com>,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Subject: [PATCH] ASoC: tda998x: add a codec to the HDMI transmitter
Message-ID: <20140702183841.7c964832@armhf>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; arm-unknown-linux-gnueabihf)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a CODEC function to the NXP TDA998x HDMI transmitter.

The CODEC handles both I2S and S/PDIF inputs and does dynamic input
switch in the TDA998x I2C driver on start/stop audio streaming.

Signed-off-by: Jean-Francois Moine <moinejf@free.fr>
---
This patch applies against linux-next.
---
 .../devicetree/bindings/drm/i2c/tda998x.txt        |  13 ++
 drivers/gpu/drm/i2c/Makefile                       |   2 +-
 drivers/gpu/drm/i2c/tda998x_codec.c                | 241 +++++++++++++++++++++
 drivers/gpu/drm/i2c/tda998x_drv.c                  |  74 +++++--
 drivers/gpu/drm/i2c/tda998x_drv.h                  |  31 +++
 include/drm/i2c/tda998x.h                          |   1 +
 6 files changed, 341 insertions(+), 21 deletions(-)
 create mode 100644 drivers/gpu/drm/i2c/tda998x_codec.c
 create mode 100644 drivers/gpu/drm/i2c/tda998x_drv.h

diff --git a/Documentation/devicetree/bindings/drm/i2c/tda998x.txt b/Documentation/devicetree/bindings/drm/i2c/tda998x.txt
index d7df01c..7ce4eac 100644
--- a/Documentation/devicetree/bindings/drm/i2c/tda998x.txt
+++ b/Documentation/devicetree/bindings/drm/i2c/tda998x.txt
@@ -15,6 +15,15 @@ Optional properties:
   - video-ports: 24 bits value which defines how the video controller
 	output is wired to the TDA998x input - default: <0x230145>
 
+  - audio-ports: one or two values corresponding to entries in
+	the audio-port-names property.
+
+  - audio-port-names: must contain "i2s", "spdif" entries
+	matching entries in the audio-ports property.
+
+  - #sound-dai-cells: must be set to <1> for use with the simple-card.
+	The DAI 0 is the I2S input and the DAI 1 is the S/PDIF input.
+
 Example:
 
 	tda998x: hdmi-encoder {
@@ -24,4 +33,8 @@ Example:
 		interrupts = <27 2>;		/* falling edge */
 		pinctrl-0 = <&pmx_camera>;
 		pinctrl-names = "default";
+
+		audio-ports = <0x03>, <0x04>;
+		audio-port-names = "i2s", "spdif";
+		#sound-dai-cells = <1>;
 	};
diff --git a/drivers/gpu/drm/i2c/Makefile b/drivers/gpu/drm/i2c/Makefile
index 43aa33b..f2d625c 100644
--- a/drivers/gpu/drm/i2c/Makefile
+++ b/drivers/gpu/drm/i2c/Makefile
@@ -6,5 +6,5 @@ obj-$(CONFIG_DRM_I2C_CH7006) += ch7006.o
 sil164-y := sil164_drv.o
 obj-$(CONFIG_DRM_I2C_SIL164) += sil164.o
 
-tda998x-y := tda998x_drv.o
+tda998x-y := tda998x_drv.o tda998x_codec.o
 obj-$(CONFIG_DRM_I2C_NXP_TDA998X) += tda998x.o
diff --git a/drivers/gpu/drm/i2c/tda998x_codec.c b/drivers/gpu/drm/i2c/tda998x_codec.c
new file mode 100644
index 0000000..dff6afb
--- /dev/null
+++ b/drivers/gpu/drm/i2c/tda998x_codec.c
@@ -0,0 +1,241 @@
+/*
+ * ALSA SoC TDA998X CODEC
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
+#include <drm/drm_encoder_slave.h>
+#include <drm/i2c/tda998x.h>
+
+#include "tda998x_drv.h"
+
+#define TDA998X_FORMATS	(SNDRV_PCM_FMTBIT_S16_LE | \
+			SNDRV_PCM_FMTBIT_S20_3LE | \
+			SNDRV_PCM_FMTBIT_S24_LE | \
+			SNDRV_PCM_FMTBIT_S32_LE)
+
+static int tda_startup(struct snd_pcm_substream *substream,
+			struct snd_soc_dai *dai)
+{
+	struct tda998x_priv *priv = snd_soc_codec_get_drvdata(dai->codec);
+	u8 *eld = priv->eld;
+	struct snd_pcm_runtime *runtime = substream->runtime;
+	u8 *sad;
+	int sad_count;
+	unsigned eld_ver, mnl, rate_mask;
+	unsigned max_channels, fmt;
+	u64 formats;
+	struct snd_pcm_hw_constraint_list *rate_constraints =
+			&priv->rate_constraints;
+	static const u32 hdmi_rates[] = {
+		32000, 44100, 48000, 88200, 9600, 176400, 192000
+	};
+
+	if (!eld)
+		return 0;
+
+	/* adjust the hw params from the ELD (EDID) */
+	eld_ver = eld[0] >> 3;
+	if (eld_ver != 2 && eld_ver != 31)
+		return 0;
+
+	mnl = eld[4] & 0x1f;
+	if (mnl > 16)
+		return 0;
+
+	sad_count = eld[5] >> 4;
+	sad = eld + 20 + mnl;
+
+	/* Start from the basic audio settings */
+	max_channels = 2;
+	rate_mask = 0;
+	fmt = 0;
+	while (sad_count--) {
+		switch (sad[0] & 0x78) {
+		case 0x08: /* PCM */
+			max_channels = max(max_channels, (sad[0] & 7) + 1u);
+			rate_mask |= sad[1];
+			fmt |= sad[2] & 0x07;
+			break;
+		}
+		sad += 3;
+	}
+
+	/* set the constraints */
+	rate_constraints->list = hdmi_rates;
+	rate_constraints->count = ARRAY_SIZE(hdmi_rates);
+	rate_constraints->mask = rate_mask;
+	snd_pcm_hw_constraint_list(runtime, 0,
+					SNDRV_PCM_HW_PARAM_RATE,
+					rate_constraints);
+
+	formats = 0;
+	if (fmt & 1)
+		formats |= SNDRV_PCM_FMTBIT_S16_LE;
+	if (fmt & 2)
+		formats |= SNDRV_PCM_FMTBIT_S20_3LE;
+	if (fmt & 4)
+		formats |= SNDRV_PCM_FMTBIT_S24_LE;
+	snd_pcm_hw_constraint_mask64(runtime,
+				SNDRV_PCM_HW_PARAM_FORMAT,
+				formats);
+
+	snd_pcm_hw_constraint_minmax(runtime,
+				SNDRV_PCM_HW_PARAM_CHANNELS,
+				1, max_channels);
+	return 0;
+}
+
+static int tda_hw_params(struct snd_pcm_substream *substream,
+			struct snd_pcm_hw_params *params,
+			struct snd_soc_dai *dai)
+{
+	struct tda998x_priv *priv = snd_soc_codec_get_drvdata(dai->codec);
+
+	/* Requires an attached display */
+	if (!priv->encoder->crtc)
+		return -ENODEV;
+
+	/* if same input and same parameters, do not do a full switch */
+	if (dai->id == priv->params.audio_format &&
+	    params_format(params) == priv->audio_sample_format) {
+		tda998x_audio_start(priv, 0);
+		return 0;
+	}
+	priv->params.audio_format = dai->id;
+	priv->audio_sample_format = params_format(params);
+	priv->params.audio_cfg =
+		priv->audio_ports[dai->id == AFMT_I2S ? 0 : 1];
+	tda998x_audio_start(priv, 1);
+	return 0;
+}
+
+static void tda_shutdown(struct snd_pcm_substream *substream,
+			struct snd_soc_dai *dai)
+{
+	struct tda998x_priv *priv = snd_soc_codec_get_drvdata(dai->codec);
+
+	tda998x_audio_stop(priv);
+}
+
+static const struct snd_soc_dai_ops tda_ops = {
+	.startup = tda_startup,
+	.hw_params = tda_hw_params,
+	.shutdown = tda_shutdown,
+};
+
+static struct snd_soc_dai_driver tda998x_dai[] = {
+	{
+		.name = "i2s-hifi",
+		.id = AFMT_I2S,
+		.playback = {
+			.stream_name	= "HDMI I2S Playback",
+			.channels_min	= 1,
+			.channels_max	= 8,
+			.rates		= SNDRV_PCM_RATE_CONTINUOUS,
+			.rate_min	= 5512,
+			.rate_max	= 192000,
+			.formats	= TDA998X_FORMATS,
+		},
+		.ops = &tda_ops,
+	},
+	{
+		.name = "spdif-hifi",
+		.id = AFMT_SPDIF,
+		.playback = {
+			.stream_name	= "HDMI SPDIF Playback",
+			.channels_min	= 1,
+			.channels_max	= 2,
+			.rates		= SNDRV_PCM_RATE_CONTINUOUS,
+			.rate_min	= 22050,
+			.rate_max	= 192000,
+			.formats	= TDA998X_FORMATS,
+		},
+		.ops = &tda_ops,
+	},
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
+	struct i2c_client *i2c_client = to_i2c_client(codec->dev);
+	struct tda998x_priv *priv = i2c_get_clientdata(i2c_client);
+	struct device_node *np = codec->dev->of_node;
+	int i, j, ret;
+	const char *p;
+
+	if (!priv)
+		return -ENODEV;
+	snd_soc_codec_set_drvdata(codec, priv);
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
+		priv->audio_ports[j] = port;
+	}
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
+int tda998x_codec_register(struct device *dev)
+{
+	return snd_soc_register_codec(dev,
+				&soc_codec_tda998x,
+				tda998x_dai, ARRAY_SIZE(tda998x_dai));
+}
+
+void tda998x_codec_unregister(struct device *dev)
+{
+	snd_soc_unregister_codec(dev);
+}
diff --git a/drivers/gpu/drm/i2c/tda998x_drv.c b/drivers/gpu/drm/i2c/tda998x_drv.c
index 240c331..7e9f9dc 100644
--- a/drivers/gpu/drm/i2c/tda998x_drv.c
+++ b/drivers/gpu/drm/i2c/tda998x_drv.c
@@ -21,6 +21,7 @@
 #include <linux/module.h>
 #include <linux/irq.h>
 #include <sound/asoundef.h>
+#include <sound/pcm_params.h>
 
 #include <drm/drmP.h>
 #include <drm/drm_crtc_helper.h>
@@ -28,24 +29,9 @@
 #include <drm/drm_edid.h>
 #include <drm/i2c/tda998x.h>
 
-#define DBG(fmt, ...) DRM_DEBUG(fmt"\n", ##__VA_ARGS__)
+#include "tda998x_drv.h"
 
-struct tda998x_priv {
-	struct i2c_client *cec;
-	struct i2c_client *hdmi;
-	uint16_t rev;
-	uint8_t current_page;
-	int dpms;
-	bool is_hdmi_sink;
-	u8 vip_cntrl_0;
-	u8 vip_cntrl_1;
-	u8 vip_cntrl_2;
-	struct tda998x_encoder_params params;
-
-	wait_queue_head_t wq_edid;
-	volatile int wq_edid_wait;
-	struct drm_encoder *encoder;
-};
+#define DBG(fmt, ...) DRM_DEBUG(fmt"\n", ##__VA_ARGS__)
 
 #define to_tda998x_priv(x)  ((struct tda998x_priv *)to_encoder_slave(x)->slave_priv)
 
@@ -640,12 +626,11 @@ static void
 tda998x_configure_audio(struct tda998x_priv *priv,
 		struct drm_display_mode *mode, struct tda998x_encoder_params *p)
 {
-	uint8_t buf[6], clksel_aip, clksel_fs, cts_n, adiv;
+	uint8_t buf[6], clksel_aip, clksel_fs, cts_n, adiv, aclk;
 	uint32_t n;
 
 	/* Enable audio ports */
 	reg_write(priv, REG_ENA_AP, p->audio_cfg);
-	reg_write(priv, REG_ENA_ACLK, p->audio_clk_cfg);
 
 	/* Set audio input source */
 	switch (p->audio_format) {
@@ -654,13 +639,28 @@ tda998x_configure_audio(struct tda998x_priv *priv,
 		clksel_aip = AIP_CLKSEL_AIP_SPDIF;
 		clksel_fs = AIP_CLKSEL_FS_FS64SPDIF;
 		cts_n = CTS_N_M(3) | CTS_N_K(3);
+		aclk = 0;				/* no clock */
 		break;
 
 	case AFMT_I2S:
 		reg_write(priv, REG_MUX_AP, MUX_AP_SELECT_I2S);
 		clksel_aip = AIP_CLKSEL_AIP_I2S;
 		clksel_fs = AIP_CLKSEL_FS_ACLK;
-		cts_n = CTS_N_M(3) | CTS_N_K(3);
+		/* with I2S input, the CTS_N predivider depends on
+		 * the sample width */
+		switch (priv->audio_sample_format) {
+		case SNDRV_PCM_FORMAT_S16_LE:
+			cts_n = CTS_N_M(3) | CTS_N_K(1);
+			break;
+		case SNDRV_PCM_FORMAT_S24_LE:
+			cts_n = CTS_N_M(3) | CTS_N_K(2);
+			break;
+		default:
+		case SNDRV_PCM_FORMAT_S32_LE:
+			cts_n = CTS_N_M(3) | CTS_N_K(3);
+			break;
+		}
+		aclk = 1;				/* clock enable */
 		break;
 
 	default:
@@ -672,6 +672,7 @@ tda998x_configure_audio(struct tda998x_priv *priv,
 	reg_clear(priv, REG_AIP_CNTRL_0, AIP_CNTRL_0_LAYOUT |
 					AIP_CNTRL_0_ACR_MAN);	/* auto CTS */
 	reg_write(priv, REG_CTS_N, cts_n);
+	reg_write(priv, REG_ENA_ACLK, aclk);
 
 	/*
 	 * Audio input somehow depends on HDMI line rate which is
@@ -728,6 +729,24 @@ tda998x_configure_audio(struct tda998x_priv *priv,
 	tda998x_write_aif(priv, p);
 }
 
+/* tda998x codec interface */
+void tda998x_audio_start(struct tda998x_priv *priv,
+			 int full)
+{
+	struct tda998x_encoder_params *p = &priv->params;
+
+	if (!full) {
+		reg_write(priv, REG_ENA_AP, p->audio_cfg);
+		return;
+	}
+	tda998x_configure_audio(priv, &priv->encoder->crtc->hwmode, p);
+}
+
+void tda998x_audio_stop(struct tda998x_priv *priv)
+{
+	reg_write(priv, REG_ENA_AP, 0);
+}
+
 /* DRM encoder functions */
 
 static void
@@ -1149,6 +1168,11 @@ tda998x_encoder_get_modes(struct drm_encoder *encoder,
 		drm_mode_connector_update_edid_property(connector, edid);
 		n = drm_add_edid_modes(connector, edid);
 		priv->is_hdmi_sink = drm_detect_hdmi_monitor(edid);
+
+		/* keep the EDID as ELD for the audio subsystem */
+		drm_edid_to_eld(connector, edid);
+		priv->eld = connector->eld;
+
 		kfree(edid);
 	}
 
@@ -1191,6 +1215,8 @@ tda998x_encoder_destroy(struct drm_encoder *encoder)
 	if (priv->hdmi->irq)
 		free_irq(priv->hdmi->irq, priv);
 
+	tda998x_codec_unregister(&priv->hdmi->dev);
+
 	if (priv->cec)
 		i2c_unregister_device(priv->cec);
 	kfree(priv);
@@ -1239,10 +1265,15 @@ tda998x_encoder_init(struct i2c_client *client,
 	if (!priv)
 		return -ENOMEM;
 
+	i2c_set_clientdata(client, priv);
+
 	priv->vip_cntrl_0 = VIP_CNTRL_0_SWAP_A(2) | VIP_CNTRL_0_SWAP_B(3);
 	priv->vip_cntrl_1 = VIP_CNTRL_1_SWAP_C(0) | VIP_CNTRL_1_SWAP_D(1);
 	priv->vip_cntrl_2 = VIP_CNTRL_2_SWAP_E(4) | VIP_CNTRL_2_SWAP_F(5);
 
+	priv->params.audio_frame[1] = 1;		/* channels - 1 */
+	priv->params.audio_sample_rate = 48000;		/* 48kHz */
+
 	priv->current_page = 0xff;
 	priv->hdmi = client;
 	priv->cec = i2c_new_dummy(client->adapter, 0x34);
@@ -1340,6 +1371,9 @@ tda998x_encoder_init(struct i2c_client *client,
 	/* enable EDID read irq: */
 	reg_set(priv, REG_INT_FLAGS_2, INT_FLAGS_2_EDID_BLK_RD);
 
+	/* register the audio CODEC */
+	tda998x_codec_register(&client->dev);
+
 	if (!np)
 		return 0;		/* non-DT */
 
diff --git a/drivers/gpu/drm/i2c/tda998x_drv.h b/drivers/gpu/drm/i2c/tda998x_drv.h
new file mode 100644
index 0000000..6db5160
--- /dev/null
+++ b/drivers/gpu/drm/i2c/tda998x_drv.h
@@ -0,0 +1,31 @@
+/* tda998x private data */
+
+struct tda998x_priv {
+	struct i2c_client *cec;
+	struct i2c_client *hdmi;
+	uint16_t rev;
+	uint8_t current_page;
+	int dpms;
+	bool is_hdmi_sink;
+	u8 vip_cntrl_0;
+	u8 vip_cntrl_1;
+	u8 vip_cntrl_2;
+	struct tda998x_encoder_params params;
+
+	wait_queue_head_t wq_edid;
+	volatile int wq_edid_wait;
+	struct drm_encoder *encoder;
+
+	u8 audio_ports[2];
+	int audio_sample_format;
+
+	u8 *eld;
+
+	struct snd_pcm_hw_constraint_list rate_constraints;
+};
+
+int tda998x_codec_register(struct device *dev);
+void tda998x_codec_unregister(struct device *dev);
+
+void tda998x_audio_start(struct tda998x_priv *priv, int full);
+void tda998x_audio_stop(struct tda998x_priv *priv);
diff --git a/include/drm/i2c/tda998x.h b/include/drm/i2c/tda998x.h
index 3e419d9..31757df 100644
--- a/include/drm/i2c/tda998x.h
+++ b/include/drm/i2c/tda998x.h
@@ -20,6 +20,7 @@ struct tda998x_encoder_params {
 	u8 audio_frame[6];
 
 	enum {
+		AFMT_NO_AUDIO = 0,
 		AFMT_SPDIF,
 		AFMT_I2S
 	} audio_format;
-- 
2.0.1


-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
