Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751683AbbAAJQx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jan 2015 04:16:53 -0500
Received: from smtpfb1-g21.free.fr ([212.27.42.9]:38578 "EHLO
	smtpfb1-g21.free.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750701AbbAAJQr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jan 2015 04:16:47 -0500
X-Mailbox-Line: From 0f9aa2b093f298e09bb50dd7474f45ea95a15da1 Mon Sep 17 00:00:00 2001
Message-Id: <0f9aa2b093f298e09bb50dd7474f45ea95a15da1.1420102454.git.moinejf@free.fr>
In-Reply-To: <cover.1420102454.git.moinejf@free.fr>
References: <cover.1420102454.git.moinejf@free.fr>
From: Jean-Francois Moine <moinejf@free.fr>
Date: Thu, 1 Jan 2015 09:15:01 +0100
Subject: [PATCH v6 1/3] ASoC: simple-card: prepare multi-CODECs
To: Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>
Cc: alsa-devel@alsa-project.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The function asoc_simple_card_sub_parse_of() is used to parse either
the CPU or CODEC DAI.
To prepare support of many CODECs in a DAI link, the parsing of the
phandle and DAI name must be moved to the upper function
asoc_simple_card_dai_link_of().

Signed-off-by: Jean-Francois Moine <moinejf@free.fr>
---
 sound/soc/generic/simple-card.c | 57 ++++++++++++++++++++---------------------
 1 file changed, 28 insertions(+), 29 deletions(-)

diff --git a/sound/soc/generic/simple-card.c b/sound/soc/generic/simple-card.c
index fb9240f..170de17 100644
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
@@ -286,6 +264,7 @@ static int asoc_simple_card_dai_link_of(struct device_node *node,
 	struct simple_dai_props *dai_props = simple_priv_to_props(priv, idx);
 	struct device_node *cpu = NULL;
 	struct device_node *codec = NULL;
+	struct of_phandle_args args;
 	char *name;
 	char prop[128];
 	char *prefix = "";
@@ -312,16 +291,36 @@ static int asoc_simple_card_dai_link_of(struct device_node *node,
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
 	if (ret < 0)
 		goto dai_link_of_err;
 
+	/* Get the node and name of the CODEC */
+	ret = of_parse_phandle_with_args(codec, "sound-dai",
+					 "#sound-dai-cells", 0, &args);
+	if (ret < 0)
+		goto dai_link_of_err;
+	dai_link->codec_of_node = args.np;
+
+	ret = snd_soc_of_get_dai_name(codec, &dai_link->codec_dai_name);
+	if (ret < 0)
+		goto dai_link_of_err;
+
 	ret = asoc_simple_card_sub_parse_of(codec, &dai_props->codec_dai,
-					    &dai_link->codec_of_node,
-					    &dai_link->codec_dai_name, NULL);
+					    dai_link->codec_of_node);
 	if (ret < 0)
 		goto dai_link_of_err;
 
-- 
2.1.4

