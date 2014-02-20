Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932291AbaBUPe3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 10:34:29 -0500
Received: from smtp1-g21.free.fr ([212.27.42.1]:32862 "EHLO smtp1-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932195AbaBUPe0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 10:34:26 -0500
X-Mailbox-Line: From 4dca81f45b67a4dcb21271e57409ba114c3b59cb Mon Sep 17 00:00:00 2001
Message-Id: <4dca81f45b67a4dcb21271e57409ba114c3b59cb.1392995566.git.moinejf@free.fr>
In-Reply-To: <cover.1392995566.git.moinejf@free.fr>
References: <cover.1392995566.git.moinejf@free.fr>
From: Jean-Francois Moine <moinejf@free.fr>
Date: Thu, 20 Feb 2014 18:25:12 +0100
Subject: [PATCH 1/4] ASoC: simple-card: Fix device node locks
To: Mark Brown <broonie@kernel.org>
Cc: alsa-devel@alsa-project.org,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        linux-kernel@vger.kernel.org, Xiubo Li <Li.Xiubo@freescale.com>,
        devicetree@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some device nodes stay locked and some other ones are not locked
while being used during the card lifetime.

Signed-off-by: Jean-Francois Moine <moinejf@free.fr>
---
 sound/soc/generic/simple-card.c | 51 +++++++++++++++++++++++++++++++----------
 1 file changed, 39 insertions(+), 12 deletions(-)

diff --git a/sound/soc/generic/simple-card.c b/sound/soc/generic/simple-card.c
index 4fe8abc..8809ab4 100644
--- a/sound/soc/generic/simple-card.c
+++ b/sound/soc/generic/simple-card.c
@@ -92,7 +92,7 @@ asoc_simple_card_sub_parse_of(struct device_node *np,
 	/* get dai->name */
 	ret = snd_soc_of_get_dai_name(np, name);
 	if (ret < 0)
-		goto parse_error;
+		return ret;
 
 	/*
 	 * bitclock-inversion, frame-inversion
@@ -112,7 +112,7 @@ asoc_simple_card_sub_parse_of(struct device_node *np,
 		clk = of_clk_get(np, 0);
 		if (IS_ERR(clk)) {
 			ret = PTR_ERR(clk);
-			goto parse_error;
+			return ret;
 		}
 
 		dai->sysclk = clk_get_rate(clk);
@@ -126,12 +126,7 @@ asoc_simple_card_sub_parse_of(struct device_node *np,
 			dai->sysclk = clk_get_rate(clk);
 	}
 
-	ret = 0;
-
-parse_error:
-	of_node_put(node);
-
-	return ret;
+	return 0;
 }
 
 static int asoc_simple_card_parse_of(struct device_node *node,
@@ -169,22 +164,26 @@ static int asoc_simple_card_parse_of(struct device_node *node,
 	/* CPU sub-node */
 	ret = -EINVAL;
 	np = of_get_child_by_name(node, "simple-audio-card,cpu");
-	if (np)
+	if (np) {
 		ret = asoc_simple_card_sub_parse_of(np, priv->daifmt,
 						  &priv->cpu_dai,
 						  &dai_link->cpu_of_node,
 						  &dai_link->cpu_dai_name);
+		of_node_put(np);
+	}
 	if (ret < 0)
 		return ret;
 
 	/* CODEC sub-node */
 	ret = -EINVAL;
 	np = of_get_child_by_name(node, "simple-audio-card,codec");
-	if (np)
+	if (np) {
 		ret = asoc_simple_card_sub_parse_of(np, priv->daifmt,
 						  &priv->codec_dai,
 						  &dai_link->codec_of_node,
 						  &dai_link->codec_dai_name);
+		of_node_put(np);
+	}
 	if (ret < 0)
 		return ret;
 
@@ -219,6 +218,26 @@ static int asoc_simple_card_parse_of(struct device_node *node,
 	return 0;
 }
 
+static int asoc_simple_card_purge(struct platform_device *pdev)
+{
+	struct snd_soc_card *card = platform_get_drvdata(pdev);
+	struct snd_soc_dai_link *dai_link;
+	struct device_node *np;
+	int num_links;
+
+	for (num_links = 0, dai_link = card->dai_link;
+	     num_links < card->num_links;
+	     num_links++, dai_link++) {
+		np = (struct device_node *) dai_link->cpu_of_node;
+		if (np)
+			of_node_put(np);
+		np = (struct device_node *) dai_link->codec_of_node;
+		if (np)
+			of_node_put(np);
+	}
+	return 0;
+}
+
 static int asoc_simple_card_probe(struct platform_device *pdev)
 {
 	struct simple_card_data *priv;
@@ -246,7 +265,7 @@ static int asoc_simple_card_probe(struct platform_device *pdev)
 		if (ret < 0) {
 			if (ret != -EPROBE_DEFER)
 				dev_err(dev, "parse error %d\n", ret);
-			return ret;
+			goto err;
 		}
 	} else {
 		struct asoc_simple_card_info *cinfo;
@@ -287,7 +306,14 @@ static int asoc_simple_card_probe(struct platform_device *pdev)
 
 	snd_soc_card_set_drvdata(&priv->snd_card, priv);
 
-	return devm_snd_soc_register_card(&pdev->dev, &priv->snd_card);
+	ret = devm_snd_soc_register_card(&pdev->dev, &priv->snd_card);
+	if (ret < 0)
+		goto err;
+	return 0;
+
+err:
+	asoc_simple_card_purge(pdev);
+	return ret;
 }
 
 static const struct of_device_id asoc_simple_of_match[] = {
@@ -303,6 +329,7 @@ static struct platform_driver asoc_simple_card = {
 		.of_match_table = asoc_simple_of_match,
 	},
 	.probe		= asoc_simple_card_probe,
+	.remove		= asoc_simple_card_purge,
 };
 
 module_platform_driver(asoc_simple_card);
-- 
1.9.0

