Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933432AbaBARdF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Feb 2014 12:33:05 -0500
Received: from smtp2-g21.free.fr ([212.27.42.2]:41905 "EHLO smtp2-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933346AbaBARdB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Feb 2014 12:33:01 -0500
X-Mailbox-Line: From 1b15025671d9099863a3091346536e45891e4a26 Mon Sep 17 00:00:00 2001
Message-Id: <1b15025671d9099863a3091346536e45891e4a26.1391274628.git.moinejf@free.fr>
In-Reply-To: <cover.1391274627.git.moinejf@free.fr>
References: <cover.1391274627.git.moinejf@free.fr>
From: Jean-Francois Moine <moinejf@free.fr>
Date: Mon, 27 Jan 2014 09:48:54 +0100
Subject: [PATCH v3 4/5] ASoC: tda998x: adjust the audio hw parameters from
 EDID
To: alsa-devel@alsa-project.org
Cc: broonie@kernel.org, Dave Airlie <airlied@gmail.com>,
        dri-devel@lists.freedesktop.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Rob Clark <robdclark@gmail.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The supported audio parameters are described in the EDID which is
received by the HDMI transmitter from the connected screen.
Use these ones to adjust the audio stream parameters.

Signed-off-by: Jean-Francois Moine <moinejf@free.fr>
---
 drivers/gpu/drm/i2c/tda998x_drv.c | 15 ++++++++
 include/drm/i2c/tda998x.h         |  1 +
 sound/soc/codecs/tda998x.c        | 79 ++++++++++++++++++++++++++++++++++++++-
 3 files changed, 94 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/i2c/tda998x_drv.c b/drivers/gpu/drm/i2c/tda998x_drv.c
index 68f0b7b..b833fa5 100644
--- a/drivers/gpu/drm/i2c/tda998x_drv.c
+++ b/drivers/gpu/drm/i2c/tda998x_drv.c
@@ -47,6 +47,8 @@ struct tda998x_priv {
 	wait_queue_head_t wq_edid;
 	volatile int wq_edid_wait;
 	struct drm_encoder *encoder;
+
+	u8 *eld;
 };
 
 #define to_tda998x_priv(x)  ((struct tda998x_priv *)to_encoder_slave(x)->slave_priv)
@@ -733,6 +735,14 @@ tda998x_configure_audio(struct tda998x_priv *priv,
 }
 
 /* tda998x codec interface */
+u8 *tda998x_audio_get_eld(struct i2c_client *client)
+{
+	struct tda998x_priv *priv = i2c_get_clientdata(client);
+
+	return priv->eld;
+}
+EXPORT_SYMBOL_GPL(tda998x_audio_get_eld);
+
 void tda998x_audio_update(struct i2c_client *client,
 			int format,
 			int port)
@@ -1187,6 +1197,11 @@ tda998x_encoder_get_modes(struct drm_encoder *encoder,
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
 
diff --git a/include/drm/i2c/tda998x.h b/include/drm/i2c/tda998x.h
index 7e4806d..99387ae 100644
--- a/include/drm/i2c/tda998x.h
+++ b/include/drm/i2c/tda998x.h
@@ -27,6 +27,7 @@ struct tda998x_encoder_params {
 	unsigned audio_sample_rate;
 };
 
+u8 *tda998x_audio_get_eld(struct i2c_client *client);
 void tda998x_audio_update(struct i2c_client *client,
 			int format,
 			int port);
diff --git a/sound/soc/codecs/tda998x.c b/sound/soc/codecs/tda998x.c
index 34d7086..0493163 100644
--- a/sound/soc/codecs/tda998x.c
+++ b/sound/soc/codecs/tda998x.c
@@ -64,10 +64,79 @@ static int tda_startup(struct snd_pcm_substream *substream,
 			struct snd_soc_dai *dai)
 {
 	struct tda_priv *priv = snd_soc_codec_get_drvdata(dai->codec);
+	u8 *eld = NULL;
+	static unsigned rates_mask[] = {
+		SNDRV_PCM_RATE_32000,
+		SNDRV_PCM_RATE_44100,
+		SNDRV_PCM_RATE_48000,
+		SNDRV_PCM_RATE_88200,
+		SNDRV_PCM_RATE_96000,
+		SNDRV_PCM_RATE_176400,
+		SNDRV_PCM_RATE_192000,
+	};
 
 	/* memorize the used DAI */
 	priv->dai_id = dai->id;
 
+	/* get the ELD from the tda998x driver */
+	if (!priv->i2c_client)
+		tda_get_encoder(priv);
+	if (priv->i2c_client)
+		eld = tda998x_audio_get_eld(priv->i2c_client);
+
+	/* adjust the hw params from the ELD (EDID) */
+	if (eld) {
+		struct snd_soc_dai_driver *dai_drv = dai->driver;
+		struct snd_soc_pcm_stream *stream = &dai_drv->playback;
+		u8 *sad;
+		int sad_count;
+		unsigned eld_ver, mnl, rates, rate_mask, i;
+		unsigned max_channels, fmt;
+		u64 formats;
+
+		eld_ver = eld[0] >> 3;
+		if (eld_ver != 2 && eld_ver != 31)
+			return 0;
+
+		mnl = eld[4] & 0x1f;
+		if (mnl > 16)
+			return 0;
+
+		sad_count = eld[5] >> 4;
+		sad = eld + 20 + mnl;
+
+		/* Start from the basic audio settings */
+		max_channels = 2;
+		rates = 0;
+		fmt = 0;
+		while (sad_count--) {
+			switch (sad[0] & 0x78) {
+			case 0x08: /* PCM */
+				max_channels = max(max_channels, (sad[0] & 7) + 1u);
+				rates |= sad[1];
+				fmt |= sad[2] & 0x07;
+				break;
+			}
+			sad += 3;
+		}
+
+		for (rate_mask = i = 0; i < ARRAY_SIZE(rates_mask); i++)
+			if (rates & 1 << i)
+				rate_mask |= rates_mask[i];
+		formats = 0;
+		if (fmt & 1)
+			formats |= SNDRV_PCM_FMTBIT_S16_LE;
+		if (fmt & 2)
+			formats |= SNDRV_PCM_FMTBIT_S20_3LE;
+		if (fmt & 4)
+			formats |= SNDRV_PCM_FMTBIT_S24_LE;
+
+		/* change the snd_soc_pcm_stream values of the driver */
+		stream->rates = rate_mask;
+		stream->channels_max = max_channels;
+		stream->formats = formats;
+	}
+
 	/* start the TDA998x audio */
 	return tda_start_stop(priv);
 }
@@ -182,9 +251,17 @@ static const struct snd_soc_codec_driver soc_codec_tda998x = {
 
 static int tda998x_dev_probe(struct platform_device *pdev)
 {
+	struct snd_soc_dai_driver *dai_drv;
+
+	/* copy the DAI driver to a writable area */
+	dai_drv = devm_kzalloc(&pdev->dev, sizeof(tda998x_dai), GFP_KERNEL);
+	if (!dai_drv)
+		return -ENOMEM;
+	memcpy(dai_drv, tda998x_dai, sizeof(tda998x_dai));
+
 	return snd_soc_register_codec(&pdev->dev,
 				&soc_codec_tda998x,
-				tda998x_dai, ARRAY_SIZE(tda998x_dai));
+				dai_drv, ARRAY_SIZE(tda998x_dai));
 }
 
 static int tda998x_dev_remove(struct platform_device *pdev)
-- 
1.9.rc1

