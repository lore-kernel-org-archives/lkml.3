Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756346AbaD1OON (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 10:14:13 -0400
Received: from ring0.de ([5.45.105.125]:51838 "EHLO ring0.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756094AbaD1OHp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 10:07:45 -0400
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
        alsa-devel@alsa-project.org, Sebastian Reichel <sre@kernel.org>,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali.rohar@gmail.com>
Subject: [PATCHv2 3/9] ASoC: omap: rx51: Use devm_snd_soc_register_card
Date: Mon, 28 Apr 2014 16:07:21 +0200
Message-Id: <1398694047-28596-4-git-send-email-sre@kernel.org>
X-Mailer: git-send-email 1.9.2
In-Reply-To: <1398694047-28596-1-git-send-email-sre@kernel.org>
References: <1398694047-28596-1-git-send-email-sre@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch converts the rx51 ASoC module to use
devm_snd_soc_register_card.

Signed-off-by: Pali Rohár <pali.rohar@gmail.com>
Signed-off-by: Sebastian Reichel <sre@kernel.org>
---
 sound/soc/omap/rx51.c | 42 ++++++++++++++++++++++--------------------
 1 file changed, 22 insertions(+), 20 deletions(-)

diff --git a/sound/soc/omap/rx51.c b/sound/soc/omap/rx51.c
index 55713d0..bbe3a66 100644
--- a/sound/soc/omap/rx51.c
+++ b/sound/soc/omap/rx51.c
@@ -363,10 +363,9 @@ static struct snd_soc_card rx51_sound_card = {
 	.num_dapm_routes = ARRAY_SIZE(audio_map),
 };
 
-static struct platform_device *rx51_snd_device;
-
-static int __init rx51_soc_init(void)
+static int rx51_soc_probe(struct platform_device *pdev)
 {
+	struct snd_soc_card *card = &rx51_sound_card;
 	int err;
 
 	if (!machine_is_nokia_rx51() && !of_machine_is_compatible("nokia,omap3-n900"))
@@ -381,22 +380,16 @@ static int __init rx51_soc_init(void)
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
 	gpio_free(RX51_ECI_SW_GPIO);
 err_gpio_eci_sw:
 	gpio_free(RX51_TVOUT_SEL_GPIO);
@@ -405,18 +398,27 @@ err_gpio_tvout_sel:
 	return err;
 }
 
-static void __exit rx51_soc_exit(void)
+static int rx51_soc_remove(struct platform_device *pdev)
 {
 	snd_soc_jack_free_gpios(&rx51_av_jack, ARRAY_SIZE(rx51_av_jack_gpios),
 				rx51_av_jack_gpios);
 
-	platform_device_unregister(rx51_snd_device);
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
-- 
1.9.2

