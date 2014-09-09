Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756717AbaIINE0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 09:04:26 -0400
Received: from mga11.intel.com ([192.55.52.93]:52210 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753744AbaIINEX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 09:04:23 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,491,1406617200"; 
   d="scan'208";a="588546369"
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
        Jacob Pan <jacob.jun.pan@linux.intel.com>
Subject: [PATCH v2 4/4] iio/adc/axp288: add support for axp288 gpadc
Date: Tue,  9 Sep 2014 06:02:55 -0700
Message-Id: <1410267775-4683-5-git-send-email-jacob.jun.pan@linux.intel.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1410267775-4683-1-git-send-email-jacob.jun.pan@linux.intel.com>
References: <1410267775-4683-1-git-send-email-jacob.jun.pan@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Platform driver for XPowers AXP288 ADC, which is a customized PMIC for Intel
Baytrail-CR platforms. GPADC device enumerates as one of the PMIC MFD cell
devices. It uses IIO infrastructure to communicate with userspace and
consumer drivers.

Usages of ADC channels include battery charging and thermal sensors.

Based on initial work by:
Ramakrishna Pallala <ramakrishna.pallala@intel.com>

Signed-off-by: Jacob Pan <jacob.jun.pan@linux.intel.com>
---
 drivers/iio/adc/Kconfig        |   8 ++
 drivers/iio/adc/Makefile       |   1 +
 drivers/iio/adc/axp288_gpadc.c | 250 +++++++++++++++++++++++++++++++++++++++++
 3 files changed, 259 insertions(+)
 create mode 100644 drivers/iio/adc/axp288_gpadc.c

diff --git a/drivers/iio/adc/Kconfig b/drivers/iio/adc/Kconfig
index 11b048a..f5c61c0 100644
--- a/drivers/iio/adc/Kconfig
+++ b/drivers/iio/adc/Kconfig
@@ -279,4 +279,12 @@ config XILINX_XADC
 	  The driver can also be build as a module. If so, the module will be called
 	  xilinx-xadc.
 
+config AXP288_GPADC
+	tristate "X-Power AXP288 GPADC driver"
+	depends on MFD_AXP2XX
+	help
+	  Say yes here to have support for X-Power power management IC (PMIC) ADC
+	  device. Depending on platform configuration, this general purpose ADC can
+	  be used for sampling sensors such as thermal resisters.
+
 endmenu
diff --git a/drivers/iio/adc/Makefile b/drivers/iio/adc/Makefile
index ad81b51..8bf0104 100644
--- a/drivers/iio/adc/Makefile
+++ b/drivers/iio/adc/Makefile
@@ -30,3 +30,4 @@ obj-$(CONFIG_VF610_ADC) += vf610_adc.o
 obj-$(CONFIG_VIPERBOARD_ADC) += viperboard_adc.o
 xilinx-xadc-y := xilinx-xadc-core.o xilinx-xadc-events.o
 obj-$(CONFIG_XILINX_XADC) += xilinx-xadc.o
+obj-$(CONFIG_AXP288_GPADC) += axp288_gpadc.o
diff --git a/drivers/iio/adc/axp288_gpadc.c b/drivers/iio/adc/axp288_gpadc.c
new file mode 100644
index 0000000..7ca6bbf
--- /dev/null
+++ b/drivers/iio/adc/axp288_gpadc.c
@@ -0,0 +1,250 @@
+/*
+ * axp288_gpadc.c - Xpower AXP288 PMIC GPADC Driver
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
+#include <linux/mfd/axp2xx.h>
+#include <linux/platform_device.h>
+
+#include <linux/iio/iio.h>
+#include <linux/iio/machine.h>
+#include <linux/iio/driver.h>
+#define ADC_EN_MASK			0xF1
+#define ADC_TS_PIN_GPADC                0xF2
+#define ADC_TS_PIN_ON                   0xF3
+
+struct gpadc_info {
+	unsigned int irq;
+	struct device *dev;
+	struct regmap *regmap;
+};
+
+#define ADC_CHANNEL(_type, _channel, _address)	        \
+	{								\
+		.indexed = 1,						\
+		.type = _type,						\
+		.channel = _channel,					\
+		.address = _address,					\
+		.datasheet_name = "CH"#_channel,			\
+		.scan_index = _channel,					\
+		.scan_type = {						\
+			.sign = 'u',					\
+			.realbits = 12,					\
+			.storagebits = 32,				\
+			.endianness = IIO_LE,				\
+		},							\
+		.info_mask_separate = BIT(IIO_CHAN_INFO_RAW),		\
+	}
+
+static const struct iio_chan_spec const axp288_adc_channels[] = {
+	ADC_CHANNEL(IIO_TEMP, 0, AXP288_TS_ADC_H),
+	ADC_CHANNEL(IIO_TEMP, 1, AXP288_PMIC_ADC_H),
+	ADC_CHANNEL(IIO_TEMP, 2, AXP288_GP_ADC_H),
+	ADC_CHANNEL(IIO_CURRENT, 3, AXP20X_BATT_CHRG_I_H),
+	ADC_CHANNEL(IIO_CURRENT, 4, AXP20X_BATT_DISCHRG_I_H),
+	ADC_CHANNEL(IIO_VOLTAGE, 5, AXP20X_BATT_V_H),
+};
+
+#define ADC_MAP(_adc_channel_label,				\
+		     _consumer_dev_name,			\
+		     _consumer_channel)				\
+	{							\
+		.adc_channel_label = _adc_channel_label,	\
+		.consumer_dev_name = _consumer_dev_name,	\
+		.consumer_channel = _consumer_channel,		\
+	}
+
+/* for consumer drivers */
+static struct iio_map axp288_iio_default_maps[] = {
+	ADC_MAP("TS_PIN", "axp288-batt", "axp288-batt-temp"),
+	ADC_MAP("PMIC_TEMP", "axp288-pmic", "axp288-pmic-temp"),
+	ADC_MAP("GPADC", "axp288-gpadc", "axp288-system-temp"),
+	ADC_MAP("BATT_CHG_I", "axp288-chrg", "axp288-chrg-curr"),
+	ADC_MAP("BATT_DISCHRG_I", "axp288-chrg", "axp288-chrg-d-curr"),
+	ADC_MAP("BATT_V", "axp288-batt", "axp288-batt-volt"),
+	{},
+};
+
+static int axp288_adc_read_raw(struct iio_dev *indio_dev,
+			struct iio_chan_spec const *chan,
+			int *val, int *val2, long m)
+{
+	int ret;
+	struct gpadc_info *info = iio_priv(indio_dev);
+	unsigned int th, tl;
+
+	mutex_lock(&indio_dev->mlock);
+
+	/* special case for GPADC sample */
+	if (chan->address == AXP288_GP_ADC_H)
+		regmap_write(info->regmap, AXP288_ADC_TS_PIN_CTRL,
+			ADC_TS_PIN_GPADC);
+
+	ret = regmap_read(info->regmap, chan->address, &th);
+	if (ret) {
+		dev_err(&indio_dev->dev, "sample raw data high failed\n");
+		goto exit_done;
+	}
+
+	ret = regmap_read(info->regmap, chan->address + 1, &tl);
+	if (ret) {
+		dev_err(&indio_dev->dev, "sample raw data low failed\n");
+		goto exit_done;
+	}
+
+	*val = (th << 4) + ((tl >> 4) & 0x0F);
+	ret = IIO_VAL_INT;
+
+exit_done:
+	if (chan->address == AXP288_GP_ADC_H)
+		regmap_write(info->regmap, AXP288_ADC_TS_PIN_CTRL,
+			ADC_TS_PIN_ON);
+
+	mutex_unlock(&indio_dev->mlock);
+
+	return ret;
+}
+
+static int axp288_gpadc_enable(struct regmap *regmap, bool enable)
+{
+	unsigned int pin_on, adc_en;
+
+	if (enable) {
+		pin_on = ADC_TS_PIN_ON;
+		adc_en = ADC_EN_MASK;
+	} else {
+		pin_on = ~ADC_TS_PIN_ON;
+		adc_en = ~ADC_EN_MASK;
+	}
+	if (regmap_write(regmap, AXP288_ADC_TS_PIN_CTRL, pin_on))
+		return -EIO;
+
+	return regmap_write(regmap, AXP20X_ADC_EN1, ~ADC_EN_MASK);
+}
+
+static const struct iio_info axp288_iio_info = {
+	.read_raw = &axp288_adc_read_raw,
+	.driver_module = THIS_MODULE,
+};
+
+static int axp288_gpadc_probe(struct platform_device *pdev)
+{
+	int err;
+	struct gpadc_info *info;
+	struct iio_dev *indio_dev;
+	struct axp2xx_dev *axp2xx = dev_get_drvdata(pdev->dev.parent);
+	int irq;
+
+	indio_dev = devm_iio_device_alloc(&pdev->dev, sizeof(*info));
+	if (!indio_dev)
+		return -ENOMEM;
+
+	info = iio_priv(indio_dev);
+	irq = platform_get_irq(pdev, 0);
+	if (irq < 0) {
+		dev_err(&pdev->dev, "no irq resource?\n");
+		return irq;
+	}
+	info->irq = irq;
+	platform_set_drvdata(pdev, indio_dev);
+	info->regmap = axp2xx->regmap;
+	axp288_gpadc_enable(axp2xx->regmap, true);
+
+	indio_dev->dev.parent = &pdev->dev;
+	indio_dev->name = pdev->name;
+	indio_dev->channels = axp288_adc_channels;
+	indio_dev->num_channels = ARRAY_SIZE(axp288_adc_channels);
+	indio_dev->info = &axp288_iio_info;
+	indio_dev->modes = INDIO_DIRECT_MODE;
+	/* REVISIT: override default map with platform data */
+	err = iio_map_array_register(indio_dev, axp288_iio_default_maps);
+	if (err)
+		goto err_disable_dev;
+
+	err = iio_device_register(indio_dev);
+	if (err < 0) {
+		dev_err(&pdev->dev, "unable to register iio device\n");
+		goto err_array_unregister;
+	}
+	return 0;
+
+err_array_unregister:
+	iio_map_array_unregister(indio_dev);
+err_disable_dev:
+	axp288_gpadc_enable(axp2xx->regmap, false);
+	return err;
+}
+
+static int axp288_gpadc_remove(struct platform_device *pdev)
+{
+	struct iio_dev *indio_dev = platform_get_drvdata(pdev);
+
+	iio_device_unregister(indio_dev);
+	iio_map_array_unregister(indio_dev);
+
+	return 0;
+}
+
+#if defined(CONFIG_PM_SLEEP) || defined(CONFIG_PM_RUNTIME)
+static int axp288_gpadc_suspend(struct device *dev)
+{
+	int ret;
+	struct iio_dev *indio_dev = dev_get_drvdata(dev);
+	struct gpadc_info *info = iio_priv(indio_dev);
+
+	mutex_lock(&indio_dev->mlock);
+	ret = axp288_gpadc_enable(info->regmap, false);
+	mutex_unlock(&indio_dev->mlock);
+
+	return ret;
+}
+
+static int axp288_gpadc_resume(struct device *dev)
+{
+	int ret;
+	struct iio_dev *indio_dev = dev_get_drvdata(dev);
+	struct gpadc_info *info = iio_priv(indio_dev);
+
+	mutex_lock(&indio_dev->mlock);
+	ret = axp288_gpadc_enable(info->regmap, true);
+	mutex_unlock(&indio_dev->mlock);
+
+	return ret;
+}
+#endif
+
+static UNIVERSAL_DEV_PM_OPS(axp288_gpadc_pm_ops, axp288_gpadc_suspend,
+			axp288_gpadc_resume, NULL);
+
+static struct platform_driver axp288_gpadc_driver = {
+	.probe = axp288_gpadc_probe,
+	.remove = axp288_gpadc_remove,
+	.driver = {
+		.name = "axp288_adc",
+		.owner = THIS_MODULE,
+		.pm = &axp288_gpadc_pm_ops,
+	},
+};
+
+module_platform_driver(axp288_gpadc_driver);
+
+MODULE_AUTHOR("Jacob Pan <jacob.jun.pan@linux.intel.com>");
+MODULE_DESCRIPTION("Dollar Cove Xpower AXP288 General Purpose ADC Driver");
+MODULE_LICENSE("GPL");
-- 
1.9.1

