Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755184Ab3J0VZm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Oct 2013 17:25:42 -0400
Received: from ring0.de ([91.143.88.219]:60045 "EHLO smtp.ring0.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754989Ab3J0VZO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Oct 2013 17:25:14 -0400
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
Subject: [RFC 4/4] ASoC: RX-51: Add DT support to sound driver
Date: Sun, 27 Oct 2013 22:24:46 +0100
Message-Id: <1382909086-10493-5-git-send-email-sre@debian.org>
X-Mailer: git-send-email 1.8.4.rc3
In-Reply-To: <1382909086-10493-1-git-send-email-sre@debian.org>
References: <1382909086-10493-1-git-send-email-sre@debian.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds device tree support to the Nokia N900 audio driver.
It also removes GPIO defines and gets them from platform data /
device tree, since some GPIO numbers may be different with DT boot.

The binding also changes a helper function in omap-mcbsp, which
is currently only used by the Nokia N900. This change is needed,
because DT instanced omap-mcbsp driver has no valid id assigned.

Last but not least the DT binding is documented.

Signed-off-by: Sebastian Reichel <sre@debian.org>
---
 .../devicetree/bindings/sound/nokia,rx51.txt       |  28 ++++
 .../devicetree/bindings/vendor-prefixes.txt        |   1 +
 include/sound/rx51.h                               |  18 +++
 sound/soc/omap/omap-mcbsp.c                        |   5 +-
 sound/soc/omap/omap-mcbsp.h                        |   2 +-
 sound/soc/omap/rx51.c                              | 175 ++++++++++++++++-----
 6 files changed, 184 insertions(+), 45 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/sound/nokia,rx51.txt
 create mode 100644 include/sound/rx51.h

diff --git a/Documentation/devicetree/bindings/sound/nokia,rx51.txt b/Documentation/devicetree/bindings/sound/nokia,rx51.txt
new file mode 100644
index 0000000..4f985ca
--- /dev/null
+++ b/Documentation/devicetree/bindings/sound/nokia,rx51.txt
@@ -0,0 +1,28 @@
+* Nokia N900 audio setup
+
+Required properties:
+- compatible: "nokia,rx51-audio"
+- ti,mcbsp: phandle for the McBSP node
+- ti,codec: phandle for the main TLV320AIC3X node
+- ti,codec_aux: phandle for the main TLV320AIC3X auxiliary node
+- ti,headset_amp: phandle for the TPA6130A2 node
+- tvout-selection-gpio: GPIO for tvout selection
+- jack-detection-gpio: GPIO for jack detection
+- eci-sw-gpio: GPIO for ECI SW
+- speaker-amp-gpio: GPIO for Speaker Amp
+
+Example:
+
+sound {
+	compatible = "nokia,rx51-audio";
+
+	ti,mcbsp = <&mcbsp2>;
+	ti,codec = <&tlv320aic3x>;
+	ti,codec_aux = <&tlv320aic3x_aux>;
+	ti,headset_amp = <&tpa6130a2>;
+
+	tvout-selection-gpio = <&gpio2 8 GPIO_ACTIVE_HIGH>; /* 40 */
+	jack-detection-gpio = <&gpio6 17 GPIO_ACTIVE_HIGH>; /* 177 */
+	eci-sw-gpio = <&gpio6 22 GPIO_ACTIVE_HIGH>; /* 182 */
+	speaker-amp-gpio = <&twl_gpio 7 GPIO_ACTIVE_HIGH>;
+};
diff --git a/Documentation/devicetree/bindings/vendor-prefixes.txt b/Documentation/devicetree/bindings/vendor-prefixes.txt
index 2956800..2cc3dad 100644
--- a/Documentation/devicetree/bindings/vendor-prefixes.txt
+++ b/Documentation/devicetree/bindings/vendor-prefixes.txt
@@ -42,6 +42,7 @@ microchip	Microchip Technology Inc.
 mosaixtech	Mosaix Technologies, Inc.
 national	National Semiconductor
 nintendo	Nintendo
+nokia	Nokia Corporation
 nvidia	NVIDIA
 nxp	NXP Semiconductors
 onnn	ON Semiconductor Corp.
diff --git a/include/sound/rx51.h b/include/sound/rx51.h
new file mode 100644
index 0000000..190d745
--- /dev/null
+++ b/include/sound/rx51.h
@@ -0,0 +1,18 @@
+/*
+ * Platform data for Nokia RX-51 SoC audio
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+#ifndef __RX51_AUDIO_H__
+#define __RX51_AUDIO_H__
+
+struct rx51_audio_pdata {
+	int tvout_selection_gpio;
+	int jack_detection_gpio;
+	int eci_sw_gpio;
+	int speaker_amp_gpio;
+};
+
+#endif
diff --git a/sound/soc/omap/omap-mcbsp.c b/sound/soc/omap/omap-mcbsp.c
index 6c19bba..f88e31e 100644
--- a/sound/soc/omap/omap-mcbsp.c
+++ b/sound/soc/omap/omap-mcbsp.c
@@ -691,7 +691,7 @@ OMAP_MCBSP_SOC_SINGLE_S16_EXT("McBSP" #port " Sidetone Channel 1 Volume", \
 OMAP_MCBSP_ST_CONTROLS(2);
 OMAP_MCBSP_ST_CONTROLS(3);
 
-int omap_mcbsp_st_add_controls(struct snd_soc_pcm_runtime *rtd)
+int omap_mcbsp_st_add_controls(struct snd_soc_pcm_runtime *rtd, int port_id)
 {
 	struct snd_soc_dai *cpu_dai = rtd->cpu_dai;
 	struct omap_mcbsp *mcbsp = snd_soc_dai_get_drvdata(cpu_dai);
@@ -701,7 +701,7 @@ int omap_mcbsp_st_add_controls(struct snd_soc_pcm_runtime *rtd)
 		return 0;
 	}
 
-	switch (mcbsp->id) {
+	switch (port_id) {
 	case 2: /* McBSP 2 */
 		return snd_soc_add_dai_controls(cpu_dai,
 					omap_mcbsp2_st_controls,
@@ -711,6 +711,7 @@ int omap_mcbsp_st_add_controls(struct snd_soc_pcm_runtime *rtd)
 					omap_mcbsp3_st_controls,
 					ARRAY_SIZE(omap_mcbsp3_st_controls));
 	default:
+		dev_err(mcbsp->dev, "Port %d not supported\n", port_id);
 		break;
 	}
 
