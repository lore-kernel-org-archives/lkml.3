Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932385AbaBUPeq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 10:34:46 -0500
Received: from smtp1-g21.free.fr ([212.27.42.1]:33780 "EHLO smtp1-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932317AbaBUPeo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 10:34:44 -0500
X-Mailbox-Line: From a6c0e6447da2ce2cc6fa403140550410e7778cc8 Mon Sep 17 00:00:00 2001
Message-Id: <a6c0e6447da2ce2cc6fa403140550410e7778cc8.1392995566.git.moinejf@free.fr>
In-Reply-To: <cover.1392995566.git.moinejf@free.fr>
References: <cover.1392995566.git.moinejf@free.fr>
From: Jean-Francois Moine <moinejf@free.fr>
Date: Fri, 21 Feb 2014 09:56:45 +0100
Subject: [PATCH 3/4] ASoC: simple-card: accept many DAI links
To: Mark Brown <broonie@kernel.org>
Cc: alsa-devel@alsa-project.org,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        linux-kernel@vger.kernel.org, Xiubo Li <Li.Xiubo@freescale.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some simple audio cards may have many DAI links.
This patch makes them handled by the simple-card driver.

Signed-off-by: Jean-Francois Moine <moinejf@free.fr>
---
 sound/soc/generic/simple-card.c | 100 ++++++++++++++++++++++++++--------------
 1 file changed, 66 insertions(+), 34 deletions(-)

diff --git a/sound/soc/generic/simple-card.c b/sound/soc/generic/simple-card.c
index a75a8bb..6e0e580 100644
--- a/sound/soc/generic/simple-card.c
+++ b/sound/soc/generic/simple-card.c
@@ -93,6 +93,9 @@ asoc_simple_card_sub_parse_of(struct device_node *np,
 	if (ret < 0)
 		return ret;
 
+	if (!dai)
+		return 0;
+
 	/*
 	 * bitclock-inversion, frame-inversion
 	 * bitclock-master,    frame-master
@@ -135,7 +138,7 @@ static int asoc_simple_card_parse_of(struct device_node *node,
 	struct snd_soc_dai_link *dai_link = priv->snd_card.dai_link;
 	struct device_node *np;
 	char *name;
-	int ret;
+	int first_link, ret;
 
 	/* parsing the card name from DT */
 	snd_soc_of_parse_card_name(&priv->snd_card, "simple-audio-card,name");
@@ -160,50 +163,67 @@ static int asoc_simple_card_parse_of(struct device_node *node,
 			return ret;
 	}
 
-	/* CPU sub-node */
-	ret = -EINVAL;
-	np = of_get_child_by_name(node, "simple-audio-card,cpu");
-	if (np) {
+	/* loop on the DAI links */
+	np = NULL;
+	first_link = 1;
+	for (;;) {
+		np = of_get_next_child(node, np);
+		if (!np)
+			break;
+
+		/* CPU sub-node */
+		if (strcmp(np->name, "simple-audio-card,cpu") != 0) {
+			dev_err(dev, "Bad CPU DAI\n");
+			of_node_put(np);
+			return -EINVAL;
+		}
 		ret = asoc_simple_card_sub_parse_of(np, priv->daifmt,
-						  &priv->cpu_dai,
+					first_link ? &priv->cpu_dai : NULL,
 						  &dai_link->cpu_of_node,
 						  &dai_link->cpu_dai_name);
 		of_node_put(np);
-	}
-	if (ret < 0)
-		return ret;
+		if (ret < 0)
+			return ret;
 
-	/* CODEC sub-node */
-	ret = -EINVAL;
-	np = of_get_child_by_name(node, "simple-audio-card,codec");
-	if (np) {
+		/* CODEC sub-node */
+		np = of_get_next_child(node, np);
+		if (strcmp(np->name, "simple-audio-card,codec") != 0) {
+			dev_err(dev, "Bad CODEC DAI\n");
+			of_node_put(np);
+			return -EINVAL;
+		}
 		ret = asoc_simple_card_sub_parse_of(np, priv->daifmt,
-						  &priv->codec_dai,
+					first_link ? &priv->codec_dai : NULL,
 						  &dai_link->codec_of_node,
 						  &dai_link->codec_dai_name);
 		of_node_put(np);
-	}
-	if (ret < 0)
-		return ret;
+		if (ret < 0)
+			return ret;
+
+		if (!dai_link->cpu_dai_name || !dai_link->codec_dai_name)
+			return -EINVAL;
 
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
+
+		dai_link++;
+		first_link = 0;
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
 	dev_dbg(dev, "platform : %04x\n", priv->daifmt);
 	dev_dbg(dev, "cpu : %s / %04x / %d\n",
 		dai_link->cpu_dai_name,
@@ -243,10 +263,22 @@ static int asoc_simple_card_probe(struct platform_device *pdev)
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
@@ -258,7 +290,7 @@ static int asoc_simple_card_probe(struct platform_device *pdev)
 	priv->snd_card.dev = dev;
 	dai_link = (struct snd_soc_dai_link *) (priv + 1);
 	priv->snd_card.dai_link = dai_link;
-	priv->snd_card.num_links = 1;
+	priv->snd_card.num_links = num_links;
 
 	if (np && of_device_is_available(np)) {
 
-- 
1.9.0

