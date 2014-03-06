Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752398AbaCFKFt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 05:05:49 -0500
Received: from mail-la0-f45.google.com ([209.85.215.45]:64957 "EHLO
	mail-la0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750969AbaCFKE5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 05:04:57 -0500
From: Max Filippov <jcmvbkbc@gmail.com>
To: alsa-devel@alsa-project.org
Cc: linux-kernel@vger.kernel.org, Liam Girdwood <lgirdwood@gmail.com>,
        Mark Brown <broonie@kernel.org>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>, Lars-Peter Clausen <lars@metafoo.de>,
        Max Filippov <jcmvbkbc@gmail.com>
Subject: [PATCH v2 1/2] ASoC: tlv320aic23: add support for SPI control mode
Date: Thu,  6 Mar 2014 14:04:41 +0400
Message-Id: <1394100282-27404-2-git-send-email-jcmvbkbc@gmail.com>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1394100282-27404-1-git-send-email-jcmvbkbc@gmail.com>
References: <1394100282-27404-1-git-send-email-jcmvbkbc@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

tlv320aic23 chip control interface may work in either I2C or SPI mode
depending on the MODE pin state. Functionality and register layout are
independent of the control mode.

Implement bus-specific parts as separate modules.

Signed-off-by: Max Filippov <jcmvbkbc@gmail.com>
---
Changes v1->v2:
- split i2c interface into separate file;
- implement spi interface in a separate file.

 sound/soc/codecs/Kconfig           | 11 ++++++-
 sound/soc/codecs/Makefile          |  4 +++
 sound/soc/codecs/tlv320aic23-i2c.c | 59 ++++++++++++++++++++++++++++++++++++++
 sound/soc/codecs/tlv320aic23-spi.c | 57 ++++++++++++++++++++++++++++++++++++
 sound/soc/codecs/tlv320aic23.c     | 55 +++++++----------------------------
 sound/soc/codecs/tlv320aic23.h     |  6 ++++
 6 files changed, 147 insertions(+), 45 deletions(-)
 create mode 100644 sound/soc/codecs/tlv320aic23-i2c.c
 create mode 100644 sound/soc/codecs/tlv320aic23-spi.c

diff --git a/sound/soc/codecs/Kconfig b/sound/soc/codecs/Kconfig
index 983d087a..5e4fc04 100644
--- a/sound/soc/codecs/Kconfig
+++ b/sound/soc/codecs/Kconfig
@@ -71,7 +71,8 @@ config SND_SOC_ALL_CODECS
 	select SND_SOC_STA529 if I2C
 	select SND_SOC_STAC9766 if SND_SOC_AC97_BUS
 	select SND_SOC_TAS5086 if I2C
-	select SND_SOC_TLV320AIC23 if I2C
+	select SND_SOC_TLV320AIC23_I2C if I2C
+	select SND_SOC_TLV320AIC23_SPI if SPI_MASTER
 	select SND_SOC_TLV320AIC26 if SPI_MASTER
 	select SND_SOC_TLV320AIC32X4 if I2C
 	select SND_SOC_TLV320AIC3X if I2C
@@ -357,6 +358,14 @@ config SND_SOC_TAS5086
 config SND_SOC_TLV320AIC23
 	tristate
 
+config SND_SOC_TLV320AIC23_I2C
+	tristate
+	select SND_SOC_TLV320AIC23
+
+config SND_SOC_TLV320AIC23_SPI
+	tristate
+	select SND_SOC_TLV320AIC23
+
 config SND_SOC_TLV320AIC26
 	tristate
 	depends on SPI
diff --git a/sound/soc/codecs/Makefile b/sound/soc/codecs/Makefile
index bc12676..ed1fd89 100644
--- a/sound/soc/codecs/Makefile
+++ b/sound/soc/codecs/Makefile
@@ -63,6 +63,8 @@ snd-soc-sta529-objs := sta529.o
 snd-soc-stac9766-objs := stac9766.o
 snd-soc-tas5086-objs := tas5086.o
 snd-soc-tlv320aic23-objs := tlv320aic23.o
+snd-soc-tlv320aic23-i2c-objs := tlv320aic23-i2c.o
+snd-soc-tlv320aic23-spi-objs := tlv320aic23-spi.o
 snd-soc-tlv320aic26-objs := tlv320aic26.o
 snd-soc-tlv320aic3x-objs := tlv320aic3x.o
 snd-soc-tlv320aic32x4-objs := tlv320aic32x4.o
@@ -193,6 +195,8 @@ obj-$(CONFIG_SND_SOC_STA529)   += snd-soc-sta529.o
 obj-$(CONFIG_SND_SOC_STAC9766)	+= snd-soc-stac9766.o
 obj-$(CONFIG_SND_SOC_TAS5086)	+= snd-soc-tas5086.o
 obj-$(CONFIG_SND_SOC_TLV320AIC23)	+= snd-soc-tlv320aic23.o
+obj-$(CONFIG_SND_SOC_TLV320AIC23_I2C)	+= snd-soc-tlv320aic23-i2c.o
+obj-$(CONFIG_SND_SOC_TLV320AIC23_SPI)	+= snd-soc-tlv320aic23-spi.o
 obj-$(CONFIG_SND_SOC_TLV320AIC26)	+= snd-soc-tlv320aic26.o
 obj-$(CONFIG_SND_SOC_TLV320AIC3X)	+= snd-soc-tlv320aic3x.o
 obj-$(CONFIG_SND_SOC_TLV320AIC32X4)     += snd-soc-tlv320aic32x4.o
diff --git a/sound/soc/codecs/tlv320aic23-i2c.c b/sound/soc/codecs/tlv320aic23-i2c.c
new file mode 100644
index 0000000..20fc460
--- /dev/null
+++ b/sound/soc/codecs/tlv320aic23-i2c.c
@@ -0,0 +1,59 @@
+/*
+ * ALSA SoC TLV320AIC23 codec driver I2C interface
+ *
+ * Author:      Arun KS, <arunks@mistralsolutions.com>
+ * Copyright:   (C) 2008 Mistral Solutions Pvt Ltd.,
+ *
+ * Based on sound/soc/codecs/wm8731.c by Richard Purdie
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/i2c.h>
+#include <linux/module.h>
+#include <linux/regmap.h>
+#include <sound/soc.h>
+
+#include "tlv320aic23.h"
+
+static int tlv320aic23_i2c_probe(struct i2c_client *i2c,
+				 const struct i2c_device_id *i2c_id)
+{
+	struct regmap *regmap;
+
+	if (!i2c_check_functionality(i2c->adapter, I2C_FUNC_SMBUS_BYTE_DATA))
+		return -EINVAL;
+
+	regmap = devm_regmap_init_i2c(i2c, &tlv320aic23_regmap);
+	return tlv320aic23_probe(&i2c->dev, regmap);
+}
+
+static int __exit tlv320aic23_i2c_remove(struct i2c_client *i2c)
+{
+	snd_soc_unregister_codec(&i2c->dev);
+	return 0;
+}
+
+static const struct i2c_device_id tlv320aic23_id[] = {
+	{"tlv320aic23", 0},
+	{}
+};
+
+MODULE_DEVICE_TABLE(i2c, tlv320aic23_id);
+
+static struct i2c_driver tlv320aic23_i2c_driver = {
+	.driver = {
+		   .name = "tlv320aic23-codec",
+		   },
+	.probe = tlv320aic23_i2c_probe,
+	.remove = __exit_p(tlv320aic23_i2c_remove),
+	.id_table = tlv320aic23_id,
+};
+
+module_i2c_driver(tlv320aic23_i2c_driver);
+
+MODULE_DESCRIPTION("ASoC TLV320AIC23 codec driver I2C");
+MODULE_AUTHOR("Arun KS <arunks@mistralsolutions.com>");
+MODULE_LICENSE("GPL");
diff --git a/sound/soc/codecs/tlv320aic23-spi.c b/sound/soc/codecs/tlv320aic23-spi.c
new file mode 100644
index 0000000..585aea4
--- /dev/null
+++ b/sound/soc/codecs/tlv320aic23-spi.c
@@ -0,0 +1,57 @@
+/*
+ * ALSA SoC TLV320AIC23 codec driver SPI interface
+ *
+ * Author:      Arun KS, <arunks@mistralsolutions.com>
+ * Copyright:   (C) 2008 Mistral Solutions Pvt Ltd.,
+ *
+ * Based on sound/soc/codecs/wm8731.c by Richard Purdie
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/module.h>
+#include <linux/regmap.h>
+#include <linux/spi/spi.h>
+#include <sound/soc.h>
+
+#include "tlv320aic23.h"
+
+static int aic23_spi_probe(struct spi_device *spi)
+{
+	int ret;
+	struct regmap *regmap;
+
+	dev_dbg(&spi->dev, "probing tlv320aic23 spi device\n");
+
+	spi->bits_per_word = 16;
+	spi->mode = SPI_MODE_0;
+	ret = spi_setup(spi);
+	if (ret < 0)
+		return ret;
+
+	regmap = devm_regmap_init_spi(spi, &tlv320aic23_regmap);
+	return tlv320aic23_probe(&spi->dev, regmap);
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
+
+MODULE_DESCRIPTION("ASoC TLV320AIC23 codec driver SPI");
+MODULE_AUTHOR("Arun KS <arunks@mistralsolutions.com>");
+MODULE_LICENSE("GPL");
diff --git a/sound/soc/codecs/tlv320aic23.c b/sound/soc/codecs/tlv320aic23.c
index 5d430cc..455250f 100644
--- a/sound/soc/codecs/tlv320aic23.c
+++ b/sound/soc/codecs/tlv320aic23.c
@@ -23,7 +23,6 @@
 #include <linux/init.h>
 #include <linux/delay.h>
 #include <linux/pm.h>
-#include <linux/i2c.h>
 #include <linux/regmap.h>
 #include <linux/slab.h>
 #include <sound/core.h>
@@ -51,7 +50,7 @@ static const struct reg_default tlv320aic23_reg[] = {
 	{  9, 0x0000 },
 };
 
-static const struct regmap_config tlv320aic23_regmap = {
+const struct regmap_config tlv320aic23_regmap = {
 	.reg_bits = 7,
 	.val_bits = 9,
 
@@ -557,7 +556,7 @@ static int tlv320aic23_resume(struct snd_soc_codec *codec)
 	return 0;
 }
 
-static int tlv320aic23_probe(struct snd_soc_codec *codec)
+static int tlv320aic23_codec_probe(struct snd_soc_codec *codec)
 {
 	int ret;
 
@@ -604,7 +603,7 @@ static int tlv320aic23_remove(struct snd_soc_codec *codec)
 }
 
 static struct snd_soc_codec_driver soc_codec_dev_tlv320aic23 = {
-	.probe = tlv320aic23_probe,
+	.probe = tlv320aic23_codec_probe,
 	.remove = tlv320aic23_remove,
 	.suspend = tlv320aic23_suspend,
 	.resume = tlv320aic23_resume,
@@ -617,57 +616,25 @@ static struct snd_soc_codec_driver soc_codec_dev_tlv320aic23 = {
 	.num_dapm_routes = ARRAY_SIZE(tlv320aic23_intercon),
 };
 
-/*
- * If the i2c layer weren't so broken, we could pass this kind of data
- * around
- */
-static int tlv320aic23_codec_probe(struct i2c_client *i2c,
-				   const struct i2c_device_id *i2c_id)
+int tlv320aic23_probe(struct device *dev, struct regmap *regmap)
 {
 	struct aic23 *aic23;
-	int ret;
 
-	if (!i2c_check_functionality(i2c->adapter, I2C_FUNC_SMBUS_BYTE_DATA))
-		return -EINVAL;
+	if (IS_ERR(regmap))
+		return PTR_ERR(regmap);
 
-	aic23 = devm_kzalloc(&i2c->dev, sizeof(struct aic23), GFP_KERNEL);
+	aic23 = devm_kzalloc(dev, sizeof(struct aic23), GFP_KERNEL);
 	if (aic23 == NULL)
 		return -ENOMEM;
 
-	aic23->regmap = devm_regmap_init_i2c(i2c, &tlv320aic23_regmap);
-	if (IS_ERR(aic23->regmap))
-		return PTR_ERR(aic23->regmap);
+	aic23->regmap = regmap;
 
-	i2c_set_clientdata(i2c, aic23);
+	dev_set_drvdata(dev, aic23);
 
-	ret =  snd_soc_register_codec(&i2c->dev,
-			&soc_codec_dev_tlv320aic23, &tlv320aic23_dai, 1);
-	return ret;
-}
-static int __exit tlv320aic23_i2c_remove(struct i2c_client *i2c)
-{
-	snd_soc_unregister_codec(&i2c->dev);
-	return 0;
+	return snd_soc_register_codec(dev, &soc_codec_dev_tlv320aic23,
+				      &tlv320aic23_dai, 1);
 }
 
-static const struct i2c_device_id tlv320aic23_id[] = {
-	{"tlv320aic23", 0},
-	{}
-};
-
-MODULE_DEVICE_TABLE(i2c, tlv320aic23_id);
-
-static struct i2c_driver tlv320aic23_i2c_driver = {
-	.driver = {
-		   .name = "tlv320aic23-codec",
-		   },
-	.probe = tlv320aic23_codec_probe,
-	.remove = __exit_p(tlv320aic23_i2c_remove),
-	.id_table = tlv320aic23_id,
-};
-
-module_i2c_driver(tlv320aic23_i2c_driver);
-
 MODULE_DESCRIPTION("ASoC TLV320AIC23 codec driver");
 MODULE_AUTHOR("Arun KS <arunks@mistralsolutions.com>");
 MODULE_LICENSE("GPL");
diff --git a/sound/soc/codecs/tlv320aic23.h b/sound/soc/codecs/tlv320aic23.h
index e804120..3a7235a 100644
--- a/sound/soc/codecs/tlv320aic23.h
+++ b/sound/soc/codecs/tlv320aic23.h
@@ -12,6 +12,12 @@
 #ifndef _TLV320AIC23_H
 #define _TLV320AIC23_H
 
+struct device;
+struct regmap_config;
+
+extern const struct regmap_config tlv320aic23_regmap;
+int tlv320aic23_probe(struct device *dev, struct regmap *regmap);
+
 /* Codec TLV320AIC23 */
 #define TLV320AIC23_LINVOL		0x00
 #define TLV320AIC23_RINVOL		0x01
-- 
1.8.1.4

