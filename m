Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753491AbaA0Jg0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 04:36:26 -0500
Received: from smtp6-g21.free.fr ([212.27.42.6]:47516 "EHLO smtp6-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751275AbaA0JgX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 04:36:23 -0500
X-Mailbox-Line: From aeba4076f81f896697e1f8bfeb193fa1774487f6 Mon Sep 17 00:00:00 2001
Message-Id: <aeba4076f81f896697e1f8bfeb193fa1774487f6.1390813481.git.moinejf@free.fr>
In-Reply-To: <cover.1390813480.git.moinejf@free.fr>
References: <cover.1390813480.git.moinejf@free.fr>
From: Jean-Francois Moine <moinejf@free.fr>
Date: Sun, 26 Jan 2014 19:02:37 +0100
Subject: [PATCH 1/4] drm/i2c: tda998x: add a function for dynamic audio input
 switch
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

Signed-off-by: Jean-Francois Moine <moinejf@free.fr>
---
 drivers/gpu/drm/i2c/tda998x_drv.c | 43 ++++++++++++++++++++++++++++++++++++++-
 include/drm/i2c/tda998x.h         |  7 +++++--
 2 files changed, 47 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/i2c/tda998x_drv.c b/drivers/gpu/drm/i2c/tda998x_drv.c
index e5bbaf2..186c751 100644
--- a/drivers/gpu/drm/i2c/tda998x_drv.c
+++ b/drivers/gpu/drm/i2c/tda998x_drv.c
@@ -34,6 +34,7 @@ struct tda998x_priv {
 	struct i2c_client *hdmi;
 	uint16_t rev;
 	uint8_t current_page;
+	u8 audio_active;
 	int dpms;
 	bool is_hdmi_sink;
 	u8 vip_cntrl_0;
@@ -729,6 +730,38 @@ tda998x_configure_audio(struct tda998x_priv *priv,
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
+
+	p->audio_cfg = port;
+
+	/* don't restart audio if same input format */
+	if (format == p->audio_format) {
+		priv->audio_active = 1;
+		reg_write(priv, REG_ENA_AP, p->audio_cfg);
+		return;
+	}
+	p->audio_format = format;
+	priv->audio_active = 1;
+
+	tda998x_configure_audio(priv, &priv->encoder->crtc->hwmode, p);
+}
+EXPORT_SYMBOL_GPL(tda998x_audio_update);
+
 /* DRM encoder functions */
 
 static void
@@ -751,6 +784,9 @@ tda998x_encoder_set_config(struct drm_encoder *encoder, void *params)
 			    (p->mirr_f ? VIP_CNTRL_2_MIRR_F : 0);
 
 	priv->params = *p;
+
+	if (p->audio_cfg)
+		priv->audio_active = 1;
 }
 
 static void
@@ -1001,7 +1037,7 @@ tda998x_encoder_mode_set(struct drm_encoder *encoder,
 
 		tda998x_write_avi(priv, adj_mode);
 
-		if (priv->params.audio_cfg)
+		if (priv->audio_active)
 			tda998x_configure_audio(priv, adj_mode, &priv->params);
 	}
 }
@@ -1233,10 +1269,15 @@ tda998x_encoder_init(struct i2c_client *client,
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
index f3bb25c..0459931 100644
--- a/include/drm/i2c/tda998x.h
+++ b/include/drm/i2c/tda998x.h
@@ -19,11 +19,14 @@ struct tda998x_encoder_params {
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
1.8.5.3

