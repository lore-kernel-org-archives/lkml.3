Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752488AbaAOPxV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 10:53:21 -0500
Received: from smtp4-g21.free.fr ([212.27.42.4]:38758 "EHLO smtp4-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752468AbaAOPxQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 10:53:16 -0500
Date: Wed, 15 Jan 2014 16:51:45 +0100
From: Jean-Francois Moine <moinejf@free.fr>
To: Mark Brown <broonie@kernel.org>, lgirdwood@gmail.com
Cc: alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        kuninori.morimoto.gx@renesas.com, Xiubo Li <Li.Xiubo@freescale.com>
Subject: [PATCH v2 4/8] ASoC: simple-card: simplify code
Message-ID: <20140115165145.2c2da894@armhf>
In-Reply-To: <20140115113551.0eb13409@armhf>
References: <20140115113551.0eb13409@armhf>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; arm-unknown-linux-gnueabihf)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Have a cleaner code using a DAI link pointer.

Signed-off-by: Jean-Francois Moine <moinejf@free.fr>
---
 sound/soc/generic/simple-card.c     | 29 ++++++++++++----------
 1 file changed, 16 insertions(+), 13 deletions(-)

diff --git a/sound/soc/generic/simple-card.c b/sound/soc/generic/simple-card.c
index 89f83b3..797696f 100644
--- a/sound/soc/generic/simple-card.c
+++ b/sound/soc/generic/simple-card.c
@@ -123,6 +123,7 @@ static int asoc_simple_card_parse_of(struct device_node *node,
 				     struct asoc_simple_card_info *info,
 				     struct device *dev)
 {
+	struct snd_soc_dai_link *dai_link = info->snd_card.dai_link;
 	struct device_node *np;
 	char *name;
 	int ret;
@@ -145,7 +146,7 @@ static int asoc_simple_card_parse_of(struct device_node *node,
 	if (np)
 		ret = asoc_simple_card_sub_parse_of(np,
 						  &info->cpu_dai,
-						  &info->snd_link.cpu_of_node);
+						  &dai_link->cpu_of_node);
 	if (ret < 0)
 		return ret;
 
@@ -155,7 +156,7 @@ static int asoc_simple_card_parse_of(struct device_node *node,
 	if (np)
 		ret = asoc_simple_card_sub_parse_of(np,
 						  &info->codec_dai,
-						  &info->snd_link.codec_of_node);
+						  &dai_link->codec_of_node);
 	if (ret < 0)
 		return ret;
 
@@ -169,10 +170,10 @@ static int asoc_simple_card_parse_of(struct device_node *node,
 			    GFP_KERNEL);
 	sprintf(name, "%s-%s", info->cpu_dai.name, info->codec_dai.name);
 	info->snd_card.name = name;
-	info->snd_link.name = info->snd_link.stream_name = name;
+	dai_link->name = dai_link->stream_name = name;
 
 	/* simple-card assumes platform == cpu */
-	info->snd_link.platform_of_node = info->snd_link.cpu_of_node;
+	dai_link->platform_of_node = dai_link->cpu_of_node;
 
 	dev_dbg(dev, "card-name : %s\n", name);
 	dev_dbg(dev, "platform : %04x\n", info->daifmt);
@@ -191,6 +192,7 @@ static int asoc_simple_card_parse_of(struct device_node *node,
 static int asoc_simple_card_probe(struct platform_device *pdev)
 {
 	struct asoc_simple_card_info *cinfo;
+	struct snd_soc_dai_link *dai_link;
 	struct device_node *np = pdev->dev.of_node;
 	struct device *dev = &pdev->dev;
 	int ret;
@@ -204,8 +206,9 @@ static int asoc_simple_card_probe(struct platform_device *pdev)
 	 */
 	cinfo->snd_card.owner		= THIS_MODULE;
 	cinfo->snd_card.dev = dev;
-	cinfo->snd_card.dai_link	= &cinfo->snd_link;
-	cinfo->snd_card.num_links	= 1;
+	dai_link = &cinfo->snd_link;
+	cinfo->snd_card.dai_link = dai_link;
+	cinfo->snd_card.num_links = 1;
 
 	if (np && of_device_is_available(np)) {
 
@@ -233,18 +236,18 @@ static int asoc_simple_card_probe(struct platform_device *pdev)
 		}
 
 		cinfo->snd_card.name		= cinfo->card;
-		cinfo->snd_link.name		= cinfo->name;
-		cinfo->snd_link.stream_name	= cinfo->name;
-		cinfo->snd_link.platform_name	= cinfo->platform;
-		cinfo->snd_link.codec_name	= cinfo->codec;
+		dai_link->name		= cinfo->name;
+		dai_link->stream_name	= cinfo->name;
+		dai_link->platform_name	= cinfo->platform;
+		dai_link->codec_name	= cinfo->codec;
 	}
 
 	/*
 	 * init snd_soc_dai_link
 	 */
-	cinfo->snd_link.cpu_dai_name	= cinfo->cpu_dai.name;
-	cinfo->snd_link.codec_dai_name	= cinfo->codec_dai.name;
-	cinfo->snd_link.init		= asoc_simple_card_dai_init;
+	dai_link->cpu_dai_name	= cinfo->cpu_dai.name;
+	dai_link->codec_dai_name = cinfo->codec_dai.name;
+	dai_link->init = asoc_simple_card_dai_init;
 
 	snd_soc_card_set_drvdata(&cinfo->snd_card, cinfo);
 
-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
