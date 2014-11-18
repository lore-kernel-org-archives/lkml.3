Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754965AbaKRSrR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 13:47:17 -0500
Received: from smtp-out-252.synserver.de ([212.40.185.252]:1125 "EHLO
	smtp-out-252.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754226AbaKRSqA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 13:46:00 -0500
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 13395
From: Lars-Peter Clausen <lars@metafoo.de>
To: Mark Brown <broonie@kernel.org>, Liam Girdwood <lgirdwood@gmail.com>
Cc: alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH 3/4] ASoC: ad1980: Convert to regmap
Date: Tue, 18 Nov 2014 19:45:53 +0100
Message-Id: <1416336354-32148-4-git-send-email-lars@metafoo.de>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1416336354-32148-1-git-send-email-lars@metafoo.de>
References: <1416336354-32148-1-git-send-email-lars@metafoo.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch converts the ad1980 driver to use regmap for its IO.

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
---
 sound/soc/codecs/Kconfig  |   1 +
 sound/soc/codecs/ad1980.c | 141 ++++++++++++++++++++++++++++------------------
 2 files changed, 88 insertions(+), 54 deletions(-)

diff --git a/sound/soc/codecs/Kconfig b/sound/soc/codecs/Kconfig
index 072b784..883c577 100644
--- a/sound/soc/codecs/Kconfig
+++ b/sound/soc/codecs/Kconfig
@@ -226,6 +226,7 @@ config SND_SOC_AD193X_I2C
 	select SND_SOC_AD193X
 
 config SND_SOC_AD1980
+	select REGMAP_AC97
 	tristate
 
 config SND_SOC_AD73311
diff --git a/sound/soc/codecs/ad1980.c b/sound/soc/codecs/ad1980.c
index 93bd47d..5fd4a29 100644
--- a/sound/soc/codecs/ad1980.c
+++ b/sound/soc/codecs/ad1980.c
@@ -24,32 +24,86 @@
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/device.h>
+#include <linux/regmap.h>
 #include <sound/core.h>
 #include <sound/pcm.h>
 #include <sound/ac97_codec.h>
 #include <sound/initval.h>
 #include <sound/soc.h>
 
