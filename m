Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752573AbaAOPyI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 10:54:08 -0500
Received: from smtp4-g21.free.fr ([212.27.42.4]:41829 "EHLO smtp4-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751754AbaAOPyF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 10:54:05 -0500
Date: Wed, 15 Jan 2014 16:52:00 +0100
From: Jean-Francois Moine <moinejf@free.fr>
To: Mark Brown <broonie@kernel.org>, lgirdwood@gmail.com
Cc: alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        kuninori.morimoto.gx@renesas.com, Xiubo Li <Li.Xiubo@freescale.com>
Subject: [PATCH v2 8/8] ASoC: simple-card: simplify code
Message-ID: <20140115165200.5f4e6077@armhf>
In-Reply-To: <20140115113551.0eb13409@armhf>
References: <20140115113551.0eb13409@armhf>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; arm-unknown-linux-gnueabihf)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rename the pointer to the private data structure to 'priv' to avoid confusion with the platform data pointer.

Signed-off-by: Jean-Francois Moine <moinejf@free.fr>
---
 sound/soc/generic/simple-card.c     | 32 +++++++++++-----------
 1 file changed, 16 insertions(+), 16 deletions(-)

diff --git a/sound/soc/generic/simple-card.c b/sound/soc/generic/simple-card.c
index 0f11c28..6443c87 100644
--- a/sound/soc/generic/simple-card.c
+++ b/sound/soc/generic/simple-card.c
@@ -47,18 +47,18 @@ static int __asoc_simple_card_dai_init(struct snd_soc_dai *dai,
 
 static int asoc_simple_card_dai_init(struct snd_soc_pcm_runtime *rtd)
 {
-	struct simple_card_data *info =
+	struct simple_card_data *priv =
 				snd_soc_card_get_drvdata(rtd->card);
 	struct snd_soc_dai *codec = rtd->codec_dai;
 	struct snd_soc_dai *cpu = rtd->cpu_dai;
-	unsigned int daifmt = info->daifmt;
+	unsigned int daifmt = priv->daifmt;
 	int ret;
 
-	ret = __asoc_simple_card_dai_init(codec, &info->codec_dai, daifmt);
+	ret = __asoc_simple_card_dai_init(codec, &priv->codec_dai, daifmt);
 	if (ret < 0)
 		return ret;
 
-	ret = __asoc_simple_card_dai_init(cpu, &info->cpu_dai, daifmt);
+	ret = __asoc_simple_card_dai_init(cpu, &priv->cpu_dai, daifmt);
 	if (ret < 0)
 		return ret;
 
@@ -129,21 +129,21 @@ parse_error:
 }
 
 static int asoc_simple_card_parse_of(struct device_node *node,
-				     struct simple_card_data *info,
+				     struct simple_card_data *priv,
 				     struct device *dev)
 {
-	struct snd_soc_dai_link *dai_link = info->snd_card.dai_link;
+	struct snd_soc_dai_link *dai_link = priv->snd_card.dai_link;
 	struct device_node *np;
 	char *name;
 	int ret;
 
 	/* get CPU/CODEC common format via simple-audio-card,format */
-	info->daifmt = snd_soc_of_parse_daifmt(node, "simple-audio-card,") &
+	priv->daifmt = snd_soc_of_parse_daifmt(node, "simple-audio-card,") &
 		(SND_SOC_DAIFMT_FORMAT_MASK | SND_SOC_DAIFMT_INV_MASK);
 
 	/* DAPM routes */
 	if (of_property_read_bool(node, "simple-audio-card,routing")) {
-		ret = snd_soc_of_parse_audio_routing(&info->snd_card,
+		ret = snd_soc_of_parse_audio_routing(&priv->snd_card,
 					"simple-audio-card,routing");
 		if (ret)
 			return ret;
@@ -154,7 +154,7 @@ static int asoc_simple_card_parse_of(struct device_node *node,
 	np = of_get_child_by_name(node, "simple-audio-card,cpu");
 	if (np)
 		ret = asoc_simple_card_sub_parse_of(np,
-						  &info->cpu_dai,
+						  &priv->cpu_dai,
 						  &dai_link->cpu_of_node,
 						  &dai_link->cpu_dai_name);
 	if (ret < 0)
@@ -165,7 +165,7 @@ static int asoc_simple_card_parse_of(struct device_node *node,
 	np = of_get_child_by_name(node, "simple-audio-card,codec");
 	if (np)
 		ret = asoc_simple_card_sub_parse_of(np,
-						  &info->codec_dai,
+						  &priv->codec_dai,
 						  &dai_link->codec_of_node,
 						  &dai_link->codec_dai_name);
 	if (ret < 0)
@@ -181,22 +181,22 @@ static int asoc_simple_card_parse_of(struct device_node *node,
 			    GFP_KERNEL);
 	sprintf(name, "%s-%s", dai_link->cpu_dai_name,
 				dai_link->codec_dai_name);
-	info->snd_card.name = name;
+	priv->snd_card.name = name;
 	dai_link->name = dai_link->stream_name = name;
 
 	/* simple-card assumes platform == cpu */
 	dai_link->platform_of_node = dai_link->cpu_of_node;
 
 	dev_dbg(dev, "card-name : %s\n", name);
-	dev_dbg(dev, "platform : %04x\n", info->daifmt);
+	dev_dbg(dev, "platform : %04x\n", priv->daifmt);
 	dev_dbg(dev, "cpu : %s / %04x / %d\n",
 		dai_link->cpu_dai_name,
-		info->cpu_dai.fmt,
-		info->cpu_dai.sysclk);
+		priv->cpu_dai.fmt,
+		priv->cpu_dai.sysclk);
 	dev_dbg(dev, "codec : %s / %04x / %d\n",
 		dai_link->codec_dai_name,
-		info->codec_dai.fmt,
-		info->codec_dai.sysclk);
+		priv->codec_dai.fmt,
+		priv->codec_dai.sysclk);
 
 	return 0;
 }
-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
