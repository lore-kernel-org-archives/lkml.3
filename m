Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756882AbbAZUxO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 15:53:14 -0500
Received: from mail-we0-f175.google.com ([74.125.82.175]:34898 "EHLO
	mail-we0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754058AbbAZUxK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 15:53:10 -0500
From: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali.rohar@gmail.com>
To: Peter Ujfalusi <peter.ujfalusi@ti.com>,
        Jarkko Nikula <jarkko.nikula@bitmer.com>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>
Cc: linux-omap@vger.kernel.org, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org, Pavel Machek <pavel@ucw.cz>,
        Sebastian Reichel <sre@debian.org>,
        Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>,
        Aaro Koskinen <aaro.koskinen@iki.fi>,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali.rohar@gmail.com>
Subject: [PATCH] ASoC: rx51: do not fail if could not get jack detection gpio
Date: Mon, 26 Jan 2015 21:51:47 +0100
Message-Id: <1422305507-10533-1-git-send-email-pali.rohar@gmail.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

qemu does not emulate it

Signed-off-by: Pali Rohár <pali.rohar@gmail.com>
---
 sound/soc/omap/rx51.c |   45 +++++++++++++++++++++++++--------------------
 1 file changed, 25 insertions(+), 20 deletions(-)

diff --git a/sound/soc/omap/rx51.c b/sound/soc/omap/rx51.c
index 04896d6..a689021 100644
--- a/sound/soc/omap/rx51.c
+++ b/sound/soc/omap/rx51.c
@@ -310,25 +310,27 @@ static int rx51_aic34_init(struct snd_soc_pcm_runtime *rtd)
 		return err;
 	}
 
-	/* AV jack detection */
-	err = snd_soc_jack_new(codec, "AV Jack",
-			       SND_JACK_HEADSET | SND_JACK_VIDEOOUT,
-			       &rx51_av_jack);
-	if (err) {
-		dev_err(card->dev, "Failed to add AV Jack\n");
-		return err;
-	}
+	if (!IS_ERR(pdata->jack_detection_gpio)) {
+		/* AV jack detection */
+		err = snd_soc_jack_new(codec, "AV Jack",
+				       SND_JACK_HEADSET | SND_JACK_VIDEOOUT,
+				       &rx51_av_jack);
+		if (err) {
+			dev_err(card->dev, "Failed to add AV Jack\n");
+			return err;
+		}
 
-	/* prepare gpio for snd_soc_jack_add_gpios */
-	rx51_av_jack_gpios[0].gpio = desc_to_gpio(pdata->jack_detection_gpio);
-	devm_gpiod_put(card->dev, pdata->jack_detection_gpio);
+		/* prepare gpio for snd_soc_jack_add_gpios */
+		rx51_av_jack_gpios[0].gpio = desc_to_gpio(pdata->jack_detection_gpio);
+		devm_gpiod_put(card->dev, pdata->jack_detection_gpio);
 
-	err = snd_soc_jack_add_gpios(&rx51_av_jack,
-				     ARRAY_SIZE(rx51_av_jack_gpios),
-				     rx51_av_jack_gpios);
-	if (err) {
-		dev_err(card->dev, "Failed to add GPIOs\n");
-		return err;
+		err = snd_soc_jack_add_gpios(&rx51_av_jack,
+					     ARRAY_SIZE(rx51_av_jack_gpios),
+					     rx51_av_jack_gpios);
+		if (err) {
+			dev_err(card->dev, "Failed to add GPIOs\n");
+			return err;
+		}
 	}
 
 	return err;
@@ -336,8 +338,11 @@ static int rx51_aic34_init(struct snd_soc_pcm_runtime *rtd)
 
 static int rx51_card_remove(struct snd_soc_card *card)
 {
-	snd_soc_jack_free_gpios(&rx51_av_jack, ARRAY_SIZE(rx51_av_jack_gpios),
-				rx51_av_jack_gpios);
+	struct rx51_audio_pdata *pdata = snd_soc_card_get_drvdata(card);
+
+	if (!IS_ERR(pdata->jack_detection_gpio))
+		snd_soc_jack_free_gpios(&rx51_av_jack, ARRAY_SIZE(rx51_av_jack_gpios),
+					rx51_av_jack_gpios);
 
 	return 0;
 }
@@ -470,8 +475,8 @@ static int rx51_soc_probe(struct platform_device *pdev)
 	pdata->jack_detection_gpio = devm_gpiod_get(card->dev,
 						    "jack-detection");
 	if (IS_ERR(pdata->jack_detection_gpio)) {
+		/* Do not fail, qemu does not emulate jack detection gpio */
 		dev_err(card->dev, "could not get jack detection gpio\n");
-		return PTR_ERR(pdata->jack_detection_gpio);
 	}
 
 	pdata->eci_sw_gpio = devm_gpiod_get(card->dev, "eci-switch");
-- 
1.7.9.5

