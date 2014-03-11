Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754667AbaCKKl0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 06:41:26 -0400
Received: from smtp3-g21.free.fr ([212.27.42.3]:48138 "EHLO smtp3-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754535AbaCKKlX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 06:41:23 -0400
X-Mailbox-Line: From d71a2b62b331302772d35b3cd35c6dc5da1e9e5d Mon Sep 17 00:00:00 2001
Message-Id: <d71a2b62b331302772d35b3cd35c6dc5da1e9e5d.1394533640.git.moinejf@free.fr>
In-Reply-To: <cover.1394533640.git.moinejf@free.fr>
References: <cover.1394533640.git.moinejf@free.fr>
From: Jean-Francois Moine <moinejf@free.fr>
Date: Tue, 11 Mar 2014 10:36:10 +0100
Subject: [PATCH v2 3/4] ASoC: simple-card: accept many DAI links
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
 sound/soc/generic/simple-card.c | 132 ++++++++++++++++++++++++++--------------
 1 file changed, 85 insertions(+), 47 deletions(-)

diff --git a/sound/soc/generic/simple-card.c b/sound/soc/generic/simple-card.c
index 2710b52..8188c34 100644
--- a/sound/soc/generic/simple-card.c
+++ b/sound/soc/generic/simple-card.c
@@ -107,6 +107,9 @@ asoc_simple_card_sub_parse_of(struct device_node *np,
 	if (ret < 0)
 		return ret;
 
+	if (!dai)
+		return 0;
+
 	/* parse TDM slot */
 	ret = snd_soc_of_parse_tdm_slot(np, &dai->slots, &dai->slot_width);
 	if (ret)
@@ -154,7 +157,7 @@ static int asoc_simple_card_parse_of(struct device_node *node,
 	struct snd_soc_dai_link *dai_link = priv->snd_card.dai_link;
 	struct device_node *np;
 	char *name;
-	int ret;
+	int first_link, ret;
 
 	/* parsing the card name from DT */
 	snd_soc_of_parse_card_name(&priv->snd_card, "simple-audio-card,name");
@@ -179,50 +182,67 @@ static int asoc_simple_card_parse_of(struct device_node *node,
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
+			ret = -EINVAL;
+			goto err;
+		}
 		ret = asoc_simple_card_sub_parse_of(np, priv->daifmt,
-						  &priv->cpu_dai,
+					first_link ? &priv->cpu_dai : NULL,
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
 		ret = asoc_simple_card_sub_parse_of(np, priv->daifmt,
-						  &priv->codec_dai,
+					first_link ? &priv->codec_dai : NULL,
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
+		priv->snd_card.name = dai_link->name;
 
-	/* simple-card assumes platform == cpu */
-	dai_link->platform_of_node = dai_link->cpu_of_node;
-
-	dev_dbg(dev, "card-name : %s\n", name);
+	dev_dbg(dev, "card-name : %s\n", priv->snd_card.name);
 	dev_dbg(dev, "platform : %04x\n", priv->daifmt);
 	dev_dbg(dev, "cpu : %s / %04x / %d\n",
 		dai_link->cpu_dai_name,
@@ -233,18 +253,11 @@ static int asoc_simple_card_parse_of(struct device_node *node,
 		priv->codec_dai.fmt,
 		priv->codec_dai.sysclk);
 
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
@@ -274,10 +287,22 @@ static int asoc_simple_card_probe(struct platform_device *pdev)
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
@@ -289,7 +314,7 @@ static int asoc_simple_card_probe(struct platform_device *pdev)
 	priv->snd_card.dev = dev;
 	dai_link = priv->dai_link;
 	priv->snd_card.dai_link = dai_link;
-	priv->snd_card.num_links = 1;
+	priv->snd_card.num_links = num_links;
 
 	if (np && of_device_is_available(np)) {
 
@@ -299,6 +324,19 @@ static int asoc_simple_card_probe(struct platform_device *pdev)
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

