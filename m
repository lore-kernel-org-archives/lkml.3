Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751756AbaANLgh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 06:36:37 -0500
Received: from smtp3-g21.free.fr ([212.27.42.3]:48004 "EHLO smtp3-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751402AbaANLgf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 06:36:35 -0500
Date: Tue, 14 Jan 2014 12:36:06 +0100
From: Jean-Francois Moine <moinejf@free.fr>
To: Mark Brown <broonie@kernel.org>, lgirdwood@gmail.com,
        Xiubo Li <Li.Xiubo@freescale.com>
Cc: alsa-devel@alsa-project.org, kuninori.morimoto.gx@renesas.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH] ASoC: simple-card: simplify code
Message-ID: <20140114123606.2241d8ab@armhf>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; arm-unknown-linux-gnueabihf)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch
- removes the fields of the platform data which are of no use to the
  non-DT platform callers,
- uses a new private structure to handle all the sound card information,
- simplifies the code and make easier a possible multi-DAI links extension.

Signed-off-by: Jean-Francois Moine <moinejf@free.fr>
---
Xiubo, I also removed 'of_device_is_available' which seems really
useless: the module is not probed when the DT status is not "okay".
---
 include/sound/simple_card.h      |   4 --
  sound/soc/generic/simple-card.c | 178 ++++++++++-----------
 2 files changed, 88 insertions(+), 94 deletions(-)

diff --git a/include/sound/simple_card.h b/include/sound/simple_card.h
index 6c74527..e1ac996 100644
--- a/include/sound/simple_card.h
+++ b/include/sound/simple_card.h
@@ -29,10 +29,6 @@ struct asoc_simple_card_info {
 	unsigned int daifmt;
 	struct asoc_simple_dai cpu_dai;
 	struct asoc_simple_dai codec_dai;
-
-	/* used in simple-card.c */
-	struct snd_soc_dai_link snd_link;
-	struct snd_soc_card snd_card;
 };
 
 #endif /* __SIMPLE_CARD_H */
diff --git a/sound/soc/generic/simple-card.c b/sound/soc/generic/simple-card.c
index 5528dd6..580900e 100644
--- a/sound/soc/generic/simple-card.c
+++ b/sound/soc/generic/simple-card.c
@@ -14,6 +14,13 @@
 #include <linux/module.h>
 #include <sound/simple_card.h>
 
+struct simple_card_data {
+	struct snd_soc_card snd_card;
+	unsigned int daifmt;
+	struct asoc_simple_dai cpu_dai;
+	struct asoc_simple_dai codec_dai;
+};
+
 static int __asoc_simple_card_dai_init(struct snd_soc_dai *dai,
 				       struct asoc_simple_dai *set,
 				       unsigned int daifmt)
