Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756851Ab3EXQWl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 May 2013 12:22:41 -0400
Received: from multi.imgtec.com ([194.200.65.239]:59967 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756773Ab3EXQW1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 May 2013 12:22:27 -0400
From: James Hogan <james.hogan@imgtec.com>
To: <linux-kernel@vger.kernel.org>
CC: James Hogan <james.hogan@imgtec.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, "Rob Landley" <rob@landley.net>,
        Linus Walleij <linus.walleij@linaro.org>, <linux-doc@vger.kernel.org>,
        <devicetree-discuss@lists.ozlabs.org>
Subject: [PATCH v2 9/9] gpio-tz1090-pdc: add TZ1090 PDC gpio driver
Date: Fri, 24 May 2013 17:21:16 +0100
Message-ID: <1369412476-14245-10-git-send-email-james.hogan@imgtec.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1369412476-14245-1-git-send-email-james.hogan@imgtec.com>
References: <1369412476-14245-1-git-send-email-james.hogan@imgtec.com>
MIME-Version: 1.0
Content-Type: text/plain
X-SEF-Processed: 7_3_0_01181__2013_05_24_17_22_18
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a GPIO driver for the low-power Powerdown Controller GPIOs in the
TZ1090 SoC.

The driver is instantiated by device tree and supports interrupts for
the SysWake GPIOs only.

Signed-off-by: James Hogan <james.hogan@imgtec.com>
Cc: Grant Likely <grant.likely@secretlab.ca>
Cc: Rob Herring <rob.herring@calxeda.com>
Cc: Rob Landley <rob@landley.net>
Cc: Linus Walleij <linus.walleij@linaro.org>
Cc: linux-doc@vger.kernel.org
Cc: devicetree-discuss@lists.ozlabs.org
---
Changes in v2:
 - gpio-tz1090-pdc: remove references to Linux flags in dt bindings
 - gpio-tz1090-pdc: make use of BIT() from linux/bitops.h
 - gpio-tz1090-pdc: make register accessors inline to match pinctrl
 - gpio-tz1090-pdc: update gpio-ranges to use 3 cells after recent ABI
   breakage

 .../devicetree/bindings/gpio/gpio-tz1090-pdc.txt   |  41 ++++
 arch/metag/boot/dts/tz1090.dtsi                    |  14 ++
 drivers/gpio/Kconfig                               |   7 +
 drivers/gpio/Makefile                              |   1 +
 drivers/gpio/gpio-tz1090-pdc.c                     | 242 +++++++++++++++++++++
 5 files changed, 305 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/gpio/gpio-tz1090-pdc.txt
 create mode 100644 drivers/gpio/gpio-tz1090-pdc.c

diff --git a/Documentation/devicetree/bindings/gpio/gpio-tz1090-pdc.txt b/Documentation/devicetree/bindings/gpio/gpio-tz1090-pdc.txt
new file mode 100644
index 0000000..a0e5eeb
--- /dev/null
+++ b/Documentation/devicetree/bindings/gpio/gpio-tz1090-pdc.txt
@@ -0,0 +1,41 @@
+ImgTec TZ1090 PDC GPIO Controller
+
+Required properties:
+- compatible: Compatible property value should be "img,tz1090-pdc-gpio>".
+
+- reg: Physical base address of the controller and length of memory mapped
+  region. This starts at and cover the SOC_GPIO_CONTROL registers.
+
+- gpio-controller: Specifies that the node is a gpio controller.
+
+- #gpio-cells: Should be 2. The syntax of the gpio specifier used by client
+  nodes should have the following values.
+     <[phandle of the gpio controller node]
+      [PDC gpio number]
+      [gpio flags]>
+
+  Values for gpio specifier:
+  - GPIO number: a value in the range 0 to 6.
+  - GPIO flags: bit field of flags:
+      1: active low
+
+Optional properties:
+- gpio-ranges: Mapping to pin controller pins
+
+- interrupts: Individual syswake interrupts (other GPIOs cannot interrupt)
+
+
+Example:
+
+	pdc_gpios: gpio-controller@02006500 {
+		gpio-controller;
+		#gpio-cells = <2>;
+
+		compatible = "img,tz1090-pdc-gpio";
+		reg = <0x02006500 0x100>;
+
+		interrupt-parent = <&pdc>;
+		interrupts =	<1 0 0>,	/* Syswake 0 */
+				<1 1 0>,	/* Syswake 1 */
+				<1 2 0>;	/* Syswake 2 */
+	};
diff --git a/arch/metag/boot/dts/tz1090.dtsi b/arch/metag/boot/dts/tz1090.dtsi
index e2e61a8..4975e10 100644
--- a/arch/metag/boot/dts/tz1090.dtsi
+++ b/arch/metag/boot/dts/tz1090.dtsi
@@ -88,5 +88,19 @@
 				gpio-ranges = <&pinctrl 0 60 30>;
 			};
 		};
