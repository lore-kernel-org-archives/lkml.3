Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759850Ab3DBEjq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 00:39:46 -0400
Received: from server.prisktech.co.nz ([115.188.14.127]:57219 "EHLO
	server.prisktech.co.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755411Ab3DBEjM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 00:39:12 -0400
From: Tony Prisk <linux@prisktech.co.nz>
To: linux.walleij@linaro.org
Cc: swarren@wwwdotorg.org, linux-arm-kernel@lists.infradead.org,
        vt8500-wm8505-linux-kernel@googlegroups.com,
        linux-kernel@vger.kernel.org, Tony Prisk <linux@prisktech.co.nz>
Subject: [PATCHv4 6/6] gpio: vt8500: Remove arch-vt8500 gpio driver
Date: Tue,  2 Apr 2013 17:39:10 +1300
Message-Id: <1364877550-25921-7-git-send-email-linux@prisktech.co.nz>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1364877550-25921-1-git-send-email-linux@prisktech.co.nz>
References: <1364877550-25921-1-git-send-email-linux@prisktech.co.nz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With the move to a combined pinctrl/gpio driver, the arch-vt8500
gpio driver is no longer required.

Signed-off-by: Tony Prisk <linux@prisktech.co.nz>
---
 .../devicetree/bindings/gpio/gpio-vt8500.txt       |   24 --
 drivers/gpio/Kconfig                               |    6 -
 drivers/gpio/Makefile                              |    1 -
 drivers/gpio/gpio-vt8500.c                         |  355 --------------------
 4 files changed, 386 deletions(-)
 delete mode 100644 Documentation/devicetree/bindings/gpio/gpio-vt8500.txt
 delete mode 100644 drivers/gpio/gpio-vt8500.c

diff --git a/Documentation/devicetree/bindings/gpio/gpio-vt8500.txt b/Documentation/devicetree/bindings/gpio/gpio-vt8500.txt
deleted file mode 100644
index f4dc523..0000000
--- a/Documentation/devicetree/bindings/gpio/gpio-vt8500.txt
+++ /dev/null
@@ -1,24 +0,0 @@
-VIA/Wondermedia VT8500 GPIO Controller
------------------------------------------------------
-
-Required properties:
-- compatible : "via,vt8500-gpio", "wm,wm8505-gpio"
-	or "wm,wm8650-gpio" depending on your SoC
-- reg : Should contain 1 register range (address and length)
-- #gpio-cells : should be <3>.
-	1) bank
-	2) pin number
-	3) flags - should be 0
-
-Example:
-
-	gpio: gpio-controller@d8110000 {
-		compatible = "via,vt8500-gpio";
-		gpio-controller;
-		reg = <0xd8110000 0x10000>;
-		#gpio-cells = <3>;
-	};
-
-	vibrate {
-		gpios = <&gpio 0 1 0>; /* Bank 0, Pin 1, No flags */
-	};
diff --git a/drivers/gpio/Kconfig b/drivers/gpio/Kconfig
index 93aaadf..b166e30 100644
--- a/drivers/gpio/Kconfig
+++ b/drivers/gpio/Kconfig
@@ -227,12 +227,6 @@ config GPIO_TS5500
 	  blocks of the TS-5500: DIO1, DIO2 and the LCD port, and the TS-5600
 	  LCD port.
 
-config GPIO_VT8500
-	bool "VIA/Wondermedia SoC GPIO Support"
-	depends on ARCH_VT8500
-	help
-	  Say yes here to support the VT8500/WM8505/WM8650 GPIO controller.
-
 config GPIO_XILINX
 	bool "Xilinx GPIO support"
 	depends on PPC_OF || MICROBLAZE
diff --git a/drivers/gpio/Makefile b/drivers/gpio/Makefile
index 22e07bc..a274d7d 100644
--- a/drivers/gpio/Makefile
+++ b/drivers/gpio/Makefile
@@ -80,7 +80,6 @@ obj-$(CONFIG_GPIO_TWL6040)	+= gpio-twl6040.o
 obj-$(CONFIG_GPIO_UCB1400)	+= gpio-ucb1400.o
 obj-$(CONFIG_GPIO_VIPERBOARD)	+= gpio-viperboard.o
 obj-$(CONFIG_GPIO_VR41XX)	+= gpio-vr41xx.o
-obj-$(CONFIG_GPIO_VT8500)	+= gpio-vt8500.o
 obj-$(CONFIG_GPIO_VX855)	+= gpio-vx855.o
 obj-$(CONFIG_GPIO_WM831X)	+= gpio-wm831x.o
 obj-$(CONFIG_GPIO_WM8350)	+= gpio-wm8350.o
