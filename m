Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932324AbaD1OIO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 10:08:14 -0400
Received: from ring0.de ([5.45.105.125]:52016 "EHLO ring0.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932262AbaD1OIH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 10:08:07 -0400
X-Spam-Report: * -0.0 NO_RELAYS Informational: message was not relayed via SMTP
	* -1.9 BAYES_00 BODY: Bayes spam probability is 0 to 1%
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
        alsa-devel@alsa-project.org, Sebastian Reichel <sre@kernel.org>
Subject: [PATCHv2 6/9] ASoC: omap: rx51: get GPIO numbers via gpiod API
Date: Mon, 28 Apr 2014 16:07:24 +0200
Message-Id: <1398694047-28596-7-git-send-email-sre@kernel.org>
X-Mailer: git-send-email 1.9.2
In-Reply-To: <1398694047-28596-1-git-send-email-sre@kernel.org>
References: <1398694047-28596-1-git-send-email-sre@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Update the driver to get GPIO numbers from the
devm gpiod API instead of requesting hardcoded
GPIO numbers.

Signed-off-by: Sebastian Reichel <sre@kernel.org>
---
 sound/soc/omap/rx51.c | 114 ++++++++++++++++++++++++++++++++++----------------
 1 file changed, 79 insertions(+), 35 deletions(-)

diff --git a/sound/soc/omap/rx51.c b/sound/soc/omap/rx51.c
index e140b1b..30cfac0 100644
--- a/sound/soc/omap/rx51.c
+++ b/sound/soc/omap/rx51.c
@@ -26,6 +26,7 @@
 #include <linux/delay.h>
 #include <linux/gpio.h>
 #include <linux/platform_device.h>
+#include <linux/gpio/consumer.h>
 #include <linux/module.h>
 #include <sound/core.h>
 #include <sound/jack.h>
@@ -38,15 +39,6 @@
 
 #include "omap-mcbsp.h"
 
-#define RX51_TVOUT_SEL_GPIO		40
-#define RX51_JACK_DETECT_GPIO		177
-#define RX51_ECI_SW_GPIO		182
-/*
- * REVISIT: TWL4030 GPIO base in RX-51. Now statically defined to 192. This
- * gpio is reserved in arch/arm/mach-omap2/board-rx51-peripherals.c
- */
-#define RX51_SPEAKER_AMP_TWL_GPIO	(192 + 7)
-
 enum {
 	RX51_JACK_DISABLED,
 	RX51_JACK_TVOUT,		/* tv-out with stereo output */
@@ -54,12 +46,21 @@ enum {
 	RX51_JACK_HS,			/* headset: stereo output with mic */
 };
 
+struct rx51_audio_pdata {
+	struct gpio_desc *tvout_selection_gpio;
+	struct gpio_desc *jack_detection_gpio;
+	struct gpio_desc *eci_sw_gpio;
+	struct gpio_desc *speaker_amp_gpio;
+};
+
 static int rx51_spk_func;
 static int rx51_dmic_func;
 static int rx51_jack_func;
 
 static void rx51_ext_control(struct snd_soc_dapm_context *dapm)
 {
+	struct snd_soc_card *card = dapm->card;
+	struct rx51_audio_pdata *pdata = snd_soc_card_get_drvdata(card);
 	int hp = 0, hs = 0, tvout = 0;
 
 	switch (rx51_jack_func) {
@@ -93,7 +94,7 @@ static void rx51_ext_control(struct snd_soc_dapm_context *dapm)
 	else
 		snd_soc_dapm_disable_pin_unlocked(dapm, "HS Mic");
 
-	gpio_set_value(RX51_TVOUT_SEL_GPIO, tvout);
+	gpiod_set_value(pdata->tvout_selection_gpio, tvout);
 
 	snd_soc_dapm_sync_unlocked(dapm);
 
@@ -154,10 +155,12 @@ static int rx51_set_spk(struct snd_kcontrol *kcontrol,
 static int rx51_spk_event(struct snd_soc_dapm_widget *w,
 			  struct snd_kcontrol *k, int event)
 {
-	if (SND_SOC_DAPM_EVENT_ON(event))
-		gpio_set_value_cansleep(RX51_SPEAKER_AMP_TWL_GPIO, 1);
-	else
-		gpio_set_value_cansleep(RX51_SPEAKER_AMP_TWL_GPIO, 0);
+	struct snd_soc_dapm_context *dapm = w->dapm;
+	struct snd_soc_card *card = dapm->card;
+	struct rx51_audio_pdata *pdata = snd_soc_card_get_drvdata(card);
+
+	gpiod_set_raw_value_cansleep(pdata->speaker_amp_gpio,
+				     !!SND_SOC_DAPM_EVENT_ON(event));
 
 	return 0;
 }
@@ -223,7 +226,6 @@ static struct snd_soc_jack rx51_av_jack;
 
 static struct snd_soc_jack_gpio rx51_av_jack_gpios[] = {
 	{
-		.gpio = RX51_JACK_DETECT_GPIO,
 		.name = "avdet-gpio",
 		.report = SND_JACK_HEADSET,
 		.invert = 1,
@@ -284,6 +286,9 @@ static const struct snd_kcontrol_new aic34_rx51_controls[] = {
 static int rx51_aic34_init(struct snd_soc_pcm_runtime *rtd)
 {
 	struct snd_soc_codec *codec = rtd->codec;
+	struct snd_soc_card *card = codec->card;
+	struct rx51_audio_pdata *pdata = snd_soc_card_get_drvdata(card);
+
 	struct snd_soc_dapm_context *dapm = &codec->dapm;
 	int err;
 
@@ -307,6 +312,11 @@ static int rx51_aic34_init(struct snd_soc_pcm_runtime *rtd)
 			       &rx51_av_jack);
 	if (err)
 		return err;
+
+	/* prepare gpio for snd_soc_jack_add_gpios */
+	rx51_av_jack_gpios[0].gpio = desc_to_gpio(pdata->jack_detection_gpio);
+	devm_gpiod_put(card->dev, pdata->jack_detection_gpio);
+
 	err = snd_soc_jack_add_gpios(&rx51_av_jack,
 				     ARRAY_SIZE(rx51_av_jack_gpios),
 				     rx51_av_jack_gpios);
@@ -365,37 +375,74 @@ static struct snd_soc_card rx51_sound_card = {
 
 static int rx51_soc_probe(struct platform_device *pdev)
 {
+	struct rx51_audio_pdata *pdata;
 	struct snd_soc_card *card = &rx51_sound_card;
 	int err;
 
 	if (!machine_is_nokia_rx51() && !of_machine_is_compatible("nokia,omap3-n900"))
 		return -ENODEV;
 
-	err = gpio_request_one(RX51_TVOUT_SEL_GPIO,
-			       GPIOF_DIR_OUT | GPIOF_INIT_LOW, "tvout_sel");
-	if (err)
-		goto err_gpio_tvout_sel;
-	err = gpio_request_one(RX51_ECI_SW_GPIO,
-			       GPIOF_DIR_OUT | GPIOF_INIT_HIGH, "eci_sw");
-	if (err)
-		goto err_gpio_eci_sw;
-
 	card->dev = &pdev->dev;
 
+	pdata = devm_kzalloc(&pdev->dev, sizeof(*pdata), GFP_KERNEL);
+	if (pdata == NULL) {
+		dev_err(card->dev, "failed to create private data\n");
+		return -ENOMEM;
+	}
+	snd_soc_card_set_drvdata(card, pdata);
+
+	pdata->tvout_selection_gpio = devm_gpiod_get(card->dev,
+						     "tvout-selection");
+	if (IS_ERR(pdata->tvout_selection_gpio)) {
+		dev_err(card->dev, "could not get tvout selection gpio\n");
+		return PTR_ERR(pdata->tvout_selection_gpio);
+	}
+
+	err = gpiod_direction_output(pdata->tvout_selection_gpio, 0);
+	if (err) {
+		dev_err(card->dev, "could not setup tvout selection gpio\n");
+		return err;
+	}
+
+	pdata->jack_detection_gpio = devm_gpiod_get(card->dev,
+						    "jack-detection");
+	if (IS_ERR(pdata->jack_detection_gpio)) {
+		dev_err(card->dev, "could not get jack detection gpio\n");
+		return PTR_ERR(pdata->jack_detection_gpio);
+	}
+
+	pdata->eci_sw_gpio = devm_gpiod_get(card->dev, "eci-switch");
+	if (IS_ERR(pdata->eci_sw_gpio)) {
+		dev_err(card->dev, "could not get eci switch gpio\n");
+		return PTR_ERR(pdata->eci_sw_gpio);
+	}
+
+	err = gpiod_direction_output(pdata->eci_sw_gpio, 1);
+	if (err) {
+		dev_err(card->dev, "could not setup eci switch gpio\n");
+		return err;
+	}
+
+	pdata->speaker_amp_gpio = devm_gpiod_get(card->dev,
+						 "speaker-amplifier");
+	if (IS_ERR(pdata->speaker_amp_gpio)) {
+		dev_err(card->dev, "could not get speaker enable gpio\n");
+		return PTR_ERR(pdata->speaker_amp_gpio);
+	}
+
+	err = gpiod_direction_output(pdata->speaker_amp_gpio, 0);
+	if (err) {
+		dev_err(card->dev, "could not setup speaker enable gpio\n");
+		return err;
+	}
+
 	err = devm_snd_soc_register_card(card->dev, card);
 	if (err) {
 		dev_err(&pdev->dev, "snd_soc_register_card failed (%d)\n", err);
-		goto err_snd;
+		return err;
 	}
 
 	return 0;
-err_snd:
-	gpio_free(RX51_ECI_SW_GPIO);
-err_gpio_eci_sw:
-	gpio_free(RX51_TVOUT_SEL_GPIO);
-err_gpio_tvout_sel:
-
-	return err;
 }
 
 static int rx51_soc_remove(struct platform_device *pdev)
@@ -403,9 +450,6 @@ static int rx51_soc_remove(struct platform_device *pdev)
 	snd_soc_jack_free_gpios(&rx51_av_jack, ARRAY_SIZE(rx51_av_jack_gpios),
 				rx51_av_jack_gpios);
 
-	gpio_free(RX51_ECI_SW_GPIO);
-	gpio_free(RX51_TVOUT_SEL_GPIO);
-
 	return 0;
 }
 
-- 
1.9.2

