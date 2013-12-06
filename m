Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757432Ab3LFJsM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 04:48:12 -0500
Received: from va3ehsobe001.messaging.microsoft.com ([216.32.180.11]:19998
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757207Ab3LFJrk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 04:47:40 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 3
X-BigFish: VS3(zzzz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah1fc6h1082kzz1de098h8275bh1de097hz2dh2a8h839hd24he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1e23h1fe8h1ff5h2218h2216h226dh22d0h2327h2336h1155h)
From: Nicolin Chen <b42378@freescale.com>
To: <broonie@kernel.org>, <lgirdwood@gmail.com>
CC: <alsa-devel@alsa-project.org>, <tiwai@suse.de>, <perex@perex.cz>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/3] ASoC: fsl: imx-wm8962: Grant hw_params/free() permission to control FLL
Date: Fri, 6 Dec 2013 17:47:43 +0800
Message-ID: <bed76b8bfd2d4ed9739269657cd55e4a81b65403.1386322845.git.b42378@freescale.com>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <cover.1386322845.git.b42378@freescale.com>
References: <cover.1386322845.git.b42378@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%0$Dn%FREESCALE.MAIL.ONMICROSOFT.COM$RO%1$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Previously, we couldn't use hw_params() and hw_free() to open and close FLL
becuase there might be a race between two simmultaneous substreams so the
FLL configuration would be changed and accordingly mulfunction. Also it
wouldn't make sense for bypass path feature of WM8962. So we adopted DAPM
way to control it. However, if we want to playback a different sample rate
file, we need to wait for DAPM to change its bias_level and reconfigure FLL.

But after we introduced full symmetry protection in the soc-pcm, we don't
need to worry about the race any more. And the instance by using hw_params()
and hw_free() to control FLL will allow us to support flexible use cases,
'aplay -Dhw:0 44k16bit.wav 48k24bit.wav 32k16bit.wav' for example.

Thus this patch mainly adds FLL configuration code to hw_params/hw_free()
so as to enchance the sound card's capability. Meanwhile in order not to
break the bypass path feature, we make both set_bias_level() and hw_xxx()
ways coexist.

Signed-off-by: Nicolin Chen <b42378@freescale.com>
---
 sound/soc/fsl/imx-wm8962.c | 136 ++++++++++++++++++++++++++++-----------------
 1 file changed, 86 insertions(+), 50 deletions(-)

