Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754098AbaFRRp7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 13:45:59 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:59143 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752656AbaFRRpz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 13:45:55 -0400
From: Dan Murphy <dmurphy@ti.com>
To: <linux-sound@vger.kernel.org>
CC: <linux-kernel@vger.kernel.org>, <alsa-devel@alsa-project.org>,
        <broonie@kernel.org>, Dan Murphy <dmurphy@ti.com>
Subject: [RFC PATCH] ASoC: tas2552: Support TI TAS2552 Amplifier
Date: Wed, 18 Jun 2014 12:45:46 -0500
Message-ID: <1403113547-15120-1-git-send-email-dmurphy@ti.com>
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
 .../devicetree/bindings/sound/tas2552.txt          |   22 +
 include/sound/tas2552-plat.h                       |   30 +
 sound/soc/codecs/Kconfig                           |    5 +
 sound/soc/codecs/Makefile                          |    2 +
 sound/soc/codecs/tas2552.c                         |  631 ++++++++++++++++++++
 sound/soc/codecs/tas2552.h                         |   79 +++
 6 files changed, 769 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/sound/tas2552.txt
 create mode 100644 include/sound/tas2552-plat.h
 create mode 100644 sound/soc/codecs/tas2552.c
 create mode 100644 sound/soc/codecs/tas2552.h

diff --git a/Documentation/devicetree/bindings/sound/tas2552.txt b/Documentation/devicetree/bindings/sound/tas2552.txt
new file mode 100644
index 0000000..58e931b
--- /dev/null
+++ b/Documentation/devicetree/bindings/sound/tas2552.txt
@@ -0,0 +1,22 @@
+Texas Instruments - tas2552 Codec module
+
+The tas2552 serial control bus communicates through I2C protocols
+
+Required properties:
+
+- compatible - "string" - One of:
+    "ti,tas2552" - TAS2552
+
+- reg - <int> -  I2C slave address
+
+Optional properties:
+
+- power-gpio - gpio pin to enable/disable the device
+
+Example:
+
+tas2552: tas2552@41 {
+	compatible = "ti,tas2552";
+	reg = <0x41>;
+	power-gpio = <&gpio4 2 GPIO_ACTIVE_HIGH>;
+};
diff --git a/include/sound/tas2552-plat.h b/include/sound/tas2552-plat.h
new file mode 100644
index 0000000..46d2732
--- /dev/null
+++ b/include/sound/tas2552-plat.h
@@ -0,0 +1,30 @@
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
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
+ * 02110-1301 USA
+ */
+
+#ifndef TAS2552_PLAT_H
+#define TAS2552_PLAT_H
+
+struct tas2552_platform_data {
+	int power_gpio;
+};
+
+#endif
diff --git a/sound/soc/codecs/Kconfig b/sound/soc/codecs/Kconfig
index cbfa1e1..06ff67e 100644
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
@@ -746,4 +747,8 @@ config SND_SOC_TPA6130A2
 	tristate "Texas Instruments TPA6130A2 headphone amplifier"
 	depends on I2C
 
+config SND_SOC_TAS2552
+	tristate "Texas Instruments TAS2552 Mono Audio amplifier"
+	depends on I2C
+
 endmenu
diff --git a/sound/soc/codecs/Makefile b/sound/soc/codecs/Makefile
index be3377b..ab33cd7 100644
--- a/sound/soc/codecs/Makefile
+++ b/sound/soc/codecs/Makefile
@@ -160,6 +160,7 @@ snd-soc-wm-hubs-objs := wm_hubs.o
 # Amp
 snd-soc-max9877-objs := max9877.o
 snd-soc-tpa6130a2-objs := tpa6130a2.o
+snd-soc-tas2552-objs := tas2552.o
 
 obj-$(CONFIG_SND_SOC_88PM860X)	+= snd-soc-88pm860x.o
 obj-$(CONFIG_SND_SOC_AB8500_CODEC)	+= snd-soc-ab8500-codec.o
@@ -321,3 +322,4 @@ obj-$(CONFIG_SND_SOC_WM_HUBS)	+= snd-soc-wm-hubs.o
 # Amp
 obj-$(CONFIG_SND_SOC_MAX9877)	+= snd-soc-max9877.o
 obj-$(CONFIG_SND_SOC_TPA6130A2)	+= snd-soc-tpa6130a2.o
