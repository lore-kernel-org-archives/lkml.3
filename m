Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752588AbaHTLUy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 07:20:54 -0400
Received: from mga14.intel.com ([192.55.52.115]:5069 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751731AbaHTLUu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 07:20:50 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="374704836"
From: Daniel Baluta <daniel.baluta@intel.com>
To: gregkh@linuxfoundation.org, linux-usb@vger.kernel.org, wsa@the-dreams.de,
        linux-i2c@vger.kernel.org, linus.walleij@linaro.org, gnurou@gmail.com,
        linux-gpio@vger.kernel.org
Cc: pratyush.anand@st.com, pebolle@tiscali.nl, stern@rowland.harvard.edu,
        octavian.purdila@intel.com, matthew@mjdsystems.ca,
        linux-kernel@vger.kernel.org, laurentiu.palcu@intel.com,
        daniel.baluta@intel.com, jdelvare@suse.de, arnd@arndb.de,
        sjg@chromium.org
Subject: [PATCH 3/3] gpio: add support for the Diolan DLN-2 USB-GPIO driver
Date: Wed, 20 Aug 2014 14:24:47 +0300
Message-Id: <1408533887-22727-4-git-send-email-daniel.baluta@intel.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1408533887-22727-1-git-send-email-daniel.baluta@intel.com>
References: <1408533887-22727-1-git-send-email-daniel.baluta@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds GPIO and IRQ support for the Diolan DLN-2 GPIO module.

Information about the USB protocol interface can be found in the
Programmer's Reference Manual [1], see section 2.9 for the GPIO
module commands and responses.

[1] https://www.diolan.com/downloads/dln-api-manual.pdf

Signed-off-by: Daniel Baluta <daniel.baluta@intel.com>
---
 drivers/gpio/Kconfig     |  13 ++
 drivers/gpio/Makefile    |   1 +
 drivers/gpio/gpio-dln2.c | 571 +++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 585 insertions(+)
 create mode 100644 drivers/gpio/gpio-dln2.c

diff --git a/drivers/gpio/Kconfig b/drivers/gpio/Kconfig
index 9de1515..1da9857 100644
--- a/drivers/gpio/Kconfig
+++ b/drivers/gpio/Kconfig
@@ -897,4 +897,17 @@ config GPIO_VIPERBOARD
           River Tech's viperboard.h for detailed meaning
           of the module parameters.
 
+config GPIO_DLN2
+	tristate "Diolan DLN2 GPIO support"
+	depends on USB
+	select USB_DLN2
+	select IRQ_DOMAIN
+
+	help
+	  Select this option to enable GPIO driver for the Diolan DLN2
+	  board.
+
+	  This driver can also be built as a module. If so, the module
+	  will be called gpio-dln2.
+
 endif
diff --git a/drivers/gpio/Makefile b/drivers/gpio/Makefile
index 5d024e3..eaa97a0 100644
--- a/drivers/gpio/Makefile
+++ b/drivers/gpio/Makefile
@@ -26,6 +26,7 @@ obj-$(CONFIG_GPIO_CRYSTAL_COVE)	+= gpio-crystalcove.o
 obj-$(CONFIG_GPIO_DA9052)	+= gpio-da9052.o
 obj-$(CONFIG_GPIO_DA9055)	+= gpio-da9055.o
 obj-$(CONFIG_GPIO_DAVINCI)	+= gpio-davinci.o
+obj-$(CONFIG_GPIO_DLN2)		+= gpio-dln2.o
 obj-$(CONFIG_GPIO_DWAPB)	+= gpio-dwapb.o
 obj-$(CONFIG_GPIO_EM)		+= gpio-em.o
 obj-$(CONFIG_GPIO_EP93XX)	+= gpio-ep93xx.o
diff --git a/drivers/gpio/gpio-dln2.c b/drivers/gpio/gpio-dln2.c
new file mode 100644
index 0000000..20d2e07
--- /dev/null
+++ b/drivers/gpio/gpio-dln2.c
@@ -0,0 +1,571 @@
+/*
+ * Driver for the Diolan DLN-2 USB-GPIO adapter
+ *
+ * Copyright (c) 2014 Intel Corporation
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation, version 2.
+ */
+
+#include <linux/kernel.h>
+#include <linux/errno.h>
+#include <linux/module.h>
+#include <linux/slab.h>
+#include <linux/types.h>
+#include <linux/mutex.h>
+#include <linux/irqdomain.h>
+#include <linux/irq.h>
+#include <linux/irqchip/chained_irq.h>
+#include <linux/usb.h>
+#include <linux/gpio.h>
+#include <linux/gpio/driver.h>
+#include <linux/ptrace.h>
+#include <linux/wait.h>
+#include <linux/usb/dln2.h>
+
+#define DRIVER_NAME "gpio-dln2"
+
+#define DLN2_GPIO_ID			0x01
+
+#define CMD_GPIO_GET_PORT_COUNT		DLN2_CMD(0x00, DLN2_GPIO_ID)
+#define CMD_GPIO_GET_PIN_COUNT		DLN2_CMD(0x01, DLN2_GPIO_ID)
+#define CMD_GPIO_SET_DEBOUNCE		DLN2_CMD(0x04, DLN2_GPIO_ID)
+#define CMD_GPIO_GET_DEBOUNCE		DLN2_CMD(0x05, DLN2_GPIO_ID)
+#define CMD_GPIO_PORT_GET_VAL		DLN2_CMD(0x06, DLN2_GPIO_ID)
+#define CMD_GPIO_PIN_GET_VAL		DLN2_CMD(0x0B, DLN2_GPIO_ID)
+#define CMD_GPIO_PIN_SET_OUT_VAL	DLN2_CMD(0x0C, DLN2_GPIO_ID)
+#define CMD_GPIO_PIN_GET_OUT_VAL	DLN2_CMD(0x0D, DLN2_GPIO_ID)
+#define CMD_GPIO_CONDITION_MET_EV	DLN2_CMD(0x0F, DLN2_GPIO_ID)
+#define CMD_GPIO_PIN_ENABLE		DLN2_CMD(0x10, DLN2_GPIO_ID)
+#define CMD_GPIO_PIN_DISABLE		DLN2_CMD(0x11, DLN2_GPIO_ID)
+#define CMD_GPIO_PIN_SET_DIRECTION	DLN2_CMD(0x13, DLN2_GPIO_ID)
+#define CMD_GPIO_PIN_GET_DIRECTION	DLN2_CMD(0x14, DLN2_GPIO_ID)
+#define CMD_GPIO_PIN_SET_EVENT_CFG	DLN2_CMD(0x1E, DLN2_GPIO_ID)
+#define CMD_GPIO_PIN_GET_EVENT_CFG	DLN2_CMD(0x1F, DLN2_GPIO_ID)
+
+#define DLN2_GPIO_EVENT_NONE		0
+#define DLN2_GPIO_EVENT_CHANGE		1
+#define DLN2_GPIO_EVENT_LVL_HIGH	2
+#define DLN2_GPIO_EVENT_LVL_LOW		3
+#define DLN2_GPIO_EVENT_CHANGE_RISING	0x11
+#define DLN2_GPIO_EVENT_CHANGE_FALLING  0x21
+#define DLN2_GPIO_EVENT_MASK		0x0F
+
+struct dln2_mod *dln2_gpio_mod, *dln2_irq_mod;
+
+#define DLN2_GPIO_MAX_PINS 32
+
+struct dln2_irq_work {
+	struct work_struct work;
+	struct dln2_gpio *dev;
+	int pin, type;
+};
+
+struct dln2_gpio {
+	struct dln2_dev *dln2;
+
+	struct gpio_chip gpio;
+
+	struct irq_domain *irq_domain;
+	DECLARE_BITMAP(irqs_masked, DLN2_GPIO_MAX_PINS);
+	DECLARE_BITMAP(irqs_enabled, DLN2_GPIO_MAX_PINS);
+	DECLARE_BITMAP(irqs_pending, DLN2_GPIO_MAX_PINS);
+	struct dln2_irq_work irq_work[DLN2_GPIO_MAX_PINS];
+};
+
+struct dln2_gpio_pin {
+	__le16 pin;
+} __packed;
+
+struct dln2_gpio_pin_val {
+	__le16 pin;
+	u8 value;
+} __packed;
+
+int dln2_gpio_get_pin_count(struct dln2_dev *dln2)
+{
+	__le16 count;
+	int ret, len = sizeof(count);
+
+	ret = dln2_transfer(dln2, dln2_gpio_mod, CMD_GPIO_GET_PIN_COUNT,
+			    NULL, 0, &count, &len);
+	if (ret < 0)
+		return ret;
+
+	return le16_to_cpu(count);
+}
+
+static int dln2_gpio_pin_cmd(struct dln2_dev *dln2, int cmd, unsigned pin)
+{
+	struct dln2_gpio_pin req = {
+		.pin = cpu_to_le16(pin),
+	};
+
+	return dln2_transfer(dln2, dln2_gpio_mod, cmd, &req, sizeof(req),
+			     NULL, NULL);
+}
+
+
+static int dln2_gpio_pin_val(struct dln2_gpio *dev, int cmd, unsigned int pin)
+{
+	struct dln2_gpio_pin req = {
+		.pin = cpu_to_le16(pin),
+	};
+	struct dln2_gpio_pin_val rsp;
+	int ret, len = sizeof(rsp);
+
+	ret = dln2_transfer(dev->dln2, dln2_gpio_mod, cmd, &req, sizeof(req),
+			    &rsp, &len);
+	if (ret < 0)
+		return ret;
+
+	if (req.pin != rsp.pin) {
+		dev_err(dev->gpio.dev, "bad pin response: %d %d\n",
+			pin, le16_to_cpu(rsp.pin));
+		return -EPROTO;
+	}
+
+	return rsp.value;
+}
+
+static int dln2_gpio_pin_get_in_val(struct dln2_gpio *dev, unsigned int pin)
+{
+	int ret = dln2_gpio_pin_val(dev, CMD_GPIO_PIN_GET_VAL, pin);
+
+	if (ret < 0)
+		return ret;
+	return !!ret;
+}
+
+static int dln2_gpio_pin_get_out_val(struct dln2_gpio *dev, unsigned int pin)
+{
+	int ret = dln2_gpio_pin_val(dev, CMD_GPIO_PIN_GET_OUT_VAL, pin);
+
+	if (ret < 0)
+		return ret;
+	return !!ret;
+}
+
+static void dln2_gpio_pin_set_out_val(struct dln2_dev *dln2, unsigned int pin,
+				      int value)
+{
+	struct dln2_gpio_pin_val req = {
+		.pin = cpu_to_le16(pin),
+		.value = cpu_to_le16(value),
+	};
+
+	dln2_transfer(dln2, dln2_gpio_mod, CMD_GPIO_PIN_SET_OUT_VAL,
+		      &req, sizeof(req), NULL, NULL);
+}
+
+static int dln2_gpio_request(struct gpio_chip *chip, unsigned offset)
+{
+	struct dln2_gpio *dev = container_of(chip, struct dln2_gpio, gpio);
+
+	return dln2_gpio_pin_cmd(dev->dln2, CMD_GPIO_PIN_ENABLE, offset);
+}
+
+static void dln2_gpio_free(struct gpio_chip *chip, unsigned offset)
+{
+	struct dln2_gpio *dev = container_of(chip, struct dln2_gpio, gpio);
+
+	dln2_gpio_pin_cmd(dev->dln2, CMD_GPIO_PIN_DISABLE, offset);
+}
+
+static int dln2_gpio_get_direction(struct gpio_chip *chip, unsigned offset)
+{
+	struct dln2_gpio *dev = container_of(chip, struct dln2_gpio, gpio);
+	struct dln2_gpio_pin req = {
+		.pin = cpu_to_le16(offset),
+	};
+	struct dln2_gpio_pin_val rsp;
+	int ret, len = sizeof(rsp);
+
+	ret = dln2_transfer(dev->dln2, dln2_gpio_mod,
+			    CMD_GPIO_PIN_GET_DIRECTION,
+			    &req, sizeof(req), &rsp, &len);
+	if (ret < 0)
+		return ret;
+
+	if (req.pin != rsp.pin) {
+		dev_err(dev->gpio.dev, "bad pin response: %d %d\n",
+			offset, le16_to_cpu(rsp.pin));
+		return -EPROTO;
+	}
+
+	/* DLN2 GPIO direction is 0 for input and 1 for output */
+	return !rsp.value;
+}
+
+static int dln2_gpio_get(struct gpio_chip *chip, unsigned int offset)
+{
+	struct dln2_gpio *dev = container_of(chip, struct dln2_gpio, gpio);
+	int dir = dln2_gpio_get_direction(chip, offset);
+
+	if (dir < 0)
+		return dir;
+
+	if (dir)
+		return dln2_gpio_pin_get_in_val(dev, offset);
+	else
+		return dln2_gpio_pin_get_out_val(dev, offset);
+}
+
+static void dln2_gpio_set(struct gpio_chip *chip, unsigned offset, int value)
+{
+	struct dln2_gpio *dev = container_of(chip, struct dln2_gpio, gpio);
+
+	dln2_gpio_pin_set_out_val(dev->dln2, offset, value);
+}
+
+static int dln2_gpio_set_direction(struct gpio_chip *chip, unsigned offset,
+				   unsigned dir)
+{
+	struct dln2_gpio *dev = container_of(chip, struct dln2_gpio, gpio);
+	struct dln2_gpio_pin_val req = {
+		.pin = cpu_to_le16(offset),
+		.value = cpu_to_le16(dir),
+	};
+
+	return dln2_transfer(dev->dln2, dln2_gpio_mod,
+			     CMD_GPIO_PIN_SET_DIRECTION,
+			     &req, sizeof(req), NULL, NULL);
+}
+
+#define DLN2_GPIO_DIRECTION_IN		0
+#define DLN2_GPIO_DIRECTION_OUT		1
+
+static int dln2_gpio_direction_input(struct gpio_chip *chip, unsigned offset)
+{
+	return dln2_gpio_set_direction(chip, offset, DLN2_GPIO_DIRECTION_IN);
+}
+
+static int dln2_gpio_direction_output(struct gpio_chip *chip, unsigned offset,
+				      int value)
+{
+	return dln2_gpio_set_direction(chip, offset, DLN2_GPIO_DIRECTION_OUT);
+}
+
+static int dln2_gpio_set_debounce(struct gpio_chip *chip, unsigned offset,
+				  unsigned debounce)
+{
+	struct dln2_gpio *dev = container_of(chip, struct dln2_gpio, gpio);
+	struct {
+		__le32 duration;
+	} __packed req = {
+		.duration = cpu_to_le32(debounce),
+	};
+
+	return dln2_transfer(dev->dln2, dln2_gpio_mod, CMD_GPIO_SET_DEBOUNCE,
+			     &req, sizeof(req), NULL, NULL);
+}
+
+static int dln2_gpio_set_event_cfg(struct dln2_dev *dln2, unsigned pin,
+				   unsigned type, unsigned period)
+{
+	struct {
+		__le16 pin;
+		u8 type;
+		__le16 period;
+	} __packed req = {
+		.pin = cpu_to_le16(pin),
+		.type = type,
+		.period = cpu_to_le16(period),
+	};
+
+	return dln2_transfer(dln2, dln2_gpio_mod, CMD_GPIO_PIN_SET_EVENT_CFG,
+			     &req, sizeof(req), NULL, NULL);
+}
+
+static int dln2_gpio_to_irq(struct gpio_chip *chip, unsigned offset)
+{
+	struct dln2_gpio *dev = container_of(chip, struct dln2_gpio, gpio);
+
+	return irq_create_mapping(dev->irq_domain, offset);
+}
+
+
+static void dln2_irq_work(struct work_struct *w)
+{
+	struct dln2_irq_work *iw = container_of(w, struct dln2_irq_work, work);
+	struct dln2_gpio *dev = iw->dev;
+	struct dln2_dev *dln2 = dev->dln2;
+	u8 type = iw->type & DLN2_GPIO_EVENT_MASK;
+
+	/* USB device has been disconnected, bail out */
+	if (!dln2)
+		return;
+
+	if (test_bit(iw->pin, dev->irqs_enabled))
+		dln2_gpio_set_event_cfg(dln2, iw->pin, type, 0);
+	else
+		dln2_gpio_set_event_cfg(dln2, iw->pin, DLN2_GPIO_EVENT_NONE, 0);
+}
+
+static void dln2_irq_enable(struct irq_data *irqd)
+{
+	struct dln2_gpio *dev = irq_data_get_irq_chip_data(irqd);
+	int pin = irqd_to_hwirq(irqd);
+
+	set_bit(pin, dev->irqs_enabled);
+	schedule_work(&dev->irq_work[pin].work);
+}
+
+static void dln2_irq_disable(struct irq_data *irqd)
+{
+	struct dln2_gpio *dev = irq_data_get_irq_chip_data(irqd);
+	int pin = irqd_to_hwirq(irqd);
+
+	clear_bit(pin, dev->irqs_enabled);
+	schedule_work(&dev->irq_work[pin].work);
+}
+
+static void dln2_irq_mask(struct irq_data *irqd)
+{
+	struct dln2_gpio *dev = irq_data_get_irq_chip_data(irqd);
+	int pin = irqd_to_hwirq(irqd);
+
+	set_bit(pin, dev->irqs_masked);
+}
+
+static void dln2_irq_unmask(struct irq_data *irqd)
+{
+	struct dln2_gpio *dev = irq_data_get_irq_chip_data(irqd);
+	int pin = irqd_to_hwirq(irqd);
+
+	if (test_and_clear_bit(pin, dev->irqs_masked))
+		generic_handle_irq(pin);
+}
+
+static int dln2_irq_set_type(struct irq_data *irqd, unsigned type)
+{
+	struct dln2_gpio *dev = irq_data_get_irq_chip_data(irqd);
+	int pin = irqd_to_hwirq(irqd);
+
+	switch (type) {
+	case IRQ_TYPE_LEVEL_HIGH:
+		dev->irq_work[pin].type = DLN2_GPIO_EVENT_LVL_HIGH;
+		break;
+	case IRQ_TYPE_LEVEL_LOW:
+		dev->irq_work[pin].type = DLN2_GPIO_EVENT_LVL_LOW;
+		break;
+	case IRQ_TYPE_EDGE_BOTH:
+		dev->irq_work[pin].type = DLN2_GPIO_EVENT_CHANGE;
+		break;
+	case IRQ_TYPE_EDGE_RISING:
+		dev->irq_work[pin].type = DLN2_GPIO_EVENT_CHANGE_RISING;
+		break;
+	case IRQ_TYPE_EDGE_FALLING:
+		dev->irq_work[pin].type = DLN2_GPIO_EVENT_CHANGE_FALLING;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static struct irq_chip dln2_gpio_irqchip = {
+	.name = "dln2-irq",
+	.irq_enable = dln2_irq_enable,
+	.irq_disable = dln2_irq_disable,
+	.irq_mask = dln2_irq_mask,
+	.irq_unmask = dln2_irq_unmask,
+	.irq_set_type = dln2_irq_set_type,
+};
+
+static int dln2_gpio_irq_map(struct irq_domain *irqd, unsigned int irq,
+			     irq_hw_number_t hwirq)
+{
+	irq_set_chip_data(irq, irqd->host_data);
+	irq_set_chip_and_handler(irq, &dln2_gpio_irqchip, handle_simple_irq);
+	irq_set_noprobe(irq);
+
+	return 0;
+}
+
+static const struct irq_domain_ops dln2_domain_irq_ops = {
+	.map = dln2_gpio_irq_map,
+	.xlate = irq_domain_xlate_twocell,
+};
+
+
+static int dln2_gpio_connect(struct dln2_dev *dln2)
+{
+	struct dln2_gpio *dev;
+	struct device *d = dln2_get_device(dln2);
+	int pins = dln2_gpio_get_pin_count(dln2), i, ret;
+
+	if (pins < 0) {
+		dev_err(d, "failed to get pin count: %d\n", pins);
+		return pins;
+	}
+	if (pins > DLN2_GPIO_MAX_PINS)
+		dev_warn(d, "clamping pins to %d\n", DLN2_GPIO_MAX_PINS);
+
+	dev = kzalloc(sizeof(*dev), GFP_KERNEL);
+	if (!dev) {
+		dev_err(d, "fail to allocate for device state\n");
+		return -ENOMEM;
+	}
+
+	for (i = 0; i < DLN2_GPIO_MAX_PINS; i++) {
+		INIT_WORK(&dev->irq_work[i].work, dln2_irq_work);
+		dev->irq_work[i].pin = i;
+		dev->irq_work[i].dev = dev;
+	}
+
+	dev->irq_domain = irq_domain_add_simple(NULL, pins, 0,
+						&dln2_domain_irq_ops, dev);
+	if (!dev->irq_domain) {
+		kfree(dev);
+		return -ENOMEM;
+	}
+
+	dev->dln2 = dln2;
+
+	dev->gpio.label = "dln2";
+	dev->gpio.dev = d;
+	dev->gpio.owner = THIS_MODULE;
+	dev->gpio.base = -1;
+	dev->gpio.ngpio = pins;
+	dev->gpio.exported = 1;
+
+	dev->gpio.set = dln2_gpio_set;
+	dev->gpio.get = dln2_gpio_get;
+	dev->gpio.request = dln2_gpio_request;
+	dev->gpio.free = dln2_gpio_free;
+	dev->gpio.get_direction = dln2_gpio_get_direction;
+	dev->gpio.direction_input = dln2_gpio_direction_input;
+	dev->gpio.direction_output = dln2_gpio_direction_output;
+	dev->gpio.set_debounce = dln2_gpio_set_debounce;
+
+	dev->gpio.to_irq = dln2_gpio_to_irq;
+
+	dln2_set_dev_context(dln2, dln2_gpio_mod, dev);
+
+	ret = gpiochip_add(&dev->gpio);
+	if (ret < 0) {
+		irq_domain_remove(dev->irq_domain);
+		kfree(dev);
+		dev_err(dev->gpio.dev, "error adding gpio chip: %d\n", ret);
+		return ret;
+	}
+
+	dev_dbg(dev->gpio.dev, "connected " DRIVER_NAME "\n");
+	return 0;
+}
+
+static void dln2_gpio_disconnect(struct dln2_dev *dln2)
+{
+	struct dln2_gpio *dev = dln2_get_dev_context(dln2, dln2_gpio_mod);
+	int ret;
+
+	irq_domain_remove(dev->irq_domain);
+	ret = gpiochip_remove(&dev->gpio);
+	if (ret < 0) {
+		dev_warn(dev->gpio.dev, "error removing gpio chip: %d\n", ret);
+		dev->dln2 = NULL;
+		return;
+	}
+
+	kfree(dev);
+
+	dev_dbg(dev->gpio.dev, "disconnected " DRIVER_NAME "\n");
+}
+
+static struct dln2_mod_ops dln2_gpio_ops = {
+	.name = DRIVER_NAME,
+	.connect = dln2_gpio_connect,
+	.disconnect = dln2_gpio_disconnect,
+};
+
+static void dln2_gpio_event(struct dln2_dev *dln2, struct urb *urb,
+			    struct dln2_response *rsp, void *data, int len)
+{
+	struct dln2_gpio *dev = dln2_get_dev_context(dln2, dln2_gpio_mod);
+	struct {
+		__le16 count;
+		__u8 type;
+		__le16 pin;
+		__u8 value;
+	} __packed *event = data;
+	int pin, irq, id = le16_to_cpu(rsp->hdr.id);
+
+	if (id != CMD_GPIO_CONDITION_MET_EV) {
+		dev_err(dev->gpio.dev, "unexpected cmd %x\n", id);
+		goto out_complete;
+	}
+
+	pin = le16_to_cpu(event->pin);
+	irq = irq_find_mapping(dev->irq_domain, pin);
+
+	if (!irq) {
+		dev_err(dev->gpio.dev, "pin %d not mapped to IRQ\n", pin);
+		goto out_complete;
+	}
+
+	if (!test_bit(pin, dev->irqs_enabled) ||
+	    test_bit(pin, dev->irqs_masked))
+		goto out_complete;
+
+	switch (dev->irq_work[pin].type) {
+	case DLN2_GPIO_EVENT_CHANGE_RISING:
+		if (event->value)
+			generic_handle_irq(irq);
+		break;
+	case DLN2_GPIO_EVENT_CHANGE_FALLING:
+		if (!event->value)
+			generic_handle_irq(irq);
+		break;
+	default:
+		generic_handle_irq(irq);
+	}
+
+out_complete:
+	usb_submit_urb(urb, GFP_ATOMIC);
+}
+
+static struct dln2_mod_ops dln2_irq_ops = {
+	.name = "irq-" DRIVER_NAME,
+	.receive = dln2_gpio_event,
+};
+
+static int __init dln2_gpio_init(void)
+{
+	int err;
+
+	dln2_gpio_mod = dln2_register_module(-1, &dln2_gpio_ops);
+
+	if (IS_ERR(dln2_gpio_mod)) {
+		err = PTR_ERR(dln2_gpio_mod);
+		dln2_gpio_mod = NULL;
+		pr_err(DRIVER_NAME "dln2_register_module failed: %d\n", err);
+		return err;
+	}
+
+	dln2_irq_mod = dln2_register_module(0, &dln2_irq_ops);
+	if (IS_ERR(dln2_irq_mod)) {
+		err = PTR_ERR(dln2_irq_mod);
+		dln2_irq_mod = NULL;
+		dln2_unregister_module(dln2_gpio_mod);
+		dln2_gpio_mod = NULL;
+		pr_err(DRIVER_NAME "dln2_register_module failed: %d\n", err);
+		return err;
+	}
+
+	return 0;
+}
+module_init(dln2_gpio_init);
+
+static void __exit dln2_gpio_exit(void)
+{
+	if (dln2_gpio_mod)
+		dln2_unregister_module(dln2_gpio_mod);
+}
+module_exit(dln2_gpio_exit);
+
+MODULE_AUTHOR("Daniel Baluta <daniel.baluta@intel.com");
+MODULE_DESCRIPTION(DRIVER_NAME "driver");
+MODULE_LICENSE("GPL");
-- 
1.9.1

