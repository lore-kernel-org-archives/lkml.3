Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752373AbaASTCF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Jan 2014 14:02:05 -0500
Received: from smtp2-g21.free.fr ([212.27.42.2]:35620 "EHLO smtp2-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751696AbaASTCB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Jan 2014 14:02:01 -0500
Date: Sun, 19 Jan 2014 19:58:43 +0100
From: Jean-Francois Moine <moinejf@free.fr>
To: dri-devel@lists.freedesktop.org
Cc: Dave Airlie <airlied@gmail.com>, Rob Clark <robdclark@gmail.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Russell King - ARM Linux <linux@arm.linux.org.uk>
Subject: [PATCH v3 13/24] drm/i2c: tda998x: fix a NULL pointer dereference
Message-ID: <20140119195843.59810a46@armhf>
In-Reply-To: <cover.1390153344.git.moinejf@free.fr>
References: <cover.1390153344.git.moinejf@free.fr>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; arm-unknown-linux-gnueabihf)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes a NULL pointer dereference when the set_config
function has not been called (priv->params == NULL).

As a side effect, now, the audio sample rate is always 48kHz and the
audio clock is always set for I2S, and never set for S/PDIF.

The audio_format enum is modified so that this format is not null when
audio is configured.

Signed-off-by: Jean-Francois Moine <moinejf@free.fr>
---
 drivers/gpu/drm/i2c/tda998x_drv.c | 46 +++++++++++++++++++++++++--------------
 include/drm/i2c/tda998x.h         |  4 ++--
 2 files changed, 32 insertions(+), 18 deletions(-)

diff --git a/drivers/gpu/drm/i2c/tda998x_drv.c b/drivers/gpu/drm/i2c/tda998x_drv.c
index a3ebc08..d3e2bb9 100644
--- a/drivers/gpu/drm/i2c/tda998x_drv.c
+++ b/drivers/gpu/drm/i2c/tda998x_drv.c
@@ -28,6 +28,8 @@
 
 #define DBG(fmt, ...) DRM_DEBUG(fmt"\n", ##__VA_ARGS__)
 
