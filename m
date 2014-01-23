Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756090AbaAWGCA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 01:02:00 -0500
Received: from ch1ehsobe001.messaging.microsoft.com ([216.32.181.181]:4764
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755954AbaAWGB4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 01:01:56 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VS0(zzzz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah21bch1fc6hzdchz1de098h8275bh1de097hz2dh2a8h839he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1e23h1fe8h1ff5h2218h2216h226dh22d0h24afh2327h2336h2438h2461h2487h24d7h1155h)
From: Xiubo Li <Li.Xiubo@freescale.com>
To: <lgirdwood@gmail.com>, <broonie@kernel.org>, <shawn.guo@linaro.org>,
        <kuninori.morimoto.gx@renesas.com>
CC: <moinejf@free.fr>, <alsa-devel@alsa-project.org>,
        <linux-kernel@vger.kernel.org>, Xiubo Li <Li.Xiubo@freescale.com>
Subject: [PATCH Resend 3/8] ASoC: simple-card: simplify the daifmt code
Date: Thu, 23 Jan 2014 13:02:45 +0800
Message-ID: <1390453370-29194-4-git-send-email-Li.Xiubo@freescale.com>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1390453370-29194-1-git-send-email-Li.Xiubo@freescale.com>
References: <1390453370-29194-1-git-send-email-Li.Xiubo@freescale.com>
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
_set_fmt().

And this will be more easy to add new functions, such as supporting
_set_tdm_slot(), etc.

Signed-off-by: Xiubo Li <Li.Xiubo@freescale.com>
---
 sound/soc/generic/simple-card.c | 20 +++++++++-----------
 1 file changed, 9 insertions(+), 11 deletions(-)

diff --git a/sound/soc/generic/simple-card.c b/sound/soc/generic/simple-card.c
index 3b8c9a2..f38e56e 100644
--- a/sound/soc/generic/simple-card.c
+++ b/sound/soc/generic/simple-card.c
@@ -24,15 +24,12 @@ struct simple_card_data {
 };
 
 static int __asoc_simple_card_dai_init(struct snd_soc_dai *dai,
-				       struct asoc_simple_dai *set,
-				       unsigned int daifmt)
+				       struct asoc_simple_dai *set)
 {
 	int ret = 0;
 
-	daifmt |= set->fmt;
-
-	if (daifmt) {
-		ret = snd_soc_dai_set_fmt(dai, daifmt);
+	if (set->fmt) {
+		ret = snd_soc_dai_set_fmt(dai, set->fmt);
 		if (ret && ret != -ENOTSUPP) {
 			dev_err(dai->dev, "simple-card: set_fmt error\n");
 			return ret;
@@ -56,14 +53,13 @@ static int asoc_simple_card_dai_init(struct snd_soc_pcm_runtime *rtd)
 				snd_soc_card_get_drvdata(rtd->card);
 	struct snd_soc_dai *codec = rtd->codec_dai;
 	struct snd_soc_dai *cpu = rtd->cpu_dai;
-	unsigned int daifmt = priv->daifmt;
 	int ret;
 
-	ret = __asoc_simple_card_dai_init(codec, &priv->codec_dai, daifmt);
+	ret = __asoc_simple_card_dai_init(codec, &priv->codec_dai);
 	if (ret < 0)
 		return ret;
 
-	ret = __asoc_simple_card_dai_init(cpu, &priv->cpu_dai, daifmt);
+	ret = __asoc_simple_card_dai_init(cpu, &priv->cpu_dai);
 	if (ret < 0)
 		return ret;
 
@@ -72,6 +68,7 @@ static int asoc_simple_card_dai_init(struct snd_soc_pcm_runtime *rtd)
 
 static int
 asoc_simple_card_sub_parse_of(struct device_node *np,
+			      unsigned int daifmt,
 			      struct asoc_simple_dai *dai,
 			      const struct device_node **p_node,
 			      const char **name)
@@ -100,6 +97,7 @@ asoc_simple_card_sub_parse_of(struct device_node *np,
 	 * and specific "format" if it has
 	 */
 	dai->fmt = snd_soc_of_parse_daifmt(np, NULL);
+	dai->fmt |= daifmt;
 
 	/*
 	 * dai->sysclk come from
@@ -158,7 +156,7 @@ static int asoc_simple_card_parse_of(struct device_node *node,
 	ret = -EINVAL;
 	np = of_get_child_by_name(node, "simple-audio-card,cpu");
 	if (np)
-		ret = asoc_simple_card_sub_parse_of(np,
+		ret = asoc_simple_card_sub_parse_of(np, priv->daifmt,
 						  &priv->cpu_dai,
 						  &dai_link->cpu_of_node,
 						  &dai_link->cpu_dai_name);
@@ -169,7 +167,7 @@ static int asoc_simple_card_parse_of(struct device_node *node,
 	ret = -EINVAL;
 	np = of_get_child_by_name(node, "simple-audio-card,codec");
 	if (np)
-		ret = asoc_simple_card_sub_parse_of(np,
+		ret = asoc_simple_card_sub_parse_of(np, priv->daifmt,
 						  &priv->codec_dai,
 						  &dai_link->codec_of_node,
 						  &dai_link->codec_dai_name);
-- 
1.8.4


