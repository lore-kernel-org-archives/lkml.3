Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936609Ab3DJNNN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 09:13:13 -0400
Received: from nbd.name ([46.4.11.11]:56759 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751347Ab3DJNNM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 09:13:12 -0400
From: John Crispin <blogic@openwrt.org>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: linux-kernel@vger.kernel.org, linux-mips@linux-mips.org,
        Gabor Juhos <juhosg@openwrt.org>, John Crispin <blogic@openwrt.org>
Subject: [PATCH] GPIO: MIPS: ralink: adds ralink gpio support
Date: Wed, 10 Apr 2013 15:09:10 +0200
Message-Id: <1365599350-14321-1-git-send-email-blogic@openwrt.org>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add gpio driver for Ralink SoC. This driver makes the gpio core on
RT2880, RT305x, rt3352, rt3662, rt3883, rt5350 and mt7620 work.

Signed-off-by: John Crispin <blogic@openwrt.org>
---
 .../devicetree/bindings/gpio/gpio-ralink.txt       |   33 ++++
 arch/mips/Kconfig                                  |    1 +
 arch/mips/include/asm/mach-ralink/gpio.h           |   24 +++
 drivers/gpio/Kconfig                               |    6 +
 drivers/gpio/Makefile                              |    1 +
 drivers/gpio/gpio-ralink.c                         |  176 ++++++++++++++++++++
 6 files changed, 241 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/gpio/gpio-ralink.txt
 create mode 100644 arch/mips/include/asm/mach-ralink/gpio.h
 create mode 100644 drivers/gpio/gpio-ralink.c

diff --git a/Documentation/devicetree/bindings/gpio/gpio-ralink.txt b/Documentation/devicetree/bindings/gpio/gpio-ralink.txt
new file mode 100644
index 0000000..399a5a5
--- /dev/null
+++ b/Documentation/devicetree/bindings/gpio/gpio-ralink.txt
@@ -0,0 +1,33 @@
+Ralink SoC GPIO controller
+
+Ralink System on a Chip have 1 or more banks of gpios. Each bank can have up
+to 32 gpios. The layout of the registers varies between banks and SoC.
+
+Required properties:
+- compatible : Should be "ralink,rt2880-gpio"
+- reg : Address and length of the register set for the device
+- #gpio-cells : Should be two.  The first cell is the pin number and
+  the second cell is used to specify optional parameters (currently
+  unused).
+- gpio-controller : Marks the device node as a gpio controller.
+- ralink,num-gpios : The number of GPIOs that this bank has
+- ralink,register-map : Each banks register layout depends on the bank
+  id and the SoC it is on. To make the driver flexible we need to define
+  the layout inside the DT.
+
+Example:
+
+palmbus@10000000 {
+	gpio0: gpio@600 {
+		compatible = "ralink,rt5350-gpio", "ralink,rt2880-gpio";
+		reg = <0x600 0x34>;
+
+		#gpio-cells = <2>;
+		gpio-controller;
+
+		ralink,num-gpios = <24>;
+		ralink,register-map = [ 00 04 08 0c
+					20 24 28 2c
+					30 34 ];
+	};
+};
diff --git a/arch/mips/Kconfig b/arch/mips/Kconfig
index e4da4f8..b237c50 100644
--- a/arch/mips/Kconfig
+++ b/arch/mips/Kconfig
@@ -443,6 +443,7 @@ config RALINK
 	select SYS_HAS_EARLY_PRINTK
 	select HAVE_MACH_CLKDEV
 	select CLKDEV_LOOKUP
+	select ARCH_REQUIRE_GPIOLIB
 
 config SGI_IP22
 	bool "SGI IP22 (Indy/Indigo2)"
diff --git a/arch/mips/include/asm/mach-ralink/gpio.h b/arch/mips/include/asm/mach-ralink/gpio.h
new file mode 100644
index 0000000..f68ee16
--- /dev/null
+++ b/arch/mips/include/asm/mach-ralink/gpio.h
@@ -0,0 +1,24 @@
+/*
+ *  Ralink SoC GPIO API support
+ *
+ *  Copyright (C) 2008-2009 Gabor Juhos <juhosg@openwrt.org>
+ *  Copyright (C) 2008 Imre Kaloz <kaloz@openwrt.org>
+ *
+ *  This program is free software; you can redistribute it and/or modify it
+ *  under the terms of the GNU General Public License version 2 as published
+ *  by the Free Software Foundation.
+ *
+ */
+
+#ifndef __ASM_MACH_RALINK_GPIO_H
+#define __ASM_MACH_RALINK_GPIO_H
+
+#define ARCH_NR_GPIOS	128
+#include <asm-generic/gpio.h>
+
+#define gpio_get_value	__gpio_get_value
+#define gpio_set_value	__gpio_set_value
+#define gpio_cansleep	__gpio_cansleep
+#define gpio_to_irq	__gpio_to_irq
+
+#endif /* __ASM_MACH_RALINK_GPIO_H */
diff --git a/drivers/gpio/Kconfig b/drivers/gpio/Kconfig
index 93aaadf..29add97 100644
--- a/drivers/gpio/Kconfig
+++ b/drivers/gpio/Kconfig
@@ -204,6 +204,12 @@ config GPIO_PXA
 	help
 	  Say yes here to support the PXA GPIO device
 
+config GPIO_RALINK
+	bool "Ralink GPIO Support"
+	depends on RALINK
+	help
+	  Say yes here to support the Ralink SoC GPIO device
+
 config GPIO_SPEAR_SPICS
 	bool "ST SPEAr13xx SPI Chip Select as GPIO support"
 	depends on PLAT_SPEAR
diff --git a/drivers/gpio/Makefile b/drivers/gpio/Makefile
index 22e07bc..f7b6603 100644
--- a/drivers/gpio/Makefile
+++ b/drivers/gpio/Makefile
@@ -55,6 +55,7 @@ obj-$(CONFIG_GPIO_PCF857X)	+= gpio-pcf857x.o
 obj-$(CONFIG_GPIO_PCH)		+= gpio-pch.o
 obj-$(CONFIG_GPIO_PL061)	+= gpio-pl061.o
 obj-$(CONFIG_GPIO_PXA)		+= gpio-pxa.o
+obj-$(CONFIG_GPIO_RALINK)	+= gpio-ralink.o
 obj-$(CONFIG_GPIO_RC5T583)	+= gpio-rc5t583.o
 obj-$(CONFIG_GPIO_RDC321X)	+= gpio-rdc321x.o
 obj-$(CONFIG_PLAT_SAMSUNG)	+= gpio-samsung.o
diff --git a/drivers/gpio/gpio-ralink.c b/drivers/gpio/gpio-ralink.c
new file mode 100644
index 0000000..26e8441
--- /dev/null
+++ b/drivers/gpio/gpio-ralink.c
@@ -0,0 +1,176 @@
+/*
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License version 2 as published
+ * by the Free Software Foundation.
+ *
+ * Copyright (C) 2009-2011 Gabor Juhos <juhosg@openwrt.org>
+ * Copyright (C) 2013 John Crispin <blogic@openwrt.org>
+ */
+
+#include <linux/module.h>
+#include <linux/io.h>
+#include <linux/gpio.h>
+#include <linux/spinlock.h>
+#include <linux/platform_device.h>
+
+enum ralink_gpio_reg {
+	GPIO_REG_INT = 0,
+	GPIO_REG_EDGE,
+	GPIO_REG_RENA,
+	GPIO_REG_FENA,
+	GPIO_REG_DATA,
+	GPIO_REG_DIR,
+	GPIO_REG_POL,
+	GPIO_REG_SET,
+	GPIO_REG_RESET,
+	GPIO_REG_TOGGLE,
+	GPIO_REG_MAX
+};
+
+struct ralink_gpio_chip {
+	struct gpio_chip chip;
+	u8 regs[GPIO_REG_MAX];
+
+	spinlock_t lock;
+	void __iomem *membase;
+};
+
+static inline struct ralink_gpio_chip *to_ralink_gpio(struct gpio_chip *chip)
+{
+	struct ralink_gpio_chip *rg;
+
+	rg = container_of(chip, struct ralink_gpio_chip, chip);
+	return rg;
+}
+
+static inline void rt_gpio_w32(struct ralink_gpio_chip *rg, u8 reg, u32 val)
+{
+	iowrite32(val, rg->membase + rg->regs[reg]);
+}
+
+static inline u32 rt_gpio_r32(struct ralink_gpio_chip *rg, u8 reg)
+{
+	return ioread32(rg->membase + rg->regs[reg]);
+}
+
+static void ralink_gpio_set(struct gpio_chip *chip, unsigned offset, int value)
+{
+	struct ralink_gpio_chip *rg = to_ralink_gpio(chip);
+
+	rt_gpio_w32(rg, (value) ? GPIO_REG_SET : GPIO_REG_RESET, BIT(offset));
+}
+
+static int ralink_gpio_get(struct gpio_chip *chip, unsigned offset)
+{
+	struct ralink_gpio_chip *rg = to_ralink_gpio(chip);
+
+	return !!(rt_gpio_r32(rg, GPIO_REG_DATA) & BIT(offset));
+}
+
+static int ralink_gpio_direction_input(struct gpio_chip *chip, unsigned offset)
+{
+	struct ralink_gpio_chip *rg = to_ralink_gpio(chip);
+	unsigned long flags;
+	u32 t;
+
+	spin_lock_irqsave(&rg->lock, flags);
+	t = rt_gpio_r32(rg, GPIO_REG_DIR);
+	t &= ~BIT(offset);
+	rt_gpio_w32(rg, GPIO_REG_DIR, t);
+	spin_unlock_irqrestore(&rg->lock, flags);
+
+	return 0;
+}
+
+static int ralink_gpio_direction_output(struct gpio_chip *chip,
+					unsigned offset, int value)
+{
+	struct ralink_gpio_chip *rg = to_ralink_gpio(chip);
+	unsigned long flags;
+	u32 t;
+
+	spin_lock_irqsave(&rg->lock, flags);
+	ralink_gpio_set(chip, offset, value);
+	t = rt_gpio_r32(rg, GPIO_REG_DIR);
+	t |= BIT(offset);
+	rt_gpio_w32(rg, GPIO_REG_DIR, t);
+	spin_unlock_irqrestore(&rg->lock, flags);
+
+	return 0;
+}
+
+static int ralink_gpio_probe(struct platform_device *pdev)
+{
+	struct device_node *np = pdev->dev.of_node;
+	struct resource *res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	struct ralink_gpio_chip *gc;
+	const __be32 *ngpio;
+
+	if (!res) {
+		dev_err(&pdev->dev, "failed to find resource\n");
+		return -ENOMEM;
+	}
+
+	gc = devm_kzalloc(&pdev->dev,
+				sizeof(struct ralink_gpio_chip), GFP_KERNEL);
+	if (!gc)
+		return -ENOMEM;
+
+	gc->membase = devm_ioremap_resource(&pdev->dev, res);
+	if (!gc->membase) {
+		dev_err(&pdev->dev, "cannot remap I/O memory region\n");
+		return -ENOMEM;
+	}
+
+	if (of_property_read_u8_array(np, "ralink,register-map",
+			gc->regs, GPIO_REG_MAX)) {
+		dev_err(&pdev->dev, "failed to read register definition\n");
+		return -EINVAL;
+	}
+
+	ngpio = of_get_property(np, "ralink,num-gpios", NULL);
+	if (!ngpio) {
+		dev_err(&pdev->dev, "failed to read number of pins\n");
+		return -EINVAL;
+	}
+
+	spin_lock_init(&gc->lock);
+
+	gc->chip.label = dev_name(&pdev->dev);
+	gc->chip.of_node = np;
+	gc->chip.base = -1;
+	gc->chip.ngpio = be32_to_cpu(*ngpio);
+	gc->chip.direction_input = ralink_gpio_direction_input;
+	gc->chip.direction_output = ralink_gpio_direction_output;
+	gc->chip.get = ralink_gpio_get;
+	gc->chip.set = ralink_gpio_set;
+
+	/* set polarity to low for all lines */
+	rt_gpio_w32(gc, GPIO_REG_POL, 0);
+
+	dev_info(&pdev->dev, "registering %d gpios\n", gc->chip.ngpio);
+
+	return gpiochip_add(&gc->chip);
+}
+
+static const struct of_device_id ralink_gpio_match[] = {
+	{ .compatible = "ralink,rt2880-gpio" },
+	{},
+};
+MODULE_DEVICE_TABLE(of, ralink_gpio_match);
+
+static struct platform_driver ralink_gpio_driver = {
+	.probe = ralink_gpio_probe,
+	.driver = {
+		.name = "rt2880_gpio",
+		.owner = THIS_MODULE,
+		.of_match_table = ralink_gpio_match,
+	},
+};
+
+static int __init ralink_gpio_init(void)
+{
+	return platform_driver_register(&ralink_gpio_driver);
+}
+
+subsys_initcall(ralink_gpio_init);
-- 
1.7.10.4

