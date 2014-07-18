Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935127AbaGRRbf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 13:31:35 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:42111 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934826AbaGRRbd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 13:31:33 -0400
From: Dan Murphy <dmurphy@ti.com>
To: <linux-sound@vger.kernel.org>
CC: <linux-kernel@vger.kernel.org>, <alsa-devel@alsa-project.org>,
        <broonie@kernel.org>, Dan Murphy <dmurphy@ti.com>
Subject: [PATCH 2/2] ASoC: tas2552: Add DAPM calls for amp and PLL
Date: Fri, 18 Jul 2014 12:31:08 -0500
Message-ID: <1405704668-8038-2-git-send-email-dmurphy@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1405704668-8038-1-git-send-email-dmurphy@ti.com>
References: <1405704668-8038-1-git-send-email-dmurphy@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add DAPM calls to enable/disable the Class D amp.
Also add a DAPM call to turn off the PLL upon
the stream completing.

Signed-off-by: Dan Murphy <dmurphy@ti.com>
---
 sound/soc/codecs/tas2552.c |   58 +++++++++++++++++++++++++++++++-------------
 1 file changed, 41 insertions(+), 17 deletions(-)

diff --git a/sound/soc/codecs/tas2552.c b/sound/soc/codecs/tas2552.c
index a3ae394..3fdb173 100644
--- a/sound/soc/codecs/tas2552.c
+++ b/sound/soc/codecs/tas2552.c
@@ -78,6 +78,40 @@ struct tas2552_data {
 	unsigned int mclk;
 };
 
+
+static int tas2552_pll_disable(struct snd_soc_dapm_widget *w,
+			   struct snd_kcontrol *kcontrol, int event)
+{
+	if (event == SND_SOC_DAPM_POST_PMD)
+		snd_soc_update_bits(w->codec, TAS2552_CFG_2, TAS2552_PLL_ENABLE, 0);
+
+	return 0;
+}
+
+static int tas2552_class_d_en(struct snd_soc_dapm_widget *w,
+			   struct snd_kcontrol *kcontrol, int event)
+{
+	switch (event) {
+	case SND_SOC_DAPM_PRE_PMU:
+		snd_soc_update_bits(w->codec, TAS2552_CFG_2,
+						 TAS2552_CLASSD_EN_MASK, TAS2552_CLASSD_EN_MASK);
+		break;
+	case SND_SOC_DAPM_POST_PMD:
+		snd_soc_update_bits(w->codec, TAS2552_CFG_2,
+						 TAS2552_CLASSD_EN_MASK, 0);
+		break;
+	}
+
+	return 0;
+}
+
+static const struct snd_soc_dapm_widget tas2552_dapm_widgets[] =
+{
+SND_SOC_DAPM_PRE("Class D Enable", tas2552_class_d_en),
+SND_SOC_DAPM_POST("Class D Disable", tas2552_class_d_en),
+SND_SOC_DAPM_POST("PLL Disable", tas2552_pll_disable),
+};
+
 static void tas2552_sw_shutdown(struct tas2552_data *tas_data, int sw_shutdown)
 {
 	u8 cfg1_reg;
@@ -101,10 +135,6 @@ static int tas2552_hw_params(struct snd_pcm_substream *substream,
 	int d;
 	u8 p, j;
 
-	/* Turn on Class D amplifier */
-	snd_soc_update_bits(codec, TAS2552_CFG_2, TAS2552_CLASSD_EN_MASK,
-						TAS2552_CLASSD_EN);
-
 	if (!tas2552->mclk)
 		return -EINVAL;
 
@@ -149,7 +179,6 @@ static int tas2552_hw_params(struct snd_pcm_substream *substream,
 
 	snd_soc_update_bits(codec, TAS2552_CFG_2, TAS2552_PLL_ENABLE,
 						TAS2552_PLL_ENABLE);
-
 	return 0;
 }
 
@@ -269,19 +298,10 @@ static const struct dev_pm_ops tas2552_pm = {
 			   NULL)
 };
 
-static void tas2552_shutdown(struct snd_pcm_substream *substream,
-			   struct snd_soc_dai *dai)
-{
-	struct snd_soc_codec *codec = dai->codec;
-
-	snd_soc_update_bits(codec, TAS2552_CFG_2, TAS2552_PLL_ENABLE, 0);
-}
-
 static struct snd_soc_dai_ops tas2552_speaker_dai_ops = {
 	.hw_params	= tas2552_hw_params,
 	.set_sysclk	= tas2552_set_dai_sysclk,
 	.set_fmt	= tas2552_set_dai_fmt,
-	.shutdown	= tas2552_shutdown,
 	.digital_mute = tas2552_mute,
 };
 
@@ -321,6 +341,7 @@ static const struct reg_default tas2552_init_regs[] = {
 static int tas2552_codec_probe(struct snd_soc_codec *codec)
 {
 	struct tas2552_data *tas2552 = snd_soc_codec_get_drvdata(codec);
+	struct snd_soc_dapm_context *dapm = &codec->dapm;
 	int ret;
 
 	tas2552->codec = codec;
@@ -362,9 +383,12 @@ static int tas2552_codec_probe(struct snd_soc_codec *codec)
 		goto patch_fail;
 	}
 
-	snd_soc_write(codec, TAS2552_CFG_2, TAS2552_CLASSD_EN |
-				  TAS2552_BOOST_EN | TAS2552_APT_EN |
-				  TAS2552_LIM_EN);
+	snd_soc_write(codec, TAS2552_CFG_2, TAS2552_BOOST_EN |
+				  TAS2552_APT_EN | TAS2552_LIM_EN);
+
+	snd_soc_dapm_new_controls(dapm, tas2552_dapm_widgets,
+				ARRAY_SIZE(tas2552_dapm_widgets));
+
 	return 0;
 
 patch_fail:
-- 
1.7.9.5