@@ -38,18 +45,18 @@ static int __asoc_simple_card_dai_init(struct snd_soc_dai *dai,
 
 static int asoc_simple_card_dai_init(struct snd_soc_pcm_runtime *rtd)
 {
-	struct asoc_simple_card_info *info =
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
 
@@ -59,7 +66,8 @@ static int asoc_simple_card_dai_init(struct snd_soc_pcm_runtime *rtd)
 static int
 asoc_simple_card_sub_parse_of(struct device_node *np,
 			      struct asoc_simple_dai *dai,
-			      struct device_node **node)
+			      struct device_node **node,
+			      const char **name)
 {
 	struct clk *clk;
 	int ret;
@@ -73,7 +81,7 @@ asoc_simple_card_sub_parse_of(struct device_node *np,
 		return -ENODEV;
 
 	/* get dai->name */
-	ret = snd_soc_of_get_dai_name(np, &dai->name);
+	ret = snd_soc_of_get_dai_name(np, name);
 	if (ret < 0)
 		goto parse_error;
 
@@ -117,23 +125,21 @@ parse_error:
 }
 
 static int asoc_simple_card_parse_of(struct device_node *node,
-				     struct asoc_simple_card_info *info,
-				     struct device *dev,
-				     struct device_node **of_cpu,
-				     struct device_node **of_codec,
-				     struct device_node **of_platform)
+				     struct simple_card_data *priv,
+				     struct device *dev)
 {
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
@@ -144,8 +150,10 @@ static int asoc_simple_card_parse_of(struct device_node *node,
 	np = of_get_child_by_name(node, "simple-audio-card,cpu");
 	if (np)
 		ret = asoc_simple_card_sub_parse_of(np,
-						  &info->cpu_dai,
-						  of_cpu);
+						  &priv->cpu_dai,
+					  (struct device_node **)
+						  &dai_link->cpu_of_node,
+						  &dai_link->cpu_dai_name);
 	if (ret < 0)
 		return ret;
 
@@ -154,109 +162,99 @@ static int asoc_simple_card_parse_of(struct device_node *node,
 	np = of_get_child_by_name(node, "simple-audio-card,codec");
 	if (np)
 		ret = asoc_simple_card_sub_parse_of(np,
-						  &info->codec_dai,
-						  of_codec);
+						  &priv->codec_dai,
+					  (struct device_node **)
+						  &dai_link->codec_of_node,
+						  &dai_link->codec_dai_name);
 	if (ret < 0)
 		return ret;
 
 	/* card name is created from CPU/CODEC dai name */
 	name = devm_kzalloc(dev,
-			    strlen(info->cpu_dai.name)   +
-			    strlen(info->codec_dai.name) + 2,
+			    strlen(dai_link->cpu_dai_name)   +
+			    strlen(dai_link->codec_dai_name) + 2,
 			    GFP_KERNEL);
-	sprintf(name, "%s-%s", info->cpu_dai.name, info->codec_dai.name);
-	info->name = info->card = name;
+	sprintf(name, "%s-%s", dai_link->cpu_dai_name, dai_link->codec_dai_name);
+	priv->snd_card.name = name;
+	dai_link->name = dai_link->stream_name = name;
 
 	/* simple-card assumes platform == cpu */
-	*of_platform = *of_cpu;
+	dai_link->platform_of_node = dai_link->cpu_of_node;
 
-	dev_dbg(dev, "card-name : %s\n", info->card);
-	dev_dbg(dev, "platform : %04x\n", info->daifmt);
+	dev_dbg(dev, "card-name : %s\n", name);
+	dev_dbg(dev, "platform : %04x\n", priv->daifmt);
 	dev_dbg(dev, "cpu : %s / %04x / %d\n",
-		info->cpu_dai.name,
-		info->cpu_dai.fmt,
-		info->cpu_dai.sysclk);
+		dai_link->cpu_dai_name,
+		priv->cpu_dai.fmt,
+		priv->cpu_dai.sysclk);
 	dev_dbg(dev, "codec : %s / %04x / %d\n",
-		info->codec_dai.name,
-		info->codec_dai.fmt,
-		info->codec_dai.sysclk);
+		dai_link->codec_dai_name,
+		priv->codec_dai.fmt,
+		priv->codec_dai.sysclk);
 
 	return 0;
 }
 
 static int asoc_simple_card_probe(struct platform_device *pdev)
 {
+	struct simple_card_data *priv;
+	struct snd_soc_dai_link *dai_link;
 	struct asoc_simple_card_info *cinfo;
 	struct device_node *np = pdev->dev.of_node;
-	struct device_node *of_cpu, *of_codec, *of_platform;
 	struct device *dev = &pdev->dev;
 
-	cinfo		= NULL;
-	of_cpu		= NULL;
-	of_codec	= NULL;
-	of_platform	= NULL;
-	if (np && of_device_is_available(np)) {
-		cinfo = devm_kzalloc(dev, sizeof(*cinfo), GFP_KERNEL);
-		if (cinfo) {
-			int ret;
-			cinfo->snd_card.dev = &pdev->dev;
-			ret = asoc_simple_card_parse_of(np, cinfo, dev,
-							&of_cpu,
-							&of_codec,
-							&of_platform);
-			if (ret < 0) {
-				if (ret != -EPROBE_DEFER)
-					dev_err(dev, "parse error %d\n", ret);
-				return ret;
-			}
-		} else {
-			return -ENOMEM;
-		}
-	} else {
-		cinfo = pdev->dev.platform_data;
-		if (!cinfo) {
-			dev_err(dev, "no info for asoc-simple-card\n");
+	priv = devm_kzalloc(dev,
+			sizeof(*priv) + sizeof(*dai_link),
+			GFP_KERNEL);
+	if (!priv)
+		return -ENOMEM;
+
+	priv->snd_card.owner = THIS_MODULE;
+	priv->snd_card.dev = &pdev->dev;
+	dai_link = (struct snd_soc_dai_link *) (priv + 1);
+	priv->snd_card.dai_link = dai_link;
+	priv->snd_card.num_links = 1;
+
+	cinfo = pdev->dev.platform_data;
+	if (cinfo) {
+		if (!cinfo->name	||
+		    !cinfo->card	||
+		    !cinfo->codec_dai.name	||
+		    !cinfo->codec	||
+		    !cinfo->platform	||
+		    !cinfo->cpu_dai.name) {
+			dev_err(dev, "insufficient asoc_simple_card_info settings\n");
 			return -EINVAL;
 		}
 
-		cinfo->snd_card.dev = &pdev->dev;
-	}
-
-	if (!cinfo->name	||
-	    !cinfo->card	||
-	    !cinfo->codec_dai.name	||
-	    !(cinfo->codec		|| of_codec)	||
-	    !(cinfo->platform		|| of_platform)	||
-	    !(cinfo->cpu_dai.name	|| of_cpu)) {
-		dev_err(dev, "insufficient asoc_simple_card_info settings\n");
+		dai_link->name		= cinfo->name;
+		dai_link->stream_name	= cinfo->name;
+		dai_link->cpu_dai_name	= cinfo->cpu_dai.name;
+		dai_link->platform_name	= cinfo->platform;
+		dai_link->codec_name	= cinfo->codec;
+		dai_link->codec_dai_name = cinfo->codec_dai.name;
+		memcpy(&priv->cpu_dai, &cinfo->cpu_dai,
+				sizeof(priv->cpu_dai));
+		memcpy(&priv->codec_dai, &cinfo->codec_dai,
+				sizeof(priv->codec_dai));
+		dai_link->init		= asoc_simple_card_dai_init;
+	} else if (np) {
+		int ret;
+
+		ret = asoc_simple_card_parse_of(np, priv, dev);
+		if (ret < 0) {
+			if (ret != -EPROBE_DEFER)
+				dev_err(dev, "parse error %d\n", ret);
+			return ret;
+		}
+	} else {
+		dev_err(dev, "no info for asoc-simple-card\n");
 		return -EINVAL;
 	}
 
-	/*
-	 * init snd_soc_dai_link
-	 */
-	cinfo->snd_link.name		= cinfo->name;
-	cinfo->snd_link.stream_name	= cinfo->name;
-	cinfo->snd_link.cpu_dai_name	= cinfo->cpu_dai.name;
-	cinfo->snd_link.platform_name	= cinfo->platform;
-	cinfo->snd_link.codec_name	= cinfo->codec;
-	cinfo->snd_link.codec_dai_name	= cinfo->codec_dai.name;
-	cinfo->snd_link.cpu_of_node	= of_cpu;
-	cinfo->snd_link.codec_of_node	= of_codec;
-	cinfo->snd_link.platform_of_node = of_platform;
-	cinfo->snd_link.init		= asoc_simple_card_dai_init;
-
-	/*
-	 * init snd_soc_card
-	 */
-	cinfo->snd_card.name		= cinfo->card;
-	cinfo->snd_card.owner		= THIS_MODULE;
-	cinfo->snd_card.dai_link	= &cinfo->snd_link;
-	cinfo->snd_card.num_links	= 1;
-
-	snd_soc_card_set_drvdata(&cinfo->snd_card, cinfo);
+	snd_soc_card_set_drvdata(&priv->snd_card, priv);
 
-	return devm_snd_soc_register_card(&pdev->dev, &cinfo->snd_card);
+	return devm_snd_soc_register_card(&pdev->dev, &priv->snd_card);
 }
 
 static const struct of_device_id asoc_simple_of_match[] = {
-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
