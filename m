Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754160AbaDEVgp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Apr 2014 17:36:45 -0400
Received: from ring0.de ([5.45.105.125]:47078 "EHLO ring0.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754107AbaDEVgm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Apr 2014 17:36:42 -0400
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
        alsa-devel@alsa-project.org,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali.rohar@gmail.com>,
        Sebastian Reichel <sre@kernel.org>
Subject: [PATCH 1/5] ASoC: omap: rx51: Use devm_snd_soc_register_card
Date: Sat,  5 Apr 2014 23:35:49 +0200
Message-Id: <1396733753-9820-2-git-send-email-sre@kernel.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1396733753-9820-1-git-send-email-sre@kernel.org>
References: <1396733753-9820-1-git-send-email-sre@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pali Rohár <pali.rohar@gmail.com>

This patch converts the rx51 ASoC module to use
devm_snd_soc_register_card. It also adds module alias
to support driver autoloading.

Signed-off-by: Pali Rohár <pali.rohar@gmail.com>
Signed-off-by: Sebastian Reichel <sre@kernel.org>
---
 sound/soc/omap/rx51.c | 48 ++++++++++++++++++++++++++++--------------------
 1 file changed, 28 insertions(+), 20 deletions(-)

diff --git a/sound/soc/omap/rx51.c b/sound/soc/omap/rx51.c
index 7fb3d4b..58f5e12 100644
--- a/sound/soc/omap/rx51.c
+++ b/sound/soc/omap/rx51.c
@@ -394,10 +394,9 @@ static struct snd_soc_card rx51_sound_card = {
 	.num_configs = ARRAY_SIZE(rx51_codec_conf),
 };
 
-static struct platform_device *rx51_snd_device;
-
-static int __init rx51_soc_init(void)
+static int rx51_soc_probe(struct platform_device *pdev)
 {
+	struct snd_soc_card *card = &rx51_sound_card;
 	int err;
 
 	if (!machine_is_nokia_rx51() && !of_machine_is_compatible("nokia,omap3-n900"))
@@ -412,22 +411,17 @@ static int __init rx51_soc_init(void)
 	if (err)
 		goto err_gpio_eci_sw;
 
-	rx51_snd_device = platform_device_alloc("soc-audio", -1);
-	if (!rx51_snd_device) {
-		err = -ENOMEM;
-		goto err1;
-	}
-
-	platform_set_drvdata(rx51_snd_device, &rx51_sound_card);
+	card->dev = &pdev->dev;
 
-	err = platform_device_add(rx51_snd_device);
-	if (err)
-		goto err2;
+	err = devm_snd_soc_register_card(card->dev, card);
+	if (err) {
+		dev_err(&pdev->dev, "snd_soc_register_card failed (%d)\n", err);
+		goto err_snd;
+	}
 
 	return 0;
-err2:
-	platform_device_put(rx51_snd_device);
-err1:
+err_snd:
+	card->dev = NULL;
 	gpio_free(RX51_ECI_SW_GPIO);
 err_gpio_eci_sw:
 	gpio_free(RX51_TVOUT_SEL_GPIO);
@@ -436,19 +430,33 @@ err_gpio_tvout_sel:
 	return err;
 }
 
-static void __exit rx51_soc_exit(void)
+static int rx51_soc_remove(struct platform_device *pdev)
 {
+	struct snd_soc_card *card = platform_get_drvdata(pdev);
+
 	snd_soc_jack_free_gpios(&rx51_av_jack, ARRAY_SIZE(rx51_av_jack_gpios),
 				rx51_av_jack_gpios);
 
-	platform_device_unregister(rx51_snd_device);
+	card->dev = NULL;
+
 	gpio_free(RX51_ECI_SW_GPIO);
 	gpio_free(RX51_TVOUT_SEL_GPIO);
+
+	return 0;
 }
 
-module_init(rx51_soc_init);
-module_exit(rx51_soc_exit);
+static struct platform_driver rx51_soc_driver = {
+	.driver = {
+		.name = "rx51-audio",
+		.owner = THIS_MODULE,
+	},
+	.probe = rx51_soc_probe,
+	.remove = rx51_soc_remove,
+};
+
+module_platform_driver(rx51_soc_driver);
 
 MODULE_AUTHOR("Nokia Corporation");
 MODULE_DESCRIPTION("ALSA SoC Nokia RX-51");
 MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:rx51-audio");
-- 
1.9.1