diff --git a/sound/soc/fsl/imx-wm8962.c b/sound/soc/fsl/imx-wm8962.c
index 3fd76bc..8baf5d4 100644
--- a/sound/soc/fsl/imx-wm8962.c
+++ b/sound/soc/fsl/imx-wm8962.c
@@ -35,6 +35,7 @@ struct imx_wm8962_data {
 	char platform_name[DAI_NAME_SIZE];
 	struct clk *codec_clk;
 	unsigned int clk_frequency;
+	bool fll_lock;
 };
 
 struct imx_priv {
@@ -49,20 +50,93 @@ static const struct snd_soc_dapm_widget imx_wm8962_dapm_widgets[] = {
 	SND_SOC_DAPM_MIC("DMIC", NULL),
 };
 
-static int sample_rate = 44100;
-static snd_pcm_format_t sample_format = SNDRV_PCM_FORMAT_S16_LE;
+static int imx_wm8962_enable_fll(struct snd_soc_dai *codec_dai, u32 sample_rate,
+				snd_pcm_format_t sample_format)
+{
+	struct imx_priv *priv = &card_priv;
+	struct device *dev = &priv->pdev->dev;
+	struct imx_wm8962_data *data = platform_get_drvdata(priv->pdev);
+	u32 freq, ret;
+
+	if (data->fll_lock)
+		return 0;
+
+	data->fll_lock = 1;
+
+	if (sample_format == SNDRV_PCM_FORMAT_S24_LE)
+		freq = sample_rate * 384;
+	else
+		freq = sample_rate * 256;
+
+	ret = snd_soc_dai_set_pll(codec_dai, WM8962_FLL, WM8962_FLL_MCLK,
+				  data->clk_frequency, freq);
+	if (ret) {
+		dev_err(dev, "failed to start FLL: %d\n", ret);
+		return ret;
+	}
+
+	ret = snd_soc_dai_set_sysclk(codec_dai, WM8962_SYSCLK_FLL,
+				     freq, SND_SOC_CLOCK_IN);
+	if (ret)
+		dev_err(dev, "failed to set SYSCLK: %d\n", ret);
+
+	return ret;
+}
+
+static int imx_wm8962_disable_fll(struct snd_soc_dai *codec_dai)
+{
+	struct imx_priv *priv = &card_priv;
+	struct device *dev = &priv->pdev->dev;
+	struct imx_wm8962_data *data = platform_get_drvdata(priv->pdev);
+	int ret;
+
+	if (!data->fll_lock)
+		return 0;
+
+	data->fll_lock = 0;
+
+	/* Switch to MCLK as sysclk once so as to disable FLL */
+	ret = snd_soc_dai_set_sysclk(codec_dai, WM8962_SYSCLK_MCLK,
+				     0, SND_SOC_CLOCK_IN);
+	if (ret) {
+		dev_err(dev, "failed to switch away from FLL: %d\n", ret);
+		return ret;
+	}
+
+	/* Disable FLL so that we can reset its output freq later */
+	ret = snd_soc_dai_set_pll(codec_dai, WM8962_FLL,
+				  WM8962_FLL_MCLK, 0, 0);
+	if (ret)
+		dev_err(dev, "failed to stop FLL: %d\n", ret);
+
+	return ret;
+}
 
 static int imx_hifi_hw_params(struct snd_pcm_substream *substream,
 		struct snd_pcm_hw_params *params)
 {
-	sample_rate = params_rate(params);
-	sample_format = params_format(params);
+	struct snd_soc_pcm_runtime *rtd = substream->private_data;
+	struct snd_soc_dai *codec_dai = rtd->codec_dai;
 
-	return 0;
+	return imx_wm8962_enable_fll(codec_dai, params_rate(params),
+				     params_format(params));
+}
+
+static int imx_hifi_hw_free(struct snd_pcm_substream *substream)
+{
+	struct snd_soc_pcm_runtime *rtd = substream->private_data;
+	struct snd_soc_dai *codec_dai = rtd->codec_dai;
+
+	/* Don't diable FLL if still having multiple substreams running */
+	if (codec_dai->active != 1)
+		return 0;
+
+	return imx_wm8962_disable_fll(codec_dai);
 }
 
 static struct snd_soc_ops imx_hifi_ops = {
 	.hw_params = imx_hifi_hw_params,
+	.hw_free = imx_hifi_hw_free,
 };
 
 static int imx_wm8962_set_bias_level(struct snd_soc_card *card,
@@ -70,60 +144,20 @@ static int imx_wm8962_set_bias_level(struct snd_soc_card *card,
 					enum snd_soc_bias_level level)
 {
 	struct snd_soc_dai *codec_dai = card->rtd[0].codec_dai;
-	struct imx_priv *priv = &card_priv;
-	struct imx_wm8962_data *data = platform_get_drvdata(priv->pdev);
-	struct device *dev = &priv->pdev->dev;
-	unsigned int pll_out;
-	int ret;
 
 	if (dapm->dev != codec_dai->dev)
 		return 0;
 
 	switch (level) {
 	case SND_SOC_BIAS_PREPARE:
-		if (dapm->bias_level == SND_SOC_BIAS_STANDBY) {
-			if (sample_format == SNDRV_PCM_FORMAT_S24_LE)
-				pll_out = sample_rate * 384;
-			else
-				pll_out = sample_rate * 256;
-
-			ret = snd_soc_dai_set_pll(codec_dai, WM8962_FLL,
-					WM8962_FLL_MCLK, data->clk_frequency,
-					pll_out);
-			if (ret < 0) {
-				dev_err(dev, "failed to start FLL: %d\n", ret);
-				return ret;
-			}
-
-			ret = snd_soc_dai_set_sysclk(codec_dai,
-					WM8962_SYSCLK_FLL, pll_out,
-					SND_SOC_CLOCK_IN);
-			if (ret < 0) {
-				dev_err(dev, "failed to set SYSCLK: %d\n", ret);
-				return ret;
-			}
-		}
+		if (dapm->bias_level == SND_SOC_BIAS_STANDBY)
+			return imx_wm8962_enable_fll(codec_dai, 44100,
+						SNDRV_PCM_FORMAT_S16_LE);
 		break;
 
 	case SND_SOC_BIAS_STANDBY:
-		if (dapm->bias_level == SND_SOC_BIAS_PREPARE) {
-			ret = snd_soc_dai_set_sysclk(codec_dai,
-					WM8962_SYSCLK_MCLK, data->clk_frequency,
-					SND_SOC_CLOCK_IN);
-			if (ret < 0) {
-				dev_err(dev,
-					"failed to switch away from FLL: %d\n",
-					ret);
-				return ret;
-			}
-
-			ret = snd_soc_dai_set_pll(codec_dai, WM8962_FLL,
-					0, 0, 0);
-			if (ret < 0) {
-				dev_err(dev, "failed to stop FLL: %d\n", ret);
-				return ret;
-			}
-		}
+		if (dapm->bias_level == SND_SOC_BIAS_PREPARE)
+			return imx_wm8962_disable_fll(codec_dai);
 		break;
 
 	default:
@@ -141,6 +175,8 @@ static int imx_wm8962_late_probe(struct snd_soc_card *card)
 	struct device *dev = &priv->pdev->dev;
 	int ret;
 
+	data->fll_lock = 0;
+
 	ret = snd_soc_dai_set_sysclk(codec_dai, WM8962_SYSCLK_MCLK,
 			data->clk_frequency, SND_SOC_CLOCK_IN);
 	if (ret < 0)
-- 
1.8.4


