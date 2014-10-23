Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754164AbaJWIs0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 04:48:26 -0400
Received: from smtp4-g21.free.fr ([212.27.42.4]:45760 "EHLO smtp4-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754024AbaJWIsU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 04:48:20 -0400
X-Mailbox-Line: From d63bb11d345ab1f1b7723ce5f82d42f56b0f1715 Mon Sep 17 00:00:00 2001
Message-Id: <d63bb11d345ab1f1b7723ce5f82d42f56b0f1715.1414053169.git.moinejf@free.fr>
In-Reply-To: <cover.1414053169.git.moinejf@free.fr>
References: <cover.1414053169.git.moinejf@free.fr>
From: Jean-Francois Moine <moinejf@free.fr>
Date: Thu, 23 Oct 2014 09:09:35 +0200
Subject: [PATCH v8 1/2] ASoC: hdmi: Add a transmitter interface to the HDMI
 CODEC
To: Mark Brown <broonie@kernel.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Dave Airlie <airlied@gmail.com>, Andrew Jackson <Andrew.Jackson@arm.com>,
        Jyri Sarha <jsarha@ti.com>, alsa-devel@alsa-project.org,
        devicetree@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Audio in HDMI asks for:
- the audio constraints of the HDMI device to be known when choosing
  the audio routes in the audio subsystem, and
- the HDMI transmitter to know which of its audio inputs has been
  chosen when audio streaming starts.

This patch adds the interface between a HDMI transmitter and the
HDMI CODEC.

At startup time, the HDMI transmitter device creates the HDMI device as
a child device giving a description of its DAIs and 2 callback functions,
these functions realizing the HDMI audio requirements.

Signed-off-by: Jean-Francois Moine <moinejf@free.fr>
---
 include/sound/hdmi.h    |  20 ++++++
 sound/soc/codecs/hdmi.c | 176 ++++++++++++++++++++++++++++++++++++++++++++++--
 2 files changed, 190 insertions(+), 6 deletions(-)
 create mode 100644 include/sound/hdmi.h

diff --git a/include/sound/hdmi.h b/include/sound/hdmi.h
new file mode 100644
index 0000000..49062c7
--- /dev/null
+++ b/include/sound/hdmi.h
@@ -0,0 +1,20 @@
+#ifndef SND_HDMI_H
+#define SND_HDMI_H
+
+#include <sound/soc.h>
+
+/* platform_data */
+struct hdmi_data {
+	int (*get_audio)(struct device *dev,
+			 int *max_channels,
+			 int *rate_mask,
+			 int *fmt);
+	void (*audio_switch)(struct device *dev,
+			     int port_index,
+			     unsigned sample_rate,
+			     int sample_format);
+	int ndais;
+	struct snd_soc_dai_driver *dais;
+	struct snd_soc_codec_driver *driver;
+};
+#endif
diff --git a/sound/soc/codecs/hdmi.c b/sound/soc/codecs/hdmi.c
index 1391ad5..f66f1f6 100644
--- a/sound/soc/codecs/hdmi.c
+++ b/sound/soc/codecs/hdmi.c
@@ -22,9 +22,148 @@
 #include <sound/soc.h>
 #include <linux/of.h>
 #include <linux/of_device.h>
+#include <sound/pcm_params.h>
+#include <sound/hdmi.h>
 
 #define DRV_NAME "hdmi-audio-codec"
 
+struct hdmi_priv {
+	struct hdmi_data hdmi_data;
+	struct snd_pcm_hw_constraint_list rate_constraints;
+};
+
+static int hdmi_dev_match(struct device *dev, void *data)
+{
+	return !strcmp(dev_name(dev), (char *) data);
+}
+
+/* get the codec device */
+static struct device *hdmi_get_cdev(struct device *dev)
+{
+	struct device *cdev;
+
+	cdev = device_find_child(dev,
+				 DRV_NAME,
+				 hdmi_dev_match);
+	if (!cdev)
+		dev_err(dev, "Cannot get codec device");
+	else
+		put_device(cdev);
+	return cdev;
+}
+
+static int hdmi_startup(struct snd_pcm_substream *substream,
+			struct snd_soc_dai *dai)
+{
+	struct snd_pcm_runtime *runtime = substream->runtime;
+	struct device *cdev;
+	struct hdmi_priv *priv;
+	struct snd_pcm_hw_constraint_list *rate_constraints;
+	int ret, max_channels, rate_mask, fmt;
+	u64 formats;
+	static const u32 hdmi_rates[] = {
+		32000, 44100, 48000, 88200, 96000, 176400, 192000
+	};
+
+	cdev = hdmi_get_cdev(dai->dev);
+	if (!cdev)
+		return -ENODEV;
+	priv = dev_get_drvdata(cdev);
+
+	/* get the EDID values and the rate constraints buffer */
+	ret = priv->hdmi_data.get_audio(dai->dev,
+					&max_channels, &rate_mask, &fmt);
+	if (ret < 0)
+		return ret;				/* no screen */
+
+	/* convert the EDID values to audio constraints */
+	rate_constraints = &priv->rate_constraints;
+	rate_constraints->list = hdmi_rates;
+	rate_constraints->count = ARRAY_SIZE(hdmi_rates);
+	rate_constraints->mask = rate_mask;
+	snd_pcm_hw_constraint_list(runtime, 0,
+				   SNDRV_PCM_HW_PARAM_RATE,
+				   rate_constraints);
+
+	formats = 0;
+	if (fmt & 1)
+		formats |= SNDRV_PCM_FMTBIT_S16_LE;
+	if (fmt & 2)
+		formats |= SNDRV_PCM_FMTBIT_S20_3LE;
+	if (fmt & 4)
+		formats |= SNDRV_PCM_FMTBIT_S24_LE |
+			   SNDRV_PCM_FMTBIT_S24_3LE |
+			   SNDRV_PCM_FMTBIT_S32_LE;
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
+static int hdmi_hw_params(struct snd_pcm_substream *substream,
+			  struct snd_pcm_hw_params *params,
+			  struct snd_soc_dai *dai)
+{
+	struct device *cdev;
+	struct hdmi_priv *priv;
+
+	cdev = hdmi_get_cdev(dai->dev);
+	if (!cdev)
+		return -ENODEV;
+	priv = dev_get_drvdata(cdev);
+
+	priv->hdmi_data.audio_switch(dai->dev, dai->id,
+				     params_rate(params),
+				     params_format(params));
+	return 0;
+}
+
+static void hdmi_shutdown(struct snd_pcm_substream *substream,
+			  struct snd_soc_dai *dai)
+{
+	struct device *cdev;
+	struct hdmi_priv *priv;
+
+	cdev = hdmi_get_cdev(dai->dev);
+	if (!cdev)
+		return;
+	priv = dev_get_drvdata(cdev);
+
+	priv->hdmi_data.audio_switch(dai->dev, -1, 0, 0);	/* stop */
+}
+
+static const struct snd_soc_dai_ops hdmi_ops = {
+	.startup = hdmi_startup,
+	.hw_params = hdmi_hw_params,
+	.shutdown = hdmi_shutdown,
+};
+
+static int hdmi_codec_probe(struct snd_soc_codec *codec)
+{
+	struct hdmi_priv *priv;
+	struct device *dev = codec->dev;	/* encoder device */
+	struct device *cdev;			/* codec device */
+
+	cdev = hdmi_get_cdev(dev);
+	if (!cdev)
+		return -ENODEV;
+
+	/* allocate some memory to store
+	 * the encoder callback functions and the rate constraints */
+	priv = devm_kzalloc(cdev, sizeof *priv, GFP_KERNEL);
+	if (!priv)
+		return -ENOMEM;
+	dev_set_drvdata(cdev, priv);
+
+	memcpy(&priv->hdmi_data, cdev->platform_data,
+				sizeof priv->hdmi_data);
+	return 0;
+}
+
 static const struct snd_soc_dapm_widget hdmi_widgets[] = {
 	SND_SOC_DAPM_INPUT("RX"),
 	SND_SOC_DAPM_OUTPUT("TX"),
@@ -79,13 +218,38 @@ static struct snd_soc_codec_driver hdmi_codec = {
 	.ignore_pmdown_time = true,
 };
 
-static int hdmi_codec_probe(struct platform_device *pdev)
+static int hdmi_codec_dev_probe(struct platform_device *pdev)
 {
-	return snd_soc_register_codec(&pdev->dev, &hdmi_codec,
-			&hdmi_codec_dai, 1);
+	struct hdmi_data *pdata = pdev->dev.platform_data;
+	struct snd_soc_dai_driver *dais;
+	struct snd_soc_codec_driver *driver;
+	int i, ret;
+
+	if (!pdata)
+		return snd_soc_register_codec(&pdev->dev, &hdmi_codec,
+						&hdmi_codec_dai, 1);
+
+	/* creation from a video encoder as a child device */
+	dais = devm_kmemdup(&pdev->dev,
+			    pdata->dais,
+			    sizeof *pdata->dais * pdata->ndais,
+			    GFP_KERNEL);
+	for (i = 0; i < pdata->ndais; i++)
+		dais[i].ops = &hdmi_ops;
+
+	driver = devm_kmemdup(&pdev->dev,
+			    pdata->driver,
+			    sizeof *pdata->driver,
+			    GFP_KERNEL);
+	driver->probe = hdmi_codec_probe;
+
+	/* register the codec on the video encoder */
+	ret = snd_soc_register_codec(pdev->dev.parent, driver,
+					dais, pdata->ndais);
+	return ret;
 }
 
-static int hdmi_codec_remove(struct platform_device *pdev)
+static int hdmi_codec_dev_remove(struct platform_device *pdev)
 {
 	snd_soc_unregister_codec(&pdev->dev);
 	return 0;
@@ -98,8 +262,8 @@ static struct platform_driver hdmi_codec_driver = {
 		.of_match_table = of_match_ptr(hdmi_audio_codec_ids),
 	},
 
-	.probe		= hdmi_codec_probe,
-	.remove		= hdmi_codec_remove,
+	.probe		= hdmi_codec_dev_probe,
+	.remove		= hdmi_codec_dev_remove,
 };
 
 module_platform_driver(hdmi_codec_driver);
-- 
2.1.1

