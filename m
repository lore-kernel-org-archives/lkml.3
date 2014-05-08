Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755205AbaEHQrb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 12:47:31 -0400
Received: from smtp2-g21.free.fr ([212.27.42.2]:27798 "EHLO smtp2-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755068AbaEHQr3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 12:47:29 -0400
From: Philippe Reynes <tremyfr@yahoo.fr>
To: linux-iio@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, armadeus-forum@lists.sourceforge.net,
        Philippe Reynes <tremyfr@yahoo.fr>
Subject: [PATCH] iio: add support of the max1027
Date: Thu,  8 May 2014 18:47:25 +0200
Message-Id: <1399567645-5956-1-git-send-email-tremyfr@yahoo.fr>
X-Mailer: git-send-email 1.7.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This driver add partial support of the
maxim 1027/1029/1031. Differential mode is not
supported.

It was tested on armadeus apf27 board.

Signed-off-by: Philippe Reynes <tremyfr@yahoo.fr>
---
 .../devicetree/bindings/iio/adc/max1027-adc.txt    |   19 +
 drivers/staging/iio/adc/Kconfig                    |   10 +
 drivers/staging/iio/adc/Makefile                   |    1 +
 drivers/staging/iio/adc/max1027.c                  |  647 ++++++++++++++++++++
 4 files changed, 677 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/iio/adc/max1027-adc.txt
 create mode 100644 drivers/staging/iio/adc/max1027.c

diff --git a/Documentation/devicetree/bindings/iio/adc/max1027-adc.txt b/Documentation/devicetree/bindings/iio/adc/max1027-adc.txt
new file mode 100644
index 0000000..8daafe4
--- /dev/null
+++ b/Documentation/devicetree/bindings/iio/adc/max1027-adc.txt
@@ -0,0 +1,19 @@
+* Maxim 1027/1029/1031 Analog to Digital Converter (ADC)
+
+Required properties:
+  - compatible: Should be "maxim,max1027" or "maxim,max1029" or "maxim,max1031"
+  - reg: Should contain the ADC SPI address
+  - gpios: gpio for end of conversion
+
+Example:
+adc@0 {
+	compatible = "maxim,max1027";
+	pinctrl-names = "default";
+	pinctrl-0 = <&pinctrl_max1027>;
+	/* SPI mode = 0 */
+	spi-cpol = <0>;
+	spi-cpha = <0>;
+	spi-max-frequency = <1000000>;
+	reg = <0>;
+	gpios = <&gpio5 15 0>;
+};
diff --git a/drivers/staging/iio/adc/Kconfig b/drivers/staging/iio/adc/Kconfig
index 3633298..472504b 100644
--- a/drivers/staging/iio/adc/Kconfig
+++ b/drivers/staging/iio/adc/Kconfig
@@ -112,6 +112,16 @@ config LPC32XX_ADC
 	  activate only one via device tree selection.  Provides direct access
 	  via sysfs.
 
+config MAX1027
+	tristate "Maxim max1027 ADC driver"
+	depends on SPI
+	select IIO_BUFFER
+	select IIO_TRIGGERED_BUFFER
+	help
+	  Say yes here to build support for many Maxim spi analog to digital
+	  converters (ADC). (max1027, max1029, max2031) Provides
+	  direct access via sysfs and buffered data via the iio dev interface.
+
 config MXS_LRADC
 	tristate "Freescale i.MX23/i.MX28 LRADC"
 	depends on ARCH_MXS || COMPILE_TEST
diff --git a/drivers/staging/iio/adc/Makefile b/drivers/staging/iio/adc/Makefile
index 3e9fb14..22fbd0c 100644
--- a/drivers/staging/iio/adc/Makefile
+++ b/drivers/staging/iio/adc/Makefile
@@ -18,5 +18,6 @@ obj-$(CONFIG_AD7816) += ad7816.o
 obj-$(CONFIG_AD7192) += ad7192.o
 obj-$(CONFIG_AD7280) += ad7280a.o
 obj-$(CONFIG_LPC32XX_ADC) += lpc32xx_adc.o
+obj-$(CONFIG_MAX1027) += max1027.o
 obj-$(CONFIG_MXS_LRADC) += mxs-lradc.o
 obj-$(CONFIG_SPEAR_ADC) += spear_adc.o
diff --git a/drivers/staging/iio/adc/max1027.c b/drivers/staging/iio/adc/max1027.c
new file mode 100644
index 0000000..a50978f
--- /dev/null
+++ b/drivers/staging/iio/adc/max1027.c
@@ -0,0 +1,647 @@
+ /*
+  * iio/adc/max1027.c
+  * Copyright (C) 2014 Philippe Reynes
+  *
+  * based on linux/drivers/iio/ad7923.c
+  * Copyright 2011 Analog Devices Inc (from AD7923 Driver)
+  * Copyright 2012 CS Systemes d'Information
+  *
+  * This program is free software; you can redistribute it and/or modify
+  * it under the terms of the GNU General Public License version 2 as
+  * published by the Free Software Foundation.
+  *
+  * max1027.c
+  *
+  * Partial support for max1027 and similar chips.
+  *
+  */
+#include <linux/kernel.h>
+#include <linux/spi/spi.h>
+#include <linux/module.h>
+#include <linux/interrupt.h>
+#include <linux/mutex.h>
+#include <linux/of.h>
+#include <linux/of_gpio.h>
+#include <linux/platform_device.h>
+#include <linux/delay.h>
+#include <linux/gpio.h>
+
+#include <linux/iio/iio.h>
+#include <linux/iio/buffer.h>
+#include <linux/iio/trigger.h>
+#include <linux/iio/trigger_consumer.h>
+#include <linux/iio/triggered_buffer.h>
+
+enum max1027_id {
+	max1027,
+	max1029,
+	max1031,
+};
+
+static const struct spi_device_id max1027_id[] = {
+	{"max1027", max1027},
+	{"max1029", max1029},
+	{"max1031", max1031},
+	{}
+};
+MODULE_DEVICE_TABLE(spi, max1027_id);
+
+#ifdef CONFIG_OF
+static const struct of_device_id max1027_adc_dt_ids[] = {
+	{ .compatible = "maxim,max1027" },
+	{ .compatible = "maxim,max1029" },
+	{ .compatible = "maxim,max1031" },
+	{},
+};
+MODULE_DEVICE_TABLE(of, max1027_adc_dt_ids);
+#endif
+
+
+#define MAX1027_V_CHAN(index)						\
+	{								\
+		.type = IIO_VOLTAGE,					\
+		.indexed = 1,						\
+		.channel = index,					\
+		.info_mask_separate = BIT(IIO_CHAN_INFO_RAW),		\
+		.info_mask_shared_by_type = BIT(IIO_CHAN_INFO_SCALE),	\
+		.address = index,					\
+		.scan_index = index+1,					\
+		.scan_type = {						\
+			.sign = 'u',					\
+			.realbits = 10,					\
+			.storagebits = 16,				\
+			.shift = 2,					\
+			.endianness = IIO_BE,				\
+		},							\
+	}
+
+#define MAX1027_T_CHAN(index)						\
+	{								\
+		.type = IIO_TEMP,					\
+		.indexed = 0,						\
+		.channel = index,					\
+		.info_mask_separate = BIT(IIO_CHAN_INFO_RAW),		\
+		.info_mask_shared_by_type = BIT(IIO_CHAN_INFO_SCALE),	\
+		.address = index,					\
+		.scan_index = index,					\
+		.scan_type = {						\
+			.sign = 'u',					\
+			.realbits = 12,					\
+			.storagebits = 16,				\
+			.endianness = IIO_BE,				\
+		},							\
+	}
+
+static const struct iio_chan_spec max1027_channels[] = {
+	MAX1027_T_CHAN(0),
+	MAX1027_V_CHAN(0),
+	MAX1027_V_CHAN(1),
+	MAX1027_V_CHAN(2),
+	MAX1027_V_CHAN(3),
+	MAX1027_V_CHAN(4),
+	MAX1027_V_CHAN(5),
+	MAX1027_V_CHAN(6),
+	MAX1027_V_CHAN(7)
+};
+
+static const struct iio_chan_spec max1029_channels[] = {
+	MAX1027_T_CHAN(0),
+	MAX1027_V_CHAN(0),
+	MAX1027_V_CHAN(1),
+	MAX1027_V_CHAN(2),
+	MAX1027_V_CHAN(3),
+	MAX1027_V_CHAN(4),
+	MAX1027_V_CHAN(5),
+	MAX1027_V_CHAN(6),
+	MAX1027_V_CHAN(7),
+	MAX1027_V_CHAN(8),
+	MAX1027_V_CHAN(9),
+	MAX1027_V_CHAN(10),
+	MAX1027_V_CHAN(11)
+};
+
+static const struct iio_chan_spec max1031_channels[] = {
+	MAX1027_T_CHAN(0),
+	MAX1027_V_CHAN(0),
+	MAX1027_V_CHAN(1),
+	MAX1027_V_CHAN(2),
+	MAX1027_V_CHAN(3),
+	MAX1027_V_CHAN(4),
+	MAX1027_V_CHAN(5),
+	MAX1027_V_CHAN(6),
+	MAX1027_V_CHAN(7),
+	MAX1027_V_CHAN(8),
+	MAX1027_V_CHAN(9),
+	MAX1027_V_CHAN(10),
+	MAX1027_V_CHAN(11),
+	MAX1027_V_CHAN(12),
+	MAX1027_V_CHAN(13),
+	MAX1027_V_CHAN(14),
+	MAX1027_V_CHAN(15)
+};
+
+struct max1027_chip_info {
+	const struct iio_chan_spec *channels;
+	unsigned int num_channels;
+};
+
+static struct max1027_chip_info max1027_chip_info[] = {
+	[max1027] = {
+		.channels = max1027_channels,
+		.num_channels = ARRAY_SIZE(max1027_channels),
+	},
+	[max1029] = {
+		.channels = max1029_channels,
+		.num_channels = ARRAY_SIZE(max1029_channels),
+	},
+	[max1031] = {
+		.channels = max1031_channels,
+		.num_channels = ARRAY_SIZE(max1031_channels),
+	},
+};
+
+struct max1027_state {
+	struct max1027_chip_info	*info;
+	struct spi_device		*spi;
+	struct spi_transfer		read_xfer;
+	struct spi_message		read_msg;
+	struct spi_transfer		write_xfer;
+	struct spi_message		write_msg;
+	struct iio_trigger		*trig;
+	unsigned int			gpio_eoc;
+	unsigned short			*buffer;
+
+	/*
+	 * DMA (thus cache coherency maintenance) requires the
+	 * transfer buffers to live in their own cache lines.
+	 * The buffer needs to be large enough to hold two samples (4 bytes) and
+	 * the naturally aligned timestamp (8 bytes).
+	 */
+	struct {
+		__be16 sample[2];
+		s64 timestamp;
+	} data ____cacheline_aligned;
+};
+
+static int max1027_write_register(struct max1027_state *st, unsigned char reg)
+{
+	int ret;
+	__be16 value = cpu_to_be16(reg << 8);
+
+	pr_debug("%s(st = 0x%p, reg = 0x%02x)\n", __func__, st, reg);
+
+	st->data.sample[0] = value;
+	st->write_xfer.len = 1;
+	ret = spi_sync(st->spi, &st->write_msg);
+	if (ret < 0)
+		pr_err("cant write register\n");
+
+	return ret;
+}
+
+static int max1027_read_value(struct max1027_state *st, int len)
+{
+	int ret;
+
+	pr_debug("%s(st = 0x%p, len = %d)\n", __func__, st, len);
+
+	st->read_xfer.len = len;
+	ret = spi_sync(st->spi, &st->read_msg);
+	if (ret < 0)
+		pr_err("cant read value\n");
+
+	return ret;
+}
+
+static int max1027_read_single_value(struct iio_dev *idev,
+			    struct iio_chan_spec const *chan,
+			    int *val, int *val2, long mask)
+{
+	int ret;
+	unsigned char reg;
+	struct max1027_state *st = iio_priv(idev);
+
+	if (iio_buffer_enabled(idev)) {
+		dev_warn(&idev->dev, "trigger mode already enable");
+		return -EIO;
+	}
+
+	/*
+	 * Start acquisition on conversion register write
+	 * b7-b6 = 1 : setup register
+	 * b5-b4 = 2 : clock mode (internal clock, start on conv write)
+	 * b3-b2 = 2 : reference mode (no wake-up delay)
+	 * b1-b0 = 0 : no unipolar/bipolar configuration
+	 */
+	ret = max1027_write_register(st, 0x68);
+	if (ret < 0) {
+		dev_err(&idev->dev, "Failed to configure setup register\n");
+		return -EIO;
+	}
+
+	/*
+	 * b7    = 1 : conversion register
+	 * b6-b3 = 0 : channel
+	 * b2-b1 = 3 : no scan
+	 * b0    = (chan->type == IIO_TEMP) : temp
+	 */
+	reg = (1 << 7) | (chan->channel << 3) | (3 << 1);
+	if (chan->type == IIO_TEMP)
+		reg |= 1;
+	ret = max1027_write_register(st, reg);
+	if (ret < 0)
+		return ret;
+
+	/*
+	 * For an unknown reason, when we use the mode "10" (write
+	 * conversion register), the it doesn't occur every time.
+	 * So we just wait 1 ms.
+	 */
+	mdelay(1);
+
+	/*
+	 * Read result
+	 */
+	if (chan->type == IIO_TEMP)
+		ret = max1027_read_value(st, 4);
+	else
+		ret = max1027_read_value(st, 2);
+	if (ret < 0)
+		return ret;
+
+	*val = be16_to_cpu(st->data.sample[0]);
+
+	return IIO_VAL_INT;
+}
+
+static int max1027_read_raw(struct iio_dev *idev,
+			    struct iio_chan_spec const *chan,
+			    int *val, int *val2, long mask)
+{
+	int ret = 0;
+
+	switch (mask) {
+	case IIO_CHAN_INFO_RAW:
+		ret = max1027_read_single_value(idev, chan, val, val2, mask);
+		break;
+	case IIO_CHAN_INFO_SCALE:
+		switch (chan->type) {
+		case IIO_TEMP:
+			*val = 1;
+			*val2 = 8;
+			ret = IIO_VAL_FRACTIONAL;
+			break;
+		case IIO_VOLTAGE:
+			*val = 1;
+			*val2 = 1;
+			ret = IIO_VAL_FRACTIONAL;
+			break;
+		default:
+			ret = -EINVAL;
+			break;
+		};
+		break;
+	default:
+		ret = -EINVAL;
+		break;
+	};
+
+	return ret;
+}
+
+static int max1027_update_scan_mode(struct iio_dev *idev,
+				    const unsigned long *scan_mask)
+{
+	pr_debug("%s(idev=0x%p, scan_mask=0x%p)\n",
+		__func__, idev, scan_mask);
+	return 0;
+}
+
+static int max1027_debugfs_reg_access(struct iio_dev *idev,
+				  unsigned reg, unsigned writeval,
+				  unsigned *readval)
+{
+	struct max1027_state *st = iio_priv(idev);
+
+	pr_debug("%s(idev=0x%p, reg=%u, writeval=0x%x, readval=0x%p)\n",
+			__func__, idev, reg, writeval, readval);
+
+	if (readval != NULL)
+		return -EINVAL;
+
+	return max1027_write_register(st, writeval);
+}
+
+static int max1027_set_trigger_state(struct iio_trigger *trig, bool state)
+{
+	struct iio_dev *idev = iio_trigger_get_drvdata(trig);
+	struct max1027_state *st = iio_priv(idev);
+	int ret;
+
+	if (state) {
+		st->buffer = kmalloc(idev->scan_bytes, GFP_KERNEL);
+		if (st->buffer == NULL)
+			return -ENOMEM;
+
+		/*
+		 * Disable averaging
+		 * b7-b5 = 1 : averaging register
+		 *    b4 = 0 : disable averaging
+		 * b3-b2 = 0 : not used (averaging is disable)
+		 * b1-b0 = 0 : not used (scan mode = 00)
+		 */
+		ret = max1027_write_register(st, 0x20);
+		if (ret < 0)
+			return ret;
+
+		/*
+		 * Start acquisition on cnvst falling edge
+		 * b7-b6 = 1 : setup register
+		 * b5-b4 = 0 : clock mode (internal clock, start on cnvst)
+		 * b3-b2 = 2 : reference mode (no wake-up delay)
+		 * b1-b0 = 0 : no unipolar/bipolar configuration
+		 */
+		ret = max1027_write_register(st, 0x48);
+		if (ret < 0)
+			return ret;
+
+		/*
+		 * we scan all the channel (0 to max)
+		 * b7    = 1 : conversion register
+		 * b6-b3 = 0 : channel
+		 * b2-b1 = 1 : scan N to max channel
+		 * b0    = 1 : temp
+		 */
+		ret = max1027_write_register(st, 0x83);
+		if (ret < 0)
+			return ret;
+	} else {
+		kfree(st->buffer);
+
+		/*
+		 * Disable averaging
+		 * b7-b5 = 1 : averaging register
+		 *    b4 = 0 : disable averaging
+		 * b3-b2 = 0 : not used (averaging is disable)
+		 * b1-b0 = 0 : not used (scan mode = 00)
+		 */
+		ret = max1027_write_register(st, 0x20);
+		if (ret < 0)
+			return ret;
+
+		/*
+		 * Start acquisition on conversion register write
+		 * b7-b6 = 1 : setup register
+		 * b5-b4 = 2 : clock mode (internal clock, start on conv write)
+		 * b3-b2 = 2 : reference mode (no wake-up delay)
+		 * b1-b0 = 0 : no unipolar/bipolar configuration
+		 */
+		ret = max1027_write_register(st, 0x68);
+		if (ret < 0)
+			return ret;
+	}
+
+	return 0;
+}
+
+static int max1027_try_reenable(struct iio_trigger *trig)
+{
+	pr_debug("%s(trig=0x%p)\n", __func__, trig);
+	return 0;
+}
+
+static int max1027_validate_device(struct iio_trigger *trig,
+				   struct iio_dev *idev)
+{
+	pr_debug("%s(trig=0x%p, idev=0x%p)\n", __func__, trig, idev);
+	return 0;
+}
+
+static irqreturn_t max1027_interrupt_handler(int irq, void *private)
+{
+	struct iio_dev *idev = (struct iio_dev *)private;
+
+	pr_debug("%s(irq=%d, private=0x%p)\n", __func__, irq, private);
+
+	if (iio_buffer_enabled(idev))
+		iio_trigger_poll(idev->trig, iio_get_time_ns());
+
+	return IRQ_HANDLED;
+}
+
+static irqreturn_t max1027_trigger_handler(int irq, void *private)
+{
+	struct iio_poll_func *pf = (struct iio_poll_func *)private;
+	struct iio_dev *idev = pf->indio_dev;
+	struct max1027_state *st = iio_priv(idev);
+	int i, n = 0;
+
+	pr_debug("%s(irq=%d, private=0x%p)\n", __func__, irq, private);
+	pr_debug("%s: scan_bytes           = %d\n",
+			__func__, idev->scan_bytes);
+	pr_debug("%s: scan_index_timestamp = %d\n",
+			__func__, idev->scan_index_timestamp);
+	pr_debug("%s: masklength           = %d\n",
+			__func__, idev->masklength);
+
+	/* fill buffer with selected channel */
+	for (i = 0; i < idev->masklength; i++) {
+		max1027_read_value(st, 2);
+		if (test_bit(i, idev->active_scan_mask)) {
+			st->buffer[n] = st->data.sample[0];
+			n++;
+		}
+	}
+
+	iio_push_to_buffers_with_timestamp(idev, st->buffer, iio_get_time_ns());
+
+	iio_trigger_notify_done(idev->trig);
+
+	return IRQ_HANDLED;
+}
+
+static const struct iio_trigger_ops max1027_trigger_ops = {
+	.owner = THIS_MODULE,
+	.set_trigger_state = &max1027_set_trigger_state,
+	.try_reenable = &max1027_try_reenable,
+	.validate_device = &max1027_validate_device
+};
+
+static const struct iio_info max1027_info = {
+	.driver_module = THIS_MODULE,
+	.read_raw = &max1027_read_raw,
+	.update_scan_mode = &max1027_update_scan_mode,
+	.debugfs_reg_access = &max1027_debugfs_reg_access,
+};
+
+static int max1027_probe(struct spi_device *spi)
+{
+	int err;
+	struct iio_dev *idev;
+	struct max1027_state *st;
+
+	pr_debug("%s: probe(spi = 0x%p)\n", __func__, spi);
+
+	/* allocate iio device */
+	idev = devm_iio_device_alloc(&spi->dev, sizeof(struct max1027_state));
+	if (!idev) {
+		pr_err("can't allocate iio device\n");
+		return -ENOMEM;
+	}
+
+	spi_set_drvdata(spi, idev);
+
+	st = iio_priv(idev);
+	st->spi = spi;
+	st->buffer = NULL;
+	st->info = &max1027_chip_info[spi_get_device_id(spi)->driver_data];
+
+	/* get the eoc gpio */
+	st->gpio_eoc = of_get_gpio_flags(spi->dev.of_node, 0, NULL);
+	if (st->gpio_eoc < 0) {
+		dev_err(&idev->dev, "cant get gpio eoc\n");
+		goto fail_gpio_get;
+	}
+
+	/* request gpio */
+	err = devm_gpio_request_one(&spi->dev, st->gpio_eoc,
+					GPIOF_IN, "max1027-eoc");
+	if (err) {
+		dev_err(&idev->dev, "cant request gpio eoc\n");
+		goto fail_gpio_request;
+	}
+
+	spi->irq = gpio_to_irq(st->gpio_eoc);
+
+	/* request irq */
+	err = devm_request_threaded_irq(&spi->dev, spi->irq,
+					max1027_interrupt_handler,
+					NULL,
+					IRQF_TRIGGER_FALLING,
+					spi->dev.driver->name, idev);
+	if (err) {
+		dev_err(&idev->dev, "Failed to allocate IRQ.\n");
+		goto fail_req_irq;
+	}
+
+	/* initialiaze spi message */
+	st->write_xfer.tx_buf = &st->data.sample[0];
+	st->write_xfer.len    = 1;
+	spi_message_init(&st->write_msg);
+	spi_message_add_tail(&st->write_xfer, &st->write_msg);
+
+	st->read_xfer.rx_buf = &st->data.sample[0];
+	st->read_xfer.len    = 4;
+	spi_message_init(&st->read_msg);
+	spi_message_add_tail(&st->read_xfer, &st->read_msg);
+
+	idev->name = spi_get_device_id(spi)->name;
+	idev->dev.parent = &spi->dev;
+	idev->info = &max1027_info;
+	idev->modes = INDIO_DIRECT_MODE;
+	idev->channels = st->info->channels;
+	idev->num_channels = st->info->num_channels;
+
+	/* Allocate buffer */
+	err = iio_triggered_buffer_setup(idev, &iio_pollfunc_store_time,
+					 &max1027_trigger_handler, NULL);
+	if (err < 0) {
+		dev_err(&idev->dev, "Failed to setup buffer\n");
+		goto fail_buffer_setup;
+	}
+
+	/* Allocate trigger */
+	st->trig = devm_iio_trigger_alloc(&spi->dev, "%s-trigger",
+							idev->name);
+	if (st->trig == NULL) {
+		err = -ENOMEM;
+		dev_err(&idev->dev, "Failed to allocate iio trigger\n");
+		goto fail_trigger_alloc;
+	}
+
+	/* configure and register trigger */
+	st->trig->ops = &max1027_trigger_ops;
+	st->trig->dev.parent = &spi->dev;
+	iio_trigger_set_drvdata(st->trig, idev);
+	iio_trigger_register(st->trig);
+
+	err = iio_device_register(idev);
+	if (err < 0) {
+		dev_err(&idev->dev, "Failed to register iio device\n");
+		goto fail_dev_register;
+	}
+
+	/*
+	 * Disable averaging
+	 * b7-b5 = 1 : averaging register
+	 *    b4 = 0 : disable averaging
+	 * b3-b2 = 0 : not used (averaging is disable)
+	 * b1-b0 = 0 : not used (scan mode = 00)
+	 */
+	err = max1027_write_register(st, 0x20);
+	if (err < 0) {
+		dev_err(&idev->dev, "Failed to configure averaging register\n");
+		goto fail_dev_register;
+	}
+
+	/*
+	 * Start acquisition on conversion register write
+	 * b7-b6 = 1 : setup register
+	 * b5-b4 = 2 : clock mode (internal clock, start on conv write)
+	 * b3-b2 = 2 : reference mode (no wake-up delay)
+	 * b1-b0 = 0 : no unipolar/bipolar configuration
+	 */
+	err = max1027_write_register(st, 0x68);
+	if (err < 0) {
+		dev_err(&idev->dev, "Failed to configure setup register\n");
+		goto fail_dev_register;
+	}
+
+	return 0;
+
+fail_dev_register:
+	devm_iio_trigger_free(&idev->dev, st->trig);
+fail_trigger_alloc:
+	iio_triggered_buffer_cleanup(idev);
+fail_buffer_setup:
+	devm_free_irq(&idev->dev, spi->irq, idev);
+fail_req_irq:
+	devm_gpio_free(&idev->dev, st->gpio_eoc);
+fail_gpio_get:
+fail_gpio_request:
+	devm_iio_device_free(&spi->dev, idev);
+
+	return err;
+}
+
+static int max1027_remove(struct spi_device *spi)
+{
+	struct iio_dev *idev = spi_get_drvdata(spi);
+	struct max1027_state *st = iio_priv(idev);
+
+	pr_debug("%s: remove(spi = 0x%p)\n", __func__, spi);
+
+	iio_device_register(idev);
+	devm_iio_trigger_free(&idev->dev, st->trig);
+	iio_triggered_buffer_cleanup(idev);
+	devm_free_irq(&idev->dev, spi->irq, idev);
+	devm_gpio_free(&idev->dev, st->gpio_eoc);
+	devm_iio_device_free(&spi->dev, idev);
+
+	return 0;
+}
+
+static struct spi_driver max1027_driver = {
+	.driver = {
+		.name	= "max1027",
+		.owner	= THIS_MODULE,
+	},
+	.probe		= max1027_probe,
+	.remove		= max1027_remove,
+	.id_table	= max1027_id,
+};
+module_spi_driver(max1027_driver);
+
+MODULE_AUTHOR("Philippe Reynes <tremyfr@yahoo.fr>");
+MODULE_DESCRIPTION("MAX1027/MAX1029/MAX1031 ADC");
+MODULE_LICENSE("GPL v2");
-- 
1.7.4.4

