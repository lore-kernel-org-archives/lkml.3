Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755080Ab3DLNPq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Apr 2013 09:15:46 -0400
Received: from mailrelay1.diasemi.com ([82.210.246.133]:37579 "EHLO
	mailrelay1.diasemi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753798Ab3DLNPp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Apr 2013 09:15:45 -0400
Message-Id: <201304121314.r3CDEJxs011832@latitude>
From: Anthony Olech <anthony.olech.opensource@diasemi.com>
Date: Fri, 12 Apr 2013 14:05:27 +0100
Subject: [NEW DRIVER V4 5/7] DA9058 GPIO driver
To: Grant Likely <grant.likely@secretlab.ca>
To: Linus Walleij <linus.walleij@stericsson.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Cc: David Dajun Chen <david.chen@diasemi.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the GPIO component driver of the Dialog DA9058 PMIC.
This driver is just one component of the whole DA9058 PMIC driver.
It depends on the CORE component driver of the DA9058 MFD.
The meaning of the PMIC register 21 bits 1 and 5 has been documented
in the driver source.

Signed-off-by: Anthony Olech <anthony.olech.opensource@diasemi.com>
Signed-off-by: David Dajun Chen <david.chen@diasemi.com>
---
 drivers/gpio/Kconfig       |   12 ++
 drivers/gpio/Makefile      |    1 +
 drivers/gpio/gpio-da9058.c |  377 ++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 390 insertions(+)
 create mode 100644 drivers/gpio/gpio-da9058.c

diff --git a/drivers/gpio/Kconfig b/drivers/gpio/Kconfig
index 93aaadf..3530f13 100644
--- a/drivers/gpio/Kconfig
+++ b/drivers/gpio/Kconfig
@@ -104,6 +104,18 @@ config GPIO_DA9055
 
 	  If driver is built as a module it will be called gpio-da9055.
 
+config GPIO_DA9058
+	tristate "Dialog DA9058 GPIO"
+	depends on MFD_DA9058
+	help
+	  Say yes here to enable the GPIO driver for the DA9058 chip.
+
+	  The Dialog DA9058 PMIC chip has 2 GPIO pins that can be
+	  be controller by this driver.
+
+	  If driver is built as a module it will be called da9058-gpio.
+
+
 config GPIO_MAX730X
 	tristate
 
diff --git a/drivers/gpio/Makefile b/drivers/gpio/Makefile
index 22e07bc..425adc7 100644
--- a/drivers/gpio/Makefile
+++ b/drivers/gpio/Makefile
@@ -19,6 +19,7 @@ obj-$(CONFIG_GPIO_ARIZONA)	+= gpio-arizona.o
 obj-$(CONFIG_GPIO_BT8XX)	+= gpio-bt8xx.o
 obj-$(CONFIG_GPIO_CLPS711X)	+= gpio-clps711x.o
 obj-$(CONFIG_GPIO_CS5535)	+= gpio-cs5535.o
+obj-$(CONFIG_GPIO_DA9058)	+= gpio-da9058.o
 obj-$(CONFIG_GPIO_DA9052)	+= gpio-da9052.o
 obj-$(CONFIG_GPIO_DA9055)	+= gpio-da9055.o
 obj-$(CONFIG_ARCH_DAVINCI)	+= gpio-davinci.o
diff --git a/drivers/gpio/gpio-da9058.c b/drivers/gpio/gpio-da9058.c
new file mode 100644
index 0000000..3d69f2f
--- /dev/null
+++ b/drivers/gpio/gpio-da9058.c
@@ -0,0 +1,377 @@
+/*
+ *  Copyright (C) 2012 Dialog Semiconductor Ltd.
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License as published by
+ *  the Free Software Foundation; either version 2 of the License, or
+ *  (at your option) any later version.
+ *
+ */
+
+#include <linux/module.h>
+#include <linux/gpio.h>
+#include <linux/mfd/core.h>
+#include <linux/regmap.h>
+
+#include <linux/mfd/da9058/version.h>
+#include <linux/mfd/da9058/registers.h>
+#include <linux/mfd/da9058/core.h>
+#include <linux/mfd/da9058/gpio.h>
+#include <linux/mfd/da9058/irq.h>
+#include <linux/mfd/da9058/pdata.h>
+
+/*
+ *  There are only 2 available GPIO pins on the DA9058 PMIC
+ *
+ *  Thus this driver distinguishes them by the offset number
+ *  being zero or non-zero for simplicity.
+*
+*
+ *  A note about the control register DA9058_GPIO0001_REG
+ *
+ *  Bit 0x02 for GPIO[0] and bit 0x20 for GPIO[1] are the direction bits
+ *
+ *  gpio_set() only makes sense for GPIO pins configured to be outputs
+ *  and since the meaning of all the other bits is different for INP's
+ *  we must not change them if that is the case
+ *
+ *  gpio_set_debounce() only makes sense for GPIO pins configured to be
+ *  inputs and since the meaning of all the other bits is different for
+ *  OUT's we must not change them if that is the case
+ *
+ *  However to allow for the case where the GPIO user issues the commands
+ *  direction_input(), direction_output(), gpio_set(), gpio_set_debounce()
+ *  in any order the driver has to remember those settings since using the
+ *  DA9058 PMIC itself will not work and that is the reason for the recorded
+ *  inp_config and out_config in the driver's da9058_gpio structure.
+ *
+ */
+struct da9058_gpio {
+	struct da9058 *da9058;
+	struct platform_device *pdev;
+	struct gpio_chip gp;
+	struct mutex lock;
+	int irq_0;
+	int irq_1;
+	u8 inp_config;
+	u8 out_config;
+};
+
+static inline
+struct da9058_gpio *gpio_chip_to_da9058_gpio(struct gpio_chip *chip)
+{
+	return container_of(chip, struct da9058_gpio, gp);
+}
+
+static int da9058_gpio_get(struct gpio_chip *gc, unsigned offset)
+{
+	struct da9058_gpio *gpio = gpio_chip_to_da9058_gpio(gc);
+	struct da9058 *da9058 = gpio->da9058;
+	unsigned int gpio_level;
+	int ret;
+
+	if (offset > 1)
+		return -EINVAL;
+
+	ret = da9058_reg_read(da9058, DA9058_STATUSC_REG, &gpio_level);
+	if (ret < 0)
+		return ret;
+
+	if (offset) {
+		if (gpio_level & DA9058_STATUSC_GPI1)
+			return 1;
+		else
+			return 0;
+	} else {
+		if (gpio_level & DA9058_STATUSC_GPI0)
+			return 1;
+		else
+			return 0;
+	}
+}
+
+static void da9058_gpio_set(struct gpio_chip *gc, unsigned offset, int value)
+{
+	struct da9058_gpio *gpio = gpio_chip_to_da9058_gpio(gc);
+	struct da9058 *da9058 = gpio->da9058;
+	unsigned int gpio_cntrl;
+	int ret;
+
+	if (offset > 1) {
+		dev_err(da9058->dev,
+			"Failed to set GPIO%d output=%d because illegal GPIO\n",
+			offset, value);
+		return;
+	}
+
+	mutex_lock(&gpio->lock);
+
+	if (offset) {
+
+		ret = da9058_reg_read(da9058, DA9058_GPIO0001_REG, &gpio_cntrl);
+		if (ret)
+			goto exit;
+		gpio->out_config &= ~0x80;
+		gpio->out_config |= value ? 0x80 : 0x00;
+
+		if (!(gpio_cntrl & 0x20))	/* an INP pin */
+			goto exit;
+
+		gpio_cntrl &= ~0xF0;
+		gpio_cntrl |= 0xF0 & gpio->out_config;
+
+		ret = da9058_reg_write(da9058, DA9058_GPIO0001_REG, gpio_cntrl);
+	} else {
+
+		ret = da9058_reg_read(da9058, DA9058_GPIO0001_REG, &gpio_cntrl);
+		if (ret)
+			goto exit;
+		gpio->out_config &= ~0x08;
+		gpio->out_config |= value ? 0x08 : 0x00;
+
+		if (!(gpio_cntrl & 0x02))	/* an INP pin */
+			goto exit;
+
+		gpio_cntrl &= ~0x0F;
+		gpio_cntrl |= 0x0F & gpio->out_config;
+
+		ret = da9058_reg_write(da9058, DA9058_GPIO0001_REG, gpio_cntrl);
+	}
+exit:
+	mutex_unlock(&gpio->lock);
+	if (ret)
+		dev_err(da9058->dev,
+			"Failed to set GPIO%d output=%d error=%d\n",
+			offset, value, ret);
+	return;
+}
+
+static int da9058_gpio_direction_input(struct gpio_chip *gc, unsigned offset)
+{
+	struct da9058_gpio *gpio = gpio_chip_to_da9058_gpio(gc);
+	struct da9058 *da9058 = gpio->da9058;
+	int ret;
+
+	if (offset > 1)
+		return -EINVAL;
+
+	mutex_lock(&gpio->lock);
+
+	ret = da9058_update_bits(da9058, DA9058_GPIO0001_REG,
+				offset ? 0xF0 : 0x0F, gpio->inp_config);
+
+	mutex_unlock(&gpio->lock);
+	if (ret)
+		dev_err(da9058->dev,
+			"Failed to set GPIO%d to output error=%d\n",
+			offset, ret);
+	return ret;
+}
+
+static int da9058_gpio_direction_output(struct gpio_chip *gc,
+					unsigned offset, int value)
+{
+	struct da9058_gpio *gpio = gpio_chip_to_da9058_gpio(gc);
+	struct da9058 *da9058 = gpio->da9058;
+	int ret;
+
+	if (offset > 1)
+		return -EINVAL;
+
+	mutex_lock(&gpio->lock);
+
+	ret = da9058_update_bits(da9058, DA9058_GPIO0001_REG,
+				offset ? 0xF0 : 0x0F, gpio->out_config);
+
+	mutex_unlock(&gpio->lock);
+	if (ret)
+		dev_err(da9058->dev,
+			"Failed to set GPIO%d to input error=%d\n",
+			offset, ret);
+	return ret;
+}
+
+/*
+ *  da9058_gpio_to_irq is an implementation of the GPIO Hook
+ *  @to_irq: supporting non-static gpio_to_irq() mappings
+ *  whose implementation may not sleep. This hook is called
+ *  when setting up the threaded GPIO irq handler.
+ */
+static int da9058_gpio_to_irq(struct gpio_chip *gc, u32 offset)
+{
+	struct da9058_gpio *gpio = gpio_chip_to_da9058_gpio(gc);
+	struct da9058 *da9058 = gpio->da9058;
+
+	if (offset > 1)
+		return -EINVAL;
+
+	if (offset)
+		return da9058_to_virt_irq_num(da9058, gpio->irq_1);
+	else
+		return da9058_to_virt_irq_num(da9058, gpio->irq_0);
+}
+
+static int da9058_gpio_set_debounce(struct gpio_chip *gc, unsigned offset,
+				unsigned debounce)
+{
+	struct da9058_gpio *gpio = gpio_chip_to_da9058_gpio(gc);
+	struct da9058 *da9058 = gpio->da9058;
+	int ret;
+	unsigned int gpio_cntrl;
+
+	if (offset > 1)
+		return -EINVAL;
+
+	mutex_lock(&gpio->lock);
+
+	if (offset) {
+		u8 debounce_bits = debounce ? 0x80 : 0x00;
+
+		ret = da9058_reg_read(da9058, DA9058_GPIO0001_REG, &gpio_cntrl);
+		if (ret)
+			goto exit;
+		gpio->inp_config &= ~0x80;
+		gpio->inp_config |= debounce_bits;
+
+		if (gpio_cntrl & 0x20)	/* an OUT pin */
+			goto exit;
+
+		gpio_cntrl &= ~0xF0;
+		gpio_cntrl |= 0xF0 & gpio->inp_config;
+
+		ret = da9058_reg_write(da9058, DA9058_GPIO0001_REG, gpio_cntrl);
+	} else {
+		u8 debounce_bits = debounce ? 0x08 : 0x00;
+
+		ret = da9058_reg_read(da9058, DA9058_GPIO0001_REG, &gpio_cntrl);
+		if (ret)
+			goto exit;
+		gpio->inp_config &= ~0x08;
+		gpio->inp_config |= debounce_bits;
+
+		if (gpio_cntrl & 0x02)	/* an OUT pin */
+			goto exit;
+
+		gpio_cntrl &= ~0x0F;
+		gpio_cntrl |= 0x0F & gpio->inp_config;
+
+		ret = da9058_reg_write(da9058, DA9058_GPIO0001_REG, gpio_cntrl);
+	}
+exit:
+	mutex_unlock(&gpio->lock);
+	if (ret)
+		dev_err(da9058->dev,
+			"Failed to set GPIO%d bounce=%d error=%d\n",
+			offset, debounce, ret);
+	return ret;
+}
+
+static int da9058_gpio_probe(struct platform_device *pdev)
+{
+	struct da9058 *da9058 = dev_get_drvdata(pdev->dev.parent);
+	const struct mfd_cell *cell = mfd_get_cell(pdev);
+	struct da9058_gpio_pdata *gpio_pdata;
+	struct da9058_gpio *gpio;
+	int ret;
+
+	if (cell == NULL) {
+		ret = -ENODEV;
+		goto exit;
+	}
+
+	gpio_pdata = cell->platform_data;
+
+	if (!gpio_pdata) {
+		ret = -EINVAL;
+		goto exit;
+	}
+
+	gpio = devm_kzalloc(&pdev->dev, sizeof(struct da9058_gpio), GFP_KERNEL);
+	if (!gpio) {
+		ret = -ENOMEM;
+		goto exit;
+	}
+
+	gpio->da9058 = da9058;
+	gpio->pdev = pdev;
+	gpio->irq_0 = platform_get_irq(pdev, 0);
+	gpio->irq_1 = platform_get_irq(pdev, 1);
+	if (gpio->irq_0 < 0 || gpio->irq_1 < 0) {
+		dev_err(&pdev->dev, "can not get GPIO IRQ error=%d,%d\n",
+				gpio->irq_0, gpio->irq_1);
+		ret = -ENODEV;
+		goto failed_to_get_irq;
+	}
+
+	gpio->gp.label = "da9058-gpio";
+	gpio->gp.owner = THIS_MODULE;
+	gpio->gp.get = da9058_gpio_get;
+	gpio->gp.set = da9058_gpio_set;
+	gpio->gp.direction_input = da9058_gpio_direction_input;
+	gpio->gp.direction_output = da9058_gpio_direction_output;
+	gpio->gp.to_irq = da9058_gpio_to_irq;
+	gpio->gp.set_debounce = da9058_gpio_set_debounce;
+	gpio->gp.can_sleep = 1;
+	gpio->gp.ngpio = gpio_pdata->ngpio;
+	gpio->gp.base = gpio_pdata->gpio_base;
+
+	/*
+	 * INP configured pins:
+	 *     9 == DebounceOn+ActiceLowPullUp
+	 *
+	 * OUT configured pins:
+	 *     7 == PushPull+ExternalPullUpToVDDIO
+	 *     3 == PushPull+InternalPullUpToVDDIO
+	 *     2 == OpenDrain+InternalPullUpToVDDIO
+	 */
+
+	gpio->inp_config = 0x99;
+	gpio->out_config = 0x77;
+
+	mutex_init(&gpio->lock);
+
+	ret = gpiochip_add(&gpio->gp);
+	if (ret < 0) {
+		dev_err(&pdev->dev, "Could not register gpiochip, %d\n", ret);
+		goto failed_to_add_gpio_chip;
+	}
+
+	platform_set_drvdata(pdev, gpio);
+
+	mutex_lock(&gpio->lock);
+	ret = da9058_reg_write(da9058, DA9058_GPIO0001_REG, gpio->inp_config);
+	mutex_unlock(&gpio->lock);
+	if (ret)
+		dev_err(da9058->dev,
+			"Failed to set GPIO0 as an output error = %d\n", ret);
+failed_to_add_gpio_chip:
+failed_to_get_irq:
+exit:
+	return ret;
+}
+
+static int da9058_gpio_remove(struct platform_device *pdev)
+{
+	struct da9058_gpio *gpio = platform_get_drvdata(pdev);
+	int ret;
+
+	ret = gpiochip_remove(&gpio->gp);
+
+	return ret;
+}
+
+static struct platform_driver da9058_gpio_driver = {
+	.probe = da9058_gpio_probe,
+	.remove = da9058_gpio_remove,
+	.driver = {
+		.name = "da9058-gpio",
+		.owner = THIS_MODULE,
+	},
+};
+
+module_platform_driver(da9058_gpio_driver);
+
+MODULE_DESCRIPTION("Dialog DA9058 PMIC General Purpose IO Driver");
+MODULE_AUTHOR("Anthony Olech <Anthony.Olech@diasemi.com>");
+MODULE_LICENSE("GPL v2");
+MODULE_ALIAS("platform:da9058-gpio");
-- 
end-of-patch for NEW DRIVER V4

