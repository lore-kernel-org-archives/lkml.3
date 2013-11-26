Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932730Ab3KZTqG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 14:46:06 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:54652 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932518Ab3KZToL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 14:44:11 -0500
From: Grygorii Strashko <grygorii.strashko@ti.com>
To: Linus Walleij <linus.walleij@linaro.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        <linux-gpio@vger.kernel.org>, <nsekhar@ti.com>
CC: <prabhakar.csengg@gmail.com>, <linux-kernel@vger.kernel.org>,
        <davinci-linux-open-source@linux.davincidsp.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>
Subject: [RFC v1 4/9] gpio: davinci: make IRQ initialization soc specific
Date: Tue, 26 Nov 2013 21:40:10 +0200
Message-ID: <1385494815-15740-5-git-send-email-grygorii.strashko@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1385494815-15740-1-git-send-email-grygorii.strashko@ti.com>
References: <1385494815-15740-1-git-send-email-grygorii.strashko@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Davinci GPIO IRQs initialization may need to be performed in a
different way depending on SoC which use it. For example:
- Davinci dm365 has AINTC irq controller, implemented using Generic IRQ
chip, SPARSE_IRQ off;
- Davinci da850 has cp-intc controller, implemented using IRQ chip;
SPARSE_IRQ off;
- Kestone has arm-gic controller, implemented using IRQ chip;
SPARSE_IRQ on;

Hence, introduce SoC specific initialization data
struct davinci_gpio_init_data {
	int (*unbanked_irq_init)(struct platform_device *pdev);
	int (*banked_irq_init)(struct platform_device *pdev);
};
which can be selected using "compatibility" property in case of DT-boot
and update code accordingly by splitting IRQ initialization code to
banked and unbanked IRQs initialization functions.

Select Davinci specific initialization data by default for non-DT boot
case.

Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
---
 drivers/gpio/gpio-davinci.c |  241 ++++++++++++++++++++++++++++---------------
 1 file changed, 156 insertions(+), 85 deletions(-)

diff --git a/drivers/gpio/gpio-davinci.c b/drivers/gpio/gpio-davinci.c
index ee7a2df..6a48bf8 100644
--- a/drivers/gpio/gpio-davinci.c
+++ b/drivers/gpio/gpio-davinci.c
@@ -37,12 +37,18 @@ struct davinci_gpio_regs {
 	u32	intstat;
 };
 
+struct davinci_gpio_init_data {
+	int (*unbanked_irq_init)(struct platform_device *pdev);
+	int (*banked_irq_init)(struct platform_device *pdev);
+};
+
 #define BINTEN	0x8 /* GPIO Interrupt Per-Bank Enable Register */
 
 #define chip2controller(chip)	\
 	container_of(chip, struct davinci_gpio_controller, chip)
 
 static void __iomem *gpio_base;
+static const struct davinci_gpio_init_data *gpio_init_data;
 
 static struct davinci_gpio_regs __iomem *gpio2regs(unsigned gpio)
 {
@@ -138,20 +144,32 @@ davinci_gpio_set(struct gpio_chip *chip, unsigned offset, int value)
 	writel((1 << offset), value ? &g->set_data : &g->clr_data);
 }
 