+
+		pdc_gpios: gpios@02006500 {
+			gpio-controller;
+			#gpio-cells = <2>;
+
+			compatible = "img,tz1090-pdc-gpio";
+			reg = <0x02006500 0x100>;
+
+			interrupt-parent = <&pdc>;
+			interrupts =	<1 0 0>,	/* Syswake 0 */
+					<1 1 0>,	/* Syswake 1 */
+					<1 2 0>;	/* Syswake 2 */
+			gpio-ranges = <&pdc_pinctrl 0 0 7>;
+		};
 	};
 };
diff --git a/drivers/gpio/Kconfig b/drivers/gpio/Kconfig
index 49e4f67..5cfae04 100644
--- a/drivers/gpio/Kconfig
+++ b/drivers/gpio/Kconfig
@@ -239,6 +239,13 @@ config GPIO_TZ1090
 	help
 	  Say yes here to support Toumaz Xenif TZ1090 GPIOs.
 
+config GPIO_TZ1090_PDC
+	bool "Toumaz Xenif TZ1090 PDC GPIO support"
+	depends on SOC_TZ1090
+	default y
+	help
+	  Say yes here to support Toumaz Xenif TZ1090 PDC GPIOs.
+
 config GPIO_XILINX
 	bool "Xilinx GPIO support"
 	depends on PPC_OF || MICROBLAZE
diff --git a/drivers/gpio/Makefile b/drivers/gpio/Makefile
index 37bdc1e..44341c7 100644
--- a/drivers/gpio/Makefile
+++ b/drivers/gpio/Makefile
@@ -80,6 +80,7 @@ obj-$(CONFIG_GPIO_TS5500)	+= gpio-ts5500.o
 obj-$(CONFIG_GPIO_TWL4030)	+= gpio-twl4030.o
 obj-$(CONFIG_GPIO_TWL6040)	+= gpio-twl6040.o
 obj-$(CONFIG_GPIO_TZ1090)	+= gpio-tz1090.o
+obj-$(CONFIG_GPIO_TZ1090_PDC)	+= gpio-tz1090-pdc.o
 obj-$(CONFIG_GPIO_UCB1400)	+= gpio-ucb1400.o
 obj-$(CONFIG_GPIO_VIPERBOARD)	+= gpio-viperboard.o
 obj-$(CONFIG_GPIO_VR41XX)	+= gpio-vr41xx.o
