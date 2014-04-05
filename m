Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754219AbaDEVhP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Apr 2014 17:37:15 -0400
Received: from ring0.de ([5.45.105.125]:47191 "EHLO ring0.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753899AbaDEVhK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Apr 2014 17:37:10 -0400
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
        alsa-devel@alsa-project.org, Sebastian Reichel <sre@kernel.org>
Subject: [PATCH 4/5] ASoC: RX-51: Convert to table based DAPM setup
Date: Sat,  5 Apr 2014 23:35:52 +0200
Message-Id: <1396733753-9820-5-git-send-email-sre@kernel.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1396733753-9820-1-git-send-email-sre@kernel.org>
References: <1396733753-9820-1-git-send-email-sre@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use table based setup to register the DAPM widgets and routes. This on one hand
makes the code a bit cleaner and on the other hand the board level DAPM
elements get registered in the card's DAPM context rather than in the CODEC's
DAPM context. This fixes an issue with double prefixing of routes.

Signed-off-by: Sebastian Reichel <sre@kernel.org>
---
 sound/soc/omap/rx51.c | 48 ++++++------------------------------------------
 1 file changed, 6 insertions(+), 42 deletions(-)

diff --git a/sound/soc/omap/rx51.c b/sound/soc/omap/rx51.c
index 89deeb7..418bd41 100644
--- a/sound/soc/omap/rx51.c
+++ b/sound/soc/omap/rx51.c
@@ -233,9 +233,6 @@ static const struct snd_soc_dapm_widget aic34_dapm_widgets[] = {
 	SND_SOC_DAPM_HP("Headphone Jack", rx51_hp_event),
 	SND_SOC_DAPM_MIC("HS Mic", NULL),
 	SND_SOC_DAPM_LINE("FM Transmitter", NULL),
-};
-
-static const struct snd_soc_dapm_widget aic34_dapm_widgetsb[] = {
 	SND_SOC_DAPM_SPK("Earphone", NULL),
 };
 
@@ -249,9 +246,7 @@ static const struct snd_soc_dapm_route audio_map[] = {
 
 	{"DMic Rate 64", NULL, "Mic Bias"},
 	{"Mic Bias", NULL, "DMic"},
-};
 
-static const struct snd_soc_dapm_route audio_mapb[] = {
 	{"b LINE2R", NULL, "MONO_LOUT"},
 	{"Earphone", NULL, "b HPLOUT"},
 
@@ -277,9 +272,6 @@ static const struct snd_kcontrol_new aic34_rx51_controls[] = {
 	SOC_ENUM_EXT("Jack Function", rx51_enum[2],
 		     rx51_get_jack, rx51_set_jack),
 	SOC_DAPM_PIN_SWITCH("FM Transmitter"),
-};
-
-static const struct snd_kcontrol_new aic34_rx51_controlsb[] = {
 	SOC_DAPM_PIN_SWITCH("Earphone"),
 };
 
@@ -297,21 +289,6 @@ static int rx51_aic34_init(struct snd_soc_pcm_runtime *rtd)
 	snd_soc_dapm_nc_pin(dapm, "MIC3R");
 	snd_soc_dapm_nc_pin(dapm, "LINE1R");
 
-	/* Add RX-51 specific controls */
-	err = snd_soc_add_card_controls(rtd->card, aic34_rx51_controls,
-				   ARRAY_SIZE(aic34_rx51_controls));
-	if (err < 0) {
-		dev_err(card->dev, "Failed to add RX-51 specific controls\n");
-		return err;
-	}
-
-	/* Add RX-51 specific widgets */
-	snd_soc_dapm_new_controls(dapm, aic34_dapm_widgets,
-				  ARRAY_SIZE(aic34_dapm_widgets));
-
-	/* Set up RX-51 specific audio path audio_map */
-	snd_soc_dapm_add_routes(dapm, audio_map, ARRAY_SIZE(audio_map));
-
 	err = tpa6130a2_add_controls(codec);
 	if (err < 0) {
 		dev_err(card->dev, "Failed to add TPA6130A2 controls\n");
@@ -348,24 +325,6 @@ static int rx51_aic34_init(struct snd_soc_pcm_runtime *rtd)
 	return 0;
 }
 
-static int rx51_aic34b_init(struct snd_soc_dapm_context *dapm)
-{
-	int err;
-
-	err = snd_soc_add_card_controls(dapm->card, aic34_rx51_controlsb,
-				   ARRAY_SIZE(aic34_rx51_controlsb));
-	if (err < 0)
-		return err;
-
-	err = snd_soc_dapm_new_controls(dapm, aic34_dapm_widgetsb,
-					ARRAY_SIZE(aic34_dapm_widgetsb));
-	if (err < 0)
-		return 0;
-
-	return snd_soc_dapm_add_routes(dapm, audio_mapb,
-				       ARRAY_SIZE(audio_mapb));
-}
-
 /* Digital audio interface glue - connects codec <--> CPU */
 static struct snd_soc_dai_link rx51_dai[] = {
 	{
@@ -386,7 +345,6 @@ static struct snd_soc_aux_dev rx51_aux_dev[] = {
 	{
 		.name = "TLV320AIC34b",
 		.codec_name = "tlv320aic3x-codec.2-0019",
-		.init = rx51_aic34b_init,
 	},
 };
 
@@ -407,6 +365,12 @@ static struct snd_soc_card rx51_sound_card = {
 	.num_aux_devs = ARRAY_SIZE(rx51_aux_dev),
 	.codec_conf = rx51_codec_conf,
 	.num_configs = ARRAY_SIZE(rx51_codec_conf),
+	.dapm_widgets = aic34_dapm_widgets,
+	.num_dapm_widgets = ARRAY_SIZE(aic34_dapm_widgets),
+	.controls = aic34_rx51_controls,
+	.num_controls = ARRAY_SIZE(aic34_rx51_controls),
+	.dapm_routes = audio_map,
+	.num_dapm_routes = ARRAY_SIZE(audio_map),
 };
 
 static int rx51_soc_probe(struct platform_device *pdev)
-- 
1.9.1

