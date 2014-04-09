Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933498AbaDINvk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 09:51:40 -0400
Received: from top.free-electrons.com ([176.31.233.9]:60873 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933148AbaDINvg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 09:51:36 -0400
From: Boris BREZILLON <boris.brezillon@free-electrons.com>
To: Randy Dunlap <rdunlap@infradead.org>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        =?UTF-8?q?Emilio=20L=C3=B3pez?= <emilio@elopez.com.ar>,
        Mike Turquette <mturquette@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>
Cc: devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Boris BREZILLON <boris.brezillon@free-electrons.com>
Subject: [PATCH 11/15] pinctrl: sunxi: add support for A31 PL pins
Date: Wed,  9 Apr 2014 15:51:14 +0200
Message-Id: <1397051478-4113-12-git-send-email-boris.brezillon@free-electrons.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1397051478-4113-1-git-send-email-boris.brezillon@free-electrons.com>
References: <1397051478-4113-1-git-send-email-boris.brezillon@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The A31 SoC define a new memory region dedicated to PL pins.

Add a new get_membase callback to the sunxi_pinctrl struct in order to
retrieve the membase and relative pin number from an absolute pin number,
and make use of this new callback when manipulating the pins.

Currently, only the A31 SoC needs a specific conversion, the other one use
a contiguous memory region for all their pins.

Signed-off-by: Boris BREZILLON <boris.brezillon@free-electrons.com>
---
 drivers/pinctrl/pinctrl-sunxi.c | 186 +++++++++++++++++++++++++++++-----------
 drivers/pinctrl/pinctrl-sunxi.h |   5 +-
 2 files changed, 139 insertions(+), 52 deletions(-)

diff --git a/drivers/pinctrl/pinctrl-sunxi.c b/drivers/pinctrl/pinctrl-sunxi.c
index ef16311..64dffc8 100644
--- a/drivers/pinctrl/pinctrl-sunxi.c
+++ b/drivers/pinctrl/pinctrl-sunxi.c
@@ -115,6 +115,35 @@ sunxi_pinctrl_desc_find_function_by_pin(struct sunxi_pinctrl *pctl,
 	return NULL;
 }
 
+static void __iomem *
+sun6i_a31_pinctrl_get_membase(struct sunxi_pinctrl *pctl, unsigned pin_num,
+			      unsigned *rel_pin_num)
+{
+	void __iomem *membase;
+
+	if (pin_num >= PL_BASE) {
+		pin_num -= PL_BASE;
+		membase = pctl->membase[1];
+	} else {
+		membase = pctl->membase[0];
+	}
+
+	if (rel_pin_num)
+		*rel_pin_num = pin_num;
+
+	return membase;
+}
+
+static void __iomem *
+sunxi_pinctrl_get_membase(struct sunxi_pinctrl *pctl, unsigned pin_num,
+			  unsigned *rel_pin_num)
+{
+	if (rel_pin_num)
+		*rel_pin_num = pin_num;
+
+	return pctl->membase[0];
+}
+
 static int sunxi_pctrl_get_groups_count(struct pinctrl_dev *pctldev)
 {
 	struct sunxi_pinctrl *pctl = pinctrl_dev_get_drvdata(pctldev);
@@ -280,8 +309,10 @@ static int sunxi_pconf_group_set(struct pinctrl_dev *pctldev,
 {
 	struct sunxi_pinctrl *pctl = pinctrl_dev_get_drvdata(pctldev);
 	struct sunxi_pinctrl_group *g = &pctl->groups[group];
+	void __iomem *membase;
 	unsigned long flags;
-	u32 val, mask;
+	u32 val, mask, reg;
+	unsigned pin;
 	u16 strength;
 	u8 dlevel;
 	int i;
@@ -289,6 +320,8 @@ static int sunxi_pconf_group_set(struct pinctrl_dev *pctldev,
 	spin_lock_irqsave(&pctl->lock, flags);
 
 	for (i = 0; i < num_configs; i++) {
+		membase = pctl->get_membase(pctl, g->pin, &pin);
+
 		switch (pinconf_to_config_param(configs[i])) {
 		case PIN_CONFIG_DRIVE_STRENGTH:
 			strength = pinconf_to_config_argument(configs[i]);
@@ -304,23 +337,26 @@ static int sunxi_pconf_group_set(struct pinctrl_dev *pctldev,
 			 *   3: 40mA
 			 */
 			dlevel = strength / 10 - 1;
-			val = readl(pctl->membase + sunxi_dlevel_reg(g->pin));
-			mask = DLEVEL_PINS_MASK << sunxi_dlevel_offset(g->pin);
+			reg = sunxi_dlevel_reg(pin);
+			val = readl(membase + reg);
+			mask = DLEVEL_PINS_MASK << sunxi_dlevel_offset(pin);
 			writel((val & ~mask)
-				| dlevel << sunxi_dlevel_offset(g->pin),
-				pctl->membase + sunxi_dlevel_reg(g->pin));
+				| dlevel << sunxi_dlevel_offset(pin),
+				membase + reg);
 			break;
 		case PIN_CONFIG_BIAS_PULL_UP:
-			val = readl(pctl->membase + sunxi_pull_reg(g->pin));
-			mask = PULL_PINS_MASK << sunxi_pull_offset(g->pin);
-			writel((val & ~mask) | 1 << sunxi_pull_offset(g->pin),
-				pctl->membase + sunxi_pull_reg(g->pin));
+			reg = sunxi_pull_reg(pin);
+			val = readl(membase + reg);
+			mask = PULL_PINS_MASK << sunxi_pull_offset(pin);
+			writel((val & ~mask) | 1 << sunxi_pull_offset(pin),
+				membase + reg);
 			break;
 		case PIN_CONFIG_BIAS_PULL_DOWN:
-			val = readl(pctl->membase + sunxi_pull_reg(g->pin));
-			mask = PULL_PINS_MASK << sunxi_pull_offset(g->pin);
-			writel((val & ~mask) | 2 << sunxi_pull_offset(g->pin),
-				pctl->membase + sunxi_pull_reg(g->pin));
+			reg = sunxi_pull_reg(pin);
+			val = readl(membase + reg);
+			mask = PULL_PINS_MASK << sunxi_pull_offset(pin);
+			writel((val & ~mask) | 2 << sunxi_pull_offset(pin),
+				membase + reg);
 			break;
 		default:
 			break;
@@ -372,15 +408,18 @@ static void sunxi_pmx_set(struct pinctrl_dev *pctldev,
 				 u8 config)
 {
 	struct sunxi_pinctrl *pctl = pinctrl_dev_get_drvdata(pctldev);
+	void __iomem *membase;
 	unsigned long flags;
 	u32 val, mask;
 
+	membase = pctl->get_membase(pctl, pin, &pin);
+
 	spin_lock_irqsave(&pctl->lock, flags);
 
-	val = readl(pctl->membase + sunxi_mux_reg(pin));
+	val = readl(membase + sunxi_mux_reg(pin));
 	mask = MUX_PINS_MASK << sunxi_mux_offset(pin);
 	writel((val & ~mask) | config << sunxi_mux_offset(pin),
-		pctl->membase + sunxi_mux_reg(pin));
+		membase + sunxi_mux_reg(pin));
 
 	spin_unlock_irqrestore(&pctl->lock, flags);
 }
@@ -462,10 +501,14 @@ static int sunxi_pinctrl_gpio_direction_input(struct gpio_chip *chip,
 static int sunxi_pinctrl_gpio_get(struct gpio_chip *chip, unsigned offset)
 {
 	struct sunxi_pinctrl *pctl = dev_get_drvdata(chip->dev);
+	void __iomem *membase;
+	u32 reg, val;
+	u8 index;
 
-	u32 reg = sunxi_data_reg(offset);
-	u8 index = sunxi_data_offset(offset);
-	u32 val = (readl(pctl->membase + reg) >> index) & DATA_PINS_MASK;
+	membase = pctl->get_membase(pctl, offset, &offset);
+	reg = sunxi_data_reg(offset);
+	index = sunxi_data_offset(offset);
+	val = (readl(membase + reg) >> index) & DATA_PINS_MASK;
 
 	return val;
 }
@@ -474,21 +517,25 @@ static void sunxi_pinctrl_gpio_set(struct gpio_chip *chip,
 				unsigned offset, int value)
 {
 	struct sunxi_pinctrl *pctl = dev_get_drvdata(chip->dev);
-	u32 reg = sunxi_data_reg(offset);
-	u8 index = sunxi_data_offset(offset);
+	void __iomem *membase;
 	unsigned long flags;
-	u32 regval;
+	u32 reg, regval;
+	u8 index;
+
+	membase = pctl->get_membase(pctl, offset, &offset);
+	reg = sunxi_data_reg(offset);
+	index = sunxi_data_offset(offset);
 
 	spin_lock_irqsave(&pctl->lock, flags);
 
-	regval = readl(pctl->membase + reg);
+	regval = readl(membase + reg);
 
 	if (value)
 		regval |= BIT(index);
 	else
 		regval &= ~(BIT(index));
 
-	writel(regval, pctl->membase + reg);
+	writel(regval, membase + reg);
 
 	spin_unlock_irqrestore(&pctl->lock, flags);
 }
@@ -556,11 +603,15 @@ static int sunxi_pinctrl_irq_set_type(struct irq_data *d,
 				      unsigned int type)
 {
 	struct sunxi_pinctrl *pctl = irq_data_get_irq_chip_data(d);
-	u32 reg = sunxi_irq_cfg_reg(d->hwirq);
-	u8 index = sunxi_irq_cfg_offset(d->hwirq);
+	void __iomem *membase;
 	unsigned long flags;
-	u32 regval;
-	u8 mode;
+	u32 reg, regval;
+	u8 index, mode;
+	unsigned pin;
+
+	membase = pctl->get_membase(pctl, d->hwirq, &pin);
+	reg = sunxi_irq_cfg_reg(pin);
+	index = sunxi_irq_cfg_offset(pin);
 
 	switch (type) {
 	case IRQ_TYPE_EDGE_RISING:
@@ -584,9 +635,9 @@ static int sunxi_pinctrl_irq_set_type(struct irq_data *d,
 
 	spin_lock_irqsave(&pctl->lock, flags);
 
-	regval = readl(pctl->membase + reg);
+	regval = readl(membase + reg);
 	regval &= ~(IRQ_CFG_IRQ_MASK << index);
-	writel(regval | (mode << index), pctl->membase + reg);
+	writel(regval | (mode << index), membase + reg);
 
 	spin_unlock_irqrestore(&pctl->lock, flags);
 
@@ -596,21 +647,27 @@ static int sunxi_pinctrl_irq_set_type(struct irq_data *d,
 static void sunxi_pinctrl_irq_mask_ack(struct irq_data *d)
 {
 	struct sunxi_pinctrl *pctl = irq_data_get_irq_chip_data(d);
-	u32 ctrl_reg = sunxi_irq_ctrl_reg(d->hwirq);
-	u8 ctrl_idx = sunxi_irq_ctrl_offset(d->hwirq);
-	u32 status_reg = sunxi_irq_status_reg(d->hwirq);
-	u8 status_idx = sunxi_irq_status_offset(d->hwirq);
+	void __iomem *membase;
+	u32 ctrl_reg, status_reg, val;
+	u8 ctrl_idx, status_idx;
 	unsigned long flags;
-	u32 val;
+	unsigned pin;
+
+	membase = pctl->get_membase(pctl, d->hwirq, &pin);
+
+	ctrl_reg = sunxi_irq_ctrl_reg(pin);
+	ctrl_idx = sunxi_irq_ctrl_offset(pin);
+	status_reg = sunxi_irq_status_reg(pin);
+	status_idx = sunxi_irq_status_offset(pin);
 
 	spin_lock_irqsave(&pctl->lock, flags);
 
 	/* Mask the IRQ */
-	val = readl(pctl->membase + ctrl_reg);
-	writel(val & ~(1 << ctrl_idx), pctl->membase + ctrl_reg);
+	val = readl(membase + ctrl_reg);
+	writel(val & ~(1 << ctrl_idx), membase + ctrl_reg);
 
 	/* Clear the IRQ */
-	writel(1 << status_idx, pctl->membase + status_reg);
+	writel(1 << status_idx, membase + status_reg);
 
 	spin_unlock_irqrestore(&pctl->lock, flags);
 }
@@ -618,16 +675,22 @@ static void sunxi_pinctrl_irq_mask_ack(struct irq_data *d)
 static void sunxi_pinctrl_irq_mask(struct irq_data *d)
 {
 	struct sunxi_pinctrl *pctl = irq_data_get_irq_chip_data(d);
-	u32 reg = sunxi_irq_ctrl_reg(d->hwirq);
-	u8 idx = sunxi_irq_ctrl_offset(d->hwirq);
+	void __iomem *membase;
+	u32 reg, val;
+	u8 idx;
 	unsigned long flags;
-	u32 val;
+	unsigned pin;
+
+	membase = pctl->get_membase(pctl, d->hwirq, &pin);
+
+	reg = sunxi_irq_ctrl_reg(pin);
+	idx = sunxi_irq_ctrl_offset(pin);
 
 	spin_lock_irqsave(&pctl->lock, flags);
 
 	/* Mask the IRQ */
-	val = readl(pctl->membase + reg);
-	writel(val & ~(1 << idx), pctl->membase + reg);
+	val = readl(membase + reg);
+	writel(val & ~(1 << idx), membase + reg);
 
 	spin_unlock_irqrestore(&pctl->lock, flags);
 }
@@ -635,11 +698,17 @@ static void sunxi_pinctrl_irq_mask(struct irq_data *d)
 static void sunxi_pinctrl_irq_unmask(struct irq_data *d)
 {
 	struct sunxi_pinctrl *pctl = irq_data_get_irq_chip_data(d);
+	void __iomem *membase;
 	struct sunxi_desc_function *func;
-	u32 reg = sunxi_irq_ctrl_reg(d->hwirq);
-	u8 idx = sunxi_irq_ctrl_offset(d->hwirq);
+	u32 reg, val;
+	u8 idx;
 	unsigned long flags;
-	u32 val;
+	unsigned pin;
+
+	membase = pctl->get_membase(pctl, d->hwirq, &pin);
+
+	reg = sunxi_irq_ctrl_reg(pin);
+	idx = sunxi_irq_ctrl_offset(pin);
 
 	func = sunxi_pinctrl_desc_find_function_by_pin(pctl,
 						       pctl->irq_array[d->hwirq],
@@ -651,8 +720,8 @@ static void sunxi_pinctrl_irq_unmask(struct irq_data *d)
 	spin_lock_irqsave(&pctl->lock, flags);
 
 	/* Unmask the IRQ */
-	val = readl(pctl->membase + reg);
-	writel(val | (1 << idx), pctl->membase + reg);
+	val = readl(membase + reg);
+	writel(val | (1 << idx), membase + reg);
 
 	spin_unlock_irqrestore(&pctl->lock, flags);
 }
@@ -668,10 +737,15 @@ static void sunxi_pinctrl_irq_handler(unsigned irq, struct irq_desc *desc)
 {
 	struct irq_chip *chip = irq_get_chip(irq);
 	struct sunxi_pinctrl *pctl = irq_get_handler_data(irq);
-	const unsigned long reg = readl(pctl->membase + IRQ_STATUS_REG);
+	void __iomem *membase;
+	unsigned long reg;
+
+	membase = pctl->get_membase(pctl, desc->irq_data.hwirq, NULL);
+
+	reg = readl(membase + IRQ_STATUS_REG);
 
 	/* Clear all interrupts */
-	writel(reg, pctl->membase + IRQ_STATUS_REG);
+	writel(reg, membase + IRQ_STATUS_REG);
 
 	if (reg) {
 		int irqoffset;
@@ -814,10 +888,20 @@ static int sunxi_pinctrl_probe(struct platform_device *pdev)
 
 	spin_lock_init(&pctl->lock);
 
-	pctl->membase = of_iomap(node, 0);
-	if (!pctl->membase)
+	pctl->membase[0] = of_iomap(node, 0);
+	if (!pctl->membase[0])
 		return -ENOMEM;
 
+	if (of_device_is_compatible(node, "allwinner,sun6i-a31-pinctrl")) {
+		pctl->membase[1] = of_iomap(node, 1);
+		if (!pctl->membase[1])
+			return -ENOMEM;
+
+		pctl->get_membase = sun6i_a31_pinctrl_get_membase;
+	} else {
+		pctl->get_membase = sunxi_pinctrl_get_membase;
+	}
+
 	device = of_match_device(sunxi_pinctrl_match, &pdev->dev);
 	if (!device)
 		return -ENODEV;
diff --git a/drivers/pinctrl/pinctrl-sunxi.h b/drivers/pinctrl/pinctrl-sunxi.h
index ef8890d..a008041 100644
--- a/drivers/pinctrl/pinctrl-sunxi.h
+++ b/drivers/pinctrl/pinctrl-sunxi.h
@@ -431,7 +431,7 @@ struct sunxi_pinctrl_group {
 };
 
 struct sunxi_pinctrl {
-	void __iomem			*membase;
+	void __iomem			*membase[2];
 	struct gpio_chip		*chip;
 	struct sunxi_pinctrl_desc	*desc;
 	struct device			*dev;
@@ -444,6 +444,9 @@ struct sunxi_pinctrl {
 	int				irq_array[SUNXI_IRQ_NUMBER];
 	spinlock_t			lock;
 	struct pinctrl_dev		*pctl_dev;
+	void __iomem * (*get_membase)(struct sunxi_pinctrl *pctl,
+				      unsigned pin_num,
+				      unsigned *rel_pin_num);
 };
 
 #define SUNXI_PIN(_pin, ...)					\
-- 
1.8.3.2

