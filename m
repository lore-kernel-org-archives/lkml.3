Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933377AbaBARcj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Feb 2014 12:32:39 -0500
Received: from smtp2-g21.free.fr ([212.27.42.2]:59391 "EHLO smtp2-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933102AbaBARcT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Feb 2014 12:32:19 -0500
X-Mailbox-Line: From 387a65107f2f2e6ff484768d0424396357067b86 Mon Sep 17 00:00:00 2001
Message-Id: <387a65107f2f2e6ff484768d0424396357067b86.1391274628.git.moinejf@free.fr>
In-Reply-To: <cover.1391274627.git.moinejf@free.fr>
References: <cover.1391274627.git.moinejf@free.fr>
From: Jean-Francois Moine <moinejf@free.fr>
Date: Sun, 26 Jan 2014 19:02:37 +0100
Subject: [PATCH v3 1/5] drm/i2c: tda998x: add a function for dynamic audio
 input switch
To: alsa-devel@alsa-project.org
Cc: broonie@kernel.org, Dave Airlie <airlied@gmail.com>,
        dri-devel@lists.freedesktop.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Rob Clark <robdclark@gmail.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When both I2S and S/PDIF are wired from the audio device to the
TDA998x, the user or some internal mechanism may choose to do audio
streaming via either inputs.

This patch adds an exported function in the TDA998x driver which
initializes the audio input parameters according to the audio
subsystem.

The audio format values in the encoder configuration interface  are
changed to non null values so that the value 0 is used in the audio
function to indicate that audio streaming is stopped.

As the audio clock depends on the input type, it is set so.
Then, the configuration value audio_clk_cfg is now ignored.

Signed-off-by: Jean-Francois Moine <moinejf@free.fr>
---
 drivers/gpu/drm/i2c/tda998x_drv.c | 48 ++++++++++++++++++++++++++++++++++++---
 include/drm/i2c/tda998x.h         |  7 ++++--
 2 files changed, 50 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/i2c/tda998x_drv.c b/drivers/gpu/drm/i2c/tda998x_drv.c
index 2f97290..2643be4 100644
--- a/drivers/gpu/drm/i2c/tda998x_drv.c
+++ b/drivers/gpu/drm/i2c/tda998x_drv.c
@@ -35,6 +35,7 @@ struct tda998x_priv {
 	struct i2c_client *hdmi;
 	uint16_t rev;
 	uint8_t current_page;
+	u8 audio_active;
 	int dpms;
 	bool is_hdmi_sink;
 	u8 vip_cntrl_0;
@@ -640,12 +641,11 @@ static void
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
@@ -654,6 +654,7 @@ tda998x_configure_audio(struct tda998x_priv *priv,
 		clksel_aip = AIP_CLKSEL_AIP_SPDIF;
 		clksel_fs = AIP_CLKSEL_FS_FS64SPDIF;
 		cts_n = CTS_N_M(3) | CTS_N_K(3);
+		aclk = 0;				/* no clock */
 		break;
 
 	case AFMT_I2S:
@@ -661,6 +662,7 @@ tda998x_configure_audio(struct tda998x_priv *priv,
 		clksel_aip = AIP_CLKSEL_AIP_I2S;
 		clksel_fs = AIP_CLKSEL_FS_ACLK;
 		cts_n = CTS_N_M(3) | CTS_N_K(3);
+		aclk = 1;				/* clock enable */
 		break;
 
 	default:
@@ -672,6 +674,7 @@ tda998x_configure_audio(struct tda998x_priv *priv,
 	reg_clear(priv, REG_AIP_CNTRL_0, AIP_CNTRL_0_LAYOUT |
 					AIP_CNTRL_0_ACR_MAN);	/* auto CTS */
 	reg_write(priv, REG_CTS_N, cts_n);
+	reg_write(priv, REG_ENA_ACLK, aclk);
 
 	/*
 	 * Audio input somehow depends on HDMI line rate which is
@@ -728,6 +731,37 @@ tda998x_configure_audio(struct tda998x_priv *priv,
 	tda998x_write_aif(priv, p);
 }
 
+/* tda998x codec interface */
+void tda998x_audio_update(struct i2c_client *client,
+			int format,
+			int port)
+{
+	struct tda998x_priv *priv = i2c_get_clientdata(client);
+	struct tda998x_encoder_params *p = &priv->params;
+
+	/* if the audio output is active, it may be a second start or a stop */
+	if (format == 0 || priv->audio_active) {
+		if (format == 0) {
+			priv->audio_active = 0;
+			reg_write(priv, REG_ENA_AP, 0);
+		}
+		return;
+	}
+	priv->audio_active = 1;
+
+	p->audio_cfg = port;
+
+	/* don't restart audio if same input format */
+	if (format == p->audio_format) {
+		reg_write(priv, REG_ENA_AP, p->audio_cfg);
+		return;
+	}
+	p->audio_format = format;
+
+	tda998x_configure_audio(priv, &priv->encoder->crtc->hwmode, p);
+}
+EXPORT_SYMBOL_GPL(tda998x_audio_update);
+
 /* DRM encoder functions */
 
 static void
@@ -750,6 +784,9 @@ tda998x_encoder_set_config(struct drm_encoder *encoder, void *params)
 			    (p->mirr_f ? VIP_CNTRL_2_MIRR_F : 0);
 
 	priv->params = *p;
+
+	if (p->audio_cfg)
+		priv->audio_active = 1;
 }
 
 static void
@@ -999,7 +1036,7 @@ tda998x_encoder_mode_set(struct drm_encoder *encoder,
 
 		tda998x_write_avi(priv, adjusted_mode);
 
-		if (priv->params.audio_cfg)
+		if (priv->audio_active)
 			tda998x_configure_audio(priv, adjusted_mode,
 						&priv->params);
 	}
@@ -1239,10 +1276,15 @@ tda998x_encoder_init(struct i2c_client *client,
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
diff --git a/include/drm/i2c/tda998x.h b/include/drm/i2c/tda998x.h
index 3e419d9..7e4806d 100644
--- a/include/drm/i2c/tda998x.h
+++ b/include/drm/i2c/tda998x.h
@@ -20,11 +20,14 @@ struct tda998x_encoder_params {
 	u8 audio_frame[6];
 
 	enum {
-		AFMT_SPDIF,
-		AFMT_I2S
+		AFMT_I2S = 1,
+		AFMT_SPDIF
 	} audio_format;
 
 	unsigned audio_sample_rate;
 };
 
+void tda998x_audio_update(struct i2c_client *client,
+			int format,
+			int port);
 #endif
-- 
1.9.rc1

