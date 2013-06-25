Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751994Ab3FYO2J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 10:28:09 -0400
Received: from multi.imgtec.com ([194.200.65.239]:39206 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751896Ab3FYO2H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 10:28:07 -0400
From: James Hogan <james.hogan@imgtec.com>
To: <linux-kernel@vger.kernel.org>
CC: James Hogan <james.hogan@imgtec.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Grant Likely <grant.likely@linaro.org>
Subject: [PATCH v4 3/3] gpio-tz1090: convert to use generic irqchip
Date: Tue, 25 Jun 2013 15:27:45 +0100
Message-ID: <1372170465-28450-4-git-send-email-james.hogan@imgtec.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1372170465-28450-1-git-send-email-james.hogan@imgtec.com>
References: <1372170465-28450-1-git-send-email-james.hogan@imgtec.com>
MIME-Version: 1.0
Content-Type: text/plain
X-SEF-Processed: 7_3_0_01192__2013_06_25_15_28_04
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert gpio-tz1090 driver to use generic irqchips. This allows the
irq_ack, irq_mask, and irq_unmask callbacks and associated helper
functions to be removed. Also switch to using irq_setup_alt_chip() in
the irq_set_type callback instead of using __irq_set_handler_locked().

Signed-off-by: James Hogan <james.hogan@imgtec.com>
Cc: Linus Walleij <linus.walleij@linaro.org>
Cc: Grant Likely <grant.likely@linaro.org>
---
This patch depends on the generic irqchip linear irqdomain work in
tip/irq/core.

Changes in v4:
 - gpio-tz1090: convert to use generic irqchip callbacks
 - gpio-tz1090: convert to use irq_setup_alt_chip() instead of
   __irq_set_handler_locked()

 drivers/gpio/Kconfig       |   1 +
 drivers/gpio/gpio-tz1090.c | 123 ++++++++++++++++++---------------------------
 2 files changed, 49 insertions(+), 75 deletions(-)

diff --git a/drivers/gpio/Kconfig b/drivers/gpio/Kconfig
index 08dbfbe..fd38622 100644
--- a/drivers/gpio/Kconfig
+++ b/drivers/gpio/Kconfig
@@ -235,6 +235,7 @@ config GPIO_TS5500
 config GPIO_TZ1090
 	bool "Toumaz Xenif TZ1090 GPIO support"
 	depends on SOC_TZ1090
+	select GENERIC_IRQ_CHIP
 	default y
 	help
 	  Say yes here to support Toumaz Xenif TZ1090 GPIOs.
diff --git a/drivers/gpio/gpio-tz1090.c b/drivers/gpio/gpio-tz1090.c
index b725a6b..23e0613 100644
--- a/drivers/gpio/gpio-tz1090.c
+++ b/drivers/gpio/gpio-tz1090.c
@@ -270,30 +270,12 @@ static inline struct tz1090_gpio_bank *irqd_to_gpio_bank(struct irq_data *data)
 	return (struct tz1090_gpio_bank *)data->domain->host_data;
 }
 
-static void tz1090_gpio_irq_clear(struct tz1090_gpio_bank *bank,
-				  unsigned int offset)
-{
-	tz1090_gpio_clear_bit(bank, REG_GPIO_IRQ_STS, offset);
-}
-
-static void tz1090_gpio_irq_enable(struct tz1090_gpio_bank *bank,
-				   unsigned int offset, bool enable)
-{
-	tz1090_gpio_mod_bit(bank, REG_GPIO_IRQ_EN, offset, enable);
-}
-
 static void tz1090_gpio_irq_polarity(struct tz1090_gpio_bank *bank,
 				     unsigned int offset, unsigned int polarity)
 {
 	tz1090_gpio_mod_bit(bank, REG_GPIO_IRQ_PLRT, offset, polarity);
 }
 
