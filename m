Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752903AbaJGERp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 00:17:45 -0400
Received: from mga02.intel.com ([134.134.136.20]:64460 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752681AbaJGERh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 00:17:37 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,667,1406617200"; 
   d="scan'208";a="482423661"
From: Jacob Pan <jacob.jun.pan@linux.intel.com>
To: IIO <linux-iio@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        DEVICE TREE <devicetree@vger.kernel.org>,
        Lee Jones <lee.jones@linaro.org>
Cc: Carlo Caione <carlo@caione.org>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        Aaron Lu <aaron.lu@intel.com>, Alan Cox <alan@linux.intel.com>,
        Jean Delvare <khali@linux-fr.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Grant Likely <grant.likely@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Rob Herring <robh+dt@kernel.org>, Lars-Peter Clausen <lars@metafoo.de>,
        Hartmut Knaack <knaack.h@gmx.de>, Fugang Duan <B38611@freescale.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Zubair Lutfullah <zubair.lutfullah@gmail.com>,
        Sebastian Reichel <sre@debian.org>,
        Johannes Thumshirn <johannes.thumshirn@men.de>,
        Philippe Reynes <tremyfr@yahoo.fr>,
        Angelo Compagnucci <angelo.compagnucci@gmail.com>,
        Doug Anderson <dianders@chromium.org>,
        Ramakrishna Pallala <ramakrishna.pallala@intel.com>,
        Peter Meerwald <pmeerw@pmeerw.net>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Rafael Wysocki <rafael.j.wysocki@intel.com>,
        Todd Brandt <todd.e.brandt@linux.intel.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>
Subject: [PATCH v7 2/2] iio/adc: add support for axp288 adc
Date: Mon,  6 Oct 2014 21:17:15 -0700
Message-Id: <1412655435-31284-3-git-send-email-jacob.jun.pan@linux.intel.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1412655435-31284-1-git-send-email-jacob.jun.pan@linux.intel.com>
References: <1412655435-31284-1-git-send-email-jacob.jun.pan@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Platform driver for X-Powers AXP288 ADC, which is a sub-device of the
customized AXP288 PMIC for Intel Baytrail-CR platforms. GPADC device
enumerates as one of the MFD cell devices. It uses IIO infrastructure
to communicate with userspace and consumer drivers.

Usages of ADC channels include battery charging and thermal sensors.

Based on initial work by:
Ramakrishna Pallala <ramakrishna.pallala@intel.com>

Acked-by: Jonathan Cameron <jic23@kernel.org>
Signed-off-by: Jacob Pan <jacob.jun.pan@linux.intel.com>
---
 drivers/iio/adc/Kconfig      |   8 ++
 drivers/iio/adc/Makefile     |   1 +
 drivers/iio/adc/axp288_adc.c | 254 +++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 263 insertions(+)
 create mode 100644 drivers/iio/adc/axp288_adc.c

diff --git a/drivers/iio/adc/Kconfig b/drivers/iio/adc/Kconfig
index 11b048a..db2681b 100644
--- a/drivers/iio/adc/Kconfig
+++ b/drivers/iio/adc/Kconfig
@@ -127,6 +127,14 @@ config AT91_ADC
 	help
 	  Say yes here to build support for Atmel AT91 ADC.
 
+config AXP288_ADC
+	tristate "X-Powers AXP288 ADC driver"
+	depends on MFD_AXP20X
+	help
+	  Say yes here to have support for X-Powers power management IC (PMIC) ADC
+	  device. Depending on platform configuration, this general purpose ADC can
+	  be used for sampling sensors such as thermal resistors.
+
 config EXYNOS_ADC
 	tristate "Exynos ADC driver support"
 	depends on ARCH_EXYNOS || (OF && COMPILE_TEST)
diff --git a/drivers/iio/adc/Makefile b/drivers/iio/adc/Makefile
index ad81b51..19640f9 100644
--- a/drivers/iio/adc/Makefile
+++ b/drivers/iio/adc/Makefile
@@ -14,6 +14,7 @@ obj-$(CONFIG_AD7793) += ad7793.o
 obj-$(CONFIG_AD7887) += ad7887.o
 obj-$(CONFIG_AD799X) += ad799x.o
 obj-$(CONFIG_AT91_ADC) += at91_adc.o
+obj-$(CONFIG_AXP288_ADC) += axp288_adc.o
 obj-$(CONFIG_EXYNOS_ADC) += exynos_adc.o
 obj-$(CONFIG_LP8788_ADC) += lp8788_adc.o
 obj-$(CONFIG_MAX1027) += max1027.o
diff --git a/drivers/iio/adc/axp288_adc.c b/drivers/iio/adc/axp288_adc.c
new file mode 100644
index 0000000..4800286
--- /dev/null
+++ b/drivers/iio/adc/axp288_adc.c
@@ -0,0 +1,254 @@
+/*
+ * axp288_adc.c - X-Powers AXP288 PMIC ADC Driver
+ *
+ * Copyright (C) 2014 Intel Corporation
+ *
+ * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; version 2 of the License.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.	See the GNU
+ * General Public License for more details.
+ *
+ */
+
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/device.h>
+#include <linux/regmap.h>
+#include <linux/mfd/axp20x.h>
+#include <linux/platform_device.h>
+
+#include <linux/iio/iio.h>
+#include <linux/iio/machine.h>
+#include <linux/iio/driver.h>
+
+#define AXP288_ADC_EN_MASK		0xF1
+#define AXP288_ADC_TS_PIN_GPADC		0xF2
+#define AXP288_ADC_TS_PIN_ON		0xF3
+
+enum axp288_adc_id {
+	AXP288_ADC_TS,
+	AXP288_ADC_PMIC,
+	AXP288_ADC_GP,
+	AXP288_ADC_BATT_CHRG_I,
+	AXP288_ADC_BATT_DISCHRG_I,
+	AXP288_ADC_BATT_V,
+	AXP288_ADC_NR_CHAN,
+};
+
+struct axp288_adc_info {
+	int irq;
+	struct regmap *regmap;
+};
+
+static const struct iio_chan_spec const axp288_adc_channels[] = {
+	{
+		.indexed = 1,
+		.type = IIO_TEMP,
+		.channel = 0,
+		.address = AXP288_TS_ADC_H,
+		.datasheet_name = "TS_PIN",
+	}, {
+		.indexed = 1,
+		.type = IIO_TEMP,
+		.channel = 1,
+		.address = AXP288_PMIC_ADC_H,
+		.datasheet_name = "PMIC_TEMP",
+	}, {
+		.indexed = 1,
+		.type = IIO_TEMP,
+		.channel = 2,
+		.address = AXP288_GP_ADC_H,
+		.datasheet_name = "GPADC",
+	}, {
+		.indexed = 1,
+		.type = IIO_CURRENT,
+		.channel = 3,
+		.address = AXP20X_BATT_CHRG_I_H,
+		.datasheet_name = "BATT_CHG_I",
+		.info_mask_separate = BIT(IIO_CHAN_INFO_PROCESSED),
+	}, {
+		.indexed = 1,
+		.type = IIO_CURRENT,
+		.channel = 4,
+		.address = AXP20X_BATT_DISCHRG_I_H,
+		.datasheet_name = "BATT_DISCHRG_I",
+		.info_mask_separate = BIT(IIO_CHAN_INFO_PROCESSED),
+	}, {
+		.indexed = 1,
+		.type = IIO_VOLTAGE,
+		.channel = 5,
+		.address = AXP20X_BATT_V_H,
+		.datasheet_name = "BATT_V",
+		.info_mask_separate = BIT(IIO_CHAN_INFO_PROCESSED),
+	},
+};
+
+#define AXP288_ADC_MAP(_adc_channel_label, _consumer_dev_name,	\
+		_consumer_channel)				\
+	{							\
+		.adc_channel_label = _adc_channel_label,	\
+		.consumer_dev_name = _consumer_dev_name,	\
+		.consumer_channel = _consumer_channel,		\
+	}
+
+/* for consumer drivers */
+static struct iio_map axp288_adc_default_maps[] = {
+	AXP288_ADC_MAP("TS_PIN", "axp288-batt", "axp288-batt-temp"),
+	AXP288_ADC_MAP("PMIC_TEMP", "axp288-pmic", "axp288-pmic-temp"),
+	AXP288_ADC_MAP("GPADC", "axp288-gpadc", "axp288-system-temp"),
+	AXP288_ADC_MAP("BATT_CHG_I", "axp288-chrg", "axp288-chrg-curr"),
+	AXP288_ADC_MAP("BATT_DISCHRG_I", "axp288-chrg", "axp288-chrg-d-curr"),
+	AXP288_ADC_MAP("BATT_V", "axp288-batt", "axp288-batt-volt"),
+	{},
+};
+
+static int axp288_adc_read_channel(int *val, unsigned long address,
+				struct regmap *regmap)
+{
+	u8 buf[2];
+
+	if (regmap_bulk_read(regmap, address, buf, 2))
+		return -EIO;
+	*val = (buf[0] << 4) + ((buf[1] >> 4) & 0x0F);
+
+	return IIO_VAL_INT;
+}
+
+static int axp288_adc_set_ts(struct regmap *regmap, unsigned int mode,
+				unsigned long address)
+{
+	/* channels other than GPADC do not need to switch TS pin */
+	if (address != AXP288_GP_ADC_H)
+		return 0;
+
+	return regmap_write(regmap, AXP288_ADC_TS_PIN_CTRL, mode);
+}
+
+static int axp288_adc_read_raw(struct iio_dev *indio_dev,
+			struct iio_chan_spec const *chan,
+			int *val, int *val2, long mask)
+{
+	int ret;
+	struct axp288_adc_info *info = iio_priv(indio_dev);
+
+	mutex_lock(&indio_dev->mlock);
+	switch (mask) {
+	case IIO_CHAN_INFO_RAW:
+		if (axp288_adc_set_ts(info->regmap, AXP288_ADC_TS_PIN_GPADC,
+					chan->address)) {
+			dev_err(&indio_dev->dev, "GPADC mode\n");
+			ret = -EINVAL;
+			break;
+		}
+		ret = axp288_adc_read_channel(val, chan->address, info->regmap);
+		if (axp288_adc_set_ts(info->regmap, AXP288_ADC_TS_PIN_ON,
+						chan->address))
+			dev_err(&indio_dev->dev, "TS pin restore\n");
+		break;
+	case IIO_CHAN_INFO_PROCESSED:
+		ret = axp288_adc_read_channel(val, chan->address, info->regmap);
+		break;
+	default:
+		ret = -EINVAL;
+	}
+	mutex_unlock(&indio_dev->mlock);
+
+	return ret;
+}
+
+static int axp288_adc_set_state(struct regmap *regmap)
+{
+	/* ADC should be always enabled for internal FG to function */
+	if (regmap_write(regmap, AXP288_ADC_TS_PIN_CTRL, AXP288_ADC_TS_PIN_ON))
+		return -EIO;
+
+	return regmap_write(regmap, AXP20X_ADC_EN1, AXP288_ADC_EN_MASK);
+}
+
+static const struct iio_info axp288_adc_iio_info = {
+	.read_raw = &axp288_adc_read_raw,
+	.driver_module = THIS_MODULE,
+};
+
+static int axp288_adc_probe(struct platform_device *pdev)
+{
+	int ret;
+	struct axp288_adc_info *info;
+	struct iio_dev *indio_dev;
+	struct axp20x_dev *axp20x = dev_get_drvdata(pdev->dev.parent);
+
+	indio_dev = devm_iio_device_alloc(&pdev->dev, sizeof(*info));
+	if (!indio_dev)
+		return -ENOMEM;
+
+	info = iio_priv(indio_dev);
+	info->irq = platform_get_irq(pdev, 0);
+	if (info->irq < 0) {
+		dev_err(&pdev->dev, "no irq resource?\n");
+		return info->irq;
+	}
+	platform_set_drvdata(pdev, indio_dev);
+	info->regmap = axp20x->regmap;
+	/*
+	 * Set ADC to enabled state at all time, including system suspend.
+	 * otherwise internal fuel gauge functionality may be affected.
+	 */
+	ret = axp288_adc_set_state(axp20x->regmap);
+	if (ret) {
+		dev_err(&pdev->dev, "unable to enable ADC device\n");
+		return ret;
+	}
+
+	indio_dev->dev.parent = &pdev->dev;
+	indio_dev->name = pdev->name;
+	indio_dev->channels = axp288_adc_channels;
+	indio_dev->num_channels = ARRAY_SIZE(axp288_adc_channels);
+	indio_dev->info = &axp288_adc_iio_info;
+	indio_dev->modes = INDIO_DIRECT_MODE;
+	ret = iio_map_array_register(indio_dev, axp288_adc_default_maps);
+	if (ret < 0)
+		return ret;
+
+	ret = iio_device_register(indio_dev);
+	if (ret < 0) {
+		dev_err(&pdev->dev, "unable to register iio device\n");
+		goto err_array_unregister;
+	}
+	return 0;
+
+err_array_unregister:
+	iio_map_array_unregister(indio_dev);
+
+	return ret;
+}
+
+static int axp288_adc_remove(struct platform_device *pdev)
+{
+	struct iio_dev *indio_dev = platform_get_drvdata(pdev);
+
+	iio_device_unregister(indio_dev);
+	iio_map_array_unregister(indio_dev);
+
+	return 0;
+}
+
+static struct platform_driver axp288_adc_driver = {
+	.probe = axp288_adc_probe,
+	.remove = axp288_adc_remove,
+	.driver = {
+		.name = "axp288_adc",
+		.owner = THIS_MODULE,
+	},
+};
+
+module_platform_driver(axp288_adc_driver);
+
+MODULE_AUTHOR("Jacob Pan <jacob.jun.pan@linux.intel.com>");
+MODULE_DESCRIPTION("X-Powers AXP288 ADC Driver");
+MODULE_LICENSE("GPL");
-- 
1.9.1

