Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755368AbaCOLmS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Mar 2014 07:42:18 -0400
Received: from smtp2-g21.free.fr ([212.27.42.2]:48191 "EHLO smtp2-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754378AbaCOLmG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Mar 2014 07:42:06 -0400
X-Mailbox-Line: From 1cf50fea2306bcb05987533042dbf1495b2c6f07 Mon Sep 17 00:00:00 2001
Message-Id: <1cf50fea2306bcb05987533042dbf1495b2c6f07.1394883134.git.moinejf@free.fr>
In-Reply-To: <cover.1394883134.git.moinejf@free.fr>
References: <cover.1394883134.git.moinejf@free.fr>
From: Jean-Francois Moine <moinejf@free.fr>
Date: Sat, 15 Mar 2014 12:09:39 +0100
Subject: [PATCH v3 2/4] ASoC: simple-card: dynamically allocate the DAI link
 and properties
To: Mark Brown <broonie@kernel.org>
Cc: alsa-devel@alsa-project.org,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        linux-kernel@vger.kernel.org, Xiubo Li <Li.Xiubo@freescale.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The DAI link array and the properties (fmt, sysclk slots) are
hard-coded for a single CPU / CODEC link.

This patch dynamically allocates the DAI link array and the
properties with the aim of supporting many DAI links.

Signed-off-by: Jean-Francois Moine <moinejf@free.fr>
---
 sound/soc/generic/simple-card.c | 49 +++++++++++++++++++++++++----------------
 1 file changed, 30 insertions(+), 19 deletions(-)

diff --git a/sound/soc/generic/simple-card.c b/sound/soc/generic/simple-card.c
index ca7e63e..a55dc46 100644
--- a/sound/soc/generic/simple-card.c
+++ b/sound/soc/generic/simple-card.c
@@ -20,9 +20,11 @@
 
 struct simple_card_data {
 	struct snd_soc_card snd_card;
-	struct asoc_simple_dai cpu_dai;
-	struct asoc_simple_dai codec_dai;
-	struct snd_soc_dai_link snd_link;
+	struct simple_dais {
+		struct asoc_simple_dai cpu_dai;
+		struct asoc_simple_dai codec_dai;
+	} *dais;
+	struct snd_soc_dai_link dai_link[];	/* dynamically allocated */
 };
 
 static int __asoc_simple_card_dai_init(struct snd_soc_dai *dai,
@@ -70,11 +72,11 @@ static int asoc_simple_card_dai_init(struct snd_soc_pcm_runtime *rtd)
 	struct snd_soc_dai *cpu = rtd->cpu_dai;
 	int ret;
 
-	ret = __asoc_simple_card_dai_init(codec, &priv->codec_dai);
+	ret = __asoc_simple_card_dai_init(codec, &priv->dais->codec_dai);
 	if (ret < 0)
 		return ret;
 
-	ret = __asoc_simple_card_dai_init(cpu, &priv->cpu_dai);
+	ret = __asoc_simple_card_dai_init(cpu, &priv->dais->cpu_dai);
 	if (ret < 0)
 		return ret;
 
@@ -184,7 +186,7 @@ static int asoc_simple_card_parse_of(struct device_node *node,
 	np = of_get_child_by_name(node, "simple-audio-card,cpu");
 	if (np) {
 		ret = asoc_simple_card_sub_parse_of(np, daifmt,
-						  &priv->cpu_dai,
+						  &priv->dais->cpu_dai,
 						  &dai_link->cpu_of_node,
 						  &dai_link->cpu_dai_name);
 		of_node_put(np);
@@ -197,7 +199,7 @@ static int asoc_simple_card_parse_of(struct device_node *node,
 	np = of_get_child_by_name(node, "simple-audio-card,codec");
 	if (np) {
 		ret = asoc_simple_card_sub_parse_of(np, daifmt,
-						  &priv->codec_dai,
+						  &priv->dais->codec_dai,
 						  &dai_link->codec_of_node,
 						  &dai_link->codec_dai_name);
 		of_node_put(np);
@@ -226,12 +228,12 @@ static int asoc_simple_card_parse_of(struct device_node *node,
 	dev_dbg(dev, "platform : %04x\n", daifmt);
 	dev_dbg(dev, "cpu : %s / %04x / %d\n",
 		dai_link->cpu_dai_name,
-		priv->cpu_dai.fmt,
-		priv->cpu_dai.sysclk);
+		priv->dais->cpu_dai.fmt,
+		priv->dais->cpu_dai.sysclk);
 	dev_dbg(dev, "codec : %s / %04x / %d\n",
 		dai_link->codec_dai_name,
-		priv->codec_dai.fmt,
-		priv->codec_dai.sysclk);
+		priv->dais->codec_dai.fmt,
+		priv->dais->codec_dai.sysclk);
 
 	/*
 	 * soc_bind_dai_link() will check cpu name
@@ -276,7 +278,9 @@ static int asoc_simple_card_probe(struct platform_device *pdev)
 	struct device *dev = &pdev->dev;
 	int ret;
 
-	priv = devm_kzalloc(dev, sizeof(*priv), GFP_KERNEL);
+	priv = devm_kzalloc(dev,
+			sizeof(*priv) + sizeof(*dai_link),
+			GFP_KERNEL);
 	if (!priv)
 		return -ENOMEM;
 
@@ -285,10 +289,17 @@ static int asoc_simple_card_probe(struct platform_device *pdev)
 	 */
 	priv->snd_card.owner = THIS_MODULE;
 	priv->snd_card.dev = dev;
-	dai_link = &priv->snd_link;
+	dai_link = priv->dai_link;
 	priv->snd_card.dai_link = dai_link;
 	priv->snd_card.num_links = 1;
 
+	/* get room for the other properties */
+	priv->dais = devm_kzalloc(dev,
+			sizeof(*priv->dais),
+			GFP_KERNEL);
+	if (!priv->dais)
+		return -ENOMEM;
+
 	if (np && of_device_is_available(np)) {
 
 		ret = asoc_simple_card_parse_of(np, priv, dev);
@@ -322,13 +333,13 @@ static int asoc_simple_card_probe(struct platform_device *pdev)
 		dai_link->codec_name	= cinfo->codec;
 		dai_link->cpu_dai_name	= cinfo->cpu_dai.name;
 		dai_link->codec_dai_name = cinfo->codec_dai.name;
-		memcpy(&priv->cpu_dai, &cinfo->cpu_dai,
-						sizeof(priv->cpu_dai));
-		memcpy(&priv->codec_dai, &cinfo->codec_dai,
-						sizeof(priv->codec_dai));
+		memcpy(&priv->dais->cpu_dai, &cinfo->cpu_dai,
+						sizeof(priv->dais->cpu_dai));
+		memcpy(&priv->dais->codec_dai, &cinfo->codec_dai,
+						sizeof(priv->dais->codec_dai));
 
-		priv->cpu_dai.fmt	|= cinfo->daifmt;
-		priv->codec_dai.fmt	|= cinfo->daifmt;
+		priv->dais->cpu_dai.fmt		|= cinfo->daifmt;
+		priv->dais->codec_dai.fmt	|= cinfo->daifmt;
 	}
 
 	/*
-- 
1.9.0

