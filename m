Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753288Ab3ATDEq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jan 2013 22:04:46 -0500
Received: from mail-wg0-f49.google.com ([74.125.82.49]:65397 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752462Ab3ATDEo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jan 2013 22:04:44 -0500
From: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali.rohar@gmail.com>
To: Peter Ujfalusi <peter.ujfalusi@ti.com>,
        Jarkko Nikula <jarkko.nikula@bitmer.com>,
        Tony Lindgren <tony@atomide.com>
Cc: linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali.rohar@gmail.com>
Subject: [PATCH 1/2] ASoC: omap: rx51: Use snd_soc_register_card and add module alias for autoloading driver
Date: Sun, 20 Jan 2013 04:04:29 +0100
Message-Id: <1358651070-30029-2-git-send-email-pali.rohar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1358651070-30029-1-git-send-email-pali.rohar@gmail.com>
References: <1358651070-30029-1-git-send-email-pali.rohar@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Pali Rohár <pali.rohar@gmail.com>
---
 sound/soc/omap/rx51.c |   50 +++++++++++++++++++++++++++++--------------------
 1 file changed, 30 insertions(+), 20 deletions(-)

diff --git a/sound/soc/omap/rx51.c b/sound/soc/omap/rx51.c
index d921ddb..82e3aae 100644
--- a/sound/soc/omap/rx51.c
+++ b/sound/soc/omap/rx51.c
@@ -391,10 +391,9 @@ static struct snd_soc_card rx51_sound_card = {
 	.num_configs = ARRAY_SIZE(rx51_codec_conf),
 };
 
-static struct platform_device *rx51_snd_device;
-
-static int __init rx51_soc_init(void)
+static int rx51_soc_probe(struct platform_device *pdev)
 {
+	struct snd_soc_card *card = &rx51_sound_card;
 	int err;
 
 	if (!machine_is_nokia_rx51())
@@ -409,22 +408,18 @@ static int __init rx51_soc_init(void)
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
+	err = snd_soc_register_card(card);
+	if (err) {
+		dev_err(&pdev->dev, "snd_soc_register_card failed (%d)\n", err);
+		goto err_snd;
+	}
 
 	return 0;
-err2:
-	platform_device_put(rx51_snd_device);
-err1:
+
+err_snd:
+	card->dev = NULL;
 	gpio_free(RX51_ECI_SW_GPIO);
 err_gpio_eci_sw:
 	gpio_free(RX51_TVOUT_SEL_GPIO);
@@ -433,19 +428,34 @@ err_gpio_tvout_sel:
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
+	snd_soc_unregister_card(card);
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
1.7.10.4

