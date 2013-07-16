Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932448Ab3GPLsy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 07:48:54 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:46811 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932322Ab3GPLsu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 07:48:50 -0400
From: Oleksandr Kozaruk <oleksandr.kozaruk@ti.com>
To: <tony@atomide.com>, <benoit.cousson@linaro.org>, <rnayak@ti.com>,
        <peter.ujfalusi@ti.com>, <kishon@ti.com>, <jic23@cam.ac.uk>,
        <grant.likely@linaro.org>, <rob.herring@calxeda.com>,
        <lars@metafoo.de>, <sameo@linux.intel.com>, <ch.naveen@samsung.com>,
        <poeschel@lemonage.de>, <milo.kim@ti.com>, <balajitk@ti.com>,
        <gg@slimlogic.co.uk>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <linux-iio@vger.kernel.org>, <devicetree-discuss@lists.ozlabs.org>,
        <linux-omap@vger.kernel.org>
Subject: [PATCH v4 2/2] iio: twl6030-gpadc: TWL6030, TWL6032 GPADC driver
Date: Tue, 16 Jul 2013 14:47:34 +0300
Message-ID: <1373975254-23764-3-git-send-email-oleksandr.kozaruk@ti.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1373975254-23764-1-git-send-email-oleksandr.kozaruk@ti.com>
References: <1373975254-23764-1-git-send-email-oleksandr.kozaruk@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The GPADC is general purpose ADC found on TWL6030, and TWL6032 PMIC,
known also as Phoenix and PhoenixLite.

The TWL6030 and TWL6032 have GPADC with 17 and 19 channels
respectively. Some channels have current source and are used for
measuring voltage drop on resistive load for detecting battery ID
resistance, or measuring voltage drop on NTC resistors for external
temperature measurements. Some channels measure voltage, (i.e. battery
voltage), and have voltage dividers, thus, capable to scale voltage.
Some channels are dedicated for measuring die temperature.

Some channels are calibrated in 2 points, having offsets from ideal
values kept in trim registers. This is used to correct measurements.

The differences between GPADC in TWL6030 and TWL6032:
- 10 bit vs 12 bit ADC;
- 17 vs 19 channels;
- channels have different purpose(i.e. battery voltage
  channel 8 vs channel 18);
- trim values are interpreted differently.

Based on the driver patched from Balaji TK, Graeme Gregory, Ambresh K,
Girish S Ghongdemath.

Signed-off-by: Balaji T K <balajitk@ti.com>
Signed-off-by: Graeme Gregory <gg@slimlogic.co.uk>
Signed-off-by: Oleksandr Kozaruk <oleksandr.kozaruk@ti.com>
---
 drivers/iio/adc/Kconfig         |   14 +
 drivers/iio/adc/Makefile        |    1 +
 drivers/iio/adc/twl6030-gpadc.c | 1008 +++++++++++++++++++++++++++++++++++++++
 3 files changed, 1023 insertions(+)
 create mode 100644 drivers/iio/adc/twl6030-gpadc.c

diff --git a/drivers/iio/adc/Kconfig b/drivers/iio/adc/Kconfig
index ab0767e6..3172461 100644
--- a/drivers/iio/adc/Kconfig
+++ b/drivers/iio/adc/Kconfig
@@ -150,6 +150,20 @@ config TI_AM335X_ADC
 	  Say yes here to build support for Texas Instruments ADC
 	  driver which is also a MFD client.
 
+config TWL6030_GPADC
+	tristate "TWL6030 GPADC (General Purpose A/D Converter) Support"
+	depends on TWL4030_CORE
+	default n
+	help
+	  Say yes here if you want support for the TWL6030/TWL6032 General
+	  Purpose A/D Converter. This will add support for battery type
+	  detection, battery voltage and temperature measurement, die
+	  temperature measurement, system supply voltage, audio accessory,
+	  USB ID detection.
+
+	  This driver can also be built as a module. If so, the module will be
+	  called twl6030-gpadc.
+
 config VIPERBOARD_ADC
 	tristate "Viperboard ADC support"
 	depends on MFD_VIPERBOARD && USB
diff --git a/drivers/iio/adc/Makefile b/drivers/iio/adc/Makefile
index 0a825be..996ba09 100644
--- a/drivers/iio/adc/Makefile
+++ b/drivers/iio/adc/Makefile
@@ -16,4 +16,5 @@ obj-$(CONFIG_LP8788_ADC) += lp8788_adc.o
 obj-$(CONFIG_MAX1363) += max1363.o
 obj-$(CONFIG_TI_ADC081C) += ti-adc081c.o
 obj-$(CONFIG_TI_AM335X_ADC) += ti_am335x_adc.o
+obj-$(CONFIG_TWL6030_GPADC) += twl6030-gpadc.o
 obj-$(CONFIG_VIPERBOARD_ADC) += viperboard_adc.o
