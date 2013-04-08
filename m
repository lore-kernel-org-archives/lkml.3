Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935125Ab3DHRSv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 13:18:51 -0400
Received: from mga09.intel.com ([134.134.136.24]:38822 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934523Ab3DHRSB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 13:18:01 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,432,1363158000"; 
   d="scan'208";a="291854091"
From: Kevin Strasser <kevin.strasser@linux.intel.com>
To: linux-kernel@vger.kernel.org
Cc: Michael Brunner <michael.brunner@kontron.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Wolfram Sang <wsa@the-dreams.de>,
        Ben Dooks <ben-linux@fluff.org>, linux-i2c@vger.kernel.org,
        Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@linaro.org>,
        Wim Van Sebroeck <wim@iguana.be>, linux-watchdog@vger.kernel.org,
        Darren Hart <dvhart@linux.intel.com>, Michael Brunner <mibru@gmx.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kevin Strasser <kevin.strasser@linux.intel.com>
Subject: [PATCH 3/4] gpio: Kontron PLD gpio driver
Date: Mon,  8 Apr 2013 10:15:20 -0700
Message-Id: <1365441321-21952-3-git-send-email-kevin.strasser@linux.intel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1365441321-21952-1-git-send-email-kevin.strasser@linux.intel.com>
References: <1365441321-21952-1-git-send-email-kevin.strasser@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michael Brunner <michael.brunner@kontron.com>

Add gpio support for the on-board PLD found on some Kontron embedded
modules.

Signed-off-by: Michael Brunner <michael.brunner@kontron.com>
Signed-off-by: Kevin Strasser <kevin.strasser@linux.intel.com>
---
 drivers/gpio/Kconfig            |   22 ++
 drivers/gpio/Makefile           |    2 +
 drivers/gpio/gpio-kempld.c      |  476 +++++++++++++++++++++++++++++++++++++++
 drivers/gpio/gpio-kempld.h      |   50 ++++
 drivers/gpio/gpio-kempld_now1.c |  280 +++++++++++++++++++++++
 5 files changed, 830 insertions(+)
 create mode 100644 drivers/gpio/gpio-kempld.c
 create mode 100644 drivers/gpio/gpio-kempld.h
 create mode 100644 drivers/gpio/gpio-kempld_now1.c

diff --git a/drivers/gpio/Kconfig b/drivers/gpio/Kconfig
index 93aaadf..88e1bc9 100644
--- a/drivers/gpio/Kconfig
+++ b/drivers/gpio/Kconfig
@@ -658,6 +658,28 @@ config GPIO_UCB1400
 	  This enables support for the Philips UCB1400 GPIO pins.
 	  The UCB1400 is an AC97 audio codec.
 
+comment "LPC GPIO expanders:"
+
+config GPIO_KEMPLD
+	tristate "Kontron COM GPIO"
+	depends on MFD_KEMPLD
+	help
+	  This enables support for the PLD GPIO interface on some Kontron ETX
+	  and COMexpress (ETXexpress) modules.
+
+	  This driver can also be built as a module. If so, the module will
+	  be called gpio-kempld.
+
+config GPIO_NOW1_KEMPLD
+	tristate "Kontron COMe-mSP1 (nanoETXexpress-SP) GPIO"
+	depends on MFD_KEMPLD
+	help
+	  This enables support for the PLD GPIO interface on the Kontron
+	  COMe-mSP1 (nanoETXexpress-SP) module.
+
+	  This driver can also be built as a module. If so, the module will
+	  be called gpio-kempld_now1.
+
 comment "MODULbus GPIO expanders:"
 
 config GPIO_JANZ_TTL
diff --git a/drivers/gpio/Makefile b/drivers/gpio/Makefile
index 22e07bc..59919db 100644
--- a/drivers/gpio/Makefile
+++ b/drivers/gpio/Makefile
@@ -28,6 +28,8 @@ obj-$(CONFIG_GPIO_GE_FPGA)	+= gpio-ge.o
 obj-$(CONFIG_GPIO_ICH)		+= gpio-ich.o
 obj-$(CONFIG_GPIO_IT8761E)	+= gpio-it8761e.o
 obj-$(CONFIG_GPIO_JANZ_TTL)	+= gpio-janz-ttl.o
+obj-$(CONFIG_GPIO_KEMPLD)   += gpio-kempld.o
+obj-$(CONFIG_GPIO_NOW1_KEMPLD) += gpio-kempld_now1.o
 obj-$(CONFIG_ARCH_KS8695)	+= gpio-ks8695.o
 obj-$(CONFIG_GPIO_LANGWELL)	+= gpio-langwell.o
 obj-$(CONFIG_ARCH_LPC32XX)	+= gpio-lpc32xx.o
diff --git a/drivers/gpio/gpio-kempld.c b/drivers/gpio/gpio-kempld.c
new file mode 100644
index 0000000..e18967d
--- /dev/null
+++ b/drivers/gpio/gpio-kempld.c
@@ -0,0 +1,476 @@
+/*
+ *  kempld_gpio.c - Kontron PLD GPIO driver
+ *
+ *  Copyright (c) 2010-2012 Kontron Europe GmbH
+ *  Author: Michael Brunner <michael.brunner@kontron.com>
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License 2 as published
+ *  by the Free Software Foundation.
+ *
+ *  This program is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *  GNU General Public License for more details.
+ *
+ *  You should have received a copy of the GNU General Public License
+ *  along with this program; see the file COPYING.  If not, write to
+ *  the Free Software Foundation, 675 Mass Ave, Cambridge, MA 02139, USA.
+ */
+
+#include <linux/init.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/io.h>
+#include <linux/slab.h>
+#include <linux/errno.h>
+#include <linux/acpi.h>
+#include <linux/platform_device.h>
+#include <linux/gpio.h>
+#include <linux/mfd/kempld.h>
+#include <linux/seq_file.h>
+
+#include "gpio-kempld.h"
+
+static int gpiobase = -1;
+static int gpioien = 0x00;
+static int gpioevt_lvl_edge = -1;
+static int gpioevt_low_high = -1;
+static int gpionmien = 0x00;
+
+static int kempld_gpio_get(struct gpio_chip *chip, unsigned offset)
+{
+	struct kempld_gpio_data *gpio
+		= container_of(chip, struct kempld_gpio_data, chip);
+	struct kempld_device_data *pld = gpio->pld;
+	int status;
+
+	pld = gpio->pld;
+
+	kempld_get_mutex_set_index(pld, KEMPLD_GPIO_LVL_NUM(offset));
+
+	status = kempld_read8(pld, KEMPLD_GPIO_LVL_NUM(offset));
+	status &= KEMPLD_GPIO_MASK(offset);
+
+	kempld_release_mutex(pld);
+
+	return status;
+}
+
+static void kempld_gpio_set(struct gpio_chip *chip, unsigned offset,
+				int value)
+{
+	struct kempld_gpio_data *gpio
+		= container_of(chip, struct kempld_gpio_data, chip);
+	struct kempld_device_data *pld = gpio->pld;
+	int status;
+
+
+	kempld_get_mutex_set_index(pld, KEMPLD_GPIO_LVL_NUM(offset));
+
+	status = kempld_read8(pld, KEMPLD_GPIO_LVL_NUM(offset));
+	if (value)
+		status |= KEMPLD_GPIO_MASK(offset);
+	else
+		status &= ~KEMPLD_GPIO_MASK(offset);
+	kempld_write8(pld, KEMPLD_GPIO_LVL_NUM(offset), status);
+
+	kempld_release_mutex(pld);
+}
+
+static int kempld_gpio_direction_input(struct gpio_chip *chip, unsigned offset)
+{
+	struct kempld_gpio_data *gpio
+		= container_of(chip, struct kempld_gpio_data, chip);
+	struct kempld_device_data *pld = gpio->pld;
+	int status;
+
+	kempld_get_mutex_set_index(pld, KEMPLD_GPIO_DIR_NUM(offset));
+
+	status = kempld_read8(pld, KEMPLD_GPIO_DIR_NUM(offset));
+	status &= ~KEMPLD_GPIO_MASK(offset);
+	kempld_write8(pld, KEMPLD_GPIO_DIR_NUM(offset), status);
+
+	kempld_release_mutex(pld);
+
+
+	return 0;
+}
+
+static int kempld_gpio_direction_output(struct gpio_chip *chip,
+					 unsigned offset, int value)
+{
+	struct kempld_gpio_data *gpio
+		= container_of(chip, struct kempld_gpio_data, chip);
+	struct kempld_device_data *pld = gpio->pld;
+	int status;
+
+	kempld_get_mutex_set_index(pld, KEMPLD_GPIO_LVL_NUM(offset));
+
+	status = kempld_read8(pld, KEMPLD_GPIO_LVL_NUM(offset));
+	if (value)
+		status |= KEMPLD_GPIO_MASK(offset);
+	else
+		status &= ~KEMPLD_GPIO_MASK(offset);
+	kempld_write8(pld, KEMPLD_GPIO_LVL_NUM(offset), status);
+
+	status = kempld_read8(pld, KEMPLD_GPIO_DIR_NUM(offset));
+	status |= KEMPLD_GPIO_MASK(offset);
+	kempld_write8(pld, KEMPLD_GPIO_DIR_NUM(offset), status);
+
+	kempld_release_mutex(pld);
+
+	return 0;
+}
+
+static int kempld_gpio_to_irq(struct gpio_chip *chip, unsigned offset)
+{
+	struct kempld_gpio_data *gpio
+		= container_of(chip, struct kempld_gpio_data, chip);
+	return gpio->irq;
+}
+
+#ifdef CONFIG_DEBUG_FS
+static int kempld_gpio_get_direction(struct gpio_chip *chip, unsigned offset)
+{
+	struct kempld_gpio_data *gpio
+		= container_of(chip, struct kempld_gpio_data, chip);
+	struct kempld_device_data *pld = gpio->pld;
+	int status;
+
+	kempld_get_mutex_set_index(pld, KEMPLD_GPIO_DIR_NUM(offset));
+
+	status = kempld_read8(pld, KEMPLD_GPIO_DIR_NUM(offset));
+	status &= KEMPLD_GPIO_MASK(offset);
+
+	kempld_release_mutex(pld);
+
+
+	return status ? 1 : 0;
+}
+
+static int kempld_gpio_get_ien(struct gpio_chip *chip, unsigned offset)
+{
+	struct kempld_gpio_data *gpio
+		= container_of(chip, struct kempld_gpio_data, chip);
+	struct kempld_device_data *pld = gpio->pld;
+	int status;
+
+	kempld_get_mutex_set_index(pld, KEMPLD_GPIO_IEN_NUM(offset));
+
+	status = kempld_read8(pld, KEMPLD_GPIO_IEN_NUM(offset));
+	status &= KEMPLD_GPIO_MASK(offset);
+
+	kempld_release_mutex(pld);
+
+
+	return status ? 1 : 0;
+}
+
+static int kempld_gpio_get_evt_lvl_edge(struct gpio_chip *chip,
+					unsigned offset)
+{
+	struct kempld_gpio_data *gpio
+		= container_of(chip, struct kempld_gpio_data, chip);
+	struct kempld_device_data *pld = gpio->pld;
+	int status;
+
+	kempld_get_mutex_set_index(pld, KEMPLD_GPIO_EVT_LVL_EDGE_NUM(offset));
+
+	status = kempld_read8(pld, KEMPLD_GPIO_EVT_LVL_EDGE_NUM(offset));
+	status &= KEMPLD_GPIO_MASK(offset);
+
+	kempld_release_mutex(pld);
+
+
+	return status ? 1 : 0;
+}
+
+static int kempld_gpio_get_evt_high_low(struct gpio_chip *chip,
+					unsigned offset)
+{
+	struct kempld_gpio_data *gpio
+		= container_of(chip, struct kempld_gpio_data, chip);
+	struct kempld_device_data *pld = gpio->pld;
+	int status;
+
+	gpio = dev_get_drvdata(chip->dev);
+	pld = gpio->pld;
+
+	kempld_get_mutex_set_index(pld, KEMPLD_GPIO_EVT_LOW_HIGH_NUM(offset));
+
+	status = kempld_read8(pld, KEMPLD_GPIO_EVT_LOW_HIGH_NUM(offset));
+	status &= KEMPLD_GPIO_MASK(offset);
+
+	kempld_release_mutex(pld);
+
+
+	return status ? 1 : 0;
+}
+
+static int kempld_gpio_get_nmien(struct gpio_chip *chip, unsigned offset)
+{
+	struct kempld_gpio_data *gpio
+		= container_of(chip, struct kempld_gpio_data, chip);
+	struct kempld_device_data *pld = gpio->pld;
+	int status;
+
+	gpio = dev_get_drvdata(chip->dev);
+	pld = gpio->pld;
+
+	kempld_get_mutex_set_index(pld, KEMPLD_GPIO_NMIEN_NUM(offset));
+
+	status = kempld_read8(pld, KEMPLD_GPIO_NMIEN_NUM(offset));
+	status &= KEMPLD_GPIO_MASK(offset);
+
+	kempld_release_mutex(pld);
+
+
+	return status ? 1 : 0;
+}
+
+static void kempld_gpio_dbg_show(struct seq_file *s, struct gpio_chip *chip)
+{
+	int i;
+
+	for (i = 0; i < chip->ngpio; i++) {
+		int gpio = i + chip->base;
+
+		seq_printf(s, " gpio-%-3d %s %s", gpio,
+				kempld_gpio_get_direction(chip, i)
+				? "out" : "in",
+				kempld_gpio_get(chip, i)
+				? "hi" : "lo");
+		seq_printf(s, ", event on %s (irq %s, nmi %s)\n",
+				(kempld_gpio_get_evt_lvl_edge(chip, i)
+				? (kempld_gpio_get_evt_high_low(chip, i)
+				? "rising edge" : "falling edge") :
+				(kempld_gpio_get_evt_high_low(chip, i)
+				? "high level" : "low level")),
+				kempld_gpio_get_ien(chip, i)
+				? "enabled" : "disabled",
+				kempld_gpio_get_nmien(chip, i)
+				? "enabled" : "disabled");
+	}
+}
+#else
+#define kempld_gpio_dbg_show NULL
+#endif
+
+static int kempld_gpio_setup_event(struct kempld_gpio_data *gpio)
+{
+	struct kempld_device_data *pld = gpio->pld;
+	struct gpio_chip *chip = &gpio->chip;
+	int irq;
+
+	irq = gpio->irq;
+
+	kempld_get_mutex_set_index(pld, KEMPLD_IRQ_GPIO);
+	irq = kempld_read8(pld, KEMPLD_IRQ_GPIO);
+
+	/* Leave if interrupts are not supported by the GPIO core */
+	if ((irq & 0xf0) == 0xf0)
+		return 0;
+
+	gpio->irq = irq & 0x0f;
+
+	if (gpioien & !gpio->mask) {
+		dev_err(chip->dev, "gpioien parameter is invalid");
+		gpio->irq = 0;
+	}
+
+	if (gpionmien & !gpio->mask) {
+		dev_err(chip->dev, "gpionmien parameter is invalid");
+		gpio->irq = 0;
+	}
+
+	if ((gpioevt_lvl_edge & !gpio->mask) && (gpioevt_lvl_edge != -1)) {
+		dev_err(chip->dev, "gpioevt_lvl_edge parameter is invalid");
+		gpio->irq = 0;
+	}
+
+	if ((gpioevt_low_high & !gpio->mask) && (gpioevt_low_high != -1)) {
+		dev_err(chip->dev, "gpioevt_low_high parameter is invalid");
+		gpio->irq = 0;
+	}
+
+	if (!gpio->irq)
+		return -EIO;
+
+	if (gpioevt_lvl_edge != -1)
+		kempld_write8(pld, KEMPLD_GPIO_EVT_LVL_EDGE, gpioevt_lvl_edge);
+
+	if (gpioevt_low_high != -1)
+		kempld_write8(pld, KEMPLD_GPIO_EVT_LOW_HIGH, gpioevt_low_high);
+
+	kempld_write8(pld, KEMPLD_GPIO_NMIEN, gpionmien);
+	kempld_write8(pld, KEMPLD_GPIO_IEN, gpioien);
+
+	kempld_release_mutex(pld);
+
+	return 0;
+}
+
+
+static int kempld_gpio_detect(struct kempld_gpio_data *gpio)
+{
+	struct kempld_device_data *pld = gpio->pld;
+	struct gpio_chip *chip = &gpio->chip;
+	u16 evt, evt_back;
+	int i;
+
+	kempld_get_mutex_set_index(pld, KEMPLD_GPIO_IEN);
+
+	/* Backup event register as it might be already initialized */
+	evt_back = kempld_read16(pld, KEMPLD_GPIO_EVT_LVL_EDGE);
+
+	/* Disable interrupt enables and set event register to zero */
+	kempld_write16(pld, KEMPLD_GPIO_IEN, 0x0000);
+	kempld_write16(pld, KEMPLD_GPIO_NMIEN, 0x0000);
+	kempld_write16(pld, KEMPLD_GPIO_EVT_LVL_EDGE, 0x0000);
+
+	/* Read back event register */
+	evt = kempld_read16(pld, KEMPLD_GPIO_EVT_LVL_EDGE);
+
+	/* Restore event register */
+	kempld_write16(pld, KEMPLD_GPIO_EVT_LVL_EDGE, evt_back);
+
+	kempld_release_mutex(pld);
+
+	gpio->mask = ~evt;
+
+	/* Now check how many GPIO pins we have */
+	for (i = 0; i < KEMPLD_GPIO_MAX_NUM; i++) {
+		if (evt & 0x1)
+			break;
+		evt >>= 1;
+	}
+
+	chip->ngpio = i;
+
+	return 0;
+}
+
+static int kempld_gpio_probe(struct platform_device *pdev)
+{
+	struct kempld_device_data *pld;
+	struct kempld_gpio_data *gpio;
+	struct gpio_chip *chip;
+	int ret;
+
+	pld = dev_get_drvdata(pdev->dev.parent);
+
+	if (pld->info.spec_major < 2) {
+		dev_err(&pdev->dev,
+			"driver only supports GPIO devices "
+			"compatible to PLD spec. rev. 2.0 or higher\n");
+		ret = -ENXIO;
+		goto err_check_rev;
+	}
+
+	gpio = kzalloc(sizeof(*gpio), GFP_KERNEL);
+	if (gpio == NULL) {
+		dev_err(&pdev->dev, "unable to get memory for device data\n");
+		ret = -ENOMEM;
+		goto err_alloc_dev_data;
+	}
+
+	gpio->pld = pld;
+
+	platform_set_drvdata(pdev, gpio);
+
+	chip = &gpio->chip;
+	chip->label =		"kempld-gpio";
+	chip->owner =		THIS_MODULE;
+	chip->dev =		&pdev->dev;
+	chip->can_sleep =	1;
+	chip->base =		gpiobase;
+	chip->ngpio =		KEMPLD_GPIO_MAX_NUM;
+
+	if (kempld_gpio_detect(gpio))
+		dev_err(&pdev->dev, "GPIO detection failed\n");
+	if (kempld_gpio_setup_event(gpio))
+		dev_err(&pdev->dev, "Initializing events failed\n");
+
+	chip->direction_input =		kempld_gpio_direction_input;
+	chip->direction_output =	kempld_gpio_direction_output;
+	chip->get =			kempld_gpio_get;
+	chip->set =			kempld_gpio_set;
+	chip->dbg_show =		kempld_gpio_dbg_show;
+	if (gpio->irq)
+		chip->to_irq =		kempld_gpio_to_irq;
+
+	ret = gpiochip_add(chip);
+	if (ret) {
+		dev_err(&pdev->dev, "Could not register GPIO chip\n");
+		goto err_gpiochip_add;
+	}
+
+	dev_info(&pdev->dev,
+		 "GPIO functionality initialized with %d IOs mask (0x%04x)\n",
+		 chip->ngpio, gpio->mask);
+
+	return 0;
+
+err_gpiochip_add:
+	kfree(gpio);
+err_alloc_dev_data:
+err_check_rev:
+
+	return ret;
+}
+
+static int kempld_gpio_remove(struct platform_device *pdev)
+{
+	struct kempld_gpio_data *gpio = platform_get_drvdata(pdev);
+	int ret;
+
+	ret = gpiochip_remove(&gpio->chip);
+	if (ret == 0) {
+		kfree(gpio);
+		platform_set_drvdata(pdev, NULL);
+	}
+
+	return ret;
+}
+
+static struct platform_driver kempld_gpio_driver = {
+	.driver = {
+		.name = "kempld-gpio",
+		.owner = THIS_MODULE,
+	},
+	.probe		= kempld_gpio_probe,
+	.remove		= kempld_gpio_remove,
+};
+
+static int __init kempld_gpio_init(void)
+{
+	return platform_driver_register(&kempld_gpio_driver);
+}
+
+static void __exit kempld_gpio_exit(void)
+{
+	platform_driver_unregister(&kempld_gpio_driver);
+}
+
+module_init(kempld_gpio_init);
+module_exit(kempld_gpio_exit);
+
+module_param(gpiobase, int, 0444);
+module_param(gpioien, int, 0444);
+module_param(gpioevt_lvl_edge, int, 0444);
+module_param(gpioevt_low_high, int, 0444);
+module_param(gpionmien, int, 0444);
+
+MODULE_DESCRIPTION("KEM PLD GPIO Driver");
+MODULE_AUTHOR("Michael Brunner <michael.brunner@kontron.com>");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:kempld_gpio");
+MODULE_PARM_DESC(gpiobase, "Set GPIO base (default -1=dynamic)");
+MODULE_PARM_DESC(gpioien, "Set GPIO IEN register (default 0x00)");
+MODULE_PARM_DESC(gpioevt_lvl_edge,
+			"Set GPIO EVT_LVL_EDGE register (default -1=no change)");
+MODULE_PARM_DESC(gpioevt_low_high,
+			"Set GPIO EVT_LOW_HIGH register (default -1=no change)");
+MODULE_PARM_DESC(gpionmien, "Set GPIO NMIEN register (default 0x00)");
+
diff --git a/drivers/gpio/gpio-kempld.h b/drivers/gpio/gpio-kempld.h
new file mode 100644
index 0000000..173932c
--- /dev/null
+++ b/drivers/gpio/gpio-kempld.h
@@ -0,0 +1,50 @@
+/*
+ *  kempld_gpio.h - Kontron PLD GPIO driver definitions
+ *
+ *  Copyright (c) 2010-2012 Kontron Europe GmbH
+ *  Author: Michael Brunner <michael.brunner@kontron.com>
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License 2 as published
+ *  by the Free Software Foundation.
+ *
+ *  This program is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *  GNU General Public License for more details.
+ *
+ *  You should have received a copy of the GNU General Public License
+ *  along with this program; see the file COPYING.  If not, write to
+ *  the Free Software Foundation, 675 Mass Ave, Cambridge, MA 02139, USA.
+ */
+
+#ifndef _KEMPLD_GPIO_H_
+#define _KEMPLD_GPIO_H_
+
+#define KEMPLD_GPIO_MAX_NUM		16
+
+#define KEMPLD_GPIO_MASK(x)		(1<<(x%8))
+
+#define KEMPLD_GPIO_DIR			0x40
+#define KEMPLD_GPIO_DIR_NUM(x)		(0x40+x/8)
+#define KEMPLD_GPIO_LVL			0x42
+#define KEMPLD_GPIO_LVL_NUM(x)		(0x42+x/8)
+#define KEMPLD_GPIO_STS			0x44
+#define KEMPLD_GPIO_STS_NUM(x)		(0x44+x/8)
+#define KEMPLD_GPIO_EVT_LVL_EDGE	0x46
+#define KEMPLD_GPIO_EVT_LVL_EDGE_NUM(x)	(0x46+x/8)
+#define KEMPLD_GPIO_EVT_LOW_HIGH	0x48
+#define KEMPLD_GPIO_EVT_LOW_HIGH_NUM(x)	(0x48+x/8)
+#define KEMPLD_GPIO_IEN			0x4A
+#define KEMPLD_GPIO_IEN_NUM(x)		(0x4A+x/8)
+#define KEMPLD_GPIO_NMIEN		0x4C
+#define KEMPLD_GPIO_NMIEN_NUM(x)	(0x4C+x/8)
+
+struct kempld_gpio_data {
+	struct gpio_chip		chip;
+	int				irq;
+	struct kempld_device_data	*pld;
+	uint16_t			mask;
+};
+
+#endif /* _KEMPLD_GPIO_H_ */
diff --git a/drivers/gpio/gpio-kempld_now1.c b/drivers/gpio/gpio-kempld_now1.c
new file mode 100644
index 0000000..50ebd67
--- /dev/null
+++ b/drivers/gpio/gpio-kempld_now1.c
@@ -0,0 +1,280 @@
+/*
+ *  kempld_now1_gpio.c - Kontron PLD GPIO driver for COMe-mSP1
+ *
+ *  Copyright (c) 2011-2012 Kontron Europe GmbH
+ *  Author: Michael Brunner <michael.brunner@kontron.com>
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License 2 as published
+ *  by the Free Software Foundation.
+ *
+ *  This program is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *  GNU General Public License for more details.
+ *
+ *  You should have received a copy of the GNU General Public License
+ *  along with this program; see the file COPYING.  If not, write to
+ *  the Free Software Foundation, 675 Mass Ave, Cambridge, MA 02139, USA.
+ */
+
+#include <linux/init.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/io.h>
+#include <linux/slab.h>
+#include <linux/errno.h>
+#include <linux/acpi.h>
+#include <linux/platform_device.h>
+#include <linux/gpio.h>
+#include <linux/mfd/kempld.h>
+#include <linux/seq_file.h>
+
+#include "gpio-kempld.h"
+
+#define KEMPLD_NOW1_GPIO_MAX_NUM	8
+
+#define KEMPLD_NOW1_FUNCTION		0x70
+#define		KEMPLD_NOW1_FUNCTION_ALF_SDIO	0x01
+#define		KEMPLD_NOW1_FUNCTION_USBCC	0x02
+#define KEMPLD_NOW1_GPIO_DIR		0xA0
+#define KEMPLD_NOW1_GPIO_LVL		0xA1
+
+static int kempld_now1_gpio_get(struct gpio_chip *chip, unsigned offset)
+{
+	struct kempld_device_data *pld;
+	int status;
+
+	pld = dev_get_drvdata(chip->dev->parent);
+
+	kempld_get_mutex_set_index(pld, KEMPLD_NOW1_GPIO_LVL);
+
+	status = kempld_read8(pld, KEMPLD_NOW1_GPIO_LVL);
+
+	kempld_release_mutex(pld);
+
+	status &= KEMPLD_GPIO_MASK(offset);
+
+	return status ? 1 : 0;
+}
+
+static void kempld_now1_gpio_set(struct gpio_chip *chip, unsigned offset,
+				int value)
+{
+	struct kempld_device_data *pld;
+	int status;
+
+	pld = dev_get_drvdata(chip->dev->parent);
+
+	kempld_get_mutex_set_index(pld, KEMPLD_NOW1_GPIO_LVL);
+
+	status = kempld_read8(pld, KEMPLD_NOW1_GPIO_LVL);
+	if (value)
+		status |= KEMPLD_GPIO_MASK(offset);
+	else
+		status &= ~KEMPLD_GPIO_MASK(offset);
+	kempld_write8(pld, KEMPLD_NOW1_GPIO_LVL, status);
+
+	kempld_release_mutex(pld);
+}
+
+static int kempld_now1_gpio_direction_input(struct gpio_chip *chip,
+						unsigned offset)
+{
+	struct kempld_device_data *pld;
+	int status;
+
+	pld = dev_get_drvdata(chip->dev->parent);
+
+	kempld_get_mutex_set_index(pld, KEMPLD_NOW1_GPIO_DIR);
+
+	status = kempld_read8(pld, KEMPLD_NOW1_GPIO_DIR);
+	status &= ~KEMPLD_GPIO_MASK(offset);
+	kempld_write8(pld, KEMPLD_NOW1_GPIO_DIR, status);
+
+	kempld_release_mutex(pld);
+
+	return 0;
+}
+
+static int kempld_now1_gpio_direction_output(struct gpio_chip *chip,
+					 unsigned offset, int value)
+{
+	struct kempld_device_data *pld;
+	int status;
+
+	pld = dev_get_drvdata(chip->dev->parent);
+
+	kempld_get_mutex_set_index(pld, KEMPLD_NOW1_GPIO_DIR);
+
+	status = kempld_read8(pld, KEMPLD_NOW1_GPIO_LVL);
+	if (value)
+		status |= KEMPLD_GPIO_MASK(offset);
+	else
+		status &= ~KEMPLD_GPIO_MASK(offset);
+	kempld_write8(pld, KEMPLD_NOW1_GPIO_LVL, status);
+
+	status = kempld_read8(pld, KEMPLD_NOW1_GPIO_DIR);
+	status |= KEMPLD_GPIO_MASK(offset);
+	kempld_write8(pld, KEMPLD_NOW1_GPIO_DIR, status);
+
+	kempld_release_mutex(pld);
+
+	return 0;
+}
+
+#ifdef CONFIG_DEBUG_FS
+static int kempld_now1_gpio_get_direction(struct gpio_chip *chip,
+					unsigned offset)
+{
+	struct kempld_device_data *pld;
+	int status;
+
+	pld = dev_get_drvdata(chip->dev->parent);
+
+	kempld_get_mutex_set_index(pld, KEMPLD_NOW1_GPIO_DIR);
+
+	status = kempld_read8(pld, KEMPLD_NOW1_GPIO_DIR);
+
+	kempld_release_mutex(pld);
+
+	status &= KEMPLD_GPIO_MASK(offset);
+
+	return status ? 1 : 0;
+}
+
+static void kempld_now1_gpio_dbg_show(struct seq_file *s,
+				struct gpio_chip *chip)
+{
+	struct kempld_device_data *pld;
+	int function;
+	int i;
+
+	pld = dev_get_drvdata(chip->dev->parent);
+
+	kempld_get_mutex_set_index(pld, KEMPLD_NOW1_FUNCTION);
+
+	function = kempld_read8(pld, KEMPLD_NOW1_FUNCTION);
+
+	kempld_release_mutex(pld);
+
+	for (i = 0; i < chip->ngpio; i++) {
+		int gpio = i + chip->base;
+
+		seq_printf(s, " gpio-%-3d %s %s %s\n", gpio,
+				kempld_now1_gpio_get_direction(chip, i)
+				? "out" : "in",
+				kempld_now1_gpio_get(chip, i)
+				? "hi" : "lo",
+				function & KEMPLD_NOW1_FUNCTION_ALF_SDIO
+				? "sdio" :
+				((function & KEMPLD_NOW1_FUNCTION_USBCC)
+					&& (i == 0))
+				? "usbcc" : "gpio");
+	}
+}
+#else
+#define kempld_now1_gpio_dbg_show NULL
+#endif
+
+static int kempld_now1_gpio_probe(struct platform_device *pdev)
+{
+	struct kempld_device_data *pld;
+	struct gpio_chip *chip;
+	int function;
+	int ret;
+
+	pld = dev_get_drvdata(pdev->dev.parent);
+
+	chip = kzalloc(sizeof(struct gpio_chip), GFP_KERNEL);
+	if (chip == NULL) {
+		dev_err(&pdev->dev, "unable to get memory for device data\n");
+		ret = -ENOMEM;
+		goto err_alloc_dev_data;
+	}
+
+	chip->label =		"kempld_now1-gpio";
+	chip->owner =		THIS_MODULE;
+	chip->can_sleep =	1;
+	chip->dev =		&pdev->dev;
+	chip->base =		-1;
+	chip->ngpio =		KEMPLD_NOW1_GPIO_MAX_NUM;
+
+	chip->direction_input =		kempld_now1_gpio_direction_input;
+	chip->direction_output =	kempld_now1_gpio_direction_output;
+	chip->get =			kempld_now1_gpio_get;
+	chip->set =			kempld_now1_gpio_set;
+	chip->dbg_show =		kempld_now1_gpio_dbg_show;
+
+	kempld_get_mutex_set_index(pld, KEMPLD_NOW1_FUNCTION);
+
+	function = kempld_read8(pld, KEMPLD_NOW1_FUNCTION);
+
+	kempld_release_mutex(pld);
+
+	if (function & KEMPLD_NOW1_FUNCTION_ALF_SDIO)
+		dev_warn(&pdev->dev, "GPIO pins are used for SDIO\n");
+	if (function & KEMPLD_NOW1_FUNCTION_USBCC) {
+		dev_info(&pdev->dev,
+			 "GPI[0] is forwarded to USB cable connect\n");
+	}
+
+	platform_set_drvdata(pdev, chip);
+
+	ret = gpiochip_add(chip);
+	if (ret) {
+		dev_err(&pdev->dev, "Could not register GPIO chip\n");
+		goto err_gpiochip_add;
+	}
+
+	dev_info(&pdev->dev, "GPIO functionality initialized\n");
+
+	return 0;
+
+err_gpiochip_add:
+	kfree(chip);
+err_alloc_dev_data:
+
+	return ret;
+}
+
+static int kempld_now1_gpio_remove(struct platform_device *pdev)
+{
+	struct gpio_chip *chip = platform_get_drvdata(pdev);
+	int ret;
+
+	ret = gpiochip_remove(chip);
+	if (ret == 0) {
+		kfree(chip);
+		platform_set_drvdata(pdev, NULL);
+	}
+
+	return ret;
+}
+
+static struct platform_driver kempld_now1_gpio_driver = {
+	.driver = {
+		.name = "kempld_now1-gpio",
+		.owner = THIS_MODULE,
+	},
+	.probe		= kempld_now1_gpio_probe,
+	.remove		= kempld_now1_gpio_remove,
+};
+
+static int __init kempld_now1_gpio_init(void)
+{
+	return platform_driver_register(&kempld_now1_gpio_driver);
+}
+
+static void __exit kempld_now1_gpio_exit(void)
+{
+	platform_driver_unregister(&kempld_now1_gpio_driver);
+}
+
+module_init(kempld_now1_gpio_init);
+module_exit(kempld_now1_gpio_exit);
+
+MODULE_DESCRIPTION("KEM PLD nanoETXexpress-SP GPIO Driver");
+MODULE_AUTHOR("Michael Brunner <michael.brunner@kontron.com>");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:kempld_now1-gpio");
-- 
1.7.9.5