-static int tz1090_gpio_valid_handler(struct irq_desc *desc)
-{
-	return desc->handle_irq == handle_level_irq ||
-		desc->handle_irq == handle_edge_irq;
-}
-
 static void tz1090_gpio_irq_type(struct tz1090_gpio_bank *bank,
 				 unsigned int offset, unsigned int type)
 {
@@ -320,43 +302,18 @@ static void tz1090_gpio_irq_next_edge(struct tz1090_gpio_bank *bank,
 	__global_unlock2(lstat);
 }
 
-static void gpio_ack_irq(struct irq_data *data)
-{
-	struct tz1090_gpio_bank *bank = irqd_to_gpio_bank(data);
-
-	tz1090_gpio_irq_clear(bank, data->hwirq);
-}
-
-static void gpio_mask_irq(struct irq_data *data)
-{
-	struct tz1090_gpio_bank *bank = irqd_to_gpio_bank(data);
-
-	tz1090_gpio_irq_enable(bank, data->hwirq, false);
-}
-
-static void gpio_unmask_irq(struct irq_data *data)
-{
-	struct tz1090_gpio_bank *bank = irqd_to_gpio_bank(data);
-
-	tz1090_gpio_irq_enable(bank, data->hwirq, true);
-}
-
 static unsigned int gpio_startup_irq(struct irq_data *data)
 {
-	struct tz1090_gpio_bank *bank = irqd_to_gpio_bank(data);
-	irq_hw_number_t hw = data->hwirq;
-	struct irq_desc *desc = irq_to_desc(data->irq);
-
 	/*
 	 * This warning indicates that the type of the irq hasn't been set
 	 * before enabling the irq. This would normally be done by passing some
 	 * trigger flags to request_irq().
 	 */
-	WARN(!tz1090_gpio_valid_handler(desc),
+	WARN(irqd_get_trigger_type(data) == IRQ_TYPE_NONE,
 		"irq type not set before enabling gpio irq %d", data->irq);
 
-	tz1090_gpio_irq_clear(bank, hw);
-	tz1090_gpio_irq_enable(bank, hw, true);
+	irq_gc_ack_clr_bit(data);
+	irq_gc_mask_set_bit(data);
 	return 0;
 }
 
@@ -392,10 +349,7 @@ static int gpio_set_irq_type(struct irq_data *data, unsigned int flow_type)
 	}
 
 	tz1090_gpio_irq_type(bank, data->hwirq, type);
-	if (type == REG_GPIO_IRQ_TYPE_LEVEL)
-		__irq_set_handler_locked(data->irq, handle_level_irq);
-	else
-		__irq_set_handler_locked(data->irq, handle_edge_irq);
+	irq_setup_alt_chip(data, flow_type);
 
 	if (flow_type == IRQ_TYPE_EDGE_BOTH)
 		tz1090_gpio_irq_next_edge(bank, data->hwirq);
@@ -421,17 +375,6 @@ static int gpio_set_irq_wake(struct irq_data *data, unsigned int on)
 #define gpio_set_irq_wake NULL
 #endif
 
-/* gpio virtual interrupt functions */
-static struct irq_chip gpio_irq_chip = {
-	.irq_startup	= gpio_startup_irq,
-	.irq_ack	= gpio_ack_irq,
-	.irq_mask	= gpio_mask_irq,
-	.irq_unmask	= gpio_unmask_irq,
-	.irq_set_type	= gpio_set_irq_type,
-	.irq_set_wake	= gpio_set_irq_wake,
-	.flags		= IRQCHIP_MASK_ON_SUSPEND,
-};
-
 static void tz1090_gpio_irq_handler(unsigned int irq, struct irq_desc *desc)
 {
 	irq_hw_number_t hw;
@@ -457,28 +400,17 @@ static void tz1090_gpio_irq_handler(unsigned int irq, struct irq_desc *desc)
 				== IRQ_TYPE_EDGE_BOTH)
 			tz1090_gpio_irq_next_edge(bank, hw);
 
-		BUG_ON(!tz1090_gpio_valid_handler(child_desc));
 		generic_handle_irq_desc(irq_no, child_desc);
 	}
 }
 