diff --git a/sound/soc/omap/omap-mcbsp.h b/sound/soc/omap/omap-mcbsp.h
index ba8386a..2e3369c 100644
--- a/sound/soc/omap/omap-mcbsp.h
+++ b/sound/soc/omap/omap-mcbsp.h
@@ -39,6 +39,6 @@ enum omap_mcbsp_div {
 	OMAP_MCBSP_CLKGDV,		/* Sample rate generator divider */
 };
 
-int omap_mcbsp_st_add_controls(struct snd_soc_pcm_runtime *rtd);
+int omap_mcbsp_st_add_controls(struct snd_soc_pcm_runtime *rtd, int port_id);
 
 #endif
diff --git a/sound/soc/omap/rx51.c b/sound/soc/omap/rx51.c
index 41f26ae..aa44108 100644
--- a/sound/soc/omap/rx51.c
+++ b/sound/soc/omap/rx51.c
@@ -26,11 +26,13 @@
 #include <linux/delay.h>
 #include <linux/gpio.h>
 #include <linux/platform_device.h>
+#include <linux/of_gpio.h>
 #include <linux/module.h>
 #include <sound/core.h>
 #include <sound/jack.h>
 #include <sound/pcm.h>
 #include <sound/soc.h>
+#include <sound/rx51.h>
 #include <linux/platform_data/asoc-ti-mcbsp.h>
 #include "../codecs/tpa6130a2.h"
 
