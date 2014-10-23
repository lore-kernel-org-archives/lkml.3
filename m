Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754283AbaJWIsf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 04:48:35 -0400
Received: from smtp4-g21.free.fr ([212.27.42.4]:46266 "EHLO smtp4-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754024AbaJWIs3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 04:48:29 -0400
X-Mailbox-Line: From a73cd2fa53e3535ad75efc9978c4884f093f4b78 Mon Sep 17 00:00:00 2001
Message-Id: <a73cd2fa53e3535ad75efc9978c4884f093f4b78.1414053169.git.moinejf@free.fr>
In-Reply-To: <cover.1414053169.git.moinejf@free.fr>
References: <cover.1414053169.git.moinejf@free.fr>
From: Jean-Francois Moine <moinejf@free.fr>
Date: Thu, 23 Oct 2014 10:29:21 +0200
Subject: [PATCH v8 2/2] drm/i2c: tda998x: Use the HDMI audio CODEC interface
To: Mark Brown <broonie@kernel.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Dave Airlie <airlied@gmail.com>, Andrew Jackson <Andrew.Jackson@arm.com>,
        Jyri Sarha <jsarha@ti.com>, alsa-devel@alsa-project.org,
        devicetree@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the necessary functions to interface the HDMI audio CODEC.

Signed-off-by: Jean-Francois Moine <moinejf@free.fr>
---
 .../devicetree/bindings/drm/i2c/tda998x.txt        |  18 ++
 drivers/gpu/drm/i2c/Kconfig                        |   1 +
 drivers/gpu/drm/i2c/tda998x_drv.c                  | 264 ++++++++++++++++++++-
 3 files changed, 270 insertions(+), 13 deletions(-)

diff --git a/Documentation/devicetree/bindings/drm/i2c/tda998x.txt b/Documentation/devicetree/bindings/drm/i2c/tda998x.txt
index e9e4bce..e50e7cd 100644
--- a/Documentation/devicetree/bindings/drm/i2c/tda998x.txt
+++ b/Documentation/devicetree/bindings/drm/i2c/tda998x.txt
@@ -17,6 +17,20 @@ Optional properties:
   - video-ports: 24 bits value which defines how the video controller
 	output is wired to the TDA998x input - default: <0x230145>
 
+  - audio-ports: must contain one or two values selecting the source
+	in the audio port.
+	The source type is given by the corresponding entry in
+	the audio-port-names property.
+
+  - audio-port-names: must contain entries matching the entries in
+	the audio-ports property.
+	Each value may be "i2s" or "spdif", giving the type of
+	the audio source.
+
+  - #sound-dai-cells: must be set to <1> for use with the simple-card.
+	The TDA998x audio CODEC always defines two DAIs.
+	The DAI 0 is the S/PDIF input and the DAI 1 is the I2S input.
+
 Example:
 
 	tda998x: hdmi-encoder {
@@ -26,4 +40,8 @@ Example:
 		interrupts = <27 2>;		/* falling edge */
 		pinctrl-0 = <&pmx_camera>;
 		pinctrl-names = "default";
+
+		audio-ports = <0x04>, <0x03>;
+		audio-port-names = "spdif", "i2s";
+		#sound-dai-cells = <1>;
 	};
diff --git a/drivers/gpu/drm/i2c/Kconfig b/drivers/gpu/drm/i2c/Kconfig
index 4d341db..42ca744 100644
--- a/drivers/gpu/drm/i2c/Kconfig
+++ b/drivers/gpu/drm/i2c/Kconfig
@@ -22,6 +22,7 @@ config DRM_I2C_SIL164
 config DRM_I2C_NXP_TDA998X
 	tristate "NXP Semiconductors TDA998X HDMI encoder"
 	default m if DRM_TILCDC
+	select SND_SOC_HDMI_CODEC
 	help
 	  Support for NXP Semiconductors TDA998X HDMI encoders.
 
diff --git a/drivers/gpu/drm/i2c/tda998x_drv.c b/drivers/gpu/drm/i2c/tda998x_drv.c
index d476279..e558e1e 100644
--- a/drivers/gpu/drm/i2c/tda998x_drv.c
+++ b/drivers/gpu/drm/i2c/tda998x_drv.c
@@ -20,12 +20,14 @@
 #include <linux/module.h>
 #include <linux/irq.h>
 #include <sound/asoundef.h>
+#include <linux/platform_device.h>
 
 #include <drm/drmP.h>
 #include <drm/drm_crtc_helper.h>
 #include <drm/drm_encoder_slave.h>
 #include <drm/drm_edid.h>
 #include <drm/i2c/tda998x.h>
+#include <sound/hdmi.h>
 
 #define DBG(fmt, ...) DRM_DEBUG(fmt"\n", ##__VA_ARGS__)
 
@@ -44,6 +46,16 @@ struct tda998x_priv {
 	wait_queue_head_t wq_edid;
 	volatile int wq_edid_wait;
 	struct drm_encoder *encoder;
+
+	/* audio variables */
+	struct platform_device *pdev_codec;
+	u8 audio_ports[2];
+
+	u8 max_channels;		/* EDID parameters */
+	u8 rate_mask;
+	u8 fmt;
+
+	int audio_sample_format;
 };
 
 #define to_tda998x_priv(x)  ((struct tda998x_priv *)to_encoder_slave(x)->slave_priv)
@@ -624,6 +636,8 @@ tda998x_write_avi(struct tda998x_priv *priv, struct drm_display_mode *mode)
 			 sizeof(buf));
 }
 
