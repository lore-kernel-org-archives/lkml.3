Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752017Ab3LLSA2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 13:00:28 -0500
Received: from smtpfb2-g21.free.fr ([212.27.42.10]:54514 "EHLO
	smtpfb2-g21.free.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751781Ab3LLSAV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 13:00:21 -0500
Date: Thu, 12 Dec 2013 18:59:17 +0100
From: Jean-Francois Moine <moinejf@free.fr>
To: Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>
Cc: Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Subject: [PATCH] ASoC: make snd_soc_dai_link more symmetrical
Message-ID: <20131212185917.7ed6b21f@armhf>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.22; arm-unknown-linux-gnueabihf)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch renders optional the CODEC name / OF node on sound card register,
as it is done for the CPU side, in the case the CODEC DAI name is unique.

This simplifies the definition of CODECs with multiple DAIs, especially
in DTs, while keeping compatibility.

Signed-off-by: Jean-Francois Moine <moinejf@free.fr>
---
 include/sound/soc.h  |  6 ++++--
 sound/soc/soc-core.c | 73 ++++++++++++++++++++++++++++++++++++++++----------------------
 2 files changed, 51 insertions(+), 28 deletions(-)

diff --git a/include/sound/soc.h b/include/sound/soc.h
index 1f741cb..67c382e 100644
--- a/include/sound/soc.h
+++ b/include/sound/soc.h
@@ -852,8 +852,10 @@ struct snd_soc_dai_link {
 	 */
 	const char *cpu_dai_name;
 	/*
-	 * You MUST specify the link's codec, either by device name, or by
-	 * DT/OF node, but not both.
+	 * You MAY specify the link's codec, either by device name, or by
+	 * DT/OF node, but not both. If this information is omitted,
+	 * the CODEC DAI is matched using .codec_dai_name only, which hence
+	 * must be globally unique.
 	 */
 	const char *codec_name;
 	const struct device_node *codec_of_node;
diff --git a/sound/soc/soc-core.c b/sound/soc/soc-core.c
index 4e53d87..11b729c 100644
--- a/sound/soc/soc-core.c
+++ b/sound/soc/soc-core.c
@@ -883,28 +883,54 @@ static int soc_bind_dai_link(struct snd_soc_card *card, int num)
 		return -EPROBE_DEFER;
 	}
 
-	/* Find CODEC from registered CODECs */
-	list_for_each_entry(codec, &codec_list, list) {
-		if (dai_link->codec_of_node) {
-			if (codec->dev->of_node != dai_link->codec_of_node)
-				continue;
-		} else {
-			if (strcmp(codec->name, dai_link->codec_name))
-				continue;
+	if (dai_link->codec_of_node || dai_link->codec_name) {
+
+		/* Find CODEC from registered CODECs */
+		list_for_each_entry(codec, &codec_list, list) {
+			if (dai_link->codec_of_node) {
+				if (codec->dev->of_node != dai_link->codec_of_node)
+					continue;
+			} else {
+				if (strcmp(codec->name, dai_link->codec_name))
+					continue;
+			}
+
+			rtd->codec = codec;
+
+			/*
+			 * CODEC found, so find CODEC DAI from registered DAIs from
+			 * this CODEC
+			 */
+			list_for_each_entry(codec_dai, &dai_list, list) {
+				if (codec->dev == codec_dai->dev &&
+					!strcmp(codec_dai->name,
+						dai_link->codec_dai_name)) {
+
+					rtd->codec_dai = codec_dai;
+				}
+			}
+
+			if (!rtd->codec_dai) {
+				dev_err(card->dev, "ASoC: CODEC DAI %s not registered\n",
+					dai_link->codec_dai_name);
+				return -EPROBE_DEFER;
+			}
 		}
 
-		rtd->codec = codec;
+		if (!rtd->codec) {
+			dev_err(card->dev, "ASoC: CODEC %s not registered\n",
+				dai_link->codec_name);
+			return -EPROBE_DEFER;
+		}
+	} else {
 
-		/*
-		 * CODEC found, so find CODEC DAI from registered DAIs from
-		 * this CODEC
-		 */
+		/* find CODEC DAI from registered DAIs */
 		list_for_each_entry(codec_dai, &dai_list, list) {
-			if (codec->dev == codec_dai->dev &&
-				!strcmp(codec_dai->name,
+			if (!strcmp(codec_dai->name,
 					dai_link->codec_dai_name)) {
-
 				rtd->codec_dai = codec_dai;
+				rtd->codec = codec_dai->codec;
+				break;
 			}
 		}
 
@@ -915,12 +941,6 @@ static int soc_bind_dai_link(struct snd_soc_card *card, int num)
 		}
 	}
 
-	if (!rtd->codec) {
-		dev_err(card->dev, "ASoC: CODEC %s not registered\n",
-			dai_link->codec_name);
-		return -EPROBE_DEFER;
-	}
-
 	/* if there's no platform we match on the empty platform */
 	platform_name = dai_link->platform_name;
 	if (!platform_name && !dai_link->platform_of_node)
@@ -3710,12 +3730,13 @@ int snd_soc_register_card(struct snd_soc_card *card)
 		struct snd_soc_dai_link *link = &card->dai_link[i];
 
 		/*
-		 * Codec must be specified by 1 of name or OF node,
-		 * not both or neither.
+		 * Codec may be specified by either name or OF node,
+		 * but can be left unspecified
+		 * and will be matched based on CODEC DAI name alone.
 		 */
-		if (!!link->codec_name == !!link->codec_of_node) {
+		if (link->codec_name && link->codec_of_node) {
 			dev_err(card->dev,
-				"ASoC: Neither/both codec name/of_node are set for %s\n",
+				"ASoC: Both codec name/of_node are set for %s\n",
 				link->name);
 			return -EINVAL;
 		}


-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