@@ -38,15 +40,6 @@
 
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
@@ -60,6 +53,8 @@ static int rx51_jack_func;
 
 static void rx51_ext_control(struct snd_soc_dapm_context *dapm)
 {
+	struct snd_soc_card *card = dapm->card;
+	struct rx51_audio_pdata *pdata = snd_soc_card_get_drvdata(card);
 	int hp = 0, hs = 0, tvout = 0;
 
 	switch (rx51_jack_func) {
@@ -91,7 +86,7 @@ static void rx51_ext_control(struct snd_soc_dapm_context *dapm)
 	else
 		snd_soc_dapm_disable_pin(dapm, "HS Mic");
 
-	gpio_set_value(RX51_TVOUT_SEL_GPIO, tvout);
+	gpio_set_value(pdata->tvout_selection_gpio, tvout);
 
 	snd_soc_dapm_sync(dapm);
 }
@@ -150,10 +145,12 @@ static int rx51_set_spk(struct snd_kcontrol *kcontrol,
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
+	gpio_set_value_cansleep(pdata->speaker_amp_gpio,
+				!!SND_SOC_DAPM_EVENT_ON(event));
 
 	return 0;
 }
@@ -219,7 +216,6 @@ static struct snd_soc_jack rx51_av_jack;
 
 static struct snd_soc_jack_gpio rx51_av_jack_gpios[] = {
 	{
-		.gpio = RX51_JACK_DETECT_GPIO,
 		.name = "avdet-gpio",
 		.report = SND_JACK_HEADSET,
 		.invert = 1,
@@ -286,6 +282,9 @@ static const struct snd_kcontrol_new aic34_rx51_controlsb[] = {
 static int rx51_aic34_init(struct snd_soc_pcm_runtime *rtd)
 {
 	struct snd_soc_codec *codec = rtd->codec;
+	struct snd_soc_card *card = codec->card;
+	struct rx51_audio_pdata *pdata = snd_soc_card_get_drvdata(card);
+
 	struct snd_soc_dapm_context *dapm = &codec->dapm;
 	int err;
 
@@ -297,8 +296,10 @@ static int rx51_aic34_init(struct snd_soc_pcm_runtime *rtd)
 	/* Add RX-51 specific controls */
 	err = snd_soc_add_card_controls(rtd->card, aic34_rx51_controls,
 				   ARRAY_SIZE(aic34_rx51_controls));
-	if (err < 0)
+	if (err < 0) {
+		dev_err(card->dev, "Failed to add RX-51 specific controls\n");
 		return err;
+	}
 
 	/* Add RX-51 specific widgets */
 	snd_soc_dapm_new_controls(dapm, aic34_dapm_widgets,
@@ -308,25 +309,39 @@ static int rx51_aic34_init(struct snd_soc_pcm_runtime *rtd)
 	snd_soc_dapm_add_routes(dapm, audio_map, ARRAY_SIZE(audio_map));
 
 	err = tpa6130a2_add_controls(codec);
-	if (err < 0)
+	if (err < 0) {
+		dev_err(card->dev, "Failed to add TPA6130A2 controls\n");
 		return err;
+	}
 	snd_soc_limit_volume(codec, "TPA6130A2 Headphone Playback Volume", 42);
 
-	err = omap_mcbsp_st_add_controls(rtd);
-	if (err < 0)
+	err = omap_mcbsp_st_add_controls(rtd, 2);
+	if (err < 0) {
+		dev_err(card->dev, "Failed to add MCBSP controls\n");
 		return err;
+	}
 
 	/* AV jack detection */
 	err = snd_soc_jack_new(codec, "AV Jack",
 			       SND_JACK_HEADSET | SND_JACK_VIDEOOUT,
 			       &rx51_av_jack);
-	if (err)
+	if (err) {
+		dev_err(card->dev, "Failed to add AV Jack\n");
 		return err;
+
+	}
+
+	rx51_av_jack_gpios[0].gpio = pdata->jack_detection_gpio;
+
 	err = snd_soc_jack_add_gpios(&rx51_av_jack,
-				     ARRAY_SIZE(rx51_av_jack_gpios),
-				     rx51_av_jack_gpios);
+				ARRAY_SIZE(rx51_av_jack_gpios),
+				rx51_av_jack_gpios);
+	if (err) {
+		dev_err(card->dev, "Failed to add GPIOs\n");
+		return err;
+	}
 
-	return err;
+	return 0;
 }
 
 static int rx51_aic34b_init(struct snd_soc_dapm_context *dapm)
@@ -392,37 +407,106 @@ static struct snd_soc_card rx51_sound_card = {
 
 static int rx51_soc_probe(struct platform_device *pdev)
 {
+	struct rx51_audio_pdata *pdata = pdev->dev.platform_data;
+	struct device_node *np = pdev->dev.of_node;
 	struct snd_soc_card *card = &rx51_sound_card;
 	int err;
 
 	if (!machine_is_nokia_rx51() && !of_machine_is_compatible("nokia,omap3-n900"))
 		return -ENODEV;
 
-	err = gpio_request_one(RX51_TVOUT_SEL_GPIO,
+	card->dev = &pdev->dev;
+
+	if (np) {
+		struct device_node *dai_node;
+
+		pdata = devm_kzalloc(&pdev->dev,
+				sizeof(struct rx51_audio_pdata), GFP_KERNEL);
+
+		if (pdata == NULL) {
+			dev_err(card->dev, "failed to create private data\n");
+			return -ENOMEM;
+		}
+
+		pdata->tvout_selection_gpio =
+			of_get_named_gpio(np, "tvout-selection-gpio", 0);
+		pdata->jack_detection_gpio  =
+			of_get_named_gpio(np, "jack-detection-gpio", 0);
+		pdata->eci_sw_gpio = of_get_named_gpio(np, "eci-sw-gpio", 0);
+		pdata->speaker_amp_gpio =
+			of_get_named_gpio(np, "speaker-amp-gpio", 0);
+
+		dai_node = of_parse_phandle(np, "ti,mcbsp", 0);
+		if (!dai_node) {
+			dev_err(&pdev->dev, "McBSP node is not provided\n");
+			return -EINVAL;
+		}
+		rx51_dai[0].cpu_dai_name = NULL;
+		rx51_dai[0].cpu_of_node = dai_node;
+
+		dai_node = of_parse_phandle(np, "ti,codec", 0);
+		if (!dai_node) {
+			dev_err(&pdev->dev, "Codec node is not provided\n");
+			return -EINVAL;
+		}
+		rx51_dai[0].codec_name = NULL;
+		rx51_dai[0].codec_of_node = dai_node;
+
+		dai_node = of_parse_phandle(np, "ti,codec_aux", 0);
+		if (!dai_node) {
+			dev_err(&pdev->dev, "Auxiliary Codec node is not provided\n");
+			return -EINVAL;
+		}
+		rx51_aux_dev[0].codec_name = NULL;
+		rx51_aux_dev[0].codec_of_node = dai_node;
+		rx51_codec_conf[0].dev_name = NULL;
+		rx51_codec_conf[0].of_node = dai_node;
+
+		if (pdata->tvout_selection_gpio == -EPROBE_DEFER ||
+		    pdata->jack_detection_gpio == -EPROBE_DEFER ||
+		    pdata->eci_sw_gpio == -EPROBE_DEFER ||
+		    pdata->speaker_amp_gpio == -EPROBE_DEFER) {
+			devm_kfree(card->dev, pdata);
+			pdev->dev.platform_data = NULL;
+			return -EPROBE_DEFER;
+		}
+
+		pdev->dev.platform_data = pdata;
+	} else if (!pdata) {
+		dev_err(card->dev, "platform data missing");
+		err = -ENODEV;
+		goto error;
+	}
+
+	err = devm_gpio_request_one(card->dev, pdata->tvout_selection_gpio,
 			       GPIOF_DIR_OUT | GPIOF_INIT_LOW, "tvout_sel");
-	if (err)
-		goto err_gpio_tvout_sel;
-	err = gpio_request_one(RX51_ECI_SW_GPIO,
+	if (err) {
+		dev_err(card->dev, "could not setup tvout_sel\n");
+		goto error;
+	}
+	err = devm_gpio_request_one(card->dev, pdata->eci_sw_gpio,
 			       GPIOF_DIR_OUT | GPIOF_INIT_HIGH, "eci_sw");
-	if (err)
-		goto err_gpio_eci_sw;
-
-	card->dev = &pdev->dev;
+	if (err) {
+		dev_err(card->dev, "could not setup eci_sw\n");
+		goto error;
+	}
+	err = devm_gpio_request_one(card->dev, pdata->speaker_amp_gpio,
+			       GPIOF_DIR_OUT | GPIOF_INIT_LOW, "speaker_en");
+	if (err) {
+		dev_err(card->dev, "could not setup speaker_en\n");
+		goto error;
+	}
 
+	snd_soc_card_set_drvdata(card, pdata);
 	err = snd_soc_register_card(card);
 	if (err) {
-		dev_err(&pdev->dev, "snd_soc_register_card failed (%d)\n", err);
-		goto err_snd;
+		dev_err(card->dev, "snd_soc_register_card failed (%d)\n", err);
+		goto error;
 	}
 
 	return 0;
-err_snd:
+error:
 	card->dev = NULL;
-	gpio_free(RX51_ECI_SW_GPIO);
-err_gpio_eci_sw:
-	gpio_free(RX51_TVOUT_SEL_GPIO);
-err_gpio_tvout_sel:
-
 	return err;
 }
 
@@ -436,16 +520,23 @@ static int rx51_soc_remove(struct platform_device *pdev)
 	snd_soc_unregister_card(card);
 	card->dev = NULL;
 
-	gpio_free(RX51_ECI_SW_GPIO);
-	gpio_free(RX51_TVOUT_SEL_GPIO);
-
 	return 0;
 }
 
+#if defined(CONFIG_OF)
+static const struct of_device_id rx51_audio_of_match[] = {
+	{ .compatible = "nokia,rx51-audio", },
+	{},
+};
+MODULE_DEVICE_TABLE(of, rx51_audio_of_match);
+#endif
+
+
 static struct platform_driver rx51_soc_driver = {
 	.driver = {
 		.name = "rx51-audio",
 		.owner = THIS_MODULE,
+		.of_match_table = of_match_ptr(rx51_audio_of_match),
 	},
 	.probe = rx51_soc_probe,
 	.remove = rx51_soc_remove,
-- 
1.8.4.rc3

