Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754565AbaGKPpD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 11:45:03 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:49936 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753503AbaGKPo6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 11:44:58 -0400
From: Dan Murphy <dmurphy@ti.com>
To: <linux-sound@vger.kernel.org>
CC: <linux-kernel@vger.kernel.org>, <alsa-devel@alsa-project.org>,
        <devicetree@vger.kernel.org>, <broonie@kernel.org>,
        Dan Murphy <dmurphy@ti.com>
Subject: [PATCH v6] ASoC: tas2552: Support TI TAS2552 Amplifier
Date: Fri, 11 Jul 2014 10:44:49 -0500
Message-ID: <1405093489-11897-1-git-send-email-dmurphy@ti.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Support the TI TAS2552 Class D amplifier.

The TAS2552 is a high efficiency Class-D audio
power amplifier with advanced battery current
management and an integrated Class-G boost
The device constantly measures the
current and voltage across the load and provides a
digital stream of this information.

Signed-off-by: Dan Murphy <dmurphy@ti.com>
---

v6 - Addressed comments from v5 also added PLL algorithim instead of
hard coding PLL registers - https://patchwork.kernel.org/patch/4476001/
v5 - Consolidated dai_fmt call back to write serial control register
once - https://patchwork.kernel.org/patch/4474531/
v4 - Added pm_runtime support, removed magical numbers, added regulator
support, changed from legacy gpio to new gpiod calls, fixed default register
values, flipped on battery tracking support and
added suspend/resume support - https://patchwork.kernel.org/patch/4465611/
v3 - Updated bindings doc per comments, rearranged probe pdata vs 
np check - https://patchwork.kernel.org/patch/4453481/
v2 - Address RFC comments- Added regmap, and snd_soc calls
removed debug code, address checkpatch errors -https://patchwork.kernel.org/patch/4378281/

 .../devicetree/bindings/sound/tas2552.txt          |   25 +
 include/sound/tas2552-plat.h                       |   25 +
 sound/soc/codecs/Kconfig                           |    5 +
 sound/soc/codecs/Makefile                          |    2 +
 sound/soc/codecs/tas2552.c                         |  538 ++++++++++++++++++++
 sound/soc/codecs/tas2552.h                         |  129 +++++
 6 files changed, 724 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/sound/tas2552.txt
 create mode 100644 include/sound/tas2552-plat.h
 create mode 100644 sound/soc/codecs/tas2552.c
 create mode 100644 sound/soc/codecs/tas2552.h

diff --git a/Documentation/devicetree/bindings/sound/tas2552.txt b/Documentation/devicetree/bindings/sound/tas2552.txt
new file mode 100644
index 0000000..00223dc
--- /dev/null
+++ b/Documentation/devicetree/bindings/sound/tas2552.txt
@@ -0,0 +1,25 @@
+Texas Instruments - tas2552 Codec module
+
+The tas2552 serial control bus communicates through I2C protocols
+
+Required properties:
+
+- compatible - One of:
+    "ti,tas2552" - TAS2552
+
+- reg -  I2C slave address
+
+Optional properties:
+
+- enable-gpio - gpio pin to enable/disable the device
+
+Example:
+
+tas2552: tas2552@41 {
+	compatible = "ti,tas2552";
+	reg = <0x41>;
+	enable-gpio = <&gpio4 2 GPIO_ACTIVE_HIGH>;
+};
+
+For more product information please see the link below:
+http://www.ti.com/product/TAS2552
diff --git a/include/sound/tas2552-plat.h b/include/sound/tas2552-plat.h
new file mode 100644
index 0000000..65e7627
--- /dev/null
+++ b/include/sound/tas2552-plat.h
@@ -0,0 +1,25 @@
+/*
+ * TAS2552 driver platform header
+ *
+ * Copyright (C) 2014 Texas Instruments Inc.
+ *
+ * Author: Dan Murphy <dmurphy@ti.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ */
+
+#ifndef TAS2552_PLAT_H
+#define TAS2552_PLAT_H
+
+struct tas2552_platform_data {
+	int enable_gpio;
+};
+
+#endif
diff --git a/sound/soc/codecs/Kconfig b/sound/soc/codecs/Kconfig
index 0b9571c..cc09261 100644
--- a/sound/soc/codecs/Kconfig
+++ b/sound/soc/codecs/Kconfig
@@ -99,6 +99,7 @@ config SND_SOC_ALL_CODECS
 	select SND_SOC_TLV320AIC32X4 if I2C
 	select SND_SOC_TLV320AIC3X if I2C
 	select SND_SOC_TPA6130A2 if I2C
