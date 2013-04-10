Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964922Ab3DJPqH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 11:46:07 -0400
Received: from mail.abilis.ch ([195.70.19.74]:20676 "EHLO mail.abilis.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936879Ab3DJPqD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 11:46:03 -0400
From: Christian Ruppert <christian.ruppert@abilis.com>
To: linux-kernel@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Sascha Leuenberger <sascha.leuenberger@abilis.com>,
        Pierrick Hascoet <pierrick.hascoet@abilis.com>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        Christian Ruppert <christian.ruppert@abilis.com>
Subject: [PATCH 2/2] GPIO: Add TB10x GPIO driver
Date: Wed, 10 Apr 2013 17:45:28 +0200
Message-Id: <1365608728-30494-2-git-send-email-christian.ruppert@abilis.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1365608728-30494-1-git-send-email-christian.ruppert@abilis.com>
References: <1365608728-30494-1-git-send-email-christian.ruppert@abilis.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The GPIO driver for the Abilis Systems TB10x series of SOCs based on ARC700
CPUs. It supports GPIO control and GPIO interrupt generation. This driver
works in conjunction with the TB10x pinctrl driver.

Signed-off-by: Sascha Leuenberger <sascha.leuenberger@abilis.com>
Signed-off-by: Christian Ruppert <christian.ruppert@abilis.com>
---
 .../devicetree/bindings/gpio/abilis,tb10x-gpio.txt |   34 ++
 drivers/gpio/Kconfig                               |    4 +
 drivers/gpio/Makefile                              |    1 +
 drivers/gpio/gpio-tb10x.c                          |  445 ++++++++++++++++++++
 4 files changed, 484 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/gpio/abilis,tb10x-gpio.txt
 create mode 100644 drivers/gpio/gpio-tb10x.c

diff --git a/Documentation/devicetree/bindings/gpio/abilis,tb10x-gpio.txt b/Documentation/devicetree/bindings/gpio/abilis,tb10x-gpio.txt
new file mode 100644
index 0000000..d6eb650
--- /dev/null
+++ b/Documentation/devicetree/bindings/gpio/abilis,tb10x-gpio.txt
@@ -0,0 +1,34 @@
+* Abilis TB10x GPIO controller
+
+Required Properties:
+- compatible: Should be "abilis,tb10x-gpio"
+- reg: Address and length of the register set for the device
+- gpio-controller: Marks the device node as a gpio controller.
+- #gpio-cells: Should be <1>;
+- gpio-base: GPIO pin index of the first GPOI managed by this controller.
+- gpio-pins: Pointer to the pin configuration node inside an
+  "abilis,tb10x-iomux"-compatible pin controller this GPIO controller is
+  managing.
+
+Optional Properties:
+- interrupt-controller: Marks the device node as an interrupt controller.
+- #interrupt-cells: Should be <1>.
+- interrupts: Defines the interrupt line connecting this GPIO controller to
+  its parent interrupt controller.
+- interrupt-parent: Defines the parent interrupt controller.
+
+Example:
+
+gpioa: gpio@FF140000 {
+	compatible = "abilis,tb10x-gpio";
+	interrupt-controller;
+	#interrupt-cells = <1>;
+	interrupt-parent = <&tb10x_ictl>;
+	interrupts = <27 1>;
+	reg = <0xFF140000 0x1000>;
+	gpio-controller;
+	#gpio-cells = <1>;
+	gpio-count = <3>;
+	gpio-base  = <0>;
+	gpio-pins = <&pctl_gpio_a>;
+};
diff --git a/drivers/gpio/Kconfig b/drivers/gpio/Kconfig
index 93aaadf..7357dd5 100644
--- a/drivers/gpio/Kconfig
+++ b/drivers/gpio/Kconfig
@@ -309,6 +309,10 @@ config GPIO_LYNXPOINT
 	  driver for GPIO functionality on Intel Lynxpoint PCH chipset
 	  Requires ACPI device enumeration code to set up a platform device.
 
+config GPIO_TB10X
+	bool
+	depends on PINCTRL_TB10X
+
 comment "I2C GPIO expanders:"
 
 config GPIO_ARIZONA
diff --git a/drivers/gpio/Makefile b/drivers/gpio/Makefile
index 22e07bc..09b0cee 100644
--- a/drivers/gpio/Makefile
+++ b/drivers/gpio/Makefile
@@ -66,6 +66,7 @@ obj-$(CONFIG_GPIO_STA2X11)	+= gpio-sta2x11.o
 obj-$(CONFIG_GPIO_STMPE)	+= gpio-stmpe.o
 obj-$(CONFIG_GPIO_STP_XWAY)	+= gpio-stp-xway.o
 obj-$(CONFIG_GPIO_SX150X)	+= gpio-sx150x.o
+obj-$(CONFIG_GPIO_TB10X)	+= gpio-tb10x.o
 obj-$(CONFIG_GPIO_TC3589X)	+= gpio-tc3589x.o
 obj-$(CONFIG_ARCH_TEGRA)	+= gpio-tegra.o
 obj-$(CONFIG_GPIO_TIMBERDALE)	+= gpio-timberdale.o
diff --git a/drivers/gpio/gpio-tb10x.c b/drivers/gpio/gpio-tb10x.c
new file mode 100644
index 0000000..b78389b
--- /dev/null
+++ b/drivers/gpio/gpio-tb10x.c
@@ -0,0 +1,445 @@
+/* Abilis Systems MODULE DESCRIPTION
+ *
+ * Copyright (C) Abilis Systems 2013
+ *
+ * Authors: Sascha Leuenberger <sascha.leuenberger@abilis.com>
+ *          Christian Ruppert <christian.ruppert@abilis.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307 USA
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/platform_device.h>
+#include <linux/gpio.h>
+#include <linux/slab.h>
+#include <linux/irq.h>
+#include <linux/irqdomain.h>
+#include <linux/interrupt.h>
+#include <linux/io.h>
+#include <linux/of.h>
+#include <linux/of_platform.h>
+#include <linux/of_gpio.h>
+#include <linux/spinlock.h>
+#include <linux/pinctrl/consumer.h>
+#include <linux/pinctrl/pinctrl-tb10x.h>
+
+#define TB10X_GPIO_DIR_IN	(0x00000000)
+#define TB10X_GPIO_DIR_OUT	(0x00000001)
+#define OFFSET_TO_REG_DDR	(0x00)
+#define OFFSET_TO_REG_DATA	(0x04)
+#define OFFSET_TO_REG_INT_EN	(0x08)
+#define OFFSET_TO_REG_CHANGE	(0x0C)
+#define OFFSET_TO_REG_WRMASK	(0x10)
+#define OFFSET_TO_REG_INT_TYPE	(0x14)
+
+struct tb10x_gpio {
+	spinlock_t spinlock;
+	void __iomem *regs;
+	struct irq_domain *domain;
+	int irq;
+	struct gpio_chip gc;
+	struct pinctrl_gpio_range gr;
+};
+
+static inline u32 tb10x_reg_read(struct tb10x_gpio *gpio, unsigned int offs)
+{
+	return ioread32(gpio->regs + offs);
+}
+
+static inline void tb10x_reg_write(struct tb10x_gpio *gpio, unsigned int offs,
+				u32 val)
+{
+	iowrite32(val, gpio->regs + offs);
+}
+
+static inline void tb10x_set_bits(struct tb10x_gpio *gpio, unsigned int offs,
+				u32 mask, u32 val)
+{
+	u32 r;
+	unsigned long flags;
+
+	spin_lock_irqsave(&gpio->spinlock, flags);
+	r = tb10x_reg_read(gpio, offs);
+	r = (r & ~mask) | (val & mask);
+	tb10x_reg_write(gpio, offs, r);
+	spin_unlock_irqrestore(&gpio->spinlock, flags);
+}
+
+static inline struct tb10x_gpio *to_tb10x_gpio(struct gpio_chip *chip)
+{
+	return container_of(chip, struct tb10x_gpio, gc);
+}
+
+static int tb10x_gpio_direction_in(struct gpio_chip *chip, unsigned offset)
+{
+	struct tb10x_gpio *tb10x_gpio = to_tb10x_gpio(chip);
+	int mask = 1 << offset;
+	int val = TB10X_GPIO_DIR_IN << offset;
+
+	tb10x_set_bits(tb10x_gpio, OFFSET_TO_REG_DDR, mask, val);
+
+	return 0;
+}
+
+static int tb10x_gpio_get(struct gpio_chip *chip, unsigned offset)
+{
+	struct tb10x_gpio *tb10x_gpio = to_tb10x_gpio(chip);
+	int val;
+
+	val = tb10x_reg_read(tb10x_gpio, OFFSET_TO_REG_DATA);
+
+	if (val & 1 << offset)
+		return 1;
+	else
+		return 0;
+}
+
+static void tb10x_gpio_set(struct gpio_chip *chip, unsigned offset, int value)
+{
+	struct tb10x_gpio *tb10x_gpio = to_tb10x_gpio(chip);
+	int mask = 1 << offset;
+	int val = value << offset;
+
+	tb10x_set_bits(tb10x_gpio, OFFSET_TO_REG_DATA, mask, val);
+}
+
+static int tb10x_gpio_direction_out(struct gpio_chip *chip,
+					unsigned offset, int value)
+{
+	struct tb10x_gpio *tb10x_gpio = to_tb10x_gpio(chip);
+	int mask = 1 << offset;
+	int val = TB10X_GPIO_DIR_OUT << offset;
+
+	tb10x_set_bits(tb10x_gpio, OFFSET_TO_REG_DDR, mask, val);
+
+	return 0;
+}
+
+static int tb10x_gpio_request(struct gpio_chip *chip, unsigned offset)
+{
+	return pinctrl_request_gpio(chip->base + offset);
+}
+
+static void tb10x_gpio_free(struct gpio_chip *chip, unsigned offset)
+{
+	pinctrl_free_gpio(chip->base + offset);
+}
+
+static int tb10x_gpio_to_irq(struct gpio_chip *chip, unsigned offset)
+{
+	struct tb10x_gpio *tb10x_gpio = to_tb10x_gpio(chip);
+	return irq_create_mapping(tb10x_gpio->domain, offset);
+}
+
+#ifdef CONFIG_OF_GPIO
+static int tb10x_gpio_xlate(struct gpio_chip *chip,
+			const struct of_phandle_args *gpiospec, u32 *flags)
+{
+	return gpiospec->args[0];
+}
+#endif
+
+static void tb10x_gpio_irq_ack(struct irq_data *data)
+{
+	struct tb10x_gpio *tb10x_gpio = irq_data_get_irq_chip_data(data);
+	unsigned int hwirq = irqd_to_hwirq(data);
+	tb10x_reg_write(tb10x_gpio, OFFSET_TO_REG_CHANGE, 0x1 << hwirq);
+}
+
+static void tb10x_gpio_irq_unmask(struct irq_data *data)
+{
+	struct tb10x_gpio *tb10x_gpio = irq_data_get_irq_chip_data(data);
+	unsigned int hwirq = irqd_to_hwirq(data);
+	u32 m = 0x1 << hwirq;
+	u32 r = tb10x_reg_read(tb10x_gpio, OFFSET_TO_REG_INT_EN);
+	tb10x_reg_write(tb10x_gpio, OFFSET_TO_REG_CHANGE, m);
+	tb10x_reg_write(tb10x_gpio, OFFSET_TO_REG_INT_EN, r | m);
+}
+
+static void tb10x_gpio_irq_mask(struct irq_data *data)
+{
+	struct tb10x_gpio *tb10x_gpio = irq_data_get_irq_chip_data(data);
+	unsigned int hwirq = irqd_to_hwirq(data);
+	u32 m = 0x1 << hwirq;
+	u32 r = tb10x_reg_read(tb10x_gpio, OFFSET_TO_REG_INT_EN);
+	tb10x_reg_write(tb10x_gpio, OFFSET_TO_REG_INT_EN, r & ~m);
+}
+
+static int tb10x_gpio_irq_set_type(struct irq_data *data, unsigned int type)
+{
+	if ((type & IRQF_TRIGGER_MASK) != IRQ_TYPE_EDGE_BOTH) {
+		pr_err("Cannot assign multiple trigger modes to GPIO IRQ.\n");
+		return -EINVAL;
+	}
+
+	irqd_set_trigger_type(data, type);
+
+	return IRQ_SET_MASK_OK;
+}
+
+static struct irq_chip irq_tb10x_gpio_chip = {
+	.name          = "TB10x-GPIO",
+	.irq_ack       = tb10x_gpio_irq_ack,
+	.irq_mask      = tb10x_gpio_irq_mask,
+	.irq_unmask    = tb10x_gpio_irq_unmask,
+	.irq_set_type  = tb10x_gpio_irq_set_type,
+};
+
+static int tb10x_gpio_irq_map(struct irq_domain *d, unsigned int irq,
+				irq_hw_number_t hw)
+{
+	irq_set_chip_data(irq, d->host_data);
+	irq_set_chip_and_handler(irq, &irq_tb10x_gpio_chip, handle_level_irq);
+
+	return 0;
+}
+
+static struct irq_domain_ops irq_tb10x_gpio_domain_ops = {
+	.map	= tb10x_gpio_irq_map,
+	.xlate	= irq_domain_xlate_onecell,
+};
+
+static irqreturn_t tb10x_gpio_irq_cascade(int irq, void *data)
+{
+	struct tb10x_gpio *tb10x_gpio = data;
+	u32 r = tb10x_reg_read(tb10x_gpio, OFFSET_TO_REG_CHANGE);
+	u32 m = tb10x_reg_read(tb10x_gpio, OFFSET_TO_REG_INT_EN);
+	int i;
+	for (i = 0; i < 32; i++)
+		if (r & m & (1L << i))
+			generic_handle_irq(irq_find_mapping(tb10x_gpio->domain,
+								i));
+	return IRQ_HANDLED;
+}
+
+static int tb10x_gpio_probe(struct platform_device *pdev)
+{
+	struct tb10x_gpio *tb10x_gpio;
+	struct resource *mem;
+	struct device_node *dn = pdev->dev.of_node;
+	int ret = -EBUSY;
+	u32 base;
+	u32 phandle;
+	struct device_node *pstate;
+	struct pinctrl *pctl;
+	struct tb10x_pinfuncgrp *pfg;
+
+	if (!dn)
+		return -EINVAL;
+
+	if (of_property_read_u32(dn, "gpio-base", &base))
+		return -EINVAL;
+
+	mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!mem) {
+		dev_err(&pdev->dev, "No memory resource defined.\n");
+		return -EINVAL;
+	}
+
+	tb10x_gpio = kzalloc(sizeof(*tb10x_gpio), GFP_KERNEL);
+	if (tb10x_gpio == NULL)
+		return -ENOMEM;
+
+	spin_lock_init(&tb10x_gpio->spinlock);
+
+	if (!request_mem_region(mem->start, resource_size(mem), pdev->name)) {
+		dev_err(&pdev->dev, "Request reg region failed.\n");
+		goto fail_reg_req;
+	}
+
+	tb10x_gpio->regs = ioremap(mem->start, resource_size(mem));
+	if (!tb10x_gpio->regs) {
+		dev_err(&pdev->dev, "Could not remap reg space.\n");
+		goto fail_ioremap;
+	}
+
+	tb10x_gpio->gc.label		= of_node_full_name(dn);
+	tb10x_gpio->gc.dev		= &pdev->dev;
+	tb10x_gpio->gc.owner		= THIS_MODULE;
+	tb10x_gpio->gc.direction_input	= tb10x_gpio_direction_in;
+	tb10x_gpio->gc.get		= tb10x_gpio_get;
+	tb10x_gpio->gc.direction_output	= tb10x_gpio_direction_out;
+	tb10x_gpio->gc.set		= tb10x_gpio_set;
+	tb10x_gpio->gc.request		= tb10x_gpio_request;
+	tb10x_gpio->gc.free		= tb10x_gpio_free;
+#ifdef CONFIG_OF_GPIO
+	tb10x_gpio->gc.of_xlate		= tb10x_gpio_xlate;
+	tb10x_gpio->gc.of_gpio_n_cells	= 1;
+#endif
+
+	tb10x_gpio->gc.can_sleep	= 0;
+
+	tb10x_gpio->gc.base		= base;
+
+	if (of_find_property(dn, "pinctrl-0", NULL)) {
+		int idx, len;
+		const __be32 *prop;
+
+		idx = of_property_match_string(dn, "pinctrl-names",
+						PINCTRL_STATE_DEFAULT);
+		if (idx < 0) {
+			ret = idx;
+			goto fail_pinctrl_setup;
+		}
+
+		prop = of_get_property(dn, "pinctrl-0", &len);
+		if (IS_ERR(prop)) {
+			ret = PTR_ERR(prop);
+			goto fail_pinctrl_setup;
+		}
+
+		if (len <= idx) {
+			ret = -EINVAL;
+			goto fail_pinctrl_setup;
+		}
+		phandle = be32_to_cpu(prop[idx]);
+
+		pctl = devm_pinctrl_get_select_default(&pdev->dev);
+		if (IS_ERR(pctl)) {
+			ret = PTR_ERR(pctl);
+			dev_err(&pdev->dev, "Could not set up pinctrl: %d\n",
+				ret);
+			goto fail_pinctrl_setup;
+		}
+	} else {
+		ret = of_property_read_u32(dn, "gpio-pins", &phandle);
+		if (ret)
+			goto fail_pinctrl_setup;
+	}
+
+	pstate = of_find_node_by_phandle(phandle);
+	if (!pstate) {
+		ret = -EINVAL;
+		goto fail_pinctrl_setup;
+	}
+	of_node_put(pstate);
+
+	pfg = tb10x_prepare_gpio_range(pstate, &tb10x_gpio->gr);
+	if (IS_ERR(pfg)) {
+		ret = PTR_ERR(pfg);
+		goto fail_pinctrl_setup;
+	}
+
+	tb10x_gpio->gc.ngpio	= tb10x_gpio->gr.npins;
+
+	tb10x_gpio->gr.name	= of_node_full_name(dn);
+	tb10x_gpio->gr.id	= 0;
+	tb10x_gpio->gr.base	= base;
+	tb10x_gpio->gr.gc	= &tb10x_gpio->gc;
+
+	ret = gpiochip_add(&tb10x_gpio->gc);
+	if (ret < 0) {
+		dev_err(&pdev->dev, "Could not add gpiochip.\n");
+		goto fail_gpiochip_registration;
+	}
+
+	tb10x_setup_gpio_range(pfg, &tb10x_gpio->gr);
+
+	platform_set_drvdata(pdev, tb10x_gpio);
+
+	if (of_find_property(dn, "interrupt-controller", NULL)) {
+		ret = platform_get_irq(pdev, 0);
+		if (ret < 0) {
+			dev_err(&pdev->dev, "No interrupt specified.\n");
+			goto fail_get_irq;
+		}
+		tb10x_gpio->gc.to_irq	= tb10x_gpio_to_irq;
+		tb10x_gpio->irq		= ret;
+		ret = request_irq(ret, tb10x_gpio_irq_cascade,
+				IRQF_TRIGGER_FALLING | IRQF_SHARED,
+				dev_name(&pdev->dev), tb10x_gpio);
+		if (ret != 0)
+			goto fail_request_irq;
+
+		tb10x_gpio->domain = irq_domain_add_linear(dn,
+						tb10x_gpio->gr.npins,
+						&irq_tb10x_gpio_domain_ops,
+						tb10x_gpio);
+		if (!tb10x_gpio->domain) {
+			ret = -ENOMEM;
+			goto fail_irq_domain;
+		}
+	}
+
+	return 0;
+
+fail_irq_domain:
+	free_irq(tb10x_gpio->irq, tb10x_gpio);
+fail_request_irq:
+fail_get_irq:
+	ret = gpiochip_remove(&tb10x_gpio->gc);
+fail_gpiochip_registration:
+fail_pinctrl_setup:
+	iounmap(tb10x_gpio->regs);
+fail_ioremap:
+	release_mem_region(mem->start, resource_size(mem));
+fail_reg_req:
+	kfree(tb10x_gpio);
+
+	return ret;
+}
+
+static int __exit tb10x_gpio_remove(struct platform_device *pdev)
+{
+	struct tb10x_gpio *tb10x_gpio = platform_get_drvdata(pdev);
+	struct resource *mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	int ret;
+
+	if (tb10x_gpio->gc.to_irq) {
+		irq_domain_remove(tb10x_gpio->domain);
+		free_irq(tb10x_gpio->irq, tb10x_gpio);
+	}
+	ret = gpiochip_remove(&tb10x_gpio->gc);
+	if (ret)
+		return ret;
+
+	iounmap(tb10x_gpio->regs);
+	release_mem_region(mem->start, resource_size(mem));
+	kfree(tb10x_gpio);
+
+	return 0;
+}
+
+static const struct of_device_id tb10x_gpio_dt_ids[] = {
+	{ .compatible = "abilis,tb10x-gpio" },
+	{ }
+};
+MODULE_DEVICE_TABLE(of, tb10x_gpio_dt_ids);
+
+static struct platform_driver tb10x_gpio_driver = {
+	.probe		= tb10x_gpio_probe,
+	.remove		= tb10x_gpio_remove,
+	.driver = {
+		.name	= "tb10x-gpio",
+		.of_match_table = of_match_ptr(tb10x_gpio_dt_ids),
+		.owner	= THIS_MODULE,
+	}
+};
+
+static int __init ab_gpio_init(void)
+{
+	return platform_driver_register(&tb10x_gpio_driver);
+}
+
+static void __exit ab_gpio_exit(void)
+{
+	platform_driver_unregister(&tb10x_gpio_driver);
+}
+
+module_init(ab_gpio_init);
+module_exit(ab_gpio_exit);
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("tb10x gpio.");
+MODULE_VERSION("0.0.1");
-- 
1.7.1

