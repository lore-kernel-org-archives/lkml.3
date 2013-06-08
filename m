Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752125Ab3FHKGi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Jun 2013 06:06:38 -0400
Received: from mail.free-electrons.com ([94.23.35.102]:54248 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751889Ab3FHKFv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Jun 2013 06:05:51 -0400
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Emilio Lopez <emilio@elopez.com.ar>, kevin@allwinnertech.com,
        sunny@allwinnertech.com, shuge@allwinnertech.com,
        linux-sunxi@googlegroups.com,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: [PATCH 2/4] pinctrl: sunxi: Add external interrupts support
Date: Sat,  8 Jun 2013 12:05:44 +0200
Message-Id: <1370685946-3718-3-git-send-email-maxime.ripard@free-electrons.com>
X-Mailer: git-send-email 1.8.3
In-Reply-To: <1370685946-3718-1-git-send-email-maxime.ripard@free-electrons.com>
References: <1370685946-3718-1-git-send-email-maxime.ripard@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The port controller IP found in the Allwinner A10 and A13 can use few of
the pins it manage as an interrupt source, called external interrupts in
the datasheet.

The number of these external interrupts are SoCs specific, but the
current upper limit is 32. In order to work, the external interrupts'
pins have to be muxed to a specific function to generate an interrupt.

This patch adds the irqchip and the needed logic to use the PIO
controller as an interrupt controller.

Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
---
 drivers/pinctrl/pinctrl-sunxi.c | 158 +++++++++++++++++++++++++++++++++++++++-
 drivers/pinctrl/pinctrl-sunxi.h |  68 +++++++++++++++++
 2 files changed, 225 insertions(+), 1 deletion(-)

diff --git a/drivers/pinctrl/pinctrl-sunxi.c b/drivers/pinctrl/pinctrl-sunxi.c
index 0e7961c..47c7f43 100644
--- a/drivers/pinctrl/pinctrl-sunxi.c
+++ b/drivers/pinctrl/pinctrl-sunxi.c
@@ -13,10 +13,12 @@
 #include <linux/io.h>
 #include <linux/clk.h>
 #include <linux/gpio.h>
+#include <linux/irqdomain.h>
 #include <linux/module.h>
 #include <linux/of.h>
 #include <linux/of_address.h>
 #include <linux/of_device.h>
+#include <linux/of_irq.h>
 #include <linux/pinctrl/consumer.h>
 #include <linux/pinctrl/machine.h>
 #include <linux/pinctrl/pinctrl.h>
@@ -1796,6 +1798,26 @@ static int sunxi_pinctrl_gpio_of_xlate(struct gpio_chip *gc,
 	return pin;
 }
 
+static int sunxi_pinctrl_gpio_to_irq(struct gpio_chip *chip, unsigned offset)
+{
+	struct sunxi_pinctrl *pctl = dev_get_drvdata(chip->dev);
+	struct sunxi_desc_function *desc;
+
+	if (offset > chip->ngpio)
+		return -ENXIO;
+
+	desc = sunxi_pinctrl_desc_find_function_by_pin(pctl, offset, "irq");
+	if (!desc)
+		return -EINVAL;
+
+	pctl->irq_array[desc->irqnum] = offset;
+
+	dev_dbg(chip->dev, "%s: request IRQ for GPIO %d, return %d\n",
+		chip->label, offset + chip->base, desc->irqnum);
+
+	return irq_find_mapping(pctl->domain, desc->irqnum);
+}
+
 static struct gpio_chip sunxi_pinctrl_gpio_chip = {
 	.owner			= THIS_MODULE,
 	.request		= sunxi_pinctrl_gpio_request,
@@ -1805,10 +1827,118 @@ static struct gpio_chip sunxi_pinctrl_gpio_chip = {
 	.get			= sunxi_pinctrl_gpio_get,
 	.set			= sunxi_pinctrl_gpio_set,
 	.of_xlate		= sunxi_pinctrl_gpio_of_xlate,
+	.to_irq			= sunxi_pinctrl_gpio_to_irq,
 	.of_gpio_n_cells	= 3,
 	.can_sleep		= 0,
 };
 
+static int sunxi_pinctrl_irq_set_type(struct irq_data *d,
+				      unsigned int type)
+{
+	struct sunxi_pinctrl *pctl = irq_data_get_irq_chip_data(d);
+	u32 reg = sunxi_irq_cfg_reg(d->hwirq);
+	u8 index = sunxi_irq_cfg_offset(d->hwirq);
+	u8 mode;
+
+	switch (type) {
+	case IRQ_TYPE_EDGE_RISING:
+		mode = IRQ_EDGE_RISING;
+		break;
+	case IRQ_TYPE_EDGE_FALLING:
+		mode = IRQ_EDGE_FALLING;
+		break;
+	case IRQ_TYPE_EDGE_BOTH:
+		mode = IRQ_EDGE_BOTH;
+		break;
+	case IRQ_TYPE_LEVEL_HIGH:
+		mode = IRQ_LEVEL_HIGH;
+		break;
+	case IRQ_TYPE_LEVEL_LOW:
+		mode = IRQ_LEVEL_LOW;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	writel((mode & IRQ_CFG_IRQ_MASK) << index, pctl->membase + reg);
+
+	return 0;
+}
+
+static void sunxi_pinctrl_irq_mask_ack(struct irq_data *d)
+{
+	struct sunxi_pinctrl *pctl = irq_data_get_irq_chip_data(d);
+	u32 ctrl_reg = sunxi_irq_ctrl_reg(d->hwirq);
+	u8 ctrl_idx = sunxi_irq_ctrl_offset(d->hwirq);
+	u32 status_reg = sunxi_irq_status_reg(d->hwirq);
+	u8 status_idx = sunxi_irq_status_offset(d->hwirq);
+	u32 val;
+
+	/* Mask the IRQ */
+	val = readl(pctl->membase + ctrl_reg);
+	writel(val & ~(1 << ctrl_idx), pctl->membase + ctrl_reg);
+
+	/* Clear the IRQ */
+	writel(1 << status_idx, pctl->membase + status_reg);
+}
+
+static void sunxi_pinctrl_irq_mask(struct irq_data *d)
+{
+	struct sunxi_pinctrl *pctl = irq_data_get_irq_chip_data(d);
+	u32 reg = sunxi_irq_ctrl_reg(d->hwirq);
+	u8 idx = sunxi_irq_ctrl_offset(d->hwirq);
+	u32 val;
+
+	/* Mask the IRQ */
+	val = readl(pctl->membase + reg);
+	writel(val & ~(1 << idx), pctl->membase + reg);
+}
+
+static void sunxi_pinctrl_irq_unmask(struct irq_data *d)
+{
+	struct sunxi_pinctrl *pctl = irq_data_get_irq_chip_data(d);
+	struct sunxi_desc_function *func;
+	u32 reg = sunxi_irq_ctrl_reg(d->hwirq);
+	u8 idx = sunxi_irq_ctrl_offset(d->hwirq);
+	u32 val;
+
+	func = sunxi_pinctrl_desc_find_function_by_pin(pctl,
+						       pctl->irq_array[d->hwirq],
+						       "irq");
+
+	/* Change muxing to INT mode */
+	sunxi_pmx_set(pctl->pctl_dev, pctl->irq_array[d->hwirq], func->muxval);
+
+	/* Unmask the IRQ */
+	val = readl(pctl->membase + reg);
+	writel(val | (1 << idx), pctl->membase + reg);
+}
+
+static struct irq_chip sunxi_pinctrl_irq_chip = {
+	.irq_mask	= sunxi_pinctrl_irq_mask,
+	.irq_mask_ack	= sunxi_pinctrl_irq_mask_ack,
+	.irq_unmask	= sunxi_pinctrl_irq_unmask,
+	.irq_set_type	= sunxi_pinctrl_irq_set_type,
+};
+
+static void sunxi_pinctrl_irq_handler(unsigned irq, struct irq_desc *desc)
+{
+	struct sunxi_pinctrl *pctl = irq_get_handler_data(irq);
+	const unsigned long reg = readl(pctl->membase + IRQ_STATUS_REG);
+
+	/* Clear all interrupts */
+	writel(reg, pctl->membase + IRQ_STATUS_REG);
+
+	if (reg) {
+		int irqoffset;
+
+		for_each_set_bit(irqoffset, &reg, SUNXI_IRQ_NUMBER) {
+			int pin_irq = irq_find_mapping(pctl->domain, irqoffset);
+			generic_handle_irq(pin_irq);
+		}
+	}
+}
+
 static struct of_device_id sunxi_pinctrl_match[] = {
 	{ .compatible = "allwinner,sun4i-a10-pinctrl", .data = (void *)&sun4i_a10_pinctrl_data },
 	{ .compatible = "allwinner,sun5i-a13-pinctrl", .data = (void *)&sun5i_a13_pinctrl_data },
@@ -2003,12 +2133,38 @@ static int sunxi_pinctrl_probe(struct platform_device *pdev)
 
 	clk_prepare_enable(clk);
 
+	pctl->irq = irq_of_parse_and_map(node, 0);
+	if (!pctl->irq) {
+		ret = -EINVAL;
+		goto gpiochip_error;
+	}
+
+	pctl->domain = irq_domain_add_linear(node, SUNXI_IRQ_NUMBER,
+					     &irq_domain_simple_ops, NULL);
+	if (!pctl->domain) {
+		dev_err(&pdev->dev, "Couldn't register IRQ domain\n");
+		ret = -ENOMEM;
+		goto gpiochip_error;
+	}
+
+	for (i = 0; i < SUNXI_IRQ_NUMBER; i++) {
+		int irqno = irq_create_mapping(pctl->domain, i);
+
+		irq_set_chip_and_handler(irqno, &sunxi_pinctrl_irq_chip,
+					 handle_simple_irq);
+		irq_set_chip_data(irqno, pctl);
+	};
+
+	irq_set_chained_handler(pctl->irq, sunxi_pinctrl_irq_handler);
+	irq_set_handler_data(pctl->irq, pctl);
+
 	dev_info(&pdev->dev, "initialized sunXi PIO driver\n");
 
 	return 0;
 
 gpiochip_error:
-	ret = gpiochip_remove(pctl->chip);
+	if (gpiochip_remove(pctl->chip))
+		dev_err(&pdev->dev, "Couldn't remove gpiochip\n");
 pinctrl_error:
 	pinctrl_unregister(pctl->pctl_dev);
 	return ret;
diff --git a/drivers/pinctrl/pinctrl-sunxi.h b/drivers/pinctrl/pinctrl-sunxi.h
index e921621..d68047d 100644
--- a/drivers/pinctrl/pinctrl-sunxi.h
+++ b/drivers/pinctrl/pinctrl-sunxi.h
@@ -344,9 +344,31 @@
 #define PULL_PINS_BITS		2
 #define PULL_PINS_MASK		0x03
 
+#define SUNXI_IRQ_NUMBER	32
+
+#define IRQ_CFG_REG		0x200
+#define IRQ_CFG_IRQ_PER_REG		8
+#define IRQ_CFG_IRQ_BITS		4
+#define IRQ_CFG_IRQ_MASK		((1 << IRQ_CFG_IRQ_BITS) - 1)
+#define IRQ_CTRL_REG		0x210
+#define IRQ_CTRL_IRQ_PER_REG		32
+#define IRQ_CTRL_IRQ_BITS		1
+#define IRQ_CTRL_IRQ_MASK		((1 << IRQ_CTRL_IRQ_BITS) - 1)
+#define IRQ_STATUS_REG		0x214
+#define IRQ_STATUS_IRQ_PER_REG		32
+#define IRQ_STATUS_IRQ_BITS		1
+#define IRQ_STATUS_IRQ_MASK		((1 << IRQ_STATUS_IRQ_BITS) - 1)
+
+#define IRQ_EDGE_RISING		0x00
+#define IRQ_EDGE_FALLING	0x01
+#define IRQ_LEVEL_HIGH		0x02
+#define IRQ_LEVEL_LOW		0x03
+#define IRQ_EDGE_BOTH		0x04
+
 struct sunxi_desc_function {
 	const char	*name;
 	u8		muxval;
+	u8		irqnum;
 };
 
 struct sunxi_desc_pin {
@@ -378,10 +400,13 @@ struct sunxi_pinctrl {
 	struct gpio_chip		*chip;
 	struct sunxi_pinctrl_desc	*desc;
 	struct device			*dev;
+	struct irq_domain		*domain;
 	struct sunxi_pinctrl_function	*functions;
 	unsigned			nfunctions;
 	struct sunxi_pinctrl_group	*groups;
 	unsigned			ngroups;
+	int				irq;
+	int				irq_array[SUNXI_IRQ_NUMBER];
 	struct pinctrl_dev		*pctl_dev;
 };
 
@@ -398,6 +423,13 @@ struct sunxi_pinctrl {
 		.muxval = _val,					\
 	}
 
+#define SUNXI_FUNCTION_IRQ(_val, _irq)				\
+	{							\
+		.name = "irq",					\
+		.muxval = _val,					\
+		.irqnum = _irq,					\
+	}
+
 /*
  * The sunXi PIO registers are organized as is:
  * 0x00 - 0x0c	Muxing values.
@@ -475,4 +507,40 @@ static inline u32 sunxi_pull_offset(u16 pin)
 	return pin_num * PULL_PINS_BITS;
 }
 
+static inline u32 sunxi_irq_cfg_reg(u16 irq)
+{
+	u8 reg = irq / IRQ_CFG_IRQ_PER_REG;
+	return reg + IRQ_CFG_REG;
+}
+
+static inline u32 sunxi_irq_cfg_offset(u16 irq)
+{
+	u32 irq_num = irq % IRQ_CFG_IRQ_PER_REG;
+	return irq_num * IRQ_CFG_IRQ_BITS;
+}
+
+static inline u32 sunxi_irq_ctrl_reg(u16 irq)
+{
+	u8 reg = irq / IRQ_CTRL_IRQ_PER_REG;
+	return reg + IRQ_CTRL_REG;
+}
+
+static inline u32 sunxi_irq_ctrl_offset(u16 irq)
+{
+	u32 irq_num = irq % IRQ_CTRL_IRQ_PER_REG;
+	return irq_num * IRQ_CTRL_IRQ_BITS;
+}
+
+static inline u32 sunxi_irq_status_reg(u16 irq)
+{
+	u8 reg = irq / IRQ_STATUS_IRQ_PER_REG;
+	return reg + IRQ_STATUS_REG;
+}
+
+static inline u32 sunxi_irq_status_offset(u16 irq)
+{
+	u32 irq_num = irq % IRQ_STATUS_IRQ_PER_REG;
+	return irq_num * IRQ_STATUS_IRQ_BITS;
+}
+
 #endif /* __PINCTRL_SUNXI_H */
-- 
1.8.3

