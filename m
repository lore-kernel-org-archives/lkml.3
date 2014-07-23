Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756755AbaGWN71 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 09:59:27 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:53422 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752463AbaGWN7Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 09:59:25 -0400
From: Grygorii Strashko <grygorii.strashko@ti.com>
To: <santosh.shilimkar@ti.com>, Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>, <linux-gpio@vger.kernel.org>
CC: <ivan.khoronzhuk@ti.com>, <m-karicheri2@ti.com>,
        Rob Herring <robh+dt@kernel.org>, Kumar Gala <galak@codeaurora.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <varkabhadram@gmail.com>, Grygorii Strashko <grygorii.strashko@ti.com>
Subject: [PATCH v2] gpio: keystone: add dsp gpio controller driver
Date: Wed, 23 Jul 2014 17:44:59 +0300
Message-ID: <1406126699-10053-1-git-send-email-grygorii.strashko@ti.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Murali Karicheri <m-karicheri2@ti.com>

On Keystone SOCs, ARM host can send interrupts to DSP cores using the
DSP GPIO controller IP. Each DSP GPIO controller provides 28 IRQ signals for
each DSP core. This is one of the component used by the IPC mechanism used
on Keystone SOCs.

Keystone 2 DSP GPIO controller has specific features:
- each GPIO can be configured only as output pin;
- setting GPIO value to 1 causes IRQ generation on target DSP core;
- reading pin value returns 0 - if IRQ was handled or 1 - IRQ is still
  pending.

Signed-off-by: Murali Karicheri <m-karicheri2@ti.com>
Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
---
Changes in v2:
- minor comments applied

v1:
 https://lkml.org/lkml/2014/7/16/170

 .../devicetree/bindings/gpio/gpio-keystone.txt     |   43 ++++++
 drivers/gpio/Kconfig                               |    8 ++
 drivers/gpio/Makefile                              |    1 +
 drivers/gpio/gpio-keystone.c                       |  138 ++++++++++++++++++++
 4 files changed, 190 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/gpio/gpio-keystone.txt
 create mode 100644 drivers/gpio/gpio-keystone.c

diff --git a/Documentation/devicetree/bindings/gpio/gpio-keystone.txt b/Documentation/devicetree/bindings/gpio/gpio-keystone.txt
new file mode 100644
index 0000000..d412711
--- /dev/null
+++ b/Documentation/devicetree/bindings/gpio/gpio-keystone.txt
@@ -0,0 +1,43 @@
+Keystone 2 DSP GPIO controller bindings
+
+HOST OS userland running on ARM can send interrupts to DSP cores using
+the DSP GPIO controller IP. It provides 28 IRQ signals per each DSP core.
+This is one of the component used by the IPC mechanism used on Keystone SOCs.
+
+For example TCI6638K2K SoC has 8 DSP GPIO controllers:
+ - 8 for C66x CorePacx CPUs 0-7
+
+Keystone 2 DSP GPIO controller has specific features:
+- each GPIO can be configured only as output pin;
+- setting GPIO value to 1 causes IRQ generation on target DSP core;
+- reading pin value returns 0 - if IRQ was handled or 1 - IRQ is still
+  pending.
+
+Required Properties:
+- compatible: should be "ti,keystone-dsp-gpio"
+
+- ti,syscon-dev : phandle/offset pair. The phandle to syscon used to
+				  access device state control registers and the offset
+				  in order to use block of device's specific registers.
+
+- gpio-controller : Marks the device node as a gpio controller.
+
+- #gpio-cells : Should be one.
+				See gpio.txt in this directory for a of the cells format
+
+Please refer to gpio.txt in this directory for details of the common GPIO
+bindings used by client devices.
+
+Example:
+	dspgpio0: keystone_dsp_gpio@02620240 {
+		compatible = "ti,keystone-dsp-gpio";
+		ti,syscon-dev = <&devctrl 0x240>;
+		gpio-controller;
+		#gpio-cells = <2>;
+	};
+
+	dsp0: dsp0 {
+		compatible = "linux,rproc-user";
+		...
+		kick-gpio = <&dspgpio0 27>;
+	};
diff --git a/drivers/gpio/Kconfig b/drivers/gpio/Kconfig
index 4a1b511..990871f 100644
--- a/drivers/gpio/Kconfig
+++ b/drivers/gpio/Kconfig
@@ -158,6 +158,14 @@ config GPIO_EP93XX
 	depends on ARCH_EP93XX
 	select GPIO_GENERIC
 
+config GPIO_KEYSTONE_DSP
+	tristate "Keystone DSP GPIO support"
+	depends on ARCH_KEYSTONE
+	help
+	  Say yes here to support the DSP GPIO driver for Keystone 2. This defines
+	  up to 28 GPIOs per each Remote (DSP) core. This is used to send
+	  signals from ARM to the Remote (DSP) core.
+
 config GPIO_ZEVIO
 	bool "LSI ZEVIO SoC memory mapped GPIOs"
 	depends on ARM && OF_GPIO
diff --git a/drivers/gpio/Makefile b/drivers/gpio/Makefile
index d10f6a9..15c3389 100644
--- a/drivers/gpio/Makefile
+++ b/drivers/gpio/Makefile
@@ -34,6 +34,7 @@ obj-$(CONFIG_GPIO_IOP)		+= gpio-iop.o
 obj-$(CONFIG_GPIO_IT8761E)	+= gpio-it8761e.o
 obj-$(CONFIG_GPIO_JANZ_TTL)	+= gpio-janz-ttl.o
 obj-$(CONFIG_GPIO_KEMPLD)	+= gpio-kempld.o