-static int tz1090_gpio_irq_map(struct irq_domain *d, unsigned int irq,
-			       irq_hw_number_t hw)
-{
-	irq_set_chip(irq, &gpio_irq_chip);
-	return 0;
-}
-
-static const struct irq_domain_ops tz1090_gpio_irq_domain_ops = {
-	.map	= tz1090_gpio_irq_map,
-	.xlate	= irq_domain_xlate_twocell,
-};
-
 static int tz1090_gpio_bank_probe(struct tz1090_gpio_bank_info *info)
 {
 	struct device_node *np = info->node;
 	struct device *dev = info->priv->dev;
 	struct tz1090_gpio_bank *bank;
+	struct irq_chip_generic *gc;
+	int err;
 
 	bank = devm_kzalloc(dev, sizeof(*bank), GFP_KERNEL);
 	if (!bank) {
@@ -533,9 +465,50 @@ static int tz1090_gpio_bank_probe(struct tz1090_gpio_bank_info *info)
 	/* Add a virtual IRQ for each GPIO */
 	bank->domain = irq_domain_add_linear(np,
 					     bank->chip.ngpio,
-					     &tz1090_gpio_irq_domain_ops,
+					     &irq_generic_chip_ops,
 					     bank);
 
+	/* Set up a generic irq chip with 2 chip types (level and edge) */
+	err = irq_alloc_domain_generic_chips(bank->domain, bank->chip.ngpio, 2,
+					     bank->label, handle_bad_irq, 0, 0,
+					     IRQ_GC_INIT_NESTED_LOCK);
+	if (err) {
+		dev_info(dev,
+			 "irq_alloc_domain_generic_chips failed for bank %u, IRQs disabled\n",
+			 info->index);
+		irq_domain_remove(bank->domain);
+		return 0;
+	}
+
+	gc = irq_get_domain_generic_chip(bank->domain, 0);
+	gc->reg_base	= bank->reg;
+
+	/* level chip type */
+	gc->chip_types[0].type			= IRQ_TYPE_LEVEL_MASK;
+	gc->chip_types[0].handler		= handle_level_irq;
+	gc->chip_types[0].regs.ack		= REG_GPIO_IRQ_STS;
+	gc->chip_types[0].regs.mask		= REG_GPIO_IRQ_EN;
+	gc->chip_types[0].chip.irq_startup	= gpio_startup_irq,
+	gc->chip_types[0].chip.irq_ack		= irq_gc_ack_clr_bit,
+	gc->chip_types[0].chip.irq_mask		= irq_gc_mask_clr_bit,
+	gc->chip_types[0].chip.irq_unmask	= irq_gc_mask_set_bit,
+	gc->chip_types[0].chip.irq_set_type	= gpio_set_irq_type,
+	gc->chip_types[0].chip.irq_set_wake	= gpio_set_irq_wake,
+	gc->chip_types[0].chip.flags		= IRQCHIP_MASK_ON_SUSPEND,
+
+	/* edge chip type */
+	gc->chip_types[1].type			= IRQ_TYPE_EDGE_BOTH;
+	gc->chip_types[1].handler		= handle_edge_irq;
+	gc->chip_types[1].regs.ack		= REG_GPIO_IRQ_STS;
+	gc->chip_types[1].regs.mask		= REG_GPIO_IRQ_EN;
+	gc->chip_types[1].chip.irq_startup	= gpio_startup_irq,
+	gc->chip_types[1].chip.irq_ack		= irq_gc_ack_clr_bit,
+	gc->chip_types[1].chip.irq_mask		= irq_gc_mask_clr_bit,
+	gc->chip_types[1].chip.irq_unmask	= irq_gc_mask_set_bit,
+	gc->chip_types[1].chip.irq_set_type	= gpio_set_irq_type,
+	gc->chip_types[1].chip.irq_set_wake	= gpio_set_irq_wake,
+	gc->chip_types[1].chip.flags		= IRQCHIP_MASK_ON_SUSPEND,
+
 	/* Setup chained handler for this GPIO bank */
 	irq_set_handler_data(bank->irq, bank);
 	irq_set_chained_handler(bank->irq, tz1090_gpio_irq_handler);
-- 
1.8.1.2


