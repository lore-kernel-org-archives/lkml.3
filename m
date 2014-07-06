Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752119AbaGFRw4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jul 2014 13:52:56 -0400
Received: from mail-pd0-f175.google.com ([209.85.192.175]:57967 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751729AbaGFRwy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jul 2014 13:52:54 -0400
Date: Sun, 6 Jul 2014 23:22:44 +0530
From: Himangi Saraogi <himangi774@gmail.com>
To: Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>, linux-gpio@vger.kernel.org,
        linux-kernel@vger.kernel.org, Randy Dunlap <rdunlap@infradead.org>,
        linux-doc@vger.kernel.org, Liam Girdwood <lgirdwood@gmail.com>,
        Mark Brown <broonie@kernel.org>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>, patches@opensource.wolfsonmicro.com,
        alsa-devel@alsa-project.org, Eric Miao <eric.y.miao@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        linux-arm-kernel@lists.infradead.org,
        Philipp Zabel <philipp.zabel@gmail.com>,
        Paul Parsons <lost.distance@yahoo.com>
Cc: julia.lawall@lip6.fr
Subject: [PATCH 5/5] ASoC: pxa/hx4700: Introduce the use of
 devm_gpio_request_array
Message-ID: <4001147a17bf23a80be799234ebb5ef3ad985a5f.1404665589.git.himangi774@gmail.com>
References: <cover.1404665589.git.himangi774@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1404665589.git.himangi774@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch moves the resources allocated using gpio_request_array to the
managed interface and removes the calls to gpio_free_array in the probe
and remove functions.

Signed-off-by: Himangi Saraogi <himangi774@gmail.com>
Acked-by: Julia Lawall <julia.lawall@lip6.fr>
---
 sound/soc/pxa/hx4700.c | 12 +++---------
 1 file changed, 3 insertions(+), 9 deletions(-)

diff --git a/sound/soc/pxa/hx4700.c b/sound/soc/pxa/hx4700.c
index 05559a7..b624526 100644
--- a/sound/soc/pxa/hx4700.c
+++ b/sound/soc/pxa/hx4700.c
@@ -198,18 +198,13 @@ static int hx4700_audio_probe(struct platform_device *pdev)
 	if (!machine_is_h4700())
 		return -ENODEV;
 
-	ret = gpio_request_array(hx4700_audio_gpios,
-				ARRAY_SIZE(hx4700_audio_gpios));
+	ret = devm_gpio_request_array(&pdev->dev, hx4700_audio_gpios,
+				      ARRAY_SIZE(hx4700_audio_gpios));
 	if (ret)
 		return ret;
 
 	snd_soc_card_hx4700.dev = &pdev->dev;
-	ret = snd_soc_register_card(&snd_soc_card_hx4700);
-	if (ret)
-		gpio_free_array(hx4700_audio_gpios,
-				ARRAY_SIZE(hx4700_audio_gpios));
-
-	return ret;
+	return snd_soc_register_card(&snd_soc_card_hx4700);
 }
 
 static int hx4700_audio_remove(struct platform_device *pdev)
@@ -219,7 +214,6 @@ static int hx4700_audio_remove(struct platform_device *pdev)
 	gpio_set_value(GPIO92_HX4700_HP_DRIVER, 0);
 	gpio_set_value(GPIO107_HX4700_SPK_nSD, 0);
 
-	gpio_free_array(hx4700_audio_gpios, ARRAY_SIZE(hx4700_audio_gpios));
 	return 0;
 }
 
-- 
1.9.1

