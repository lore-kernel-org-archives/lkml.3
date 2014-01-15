Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752532AbaAOPxq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 10:53:46 -0500
Received: from smtp4-g21.free.fr ([212.27.42.4]:40366 "EHLO smtp4-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751754AbaAOPxl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 10:53:41 -0500
Date: Wed, 15 Jan 2014 16:51:52 +0100
From: Jean-Francois Moine <moinejf@free.fr>
To: Mark Brown <broonie@kernel.org>, lgirdwood@gmail.com
Cc: alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        kuninori.morimoto.gx@renesas.com, Xiubo Li <Li.Xiubo@freescale.com>
Subject: [PATCH v2 6/8] ASoC: simple-card: simplify code
Message-ID: <20140115165152.0ad6e344@armhf>
In-Reply-To: <20140115113551.0eb13409@armhf>
References: <20140115113551.0eb13409@armhf>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; arm-unknown-linux-gnueabihf)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the non-DT sequence, the platform data is copied as a whole to the
dynamic card info and the same pointer 'cinfo' is used to copy the
platform information to the card.

Use 'priv' as the pointer to the dynamic card info and copy only the
useful information from the platform data.

Signed-off-by: Jean-Francois Moine <moinejf@free.fr>
---
 sound/soc/generic/simple-card.c     | 34 +++++++++++++---------
 1 file changed, 20 insertions(+), 14 deletions(-)

diff --git a/sound/soc/generic/simple-card.c b/sound/soc/generic/simple-card.c
index 9068ab4..90c6fd5 100644
--- a/sound/soc/generic/simple-card.c
+++ b/sound/soc/generic/simple-card.c
@@ -195,40 +195,42 @@ static int asoc_simple_card_parse_of(struct device_node *node,
 
 static int asoc_simple_card_probe(struct platform_device *pdev)
 {
-	struct asoc_simple_card_info *cinfo;
+	struct asoc_simple_card_info *priv;
 	struct snd_soc_dai_link *dai_link;
 	struct device_node *np = pdev->dev.of_node;
 	struct device *dev = &pdev->dev;
 	int ret;
 
-	cinfo = devm_kzalloc(dev, sizeof(*cinfo), GFP_KERNEL);
-	if (!cinfo)
+	priv = devm_kzalloc(dev, sizeof(*priv), GFP_KERNEL);
+	if (!priv)
 		return -ENOMEM;
 
 	/*
 	 * init snd_soc_card
 	 */
-	cinfo->snd_card.owner		= THIS_MODULE;
-	cinfo->snd_card.dev = dev;
-	dai_link = &cinfo->snd_link;
-	cinfo->snd_card.dai_link = dai_link;
-	cinfo->snd_card.num_links = 1;
+	priv->snd_card.owner = THIS_MODULE;
+	priv->snd_card.dev = dev;
+	dai_link = &priv->snd_link;
+	priv->snd_card.dai_link = dai_link;
+	priv->snd_card.num_links = 1;
 
 	if (np && of_device_is_available(np)) {
 
-		ret = asoc_simple_card_parse_of(np, cinfo, dev);
+		ret = asoc_simple_card_parse_of(np, priv, dev);
 		if (ret < 0) {
 			if (ret != -EPROBE_DEFER)
 				dev_err(dev, "parse error %d\n", ret);
 			return ret;
 		}
 	} else {
-		if (!dev->platform_data) {
+		struct asoc_simple_card_info *cinfo;
+
+		cinfo = dev->platform_data;
+		if (!cinfo) {
 			dev_err(dev, "no info for asoc-simple-card\n");
 			return -EINVAL;
 		}
 
-		memcpy(cinfo, dev->platform_data, sizeof(*cinfo));
 		if (!cinfo->name	||
 		    !cinfo->card	||
 		    !cinfo->codec_dai.name	||
@@ -239,13 +241,17 @@ static int asoc_simple_card_probe(struct platform_device *pdev)
 			return -EINVAL;
 		}
 
-		cinfo->snd_card.name		= cinfo->card;
+		priv->snd_card.name	= cinfo->card;
 		dai_link->name		= cinfo->name;
 		dai_link->stream_name	= cinfo->name;
 		dai_link->platform_name	= cinfo->platform;
 		dai_link->codec_name	= cinfo->codec;
 		dai_link->cpu_dai_name	= cinfo->cpu_dai.name;
 		dai_link->codec_dai_name = cinfo->codec_dai.name;
+		memcpy(&priv->cpu_dai, &cinfo->cpu_dai,
+						sizeof(priv->cpu_dai));
+		memcpy(&priv->codec_dai, &cinfo->codec_dai,
+						sizeof(priv->codec_dai));
 	}
 
 	/*
@@ -253,9 +259,9 @@ static int asoc_simple_card_probe(struct platform_device *pdev)
 	 */
 	dai_link->init = asoc_simple_card_dai_init;
 
-	snd_soc_card_set_drvdata(&cinfo->snd_card, cinfo);
+	snd_soc_card_set_drvdata(&priv->snd_card, priv);
 
-	return devm_snd_soc_register_card(&pdev->dev, &cinfo->snd_card);
+	return devm_snd_soc_register_card(&pdev->dev, &priv->snd_card);
 }
 
 static const struct of_device_id asoc_simple_of_match[] = {
-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
