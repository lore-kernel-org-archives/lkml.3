Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751713AbaCFHpL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 02:45:11 -0500
Received: from mail-la0-f42.google.com ([209.85.215.42]:63894 "EHLO
	mail-la0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751059AbaCFHpJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 02:45:09 -0500
From: Max Filippov <jcmvbkbc@gmail.com>
To: alsa-devel@alsa-project.org
Cc: linux-kernel@vger.kernel.org, Liam Girdwood <lgirdwood@gmail.com>,
        Mark Brown <broonie@kernel.org>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>, Max Filippov <jcmvbkbc@gmail.com>
Subject: [PATCH] ASoC: tlv320aic23: add support for SPI control mode
Date: Thu,  6 Mar 2014 11:44:22 +0400
Message-Id: <1394091862-13603-1-git-send-email-jcmvbkbc@gmail.com>
X-Mailer: git-send-email 1.8.1.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

tlv320aic23 chip control interface may work in either I2C or SPI mode
depending on the MODE pin state. Functionality and register layout are
independent of the control mode.

Provide i2c and spi driver entry points when CONFIG_I2C and
CONFIG_SPI_MASTER are enabled respectively.

Signed-off-by: Max Filippov <jcmvbkbc@gmail.com>
---
 sound/soc/codecs/Kconfig       |  2 +-
 sound/soc/codecs/tlv320aic23.c | 58 +++++++++++++++++++++++++++++++++++++++---
 2 files changed, 56 insertions(+), 4 deletions(-)

diff --git a/sound/soc/codecs/Kconfig b/sound/soc/codecs/Kconfig
index 983d087a..6d82de5 100644
--- a/sound/soc/codecs/Kconfig
+++ b/sound/soc/codecs/Kconfig
@@ -71,7 +71,7 @@ config SND_SOC_ALL_CODECS
 	select SND_SOC_STA529 if I2C
 	select SND_SOC_STAC9766 if SND_SOC_AC97_BUS
 	select SND_SOC_TAS5086 if I2C
-	select SND_SOC_TLV320AIC23 if I2C
+	select SND_SOC_TLV320AIC23 if SND_SOC_I2C_AND_SPI
 	select SND_SOC_TLV320AIC26 if SPI_MASTER
 	select SND_SOC_TLV320AIC32X4 if I2C
 	select SND_SOC_TLV320AIC3X if I2C
diff --git a/sound/soc/codecs/tlv320aic23.c b/sound/soc/codecs/tlv320aic23.c
index 5d430cc..2418260 100644
--- a/sound/soc/codecs/tlv320aic23.c
+++ b/sound/soc/codecs/tlv320aic23.c
@@ -26,6 +26,7 @@
 #include <linux/i2c.h>
 #include <linux/regmap.h>
 #include <linux/slab.h>
+#include <linux/spi/spi.h>
 #include <sound/core.h>
 #include <sound/pcm.h>
 #include <sound/pcm_params.h>
@@ -617,12 +618,13 @@ static struct snd_soc_codec_driver soc_codec_dev_tlv320aic23 = {
 	.num_dapm_routes = ARRAY_SIZE(tlv320aic23_intercon),
 };
 
+#ifdef CONFIG_I2C
 /*
  * If the i2c layer weren't so broken, we could pass this kind of data
  * around
  */
-static int tlv320aic23_codec_probe(struct i2c_client *i2c,
-				   const struct i2c_device_id *i2c_id)
+static int tlv320aic23_i2c_probe(struct i2c_client *i2c,
+				 const struct i2c_device_id *i2c_id)
 {
 	struct aic23 *aic23;
 	int ret;
@@ -661,12 +663,62 @@ static struct i2c_driver tlv320aic23_i2c_driver = {
 	.driver = {
 		   .name = "tlv320aic23-codec",
 		   },
-	.probe = tlv320aic23_codec_probe,
+	.probe = tlv320aic23_i2c_probe,
 	.remove = __exit_p(tlv320aic23_i2c_remove),
 	.id_table = tlv320aic23_id,
 };
 
 module_i2c_driver(tlv320aic23_i2c_driver);
+#endif /* CONFIG_I2C */
+
+#ifdef CONFIG_SPI_MASTER
+static int aic23_spi_probe(struct spi_device *spi)
+{
+	struct aic23 *aic23;
+	int ret;
+
+	dev_dbg(&spi->dev, "probing tlv320aic23 spi device\n");
+
+	spi->bits_per_word = 16;
+	spi->mode = SPI_MODE_0;
+	ret = spi_setup(spi);
+	if (ret < 0)
+		return ret;
+
+	/* Allocate driver data */
+	aic23 = devm_kzalloc(&spi->dev, sizeof(struct aic23), GFP_KERNEL);
+	if (!aic23)
+		return -ENOMEM;
+
+	aic23->regmap = devm_regmap_init_spi(spi, &tlv320aic23_regmap);
+	if (IS_ERR(aic23->regmap))
+		return PTR_ERR(aic23->regmap);
+
+	/* Initialize the driver data */
+	dev_set_drvdata(&spi->dev, aic23);
+
+	ret = snd_soc_register_codec(&spi->dev,
+			&soc_codec_dev_tlv320aic23, &tlv320aic23_dai, 1);
+	return ret;
+}
+
+static int aic23_spi_remove(struct spi_device *spi)
+{
+	snd_soc_unregister_codec(&spi->dev);
+	return 0;
+}
+
+static struct spi_driver aic23_spi = {
+	.driver = {
+		.name = "tlv320aic23",
+		.owner = THIS_MODULE,
+	},
+	.probe = aic23_spi_probe,
+	.remove = aic23_spi_remove,
+};
+
+module_spi_driver(aic23_spi);
+#endif /* CONFIG_SPI_MASTER */
 
 MODULE_DESCRIPTION("ASoC TLV320AIC23 codec driver");
 MODULE_AUTHOR("Arun KS <arunks@mistralsolutions.com>");
-- 
1.8.1.4