+obj-$(CONFIG_SND_SOC_TAS2552)	+= snd-soc-tas2552.o
diff --git a/sound/soc/codecs/tas2552.c b/sound/soc/codecs/tas2552.c
new file mode 100644
index 0000000..111eb0e
--- /dev/null
+++ b/sound/soc/codecs/tas2552.c
@@ -0,0 +1,631 @@
+/*
+ * ALSA SoC Texas Instruments TAS2552 Mono Audio Amplifier
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
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
+ * 02110-1301 USA
+ */
+
+#include <linux/module.h>
+#include <linux/errno.h>
+#include <linux/device.h>
+#include <linux/i2c.h>
+#include <linux/gpio.h>
+#include <linux/of_gpio.h>
+#include <linux/regmap.h>
+#include <linux/slab.h>
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
+/* Remove this below to disable register debugging */
+#define TAS2552_DEBUG
+
+struct tas2552_data {
+	struct mutex mutex;
+	struct snd_soc_codec *codec;
+	struct regmap *regmap;
+	struct i2c_client *tas2552_client;
+	unsigned char regs[TAS2552_VBAT_DATA];
+	int power_gpio;
+	u8 power_state:1;
+};
+
+static int tas2552_i2c_read(struct tas2552_data *tas_data, int reg)
+{
+	int val;
+
+	if (WARN_ON(!tas_data->tas2552_client))
+		return -EINVAL;
+
+	/* If powered off, return the cached value */
+	mutex_lock(&tas_data->mutex);
+	if (tas_data->power_state) {
+		val = i2c_smbus_read_byte_data(tas_data->tas2552_client, reg);
+		if (val < 0)
+			dev_err(&tas_data->tas2552_client->dev, "Read failed %i\n", val);
+		else
+			tas_data->regs[reg] = val;
+	} else {
+		val = tas_data->regs[reg];
+	}
+
+	mutex_unlock(&tas_data->mutex);
+	return val;
+}
+
+static int tas2552_i2c_write(struct tas2552_data *tas_data, int reg, u8 value)
+{
+	int val = 0;
+
+	if (WARN_ON(!tas_data->tas2552_client))
+		return -EINVAL;
+
+	mutex_lock(&tas_data->mutex);
+	if (tas_data->power_state) {
+		val = i2c_smbus_write_byte_data(tas_data->tas2552_client, reg, value);
+		if (val < 0) {
+			dev_err(&tas_data->tas2552_client->dev, "Write failed %i\n", val);
+			goto write_err;
+		}
+	}
+
+	/* Either powered on or off, we save the context */
+	tas_data->regs[reg] = value;
+
+write_err:
+	mutex_unlock(&tas_data->mutex);
+	return val;
+}
+
+static int tas2552_power(struct tas2552_data *data, u8 power)
+{
+	int	ret = 0;
+
+	BUG_ON(data->tas2552_client == NULL);
+
+	mutex_lock(&data->mutex);
+	if (power == data->power_state)
+		goto exit;
+
+	if (power) {
+		if (data->power_gpio >= 0)
+			gpio_set_value(data->power_gpio, 1);
+
+		data->power_state = 1;
+	} else {
+		if (data->power_gpio >= 0)
+			gpio_set_value(data->power_gpio, 0);
+
+		data->power_state = 0;
+	}
+
+exit:
+	mutex_unlock(&data->mutex);
+	return ret;
+}
+
+#ifdef TAS2552_DEBUG
+struct tas2552_reg {
+	const char *name;
+	uint8_t reg;
+	int writeable;
+} tas2552_regs[] = {
+	{ "STATUS",		TAS2552_DEVICE_STATUS, 1 },
+	{ "CFG1",		TAS2552_CFG_1, 1 },
+	{ "CFG2",		TAS2552_CFG_2, 1 },
+	{ "CFG3",		TAS2552_CFG_3, 1 },
+	{ "DOUT",		TAS2552_DOUT, 1 },
+	{ "SER_CTRL_1",	TAS2552_SER_CTRL_1, 1 },
+	{ "SER_CTRL_2",	TAS2552_SER_CTRL_2, 1 },
+	{ "OUTPUT_DATA", TAS2552_OUTPUT_DATA, 1 },
+	{ "PLL_CTRL_1",	TAS2552_PLL_CTRL_1, 1 },
+	{ "PLL_CTRL_2",	TAS2552_PLL_CTRL_2, 1 },
+	{ "PLL_CTRL_3",	TAS2552_PLL_CTRL_3, 1 },
+	{ "BTIP", TAS2552_BTIP, 1 },
+	{ "BTS_CTRL", TAS2552_BTS_CTRL, 1 },
+	{ "LIMIT_LVL_CTRL",	TAS2552_LIMIT_LVL_CTRL, 1 },
+	{ "LIMIT_RATE_HYS",	TAS2552_LIMIT_RATE_HYS, 1 },
+	{ "IMIT_RELEASE",	TAS2552_LIMIT_RELEASE, 1 },
+	{ "LIMIT_INT_COUNT", TAS2552_LIMIT_INT_COUNT, 1 },
+	{ "PDM_CFG",	TAS2552_PDM_CFG, 1 },
+	{ "PGA_GAIN",	TAS2552_PGA_GAIN, 1 },
+	{ "EDGE_CTRL",	TAS2552_EDGE_RATE_CTRL, 1 },
+	{ "BOOST_CTRL",	TAS2552_BOOST_PT_CTRL, 1 },
+	{ "VER_NUM", TAS2552_VER_NUM, 1 },
+	{ "VBAT_DATA", TAS2552_VBAT_DATA, 1 },
+};
+
+static ssize_t tas2552_registers_show(struct device *dev,
+			      struct device_attribute *attr, char *buf)
+{
+	unsigned i, n, reg_count;
+	u8 read_buf;
+	struct tas2552_data *data = dev_get_drvdata(dev);
+
+	tas2552_power(data, 1);
+	reg_count = sizeof(tas2552_regs) / sizeof(tas2552_regs[0]);
+	for (i = 0, n = 0; i < reg_count; i++) {
+		read_buf = tas2552_i2c_read(data, tas2552_regs[i].reg);
+		n += scnprintf(buf + n, PAGE_SIZE - n,
+			       "%-20s = 0x%02X\n",
+			       tas2552_regs[i].name,
+			       read_buf);
+	}
+	tas2552_power(data, 0);
+	return n;
+}
+
+static ssize_t tas2552_registers_store(struct device *dev,
+			       struct device_attribute *attr,
+			       const char *buf, size_t count)
+{
+	unsigned i, reg_count, value;
+	int error = 0;
+	char name[30];
+	struct tas2552_data *data = dev_get_drvdata(dev);
+
+	if (count >= 30) {
+		pr_err("%s:input too long\n", __func__);
+		return -1;
+	}
+
+	if (sscanf(buf, "%s %x", name, &value) != 2) {
+		pr_err("%s:unable to parse input\n", __func__);
+		return -1;
+	}
+
+	tas2552_power(data, 1);
+	reg_count = sizeof(tas2552_regs) / sizeof(tas2552_regs[0]);
+	for (i = 0; i < reg_count; i++) {
+		if (!strcmp(name, tas2552_regs[i].name)) {
+			if (tas2552_regs[i].writeable) {
+				error = tas2552_i2c_write(data, tas2552_regs[i].reg, value);
+				if (error) {
+					pr_err("%s:Failed to write %s\n",
+						__func__, name);
+					return -1;
+				}
+			} else {
+				pr_err("%s:Register %s is not writeable\n",
+						__func__, name);
+					return -1;
+			}
+			return count;
+		}
+	}
+	tas2552_power(data, 0);
+	pr_err("%s:no such register %s\n", __func__, name);
+	return -1;
+}
+
+static DEVICE_ATTR(registers, S_IWUSR | S_IRUGO,
+		tas2552_registers_show, tas2552_registers_store);
+
+static struct attribute *tas2552_attrs[] = {
+	&dev_attr_registers.attr,
+	NULL
+};
+
+static const struct attribute_group tas2552_attr_group = {
+	.attrs = tas2552_attrs,
+};
+#endif
+
+static void tas2552_sw_shutdown(struct tas2552_data *tas_data, int sw_shutdown)
+{
+	u8 cfg1_reg;
+
+	cfg1_reg = tas2552_i2c_read(tas_data, TAS2552_CFG_1);
+	if (sw_shutdown)
+		cfg1_reg |= (sw_shutdown << 1);
+	else
+		cfg1_reg &= TAS2552_SWS_MASK;
+
+	tas2552_i2c_write(tas_data, TAS2552_CFG_1, cfg1_reg);
+}
+
+static void tas2552_init(struct snd_soc_codec *codec)
+{
+	struct tas2552_data *tas2552 = snd_soc_codec_get_drvdata(codec);
+
+	/* BCLK source, MUTE, SW Shutdown */
+	tas2552_i2c_write(tas2552, TAS2552_CFG_1, 0x16);
+
+	tas2552_i2c_write(tas2552, TAS2552_CFG_3, 0x5E);
+	/* DOUT set to logic low when not transmitting data */
+	tas2552_i2c_write(tas2552, TAS2552_DOUT, 0x00);
+
+	tas2552_i2c_write(tas2552, TAS2552_OUTPUT_DATA, 0xC8);
+
+	/* BLCK source for PDM*/
+	tas2552_i2c_write(tas2552, TAS2552_PDM_CFG, 0x02);
+	tas2552_i2c_write(tas2552, TAS2552_PGA_GAIN, 0x10);
+
+	tas2552_i2c_write(tas2552, TAS2552_BOOST_PT_CTRL, 0x0F);
+	tas2552_i2c_write(tas2552, TAS2552_LIMIT_LVL_CTRL, 0x0C);
+	tas2552_i2c_write(tas2552, TAS2552_LIMIT_RATE_HYS, 0x20);
+	tas2552_i2c_write(tas2552, TAS2552_CFG_2, 0xEA);
+
+}
+
+static int tas2552_hw_params(struct snd_pcm_substream *substream,
+			     struct snd_pcm_hw_params *params,
+			     struct snd_soc_dai *dai)
+{
+	u8 wclk_reg;
+	u8 cfg3_reg;
+	struct tas2552_data *data = dev_get_drvdata(dai->dev);
+
+	/* Setting DAC clock dividers based on substream sample rate. */
+	switch (params_rate(params)) {
+	case 8000:
+		wclk_reg = TAS2552_8KHZ;
+		break;
+	case 11025:
+		wclk_reg = TAS2552_11_12KHZ;
+		break;
+	case 16000:
+		wclk_reg = TAS2552_16KHZ;
+		break;
+	case 32000:
+		wclk_reg = TAS2552_32KHZ;
+		break;
+	case 22050:
+	case 24000:
+		wclk_reg = TAS2552_22_24KHZ;
+		break;
+	case 44100:
+	case 48000:
+		wclk_reg = TAS2552_44_48KHZ;
+		break;
+	case 96000:
+		wclk_reg = TAS2552_88_96KHZ;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	cfg3_reg = tas2552_i2c_read(data, TAS2552_CFG_3);
+	cfg3_reg &= ~TAS2552_WCLK_MASK;
+	cfg3_reg |= wclk_reg;
+	tas2552_i2c_write(data, TAS2552_CFG_3, cfg3_reg);
+
+	return 0;
+}
+
+static int tas2552_set_dai_fmt(struct snd_soc_dai *codec_dai, unsigned int fmt)
+{
+	u8 serial_format;
+	u8 serial_1_reg;
+	struct tas2552_data *data = dev_get_drvdata(codec_dai->dev);
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
+		return -EINVAL;
+	}
+
+	serial_1_reg = tas2552_i2c_read(data, TAS2552_SER_CTRL_1);
+	serial_1_reg &= ~(TAS2552_BIT_CLK_MASK | TAS2552_WORD_CLK_MASK);
+	serial_1_reg |= serial_format;
+
+	tas2552_i2c_write(data, TAS2552_SER_CTRL_1, serial_1_reg);
+
+	switch (fmt & SND_SOC_DAIFMT_FORMAT_MASK) {
+	case SND_SOC_DAIFMT_I2S:
+		serial_format = 0x0;
+		break;
+	case SND_SOC_DAIFMT_DSP_A:
+		serial_format = TAS2552_DAIFMT_DSP;
+		break;
+	case SND_SOC_DAIFMT_RIGHT_J:
+		serial_format = TAS2552_DAIFMT_RIGHT_J;
+		break;
+	case SND_SOC_DAIFMT_LEFT_J:
+		serial_format = TAS2552_DAIFMT_LEFT_J;
+		break;
+
+	default:
+		return -EINVAL;
+	}
+
+	serial_1_reg = tas2552_i2c_read(data, TAS2552_SER_CTRL_1);
+	serial_1_reg &= ~TAS2552_DATA_FORMAT_MASK;
+	serial_1_reg |= serial_format;
+
+	tas2552_i2c_write(data, TAS2552_SER_CTRL_1, serial_1_reg);
+
+	return 0;
+}
+
+static int tas2552_set_dai_sysclk(struct snd_soc_dai *dai, int clk_id,
+				  unsigned int freq, int dir)
+{
+	u8 cfg2_reg;
+	struct tas2552_data *data = dev_get_drvdata(dai->dev);
+
+	switch (freq) {
+	case 12288000:
+	case 26000000:
+	case 19200000:
+	case 24576000:
+		break;
+	case 48000:
+	case 32576:
+		break;
+	default:
+		break;
+	}
+
+	tas2552_sw_shutdown(data, 1);
+	cfg2_reg = tas2552_i2c_read(data, TAS2552_CFG_2);
+	tas2552_i2c_write(data, TAS2552_CFG_2, cfg2_reg & ~TAS2552_PLL_ENABLE);
+
+	tas2552_i2c_write(data, TAS2552_PLL_CTRL_1, 0x10);
+	tas2552_i2c_write(data, TAS2552_PLL_CTRL_2, 0x00);
+	tas2552_i2c_write(data, TAS2552_PLL_CTRL_3, 0x00);
+
+	cfg2_reg = tas2552_i2c_read(data, TAS2552_CFG_2);
+	tas2552_i2c_write(data, TAS2552_CFG_2, cfg2_reg | TAS2552_PLL_ENABLE);
+
+	tas2552_sw_shutdown(data, 0);
+
+	return 0;
+}
+
+static int tas2552_mute(struct snd_soc_dai *dai, int mute)
+{
+	u8 cfg1_reg;
+
+	struct tas2552_data *data = dev_get_drvdata(dai->dev);
+
+	cfg1_reg = tas2552_i2c_read(data, TAS2552_CFG_1);
+	if (mute)
+		cfg1_reg |= (mute << 2);
+	else
+		cfg1_reg &= TAS2552_MUTE_MASK;
+
+	tas2552_i2c_write(data, TAS2552_CFG_1, cfg1_reg);
+
+	return 0;
+}
+
+static int tas2552_startup(struct snd_pcm_substream *substream,
+			   struct snd_soc_dai *dai)
+{
+	struct snd_soc_codec *codec = dai->codec;
+	struct tas2552_data *tas2552 = snd_soc_codec_get_drvdata(codec);
+
+	tas2552_sw_shutdown(tas2552, 1);
+	tas2552_power(tas2552, 1);
+	/* Turn on Class D amplifier */
+	tas2552_i2c_write(tas2552, TAS2552_CFG_2, 0x80);
+	tas2552_sw_shutdown(tas2552, 0);
+
+	return 0;
+}
+
+static void tas2552_shutdown(struct snd_pcm_substream *substream,
+			   struct snd_soc_dai *dai)
+{
+	struct snd_soc_codec *codec = dai->codec;
+	struct tas2552_data *tas2552 = snd_soc_codec_get_drvdata(codec);
+
+	tas2552_sw_shutdown(tas2552, 1);
+	tas2552_power(tas2552, 0);
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
+static int tas2552_codec_probe(struct snd_soc_codec *codec)
+{
+	struct tas2552_data *tas2552 = snd_soc_codec_get_drvdata(codec);
+
+	tas2552->codec = codec;
+	tas2552_power(tas2552, 1);
+	tas2552_init(codec);
+
+	return 0;
+}
+
+static int tas2552_codec_remove(struct snd_soc_codec *codec)
+{
+	struct tas2552_data *tas2552 = snd_soc_codec_get_drvdata(codec);
+
+	tas2552_power(tas2552, 0);
+
+	return 0;
+};
+
+static struct snd_soc_codec_driver soc_codec_dev_tas2552 = {
+	.probe = tas2552_codec_probe,
+	.remove = tas2552_codec_remove,
+	.controls = tas2552_snd_controls,
+	.num_controls = ARRAY_SIZE(tas2552_snd_controls),
+};
+
+static const struct regmap_config tas2552_regmap_config = {
+	.reg_bits = 8,
+	.val_bits = 8,
+
+	.max_register = TAS2552_MAX_REG,
+	.reg_defaults = NULL,
+	.num_reg_defaults = 0,
+	.cache_type = REGCACHE_RBTREE,
+};
+
+static int tas2552_probe(struct i2c_client *client,
+			   const struct i2c_device_id *id)
+{
+	struct device *dev;
+	struct tas2552_data *data;
+	struct tas2552_platform_data *pdata = client->dev.platform_data;
+	struct device_node *np = client->dev.of_node;
+	int ret;
+
+	dev = &client->dev;
+	data = devm_kzalloc(&client->dev, sizeof(*data), GFP_KERNEL);
+	if (data == NULL) {
+		dev_err(dev, "Can not allocate memory\n");
+		return -ENOMEM;
+	}
+
+	if (pdata) {
+		data->power_gpio = pdata->power_gpio;
+	} else if (np) {
+		data->power_gpio = of_get_named_gpio(np, "enable-gpio", 0);
+	} else {
+		dev_err(dev, "Platform data not set\n");
+		return -ENODEV;
+	}
+
+	data->regmap = devm_regmap_init_i2c(client, &tas2552_regmap_config);
+	if (IS_ERR(data->regmap)) {
+		ret = PTR_ERR(data->regmap);
+		dev_err(&client->dev, "Failed to allocate register map: %d\n",
+			ret);
+		return ret;
+	}
+
+	data->tas2552_client = client;
+	dev_set_drvdata(&client->dev, data);
+
+	mutex_init(&data->mutex);
+
+	if (data->power_gpio >= 0) {
+		ret = devm_gpio_request(dev, data->power_gpio, "tas2552 enable");
+		if (ret < 0) {
+			dev_err(dev, "Failed to request power GPIO (%d)\n",
+				data->power_gpio);
+			goto err_gpio;
+		}
+		gpio_direction_output(data->power_gpio, 0);
+	}
+
+	ret = snd_soc_register_codec(&client->dev,
+				      &soc_codec_dev_tas2552,
+				      tas2552_dai, ARRAY_SIZE(tas2552_dai));
+	if (ret < 0)
+		dev_err(&client->dev, "Failed to register codec: %d\n", ret);
+
+#ifdef TAS2552_DEBUG
+	ret = sysfs_create_group(&client->dev.kobj, &tas2552_attr_group);
+	if (ret) {
+		pr_err("%s:Cannot create sysfs group\n", __func__);
+		goto err_sysfs;
+	}
+#endif
+	return 0;
+#ifdef TAS2552_DEBUG
+err_sysfs:
+	snd_soc_unregister_codec(&client->dev);
+#endif
+err_gpio:
+	data->tas2552_client = NULL;
+	return ret;
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
+		.name = "tas2552-codec",
+		.owner = THIS_MODULE,
+		.of_match_table = of_match_ptr(tas2552_of_match),
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
index 0000000..5ba583a
--- /dev/null
+++ b/sound/soc/codecs/tas2552.h
@@ -0,0 +1,79 @@
+/*
+ * ALSA SoC Texas Instruments TAS2552 Mono Audio Amplifier
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
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
+ * 02110-1301 USA
+ *
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
+#define TAS2552_LIMIT_LVL_CTRL	0x0d
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
+#define TAS2552_MUTE_MASK		0xfb
+#define TAS2552_SWS_MASK		0xfd
+#define TAS2552_WCLK_MASK		0x07
+
+#define TAS2552_PLL_ENABLE		0x08
+
+/* CFG3 Register Masks */
+#define TAS2552_WORD_CLK_MASK		0x80
+#define TAS2552_BIT_CLK_MASK		0x40
+#define TAS2552_DATA_FORMAT_MASK	0x0c
+
+#define TAS2552_DAIFMT_DSP			0x04
+#define TAS2552_DAIFMT_RIGHT_J		0x08
+#define TAS2552_DAIFMT_LEFT_J		0x0c
+
+/* WCLK Dividers */
+#define TAS2552_8KHZ		0x00
+#define TAS2552_11_12KHZ	0x01
+#define TAS2552_16KHZ		0x02
+#define TAS2552_22_24KHZ	0x03
+#define TAS2552_32KHZ		0x04
+#define TAS2552_44_48KHZ	0x05
+#define TAS2552_88_96KHZ	0x06
+#define TAS2552_176_192KHZ	0x07
+
+#endif
-- 
1.7.9.5

