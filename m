Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754448AbaIXN62 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 09:58:28 -0400
Received: from ns.mm-sol.com ([37.157.136.199]:53616 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750817AbaIXN6Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 09:58:25 -0400
From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
To: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Jonathan Cameron <jic23@kernel.org>,
        Grant Likely <grant.likely@linaro.org>
Cc: "Ivan T. Ivanov" <iivanov@mm-sol.com>,
        Lars-Peter Clausen <lars@metafoo.de>, Hartmut Knaack <knaack.h@gmx.de>,
        Lee Jones <lee.jones@linaro.org>, Philippe Reynes <tremyfr@yahoo.fr>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-iio@vger.kernel.org, linux-arm-msm@vger.kernel.org
Subject: [PATCH v2] iio: iadc: Qualcomm SPMI PMIC current ADC driver
Date: Wed, 24 Sep 2014 16:58:23 +0300
Message-Id: <1411567103-2380-1-git-send-email-iivanov@mm-sol.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The current ADC is peripheral of Qualcomm SPMI PMIC chips. It has
16 bits resolution and register space inside PMIC accessible across
SPMI bus.

The driver registers itself through IIO interface.

Signed-off-by: Ivan T. Ivanov <iivanov@mm-sol.com>
---
Changes:
- Fix Kconfig dependencies 
- Reword Kconfig help text
- Replace IIO_CHAN_INFO_PROCESSED with IIO_CHAN_INFO_RAW and IIO_CHAN_INFO_SCALE,
  This enable client drivers to use microampers precission, instead miliamps.
- Use const array for iio_schan_spec-fiers.
- Fix spelling errors and adress review comments.  

Previous version:
https://www.mail-archive.com/linux-kernel@vger.kernel.org/msg728360.html

 .../devicetree/bindings/iio/adc/qcom,spmi-iadc.txt |  61 ++
 drivers/iio/adc/Kconfig                            |  11 +
 drivers/iio/adc/Makefile                           |   1 +
 drivers/iio/adc/qcom-spmi-iadc.c                   | 691 +++++++++++++++++++++
 4 files changed, 764 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/iio/adc/qcom,spmi-iadc.txt
 create mode 100644 drivers/iio/adc/qcom-spmi-iadc.c

diff --git a/Documentation/devicetree/bindings/iio/adc/qcom,spmi-iadc.txt b/Documentation/devicetree/bindings/iio/adc/qcom,spmi-iadc.txt
new file mode 100644
index 0000000..06e58b6
--- /dev/null
+++ b/Documentation/devicetree/bindings/iio/adc/qcom,spmi-iadc.txt
@@ -0,0 +1,61 @@
+Qualcomm's SPMI PMIC current ADC
+
+QPNP PMIC current ADC (IADC) provides interface to clients to read current.
+A 16 bit ADC is used for current measurements.
+
+IADC node:
+
+- compatible:
+    Usage: required
+    Value type: <string>
+    Definition: Should contain "qcom,spmi-iadc".
+
+- reg:
+    Usage: required
+    Value type: <prop-encoded-array>
+    Definition: IADC base address and length in the SPMI PMIC register map.
+                TRIM_CNST_RDS register address and length(1)
+
+- interrupts:
+    Usage: optional
+    Value type: <prop-encoded-array>
+    Definition: End of conversion interrupt number. If property is
+            missing driver will use polling to detect end of conversion
+            completion.
+
+- qcom,rsense:
+    Usage: optional
+    Value type: <u32>
+    Definition: External sense register value in Ohm. Defining this
+            propery will instruct ADC to use external ADC sense channel.
+            If property is not defined ADC will use internal sense channel.
+
+- qcom,rds-trim:
+    Usage: optional
+    Value type: <u32>
+    Definition: Calculate internal sense resistor value based TRIM_CNST_RDS,
+            IADC RDS and manufacturer.
+            0: Read the IADC and SMBB trim register and apply the default
+               RSENSE if conditions are met.
+            1: Read the IADC, SMBB trim register and manufacturer type and
+               apply the default RSENSE if conditions are met.
+            2: Read the IADC, SMBB trim register and apply the default RSENSE
+               if conditions are met.
+            If property is not defined driver will use qcom,rsense value if
+            defined or internal sense resistor value trimmed into register.
+
+Example:
+	/* IADC node */
+	pmic_iadc: iadc@3600 {
+		compatible = "qcom,spmi-iadc";
+		reg = <0x3600 0x100>,
+			  <0x12f1 0x1>;
+		interrupts = <0x0 0x36 0x0 IRQ_TYPE_EDGE_RISING>;
+		qcom,rds-trim = <0>;
+	};
+
+	/* IIO client node */
+	bat {
+		io-channels = <&pmic_iadc 0>;
+		io-channel-names = "iadc";
+	};
diff --git a/drivers/iio/adc/Kconfig b/drivers/iio/adc/Kconfig
index 11b048a..ee1ad5b 100644
--- a/drivers/iio/adc/Kconfig
+++ b/drivers/iio/adc/Kconfig
@@ -206,6 +206,17 @@ config NAU7802
 	  To compile this driver as a module, choose M here: the
 	  module will be called nau7802.
 
+config QCOM_SPMI_IADC
+	tristate "Qualcomm SPMI PMIC current ADC"
+	depends on SPMI
+	select REGMAP_SPMI
+	help
+	  This is the IIO Current ADC driver for Qualcomm QPNP IADC Chip.
+
+	  The driver supports single mode operation to read from one of two
+	  channels (external or internal). Hardware have additional
+	  channels internally used for gain and offset calibration.
+
 config TI_ADC081C
 	tristate "Texas Instruments ADC081C021/027"
 	depends on I2C
diff --git a/drivers/iio/adc/Makefile b/drivers/iio/adc/Makefile
index ad81b51..c790543 100644
--- a/drivers/iio/adc/Makefile
+++ b/drivers/iio/adc/Makefile
@@ -30,3 +30,4 @@ obj-$(CONFIG_VF610_ADC) += vf610_adc.o
 obj-$(CONFIG_VIPERBOARD_ADC) += viperboard_adc.o
 xilinx-xadc-y := xilinx-xadc-core.o xilinx-xadc-events.o
 obj-$(CONFIG_XILINX_XADC) += xilinx-xadc.o
+obj-$(CONFIG_QCOM_SPMI_IADC) += qcom-spmi-iadc.o
diff --git a/drivers/iio/adc/qcom-spmi-iadc.c b/drivers/iio/adc/qcom-spmi-iadc.c
new file mode 100644
index 0000000..be3f591
--- /dev/null
+++ b/drivers/iio/adc/qcom-spmi-iadc.c
@@ -0,0 +1,691 @@
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
+#include <linux/mutex.h>
+#include <linux/module.h>
+#include <linux/of.h>
+#include <linux/platform_device.h>
+#include <linux/regmap.h>
+#include <linux/slab.h>
+
+/* IADC register and bit definition */
+#define IADC_REVISION2				0x1
+#define IADC_REVISION2_SUPPORTED_IADC		1
+
+#define IADC_PERPH_TYPE				0x4
+#define IADC_PERPH_TYPE_ADC			8
+
+#define IADC_PERPH_SUBTYPE			0x5
+#define IADC_PERPH_SUBTYPE_IADC			3
+
+#define IADC_STATUS1				0x8
+#define IADC_STATUS1_OP_MODE			4
+#define IADC_STATUS1_REQ_STS			BIT(1)
+#define IADC_STATUS1_EOC			BIT(0)
+#define IADC_STATUS1_REQ_STS_EOC_MASK		0x3
+
+#define IADC_MODE_CTL				0x40
+#define IADC_OP_MODE_SHIFT			3
+#define IADC_OP_MODE_NORMAL			0
+#define IADC_TRIM_EN				BIT(0)
+
+#define IADC_EN_CTL1				0x46
+#define IADC_EN_CTL1_SET			BIT(7)
+
+#define IADC_CH_SEL_CTL				0x48
+
+#define IADC_DIG_PARAM				0x50
+#define IADC_DIG_DEC_RATIO_SEL_SHIFT		2
+
+#define IADC_HW_SETTLE_DELAY			0x51
+
+#define IADC_CONV_REQ				0x52
+#define IADC_CONV_REQ_SET			BIT(7)
+
+#define IADC_FAST_AVG_CTL			0x5a
+#define IADC_FAST_AVG_EN			0x5b
+#define IADC_FAST_AVG_EN_SET			BIT(7)
+
+#define IADC_PERH_RESET_CTL3			0xda
+#define IADC_FOLLOW_WARM_RB			BIT(2)
+
+#define IADC_DATA0				0x60
+#define IADC_DATA1				0x61
+
+#define IADC_SEC_ACCESS				0xd0
+#define IADC_SEC_ACCESS_DATA			0xa5
+
+#define IADC_INT_TEST_VAL			0xe1
+#define IADC_MSB_OFFSET				0xf2
+#define IADC_LSB_OFFSET				0xf3
+
+#define IADC_NOMINAL_RSENSE			0xf4
+#define IADC_NOMINAL_RSENSE_SIGN_MASK		BIT(7)
+
+#define IADC_REF_GAIN_MICRO_VOLTS		17857
+
+#define IADC_INTERNAL_RSENSE_OHMS		10000000
+#define IADC_RSENSE_OHMS_PER_BIT		15625
+
+#define IADC_TRIM_CNST_RDS_MASK			0x7
+
+#define IADC_FACTORY_GF				0
+#define IADC_FACTORY_SMIC			1
+#define IADC_FACTORY_TSMC			2
+
+#define IADC_TRIM2_FULLSCALE			127
+
+#define IADC_RSENSE_DEFAULT_VALUE		7800000
+#define IADC_RSENSE_DEFAULT_GF			9000000
+#define IADC_RSENSE_DEFAULT_SMIC		9700000
+
+#define IADC_CONV_TIME_MIN_US			2000
+#define IADC_CONV_TIME_MAX_US			2100
+
+#define IADC_DEF_PRESCALING			0 /* 1:1 */
+#define IADC_DEF_DECIMATION			0 /* 512 */
+#define IADC_DEF_HW_SETTLE_TIME			0 /* 0 us */
+#define IADC_DEF_AVG_SAMPLES			0 /* 1 sample */
+
+/* IADC IADC channel list */
+#define IADC_INTERNAL_RSENSE			0
+#define IADC_EXTERNAL_RSENSE			1
+#define IADC_ALT_LEAD_PAIR			2
+#define IADC_GAIN_17P857MV			3
+#define IADC_OFFSET_SHORT_CADC_LEADS		4
+#define IADC_OFFSET_CSP_CSN			5
+#define IADC_OFFSET_CSP2_CSN2			6
+#define IADC_CHANNEL_COUNT			7
+
+/**
+ * struct iadc_drv - IADC Current ADC device structure.
+ * @regmap: regmap for register read/write.
+ * @dev: This device pointer.
+ * @factory: Chip manufacturer.
+ * @base: base offset for the ADC peripheral.
+ * @trim_rds: Address of the Trim Constant Rds register.
+ * @rsense: Sense register in Ohms.
+ * @ext_sense: Using external sense resistor.
+ * @poll_eoc: Poll for end of conversion instead of waiting for IRQ.
+ * @offset_raw: Raw offset value for the channel.
+ * @gain_raw: Raw gain of the channel.
+ * @lock: ADC lock for access to the peripheral.
+ * @complete: ADC notification after end of conversion interrupt is received.
+ */
+struct iadc_chip {
+	struct regmap *regmap;
+	struct device *dev;
+	u8 factory;
+	u16 base;
+	u16 trim_rds;
+	int rsense;
+	bool ext_sense;
+	bool poll_eoc;
+	u16 offset_raw;
+	u16 gain_raw;
+	struct mutex lock;
+	struct completion complete;
+};
+
+static int iadc_read(struct iadc_chip *iadc, u16 offset, u8 *data)
+{
+	unsigned int val;
+	int ret;
+
+	ret = regmap_read(iadc->regmap, iadc->base + offset, &val);
+	if (ret < 0)
+		return ret;
+
+	*data = val;
+	return 0;
+}
+
+static int iadc_write(struct iadc_chip *iadc, u16 offset, u8 data)
+{
+	return regmap_write(iadc->regmap, iadc->base + offset, data);
+}
+
+static int iadc_reset(struct iadc_chip *iadc)
+{
+	u8 data;
+	int ret;
+
+	ret = iadc_write(iadc, IADC_SEC_ACCESS, IADC_SEC_ACCESS_DATA);
+	if (ret < 0)
+		return ret;
+
+	ret = iadc_read(iadc, IADC_PERH_RESET_CTL3, &data);
+	if (ret < 0)
+		return ret;
+
+	ret = iadc_write(iadc, IADC_SEC_ACCESS, IADC_SEC_ACCESS_DATA);
+	if (ret < 0)
+		return ret;
+
+	data |= IADC_FOLLOW_WARM_RB;
+
+	return iadc_write(iadc, IADC_PERH_RESET_CTL3, data);
+}
+
+static int iadc_set_state(struct iadc_chip *iadc, bool state)
+{
+	u8 data = 0;
+
+	if (state)
+		data = IADC_EN_CTL1_SET;
+
+	return iadc_write(iadc, IADC_EN_CTL1, data);
+}
+
+static void iadc_status_show(struct iadc_chip *iadc)
+{
+	u8 mode, sta1, chan, dig, en, req;
+	int ret;
+
+	ret = iadc_read(iadc, IADC_MODE_CTL, &mode);
+	if (ret < 0)
+		return;
+
+	ret = iadc_read(iadc, IADC_DIG_PARAM, &dig);
+	if (ret < 0)
+		return;
+
+	ret = iadc_read(iadc, IADC_CH_SEL_CTL, &chan);
+	if (ret < 0)
+		return;
+
+	ret = iadc_read(iadc, IADC_CONV_REQ, &req);
+	if (ret < 0)
+		return;
+
+	ret = iadc_read(iadc, IADC_STATUS1, &sta1);
+	if (ret < 0)
+		return;
+
+	ret = iadc_read(iadc, IADC_EN_CTL1, &en);
+	if (ret < 0)
+		return;
+
+	dev_warn(iadc->dev,
+		"mode:%02x en:%02x chan:%02x dig:%02x req:%02x sta1:%02x\n",
+		mode, en, chan, dig, req, sta1);
+}
+
+static int iadc_configure(struct iadc_chip *iadc, int channel)
+{
+	u8 decim, mode;
+	int ret;
+
+	/* Mode selection */
+	mode = (IADC_OP_MODE_NORMAL << IADC_OP_MODE_SHIFT) | IADC_TRIM_EN;
+	ret = iadc_write(iadc, IADC_MODE_CTL, mode);
+	if (ret < 0)
+		return ret;
+
+	/* Channel selection */
+	ret = iadc_write(iadc, IADC_CH_SEL_CTL, channel);
+	if (ret < 0)
+		return ret;
+
+	/* Digital parameter setup */
+	decim = IADC_DEF_DECIMATION << IADC_DIG_DEC_RATIO_SEL_SHIFT;
+	ret = iadc_write(iadc, IADC_DIG_PARAM, decim);
+	if (ret < 0)
+		return ret;
+
+	/* HW settle time delay */
+	ret = iadc_write(iadc, IADC_HW_SETTLE_DELAY, IADC_DEF_HW_SETTLE_TIME);
+	if (ret < 0)
+		return ret;
+
+	ret = iadc_write(iadc, IADC_FAST_AVG_CTL, IADC_DEF_AVG_SAMPLES);
+	if (ret < 0)
+		return ret;
+
+	if (IADC_DEF_AVG_SAMPLES)
+		ret = iadc_write(iadc, IADC_FAST_AVG_EN, IADC_FAST_AVG_EN_SET);
+	else
+		ret = iadc_write(iadc, IADC_FAST_AVG_EN, 0);
+
+	if (ret < 0)
+		return ret;
+
+	if (!iadc->poll_eoc)
+		reinit_completion(&iadc->complete);
+
+	ret = iadc_set_state(iadc, true);
+	if (ret < 0)
+		return ret;
+
+	/* Request conversion */
+	return iadc_write(iadc, IADC_CONV_REQ, IADC_CONV_REQ_SET);
+}
+
+static int iadc_poll_wait_eoc(struct iadc_chip *iadc, int interval_us)
+{
+	int ret, count, retry;
+	u8 sta1;
+
+	retry = interval_us / IADC_CONV_TIME_MIN_US;
+
+	for (count = 0; count < retry; count++) {
+		ret = iadc_read(iadc, IADC_STATUS1, &sta1);
+		if (ret < 0)
+			return ret;
+
+		sta1 &= IADC_STATUS1_REQ_STS_EOC_MASK;
+		if (sta1 == IADC_STATUS1_EOC)
+			return 0;
+
+		usleep_range(IADC_CONV_TIME_MIN_US, IADC_CONV_TIME_MAX_US);
+	}
+
+	iadc_status_show(iadc);
+
+	return -ETIMEDOUT;
+}
+
+static int iadc_read_result(struct iadc_chip *iadc, u16 *data)
+{
+	u8 lsb, msb;
+	int ret;
+
+	ret = iadc_read(iadc, IADC_DATA0, &lsb);
+	if (ret < 0)
+		return ret;
+
+	ret = iadc_read(iadc, IADC_DATA1, &msb);
+	if (ret < 0)
+		return ret;
+
+	*data = (msb << 8) | lsb;
+
+	return 0;
+}
+
+static int iadc_do_conversion(struct iadc_chip *iadc, int chan, u16 *data)
+{
+	int wait, ret;
+
+	ret = iadc_configure(iadc, chan);
+	if (ret < 0)
+		goto exit;
+
+	wait = BIT(IADC_DEF_AVG_SAMPLES) * IADC_CONV_TIME_MIN_US * 2;
+
+	if (iadc->poll_eoc) {
+		ret = iadc_poll_wait_eoc(iadc, wait);
+	} else {
+		ret = wait_for_completion_timeout(&iadc->complete, wait);
+		if (!ret)
+			ret = -ETIMEDOUT;
+		else
+			/* double check conversion status */
+			ret = iadc_poll_wait_eoc(iadc, IADC_CONV_TIME_MIN_US);
+	}
+
+	if (!ret)
+		ret = iadc_read_result(iadc, data);
+exit:
+	iadc_set_state(iadc, false);
+	if (ret < 0)
+		dev_err(iadc->dev, "conversion failed\n");
+
+	return ret;
+}
+
+static int iadc_read_raw(struct iio_dev *indio_dev,
+			 struct iio_chan_spec const *chan,
+			 int *val, int *val2, long mask)
+{
+	struct iadc_chip *iadc = iio_priv(indio_dev);
+	long rsense_ua, rsense_uv, rsense_raw;
+	int ret, sign;
+	u16 adc_raw;
+
+	mutex_lock(&iadc->lock);
+
+	switch (mask) {
+	case IIO_CHAN_INFO_RAW:
+		ret = iadc_do_conversion(iadc, chan->channel, &adc_raw);
+		if (ret < 0)
+			goto exit;
+
+		rsense_raw = adc_raw - iadc->offset_raw;
+
+		rsense_uv = rsense_raw * IADC_REF_GAIN_MICRO_VOLTS;
+		rsense_uv /= iadc->gain_raw - iadc->offset_raw;
+
+		sign = 1;
+		if (rsense_uv < 0)
+			sign = -1;
+
+		rsense_ua = sign * rsense_uv;
+
+		do_div(rsense_ua, iadc->rsense);
+
+		rsense_ua = sign * rsense_ua;
+
+		dev_dbg(iadc->dev, "offset %d, gain %d, adc %d, V=%ld,uV, I=%ld,uA\n",
+			iadc->offset_raw, iadc->gain_raw, adc_raw,
+			rsense_uv, rsense_ua);
+
+		*val = rsense_ua;
+		ret = IIO_VAL_INT;
+		break;
+	case IIO_CHAN_INFO_SCALE:
+		*val = 0;
+		*val2 = 1000;
+		ret = IIO_VAL_INT_PLUS_MICRO;
+		break;
+	default:
+		ret = -EINVAL;
+		break;
+	}
+
+exit:
+	mutex_unlock(&iadc->lock);
+
+	return ret;
+}
+
+static const struct iio_info iadc_info = {
+	.read_raw = iadc_read_raw,
+	.driver_module = THIS_MODULE,
+};
+
+static irqreturn_t iadc_isr(int irq, void *dev_id)
+{
+	struct iadc_chip *iadc = dev_id;
+
+	complete(&iadc->complete);
+
+	return IRQ_HANDLED;
+}
+
+static int iadc_update_trim_offset(struct iadc_chip *iadc)
+{
+	int ret, chan;
+
+	ret = iadc_do_conversion(iadc, IADC_GAIN_17P857MV, &iadc->gain_raw);
+	if (ret < 0)
+		return ret;
+
+	chan = IADC_OFFSET_CSP2_CSN2;
+	if (iadc->ext_sense)
+		chan = IADC_OFFSET_CSP_CSN;
+
+	ret = iadc_do_conversion(iadc, chan, &iadc->offset_raw);
+	if (ret < 0)
+		return ret;
+
+	if ((iadc->gain_raw - iadc->offset_raw) == 0) {
+		dev_err(iadc->dev, "error: offset %d gain %d\n",
+			iadc->offset_raw, iadc->gain_raw);
+		return -EINVAL;
+	}
+
+	ret = iadc_write(iadc, IADC_SEC_ACCESS, IADC_SEC_ACCESS_DATA);
+	if (ret < 0)
+		return ret;
+
+	ret = iadc_write(iadc, IADC_MSB_OFFSET, iadc->offset_raw >> 8);
+	if (ret < 0)
+		return ret;
+
+	ret = iadc_write(iadc, IADC_SEC_ACCESS, IADC_SEC_ACCESS_DATA);
+	if (ret < 0)
+		return ret;
+
+	return iadc_write(iadc, IADC_LSB_OFFSET, iadc->offset_raw & 0xff);
+}
+
+static int iadc_version_check(struct iadc_chip *iadc)
+{
+	u8 revision, type, subtype;
+	int ret;
+
+	ret = iadc_read(iadc, IADC_PERPH_TYPE, &type);
+	if (ret < 0)
+		return ret;
+
+	if (type < IADC_PERPH_TYPE_ADC) {
+		dev_err(iadc->dev, "%d is not ADC\n", type);
+		return -EINVAL;
+	}
+
+	ret = iadc_read(iadc, IADC_PERPH_SUBTYPE, &subtype);
+	if (ret < 0)
+		return ret;
+
+	if (subtype < IADC_PERPH_SUBTYPE_IADC) {
+		dev_err(iadc->dev, "%d is not IADC\n", subtype);
+		return -EINVAL;
+	}
+
+	ret = iadc_read(iadc, IADC_REVISION2, &revision);
+	if (ret < 0)
+		return ret;
+
+	if (revision < IADC_REVISION2_SUPPORTED_IADC) {
+		dev_err(iadc->dev, "revision %d not supported\n", revision);
+		return -EINVAL;
+	}
+
+	return iadc_read(iadc, IADC_INT_TEST_VAL, &iadc->factory);
+}
+
+static int iadc_rsense_read(struct iadc_chip *iadc, struct device_node *node)
+{
+	unsigned int trim_val;
+	u8 rsense, const_rds;
+	int ret, sign;
+	u32 trim_type;
+
+	ret = of_property_read_u32(node, "qcom,rsense", &iadc->rsense);
+	if (!ret) {
+		iadc->ext_sense = true;
+		return 0;
+	}
+
+	ret = iadc_read(iadc, IADC_NOMINAL_RSENSE, &rsense);
+	if (ret < 0)
+		return ret;
+
+	sign = 1;
+	if (rsense & IADC_NOMINAL_RSENSE_SIGN_MASK)
+		sign = -1;
+
+	rsense &= ~IADC_NOMINAL_RSENSE_SIGN_MASK;
+
+	iadc->rsense = IADC_INTERNAL_RSENSE_OHMS;
+	iadc->rsense += sign * rsense * IADC_RSENSE_OHMS_PER_BIT;
+
+	if (rsense < IADC_TRIM2_FULLSCALE)
+		return 0;
+	/*
+	 * Trim register is "saturated", check for specific trim value
+	 * based on manufacturer and RDS constant
+	 */
+	ret = of_property_read_u32(node, "qcom,rds-trim", &trim_type);
+	if (ret)
+		return 0;
+
+	ret = regmap_read(iadc->regmap, iadc->trim_rds, &trim_val);
+	if (ret < 0)
+		return ret;
+
+	const_rds = trim_val & IADC_TRIM_CNST_RDS_MASK;
+
+	dev_dbg(iadc->dev, "factory %d trim type %d rsense %d const %d\n",
+		iadc->factory, trim_type, rsense, const_rds);
+
+	switch (trim_type) {
+	case 0:
+		if (const_rds == 2)
+			iadc->rsense = IADC_RSENSE_DEFAULT_VALUE;
+		break;
+	case 1:
+		if (const_rds >= 2) {
+			iadc->rsense = IADC_RSENSE_DEFAULT_VALUE;
+		} else if (const_rds < 2) {
+			if (iadc->factory == IADC_FACTORY_GF)
+				iadc->rsense = IADC_RSENSE_DEFAULT_GF;
+			else if (iadc->factory == IADC_FACTORY_SMIC)
+				iadc->rsense = IADC_RSENSE_DEFAULT_SMIC;
+		}
+		break;
+	case 2:
+		if (const_rds > 0 && const_rds <= 2)
+			iadc->rsense = IADC_RSENSE_DEFAULT_VALUE;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static const struct iio_chan_spec iadc_channels[] = {
+	{
+		.type = IIO_CURRENT,
+		.datasheet_name	= "INTERNAL_RSENSE",
+		.channel = 0,
+		.info_mask_separate = BIT(IIO_CHAN_INFO_RAW) |
+				      BIT(IIO_CHAN_INFO_SCALE),
+	},
+	{
+		.type = IIO_CURRENT,
+		.datasheet_name	= "EXTERNAL_RSENSE",
+		.channel = 1,
+		.info_mask_separate = BIT(IIO_CHAN_INFO_RAW) |
+				      BIT(IIO_CHAN_INFO_SCALE),
+	},
+};
+
+static int iadc_probe(struct platform_device *pdev)
+{
+	struct device_node *node = pdev->dev.of_node;
+	struct device *dev = &pdev->dev;
+	struct iio_dev *indio_dev;
+	struct iadc_chip *iadc;
+	struct resource *res;
+	int ret, irq_eoc;
+
+	indio_dev = devm_iio_device_alloc(dev, sizeof(*iadc));
+	if (!indio_dev)
+		return -ENOMEM;
+
+	iadc = iio_priv(indio_dev);
+	iadc->dev = dev;
+
+	iadc->regmap = dev_get_regmap(dev->parent, NULL);
+	if (!iadc->regmap)
+		return -ENODEV;
+
+	init_completion(&iadc->complete);
+	mutex_init(&iadc->lock);
+
+	platform_set_drvdata(pdev, iadc);
+
+	res = platform_get_resource(pdev, IORESOURCE_REG, 0);
+	if (!res)
+		return -ENODEV;
+
+	iadc->base = res->start;
+
+	res = platform_get_resource(pdev, IORESOURCE_REG, 1);
+	if (!res)
+		return -ENODEV;
+
+	iadc->trim_rds = res->start;
+
+	ret = iadc_version_check(iadc);
+	if (ret < 0)
+		return -ENODEV;
+
+	ret = iadc_rsense_read(iadc, node);
+	if (ret < 0)
+		return -ENODEV;
+
+	dev_dbg(iadc->dev, "%s sense resistor %d Ohm\n", iadc->ext_sense ?
+		"external" : "internal", iadc->rsense);
+
+	irq_eoc = platform_get_irq(pdev, 0);
+	if (irq_eoc == -EPROBE_DEFER)
+		return irq_eoc;
+
+	if (irq_eoc < 0)
+		iadc->poll_eoc = true;
+
+	ret = iadc_reset(iadc);
+	if (ret < 0) {
+		dev_err(dev, "reset failed\n");
+		return ret;
+	}
+
+	if (!iadc->poll_eoc) {
+		ret = devm_request_irq(dev, irq_eoc, iadc_isr, 0,
+					"spmi-iadc", iadc);
+		if (!ret)
+			enable_irq_wake(irq_eoc);
+		else
+			return ret;
+	} else {
+		device_init_wakeup(iadc->dev, 1);
+	}
+
+	ret = iadc_update_trim_offset(iadc);
+	if (ret < 0) {
+		dev_err(dev, "failed trim offset calibration\n");
+		return ret;
+	}
+
+	indio_dev->dev.parent = dev;
+	indio_dev->dev.of_node = node;
+	indio_dev->name = pdev->name;
+	indio_dev->modes = INDIO_DIRECT_MODE;
+	indio_dev->info = &iadc_info;
+	indio_dev->channels = &iadc_channels[0];
+	if (iadc->ext_sense)
+		indio_dev->channels = &iadc_channels[1];
+	indio_dev->num_channels = 1;
+
+	return devm_iio_device_register(dev, indio_dev);
+}
+
+static const struct of_device_id iadc_match_table[] = {
+	{ .compatible = "qcom,spmi-iadc" },
+	{ }
+};
+MODULE_DEVICE_TABLE(of, iadc_match_table);
+
+static struct platform_driver iadc_driver = {
+	.driver = {
+		   .name = "spmi-iadc",
+		   .of_match_table = iadc_match_table,
+	},
+	.probe = iadc_probe,
+};
+module_platform_driver(iadc_driver);
+
+MODULE_ALIAS("platform:spmi-iadc");
+MODULE_DESCRIPTION("Qualcomm SPMI PMIC current ADC driver");
+MODULE_LICENSE("GPL v2");
-- 
1.9.1

