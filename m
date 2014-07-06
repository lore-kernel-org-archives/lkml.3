Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752070AbaGFRvw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jul 2014 13:51:52 -0400
Received: from mail-pd0-f182.google.com ([209.85.192.182]:48056 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751696AbaGFRvv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jul 2014 13:51:51 -0400
Date: Sun, 6 Jul 2014 23:21:41 +0530
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
Cc: Julia Lawall <julia.lawall@lip6.fr>
Subject: [PATCH 4/5] ASoC: pxa: e800_wm9712: Introduce the use of
 devm_gpio_request_array
Message-ID: <e0d09d7f466535ce9cacc2fcd9986927dfd830c7.1404665589.git.himangi774@gmail.com>
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
 sound/soc/pxa/e800_wm9712.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/sound/soc/pxa/e800_wm9712.c b/sound/soc/pxa/e800_wm9712.c
index 24c2078..dbc3670 100644
--- a/sound/soc/pxa/e800_wm9712.c
+++ b/sound/soc/pxa/e800_wm9712.c
@@ -112,19 +112,17 @@ static int e800_probe(struct platform_device *pdev)
 	struct snd_soc_card *card = &e800;
 	int ret;
 
-	ret = gpio_request_array(e800_audio_gpios,
-				 ARRAY_SIZE(e800_audio_gpios));
+	ret = devm_gpio_request_array(&pdev->dev, e800_audio_gpios,
+				      ARRAY_SIZE(e800_audio_gpios));
 	if (ret)
 		return ret;
 
 	card->dev = &pdev->dev;
 
 	ret = snd_soc_register_card(card);
-	if (ret) {
+	if (ret)
 		dev_err(&pdev->dev, "snd_soc_register_card() failed: %d\n",
 			ret);
-		gpio_free_array(e800_audio_gpios, ARRAY_SIZE(e800_audio_gpios));
-	}
 	return ret;
 }
 
@@ -132,7 +130,6 @@ static int e800_remove(struct platform_device *pdev)
 {
 	struct snd_soc_card *card = platform_get_drvdata(pdev);
 
-	gpio_free_array(e800_audio_gpios, ARRAY_SIZE(e800_audio_gpios));
 	snd_soc_unregister_card(card);
 	return 0;
 }
-- 
1.9.1

