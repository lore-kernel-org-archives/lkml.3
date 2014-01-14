Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752161AbaANGn2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 01:43:28 -0500
Received: from ch1ehsobe003.messaging.microsoft.com ([216.32.181.183]:39162
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751904AbaANGn0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 01:43:26 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VS0(zzzz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah1fc6hzdchz1de098h8275bh1de097h84d07hz2dh2a8h839he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dc1h1dfeh1dffh1e23h1fe8h1ff5h2218h2216h226dh22d0h2327h2336h2438h2461h1155h)
From: Xiubo Li <Li.Xiubo@freescale.com>
To: <broonie@kernel.org>, <lgirdwood@gmail.com>, <moinejf@free.fr>,
        <kuninori.morimoto.gx@renesas.com>
CC: <alsa-devel@alsa-project.org>, <linux-kernel@vger.kernel.org>,
        Xiubo Li <Li.Xiubo@freescale.com>
Subject: [RFC][PATCH] ASoC: simple-card: Add asoc_simple_card_data for the simple card driver data
Date: Tue, 14 Jan 2014 13:44:42 +0800
Message-ID: <1389678282-1097-1-git-send-email-Li.Xiubo@freescale.com>
X-Mailer: git-send-email 1.8.0
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%0$Dn%FREESCALE.MAIL.ONMICROSOFT.COM$RO%1$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Whether the dt is used or not, almost all the simple card information
for the DAI link and sound card are initialized in the simple card driver.

And for the platform caller, the snd_link and snd_card are of no use, so
move them from struct asoc_simple_card_info to struct asoc_simple_card_data.

And now only one DAI link is supported for simple card.

Suggested-by: Jean-Francois Moine <moinejf@free.fr>
Signed-off-by: Xiubo Li <Li.Xiubo@freescale.com>
---
 include/sound/simple_card.h     |   4 --
 sound/soc/generic/simple-card.c | 115 +++++++++++++++++++++-------------------
 2 files changed, 60 insertions(+), 59 deletions(-)

diff --git a/include/sound/simple_card.h b/include/sound/simple_card.h
index 6c74527..e1ac996 100644
--- a/include/sound/simple_card.h
+++ b/include/sound/simple_card.h
@@ -29,10 +29,6 @@ struct asoc_simple_card_info {
 	unsigned int daifmt;
 	struct asoc_simple_dai cpu_dai;
 	struct asoc_simple_dai codec_dai;
-
-	/* used in simple-card.c */
-	struct snd_soc_dai_link snd_link;
-	struct snd_soc_card snd_card;
 };
 
 #endif /* __SIMPLE_CARD_H */
diff --git a/sound/soc/generic/simple-card.c b/sound/soc/generic/simple-card.c
index 2a1b1b5..eab8f92 100644
--- a/sound/soc/generic/simple-card.c
+++ b/sound/soc/generic/simple-card.c
@@ -15,6 +15,12 @@
 #include <linux/string.h>
 #include <sound/simple_card.h>
 
+struct asoc_simple_card_data {
+	struct asoc_simple_card_info info;
+	struct snd_soc_dai_link snd_link;
+	struct snd_soc_card snd_card;
+};
+
 static int __asoc_simple_card_dai_init(struct snd_soc_dai *dai,
 				       struct asoc_simple_dai *set,
 				       unsigned int daifmt)
@@ -39,18 +45,18 @@ static int __asoc_simple_card_dai_init(struct snd_soc_dai *dai,
 
 static int asoc_simple_card_dai_init(struct snd_soc_pcm_runtime *rtd)
 {
-	struct asoc_simple_card_info *info =
+	struct asoc_simple_card_data *sdata =
 				snd_soc_card_get_drvdata(rtd->card);
 	struct snd_soc_dai *codec = rtd->codec_dai;
 	struct snd_soc_dai *cpu = rtd->cpu_dai;
-	unsigned int daifmt = info->daifmt;
+	unsigned int daifmt = sdata->info.daifmt;
 	int ret;
 
-	ret = __asoc_simple_card_dai_init(codec, &info->codec_dai, daifmt);
+	ret = __asoc_simple_card_dai_init(codec, &sdata->info.codec_dai, daifmt);
 	if (ret < 0)
 		return ret;
 
-	ret = __asoc_simple_card_dai_init(cpu, &info->cpu_dai, daifmt);
+	ret = __asoc_simple_card_dai_init(cpu, &sdata->info.cpu_dai, daifmt);
 	if (ret < 0)
 		return ret;
 
@@ -118,23 +124,23 @@ parse_error:
 }
 
 static int asoc_simple_card_parse_of(struct device_node *node,
-				     struct asoc_simple_card_info *info,
-				     struct device *dev,
+				     struct asoc_simple_card_data *sdata,
 				     struct device_node **of_cpu,
 				     struct device_node **of_codec,
 				     struct device_node **of_platform)
 {
+	struct device *dev = sdata->snd_card.dev;
 	struct device_node *np;
 	char *name;
 	int ret;
 
 	/* get CPU/CODEC common format via simple-audio-card,format */
-	info->daifmt = snd_soc_of_parse_daifmt(node, "simple-audio-card,") &
-		(SND_SOC_DAIFMT_FORMAT_MASK | SND_SOC_DAIFMT_INV_MASK);
+	sdata->info.daifmt = snd_soc_of_parse_daifmt(node,
+			"simple-audio-card,") & SND_SOC_DAIFMT_FORMAT_MASK;
 
 	/* DAPM routes */
 	if (of_property_read_bool(node, "simple-audio-card,routing")) {
-		ret = snd_soc_of_parse_audio_routing(&info->snd_card,
+		ret = snd_soc_of_parse_audio_routing(&sdata->snd_card,
 					"simple-audio-card,routing");
 		if (ret)
 			return ret;
@@ -145,7 +151,7 @@ static int asoc_simple_card_parse_of(struct device_node *node,
 	np = of_get_child_by_name(node, "simple-audio-card,cpu");
 	if (np)
 		ret = asoc_simple_card_sub_parse_of(np,
-						  &info->cpu_dai,
+						  &sdata->info.cpu_dai,
 						  of_cpu);
 	if (ret < 0)
 		return ret;
@@ -155,60 +161,60 @@ static int asoc_simple_card_parse_of(struct device_node *node,
 	np = of_get_child_by_name(node, "simple-audio-card,codec");
 	if (np)
 		ret = asoc_simple_card_sub_parse_of(np,
-						  &info->codec_dai,
+						  &sdata->info.codec_dai,
 						  of_codec);
 	if (ret < 0)
 		return ret;
 
-	if (!info->cpu_dai.name || !info->codec_dai.name)
+	if (!sdata->info.cpu_dai.name || !sdata->info.codec_dai.name)
 		return -EINVAL;
 
 	/* card name is created from CPU/CODEC dai name */
 	name = devm_kzalloc(dev,
-			    strlen(info->cpu_dai.name)   +
-			    strlen(info->codec_dai.name) + 2,
+			    strlen(sdata->info.cpu_dai.name)   +
+			    strlen(sdata->info.codec_dai.name) + 2,
 			    GFP_KERNEL);
-	sprintf(name, "%s-%s", info->cpu_dai.name, info->codec_dai.name);
-	info->name = info->card = name;
+	sprintf(name, "%s-%s", sdata->info.cpu_dai.name,
+			sdata->info.codec_dai.name);
+	sdata->info.name = sdata->info.card = name;
 
 	/* simple-card assumes platform == cpu */
 	*of_platform = *of_cpu;
 
-	dev_dbg(dev, "card-name : %s\n", info->card);
-	dev_dbg(dev, "platform : %04x\n", info->daifmt);
+	dev_dbg(dev, "card-name : %s\n", sdata->info.card);
+	dev_dbg(dev, "platform : %04x\n", sdata->info.daifmt);
 	dev_dbg(dev, "cpu : %s / %04x / %d\n",
-		info->cpu_dai.name,
-		info->cpu_dai.fmt,
-		info->cpu_dai.sysclk);
+		sdata->info.cpu_dai.name,
+		sdata->info.cpu_dai.fmt,
+		sdata->info.cpu_dai.sysclk);
 	dev_dbg(dev, "codec : %s / %04x / %d\n",
-		info->codec_dai.name,
-		info->codec_dai.fmt,
-		info->codec_dai.sysclk);
+		sdata->info.codec_dai.name,
+		sdata->info.codec_dai.fmt,
+		sdata->info.codec_dai.sysclk);
 
 	return 0;
 }
 
 static int asoc_simple_card_probe(struct platform_device *pdev)
 {
-	struct asoc_simple_card_info *cinfo;
+	struct asoc_simple_card_data *sdata;
 	struct device_node *np = pdev->dev.of_node;
 	struct device_node *of_cpu, *of_codec, *of_platform;
 	struct device *dev = &pdev->dev;
 	int ret;
 
-	cinfo		= NULL;
 	of_cpu		= NULL;
 	of_codec	= NULL;
 	of_platform	= NULL;
 
-	cinfo = devm_kzalloc(dev, sizeof(*cinfo), GFP_KERNEL);
-	if (!cinfo)
+	sdata = devm_kzalloc(dev, sizeof(*sdata), GFP_KERNEL);
+	if (!sdata)
 		return -ENOMEM;
 
-	if (np && of_device_is_available(np)) {
-		cinfo->snd_card.dev = dev;
+	sdata->snd_card.dev = dev;
 
-		ret = asoc_simple_card_parse_of(np, cinfo, dev,
+	if (np && of_device_is_available(np)) {
+		ret = asoc_simple_card_parse_of(np, sdata,
 						&of_cpu,
 						&of_codec,
 						&of_platform);
@@ -223,16 +229,15 @@ static int asoc_simple_card_probe(struct platform_device *pdev)
 			return -EINVAL;
 		}
 
-		memcpy(cinfo, dev->platform_data, sizeof(*cinfo));
-		cinfo->snd_card.dev = dev;
+		memcpy(&sdata->info, dev->platform_data, sizeof(sdata->info));
 	}
 
-	if (!cinfo->name	||
-	    !cinfo->card	||
-	    !cinfo->codec_dai.name	||
-	    !(cinfo->codec		|| of_codec)	||
-	    !(cinfo->platform		|| of_platform)	||
-	    !(cinfo->cpu_dai.name	|| of_cpu)) {
+	if (!sdata->info.name	||
+	    !sdata->info.card	||
+	    !sdata->info.codec_dai.name	||
+	    !(sdata->info.codec		|| of_codec)	||
+	    !(sdata->info.platform		|| of_platform)	||
+	    !(sdata->info.cpu_dai.name		|| of_cpu)) {
 		dev_err(dev, "insufficient asoc_simple_card_info settings\n");
 		return -EINVAL;
 	}
@@ -240,28 +245,28 @@ static int asoc_simple_card_probe(struct platform_device *pdev)
 	/*
 	 * init snd_soc_dai_link
 	 */
-	cinfo->snd_link.name		= cinfo->name;
-	cinfo->snd_link.stream_name	= cinfo->name;
-	cinfo->snd_link.cpu_dai_name	= cinfo->cpu_dai.name;
-	cinfo->snd_link.platform_name	= cinfo->platform;
-	cinfo->snd_link.codec_name	= cinfo->codec;
-	cinfo->snd_link.codec_dai_name	= cinfo->codec_dai.name;
-	cinfo->snd_link.cpu_of_node	= of_cpu;
-	cinfo->snd_link.codec_of_node	= of_codec;
-	cinfo->snd_link.platform_of_node = of_platform;
-	cinfo->snd_link.init		= asoc_simple_card_dai_init;
+	sdata->snd_link.name		= sdata->info.name;
+	sdata->snd_link.stream_name	= sdata->info.name;
+	sdata->snd_link.cpu_dai_name	= sdata->info.cpu_dai.name;
+	sdata->snd_link.platform_name	= sdata->info.platform;
+	sdata->snd_link.codec_name	= sdata->info.codec;
+	sdata->snd_link.codec_dai_name	= sdata->info.codec_dai.name;
+	sdata->snd_link.cpu_of_node	= of_cpu;
+	sdata->snd_link.codec_of_node	= of_codec;
+	sdata->snd_link.platform_of_node = of_platform;
+	sdata->snd_link.init 		= asoc_simple_card_dai_init;
 
 	/*
 	 * init snd_soc_card
 	 */
-	cinfo->snd_card.name		= cinfo->card;
-	cinfo->snd_card.owner		= THIS_MODULE;
-	cinfo->snd_card.dai_link	= &cinfo->snd_link;
-	cinfo->snd_card.num_links	= 1;
+	sdata->snd_card.name 		= sdata->info.card;
+	sdata->snd_card.owner 		= THIS_MODULE;
+	sdata->snd_card.dai_link 	= &sdata->snd_link;
+	sdata->snd_card.num_links 	= 1;
 
-	snd_soc_card_set_drvdata(&cinfo->snd_card, cinfo);
+	snd_soc_card_set_drvdata(&sdata->snd_card, sdata);
 
-	return devm_snd_soc_register_card(&pdev->dev, &cinfo->snd_card);
+	return devm_snd_soc_register_card(dev, &sdata->snd_card);
 }
 
 static const struct of_device_id asoc_simple_of_match[] = {
-- 
1.8.4


