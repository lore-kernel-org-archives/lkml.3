Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753837AbaKHNkq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Nov 2014 08:40:46 -0500
Received: from mail.lysator.liu.se ([130.236.254.3]:57195 "EHLO
	mail.lysator.liu.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753784AbaKHNko (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Nov 2014 08:40:44 -0500
From: Peter Rosin <peda@lysator.liu.se>
To: alsa-devel@alsa-project.org
Cc: Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        linux-kernel@vger.kernel.org, Peter Rosin <peda@axentia.se>
Subject: [PATCH v3] ASoC: tfa9879: New driver for NXP Semiconductors TFA9879 amplifier.
Date: Sat,  8 Nov 2014 14:40:17 +0100
Message-Id: <1415454017-4146-2-git-send-email-peda@lysator.liu.se>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1415454017-4146-1-git-send-email-peda@lysator.liu.se>
References: <20141107111737.GJ8509@sirena.org.uk>
 <1415454017-4146-1-git-send-email-peda@lysator.liu.se>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Rosin <peda@axentia.se>

Signed-off-by: Peter Rosin <peda@axentia.se>
---
 MAINTAINERS                |    6 +
 sound/soc/codecs/Kconfig   |    5 +
 sound/soc/codecs/Makefile  |    2 +
 sound/soc/codecs/tfa9879.c |  328 ++++++++++++++++++++++++++++++++++++++++++++
 sound/soc/codecs/tfa9879.h |  202 +++++++++++++++++++++++++++
 5 files changed, 543 insertions(+)
 create mode 100644 sound/soc/codecs/tfa9879.c
 create mode 100644 sound/soc/codecs/tfa9879.h

diff --git a/MAINTAINERS b/MAINTAINERS
index f10ed3914ea8..9ca9e68ea9ab 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -6467,6 +6467,12 @@ S:	Supported
 F:	drivers/gpu/drm/i2c/tda998x_drv.c
 F:	include/drm/i2c/tda998x.h
 
+NXP TFA9879 DRIVER
+M:	Peter Rosin <peda@axentia.se>
+L:	alsa-devel@alsa-project.org (moderated for non-subscribers)
+S:	Maintained
+F:	sound/soc/codecs/tfa9879*
+
 OMAP SUPPORT
 M:	Tony Lindgren <tony@atomide.com>
 L:	linux-omap@vger.kernel.org
diff --git a/sound/soc/codecs/Kconfig b/sound/soc/codecs/Kconfig
index 8838838e25ed..36bf3f83a333 100644
--- a/sound/soc/codecs/Kconfig
+++ b/sound/soc/codecs/Kconfig
@@ -96,6 +96,7 @@ config SND_SOC_ALL_CODECS
 	select SND_SOC_STAC9766 if SND_SOC_AC97_BUS
 	select SND_SOC_TAS2552 if I2C
 	select SND_SOC_TAS5086 if I2C
+	select SND_SOC_TFA9879 if I2C
 	select SND_SOC_TLV320AIC23_I2C if I2C
 	select SND_SOC_TLV320AIC23_SPI if SPI_MASTER
 	select SND_SOC_TLV320AIC26 if SPI_MASTER
@@ -548,6 +549,10 @@ config SND_SOC_TAS5086
 	tristate "Texas Instruments TAS5086 speaker amplifier"
 	depends on I2C
 
+config SND_SOC_TFA9879
+	tristate "NXP Semiconductors TFA9879 amplifier"
+	depends on I2C
+
 config SND_SOC_TLV320AIC23
 	tristate
 
diff --git a/sound/soc/codecs/Makefile b/sound/soc/codecs/Makefile
index 20afe0f0c5be..678a3a6df8a5 100644
--- a/sound/soc/codecs/Makefile
+++ b/sound/soc/codecs/Makefile
@@ -96,6 +96,7 @@ snd-soc-sta350-objs := sta350.o
 snd-soc-sta529-objs := sta529.o
 snd-soc-stac9766-objs := stac9766.o
 snd-soc-tas5086-objs := tas5086.o
+snd-soc-tfa9879-objs := tfa9879.o
 snd-soc-tlv320aic23-objs := tlv320aic23.o
 snd-soc-tlv320aic23-i2c-objs := tlv320aic23-i2c.o
 snd-soc-tlv320aic23-spi-objs := tlv320aic23-spi.o
@@ -264,6 +265,7 @@ obj-$(CONFIG_SND_SOC_STA529)   += snd-soc-sta529.o
 obj-$(CONFIG_SND_SOC_STAC9766)	+= snd-soc-stac9766.o
 obj-$(CONFIG_SND_SOC_TAS2552)	+= snd-soc-tas2552.o
 obj-$(CONFIG_SND_SOC_TAS5086)	+= snd-soc-tas5086.o
+obj-$(CONFIG_SND_SOC_TFA9879)	+= snd-soc-tfa9879.o
 obj-$(CONFIG_SND_SOC_TLV320AIC23)	+= snd-soc-tlv320aic23.o
 obj-$(CONFIG_SND_SOC_TLV320AIC23_I2C)	+= snd-soc-tlv320aic23-i2c.o
 obj-$(CONFIG_SND_SOC_TLV320AIC23_SPI)	+= snd-soc-tlv320aic23-spi.o
diff --git a/sound/soc/codecs/tfa9879.c b/sound/soc/codecs/tfa9879.c
new file mode 100644
index 000000000000..16f1b71edb55
--- /dev/null
+++ b/sound/soc/codecs/tfa9879.c
@@ -0,0 +1,328 @@
+/*
+ * tfa9879.c  --  driver for NXP Semiconductors TFA9879
+ *
+ * Copyright (C) 2014 Axentia Technologies AB
+ * Author: Peter Rosin <peda@axentia.se>
+ *
+ *  This program is free software; you can redistribute  it and/or modify it
+ *  under  the terms of  the GNU General  Public License as published by the
+ *  Free Software Foundation;  either version 2 of the  License, or (at your
+ *  option) any later version.
+ *
+ */
+
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/i2c.h>
+#include <linux/regmap.h>
+#include <sound/soc.h>
+#include <sound/tlv.h>
+#include <sound/pcm_params.h>
+
+#include "tfa9879.h"
+
+struct tfa9879_priv {
+	struct regmap *regmap;
+	int lsb_justified;
+};
+
+static int tfa9879_hw_params(struct snd_pcm_substream *substream,
+			     struct snd_pcm_hw_params *params,
+			     struct snd_soc_dai *dai)
+{
+	struct snd_soc_codec *codec = dai->codec;
+	struct tfa9879_priv *tfa9879 = snd_soc_codec_get_drvdata(codec);
+	int fs;
+	int i2s_set = 0;
+
+	switch (params_rate(params)) {
+	case 8000:
+		fs = TFA9879_I2S_FS_8000;
+		break;
+	case 11025:
+		fs = TFA9879_I2S_FS_11025;
+		break;
+	case 12000:
+		fs = TFA9879_I2S_FS_12000;
+		break;
+	case 16000:
+		fs = TFA9879_I2S_FS_16000;
+		break;
+	case 22050:
+		fs = TFA9879_I2S_FS_22050;
+		break;
+	case 24000:
+		fs = TFA9879_I2S_FS_24000;
+		break;
+	case 32000:
+		fs = TFA9879_I2S_FS_32000;
+		break;
+	case 44100:
+		fs = TFA9879_I2S_FS_44100;
+		break;
+	case 48000:
+		fs = TFA9879_I2S_FS_48000;
+		break;
+	case 64000:
+		fs = TFA9879_I2S_FS_64000;
+		break;
+	case 88200:
+		fs = TFA9879_I2S_FS_88200;
+		break;
+	case 96000:
+		fs = TFA9879_I2S_FS_96000;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	switch (params_width(params)) {
+	case 16:
+		i2s_set = TFA9879_I2S_SET_LSB_J_16;
+		break;
+	case 24:
+		i2s_set = TFA9879_I2S_SET_LSB_J_24;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	if (tfa9879->lsb_justified)
+		snd_soc_update_bits(codec, TFA9879_SERIAL_INTERFACE_1,
+				    TFA9879_I2S_SET_MASK,
+				    i2s_set << TFA9879_I2S_SET_SHIFT);
+
+	snd_soc_update_bits(codec, TFA9879_SERIAL_INTERFACE_1,
+			    TFA9879_I2S_FS_MASK,
+			    fs << TFA9879_I2S_FS_SHIFT);
+	return 0;
+}
+
+static int tfa9879_digital_mute(struct snd_soc_dai *dai, int mute)
+{
+	struct snd_soc_codec *codec = dai->codec;
+
+	snd_soc_update_bits(codec, TFA9879_MISC_CONTROL,
+			    TFA9879_S_MUTE_MASK,
+			    !!mute << TFA9879_S_MUTE_SHIFT);
+
+	return 0;
+}
+
+static int tfa9879_set_fmt(struct snd_soc_dai *dai, unsigned int fmt)
+{
+	struct snd_soc_codec *codec = dai->codec;
+	struct tfa9879_priv *tfa9879 = snd_soc_codec_get_drvdata(codec);
+	int i2s_set;
+	int sck_pol;
+
+	switch (fmt & SND_SOC_DAIFMT_MASTER_MASK) {
+	case SND_SOC_DAIFMT_CBS_CFS:
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	switch (fmt & SND_SOC_DAIFMT_INV_MASK) {
+	case SND_SOC_DAIFMT_NB_NF:
+		sck_pol = TFA9879_SCK_POL_NORMAL;
+		break;
+	case SND_SOC_DAIFMT_IB_NF:
+		sck_pol = TFA9879_SCK_POL_INVERSE;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	switch (fmt & SND_SOC_DAIFMT_FORMAT_MASK) {
+	case SND_SOC_DAIFMT_I2S:
+		tfa9879->lsb_justified = 0;
+		i2s_set = TFA9879_I2S_SET_I2S_24;
+		break;
+	case SND_SOC_DAIFMT_LEFT_J:
+		tfa9879->lsb_justified = 0;
+		i2s_set = TFA9879_I2S_SET_MSB_J_24;
+		break;
+	case SND_SOC_DAIFMT_RIGHT_J:
+		tfa9879->lsb_justified = 1;
+		i2s_set = TFA9879_I2S_SET_LSB_J_24;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	snd_soc_update_bits(codec, TFA9879_SERIAL_INTERFACE_1,
+			    TFA9879_SCK_POL_MASK,
+			    sck_pol << TFA9879_SCK_POL_SHIFT);
+	snd_soc_update_bits(codec, TFA9879_SERIAL_INTERFACE_1,
+			    TFA9879_I2S_SET_MASK,
+			    i2s_set << TFA9879_I2S_SET_SHIFT);
+	return 0;
+}
+
+static struct reg_default tfa9879_regs[] = {
+	{ TFA9879_DEVICE_CONTROL,	0x0000 }, /* 0x00 */
+	{ TFA9879_SERIAL_INTERFACE_1,	0x0a18 }, /* 0x01 */
+	{ TFA9879_PCM_IOM2_FORMAT_1,	0x0007 }, /* 0x02 */
+	{ TFA9879_SERIAL_INTERFACE_2,	0x0a18 }, /* 0x03 */
+	{ TFA9879_PCM_IOM2_FORMAT_2,	0x0007 }, /* 0x04 */
+	{ TFA9879_EQUALIZER_A1,		0x59dd }, /* 0x05 */
+	{ TFA9879_EQUALIZER_A2,		0xc63e }, /* 0x06 */
+	{ TFA9879_EQUALIZER_B1,		0x651a }, /* 0x07 */
+	{ TFA9879_EQUALIZER_B2,		0xe53e }, /* 0x08 */
+	{ TFA9879_EQUALIZER_C1,		0x4616 }, /* 0x09 */
+	{ TFA9879_EQUALIZER_C2,		0xd33e }, /* 0x0a */
+	{ TFA9879_EQUALIZER_D1,		0x4df3 }, /* 0x0b */
+	{ TFA9879_EQUALIZER_D2,		0xea3e }, /* 0x0c */
+	{ TFA9879_EQUALIZER_E1,		0x5ee0 }, /* 0x0d */
+	{ TFA9879_EQUALIZER_E2,		0xf93e }, /* 0x0e */
+	{ TFA9879_BYPASS_CONTROL,	0x0093 }, /* 0x0f */
+	{ TFA9879_DYNAMIC_RANGE_COMPR,	0x92ba }, /* 0x10 */
+	{ TFA9879_BASS_TREBLE,		0x12a5 }, /* 0x11 */
+	{ TFA9879_HIGH_PASS_FILTER,	0x0004 }, /* 0x12 */
+	{ TFA9879_VOLUME_CONTROL,	0x10bd }, /* 0x13 */
+	{ TFA9879_MISC_CONTROL,		0x0000 }, /* 0x14 */
+};
+
+static bool tfa9879_volatile_reg(struct device *dev, unsigned int reg)
+{
+	return reg == TFA9879_MISC_STATUS;
+}
+
+static const DECLARE_TLV_DB_SCALE(volume_tlv, -7050, 50, 1);
+static const DECLARE_TLV_DB_SCALE(tb_gain_tlv, -1800, 200, 0);
+static const char * const tb_freq_text[] = {
+	"Low", "Mid", "High"
+};
+static const struct soc_enum treble_freq_enum =
+	SOC_ENUM_SINGLE(TFA9879_BASS_TREBLE, TFA9879_F_TRBLE_SHIFT,
+			ARRAY_SIZE(tb_freq_text), tb_freq_text);
+static const struct soc_enum bass_freq_enum =
+	SOC_ENUM_SINGLE(TFA9879_BASS_TREBLE, TFA9879_F_BASS_SHIFT,
+			ARRAY_SIZE(tb_freq_text), tb_freq_text);
+
+static const struct snd_kcontrol_new tfa9879_controls[] = {
+	SOC_SINGLE_TLV("PCM Playback Volume", TFA9879_VOLUME_CONTROL,
+		       TFA9879_VOL_SHIFT, 0xbd, 1, volume_tlv),
+	SOC_SINGLE_TLV("Treble Volume", TFA9879_BASS_TREBLE,
+		       TFA9879_G_TRBLE_SHIFT, 18, 0, tb_gain_tlv),
+	SOC_SINGLE_TLV("Bass Volume", TFA9879_BASS_TREBLE,
+		       TFA9879_G_BASS_SHIFT, 18, 0, tb_gain_tlv),
+	SOC_ENUM("Treble Corner Freq", treble_freq_enum),
+	SOC_ENUM("Bass Corner Freq", bass_freq_enum),
+};
+
+static const struct snd_soc_dapm_widget tfa9879_dapm_widgets[] = {
+SND_SOC_DAPM_AIF_IN("AIFINL", "Playback", 0, SND_SOC_NOPM, 0, 0),
+SND_SOC_DAPM_AIF_IN("AIFINR", "Playback", 1, SND_SOC_NOPM, 0, 0),
+SND_SOC_DAPM_DAC("DAC", NULL, TFA9879_DEVICE_CONTROL, TFA9879_OPMODE_SHIFT, 0),
+SND_SOC_DAPM_OUTPUT("LINEOUT"),
+SND_SOC_DAPM_SUPPLY("POWER", TFA9879_DEVICE_CONTROL, TFA9879_POWERUP_SHIFT, 0,
+		    NULL, 0),
+};
+
+static const struct snd_soc_dapm_route tfa9879_dapm_routes[] = {
+	{ "DAC", NULL, "AIFINL" },
+	{ "DAC", NULL, "AIFINR" },
+
+	{ "LINEOUT", NULL, "DAC" },
+
+	{ "DAC", NULL, "POWER" },
+};
+
+static const struct snd_soc_codec_driver tfa9879_codec = {
+	.controls = tfa9879_controls,
+	.num_controls = ARRAY_SIZE(tfa9879_controls),
+
+	.dapm_widgets = tfa9879_dapm_widgets,
+	.num_dapm_widgets = ARRAY_SIZE(tfa9879_dapm_widgets),
+	.dapm_routes = tfa9879_dapm_routes,
+	.num_dapm_routes = ARRAY_SIZE(tfa9879_dapm_routes),
+};
+
+static const struct regmap_config tfa9879_regmap = {
+	.reg_bits = 8,
+	.val_bits = 16,
+
+	.volatile_reg = tfa9879_volatile_reg,
+	.max_register = TFA9879_MISC_STATUS,
+	.reg_defaults = tfa9879_regs,
+	.num_reg_defaults = ARRAY_SIZE(tfa9879_regs),
+	.cache_type = REGCACHE_RBTREE,
+};
+
+static const struct snd_soc_dai_ops tfa9879_dai_ops = {
+	.hw_params = tfa9879_hw_params,
+	.digital_mute = tfa9879_digital_mute,
+	.set_fmt = tfa9879_set_fmt,
+};
+
+#define TFA9879_RATES SNDRV_PCM_RATE_8000_96000
+
+#define TFA9879_FORMATS (SNDRV_PCM_FMTBIT_S16_LE | \
+			 SNDRV_PCM_FMTBIT_S24_LE)
+
+static struct snd_soc_dai_driver tfa9879_dai = {
+	.name = "tfa9879-hifi",
+	.playback = {
+		.stream_name = "Playback",
+		.channels_min = 2,
+		.channels_max = 2,
+		.rates = TFA9879_RATES,
+		.formats = TFA9879_FORMATS, },
+	.ops = &tfa9879_dai_ops,
+};
+
+static int tfa9879_i2c_probe(struct i2c_client *i2c,
+			     const struct i2c_device_id *id)
+{
+	struct tfa9879_priv *tfa9879;
+	int i;
+
+	tfa9879 = devm_kzalloc(&i2c->dev, sizeof(*tfa9879), GFP_KERNEL);
+	if (IS_ERR(tfa9879))
+		return PTR_ERR(tfa9879);
+
+	i2c_set_clientdata(i2c, tfa9879);
+
+	tfa9879->regmap = devm_regmap_init_i2c(i2c, &tfa9879_regmap);
+	if (IS_ERR(tfa9879->regmap))
+		return PTR_ERR(tfa9879->regmap);
+
+	/* Ensure the device is in reset state */
+	for (i = 0; i < ARRAY_SIZE(tfa9879_regs); i++)
+		regmap_write(tfa9879->regmap,
+			     tfa9879_regs[i].reg, tfa9879_regs[i].def);
+
+	return snd_soc_register_codec(&i2c->dev, &tfa9879_codec,
+				      &tfa9879_dai, 1);
+}
+
+static int tfa9879_i2c_remove(struct i2c_client *client)
+{
+	snd_soc_unregister_codec(&client->dev);
+
+	return 0;
+}
+
+static const struct i2c_device_id tfa9879_i2c_id[] = {
+	{ "tfa9879", 0 },
+	{ }
+};
+MODULE_DEVICE_TABLE(i2c, tfa9879_i2c_id);
+
+static struct i2c_driver tfa9879_i2c_driver = {
+	.driver = {
+		.name = "tfa9879",
+		.owner = THIS_MODULE,
+	},
+	.probe = tfa9879_i2c_probe,
+	.remove = tfa9879_i2c_remove,
+	.id_table = tfa9879_i2c_id,
+};
+
+module_i2c_driver(tfa9879_i2c_driver);
+
+MODULE_DESCRIPTION("ASoC NXP Semiconductors TFA9879 driver");
+MODULE_AUTHOR("Peter Rosin <peda@axentia.se>");
+MODULE_LICENSE("GPL");
diff --git a/sound/soc/codecs/tfa9879.h b/sound/soc/codecs/tfa9879.h
new file mode 100644
index 000000000000..3408c90c4628
--- /dev/null
+++ b/sound/soc/codecs/tfa9879.h
@@ -0,0 +1,202 @@
+/*
+ * tfa9879.h  --  driver for NXP Semiconductors TFA9879
+ *
+ * Copyright (C) 2014 Axentia Technologies AB
+ * Author: Peter Rosin <peda@axentia.se>
+ *
+ *  This program is free software; you can redistribute  it and/or modify it
+ *  under  the terms of  the GNU General  Public License as published by the
+ *  Free Software Foundation;  either version 2 of the  License, or (at your
+ *  option) any later version.
+ *
+ */
+
+#ifndef _TFA9879_H
+#define _TFA9879_H
+
+#define TFA9879_DEVICE_CONTROL		0x00
+#define TFA9879_SERIAL_INTERFACE_1	0x01
+#define TFA9879_PCM_IOM2_FORMAT_1	0x02
+#define TFA9879_SERIAL_INTERFACE_2	0x03
+#define TFA9879_PCM_IOM2_FORMAT_2	0x04
+#define TFA9879_EQUALIZER_A1		0x05
+#define TFA9879_EQUALIZER_A2		0x06
+#define TFA9879_EQUALIZER_B1		0x07
+#define TFA9879_EQUALIZER_B2		0x08
+#define TFA9879_EQUALIZER_C1		0x09
+#define TFA9879_EQUALIZER_C2		0x0a
+#define TFA9879_EQUALIZER_D1		0x0b
+#define TFA9879_EQUALIZER_D2		0x0c
+#define TFA9879_EQUALIZER_E1		0x0d
+#define TFA9879_EQUALIZER_E2		0x0e
+#define TFA9879_BYPASS_CONTROL		0x0f
+#define TFA9879_DYNAMIC_RANGE_COMPR	0x10
+#define TFA9879_BASS_TREBLE		0x11
+#define TFA9879_HIGH_PASS_FILTER	0x12
+#define TFA9879_VOLUME_CONTROL		0x13
+#define TFA9879_MISC_CONTROL		0x14
+#define TFA9879_MISC_STATUS		0x15
+
+/* TFA9879_DEVICE_CONTROL */
+#define TFA9879_INPUT_SEL_MASK		0x0010
+#define TFA9879_INPUT_SEL_SHIFT		4
+#define TFA9879_OPMODE_MASK		0x0008
+#define TFA9879_OPMODE_SHIFT		3
+#define TFA9879_RESET_MASK		0x0002
+#define TFA9879_RESET_SHIFT		1
+#define TFA9879_POWERUP_MASK		0x0001
+#define TFA9879_POWERUP_SHIFT		0
+
+/* TFA9879_SERIAL_INTERFACE */
+#define TFA9879_MONO_SEL_MASK		0x0c00
+#define TFA9879_MONO_SEL_SHIFT		10
+#define TFA9879_MONO_SEL_LEFT		0
+#define TFA9879_MONO_SEL_RIGHT		1
+#define TFA9879_MONO_SEL_BOTH		2
+#define TFA9879_I2S_FS_MASK		0x03c0
+#define TFA9879_I2S_FS_SHIFT		6
+#define TFA9879_I2S_FS_8000		0
+#define TFA9879_I2S_FS_11025		1
+#define TFA9879_I2S_FS_12000		2
+#define TFA9879_I2S_FS_16000		3
+#define TFA9879_I2S_FS_22050		4
+#define TFA9879_I2S_FS_24000		5
+#define TFA9879_I2S_FS_32000		6
+#define TFA9879_I2S_FS_44100		7
+#define TFA9879_I2S_FS_48000		8
+#define TFA9879_I2S_FS_64000		9
+#define TFA9879_I2S_FS_88200		10
+#define TFA9879_I2S_FS_96000		11
+#define TFA9879_I2S_SET_MASK		0x0038
+#define TFA9879_I2S_SET_SHIFT		3
+#define TFA9879_I2S_SET_MSB_J_24	2
+#define TFA9879_I2S_SET_I2S_24		3
+#define TFA9879_I2S_SET_LSB_J_16	4
+#define TFA9879_I2S_SET_LSB_J_18	5
+#define TFA9879_I2S_SET_LSB_J_20	6
+#define TFA9879_I2S_SET_LSB_J_24	7
+#define TFA9879_SCK_POL_MASK		0x0004
+#define TFA9879_SCK_POL_SHIFT		2
+#define TFA9879_SCK_POL_NORMAL		0
+#define TFA9879_SCK_POL_INVERSE		1
+#define TFA9879_I_MODE_MASK		0x0003
+#define TFA9879_I_MODE_SHIFT		0
+#define TFA9879_I_MODE_I2S		0
+#define TFA9879_I_MODE_PCM_IOM2_SHORT	1
+#define TFA9879_I_MODE_PCM_IOM2_LONG	2
+
+/* TFA9879_PCM_IOM2_FORMAT */
+#define TFA9879_PCM_FS_MASK		0x0800
+#define TFA9879_PCM_FS_SHIFT		11
+#define TFA9879_A_LAW_MASK		0x0400
+#define TFA9879_A_LAW_SHIFT		10
+#define TFA9879_PCM_COMP_MASK		0x0200
+#define TFA9879_PCM_COMP_SHIFT		9
+#define TFA9879_PCM_DL_MASK		0x0100
+#define TFA9879_PCM_DL_SHIFT		8
+#define TFA9879_D1_SLOT_MASK		0x00f0
+#define TFA9879_D1_SLOT_SHIFT		4
+#define TFA9879_D2_SLOT_MASK		0x000f
+#define TFA9879_D2_SLOT_SHIFT		0
+
+/* TFA9879_EQUALIZER_X1 */
+#define TFA9879_T1_MASK			0x8000
+#define TFA9879_T1_SHIFT		15
+#define TFA9879_K1M_MASK		0x7ff0
+#define TFA9879_K1M_SHIFT		4
+#define TFA9879_K1E_MASK		0x000f
+#define TFA9879_K1E_SHIFT		0
+
+/* TFA9879_EQUALIZER_X2 */
+#define TFA9879_T2_MASK			0x8000
+#define TFA9879_T2_SHIFT		15
+#define TFA9879_K2M_MASK		0x7800
+#define TFA9879_K2M_SHIFT		11
+#define TFA9879_K2E_MASK		0x0700
+#define TFA9879_K2E_SHIFT		8
+#define TFA9879_K0_MASK			0x00fe
+#define TFA9879_K0_SHIFT		1
+#define TFA9879_S_MASK			0x0001
+#define TFA9879_S_SHIFT			0
+
+/* TFA9879_BYPASS_CONTROL */
+#define TFA9879_L_OCP_MASK		0x00c0
+#define TFA9879_L_OCP_SHIFT		6
+#define TFA9879_L_OTP_MASK		0x0030
+#define TFA9879_L_OTP_SHIFT		4
+#define TFA9879_CLIPCTRL_MASK		0x0008
+#define TFA9879_CLIPCTRL_SHIFT		3
+#define TFA9879_HPF_BP_MASK		0x0004
+#define TFA9879_HPF_BP_SHIFT		2
+#define TFA9879_DRC_BP_MASK		0x0002
+#define TFA9879_DRC_BP_SHIFT		1
+#define TFA9879_EQ_BP_MASK		0x0001
+#define TFA9879_EQ_BP_SHIFT		0
+
+/* TFA9879_DYNAMIC_RANGE_COMPR */
+#define TFA9879_AT_LVL_MASK		0xf000
+#define TFA9879_AT_LVL_SHIFT		12
+#define TFA9879_AT_RATE_MASK		0x0f00
+#define TFA9879_AT_RATE_SHIFT		8
+#define TFA9879_RL_LVL_MASK		0x00f0
+#define TFA9879_RL_LVL_SHIFT		4
+#define TFA9879_RL_RATE_MASK		0x000f
+#define TFA9879_RL_RATE_SHIFT		0
+
+/* TFA9879_BASS_TREBLE */
+#define TFA9879_G_TRBLE_MASK		0x3e00
+#define TFA9879_G_TRBLE_SHIFT		9
+#define TFA9879_F_TRBLE_MASK		0x0180
+#define TFA9879_F_TRBLE_SHIFT		7
+#define TFA9879_G_BASS_MASK		0x007c
+#define TFA9879_G_BASS_SHIFT		2
+#define TFA9879_F_BASS_MASK		0x0003
+#define TFA9879_F_BASS_SHIFT		0
+
+/* TFA9879_HIGH_PASS_FILTER */
+#define TFA9879_HP_CTRL_MASK		0x00ff
+#define TFA9879_HP_CTRL_SHIFT		0
+
+/* TFA9879_VOLUME_CONTROL */
+#define TFA9879_ZR_CRSS_MASK		0x1000
+#define TFA9879_ZR_CRSS_SHIFT		12
+#define TFA9879_VOL_MASK		0x00ff
+#define TFA9879_VOL_SHIFT		0
+
+/* TFA9879_MISC_CONTROL */
+#define TFA9879_DE_PHAS_MASK		0x0c00
+#define TFA9879_DE_PHAS_SHIFT		10
+#define TFA9879_H_MUTE_MASK		0x0200
+#define TFA9879_H_MUTE_SHIFT		9
+#define TFA9879_S_MUTE_MASK		0x0100
+#define TFA9879_S_MUTE_SHIFT		8
+#define TFA9879_P_LIM_MASK		0x00ff
+#define TFA9879_P_LIM_SHIFT		0
+
+/* TFA9879_MISC_STATUS */
+#define TFA9879_PS_MASK			0x4000
+#define TFA9879_PS_SHIFT		14
+#define TFA9879_PORA_MASK		0x2000
+#define TFA9879_PORA_SHIFT		13
+#define TFA9879_AMP_MASK		0x0600
+#define TFA9879_AMP_SHIFT		9
+#define TFA9879_IBP_2_MASK		0x0100
+#define TFA9879_IBP_2_SHIFT		8
+#define TFA9879_OFP_2_MASK		0x0080
+#define TFA9879_OFP_2_SHIFT		7
+#define TFA9879_UFP_2_MASK		0x0040
+#define TFA9879_UFP_2_SHIFT		6
+#define TFA9879_IBP_1_MASK		0x0020
+#define TFA9879_IBP_1_SHIFT		5
+#define TFA9879_OFP_1_MASK		0x0010
+#define TFA9879_OFP_1_SHIFT		4
+#define TFA9879_UFP_1_MASK		0x0008
+#define TFA9879_UFP_1_SHIFT		3
+#define TFA9879_OCPOKA_MASK		0x0004
+#define TFA9879_OCPOKA_SHIFT		2
+#define TFA9879_OCPOKB_MASK		0x0002
+#define TFA9879_OCPOKB_SHIFT		1
+#define TFA9879_OTPOK_MASK		0x0001
+#define TFA9879_OTPOK_SHIFT		0
+
+#endif
-- 
1.7.10.4

