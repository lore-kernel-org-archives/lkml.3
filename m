Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751721AbaHaNda (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Aug 2014 09:33:30 -0400
Received: from smtp2-g21.free.fr ([212.27.42.2]:9163 "EHLO smtp2-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751667AbaHaNd1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Aug 2014 09:33:27 -0400
X-Mailbox-Line: From 23c70e08b14862bff75ca62e52f8ff69e8f9bc70 Mon Sep 17 00:00:00 2001
Message-Id: <23c70e08b14862bff75ca62e52f8ff69e8f9bc70.1409490122.git.moinejf@free.fr>
In-Reply-To: <cover.1409490122.git.moinejf@free.fr>
References: <cover.1409490122.git.moinejf@free.fr>
From: Jean-Francois Moine <moinejf@free.fr>
Date: Sun, 31 Aug 2014 14:35:39 +0200
Subject: [PATCH v4 2/2] drm/i2c:tda998x: Use the HDMI2 audio CODEC
To: Mark Brown <broonie@kernel.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Andrew Jackson <Andrew.Jackson@arm.com>, alsa-devel@alsa-project.org,
        devicetree@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds an audio CODEC function to the NXP TDA998x transmitter.

Signed-off-by: Jean-Francois Moine <moinejf@free.fr>
---
 drivers/gpu/drm/i2c/Kconfig       |   1 +
 drivers/gpu/drm/i2c/tda998x_drv.c | 142 +++++++++++++++++++++++++++++++++++---
 2 files changed, 135 insertions(+), 8 deletions(-)

diff --git a/drivers/gpu/drm/i2c/Kconfig b/drivers/gpu/drm/i2c/Kconfig
index 4d341db..fa79cd3 100644
--- a/drivers/gpu/drm/i2c/Kconfig
+++ b/drivers/gpu/drm/i2c/Kconfig
@@ -22,6 +22,7 @@ config DRM_I2C_SIL164
 config DRM_I2C_NXP_TDA998X
 	tristate "NXP Semiconductors TDA998X HDMI encoder"
 	default m if DRM_TILCDC
+	select SND_SOC_HDMI2
 	help
 	  Support for NXP Semiconductors TDA998X HDMI encoders.
 
diff --git a/drivers/gpu/drm/i2c/tda998x_drv.c b/drivers/gpu/drm/i2c/tda998x_drv.c
index d476279..5f86b4d 100644
--- a/drivers/gpu/drm/i2c/tda998x_drv.c
+++ b/drivers/gpu/drm/i2c/tda998x_drv.c
@@ -27,6 +27,9 @@
 #include <drm/drm_edid.h>
 #include <drm/i2c/tda998x.h>
 
+#include <sound/pcm_params.h>
+#include <sound/hdmi2.h>
+
 #define DBG(fmt, ...) DRM_DEBUG(fmt"\n", ##__VA_ARGS__)
 
 struct tda998x_priv {
@@ -44,9 +47,13 @@ struct tda998x_priv {
 	wait_queue_head_t wq_edid;
 	volatile int wq_edid_wait;
 	struct drm_encoder *encoder;
+
+	struct hdmi2_codec audio;
 };
 
 #define to_tda998x_priv(x)  ((struct tda998x_priv *)to_encoder_slave(x)->slave_priv)
+#define audio_priv(x) \
+		container_of(audio, struct tda998x_priv, audio)
 
 /* The TDA9988 series of devices use a paged register scheme.. to simplify
  * things we encode the page # in upper bits of the register #.  To read/
@@ -639,27 +646,42 @@ static void
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
-	switch (p->audio_format) {
-	case AFMT_SPDIF:
+	switch (priv->audio.source) {
+	case HDMI2_SPDIF:
 		reg_write(priv, REG_MUX_AP, MUX_AP_SELECT_SPDIF);
 		clksel_aip = AIP_CLKSEL_AIP_SPDIF;
 		clksel_fs = AIP_CLKSEL_FS_FS64SPDIF;
 		cts_n = CTS_N_M(3) | CTS_N_K(3);
+		aclk = 0;				/* no clock */
 		break;
 
-	case AFMT_I2S:
+	case HDMI2_I2S:
 		reg_write(priv, REG_MUX_AP, MUX_AP_SELECT_I2S);
 		clksel_aip = AIP_CLKSEL_AIP_I2S;
 		clksel_fs = AIP_CLKSEL_FS_ACLK;
 		cts_n = CTS_N_M(3) | CTS_N_K(3);
+		/* with I2S input, the CTS_N predivider depends on
+		 * the sample width */
+		switch (priv->audio.sample_format) {
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
@@ -671,6 +693,7 @@ tda998x_configure_audio(struct tda998x_priv *priv,
 	reg_clear(priv, REG_AIP_CNTRL_0, AIP_CNTRL_0_LAYOUT |
 					AIP_CNTRL_0_ACR_MAN);	/* auto CTS */
 	reg_write(priv, REG_CTS_N, cts_n);
+	reg_write(priv, REG_ENA_ACLK, aclk);
 
 	/*
 	 * Audio input somehow depends on HDMI line rate which is
@@ -684,7 +707,7 @@ tda998x_configure_audio(struct tda998x_priv *priv,
 		adiv++;			/* AUDIO_DIV_SERCLK_16 */
 
 	/* S/PDIF asks for a larger divider */
-	if (p->audio_format == AFMT_SPDIF)
+	if (priv->audio.source == HDMI2_SPDIF)
 		adiv++;			/* AUDIO_DIV_SERCLK_16 or _32 */
 
 	reg_write(priv, REG_AUDIO_DIV, adiv);
@@ -693,7 +716,7 @@ tda998x_configure_audio(struct tda998x_priv *priv,
 	 * This is the approximate value of N, which happens to be
 	 * the recommended values for non-coherent clocks.
 	 */
-	n = 128 * p->audio_sample_rate / 1000;
+	n = 128 * priv->audio.sample_rate / 1000;
 
 	/* Write the CTS and N values */
 	buf[0] = 0x44;
@@ -727,6 +750,30 @@ tda998x_configure_audio(struct tda998x_priv *priv,
 	tda998x_write_aif(priv, p);
 }
 
+/* hdmi2 codec interface */
+void tda998x_audio_start(struct hdmi2_codec *audio,
+			 int full)
+{
+	struct tda998x_priv *priv = audio_priv(audio);
+	struct tda998x_encoder_params *p = &priv->params;
+
+	if (!priv->encoder->crtc)
+		return;
+	p->audio_cfg = audio->ports[audio->source];
+	if (!full) {
+		reg_write(priv, REG_ENA_AP, p->audio_cfg);
+		return;
+	}
+	tda998x_configure_audio(priv, &priv->encoder->crtc->hwmode, p);
+}
+
+void tda998x_audio_stop(struct hdmi2_codec *audio)
+{
+	struct tda998x_priv *priv = audio_priv(audio);
+
+	reg_write(priv, REG_ENA_AP, 0);
+}
+
 /* DRM encoder functions */
 
 static void tda998x_encoder_set_config(struct tda998x_priv *priv,
@@ -746,6 +793,9 @@ static void tda998x_encoder_set_config(struct tda998x_priv *priv,
 			    (p->mirr_f ? VIP_CNTRL_2_MIRR_F : 0);
 
 	priv->params = *p;
+	priv->audio.source = p->audio_format == AFMT_I2S ?
+					HDMI2_I2S : HDMI2_SPDIF;
+	priv->audio.sample_rate = p->audio_sample_rate;
 }
 
 static void tda998x_encoder_dpms(struct tda998x_priv *priv, int mode)
@@ -1128,6 +1178,64 @@ fail:
 	return NULL;
 }
 
+static void tda998x_set_audio(struct hdmi2_codec *audio,
+				struct drm_connector *connector)
+{
+	u8 *eld = connector->eld;
+	u8 *sad;
+	int sad_count;
+	unsigned eld_ver, mnl, rate_mask;
+	unsigned max_channels, fmt;
+	u64 formats;
+	struct snd_pcm_hw_constraint_list *rate_constraints =
+			&audio->rate_constraints;
+	static const u32 hdmi_rates[] = {
+		32000, 44100, 48000, 88200, 96000, 176400, 192000
+	};
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
+	/* set the constraints */
+	rate_constraints->list = hdmi_rates;
+	rate_constraints->count = ARRAY_SIZE(hdmi_rates);
+	rate_constraints->mask = rate_mask;
+
+	formats = 0;
+	if (fmt & 1)
+		formats |= SNDRV_PCM_FMTBIT_S16_LE;
+	if (fmt & 2)
+		formats |= SNDRV_PCM_FMTBIT_S20_3LE;
+	if (fmt & 4)
+		formats |= SNDRV_PCM_FMTBIT_S24_LE;
+	audio->formats = formats;
+	audio->max_channels = max_channels;
+}
+
 static int
 tda998x_encoder_get_modes(struct tda998x_priv *priv,
 			  struct drm_connector *connector)
@@ -1139,6 +1247,13 @@ tda998x_encoder_get_modes(struct tda998x_priv *priv,
 		drm_mode_connector_update_edid_property(connector, edid);
 		n = drm_add_edid_modes(connector, edid);
 		priv->is_hdmi_sink = drm_detect_hdmi_monitor(edid);
+
+		/* set the audio parameters from the EDID */
+		if (priv->is_hdmi_sink) {
+			drm_edid_to_eld(connector, edid);
+			tda998x_set_audio(&priv->audio, connector);
+		}
+
 		kfree(edid);
 	}
 
@@ -1167,12 +1282,14 @@ tda998x_encoder_set_property(struct drm_encoder *encoder,
 
 static void tda998x_destroy(struct tda998x_priv *priv)
 {
+	struct i2c_client *client = priv->hdmi;
+
 	/* disable all IRQs and free the IRQ handler */
 	cec_write(priv, REG_CEC_RXSHPDINTENA, 0);
 	reg_clear(priv, REG_INT_FLAGS_2, INT_FLAGS_2_EDID_BLK_RD);
 	if (priv->hdmi->irq)
 		free_irq(priv->hdmi->irq, priv);
-
+	hdmi2_codec_unregister(&client->dev);
 	i2c_unregister_device(priv->cec);
 }
 
@@ -1260,6 +1377,9 @@ static int tda998x_create(struct i2c_client *client, struct tda998x_priv *priv)
 	priv->vip_cntrl_1 = VIP_CNTRL_1_SWAP_C(0) | VIP_CNTRL_1_SWAP_D(1);
 	priv->vip_cntrl_2 = VIP_CNTRL_2_SWAP_E(4) | VIP_CNTRL_2_SWAP_F(5);
 
+	priv->params.audio_frame[1] = 1;		/* channels - 1 */
+	priv->audio.sample_rate = 48000;		/* 48kHz */
+
 	priv->current_page = 0xff;
 	priv->hdmi = client;
 	priv->cec = i2c_new_dummy(client->adapter, 0x34);
@@ -1351,6 +1471,12 @@ static int tda998x_create(struct i2c_client *client, struct tda998x_priv *priv)
 	/* enable EDID read irq: */
 	reg_set(priv, REG_INT_FLAGS_2, INT_FLAGS_2_EDID_BLK_RD);
 
+	/* register the HDMI2 audio CODEC */
+	priv->audio.start = tda998x_audio_start;
+	priv->audio.stop = tda998x_audio_stop;
+	i2c_set_clientdata(client, &priv->audio);
+	hdmi2_codec_register(&client->dev);
+
 	if (!np)
 		return 0;		/* non-DT */
 
-- 
2.1.0

