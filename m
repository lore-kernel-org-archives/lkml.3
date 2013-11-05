Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754977Ab3KEQ4r (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Nov 2013 11:56:47 -0500
Received: from co1ehsobe001.messaging.microsoft.com ([216.32.180.184]:13215
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754835Ab3KEQ4m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Nov 2013 11:56:42 -0500
X-Forefront-Antispam-Report: CIP:66.35.236.232;KIP:(null);UIP:(null);IPV:NLI;H:SJ-ITEXEDGE02.altera.priv.altera.com;RD:none;EFVD:NLI
X-SpamScore: 4
X-BigFish: VS4(zzzz1f42h2148h1ee6h1ce5h1fdah201ch2073h2146h1202h1fd0h1e76h1d1ah1cabh1d2ah1fc6h1082kzz1de098h8275bh1de097hz31h87h2a8h839hd24he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h14ddh1504h1537h15a8h162dh1631h1758h17eeh1898h18e1h1946h19b5h1ad9h1b0ah1d0ch1d2eh1d3fh1dfeh1dffh1e1dh1e23h1fe8h1ff5h2218h2216h129fi1151h1155h)
X-FB-DOMAIN-IP-MATCH: fail
From: Alan Tull <delicious.quinoa@gmail.com>
To: <linux-kernel@vger.kernel.org>
CC: <linux-doc@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Steffen Trumtrar <s.trumtrar@pengutronix.de>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Jamie Iles <jamie@jamieiles.com>,
        delicious quinoa <delicious.quinoa@gmail.com>,
        Heiko Stuebner <heiko@sntech.de>, Alan Tull <atull@altera.com>,
        Dinh Nguyen <dinguyen@altera.com>,
        Yves Vandervennet <rocket.yvanderv@gmail.com>
Subject: [PATCH 3/3] use linear irq domain in gpio-dwapb
Date: Tue, 5 Nov 2013 10:55:52 -0600
Message-ID: <1383670552-17566-4-git-send-email-delicious.quinoa@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1383670552-17566-1-git-send-email-delicious.quinoa@gmail.com>
References: <1383670552-17566-1-git-send-email-delicious.quinoa@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: altera.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Tull <atull@altera.com>

 * Changes to get gpio-dwapb (originally v3.2-rc7) driver building and
   working on current kernel.
 * Use linear irq domain.
 * Fix setting irq edge type for 'rising' and 'both'.
 * Support as a loadable module.
 * Use bgpio_chip's spinlock during register access.

Signed-off-by: Alan Tull <atull@altera.com>
---
 drivers/gpio/Kconfig      |    2 +-
 drivers/gpio/gpio-dwapb.c |  235 ++++++++++++++++++++++++++++++---------------
 2 files changed, 160 insertions(+), 77 deletions(-)

diff --git a/drivers/gpio/Kconfig b/drivers/gpio/Kconfig
index 4cc26ed..5fc674a 100644
--- a/drivers/gpio/Kconfig
+++ b/drivers/gpio/Kconfig
@@ -122,7 +122,7 @@ config GPIO_GENERIC_PLATFORM
 	  Say yes here to support basic platform_device memory-mapped GPIO controllers.
 
 config GPIO_DWAPB
-	bool "Synopsys DesignWare APB GPIO driver"
+	tristate "Synopsys DesignWare APB GPIO driver"
 	select GPIO_GENERIC
 	select GENERIC_IRQ_CHIP
 	depends on OF_GPIO && IRQ_DOMAIN
diff --git a/drivers/gpio/gpio-dwapb.c b/drivers/gpio/gpio-dwapb.c
index 64c7183..cca97e3 100644
--- a/drivers/gpio/gpio-dwapb.c
+++ b/drivers/gpio/gpio-dwapb.c
@@ -18,6 +18,7 @@
 #include <linux/of_address.h>
 #include <linux/of_irq.h>
 #include <linux/platform_device.h>
+#include <linux/spinlock.h>
 
 #define INT_EN_REG_OFFS		0x30
 #define INT_MASK_REG_OFFS	0x34
@@ -30,7 +31,6 @@ struct dwapb_gpio;
 
 struct dwapb_gpio_bank {
 	struct bgpio_chip	bgc;
-	unsigned int		bank_idx;
 	bool			is_registered;
 	struct dwapb_gpio	*gpio;
 };
@@ -41,8 +41,9 @@ struct dwapb_gpio {
 	void __iomem		*regs;
 	struct dwapb_gpio_bank	*banks;
 	unsigned int		nr_banks;
-	struct irq_chip_generic	*irq_gc;
 	unsigned long		toggle_edge;
+	struct irq_domain	*domain;
+	int			hwirq;
 };
 
 static unsigned int dwapb_gpio_nr_banks(struct device_node *of_node)
@@ -63,29 +64,30 @@ static int dwapb_gpio_to_irq(struct gpio_chip *gc, unsigned offset)
 						    dwapb_gpio_bank, bgc);
 	struct dwapb_gpio *gpio = bank->gpio;
 
-	return irq_domain_to_irq(&gpio->irq_gc->domain, offset);
+	return irq_create_mapping(gpio->domain, offset);
 }
 
 static void dwapb_toggle_trigger(struct dwapb_gpio *gpio, unsigned int offs)
 {
-	u32 v = readl(gpio->regs + INT_TYPE_REG_OFFS);
+	u32 v = readl(gpio->regs + INT_POLARITY_REG_OFFS);
 
 	if (gpio_get_value(gpio->banks[0].bgc.gc.base + offs))
 		v &= ~BIT(offs);
 	else
 		v |= BIT(offs);
 
-	writel(v, gpio->regs + INT_TYPE_REG_OFFS);
+	writel(v, gpio->regs + INT_POLARITY_REG_OFFS);
 }
 
 static void dwapb_irq_handler(u32 irq, struct irq_desc *desc)
 {
 	struct dwapb_gpio *gpio = irq_get_handler_data(irq);
+	struct irq_chip *chip = irq_desc_get_chip(desc);
 	u32 irq_status = readl(gpio->regs + INT_STATUS_REG_OFFS);
 
 	while (irq_status) {
 		int irqoffset = fls(irq_status) - 1;
-		int irq = irq_domain_to_irq(&gpio->irq_gc->domain, irqoffset);
+		int irq = irq_linear_revmap(gpio->domain, irqoffset);
 
 		generic_handle_irq(irq);
 		irq_status &= ~(1 << irqoffset);
@@ -93,44 +95,56 @@ static void dwapb_irq_handler(u32 irq, struct irq_desc *desc)
 		if (gpio->toggle_edge & BIT(irqoffset))
 			dwapb_toggle_trigger(gpio, irqoffset);
 	}
+
+	if (chip->irq_eoi)
+		chip->irq_eoi(irq_desc_get_irq_data(desc));
 }
 
 static void dwapb_irq_enable(struct irq_data *d)
 {
-	struct irq_chip_generic *gc = irq_data_get_irq_chip_data(d);
-	struct dwapb_gpio *gpio = gc->private;
+	struct dwapb_gpio *gpio = irq_data_get_irq_chip_data(d);
+	struct bgpio_chip *bgc = &gpio->banks[0].bgc;
+	unsigned long flags;
+	u32 val;
 
-	u32 val = readl(gpio->regs + INT_EN_REG_OFFS);
+	spin_lock_irqsave(&bgc->lock, flags);
+	val = readl(gpio->regs + INT_EN_REG_OFFS);
 	val |= 1 << d->hwirq;
 	writel(val, gpio->regs + INT_EN_REG_OFFS);
+	spin_unlock_irqrestore(&bgc->lock, flags);
 }
 
 static void dwapb_irq_disable(struct irq_data *d)
 {
-	struct irq_chip_generic *gc = irq_data_get_irq_chip_data(d);
-	struct dwapb_gpio *gpio = gc->private;
+	struct dwapb_gpio *gpio = irq_data_get_irq_chip_data(d);
+	struct bgpio_chip *bgc = &gpio->banks[0].bgc;
+	unsigned long flags;
+	u32 val;
 
-	u32 val = readl(gpio->regs + INT_EN_REG_OFFS);
+	spin_lock_irqsave(&bgc->lock, flags);
+	val = readl(gpio->regs + INT_EN_REG_OFFS);
 	val &= ~(1 << d->hwirq);
 	writel(val, gpio->regs + INT_EN_REG_OFFS);
+	spin_unlock_irqrestore(&bgc->lock, flags);
 }
 
 static int dwapb_irq_set_type(struct irq_data *d, u32 type)
 {
-	struct irq_chip_generic *gc = irq_data_get_irq_chip_data(d);
-	struct dwapb_gpio *gpio = gc->private;
+	struct dwapb_gpio *gpio = irq_data_get_irq_chip_data(d);
+	struct bgpio_chip *bgc = &gpio->banks[0].bgc;
 	int bit = d->hwirq;
-	unsigned long level, polarity;
+	unsigned long level, polarity, flags;
 
 	if (type & ~(IRQ_TYPE_EDGE_RISING | IRQ_TYPE_EDGE_FALLING |
 		     IRQ_TYPE_LEVEL_HIGH | IRQ_TYPE_LEVEL_LOW))
 		return -EINVAL;
 
+	spin_lock_irqsave(&bgc->lock, flags);
 	level = readl(gpio->regs + INT_TYPE_REG_OFFS);
 	polarity = readl(gpio->regs + INT_POLARITY_REG_OFFS);
 
 	gpio->toggle_edge &= ~BIT(bit);
-	if (type & IRQ_TYPE_EDGE_BOTH) {
+	if (type == IRQ_TYPE_EDGE_BOTH) {
 		gpio->toggle_edge |= BIT(bit);
 		level |= (1 << bit);
 		dwapb_toggle_trigger(gpio, bit);
@@ -150,72 +164,102 @@ static int dwapb_irq_set_type(struct irq_data *d, u32 type)
 
 	writel(level, gpio->regs + INT_TYPE_REG_OFFS);
 	writel(polarity, gpio->regs + INT_POLARITY_REG_OFFS);
+	spin_unlock_irqrestore(&bgc->lock, flags);
 
 	return 0;
 }
 
-static int dwapb_create_irqchip(struct dwapb_gpio *gpio,
-				struct dwapb_gpio_bank *bank,
-				unsigned int irq_base)
+static void dwapb_irq_ack(struct irq_data *d)
 {
-	struct irq_chip_type *ct;
-
-	gpio->irq_gc = irq_alloc_generic_chip("gpio-dwapb", 1, irq_base,
-					      gpio->regs, handle_level_irq);
-	if (!gpio->irq_gc)
-		return -EIO;
-
-	gpio->irq_gc->domain.of_node = of_node_get(bank->bgc.gc.of_node);
-	gpio->irq_gc->private = gpio;
-	ct = gpio->irq_gc->chip_types;
-	ct->chip.irq_ack = irq_gc_ack_set_bit;
-	ct->chip.irq_mask = irq_gc_mask_set_bit;
-	ct->chip.irq_unmask = irq_gc_mask_clr_bit;
-	ct->chip.irq_set_type = dwapb_irq_set_type;
-	ct->chip.irq_enable = dwapb_irq_enable;
-	ct->chip.irq_disable = dwapb_irq_disable;
-	ct->regs.ack = EOI_REG_OFFS;
-	ct->regs.mask = INT_MASK_REG_OFFS;
-	irq_setup_generic_chip(gpio->irq_gc, IRQ_MSK(bank->bgc.gc.ngpio),
-			       IRQ_GC_INIT_NESTED_LOCK, IRQ_NOREQUEST, 0);
+	struct dwapb_gpio *gpio = irq_data_get_irq_chip_data(d);
+	struct bgpio_chip *bgc = &gpio->banks[0].bgc;
+	unsigned long flags;
 
-	return 0;
+	spin_lock_irqsave(&bgc->lock, flags);
+	writel(1 << d->hwirq, gpio->regs + EOI_REG_OFFS);
+	spin_unlock_irqrestore(&bgc->lock, flags);
 }
 
-static int dwapb_configure_irqs(struct dwapb_gpio *gpio,
-				struct dwapb_gpio_bank *bank)
+static void dwapb_irq_mask(struct irq_data *d)
 {
-	unsigned int m, irq, ngpio = bank->bgc.gc.ngpio;
-	int irq_base;
-
-	for (m = 0; m < ngpio; ++m) {
-		irq = irq_of_parse_and_map(bank->bgc.gc.of_node, m);
-		if (!irq && m == 0) {
-			dev_warn(gpio->dev, "no irq for bank %s\n",
-				 bank->bgc.gc.of_node->full_name);
-			return -ENXIO;
-		} else if (!irq) {
-			break;
-		}
-
-		irq_set_chained_handler(irq, dwapb_irq_handler);
-		irq_set_handler_data(irq, gpio);
-	}
-	bank->bgc.gc.to_irq = dwapb_gpio_to_irq;
+	struct dwapb_gpio *gpio = irq_data_get_irq_chip_data(d);
+	struct bgpio_chip *bgc = &gpio->banks[0].bgc;
+	unsigned long value, flags;
+
+	spin_lock_irqsave(&bgc->lock, flags);
+	value = readl(gpio->regs + INT_MASK_REG_OFFS);
+	value |= 1 << d->hwirq;
+	writel(value, gpio->regs + INT_MASK_REG_OFFS);
+	spin_unlock_irqrestore(&bgc->lock, flags);
+}
 
-	irq_base = irq_alloc_descs(-1, 0, ngpio, NUMA_NO_NODE);
-	if (irq_base < 0)
-		return irq_base;
+static void dwapb_irq_unmask(struct irq_data *d)
+{
+	struct dwapb_gpio *gpio = irq_data_get_irq_chip_data(d);
+	struct bgpio_chip *bgc = &gpio->banks[0].bgc;
+	unsigned long value, flags;
+
+	spin_lock_irqsave(&bgc->lock, flags);
+	value = readl(gpio->regs + INT_MASK_REG_OFFS);
+	value &= ~(1 << d->hwirq);
+	writel(value, gpio->regs + INT_MASK_REG_OFFS);
+	spin_unlock_irqrestore(&bgc->lock, flags);
+}
 
-	if (dwapb_create_irqchip(gpio, bank, irq_base))
-		goto out_free_descs;
+static struct irq_chip dwapb_irq_chip = {
+	.name = "gpio-dwapb",
+	.irq_ack = dwapb_irq_ack,
+	.irq_mask = dwapb_irq_mask,
+	.irq_unmask = dwapb_irq_unmask,
+	.irq_set_type = dwapb_irq_set_type,
+	.irq_enable = dwapb_irq_enable,
+	.irq_disable = dwapb_irq_disable,
+};
+
+static int dwapb_gpio_irq_map(struct irq_domain *domain,
+			      unsigned int irq,
+			      irq_hw_number_t hwirq)
+{
+	struct dwapb_gpio *gpio = domain->host_data;
+
+	irq_set_chip_data(irq, gpio);
+	irq_set_chip_and_handler(irq, &dwapb_irq_chip, handle_level_irq);
+	irq_set_irq_type(irq, IRQ_TYPE_NONE);
+	irq_set_handler_data(irq, gpio);
 
 	return 0;
+}
 
-out_free_descs:
-	irq_free_descs(irq_base, ngpio);
+static struct irq_domain_ops dwapb_gpio_irq_ops = {
+	.map = dwapb_gpio_irq_map,
+	.xlate = irq_domain_xlate_twocell,
+};
 
-	return -EIO;
+static void dwapb_configure_irqs(struct dwapb_gpio *gpio,
+				 struct dwapb_gpio_bank *bank)
+{
+	struct gpio_chip *gc = &bank->bgc.gc;
+	struct device_node *node =  gc->of_node;
+	unsigned int ngpio = gc->ngpio;
+	int reg;
+
+	if (of_get_property(node, "interrupts", &reg) == NULL)
+		return;
+
+	gpio->hwirq = irq_of_parse_and_map(node, 0);
+	if (gpio->hwirq == NO_IRQ)
+		return;
+
+	gpio->domain = irq_domain_add_linear(node, ngpio, &dwapb_gpio_irq_ops,
+					     gpio);
+	if (!gpio->domain) {
+		irq_dispose_mapping(gpio->hwirq);
+		return;
+	}
+
+	irq_set_handler_data(gpio->hwirq, gpio);
+	irq_set_chained_handler(gpio->hwirq, dwapb_irq_handler);
+	bank->bgc.gc.to_irq = dwapb_gpio_to_irq;
 }
 
 static int dwapb_gpio_add_bank(struct dwapb_gpio *gpio,
@@ -240,7 +284,6 @@ static int dwapb_gpio_add_bank(struct dwapb_gpio *gpio,
 		return -EINVAL;
 	}
 
-	bank->bank_idx = bank_idx;
 	err = bgpio_init(&bank->bgc, gpio->dev, 4,
 			 gpio->regs + 0x50 + (bank_idx * 0x4),
 			 gpio->regs + 0x00 + (bank_idx * 0xc),
@@ -282,7 +325,7 @@ static void dwapb_gpio_unregister(struct dwapb_gpio *gpio)
 	of_node_put(gpio->of_node);
 }
 
-static int __devinit dwapb_gpio_probe(struct platform_device *pdev)
+static int dwapb_gpio_probe(struct platform_device *pdev)
 {
 	struct resource *res;
 	struct dwapb_gpio *gpio;
@@ -296,21 +339,29 @@ static int __devinit dwapb_gpio_probe(struct platform_device *pdev)
 	gpio->dev = &pdev->dev;
 
 	gpio->nr_banks = dwapb_gpio_nr_banks(pdev->dev.of_node);
-	if (!gpio->nr_banks)
-		return -EINVAL;
+	if (!gpio->nr_banks) {
+		err = -EINVAL;
+		goto out_err;
+	}
 	gpio->banks = devm_kzalloc(&pdev->dev, gpio->nr_banks *
 				   sizeof(*gpio->banks), GFP_KERNEL);
-	if (!gpio->banks)
-		return -ENOMEM;
+	if (!gpio->banks) {
+		err = -ENOMEM;
+		goto out_err;
+	}
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	if (!res) {
 		dev_err(&pdev->dev, "failed to get iomem\n");
-		return -ENXIO;
+		err = -ENXIO;
+		goto out_free_banks;
 	}
+
 	gpio->regs = devm_ioremap(&pdev->dev, res->start, resource_size(res));
-	if (!gpio->regs)
-		return -ENOMEM;
+	if (!gpio->regs) {
+		err = -ENOMEM;
+		goto out_free_banks;
+	}
 
 	gpio->of_node = of_node_get(pdev->dev.of_node);
 	for_each_child_of_node(pdev->dev.of_node, np) {
@@ -325,9 +376,34 @@ static int __devinit dwapb_gpio_probe(struct platform_device *pdev)
 out_unregister:
 	dwapb_gpio_unregister(gpio);
 
+	if (gpio->domain) {
+		irq_dispose_mapping(gpio->hwirq);
+		irq_domain_remove(gpio->domain);
+	}
+
+out_free_banks:
+	devm_kfree(&pdev->dev, gpio->banks);
+
+out_err:
+	devm_kfree(&pdev->dev, gpio);
 	return err;
 }
 
+static int dwapb_gpio_remove(struct platform_device *pdev)
+{
+	struct dwapb_gpio *gpio = platform_get_drvdata(pdev);
+
+	dwapb_gpio_unregister(gpio);
+	if (gpio->domain) {
+		irq_dispose_mapping(gpio->hwirq);
+		irq_domain_remove(gpio->domain);
+	}
+	devm_kfree(&pdev->dev, gpio->banks);
+	devm_kfree(&pdev->dev, gpio);
+
+	return 0;
+}
+
 static const struct of_device_id dwapb_of_match_table[] = {
 	{ .compatible = "snps,dw-apb-gpio" },
 	{ /* Sentinel */ }
@@ -340,6 +416,7 @@ static struct platform_driver dwapb_gpio_driver = {
 		.of_match_table = dwapb_of_match_table,
 	},
 	.probe		= dwapb_gpio_probe,
+	.remove		= dwapb_gpio_remove,
 };
 
 static int __init dwapb_gpio_init(void)
@@ -348,6 +425,12 @@ static int __init dwapb_gpio_init(void)
 }
 postcore_initcall(dwapb_gpio_init);
 
+static void __exit dwapb_gpio_exit(void)
+{
+	platform_driver_unregister(&dwapb_gpio_driver);
+}
+module_exit(dwapb_gpio_exit);
+
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Jamie Iles");
 MODULE_DESCRIPTION("Synopsys DesignWare APB GPIO driver");
-- 
1.7.9.5


