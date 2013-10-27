Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755060Ab3J0VZQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Oct 2013 17:25:16 -0400
Received: from ring0.de ([91.143.88.219]:60028 "EHLO smtp.ring0.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754971Ab3J0VZJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Oct 2013 17:25:09 -0400
X-Spam-Report: * -0.0 NO_RELAYS Informational: message was not relayed via SMTP
	* -1.9 BAYES_00 BODY: Spamwahrscheinlichkeit nach Bayes-Test: 0-1%
	*      [score: 0.0000]
	* -0.0 NO_RECEIVED Informational: message has no Received headers
From: Sebastian Reichel <sre@debian.org>
To: Sebastian Reichel <sre@ring0.de>, Peter Ujfalusi <peter.ujfalusi@ti.com>
Cc: Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>, Tony Lindgren <tony@atomide.com>,
        Russell King <linux@arm.linux.org.uk>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Jarkko Nikula <jarkko.nikula@bitmer.com>,
        Grant Likely <grant.likely@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org,
        alsa-devel@alsa-project.org, Sebastian Reichel <sre@debian.org>
Subject: [RFC 3/4] ASoC: Allow Aux Codecs to be specified using DT
Date: Sun, 27 Oct 2013 22:24:45 +0100
Message-Id: <1382909086-10493-4-git-send-email-sre@debian.org>
X-Mailer: git-send-email 1.8.4.rc3
In-Reply-To: <1382909086-10493-1-git-send-email-sre@debian.org>
References: <1382909086-10493-1-git-send-email-sre@debian.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds support for specifying auxiliary codecs and
codec configuration via device tree phandles.

This change adds new fields to snd_soc_aux_dev and snd_soc_codec_conf
and adds support for the changes to SoC core methods.

Signed-off-by: Sebastian Reichel <sre@debian.org>
---
 include/sound/soc.h  | 13 +++++++++-
 sound/soc/soc-core.c | 68 ++++++++++++++++++++++++++++++++++++----------------
 2 files changed, 59 insertions(+), 22 deletions(-)

diff --git a/include/sound/soc.h b/include/sound/soc.h
index d22cb0a..00b25a8 100644
--- a/include/sound/soc.h
+++ b/include/sound/soc.h
@@ -937,7 +937,12 @@ struct snd_soc_dai_link {
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
@@ -954,7 +959,13 @@ struct snd_soc_codec_conf {
 
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
index 1a38be0..392f479 100644
--- a/sound/soc/soc-core.c
+++ b/sound/soc/soc-core.c
@@ -1085,10 +1085,12 @@ static void soc_set_name_prefix(struct snd_soc_card *card,
 
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
 
@@ -1527,15 +1529,23 @@ static void soc_unregister_ac97_dai_link(struct snd_soc_codec *codec)
 static int soc_check_aux_dev(struct snd_soc_card *card, int num)
 {
 	struct snd_soc_aux_dev *aux_dev = &card->aux_dev[num];
+	const char *codecname = aux_dev->codec_name;
 	struct snd_soc_codec *codec;
 
 	/* find CODEC from registered CODECs*/
 	list_for_each_entry(codec, &codec_list, list) {
-		if (!strcmp(codec->name, aux_dev->codec_name))
+		if (aux_dev->codec_of_node &&
+				codec->dev->of_node == aux_dev->codec_of_node)
+			return 0;
+		if (aux_dev->codec_name &&
+				!strcmp(codec->name, aux_dev->codec_name))
 			return 0;
 	}
 
-	dev_err(card->dev, "ASoC: %s not registered\n", aux_dev->codec_name);
+	if (aux_dev->codec_of_node)
+		codecname = of_node_full_name(aux_dev->codec_of_node);
+
+	dev_err(card->dev, "ASoC: %s not registered\n", codecname);
 
 	return -EPROBE_DEFER;
 }
@@ -1544,22 +1554,31 @@ static int soc_probe_aux_dev(struct snd_soc_card *card, int num)
 {
 	struct snd_soc_aux_dev *aux_dev = &card->aux_dev[num];
 	struct snd_soc_codec *codec;
+	const char *codecname = aux_dev->codec_name;
 	int ret = -ENODEV;
 
 	/* find CODEC from registered CODECs*/
 	list_for_each_entry(codec, &codec_list, list) {
-		if (!strcmp(codec->name, aux_dev->codec_name)) {
-			if (codec->probed) {
-				dev_err(codec->dev,
-					"ASoC: codec already probed");
-				ret = -EBUSY;
-				goto out;
-			}
-			goto found;
+		if (aux_dev->codec_of_node &&
+				codec->dev->of_node != aux_dev->codec_of_node)
+			continue;
+		if (aux_dev->codec_name &&
+				strcmp(codec->name, aux_dev->codec_name))
+			continue;
+
+		if (codec->probed) {
+			dev_err(codec->dev, "ASoC: codec already probed");
+			ret = -EBUSY;
+			goto out;
 		}
+		goto found;
 	}
+
+	if (aux_dev->codec_of_node)
+		codecname = of_node_full_name(aux_dev->codec_of_node);
+
 	/* codec not found */
-	dev_err(card->dev, "ASoC: codec %s not found", aux_dev->codec_name);
+	dev_err(card->dev, "ASoC: codec %s not found", codecname);
 	return -EPROBE_DEFER;
 
 found:
@@ -1644,12 +1663,19 @@ static int snd_soc_instantiate_card(struct snd_soc_card *card)
 		/* check to see if we need to override the compress_type */
 		for (i = 0; i < card->num_configs; ++i) {
 			codec_conf = &card->codec_conf[i];
-			if (!strcmp(codec->name, codec_conf->dev_name)) {
-				compress_type = codec_conf->compress_type;
-				if (compress_type && compress_type
-				    != codec->compress_type)
-					break;
-			}
+
+			if (codec_conf->of_node &&
+				codec->dev->of_node != codec_conf->of_node)
+				continue;
+
+			if (codec_conf->dev_name &&
+				strcmp(codec->name, codec_conf->dev_name))
+				continue;
+
+			compress_type = codec_conf->compress_type;
+			if (compress_type && compress_type
+			    != codec->compress_type)
+				break;
 		}
 		ret = snd_soc_init_codec_cache(codec, compress_type);
 		if (ret < 0)
-- 
1.8.4.rc3

