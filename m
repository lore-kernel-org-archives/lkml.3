Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752474AbaGFHIK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jul 2014 03:08:10 -0400
Received: from mail-pa0-f45.google.com ([209.85.220.45]:52721 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751599AbaGFHII (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jul 2014 03:08:08 -0400
Date: Sun, 6 Jul 2014 12:38:00 +0530
From: Himangi Saraogi <himangi774@gmail.com>
To: Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Cc: julia.lawall@lip6.fr
Subject: [PATCH] ASoC: sgtl5000: Use devm_ functions
Message-ID: <20140706070800.GA2927@himangi-Dell>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch introduces the use of managed interfaces like devm_kzalloc,
devm_kstrdup and devm_regulator_register and does avay with the calls to
the functions to free the allocated memory in ldo_regulator_register and
ldo_regulator_remove. The ldo_regulator_remove function is completely
removed as it is no longer required. ldo_regulator_register is called
from a probe function and on failure its value is returned as the
result.

Signed-off-by: Himangi Saraogi <himangi774@gmail.com>
---
To send to: Liam Girdwood <lgirdwood@gmail.com>,Mark Brown <broonie@kernel.org>,Jaroslav Kysela <perex@perex.cz>,Takashi Iwai <tiwai@suse.de>,alsa-devel@alsa-project.org,linux-kernel@vger.kernel.org
 sound/soc/codecs/sgtl5000.c | 46 +++++++--------------------------------------
 1 file changed, 7 insertions(+), 39 deletions(-)

diff --git a/sound/soc/codecs/sgtl5000.c b/sound/soc/codecs/sgtl5000.c
index 249fadb..0efd6d6 100644
--- a/sound/soc/codecs/sgtl5000.c
+++ b/sound/soc/codecs/sgtl5000.c
@@ -841,14 +841,15 @@ static int ldo_regulator_register(struct snd_soc_codec *codec,
 	struct sgtl5000_priv *sgtl5000 = snd_soc_codec_get_drvdata(codec);
 	struct regulator_config config = { };
 
-	ldo = kzalloc(sizeof(struct ldo_regulator), GFP_KERNEL);
+	ldo = devm_kzalloc(codec->dev, sizeof(struct ldo_regulator),
+			   GFP_KERNEL);
 
 	if (!ldo)
 		return -ENOMEM;
 
-	ldo->desc.name = kstrdup(dev_name(codec->dev), GFP_KERNEL);
+	ldo->desc.name = devm_kstrdup(codec->dev, dev_name(codec->dev),
+				      GFP_KERNEL);
 	if (!ldo->desc.name) {
-		kfree(ldo);
 		dev_err(codec->dev, "failed to allocate decs name memory\n");
 		return -ENOMEM;
 	}
@@ -865,35 +866,17 @@ static int ldo_regulator_register(struct snd_soc_codec *codec,
 	config.driver_data = ldo;
 	config.init_data = init_data;
 
-	ldo->dev = regulator_register(&ldo->desc, &config);
+	ldo->dev = devm_regulator_register(codec->dev, &ldo->desc, &config);
 	if (IS_ERR(ldo->dev)) {
 		int ret = PTR_ERR(ldo->dev);
 
 		dev_err(codec->dev, "failed to register regulator\n");
-		kfree(ldo->desc.name);
-		kfree(ldo);
-
 		return ret;
 	}
 	sgtl5000->ldo = ldo;
 
 	return 0;
 }
-
-static int ldo_regulator_remove(struct snd_soc_codec *codec)
-{
-	struct sgtl5000_priv *sgtl5000 = snd_soc_codec_get_drvdata(codec);
-	struct ldo_regulator *ldo = sgtl5000->ldo;
-
-	if (!ldo)
-		return 0;
-
-	regulator_unregister(ldo->dev);
-	kfree(ldo->desc.name);
-	kfree(ldo);
-
-	return 0;
-}
 #else
 static int ldo_regulator_register(struct snd_soc_codec *codec,
 				struct regulator_init_data *init_data,
@@ -902,11 +885,6 @@ static int ldo_regulator_register(struct snd_soc_codec *codec,
 	dev_err(codec->dev, "this setup needs regulator support in the kernel\n");
 	return -EINVAL;
 }
-
-static int ldo_regulator_remove(struct snd_soc_codec *codec)
-{
-	return 0;
-}
 #endif
 
 /*
@@ -1278,23 +1256,17 @@ static int sgtl5000_enable_regulators(struct snd_soc_codec *codec)
 	ret = devm_regulator_bulk_get(codec->dev, ARRAY_SIZE(sgtl5000->supplies),
 				 sgtl5000->supplies);
 	if (ret)
-		goto err_ldo_remove;
+		return ret;
 
 	ret = regulator_bulk_enable(ARRAY_SIZE(sgtl5000->supplies),
 					sgtl5000->supplies);
 	if (ret)
-		goto err_ldo_remove;
+		return ret;
 
 	/* wait for all power rails bring up */
 	udelay(10);
 
 	return 0;
-
-err_ldo_remove:
-	if (!external_vddd)
-		ldo_regulator_remove(codec);
-	return ret;
-
 }
 
 static int sgtl5000_probe(struct snd_soc_codec *codec)
@@ -1359,8 +1331,6 @@ static int sgtl5000_probe(struct snd_soc_codec *codec)
 err:
 	regulator_bulk_disable(ARRAY_SIZE(sgtl5000->supplies),
 						sgtl5000->supplies);
-	ldo_regulator_remove(codec);
-
 	return ret;
 }
 
@@ -1372,8 +1342,6 @@ static int sgtl5000_remove(struct snd_soc_codec *codec)
 
 	regulator_bulk_disable(ARRAY_SIZE(sgtl5000->supplies),
 						sgtl5000->supplies);
-	ldo_regulator_remove(codec);
-
 	return 0;
 }
 
-- 
1.9.1

