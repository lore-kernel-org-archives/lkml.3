Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754765AbbA1UPB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 15:15:01 -0500
Received: from mail.lysator.liu.se ([130.236.254.3]:44061 "EHLO
	mail.lysator.liu.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754691AbbA1UO5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 15:14:57 -0500
From: Peter Rosin <peda@lysator.liu.se>
To: alsa-devel@alsa-project.org
Cc: Peter Rosin <peda@axentia.se>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>, Liam Girdwood <lgirdwood@gmail.com>,
        Mark Brown <broonie@kernel.org>, Clemens Ladisch <clemens@ladisch.de>,
        Lars-Peter Clausen <lars@metafoo.de>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 7/7] ASoC: pcm512x: Support SND_SOC_DAIFMT_CBM_CFS
Date: Wed, 28 Jan 2015 15:16:12 +0100
Message-Id: <1422454572-7847-8-git-send-email-peda@lysator.liu.se>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1422454572-7847-1-git-send-email-peda@lysator.liu.se>
References: <1422454572-7847-1-git-send-email-peda@lysator.liu.se>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Rosin <peda@axentia.se>

Signed-off-by: Peter Rosin <peda@axentia.se>
---
 sound/soc/codecs/pcm512x.c |   13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/sound/soc/codecs/pcm512x.c b/sound/soc/codecs/pcm512x.c
index d46d6cdb6b87..64be85fb2748 100644
--- a/sound/soc/codecs/pcm512x.c
+++ b/sound/soc/codecs/pcm512x.c
@@ -464,6 +464,7 @@ static int pcm512x_dai_startup(struct snd_pcm_substream *substream,
 
 	switch (pcm512x->fmt & SND_SOC_DAIFMT_MASTER_MASK) {
 	case SND_SOC_DAIFMT_CBM_CFM:
+	case SND_SOC_DAIFMT_CBM_CFS:
 		return pcm512x_dai_startup_master(substream, dai);
 
 	case SND_SOC_DAIFMT_CBS_CFS:
@@ -970,6 +971,8 @@ static int pcm512x_hw_params(struct snd_pcm_substream *substream,
 	struct pcm512x_priv *pcm512x = snd_soc_codec_get_drvdata(codec);
 	int alen;
 	int gpio;
+	int clock_output;
+	int master_mode;
 	int ret;
 
 	dev_dbg(codec->dev, "hw_params %u Hz, %u channels\n",
@@ -1018,6 +1021,12 @@ static int pcm512x_hw_params(struct snd_pcm_substream *substream,
 		}
 		return 0;
 	case SND_SOC_DAIFMT_CBM_CFM:
+		clock_output = PCM512x_BCKO | PCM512x_LRKO;
+		master_mode = PCM512x_RLRK | PCM512x_RBCK;
+		break;
+	case SND_SOC_DAIFMT_CBM_CFS:
+		clock_output = PCM512x_BCKO;
+		master_mode = PCM512x_RBCK;
 		break;
 	default:
 		return -EINVAL;
@@ -1114,7 +1123,7 @@ static int pcm512x_hw_params(struct snd_pcm_substream *substream,
 
 	ret = regmap_update_bits(pcm512x->regmap, PCM512x_BCLK_LRCLK_CFG,
 				 PCM512x_BCKP | PCM512x_BCKO | PCM512x_LRKO,
-				 PCM512x_BCKO | PCM512x_LRKO);
+				 clock_output);
 	if (ret != 0) {
 		dev_err(codec->dev, "Failed to enable clock output: %d\n", ret);
 		return ret;
@@ -1122,7 +1131,7 @@ static int pcm512x_hw_params(struct snd_pcm_substream *substream,
 
 	ret = regmap_update_bits(pcm512x->regmap, PCM512x_MASTER_MODE,
 				 PCM512x_RLRK | PCM512x_RBCK,
-				 PCM512x_RLRK | PCM512x_RBCK);
+				 master_mode);
 	if (ret != 0) {
 		dev_err(codec->dev, "Failed to enable master mode: %d\n", ret);
 		return ret;
-- 
1.7.10.4