+#define AUDIO_SAMPLE 48000
+
 struct tda998x_priv {
 	struct i2c_client *cec;
 	struct i2c_client *hdmi;
@@ -38,7 +40,10 @@ struct tda998x_priv {
 	u8 vip_cntrl_0;
 	u8 vip_cntrl_1;
 	u8 vip_cntrl_2;
-	struct tda998x_encoder_params params;
+
+	u8 audio_format;
+	u8 audio_frame[6];
+	u32 audio_port;
 };
 
 #define to_tda998x_priv(x)  ((struct tda998x_priv *)to_encoder_slave(x)->slave_priv)
@@ -547,7 +552,7 @@ tda998x_write_if(struct tda998x_priv *priv, uint8_t bit, uint16_t addr,
 }
 
 static void
-tda998x_write_aif(struct tda998x_priv *priv, struct tda998x_encoder_params *p)
+tda998x_write_aif(struct tda998x_priv *priv)
 {
 	u8 buf[PB(HDMI_AUDIO_INFOFRAME_SIZE) + 1];
 
@@ -555,10 +560,10 @@ tda998x_write_aif(struct tda998x_priv *priv, struct tda998x_encoder_params *p)
 	buf[HB(0)] = HDMI_INFOFRAME_TYPE_AUDIO;
 	buf[HB(1)] = 0x01;
 	buf[HB(2)] = HDMI_AUDIO_INFOFRAME_SIZE;
-	buf[PB(1)] = p->audio_frame[1] & 0x07; /* CC */
-	buf[PB(2)] = p->audio_frame[2] & 0x1c; /* SF */
-	buf[PB(4)] = p->audio_frame[4];
-	buf[PB(5)] = p->audio_frame[5] & 0xf8; /* DM_INH + LSV */
+	buf[PB(1)] = priv->audio_frame[1] & 0x07; /* CC */
+	buf[PB(2)] = priv->audio_frame[2] & 0x1c; /* SF */
+	buf[PB(4)] = priv->audio_frame[4];
+	buf[PB(5)] = priv->audio_frame[5] & 0xf8; /* DM_INH + LSV */
 
 	tda998x_write_if(priv, DIP_IF_FLAGS_IF4, REG_IF4_HB0, buf,
 			 sizeof(buf));
@@ -594,23 +599,23 @@ static void tda998x_audio_mute(struct tda998x_priv *priv, bool on)
 
 static void
 tda998x_configure_audio(struct tda998x_priv *priv,
-		struct drm_display_mode *mode, struct tda998x_encoder_params *p)
+		struct drm_display_mode *mode)
 {
 	uint8_t buf[6], clksel_aip, clksel_fs, ca_i2s, cts_n, adiv;
-	uint32_t n;
+	uint32_t aclk, n;
 
 	/* Enable audio ports */
-	reg_write(priv, REG_ENA_AP, p->audio_cfg);
-	reg_write(priv, REG_ENA_ACLK, p->audio_clk_cfg);
+	reg_write(priv, REG_ENA_AP, priv->audio_port);
 
 	/* Set audio input source */
-	switch (p->audio_format) {
+	switch (priv->audio_format) {
 	case AFMT_SPDIF:
 		reg_write(priv, REG_MUX_AP, 0x40);
 		clksel_aip = AIP_CLKSEL_AIP(0);
 		/* FS64SPDIF */
 		clksel_fs = AIP_CLKSEL_FS(2);
 		cts_n = CTS_N_M(3) | CTS_N_K(3);
+		aclk = 0;				/* no clock */
 		ca_i2s = 0;
 		break;
 
@@ -620,6 +625,7 @@ tda998x_configure_audio(struct tda998x_priv *priv,
 		/* ACLK */
 		clksel_fs = AIP_CLKSEL_FS(0);
 		cts_n = CTS_N_M(3) | CTS_N_K(3);
+		aclk = 1;				/* clock enable */
 		ca_i2s = CA_I2S_CA_I2S(0);
 		break;
 
@@ -634,6 +640,7 @@ tda998x_configure_audio(struct tda998x_priv *priv,
 	/* Enable automatic CTS generation */
 	reg_clear(priv, REG_AIP_CNTRL_0, AIP_CNTRL_0_ACR_MAN);
 	reg_write(priv, REG_CTS_N, cts_n);
+	reg_write(priv, REG_ENA_ACLK, aclk);
 
 	/*
 	 * Audio input somehow depends on HDMI line rate which is
@@ -652,7 +659,7 @@ tda998x_configure_audio(struct tda998x_priv *priv,
 	 * This is the approximate value of N, which happens to be
 	 * the recommended values for non-coherent clocks.
 	 */
-	n = 128 * p->audio_sample_rate / 1000;
+	n = 128 * AUDIO_SAMPLE / 1000;
 
 	/* Write the CTS and N values */
 	buf[0] = 0x44;
@@ -682,7 +689,7 @@ tda998x_configure_audio(struct tda998x_priv *priv,
 	tda998x_audio_mute(priv, false);
 
 	/* Write the audio information packet */
-	tda998x_write_aif(priv, p);
+	tda998x_write_aif(priv);
 }
 
 /* DRM encoder functions */
@@ -706,7 +713,13 @@ tda998x_encoder_set_config(struct drm_encoder *encoder, void *params)
 			    VIP_CNTRL_2_SWAP_F(p->swap_f) |
 			    (p->mirr_f ? VIP_CNTRL_2_MIRR_F : 0);
 
-	priv->params = *p;
+	memcpy(priv->audio_frame, p->audio_frame,
+			sizeof priv->audio_frame);
+
+	if (p->audio_cfg) {
+		priv->audio_port = p->audio_cfg;
+		priv->audio_format = p->audio_format;
+	}
 }
 
 static void
@@ -954,8 +967,8 @@ tda998x_encoder_mode_set(struct drm_encoder *encoder,
 
 		tda998x_write_avi(priv, adj_mode);
 
-		if (priv->params.audio_cfg)
-			tda998x_configure_audio(priv, adj_mode, &priv->params);
+		if (priv->audio_format)
+			tda998x_configure_audio(priv, adj_mode);
 	}
 }
 
@@ -1173,6 +1186,7 @@ tda998x_encoder_init(struct i2c_client *client,
 	priv->vip_cntrl_0 = VIP_CNTRL_0_SWAP_A(2) | VIP_CNTRL_0_SWAP_B(3);
 	priv->vip_cntrl_1 = VIP_CNTRL_1_SWAP_C(0) | VIP_CNTRL_1_SWAP_D(1);
 	priv->vip_cntrl_2 = VIP_CNTRL_2_SWAP_E(4) | VIP_CNTRL_2_SWAP_F(5);
+	priv->audio_frame[1] = 1;		/* channels - 1 */
 
 	priv->current_page = 0xff;
 	priv->hdmi = client;
diff --git a/include/drm/i2c/tda998x.h b/include/drm/i2c/tda998x.h
index 3e419d9..d469b07 100644
--- a/include/drm/i2c/tda998x.h
+++ b/include/drm/i2c/tda998x.h
@@ -20,8 +20,8 @@ struct tda998x_encoder_params {
 	u8 audio_frame[6];
 
 	enum {
-		AFMT_SPDIF,
-		AFMT_I2S
+		AFMT_I2S = 1,
+		AFMT_SPDIF
 	} audio_format;
 
 	unsigned audio_sample_rate;
-- 
1.8.5.3