+	select SND_SOC_TAS2552 if I2C
 	select SND_SOC_TLV320DAC33 if I2C
 	select SND_SOC_TWL4030 if TWL4030_CORE
 	select SND_SOC_TWL6040 if TWL6040_CORE
@@ -754,4 +755,8 @@ config SND_SOC_TPA6130A2
 	tristate "Texas Instruments TPA6130A2 headphone amplifier"
 	depends on I2C
 
+config SND_SOC_TAS2552
+	tristate "Texas Instruments TAS2552 Mono Audio amplifier"
+	depends on I2C
+
 endmenu
diff --git a/sound/soc/codecs/Makefile b/sound/soc/codecs/Makefile
index 1bd6e1c..33bc7228 100644
--- a/sound/soc/codecs/Makefile
+++ b/sound/soc/codecs/Makefile
@@ -162,6 +162,7 @@ snd-soc-wm-hubs-objs := wm_hubs.o
 # Amp
 snd-soc-max9877-objs := max9877.o
 snd-soc-tpa6130a2-objs := tpa6130a2.o
+snd-soc-tas2552-objs := tas2552.o
 
 obj-$(CONFIG_SND_SOC_88PM860X)	+= snd-soc-88pm860x.o
 obj-$(CONFIG_SND_SOC_AB8500_CODEC)	+= snd-soc-ab8500-codec.o
@@ -325,3 +326,4 @@ obj-$(CONFIG_SND_SOC_WM_HUBS)	+= snd-soc-wm-hubs.o
 # Amp
 obj-$(CONFIG_SND_SOC_MAX9877)	+= snd-soc-max9877.o
 obj-$(CONFIG_SND_SOC_TPA6130A2)	+= snd-soc-tpa6130a2.o
