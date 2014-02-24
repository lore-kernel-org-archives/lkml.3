Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752089AbaBXGyl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 01:54:41 -0500
Received: from va3ehsobe005.messaging.microsoft.com ([216.32.180.31]:43441
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750757AbaBXGyi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 01:54:38 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 1
X-BigFish: VS1(zze0eahzz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah21bch1fc6hzdchd2iz1de098h8275bh1de097hz2dh2a8h839he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dc1h1dfeh1dffh1e23h1fe8h1ff5h2218h2216h226dh22d0h24afh2327h2336h2438h2461h2487h24d7h2516h2545h255eh1155h)
From: Nicolin Chen <Guangyu.Chen@freescale.com>
To: <broonie@kernel.org>, <brian.austin@cirrus.com>,
        <Paul.Handrigan@cirrus.com>
CC: <robh+dt@kernel.org>, <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <ijc+devicetree@hellion.org.uk>, <galak@codeaurora.org>,
        <rob@landley.net>, <lgirdwood@gmail.com>, <grant.likely@linaro.org>,
        <devicetree@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <alsa-devel@alsa-project.org>
Subject: [PATCH] ASoC: cs42888: Add codec driver support
Date: Mon, 24 Feb 2014 14:55:29 +0800
Message-ID: <1393224929-7555-1-git-send-email-Guangyu.Chen@freescale.com>
X-Mailer: git-send-email 1.8.4
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds support for the Cirrus Logic CS42888 Audio CODEC that
has four 24-bit A/D and eight 24-bit D/A converters.

[ CS42888 supports both I2C and SPI control ports. As initial patch,
  this patch only adds the support for I2C. ]

Signed-off-by: Nicolin Chen <Guangyu.Chen@freescale.com>
---
 .../devicetree/bindings/sound/cs42888.txt          |  27 +
 sound/soc/codecs/Kconfig                           |   5 +
 sound/soc/codecs/Makefile                          |   2 +
 sound/soc/codecs/cs42888.c                         | 552 +++++++++++++++++++++
 sound/soc/codecs/cs42888.h                         | 209 ++++++++
 5 files changed, 795 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/sound/cs42888.txt
 create mode 100644 sound/soc/codecs/cs42888.c
 create mode 100644 sound/soc/codecs/cs42888.h

diff --git a/Documentation/devicetree/bindings/sound/cs42888.txt b/Documentation/devicetree/bindings/sound/cs42888.txt
new file mode 100644
index 0000000..7736527
--- /dev/null
+++ b/Documentation/devicetree/bindings/sound/cs42888.txt
@@ -0,0 +1,27 @@
+CS42888 audio CODEC
+
+Required properties:
+
+  - compatible : "cirrus,cs42888"
+
+  - reg : the I2C address of the device for I2C
+
+  - clocks : phandle to the clock source for MCLK
+
+  - clock-names : must contain "mclk".
+
+  - VA-supply, VD-supply, VLS-supply, VLC-supply: power supplies for the device,
+    as covered in Documentation/devicetree/bindings/regulator/regulator.txt
+
+Example:
+
+codec: cs42888@48 {
+	compatible = "cirrus,cs42888";
+	reg = <0x48>;
+	clocks = <&codec_mclk 0>;
+	clock-names = "mclk";
+	VA-supply = <&reg_audio>;
+	VD-supply = <&reg_audio>;
+	VLS-supply = <&reg_audio>;
+	VLC-supply = <&reg_audio>;
+};
diff --git a/sound/soc/codecs/Kconfig b/sound/soc/codecs/Kconfig
index f2383eb..3211488 100644
--- a/sound/soc/codecs/Kconfig
+++ b/sound/soc/codecs/Kconfig
@@ -44,6 +44,7 @@ config SND_SOC_ALL_CODECS
 	select SND_SOC_CS42L73 if I2C
 	select SND_SOC_CS4270 if I2C
 	select SND_SOC_CS4271 if SND_SOC_I2C_AND_SPI
+	select SND_SOC_CS42888 if I2C
 	select SND_SOC_CX20442 if TTY
 	select SND_SOC_DA7210 if I2C
 	select SND_SOC_DA7213 if I2C
@@ -300,6 +301,10 @@ config SND_SOC_CS4271
 	tristate "Cirrus Logic CS4271 CODEC"
 	depends on SND_SOC_I2C_AND_SPI
 
+config SND_SOC_CS42888
+	tristate "Cirrus Logic CS42888 CODEC"
+	depends on I2C
+
 config SND_SOC_CX20442
 	tristate
 	depends on TTY
diff --git a/sound/soc/codecs/Makefile b/sound/soc/codecs/Makefile
index 6af7a55..75fe757 100644
--- a/sound/soc/codecs/Makefile
+++ b/sound/soc/codecs/Makefile
@@ -30,6 +30,7 @@ snd-soc-cs42l52-objs := cs42l52.o
 snd-soc-cs42l73-objs := cs42l73.o
 snd-soc-cs4270-objs := cs4270.o
 snd-soc-cs4271-objs := cs4271.o
+snd-soc-cs42888-objs := cs42888.o
 snd-soc-cx20442-objs := cx20442.o
 snd-soc-da7210-objs := da7210.o
 snd-soc-da7213-objs := da7213.o
@@ -173,6 +174,7 @@ obj-$(CONFIG_SND_SOC_CS42L52)	+= snd-soc-cs42l52.o
 obj-$(CONFIG_SND_SOC_CS42L73)	+= snd-soc-cs42l73.o
 obj-$(CONFIG_SND_SOC_CS4270)	+= snd-soc-cs4270.o
 obj-$(CONFIG_SND_SOC_CS4271)	+= snd-soc-cs4271.o
+obj-$(CONFIG_SND_SOC_CS42888)	+= snd-soc-cs42888.o
 obj-$(CONFIG_SND_SOC_CX20442)	+= snd-soc-cx20442.o
 obj-$(CONFIG_SND_SOC_DA7210)	+= snd-soc-da7210.o
 obj-$(CONFIG_SND_SOC_DA7213)	+= snd-soc-da7213.o
diff --git a/sound/soc/codecs/cs42888.c b/sound/soc/codecs/cs42888.c
new file mode 100644
index 0000000..8561a25
--- /dev/null
+++ b/sound/soc/codecs/cs42888.c
@@ -0,0 +1,552 @@
+/*
+ * Cirrus Logic CS42888 Audio CODEC Digital Audio Interface (DAI) driver
+ *
+ * Copyright (C) 2014 Freescale Semiconductor, Inc.
+ *
+ * Author: Nicolin Chen <Guangyu.Chen@freescale.com>
+ *
+ * This file is licensed under the terms of the GNU General Public License
+ * version 2. This program is licensed "as is" without any warranty of any
+ * kind, whether express or implied.
+ */
+
+#include <linux/clk.h>
+#include <linux/delay.h>
+#include <linux/i2c.h>
+#include <linux/module.h>
+#include <linux/pm_runtime.h>
+#include <linux/regulator/consumer.h>
+#include <sound/pcm_params.h>
+#include <sound/soc.h>
+#include <sound/tlv.h>
+
+#include "cs42888.h"
+
+#define CS42888_NUM_SUPPLIES 4
+static const char *cs42888_supply_names[CS42888_NUM_SUPPLIES] = {
+	"VA",
+	"VD",
+	"VLS",
+	"VLC",
+};
+
+#define CS42888_FORMATS	(SNDRV_PCM_FMTBIT_S16_LE | \
+			 SNDRV_PCM_FMTBIT_S20_3LE | \
+			 SNDRV_PCM_FMTBIT_S24_LE | \
+			 SNDRV_PCM_FMTBIT_S32_LE)
+
+/* codec private data */
+struct cs42888_priv {
+	struct regulator_bulk_data supplies[CS42888_NUM_SUPPLIES];
+	struct regmap *regmap;
+	struct clk *clk;
+
+	bool slave_mode;
+	unsigned long sysclk;
+};
+
+/* -127.5dB to 0dB with step of 0.5dB */
+static const DECLARE_TLV_DB_SCALE(dac_tlv, -12750, 50, 1);
+/* -64dB to 24dB with step of 0.5dB */
+static const DECLARE_TLV_DB_SCALE(adc_tlv, -6400, 50, 0);
+
+static const char *cs42888_adc_single[] = { "Differential", "Single-Ended" };
+static const char *cs42888_szc[] = { "Immediate Change", "Zero Cross",
+				     "Soft Ramp", "Soft Ramp on Zero Cross" };
+
+static const struct soc_enum cs42888_enum[] = {
+	SOC_ENUM_SINGLE(CS42888_ADCCTL, 4, 2, cs42888_adc_single),
+	SOC_ENUM_SINGLE(CS42888_ADCCTL, 3, 2, cs42888_adc_single),
+	SOC_ENUM_SINGLE(CS42888_TXCTL, 5, 4, cs42888_szc),
+	SOC_ENUM_SINGLE(CS42888_TXCTL, 0, 4, cs42888_szc),
+};
+
+static const struct snd_kcontrol_new cs42888_snd_controls[] = {
+	SOC_DOUBLE_R_TLV("DAC1 Playback Volume", CS42888_VOLAOUT1,
+			 CS42888_VOLAOUT2, 0, 0xff, 1, dac_tlv),
+	SOC_DOUBLE_R_TLV("DAC2 Playback Volume", CS42888_VOLAOUT3,
+			 CS42888_VOLAOUT4, 0, 0xff, 1, dac_tlv),
+	SOC_DOUBLE_R_TLV("DAC3 Playback Volume", CS42888_VOLAOUT5,
+			 CS42888_VOLAOUT6, 0, 0xff, 1, dac_tlv),
+	SOC_DOUBLE_R_TLV("DAC4 Playback Volume", CS42888_VOLAOUT7,
+			 CS42888_VOLAOUT8, 0, 0xff, 1, dac_tlv),
+	SOC_DOUBLE_R_S_TLV("ADC1 Capture Volume", CS42888_VOLAIN1,
+			   CS42888_VOLAIN2, 0, -0x80, 0x30, 7, 0, adc_tlv),
+	SOC_DOUBLE_R_S_TLV("ADC2 Capture Volume", CS42888_VOLAIN3,
+			   CS42888_VOLAIN4, 0, -0x80, 0x30, 7, 0, adc_tlv),
+	SOC_DOUBLE("DAC1 Invert Switch", CS42888_DACINV, 0, 1, 1, 0),
+	SOC_DOUBLE("DAC2 Invert Switch", CS42888_DACINV, 2, 3, 1, 0),
+	SOC_DOUBLE("DAC3 Invert Switch", CS42888_DACINV, 4, 5, 1, 0),
+	SOC_DOUBLE("DAC4 Invert Switch", CS42888_DACINV, 6, 7, 1, 0),
+	SOC_DOUBLE("ADC1 Invert Switch", CS42888_ADCINV, 0, 1, 1, 0),
+	SOC_DOUBLE("ADC2 Invert Switch", CS42888_ADCINV, 2, 3, 1, 0),
+	SOC_SINGLE("ADC High-Pass Filter Switch", CS42888_ADCCTL, 7, 1, 1),
+	SOC_SINGLE("DAC De-emphasis Switch", CS42888_ADCCTL, 5, 1, 0),
+	SOC_ENUM("ADC1 Single Ended Mode Switch", cs42888_enum[0]),
+	SOC_ENUM("ADC2 Single Ended Mode Switch", cs42888_enum[1]),
+	SOC_SINGLE("DAC Single Volume Control Switch", CS42888_TXCTL, 7, 1, 0),
+	SOC_ENUM("DAC Soft Ramp & Zero Cross Control Switch", cs42888_enum[2]),
+	SOC_SINGLE("DAC Auto Mute Switch", CS42888_TXCTL, 4, 1, 0),
+	SOC_SINGLE("Mute ADC Serial Port Switch", CS42888_TXCTL, 3, 1, 0),
+	SOC_SINGLE("ADC Single Volume Control Switch", CS42888_TXCTL, 2, 1, 0),
+	SOC_ENUM("ADC Soft Ramp & Zero Cross Control Switch", cs42888_enum[3]),
+};
+
+static const struct snd_soc_dapm_widget cs42888_dapm_widgets[] = {
+	SND_SOC_DAPM_DAC("DAC1", "Playback", CS42888_PWRCTL, 1, 1),
+	SND_SOC_DAPM_DAC("DAC2", "Playback", CS42888_PWRCTL, 2, 1),
+	SND_SOC_DAPM_DAC("DAC3", "Playback", CS42888_PWRCTL, 3, 1),
+	SND_SOC_DAPM_DAC("DAC4", "Playback", CS42888_PWRCTL, 4, 1),
+
+	SND_SOC_DAPM_OUTPUT("AOUT1L"),
+	SND_SOC_DAPM_OUTPUT("AOUT1R"),
+	SND_SOC_DAPM_OUTPUT("AOUT2L"),
+	SND_SOC_DAPM_OUTPUT("AOUT2R"),
+	SND_SOC_DAPM_OUTPUT("AOUT3L"),
+	SND_SOC_DAPM_OUTPUT("AOUT3R"),
+	SND_SOC_DAPM_OUTPUT("AOUT4L"),
+	SND_SOC_DAPM_OUTPUT("AOUT4R"),
+
+	SND_SOC_DAPM_ADC("ADC1", "Capture", CS42888_PWRCTL, 5, 1),
+	SND_SOC_DAPM_ADC("ADC2", "Capture", CS42888_PWRCTL, 6, 1),
+
+	SND_SOC_DAPM_INPUT("AIN1L"),
+	SND_SOC_DAPM_INPUT("AIN1R"),
+	SND_SOC_DAPM_INPUT("AIN2L"),
+	SND_SOC_DAPM_INPUT("AIN2R"),
+
+	SND_SOC_DAPM_SUPPLY("PWR", CS42888_PWRCTL, 0, 1, NULL, 0),
+};
+
+static const struct snd_soc_dapm_route cs42888_dapm_routes[] = {
+	/* Playback */
+	{ "AOUT1L", NULL, "DAC1" },
+	{ "AOUT1R", NULL, "DAC1" },
+	{ "DAC1", NULL, "PWR" },
+
+	{ "AOUT2L", NULL, "DAC2" },
+	{ "AOUT2R", NULL, "DAC2" },
+	{ "DAC2", NULL, "PWR" },
+
+	{ "AOUT3L", NULL, "DAC3" },
+	{ "AOUT3R", NULL, "DAC3" },
+	{ "DAC3", NULL, "PWR" },
+
+	{ "AOUT4L", NULL, "DAC4" },
+	{ "AOUT4R", NULL, "DAC4" },
+	{ "DAC4", NULL, "PWR" },
+
+	/* Capture */
+	{ "ADC1", NULL, "AIN1L" },
+	{ "ADC1", NULL, "AIN1R" },
+	{ "ADC1", NULL, "PWR" },
+
+	{ "ADC2", NULL, "AIN2L" },
+	{ "ADC2", NULL, "AIN2R" },
+	{ "ADC2", NULL, "PWR" },
+};
+
+struct cs42888_ratios {
+	unsigned int ratio;
+	unsigned char speed;
+	unsigned char mclk;
+};
+
+static struct cs42888_ratios cs42888_ratios[] = {
+	{ 64, CS42888_FM_QUAD, CS42888_FUNCMOD_MFREQ_256(4) },
+	{ 96, CS42888_FM_QUAD, CS42888_FUNCMOD_MFREQ_384(4) },
+	{ 128, CS42888_FM_QUAD, CS42888_FUNCMOD_MFREQ_512(4) },
+	{ 192, CS42888_FM_QUAD, CS42888_FUNCMOD_MFREQ_768(4) },
+	{ 256, CS42888_FM_SINGLE, CS42888_FUNCMOD_MFREQ_256(1) },
+	{ 384, CS42888_FM_SINGLE, CS42888_FUNCMOD_MFREQ_384(1) },
+	{ 512, CS42888_FM_SINGLE, CS42888_FUNCMOD_MFREQ_512(1) },
+	{ 768, CS42888_FM_SINGLE, CS42888_FUNCMOD_MFREQ_768(1) },
+	{ 1024, CS42888_FM_SINGLE, CS42888_FUNCMOD_MFREQ_1024(1) }
+};
+
+static int cs42888_set_dai_sysclk(struct snd_soc_dai *codec_dai,
+				  int clk_id, unsigned int freq, int dir)
+{
+	struct snd_soc_codec *codec = codec_dai->codec;
+	struct cs42888_priv *cs42888 = snd_soc_codec_get_drvdata(codec);
+
+	cs42888->sysclk = freq;
+
+	return 0;
+}
+
+static int cs42888_set_dai_fmt(struct snd_soc_dai *codec_dai,
+			      unsigned int format)
+{
+	struct snd_soc_codec *codec = codec_dai->codec;
+	struct cs42888_priv *cs42888 = snd_soc_codec_get_drvdata(codec);
+	u32 val;
+
+	/* Set DAI format */
+	switch (format & SND_SOC_DAIFMT_FORMAT_MASK) {
+	case SND_SOC_DAIFMT_LEFT_J:
+		val = CS42888_INTF_DAC_DIF_LEFTJ | CS42888_INTF_ADC_DIF_LEFTJ;
+		break;
+	case SND_SOC_DAIFMT_I2S:
+		val = CS42888_INTF_DAC_DIF_I2S | CS42888_INTF_ADC_DIF_I2S;
+		break;
+	case SND_SOC_DAIFMT_RIGHT_J:
+		val = CS42888_INTF_DAC_DIF_RIGHTJ | CS42888_INTF_ADC_DIF_RIGHTJ;
+		break;
+	default:
+		dev_err(codec->dev, "unsupported dai format\n");
+		return -EINVAL;
+	}
+
+	regmap_update_bits(cs42888->regmap, CS42888_INTF,
+			   CS42888_INTF_DAC_DIF_MASK |
+			   CS42888_INTF_ADC_DIF_MASK, val);
+
+	/* Set master/slave audio interface */
+	switch (format & SND_SOC_DAIFMT_MASTER_MASK) {
+	case SND_SOC_DAIFMT_CBS_CFS:
+		cs42888->slave_mode = true;
+		break;
+	case SND_SOC_DAIFMT_CBM_CFM:
+		cs42888->slave_mode = false;
+		break;
+	default:
+		dev_err(codec->dev, "unsupported master/slave mode\n");
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static int cs42888_hw_params(struct snd_pcm_substream *substream,
+			     struct snd_pcm_hw_params *params,
+			     struct snd_soc_dai *dai)
+{
+	struct snd_soc_pcm_runtime *rtd = substream->private_data;
+	struct snd_soc_codec *codec = rtd->codec;
+	struct cs42888_priv *cs42888 = snd_soc_codec_get_drvdata(codec);
+	bool tx = substream->stream == SNDRV_PCM_STREAM_PLAYBACK;
+	u32 ratio = cs42888->sysclk / params_rate(params);
+	u32 i, fm, val, mask;
+
+	for (i = 0; i < ARRAY_SIZE(cs42888_ratios); i++) {
+		if (cs42888_ratios[i].ratio == ratio)
+			break;
+	}
+
+	if (i == ARRAY_SIZE(cs42888_ratios)) {
+		dev_err(codec->dev, "unsupported sysclk ratio\n");
+		return -EINVAL;
+	}
+
+	mask = CS42888_FUNCMOD_MFREQ_MASK;
+	val = cs42888_ratios[i].mclk;
+
+	fm = cs42888->slave_mode ? CS42888_FM_AUTO : cs42888_ratios[i].speed;
+
+	regmap_update_bits(cs42888->regmap, CS42888_FUNCMOD,
+			   CS42888_FUNCMOD_xC_FM_MASK(tx) | mask,
+			   CS42888_FUNCMOD_xC_FM(tx, fm) | val);
+
+	return 0;
+}
+
+static int cs42888_digital_mute(struct snd_soc_dai *dai, int mute)
+{
+	struct snd_soc_codec *codec = dai->codec;
+	struct cs42888_priv *cs42888 = snd_soc_codec_get_drvdata(codec);
+
+	regmap_update_bits(cs42888->regmap, CS42888_DACMUTE,
+			   CS42888_DACMUTE_ALL, mute ? CS42888_DACMUTE_ALL : 0);
+
+	return 0;
+}
+
+static struct snd_soc_dai_ops cs42888_dai_ops = {
+	.set_fmt	= cs42888_set_dai_fmt,
+	.set_sysclk	= cs42888_set_dai_sysclk,
+	.hw_params	= cs42888_hw_params,
+	.digital_mute	= cs42888_digital_mute,
+};
+
+static struct snd_soc_dai_driver cs42888_dai = {
+	.name = "cs42888",
+	.playback = {
+		.stream_name = "Playback",
+		.channels_min = 1,
+		.channels_max = 8,
+		.rates = SNDRV_PCM_RATE_8000_192000,
+		.formats = CS42888_FORMATS,
+	},
+	.capture = {
+		.stream_name = "Capture",
+		.channels_min = 1,
+		.channels_max = 4,
+		.rates = SNDRV_PCM_RATE_8000_192000,
+		.formats = CS42888_FORMATS,
+	},
+	.ops = &cs42888_dai_ops,
+};
+
+static struct reg_default cs42888_reg[] = {
+	{ 0x01, 0x01 },   /* Chip I.D. and Revision Register */
+	{ 0x02, 0x00 },   /* Power Control */
+	{ 0x03, 0xF0 },   /* Functional Mode */
+	{ 0x04, 0x46 },   /* Interface Formats */
+	{ 0x05, 0x00 },   /* ADC Control & DAC De-Emphasis */
+	{ 0x06, 0x10 },   /* Transition Control */
+	{ 0x07, 0x00 },   /* DAC Channel Mute */
+	{ 0x08, 0x00 },   /* Volume Control AOUT1 */
+	{ 0x09, 0x00 },   /* Volume Control AOUT2 */
+	{ 0x0a, 0x00 },   /* Volume Control AOUT3 */
+	{ 0x0b, 0x00 },   /* Volume Control AOUT4 */
+	{ 0x0c, 0x00 },   /* Volume Control AOUT5 */
+	{ 0x0d, 0x00 },   /* Volume Control AOUT6 */
+	{ 0x0e, 0x00 },   /* Volume Control AOUT7 */
+	{ 0x0f, 0x00 },   /* Volume Control AOUT8 */
+	{ 0x10, 0x00 },   /* DAC Channel Invert */
+	{ 0x11, 0x00 },   /* Volume Control AIN1 */
+	{ 0x12, 0x00 },   /* Volume Control AIN2 */
+	{ 0x13, 0x00 },   /* Volume Control AIN3 */
+	{ 0x14, 0x00 },   /* Volume Control AIN4 */
+	{ 0x17, 0x00 },   /* ADC Channel Invert */
+	{ 0x18, 0x00 },   /* Status Control */
+	{ 0x1a, 0x00 },   /* Status Mask */
+	{ 0x1b, 0x00 },   /* MUTEC Pin Control */
+};
+
+static bool cs42888_volatile_register(struct device *dev, unsigned int reg)
+{
+	switch (reg) {
+	case CS42888_STATUS:
+		return true;
+	default:
+		return false;
+	}
+}
+
+static bool cs42888_writeable_register(struct device *dev, unsigned int reg)
+{
+	switch (reg) {
+	case CS42888_CHIPID:
+	case CS42888_STATUS:
+		return false;
+	default:
+		return true;
+	}
+}
+
+static const struct regmap_config cs42888_regmap = {
+	.reg_bits = 8,
+	.val_bits = 8,
+
+	.max_register = CS42888_LASTREG,
+	.reg_defaults = cs42888_reg,
+	.num_reg_defaults = ARRAY_SIZE(cs42888_reg),
+	.volatile_reg = cs42888_volatile_register,
+	.writeable_reg = cs42888_writeable_register,
+	.cache_type = REGCACHE_RBTREE,
+};
+
+static int cs42888_probe(struct snd_soc_codec *codec)
+{
+	struct cs42888_priv *cs42888 = snd_soc_codec_get_drvdata(codec);
+
+	/* Disable auto-mute */
+	regmap_update_bits(cs42888->regmap, CS42888_TXCTL,
+			   CS42888_TXCTL_AMUTE | CS42888_TXCTL_DAC_SZC_MASK,
+			   CS42888_TXCTL_DAC_SZC_SR);
+
+	/* Mute all DAC channels */
+	regmap_write(cs42888->regmap, CS42888_DACMUTE, CS42888_DACMUTE_ALL);
+
+	return 0;
+}
+
+static struct snd_soc_codec_driver cs42888_driver = {
+	.probe = cs42888_probe,
+	.idle_bias_off = true,
+
+	.controls = cs42888_snd_controls,
+	.num_controls = ARRAY_SIZE(cs42888_snd_controls),
+	.dapm_widgets = cs42888_dapm_widgets,
+	.num_dapm_widgets = ARRAY_SIZE(cs42888_dapm_widgets),
+	.dapm_routes = cs42888_dapm_routes,
+	.num_dapm_routes = ARRAY_SIZE(cs42888_dapm_routes),
+};
+
+static int cs42888_i2c_probe(struct i2c_client *i2c,
+			     const struct i2c_device_id *id)
+{
+	struct cs42888_priv *cs42888;
+	int ret, val, i;
+
+	cs42888 = devm_kzalloc(&i2c->dev, sizeof(*cs42888), GFP_KERNEL);
+	if (cs42888 == NULL)
+		return -ENOMEM;
+
+	i2c_set_clientdata(i2c, cs42888);
+
+	cs42888->clk = devm_clk_get(&i2c->dev, "mclk");
+	if (IS_ERR(cs42888->clk))
+		dev_warn(&i2c->dev, "failed to get the clock: %ld\n",
+				PTR_ERR(cs42888->clk));
+	else
+		cs42888->sysclk = clk_get_rate(cs42888->clk);
+
+	for (i = 0; i < ARRAY_SIZE(cs42888->supplies); i++)
+		cs42888->supplies[i].supply = cs42888_supply_names[i];
+
+	ret = devm_regulator_bulk_get(&i2c->dev,
+			ARRAY_SIZE(cs42888->supplies), cs42888->supplies);
+	if (ret) {
+		dev_err(&i2c->dev, "failed to request supplies: %d\n",	ret);
+		return ret;
+	}
+
+	ret = regulator_bulk_enable(ARRAY_SIZE(cs42888->supplies),
+				    cs42888->supplies);
+	if (ret) {
+		dev_err(&i2c->dev, "failed to enable supplies: %d\n", ret);
+		return ret;
+	}
+
+	/* Make sure hardware reset done */
+	msleep(5);
+
+	cs42888->regmap = devm_regmap_init_i2c(i2c, &cs42888_regmap);
+	if (IS_ERR(cs42888->regmap)) {
+		ret = PTR_ERR(cs42888->regmap);
+		dev_err(&i2c->dev, "failed to allocate regmap: %d\n", ret);
+		goto err_enable;
+	}
+
+	/*
+	 * We haven't marked the chip revision as volatile due to
+	 * sharing a register with the right input volume; explicitly
+	 * bypass the cache to read it.
+	 */
+	regcache_cache_bypass(cs42888->regmap, true);
+
+	/* Validate the chip ID */
+	regmap_read(cs42888->regmap, CS42888_CHIPID, &val);
+	if (val < 0) {
+		dev_err(&i2c->dev, "failed to get device ID: %x", val);
+		ret = -EINVAL;
+		goto err_enable;
+	}
+
+	/* The top four bits of the chip ID should be 0000 */
+	if ((val & CS42888_CHIPID_CHIP_ID_MASK) != 0x00) {
+		dev_err(&i2c->dev, "unmatched chip ID: %d\n",
+				val & CS42888_CHIPID_CHIP_ID_MASK);
+		ret = -EINVAL;
+		goto err_enable;
+	}
+
+	dev_info(&i2c->dev, "found device at %X, revision %X\n",
+			i2c->addr, val & CS42888_CHIPID_REV_ID_MASK);
+
+	regcache_cache_bypass(cs42888->regmap, false);
+
+	pm_runtime_enable(&i2c->dev);
+	pm_request_idle(&i2c->dev);
+
+	ret = snd_soc_register_codec(&i2c->dev, &cs42888_driver, &cs42888_dai, 1);
+	if (ret) {
+		dev_err(&i2c->dev, "failed to register codec:%d\n", ret);
+		goto err_enable;
+	}
+
+	regcache_cache_only(cs42888->regmap, true);
+
+err_enable:
+	regulator_bulk_disable(ARRAY_SIZE(cs42888->supplies), cs42888->supplies);
+
+	return ret;
+}
+
+static int cs42888_i2c_remove(struct i2c_client *i2c_client)
+{
+	snd_soc_unregister_codec(&i2c_client->dev);
+	return 0;
+}
+
+#ifdef CONFIG_PM_RUNTIME
+static int cs42888_runtime_resume(struct device *dev)
+{
+	struct cs42888_priv *cs42888 = dev_get_drvdata(dev);
+	int ret;
+
+	if (!IS_ERR(cs42888->clk))
+		clk_prepare_enable(cs42888->clk);
+
+	ret = regulator_bulk_enable(ARRAY_SIZE(cs42888->supplies),
+				    cs42888->supplies);
+	if (ret) {
+		dev_err(dev, "failed to enable supplies: %d\n", ret);
+		return ret;
+	}
+
+	/*
+	 * In case the device was put to hard reset during sleep,
+	 * we need to wait 500ns here before any I2C communication
+	 */
+	mdelay(5);
+
+	regcache_cache_only(cs42888->regmap, false);
+
+	regcache_sync(cs42888->regmap);
+
+	return 0;
+}
+
+static int cs42888_runtime_suspend(struct device *dev)
+{
+	struct cs42888_priv *cs42888 = dev_get_drvdata(dev);
+
+	regcache_cache_only(cs42888->regmap, true);
+
+	regulator_bulk_disable(ARRAY_SIZE(cs42888->supplies),
+			       cs42888->supplies);
+
+	if (!IS_ERR(cs42888->clk))
+		clk_disable_unprepare(cs42888->clk);
+
+	return 0;
+}
+#endif
+
+static const struct dev_pm_ops cs42888_pm = {
+	SET_RUNTIME_PM_OPS(cs42888_runtime_suspend, cs42888_runtime_resume, NULL)
+};
+
+static struct i2c_device_id cs42888_i2c_id[] = {
+	{"cs42888", 0},
+	{}
+};
+MODULE_DEVICE_TABLE(i2c, cs42888_i2c_id);
+
+static const struct of_device_id cs42888_of_match[] = {
+	{ .compatible = "cirrus,cs42888", },
+	{ /* sentinel */ }
+};
+MODULE_DEVICE_TABLE(of, cs42888_of_match);
+
+static struct i2c_driver cs42888_i2c_driver = {
+	.driver = {
+		.name = "cs42888",
+		.owner = THIS_MODULE,
+		.of_match_table = cs42888_of_match,
+		.pm = &cs42888_pm,
+	},
+	.probe = cs42888_i2c_probe,
+	.remove = cs42888_i2c_remove,
+	.id_table = cs42888_i2c_id,
+};
+
+module_i2c_driver(cs42888_i2c_driver);
+
+MODULE_DESCRIPTION("Cirrus Logic CS42888 ALSA SoC Codec Driver");
+MODULE_AUTHOR("Freescale Semiconductor, Inc.");
+MODULE_LICENSE("GPL");
diff --git a/sound/soc/codecs/cs42888.h b/sound/soc/codecs/cs42888.h
new file mode 100644
index 0000000..6d2cdec
--- /dev/null
+++ b/sound/soc/codecs/cs42888.h
@@ -0,0 +1,209 @@
+/*
+ * cs42888.h - Cirrus Logic CS42888 Audio CODEC driver header file
+ *
+ * Copyright (C) 2014 Freescale Semiconductor, Inc.
+ *
+ * Author: Nicolin Chen <Guangyu.Chen@freescale.com>
+ *
+ * This file is licensed under the terms of the GNU General Public License
+ * version 2. This program is licensed "as is" without any warranty of any
+ * kind, whether express or implied.
+ */
+
+#ifndef _CS42888_H
+#define _CS42888_H
+
+/* CS42888 register map */
+#define CS42888_CHIPID				0x01	/* Chip ID */
+#define CS42888_PWRCTL				0x02	/* Power Control */
+#define CS42888_FUNCMOD				0x03	/* Functional Mode */
+#define CS42888_INTF				0x04	/* Interface Formats */
+#define CS42888_ADCCTL				0x05	/* ADC Control */
+#define CS42888_TXCTL				0x06	/* Transition Control */
+#define CS42888_DACMUTE				0x07	/* DAC Mute Control */
+#define CS42888_VOLAOUT1			0x08	/* Volume Control AOUT1 */
+#define CS42888_VOLAOUT2			0x09	/* Volume Control AOUT2 */
+#define CS42888_VOLAOUT3			0x0A	/* Volume Control AOUT3 */
+#define CS42888_VOLAOUT4			0x0B	/* Volume Control AOUT4 */
+#define CS42888_VOLAOUT5			0x0C	/* Volume Control AOUT5 */
+#define CS42888_VOLAOUT6			0x0D	/* Volume Control AOUT6 */
+#define CS42888_VOLAOUT7			0x0E	/* Volume Control AOUT7 */
+#define CS42888_VOLAOUT8			0x0F	/* Volume Control AOUT8 */
+#define CS42888_DACINV				0x10	/* DAC Channel Invert */
+#define CS42888_VOLAIN1				0x11	/* Volume Control AIN1 */
+#define CS42888_VOLAIN2				0x12	/* Volume Control AIN2 */
+#define CS42888_VOLAIN3				0x13	/* Volume Control AIN3 */
+#define CS42888_VOLAIN4				0x14	/* Volume Control AIN4 */
+#define CS42888_ADCINV				0x17	/* ADC Channel Invert */
+#define CS42888_STATUSCTL			0x18	/* Status Control */
+#define CS42888_STATUS				0x19	/* Status */
+#define CS42888_STATUSM				0x1A	/* Status Mask */
+#define CS42888_MUTEC				0x1B	/* MUTEC Pin Control */
+
+#define CS42888_FIRSTREG			CS42888_CHIPID
+#define CS42888_LASTREG				CS42888_MUTEC
+#define CS42888_NUMREGS				(CS42888_LASTREG - CS42888_FIRSTREG + 1)
+#define CS42888_I2C_INCR			0x80
+
+/* Chip I.D. and Revision Register (Address 01h) */
+#define CS42888_CHIPID_CHIP_ID_MASK		0xF0
+#define CS42888_CHIPID_REV_ID_MASK		0x0F
+
+/* Power Control (Address 02h) */
+#define CS42888_PWRCTL_PDN_ADC2_SHIFT		6
+#define CS42888_PWRCTL_PDN_ADC2_MASK		(1 << CS42888_PWRCTL_PDN_ADC2_SHIFT)
+#define CS42888_PWRCTL_PDN_ADC2			(1 << CS42888_PWRCTL_PDN_ADC2_SHIFT)
+#define CS42888_PWRCTL_PDN_ADC1_SHIFT		5
+#define CS42888_PWRCTL_PDN_ADC1_MASK		(1 << CS42888_PWRCTL_PDN_ADC1_SHIFT)
+#define CS42888_PWRCTL_PDN_ADC1			(1 << CS42888_PWRCTL_PDN_ADC1_SHIFT)
+#define CS42888_PWRCTL_PDN_DAC4_SHIFT		4
+#define CS42888_PWRCTL_PDN_DAC4_MASK		(1 << CS42888_PWRCTL_PDN_DAC4_SHIFT)
+#define CS42888_PWRCTL_PDN_DAC4			(1 << CS42888_PWRCTL_PDN_DAC4_SHIFT)
+#define CS42888_PWRCTL_PDN_DAC3_SHIFT		3
+#define CS42888_PWRCTL_PDN_DAC3_MASK		(1 << CS42888_PWRCTL_PDN_DAC3_SHIFT)
+#define CS42888_PWRCTL_PDN_DAC3			(1 << CS42888_PWRCTL_PDN_DAC3_SHIFT)
+#define CS42888_PWRCTL_PDN_DAC2_SHIFT		2
+#define CS42888_PWRCTL_PDN_DAC2_MASK		(1 << CS42888_PWRCTL_PDN_DAC2_SHIFT)
+#define CS42888_PWRCTL_PDN_DAC2			(1 << CS42888_PWRCTL_PDN_DAC2_SHIFT)
+#define CS42888_PWRCTL_PDN_DAC1_SHIFT		1
+#define CS42888_PWRCTL_PDN_DAC1_MASK		(1 << CS42888_PWRCTL_PDN_DAC1_SHIFT)
+#define CS42888_PWRCTL_PDN_DAC1			(1 << CS42888_PWRCTL_PDN_DAC1_SHIFT)
+#define CS42888_PWRCTL_PDN_SHIFT		0
+#define CS42888_PWRCTL_PDN_MASK			(1 << CS42888_PWRCTL_PDN_SHIFT)
+#define CS42888_PWRCTL_PDN			(1 << CS42888_PWRCTL_PDN_SHIFT)
+
+/* Functional Mode (Address 03h) */
+#define CS42888_FUNCMOD_DAC_FM_SHIFT		6
+#define CS42888_FUNCMOD_DAC_FM_WIDTH		2
+#define CS42888_FUNCMOD_DAC_FM_MASK		(((1 << CS42888_FUNCMOD_DAC_FM_WIDTH) - 1) << CS42888_FUNCMOD_DAC_FM_SHIFT)
+#define CS42888_FUNCMOD_DAC_FM(v)		((v) << CS42888_FUNCMOD_DAC_FM_SHIFT)
+#define CS42888_FUNCMOD_ADC_FM_SHIFT		4
+#define CS42888_FUNCMOD_ADC_FM_WIDTH		2
+#define CS42888_FUNCMOD_ADC_FM_MASK		(((1 << CS42888_FUNCMOD_ADC_FM_WIDTH) - 1) << CS42888_FUNCMOD_ADC_FM_SHIFT)
+#define CS42888_FUNCMOD_ADC_FM(v)		((v) << CS42888_FUNCMOD_ADC_FM_SHIFT)
+#define CS42888_FUNCMOD_xC_FM_MASK(x)		((x) ? CS42888_FUNCMOD_DAC_FM_MASK : CS42888_FUNCMOD_ADC_FM_MASK)
+#define CS42888_FUNCMOD_xC_FM(x, v)		((x) ? CS42888_FUNCMOD_DAC_FM(v) : CS42888_FUNCMOD_ADC_FM(v))
+#define CS42888_FUNCMOD_MFREQ_SHIFT		1
+#define CS42888_FUNCMOD_MFREQ_WIDTH		3
+#define CS42888_FUNCMOD_MFREQ_MASK		(((1 << CS42888_FUNCMOD_MFREQ_WIDTH) - 1) << CS42888_FUNCMOD_MFREQ_SHIFT)
+#define CS42888_FUNCMOD_MFREQ_256(s)		((0 << CS42888_FUNCMOD_MFREQ_SHIFT) >> (s >> 1))
+#define CS42888_FUNCMOD_MFREQ_384(s)		((1 << CS42888_FUNCMOD_MFREQ_SHIFT) >> (s >> 1))
+#define CS42888_FUNCMOD_MFREQ_512(s)		((2 << CS42888_FUNCMOD_MFREQ_SHIFT) >> (s >> 1))
+#define CS42888_FUNCMOD_MFREQ_768(s)		((3 << CS42888_FUNCMOD_MFREQ_SHIFT) >> (s >> 1))
+#define CS42888_FUNCMOD_MFREQ_1024(s)		((4 << CS42888_FUNCMOD_MFREQ_SHIFT) >> (s >> 1))
+
+#define CS42888_FM_SINGLE			0
+#define CS42888_FM_DOUBLE			1
+#define CS42888_FM_QUAD				2
+#define CS42888_FM_AUTO				3
+
+/* Interface Formats (Address 04h) */
+#define CS42888_INTF_FREEZE_SHIFT		7
+#define CS42888_INTF_FREEZE_MASK		(1 << CS42888_INTF_FREEZE_SHIFT)
+#define CS42888_INTF_FREEZE			(1 << CS42888_INTF_FREEZE_SHIFT)
+#define CS42888_INTF_AUX_DIF_SHIFT		6
+#define CS42888_INTF_AUX_DIF_MASK		(1 << CS42888_INTF_AUX_DIF_SHIFT)
+#define CS42888_INTF_AUX_DIF			(1 << CS42888_INTF_AUX_DIF_SHIFT)
+#define CS42888_INTF_DAC_DIF_SHIFT		3
+#define CS42888_INTF_DAC_DIF_WIDTH		3
+#define CS42888_INTF_DAC_DIF_MASK		(((1 << CS42888_INTF_DAC_DIF_WIDTH) - 1) << CS42888_INTF_DAC_DIF_SHIFT)
+#define CS42888_INTF_DAC_DIF_LEFTJ		(0 << CS42888_INTF_DAC_DIF_SHIFT)
+#define CS42888_INTF_DAC_DIF_I2S		(1 << CS42888_INTF_DAC_DIF_SHIFT)
+#define CS42888_INTF_DAC_DIF_RIGHTJ		(2 << CS42888_INTF_DAC_DIF_SHIFT)
+#define CS42888_INTF_DAC_DIF_RIGHTJ_16		(3 << CS42888_INTF_DAC_DIF_SHIFT)
+#define CS42888_INTF_DAC_DIF_ONELINE_20		(4 << CS42888_INTF_DAC_DIF_SHIFT)
+#define CS42888_INTF_DAC_DIF_ONELINE_24		(6 << CS42888_INTF_DAC_DIF_SHIFT)
+#define CS42888_INTF_DAC_DIF_TDM		(7 << CS42888_INTF_DAC_DIF_SHIFT)
+#define CS42888_INTF_ADC_DIF_SHIFT		0
+#define CS42888_INTF_ADC_DIF_WIDTH		3
+#define CS42888_INTF_ADC_DIF_MASK		(((1 << CS42888_INTF_ADC_DIF_WIDTH) - 1) << CS42888_INTF_ADC_DIF_SHIFT)
+#define CS42888_INTF_ADC_DIF_LEFTJ		(0 << CS42888_INTF_ADC_DIF_SHIFT)
+#define CS42888_INTF_ADC_DIF_I2S		(1 << CS42888_INTF_ADC_DIF_SHIFT)
+#define CS42888_INTF_ADC_DIF_RIGHTJ		(2 << CS42888_INTF_ADC_DIF_SHIFT)
+#define CS42888_INTF_ADC_DIF_RIGHTJ_16		(3 << CS42888_INTF_ADC_DIF_SHIFT)
+#define CS42888_INTF_ADC_DIF_ONELINE_20		(4 << CS42888_INTF_ADC_DIF_SHIFT)
+#define CS42888_INTF_ADC_DIF_ONELINE_24		(6 << CS42888_INTF_ADC_DIF_SHIFT)
+#define CS42888_INTF_ADC_DIF_TDM		(7 << CS42888_INTF_ADC_DIF_SHIFT)
+
+/* ADC Control & DAC De-Emphasis (Address 05h) */
+#define CS42888_ADCCTL_ADC_HPF_FREEZE_SHIFT	7
+#define CS42888_ADCCTL_ADC_HPF_FREEZE_MASK	(1 << CS42888_ADCCTL_ADC_HPF_FREEZE_SHIFT)
+#define CS42888_ADCCTL_ADC_HPF_FREEZE		(1 << CS42888_ADCCTL_ADC_HPF_FREEZE_SHIFT)
+#define CS42888_ADCCTL_DAC_DEM_SHIFT		5
+#define CS42888_ADCCTL_DAC_DEM_MASK		(1 << CS42888_ADCCTL_DAC_DEM_SHIFT)
+#define CS42888_ADCCTL_DAC_DEM			(1 << CS42888_ADCCTL_DAC_DEM_SHIFT)
+#define CS42888_ADCCTL_ADC1_SINGLE_SHIFT	4
+#define CS42888_ADCCTL_ADC1_SINGLE_MASK		(1 << CS42888_ADCCTL_ADC1_SINGLE_SHIFT)
+#define CS42888_ADCCTL_ADC1_SINGLE		(1 << CS42888_ADCCTL_ADC1_SINGLE_SHIFT)
+#define CS42888_ADCCTL_ADC2_SINGLE_SHIFT	3
+#define CS42888_ADCCTL_ADC2_SINGLE_MASK		(1 << CS42888_ADCCTL_ADC2_SINGLE_SHIFT)
+#define CS42888_ADCCTL_ADC2_SINGLE		(1 << CS42888_ADCCTL_ADC2_SINGLE_SHIFT)
+
+/* Transition Control (Address 06h) */
+#define CS42888_TXCTL_DAC_SNGVOL_SHIFT		7
+#define CS42888_TXCTL_DAC_SNGVOL_MASK		(1 << CS42888_TXCTL_DAC_SNGVOL_SHIFT)
+#define CS42888_TXCTL_DAC_SNGVOL		(1 << CS42888_TXCTL_DAC_SNGVOL_SHIFT)
+#define CS42888_TXCTL_DAC_SZC_SHIFT		5
+#define CS42888_TXCTL_DAC_SZC_WIDTH		2
+#define CS42888_TXCTL_DAC_SZC_MASK		(((1 << CS42888_TXCTL_DAC_SZC_WIDTH) - 1) << CS42888_TXCTL_DAC_SZC_SHIFT)
+#define CS42888_TXCTL_DAC_SZC_IC		(0 << CS42888_TXCTL_DAC_SZC_SHIFT)
+#define CS42888_TXCTL_DAC_SZC_ZC		(1 << CS42888_TXCTL_DAC_SZC_SHIFT)
+#define CS42888_TXCTL_DAC_SZC_SR		(2 << CS42888_TXCTL_DAC_SZC_SHIFT)
+#define CS42888_TXCTL_DAC_SZC_SRZC		(3 << CS42888_TXCTL_DAC_SZC_SHIFT)
+#define CS42888_TXCTL_AMUTE_SHIFT		4
+#define CS42888_TXCTL_AMUTE_MASK		(1 << CS42888_TXCTL_AMUTE_SHIFT)
+#define CS42888_TXCTL_AMUTE			(1 << CS42888_TXCTL_AMUTE_SHIFT)
+#define CS42888_TXCTL_MUTE_ADC_SP_SHIFT		3
+#define CS42888_TXCTL_MUTE_ADC_SP_MASK		(1 << CS42888_TXCTL_MUTE_ADC_SP_SHIFT)
+#define CS42888_TXCTL_MUTE_ADC_SP		(1 << CS42888_TXCTL_MUTE_ADC_SP_SHIFT)
+#define CS42888_TXCTL_ADC_SNGVOL_SHIFT		2
+#define CS42888_TXCTL_ADC_SNGVOL_MASK		(1 << CS42888_TXCTL_ADC_SNGVOL_SHIFT)
+#define CS42888_TXCTL_ADC_SNGVOL		(1 << CS42888_TXCTL_ADC_SNGVOL_SHIFT)
+#define CS42888_TXCTL_ADC_SZC_SHIFT		0
+#define CS42888_TXCTL_ADC_SZC_MASK		(((1 << CS42888_TXCTL_ADC_SZC_WIDTH) - 1) << CS42888_TXCTL_ADC_SZC_SHIFT)
+#define CS42888_TXCTL_ADC_SZC_IC		(0 << CS42888_TXCTL_ADC_SZC_SHIFT)
+#define CS42888_TXCTL_ADC_SZC_ZC		(1 << CS42888_TXCTL_ADC_SZC_SHIFT)
+#define CS42888_TXCTL_ADC_SZC_SR		(2 << CS42888_TXCTL_ADC_SZC_SHIFT)
+#define CS42888_TXCTL_ADC_SZC_SRZC		(3 << CS42888_TXCTL_ADC_SZC_SHIFT)
+
+/* DAC Channel Mute (Address 07h) */
+#define CS42888_DACMUTE_AOUT(n)			(0x1 << n)
+#define CS42888_DACMUTE_ALL			0xff
+
+/* Status Control (Address 18h)*/
+#define CS42888_STATUSCTL_INI_SHIFT		2
+#define CS42888_STATUSCTL_INI_WIDTH		2
+#define CS42888_STATUSCTL_INI_MASK		(((1 << CS42888_STATUSCTL_INI_WIDTH) - 1) << CS42888_STATUSCTL_INI_SHIFT)
+#define CS42888_STATUSCTL_INT_ACTIVE_HIGH	(0 << CS42888_STATUSCTL_INI_SHIFT)
+#define CS42888_STATUSCTL_INT_ACTIVE_LOW	(1 << CS42888_STATUSCTL_INI_SHIFT)
+#define CS42888_STATUSCTL_INT_OPEN_DRAIN	(2 << CS42888_STATUSCTL_INI_SHIFT)
+
+/* Status (Address 19h)*/
+#define CS42888_STATUS_DAC_CLK_ERR_SHIFT	4
+#define CS42888_STATUS_DAC_CLK_ERR_MASK		(1 << CS42888_STATUS_DAC_CLK_ERR_SHIFT)
+#define CS42888_STATUS_ADC_CLK_ERR_SHIFT	3
+#define CS42888_STATUS_ADC_CLK_ERR_MASK		(1 << CS42888_STATUS_ADC_CLK_ERR_SHIFT)
+#define CS42888_STATUS_ADC2_OVFL_SHIFT		1
+#define CS42888_STATUS_ADC2_OVFL_MASK		(1 << CS42888_STATUS_ADC2_OVFL_SHIFT)
+#define CS42888_STATUS_ADC1_OVFL_SHIFT		0
+#define CS42888_STATUS_ADC1_OVFL_MASK		(1 << CS42888_STATUS_ADC1_OVFL_SHIFT)
+
+/* Status Mask (Address 1Ah) */
+#define CS42888_STATUS_DAC_CLK_ERR_M_SHIFT	4
+#define CS42888_STATUS_DAC_CLK_ERR_M_MASK	(1 << CS42888_STATUS_DAC_CLK_ERR_M_SHIFT)
+#define CS42888_STATUS_ADC_CLK_ERR_M_SHIFT	3
+#define CS42888_STATUS_ADC_CLK_ERR_M_MASK	(1 << CS42888_STATUS_ADC_CLK_ERR_M_SHIFT)
+#define CS42888_STATUS_ADC2_OVFL_M_SHIFT	1
+#define CS42888_STATUS_ADC2_OVFL_M_MASK		(1 << CS42888_STATUS_ADC2_OVFL_M_SHIFT)
+#define CS42888_STATUS_ADC1_OVFL_M_SHIFT	0
+#define CS42888_STATUS_ADC1_OVFL_M_MASK		(1 << CS42888_STATUS_ADC1_OVFL_M_SHIFT)
+
+/* MUTEC Pin Control (Address 1Bh) */
+#define CS42888_MUTEC_MCPOLARITY_SHIFT		1
+#define CS42888_MUTEC_MCPOLARITY_MASK		(1 << CS42888_MUTEC_MCPOLARITY_SHIFT)
+#define CS42888_MUTEC_MCPOLARITY_ACTIVE_LOW	(0 << CS42888_MUTEC_MCPOLARITY_SHIFT)
+#define CS42888_MUTEC_MCPOLARITY_ACTIVE_HIGH	(1 << CS42888_MUTEC_MCPOLARITY_SHIFT)
+#define CS42888_MUTEC_MUTEC_ACTIVE_SHIFT	0
+#define CS42888_MUTEC_MUTEC_ACTIVE_MASK		(1 << CS42888_MUTEC_MUTEC_ACTIVE_SHIFT)
+#define CS42888_MUTEC_MUTEC_ACTIVE		(1 << CS42888_MUTEC_MUTEC_ACTIVE_SHIFT)
+#endif /* _CS42888_H */
-- 
1.8.4


