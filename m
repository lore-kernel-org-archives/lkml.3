Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752232AbaKJI0u (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 03:26:50 -0500
Received: from smtp4-g21.free.fr ([212.27.42.4]:3221 "EHLO smtp4-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752197AbaKJI0s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 03:26:48 -0500
X-Mailbox-Line: From d49d348da24fbd96e7be51ba2839ee8bc821ddec Mon Sep 17 00:00:00 2001
Message-Id: <d49d348da24fbd96e7be51ba2839ee8bc821ddec.1415605717.git.moinejf@free.fr>
In-Reply-To: <cover.1415605716.git.moinejf@free.fr>
References: <cover.1415605716.git.moinejf@free.fr>
From: Jean-Francois Moine <moinejf@free.fr>
Date: Sun, 9 Nov 2014 12:22:21 +0100
Subject: [PATCH v4 3/4] ASoC: simple-card: add multi-CODECs in DT
To: Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>
Cc: alsa-devel@alsa-project.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch allows many CODECs per link to be defined in the device tree.

Signed-off-by: Jean-Francois Moine <moinejf@free.fr>
---
 .../devicetree/bindings/sound/simple-card.txt      | 20 ++----
 sound/soc/generic/simple-card.c                    | 81 ++++++++++++----------
 2 files changed, 53 insertions(+), 48 deletions(-)

diff --git a/Documentation/devicetree/bindings/sound/simple-card.txt b/Documentation/devicetree/bindings/sound/simple-card.txt
index c3cba60..debe35c 100644
--- a/Documentation/devicetree/bindings/sound/simple-card.txt
+++ b/Documentation/devicetree/bindings/sound/simple-card.txt
@@ -65,7 +65,10 @@ properties should also be placed in the codec node if needed.
 
 Required CPU/CODEC subnodes properties:
 
-- sound-dai				: phandle and port of CPU/CODEC
+either
+  - sound-dai				: phandle and port of CPU/CODEC
+or
+  - sound-dais				: list of phandle and port of CODECs
 
 Optional CPU/CODEC subnodes properties:
 
@@ -119,7 +122,7 @@ sh_fsi2: sh_fsi2@ec230000 {
 	interrupts = <0 146 0x4>;
 };
 
-Example 2 - many DAI links:
+Example 2 - many DAI links and multi-CODECs:
 
 sound {
 	compatible = "simple-audio-card";
@@ -135,21 +138,12 @@ sound {
 		};
 	};
 
-	simple-audio-card,dai-link@1 {		/* S/PDIF - HDMI */
+	simple-audio-card,dai-link@1 {		/* S/PDIF - HDMI & S/PDIF */
 		cpu {
 			sound-dai = <&audio1 1>;
 		};
 		codec {
-			sound-dai = <&tda998x 1>;
-		};
-	};
-
-	simple-audio-card,dai-link@2 {		/* S/PDIF - S/PDIF */
-		cpu {
-			sound-dai = <&audio1 1>;
-		};
-		codec {
-			sound-dai = <&spdif_codec>;
+			sound-dais = <&tda998x 1>, <&spdif_codec>;
 		};
 	};
 };
diff --git a/sound/soc/generic/simple-card.c b/sound/soc/generic/simple-card.c
index ece22d5..61f9500 100644
--- a/sound/soc/generic/simple-card.c
+++ b/sound/soc/generic/simple-card.c
@@ -172,34 +172,12 @@ static int asoc_simple_card_dai_init(struct snd_soc_pcm_runtime *rtd)
 static int
 asoc_simple_card_sub_parse_of(struct device_node *np,
 			      struct asoc_simple_dai *dai,
-			      struct device_node **p_node,
-			      const char **name,
-			      int *args_count)
+			      struct device_node *dai_np)
 {
-	struct of_phandle_args args;
 	struct clk *clk;
 	u32 val;
 	int ret;
 
-	/*
-	 * Get node via "sound-dai = <&phandle port>"
-	 * it will be used as xxx_of_node on soc_bind_dai_link()
-	 */
-	ret = of_parse_phandle_with_args(np, "sound-dai",
-					 "#sound-dai-cells", 0, &args);
-	if (ret)
-		return ret;
-
-	*p_node = args.np;
-
-	if (args_count)
-		*args_count = args.args_count;
-
-	/* Get dai->name */
-	ret = snd_soc_of_get_dai_name(np, name);
-	if (ret < 0)
-		return ret;
-
 	/* Parse TDM slot */
 	ret = snd_soc_of_parse_tdm_slot(np, &dai->slots, &dai->slot_width);
 	if (ret)
@@ -222,7 +200,7 @@ asoc_simple_card_sub_parse_of(struct device_node *np,
 	} else if (!of_property_read_u32(np, "system-clock-frequency", &val)) {
 		dai->sysclk = val;
 	} else {
-		clk = of_clk_get(args.np, 0);
+		clk = of_clk_get(dai_np, 0);
 		if (!IS_ERR(clk))
 			dai->sysclk = clk_get_rate(clk);
 	}
@@ -286,10 +264,12 @@ static int asoc_simple_card_dai_link_of(struct device_node *node,
 	struct simple_dai_props *dai_props = simple_priv_to_props(priv, idx);
 	struct device_node *cpu = NULL;
 	struct device_node *codec = NULL;
+	struct snd_soc_dai_link_component *component;
+	struct of_phandle_args args;
 	char *name;
 	char prop[128];
 	char *prefix = "";
-	int ret, cpu_args;
+	int ret, cpu_args, i;
 
 	/* For single DAI link & old style of DT node */
 	if (is_top_level_node)
@@ -312,16 +292,30 @@ static int asoc_simple_card_dai_link_of(struct device_node *node,
 	if (ret < 0)
 		goto dai_link_of_err;
 
+	/* Get the CPU node and name */
+	ret = of_parse_phandle_with_args(cpu, "sound-dai",
+					 "#sound-dai-cells", 0, &args);
+	if (ret)
+		goto dai_link_of_err;
+	dai_link->cpu_of_node = args.np;
+	cpu_args = args.args_count;
+
+	ret = snd_soc_of_get_dai_name(cpu, &dai_link->cpu_dai_name);
+	if (ret < 0)
+		goto dai_link_of_err;
+
 	ret = asoc_simple_card_sub_parse_of(cpu, &dai_props->cpu_dai,
-					    &dai_link->cpu_of_node,
-					    &dai_link->cpu_dai_name,
-					    &cpu_args);
+					    dai_link->cpu_of_node);
+	if (ret < 0)
+		goto dai_link_of_err;
+
+	/* Get the node and name of the CODEC(s) */
+	ret = snd_soc_of_get_dai_link_codecs(dev, codec, dai_link);
 	if (ret < 0)
 		goto dai_link_of_err;
 
 	ret = asoc_simple_card_sub_parse_of(codec, &dai_props->codec_dai,
-					    &dai_link->codec_of_node,
-					    &dai_link->codec_dai_name, NULL);
+					    dai_link->codecs[0].of_node);
 	if (ret < 0)
 		goto dai_link_of_err;
 
@@ -336,10 +330,10 @@ static int asoc_simple_card_dai_link_of(struct device_node *node,
 	/* DAI link name is created from CPU/CODEC dai name */
 	name = devm_kzalloc(dev,
 			    strlen(dai_link->cpu_dai_name)   +
-			    strlen(dai_link->codec_dai_name) + 2,
+			    strlen(dai_link->codecs[0].dai_name) + 2,
 			    GFP_KERNEL);
 	sprintf(name, "%s-%s", dai_link->cpu_dai_name,
-				dai_link->codec_dai_name);
+				dai_link->codecs[0].dai_name);
 	dai_link->name = dai_link->stream_name = name;
 	dai_link->ops = &asoc_simple_card_ops;
 	dai_link->init = asoc_simple_card_dai_init;
@@ -350,7 +344,7 @@ static int asoc_simple_card_dai_link_of(struct device_node *node,
 		dai_props->cpu_dai.fmt,
 		dai_props->cpu_dai.sysclk);
 	dev_dbg(dev, "\tcodec : %s / %04x / %d\n",
-		dai_link->codec_dai_name,
+		dai_link->codecs[0].dai_name,
 		dai_props->codec_dai.fmt,
 		dai_props->codec_dai.sysclk);
 
@@ -365,8 +359,18 @@ static int asoc_simple_card_dai_link_of(struct device_node *node,
 	 */
 	if (!cpu_args)
 		dai_link->cpu_dai_name = NULL;
+	goto out;
 
 dai_link_of_err:
+	for (i = 0, component = dai_link->codecs;
+	     i < dai_link->num_codecs;
+	     i++, component++) {
+		if (!component->of_node)
+			break;
+		of_node_put(component->of_node);
+		component->of_node = NULL;
+	}
+out:
 	of_node_put(cpu);
 	of_node_put(codec);
 
@@ -456,13 +460,20 @@ static int asoc_simple_card_unref(struct platform_device *pdev)
 {
 	struct snd_soc_card *card = platform_get_drvdata(pdev);
 	struct snd_soc_dai_link *dai_link;
-	int num_links;
+	struct snd_soc_dai_link_component *component;
+	int num_links, i;
 
 	for (num_links = 0, dai_link = card->dai_link;
 	     num_links < card->num_links;
 	     num_links++, dai_link++) {
 		of_node_put(dai_link->cpu_of_node);
-		of_node_put(dai_link->codec_of_node);
+		for (i = 0, component = dai_link->codecs;
+		     i < dai_link->num_codecs;
+		     i++, component++) {
+			if (!component->of_node)
+				break;
+			of_node_put(component->of_node);
+		}
 	}
 	return 0;
 }
-- 
2.1.3

