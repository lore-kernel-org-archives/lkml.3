Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753106AbaA3KL2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jan 2014 05:11:28 -0500
Received: from mail-pa0-f41.google.com ([209.85.220.41]:51773 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751445AbaA3KLJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jan 2014 05:11:09 -0500
From: Matt Ranostay <mranostay@gmail.com>
To: linux-kernel@vger.kernel.org, linux-iio@vger.kernel.org
Cc: matt.porter@linaro.org, koen@dominion.thruhere.net,
        pantelis.antoniou@gmail.com, Matt Ranostay <mranostay@gmail.com>
Subject: [PATCH 2/2] iio: Add AS3935 lightning sensor support
Date: Thu, 30 Jan 2014 02:11:13 -0800
Message-Id: <1391076673-5623-2-git-send-email-mranostay@gmail.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1391076673-5623-1-git-send-email-mranostay@gmail.com>
References: <1391076673-5623-1-git-send-email-mranostay@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

AS3935 chipset can detect lightning strikes and reports those
back as events and the esimated distance to the storm.

Signed-off-by: Matt Ranostay <mranostay@gmail.com>
---
 .../devicetree/bindings/iio/distance/as3935.txt    |  25 ++
 drivers/iio/Kconfig                                |   1 +
 drivers/iio/Makefile                               |   1 +
 drivers/iio/distance/Kconfig                       |  19 +
 drivers/iio/distance/Makefile                      |   6 +
 drivers/iio/distance/as3935.c                      | 459 +++++++++++++++++++++
 6 files changed, 511 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/iio/distance/as3935.txt
 create mode 100644 drivers/iio/distance/Kconfig
 create mode 100644 drivers/iio/distance/Makefile
 create mode 100644 drivers/iio/distance/as3935.c

diff --git a/Documentation/devicetree/bindings/iio/distance/as3935.txt b/Documentation/devicetree/bindings/iio/distance/as3935.txt
new file mode 100644
index 0000000..af35827
--- /dev/null
+++ b/Documentation/devicetree/bindings/iio/distance/as3935.txt
@@ -0,0 +1,25 @@
+Austrian Microsystems AS3935 Franklin lightning sensor device driver
+
+Required properties:
+	- compatible: must be "ams,as3935"
+	- reg: SPI chip select number for the device
+	- spi-max-frequency: Max SPI frequency to use
+	- spi-cpha: SPI Mode 1
+	- gpios: GPIO input of interrupt line from IRQ pin of AS3935 IC
+
+Optional properties:
+	- ams,tune-cap: Calibration tuning capacitor stepping value 0 - 15.
+	  Range of 0 to 120 pF, 8pF steps. This will require using the calibration
+	  data from the manufacturer.
+
+
+Example:
+
+		as3935@0 {
+			compatible = "ams,as3935";
+			reg = <0>;
+			spi-max-frequency = <100000>;
+			spi-cpha;
+			ams,tune-cap = /bits/ 8 <10>;
+			gpios = <&gpio1 16 10>;
+		};
diff --git a/drivers/iio/Kconfig b/drivers/iio/Kconfig
index 5dd0e12..5164a68 100644
--- a/drivers/iio/Kconfig
+++ b/drivers/iio/Kconfig
@@ -63,6 +63,7 @@ source "drivers/iio/adc/Kconfig"
 source "drivers/iio/amplifiers/Kconfig"
 source "drivers/iio/common/Kconfig"
 source "drivers/iio/dac/Kconfig"
+source "drivers/iio/distance/Kconfig"
 source "drivers/iio/frequency/Kconfig"
 source "drivers/iio/gyro/Kconfig"
 source "drivers/iio/humidity/Kconfig"
diff --git a/drivers/iio/Makefile b/drivers/iio/Makefile
index 887d390..1574731 100644
--- a/drivers/iio/Makefile
+++ b/drivers/iio/Makefile
@@ -16,6 +16,7 @@ obj-y += adc/
 obj-y += amplifiers/
 obj-y += common/
 obj-y += dac/
+obj-y += distance/
 obj-y += gyro/
 obj-y += frequency/
 obj-y += humidity/
diff --git a/drivers/iio/distance/Kconfig b/drivers/iio/distance/Kconfig
new file mode 100644
index 0000000..753352c
--- /dev/null
+++ b/drivers/iio/distance/Kconfig
@@ -0,0 +1,19 @@
+#
+# Distance sensors
+#
+
+menu "Lightning sensors"
+
+config AS3935
+	tristate "AS3935 Franklin lightning sensor"
+	select IIO_BUFFER
+	select IIO_TRIGGERED_BUFFER
+	depends on SPI
+	help
+	 If you say yes here you get support for the Austrian Microsystems
+	 AS3935 lightning detection sensor.
+
+	 This driver can also be built as a module. If so, the module
+	 will be called as3935
+
+endmenu
diff --git a/drivers/iio/distance/Makefile b/drivers/iio/distance/Makefile
new file mode 100644
index 0000000..f63b70d
--- /dev/null
+++ b/drivers/iio/distance/Makefile
@@ -0,0 +1,6 @@
+#
+# Makefile for IIO distance sensors
+#
+
+# When adding new entries keep the list in alphabetical order
+obj-$(CONFIG_AS3935)		+= as3935.o
diff --git a/drivers/iio/distance/as3935.c b/drivers/iio/distance/as3935.c
new file mode 100644
index 0000000..1a8f48d
--- /dev/null
+++ b/drivers/iio/distance/as3935.c
@@ -0,0 +1,459 @@
+/*
+ * as3935.c - Support for AS3935 Franklin lightning sensor
+ *
+ * Copyright (C) 2014 Matt Ranostay <mranostay@gmail.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
+ * GNU General Public License for more details.
+ *
+ */
+
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/interrupt.h>
+#include <linux/delay.h>
+#include <linux/mutex.h>
+#include <linux/workqueue.h>
+#include <linux/err.h>
+#include <linux/irq.h>
+#include <linux/gpio.h>
+#include <linux/spi/spi.h>
+#include <linux/iio/iio.h>
+#include <linux/iio/sysfs.h>
+#include <linux/iio/trigger.h>
+#include <linux/iio/trigger_consumer.h>
+#include <linux/iio/buffer.h>
+#include <linux/iio/triggered_buffer.h>
+#include <linux/pinctrl/pinctrl.h>
+#include <linux/pinctrl/pinmux.h>
+#include <linux/pinctrl/consumer.h>
+#include <linux/pm_runtime.h>
+#include <linux/of_gpio.h>
+
+
+#define AS3935_AFE_GAIN		0x00
+#define AS3935_AFE_MASK		0x3F
+#define AS3935_AFE_GAIN_MAX	0x1F
+
+#define AS3935_INT		0x03
+#define AS3935_INT_MASK		0x07
+#define AS3935_DATA		0x07
+#define AS3935_DATA_MASK	0x1F
+
+#define AS3935_TUNE_CAP		0x08
+#define AS3935_CALIBRATE	0x3D
+
+#define AS3935_WRITE_DATA	(0x1 << 15)
+#define AS3935_READ_DATA	(0x1 << 14)
+#define AS3935_ADDRESS(x)	(x << 8)
+
+#define AS3935_EVENT_INT	(1<<3)
+#define AS3935_NOISE_INT	(1<<0)
+
+struct as3935_state {
+	struct spi_device *spi;
+	struct mutex lock;
+
+	struct iio_trigger *trig;
+	struct delayed_work work;
+
+	u8 tune_cap;
+};
+
+static const struct iio_chan_spec as3935_channels[] = {
+	{
+		.type           = IIO_DISTANCE,
+		.channel        = 0,
+		.info_mask_separate =
+			BIT(IIO_CHAN_INFO_RAW),
+		.scan_index     = 0,
+		.scan_type = {
+			.sign           = 'u',
+			.realbits       = 6,
+			.storagebits    = 6,
+		},
+		.modified = 0,
+	},
+	IIO_CHAN_SOFT_TIMESTAMP(1),
+};
+
+static const unsigned long as3935_available_scan_masks[] = { 0x01, 0x0 };
+
+static int as3935_read(struct as3935_state *st, unsigned int reg, int *val)
+{
+	u8 tx, rx;
+	int ret;
+
+	struct spi_transfer xfers[] = {
+		{
+			.tx_buf = &tx,
+			.bits_per_word = 8,
+			.len = 1,
+		}, {
+			.rx_buf = &rx,
+			.bits_per_word = 8,
+			.len = 1,
+		},
+	};
+
+	mutex_lock(&st->lock);
+	tx = (AS3935_READ_DATA | AS3935_ADDRESS(reg)) >> 8;
+
+	ret = spi_sync_transfer(st->spi, xfers, ARRAY_SIZE(xfers));
+	mutex_unlock(&st->lock);
+
+	*val = rx;
+
+	return ret;
+};
+
+static int as3935_write(struct as3935_state *st,
+				unsigned int reg,
+				unsigned int val)
+{
+	u8 buf[2];
+	int ret;
+
+	mutex_lock(&st->lock);
+	buf[0] = AS3935_WRITE_DATA | AS3935_ADDRESS(reg) >> 8;
+	buf[1] = val;
+
+	ret = spi_write(st->spi, (u8 *) &buf, 2);
+	mutex_unlock(&st->lock);
+
+	return ret;
+};
+
+static ssize_t gain_boost_show(struct device *dev,
+				struct device_attribute *attr,
+				char *buf)
+{
+	struct as3935_state *st = iio_priv(dev_to_iio_dev(dev));
+	int val, ret;
+
+	ret = as3935_read(st, AS3935_AFE_GAIN, &val);
+	if (ret)
+		return ret;
+	val = (val & AS3935_AFE_MASK) >> 1;
+
+	return sprintf(buf, "%d\n", val);
+};
+
+static ssize_t gain_boost_store(struct device *dev,
+					struct device_attribute *attr,
+					const char *buf, size_t len)
+{
+	struct as3935_state *st = iio_priv(dev_to_iio_dev(dev));
+	unsigned long val;
+	int ret;
+
+	ret = kstrtoul((const char *) buf, 10, &val);
+	if (ret)
+		return -EINVAL;
+
+	if (val > AS3935_AFE_GAIN_MAX)
+		return -EINVAL;
+
+	as3935_write(st, AS3935_AFE_GAIN, val << 1);
+
+	return len;
+};
+
+static IIO_DEVICE_ATTR(gain_boost, S_IRUGO | S_IWUSR,
+	gain_boost_show, gain_boost_store, 0);
+
+
+static struct attribute *as3935_attributes[] = {
+	&iio_dev_attr_gain_boost.dev_attr.attr,
+	NULL,
+};
+
+static struct attribute_group as3935_attribute_group = {
+	.attrs = as3935_attributes,
+};
+
+static int as3935_read_raw(struct iio_dev *indio_dev,
+			   struct iio_chan_spec const *chan,
+			   int *val,
+			   int *val2,
+			   long m)
+{
+	struct as3935_state *st = iio_priv(indio_dev);
+
+	if (m == IIO_CHAN_INFO_RAW) {
+		int ret;
+		*val = 0;
+		ret = as3935_read(st, AS3935_DATA, val2);
+		if (ret)
+			return ret;
+		return IIO_VAL_INT;
+	}
+
+	return -EINVAL;
+}
+
+static const struct iio_info as3935_info = {
+	.driver_module = THIS_MODULE,
+	.attrs = &as3935_attribute_group,
+	.read_raw = &as3935_read_raw,
+};
+
+static const struct iio_buffer_setup_ops iio_triggered_buffer_setup_ops = {
+	.postenable = &iio_triggered_buffer_postenable,
+	.predisable = &iio_triggered_buffer_predisable,
+};
+
+static irqreturn_t as3935_trigger_handler(int irq, void *private)
+{
+	struct iio_poll_func *pf = private;
+	struct iio_dev *indio_dev = pf->indio_dev;
+	struct as3935_state *st = iio_priv(indio_dev);
+	int val, ret;
+
+	ret = as3935_read(st, AS3935_DATA, &val);
+	if (ret)
+		goto err_read;
+	val &= AS3935_DATA_MASK;
+	iio_push_to_buffers_with_timestamp(indio_dev, &val, iio_get_time_ns());
+
+	iio_trigger_notify_done(indio_dev->trig);
+err_read:
+
+	return IRQ_HANDLED;
+};
+
+static const struct iio_trigger_ops iio_interrupt_trigger_ops = {
+	.owner = THIS_MODULE,
+};
+
+static void as3935_event_work(struct work_struct *work)
+{
+	struct as3935_state *st;
+	struct spi_device *spi;
+	int val;
+
+	st = container_of(work, struct as3935_state, work.work);
+	spi = st->spi;
+
+	as3935_read(st, AS3935_INT, &val);
+	val &= AS3935_INT_MASK;
+
+	switch (val) {
+	case AS3935_EVENT_INT:
+		iio_trigger_poll(st->trig, 0);
+		break;
+	case AS3935_NOISE_INT:
+		dev_warn(&spi->dev, "noise level is too high");
+		break;
+	}
+};
+
+static irqreturn_t as3935_interrupt_handler(int irq, void *private)
+{
+	struct iio_dev *indio_dev = private;
+	struct as3935_state *st = iio_priv(indio_dev);
+
+	cancel_delayed_work(&st->work);
+	schedule_delayed_work(&st->work, jiffies_to_msecs(3));
+	return IRQ_HANDLED;
+}
+
+static void calibrate_as3935(struct as3935_state *st)
+{
+	/* mask disturber interrupt bit */
+	as3935_write(st, AS3935_INT, 1 << 5);
+
+	as3935_write(st, AS3935_CALIBRATE, 0x96);
+	as3935_write(st, AS3935_TUNE_CAP, 1 << 5 | st->tune_cap);
+
+	mdelay(2);
+	as3935_write(st, AS3935_TUNE_CAP, st->tune_cap);
+}
+
+#ifdef CONFIG_PM_SLEEP
+static int as3935_suspend(struct spi_device *spi, pm_message_t msg)
+{
+	struct iio_dev *indio_dev = spi_get_drvdata(spi);
+	struct as3935_state *st = iio_priv(indio_dev);
+	int val, ret;
+
+	ret = as3935_read(st, AS3935_AFE_GAIN, &val);
+	if (ret)
+		return ret;
+	val |= 0x01;
+
+	return as3935_write(st, AS3935_AFE_GAIN, val);
+}
+
+static int as3935_resume(struct spi_device *spi)
+{
+	struct iio_dev *indio_dev = spi_get_drvdata(spi);
+	struct as3935_state *st = iio_priv(indio_dev);
+	int val, ret;
+
+	ret = as3935_read(st, AS3935_AFE_GAIN, &val);
+	if (ret)
+		return ret;
+	val &= ~1;
+
+	return as3935_write(st, AS3935_AFE_GAIN, val);
+}
+#else
+#define as3935_suspend	NULL
+#define as3935_resume	NULL
+#endif
+
+static int as3935_probe(struct spi_device *spi)
+{
+	struct iio_dev *indio_dev;
+	struct iio_trigger *trig;
+	struct as3935_state *st;
+	struct device_node *np = spi->dev.of_node;
+	int gpio;
+	int irq;
+	int ret;
+
+	/* Grab the GPIO to use for lightning event interrupt */
+	if (np)
+		gpio = of_get_gpio(spi->dev.of_node, 0);
+	else {
+		dev_err(&spi->dev, "unable to get interrupt gpio\n");
+		return -EINVAL;
+	}
+
+	/* GPIO event setup */
+	ret = devm_gpio_request(&spi->dev, gpio, "as3935");
+	if (ret) {
+		dev_err(&spi->dev, "failed to request GPIO %u\n", gpio);
+		return ret;
+	}
+
+	ret = gpio_direction_input(gpio);
+	if (ret) {
+		dev_err(&spi->dev, "failed to set pin direction\n");
+		return -EINVAL;
+	}
+
+	/* IRQ setup */
+	irq = gpio_to_irq(gpio);
+	if (irq < 0) {
+		dev_err(&spi->dev, "failed to map GPIO to IRQ: %d\n", irq);
+		return -EINVAL;
+	}
+
+	indio_dev = devm_iio_device_alloc(&spi->dev, sizeof(st));
+	if (!indio_dev)
+		return -ENOMEM;
+
+	st = iio_priv(indio_dev);
+	st->spi = spi;
+	st->tune_cap = 0;
+	spi_set_drvdata(spi, indio_dev);
+	mutex_init(&st->lock);
+	INIT_DELAYED_WORK(&st->work, as3935_event_work);
+
+	of_property_read_u8(np, "ams,tune-cap", &st->tune_cap);
+	if (st->tune_cap > 15) {
+		dev_err(&spi->dev,
+			"wrong tune_cap setting of %d\n", st->tune_cap);
+		return -EINVAL;
+	}
+
+	indio_dev->dev.parent = &spi->dev;
+	indio_dev->name = spi_get_device_id(spi)->name;
+	indio_dev->channels = as3935_channels;
+	indio_dev->num_channels = ARRAY_SIZE(as3935_channels);
+	indio_dev->modes = INDIO_DIRECT_MODE;
+	indio_dev->available_scan_masks = as3935_available_scan_masks;
+	indio_dev->info = &as3935_info;
+
+	trig = devm_iio_trigger_alloc(&spi->dev, "%s-dev%d",
+				      indio_dev->name, indio_dev->id);
+
+	if (!trig)
+		return -ENOMEM;
+
+	st->trig = trig;
+	trig->dev.parent = indio_dev->dev.parent;
+	iio_trigger_set_drvdata(trig, indio_dev);
+	trig->ops = &iio_interrupt_trigger_ops;
+
+	ret = iio_trigger_register(trig);
+	if (ret) {
+		dev_err(&spi->dev, "failed to register trigger\n");
+		return ret;
+	}
+
+	ret = iio_triggered_buffer_setup(indio_dev, NULL,
+					&as3935_trigger_handler,
+					&iio_triggered_buffer_setup_ops);
+
+	if (ret) {
+		dev_err(&spi->dev, "cannot setup iio trigger\n");
+		return -EINVAL;
+	}
+
+	calibrate_as3935(st);
+
+	ret = devm_request_irq(&spi->dev, irq,
+				&as3935_interrupt_handler,
+				IRQF_TRIGGER_RISING,
+				dev_name(&spi->dev),
+				indio_dev);
+
+	if (ret) {
+		dev_err(&spi->dev, "unable to request irq\n");
+		goto uninit_buffer;
+	}
+
+	ret = iio_device_register(indio_dev);
+	if (ret < 0) {
+		dev_err(&spi->dev, "unable to register device\n");
+		goto uninit_buffer;
+	}
+
+	return 0;
+
+uninit_buffer:
+	iio_triggered_buffer_cleanup(indio_dev);
+
+	return ret;
+};
+
+static int as3935_remove(struct spi_device *spi)
+{
+	struct iio_dev *indio_dev = spi_get_drvdata(spi);
+
+	iio_device_unregister(indio_dev);
+	return 0;
+};
+
+static const struct spi_device_id as3935_id[] = {
+	{"as3935", 0},
+	{},
+};
+MODULE_DEVICE_TABLE(spi, as3935_id);
+
+static struct spi_driver as3935_driver = {
+	.driver = {
+		.name	= "as3935",
+		.owner	= THIS_MODULE,
+	},
+	.probe		= as3935_probe,
+	.remove		= as3935_remove,
+	.id_table	= as3935_id,
+	.suspend	= as3935_suspend,
+	.resume		= as3935_resume,
+};
+module_spi_driver(as3935_driver);
+
+MODULE_AUTHOR("Matt Ranostay <mranostay@gmail.com>");
+MODULE_DESCRIPTION("AS3935 lightning sensor");
+MODULE_LICENSE("GPL");
-- 
1.8.3.2

