Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752464AbaAOPxI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 10:53:08 -0500
Received: from smtp4-g21.free.fr ([212.27.42.4]:37874 "EHLO smtp4-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752420AbaAOPxE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 10:53:04 -0500
Date: Wed, 15 Jan 2014 16:51:41 +0100
From: Jean-Francois Moine <moinejf@free.fr>
To: Mark Brown <broonie@kernel.org>, lgirdwood@gmail.com
Cc: alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        kuninori.morimoto.gx@renesas.com, Xiubo Li <Li.Xiubo@freescale.com>
Subject: [PATCH v2 3/8] ASoC: simple-card: simplify code
Message-ID: <20140115165141.3ab93dc1@armhf>
In-Reply-To: <20140115113551.0eb13409@armhf>
References: <20140115113551.0eb13409@armhf>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; arm-unknown-linux-gnueabihf)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The OF pointers are put in the stack and then copied to the card
descriptor.
Put them directly at their right place.

Signed-off-by: Jean-Francois Moine <moinejf@free.fr>
---
 sound/soc/generic/simple-card.c     | 55 ++++++++--------------
 1 file changed, 20 insertions(+), 35 deletions(-)

diff --git a/sound/soc/generic/simple-card.c b/sound/soc/generic/simple-card.c
index 7c5dc73..89f83b3 100644
--- a/sound/soc/generic/simple-card.c
+++ b/sound/soc/generic/simple-card.c
@@ -60,8 +60,9 @@ static int asoc_simple_card_dai_init(struct snd_soc_pcm_runtime *rtd)
 static int
 asoc_simple_card_sub_parse_of(struct device_node *np,
 			      struct asoc_simple_dai *dai,
-			      struct device_node **node)
+			      const struct device_node **p_node)
 {
+	struct device_node *node;
 	struct clk *clk;
 	int ret;
 
@@ -69,9 +70,10 @@ asoc_simple_card_sub_parse_of(struct device_node *np,
 	 * get node via "sound-dai = <&phandle port>"
 	 * it will be used as xxx_of_node on soc_bind_dai_link()
 	 */
-	*node = of_parse_phandle(np, "sound-dai", 0);
-	if (!*node)
+	node = of_parse_phandle(np, "sound-dai", 0);
+	if (!node)
 		return -ENODEV;
+	*p_node = node;
 
 	/* get dai->name */
 	ret = snd_soc_of_get_dai_name(np, &dai->name);
@@ -104,7 +106,7 @@ asoc_simple_card_sub_parse_of(struct device_node *np,
 				     "system-clock-frequency",
 				     &dai->sysclk);
 	} else {
-		clk = of_clk_get(*node, 0);
+		clk = of_clk_get(node, 0);
 		if (!IS_ERR(clk))
 			dai->sysclk = clk_get_rate(clk);
 	}
@@ -112,17 +114,14 @@ asoc_simple_card_sub_parse_of(struct device_node *np,
 	ret = 0;
 
 parse_error:
-	of_node_put(*node);
+	of_node_put(node);
 
 	return ret;
 }
 
 static int asoc_simple_card_parse_of(struct device_node *node,
 				     struct asoc_simple_card_info *info,
-				     struct device *dev,
-				     struct device_node **of_cpu,
-				     struct device_node **of_codec,
-				     struct device_node **of_platform)
+				     struct device *dev)
 {
 	struct device_node *np;
 	char *name;
@@ -146,7 +145,7 @@ static int asoc_simple_card_parse_of(struct device_node *node,
 	if (np)
 		ret = asoc_simple_card_sub_parse_of(np,
 						  &info->cpu_dai,
-						  of_cpu);
+						  &info->snd_link.cpu_of_node);
 	if (ret < 0)
 		return ret;
 
@@ -156,7 +155,7 @@ static int asoc_simple_card_parse_of(struct device_node *node,
 	if (np)
 		ret = asoc_simple_card_sub_parse_of(np,
 						  &info->codec_dai,
-						  of_codec);
+						  &info->snd_link.codec_of_node);
 	if (ret < 0)
 		return ret;
 
@@ -173,7 +172,7 @@ static int asoc_simple_card_parse_of(struct device_node *node,
 	info->snd_link.name = info->snd_link.stream_name = name;
 
 	/* simple-card assumes platform == cpu */
-	*of_platform = *of_cpu;
+	info->snd_link.platform_of_node = info->snd_link.cpu_of_node;
 
 	dev_dbg(dev, "card-name : %s\n", name);
 	dev_dbg(dev, "platform : %04x\n", info->daifmt);
@@ -193,34 +192,29 @@ static int asoc_simple_card_probe(struct platform_device *pdev)
 {
 	struct asoc_simple_card_info *cinfo;
 	struct device_node *np = pdev->dev.of_node;
-	struct device_node *of_cpu, *of_codec, *of_platform;
 	struct device *dev = &pdev->dev;
 	int ret;
 
-	cinfo		= NULL;
-	of_cpu		= NULL;
-	of_codec	= NULL;
-	of_platform	= NULL;
-
 	cinfo = devm_kzalloc(dev, sizeof(*cinfo), GFP_KERNEL);
 	if (!cinfo)
 		return -ENOMEM;
 
+	/*
+	 * init snd_soc_card
+	 */
+	cinfo->snd_card.owner		= THIS_MODULE;
+	cinfo->snd_card.dev = dev;
+	cinfo->snd_card.dai_link	= &cinfo->snd_link;
+	cinfo->snd_card.num_links	= 1;
+
 	if (np && of_device_is_available(np)) {
-		cinfo->snd_card.dev = dev;
 
-		ret = asoc_simple_card_parse_of(np, cinfo, dev,
-						&of_cpu,
-						&of_codec,
-						&of_platform);
+		ret = asoc_simple_card_parse_of(np, cinfo, dev);
 		if (ret < 0) {
 			if (ret != -EPROBE_DEFER)
 				dev_err(dev, "parse error %d\n", ret);
 			return ret;
 		}
-		cinfo->snd_link.cpu_of_node	= of_cpu;
-		cinfo->snd_link.codec_of_node	= of_codec;
-		cinfo->snd_link.platform_of_node = of_platform;
 	} else {
 		if (!dev->platform_data) {
 			dev_err(dev, "no info for asoc-simple-card\n");
@@ -228,8 +222,6 @@ static int asoc_simple_card_probe(struct platform_device *pdev)
 		}
 
 		memcpy(cinfo, dev->platform_data, sizeof(*cinfo));
-		cinfo->snd_card.dev = dev;
-
 		if (!cinfo->name	||
 		    !cinfo->card	||
 		    !cinfo->codec_dai.name	||
@@ -254,13 +246,6 @@ static int asoc_simple_card_probe(struct platform_device *pdev)
 	cinfo->snd_link.codec_dai_name	= cinfo->codec_dai.name;
 	cinfo->snd_link.init		= asoc_simple_card_dai_init;
 
-	/*
-	 * init snd_soc_card
-	 */
-	cinfo->snd_card.owner		= THIS_MODULE;
-	cinfo->snd_card.dai_link	= &cinfo->snd_link;
-	cinfo->snd_card.num_links	= 1;
-
 	snd_soc_card_set_drvdata(&cinfo->snd_card, cinfo);
 
 	return devm_snd_soc_register_card(&pdev->dev, &cinfo->snd_card);
-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