diff --git a/drivers/iio/adc/twl6030-gpadc.c b/drivers/iio/adc/twl6030-gpadc.c
new file mode 100644
index 0000000..658f35b
--- /dev/null
+++ b/drivers/iio/adc/twl6030-gpadc.c
@@ -0,0 +1,1008 @@
+/*
+ * TWL6030 GPADC module driver
+ *
+ * Copyright (C) 2009-2013 Texas Instruments Inc.
+ * Nishant Kamat <nskamat@ti.com>
+ * Balaji T K <balajitk@ti.com>
+ * Graeme Gregory <gg@slimlogic.co.uk>
+ * Girish S Ghongdemath <girishsg@ti.com>
+ * Ambresh K <ambresh@ti.com>
+ * Oleksandr Kozaruk <oleksandr.kozaruk@ti.com
+ *
+ * Based on twl4030-madc.c
+ * Copyright (C) 2008 Nokia Corporation
+ * Mikko Ylinen <mikko.k.ylinen@nokia.com>
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
+#include <linux/init.h>
+#include <linux/interrupt.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/platform_device.h>
+#include <linux/of_platform.h>
+#include <linux/i2c/twl.h>
+#include <linux/iio/iio.h>
+#include <linux/iio/sysfs.h>
+
+#define DRIVER_NAME		"twl6030_gpadc"
+
+#define TWL6030_GPADC_MAX_CHANNELS 17
+#define TWL6032_GPADC_MAX_CHANNELS 19
+
+#define TWL6030_GPADC_CTRL_P1			0x05
+
+#define TWL6032_GPADC_GPSELECT_ISB		0x07
+#define TWL6032_GPADC_CTRL_P1			0x08
+
+#define TWL6032_GPADC_GPCH0_LSB			0x0d
+#define TWL6032_GPADC_GPCH0_MSB			0x0e
+
+#define TWL6030_GPADC_CTRL_P1_SP1		BIT(3)
+
+#define TWL6030_GPADC_GPCH0_LSB			(0x29)
+
+#define TWL6030_GPADC_RT_SW1_EOC_MASK		BIT(5)
+
+#define TWL6030_GPADC_TRIM1			0xCD
+
+#define TWL6030_REG_TOGGLE1			0x90
+#define TWL6030_GPADCS				BIT(1)
+#define TWL6030_GPADCR				BIT(0)
+
+/**
+ * struct twl6030_chnl_calib - channel calibration
+ * @gain:		slope coefficient for ideal curve
+ * @gain_error:		gain error
+ * @offset_error:	offset of the real curve
+ */
+struct twl6030_chnl_calib {
+	s32 gain;
+	s32 gain_error;
+	s32 offset_error;
+};
+
+/**
+ * struct twl6030_ideal_code - GPADC calibration parameters
+ * GPADC is calibrated in two points: close to the beginning and
+ * to the and of the measurable input range
+ *
+ * @code1:	ideal code for the input at the beginning
+ * @code2:	ideal code for at the end of the range
+ * @volt1:	voltage input at the beginning(low voltage)
+ * @volt2:	voltage input at the end(high voltage)
+ */
+struct twl6030_ideal_code {
+	u16 code1;
+	u16 code2;
+	u16 volt1;
+	u16 volt2;
+};
+
+struct twl6030_gpadc_data;
+
+/**
+ * struct twl6030_gpadc_platform_data - platform specific data
+ * @nchannels:		number of GPADC channels
+ * @iio_channels:	iio channels
+ * @twl6030_ideal:	pointer to calibration parameters
+ * @start_conversion:	pointer to ADC start conversion function
+ * @channel_to_reg	pointer to ADC function to convert channel to
+ * 			register address for reading conversion result
+ * @calibrate:		pointer to calibration function
+ */
+struct twl6030_gpadc_platform_data {
+	const int nchannels;
+	const struct iio_chan_spec *iio_channels;
+	const struct twl6030_ideal_code *ideal;
+	int (*start_conversion)(int channel);
+	u8 (*channel_to_reg)(int channel);
+	int (*calibrate)(struct twl6030_gpadc_data *gpadc);
+};
+
+/**
+ * struct twl6030_gpadc_data - GPADC data
+ * @dev:		device pointer
+ * @lock:		mutual exclusion lock for the structure
+ * @irq_complete:	completion to signal end of conversion
+ * @twl6030_cal_tbl:	pointer to calibration data for each
+ * 			channel with gain error and offset
+ * @pdata:		pointer to device specific data
+ */
+struct twl6030_gpadc_data {
+	struct device	*dev;
+	struct mutex	lock;
+	struct completion	irq_complete;
+	struct twl6030_chnl_calib	*twl6030_cal_tbl;
+	const struct twl6030_gpadc_platform_data *pdata;
+};
+
+/*
+ * channels 11, 12, 13, 15 and 16 have no calibration data
+ * calibration offset is same for channels 1, 3, 4, 5
+ *
+ * The data is taken from GPADC_TRIM registers description.
+ * GPADC_TRIM registers keeps difference between the code measured
+ * at volt1 and volt2 input voltages and corresponding code1 and code2
+ */
+static const struct twl6030_ideal_code
+	twl6030_ideal[TWL6030_GPADC_MAX_CHANNELS] = {
+	[0] = { /* ch 0, external, battery type, resistor value */
+		.code1 = 116,
+		.code2 = 745,
+		.volt1 = 141,
+		.volt2 = 910,
+	},
+	[1] = { /* ch 1, external, battery temperature, NTC resistor value */
+		.code1 = 82,
+		.code2 = 900,
+		.volt1 = 100,
+		.volt2 = 1100,
+	},
+	[2] = { /* ch 2, external, audio accessory/general purpose */
+		.code1 = 55,
+		.code2 = 818,
+		.volt1 = 101,
+		.volt2 = 1499,
+	},
+	[3] = { /* ch 3, external, general purpose */
+		.code1 = 82,
+		.code2 = 900,
+		.volt1 = 100,
+		.volt2 = 1100,
+	},
+	[4] = { /* ch 4, external, temperature measurement/general purpose */
+		.code1 = 82,
+		.code2 = 900,
+		.volt1 = 100,
+		.volt2 = 1100,
+	},
+	[5] = { /* ch 5, external, general purpose */
+		.code1 = 82,
+		.code2 = 900,
+		.volt1 = 100,
+		.volt2 = 1100,
+	},
+	[6] = { /* ch 6, external, general purpose */
+		.code1 = 82,
+		.code2 = 900,
+		.volt1 = 100,
+		.volt2 = 1100,
+	},
+	[7] = { /* ch 7, internal, main battery */
+		.code1 = 614,
+		.code2 = 941,
+		.volt1 = 3001,
+		.volt2 = 4599,
+	},
+	[8] = { /* ch 8, internal, backup battery */
+		.code1 = 82,
+		.code2 = 688,
+		.volt1 = 501,
+		.volt2 = 4203,
+	},
+	[9] = { /* ch 9, internal, external charger input */
+		.code1 = 182,
+		.code2 = 818,
+		.volt1 = 2001,
+		.volt2 = 8996,
+	},
+	[10] = { /* ch 10, internal, VBUS */
+		.code1 = 149,
+		.code2 = 818,
+		.volt1 = 1001,
+		.volt2 = 5497,
+	},
+	[11] = {},	/* ch 11, internal, VBUS charging current */
+	[12] = {},	/* ch 12, internal, Die temperature */
+	[13] = {},	/* ch 13, internal, Die temperature */
+	[14] = { /* ch 14, internal, USB ID line */
+		.code1 = 48,
+		.code2 = 714,
+		.volt1 = 323,
+		.volt2 = 4800,
+	},
+	[15] = {},	/* ch 15, internal, test network */
+	[16] = {},	/* ch 16, internal, test network */
+};
+
+static const struct twl6030_ideal_code
+			twl6032_ideal[TWL6032_GPADC_MAX_CHANNELS] = {
+	[0] = { /* ch 0, external, battery type, resistor value */
+		.code1 = 1441,
+		.code2 = 3276,
+		.volt1 = 440,
+		.volt2 = 1000,
+	},
+	[1] = { /* ch 1, external, battery temperature, NTC resistor value */
+		.code1 = 1441,
+		.code2 = 3276,
+		.volt1 = 440,
+		.volt2 = 1000,
+	},
+	[2] = { /* ch 2, external, audio accessory/general purpose */
+		.code1 = 1441,
+		.code2 = 3276,
+		.volt1 = 660,
+		.volt2 = 1500,
+	},
+	[3] = { /* ch 3, external, temperature with external diode/general
+								purpose */
+		.code1 = 1441,
+		.code2 = 3276,
+		.volt1 = 440,
+		.volt2 = 1000,
+	},
+	[4] = { /* ch 4, external, temperature measurement/general purpose */
+		.code1 = 1441,
+		.code2 = 3276,
+		.volt1 = 440,
+		.volt2 = 1000,
+	},
+	[5] = { /* ch 5, external, general purpose */
+		.code1 = 1441,
+		.code2 = 3276,
+		.volt1 = 440,
+		.volt2 = 1000,
+	},
+	[6] = { /* ch 6, external, general purpose */
+		.code1 = 1441,
+		.code2 = 3276,
+		.volt1 = 440,
+		.volt2 = 1000,
+	},
+	[7] = { /* ch7, internal, system supply */
+		.code1 = 1441,
+		.code2 = 3276,
+		.volt1 = 2200,
+		.volt2 = 5000,
+	},
+	[8] = { /* ch8, internal, backup battery */
+		.code1 = 1441,
+		.code2 = 3276,
+		.volt1 = 2200,
+		.volt2 = 5000,
+	},
+	[9] = { /* ch 9, internal, external charger input */
+		.code1 = 1441,
+		.code2 = 3276,
+		.volt1 = 3960,
+		.volt2 = 9000,
+	},
+	[10] = { /* ch10, internal, VBUS */
+		.code1 = 150,
+		.code2 = 751,
+		.volt1 = 1000,
+		.volt2 = 5000,
+	},
+	[11] = { /* ch 11, internal, VBUS DC-DC output current */
+		.code1 = 1441,
+		.code2 = 3276,
+		.volt1 = 660,
+		.volt2 = 1500,
+	},
+	[12] = { /* ch 12, internal, Die temperature */
+		.code1 = 1441,
+		.code2 = 3276,
+		.volt1 = 440,
+		.volt2 = 1000,
+	},
+	[13] = { /* ch 13, internal, Die temperature */
+		.code1 = 1441,
+		.code2 = 3276,
+		.volt1 = 440,
+		.volt2 = 1000,
+	},
+	[14] = { /* ch 14, internal, USB ID line */
+		.code1 = 1441,
+		.code2 = 3276,
+		.volt1 = 2420,
+		.volt2 = 5500,
+	},
+	[15] = {},	/* ch 15, internal, test network */
+	[16] = {},	/* ch 16, internal, test network */
+	[17] = {},	/* ch 17, internal, battery charging current */
+	[18] = { /* ch 18, internal, battery voltage */
+		.code1 = 1441,
+		.code2 = 3276,
+		.volt1 = 2200,
+		.volt2 = 5000,
+	},
+};
+
+static inline int twl6030_gpadc_write(u8 reg, u8 val)
+{
+	return twl_i2c_write_u8(TWL6030_MODULE_GPADC, val, reg);
+}
+
+static inline int twl6030_gpadc_read(u8 reg, u8 *val)
+{
+
+	return twl_i2c_read(TWL6030_MODULE_GPADC, val, reg, 2);
+}
+
+static int twl6030_gpadc_enable_irq(u8 mask)
+{
+	int ret;
+
+	ret = twl6030_interrupt_unmask(mask, REG_INT_MSK_LINE_B);
+	if (ret < 0)
+		return ret;
+
+	ret = twl6030_interrupt_unmask(mask, REG_INT_MSK_STS_B);
+
+	return ret;
+}
+
+static void twl6030_gpadc_disable_irq(u8 mask)
+{
+	twl6030_interrupt_mask(mask, REG_INT_MSK_LINE_B);
+	twl6030_interrupt_mask(mask, REG_INT_MSK_STS_B);
+}
+
+static irqreturn_t twl6030_gpadc_irq_handler(int irq, void *_gpadc)
+{
+	struct twl6030_gpadc_data *gpadc = _gpadc;
+
+	complete(&gpadc->irq_complete);
+
+	return IRQ_HANDLED;
+}
+
+static int twl6030_start_conversion(int channel)
+{
+	return twl6030_gpadc_write(TWL6030_GPADC_CTRL_P1,
+					TWL6030_GPADC_CTRL_P1_SP1);
+}
+
+static int twl6032_start_conversion(int channel)
+{
+	int ret;
+
+	ret = twl6030_gpadc_write(TWL6032_GPADC_GPSELECT_ISB, channel);
+	if (ret)
+		return ret;
+
+	return twl6030_gpadc_write(TWL6032_GPADC_CTRL_P1,
+						TWL6030_GPADC_CTRL_P1_SP1);
+}
+
+static u8 twl6030_channel_to_reg(int channel)
+{
+	return TWL6030_GPADC_GPCH0_LSB + 2 * channel;
+}
+
+static u8 twl6032_channel_to_reg(int channel)
+{
+	/*
+	 * for any prior chosen channel, when the conversion is ready
+	 * the result is avalable in GPCH0_LSB, GPCH0_MSB.
+	 */
+
+	return TWL6032_GPADC_GPCH0_LSB;
+}
+
+static int twl6030_gpadc_get_raw(struct twl6030_gpadc_data *gpadc,
+		int channel, int *res)
+{
+	u8 reg = gpadc->pdata->channel_to_reg(channel);
+	__le16 val;
+	int ret;
+
+	ret = twl6030_gpadc_read(reg, (u8 *)&val);
+	if (ret) {
+		dev_dbg(gpadc->dev, "unable to read register 0x%X\n", reg);
+		return ret;
+	}
+
+	*res = le16_to_cpup(&val);
+
+	return ret;
+}
+
+static int twl6030_gpadc_get_processed(struct twl6030_gpadc_data *gpadc,
+		int channel, int *val)
+{
+	int raw_code;
+	int corrected_code;
+	int channel_value;
+	int ret;
+
+	ret = twl6030_gpadc_get_raw(gpadc, channel, &raw_code);
+	if (ret)
+		return ret;
+
+	corrected_code = ((raw_code * 1000) -
+		gpadc->twl6030_cal_tbl[channel].offset_error) /
+		gpadc->twl6030_cal_tbl[channel].gain_error;
+
+	channel_value = corrected_code *
+			gpadc->twl6030_cal_tbl[channel].gain;
+
+	/* Shift back into mV range */
+	channel_value /= 1000;
+
+	dev_dbg(gpadc->dev, "GPADC raw code: %d", raw_code);
+	dev_dbg(gpadc->dev, "GPADC corrected code: %d", corrected_code);
+	dev_dbg(gpadc->dev, "GPADC value: %d", channel_value);
+
+	*val = channel_value;
+
+	return ret;
+}
+
+static int twl6030_gpadc_read_raw(struct iio_dev *indio_dev,
+			     const struct iio_chan_spec *chan,
+			     int *val, int *val2, long mask)
+{
+	struct twl6030_gpadc_data *gpadc = iio_priv(indio_dev);
+	int ret = -EINVAL;
+	long timeout;
+
+	mutex_lock(&gpadc->lock);
+
+	ret = gpadc->pdata->start_conversion(chan->channel);
+	if (ret) {
+		dev_err(gpadc->dev, "failed to start conversion\n");
+		goto err;
+	}
+	/* wait for conversion to complete */
+	timeout = wait_for_completion_interruptible_timeout(
+				&gpadc->irq_complete, msecs_to_jiffies(5000));
+	if (!timeout)
+		return -ETIMEDOUT;
+	else if (timeout < 0)
+		return EINTR;
+
+	switch (mask) {
+	case IIO_CHAN_INFO_RAW:
+		ret = twl6030_gpadc_get_raw(gpadc, chan->channel, val);
+		ret = ret ? -EIO : IIO_VAL_INT;
+		break;
+
+	case IIO_CHAN_INFO_PROCESSED:
+		ret = twl6030_gpadc_get_processed(gpadc, chan->channel, val);
+		ret = ret ? -EIO : IIO_VAL_INT;
+		break;
+
+	default:
+		break;
+	}
+err:
+	mutex_unlock(&gpadc->lock);
+
+	return ret;
+}
+
+/*
+ * The GPADC channels are calibrated using a two point calibration method.
+ * The channels measured with two known values: volt1 and volt2, and
+ * ideal corresponding output codes are known: code1, code2.
+ * The difference(d1, d2) between ideal and measured codes stored in trim
+ * registers.
+ * The goal is to find offset and gain of the real curve for each calibrated
+ * channel.
+ * gain: k = 1 + ((d2 - d1) / (x2 - x1))
+ * offset: b = d1 + (k - 1) * x1
+ */
+static void twl6030_calibrate_channel(struct twl6030_gpadc_data *gpadc,
+					int channel, int d1, int d2)
+{
+	int b, k, gain, x1, x2;
+	const struct twl6030_ideal_code *ideal = gpadc->pdata->ideal;
+
+	/* Gain */
+	gain = ((ideal[channel].volt2 - ideal[channel].volt1) * 1000) /
+		(ideal[channel].code2 - ideal[channel].code1);
+
+	x1 = ideal[channel].code1;
+	x2 = ideal[channel].code2;
+
+	/* k - real curve gain */
+	k = 1000 + (((d2 - d1) * 1000) / (x2 - x1));
+
+	/* b - offset of the real curve gain */
+	b = (d1 * 1000) - (k - 1000) * x1;
+
+	gpadc->twl6030_cal_tbl[channel].gain = gain;
+	gpadc->twl6030_cal_tbl[channel].gain_error = k;
+	gpadc->twl6030_cal_tbl[channel].offset_error = b;
+
+	dev_dbg(gpadc->dev, "GPADC d1   for Chn: %d = %d\n", channel, d1);
+	dev_dbg(gpadc->dev, "GPADC d2   for Chn: %d = %d\n", channel, d2);
+	dev_dbg(gpadc->dev, "GPADC x1   for Chn: %d = %d\n", channel, x1);
+	dev_dbg(gpadc->dev, "GPADC x2   for Chn: %d = %d\n", channel, x2);
+	dev_dbg(gpadc->dev, "GPADC Gain for Chn: %d = %d\n", channel, gain);
+	dev_dbg(gpadc->dev, "GPADC k    for Chn: %d = %d\n", channel, k);
+	dev_dbg(gpadc->dev, "GPADC b    for Chn: %d = %d\n", channel, b);
+}
+
+static inline int twl6030_gpadc_get_trim_offset(s8 d)
+{
+	/*
+	 * XXX NOTE!
+	 * bit 0 - sign, bit 7 - reserved, 6..1 - trim value
+	 * though, the documentation states that trim value
+	 * is absolute value, the correct conversion results are
+	 * obtained if the value is interpreted as 2's complement.
+	 */
+	__u32 temp = ((d & 0x7f) >> 1) | ((d & 1) << 6);
+
+	return sign_extend32(temp, 6);
+}
+
+static int twl6030_calibration(struct twl6030_gpadc_data *gpadc)
+{
+	int ret;
+	int chn;
+	u8 trim_regs[TWL6030_GPADC_MAX_CHANNELS];
+	s8 d1, d2;
+
+	/*
+	 * for calibration two measurements have been performed at
+	 * factory, for some channels, during the production test and
+	 * have been stored in registers. This two stored values are
+	 * used to correct the measurements. The values represent
+	 * offsets for the given input from the output on ideal curve.
+	 */
+	ret = twl_i2c_read(TWL6030_MODULE_ID2, trim_regs,
+			TWL6030_GPADC_TRIM1, 16);
+	if (ret < 0) {
+		dev_err(gpadc->dev, "calibration failed\n");
+		return ret;
+	}
+
+	for (chn = 0; chn < TWL6030_GPADC_MAX_CHANNELS; chn++) {
+
+		switch (chn) {
+		case 0:
+			d1 = trim_regs[0];
+			d2 = trim_regs[1];
+			break;
+		case 1:
+		case 3:
+		case 4:
+		case 5:
+		case 6:
+			d1 = trim_regs[4];
+			d2 = trim_regs[5];
+			break;
+		case 2:
+			d1 = trim_regs[12];
+			d2 = trim_regs[13];
+			break;
+		case 7:
+			d1 = trim_regs[6];
+			d2 = trim_regs[7];
+			break;
+		case 8:
+			d1 = trim_regs[2];
+			d2 = trim_regs[3];
+			break;
+		case 9:
+			d1 = trim_regs[8];
+			d2 = trim_regs[9];
+			break;
+		case 10:
+			d1 = trim_regs[10];
+			d2 = trim_regs[11];
+			break;
+		case 14:
+			d1 = trim_regs[14];
+			d2 = trim_regs[15];
+			break;
+		default:
+			continue;
+		}
+
+		d1 = twl6030_gpadc_get_trim_offset(d1);
+		d2 = twl6030_gpadc_get_trim_offset(d2);
+
+		twl6030_calibrate_channel(gpadc, chn, d1, d2);
+	}
+
+	return 0;
+}
+
+static int twl6032_calibration(struct twl6030_gpadc_data *gpadc)
+{
+	int chn, d1 = 0, d2 = 0, temp;
+	u8 trim_regs[17];
+	int ret;
+
+	ret = twl_i2c_read(TWL6030_MODULE_ID2, trim_regs + 1,
+			TWL6030_GPADC_TRIM1, 16);
+	if (ret < 0) {
+		dev_err(gpadc->dev, "calibration failed\n");
+		return ret;
+	}
+
+	/*
+	 * Loop to calculate the value needed for returning voltages from
+	 * GPADC not values.
+	 *
+	 * gain is calculated to 3 decimal places fixed point.
+	 */
+	for (chn = 0; chn < TWL6032_GPADC_MAX_CHANNELS; chn++) {
+
+		switch (chn) {
+		case 0:
+		case 1:
+		case 2:
+		case 3:
+		case 4:
+		case 5:
+		case 6:
+		case 11:
+		case 12:
+		case 13:
+		case 14:
+			/* D1 */
+			d1 = (trim_regs[3] & 0x1F) << 2;
+			d1 |= (trim_regs[1] & 0x06) >> 1;
+			if (trim_regs[1] & 0x01)
+				d1 = -d1;
+
+			/* D2 */
+			d2 = (trim_regs[4] & 0x3F) << 2;
+			d2 |= (trim_regs[2] & 0x06) >> 1;
+			if (trim_regs[2] & 0x01)
+				d2 = -d2;
+			break;
+		case 8:
+			/* D1 */
+			temp = (trim_regs[3] & 0x1F) << 2;
+			temp |= (trim_regs[1] & 0x06) >> 1;
+			if (trim_regs[1] & 0x01)
+				temp = -temp;
+
+			d1 = (trim_regs[8] & 0x18) << 1;
+			d1 |= (trim_regs[7] & 0x1E) >> 1;
+			if (trim_regs[7] & 0x01)
+				d1 = -d1;
+
+			d1 += temp;
+
+			/* D2 */
+			temp = (trim_regs[4] & 0x3F) << 2;
+			temp |= (trim_regs[2] & 0x06) >> 1;
+			if (trim_regs[2] & 0x01)
+				temp = -temp;
+
+			d2 = (trim_regs[10] & 0x1F) << 2;
+			d2 |= (trim_regs[8] & 0x06) >> 1;
+			if (trim_regs[8] & 0x01)
+				d2 = -d2;
+
+			d2 += temp;
+			break;
+		case 9:
+			/* D1 */
+			temp = (trim_regs[3] & 0x1F) << 2;
+			temp |= (trim_regs[1] & 0x06) >> 1;
+			if (trim_regs[1] & 0x01)
+				temp = -temp;
+
+			d1 = (trim_regs[14] & 0x18) << 1;
+			d1 |= (trim_regs[12] & 0x1E) >> 1;
+			if (trim_regs[12] & 0x01)
+				d1 = -d1;
+
+			d1 += temp;
+
+			/* D2 */
+			temp = (trim_regs[4] & 0x3F) << 2;
+			temp |= (trim_regs[2] & 0x06) >> 1;
+			if (trim_regs[2] & 0x01)
+				temp = -temp;
+
+			d2 = (trim_regs[16] & 0x1F) << 2;
+			d2 |= (trim_regs[14] & 0x06) >> 1;
+			if (trim_regs[14] & 0x01)
+				d2 = -d2;
+
+			d2 += temp;
+		case 10:
+			/* D1 */
+			d1 = (trim_regs[11] & 0x0F) << 3;
+			d1 |= (trim_regs[9] & 0x0E) >> 1;
+			if (trim_regs[9] & 0x01)
+				d1 = -d1;
+
+			/* D2 */
+			d2 = (trim_regs[15] & 0x0F) << 3;
+			d2 |= (trim_regs[13] & 0x0E) >> 1;
+			if (trim_regs[13] & 0x01)
+				d2 = -d2;
+			break;
+		case 7:
+		case 18:
+			/* D1 */
+			temp = (trim_regs[3] & 0x1F) << 2;
+			temp |= (trim_regs[1] & 0x06) >> 1;
+			if (trim_regs[1] & 0x01)
+				temp = -temp;
+
+			d1 = (trim_regs[5] & 0x7E) >> 1;
+			if (trim_regs[5] & 0x01)
+				d1 = -d1;
+
+			d1 += temp;
+
+			/* D2 */
+			temp = (trim_regs[4] & 0x3F) << 2;
+			temp |= (trim_regs[2] & 0x06) >> 1;
+			if (trim_regs[2] & 0x01)
+				temp = -temp;
+
+			d2 = (trim_regs[6] & 0xFE) >> 1;
+			if (trim_regs[6] & 0x01)
+				d2 = -d2;
+
+			d2 += temp;
+			break;
+		default:
+			/* No data for other channels */
+			continue;
+		}
+
+		twl6030_calibrate_channel(gpadc, chn, d1, d2);
+	}
+
+	return 0;
+}
+
+#define TWL6030_GPADC_CHAN(chn, chan_info) {		\
+	.type = IIO_VOLTAGE,				\
+	.channel = chn,					\
+	.info_mask = BIT(chan_info),			\
+	.info_mask_separate = BIT(chan_info), 		\
+	.indexed = 1,					\
+}
+
+/* internal test network channel */
+#define TWL6030_GPADC_TEST_CHAN(chn, chan_info) {	\
+	.type = IIO_VOLTAGE,				\
+	.channel = chn,					\
+	.info_mask = BIT(chan_info),			\
+	.indexed = 1,					\
+}
+
+static const struct iio_chan_spec twl6030_gpadc_iio_channels[] = {
+	TWL6030_GPADC_CHAN(0, IIO_CHAN_INFO_PROCESSED),
+	TWL6030_GPADC_CHAN(1, IIO_CHAN_INFO_PROCESSED),
+	TWL6030_GPADC_CHAN(2, IIO_CHAN_INFO_PROCESSED),
+	TWL6030_GPADC_CHAN(3, IIO_CHAN_INFO_PROCESSED),
+	TWL6030_GPADC_CHAN(4, IIO_CHAN_INFO_PROCESSED),
+	TWL6030_GPADC_CHAN(5, IIO_CHAN_INFO_PROCESSED),
+	TWL6030_GPADC_CHAN(6, IIO_CHAN_INFO_PROCESSED),
+	TWL6030_GPADC_CHAN(7, IIO_CHAN_INFO_PROCESSED),
+	TWL6030_GPADC_CHAN(8, IIO_CHAN_INFO_PROCESSED),
+	TWL6030_GPADC_CHAN(9, IIO_CHAN_INFO_PROCESSED),
+	TWL6030_GPADC_CHAN(10, IIO_CHAN_INFO_PROCESSED),
+	TWL6030_GPADC_CHAN(11, IIO_CHAN_INFO_RAW),
+	TWL6030_GPADC_CHAN(12, IIO_CHAN_INFO_RAW),
+	TWL6030_GPADC_CHAN(13, IIO_CHAN_INFO_RAW),
+	TWL6030_GPADC_CHAN(14, IIO_CHAN_INFO_PROCESSED),
+	TWL6030_GPADC_TEST_CHAN(15, IIO_CHAN_INFO_RAW),
+	TWL6030_GPADC_TEST_CHAN(16, IIO_CHAN_INFO_RAW),
+};
+
+static const struct iio_chan_spec twl6032_gpadc_iio_channels[] = {
+	TWL6030_GPADC_CHAN(0, IIO_CHAN_INFO_PROCESSED),
+	TWL6030_GPADC_CHAN(1, IIO_CHAN_INFO_PROCESSED),
+	TWL6030_GPADC_CHAN(2, IIO_CHAN_INFO_PROCESSED),
+	TWL6030_GPADC_CHAN(3, IIO_CHAN_INFO_PROCESSED),
+	TWL6030_GPADC_CHAN(4, IIO_CHAN_INFO_PROCESSED),
+	TWL6030_GPADC_CHAN(5, IIO_CHAN_INFO_PROCESSED),
+	TWL6030_GPADC_CHAN(6, IIO_CHAN_INFO_PROCESSED),
+	TWL6030_GPADC_CHAN(7, IIO_CHAN_INFO_PROCESSED),
+	TWL6030_GPADC_CHAN(8, IIO_CHAN_INFO_PROCESSED),
+	TWL6030_GPADC_CHAN(9, IIO_CHAN_INFO_PROCESSED),
+	TWL6030_GPADC_CHAN(10, IIO_CHAN_INFO_PROCESSED),
+	TWL6030_GPADC_CHAN(11, IIO_CHAN_INFO_PROCESSED),
+	TWL6030_GPADC_CHAN(12, IIO_CHAN_INFO_PROCESSED),
+	TWL6030_GPADC_CHAN(13, IIO_CHAN_INFO_PROCESSED),
+	TWL6030_GPADC_CHAN(14, IIO_CHAN_INFO_PROCESSED),
+	TWL6030_GPADC_TEST_CHAN(15, IIO_CHAN_INFO_RAW),
+	TWL6030_GPADC_TEST_CHAN(16, IIO_CHAN_INFO_RAW),
+	TWL6030_GPADC_CHAN(17, IIO_CHAN_INFO_RAW),
+	TWL6030_GPADC_CHAN(18, IIO_CHAN_INFO_PROCESSED),
+};
+
+static const struct iio_info twl6030_gpadc_iio_info = {
+	.read_raw = &twl6030_gpadc_read_raw,
+	.driver_module = THIS_MODULE,
+};
+
+static const struct twl6030_gpadc_platform_data twl6030_pdata = {
+	.iio_channels = twl6030_gpadc_iio_channels,
+	.nchannels = TWL6030_GPADC_MAX_CHANNELS,
+	.ideal = twl6030_ideal,
+	.start_conversion = twl6030_start_conversion,
+	.channel_to_reg = twl6030_channel_to_reg,
+	.calibrate = twl6030_calibration,
+};
+
+static const struct twl6030_gpadc_platform_data twl6032_pdata = {
+	.iio_channels = twl6032_gpadc_iio_channels,
+	.nchannels = TWL6032_GPADC_MAX_CHANNELS,
+	.ideal = twl6032_ideal,
+	.start_conversion = twl6032_start_conversion,
+	.channel_to_reg = twl6032_channel_to_reg,
+	.calibrate = twl6032_calibration,
+};
+
+static const struct of_device_id of_twl6030_match_tbl[] = {
+	{
+		.compatible = "ti,twl6030_gpadc",
+		.data = &twl6030_pdata,
+	},
+	{
+		.compatible = "ti,twl6032_gpadc",
+		.data = &twl6032_pdata,
+	},
+	{ /* end */ }
+};
+
+static int twl6030_gpadc_probe(struct platform_device *pdev)
+{
+	struct device *dev = &pdev->dev;
+	struct twl6030_gpadc_data *gpadc;
+	const struct twl6030_gpadc_platform_data *pdata;
+	const struct of_device_id *match;
+	struct iio_dev *indio_dev;
+	int irq;
+	int ret;
+
+	match = of_match_device(of_match_ptr(of_twl6030_match_tbl), dev);
+	pdata = match ? match->data : dev->platform_data;
+
+	if (!pdata)
+		return -EINVAL;
+
+	indio_dev = iio_device_alloc(sizeof(*gpadc));
+	if (!indio_dev) {
+		dev_err(dev, "failed allocating iio device\n");
+		ret = -ENOMEM;
+	}
+
+	gpadc = iio_priv(indio_dev);
+
+	gpadc->twl6030_cal_tbl = devm_kzalloc(dev,
+					sizeof(struct twl6030_chnl_calib) *
+					pdata->nchannels, GFP_KERNEL);
+	if (!gpadc->twl6030_cal_tbl)
+		goto err_free_device;
+
+	gpadc->dev = dev;
+	gpadc->pdata = pdata;
+
+	platform_set_drvdata(pdev, indio_dev);
+	mutex_init(&gpadc->lock);
+	init_completion(&gpadc->irq_complete);
+
+	ret = pdata->calibrate(gpadc);
+	if (ret < 0) {
+		dev_err(&pdev->dev, "failed to read calibration registers\n");
+		goto err_free_device;
+	}
+
+	irq = platform_get_irq(pdev, 0);
+	if (irq < 0) {
+		dev_err(&pdev->dev, "failed to get irq\n");
+		goto err_free_device;
+	}
+
+	ret = request_threaded_irq(irq, NULL, twl6030_gpadc_irq_handler,
+				IRQF_ONESHOT, "twl6030_gpadc", gpadc);
+	if (ret) {
+		dev_dbg(&pdev->dev, "could not request irq\n");
+		goto err_free_device;
+	}
+
+	ret = twl6030_gpadc_enable_irq(TWL6030_GPADC_RT_SW1_EOC_MASK);
+	if (ret < 0) {
+		dev_err(&pdev->dev, "failed to enable GPADC interrupt\n");
+		goto err_free_irq;
+	}
+
+	ret = twl_i2c_write_u8(TWL6030_MODULE_ID1, TWL6030_GPADCS,
+					TWL6030_REG_TOGGLE1);
+	if (ret < 0) {
+		dev_err(&pdev->dev, "failed to enable GPADC module\n");
+		goto err_free_irq;
+	}
+
+	indio_dev->name = DRIVER_NAME;
+	indio_dev->dev.parent = dev;
+	indio_dev->info = &twl6030_gpadc_iio_info;
+	indio_dev->modes = INDIO_DIRECT_MODE;
+	indio_dev->channels = pdata->iio_channels;
+	indio_dev->num_channels = pdata->nchannels;
+
+	ret = iio_device_register(indio_dev);
+	if (ret)
+		goto err_free_irq;
+
+	return ret;
+
+err_free_irq:
+	free_irq(irq, indio_dev);
+err_free_device:
+	iio_device_free(indio_dev);
+
+	return ret;
+}
+
+static int twl6030_gpadc_remove(struct platform_device *pdev)
+{
+	struct iio_dev *indio_dev = platform_get_drvdata(pdev);
+
+	twl6030_gpadc_disable_irq(TWL6030_GPADC_RT_SW1_EOC_MASK);
+	free_irq(platform_get_irq(pdev, 0), indio_dev);
+	iio_device_unregister(indio_dev);
+	iio_device_free(indio_dev);
+
+	return 0;
+}
+
+#ifdef CONFIG_PM_SLEEP
+static int twl6030_gpadc_suspend(struct device *pdev)
+{
+	int ret;
+
+	ret = twl_i2c_write_u8(TWL6030_MODULE_ID1, TWL6030_GPADCR,
+				TWL6030_REG_TOGGLE1);
+	if (ret)
+		dev_err(pdev, "error reseting GPADC (%d)!\n", ret);
+
+	return 0;
+};
+
+static int twl6030_gpadc_resume(struct device *pdev)
+{
+	int ret;
+
+	ret = twl_i2c_write_u8(TWL6030_MODULE_ID1, TWL6030_GPADCS,
+				TWL6030_REG_TOGGLE1);
+	if (ret)
+		dev_err(pdev, "error setting GPADC (%d)!\n", ret);
+
+	return 0;
+};
+#endif
+
+SIMPLE_DEV_PM_OPS(twl6030_gpadc_pm_ops, twl6030_gpadc_suspend,
+					twl6030_gpadc_resume);
+
+static struct platform_driver twl6030_gpadc_driver = {
+	.probe		= twl6030_gpadc_probe,
+	.remove		= twl6030_gpadc_remove,
+	.driver		= {
+		.name	= DRIVER_NAME,
+		.owner	= THIS_MODULE,
+		.pm	= &twl6030_gpadc_pm_ops,
+		.of_match_table = of_twl6030_match_tbl,
+	},
+};
+
+module_platform_driver(twl6030_gpadc_driver);
+
+MODULE_ALIAS("platform: " DRIVER_NAME);
+MODULE_AUTHOR("Texas Instruments Inc.");
+MODULE_DESCRIPTION("twl6030 ADC driver");
+MODULE_LICENSE("GPL");
-- 
1.8.1.2

