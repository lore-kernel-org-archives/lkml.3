Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752406AbaAOPwy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 10:52:54 -0500
Received: from smtp4-g21.free.fr ([212.27.42.4]:37138 "EHLO smtp4-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751895AbaAOPww convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 10:52:52 -0500
Date: Wed, 15 Jan 2014 16:51:37 +0100
From: Jean-Francois Moine <moinejf@free.fr>
To: Mark Brown <broonie@kernel.org>, lgirdwood@gmail.com
Cc: alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        kuninori.morimoto.gx@renesas.com, Xiubo Li <Li.Xiubo@freescale.com>
Subject: [PATCH v2 2/8] ASoC: simple-card: simplify code
Message-ID: <20140115165137.5fec601b@armhf>
In-Reply-To: <20140115113551.0eb13409@armhf>
References: <20140115113551.0eb13409@armhf>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; arm-unknown-linux-gnueabihf)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The DT values are copied to the non-DT structure before being moved to
the card structure.
Set directly the DT values in the card and move the non-DT copy to the
non-DT sequence.

Signed-off-by: Jean-Francois Moine <moinejf@free.fr>
---
 sound/soc/generic/simple-card.c     | 22 ++++++++++++----------
 1 file changed, 12 insertions(+), 10 deletions(-)

diff --git a/sound/soc/generic/simple-card.c b/sound/soc/generic/simple-card.c
index f0784ca..7c5dc73 100644
--- a/sound/soc/generic/simple-card.c
+++ b/sound/soc/generic/simple-card.c
@@ -169,12 +169,13 @@ static int asoc_simple_card_parse_of(struct device_node *node,
 			    strlen(info->codec_dai.name) + 2,
 			    GFP_KERNEL);
 	sprintf(name, "%s-%s", info->cpu_dai.name, info->codec_dai.name);
-	info->name = info->card = name;
+	info->snd_card.name = name;
+	info->snd_link.name = info->snd_link.stream_name = name;
 
 	/* simple-card assumes platform == cpu */
 	*of_platform = *of_cpu;
 
-	dev_dbg(dev, "card-name : %s\n", info->card);
+	dev_dbg(dev, "card-name : %s\n", name);
 	dev_dbg(dev, "platform : %04x\n", info->daifmt);
 	dev_dbg(dev, "cpu : %s / %04x / %d\n",
 		info->cpu_dai.name,
@@ -217,6 +218,9 @@ static int asoc_simple_card_probe(struct platform_device *pdev)
 				dev_err(dev, "parse error %d\n", ret);
 			return ret;
 		}
+		cinfo->snd_link.cpu_of_node	= of_cpu;
+		cinfo->snd_link.codec_of_node	= of_codec;
+		cinfo->snd_link.platform_of_node = of_platform;
 	} else {
 		if (!dev->platform_data) {
 			dev_err(dev, "no info for asoc-simple-card\n");
@@ -235,26 +239,24 @@ static int asoc_simple_card_probe(struct platform_device *pdev)
 			dev_err(dev, "insufficient asoc_simple_card_info settings\n");
 			return -EINVAL;
 		}
+
+		cinfo->snd_card.name		= cinfo->card;
+		cinfo->snd_link.name		= cinfo->name;
+		cinfo->snd_link.stream_name	= cinfo->name;
+		cinfo->snd_link.platform_name	= cinfo->platform;
+		cinfo->snd_link.codec_name	= cinfo->codec;
 	}
 
 	/*
 	 * init snd_soc_dai_link
 	 */
-	cinfo->snd_link.name		= cinfo->name;
-	cinfo->snd_link.stream_name	= cinfo->name;
 	cinfo->snd_link.cpu_dai_name	= cinfo->cpu_dai.name;
-	cinfo->snd_link.platform_name	= cinfo->platform;
-	cinfo->snd_link.codec_name	= cinfo->codec;
 	cinfo->snd_link.codec_dai_name	= cinfo->codec_dai.name;
-	cinfo->snd_link.cpu_of_node	= of_cpu;
-	cinfo->snd_link.codec_of_node	= of_codec;
-	cinfo->snd_link.platform_of_node = of_platform;
 	cinfo->snd_link.init		= asoc_simple_card_dai_init;
 
 	/*
 	 * init snd_soc_card
 	 */
-	cinfo->snd_card.name		= cinfo->card;
 	cinfo->snd_card.owner		= THIS_MODULE;
 	cinfo->snd_card.dai_link	= &cinfo->snd_link;
 	cinfo->snd_card.num_links	= 1;
-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