+obj-$(CONFIG_SND_SOC_TAS2552)	+= snd-soc-tas2552.o
diff --git a/sound/soc/codecs/tas2552.c b/sound/soc/codecs/tas2552.c
new file mode 100644
index 0000000..7b762d4
--- /dev/null
+++ b/sound/soc/codecs/tas2552.c
@@ -0,0 +1,538 @@
+/*
+ * tas2552.c - ALSA SoC Texas Instruments TAS2552 Mono Audio Amplifier
+ *
+ * Copyright (C) 2014 Texas Instruments Incorporated -  http://www.ti.com
+ *
+ * Author: Dan Murphy <dmurphy@ti.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ */
+
+#include <linux/module.h>
+#include <linux/errno.h>
+#include <linux/device.h>
+#include <linux/i2c.h>
+#include <linux/gpio.h>
+#include <linux/of_gpio.h>
+#include <linux/pm_runtime.h>
+#include <linux/regmap.h>
+#include <linux/slab.h>
+
+#include <linux/gpio/consumer.h>
+#include <linux/regulator/consumer.h>
+
+#include <sound/pcm.h>
+#include <sound/pcm_params.h>
+#include <sound/soc.h>
+#include <sound/soc-dapm.h>
+#include <sound/tlv.h>
+#include <sound/tas2552-plat.h>
+
+#include "tas2552.h"
+
+static struct reg_default tas2552_reg_defs[] = {
+	{TAS2552_CFG_1, 0x22},
+	{TAS2552_CFG_3, 0x80},
+	{TAS2552_DOUT, 0x00},
+	{TAS2552_OUTPUT_DATA, 0xc0},
+	{TAS2552_PDM_CFG, 0x01},
+	{TAS2552_PGA_GAIN, 0x00},
+	{TAS2552_BOOST_PT_CTRL, 0x0f},
+	{TAS2552_RESERVED_0D, 0x00},
+	{TAS2552_LIMIT_RATE_HYS, 0x08},
+	{TAS2552_CFG_2, 0xef},
+	{TAS2552_SER_CTRL_1, 0x00},
+	{TAS2552_SER_CTRL_2, 0x00},
+	{TAS2552_PLL_CTRL_1, 0x10},
+	{TAS2552_PLL_CTRL_2, 0x00},
+	{TAS2552_PLL_CTRL_3, 0x00},
+	{TAS2552_BTIP, 0x8f},
+	{TAS2552_BTS_CTRL, 0x80},
+	{TAS2552_LIMIT_RELEASE, 0x04},
+	{TAS2552_LIMIT_INT_COUNT, 0x00},
+	{TAS2552_EDGE_RATE_CTRL, 0x40},
+	{TAS2552_VBAT_DATA, 0x00},
+};
+
+#define TAS2552_NUM_SUPPLIES	3
+static const char *tas2552_supply_names[TAS2552_NUM_SUPPLIES] = {
+	"vbat",		/* vbat voltage */
+	"iovdd",	/* I/O Voltage */
+	"avdd",		/* Analog DAC Voltage */
+};
+
+struct tas2552_data {
+	struct snd_soc_codec *codec;
+	struct regmap *regmap;
+	struct i2c_client *tas2552_client;
+	struct regulator_bulk_data supplies[TAS2552_NUM_SUPPLIES];
+	struct gpio_desc *enable_gpio;
+	unsigned char regs[TAS2552_VBAT_DATA];
+	unsigned int mclk;
+};
+
+static void tas2552_sw_shutdown(struct tas2552_data *tas_data, int sw_shutdown)
+{
+	u8 cfg1_reg;
+
+	if (sw_shutdown)
+		cfg1_reg = 0;
+	else
+		cfg1_reg = TAS2552_SWS_MASK;
+
+	snd_soc_update_bits(tas_data->codec, TAS2552_CFG_1,
+						 TAS2552_SWS_MASK, cfg1_reg);
+}
+
+static int tas2552_hw_params(struct snd_pcm_substream *substream,
+			     struct snd_pcm_hw_params *params,
+			     struct snd_soc_dai *dai)
+{
+	struct snd_soc_codec *codec = dai->codec;
+	struct tas2552_data *tas2552 = dev_get_drvdata(codec->dev);
+	int sample_rate, pll_clk;
+	int d;
+	u8 p, j;
+
+	/* Turn on Class D amplifier */
+	snd_soc_update_bits(codec, TAS2552_CFG_2, TAS2552_CLASSD_EN_MASK,
+						TAS2552_CLASSD_EN);
+
+	if (!tas2552->mclk)
+		return -EINVAL;
+
+	snd_soc_update_bits(codec, TAS2552_CFG_2, TAS2552_PLL_ENABLE, 0);
+
+	if (tas2552->mclk == TAS2552_245MHZ_CLK ||
+		tas2552->mclk == TAS2552_225MHZ_CLK) {
+		/* By pass the PLL configuration */
+		snd_soc_update_bits(codec, TAS2552_PLL_CTRL_2,
+				    TAS2552_PLL_BYPASS_MASK,
+				    TAS2552_PLL_BYPASS);
+	} else {
+		/* Fill in the PLL control registers for J & D
+		 * PLL_CLK = (.5 * freq * J.D) / 2^p
+		 * Need to fill in J and D here based on incoming freq
+		 */
+		p = snd_soc_read(codec, TAS2552_PLL_CTRL_1);
+		p = (p >> 7);
+		sample_rate = params_rate(params);
+
+		if (sample_rate == 48000)
+			pll_clk = TAS2552_245MHZ_CLK;
+		else if (sample_rate == 44100)
+			pll_clk = TAS2552_225MHZ_CLK;
+		else {
+			dev_vdbg(codec->dev, "Substream sample rate is not found %i\n",
+					params_rate(params));
+			return -EINVAL;
+		}
+
+		j = (pll_clk * 2 * (1 << p)) / tas2552->mclk;
+		d = (pll_clk * 2 * (1 << p)) % tas2552->mclk;
+
+		snd_soc_update_bits(codec, TAS2552_PLL_CTRL_1,
+				TAS2552_PLL_J_MASK, j);
+		snd_soc_write(codec, TAS2552_PLL_CTRL_2,
+					(d >> 7) & TAS2552_PLL_D_UPPER_MASK);
+		snd_soc_write(codec, TAS2552_PLL_CTRL_3,
+				d & TAS2552_PLL_D_LOWER_MASK);
+
+	}
+
+	snd_soc_update_bits(codec, TAS2552_CFG_2, TAS2552_PLL_ENABLE,
+						TAS2552_PLL_ENABLE);
+
+	return 0;
+}
+
+static int tas2552_set_dai_fmt(struct snd_soc_dai *dai, unsigned int fmt)
+{
+	struct snd_soc_codec *codec = dai->codec;
+	u8 serial_format;
+	u8 serial_control_mask;
+
+	switch (fmt & SND_SOC_DAIFMT_MASTER_MASK) {
+	case SND_SOC_DAIFMT_CBS_CFS:
+		serial_format = 0x00;
+		break;
+	case SND_SOC_DAIFMT_CBS_CFM:
+		serial_format = TAS2552_WORD_CLK_MASK;
+		break;
+	case SND_SOC_DAIFMT_CBM_CFS:
+		serial_format = TAS2552_BIT_CLK_MASK;
+		break;
+	case SND_SOC_DAIFMT_CBM_CFM:
+		serial_format = (TAS2552_BIT_CLK_MASK | TAS2552_WORD_CLK_MASK);
+		break;
+	default:
+		dev_vdbg(codec->dev, "DAI Format master is not found\n");
+		return -EINVAL;
+	}
+
+	serial_control_mask = TAS2552_BIT_CLK_MASK | TAS2552_WORD_CLK_MASK;
+
+	switch (fmt & SND_SOC_DAIFMT_FORMAT_MASK) {
+	case SND_SOC_DAIFMT_I2S:
+		serial_format &= TAS2552_DAIFMT_I2S_MASK;
+		break;
+	case SND_SOC_DAIFMT_DSP_A:
+		serial_format |= TAS2552_DAIFMT_DSP;
+		break;
+	case SND_SOC_DAIFMT_RIGHT_J:
+		serial_format |= TAS2552_DAIFMT_RIGHT_J;
+		break;
+	case SND_SOC_DAIFMT_LEFT_J:
+		serial_format |= TAS2552_DAIFMT_LEFT_J;
+		break;
+	default:
+		dev_vdbg(codec->dev, "DAI Format is not found\n");
+		return -EINVAL;
+	}
+
+	if (fmt & SND_SOC_DAIFMT_FORMAT_MASK)
+		serial_control_mask |= TAS2552_DATA_FORMAT_MASK;
+
+	snd_soc_update_bits(codec, TAS2552_SER_CTRL_1, serial_control_mask,
+						serial_format);
+
+	return 0;
+}
+
+static int tas2552_set_dai_sysclk(struct snd_soc_dai *dai, int clk_id,
+				  unsigned int freq, int dir)
+{
+	struct snd_soc_codec *codec = dai->codec;
+	struct tas2552_data *tas2552 = dev_get_drvdata(codec->dev);
+
+	tas2552->mclk = freq;
+
+	return 0;
+}
+
+static int tas2552_mute(struct snd_soc_dai *dai, int mute)
+{
+	u8 cfg1_reg;
+	struct snd_soc_codec *codec = dai->codec;
+
+	if (mute)
+		cfg1_reg = TAS2552_MUTE_MASK;
+	else
+		cfg1_reg = ~TAS2552_MUTE_MASK;
+
+	snd_soc_update_bits(codec, TAS2552_CFG_1, TAS2552_MUTE_MASK, cfg1_reg);
+
+	return 0;
+}
+
+#ifdef CONFIG_PM_RUNTIME
+static int tas2552_runtime_suspend(struct device *dev)
+{
+	struct tas2552_data *tas2552 = dev_get_drvdata(dev);
+
+	tas2552_sw_shutdown(tas2552, 0);
+
+	if (tas2552->enable_gpio)
+		gpiod_set_value(tas2552->enable_gpio, 0);
+
+	regcache_cache_only(tas2552->regmap, true);
+	regcache_mark_dirty(tas2552->regmap);
+
+	return 0;
+}
+
+static int tas2552_runtime_resume(struct device *dev)
+{
+	struct tas2552_data *tas2552 = dev_get_drvdata(dev);
+
+	if (tas2552->enable_gpio)
+		gpiod_set_value(tas2552->enable_gpio, 1);
+
+	tas2552_sw_shutdown(tas2552, 1);
+
+	regcache_cache_only(tas2552->regmap, false);
+	regcache_sync(tas2552->regmap);
+
+	return 0;
+}
+#endif
+
+static const struct dev_pm_ops tas2552_pm = {
+	SET_RUNTIME_PM_OPS(tas2552_runtime_suspend, tas2552_runtime_resume,
+			   NULL)
+};
+
+static int tas2552_startup(struct snd_pcm_substream *substream,
+			   struct snd_soc_dai *dai)
+{
+	struct snd_soc_codec *codec = dai->codec;
+
+	pm_runtime_get_sync(codec->dev);
+
+	return 0;
+}
+
+static void tas2552_shutdown(struct snd_pcm_substream *substream,
+			   struct snd_soc_dai *dai)
+{
+	struct snd_soc_codec *codec = dai->codec;
+
+	pm_runtime_put(codec->dev);
+}
+
+static struct snd_soc_dai_ops tas2552_speaker_dai_ops = {
+	.hw_params	= tas2552_hw_params,
+	.set_sysclk	= tas2552_set_dai_sysclk,
+	.set_fmt	= tas2552_set_dai_fmt,
+	.startup	= tas2552_startup,
+	.shutdown	= tas2552_shutdown,
+	.digital_mute = tas2552_mute,
+};
+
+/* Formats supported by TAS2552 driver. */
+#define TAS2552_FORMATS (SNDRV_PCM_FMTBIT_S16_LE | SNDRV_PCM_FMTBIT_S20_3LE |\
+			 SNDRV_PCM_FMTBIT_S24_LE | SNDRV_PCM_FMTBIT_S32_LE)
+
+/* TAS2552 dai structure. */
+static struct snd_soc_dai_driver tas2552_dai[] = {
+	{
+		.name = "tas2552-amplifier",
+		.playback = {
+			.stream_name = "Speaker",
+			.channels_min = 2,
+			.channels_max = 2,
+			.rates = SNDRV_PCM_RATE_8000_192000,
+			.formats = TAS2552_FORMATS,
+		},
+		.ops = &tas2552_speaker_dai_ops,
+	},
+};
+
+/*
+ * DAC digital volumes. From -7 to 24 dB in 1 dB steps
+ */
+static DECLARE_TLV_DB_SCALE(dac_tlv, -7, 100, 24);
+
+static const struct snd_kcontrol_new tas2552_snd_controls[] = {
+	SOC_SINGLE_TLV("Speaker Driver Playback Volume",
+			 TAS2552_PGA_GAIN, 0, 0x1f, 1, dac_tlv),
+};
+
+static const struct reg_default tas2552_init_regs[] = {
+	{ TAS2552_RESERVED_0D, 0xc0 },
+};
+
+static int tas2552_codec_probe(struct snd_soc_codec *codec)
+{
+	struct tas2552_data *tas2552 = snd_soc_codec_get_drvdata(codec);
+	int ret;
+
+	tas2552->codec = codec;
+
+	ret = regulator_bulk_enable(ARRAY_SIZE(tas2552->supplies),
+				    tas2552->supplies);
+
+	if (ret != 0) {
+		dev_err(codec->dev, "Failed to enable supplies: %d\n",
+			ret);
+		return ret;
+	}
+
+	if (tas2552->enable_gpio)
+		gpiod_set_value(tas2552->enable_gpio, 1);
+
+	pm_runtime_get_sync(codec->dev);
+
+	snd_soc_write(codec, TAS2552_CFG_1, TAS2552_MUTE_MASK |
+				TAS2552_PLL_SRC_BCLK);
+	snd_soc_write(codec, TAS2552_CFG_3, TAS2552_I2S_OUT_SEL |
+				TAS2552_DIN_SRC_SEL_AVG_L_R | TAS2552_88_96KHZ);
+	snd_soc_write(codec, TAS2552_DOUT, TAS2552_PDM_DATA_I);
+	snd_soc_write(codec, TAS2552_OUTPUT_DATA, TAS2552_PDM_DATA_V_I | 0x8);
+	snd_soc_write(codec, TAS2552_PDM_CFG, TAS2552_PDM_BCLK_SEL);
+	snd_soc_write(codec, TAS2552_BOOST_PT_CTRL, TAS2552_APT_DELAY_200 |
+				TAS2552_APT_THRESH_2_1_7);
+
+	ret = regmap_register_patch(tas2552->regmap, tas2552_init_regs,
+					    ARRAY_SIZE(tas2552_init_regs));
+	if (ret != 0)
+		dev_err(codec->dev, "Failed to write init registers: %d\n",
+			ret);
+
+	snd_soc_write(codec, TAS2552_CFG_2, TAS2552_CLASSD_EN |
+				  TAS2552_BOOST_EN | TAS2552_APT_EN |
+				  TAS2552_PLL_ENABLE | TAS2552_LIM_EN);
+	return 0;
+}
+
+static int tas2552_codec_remove(struct snd_soc_codec *codec)
+{
+	struct tas2552_data *tas2552 = snd_soc_codec_get_drvdata(codec);
+
+	if (tas2552->enable_gpio)
+		gpiod_set_value(tas2552->enable_gpio, 0);
+
+	return 0;
+};
+
+#ifdef CONFIG_PM
+static int tas2552_suspend(struct snd_soc_codec *codec)
+{
+	struct tas2552_data *tas2552 = snd_soc_codec_get_drvdata(codec);
+	int ret;
+
+	pm_runtime_put(codec->dev);
+
+	ret = regulator_bulk_disable(ARRAY_SIZE(tas2552->supplies),
+					tas2552->supplies);
+
+	if (ret != 0)
+		dev_err(codec->dev, "Failed to disable supplies: %d\n",
+			ret);
+	return 0;
+}
+
+static int tas2552_resume(struct snd_soc_codec *codec)
+{
+	struct tas2552_data *tas2552 = snd_soc_codec_get_drvdata(codec);
+	int ret;
+
+	ret = regulator_bulk_enable(ARRAY_SIZE(tas2552->supplies),
+				    tas2552->supplies);
+
+	if (ret != 0) {
+		dev_err(codec->dev, "Failed to enable supplies: %d\n",
+			ret);
+	}
+
+	pm_runtime_get_sync(codec->dev);
+
+	return 0;
+}
+#else
+#define tas2552_suspend NULL
+#define tas2552_resume NULL
+#endif
+
+static struct snd_soc_codec_driver soc_codec_dev_tas2552 = {
+	.probe = tas2552_codec_probe,
+	.remove = tas2552_codec_remove,
+	.suspend =	tas2552_suspend,
+	.resume = tas2552_resume,
+	.controls = tas2552_snd_controls,
+	.num_controls = ARRAY_SIZE(tas2552_snd_controls),
+};
+
+static const struct regmap_config tas2552_regmap_config = {
+	.reg_bits = 8,
+	.val_bits = 8,
+
+	.max_register = TAS2552_MAX_REG,
+	.reg_defaults = tas2552_reg_defs,
+	.num_reg_defaults = ARRAY_SIZE(tas2552_reg_defs),
+	.cache_type = REGCACHE_RBTREE,
+};
+
+static int tas2552_probe(struct i2c_client *client,
+			   const struct i2c_device_id *id)
+{
+	struct device *dev;
+	struct tas2552_data *data;
+	int ret;
+	int i;
+
+	dev = &client->dev;
+	data = devm_kzalloc(&client->dev, sizeof(*data), GFP_KERNEL);
+	if (data == NULL)
+		return -ENOMEM;
+
+	data->enable_gpio = devm_gpiod_get(dev, "enable");
+	if (IS_ERR(data->enable_gpio)) {
+		ret = PTR_ERR(data->enable_gpio);
+		if (ret != -ENOENT && ret != -ENOSYS)
+			return ret;
+
+		data->enable_gpio = NULL;
+	} else {
+		gpiod_direction_output(data->enable_gpio, 0);
+	}
+
+	data->tas2552_client = client;
+	data->regmap = devm_regmap_init_i2c(client, &tas2552_regmap_config);
+	if (IS_ERR(data->regmap)) {
+		ret = PTR_ERR(data->regmap);
+		dev_err(&client->dev, "Failed to allocate register map: %d\n",
+			ret);
+		return ret;
+	}
+
+	for (i = 0; i < ARRAY_SIZE(data->supplies); i++)
+		data->supplies[i].supply = tas2552_supply_names[i];
+
+	ret = devm_regulator_bulk_get(dev, ARRAY_SIZE(data->supplies),
+				      data->supplies);
+	if (ret != 0)
+		dev_err(dev, "Failed to request supplies: %d\n", ret);
+
+	pm_runtime_set_active(&client->dev);
+	pm_runtime_set_autosuspend_delay(&client->dev, 1000);
+	pm_runtime_use_autosuspend(&client->dev);
+	pm_runtime_enable(&client->dev);
+	pm_runtime_mark_last_busy(&client->dev);
+	pm_runtime_put_sync_autosuspend(&client->dev);
+
+	dev_set_drvdata(&client->dev, data);
+
+	ret = snd_soc_register_codec(&client->dev,
+				      &soc_codec_dev_tas2552,
+				      tas2552_dai, ARRAY_SIZE(tas2552_dai));
+	if (ret < 0)
+		dev_err(&client->dev, "Failed to register codec: %d\n", ret);
+
+	return 0;
+}
+
+static int tas2552_i2c_remove(struct i2c_client *client)
+{
+	snd_soc_unregister_codec(&client->dev);
+	return 0;
+}
+
+static const struct i2c_device_id tas2552_id[] = {
+	{ "tas2552-codec", 0 },
+	{ }
+};
+MODULE_DEVICE_TABLE(i2c, tas2552_id);
+
+#if IS_ENABLED(CONFIG_OF)
+static const struct of_device_id tas2552_of_match[] = {
+	{ .compatible = "ti,tas2552", },
+	{},
+};
+MODULE_DEVICE_TABLE(of, tas2552_of_match);
+#endif
+
+static struct i2c_driver tas2552_i2c_driver = {
+	.driver = {
+		.name = "tas2552",
+		.owner = THIS_MODULE,
+		.of_match_table = of_match_ptr(tas2552_of_match),
+		.pm = &tas2552_pm,
+	},
+	.probe = tas2552_probe,
+	.remove = tas2552_i2c_remove,
+	.id_table = tas2552_id,
+};
+
+module_i2c_driver(tas2552_i2c_driver);
+
+MODULE_AUTHOR("Dan Muprhy <dmurphy@ti.com>");
+MODULE_DESCRIPTION("TAS2552 Audio amplifier driver");
+MODULE_LICENSE("GPL");
diff --git a/sound/soc/codecs/tas2552.h b/sound/soc/codecs/tas2552.h
new file mode 100644
index 0000000..6cea8f3
--- /dev/null
+++ b/sound/soc/codecs/tas2552.h
@@ -0,0 +1,129 @@
+/*
+ * tas2552.h - ALSA SoC Texas Instruments TAS2552 Mono Audio Amplifier
+ *
+ * Copyright (C) 2014 Texas Instruments Incorporated -  http://www.ti.com
+ *
+ * Author: Dan Murphy <dmurphy@ti.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ */
+
+#ifndef __TAS2552_H__
+#define __TAS2552_H__
+
+/* Register Address Map */
+#define TAS2552_DEVICE_STATUS	0x00
+#define TAS2552_CFG_1			0x01
+#define TAS2552_CFG_2			0x02
+#define TAS2552_CFG_3			0x03
+#define TAS2552_DOUT			0x04
+#define TAS2552_SER_CTRL_1		0x05
+#define TAS2552_SER_CTRL_2		0x06
+#define TAS2552_OUTPUT_DATA		0x07
+#define TAS2552_PLL_CTRL_1		0x08
+#define TAS2552_PLL_CTRL_2		0x09
+#define TAS2552_PLL_CTRL_3		0x0a
+#define TAS2552_BTIP			0x0b
+#define TAS2552_BTS_CTRL		0x0c
+#define TAS2552_RESERVED_0D		0x0d
+#define TAS2552_LIMIT_RATE_HYS	0x0e
+#define TAS2552_LIMIT_RELEASE	0x0f
+#define TAS2552_LIMIT_INT_COUNT	0x10
+#define TAS2552_PDM_CFG			0x11
+#define TAS2552_PGA_GAIN		0x12
+#define TAS2552_EDGE_RATE_CTRL	0x13
+#define TAS2552_BOOST_PT_CTRL	0x14
+#define TAS2552_VER_NUM			0x16
+#define TAS2552_VBAT_DATA		0x19
+#define TAS2552_MAX_REG			0x20
+
+/* CFG1 Register Masks */
+#define TAS2552_MUTE_MASK		(1 << 2)
+#define TAS2552_SWS_MASK		(1 << 1)
+#define TAS2552_WCLK_MASK		0x07
+#define TAS2552_CLASSD_EN_MASK	(1 << 7)
+
+/* CFG2 Register Masks */
+#define TAS2552_CLASSD_EN		(1 << 7)
+#define TAS2552_BOOST_EN		(1 << 6)
+#define TAS2552_APT_EN			(1 << 5)
+#define TAS2552_PLL_ENABLE		(1 << 3)
+#define TAS2552_LIM_EN			(1 << 2)
+#define TAS2552_IVSENSE_EN		(1 << 1)
+
+/* CFG3 Register Masks */
+#define TAS2552_WORD_CLK_MASK		(1 << 7)
+#define TAS2552_BIT_CLK_MASK		(1 << 6)
+#define TAS2552_DATA_FORMAT_MASK	(0x11 << 2)
+
+#define TAS2552_DAIFMT_I2S_MASK		0xf3
+#define TAS2552_DAIFMT_DSP			(1 << 3)
+#define TAS2552_DAIFMT_RIGHT_J		(1 << 4)
+#define TAS2552_DAIFMT_LEFT_J		(0x11 << 3)
+
+#define TAS2552_PLL_SRC_MCLK	0x00
+#define TAS2552_PLL_SRC_BCLK	(1 << 3)
+#define TAS2552_PLL_SRC_IVCLKIN	(1 << 4)
+#define TAS2552_PLL_SRC_1_8_FIXED (0x11 << 3)
+
+#define TAS2552_DIN_SRC_SEL_MUTED	0x00
+#define TAS2552_DIN_SRC_SEL_LEFT	(1 << 4)
+#define TAS2552_DIN_SRC_SEL_RIGHT	(1 << 5)
+#define TAS2552_DIN_SRC_SEL_AVG_L_R	(0x11 << 4)
+
+#define TAS2552_PDM_IN_SEL		(1 << 5)
+#define TAS2552_I2S_OUT_SEL		(1 << 6)
+#define TAS2552_ANALOG_IN_SEL	(1 << 7)
+
+/* CFG3 WCLK Dividers */
+#define TAS2552_8KHZ		0x00
+#define TAS2552_11_12KHZ	(1 << 1)
+#define TAS2552_16KHZ		(1 << 2)
+#define TAS2552_22_24KHZ	(1 << 3)
+#define TAS2552_32KHZ		(1 << 4)
+#define TAS2552_44_48KHZ	(1 << 5)
+#define TAS2552_88_96KHZ	(1 << 6)
+#define TAS2552_176_192KHZ	(1 << 7)
+
+/* OUTPUT_DATA register */
+#define TAS2552_PDM_DATA_I		0x00
+#define TAS2552_PDM_DATA_V		(1 << 6)
+#define TAS2552_PDM_DATA_I_V	(1 << 7)
+#define TAS2552_PDM_DATA_V_I	(0x11 << 6)
+
+/* PDM CFG Register */
+#define TAS2552_PDM_DATA_ES_RISE 0x4
+
+#define TAS2552_PDM_PLL_CLK_SEL 0x00
+#define TAS2552_PDM_IV_CLK_SEL	(1 << 1)
+#define TAS2552_PDM_BCLK_SEL	(1 << 2)
+#define TAS2552_PDM_MCLK_SEL	(1 << 3)
+
+/* Boost pass-through register */
+#define TAS2552_APT_DELAY_50	0x00
+#define TAS2552_APT_DELAY_75	(1 << 1)
+#define TAS2552_APT_DELAY_125	(1 << 2)
+#define TAS2552_APT_DELAY_200	(1 << 3)
+
+#define TAS2552_APT_THRESH_2_5		0x00
+#define TAS2552_APT_THRESH_1_7		(1 << 3)
+#define TAS2552_APT_THRESH_1_4_1_1	(1 << 4)
+#define TAS2552_APT_THRESH_2_1_7	(0x11 << 2)
+
+/* PLL Control Register */
+#define TAS2552_245MHZ_CLK			24576000
+#define TAS2552_225MHZ_CLK			22579200
+#define TAS2552_PLL_J_MASK			0x7f
+#define TAS2552_PLL_D_UPPER_MASK	0x3f
+#define TAS2552_PLL_D_LOWER_MASK	0xff
+#define TAS2552_PLL_BYPASS_MASK		0x80
+#define TAS2552_PLL_BYPASS			0x80
+
+#endif
-- 
1.7.9.5

