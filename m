Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754108AbbATTo1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 14:44:27 -0500
Received: from smtp6-g21.free.fr ([212.27.42.6]:24448 "EHLO smtp6-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753880AbbATToY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 14:44:24 -0500
X-Mailbox-Line: From a67026f283019719432ef4310f9f8d75f467a4a6 Mon Sep 17 00:00:00 2001
Message-Id: <a67026f283019719432ef4310f9f8d75f467a4a6.1421782533.git.moinejf@free.fr>
In-Reply-To: <cover.1421782532.git.moinejf@free.fr>
References: <cover.1421782532.git.moinejf@free.fr>
From: Jean-Francois Moine <moinejf@free.fr>
Date: Tue, 20 Jan 2015 17:50:25 +0100
Subject: [PATCH v10 7/9] drm/i2c: tda998x: set cts_n according to the sample
 width
To: Mark Brown <broonie@kernel.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Dave Airlie <airlied@gmail.com>, Andrew Jackson <Andrew.Jackson@arm.com>,
        Jyri Sarha <jsarha@ti.com>, alsa-devel@alsa-project.org,
        devicetree@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With I2S input, the CTS_N predivider depends on the audio sample width.

Signed-off-by: Jean-Francois Moine <moinejf@free.fr>
---
 drivers/gpu/drm/i2c/tda998x_drv.c | 21 ++++++++++++++++++---
 include/sound/tda998x.h           |  4 +++-
 sound/soc/codecs/tda998x.c        |  5 +++--
 3 files changed, 24 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/i2c/tda998x_drv.c b/drivers/gpu/drm/i2c/tda998x_drv.c
index a2cfc11..adf34e0 100644
--- a/drivers/gpu/drm/i2c/tda998x_drv.c
+++ b/drivers/gpu/drm/i2c/tda998x_drv.c
@@ -28,6 +28,7 @@
 #include <drm/drm_edid.h>
 #include <drm/i2c/tda998x.h>
 #include <sound/tda998x.h>
+#include <sound/pcm.h>
 
 #define DBG(fmt, ...) DRM_DEBUG(fmt"\n", ##__VA_ARGS__)
 
@@ -663,7 +664,17 @@ tda998x_configure_audio(struct tda998x_priv *priv,
 		reg_write(priv, REG_MUX_AP, MUX_AP_SELECT_I2S);
 		clksel_aip = AIP_CLKSEL_AIP_I2S;
 		clksel_fs = AIP_CLKSEL_FS_ACLK;
-		cts_n = CTS_N_M(3) | CTS_N_K(3);
+
+		/* with I2S input, the CTS_N predivider depends on
+		 * the sample width */
+		switch (priv->audio.sample_format) {
+		case SNDRV_PCM_FORMAT_S16_LE:
+			cts_n = CTS_N_M(3) | CTS_N_K(1);
+			break;
+		default:
+			cts_n = CTS_N_M(3) | CTS_N_K(3);
+			break;
+		}
 		break;
 
 	default:
@@ -751,7 +762,8 @@ static int tda998x_get_audio_var(struct device *dev,
 /* switch the audio port and initialize the audio parameters for streaming */
 static int tda998x_set_audio_input(struct device *dev,
 				int port_index,
-				unsigned sample_rate)
+				unsigned sample_rate,
+				int sample_format)
 {
 	struct tda998x_priv *priv = dev_get_drvdata(dev);
 	struct tda998x_encoder_params *p = &priv->params;
@@ -767,7 +779,8 @@ static int tda998x_set_audio_input(struct device *dev,
 
 	/* if same audio parameters, just enable the audio port */
 	if (p->audio_cfg == priv->audio.ports[port_index] &&
-	    p->audio_sample_rate == sample_rate) {
+	    p->audio_sample_rate == sample_rate &&
+	    priv->audio.sample_format == sample_format) {
 		reg_write(priv, REG_ENA_AP, p->audio_cfg);
 		return 0;
 	}
@@ -776,6 +789,7 @@ static int tda998x_set_audio_input(struct device *dev,
 	p->audio_clk_cfg = p->audio_format == AFMT_SPDIF ? 0 : 1;
 	p->audio_cfg = priv->audio.ports[port_index];
 	p->audio_sample_rate = sample_rate;
+	priv->audio.sample_format = sample_format;
 	tda998x_configure_audio(priv, &priv->encoder->crtc->hwmode, p);
 	return 0;
 }
@@ -1427,6 +1441,7 @@ static int tda998x_create(struct i2c_client *client, struct tda998x_priv *priv)
 
 	priv->params.audio_frame[1] = 1;		/* channels - 1 */
 	priv->params.audio_sample_rate = 48000;		/* 48kHz */
+	priv->audio.sample_format = SNDRV_PCM_FORMAT_S24_LE;
 
 	priv->current_page = 0xff;
 	priv->hdmi = client;
diff --git a/include/sound/tda998x.h b/include/sound/tda998x.h
index b4b747b..a870c40 100644
--- a/include/sound/tda998x.h
+++ b/include/sound/tda998x.h
@@ -9,6 +9,7 @@
 struct tda998x_audio_s {
 	u8 ports[2];			/* AP value */
 	u8 port_types[2];		/* AFMT_xxx */
+	int sample_format;
 #if IS_ENABLED(CONFIG_SND_SOC_TDA998X)
 	struct cea_sad cea_sad;		/* Short Audio Descriptor */
 	void *codec_priv;
@@ -20,7 +21,8 @@ struct tda998x_ops_s {
 			struct tda998x_audio_s **tda998x_audio);
 	int (*set_audio_input)(struct device *dev,
 			int port_index,
-			unsigned sample_rate);
+			unsigned sample_rate,
+			int sample_format);
 };
 
 int tda9998x_codec_register(struct device *dev,
diff --git a/sound/soc/codecs/tda998x.c b/sound/soc/codecs/tda998x.c
index 0a186e7..fece8d2 100644
--- a/sound/soc/codecs/tda998x.c
+++ b/sound/soc/codecs/tda998x.c
@@ -73,13 +73,14 @@ static int tda998x_codec_hw_params(struct snd_pcm_substream *substream,
 				   struct snd_soc_dai *dai)
 {
 	return tda998x_ops->set_audio_input(dai->dev, dai->id,
-					params_rate(params));
+					params_rate(params),
+					params_format(params));
 }
 
 static void tda998x_codec_shutdown(struct snd_pcm_substream *substream,
 				   struct snd_soc_dai *dai)
 {
-	tda998x_ops->set_audio_input(dai->dev, PORT_NONE, 0);
+	tda998x_ops->set_audio_input(dai->dev, PORT_NONE, 0, 0);
 }
 
 static const struct snd_soc_dai_ops tda998x_codec_ops = {
-- 
2.1.4

