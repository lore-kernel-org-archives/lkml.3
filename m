Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754025AbaCKKlK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 06:41:10 -0400
Received: from smtp3-g21.free.fr ([212.27.42.3]:47100 "EHLO smtp3-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751718AbaCKKlF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 06:41:05 -0400
X-Mailbox-Line: From bfb5bfeb1b934384d84fab0045ce65c9b2766f31 Mon Sep 17 00:00:00 2001
Message-Id: <bfb5bfeb1b934384d84fab0045ce65c9b2766f31.1394533640.git.moinejf@free.fr>
In-Reply-To: <cover.1394533640.git.moinejf@free.fr>
References: <cover.1394533640.git.moinejf@free.fr>
From: Jean-Francois Moine <moinejf@free.fr>
Date: Tue, 11 Mar 2014 10:03:40 +0100
Subject: [PATCH v2 1/4] ASoC: simple-card: Fix the reference count of device
 nodes
To: Mark Brown <broonie@kernel.org>
Cc: alsa-devel@alsa-project.org,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        linux-kernel@vger.kernel.org, Xiubo Li <Li.Xiubo@freescale.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The reference count of some device nodes is not correctly reset
at end of card probe.

Signed-off-by: Jean-Francois Moine <moinejf@free.fr>
---
 sound/soc/generic/simple-card.c | 50 ++++++++++++++++++++++++++++++-----------
 1 file changed, 37 insertions(+), 13 deletions(-)

diff --git a/sound/soc/generic/simple-card.c b/sound/soc/generic/simple-card.c
index 5dd4769..dcf37fb 100644
--- a/sound/soc/generic/simple-card.c
+++ b/sound/soc/generic/simple-card.c
@@ -105,12 +105,12 @@ asoc_simple_card_sub_parse_of(struct device_node *np,
 	/* get dai->name */
 	ret = snd_soc_of_get_dai_name(np, name);
 	if (ret < 0)
-		goto parse_error;
+		return ret;
 
 	/* parse TDM slot */
 	ret = snd_soc_of_parse_tdm_slot(np, &dai->slots, &dai->slot_width);
 	if (ret)
-		goto parse_error;
+		return ret;
 
 	/*
 	 * bitclock-inversion, frame-inversion
@@ -130,7 +130,7 @@ asoc_simple_card_sub_parse_of(struct device_node *np,
 		clk = of_clk_get(np, 0);
 		if (IS_ERR(clk)) {
 			ret = PTR_ERR(clk);
-			goto parse_error;
+			return ret;
 		}
 
 		dai->sysclk = clk_get_rate(clk);
@@ -144,12 +144,7 @@ asoc_simple_card_sub_parse_of(struct device_node *np,
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
@@ -187,22 +182,26 @@ static int asoc_simple_card_parse_of(struct device_node *node,
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
 
@@ -248,6 +247,27 @@ static int asoc_simple_card_parse_of(struct device_node *node,
 	return 0;
 }
 
+/* update the reference count of the devices nodes at end of probe */
+static int asoc_simple_card_unref(struct platform_device *pdev)
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
@@ -275,7 +295,7 @@ static int asoc_simple_card_probe(struct platform_device *pdev)
 		if (ret < 0) {
 			if (ret != -EPROBE_DEFER)
 				dev_err(dev, "parse error %d\n", ret);
-			return ret;
+			goto err;
 		}
 	} else {
 		struct asoc_simple_card_info *cinfo;
@@ -318,7 +338,11 @@ static int asoc_simple_card_probe(struct platform_device *pdev)
 
 	snd_soc_card_set_drvdata(&priv->snd_card, priv);
 
-	return devm_snd_soc_register_card(&pdev->dev, &priv->snd_card);
+	ret = devm_snd_soc_register_card(&pdev->dev, &priv->snd_card);
+
+err:
+	asoc_simple_card_unref(pdev);
+	return ret;
 }
 
 static const struct of_device_id asoc_simple_of_match[] = {
-- 
1.9.0