diff --git a/drivers/gpio/gpio-tz1090-pdc.c b/drivers/gpio/gpio-tz1090-pdc.c
new file mode 100644
index 0000000..85fed6a
--- /dev/null
+++ b/drivers/gpio/gpio-tz1090-pdc.c
@@ -0,0 +1,242 @@
+/*
+ * Toumaz Xenif TZ1090 PDC GPIO handling.
+ *
+ * Copyright (C) 2012-2013 Imagination Technologies Ltd.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/bitops.h>
+#include <linux/gpio.h>
+#include <linux/io.h>
+#include <linux/module.h>
+#include <linux/of_irq.h>
+#include <linux/pinctrl/consumer.h>
+#include <linux/platform_device.h>
+#include <linux/slab.h>
+#include <linux/syscore_ops.h>
+#include <asm/global_lock.h>
+
+/* Register offsets from SOC_GPIO_CONTROL0 */
+#define REG_SOC_GPIO_CONTROL0	0x00
+#define REG_SOC_GPIO_CONTROL1	0x04
+#define REG_SOC_GPIO_CONTROL2	0x08
+#define REG_SOC_GPIO_CONTROL3	0x0c
+#define REG_SOC_GPIO_STATUS	0x80
+
+/* PDC GPIOs go after normal GPIOs */
+#define GPIO_PDC_BASE		90
+#define GPIO_PDC_NGPIO		7
+
+/* Out of PDC gpios, only syswakes have irqs */
+#define GPIO_PDC_IRQ_FIRST	2
+#define GPIO_PDC_NIRQ		3
+
+/**
+ * struct tz1090_pdc_gpio - GPIO bank private data
+ * @chip:	Generic GPIO chip for GPIO bank
+ * @reg:	Base of registers, offset for this GPIO bank
+ * @irq:	IRQ numbers for Syswake GPIOs
+ *
+ * This is the main private data for the PDC GPIO driver. It encapsulates a
+ * gpio_chip, and the callbacks for the gpio_chip can access the private data
+ * with the to_pdc() macro below.
+ */
+struct tz1090_pdc_gpio {
+	struct gpio_chip chip;
+	void __iomem *reg;
+	int irq[GPIO_PDC_NIRQ];
+};
+#define to_pdc(c)	container_of(c, struct tz1090_pdc_gpio, chip)
+
+/* Register accesses into the PDC MMIO area */
+
+static inline void pdc_write(struct tz1090_pdc_gpio *priv, unsigned int reg_offs,
+		      unsigned int data)
+{
+	writel(data, priv->reg + reg_offs);
+}
+
+static inline unsigned int pdc_read(struct tz1090_pdc_gpio *priv,
+			     unsigned int reg_offs)
+{
+	return readl(priv->reg + reg_offs);
+}
+
+/* Generic GPIO interface */
+
+static int tz1090_pdc_gpio_direction_input(struct gpio_chip *chip,
+					   unsigned offset)
+{
+	struct tz1090_pdc_gpio *priv = to_pdc(chip);
+	u32 value;
+	int lstat;
+
+	__global_lock2(lstat);
+	value = pdc_read(priv, REG_SOC_GPIO_CONTROL1);
+	value |= BIT(offset);
+	pdc_write(priv, REG_SOC_GPIO_CONTROL1, value);
+	__global_unlock2(lstat);
+
+	return 0;
+}
+
+static int tz1090_pdc_gpio_direction_output(struct gpio_chip *chip,
+					    unsigned offset, int output_value)
+{
+	struct tz1090_pdc_gpio *priv = to_pdc(chip);
+	u32 value;
+	int lstat;
+
+	__global_lock2(lstat);
+	/* EXT_POWER doesn't seem to have an output value bit */
+	if (offset < 6) {
+		value = pdc_read(priv, REG_SOC_GPIO_CONTROL0);
+		if (output_value)
+			value |= BIT(offset);
+		else
+			value &= ~BIT(offset);
+		pdc_write(priv, REG_SOC_GPIO_CONTROL0, value);
+	}
+
+	value = pdc_read(priv, REG_SOC_GPIO_CONTROL1);
+	value &= ~BIT(offset);
+	pdc_write(priv, REG_SOC_GPIO_CONTROL1, value);
+	__global_unlock2(lstat);
+
+	return 0;
+}
+
+static int tz1090_pdc_gpio_get(struct gpio_chip *chip, unsigned offset)
+{
+	struct tz1090_pdc_gpio *priv = to_pdc(chip);
+	return pdc_read(priv, REG_SOC_GPIO_STATUS) & BIT(offset);
+}
+
+static void tz1090_pdc_gpio_set(struct gpio_chip *chip, unsigned offset,
+				int output_value)
+{
+	struct tz1090_pdc_gpio *priv = to_pdc(chip);
+	u32 value;
+	int lstat;
+
+	/* EXT_POWER doesn't seem to have an output value bit */
+	if (offset >= 6)
+		return;
+
+	__global_lock2(lstat);
+	value = pdc_read(priv, REG_SOC_GPIO_CONTROL0);
+	if (output_value)
+		value |= BIT(offset);
+	else
+		value &= ~BIT(offset);
+	pdc_write(priv, REG_SOC_GPIO_CONTROL0, value);
+	__global_unlock2(lstat);
+}
+
+static int tz1090_pdc_gpio_request(struct gpio_chip *chip, unsigned offset)
+{
+	return pinctrl_request_gpio(chip->base + offset);
+}
+
+static void tz1090_pdc_gpio_free(struct gpio_chip *chip, unsigned offset)
+{
+	pinctrl_free_gpio(chip->base + offset);
+}
+
+static int tz1090_pdc_gpio_to_irq(struct gpio_chip *chip, unsigned offset)
+{
+	struct tz1090_pdc_gpio *priv = to_pdc(chip);
+	unsigned int syswake = offset - GPIO_PDC_IRQ_FIRST;
+	int irq;
+
+	/* only syswakes have irqs */
+	if (syswake >= GPIO_PDC_NIRQ)
+		return -EINVAL;
+
+	irq = priv->irq[syswake];
+	if (!irq)
+		return -EINVAL;
+
+	return irq;
+}
+
+static int tz1090_pdc_gpio_probe(struct platform_device *pdev)
+{
+	struct device_node *np = pdev->dev.of_node;
+	struct resource *res_regs;
+	struct tz1090_pdc_gpio *priv;
+	unsigned int i;
+
+	if (!np) {
+		dev_err(&pdev->dev, "must be instantiated via devicetree\n");
+		return -ENOENT;
+	}
+
+	res_regs = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!res_regs) {
+		dev_err(&pdev->dev, "cannot find registers resource\n");
+		return -ENOENT;
+	}
+
+	priv = devm_kzalloc(&pdev->dev, sizeof(*priv), GFP_KERNEL);
+	if (!priv) {
+		dev_err(&pdev->dev, "unable to allocate driver data\n");
+		return -ENOMEM;
+	}
+
+	/* Ioremap the registers */
+	priv->reg = devm_ioremap(&pdev->dev, res_regs->start,
+				 res_regs->end - res_regs->start);
+	if (!priv->reg) {
+		dev_err(&pdev->dev, "unable to ioremap registers\n");
+		return -ENOMEM;
+	}
+
+	/* Set up GPIO chip */
+	priv->chip.label		= "tz1090-pdc-gpio";
+	priv->chip.dev			= &pdev->dev;
+	priv->chip.direction_input	= tz1090_pdc_gpio_direction_input;
+	priv->chip.direction_output	= tz1090_pdc_gpio_direction_output;
+	priv->chip.get			= tz1090_pdc_gpio_get;
+	priv->chip.set			= tz1090_pdc_gpio_set;
+	priv->chip.free			= tz1090_pdc_gpio_free;
+	priv->chip.request		= tz1090_pdc_gpio_request;
+	priv->chip.to_irq		= tz1090_pdc_gpio_to_irq;
+	priv->chip.of_node		= np;
+
+	/* GPIO numbering */
+	priv->chip.base			= GPIO_PDC_BASE;
+	priv->chip.ngpio		= GPIO_PDC_NGPIO;
+
+	/* Map the syswake irqs */
+	for (i = 0; i < GPIO_PDC_NIRQ; ++i)
+		priv->irq[i] = irq_of_parse_and_map(np, i);
+
+	/* Add the GPIO bank */
+	gpiochip_add(&priv->chip);
+
+	return 0;
+}
+
+static struct of_device_id tz1090_pdc_gpio_of_match[] = {
+	{ .compatible = "img,tz1090-pdc-gpio" },
+	{ },
+};
+
+static struct platform_driver tz1090_pdc_gpio_driver = {
+	.driver = {
+		.name		= "tz1090-pdc-gpio",
+		.owner		= THIS_MODULE,
+		.of_match_table	= tz1090_pdc_gpio_of_match,
+	},
+	.probe		= tz1090_pdc_gpio_probe,
+};
+
+static int __init tz1090_pdc_gpio_init(void)
+{
+	return platform_driver_register(&tz1090_pdc_gpio_driver);
+}
+postcore_initcall(tz1090_pdc_gpio_init);
-- 
1.8.1.2


