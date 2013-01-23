Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754389Ab3AWJeV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 04:34:21 -0500
Received: from mail.free-electrons.com ([94.23.35.102]:35319 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753929Ab3AWJeT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 04:34:19 -0500
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, Alejandro Mery <amery@geeks.cl>,
        Stefan Roese <sr@denx.de>, linux-kernel@vger.kernel.org
Subject: [PATCH] ARM: sunxi: gpio: Add Allwinner SoCs GPIO drivers
Date: Wed, 23 Jan 2013 10:34:06 +0100
Message-Id: <1358933646-12681-2-git-send-email-maxime.ripard@free-electrons.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1358933646-12681-1-git-send-email-maxime.ripard@free-electrons.com>
References: <1358933646-12681-1-git-send-email-maxime.ripard@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The IP responsible for the muxing on the Allwinner SoCs are also
handling the GPIOs on the system. This patch adds the needed driver that
relies on the pinctrl driver for most of its operations.

The number of pins available for GPIOs operations are already declared
in the pinctrl driver, we only need to probe a generic driver to handle
the banks available for each SoC.

This driver has been tested on a A13-Olinuxino.

Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
---
 drivers/pinctrl/pinctrl-sunxi.c |  138 ++++++++++++++++++++++++++++++++++++++-
 drivers/pinctrl/pinctrl-sunxi.h |   23 ++++++-
 2 files changed, 158 insertions(+), 3 deletions(-)

diff --git a/drivers/pinctrl/pinctrl-sunxi.c b/drivers/pinctrl/pinctrl-sunxi.c
index 6f02e34..bfca9e1 100644
--- a/drivers/pinctrl/pinctrl-sunxi.c
+++ b/drivers/pinctrl/pinctrl-sunxi.c
@@ -11,6 +11,7 @@
  */
 
 #include <linux/io.h>
+#include <linux/gpio.h>
 #include <linux/module.h>
 #include <linux/of.h>
 #include <linux/of_address.h>
@@ -609,11 +610,57 @@ static int sunxi_pmx_enable(struct pinctrl_dev *pctldev,
 	return 0;
 }
 
+static int
+sunxi_pmx_gpio_set_direction(struct pinctrl_dev *pctldev,
+			struct pinctrl_gpio_range *range,
+			unsigned offset,
+			bool input)
+{
+	struct sunxi_pinctrl *pctl = pinctrl_dev_get_drvdata(pctldev);
+	struct sunxi_desc_function *desc;
+	char *func, *pin_name;
+	u8 bank, pin;
+	int ret;
+
+	bank = (offset) / PINS_PER_BANK;
+	pin = (offset) % PINS_PER_BANK;
+
+	pin_name = kzalloc(5, GFP_KERNEL);
+	if (!pin_name)
+		return -ENOMEM;
+
+	ret = sprintf(pin_name, "P%c%d", 'A' + bank, pin);
+	if (!ret)
+		goto error;
+
+	if (input)
+		func = "gpio_in";
+	else
+		func = "gpio_out";
+
+	desc = sunxi_pinctrl_desc_find_function_by_name(pctl,
+							pin_name,
+							func);
+	if (!desc) {
+		ret = -EINVAL;
+		goto error;
+	}
+
+	sunxi_pmx_set(pctldev, offset, desc->muxval);
+
+	ret = 0;
+
+error:
+	kfree(pin_name);
+	return ret;
+}
+
 static struct pinmux_ops sunxi_pmx_ops = {
 	.get_functions_count	= sunxi_pmx_get_funcs_cnt,
 	.get_function_name	= sunxi_pmx_get_func_name,
 	.get_function_groups	= sunxi_pmx_get_func_groups,
 	.enable			= sunxi_pmx_enable,
+	.gpio_set_direction	= sunxi_pmx_gpio_set_direction,
 };
 
 static struct pinctrl_desc sunxi_pctrl_desc = {
@@ -622,6 +669,60 @@ static struct pinctrl_desc sunxi_pctrl_desc = {
 	.pmxops		= &sunxi_pmx_ops,
 };
 
+static int sunxi_pinctrl_gpio_request(struct gpio_chip *chip, unsigned offset)
+{
+	return pinctrl_request_gpio(chip->base + offset);
+}
+
+static void sunxi_pinctrl_gpio_free(struct gpio_chip *chip, unsigned offset)
+{
+	pinctrl_free_gpio(chip->base + offset);
+}
+
+static int sunxi_pinctrl_gpio_direction_input(struct gpio_chip *chip,
+					unsigned offset)
+{
+	return pinctrl_gpio_direction_input(chip->base + offset);
+}
+
+static int sunxi_pinctrl_gpio_get(struct gpio_chip *chip, unsigned offset)
+{
+	struct sunxi_pinctrl *pctl = dev_get_drvdata(chip->dev);
+
+	u32 reg = sunxi_data_reg(offset);
+	u8 index = sunxi_data_offset(offset);
+	u32 val = (readl(pctl->membase + reg) >> index) & DATA_PINS_MASK;
+
+	return val;
+}
+
+static int sunxi_pinctrl_gpio_direction_output(struct gpio_chip *chip,
+					unsigned offset, int value)
+{
+	return pinctrl_gpio_direction_output(chip->base + offset);
+}
+
+static void sunxi_pinctrl_gpio_set(struct gpio_chip *chip,
+				unsigned offset, int value)
+{
+	struct sunxi_pinctrl *pctl = dev_get_drvdata(chip->dev);
+	u32 reg = sunxi_data_reg(offset);
+	u8 index = sunxi_data_offset(offset);
+
+	writel((value & DATA_PINS_MASK) << index, pctl->membase + reg);
+}
+
+static struct gpio_chip sunxi_pinctrl_gpio_chip __devinitconst = {
+	.owner			= THIS_MODULE,
+	.request		= sunxi_pinctrl_gpio_request,
+	.free			= sunxi_pinctrl_gpio_free,
+	.direction_input	= sunxi_pinctrl_gpio_direction_input,
+	.direction_output	= sunxi_pinctrl_gpio_direction_output,
+	.get			= sunxi_pinctrl_gpio_get,
+	.set			= sunxi_pinctrl_gpio_set,
+	.can_sleep		= 0,
+};
+
 static struct of_device_id sunxi_pinctrl_match[] = {
 	{ .compatible = "allwinner,sun5i-a13-pinctrl", .data = (void *)&sun5i_a13_pinctrl_data },
 	{}
@@ -737,7 +838,7 @@ static int sunxi_pinctrl_probe(struct platform_device *pdev)
 	const struct of_device_id *device;
 	struct pinctrl_pin_desc *pins;
 	struct sunxi_pinctrl *pctl;
-	int i, ret;
+	int i, ret, last_pin;
 
 	pctl = devm_kzalloc(&pdev->dev, sizeof(*pctl), GFP_KERNEL);
 	if (!pctl)
@@ -781,9 +882,42 @@ static int sunxi_pinctrl_probe(struct platform_device *pdev)
 		return -EINVAL;
 	}
 
-	dev_info(&pdev->dev, "initialized sunXi pin control driver\n");
+	pctl->chip = devm_kzalloc(&pdev->dev, sizeof(*pctl->chip), GFP_KERNEL);
+	if (!pctl->chip) {
+		ret = -ENOMEM;
+		goto pinctrl_error;
+	}
+
+	last_pin = pctl->desc->pins[pctl->desc->npins - 1].pin.number;
+	pctl->chip = &sunxi_pinctrl_gpio_chip;
+	pctl->chip->ngpio = round_up(last_pin, PINS_PER_BANK);
+	pctl->chip->label = dev_name(&pdev->dev);
+	pctl->chip->dev = &pdev->dev;
+	pctl->chip->base = 0;
+
+	ret = gpiochip_add(pctl->chip);
+	if (ret)
+		goto pinctrl_error;
+
+	for (i = 0; i < pctl->desc->npins; i++) {
+		const struct sunxi_desc_pin *pin = pctl->desc->pins + i;
+
+		ret = gpiochip_add_pin_range(pctl->chip, dev_name(&pdev->dev),
+					     pin->pin.number,
+					     pin->pin.number, 1);
+		if (ret)
+			goto gpiochip_error;
+	}
+
+	dev_info(&pdev->dev, "initialized sunXi PIO driver\n");
 
 	return 0;
+
+gpiochip_error:
+	ret = gpiochip_remove(pctl->chip);
+pinctrl_error:
+	pinctrl_unregister(pctl->pctl_dev);
+	return ret;
 }
 
 static struct platform_driver sunxi_pinctrl_driver = {
diff --git a/drivers/pinctrl/pinctrl-sunxi.h b/drivers/pinctrl/pinctrl-sunxi.h
index 0dc3b9d..0416c36 100644
--- a/drivers/pinctrl/pinctrl-sunxi.h
+++ b/drivers/pinctrl/pinctrl-sunxi.h
@@ -256,6 +256,7 @@
 
 #define BANK_MEM_SIZE		0x24
 #define MUX_REGS_OFFSET		0x0
+#define DATA_REGS_OFFSET	0x10
 #define DLEVEL_REGS_OFFSET	0x14
 #define PULL_REGS_OFFSET	0x1c
 
@@ -263,6 +264,9 @@
 #define MUX_PINS_PER_REG	8
 #define MUX_PINS_BITS		4
 #define MUX_PINS_MASK		0x0f
+#define DATA_PINS_PER_REG	32
+#define DATA_PINS_BITS		1
+#define DATA_PINS_MASK		0x01
 #define DLEVEL_PINS_PER_REG	16
 #define DLEVEL_PINS_BITS	2
 #define DLEVEL_PINS_MASK	0x03
@@ -283,6 +287,8 @@ struct sunxi_desc_pin {
 struct sunxi_pinctrl_desc {
 	const struct sunxi_desc_pin	*pins;
 	int				npins;
+	struct pinctrl_gpio_range	*ranges;
+	int				nranges;
 };
 
 struct sunxi_pinctrl_function {
@@ -299,6 +305,7 @@ struct sunxi_pinctrl_group {
 
 struct sunxi_pinctrl {
 	void __iomem			*membase;
+	struct gpio_chip		*chip;
 	struct sunxi_pinctrl_desc	*desc;
 	struct device			*dev;
 	struct sunxi_pinctrl_function	*functions;
@@ -321,7 +328,6 @@ struct sunxi_pinctrl {
 		.muxval = _val,					\
 	}
 
-
 /*
  * The sunXi PIO registers are organized as is:
  * 0x00 - 0x0c	Muxing values.
@@ -354,6 +360,21 @@ static inline u32 sunxi_mux_offset(u16 pin)
 	return pin_num * MUX_PINS_BITS;
 }
 
+static inline u32 sunxi_data_reg(u16 pin)
+{
+	u8 bank = pin / PINS_PER_BANK;
+	u32 offset = bank * BANK_MEM_SIZE;
+	offset += DATA_REGS_OFFSET;
+	offset += pin % PINS_PER_BANK / DATA_PINS_PER_REG * 0x04;
+	return round_down(offset, 4);
+}
+
+static inline u32 sunxi_data_offset(u16 pin)
+{
+	u32 pin_num = pin % DATA_PINS_PER_REG;
+	return pin_num * DATA_PINS_BITS;
+}
+
 static inline u32 sunxi_dlevel_reg(u16 pin)
 {
 	u8 bank = pin / PINS_PER_BANK;
-- 
1.7.10.4