diff --git a/drivers/gpio/gpio-vt8500.c b/drivers/gpio/gpio-vt8500.c
deleted file mode 100644
index 81683ca..0000000
--- a/drivers/gpio/gpio-vt8500.c
+++ /dev/null
@@ -1,355 +0,0 @@
-/* drivers/gpio/gpio-vt8500.c
- *
- * Copyright (C) 2012 Tony Prisk <linux@prisktech.co.nz>
- * Based on arch/arm/mach-vt8500/gpio.c:
- * - Copyright (C) 2010 Alexey Charkov <alchark@gmail.com>
- *
- * This software is licensed under the terms of the GNU General Public
- * License version 2, as published by the Free Software Foundation, and
- * may be copied, distributed, and modified under those terms.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- */
-
-#include <linux/module.h>
-#include <linux/err.h>
-#include <linux/io.h>
-#include <linux/gpio.h>
-#include <linux/platform_device.h>
-#include <linux/bitops.h>
-#include <linux/of.h>
-#include <linux/of_address.h>
-#include <linux/of_irq.h>
-#include <linux/of_device.h>
-
-/*
-	We handle GPIOs by bank, each bank containing up to 32 GPIOs covered
-	by one set of registers (although not all may be valid).
-
-	Because different SoC's have different register offsets, we pass the
-	register offsets as data in vt8500_gpio_dt_ids[].
-
-	A value of NO_REG is used to indicate that this register is not
-	supported. Only used for ->en at the moment.
-*/
-
-#define NO_REG	0xFFFF
-
-/*
- * struct vt8500_gpio_bank_regoffsets
- * @en: offset to enable register of the bank
- * @dir: offset to direction register of the bank
- * @data_out: offset to the data out register of the bank
- * @data_in: offset to the data in register of the bank
- * @ngpio: highest valid pin in this bank
- */
-
-struct vt8500_gpio_bank_regoffsets {
-	unsigned int	en;
-	unsigned int	dir;
-	unsigned int	data_out;
-	unsigned int	data_in;
-	unsigned char	ngpio;
-};
-
-struct vt8500_gpio_data {
-	unsigned int				num_banks;
-	struct vt8500_gpio_bank_regoffsets	banks[];
-};
-
-#define VT8500_BANK(__en, __dir, __out, __in, __ngpio)		\
-{								\
-	.en = __en,						\
-	.dir = __dir,						\
-	.data_out = __out,					\
-	.data_in = __in,					\
-	.ngpio = __ngpio,					\
-}
-
-static struct vt8500_gpio_data vt8500_data = {
-	.num_banks	= 7,
-	.banks	= {
-		VT8500_BANK(NO_REG, 0x3C, 0x5C, 0x7C, 9),
-		VT8500_BANK(0x00, 0x20, 0x40, 0x60, 26),
-		VT8500_BANK(0x04, 0x24, 0x44, 0x64, 28),
-		VT8500_BANK(0x08, 0x28, 0x48, 0x68, 31),
-		VT8500_BANK(0x0C, 0x2C, 0x4C, 0x6C, 19),
-		VT8500_BANK(0x10, 0x30, 0x50, 0x70, 19),
-		VT8500_BANK(0x14, 0x34, 0x54, 0x74, 23),
-	},
-};
-
-static struct vt8500_gpio_data wm8505_data = {
-	.num_banks	= 10,
-	.banks	= {
-		VT8500_BANK(0x64, 0x8C, 0xB4, 0xDC, 22),
-		VT8500_BANK(0x40, 0x68, 0x90, 0xB8, 8),
-		VT8500_BANK(0x44, 0x6C, 0x94, 0xBC, 32),
-		VT8500_BANK(0x48, 0x70, 0x98, 0xC0, 6),
-		VT8500_BANK(0x4C, 0x74, 0x9C, 0xC4, 16),
-		VT8500_BANK(0x50, 0x78, 0xA0, 0xC8, 25),
-		VT8500_BANK(0x54, 0x7C, 0xA4, 0xCC, 5),
-		VT8500_BANK(0x58, 0x80, 0xA8, 0xD0, 5),
-		VT8500_BANK(0x5C, 0x84, 0xAC, 0xD4, 12),
-		VT8500_BANK(0x60, 0x88, 0xB0, 0xD8, 16),
-		VT8500_BANK(0x500, 0x504, 0x508, 0x50C, 6),
-	},
-};
-
-/*
- * No information about which bits are valid so we just make
- * them all available until its figured out.
- */
-static struct vt8500_gpio_data wm8650_data = {
-	.num_banks	= 9,
-	.banks	= {
-		VT8500_BANK(0x40, 0x80, 0xC0, 0x00, 32),
-		VT8500_BANK(0x44, 0x84, 0xC4, 0x04, 32),
-		VT8500_BANK(0x48, 0x88, 0xC8, 0x08, 32),
-		VT8500_BANK(0x4C, 0x8C, 0xCC, 0x0C, 32),
-		VT8500_BANK(0x50, 0x90, 0xD0, 0x10, 32),
-		VT8500_BANK(0x54, 0x94, 0xD4, 0x14, 32),
-		VT8500_BANK(0x58, 0x98, 0xD8, 0x18, 32),
-		VT8500_BANK(0x5C, 0x9C, 0xDC, 0x1C, 32),
-		VT8500_BANK(0x7C, 0xBC, 0xFC, 0x3C, 32),
-		VT8500_BANK(0x500, 0x504, 0x508, 0x50C, 6),
-	},
-};
-
-struct vt8500_gpio_chip {
-	struct gpio_chip		chip;
-
-	const struct vt8500_gpio_bank_regoffsets *regs;
-	void __iomem	*base;
-};
-
-struct vt8500_data {
-	struct vt8500_gpio_chip *chip;
-	void __iomem *iobase;
-	int num_banks;
-};
-
-
-#define to_vt8500(__chip) container_of(__chip, struct vt8500_gpio_chip, chip)
-
-static int vt8500_gpio_request(struct gpio_chip *chip, unsigned offset)
-{
-	u32 val;
-	struct vt8500_gpio_chip *vt8500_chip = to_vt8500(chip);
-
-	if (vt8500_chip->regs->en == NO_REG)
-		return 0;
-
-	val = readl_relaxed(vt8500_chip->base + vt8500_chip->regs->en);
-	val |= BIT(offset);
-	writel_relaxed(val, vt8500_chip->base + vt8500_chip->regs->en);
-
-	return 0;
-}
-
-static void vt8500_gpio_free(struct gpio_chip *chip, unsigned offset)
-{
-	struct vt8500_gpio_chip *vt8500_chip = to_vt8500(chip);
-	u32 val;
-
-	if (vt8500_chip->regs->en == NO_REG)
-		return;
-
-	val = readl_relaxed(vt8500_chip->base + vt8500_chip->regs->en);
-	val &= ~BIT(offset);
-	writel_relaxed(val, vt8500_chip->base + vt8500_chip->regs->en);
-}
-
-static int vt8500_gpio_direction_input(struct gpio_chip *chip, unsigned offset)
-{
-	struct vt8500_gpio_chip *vt8500_chip = to_vt8500(chip);
-
-	u32 val = readl_relaxed(vt8500_chip->base + vt8500_chip->regs->dir);
-	val &= ~BIT(offset);
-	writel_relaxed(val, vt8500_chip->base + vt8500_chip->regs->dir);
-
-	return 0;
-}
-
-static int vt8500_gpio_direction_output(struct gpio_chip *chip, unsigned offset,
-								int value)
-{
-	struct vt8500_gpio_chip *vt8500_chip = to_vt8500(chip);
-
-	u32 val = readl_relaxed(vt8500_chip->base + vt8500_chip->regs->dir);
-	val |= BIT(offset);
-	writel_relaxed(val, vt8500_chip->base + vt8500_chip->regs->dir);
-
-	if (value) {
-		val = readl_relaxed(vt8500_chip->base +
-						vt8500_chip->regs->data_out);
-		val |= BIT(offset);
-		writel_relaxed(val, vt8500_chip->base +
-						vt8500_chip->regs->data_out);
-	}
-	return 0;
-}
-
-static int vt8500_gpio_get_value(struct gpio_chip *chip, unsigned offset)
-{
-	struct vt8500_gpio_chip *vt8500_chip = to_vt8500(chip);
-
-	return (readl_relaxed(vt8500_chip->base + vt8500_chip->regs->data_in) >>
-								offset) & 1;
-}
-
-static void vt8500_gpio_set_value(struct gpio_chip *chip, unsigned offset,
-								int value)
-{
-	struct vt8500_gpio_chip *vt8500_chip = to_vt8500(chip);
-
-	u32 val = readl_relaxed(vt8500_chip->base +
-						vt8500_chip->regs->data_out);
-	if (value)
-		val |= BIT(offset);
-	else
-		val &= ~BIT(offset);
-
-	writel_relaxed(val, vt8500_chip->base + vt8500_chip->regs->data_out);
-}
-
-static int vt8500_of_xlate(struct gpio_chip *gc,
-			    const struct of_phandle_args *gpiospec, u32 *flags)
-{
-	/* bank if specificed in gpiospec->args[0] */
-	if (flags)
-		*flags = gpiospec->args[2];
-
-	return gpiospec->args[1];
-}
-
-static int vt8500_add_chips(struct platform_device *pdev, void __iomem *base,
-				const struct vt8500_gpio_data *data)
-{
-	struct vt8500_data *priv;
-	struct vt8500_gpio_chip *vtchip;
-	struct gpio_chip *chip;
-	int i;
-	int pin_cnt = 0;
-
-	priv = devm_kzalloc(&pdev->dev, sizeof(struct vt8500_data), GFP_KERNEL);
-	if (!priv) {
-		dev_err(&pdev->dev, "failed to allocate memory\n");
-		return -ENOMEM;
-	}
-
-	priv->chip = devm_kzalloc(&pdev->dev,
-			sizeof(struct vt8500_gpio_chip) * data->num_banks,
-			GFP_KERNEL);
-	if (!priv->chip) {
-		dev_err(&pdev->dev, "failed to allocate chip memory\n");
-		return -ENOMEM;
-	}
-
-	priv->iobase = base;
-	priv->num_banks = data->num_banks;
-	platform_set_drvdata(pdev, priv);
-
-	vtchip = priv->chip;
-
-	for (i = 0; i < data->num_banks; i++) {
-		vtchip[i].base = base;
-		vtchip[i].regs = &data->banks[i];
-
-		chip = &vtchip[i].chip;
-
-		chip->of_xlate = vt8500_of_xlate;
-		chip->of_gpio_n_cells = 3;
-		chip->of_node = pdev->dev.of_node;
-
-		chip->request = vt8500_gpio_request;
-		chip->free = vt8500_gpio_free;
-		chip->direction_input = vt8500_gpio_direction_input;
-		chip->direction_output = vt8500_gpio_direction_output;
-		chip->get = vt8500_gpio_get_value;
-		chip->set = vt8500_gpio_set_value;
-		chip->can_sleep = 0;
-		chip->base = pin_cnt;
-		chip->ngpio = data->banks[i].ngpio;
-
-		pin_cnt += data->banks[i].ngpio;
-
-		gpiochip_add(chip);
-	}
-	return 0;
-}
-
-static struct of_device_id vt8500_gpio_dt_ids[] = {
-	{ .compatible = "via,vt8500-gpio", .data = &vt8500_data, },
-	{ .compatible = "wm,wm8505-gpio", .data = &wm8505_data, },
-	{ .compatible = "wm,wm8650-gpio", .data = &wm8650_data, },
-	{ /* Sentinel */ },
-};
-
-static int vt8500_gpio_probe(struct platform_device *pdev)
-{
-	int ret;
-	void __iomem *gpio_base;
-	struct resource *res;
-	const struct of_device_id *of_id =
-				of_match_device(vt8500_gpio_dt_ids, &pdev->dev);
-
-	if (!of_id) {
-		dev_err(&pdev->dev, "No matching driver data\n");
-		return -ENODEV;
-	}
-
-	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (!res) {
-		dev_err(&pdev->dev, "Unable to get IO resource\n");
-		return -ENODEV;
-	}
-
-	gpio_base = devm_request_and_ioremap(&pdev->dev, res);
-	if (!gpio_base) {
-		dev_err(&pdev->dev, "Unable to map GPIO registers\n");
-		return -ENOMEM;
-	}
-
-	ret = vt8500_add_chips(pdev, gpio_base, of_id->data);
-
-	return ret;
-}
-
-static int vt8500_gpio_remove(struct platform_device *pdev)
-{
-	int i;
-	int ret;
-	struct vt8500_data *priv = platform_get_drvdata(pdev);
-	struct vt8500_gpio_chip *vtchip = priv->chip;
-
-	for (i = 0; i < priv->num_banks; i++) {
-		ret = gpiochip_remove(&vtchip[i].chip);
-		if (ret)
-			dev_warn(&pdev->dev, "gpiochip_remove returned %d\n",
-				 ret);
-	}
-
-	return 0;
-}
-
-static struct platform_driver vt8500_gpio_driver = {
-	.probe		= vt8500_gpio_probe,
-	.remove		= vt8500_gpio_remove,
-	.driver		= {
-		.name	= "vt8500-gpio",
-		.owner	= THIS_MODULE,
-		.of_match_table = vt8500_gpio_dt_ids,
-	},
-};
-
-module_platform_driver(vt8500_gpio_driver);
-
-MODULE_DESCRIPTION("VT8500 GPIO Driver");
-MODULE_AUTHOR("Tony Prisk <linux@prisktech.co.nz>");
-MODULE_LICENSE("GPL v2");
-MODULE_DEVICE_TABLE(of, vt8500_gpio_dt_ids);
-- 
1.7.9.5