+obj-$(CONFIG_GPIO_KEYSTONE_DSP)	+= gpio-keystone.o
 obj-$(CONFIG_ARCH_KS8695)	+= gpio-ks8695.o
 obj-$(CONFIG_GPIO_INTEL_MID)	+= gpio-intel-mid.o
 obj-$(CONFIG_GPIO_LP3943)	+= gpio-lp3943.o
diff --git a/drivers/gpio/gpio-keystone.c b/drivers/gpio/gpio-keystone.c
new file mode 100644
index 0000000..7909a1c
--- /dev/null
+++ b/drivers/gpio/gpio-keystone.c
@@ -0,0 +1,138 @@
+/*
+ * Keystone 2 DSP GPIO support.
+ *
+ * Copyright (C) 2014 Texas Instruments, Inc.
+ * Author: Murali Karicheri <m-karicheri2@ti.com>
+ *	   Grygorii Strashko <grygorii.strashko@ti.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+#include <linux/module.h>
+#include <linux/of_platform.h>
+#include <linux/gpio.h>
+#include <linux/mfd/syscon.h>
+#include <linux/regmap.h>
+
+/* 28 bits in IPCGRx are treated as GPIO pins to generate interrupt */
+#define GPIOS_PER_BANK		28
+#define GPIO_OFFSET		4
+
+struct keystone_gpio_bank {
+	struct gpio_chip	 chip;
+	struct device		*dev;
+	struct regmap		*devctrl_regs;
+	u32			devctrl_offset;
+};
+#define chip_to_bank(c) \
+	container_of(c, struct keystone_gpio_bank, chip)
+
+static int keystone_gpio_direction_out(struct gpio_chip *c,
+					unsigned ofs, int val)
+{
+	return 0;
+}
+
+static int keystone_gpio_get(struct gpio_chip *c, unsigned ofs)
+{
+	struct keystone_gpio_bank *bank = chip_to_bank(c);
+	int bit = ofs + GPIO_OFFSET;
+	int ret;
+	u32 val = 0;
+
+	ret = regmap_read(bank->devctrl_regs, bank->devctrl_offset, &val);
+	if (ret < 0)
+		dev_dbg(bank->dev, "gpio read failed ret(%d)\n", ret);
+
+	return (val >> bit) & 1;
+}
+
+static void keystone_gpio_set(struct gpio_chip *c, unsigned ofs, int val)
+{
+	struct keystone_gpio_bank *bank = chip_to_bank(c);
+	int bit = ofs + GPIO_OFFSET;
+	int ret;
+
+	if (!val)
+		return;
+
+	ret = regmap_write(bank->devctrl_regs, bank->devctrl_offset,
+			   BIT(bit) | 1);
+	if (ret < 0)
+		dev_dbg(bank->dev, "gpio write failed ret(%d)\n", ret);
+}
+
+static int keystone_gpio_probe(struct platform_device *pdev)
+{
+	struct device *dev = &pdev->dev;
+	struct device_node *np = dev->of_node;
+	struct keystone_gpio_bank *bank;
+	int ret = 0;
+
+	bank = devm_kzalloc(&pdev->dev, sizeof(*bank), GFP_KERNEL);
+	if (!bank)
+		return -ENOMEM;
+
+	bank->devctrl_regs =
+		syscon_regmap_lookup_by_phandle(np, "ti,syscon-dev");
+	if (IS_ERR(bank->devctrl_regs))
+		return PTR_ERR(bank->devctrl_regs);
+
+	ret = of_property_read_u32_index(np, "ti,syscon-dev", 1,
+					 &bank->devctrl_offset);
+	if (ret) {
+		dev_err(dev, "couldn't read the devctrl_offset offset!\n");
+		return ret;
+	}
+
+	bank->dev			= dev;
+#ifdef CONFIG_OF_GPIO
+	bank->chip.of_node		= of_node_get(np);
+#endif
+	bank->chip.label		= dev_name(dev);
+	bank->chip.get			= keystone_gpio_get;
+	bank->chip.set			= keystone_gpio_set;
+	bank->chip.direction_output	= keystone_gpio_direction_out;
+	bank->chip.base			= -1;
+	bank->chip.ngpio		= GPIOS_PER_BANK;
+
+	platform_set_drvdata(pdev, bank);
+
+	ret = gpiochip_add(&bank->chip);
+	if (ret) {
+		dev_err(dev, "gpio chip registration failed ret(%d)\n", ret);
+		return ret;
+	}
+
+	dev_info(bank->dev, "registered %d gpios\n", bank->chip.ngpio);
+	return ret;
+}
+
+static int keystone_gpio_remove(struct platform_device *pdev)
+{
+	struct keystone_gpio_bank *bank = platform_get_drvdata(pdev);
+
+	return gpiochip_remove(&bank->chip);
+}
+
+static const struct of_device_id keystone_gpio_dt_ids[] = {
+	{ .compatible = "ti,keystone-dsp-gpio", },
+	{ },
+};
+
+static struct platform_driver keystone_gpio_driver = {
+	.probe		= keystone_gpio_probe,
+	.remove		= keystone_gpio_remove,
+	.driver		= {
+		.name	= "keystone-dsp-gpio",
+		.of_match_table = keystone_gpio_dt_ids,
+	},
+};
+
+module_platform_driver(keystone_gpio_driver);
+
+MODULE_AUTHOR("Texas Instruments");
+MODULE_AUTHOR("Murali Karicheri <m-karicheri2@ti.com>");
+MODULE_DESCRIPTION("Texas Instruments Keystone 2 DSP GPIO");
+MODULE_LICENSE("GPL v2");
-- 
1.7.9.5

