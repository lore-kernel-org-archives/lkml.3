Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756440AbaCOLnP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Mar 2014 07:43:15 -0400
Received: from smtp2-g21.free.fr ([212.27.42.2]:48617 "EHLO smtp2-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754598AbaCOLmP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Mar 2014 07:42:15 -0400
X-Mailbox-Line: From 0d648a81b7dd3fbd3ec769cb77bce0af5b39d699 Mon Sep 17 00:00:00 2001
Message-Id: <0d648a81b7dd3fbd3ec769cb77bce0af5b39d699.1394883134.git.moinejf@free.fr>
In-Reply-To: <cover.1394883134.git.moinejf@free.fr>
References: <cover.1394883134.git.moinejf@free.fr>
From: Jean-Francois Moine <moinejf@free.fr>
Date: Sat, 15 Mar 2014 12:26:54 +0100
Subject: [PATCH v3 3/4] ASoC: simple-card: Handle many DAI links
To: Mark Brown <broonie@kernel.org>
Cc: alsa-devel@alsa-project.org,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        linux-kernel@vger.kernel.org, Xiubo Li <Li.Xiubo@freescale.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some simple audio cards may have many DAI links.
This patch extends the simple-card driver for handling such cards.

Signed-off-by: Jean-Francois Moine <moinejf@free.fr>
---
 sound/soc/generic/simple-card.c | 134 +++++++++++++++++++++++++---------------
 1 file changed, 83 insertions(+), 51 deletions(-)

diff --git a/sound/soc/generic/simple-card.c b/sound/soc/generic/simple-card.c
index a55dc46..ffb9be3 100644
--- a/sound/soc/generic/simple-card.c
+++ b/sound/soc/generic/simple-card.c
@@ -70,13 +70,14 @@ static int asoc_simple_card_dai_init(struct snd_soc_pcm_runtime *rtd)
 				snd_soc_card_get_drvdata(rtd->card);
 	struct snd_soc_dai *codec = rtd->codec_dai;
 	struct snd_soc_dai *cpu = rtd->cpu_dai;
-	int ret;
+	int num, ret;
 
-	ret = __asoc_simple_card_dai_init(codec, &priv->dais->codec_dai);
+	num = rtd - rtd->card->rtd;
+	ret = __asoc_simple_card_dai_init(codec, &priv->dais[num].codec_dai);
 	if (ret < 0)
 		return ret;
 
-	ret = __asoc_simple_card_dai_init(cpu, &priv->dais->cpu_dai);
+	ret = __asoc_simple_card_dai_init(cpu, &priv->dais[num].cpu_dai);
 	if (ret < 0)
 		return ret;
 
@@ -156,7 +157,7 @@ static int asoc_simple_card_parse_of(struct device_node *node,
 	struct device_node *np;
 	char *name;
 	unsigned int daifmt;
-	int ret;
+	int num, ret;
 
 	/* parsing the card name from DT */
 	snd_soc_of_parse_card_name(&priv->snd_card, "simple-audio-card,name");
@@ -181,50 +182,63 @@ static int asoc_simple_card_parse_of(struct device_node *node,
 			return ret;
 	}
 
-	/* CPU sub-node */
-	ret = -EINVAL;
-	np = of_get_child_by_name(node, "simple-audio-card,cpu");
-	if (np) {
+	/* loop on the DAI links */
+	np = NULL;
+	for (num = 0; ; num++, dai_link++) {
+		np = of_get_next_child(node, np);
+		if (!np)
+			break;
+
+		/* CPU sub-node */
+		if (strcmp(np->name, "simple-audio-card,cpu") != 0) {
+			dev_err(dev, "Bad CPU DAI\n");
+			ret = -EINVAL;
+			goto err;
+		}
 		ret = asoc_simple_card_sub_parse_of(np, daifmt,
-						  &priv->dais->cpu_dai,
+						  &priv->dais[num].cpu_dai,
 						  &dai_link->cpu_of_node,
 						  &dai_link->cpu_dai_name);
-		of_node_put(np);
-	}
-	if (ret < 0)
-		return ret;
+		if (ret < 0)
+			goto err;
 
-	/* CODEC sub-node */
-	ret = -EINVAL;
-	np = of_get_child_by_name(node, "simple-audio-card,codec");
-	if (np) {
+		/* CODEC sub-node */
+		np = of_get_next_child(node, np);
+		if (strcmp(np->name, "simple-audio-card,codec") != 0) {
+			dev_err(dev, "Bad CODEC DAI\n");
+			ret = -EINVAL;
+			goto err;
+		}
 		ret = asoc_simple_card_sub_parse_of(np, daifmt,
-						  &priv->dais->codec_dai,
+						  &priv->dais[num].codec_dai,
 						  &dai_link->codec_of_node,
 						  &dai_link->codec_dai_name);
-		of_node_put(np);
-	}
-	if (ret < 0)
-		return ret;
+		if (ret < 0)
+			goto err;
+
+		if (!dai_link->cpu_dai_name || !dai_link->codec_dai_name) {
+			ret = -EINVAL;
+			goto err;
+		}
 
-	if (!dai_link->cpu_dai_name || !dai_link->codec_dai_name)
-		return -EINVAL;
+		/* simple-card assumes platform == cpu */
+		dai_link->platform_of_node = dai_link->cpu_of_node;
+
+		name = devm_kzalloc(dev,
+				    strlen(dai_link->cpu_dai_name)   +
+				    strlen(dai_link->codec_dai_name) + 2,
+				    GFP_KERNEL);
+		sprintf(name, "%s-%s", dai_link->cpu_dai_name,
+					dai_link->codec_dai_name);
+		dai_link->name = dai_link->stream_name = name;
+	}
 
 	/* card name is created from CPU/CODEC dai name */
-	name = devm_kzalloc(dev,
-			    strlen(dai_link->cpu_dai_name)   +
-			    strlen(dai_link->codec_dai_name) + 2,
-			    GFP_KERNEL);
-	sprintf(name, "%s-%s", dai_link->cpu_dai_name,
-				dai_link->codec_dai_name);
+	dai_link = priv->snd_card.dai_link;
 	if (!priv->snd_card.name)
-		priv->snd_card.name = name;
-	dai_link->name = dai_link->stream_name = name;
-
-	/* simple-card assumes platform == cpu */
-	dai_link->platform_of_node = dai_link->cpu_of_node;
+		priv->snd_card.name = dai_link->name;
 
-	dev_dbg(dev, "card-name : %s\n", name);
+	dev_dbg(dev, "card-name : %s\n", priv->snd_card.name);
 	dev_dbg(dev, "platform : %04x\n", daifmt);
 	dev_dbg(dev, "cpu : %s / %04x / %d\n",
 		dai_link->cpu_dai_name,
@@ -235,18 +249,11 @@ static int asoc_simple_card_parse_of(struct device_node *node,
 		priv->dais->codec_dai.fmt,
 		priv->dais->codec_dai.sysclk);
 
-	/*
-	 * soc_bind_dai_link() will check cpu name
-	 * after of_node matching if dai_link has cpu_dai_name.
-	 * but, it will never match if name was created by fmt_single_name()
-	 * remove cpu_dai_name to escape name matching.
-	 * see
-	 *	fmt_single_name()
-	 *	fmt_multiple_name()
-	 */
-	dai_link->cpu_dai_name = NULL;
-
 	return 0;
+
+err:
+	of_node_put(np);
+	return ret;
 }
 
 /* update the reference count of the devices nodes at end of probe */
@@ -276,10 +283,22 @@ static int asoc_simple_card_probe(struct platform_device *pdev)
 	struct snd_soc_dai_link *dai_link;
 	struct device_node *np = pdev->dev.of_node;
 	struct device *dev = &pdev->dev;
-	int ret;
+	int num_links, ret;
+
+	/* get the number of DAI links */
+	if (np) {
+		num_links = of_get_child_count(np);
+		if (num_links == 0 || (num_links & 1)) {
+			dev_err(&pdev->dev, "Bad number of DAI links\n");
+			return -EINVAL;
+		}
+		num_links /= 2;
+	} else {
+		num_links = 1;
+	}
 
 	priv = devm_kzalloc(dev,
-			sizeof(*priv) + sizeof(*dai_link),
+			sizeof(*priv) + sizeof(*dai_link) * num_links,
 			GFP_KERNEL);
 	if (!priv)
 		return -ENOMEM;
@@ -291,11 +310,11 @@ static int asoc_simple_card_probe(struct platform_device *pdev)
 	priv->snd_card.dev = dev;
 	dai_link = priv->dai_link;
 	priv->snd_card.dai_link = dai_link;
-	priv->snd_card.num_links = 1;
+	priv->snd_card.num_links = num_links;
 
 	/* get room for the other properties */
 	priv->dais = devm_kzalloc(dev,
-			sizeof(*priv->dais),
+			sizeof(*priv->dais) * num_links,
 			GFP_KERNEL);
 	if (!priv->dais)
 		return -ENOMEM;
@@ -308,6 +327,19 @@ static int asoc_simple_card_probe(struct platform_device *pdev)
 				dev_err(dev, "parse error %d\n", ret);
 			goto err;
 		}
+
+		/*
+		 * soc_bind_dai_link() will check cpu name
+		 * after of_node matching if dai_link has cpu_dai_name.
+		 * but, it will never match if name was created by fmt_single_name()
+		 * remove cpu_dai_name to escape name matching.
+		 * see
+		 *	fmt_single_name()
+		 *	fmt_multiple_name()
+		 */
+		if (num_links == 1)
+			dai_link->cpu_dai_name = NULL;
+
 	} else {
 		struct asoc_simple_card_info *cinfo;
 
-- 
1.9.0