+/* audio functions */
+
 static void tda998x_audio_mute(struct tda998x_priv *priv, bool on)
 {
 	if (on) {
@@ -639,12 +653,11 @@ static void
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
@@ -653,6 +666,7 @@ tda998x_configure_audio(struct tda998x_priv *priv,
 		clksel_aip = AIP_CLKSEL_AIP_SPDIF;
 		clksel_fs = AIP_CLKSEL_FS_FS64SPDIF;
 		cts_n = CTS_N_M(3) | CTS_N_K(3);
+		aclk = 0;				/* no clock */
 		break;
 
 	case AFMT_I2S:
@@ -660,6 +674,7 @@ tda998x_configure_audio(struct tda998x_priv *priv,
 		clksel_aip = AIP_CLKSEL_AIP_I2S;
 		clksel_fs = AIP_CLKSEL_FS_ACLK;
 		cts_n = CTS_N_M(3) | CTS_N_K(3);
+		aclk = 1;				/* clock enable */
 		break;
 
 	default:
@@ -671,6 +686,7 @@ tda998x_configure_audio(struct tda998x_priv *priv,
 	reg_clear(priv, REG_AIP_CNTRL_0, AIP_CNTRL_0_LAYOUT |
 					AIP_CNTRL_0_ACR_MAN);	/* auto CTS */
 	reg_write(priv, REG_CTS_N, cts_n);
+	reg_write(priv, REG_ENA_ACLK, aclk);
 
 	/*
 	 * Audio input somehow depends on HDMI line rate which is
@@ -727,6 +743,137 @@ tda998x_configure_audio(struct tda998x_priv *priv,
 	tda998x_write_aif(priv, p);
 }
 
+/* audio codec interface */
+
+/* return the audio parameters extracted from the last EDID */
+static int tda998x_get_audio(struct device *dev,
+			int *max_channels,
+			int *rate_mask,
+			int *fmt)
+{
+	struct tda998x_priv *priv = dev_get_drvdata(dev);
+
+	if (!priv->encoder->crtc)
+		return -ENODEV;
+
+	*max_channels = priv->max_channels;
+	*rate_mask = priv->rate_mask;
+	*fmt = priv->fmt;
+	return 0;
+}
+
+/* switch the audio port and initialize the audio parameters for streaming */
+static void tda998x_audio_switch(struct device *dev,
+				 int port_index,
+				 unsigned sample_rate,
+				 int sample_format)
+{
+	struct tda998x_priv *priv = dev_get_drvdata(dev);
+	struct tda998x_encoder_params *p = &priv->params;
+
+	if (!priv->encoder->crtc)
+		return;
+
+	/*
+	 * if port_index is negative (streaming stop),
+	 * disable the audio port
+	 */
+	if (port_index < 0) {
+		reg_write(priv, REG_ENA_AP, 0);
+		return;
+	}
+
+	/* if same audio parameters, just enable the audio port */
+	if (p->audio_cfg == priv->audio_ports[port_index] &&
+	    p->audio_sample_rate == sample_rate &&
+	    priv->audio_sample_format == sample_format) {
+		reg_write(priv, REG_ENA_AP, p->audio_cfg);
+		return;
+	}
+
+	p->audio_format = port_index;
+	p->audio_cfg = priv->audio_ports[port_index];
+	p->audio_sample_rate = sample_rate;
+	priv->audio_sample_format = sample_format;
+	tda998x_configure_audio(priv, &priv->encoder->crtc->hwmode, p);
+}
+
+#define TDA998X_FORMATS	(SNDRV_PCM_FMTBIT_S16_LE | \
+			SNDRV_PCM_FMTBIT_S20_3LE | \
+			SNDRV_PCM_FMTBIT_S24_LE | \
+			SNDRV_PCM_FMTBIT_S32_LE)
+
+static struct snd_soc_dai_driver tda998x_dais[] = {
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
+	},
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
+	},
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
+static struct snd_soc_codec_driver tda998x_codec_driver = {
+	.dapm_widgets = tda998x_widgets,
+	.num_dapm_widgets = ARRAY_SIZE(tda998x_widgets),
+	.dapm_routes = tda998x_routes,
+	.num_dapm_routes = ARRAY_SIZE(tda998x_routes),
+};
+
+static struct hdmi_data tda998x_hdmi_data = {
+	.get_audio = tda998x_get_audio,
+	.audio_switch = tda998x_audio_switch,
+	.ndais = ARRAY_SIZE(tda998x_dais),
+	.dais = tda998x_dais,
+	.driver = &tda998x_codec_driver,
+};
+
+static void tda998x_create_audio_codec(struct tda998x_priv *priv)
+{
+	struct platform_device *pdev;
+
+	pdev = platform_device_register_resndata(&priv->hdmi->dev,
+						 "hdmi-audio-codec",
+						  PLATFORM_DEVID_NONE,
+						  NULL, 0,
+						  &tda998x_hdmi_data,
+						  sizeof tda998x_hdmi_data);
+	if (IS_ERR(pdev)) {
+		dev_err(&priv->hdmi->dev, "cannot create codec: %ld\n",
+			PTR_ERR(pdev));
+		return;
+	}
+
+	priv->pdev_codec = pdev;
+}
+
 /* DRM encoder functions */
 
 static void tda998x_encoder_set_config(struct tda998x_priv *priv,
@@ -746,6 +893,8 @@ static void tda998x_encoder_set_config(struct tda998x_priv *priv,
 			    (p->mirr_f ? VIP_CNTRL_2_MIRR_F : 0);
 
 	priv->params = *p;
+	priv->audio_ports[p->audio_format] = p->audio_cfg;
+	priv->audio_sample_format = SNDRV_PCM_FORMAT_S24_LE;
 }
 
 static void tda998x_encoder_dpms(struct tda998x_priv *priv, int mode)
@@ -1128,6 +1277,47 @@ fail:
 	return NULL;
 }
 
+static void tda998x_set_audio(struct tda998x_priv *priv,
+			      struct drm_connector *connector)
+{
+	u8 *eld = connector->eld;
+	u8 *sad;
+	int sad_count;
+	unsigned eld_ver, mnl, rate_mask;
+	unsigned max_channels, fmt;
+
+	/* adjust the hw params from the ELD (EDID) */
+	eld_ver = eld[0] >> 3;
+	if (eld_ver != 2 && eld_ver != 31)
+		return;
+
+	mnl = eld[4] & 0x1f;
+	if (mnl > 16)
+		return;
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
+	priv->max_channels = max_channels;
+	priv->rate_mask = rate_mask;
+	priv->fmt = fmt;
+}
+
 static int
 tda998x_encoder_get_modes(struct tda998x_priv *priv,
 			  struct drm_connector *connector)
@@ -1139,6 +1329,12 @@ tda998x_encoder_get_modes(struct tda998x_priv *priv,
 		drm_mode_connector_update_edid_property(connector, edid);
 		n = drm_add_edid_modes(connector, edid);
 		priv->is_hdmi_sink = drm_detect_hdmi_monitor(edid);
+
+		/* set the audio parameters from the EDID */
+		if (priv->is_hdmi_sink) {
+			drm_edid_to_eld(connector, edid);
+			tda998x_set_audio(priv, connector);
+		}
 		kfree(edid);
 	}
 
@@ -1173,6 +1369,8 @@ static void tda998x_destroy(struct tda998x_priv *priv)
 	if (priv->hdmi->irq)
 		free_irq(priv->hdmi->irq, priv);
 
+	if (priv->pdev_codec)
+		platform_device_unregister(priv->pdev_codec);
 	i2c_unregister_device(priv->cec);
 }
 
@@ -1254,12 +1452,16 @@ static int tda998x_create(struct i2c_client *client, struct tda998x_priv *priv)
 {
 	struct device_node *np = client->dev.of_node;
 	u32 video;
-	int rev_lo, rev_hi, ret;
+	int i, j, rev_lo, rev_hi, ret;
+	const char *p;
 
 	priv->vip_cntrl_0 = VIP_CNTRL_0_SWAP_A(2) | VIP_CNTRL_0_SWAP_B(3);
 	priv->vip_cntrl_1 = VIP_CNTRL_1_SWAP_C(0) | VIP_CNTRL_1_SWAP_D(1);
 	priv->vip_cntrl_2 = VIP_CNTRL_2_SWAP_E(4) | VIP_CNTRL_2_SWAP_F(5);
 
+	priv->params.audio_frame[1] = 1;		/* channels - 1 */
+	priv->params.audio_sample_rate = 48000;		/* 48kHz */
+
 	priv->current_page = 0xff;
 	priv->hdmi = client;
 	priv->cec = i2c_new_dummy(client->adapter, 0x34);
@@ -1351,17 +1553,48 @@ static int tda998x_create(struct i2c_client *client, struct tda998x_priv *priv)
 	/* enable EDID read irq: */
 	reg_set(priv, REG_INT_FLAGS_2, INT_FLAGS_2_EDID_BLK_RD);
 
-	if (!np)
-		return 0;		/* non-DT */
+	/* get the device tree parameters */
+	if (np) {
+
+		/* optional video properties */
+		ret = of_property_read_u32(np, "video-ports", &video);
+		if (ret == 0) {
+			priv->vip_cntrl_0 = video >> 16;
+			priv->vip_cntrl_1 = video >> 8;
+			priv->vip_cntrl_2 = video;
+		}
+
+		/* audio properties */
+		for (i = 0; i < 2; i++) {
+			u32 port;
 
-	/* get the optional video properties */
-	ret = of_property_read_u32(np, "video-ports", &video);
-	if (ret == 0) {
-		priv->vip_cntrl_0 = video >> 16;
-		priv->vip_cntrl_1 = video >> 8;
-		priv->vip_cntrl_2 = video;
+			ret = of_property_read_u32_index(np, "audio-ports", i, &port);
+			if (ret)
+				break;
+			ret = of_property_read_string_index(np, "audio-port-names",
+							i, &p);
+			if (ret) {
+				dev_err(&client->dev,
+					"missing audio-port-names[%d]\n", i);
+				break;
+			}
+			if (strcmp(p, "spdif") == 0) {
+				j = AFMT_SPDIF;
+			} else if (strcmp(p, "i2s") == 0) {
+				j = AFMT_I2S;
+			} else {
+				dev_err(&client->dev,
+					"bad audio-port-names '%s'\n", p);
+				break;
+			}
+			priv->audio_ports[j] = port;
+		}
 	}
 
+	/* create the audio CODEC */
+	if (priv->audio_ports[AFMT_SPDIF] || priv->audio_ports[AFMT_I2S])
+		tda998x_create_audio_codec(priv);
+
 	return 0;
 
 fail:
@@ -1395,6 +1628,9 @@ static int tda998x_encoder_init(struct i2c_client *client,
 	encoder_slave->slave_priv = priv;
 	encoder_slave->slave_funcs = &tda998x_encoder_slave_funcs;
 
+	/* set the drvdata pointer for CODEC calls */
+	dev_set_drvdata(&client->dev, priv);
+
 	return 0;
 }
 
@@ -1521,7 +1757,7 @@ static int tda998x_bind(struct device *dev, struct device *master, void *data)
 	if (!priv)
 		return -ENOMEM;
 
-	dev_set_drvdata(dev, priv);
+	dev_set_drvdata(dev, &priv->base);
 
 	priv->base.encoder = &priv->encoder;
 	priv->connector.interlace_allowed = 1;
@@ -1571,7 +1807,9 @@ err_encoder:
 static void tda998x_unbind(struct device *dev, struct device *master,
 			   void *data)
 {
-	struct tda998x_priv2 *priv = dev_get_drvdata(dev);
+	struct tda998x_priv *priv_s = dev_get_drvdata(dev);
+	struct tda998x_priv2 *priv =
+			container_of(priv_s, struct tda998x_priv2, base);
 
 	drm_connector_cleanup(&priv->connector);
 	drm_encoder_cleanup(&priv->encoder);
-- 
2.1.1

