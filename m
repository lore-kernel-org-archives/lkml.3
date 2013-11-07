Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752438Ab3KGM1B (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 07:27:01 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:47130 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750964Ab3KGM06 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 07:26:58 -0500
Date: Thu, 7 Nov 2013 13:26:55 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Sebastian Reichel <sre@debian.org>
Cc: Sebastian Reichel <sre@ring0.de>, Peter Ujfalusi <peter.ujfalusi@ti.com>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
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
        alsa-devel@alsa-project.org
Subject: Re: [RFC 3/4] ASoC: Allow Aux Codecs to be specified using DT
Message-ID: <20131107122655.GA7110@amd.pavel.ucw.cz>
References: <1382909086-10493-1-git-send-email-sre@debian.org>
 <1382909086-10493-4-git-send-email-sre@debian.org>
 <20131106142559.GC15551@amd.pavel.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131106142559.GC15551@amd.pavel.ucw.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!


> So in (error) case of ! aux_dev->codec_of_node && ! aux_dev->codec_name 
> we match first possible codec?
> 
> Given code similarity between this and the one above, should there be
> helper function that does the comparison (or even walks the list)?

Something like this? soc_probe_aux_dev now looks better... (Only
compile tested).

Signed-off-by: Pavel Machek <pavel@ucw.cz>

diff --git a/sound/soc/soc-core.c b/sound/soc/soc-core.c
index 392f479..3097e17 100644
--- a/sound/soc/soc-core.c
+++ b/sound/soc/soc-core.c
@@ -1526,69 +1526,65 @@ static void soc_unregister_ac97_dai_link(struct snd_soc_codec *codec)
 }
 #endif
 
-static int soc_check_aux_dev(struct snd_soc_card *card, int num)
+struct snd_soc_codec *soc_find_matching_codec(struct snd_soc_card *card, int num)
 {
 	struct snd_soc_aux_dev *aux_dev = &card->aux_dev[num];
-	const char *codecname = aux_dev->codec_name;
 	struct snd_soc_codec *codec;
 
-	/* find CODEC from registered CODECs*/
+	/* find CODEC from registered CODECs */
 	list_for_each_entry(codec, &codec_list, list) {
-		if (aux_dev->codec_of_node &&
-				codec->dev->of_node == aux_dev->codec_of_node)
-			return 0;
-		if (aux_dev->codec_name &&
-				!strcmp(codec->name, aux_dev->codec_name))
-			return 0;
+		if (aux_dev->codec_of_node && 
+		    (codec->dev->of_node != aux_dev->codec_of_node))
+			continue;
+		if (aux_dev->codec_name && strcmp(codec->name, aux_dev->codec_name))
+			continue;
+		return codec;
 	}
+	return NULL;
+}
 
+static int soc_check_aux_dev(struct snd_soc_card *card, int num)
+{
+	struct snd_soc_aux_dev *aux_dev = &card->aux_dev[num];
+	const char *codecname = aux_dev->codec_name;
+	struct snd_soc_codec *codec = soc_find_matching_codec(card, num);
+
+	if (codec)
+		return 0;
 	if (aux_dev->codec_of_node)
 		codecname = of_node_full_name(aux_dev->codec_of_node);
 
 	dev_err(card->dev, "ASoC: %s not registered\n", codecname);
-
 	return -EPROBE_DEFER;
 }
 
+
 static int soc_probe_aux_dev(struct snd_soc_card *card, int num)
 {
 	struct snd_soc_aux_dev *aux_dev = &card->aux_dev[num];
-	struct snd_soc_codec *codec;
 	const char *codecname = aux_dev->codec_name;
 	int ret = -ENODEV;
+	struct snd_soc_codec *codec = soc_find_matching_codec(card, num);
 
-	/* find CODEC from registered CODECs*/
-	list_for_each_entry(codec, &codec_list, list) {
-		if (aux_dev->codec_of_node &&
-				codec->dev->of_node != aux_dev->codec_of_node)
-			continue;
-		if (aux_dev->codec_name &&
-				strcmp(codec->name, aux_dev->codec_name))
-			continue;
+	if (!codec) {
+		if (aux_dev->codec_of_node)
+			codecname = of_node_full_name(aux_dev->codec_of_node);
 
-		if (codec->probed) {
-			dev_err(codec->dev, "ASoC: codec already probed");
-			ret = -EBUSY;
-			goto out;
-		}
-		goto found;
+		/* codec not found */
+		dev_err(card->dev, "ASoC: codec %s not found", codecname);
+		return -EPROBE_DEFER;
 	}
 
-	if (aux_dev->codec_of_node)
-		codecname = of_node_full_name(aux_dev->codec_of_node);
-
-	/* codec not found */
-	dev_err(card->dev, "ASoC: codec %s not found", codecname);
-	return -EPROBE_DEFER;
+	if (codec->probed) {
+		dev_err(codec->dev, "ASoC: codec already probed");
+		return -EBUSY;
+	}
 
-found:
 	ret = soc_probe_codec(card, codec);
 	if (ret < 0)
 		return ret;
 
 	ret = soc_post_component_init(card, codec, num, 1);
-
-out:
 	return ret;
 }
 


-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
