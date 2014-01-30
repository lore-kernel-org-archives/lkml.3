Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933448AbaBARdT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Feb 2014 12:33:19 -0500
Received: from smtp2-g21.free.fr ([212.27.42.2]:42833 "EHLO smtp2-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933346AbaBARdP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Feb 2014 12:33:15 -0500
X-Mailbox-Line: From df65a2de7d4afc2471846c02b73e8bbdc4f9a743 Mon Sep 17 00:00:00 2001
Message-Id: <df65a2de7d4afc2471846c02b73e8bbdc4f9a743.1391274628.git.moinejf@free.fr>
In-Reply-To: <cover.1391274627.git.moinejf@free.fr>
References: <cover.1391274627.git.moinejf@free.fr>
From: Jean-Francois Moine <moinejf@free.fr>
Date: Thu, 30 Jan 2014 12:08:06 +0100
Subject: [PATCH v3 5/5] ASoC: tda998x: adjust the audio CTS_N pre-divider from
 audio format
To: alsa-devel@alsa-project.org
Cc: broonie@kernel.org, Dave Airlie <airlied@gmail.com>,
        dri-devel@lists.freedesktop.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Rob Clark <robdclark@gmail.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In some boards, with I2S input, the NXP TDA998x HDMI transmitter did
not play audio streams with a sample width lower than S16_32.

This patch adjusts the CTS_N predivider according to the used sample
width.

Signed-off-by: Jean-Francois Moine <moinejf@free.fr>
---
 drivers/gpu/drm/i2c/tda998x_drv.c | 25 +++++++++++++++++++++----
 include/drm/i2c/tda998x.h         |  5 ++++-
 sound/soc/codecs/tda998x.c        | 18 ++++++++++++++----
 3 files changed, 39 insertions(+), 9 deletions(-)

diff --git a/drivers/gpu/drm/i2c/tda998x_drv.c b/drivers/gpu/drm/i2c/tda998x_drv.c
index b833fa5..66013ba 100644
--- a/drivers/gpu/drm/i2c/tda998x_drv.c
+++ b/drivers/gpu/drm/i2c/tda998x_drv.c
@@ -22,6 +22,7 @@
 #include <linux/irq.h>
 #include <linux/of_platform.h>
 #include <sound/asoundef.h>
+#include <sound/pcm_params.h>
 
 #include <drm/drmP.h>
 #include <drm/drm_crtc_helper.h>
@@ -48,6 +49,8 @@ struct tda998x_priv {
 	volatile int wq_edid_wait;
 	struct drm_encoder *encoder;
 
+	int audio_sample_format;
+
 	u8 *eld;
 };
 
@@ -664,7 +667,18 @@ tda998x_configure_audio(struct tda998x_priv *priv,
 		reg_write(priv, REG_MUX_AP, MUX_AP_SELECT_I2S);
 		clksel_aip = AIP_CLKSEL_AIP_I2S;
 		clksel_fs = AIP_CLKSEL_FS_ACLK;
-		cts_n = CTS_N_M(3) | CTS_N_K(3);
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
 		aclk = 1;				/* clock enable */
 		break;
 
@@ -745,13 +759,14 @@ EXPORT_SYMBOL_GPL(tda998x_audio_get_eld);
 
 void tda998x_audio_update(struct i2c_client *client,
 			int format,
-			int port)
+			int port,
+			struct snd_pcm_hw_params *params)
 {
 	struct tda998x_priv *priv = i2c_get_clientdata(client);
 	struct tda998x_encoder_params *p = &priv->params;
 
 	/* if the audio output is active, it may be a second start or a stop */
-	if (format == 0 || priv->audio_active) {
+	if (format == 0 || !params || priv->audio_active) {
 		if (format == 0) {
 			priv->audio_active = 0;
 			reg_write(priv, REG_ENA_AP, 0);
@@ -763,11 +778,13 @@ void tda998x_audio_update(struct i2c_client *client,
 	p->audio_cfg = port;
 
 	/* don't restart audio if same input format */
-	if (format == p->audio_format) {
+	if (format == p->audio_format &&
+	    params_format(params) == priv->audio_sample_format) {
 		reg_write(priv, REG_ENA_AP, p->audio_cfg);
 		return;
 	}
 	p->audio_format = format;
+	priv->audio_sample_format = params_format(params);
 
 	tda998x_configure_audio(priv, &priv->encoder->crtc->hwmode, p);
 }
diff --git a/include/drm/i2c/tda998x.h b/include/drm/i2c/tda998x.h
index 99387ae..62b838f 100644
--- a/include/drm/i2c/tda998x.h
+++ b/include/drm/i2c/tda998x.h
@@ -27,8 +27,11 @@ struct tda998x_encoder_params {
 	unsigned audio_sample_rate;
 };
 
+struct snd_pcm_hw_params;
+
 u8 *tda998x_audio_get_eld(struct i2c_client *client);
 void tda998x_audio_update(struct i2c_client *client,
 			int format,
-			int port);
+			int port,
+			struct snd_pcm_hw_params *params);
 #endif
diff --git a/sound/soc/codecs/tda998x.c b/sound/soc/codecs/tda998x.c
index 0493163..a1de35d 100644
--- a/sound/soc/codecs/tda998x.c
+++ b/sound/soc/codecs/tda998x.c
@@ -47,7 +47,8 @@ static int tda_get_encoder(struct tda_priv *priv)
 	return 0;
 }
 
-static int tda_start_stop(struct tda_priv *priv)
+static int tda_start_stop(struct tda_priv *priv,
+			struct snd_pcm_hw_params *params)
 {
 	int port;
 
@@ -56,7 +57,7 @@ static int tda_start_stop(struct tda_priv *priv)
 		port = priv->ports[0];
 	else
 		port = priv->ports[1];
-	tda998x_audio_update(priv->i2c_client, priv->dai_id, port);
+	tda998x_audio_update(priv->i2c_client, priv->dai_id, port, params);
 	return 0;
 }
 
@@ -136,9 +137,17 @@ static int tda_startup(struct snd_pcm_substream *substream,
 		stream->channels_max = max_channels;
 		stream->formats = formats;
 	}
+	return 0;
+}
+
+static int tda_hw_params(struct snd_pcm_substream *substream,
+			struct snd_pcm_hw_params *params,
+			struct snd_soc_dai *dai)
+{
+	struct tda_priv *priv = snd_soc_codec_get_drvdata(dai->codec);
 
 	/* start the TDA998x audio */
-	return tda_start_stop(priv);
+	return tda_start_stop(priv, params);
 }
 
 static void tda_shutdown(struct snd_pcm_substream *substream,
@@ -147,11 +156,12 @@ static void tda_shutdown(struct snd_pcm_substream *substream,
 	struct tda_priv *priv = snd_soc_codec_get_drvdata(dai->codec);
 
 	priv->dai_id = 0;		/* streaming stop */
-	tda_start_stop(priv);
+	tda_start_stop(priv, NULL);
 }
 
 static const struct snd_soc_dai_ops tda_ops = {
 	.startup = tda_startup,
+	.hw_params = tda_hw_params,
 	.shutdown = tda_shutdown,
 };
 
-- 
1.9.rc1

