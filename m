Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753453AbaCYMwy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2014 08:52:54 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:35892 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753281AbaCYMwp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2014 08:52:45 -0400
From: Linus Walleij <linus.walleij@linaro.org>
To: linux-gpio@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Cc: Alexandre Courbot <acourbot@nvidia.com>, linux-kernel@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 3/4] pinctrl: nomadik: convert driver to use gpiolib irqchip
Date: Tue, 25 Mar 2014 13:51:33 +0100
Message-Id: <1395751894-7110-4-git-send-email-linus.walleij@linaro.org>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1395751894-7110-1-git-send-email-linus.walleij@linaro.org>
References: <1395751894-7110-1-git-send-email-linus.walleij@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This converts the Nomadik pin control driver to register its
chained irq handler and irqchip using the helpers in the
gpiolib core.

Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/pinctrl/Kconfig           |   3 +
 drivers/pinctrl/pinctrl-nomadik.c | 123 ++++++++++----------------------------
 2 files changed, 36 insertions(+), 90 deletions(-)

diff --git a/drivers/pinctrl/Kconfig b/drivers/pinctrl/Kconfig
index 1e4e69384baa..a05087bd1955 100644
--- a/drivers/pinctrl/Kconfig
+++ b/drivers/pinctrl/Kconfig
@@ -235,6 +235,9 @@ config PINCTRL_NOMADIK
 	depends on ARCH_U8500 || ARCH_NOMADIK
 	select PINMUX
 	select PINCONF
+	select GPIOLIB
+	select OF_GPIO
+	select GPIOLIB_IRQCHIP
 
 config PINCTRL_STN8815
 	bool "STN8815 pin controller driver"
diff --git a/drivers/pinctrl/pinctrl-nomadik.c b/drivers/pinctrl/pinctrl-nomadik.c
index 98a36a0969f9..db0cc30c82de 100644
--- a/drivers/pinctrl/pinctrl-nomadik.c
+++ b/drivers/pinctrl/pinctrl-nomadik.c
@@ -21,9 +21,6 @@
 #include <linux/gpio.h>
 #include <linux/spinlock.h>
 #include <linux/interrupt.h>
-#include <linux/irq.h>
-#include <linux/irqdomain.h>
-#include <linux/irqchip/chained_irq.h>
 #include <linux/slab.h>
 #include <linux/of_device.h>
 #include <linux/of_address.h>
