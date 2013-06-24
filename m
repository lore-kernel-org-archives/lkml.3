Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751387Ab3FXEHl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 00:07:41 -0400
Received: from mga09.intel.com ([134.134.136.24]:5919 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750755Ab3FXEHB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 00:07:01 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,925,1363158000"; 
   d="scan'208";a="334396278"
From: Kevin Strasser <kevin.strasser@linux.intel.com>
To: linux-kernel@vger.kernel.org
Cc: Guenter Roeck <linux@roeck-us.net>,
        Kevin Strasser <kevin.strasser@linux.intel.com>,
        Kevin Strasser <strassek@engr.orst.edu>,
        Darren Hart <dvhart@linux.intel.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Michael Brunner <Michael.Brunner@kontron.com>,
        Michael Brunner <mibru@gmx.de>, Chris Healy <chealy@imsco-us.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Dirk Hohndel <Dirk.Hohndel@intel.com>,
        Wolfram Sang <wsa@the-dreams.de>, Ben Dooks <ben-linux@fluff.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@linaro.org>,
        Wim Van Sebroeck <wim@iguana.be>
Subject: [PATCH v3 3/4] gpio: Kontron PLD gpio driver
Date: Sun, 23 Jun 2013 21:00:05 -0700
Message-Id: <1372046406-3127-4-git-send-email-kevin.strasser@linux.intel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1372046406-3127-1-git-send-email-kevin.strasser@linux.intel.com>
References: <1365441321-21952-1-git-send-email-kevin.strasser@linux.intel.com>
 <1372046406-3127-1-git-send-email-kevin.strasser@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Guenter Roeck <linux@roeck-us.net>

Add gpio support for the on-board PLD found on some Kontron embedded modules.

Originally-From: Michael Brunner <michael.brunner@kontron.com>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Kevin Strasser <kevin.strasser@linux.intel.com>
Acked-by: Darren Hart <dvhart@linux.intel.com>
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/gpio/Kconfig       |   12 +++
 drivers/gpio/Makefile      |    1 +
 drivers/gpio/gpio-kempld.c |  225 ++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 238 insertions(+)
 create mode 100644 drivers/gpio/gpio-kempld.c

diff --git a/drivers/gpio/Kconfig b/drivers/gpio/Kconfig
index 93aaadf..e94b266 100644
--- a/drivers/gpio/Kconfig
+++ b/drivers/gpio/Kconfig
@@ -658,6 +658,18 @@ config GPIO_UCB1400
 	  This enables support for the Philips UCB1400 GPIO pins.
 	  The UCB1400 is an AC97 audio codec.
 
+comment "LPC GPIO expanders:"
+
+config GPIO_KEMPLD
+	tristate "Kontron ETX / COMexpress GPIO"
+	depends on MFD_KEMPLD
+	help
+	  This enables support for the PLD GPIO interface on some Kontron ETX
+	  and COMexpress (ETXexpress) modules.
+
+	  This driver can also be built as a module. If so, the module will be
+	  called gpio-kempld.
+
 comment "MODULbus GPIO expanders:"
 
 config GPIO_JANZ_TTL
diff --git a/drivers/gpio/Makefile b/drivers/gpio/Makefile
index 22e07bc..758c348 100644
--- a/drivers/gpio/Makefile
+++ b/drivers/gpio/Makefile
@@ -28,6 +28,7 @@ obj-$(CONFIG_GPIO_GE_FPGA)	+= gpio-ge.o
 obj-$(CONFIG_GPIO_ICH)		+= gpio-ich.o
 obj-$(CONFIG_GPIO_IT8761E)	+= gpio-it8761e.o
 obj-$(CONFIG_GPIO_JANZ_TTL)	+= gpio-janz-ttl.o
+obj-$(CONFIG_GPIO_KEMPLD)	+= gpio-kempld.o
 obj-$(CONFIG_ARCH_KS8695)	+= gpio-ks8695.o
 obj-$(CONFIG_GPIO_LANGWELL)	+= gpio-langwell.o
 obj-$(CONFIG_ARCH_LPC32XX)	+= gpio-lpc32xx.o
diff --git a/drivers/gpio/gpio-kempld.c b/drivers/gpio/gpio-kempld.c
new file mode 100644
index 0000000..1bdc3a2
--- /dev/null
+++ b/drivers/gpio/gpio-kempld.c
@@ -0,0 +1,225 @@
+/*
+ * Kontron PLD GPIO driver
+ *
+ * Copyright (c) 2010-2013 Kontron Europe GmbH
+ * Author: Michael Brunner <michael.brunner@kontron.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License 2 as published
+ * by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#include <linux/init.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/bitops.h>
+#include <linux/errno.h>
+#include <linux/platform_device.h>
+#include <linux/gpio.h>
+#include <linux/mfd/kempld.h>
+
+#define KEMPLD_GPIO_MAX_NUM		16
+#define KEMPLD_GPIO_MASK(x)		(1 << ((x) % 8))
+#define KEMPLD_GPIO_DIR_NUM(x)		(0x40 + (x) / 8)
+#define KEMPLD_GPIO_LVL_NUM(x)		(0x42 + (x) / 8)
+#define KEMPLD_GPIO_EVT_LVL_EDGE	0x46
+#define KEMPLD_GPIO_IEN			0x4A
+
+struct kempld_gpio_data {
+	struct gpio_chip		chip;
+	struct kempld_device_data	*pld;
+};
+
+/*
+ * Set or clear GPIO bit
+ * kempld_get_mutex must be called prior to calling this function.
+ */
+static void kempld_gpio_bitop(struct kempld_device_data *pld,
+			      u8 reg, u8 bit, u8 val)
+{
+	u8 status;
+
+	status = kempld_read8(pld, reg);
+	if (val)
+		status |= (1 << bit);
+	else
+		status &= ~(1 << bit);
+	kempld_write8(pld, reg, status);
+}
+
+static int kempld_gpio_get_bit(struct kempld_device_data *pld, u8 reg, u8 bit)
+{
+	u8 status;
+
+	kempld_get_mutex(pld);
+	status = kempld_read8(pld, reg);
+	kempld_release_mutex(pld);
+
+	return !!(status & (1 << bit));
+}
+
+static int kempld_gpio_get(struct gpio_chip *chip, unsigned offset)
+{
+	struct kempld_gpio_data *gpio
+		= container_of(chip, struct kempld_gpio_data, chip);
+	struct kempld_device_data *pld = gpio->pld;
+
+	return kempld_gpio_get_bit(pld, KEMPLD_GPIO_LVL_NUM(offset),
+				   KEMPLD_GPIO_MASK(offset));
+}
+
+static void kempld_gpio_set(struct gpio_chip *chip, unsigned offset, int value)
+{
+	struct kempld_gpio_data *gpio
+		= container_of(chip, struct kempld_gpio_data, chip);
+	struct kempld_device_data *pld = gpio->pld;
+
+	kempld_get_mutex(pld);
+	kempld_gpio_bitop(pld, KEMPLD_GPIO_LVL_NUM(offset),
+			  KEMPLD_GPIO_MASK(offset), value);
+	kempld_release_mutex(pld);
+}
+
+static int kempld_gpio_direction_input(struct gpio_chip *chip, unsigned offset)
+{
+	struct kempld_gpio_data *gpio
+		= container_of(chip, struct kempld_gpio_data, chip);
+	struct kempld_device_data *pld = gpio->pld;
+
+	kempld_get_mutex(pld);
+	kempld_gpio_bitop(pld, KEMPLD_GPIO_DIR_NUM(offset),
+			  KEMPLD_GPIO_MASK(offset), 0);
+	kempld_release_mutex(pld);
+
+	return 0;
+}
+
+static int kempld_gpio_direction_output(struct gpio_chip *chip, unsigned offset,
+					int value)
+{
+	struct kempld_gpio_data *gpio
+		= container_of(chip, struct kempld_gpio_data, chip);
+	struct kempld_device_data *pld = gpio->pld;
+
+	kempld_get_mutex(pld);
+	kempld_gpio_bitop(pld, KEMPLD_GPIO_LVL_NUM(offset),
+			  KEMPLD_GPIO_MASK(offset), value);
+	kempld_gpio_bitop(pld, KEMPLD_GPIO_DIR_NUM(offset),
+			  KEMPLD_GPIO_MASK(offset), 1);
+	kempld_release_mutex(pld);
+
+	return 0;
+}
+
+static int kempld_gpio_get_direction(struct gpio_chip *chip, unsigned offset)
+{
+	struct kempld_gpio_data *gpio
+		= container_of(chip, struct kempld_gpio_data, chip);
+	struct kempld_device_data *pld = gpio->pld;
+
+	return kempld_gpio_get_bit(pld, KEMPLD_GPIO_DIR_NUM(offset),
+				   KEMPLD_GPIO_MASK(offset));
+}
+
+static int kempld_gpio_pincount(struct kempld_device_data *pld)
+{
+	u16 evt, evt_back;
+
+	kempld_get_mutex(pld);
+
+	/* Backup event register as it might be already initialized */
+	evt_back = kempld_read16(pld, KEMPLD_GPIO_EVT_LVL_EDGE);
+	/* Clear event register */
+	kempld_write16(pld, KEMPLD_GPIO_EVT_LVL_EDGE, 0x0000);
+	/* Read back event register */
+	evt = kempld_read16(pld, KEMPLD_GPIO_EVT_LVL_EDGE);
+	/* Restore event register */
+	kempld_write16(pld, KEMPLD_GPIO_EVT_LVL_EDGE, evt_back);
+
+	kempld_release_mutex(pld);
+
+	return evt ? __ffs(evt) : 16;
+}
+
+static int kempld_gpio_probe(struct platform_device *pdev)
+{
+	struct device *dev = &pdev->dev;
+	struct kempld_device_data *pld = dev_get_drvdata(dev->parent);
+	struct kempld_platform_data *pdata = pld->dev->platform_data;
+	struct kempld_gpio_data *gpio;
+	struct gpio_chip *chip;
+	int ret;
+
+	if (pld->info.spec_major < 2) {
+		dev_err(dev,
+			"Driver only supports GPIO devices compatible to PLD spec. rev. 2.0 or higher\n");
+		return -ENODEV;
+	}
+
+	gpio = devm_kzalloc(dev, sizeof(*gpio), GFP_KERNEL);
+	if (gpio == NULL)
+		return -ENOMEM;
+
+	gpio->pld = pld;
+
+	platform_set_drvdata(pdev, gpio);
+
+	chip = &gpio->chip;
+	chip->label = "gpio-kempld";
+	chip->owner = THIS_MODULE;
+	chip->dev = dev;
+	chip->can_sleep = 1;
+	if (pdata && pdata->gpio_base)
+		chip->base = pdata->gpio_base;
+	else
+		chip->base = -1;
+	chip->direction_input = kempld_gpio_direction_input;
+	chip->direction_output = kempld_gpio_direction_output;
+	chip->get_direction = kempld_gpio_get_direction;
+	chip->get = kempld_gpio_get;
+	chip->set = kempld_gpio_set;
+	chip->ngpio = kempld_gpio_pincount(pld);
+	if (chip->ngpio == 0) {
+		dev_err(dev, "No GPIO pins detected\n");
+		return -ENODEV;
+	}
+
+	ret = gpiochip_add(chip);
+	if (ret) {
+		dev_err(dev, "Could not register GPIO chip\n");
+		return ret;
+	}
+
+	dev_info(dev, "GPIO functionality initialized with %d pins\n",
+		 chip->ngpio);
+
+	return 0;
+}
+
+static int kempld_gpio_remove(struct platform_device *pdev)
+{
+	struct kempld_gpio_data *gpio = platform_get_drvdata(pdev);
+
+	return gpiochip_remove(&gpio->chip);
+}
+
+static struct platform_driver kempld_gpio_driver = {
+	.driver = {
+		.name = "gpio-kempld",
+		.owner = THIS_MODULE,
+	},
+	.probe		= kempld_gpio_probe,
+	.remove		= kempld_gpio_remove,
+};
+
+module_platform_driver(kempld_gpio_driver);
+
+MODULE_DESCRIPTION("KEM PLD GPIO Driver");
+MODULE_AUTHOR("Michael Brunner <michael.brunner@kontron.com>");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:gpio-kempld");
-- 
1.7.9.5