+static const struct of_device_id davinci_gpio_ids[];
+
 static struct davinci_gpio_platform_data *
 davinci_gpio_get_pdata(struct platform_device *pdev)
 {
 	struct device_node *dn = pdev->dev.of_node;
 	struct davinci_gpio_platform_data *pdata;
+	const struct of_device_id *match;
 	int ret;
 	u32 val;
 
 	if (!IS_ENABLED(CONFIG_OF) || !pdev->dev.of_node)
 		return pdev->dev.platform_data;
 
+	match = of_match_device(of_match_ptr(davinci_gpio_ids), &pdev->dev);
+	if (!match) {
+		ret = -ENODEV;
+		goto of_err;
+	}
+	gpio_init_data = match->data;
+
 	pdata = devm_kzalloc(&pdev->dev, sizeof(*pdata), GFP_KERNEL);
-	if (!pdata)
-		return NULL;
+	if (!pdata) {
+		ret = -ENOMEM;
+		goto of_err;
+	}
 
 	ret = of_property_read_u32(dn, "ti,ngpio", &val);
 	if (ret)
@@ -351,7 +369,11 @@ static int gpio_to_irq_banked(struct gpio_chip *chip, unsigned offset)
 {
 	struct davinci_gpio_controller *d = chip2controller(chip);
 
-	return irq_create_mapping(d->irq_domain, d->chip.base + offset);
+	if (d->irq_domain)
+		return irq_create_mapping(d->irq_domain,
+					   d->chip.base + offset);
+	else
+		return -ENXIO;
 }
 
 static int gpio_to_irq_unbanked(struct gpio_chip *chip, unsigned offset)
@@ -410,6 +432,121 @@ static const struct irq_domain_ops davinci_gpio_irq_ops = {
 	.xlate = irq_domain_xlate_onetwocell,
 };
 
+static int davinci_gpio_unbanked_irq_init(struct platform_device *pdev)
+{
+	int base_irq, irq;
+	unsigned gpio, ngpio;
+	struct davinci_gpio_regs __iomem *g;
+	struct device *dev = &pdev->dev;
+	struct davinci_gpio_controller *chips = platform_get_drvdata(pdev);
+	struct davinci_gpio_platform_data *pdata = dev->platform_data;
+
+	static struct irq_chip_type gpio_unbanked;
+
+	if (pdata->gpio_unbanked > chips[0].chip.ngpio) {
+		dev_err(dev, "Invalid IRQ configuration\n");
+		return -EINVAL;
+	}
+
+	ngpio = pdata->ngpio;
+
+	base_irq = platform_get_irq(pdev, 0);
+	if (base_irq <= 0) {
+		dev_err(dev, "Invalid first banked IRQ number %d\n", base_irq);
+		return base_irq < 0 ? base_irq : -EINVAL;
+	}
+
+	/* pass "bank 0" GPIO IRQs to AINTC */
+	chips[0].chip.to_irq = gpio_to_irq_unbanked;
+	chips[0].gpio_irq = base_irq;
+	chips[0].gpio_unbanked = pdata->gpio_unbanked;
+
+	/* AINTC handles mask/unmask; GPIO handles triggering */
+	gpio_unbanked = *container_of(irq_get_chip(base_irq),
+				      struct irq_chip_type, chip);
+	gpio_unbanked.chip.name = "GPIO-AINTC";
+	gpio_unbanked.chip.irq_set_type = gpio_irq_type_unbanked;
+
+	/* default trigger: both edges */
+	g = gpio2regs(0);
+	writel(~0, &g->set_falling);
+	writel(~0, &g->set_rising);
+
+	irq = base_irq;
+	/* set the direct IRQs up to use that irqchip */
+	for (gpio = 0; gpio < pdata->gpio_unbanked; gpio++, irq++) {
+		irq_set_chip(irq, &gpio_unbanked.chip);
+		irq_set_handler_data(irq, &chips[gpio / 32]);
+		irq_set_status_flags(irq, IRQ_TYPE_EDGE_BOTH);
+	}
+
+	return 0;
+};
+
+static int davinci_gpio_banked_irq_init(struct platform_device *pdev)
+{
+	int base_irq, irq;
+	unsigned gpio, ngpio, bank;
+	struct davinci_gpio_regs __iomem *g;
+	struct device *dev = &pdev->dev;
+	struct davinci_gpio_controller *chips = platform_get_drvdata(pdev);
+	struct davinci_gpio_platform_data *pdata = dev->platform_data;
+	struct irq_domain *irq_domain = NULL;
+
+	ngpio = pdata->ngpio;
+
+	base_irq = platform_get_irq(pdev, 0);
+	if (base_irq <= 0) {
+		dev_err(dev, "Invalid first banked IRQ number %d\n", base_irq);
+		return base_irq < 0 ? base_irq : -EINVAL;
+	}
+
+	irq = irq_alloc_descs(-1, 0, ngpio, 0);
+	if (irq < 0) {
+		dev_err(dev, "Couldn't allocate IRQ numbers\n");
+		return irq;
+	}
+
+	irq_domain = irq_domain_add_legacy(dev->of_node, ngpio, irq, 0,
+					   &davinci_gpio_irq_ops,
+					   chips);
+	if (!irq_domain) {
+		dev_err(dev, "Couldn't register an IRQ domain\n");
+		return -ENOMEM;
+	}
+
+	/*
+	 * Or, AINTC can handle IRQs for banks of 16 GPIO IRQs, which we
+	 * then chain through our own handler.
+	 */
+	for (gpio = 0, bank = 0; gpio < ngpio; bank++, base_irq++, gpio += 16) {
+		/* disabled by default, enabled only as needed */
+		g = gpio2regs(gpio);
+		writel(~0, &g->clr_falling);
+		writel(~0, &g->clr_rising);
+
+		/* set up all irqs in this bank */
+		irq_set_chained_handler(base_irq, gpio_irq_handler);
+
+		/*
+		 * Each chip handles 32 gpios, and each irq bank consists of 16
+		 * gpio irqs. Pass the irq bank's corresponding controller to
+		 * the chained irq handler.
+		 */
+		irq_set_handler_data(base_irq, &chips[gpio / 32]);
+
+		if (!(gpio % 32))
+			chips[gpio / 32].irq_domain = irq_domain;
+	}
+
+	return 0;
+}
+
+static const struct davinci_gpio_init_data davinci_gpio_pdata = {
+	.unbanked_irq_init = davinci_gpio_unbanked_irq_init,
+	.banked_irq_init = davinci_gpio_banked_irq_init,
+};
+
 /*
  * NOTE:  for suspend/resume, probably best to make a platform_device with
  * suspend_late/resume_resume calls hooking into results of the set_wake()
@@ -420,30 +557,12 @@ static const struct irq_domain_ops davinci_gpio_irq_ops = {
 
 static int davinci_gpio_irq_setup(struct platform_device *pdev)
 {
-	unsigned	gpio, irq, bank;
+	unsigned	gpio, bank;
 	struct clk	*clk;
 	u32		binten = 0;
-	unsigned	ngpio, bank_irq;
 	struct device *dev = &pdev->dev;
-	struct resource	*res;
 	struct davinci_gpio_controller *chips = platform_get_drvdata(pdev);
 	struct davinci_gpio_platform_data *pdata = dev->platform_data;
-	struct davinci_gpio_regs __iomem *g;
-	struct irq_domain	*irq_domain;
-
-	ngpio = pdata->ngpio;
-	res = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
-	if (!res) {
-		dev_err(dev, "Invalid IRQ resource\n");
-		return -EBUSY;
-	}
-
-	bank_irq = res->start;
-
-	if (!bank_irq) {
-		dev_err(dev, "Invalid IRQ resource\n");
-		return -ENODEV;
-	}
 
 	clk = devm_clk_get(dev, "gpio");
 	if (IS_ERR(clk)) {
@@ -453,19 +572,12 @@ static int davinci_gpio_irq_setup(struct platform_device *pdev)
 	}
 	clk_prepare_enable(clk);
 
-	irq = irq_alloc_descs(-1, 0, ngpio, 0);
-	if (irq < 0) {
-		dev_err(dev, "Couldn't allocate IRQ numbers\n");
-		return -ENODEV;
-	}
-
-	irq_domain = irq_domain_add_legacy(NULL, ngpio, irq, 0,
-						&davinci_gpio_irq_ops,
-						chips);
-	if (!irq_domain) {
-		dev_err(dev, "Couldn't register an IRQ domain\n");
-		return -ENODEV;
-	}
+	/*
+	 * Use Davinci GPIO init data by default for compatibility
+	 * with non-DT platforms
+	 */
+	if (!gpio_init_data)
+		gpio_init_data = &davinci_gpio_pdata;
 
 	/*
 	 * Arrange gpio_to_irq() support, handling either direct IRQs or
@@ -473,11 +585,8 @@ static int davinci_gpio_irq_setup(struct platform_device *pdev)
 	 * IRQs, while the others use banked IRQs, would need some setup
 	 * tweaks to recognize hardware which can do that.
 	 */
-	for (gpio = 0, bank = 0; gpio < ngpio; bank++, gpio += 32) {
+	for (gpio = 0, bank = 0; gpio < pdata->ngpio; bank++, gpio += 32)
 		chips[bank].chip.to_irq = gpio_to_irq_banked;
-		if (!pdata->gpio_unbanked)
-			chips[bank].irq_domain = irq_domain;
-	}
 
 	/*
 	 * AINTC can handle direct/unbanked IRQs for GPIOs, with the GPIO
@@ -485,33 +594,9 @@ static int davinci_gpio_irq_setup(struct platform_device *pdev)
 	 * IRQ mux conflicts; gpio_irq_type_unbanked() is only for GPIOs.
 	 */
 	if (pdata->gpio_unbanked) {
-		static struct irq_chip_type gpio_unbanked;
-
-		/* pass "bank 0" GPIO IRQs to AINTC */
-		chips[0].chip.to_irq = gpio_to_irq_unbanked;
-		chips[0].gpio_irq = bank_irq;
-		chips[0].gpio_unbanked = pdata->gpio_unbanked;
-		binten = BIT(0);
-
-		/* AINTC handles mask/unmask; GPIO handles triggering */
-		irq = bank_irq;
-		gpio_unbanked = *container_of(irq_get_chip(irq),
-					      struct irq_chip_type, chip);
-		gpio_unbanked.chip.name = "GPIO-AINTC";
-		gpio_unbanked.chip.irq_set_type = gpio_irq_type_unbanked;
-
-		/* default trigger: both edges */
-		g = gpio2regs(0);
-		writel(~0, &g->set_falling);
-		writel(~0, &g->set_rising);
-
-		/* set the direct IRQs up to use that irqchip */
-		for (gpio = 0; gpio < pdata->gpio_unbanked; gpio++, irq++) {
-			irq_set_chip(irq, &gpio_unbanked.chip);
-			irq_set_handler_data(irq, &chips[gpio / 32]);
-			irq_set_status_flags(irq, IRQ_TYPE_EDGE_BOTH);
-		}
-
+		if (gpio_init_data && gpio_init_data->unbanked_irq_init)
+			if (!gpio_init_data->unbanked_irq_init(pdev))
+				binten = BIT(0);
 		goto done;
 	}
 
@@ -519,24 +604,10 @@ static int davinci_gpio_irq_setup(struct platform_device *pdev)
 	 * Or, AINTC can handle IRQs for banks of 16 GPIO IRQs, which we
 	 * then chain through our own handler.
 	 */
-	for (gpio = 0, bank = 0; gpio < ngpio; bank++, bank_irq++, gpio += 16) {
-		/* disabled by default, enabled only as needed */
-		g = gpio2regs(gpio);
-		writel(~0, &g->clr_falling);
-		writel(~0, &g->clr_rising);
-
-		/* set up all irqs in this bank */
-		irq_set_chained_handler(bank_irq, gpio_irq_handler);
-
-		/*
-		 * Each chip handles 32 gpios, and each irq bank consists of 16
-		 * gpio irqs. Pass the irq bank's corresponding controller to
-		 * the chained irq handler.
-		 */
-		irq_set_handler_data(bank_irq, &chips[gpio / 32]);
-
-		binten |= BIT(bank);
-	}
+	if (gpio_init_data && gpio_init_data->banked_irq_init)
+		if (!gpio_init_data->banked_irq_init(pdev))
+			/* calculate biten mask - one bit per 16 GPIOs */
+			binten |= BIT((pdata->ngpio / 16) + 1) - 1;
 
 done:
 	/*
@@ -550,7 +621,7 @@ done:
 
 #if IS_ENABLED(CONFIG_OF)
 static const struct of_device_id davinci_gpio_ids[] = {
-	{ .compatible = "ti,dm6441-gpio", },
+	{ .compatible = "ti,dm6441-gpio", &davinci_gpio_pdata},
 	{ /* sentinel */ },
 };
 MODULE_DEVICE_TABLE(of, davinci_gpio_ids);
-- 
1.7.9.5