@@ -248,7 +245,6 @@ enum nmk_gpio_slpm {
 
 struct nmk_gpio_chip {
 	struct gpio_chip chip;
-	struct irq_domain *domain;
 	void __iomem *addr;
 	struct clk *clk;
 	unsigned int bank;
@@ -419,7 +415,7 @@ nmk_gpio_disable_lazy_irq(struct nmk_gpio_chip *nmk_chip, unsigned offset)
 	u32 falling = nmk_chip->fimsc & BIT(offset);
 	u32 rising = nmk_chip->rimsc & BIT(offset);
 	int gpio = nmk_chip->chip.base + offset;
-	int irq = irq_find_mapping(nmk_chip->domain, offset);
+	int irq = irq_find_mapping(nmk_chip->chip.irqdomain, offset);
 	struct irq_data *d = irq_get_irq_data(irq);
 
 	if (!rising && !falling)
@@ -647,11 +643,8 @@ static inline int nmk_gpio_get_bitmask(int gpio)
 
 static void nmk_gpio_irq_ack(struct irq_data *d)
 {
-	struct nmk_gpio_chip *nmk_chip;
-
-	nmk_chip = irq_data_get_irq_chip_data(d);
-	if (!nmk_chip)
-		return;
+	struct gpio_chip *chip = irq_data_get_irq_chip_data(d);
+	struct nmk_gpio_chip *nmk_chip = container_of(chip, struct nmk_gpio_chip, chip);
 
 	clk_enable(nmk_chip->clk);
 	writel(nmk_gpio_get_bitmask(d->hwirq), nmk_chip->addr + NMK_GPIO_IC);
@@ -848,26 +841,6 @@ static void nmk_gpio_irq_shutdown(struct irq_data *d)
 	clk_disable(nmk_chip->clk);
 }
 
-static int nmk_gpio_irq_reqres(struct irq_data *d)
-{
-	struct nmk_gpio_chip *nmk_chip = irq_data_get_irq_chip_data(d);
-
-	if (gpio_lock_as_irq(&nmk_chip->chip, d->hwirq)) {
-		dev_err(nmk_chip->chip.dev,
-			"unable to lock HW IRQ %lu for IRQ\n",
-			d->hwirq);
-		return -EINVAL;
-	}
-	return 0;
-}
-
-static void nmk_gpio_irq_relres(struct irq_data *d)
-{
-	struct nmk_gpio_chip *nmk_chip = irq_data_get_irq_chip_data(d);
-
-	gpio_unlock_as_irq(&nmk_chip->chip, d->hwirq);
-}
-
 static struct irq_chip nmk_gpio_irq_chip = {
 	.name		= "Nomadik-GPIO",
 	.irq_ack	= nmk_gpio_irq_ack,
@@ -877,24 +850,21 @@ static struct irq_chip nmk_gpio_irq_chip = {
 	.irq_set_wake	= nmk_gpio_irq_set_wake,
 	.irq_startup	= nmk_gpio_irq_startup,
 	.irq_shutdown	= nmk_gpio_irq_shutdown,
-	.irq_request_resources = nmk_gpio_irq_reqres,
-	.irq_release_resources = nmk_gpio_irq_relres,
 	.flags		= IRQCHIP_MASK_ON_SUSPEND,
 };
 
 static void __nmk_gpio_irq_handler(unsigned int irq, struct irq_desc *desc,
 				   u32 status)
 {
-	struct nmk_gpio_chip *nmk_chip;
 	struct irq_chip *host_chip = irq_get_chip(irq);
+	struct gpio_chip *chip = irq_desc_get_handler_data(desc);
 
 	chained_irq_enter(host_chip, desc);
 
-	nmk_chip = irq_get_handler_data(irq);
 	while (status) {
 		int bit = __ffs(status);
 
-		generic_handle_irq(irq_find_mapping(nmk_chip->domain, bit));
+		generic_handle_irq(irq_find_mapping(chip->irqdomain, bit));
 		status &= ~BIT(bit);
 	}
 
@@ -903,9 +873,11 @@ static void __nmk_gpio_irq_handler(unsigned int irq, struct irq_desc *desc,
 
 static void nmk_gpio_irq_handler(unsigned int irq, struct irq_desc *desc)
 {
-	struct nmk_gpio_chip *nmk_chip = irq_get_handler_data(irq);
+	struct gpio_chip *chip = irq_desc_get_handler_data(desc);
+	struct nmk_gpio_chip *nmk_chip = container_of(chip, struct nmk_gpio_chip, chip);
 	u32 status;
 
+	pr_err("PLONK IRQ %d\n", irq);
 	clk_enable(nmk_chip->clk);
 	status = readl(nmk_chip->addr + NMK_GPIO_IS);
 	clk_disable(nmk_chip->clk);
@@ -916,26 +888,13 @@ static void nmk_gpio_irq_handler(unsigned int irq, struct irq_desc *desc)
 static void nmk_gpio_latent_irq_handler(unsigned int irq,
 					   struct irq_desc *desc)
 {
-	struct nmk_gpio_chip *nmk_chip = irq_get_handler_data(irq);
+	struct gpio_chip *chip = irq_desc_get_handler_data(desc);
+	struct nmk_gpio_chip *nmk_chip = container_of(chip, struct nmk_gpio_chip, chip);
 	u32 status = nmk_chip->get_latent_status(nmk_chip->bank);
 
 	__nmk_gpio_irq_handler(irq, desc, status);
 }
 
-static int nmk_gpio_init_irq(struct nmk_gpio_chip *nmk_chip)
-{
-	irq_set_chained_handler(nmk_chip->parent_irq, nmk_gpio_irq_handler);
-	irq_set_handler_data(nmk_chip->parent_irq, nmk_chip);
-
-	if (nmk_chip->latent_parent_irq >= 0) {
-		irq_set_chained_handler(nmk_chip->latent_parent_irq,
-					nmk_gpio_latent_irq_handler);
-		irq_set_handler_data(nmk_chip->latent_parent_irq, nmk_chip);
-	}
-
-	return 0;
-}
-
 /* I/O Functions */
 
 static int nmk_gpio_request(struct gpio_chip *chip, unsigned offset)
@@ -1014,14 +973,6 @@ static int nmk_gpio_make_output(struct gpio_chip *chip, unsigned offset,
 	return 0;
 }
 
-static int nmk_gpio_to_irq(struct gpio_chip *chip, unsigned offset)
-{
-	struct nmk_gpio_chip *nmk_chip =
-		container_of(chip, struct nmk_gpio_chip, chip);
-
-	return irq_create_mapping(nmk_chip->domain, offset);
-}
-
 #ifdef CONFIG_DEBUG_FS
 
 #include <linux/seq_file.h>
@@ -1120,7 +1071,6 @@ static struct gpio_chip nmk_gpio_template = {
 	.get			= nmk_gpio_get_input,
 	.direction_output	= nmk_gpio_make_output,
 	.set			= nmk_gpio_set_output,
-	.to_irq			= nmk_gpio_to_irq,
 	.dbg_show		= nmk_gpio_dbg_show,
 	.can_sleep		= false,
 };
@@ -1221,27 +1171,6 @@ void nmk_gpio_read_pull(int gpio_bank, u32 *pull_up)
 	}
 }
 
-static int nmk_gpio_irq_map(struct irq_domain *d, unsigned int irq,
-			    irq_hw_number_t hwirq)
-{
-	struct nmk_gpio_chip *nmk_chip = d->host_data;
-
-	if (!nmk_chip)
-		return -EINVAL;
-
-	irq_set_chip_and_handler(irq, &nmk_gpio_irq_chip, handle_edge_irq);
-	set_irq_flags(irq, IRQF_VALID);
-	irq_set_chip_data(irq, nmk_chip);
-	irq_set_irq_type(irq, IRQ_TYPE_EDGE_FALLING);
-
-	return 0;
-}
-
-static const struct irq_domain_ops nmk_gpio_irq_simple_ops = {
-	.map = nmk_gpio_irq_map,
-	.xlate = irq_domain_xlate_twocell,
-};
-
 static int nmk_gpio_probe(struct platform_device *dev)
 {
 	struct device_node *np = dev->dev.of_node;
@@ -1321,17 +1250,31 @@ static int nmk_gpio_probe(struct platform_device *dev)
 
 	platform_set_drvdata(dev, nmk_chip);
 
-	nmk_chip->domain = irq_domain_add_simple(np,
-				NMK_GPIO_PER_CHIP, 0,
-				&nmk_gpio_irq_simple_ops, nmk_chip);
-	if (!nmk_chip->domain) {
-		dev_err(&dev->dev, "failed to create irqdomain\n");
-		/* Just do this, no matter if it fails */
+	/*
+	 * Let the generic code handle this edge IRQ, the the chained
+	 * handler will perform the actual work of handling the parent
+	 * interrupt.
+	 */
+	ret = gpiochip_irqchip_add(&nmk_chip->chip,
+				   &nmk_gpio_irq_chip,
+				   0,
+				   handle_edge_irq,
+				   IRQ_TYPE_EDGE_FALLING);
+	if (ret) {
+		dev_err(&dev->dev, "could not add irqchip\n");
 		ret = gpiochip_remove(&nmk_chip->chip);
-		return -ENOSYS;
+		return -ENODEV;
 	}
-
-	nmk_gpio_init_irq(nmk_chip);
+	/* Then register the chain on the parent IRQ */
+	gpiochip_set_chained_irqchip(&nmk_chip->chip,
+				     &nmk_gpio_irq_chip,
+				     nmk_chip->parent_irq,
+				     nmk_gpio_irq_handler);
+	if (nmk_chip->latent_parent_irq > 0)
+		gpiochip_set_chained_irqchip(&nmk_chip->chip,
+					     &nmk_gpio_irq_chip,
+					     nmk_chip->latent_parent_irq,
+					     nmk_gpio_latent_irq_handler);
 
 	dev_info(&dev->dev, "at address %p\n", nmk_chip->addr);
 
-- 
1.8.5.3