-/*
- * AD1980 register cache
- */
-static const u16 ad1980_reg[] = {
-	0x0090, 0x8000, 0x8000, 0x8000, /* 0 - 6  */
-	0x0000, 0x0000, 0x8008, 0x8008, /* 8 - e  */
-	0x8808, 0x8808, 0x0000, 0x8808, /* 10 - 16 */
-	0x8808, 0x0000, 0x8000, 0x0000, /* 18 - 1e */
-	0x0000, 0x0000, 0x0000, 0x0000, /* 20 - 26 */
-	0x03c7, 0x0000, 0xbb80, 0xbb80, /* 28 - 2e */
-	0xbb80, 0xbb80, 0x0000, 0x8080, /* 30 - 36 */
-	0x8080, 0x2000, 0x0000, 0x0000, /* 38 - 3e */
-	0x0000, 0x0000, 0x0000, 0x0000, /* reserved */
-	0x0000, 0x0000, 0x0000, 0x0000, /* reserved */
-	0x0000, 0x0000, 0x0000, 0x0000, /* reserved */
-	0x0000, 0x0000, 0x0000, 0x0000, /* reserved */
-	0x8080, 0x0000, 0x0000, 0x0000, /* 60 - 66 */
-	0x0000, 0x0000, 0x0000, 0x0000, /* reserved */
-	0x0000, 0x0000, 0x1001, 0x0000, /* 70 - 76 */
-	0x0000, 0x0000, 0x4144, 0x5370  /* 78 - 7e */
+static const struct reg_default ad1980_reg_defaults[] = {
+	{ 0x02, 0x8000 },
+	{ 0x04, 0x8000 },
+	{ 0x06, 0x8000 },
+	{ 0x0c, 0x8008 },
+	{ 0x0e, 0x8008 },
+	{ 0x10, 0x8808 },
+	{ 0x12, 0x8808 },
+	{ 0x16, 0x8808 },
+	{ 0x18, 0x8808 },
+	{ 0x1a, 0x0000 },
+	{ 0x1c, 0x8000 },
+	{ 0x20, 0x0000 },
+	{ 0x28, 0x03c7 },
+	{ 0x2c, 0xbb80 },
+	{ 0x2e, 0xbb80 },
+	{ 0x30, 0xbb80 },
+	{ 0x32, 0xbb80 },
+	{ 0x36, 0x8080 },
+	{ 0x38, 0x8080 },
+	{ 0x3a, 0x2000 },
+	{ 0x60, 0x0000 },
+	{ 0x62, 0x0000 },
+	{ 0x72, 0x0000 },
+	{ 0x74, 0x1001 },
+	{ 0x76, 0x0000 },
+};
+
+static bool ad1980_readable_reg(struct device *dev, unsigned int reg)
+{
+	switch (reg) {
+	case AC97_RESET ... AC97_MASTER_MONO:
+	case AC97_PHONE ... AC97_CD:
+	case AC97_AUX ... AC97_GENERAL_PURPOSE:
+	case AC97_POWERDOWN ... AC97_PCM_LR_ADC_RATE:
+	case AC97_SPDIF:
+	case AC97_CODEC_CLASS_REV:
+	case AC97_PCI_SVID:
+	case AC97_AD_CODEC_CFG:
+	case AC97_AD_JACK_SPDIF:
+	case AC97_AD_SERIAL_CFG:
+	case AC97_VENDOR_ID1:
+	case AC97_VENDOR_ID2:
+		return true;
+	default:
+		return false;
+	}
+}
+
+static bool ad1980_writeable_reg(struct device *dev, unsigned int reg)
+{
+	switch (reg) {
+	case AC97_VENDOR_ID1:
+	case AC97_VENDOR_ID2:
+		return false;
+	default:
+		return ad1980_readable_reg(dev, reg);
+	}
+}
+
+static const struct regmap_config ad1980_regmap_config = {
+	.reg_bits = 16,
+	.reg_stride = 2,
+	.val_bits = 16,
+	.max_register = 0x7e,
+	.cache_type = REGCACHE_RBTREE,
+
+	.volatile_reg = regmap_ac97_default_volatile,
+	.readable_reg = ad1980_readable_reg,
+	.writeable_reg = ad1980_writeable_reg,
+
+	.reg_defaults = ad1980_reg_defaults,
+	.num_reg_defaults = ARRAY_SIZE(ad1980_reg_defaults),
 };
 
 static const char *ad1980_rec_sel[] = {"Mic", "CD", "NC", "AUX", "Line",
@@ -135,39 +189,13 @@ static const struct snd_soc_dapm_route ad1980_dapm_routes[] = {
 static unsigned int ac97_read(struct snd_soc_codec *codec,
 	unsigned int reg)
 {
-	struct snd_ac97 *ac97 = snd_soc_codec_get_drvdata(codec);
-	u16 *cache = codec->reg_cache;
-
-	switch (reg) {
-	case AC97_RESET:
-	case AC97_INT_PAGING:
-	case AC97_POWERDOWN:
-	case AC97_EXTENDED_STATUS:
-	case AC97_VENDOR_ID1:
-	case AC97_VENDOR_ID2:
-		return soc_ac97_ops->read(ac97, reg);
-	default:
-		reg = reg >> 1;
-
-		if (reg >= ARRAY_SIZE(ad1980_reg))
-			return -EINVAL;
-
-		return cache[reg];
-	}
+	return snd_soc_read(codec, reg);
 }
 
 static int ac97_write(struct snd_soc_codec *codec, unsigned int reg,
 	unsigned int val)
 {
-	struct snd_ac97 *ac97 = snd_soc_codec_get_drvdata(codec);
-	u16 *cache = codec->reg_cache;
-
-	soc_ac97_ops->write(ac97, reg, val);
-	reg = reg >> 1;
-	if (reg < ARRAY_SIZE(ad1980_reg))
-		cache[reg] = val;
-
-	return 0;
+	return snd_soc_write(codec, reg, val);
 }
 
 static struct snd_soc_dai_driver ad1980_dai = {
@@ -219,6 +247,7 @@ static int ad1980_reset(struct snd_soc_codec *codec, int try_warm)
 static int ad1980_soc_probe(struct snd_soc_codec *codec)
 {
 	struct snd_ac97 *ac97;
+	struct regmap *regmap;
 	int ret;
 	u16 vendor_id2;
 	u16 ext_status;
@@ -230,6 +259,13 @@ static int ad1980_soc_probe(struct snd_soc_codec *codec)
 		return ret;
 	}
 
+	regmap = regmap_init_ac97(ac97, &ad1980_regmap_config);
+	if (IS_ERR(regmap)) {
+		ret = PTR_ERR(regmap);
+		goto err_free_ac97;
+	}
+
+	snd_soc_codec_init_regmap(codec, regmap);
 	snd_soc_codec_set_drvdata(codec, ac97);
 
 	ret = ad1980_reset(codec, 0);
@@ -268,6 +304,8 @@ static int ad1980_soc_probe(struct snd_soc_codec *codec)
 	return 0;
 
 reset_err:
+	snd_soc_codec_exit_regmap(codec);
+err_free_ac97:
 	snd_soc_free_ac97_codec(ac97);
 	return ret;
 }
@@ -276,6 +314,7 @@ static int ad1980_soc_remove(struct snd_soc_codec *codec)
 {
 	struct snd_ac97 *ac97 = snd_soc_codec_get_drvdata(codec);
 
+	snd_soc_codec_exit_regmap(codec);
 	snd_soc_free_ac97_codec(ac97);
 	return 0;
 }
@@ -283,12 +322,6 @@ static int ad1980_soc_remove(struct snd_soc_codec *codec)
 static struct snd_soc_codec_driver soc_codec_dev_ad1980 = {
 	.probe = 	ad1980_soc_probe,
 	.remove = 	ad1980_soc_remove,
-	.reg_cache_size = ARRAY_SIZE(ad1980_reg),
-	.reg_word_size = sizeof(u16),
-	.reg_cache_default = ad1980_reg,
-	.reg_cache_step = 2,
-	.write = ac97_write,
-	.read = ac97_read,
 
 	.controls = ad1980_snd_ac97_controls,
 	.num_controls = ARRAY_SIZE(ad1980_snd_ac97_controls),
-- 
1.8.0

