Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753420AbaDDObN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 10:31:13 -0400
Received: from mail-wi0-f176.google.com ([209.85.212.176]:36981 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753169AbaDDObK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 10:31:10 -0400
From: Linus Walleij <linus.walleij@linaro.org>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: linux-gpio@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>,
        Srinivas Kandagatla <srinivas.kandagatla@st.com>,
        Maxime COQUELIN <maxime.coquelin@st.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>
Subject: [PATCH] RFT: pinctrl: st: use gpiolib irqchip helpers
Date: Fri,  4 Apr 2014 16:31:00 +0200
Message-Id: <1396621860-4699-1-git-send-email-linus.walleij@linaro.org>
X-Mailer: git-send-email 1.9.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This lets the gpiolib core handle the irqchip set-up and
chained IRQ on the primary (behind the mux) IRQ chip in
the st pinctrl driver.

Cc: Srinivas Kandagatla <srinivas.kandagatla@st.com>
Cc: Maxime COQUELIN <maxime.coquelin@st.com>
Cc: Giuseppe Cavallaro <peppe.cavallaro@st.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
Hi ST folks, this is a rough sketch of how to use the new
gpiolib-provided irqchip in this driver, please test this as
I don't have this hardware. It requires the previous patch
patching the resource callbacks.
---
 drivers/pinctrl/Kconfig      |  1 +
 drivers/pinctrl/pinctrl-st.c | 99 ++++++++------------------------------------
 2 files changed, 19 insertions(+), 81 deletions(-)

diff --git a/drivers/pinctrl/Kconfig b/drivers/pinctrl/Kconfig
index e49324032611..3372b689a3aa 100644
--- a/drivers/pinctrl/Kconfig
+++ b/drivers/pinctrl/Kconfig
@@ -281,6 +281,7 @@ config PINCTRL_ST
 	depends on OF
 	select PINMUX
 	select PINCONF
+	select GPIOLIB_IRQCHIP
 
 config PINCTRL_TEGRA
 	bool
diff --git a/drivers/pinctrl/pinctrl-st.c b/drivers/pinctrl/pinctrl-st.c
index 639af4a9a2e4..42d1b8905ac4 100644
--- a/drivers/pinctrl/pinctrl-st.c
+++ b/drivers/pinctrl/pinctrl-st.c
@@ -13,10 +13,6 @@
 #include <linux/slab.h>
 #include <linux/err.h>
 #include <linux/io.h>
-#include <linux/irq.h>
-#include <linux/irqdesc.h>
-#include <linux/irqdomain.h>
-#include <linux/irqchip/chained_irq.h>
 #include <linux/of.h>
 #include <linux/of_irq.h>
 #include <linux/of_gpio.h>
@@ -321,7 +317,6 @@ struct st_gpio_bank {
 	struct pinctrl_gpio_range	range;
 	void __iomem			*base;
 	struct st_pio_control		pc;
-	struct	irq_domain		*domain;
 	unsigned long			irq_edge_conf;
 	spinlock_t                      lock;
 };
@@ -1285,56 +1280,26 @@ static int st_pctl_parse_functions(struct device_node *np,
 	return 0;
 }
 
-static int st_gpio_to_irq(struct gpio_chip *chip, unsigned offset)
-{
-	struct st_gpio_bank *bank = gpio_chip_to_bank(chip);
-	int irq = -ENXIO;
-
-	if (offset < chip->ngpio)
-		irq = irq_find_mapping(bank->domain, offset);
-
-	dev_info(chip->dev, "%s: request IRQ for GPIO %d, return %d\n",
-				chip->label, offset + chip->base, irq);
-	return irq;
-}
-
 static void st_gpio_irq_mask(struct irq_data *d)
 {
-	struct st_gpio_bank *bank = irq_data_get_irq_chip_data(d);
+	struct gpio_chip *gc = irq_data_get_irq_chip_data(d);
+	struct st_gpio_bank *bank = gpio_chip_to_bank(gc);
 
 	writel(BIT(d->hwirq), bank->base + REG_PIO_CLR_PMASK);
 }
 
 static void st_gpio_irq_unmask(struct irq_data *d)
 {
-	struct st_gpio_bank *bank = irq_data_get_irq_chip_data(d);
+	struct gpio_chip *gc = irq_data_get_irq_chip_data(d);
+	struct st_gpio_bank *bank = gpio_chip_to_bank(gc);
 
 	writel(BIT(d->hwirq), bank->base + REG_PIO_SET_PMASK);
 }
 
-static int st_gpio_irq_reqres(struct irq_data *d)
-{
-	struct st_gpio_bank *bank = irq_data_get_irq_chip_data(d);
-
-	if (gpio_lock_as_irq(&bank->gpio_chip, d->hwirq)) {
-		dev_err(bank->gpio_chip.dev,
-			"unable to lock HW IRQ %lu for IRQ\n",
-			d->hwirq);
-		return -EINVAL;
-	}
-	return 0;
-}
-
-static void st_gpio_irq_relres(struct irq_data *d)
-{
-	struct st_gpio_bank *bank = irq_data_get_irq_chip_data(d);
-
-	gpio_unlock_as_irq(&bank->gpio_chip, d->hwirq);
-}
-
 static int st_gpio_irq_set_type(struct irq_data *d, unsigned type)
 {
-	struct st_gpio_bank *bank = irq_data_get_irq_chip_data(d);
+	struct gpio_chip *gc = irq_data_get_irq_chip_data(d);
+	struct st_gpio_bank *bank = gpio_chip_to_bank(gc);
 	unsigned long flags;
 	int comp, pin = d->hwirq;
 	u32 val;
@@ -1438,7 +1403,7 @@ static void __gpio_irq_handler(struct st_gpio_bank *bank)
 					continue;
 			}
 
-			generic_handle_irq(irq_find_mapping(bank->domain, n));
+			generic_handle_irq(irq_find_mapping(bank->gpio_chip.irqdomain, n));
 		}
 	}
 }
