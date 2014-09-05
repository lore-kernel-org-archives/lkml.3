Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932277AbaIEMPl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 08:15:41 -0400
Received: from ns.mm-sol.com ([37.157.136.199]:56719 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756995AbaIEMPi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 08:15:38 -0400
From: Stanimir Varbanov <svarbanov@mm-sol.com>
To: Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Pawel Moll <pawel.moll@arm.com>, Rob Herring <robh+dt@kernel.org>,
        Kumar Gala <galak@codeaurora.org>, Mark Rutland <mark.rutland@arm.com>,
        Grant Likely <grant.likely@linaro.org>,
        Jonathan Cameron <jic23@kernel.org>
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
Subject: [PATCH 1/2] iio: vadc: Qualcomm SPMI PMIC voltage ADC driver
Date: Fri,  5 Sep 2014 15:14:33 +0300
Message-Id: <1409919274-13419-2-git-send-email-svarbanov@mm-sol.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1409919274-13419-1-git-send-email-svarbanov@mm-sol.com>
References: <1409919274-13419-1-git-send-email-svarbanov@mm-sol.com>
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
 drivers/iio/adc/Kconfig                       |   11 +
 drivers/iio/adc/Makefile                      |    1 +
 drivers/iio/adc/qcom-spmi-vadc.c              | 1275 +++++++++++++++++++++++++
 include/dt-bindings/iio/qcom,spmi-pmic-vadc.h |  119 +++
 4 files changed, 1406 insertions(+), 0 deletions(-)
 create mode 100644 drivers/iio/adc/qcom-spmi-vadc.c
 create mode 100644 include/dt-bindings/iio/qcom,spmi-pmic-vadc.h

diff --git a/drivers/iio/adc/Kconfig b/drivers/iio/adc/Kconfig
index 11b048a..e652d40 100644
--- a/drivers/iio/adc/Kconfig
+++ b/drivers/iio/adc/Kconfig
@@ -279,4 +279,15 @@ config XILINX_XADC
 	  The driver can also be build as a module. If so, the module will be called
 	  xilinx-xadc.
 
+config QCOM_SPMI_VADC
+	tristate "Qualcomm SPMI PMIC voltage ADC"
+	depends on SPMI
+	help
+	  Say yes here if you want support for the Qualcomm SPMI PMIC voltage ADC.
+
+	  The driver supports reading the HKADC, XOADC through the ADC AMUX arbiter.
+	  The VADC includes support for the conversion sequencer. The driver
+	  supports reading the ADC through the AMUX channels for external pull-ups
+	  simultaneously.
+
 endmenu
diff --git a/drivers/iio/adc/Makefile b/drivers/iio/adc/Makefile
index ad81b51..050cc96 100644
--- a/drivers/iio/adc/Makefile
+++ b/drivers/iio/adc/Makefile
@@ -30,3 +30,4 @@ obj-$(CONFIG_VF610_ADC) += vf610_adc.o
 obj-$(CONFIG_VIPERBOARD_ADC) += viperboard_adc.o
 xilinx-xadc-y := xilinx-xadc-core.o xilinx-xadc-events.o
 obj-$(CONFIG_XILINX_XADC) += xilinx-xadc.o
+obj-$(CONFIG_QCOM_SPMI_VADC) += qcom-spmi-vadc.o
diff --git a/drivers/iio/adc/qcom-spmi-vadc.c b/drivers/iio/adc/qcom-spmi-vadc.c
new file mode 100644
index 0000000..0c500df
--- /dev/null
+++ b/drivers/iio/adc/qcom-spmi-vadc.c
@@ -0,0 +1,1275 @@
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
+#include <linux/iio/sysfs.h>
+#include <linux/interrupt.h>
+#include <linux/kernel.h>
+#include <linux/mutex.h>
+#include <linux/module.h>
+#include <linux/of.h>
+#include <linux/platform_device.h>
+#include <linux/regmap.h>
+#include <linux/slab.h>
+#include <linux/log2.h>
+
+#include <dt-bindings/iio/qcom,spmi-pmic-vadc.h>
+
+/* QPNP VADC register and bit definition */
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
+/* Min ADC code represets 0V */
+#define VADC_MIN_ADC_CODE			0x6000
+/* Max ADC code represents full-scale range of 1.8V */
+#define VADC_MAX_ADC_CODE			0xA800
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
+/*
+ * VADC_CALIB_ABSOLUTE: Uses the 625mv and 1.25V reference channels.
+ * VADC_CALIB_RATIOMETRIC: Uses the reference Voltage/GND for calibration.
+ */
+enum vadc_calibration {
+	VADC_CALIB_ABSOLUTE = 0,
+	VADC_CALIB_RATIOMETRIC
+};
+
+/*
+ * struct vadc_linear_graph - Represent ADC characteristics.
+ * @dy: Numerator slope to calculate the gain.
+ * @dx: Denominator slope to calculate the gain.
+ * @vref: A/D word of the voltage reference used for the channel.
+ * @gnd: A/D word of the ground reference used for the channel.
+ *
+ * Each ADC device has different offset and gain parameters which are
+ * computed to calibrate the device.
+ */
+struct vadc_linear_graph {
+	s64 dy;
+	s64 dx;
+	s64 vref;
+	s64 gnd;
+};
+
+/*
+ * struct vadc_prescaling - Represent scaling ratio for ADC input.
+ * num: The inverse numerator of the gain applied to the input channel.
+ * den: The inverse denominator of the gain applied to the input channel.
+ */
+struct vadc_prescaling {
+	s32 num;
+	s32 den;
+};
+
+/**
+ * struct vadc_result - Represent the res of the QPNP ADC.
+ * @adc_code: The pre-calibrated digital output of a given ADC relative to the
+ *	the ADC reference.
+ * @measurement: In units specific for a given ADC; most ADC uses reference
+ *	voltage but some ADC uses reference current. This measurement
+ *	here is a number relative to a reference of a given ADC.
+ * @physical: The data meaningful for each individual channel whether it is
+ *      voltage, current, temperature, etc.
+ */
+struct vadc_result {
+	s32 adc_code;
+	s64 measurement;
+	s64 physical;
+};
+
+/*
+ * struct vadc_channel - QPNP VADC amux channel property.
+ * @name - AMUX channel name.
+ * @number - Channel number, refer to the channel list.
+ * @calibration - Calibration type.
+ * @decimation - Sampling rate supported for the channel.
+ * @prescaling - Channel scaling performed on the input signal.
+ * @hw_settle_time - The time between AMUX being configured and the
+ *	start of conversion.
+ * @avg_samples - Ability to provide single result from the ADC
+ *	that is an average of multiple measurements.
+ */
+struct vadc_channel {
+	const char *name;
+	int number;
+	enum vadc_calibration calibration;
+	unsigned decimation;
+	unsigned prescaling;
+	unsigned hw_settle_time;
+	unsigned avg_samples;
+};
+
+/**
+ * struct vadc_drv - QPNP ADC device structure.
+ * @regmap -
+ * @base - base offset for the ADC peripheral.
+ * @dev - ADC properties specific to the ADC peripheral.
+ * @nchannels -
+ * @channels - AMUX properties representing the ADC peripheral.
+ * @is_callibrated -
+ * @poll_eoc -
+ * @lock - ADC lock for access to the peripheral.
+ * @complete - ADC res notification after interrupt is received.
+ * @graph -
+ */
+struct vadc_chip {
+	struct regmap *regmap;
+	struct device *dev;
+	u16 base;
+	int nchannels;
+	struct vadc_channel *channels;
+	int sysfs_channel;
+	bool is_ref_measured;
+	bool poll_eoc;
+	struct mutex lock;
+	struct completion complete;
+	struct vadc_linear_graph graph[2];
+};
+
+static const struct vadc_prescaling vadc_prescale[] = {
+	{1,  1},
+	{1,  3},
+	{1,  4},
+	{1,  6},
+	{1,  20},
+	{1,  8},
+	{10, 81},
+	{1,  10}
+};
+
+static int vadc_read(struct vadc_chip *vadc, u16 offset, u8 *data)
+{
+	unsigned int val;
+	int rc;
+
+	rc = regmap_read(vadc->regmap, vadc->base + offset, &val);
+	if (rc < 0)
+		return rc;
+
+	*data = val;
+
+	return 0;
+}
+
+static int vadc_write(struct vadc_chip *vadc, u16 offset, u8 data)
+{
+	return regmap_write(vadc->regmap, vadc->base + offset, data);
+}
+
+static int vadc_reset(struct vadc_chip *vadc)
+{
+	u8 data;
+	int rc;
+
+	rc = vadc_write(vadc, VADC_ACCESS, VADC_ACCESS_DATA);
+	if (rc < 0)
+		return rc;
+
+	rc = vadc_read(vadc, VADC_PERH_RESET_CTL3, &data);
+	if (rc < 0)
+		return rc;
+
+	rc = vadc_write(vadc, VADC_ACCESS, VADC_ACCESS_DATA);
+	if (rc < 0)
+		return rc;
+
+	data |= VADC_FOLLOW_WARM_RB;
+
+	return vadc_write(vadc, VADC_PERH_RESET_CTL3, data);
+}
+
+static int vadc_enable(struct vadc_chip *vadc, bool state)
+{
+	u8 data = 0;
+
+	if (state)
+		data = VADC_EN_CTL1_SET;
+
+	return vadc_write(vadc, VADC_EN_CTL1, data);
+}
+
+static void vadc_status_show(struct vadc_chip *vadc)
+{
+	u8 mode, sta1, chan, dig, en, req;
+	int rc;
+
+	rc = vadc_read(vadc, VADC_MODE_CTL, &mode);
+	if (rc < 0)
+		return;
+
+	rc = vadc_read(vadc, VADC_ADC_DIG_PARAM, &dig);
+	if (rc < 0)
+		return;
+
+	rc = vadc_read(vadc, VADC_ADC_CH_SEL_CTL, &chan);
+	if (rc < 0)
+		return;
+
+	rc = vadc_read(vadc, VADC_CONV_REQ, &req);
+	if (rc < 0)
+		return;
+
+	rc = vadc_read(vadc, VADC_STATUS1, &sta1);
+	if (rc < 0)
+		return;
+
+	rc = vadc_read(vadc, VADC_EN_CTL1, &en);
+	if (rc < 0)
+		return;
+
+	dev_dbg(vadc->dev,
+		"mode:%02x en:%02x chan:%02x dig:%02x req:%02x sta1:%02x\n",
+		mode, en, chan, dig, req, sta1);
+}
+
+static int vadc_configure(struct vadc_chip *vadc, struct vadc_channel *vchan)
+{
+	u8 decim, mode_ctrl;
+	int rc;
+
+	/* Mode selection */
+	mode_ctrl = (VADC_OP_MODE_NORMAL << VADC_OP_MODE_SHIFT) |
+		     VADC_ADC_TRIM_EN | VADC_AMUX_TRIM_EN;
+	rc = vadc_write(vadc, VADC_MODE_CTL, mode_ctrl);
+	if (rc < 0)
+		return rc;
+
+	/* Channel selection */
+	rc = vadc_write(vadc, VADC_ADC_CH_SEL_CTL, vchan->number);
+	if (rc < 0)
+		return rc;
+
+	/* Digital parameter setup */
+	decim = vchan->decimation << VADC_ADC_DIG_DEC_RATIO_SEL_SHIFT;
+	rc = vadc_write(vadc, VADC_ADC_DIG_PARAM, decim);
+	if (rc < 0)
+		return rc;
+
+	/* HW settle time delay */
+	rc = vadc_write(vadc, VADC_HW_SETTLE_DELAY, vchan->hw_settle_time);
+	if (rc < 0)
+		return rc;
+
+	rc = vadc_write(vadc, VADC_FAST_AVG_CTL, vchan->avg_samples);
+	if (rc < 0)
+		return rc;
+
+	if (vchan->avg_samples)
+		rc = vadc_write(vadc, VADC_FAST_AVG_EN, VADC_FAST_AVG_EN_SET);
+	else
+		rc = vadc_write(vadc, VADC_FAST_AVG_EN, 0);
+
+	if (rc < 0)
+		return rc;
+
+	if (!vadc->poll_eoc)
+		reinit_completion(&vadc->complete);
+
+	rc = vadc_enable(vadc, true);
+	if (rc < 0)
+		return rc;
+
+	/* Request conversion */
+	return vadc_write(vadc, VADC_CONV_REQ, VADC_CONV_REQ_SET);
+}
+
+static int vadc_poll_wait_eoc(struct vadc_chip *vadc, int interval_us)
+{
+	int rc, count, retry;
+	u8 sta1;
+
+	retry = interval_us / VADC_CONV_TIME_MIN_US;
+
+	for (count = 0; count < retry; count++) {
+		rc = vadc_read(vadc, VADC_STATUS1, &sta1);
+		if (rc < 0)
+			return rc;
+
+		sta1 &= VADC_STATUS1_REQ_STS_EOC_MASK;
+		if (sta1 == VADC_STATUS1_EOC)
+			return 0;
+
+		usleep_range(VADC_CONV_TIME_MIN_US, VADC_CONV_TIME_MAX_US);
+	}
+
+	vadc_status_show(vadc);
+
+	return -ETIMEDOUT;
+}
+
+static int vadc_read_result(struct vadc_chip *vadc, s32 *data)
+{
+	u8 lsb, msb;
+	int rc;
+
+	rc = vadc_read(vadc, VADC_DATA0, &lsb);
+	if (rc < 0)
+		return rc;
+
+	rc = vadc_read(vadc, VADC_DATA1, &msb);
+	if (rc < 0)
+		return rc;
+
+	*data = ((unsigned)msb << 8) | lsb;
+
+	*data = clamp_t(s32, *data, VADC_MIN_ADC_CODE, VADC_MAX_ADC_CODE);
+
+	return 0;
+}
+
+static struct vadc_channel *vadc_find_channel(struct vadc_chip *vadc, int num)
+{
+	int i;
+
+	for (i = 0; i < vadc->nchannels; i++)
+		if (vadc->channels[i].number == num)
+			return &vadc->channels[num];
+
+	dev_dbg(vadc->dev, "no such channel %02x\n", num);
+
+	return NULL;
+}
+
+static int vadc_do_conversion(struct vadc_chip *vadc,
+			      struct vadc_channel *vchan, s32 *data)
+{
+	int wait, rc;
+
+	rc = vadc_configure(vadc, vchan);
+	if (rc < 0)
+		goto exit;
+
+	wait = BIT(vchan->avg_samples) * VADC_CONV_TIME_MIN_US * 2;
+
+	if (vadc->poll_eoc) {
+		rc = vadc_poll_wait_eoc(vadc, wait);
+	} else {
+		rc = wait_for_completion_timeout(&vadc->complete, wait);
+		if (!rc)
+			return -ETIMEDOUT;
+
+		/* double check convertion status */
+		rc = vadc_poll_wait_eoc(vadc, VADC_CONV_TIME_MIN_US);
+	}
+
+	rc = vadc_read_result(vadc, data);
+exit:
+	vadc_enable(vadc, false);
+	if (rc < 0)
+		dev_err(vadc->dev, "conversion failed\n");
+
+	return rc;
+}
+
+static int vadc_measure_reference_points(struct vadc_chip *vadc)
+{
+	struct vadc_channel *vchan;
+	int rc = -EINVAL, read_1, read_2;
+
+	vadc->graph[VADC_CALIB_RATIOMETRIC].dx = VADC_RATIOMETRIC_RANGE_UV;
+	vadc->graph[VADC_CALIB_ABSOLUTE].dx = VADC_ABSOLUTE_RANGE_UV;
+
+	vchan = vadc_find_channel(vadc, VADC_REF_1250MV);
+	if (!vchan)
+		goto exit;
+
+	rc = vadc_do_conversion(vadc, vchan, &read_1);
+	if (rc < 0)
+		goto exit;
+
+	/* Try with buffered 625mV channel first */
+	vchan = vadc_find_channel(vadc, VADC_SPARE1);
+	if (!vchan) {
+		vchan = vadc_find_channel(vadc, VADC_REF_625MV);
+		if (!vchan) {
+			rc = -EINVAL;
+			goto exit;
+		}
+	}
+
+	rc = vadc_do_conversion(vadc, vchan, &read_2);
+	if (rc < 0)
+		goto exit;
+
+	if (read_1 == read_2) {
+		rc = -EINVAL;
+		goto exit;
+	}
+
+	vadc->graph[VADC_CALIB_ABSOLUTE].dy = read_1 - read_2;
+	vadc->graph[VADC_CALIB_ABSOLUTE].vref = read_1;
+	vadc->graph[VADC_CALIB_ABSOLUTE].gnd = read_2;
+
+	/* Ratiometric calibration */
+	vchan = vadc_find_channel(vadc, VADC_VDD_VADC);
+	if (!vchan) {
+		rc = -EINVAL;
+		goto exit;
+	}
+
+	rc = vadc_do_conversion(vadc, vchan, &read_1);
+	if (rc < 0)
+		goto exit;
+
+	vchan = vadc_find_channel(vadc, VADC_GND_REF);
+	if (!vchan) {
+		rc = -EINVAL;
+		goto exit;
+	}
+
+	rc = vadc_do_conversion(vadc, vchan, &read_2);
+	if (rc < 0)
+		goto exit;
+
+	if (read_1 == read_2) {
+		rc = -EINVAL;
+		goto exit;
+	}
+
+	vadc->graph[VADC_CALIB_RATIOMETRIC].dy = read_1 - read_2;
+	vadc->graph[VADC_CALIB_RATIOMETRIC].vref = read_1;
+	vadc->graph[VADC_CALIB_RATIOMETRIC].gnd = read_2;
+exit:
+	if (rc < 0)
+		dev_err(vadc->dev, "measure reference points failed\n");
+
+	return rc;
+}
+
+static void vadc_calibrate(struct vadc_chip *vadc,
+			   const struct vadc_channel *vchan,
+			   struct vadc_result *res)
+{
+	const struct vadc_prescaling *prescale;
+	bool negative = false;
+	s64 voltage;
+
+	voltage = res->adc_code - vadc->graph[vchan->calibration].gnd;
+	voltage *= vadc->graph[vchan->calibration].dx;
+
+	if (voltage < 0) {
+		negative = true;
+		voltage = -voltage;
+	}
+
+	do_div(voltage, vadc->graph[vchan->calibration].dy);
+	if (negative)
+		voltage = -voltage;
+
+	if (vchan->calibration == VADC_CALIB_ABSOLUTE)
+		voltage += vadc->graph[vchan->calibration].dx;
+
+	if (voltage < 0)
+		voltage = 0;
+
+	prescale = &vadc_prescale[vchan->prescaling];
+
+	res->measurement = voltage * prescale->den;
+
+	do_div(res->measurement, prescale->num);
+
+	res->physical = res->measurement;
+}
+
+static inline unsigned vadc_decimation_from_user(unsigned int value)
+{
+	if (!is_power_of_2(value) || value < VADC_DECIMATION_MIN ||
+	    value > VADC_DECIMATION_MAX)
+		return -EINVAL;
+
+	return __ffs64(value / VADC_DECIMATION_MIN);
+}
+
+static inline unsigned vadc_decimation_to_user(unsigned value)
+{
+	return (1 << value) * VADC_DECIMATION_MIN;
+}
+
+static inline int
+vadc_prescaling_from_user(unsigned int value, unsigned int value2)
+{
+	int pre;
+
+	for (pre = 0; pre < ARRAY_SIZE(vadc_prescale); pre++)
+		if (vadc_prescale[pre].num == value &&
+		    vadc_prescale[pre].den == value2)
+			break;
+
+	if (pre == ARRAY_SIZE(vadc_prescale))
+		return -EINVAL;
+
+	return pre;
+}
+
+static inline int vadc_hw_settle_time_from_user(unsigned int value)
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
+static inline unsigned vadc_hw_settle_time_to_user(unsigned value)
+{
+	if (value <= 10)
+		value *= 100;
+	else
+		value = (value - 10) * 2000;
+
+	return value;
+}
+
+static inline int vadc_avg_samples_from_user(unsigned int value)
+{
+	if (!is_power_of_2(value) || value > VADC_AVG_SAMPLES_MAX)
+		return -EINVAL;
+
+	return __ffs64(value);
+}
+
+static inline unsigned vadc_avg_samples_to_user(unsigned value)
+{
+	return 1 << value;
+}
+
+static ssize_t vadc_show_channel(struct device *dev,
+				 struct device_attribute *attr, char *buf)
+{
+	struct vadc_chip *vadc = iio_priv(dev_to_iio_dev(dev));
+
+	return sprintf(buf, "%d\n", vadc->sysfs_channel);
+}
+
+static ssize_t vadc_store_channel(struct device *dev,
+				  struct device_attribute *attr,
+				  const char *buf, size_t len)
+{
+	struct vadc_chip *vadc = iio_priv(dev_to_iio_dev(dev));
+	unsigned number;
+	int rc;
+
+	rc = kstrtouint(buf, 10, &number);
+	if (rc)
+		return rc;
+
+	if (!vadc_find_channel(vadc, number))
+		return -EINVAL;
+
+	mutex_lock(&vadc->lock);
+	vadc->sysfs_channel = number;
+	mutex_unlock(&vadc->lock);
+
+	return rc < 0 ? rc : len;
+}
+
+static ssize_t vadc_show_calibration(struct device *dev,
+				     struct device_attribute *attr, char *buf)
+{
+	struct vadc_chip *vadc = iio_priv(dev_to_iio_dev(dev));
+	struct vadc_channel *vchan = &vadc->channels[vadc->sysfs_channel];
+	const char *type;
+
+	type = vchan->calibration ? "ratiometric" : "absolute";
+
+	return sprintf(buf, "%s\n", type);
+}
+
+static ssize_t vadc_store_calibration(struct device *dev,
+				      struct device_attribute *attr,
+				      const char *buf, size_t len)
+{
+	struct vadc_chip *vadc = iio_priv(dev_to_iio_dev(dev));
+	struct vadc_channel *vchan = &vadc->channels[vadc->sysfs_channel];
+	bool calibration;
+
+	if (!strncmp(buf, "ratiometric", sizeof("ratiometric")))
+		calibration = VADC_CALIB_RATIOMETRIC;
+	else if (!strncmp(buf, "absolute", sizeof("absolute")))
+		calibration = VADC_CALIB_ABSOLUTE;
+	else
+		return -EINVAL;
+
+	mutex_lock(&vadc->lock);
+	vchan->calibration = calibration;
+	mutex_unlock(&vadc->lock);
+
+	return len;
+}
+
+static ssize_t vadc_show_decimation(struct device *dev,
+				    struct device_attribute *attr, char *buf)
+{
+	struct vadc_chip *vadc = iio_priv(dev_to_iio_dev(dev));
+	struct vadc_channel *vchan = &vadc->channels[vadc->sysfs_channel];
+	unsigned decim;
+
+	decim = vadc_decimation_to_user(vchan->decimation);
+
+	return sprintf(buf, "%d\n", decim);
+}
+
+static ssize_t vadc_store_decimation(struct device *dev,
+				     struct device_attribute *attr,
+				     const char *buf, size_t len)
+{
+	struct vadc_chip *vadc = iio_priv(dev_to_iio_dev(dev));
+	struct vadc_channel *vchan = &vadc->channels[vadc->sysfs_channel];
+	unsigned int user;
+	int rc, decimation;
+
+	rc = kstrtouint(buf, 10, &user);
+	if (rc)
+		return rc;
+
+	decimation = vadc_decimation_from_user(user);
+	if (decimation < 0)
+		return decimation;
+
+	mutex_lock(&vadc->lock);
+	vchan->decimation = decimation;
+	mutex_unlock(&vadc->lock);
+
+	return len;
+}
+
+static ssize_t vadc_show_prescaling(struct device *dev,
+				    struct device_attribute *attr, char *buf)
+{
+	struct vadc_chip *vadc = iio_priv(dev_to_iio_dev(dev));
+	struct vadc_channel *vchan = &vadc->channels[vadc->sysfs_channel];
+	int num, den;
+
+	num = vadc_prescale[vchan->prescaling].num;
+	den = vadc_prescale[vchan->prescaling].den;
+
+	return sprintf(buf, "%d %d\n", num, den);
+}
+
+static ssize_t vadc_store_prescaling(struct device *dev,
+				     struct device_attribute *attr,
+				     const char *buf, size_t len)
+{
+	struct vadc_chip *vadc = iio_priv(dev_to_iio_dev(dev));
+	struct vadc_channel *vchan = &vadc->channels[vadc->sysfs_channel];
+	unsigned prescaling;
+	int rc;
+
+	rc = kstrtouint(buf, 10, &prescaling);
+	if (rc)
+		return rc;
+
+	if (prescaling >= ARRAY_SIZE(vadc_prescale))
+		return -EINVAL;
+
+	mutex_lock(&vadc->lock);
+	vchan->prescaling = prescaling;
+	mutex_unlock(&vadc->lock);
+
+	return len;
+}
+
+static ssize_t vadc_show_hw_settle_time(struct device *dev,
+					struct device_attribute *attr,
+					char *buf)
+{
+	struct vadc_chip *vadc = iio_priv(dev_to_iio_dev(dev));
+	struct vadc_channel *vchan = &vadc->channels[vadc->sysfs_channel];
+	unsigned time;
+
+	time = vchan->hw_settle_time;
+
+	return sprintf(buf, "%d\n", vadc_hw_settle_time_to_user(time));
+}
+
+static ssize_t vadc_store_hw_settle_time(struct device *dev,
+					 struct device_attribute *attr,
+					 const char *buf, size_t len)
+{
+	struct vadc_chip *vadc = iio_priv(dev_to_iio_dev(dev));
+	struct vadc_channel *vchan = &vadc->channels[vadc->sysfs_channel];
+	unsigned int user;
+	int rc, time;
+
+	rc = kstrtouint(buf, 10, &user);
+	if (rc)
+		return rc;
+
+	time = vadc_hw_settle_time_from_user(user);
+	if (time < 0)
+		return time;
+
+	mutex_lock(&vadc->lock);
+	vchan->hw_settle_time = time;
+	mutex_unlock(&vadc->lock);
+
+	return len;
+}
+
+static ssize_t vadc_show_avg_samples(struct device *dev,
+				     struct device_attribute *attr, char *buf)
+{
+	struct vadc_chip *vadc = iio_priv(dev_to_iio_dev(dev));
+	struct vadc_channel *vchan = &vadc->channels[vadc->sysfs_channel];
+	unsigned avg;
+
+	avg = vadc_avg_samples_to_user(vchan->avg_samples);
+
+	return sprintf(buf, "%d\n", avg);
+}
+
+static ssize_t vadc_store_avg_samples(struct device *dev,
+				      struct device_attribute *attr,
+				      const char *buf, size_t len)
+{
+	struct vadc_chip *vadc = iio_priv(dev_to_iio_dev(dev));
+	struct vadc_channel *vchan = &vadc->channels[vadc->sysfs_channel];
+	unsigned int user;
+	int rc, avg;
+
+	rc = kstrtouint(buf, 10, &user);
+	if (rc)
+		return rc;
+
+	avg = vadc_avg_samples_from_user(user);
+	if (avg < 0)
+		return avg;
+
+	mutex_lock(&vadc->lock);
+	vchan->avg_samples = avg;
+	mutex_unlock(&vadc->lock);
+
+	return len;
+}
+
+static IIO_DEVICE_ATTR(channel, S_IRUGO | S_IWUSR,
+		       vadc_show_channel, vadc_store_channel, 0);
+static IIO_DEVICE_ATTR(calibration, S_IRUGO | S_IWUSR,
+		       vadc_show_calibration, vadc_store_calibration, 0);
+static IIO_DEVICE_ATTR(decimation, S_IRUGO | S_IWUSR,
+		       vadc_show_decimation, vadc_store_decimation, 0);
+static IIO_DEVICE_ATTR(pre_scaling, S_IRUGO | S_IWUSR,
+		       vadc_show_prescaling, vadc_store_prescaling, 0);
+static IIO_DEVICE_ATTR(hw_settle_time, S_IRUGO | S_IWUSR,
+		       vadc_show_hw_settle_time, vadc_store_hw_settle_time, 0);
+static IIO_DEVICE_ATTR(avg_samples, S_IRUGO | S_IWUSR,
+		       vadc_show_avg_samples, vadc_store_avg_samples, 0);
+
+static struct attribute *vadc_attributes[] = {
+	&iio_dev_attr_channel.dev_attr.attr,
+	&iio_dev_attr_calibration.dev_attr.attr,
+	&iio_dev_attr_decimation.dev_attr.attr,
+	&iio_dev_attr_pre_scaling.dev_attr.attr,
+	&iio_dev_attr_hw_settle_time.dev_attr.attr,
+	&iio_dev_attr_avg_samples.dev_attr.attr,
+	NULL,
+};
+
+static const struct attribute_group vadc_attribute_group = {
+	.attrs = vadc_attributes,
+};
+
+static int vadc_read_raw(struct iio_dev *indio_dev,
+			 struct iio_chan_spec const *chan,
+			 int *val, int *val2, long mask)
+{
+	struct vadc_chip *vadc = iio_priv(indio_dev);
+	struct vadc_channel *vchan;
+	struct vadc_result result;
+	int rc = -EINVAL;
+
+	mutex_lock(&vadc->lock);
+
+	vchan = vadc_find_channel(vadc, chan->channel);
+	if (!vchan)
+		goto exit;
+
+	if (!vadc->is_ref_measured) {
+		rc = vadc_measure_reference_points(vadc);
+		if (rc < 0)
+			goto exit;
+
+		vadc->is_ref_measured = true;
+	}
+
+	switch (mask) {
+	case IIO_CHAN_INFO_PROCESSED:
+		rc = vadc_do_conversion(vadc, vchan, &result.adc_code);
+		if (rc < 0)
+			goto exit;
+
+		vadc_calibrate(vadc, vchan, &result);
+
+		*val = result.physical;
+		rc = IIO_VAL_INT;
+		break;
+	default:
+		break;
+	}
+
+exit:
+	mutex_unlock(&vadc->lock);
+
+	return rc;
+}
+
+static const struct iio_info vadc_info = {
+	.read_raw = vadc_read_raw,
+	.attrs = &vadc_attribute_group,
+	.driver_module = THIS_MODULE,
+};
+
+#define VADC_CHAN(_id, _pre)						\
+	[VADC_##_id] = {						\
+		.type = IIO_VOLTAGE,					\
+		.indexed = 1,						\
+		.channel = VADC_##_id,					\
+		.address = _pre,					\
+		.info_mask_separate = BIT(IIO_CHAN_INFO_PROCESSED),	\
+		.datasheet_name = __stringify(VADC_##_id),		\
+		.scan_type = {						\
+			.sign		= 's',				\
+			.realbits	= 15,				\
+			.storagebits	= 16,				\
+		},							\
+	},
+
+static const struct iio_chan_spec vadc_channels[] = {
+	VADC_CHAN(USBIN, 4)				/* 0x00 */
+	VADC_CHAN(DCIN, 4)
+	VADC_CHAN(VCHG_SNS, 3)
+	VADC_CHAN(SPARE1_03, 1)
+	VADC_CHAN(USB_ID_MV, 1)
+	VADC_CHAN(VCOIN, 1)
+	VADC_CHAN(VBAT_SNS, 1)
+	VADC_CHAN(VSYS, 1)
+	VADC_CHAN(DIE_TEMP, 0)
+	VADC_CHAN(REF_625MV, 0)
+	VADC_CHAN(REF_1250MV, 0)
+	VADC_CHAN(CHG_TEMP, 0)
+	VADC_CHAN(SPARE1, 0)
+	VADC_CHAN(SPARE2, 0)
+	VADC_CHAN(GND_REF, 0)
+	VADC_CHAN(VDD_VADC, 0)				/* 0x0f */
+
+	VADC_CHAN(P_MUX1_1_1, 0)			/* 0x10 */
+	VADC_CHAN(P_MUX2_1_1, 0)
+	VADC_CHAN(P_MUX3_1_1, 0)
+	VADC_CHAN(P_MUX4_1_1, 0)
+	VADC_CHAN(P_MUX5_1_1, 0)
+	VADC_CHAN(P_MUX6_1_1, 0)
+	VADC_CHAN(P_MUX7_1_1, 0)
+	VADC_CHAN(P_MUX8_1_1, 0)
+	VADC_CHAN(P_MUX9_1_1, 0)
+	VADC_CHAN(P_MUX10_1_1, 0)
+	VADC_CHAN(P_MUX11_1_1, 0)
+	VADC_CHAN(P_MUX12_1_1, 0)
+	VADC_CHAN(P_MUX13_1_1, 0)
+	VADC_CHAN(P_MUX14_1_1, 0)
+	VADC_CHAN(P_MUX15_1_1, 0)
+	VADC_CHAN(P_MUX16_1_1, 0)			/* 0x1f */
+
+	VADC_CHAN(P_MUX1_1_3, 1)			/* 0x20 */
+	VADC_CHAN(P_MUX2_1_3, 1)
+	VADC_CHAN(P_MUX3_1_3, 1)
+	VADC_CHAN(P_MUX4_1_3, 1)
+	VADC_CHAN(P_MUX5_1_3, 1)
+	VADC_CHAN(P_MUX6_1_3, 1)
+	VADC_CHAN(P_MUX7_1_3, 1)
+	VADC_CHAN(P_MUX8_1_3, 1)
+	VADC_CHAN(P_MUX9_1_3, 1)
+	VADC_CHAN(P_MUX10_1_3, 1)
+	VADC_CHAN(P_MUX11_1_3, 1)
+	VADC_CHAN(P_MUX12_1_3, 1)
+	VADC_CHAN(P_MUX13_1_3, 1)
+	VADC_CHAN(P_MUX14_1_3, 1)
+	VADC_CHAN(P_MUX15_1_3, 1)
+	VADC_CHAN(P_MUX16_1_3, 1)			/* 0x2f */
+
+	VADC_CHAN(LR_MUX1_BAT_THERM, 0)			/* 0x30 */
+	VADC_CHAN(LR_MUX2_BAT_ID, 0)
+	VADC_CHAN(LR_MUX3_XO_THERM, 0)
+	VADC_CHAN(LR_MUX4_AMUX_THM1, 0)
+	VADC_CHAN(LR_MUX5_AMUX_THM2, 0)
+	VADC_CHAN(LR_MUX6_AMUX_THM3, 0)
+	VADC_CHAN(LR_MUX7_HW_ID, 0)
+	VADC_CHAN(LR_MUX8_AMUX_THM4, 0)
+	VADC_CHAN(LR_MUX9_AMUX_THM5, 0)
+	VADC_CHAN(AMUX_PU1, 0)
+	VADC_CHAN(AMUX_PU2, 0)
+	VADC_CHAN(LR_MUX3_BUF_XO_THERM_BUF, 0)		/* 0x3c */
+
+	VADC_CHAN(LR_MUX1_PU1_BAT_THERM, 0)		/* 0x70 */
+	VADC_CHAN(LR_MUX2_PU1_BAT_ID, 0)
+	VADC_CHAN(LR_MUX3_PU1_XO_THERM, 0)
+	VADC_CHAN(LR_MUX4_PU1_AMUX_THM1, 0)
+	VADC_CHAN(LR_MUX5_PU1_AMUX_THM2, 0)
+	VADC_CHAN(LR_MUX6_PU1_AMUX_THM3, 0)
+	VADC_CHAN(LR_MUX7_PU1_AMUX_HW_ID, 0)
+	VADC_CHAN(LR_MUX8_PU1_AMUX_THM4, 0)
+	VADC_CHAN(LR_MUX9_PU1_AMUX_THM5, 0)
+	VADC_CHAN(LR_MUX10_PU1_AMUX_USB_ID, 0)		/* 0x79 */
+	VADC_CHAN(LR_MUX3_BUF_PU1_XO_THERM_BUF, 0)	/* 0x7c */
+
+	VADC_CHAN(LR_MUX1_PU2_BAT_THERM, 0)		/* 0xb0 */
+	VADC_CHAN(LR_MUX2_PU2_BAT_ID, 0)
+	VADC_CHAN(LR_MUX3_PU2_XO_THERM, 0)
+	VADC_CHAN(LR_MUX4_PU2_AMUX_THM1, 0)
+	VADC_CHAN(LR_MUX5_PU2_AMUX_THM2, 0)
+	VADC_CHAN(LR_MUX6_PU2_AMUX_THM3, 0)
+	VADC_CHAN(LR_MUX7_PU2_AMUX_HW_ID, 0)
+	VADC_CHAN(LR_MUX8_PU2_AMUX_THM4, 0)
+	VADC_CHAN(LR_MUX9_PU2_AMUX_THM5, 0)
+	VADC_CHAN(LR_MUX10_PU2_AMUX_USB_ID, 0)		/* 0xb9 */
+	VADC_CHAN(LR_MUX3_BUF_PU2_XO_THERM_BUF, 0)	/* 0xbc */
+
+	VADC_CHAN(LR_MUX1_PU1_PU2_BAT_THERM, 0)		/* 0xf0 */
+	VADC_CHAN(LR_MUX2_PU1_PU2_BAT_ID, 0)
+	VADC_CHAN(LR_MUX3_PU1_PU2_XO_THERM, 0)
+	VADC_CHAN(LR_MUX4_PU1_PU2_AMUX_THM1, 0)
+	VADC_CHAN(LR_MUX5_PU1_PU2_AMUX_THM2, 0)
+	VADC_CHAN(LR_MUX6_PU1_PU2_AMUX_THM3, 0)
+	VADC_CHAN(LR_MUX7_PU1_PU2_AMUX_HW_ID, 0)
+	VADC_CHAN(LR_MUX8_PU1_PU2_AMUX_THM4, 0)
+	VADC_CHAN(LR_MUX9_PU1_PU2_AMUX_THM5, 0)
+	VADC_CHAN(LR_MUX10_PU1_PU2_AMUX_USB_ID, 0)	/* 0xf9 */
+	VADC_CHAN(LR_MUX3_BUF_PU1_PU2_XO_THERM_BU, 0)	/* 0xfc */
+};
+
+static int
+vadc_get_dt_channel_data(struct vadc_chip *vadc, struct device_node *node)
+{
+	struct vadc_channel *vchan;
+	u32 num, value, varr[2];
+	int rc, pre, time, avg, decim;
+	const char *name;
+
+	name = of_get_property(node, "label", NULL) ? : node->name;
+
+	rc = of_property_read_u32(node, "qcom,channel", &num);
+	if (rc) {
+		dev_err(vadc->dev, "invalid channel number %s\n", name);
+		return -EINVAL;
+	}
+
+	if (num >= vadc->nchannels) {
+		dev_err(vadc->dev, "%s invalid channel number %d\n", name, num);
+		return -EINVAL;
+	}
+
+	vchan = &vadc->channels[num];
+
+	/* exist */
+	vchan->number = num;
+
+	rc = of_property_read_u32(node, "qcom,decimation", &value);
+	if (!rc) {
+		decim = vadc_decimation_from_user(value);
+		if (decim < 0) {
+			dev_err(vadc->dev, "%02x invalid decimation %d\n",
+				num, value);
+			return -EINVAL;
+		}
+		vchan->decimation = decim;
+	}
+
+	rc = of_property_read_u32_array(node, "qcom,pre-scaling", varr, 2);
+	if (!rc) {
+		pre = vadc_prescaling_from_user(varr[0], varr[1]);
+		if (pre < 0) {
+			dev_warn(vadc->dev,
+				 "%02x invalid pre-scaling <%d %d>\n",
+				 num, varr[0], varr[1]);
+			return -EINVAL;
+		}
+		vchan->prescaling = pre;
+	}
+
+	rc = of_property_read_u32(node, "qcom,hw-settle-time", &value);
+	if (!rc) {
+		time = vadc_hw_settle_time_from_user(value);
+		if (time < 0) {
+			dev_warn(vadc->dev,
+				 "%02x invalid hw-settle-time %d, us\n",
+				 num, value);
+			return -EINVAL;
+		}
+		vchan->hw_settle_time = time;
+	}
+
+	rc = of_property_read_u32(node, "qcom,avg-samples", &value);
+	if (!rc) {
+		avg = vadc_avg_samples_from_user(value);
+		if (avg < 0) {
+			dev_warn(vadc->dev, "%02x invalid avg-samples %d\n",
+				 num, value);
+			return -EINVAL;
+		}
+		vchan->avg_samples = avg;
+	}
+
+	if (of_property_read_bool(node, "qcom,ratiometric"))
+		vchan->calibration = VADC_CALIB_RATIOMETRIC;
+	else
+		vchan->calibration = VADC_CALIB_ABSOLUTE;
+
+	dev_info(vadc->dev, "%02x name %s\n", num, name);
+
+	return 0;
+}
+
+static int vadc_get_dt_data(struct vadc_chip *vadc, struct device_node *node)
+{
+	struct device_node *child;
+	int rc;
+
+	vadc->poll_eoc = of_property_read_bool(node, "qcom,poll-eoc");
+
+	for_each_available_child_of_node(node, child) {
+		rc = vadc_get_dt_channel_data(vadc, child);
+		if (rc < 0)
+			return rc;
+	}
+
+	return 0;
+}
+
+static irqreturn_t vadc_isr(int irq, void *dev_id)
+{
+	struct vadc_chip *vadc = dev_id;
+
+	complete(&vadc->complete);
+
+	return IRQ_HANDLED;
+}
+
+static int vadc_version_check(struct vadc_chip *vadc)
+{
+	u8 revision, type, subtype;
+	int rc;
+
+	rc = vadc_read(vadc, VADC_PERPH_TYPE, &type);
+	if (rc < 0)
+		return rc;
+
+	if (type < VADC_PERPH_TYPE_ADC) {
+		dev_dbg(vadc->dev, "%d is not ADC\n", type);
+		return -EINVAL;
+	}
+
+	rc = vadc_read(vadc, VADC_PERPH_SUBTYPE, &subtype);
+	if (rc < 0)
+		return rc;
+
+	if (subtype < VADC_PERPH_SUBTYPE_VADC) {
+		dev_dbg(vadc->dev, "%d is not VADC\n", subtype);
+		return -EINVAL;
+	}
+
+	rc = vadc_read(vadc, VADC_REVISION2, &revision);
+	if (rc < 0)
+		return rc;
+
+	if (revision < VADC_REVISION2_SUPPORTED_VADC) {
+		dev_dbg(vadc->dev, "revision %d not supported\n", revision);
+		return -EINVAL;
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
+	struct vadc_channel *vchan;
+	struct vadc_chip *vadc;
+	struct resource *res;
+	struct regmap *regmap;
+	int rc, irq_eoc, n;
+
+	regmap = dev_get_regmap(dev->parent, NULL);
+	if (!regmap)
+		return -ENODEV;
+
+	indio_dev = devm_iio_device_alloc(dev, sizeof(*vadc));
+	if (!indio_dev)
+		return -ENOMEM;
+
+	vadc = iio_priv(indio_dev);
+	vadc->dev = dev;
+	vadc->regmap = regmap;
+	vadc->is_ref_measured = false;
+	init_completion(&vadc->complete);
+	mutex_init(&vadc->lock);
+
+	vadc->nchannels = ARRAY_SIZE(vadc_channels);
+	vadc->channels = devm_kcalloc(dev, sizeof(*vadc->channels),
+				      vadc->nchannels, GFP_KERNEL);
+	if (!vadc->channels)
+		return -ENOMEM;
+
+	for (n = 0; n < vadc->nchannels; n++) {
+		vchan = &vadc->channels[n];
+		/* set default channel properties */
+		vchan->name = (char *)vadc_channels[n].datasheet_name;
+		vchan->number = -1;	/* inactive */
+		vchan->prescaling = vadc_channels[n].address;
+		vchan->decimation = VADC_DEF_DECIMATION;
+		vchan->hw_settle_time = VADC_DEF_HW_SETTLE_TIME;
+		vchan->avg_samples = VADC_DEF_AVG_SAMPLES;
+		vchan->calibration = VADC_DEF_CALIB_TYPE;
+	}
+
+	platform_set_drvdata(pdev, vadc);
+
+	res = platform_get_resource(pdev, IORESOURCE_REG, 0);
+	if (!res)
+		return -ENODEV;
+
+	vadc->base = res->start;
+
+	rc = vadc_version_check(vadc);
+	if (rc < 0)
+		return -ENODEV;
+
+	irq_eoc = platform_get_irq(pdev, 0);
+	if (irq_eoc < 0)
+		return -ENODEV;
+
+	rc = vadc_get_dt_data(vadc, node);
+	if (rc < 0)
+		return rc;
+
+	rc = vadc_reset(vadc);
+	if (rc < 0) {
+		dev_dbg(dev, "reset failed\n");
+		return rc;
+	}
+
+	if (!vadc->poll_eoc) {
+		rc = devm_request_irq(dev, irq_eoc, vadc_isr, 0,
+				      "spmi-vadc", vadc);
+		if (!rc)
+			enable_irq_wake(irq_eoc);
+		else
+			return rc;
+	} else {
+		device_init_wakeup(vadc->dev, 1);
+	}
+
+	indio_dev->dev.parent = dev;
+	indio_dev->dev.of_node = node;
+	indio_dev->name = pdev->name;
+	indio_dev->modes = INDIO_DIRECT_MODE;
+	indio_dev->info = &vadc_info;
+	indio_dev->channels = vadc_channels;
+	indio_dev->num_channels = ARRAY_SIZE(vadc_channels);
+
+	return devm_iio_device_register(dev, indio_dev);
+}
+
+static int vadc_remove(struct platform_device *pdev)
+{
+	return 0;
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
+	.remove = vadc_remove,
+};
+module_platform_driver(vadc_driver);
+
+MODULE_ALIAS("platform:spmi-vadc");
+MODULE_DESCRIPTION("Qualcomm SPMI PMIC voltage ADC driver");
+MODULE_LICENSE("GPL v2");
diff --git a/include/dt-bindings/iio/qcom,spmi-pmic-vadc.h b/include/dt-bindings/iio/qcom,spmi-pmic-vadc.h
new file mode 100644
index 0000000..594e131
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
+/* QPNP Voltage ADC channels */
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
+#define VADC_LR_MUX3_BUF_XO_THERM_BUF		0x3c
+
+#define VADC_LR_MUX1_PU1_BAT_THERM 		0x70
+#define VADC_LR_MUX2_PU1_BAT_ID			0x71
+#define VADC_LR_MUX3_PU1_XO_THERM		0x72
+#define VADC_LR_MUX4_PU1_AMUX_THM1		0x73
+#define VADC_LR_MUX5_PU1_AMUX_THM2		0x74
+#define VADC_LR_MUX6_PU1_AMUX_THM3		0x75
+#define VADC_LR_MUX7_PU1_AMUX_HW_ID		0x76
+#define VADC_LR_MUX8_PU1_AMUX_THM4		0x77
+#define VADC_LR_MUX9_PU1_AMUX_THM5		0x78
+#define VADC_LR_MUX10_PU1_AMUX_USB_ID		0x79
+#define VADC_LR_MUX3_BUF_PU1_XO_THERM_BUF	0x7c
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
+#define VADC_LR_MUX3_BUF_PU2_XO_THERM_BUF	0xbc
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
+#define VADC_LR_MUX3_BUF_PU1_PU2_XO_THERM_BU	0xfc
+
+#endif /* _DT_BINDINGS_QCOM_PMIC_ADC_H */
-- 
1.7.0.4

