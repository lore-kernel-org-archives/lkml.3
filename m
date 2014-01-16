Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752127AbaAPELy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 23:11:54 -0500
Received: from [65.55.88.11] ([65.55.88.11]:58648 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751632AbaAPELs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 23:11:48 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VS0(zzzz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah1fc6hzz1de098h8275bh1de097hz2dh2a8h839he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dc1h1dfeh1dffh1e23h1fe8h1ff5h2218h2216h226dh22d0h2327h2336h2438h2461h2487h1155h)
From: Xiubo Li <Li.Xiubo@freescale.com>
To: <broonie@kernel.org>, <lgirdwood@gmail.com>
CC: <kuninori.morimoto.gx@renesas.com>, <moinejf@free.fr>,
        <alsa-devel@alsa-project.org>, <linux-kernel@vger.kernel.org>,
        Xiubo Li <Li.Xiubo@freescale.com>
Subject: [PATCH] ASoC: simple-card: simplify the daifmt code
Date: Thu, 16 Jan 2014 11:12:18 +0800
Message-ID: <1389841938-17177-1-git-send-email-Li.Xiubo@freescale.com>
X-Mailer: git-send-email 1.8.0
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%0$Dn%FREESCALE.MAIL.ONMICROSOFT.COM$RO%1$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the asoc_simple_card_parse_of() will parse the device node's CPU/CODEC
DAI commone fmts, and then in asoc_simple_card_sub_parse_of() will parse
the CPU/CODEC DAI's sub-node fmts, so we can combine the info->daifmt and
info->set.fmt in asoc_simple_card_sub_parse_of() not while just before
set_fmt().

Signed-off-by: Xiubo Li <Li.Xiubo@freescale.com>
---
 sound/soc/generic/simple-card.c | 20 +++++++++-----------
 1 file changed, 9 insertions(+), 11 deletions(-)

diff --git a/sound/soc/generic/simple-card.c b/sound/soc/generic/simple-card.c
index b6014fe..0e2fbdd 100644
--- a/sound/soc/generic/simple-card.c
+++ b/sound/soc/generic/simple-card.c
@@ -16,15 +16,12 @@
 #include <sound/simple_card.h>
 
 static int __asoc_simple_card_dai_init(struct snd_soc_dai *dai,
-				       struct asoc_simple_dai *set,
-				       unsigned int daifmt)
+				       struct asoc_simple_dai *set)
 {
 	int ret;
 
-	daifmt |= set->fmt;
-
-	if (daifmt) {
-		ret = snd_soc_dai_set_fmt(dai, daifmt);
+	if (set->fmt) {
+		ret = snd_soc_dai_set_fmt(dai, set->fmt);
 		if (ret && ret != -ENOTSUPP) {
 			dev_err(dai->dev, "simple-card: set_fmt error\n");
 			return ret;
@@ -48,14 +45,13 @@ static int asoc_simple_card_dai_init(struct snd_soc_pcm_runtime *rtd)
 				snd_soc_card_get_drvdata(rtd->card);
 	struct snd_soc_dai *codec = rtd->codec_dai;
 	struct snd_soc_dai *cpu = rtd->cpu_dai;
-	unsigned int daifmt = info->daifmt;
 	int ret;
 
-	ret = __asoc_simple_card_dai_init(codec, &info->codec_dai, daifmt);
+	ret = __asoc_simple_card_dai_init(codec, &info->codec_dai);
 	if (ret < 0)
 		return ret;
 
-	ret = __asoc_simple_card_dai_init(cpu, &info->cpu_dai, daifmt);
+	ret = __asoc_simple_card_dai_init(cpu, &info->cpu_dai);
 	if (ret < 0)
 		return ret;
 
@@ -64,6 +60,7 @@ static int asoc_simple_card_dai_init(struct snd_soc_pcm_runtime *rtd)
 
 static int
 asoc_simple_card_sub_parse_of(struct device_node *np,
+			      unsigned int daifmt,
 			      struct asoc_simple_dai *dai,
 			      struct device_node **node)
 {
@@ -89,6 +86,7 @@ asoc_simple_card_sub_parse_of(struct device_node *np,
 	 * and specific "format" if it has
 	 */
 	dai->fmt = snd_soc_of_parse_daifmt(np, NULL);
+	dai->fmt |= daifmt;
 
 	/*
 	 * dai->sysclk come from
@@ -149,7 +147,7 @@ static int asoc_simple_card_parse_of(struct device_node *node,
 	ret = -EINVAL;
 	np = of_get_child_by_name(node, "simple-audio-card,cpu");
 	if (np)
-		ret = asoc_simple_card_sub_parse_of(np,
+		ret = asoc_simple_card_sub_parse_of(np, info->daifmt,
 						  &info->cpu_dai,
 						  of_cpu);
 	if (ret < 0)
@@ -159,7 +157,7 @@ static int asoc_simple_card_parse_of(struct device_node *node,
 	ret = -EINVAL;
 	np = of_get_child_by_name(node, "simple-audio-card,codec");
 	if (np)
-		ret = asoc_simple_card_sub_parse_of(np,
+		ret = asoc_simple_card_sub_parse_of(np, info->daifmt,
 						  &info->codec_dai,
 						  of_codec);
 	if (ret < 0)
-- 
1.8.4


