Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754186AbaDEVgy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Apr 2014 17:36:54 -0400
Received: from ring0.de ([5.45.105.125]:47132 "EHLO ring0.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754005AbaDEVgv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Apr 2014 17:36:51 -0400
X-Spam-Report: * -0.0 NO_RELAYS Informational: message was not relayed via SMTP
	* -1.9 BAYES_00 BODY: Spamwahrscheinlichkeit nach Bayes-Test: 0-1%
	*      [score: 0.0000]
	* -0.0 NO_RECEIVED Informational: message has no Received headers
From: Sebastian Reichel <sre@kernel.org>
To: Sebastian Reichel <sre@ring0.de>, Mark Brown <broonie@kernel.org>,
        Peter Ujfalusi <peter.ujfalusi@ti.com>
Cc: Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Tony Lindgren <tony@atomide.com>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Jarkko Nikula <jarkko.nikula@bitmer.com>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        alsa-devel@alsa-project.org, Sebastian Reichel <sre@kernel.org>,
        Pavel Machek <pavel@ucw.cz>
Subject: [PATCH 2/5] ASoC: Allow Aux Codecs to be specified using DT
Date: Sat,  5 Apr 2014 23:35:50 +0200
Message-Id: <1396733753-9820-3-git-send-email-sre@kernel.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1396733753-9820-1-git-send-email-sre@kernel.org>
References: <1396733753-9820-1-git-send-email-sre@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds support for specifying auxiliary codecs and
codec configuration via device tree phandles.

This change adds new fields to snd_soc_aux_dev and snd_soc_codec_conf
and adds support for the changes to SoC core methods.

Signed-off-by: Sebastian Reichel <sre@kernel.org>
Signed-off-by: Pavel Machek <pavel@ucw.cz>
---
 include/sound/soc.h  | 13 +++++++++-
 sound/soc/soc-core.c | 68 ++++++++++++++++++++++++++++++++--------------------
 2 files changed, 54 insertions(+), 27 deletions(-)

diff --git a/include/sound/soc.h b/include/sound/soc.h
index 0b83168..d371ae1 100644
--- a/include/sound/soc.h
+++ b/include/sound/soc.h
@@ -931,7 +931,12 @@ struct snd_soc_dai_link {
 };
 
 struct snd_soc_codec_conf {
+	/*
+	 * specify device either by device name, or by
+	 * DT/OF node, but not both.
+	 */
 	const char *dev_name;
+	const struct device_node *of_node;
 
 	/*
 	 * optional map of kcontrol, widget and path name prefixes that are
@@ -942,7 +947,13 @@ struct snd_soc_codec_conf {
 
 struct snd_soc_aux_dev {
 	const char *name;		/* Codec name */
-	const char *codec_name;		/* for multi-codec */
+
+	/*
+	 * specify multi-codec either by device name, or by
+	 * DT/OF node, but not both.
+	 */
+	const char *codec_name;
+	const struct device_node *codec_of_node;
 
 	/* codec/machine specific init - e.g. add machine controls */
 	int (*init)(struct snd_soc_dapm_context *dapm);
diff --git a/sound/soc/soc-core.c b/sound/soc/soc-core.c
index 051c006..448a607 100644
--- a/sound/soc/soc-core.c
+++ b/sound/soc/soc-core.c
@@ -1104,10 +1104,12 @@ static void soc_set_name_prefix(struct snd_soc_card *card,
 
 	for (i = 0; i < card->num_configs; i++) {
 		struct snd_soc_codec_conf *map = &card->codec_conf[i];
-		if (map->dev_name && !strcmp(codec->name, map->dev_name)) {
-			codec->name_prefix = map->name_prefix;
-			break;
-		}
+		if (map->of_node && codec->dev->of_node != map->of_node)
+			continue;
+		if (map->dev_name && strcmp(codec->name, map->dev_name))
+			continue;
+		codec->name_prefix = map->name_prefix;
+		break;
 	}
 }
 
@@ -1541,52 +1543,66 @@ static void soc_unregister_ac97_dai_link(struct snd_soc_codec *codec)
 }
 #endif
 
-static int soc_check_aux_dev(struct snd_soc_card *card, int num)
+struct snd_soc_codec *soc_find_matching_codec(struct snd_soc_card *card, int num)
 {
 	struct snd_soc_aux_dev *aux_dev = &card->aux_dev[num];
 	struct snd_soc_codec *codec;
 
-	/* find CODEC from registered CODECs*/
+	/* find CODEC from registered CODECs */
 	list_for_each_entry(codec, &codec_list, list) {
-		if (!strcmp(codec->name, aux_dev->codec_name))
-			return 0;
+		if (aux_dev->codec_of_node &&
+		   (codec->dev->of_node != aux_dev->codec_of_node))
+			continue;
+		if (aux_dev->codec_name && strcmp(codec->name, aux_dev->codec_name))
+			continue;
+		return codec;
 	}
 
-	dev_err(card->dev, "ASoC: %s not registered\n", aux_dev->codec_name);
+	return NULL;
+}
+
+static int soc_check_aux_dev(struct snd_soc_card *card, int num)
+{
+	struct snd_soc_aux_dev *aux_dev = &card->aux_dev[num];
+	const char *codecname = aux_dev->codec_name;
+	struct snd_soc_codec *codec = soc_find_matching_codec(card, num);
 
+	if (codec)
+		return 0;
+	if (aux_dev->codec_of_node)
+		codecname = of_node_full_name(aux_dev->codec_of_node);
+
+	dev_err(card->dev, "ASoC: %s not registered\n", codecname);
 	return -EPROBE_DEFER;
 }
 
 static int soc_probe_aux_dev(struct snd_soc_card *card, int num)
 {
 	struct snd_soc_aux_dev *aux_dev = &card->aux_dev[num];
-	struct snd_soc_codec *codec;
+	const char *codecname = aux_dev->codec_name;
 	int ret = -ENODEV;
+	struct snd_soc_codec *codec = soc_find_matching_codec(card, num);
 
-	/* find CODEC from registered CODECs*/
-	list_for_each_entry(codec, &codec_list, list) {
-		if (!strcmp(codec->name, aux_dev->codec_name)) {
-			if (codec->probed) {
-				dev_err(codec->dev,
-					"ASoC: codec already probed");
-				ret = -EBUSY;
-				goto out;
-			}
-			goto found;
-		}
+	if (!codec) {
+		if (aux_dev->codec_of_node)
+			codecname = of_node_full_name(aux_dev->codec_of_node);
+
+		/* codec not found */
+		dev_err(card->dev, "ASoC: codec %s not found", codecname);
+		return -EPROBE_DEFER;
+	}
+
+	if (codec->probed) {
+		dev_err(codec->dev, "ASoC: codec already probed");
+		return -EBUSY;
 	}
-	/* codec not found */
-	dev_err(card->dev, "ASoC: codec %s not found", aux_dev->codec_name);
-	return -EPROBE_DEFER;
 
-found:
 	ret = soc_probe_codec(card, codec);
 	if (ret < 0)
 		return ret;
 
 	ret = soc_post_component_init(card, codec, num, 1);
 
-out:
 	return ret;
 }
 
-- 
1.9.1

