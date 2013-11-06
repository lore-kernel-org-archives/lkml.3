Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756373Ab3KFJzF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 04:55:05 -0500
Received: from mail-ie0-f179.google.com ([209.85.223.179]:39492 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756350Ab3KFJzA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 04:55:00 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: linus.walleij@linaro.org, Lee Jones <lee.jones@linaro.org>,
        alsa-devel@alsa-project.org, Mark Brown <broonie@linaro.org>
Subject: [PATCH 2/2] ASoC: ab8500: Revert "ASoC: ab8500: Convert register I/O to regmap"
Date: Wed,  6 Nov 2013 09:54:45 +0000
Message-Id: <1383731685-18441-2-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1383731685-18441-1-git-send-email-lee.jones@linaro.org>
References: <1383731685-18441-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This reverts commit ff795d614bfa62a3c6fc0bcb75cb8842e5a87892, as this
is one of two patches which stop audio from working on Snowball.

Cc: alsa-devel@alsa-project.org
Cc: Mark Brown <broonie@linaro.org>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 sound/soc/codecs/ab8500-codec.c | 64 ++++++++++++++++++++++-------------------
 1 file changed, 34 insertions(+), 30 deletions(-)

diff --git a/sound/soc/codecs/ab8500-codec.c b/sound/soc/codecs/ab8500-codec.c
index ca500fd..7990217 100644
--- a/sound/soc/codecs/ab8500-codec.c
+++ b/sound/soc/codecs/ab8500-codec.c
@@ -126,8 +126,6 @@ struct ab8500_codec_drvdata_dbg {
 
 /* Private data for AB8500 device-driver */
 struct ab8500_codec_drvdata {
-	struct regmap *regmap;
-
 	/* Sidetone */
 	long *sid_fir_values;
 	enum sid_state sid_status;
@@ -168,34 +166,48 @@ static inline const char *amic_type_str(enum amic_type type)
  */
 
 /* Read a register from the audio-bank of AB8500 */
-static int ab8500_codec_read_reg(void *context, unsigned int reg,
-				 unsigned int *value)
+static unsigned int ab8500_codec_read_reg(struct snd_soc_codec *codec,
+					unsigned int reg)
 {
-	struct device *dev = context;
 	int status;
+	unsigned int value = 0;
 
 	u8 value8;
-	status = abx500_get_register_interruptible(dev, AB8500_AUDIO,
-						   reg, &value8);
-	*value = (unsigned int)value8;
+	status = abx500_get_register_interruptible(codec->dev, AB8500_AUDIO,
+						reg, &value8);
+	if (status < 0) {
+		dev_err(codec->dev,
+			"%s: ERROR: Register (0x%02x:0x%02x) read failed (%d).\n",
+			__func__, (u8)AB8500_AUDIO, (u8)reg, status);
+	} else {
+		dev_dbg(codec->dev,
+			"%s: Read 0x%02x from register 0x%02x:0x%02x\n",
+			__func__, value8, (u8)AB8500_AUDIO, (u8)reg);
+		value = (unsigned int)value8;
+	}
 
-	return status;
+	return value;
 }
 
 /* Write to a register in the audio-bank of AB8500 */
-static int ab8500_codec_write_reg(void *context, unsigned int reg,
-				  unsigned int value)
+static int ab8500_codec_write_reg(struct snd_soc_codec *codec,
+				unsigned int reg, unsigned int value)
 {
-	struct device *dev = context;
+	int status;
 
-	return abx500_set_register_interruptible(dev, AB8500_AUDIO,
-						 reg, value);
-}
+	status = abx500_set_register_interruptible(codec->dev, AB8500_AUDIO,
+						reg, value);
+	if (status < 0)
+		dev_err(codec->dev,
+			"%s: ERROR: Register (%02x:%02x) write failed (%d).\n",
+			__func__, (u8)AB8500_AUDIO, (u8)reg, status);
+	else
+		dev_dbg(codec->dev,
+			"%s: Wrote 0x%02x into register %02x:%02x\n",
+			__func__, (u8)value, (u8)AB8500_AUDIO, (u8)reg);
 
-static const struct regmap_config ab8500_codec_regmap = {
-	.reg_read = ab8500_codec_read_reg,
-	.reg_write = ab8500_codec_write_reg,
-};
+	return status;
+}
 
 /*
  * Controls - DAPM
@@ -2476,8 +2488,6 @@ static int ab8500_codec_probe(struct snd_soc_codec *codec)
 	/* Setup AB8500 according to board-settings */
 	pdata = dev_get_platdata(dev->parent);
 
-	codec->control_data = drvdata->regmap;
-
 	if (np) {
 		if (!pdata)
 			pdata = devm_kzalloc(dev,
@@ -2555,6 +2565,9 @@ static int ab8500_codec_probe(struct snd_soc_codec *codec)
 
 static struct snd_soc_codec_driver ab8500_codec_driver = {
 	.probe =		ab8500_codec_probe,
+	.read =			ab8500_codec_read_reg,
+	.write =		ab8500_codec_write_reg,
+	.reg_word_size =	sizeof(u8),
 	.controls =		ab8500_ctrls,
 	.num_controls =		ARRAY_SIZE(ab8500_ctrls),
 	.dapm_widgets =		ab8500_dapm_widgets,
@@ -2577,15 +2590,6 @@ static int ab8500_codec_driver_probe(struct platform_device *pdev)
 	drvdata->anc_status = ANC_UNCONFIGURED;
 	dev_set_drvdata(&pdev->dev, drvdata);
 
-	drvdata->regmap = devm_regmap_init(&pdev->dev, NULL, &pdev->dev,
-					   &ab8500_codec_regmap);
-	if (IS_ERR(drvdata->regmap)) {
-		status = PTR_ERR(drvdata->regmap);
-		dev_err(&pdev->dev, "%s: Failed to allocate regmap: %d\n",
-			__func__, status);
-		return status;
-	}
-
 	dev_dbg(&pdev->dev, "%s: Register codec.\n", __func__);
 	status = snd_soc_register_codec(&pdev->dev, &ab8500_codec_driver,
 				ab8500_codec_dai,
-- 
1.8.1.2

