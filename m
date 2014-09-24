Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753285AbaIXM55 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 08:57:57 -0400
Received: from ns.mm-sol.com ([37.157.136.199]:49726 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750742AbaIXM5x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 08:57:53 -0400
From: Stanimir Varbanov <svarbanov@mm-sol.com>
To: Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Pawel Moll <pawel.moll@arm.com>, Rob Herring <robh+dt@kernel.org>,
        Kumar Gala <galak@codeaurora.org>, Mark Rutland <mark.rutland@arm.com>,
        Grant Likely <grant.likely@linaro.org>,
        Jonathan Cameron <jic23@kernel.org>, Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-iio@vger.kernel.org, devicetree@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Lars-Peter Clausen <lars@metafoo.de>, Hartmut Knaack <knaack.h@gmx.de>,
        Angelo Compagnucci <angelo.compagnucci@gmail.com>,
        Doug Anderson <dianders@chromium.org>,
        Fugang Duan <B38611@freescale.com>,
        Johannes Thumshirn <johannes.thumshirn@men.de>,
        Jean Delvare <jdelvare@suse.de>, Philippe Reynes <tremyfr@yahoo.fr>,
        Lee Jones <lee.jones@linaro.org>,
        Josh Cartwright <joshc@codeaurora.org>,
        Stephen Boyd <sboyd@codeaurora.org>,
        David Collins <collinsd@codeaurora.org>,
        Stanimir Varbanov <svarbanov@mm-sol.com>,
        "Ivan T. Ivanov" <iivanov@mm-sol.com>
Subject: [PATCH v3 1/2] iio: vadc: Qualcomm SPMI PMIC voltage ADC driver
Date: Wed, 24 Sep 2014 15:56:54 +0300
Message-Id: <1411563415-11933-2-git-send-email-svarbanov@mm-sol.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1411563415-11933-1-git-send-email-svarbanov@mm-sol.com>
References: <1411563415-11933-1-git-send-email-svarbanov@mm-sol.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The voltage ADC is peripheral of Qualcomm SPMI PMIC chips. It has
15bits resolution and register space inside PMIC accessible across
SPMI bus.

The vadc driver registers itself through IIO interface.

Signed-off-by: Stanimir Varbanov <svarbanov@mm-sol.com>
Signed-off-by: Ivan T. Ivanov <iivanov@mm-sol.com>
---
 drivers/iio/adc/Kconfig                       |   10 +
 drivers/iio/adc/Makefile                      |    1 +
 drivers/iio/adc/qcom-spmi-vadc.c              | 1029 +++++++++++++++++++++++++
 include/dt-bindings/iio/qcom,spmi-pmic-vadc.h |  119 +++
 4 files changed, 1159 insertions(+), 0 deletions(-)
 create mode 100644 drivers/iio/adc/qcom-spmi-vadc.c
 create mode 100644 include/dt-bindings/iio/qcom,spmi-pmic-vadc.h

diff --git a/drivers/iio/adc/Kconfig b/drivers/iio/adc/Kconfig
index 11b048a..ec48360 100644
--- a/drivers/iio/adc/Kconfig
+++ b/drivers/iio/adc/Kconfig
@@ -206,6 +206,16 @@ config NAU7802
 	  To compile this driver as a module, choose M here: the
 	  module will be called nau7802.
 
+config QCOM_SPMI_VADC
+	tristate "Qualcomm SPMI PMIC voltage ADC"
+	depends on SPMI
+	help
+	  Say yes here if you want support for the Qualcomm SPMI PMIC voltage ADC.
+
+	  The driver supports reading the HKADC, XOADC through the ADC AMUX arbiter.
+	  The driver supports reading the ADC through the AMUX channels for
+	  external pull-ups simultaneously.
+
 config TI_ADC081C
 	tristate "Texas Instruments ADC081C021/027"
 	depends on I2C
diff --git a/drivers/iio/adc/Makefile b/drivers/iio/adc/Makefile
index ad81b51..d5d18f4 100644
--- a/drivers/iio/adc/Makefile
+++ b/drivers/iio/adc/Makefile
@@ -22,6 +22,7 @@ obj-$(CONFIG_MCP320X) += mcp320x.o
 obj-$(CONFIG_MCP3422) += mcp3422.o
 obj-$(CONFIG_MEN_Z188_ADC) += men_z188_adc.o
 obj-$(CONFIG_NAU7802) += nau7802.o
+obj-$(CONFIG_QCOM_SPMI_VADC) += qcom-spmi-vadc.o
 obj-$(CONFIG_TI_ADC081C) += ti-adc081c.o
 obj-$(CONFIG_TI_AM335X_ADC) += ti_am335x_adc.o
 obj-$(CONFIG_TWL4030_MADC) += twl4030-madc.o
diff --git a/drivers/iio/adc/qcom-spmi-vadc.c b/drivers/iio/adc/qcom-spmi-vadc.c
new file mode 100644
index 0000000..9e3e022
--- /dev/null
+++ b/drivers/iio/adc/qcom-spmi-vadc.c
@@ -0,0 +1,1029 @@
+/*
+ * Copyright (c) 2012-2014, The Linux Foundation. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 and
+ * only version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#include <linux/bitops.h>
+#include <linux/completion.h>
+#include <linux/delay.h>
+#include <linux/err.h>
+#include <linux/iio/iio.h>
+#include <linux/interrupt.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/of.h>
+#include <linux/platform_device.h>
+#include <linux/regmap.h>
+#include <linux/slab.h>
+#include <linux/log2.h>
+
+#include <dt-bindings/iio/qcom,spmi-pmic-vadc.h>
+
+/* VADC register and bit definitions */
+#define VADC_REVISION2				0x1
+#define VADC_REVISION2_SUPPORTED_VADC		1
+
+#define VADC_PERPH_TYPE				0x4
+#define VADC_PERPH_TYPE_ADC			8
+
+#define VADC_PERPH_SUBTYPE			0x5
+#define VADC_PERPH_SUBTYPE_VADC			1
+
+#define VADC_STATUS1				0x8
+#define VADC_STATUS1_OP_MODE			4
+#define VADC_STATUS1_REQ_STS			BIT(1)
+#define VADC_STATUS1_EOC			BIT(0)
+#define VADC_STATUS1_REQ_STS_EOC_MASK		0x3
+
+#define VADC_MODE_CTL				0x40
+#define VADC_OP_MODE_SHIFT			3
+#define VADC_OP_MODE_NORMAL			0
+#define VADC_AMUX_TRIM_EN			BIT(1)
+#define VADC_ADC_TRIM_EN			BIT(0)
+
+#define VADC_EN_CTL1				0x46
+#define VADC_EN_CTL1_SET			BIT(7)
+
+#define VADC_ADC_CH_SEL_CTL			0x48
+
+#define VADC_ADC_DIG_PARAM			0x50
+#define VADC_ADC_DIG_DEC_RATIO_SEL_SHIFT	2
+
+#define VADC_HW_SETTLE_DELAY			0x51
+
+#define VADC_CONV_REQ				0x52
+#define VADC_CONV_REQ_SET			BIT(7)
+
+#define VADC_FAST_AVG_CTL			0x5a
+#define VADC_FAST_AVG_EN			0x5b
+#define VADC_FAST_AVG_EN_SET			BIT(7)
+
+#define VADC_ACCESS				0xd0
+#define VADC_ACCESS_DATA			0xa5
+
+#define VADC_PERH_RESET_CTL3			0xda
+#define VADC_FOLLOW_WARM_RB			BIT(2)
+
+#define VADC_DATA0				0x60
+#define VADC_DATA1				0x61
+
+#define VADC_CONV_TIME_MIN_US			2000
+#define VADC_CONV_TIME_MAX_US			2100
+
+/* Min ADC code represents 0V */
+#define VADC_MIN_ADC_CODE			0x6000
+/* Max ADC code represents full-scale range of 1.8V */
+#define VADC_MAX_ADC_CODE			0xa800
+
+#define VADC_ABSOLUTE_RANGE_UV			625000
+#define VADC_RATIOMETRIC_RANGE_UV		1800000
+
+#define VADC_DEF_PRESCALING			0 /* 1:1 */
+#define VADC_DEF_DECIMATION			0 /* 512 */
+#define VADC_DEF_HW_SETTLE_TIME			0 /* 0 us */
+#define VADC_DEF_AVG_SAMPLES			0 /* 1 sample */
+#define VADC_DEF_CALIB_TYPE			VADC_CALIB_ABSOLUTE
+
+#define VADC_DECIMATION_MIN			512
+#define VADC_DECIMATION_MAX			4096
+
+#define VADC_HW_SETTLE_DELAY_MAX		10000
+#define VADC_AVG_SAMPLES_MAX			512
+
+#define KELVINMIL_CELSIUSMIL			273150
+
+#define VADC_CHAN_MIN			VADC_USBIN
+#define VADC_CHAN_MAX			VADC_LR_MUX3_BUF_PU1_PU2_XO_THERM
+
+/*
+ * VADC_CALIB_ABSOLUTE: uses the 625mV and 1.25V reference channels.
+ * VADC_CALIB_RATIOMETRIC: uses the reference Voltage/GND for calibration.
+ */
+enum vadc_calibration {
+	VADC_CALIB_ABSOLUTE = 0,
+	VADC_CALIB_RATIOMETRIC
+};
+
+/**
+ * struct vadc_linear_graph - Represent ADC characteristics.
+ * @dy: numerator slope to calculate the gain.
+ * @dx: denominator slope to calculate the gain.
+ * @vref: A/D word of the voltage reference used for the channel.
+ * @gnd: A/D word of the ground reference used for the channel.
+ *
+ * Each ADC device has different offset and gain parameters which are
+ * computed to calibrate the device.
+ */
+struct vadc_linear_graph {
+	s32 dy;
+	s32 dx;
+	s32 vref;
+	s32 gnd;
+};
+
+/**
+ * struct vadc_prescale_ratio - Represent scaling ratio for ADC input.
+ * @num: the inverse numerator of the gain applied to the input channel.
+ * @den: the inverse denominator of the gain applied to the input channel.
+ */
+struct vadc_prescale_ratio {
+	u32 num;
+	u32 den;
+};
+
+/**
+ * struct vadc_channel_prop - VADC channel property.
+ * @channel: channel number, refer to the channel list.
+ * @calibration: calibration type.
+ * @decimation: sampling rate supported for the channel.
+ * @prescale: channel scaling performed on the input signal.
+ * @hw_settle_time: the time between AMUX being configured and the
+ *	start of conversion.
+ * @avg_samples: ability to provide single result from the ADC
+ *	that is an average of multiple measurements.
+ */
+struct vadc_channel_prop {
+	unsigned int channel;
+	enum vadc_calibration calibration;
+	unsigned int decimation;
+	unsigned int prescale;
+	unsigned int hw_settle_time;
+	unsigned int avg_samples;
+};
+
+/**
+ * struct vadc_priv - VADC private structure.
+ * @regmap: pointer to struct regmap.
+ * @dev: pointer to struct device.
+ * @base: base address for the ADC peripheral.
+ * @nchannels: number of VADC channels.
+ * @chan_props: array of VADC channel properties.
+ * @iio_chans: array of IIO channels specification.
+ * @are_ref_measured: are reference points measured.
+ * @poll_eoc: use polling instead of interrupt.
+ * @complete: VADC result notification after interrupt is received.
+ * @graph: store parameters for calibration.
+ */
+struct vadc_priv {
+	struct regmap *regmap;
+	struct device *dev;
+	u16 base;
+	unsigned int nchannels;
+	struct vadc_channel_prop *chan_props;
+	struct iio_chan_spec *iio_chans;
+	bool are_ref_measured;
+	bool poll_eoc;
+	struct completion complete;
+	struct vadc_linear_graph graph[2];
+};
+
+static const struct vadc_prescale_ratio vadc_prescale_ratios[] = {
+	{.num =  1, .den =  1},
+	{.num =  1, .den =  3},
+	{.num =  1, .den =  4},
+	{.num =  1, .den =  6},
+	{.num =  1, .den = 20},
+	{.num =  1, .den =  8},
+	{.num = 10, .den = 81},
+	{.num =  1, .den = 10}
+};
+
+static int vadc_read(struct vadc_priv *vadc, u16 offset, u8 *data)
+{
+	return regmap_bulk_read(vadc->regmap, vadc->base + offset, data, 1);
+}
+
+static int vadc_write(struct vadc_priv *vadc, u16 offset, u8 data)
+{
+	return regmap_write(vadc->regmap, vadc->base + offset, data);
+}
+
+static int vadc_reset(struct vadc_priv *vadc)
+{
+	u8 data;
+	int ret;
+
+	ret = vadc_write(vadc, VADC_ACCESS, VADC_ACCESS_DATA);
+	if (ret)
+		return ret;
+
+	ret = vadc_read(vadc, VADC_PERH_RESET_CTL3, &data);
+	if (ret)
+		return ret;
+
+	ret = vadc_write(vadc, VADC_ACCESS, VADC_ACCESS_DATA);
+	if (ret)
+		return ret;
+
+	data |= VADC_FOLLOW_WARM_RB;
+
+	return vadc_write(vadc, VADC_PERH_RESET_CTL3, data);
+}
+
+static int vadc_enable(struct vadc_priv *vadc, bool state)
+{
+	return vadc_write(vadc, VADC_EN_CTL1, state ? VADC_EN_CTL1_SET : 0);
+}
+
+#ifdef DEBUG
+static void vadc_show_status(struct vadc_priv *vadc)
+{
+	u8 mode, sta1, chan, dig, en, req;
+	int ret;
+
+	ret = vadc_read(vadc, VADC_MODE_CTL, &mode);
+	if (ret)
+		return;
+
+	ret = vadc_read(vadc, VADC_ADC_DIG_PARAM, &dig);
+	if (ret)
+		return;
+
+	ret = vadc_read(vadc, VADC_ADC_CH_SEL_CTL, &chan);
+	if (ret)
+		return;
+
+	ret = vadc_read(vadc, VADC_CONV_REQ, &req);
+	if (ret)
+		return;
+
+	ret = vadc_read(vadc, VADC_STATUS1, &sta1);
+	if (ret)
+		return;
+
+	ret = vadc_read(vadc, VADC_EN_CTL1, &en);
+	if (ret)
+		return;
+
+	dev_dbg(vadc->dev,
+		"mode:%02x en:%02x chan:%02x dig:%02x req:%02x sta1:%02x\n",
+		mode, en, chan, dig, req, sta1);
+}
+#else
+static void vadc_show_status(struct vadc_priv *vadc) {}
+#endif
+
+static int vadc_configure(struct vadc_priv *vadc,
+			  struct vadc_channel_prop *prop)
+{
+	u8 decimation, mode_ctrl;
+	int ret;
+
+	/* Mode selection */
+	mode_ctrl = (VADC_OP_MODE_NORMAL << VADC_OP_MODE_SHIFT) |
+		     VADC_ADC_TRIM_EN | VADC_AMUX_TRIM_EN;
+	ret = vadc_write(vadc, VADC_MODE_CTL, mode_ctrl);
+	if (ret)
+		return ret;
+
+	/* Channel selection */
+	ret = vadc_write(vadc, VADC_ADC_CH_SEL_CTL, prop->channel);
+	if (ret)
+		return ret;
+
+	/* Digital parameter setup */
+	decimation = prop->decimation << VADC_ADC_DIG_DEC_RATIO_SEL_SHIFT;
+	ret = vadc_write(vadc, VADC_ADC_DIG_PARAM, decimation);
+	if (ret)
+		return ret;
+
+	/* HW settle time delay */
+	ret = vadc_write(vadc, VADC_HW_SETTLE_DELAY, prop->hw_settle_time);
+	if (ret)
+		return ret;
+
+	ret = vadc_write(vadc, VADC_FAST_AVG_CTL, prop->avg_samples);
+	if (ret)
+		return ret;
+
+	if (prop->avg_samples)
+		ret = vadc_write(vadc, VADC_FAST_AVG_EN, VADC_FAST_AVG_EN_SET);
+	else
+		ret = vadc_write(vadc, VADC_FAST_AVG_EN, 0);
+
+	return ret;
+}
+
+static int vadc_poll_wait_eoc(struct vadc_priv *vadc, unsigned int interval_us)
+{
+	unsigned int count, retry;
+	u8 sta1;
+	int ret;
+
+	retry = interval_us / VADC_CONV_TIME_MIN_US;
+
+	for (count = 0; count < retry; count++) {
+		ret = vadc_read(vadc, VADC_STATUS1, &sta1);
+		if (ret)
+			return ret;
+
+		sta1 &= VADC_STATUS1_REQ_STS_EOC_MASK;
+		if (sta1 == VADC_STATUS1_EOC)
+			return 0;
+
+		usleep_range(VADC_CONV_TIME_MIN_US, VADC_CONV_TIME_MAX_US);
+	}
+
+	vadc_show_status(vadc);
+
+	return -ETIMEDOUT;
+}
+
+static int vadc_read_result(struct vadc_priv *vadc, s32 *data)
+{
+	u8 lsb, msb;
+	int ret;
+
+	ret = vadc_read(vadc, VADC_DATA0, &lsb);
+	if (ret)
+		return ret;
+
+	ret = vadc_read(vadc, VADC_DATA1, &msb);
+	if (ret)
+		return ret;
+
+	*data = clamp_t(s32, (msb << 8) | lsb, VADC_MIN_ADC_CODE,
+			VADC_MAX_ADC_CODE);
+
+	return 0;
+}
+
+static struct vadc_channel_prop *vadc_get_channel(struct vadc_priv *vadc,
+						  int num)
+{
+	unsigned int i;
+
+	for (i = 0; i < vadc->nchannels; i++)
+		if (vadc->chan_props[i].channel == num)
+			return &vadc->chan_props[i];
+
+	dev_dbg(vadc->dev, "no such channel %02x\n", num);
+
+	return NULL;
+}
+
+static int vadc_do_conversion(struct vadc_priv *vadc,
+			      struct vadc_channel_prop *prop, s32 *data)
+{
+	unsigned int timeout;
+	int ret;
+
+	ret = vadc_configure(vadc, prop);
+	if (ret)
+		return ret;
+
+	if (!vadc->poll_eoc)
+		reinit_completion(&vadc->complete);
+
+	ret = vadc_enable(vadc, true);
+	if (ret)
+		return ret;
+
+	ret = vadc_write(vadc, VADC_CONV_REQ, VADC_CONV_REQ_SET);
+	if (ret)
+		goto err_disable;
+
+	timeout = BIT(prop->avg_samples) * VADC_CONV_TIME_MIN_US * 2;
+
+	if (vadc->poll_eoc) {
+		ret = vadc_poll_wait_eoc(vadc, timeout);
+	} else {
+		ret = wait_for_completion_timeout(&vadc->complete,
+						  msecs_to_jiffies(1000));
+		if (!ret) {
+			ret = -ETIMEDOUT;
+			goto err_disable;
+		}
+
+		/* double check conversion status */
+		ret = vadc_poll_wait_eoc(vadc, VADC_CONV_TIME_MIN_US * 2);
+		if (ret)
+			goto err_disable;
+	}
+
+	ret = vadc_read_result(vadc, data);
+
+err_disable:
+	vadc_enable(vadc, false);
+
+	if (ret)
+		dev_dbg(vadc->dev, "conversion failed\n");
+
+	return ret;
+}
+
+static int vadc_measure_ref_points(struct vadc_priv *vadc)
+{
+	struct vadc_channel_prop *prop;
+	s32 read_1, read_2;
+	int ret = -EINVAL;
+
+	vadc->graph[VADC_CALIB_RATIOMETRIC].dx = VADC_RATIOMETRIC_RANGE_UV;
+	vadc->graph[VADC_CALIB_ABSOLUTE].dx = VADC_ABSOLUTE_RANGE_UV;
+
+	prop = vadc_get_channel(vadc, VADC_REF_1250MV);
+	if (!prop)
+		goto err;
+
+	ret = vadc_do_conversion(vadc, prop, &read_1);
+	if (ret)
+		goto err;
+
+	/* Try with buffered 625mV channel first */
+	prop = vadc_get_channel(vadc, VADC_SPARE1);
+	if (!prop) {
+		prop = vadc_get_channel(vadc, VADC_REF_625MV);
+		if (!prop) {
+			ret = -EINVAL;
+			goto err;
+		}
+	}
+
+	ret = vadc_do_conversion(vadc, prop, &read_2);
+	if (ret)
+		goto err;
+
+	if (read_1 == read_2) {
+		ret = -EINVAL;
+		goto err;
+	}
+
+	vadc->graph[VADC_CALIB_ABSOLUTE].dy = read_1 - read_2;
+	vadc->graph[VADC_CALIB_ABSOLUTE].vref = read_1;
+	vadc->graph[VADC_CALIB_ABSOLUTE].gnd = read_2;
+
+	/* Ratiometric calibration */
+	prop = vadc_get_channel(vadc, VADC_VDD_VADC);
+	if (!prop) {
+		ret = -EINVAL;
+		goto err;
+	}
+
+	ret = vadc_do_conversion(vadc, prop, &read_1);
+	if (ret)
+		goto err;
+
+	prop = vadc_get_channel(vadc, VADC_GND_REF);
+	if (!prop) {
+		ret = -EINVAL;
+		goto err;
+	}
+
+	ret = vadc_do_conversion(vadc, prop, &read_2);
+	if (ret)
+		goto err;
+
+	if (read_1 == read_2) {
+		ret = -EINVAL;
+		goto err;
+	}
+
+	vadc->graph[VADC_CALIB_RATIOMETRIC].dy = read_1 - read_2;
+	vadc->graph[VADC_CALIB_RATIOMETRIC].vref = read_1;
+	vadc->graph[VADC_CALIB_RATIOMETRIC].gnd = read_2;
+err:
+	if (ret)
+		dev_dbg(vadc->dev, "measure reference points failed\n");
+
+	return ret;
+}
+
+static s64 vadc_calibrate(struct vadc_priv *vadc,
+			  const struct vadc_channel_prop *prop, s32 adc_code)
+{
+	const struct vadc_prescale_ratio *prescale;
+	bool negative = false;
+	s64 voltage;
+
+	voltage = adc_code - vadc->graph[prop->calibration].gnd;
+	voltage *= vadc->graph[prop->calibration].dx;
+
+	if (voltage < 0) {
+		negative = true;
+		voltage = -voltage;
+	}
+
+	voltage = div_s64(voltage, vadc->graph[prop->calibration].dy);
+	if (negative)
+		voltage = -voltage;
+
+	if (prop->calibration == VADC_CALIB_ABSOLUTE)
+		voltage += vadc->graph[prop->calibration].dx;
+
+	if (voltage < 0)
+		voltage = 0;
+
+	prescale = &vadc_prescale_ratios[prop->prescale];
+
+	voltage = voltage * prescale->den;
+
+	return div_s64(voltage, prescale->num);
+}
+
+static int vadc_decimation_from_dt(u32 value)
+{
+	if (!is_power_of_2(value) || !value || value < VADC_DECIMATION_MIN ||
+	    value > VADC_DECIMATION_MAX)
+		return -EINVAL;
+
+	return __ffs64(value / VADC_DECIMATION_MIN);
+}
+
+static int vadc_prescaling_from_dt(u32 num, u32 den)
+{
+	unsigned int pre;
+
+	for (pre = 0; pre < ARRAY_SIZE(vadc_prescale_ratios); pre++)
+		if (vadc_prescale_ratios[pre].num == num &&
+		    vadc_prescale_ratios[pre].den == den)
+			break;
+
+	if (pre == ARRAY_SIZE(vadc_prescale_ratios))
+		return -EINVAL;
+
+	return pre;
+}
+
+static int vadc_hw_settle_time_from_dt(u32 value)
+{
+	if ((value <= 1000 && value % 100) || (value > 1000 && value % 2000))
+		return -EINVAL;
+
+	if (value <= 1000)
+		value /= 100;
+	else
+		value = value / 2000 + 10;
+
+	return value;
+}
+
+static int vadc_avg_samples_from_dt(u32 value)
+{
+	if (!is_power_of_2(value) || !value || value > VADC_AVG_SAMPLES_MAX)
+		return -EINVAL;
+
+	return __ffs64(value);
+}
+
+static int vadc_read_raw(struct iio_dev *indio_dev,
+			 struct iio_chan_spec const *chan, int *val, int *val2,
+			 long mask)
+{
+	struct vadc_priv *vadc = iio_priv(indio_dev);
+	struct vadc_channel_prop *prop;
+	s32 adc_code;
+	int ret;
+
+	if (!vadc->are_ref_measured) {
+		ret = vadc_measure_ref_points(vadc);
+		if (ret)
+			return ret;
+
+		vadc->are_ref_measured = true;
+	}
+
+	if (mask == IIO_CHAN_INFO_PROCESSED || mask == IIO_CHAN_INFO_RAW) {
+		prop = &vadc->chan_props[chan->address];
+
+		ret = vadc_do_conversion(vadc, prop, &adc_code);
+		if (ret)
+			return ret;
+
+		*val = vadc_calibrate(vadc, prop, adc_code);
+	}
+
+	switch (mask) {
+	case IIO_CHAN_INFO_PROCESSED:
+		if (chan->type != IIO_TEMP && chan->channel != VADC_DIE_TEMP)
+			return -EINVAL;
+
+		/* 2mV/K, return milliCelsius */
+		*val /= 2;
+		*val -= KELVINMIL_CELSIUSMIL;
+		return IIO_VAL_INT;
+	case IIO_CHAN_INFO_RAW:
+		return IIO_VAL_INT;
+	case IIO_CHAN_INFO_SCALE:
+		*val = 0;
+		*val2 = 1000;
+		return IIO_VAL_INT_PLUS_MICRO;
+	default:
+		break;
+	}
+
+	return -EINVAL;
+}
+
+static const struct iio_info vadc_info = {
+	.read_raw = vadc_read_raw,
+	.driver_module = THIS_MODULE,
+};
+
+struct vadc_channels {
+	const char *datasheet_name;
+	unsigned int prescale_index;
+	enum iio_chan_type type;
+	long info_mask;
+};
+
+#define VADC_CHAN(_dname, _type, _mask, _pre)				\
+	[VADC_##_dname] = {						\
+		.datasheet_name = __stringify(_dname),			\
+		.prescale_index = _pre,					\
+		.type = _type,						\
+		.info_mask = _mask					\
+	},								\
+
+#define VADC_CHAN_TEMP(_dname, _pre)					\
+	VADC_CHAN(_dname, IIO_TEMP, BIT(IIO_CHAN_INFO_PROCESSED), _pre)	\
+
+#define VADC_CHAN_VOLT(_dname, _pre)					\
+	VADC_CHAN(_dname, IIO_VOLTAGE,					\
+		  BIT(IIO_CHAN_INFO_RAW) | BIT(IIO_CHAN_INFO_SCALE),	\
+		  _pre)							\
+
+/*
+ * The array represents all possible ADC channels found in the supported PMICs.
+ * Every index in the array is equal to the channel number per datasheet. The
+ * gaps in the array should be treated as reserved channels.
+ */
+static const struct vadc_channels vadc_chans[] = {
+	VADC_CHAN_VOLT(USBIN, 4)
+	VADC_CHAN_VOLT(DCIN, 4)
+	VADC_CHAN_VOLT(VCHG_SNS, 3)
+	VADC_CHAN_VOLT(SPARE1_03, 1)
+	VADC_CHAN_VOLT(USB_ID_MV, 1)
+	VADC_CHAN_VOLT(VCOIN, 1)
+	VADC_CHAN_VOLT(VBAT_SNS, 1)
+	VADC_CHAN_VOLT(VSYS, 1)
+	VADC_CHAN_TEMP(DIE_TEMP, 0)
+	VADC_CHAN_VOLT(REF_625MV, 0)
+	VADC_CHAN_VOLT(REF_1250MV, 0)
+	VADC_CHAN_VOLT(CHG_TEMP, 0)
+	VADC_CHAN_VOLT(SPARE1, 0)
+	VADC_CHAN_VOLT(SPARE2, 0)
+	VADC_CHAN_VOLT(GND_REF, 0)
+	VADC_CHAN_VOLT(VDD_VADC, 0)
+
+	VADC_CHAN_VOLT(P_MUX1_1_1, 0)
+	VADC_CHAN_VOLT(P_MUX2_1_1, 0)
+	VADC_CHAN_VOLT(P_MUX3_1_1, 0)
+	VADC_CHAN_VOLT(P_MUX4_1_1, 0)
+	VADC_CHAN_VOLT(P_MUX5_1_1, 0)
+	VADC_CHAN_VOLT(P_MUX6_1_1, 0)
+	VADC_CHAN_VOLT(P_MUX7_1_1, 0)
+	VADC_CHAN_VOLT(P_MUX8_1_1, 0)
+	VADC_CHAN_VOLT(P_MUX9_1_1, 0)
+	VADC_CHAN_VOLT(P_MUX10_1_1, 0)
+	VADC_CHAN_VOLT(P_MUX11_1_1, 0)
+	VADC_CHAN_VOLT(P_MUX12_1_1, 0)
+	VADC_CHAN_VOLT(P_MUX13_1_1, 0)
+	VADC_CHAN_VOLT(P_MUX14_1_1, 0)
+	VADC_CHAN_VOLT(P_MUX15_1_1, 0)
+	VADC_CHAN_VOLT(P_MUX16_1_1, 0)
+
+	VADC_CHAN_VOLT(P_MUX1_1_3, 1)
+	VADC_CHAN_VOLT(P_MUX2_1_3, 1)
+	VADC_CHAN_VOLT(P_MUX3_1_3, 1)
+	VADC_CHAN_VOLT(P_MUX4_1_3, 1)
+	VADC_CHAN_VOLT(P_MUX5_1_3, 1)
+	VADC_CHAN_VOLT(P_MUX6_1_3, 1)
+	VADC_CHAN_VOLT(P_MUX7_1_3, 1)
+	VADC_CHAN_VOLT(P_MUX8_1_3, 1)
+	VADC_CHAN_VOLT(P_MUX9_1_3, 1)
+	VADC_CHAN_VOLT(P_MUX10_1_3, 1)
+	VADC_CHAN_VOLT(P_MUX11_1_3, 1)
+	VADC_CHAN_VOLT(P_MUX12_1_3, 1)
+	VADC_CHAN_VOLT(P_MUX13_1_3, 1)
+	VADC_CHAN_VOLT(P_MUX14_1_3, 1)
+	VADC_CHAN_VOLT(P_MUX15_1_3, 1)
+	VADC_CHAN_VOLT(P_MUX16_1_3, 1)
+
+	VADC_CHAN_VOLT(LR_MUX1_BAT_THERM, 0)
+	VADC_CHAN_VOLT(LR_MUX2_BAT_ID, 0)
+	VADC_CHAN_VOLT(LR_MUX3_XO_THERM, 0)
+	VADC_CHAN_VOLT(LR_MUX4_AMUX_THM1, 0)
+	VADC_CHAN_VOLT(LR_MUX5_AMUX_THM2, 0)
+	VADC_CHAN_VOLT(LR_MUX6_AMUX_THM3, 0)
+	VADC_CHAN_VOLT(LR_MUX7_HW_ID, 0)
+	VADC_CHAN_VOLT(LR_MUX8_AMUX_THM4, 0)
+	VADC_CHAN_VOLT(LR_MUX9_AMUX_THM5, 0)
+	VADC_CHAN_VOLT(LR_MUX10_USB_ID, 0)
+	VADC_CHAN_VOLT(AMUX_PU1, 0)
+	VADC_CHAN_VOLT(AMUX_PU2, 0)
+	VADC_CHAN_VOLT(LR_MUX3_BUF_XO_THERM, 0)
+
+	VADC_CHAN_VOLT(LR_MUX1_PU1_BAT_THERM, 0)
+	VADC_CHAN_VOLT(LR_MUX2_PU1_BAT_ID, 0)
+	VADC_CHAN_VOLT(LR_MUX3_PU1_XO_THERM, 0)
+	VADC_CHAN_VOLT(LR_MUX4_PU1_AMUX_THM1, 0)
+	VADC_CHAN_VOLT(LR_MUX5_PU1_AMUX_THM2, 0)
+	VADC_CHAN_VOLT(LR_MUX6_PU1_AMUX_THM3, 0)
+	VADC_CHAN_VOLT(LR_MUX7_PU1_AMUX_HW_ID, 0)
+	VADC_CHAN_VOLT(LR_MUX8_PU1_AMUX_THM4, 0)
+	VADC_CHAN_VOLT(LR_MUX9_PU1_AMUX_THM5, 0)
+	VADC_CHAN_VOLT(LR_MUX10_PU1_AMUX_USB_ID, 0)
+	VADC_CHAN_VOLT(LR_MUX3_BUF_PU1_XO_THERM, 0)
+
+	VADC_CHAN_VOLT(LR_MUX1_PU2_BAT_THERM, 0)
+	VADC_CHAN_VOLT(LR_MUX2_PU2_BAT_ID, 0)
+	VADC_CHAN_VOLT(LR_MUX3_PU2_XO_THERM, 0)
+	VADC_CHAN_VOLT(LR_MUX4_PU2_AMUX_THM1, 0)
+	VADC_CHAN_VOLT(LR_MUX5_PU2_AMUX_THM2, 0)
+	VADC_CHAN_VOLT(LR_MUX6_PU2_AMUX_THM3, 0)
+	VADC_CHAN_VOLT(LR_MUX7_PU2_AMUX_HW_ID, 0)
+	VADC_CHAN_VOLT(LR_MUX8_PU2_AMUX_THM4, 0)
+	VADC_CHAN_VOLT(LR_MUX9_PU2_AMUX_THM5, 0)
+	VADC_CHAN_VOLT(LR_MUX10_PU2_AMUX_USB_ID, 0)
+	VADC_CHAN_VOLT(LR_MUX3_BUF_PU2_XO_THERM, 0)
+
+	VADC_CHAN_VOLT(LR_MUX1_PU1_PU2_BAT_THERM, 0)
+	VADC_CHAN_VOLT(LR_MUX2_PU1_PU2_BAT_ID, 0)
+	VADC_CHAN_VOLT(LR_MUX3_PU1_PU2_XO_THERM, 0)
+	VADC_CHAN_VOLT(LR_MUX4_PU1_PU2_AMUX_THM1, 0)
+	VADC_CHAN_VOLT(LR_MUX5_PU1_PU2_AMUX_THM2, 0)
+	VADC_CHAN_VOLT(LR_MUX6_PU1_PU2_AMUX_THM3, 0)
+	VADC_CHAN_VOLT(LR_MUX7_PU1_PU2_AMUX_HW_ID, 0)
+	VADC_CHAN_VOLT(LR_MUX8_PU1_PU2_AMUX_THM4, 0)
+	VADC_CHAN_VOLT(LR_MUX9_PU1_PU2_AMUX_THM5, 0)
+	VADC_CHAN_VOLT(LR_MUX10_PU1_PU2_AMUX_USB_ID, 0)
+	VADC_CHAN_VOLT(LR_MUX3_BUF_PU1_PU2_XO_THERM, 0)
+};
+
+static int vadc_get_dt_channel_data(struct device *dev,
+				    struct vadc_channel_prop *prop,
+				    struct device_node *node)
+{
+	const char *name = node->name;
+	u32 chan, value, varr[2];
+	int ret;
+
+	ret = of_property_read_u32(node, "reg", &chan);
+	if (ret) {
+		dev_dbg(dev, "invalid channel number %s\n", name);
+		return ret;
+	}
+
+	if (chan > VADC_CHAN_MAX || chan < VADC_CHAN_MIN) {
+		dev_dbg(dev, "%s invalid channel number %d\n", name, chan);
+		return -EINVAL;
+	}
+
+	/* the channel has DT description */
+	prop->channel = chan;
+
+	ret = of_property_read_u32(node, "qcom,decimation", &value);
+	if (!ret) {
+		ret = vadc_decimation_from_dt(value);
+		if (ret < 0) {
+			dev_dbg(dev, "%02x invalid decimation %d\n",
+				chan, value);
+			return ret;
+		}
+		prop->decimation = ret;
+	} else {
+		prop->decimation = VADC_DEF_DECIMATION;
+	}
+
+	ret = of_property_read_u32_array(node, "qcom,pre-scaling", varr, 2);
+	if (!ret) {
+		ret = vadc_prescaling_from_dt(varr[0], varr[1]);
+		if (ret < 0) {
+			dev_dbg(dev, "%02x invalid pre-scaling <%d %d>\n",
+				chan, varr[0], varr[1]);
+			return ret;
+		}
+		prop->prescale = ret;
+	} else {
+		prop->prescale = vadc_chans[prop->channel].prescale_index;
+	}
+
+	ret = of_property_read_u32(node, "qcom,hw-settle-time", &value);
+	if (!ret) {
+		ret = vadc_hw_settle_time_from_dt(value);
+		if (ret < 0) {
+			dev_dbg(dev, "%02x invalid hw-settle-time %d, us\n",
+				chan, value);
+			return ret;
+		}
+		prop->hw_settle_time = ret;
+	} else {
+		prop->hw_settle_time = VADC_DEF_HW_SETTLE_TIME;
+	}
+
+	ret = of_property_read_u32(node, "qcom,avg-samples", &value);
+	if (!ret) {
+		ret = vadc_avg_samples_from_dt(value);
+		if (ret < 0) {
+			dev_dbg(dev, "%02x invalid avg-samples %d\n",
+				chan, value);
+			return ret;
+		}
+		prop->avg_samples = ret;
+	} else {
+		prop->avg_samples = VADC_DEF_AVG_SAMPLES;
+	}
+
+	if (of_property_read_bool(node, "qcom,ratiometric"))
+		prop->calibration = VADC_CALIB_RATIOMETRIC;
+	else
+		prop->calibration = VADC_CALIB_ABSOLUTE;
+
+	dev_dbg(dev, "%02x name %s\n", chan, name);
+
+	return 0;
+}
+
+static int vadc_get_dt_data(struct vadc_priv *vadc, struct device_node *node)
+{
+	struct iio_chan_spec *iio_chan = vadc->iio_chans;
+	const struct vadc_channels *vadc_chan;
+	struct vadc_channel_prop prop;
+	struct device_node *child;
+	int ret, index = 0;
+
+	for_each_available_child_of_node(node, child) {
+		ret = vadc_get_dt_channel_data(vadc->dev, &prop, child);
+		if (ret)
+			return ret;
+
+		vadc->chan_props[index] = prop;
+
+		vadc_chan = &vadc_chans[prop.channel];
+
+		iio_chan->channel = prop.channel;
+		iio_chan->datasheet_name = vadc_chan->datasheet_name;
+		iio_chan->info_mask_separate = vadc_chan->info_mask;
+		iio_chan->type = vadc_chan->type;
+		iio_chan->indexed = 1;
+		iio_chan->scan_type.sign = 's';
+		iio_chan->scan_type.realbits = 15;
+		iio_chan->scan_type.storagebits = 16;
+		iio_chan->address = index++;
+
+		iio_chan++;
+	}
+
+	return 0;
+}
+
+static irqreturn_t vadc_isr(int irq, void *dev_id)
+{
+	struct vadc_priv *vadc = dev_id;
+
+	complete(&vadc->complete);
+
+	return IRQ_HANDLED;
+}
+
+static int vadc_check_revision(struct vadc_priv *vadc)
+{
+	u8 val;
+	int ret;
+
+	ret = vadc_read(vadc, VADC_PERPH_TYPE, &val);
+	if (ret)
+		return ret;
+
+	if (val < VADC_PERPH_TYPE_ADC) {
+		dev_dbg(vadc->dev, "%d is not ADC\n", val);
+		return -ENODEV;
+	}
+
+	ret = vadc_read(vadc, VADC_PERPH_SUBTYPE, &val);
+	if (ret)
+		return ret;
+
+	if (val < VADC_PERPH_SUBTYPE_VADC) {
+		dev_dbg(vadc->dev, "%d is not VADC\n", val);
+		return -ENODEV;
+	}
+
+	ret = vadc_read(vadc, VADC_REVISION2, &val);
+	if (ret)
+		return ret;
+
+	if (val < VADC_REVISION2_SUPPORTED_VADC) {
+		dev_dbg(vadc->dev, "revision %d not supported\n", val);
+		return -ENODEV;
+	}
+
+	return 0;
+}
+
+static int vadc_probe(struct platform_device *pdev)
+{
+	struct device_node *node = pdev->dev.of_node;
+	struct device *dev = &pdev->dev;
+	struct iio_dev *indio_dev;
+	struct vadc_priv *vadc;
+	struct resource *res;
+	struct regmap *regmap;
+	int ret, irq_eoc;
+
+	regmap = dev_get_regmap(dev->parent, NULL);
+	if (!regmap)
+		return -ENODEV;
+
+	res = platform_get_resource(pdev, IORESOURCE_REG, 0);
+	if (!res)
+		return -ENODEV;
+
+	indio_dev = devm_iio_device_alloc(dev, sizeof(*vadc));
+	if (!indio_dev)
+		return -ENOMEM;
+
+	vadc = iio_priv(indio_dev);
+	vadc->regmap = regmap;
+	vadc->dev = dev;
+	vadc->base = res->start;
+	vadc->are_ref_measured = false;
+	init_completion(&vadc->complete);
+
+	ret = vadc_check_revision(vadc);
+	if (ret)
+		return ret;
+
+	vadc->nchannels = of_get_available_child_count(node);
+	if (!vadc->nchannels)
+		return -EINVAL;
+
+	vadc->iio_chans = devm_kcalloc(dev, vadc->nchannels,
+				       sizeof(*vadc->iio_chans), GFP_KERNEL);
+	if (!vadc->iio_chans)
+		return -ENOMEM;
+
+	vadc->chan_props = devm_kcalloc(dev, vadc->nchannels,
+					sizeof(*vadc->chan_props), GFP_KERNEL);
+	if (!vadc->chan_props)
+		return -ENOMEM;
+
+	ret = vadc_get_dt_data(vadc, node);
+	if (ret)
+		return ret;
+
+	irq_eoc = platform_get_irq(pdev, 0);
+	if (irq_eoc < 0) {
+		if (irq_eoc == -EPROBE_DEFER || irq_eoc == -EINVAL)
+			return irq_eoc;
+		vadc->poll_eoc = true;
+	}
+
+	if (!vadc->poll_eoc) {
+		ret = devm_request_irq(dev, irq_eoc, vadc_isr,
+				       IRQF_TRIGGER_RISING, "spmi-vadc", vadc);
+		if (!ret)
+			enable_irq_wake(irq_eoc);
+		else
+			return ret;
+	} else {
+		device_init_wakeup(vadc->dev, true);
+	}
+
+	ret = vadc_reset(vadc);
+	if (ret) {
+		dev_dbg(dev, "reset failed\n");
+		return ret;
+	}
+
+	platform_set_drvdata(pdev, vadc);
+
+	indio_dev->dev.parent = dev;
+	indio_dev->dev.of_node = node;
+	indio_dev->name = pdev->name;
+	indio_dev->modes = INDIO_DIRECT_MODE;
+	indio_dev->info = &vadc_info;
+	indio_dev->channels = vadc->iio_chans;
+	indio_dev->num_channels = vadc->nchannels;
+
+	return devm_iio_device_register(dev, indio_dev);
+}
+
+static const struct of_device_id vadc_match_table[] = {
+	{ .compatible = "qcom,spmi-vadc" },
+	{ }
+};
+MODULE_DEVICE_TABLE(of, vadc_match_table);
+
+static struct platform_driver vadc_driver = {
+	.driver = {
+		   .name = "spmi-vadc",
+		   .of_match_table = vadc_match_table,
+	},
+	.probe = vadc_probe,
+};
+module_platform_driver(vadc_driver);
+
+MODULE_ALIAS("platform:spmi-vadc");
+MODULE_DESCRIPTION("Qualcomm SPMI PMIC voltage ADC driver");
+MODULE_LICENSE("GPL v2");
+MODULE_AUTHOR("Stanimir Varbanov <svarbanov@mm-sol.com>");
+MODULE_AUTHOR("Ivan T. Ivanov <iivanov@mm-sol.com>");
\ No newline at end of file
diff --git a/include/dt-bindings/iio/qcom,spmi-pmic-vadc.h b/include/dt-bindings/iio/qcom,spmi-pmic-vadc.h
new file mode 100644
index 0000000..d543f24
--- /dev/null
+++ b/include/dt-bindings/iio/qcom,spmi-pmic-vadc.h
@@ -0,0 +1,119 @@
+/*
+ * Copyright (c) 2012-2014, The Linux Foundation. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 and
+ * only version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#ifndef _DT_BINDINGS_QCOM_PMIC_ADC_H
+#define _DT_BINDINGS_QCOM_PMIC_ADC_H
+
+/* Voltage ADC channels */
+#define VADC_USBIN				0x00
+#define VADC_DCIN				0x01
+#define VADC_VCHG_SNS				0x02
+#define VADC_SPARE1_03				0x03
+#define VADC_USB_ID_MV				0x04
+#define VADC_VCOIN				0x05
+#define VADC_VBAT_SNS				0x06
+#define VADC_VSYS				0x07
+#define VADC_DIE_TEMP				0x08
+#define VADC_REF_625MV				0x09
+#define VADC_REF_1250MV				0x0a
+#define VADC_CHG_TEMP				0x0b
+#define VADC_SPARE1				0x0c
+#define VADC_SPARE2				0x0d
+#define VADC_GND_REF				0x0e
+#define VADC_VDD_VADC				0x0f
+
+#define VADC_P_MUX1_1_1				0x10
+#define VADC_P_MUX2_1_1				0x11
+#define VADC_P_MUX3_1_1				0x12
+#define VADC_P_MUX4_1_1				0x13
+#define VADC_P_MUX5_1_1				0x14
+#define VADC_P_MUX6_1_1				0x15
+#define VADC_P_MUX7_1_1				0x16
+#define VADC_P_MUX8_1_1				0x17
+#define VADC_P_MUX9_1_1				0x18
+#define VADC_P_MUX10_1_1			0x19
+#define VADC_P_MUX11_1_1			0x1a
+#define VADC_P_MUX12_1_1			0x1b
+#define VADC_P_MUX13_1_1			0x1c
+#define VADC_P_MUX14_1_1			0x1d
+#define VADC_P_MUX15_1_1			0x1e
+#define VADC_P_MUX16_1_1			0x1f
+
+#define VADC_P_MUX1_1_3				0x20
+#define VADC_P_MUX2_1_3				0x21
+#define VADC_P_MUX3_1_3				0x22
+#define VADC_P_MUX4_1_3				0x23
+#define VADC_P_MUX5_1_3				0x24
+#define VADC_P_MUX6_1_3				0x25
+#define VADC_P_MUX7_1_3				0x26
+#define VADC_P_MUX8_1_3				0x27
+#define VADC_P_MUX9_1_3				0x28
+#define VADC_P_MUX10_1_3			0x29
+#define VADC_P_MUX11_1_3			0x2a
+#define VADC_P_MUX12_1_3			0x2b
+#define VADC_P_MUX13_1_3			0x2c
+#define VADC_P_MUX14_1_3			0x2d
+#define VADC_P_MUX15_1_3			0x2e
+#define VADC_P_MUX16_1_3			0x2f
+
+#define VADC_LR_MUX1_BAT_THERM			0x30
+#define VADC_LR_MUX2_BAT_ID			0x31
+#define VADC_LR_MUX3_XO_THERM			0x32
+#define VADC_LR_MUX4_AMUX_THM1			0x33
+#define VADC_LR_MUX5_AMUX_THM2			0x34
+#define VADC_LR_MUX6_AMUX_THM3			0x35
+#define VADC_LR_MUX7_HW_ID			0x36
+#define VADC_LR_MUX8_AMUX_THM4			0x37
+#define VADC_LR_MUX9_AMUX_THM5			0x38
+#define VADC_LR_MUX10_USB_ID			0x39
+#define VADC_AMUX_PU1				0x3a
+#define VADC_AMUX_PU2				0x3b
+#define VADC_LR_MUX3_BUF_XO_THERM		0x3c
+
+#define VADC_LR_MUX1_PU1_BAT_THERM		0x70
+#define VADC_LR_MUX2_PU1_BAT_ID			0x71
+#define VADC_LR_MUX3_PU1_XO_THERM		0x72
+#define VADC_LR_MUX4_PU1_AMUX_THM1		0x73
+#define VADC_LR_MUX5_PU1_AMUX_THM2		0x74
+#define VADC_LR_MUX6_PU1_AMUX_THM3		0x75
+#define VADC_LR_MUX7_PU1_AMUX_HW_ID		0x76
+#define VADC_LR_MUX8_PU1_AMUX_THM4		0x77
+#define VADC_LR_MUX9_PU1_AMUX_THM5		0x78
+#define VADC_LR_MUX10_PU1_AMUX_USB_ID		0x79
+#define VADC_LR_MUX3_BUF_PU1_XO_THERM		0x7c
+
+#define VADC_LR_MUX1_PU2_BAT_THERM		0xb0
+#define VADC_LR_MUX2_PU2_BAT_ID			0xb1
+#define VADC_LR_MUX3_PU2_XO_THERM		0xb2
+#define VADC_LR_MUX4_PU2_AMUX_THM1		0xb3
+#define VADC_LR_MUX5_PU2_AMUX_THM2		0xb4
+#define VADC_LR_MUX6_PU2_AMUX_THM3		0xb5
+#define VADC_LR_MUX7_PU2_AMUX_HW_ID		0xb6
+#define VADC_LR_MUX8_PU2_AMUX_THM4		0xb7
+#define VADC_LR_MUX9_PU2_AMUX_THM5		0xb8
+#define VADC_LR_MUX10_PU2_AMUX_USB_ID		0xb9
+#define VADC_LR_MUX3_BUF_PU2_XO_THERM		0xbc
+
+#define VADC_LR_MUX1_PU1_PU2_BAT_THERM		0xf0
+#define VADC_LR_MUX2_PU1_PU2_BAT_ID		0xf1
+#define VADC_LR_MUX3_PU1_PU2_XO_THERM		0xf2
+#define VADC_LR_MUX4_PU1_PU2_AMUX_THM1		0xf3
+#define VADC_LR_MUX5_PU1_PU2_AMUX_THM2		0xf4
+#define VADC_LR_MUX6_PU1_PU2_AMUX_THM3		0xf5
+#define VADC_LR_MUX7_PU1_PU2_AMUX_HW_ID		0xf6
+#define VADC_LR_MUX8_PU1_PU2_AMUX_THM4		0xf7
+#define VADC_LR_MUX9_PU1_PU2_AMUX_THM5		0xf8
+#define VADC_LR_MUX10_PU1_PU2_AMUX_USB_ID	0xf9
+#define VADC_LR_MUX3_BUF_PU1_PU2_XO_THERM	0xfc
+
+#endif /* _DT_BINDINGS_QCOM_PMIC_ADC_H */
-- 
1.7.0.4