@@ -1447,7 +1412,8 @@ static void st_gpio_irq_handler(unsigned irq, struct irq_desc *desc)
 {
 	/* interrupt dedicated per bank */
 	struct irq_chip *chip = irq_get_chip(irq);
-	struct st_gpio_bank *bank = irq_get_handler_data(irq);
+	struct gpio_chip *gc = irq_desc_get_handler_data(desc);
+	struct st_gpio_bank *bank = gpio_chip_to_bank(gc);
 
 	chained_irq_enter(chip, desc);
 	__gpio_irq_handler(bank);
@@ -1481,7 +1447,6 @@ static struct gpio_chip st_gpio_template = {
 	.ngpio			= ST_GPIO_PINS_PER_BANK,
 	.of_gpio_n_cells	= 1,
 	.of_xlate		= st_gpio_xlate,
-	.to_irq			= st_gpio_to_irq,
 };
 
 static struct irq_chip st_gpio_irqchip = {
@@ -1489,26 +1454,6 @@ static struct irq_chip st_gpio_irqchip = {
 	.irq_mask	= st_gpio_irq_mask,
 	.irq_unmask	= st_gpio_irq_unmask,
 	.irq_set_type	= st_gpio_irq_set_type,
-	.irq_request_resources = st_gpio_irq_reqres,
-	.irq_release_resources = st_gpio_irq_relres,
-};
-
-static int st_gpio_irq_domain_map(struct irq_domain *h,
-			unsigned int virq, irq_hw_number_t hw)
-{
-	struct st_gpio_bank *bank = h->host_data;
-
-	irq_set_chip(virq, &st_gpio_irqchip);
-	irq_set_handler(virq, handle_simple_irq);
-	set_irq_flags(virq, IRQF_VALID);
-	irq_set_chip_data(virq, bank);
-
-	return 0;
-}
-
-static struct irq_domain_ops st_gpio_irq_ops = {
-	.map	= st_gpio_irq_domain_map,
-	.xlate	= irq_domain_xlate_twocell,
 };
 
 static int st_gpiolib_register_bank(struct st_pinctrl *info,
@@ -1519,7 +1464,7 @@ static int st_gpiolib_register_bank(struct st_pinctrl *info,
 	struct device *dev = info->dev;
 	int bank_num = of_alias_get_id(np, "gpio");
 	struct resource res, irq_res;
-	int gpio_irq = 0, err, i;
+	int gpio_irq = 0, err;
 
 	if (of_address_to_resource(np, 0, &res))
 		return -ENODEV;
@@ -1569,26 +1514,18 @@ static int st_gpiolib_register_bank(struct st_pinctrl *info,
 
 	if (of_irq_to_resource(np, 0, &irq_res)) {
 		gpio_irq = irq_res.start;
-		irq_set_chained_handler(gpio_irq, st_gpio_irq_handler);
-		irq_set_handler_data(gpio_irq, bank);
+		gpiochip_set_chained_irqchip(&bank->gpio_chip, &st_gpio_irqchip,
+					     gpio_irq, st_gpio_irq_handler);
 	}
 
 	if (info->irqmux_base > 0 || gpio_irq > 0) {
-		/* Setup IRQ domain */
-		bank->domain  = irq_domain_add_linear(np,
-						ST_GPIO_PINS_PER_BANK,
-						&st_gpio_irq_ops, bank);
-		if (!bank->domain) {
-			dev_err(dev, "Failed to add irq domain for %s\n",
-				np->full_name);
-		} else  {
-			for (i = 0; i < ST_GPIO_PINS_PER_BANK; i++) {
-				if (irq_create_mapping(bank->domain, i) < 0)
-					dev_err(dev,
-						"Failed to map IRQ %i\n", i);
-			}
+		err = gpiochip_irqchip_add(&bank->gpio_chip, &st_gpio_irqchip,
+					   0, handle_simple_irq,
+					   IRQ_TYPE_NONE);
+		if (err) {
+			dev_info(dev, "could not add irqchip\n");
+			return err;
 		}
-
 	} else {
 		dev_info(dev, "No IRQ support for %s bank\n", np->full_name);
 	}
-- 
1.9.0

