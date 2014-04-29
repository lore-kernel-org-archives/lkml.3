Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934061AbaD2SHZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 14:07:25 -0400
Received: from mail-qa0-f41.google.com ([209.85.216.41]:44986 "EHLO
	mail-qa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934032AbaD2SGt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 14:06:49 -0400
From: Linus Walleij <linus.walleij@linaro.org>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: linux-gpio@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>,
        Bjorn Andersson <bjorn.andersson@sonymobile.com>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Josh Cartwright <joshc@codeaurora.org>
Subject: [PATCH] RFT: pinctrl: msm: switch to using generic GPIO irqchip helpers
Date: Tue, 29 Apr 2014 11:06:34 -0700
Message-Id: <1398794794-28920-1-git-send-email-linus.walleij@linaro.org>
X-Mailer: git-send-email 1.9.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This switches the Qualcomm MSM pin control driver over to using
the generic GPIO irqchip helpers.

Cc: Bjorn Andersson <bjorn.andersson@sonymobile.com>
Cc: Stephen Boyd <sboyd@codeaurora.org>
Cc: Josh Cartwright <joshc@codeaurora.org>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
Stephen: you may get the lockdep warnings back if you use this
with the pinctrl tree only, but the GPIO tree also has this patch:
http://marc.info/?l=linux-gpio&m=139817061114511&w=2

Björn: you may see the HW setup happening for each interrupt, but
the GPIO tree also has this patch:
http://marc.info/?l=linux-gpio&m=139826462511107&w=2
---
 drivers/pinctrl/Kconfig       |  1 +
 drivers/pinctrl/pinctrl-msm.c | 99 ++++++++++++-------------------------------
 2 files changed, 28 insertions(+), 72 deletions(-)

diff --git a/drivers/pinctrl/Kconfig b/drivers/pinctrl/Kconfig
index 934fd89978d3..4f7b8397e0af 100644
--- a/drivers/pinctrl/Kconfig
+++ b/drivers/pinctrl/Kconfig
@@ -224,6 +224,7 @@ config PINCTRL_MSM
 	select PINMUX
 	select PINCONF
 	select GENERIC_PINCONF
+	select GPIOLIB_IRQCHIP
 
 config PINCTRL_APQ8064
 	tristate "Qualcomm APQ8064 pin controller driver"
diff --git a/drivers/pinctrl/pinctrl-msm.c b/drivers/pinctrl/pinctrl-msm.c
index 5fa9341cc589..df6dda4ce803 100644
--- a/drivers/pinctrl/pinctrl-msm.c
+++ b/drivers/pinctrl/pinctrl-msm.c
@@ -13,7 +13,6 @@
  */
 
 #include <linux/err.h>
-#include <linux/irqdomain.h>
 #include <linux/io.h>
 #include <linux/module.h>
 #include <linux/of.h>
@@ -26,8 +25,6 @@
 #include <linux/slab.h>
 #include <linux/gpio.h>
 #include <linux/interrupt.h>
-#include <linux/irq.h>
-#include <linux/irqchip/chained_irq.h>
 #include <linux/spinlock.h>
 
 #include "core.h"
@@ -41,7 +38,6 @@
  * struct msm_pinctrl - state for a pinctrl-msm device
  * @dev:            device handle.
  * @pctrl:          pinctrl handle.
- * @domain:         irqdomain handle.
  * @chip:           gpiochip handle.
  * @irq:            parent irq for the TLMM irq_chip.
  * @lock:           Spinlock to protect register resources as well
@@ -55,7 +51,6 @@
 struct msm_pinctrl {
 	struct device *dev;
 	struct pinctrl_dev *pctrl;
-	struct irq_domain *domain;
 	struct gpio_chip chip;
 	int irq;
 
@@ -68,6 +63,11 @@ struct msm_pinctrl {
 	void __iomem *regs;
 };
 
+static inline struct msm_pinctrl *to_msm_pinctrl(struct gpio_chip *gc)
+{
+	return container_of(gc, struct msm_pinctrl, chip);
+}
+
 static int msm_get_groups_count(struct pinctrl_dev *pctldev)
 {
 	struct msm_pinctrl *pctrl = pinctrl_dev_get_drvdata(pctldev);
@@ -480,13 +480,6 @@ static void msm_gpio_set(struct gpio_chip *chip, unsigned offset, int value)
 	spin_unlock_irqrestore(&pctrl->lock, flags);
 }
 
-static int msm_gpio_to_irq(struct gpio_chip *chip, unsigned offset)
-{
-	struct msm_pinctrl *pctrl = container_of(chip, struct msm_pinctrl, chip);
-
-	return irq_find_mapping(pctrl->domain, offset);
-}
-
 static int msm_gpio_request(struct gpio_chip *chip, unsigned offset)
 {
 	int gpio = chip->base + offset;
@@ -556,7 +549,6 @@ static struct gpio_chip msm_gpio_template = {
 	.direction_output = msm_gpio_direction_output,
 	.get              = msm_gpio_get,
 	.set              = msm_gpio_set,
-	.to_irq           = msm_gpio_to_irq,
 	.request          = msm_gpio_request,
 	.free             = msm_gpio_free,
 	.dbg_show         = msm_gpio_dbg_show,
@@ -608,12 +600,12 @@ static void msm_gpio_update_dual_edge_pos(struct msm_pinctrl *pctrl,
 
 static void msm_gpio_irq_mask(struct irq_data *d)
 {
+	struct gpio_chip *gc = irq_data_get_irq_chip_data(d);
+	struct msm_pinctrl *pctrl = to_msm_pinctrl(gc);
 	const struct msm_pingroup *g;
-	struct msm_pinctrl *pctrl;
 	unsigned long flags;
 	u32 val;
 
-	pctrl = irq_data_get_irq_chip_data(d);
 	g = &pctrl->soc->groups[d->hwirq];
 
 	spin_lock_irqsave(&pctrl->lock, flags);
@@ -629,12 +621,12 @@ static void msm_gpio_irq_mask(struct irq_data *d)
 
 static void msm_gpio_irq_unmask(struct irq_data *d)
 {
+	struct gpio_chip *gc = irq_data_get_irq_chip_data(d);
+	struct msm_pinctrl *pctrl = to_msm_pinctrl(gc);
 	const struct msm_pingroup *g;
-	struct msm_pinctrl *pctrl;
 	unsigned long flags;
 	u32 val;
 
-	pctrl = irq_data_get_irq_chip_data(d);
 	g = &pctrl->soc->groups[d->hwirq];
 
 	spin_lock_irqsave(&pctrl->lock, flags);
@@ -654,12 +646,12 @@ static void msm_gpio_irq_unmask(struct irq_data *d)
 
 static void msm_gpio_irq_ack(struct irq_data *d)
 {
+	struct gpio_chip *gc = irq_data_get_irq_chip_data(d);
+	struct msm_pinctrl *pctrl = to_msm_pinctrl(gc);
 	const struct msm_pingroup *g;
-	struct msm_pinctrl *pctrl;
 	unsigned long flags;
 	u32 val;
 
-	pctrl = irq_data_get_irq_chip_data(d);
 	g = &pctrl->soc->groups[d->hwirq];
 
 	spin_lock_irqsave(&pctrl->lock, flags);
@@ -681,12 +673,12 @@ static void msm_gpio_irq_ack(struct irq_data *d)
 
 static int msm_gpio_irq_set_type(struct irq_data *d, unsigned int type)
 {
+	struct gpio_chip *gc = irq_data_get_irq_chip_data(d);
+	struct msm_pinctrl *pctrl = to_msm_pinctrl(gc);
 	const struct msm_pingroup *g;
-	struct msm_pinctrl *pctrl;
 	unsigned long flags;
 	u32 val;
 
-	pctrl = irq_data_get_irq_chip_data(d);
 	g = &pctrl->soc->groups[d->hwirq];
 
 	spin_lock_irqsave(&pctrl->lock, flags);
@@ -775,11 +767,10 @@ static int msm_gpio_irq_set_type(struct irq_data *d, unsigned int type)
 
 static int msm_gpio_irq_set_wake(struct irq_data *d, unsigned int on)
 {
-	struct msm_pinctrl *pctrl;
+	struct gpio_chip *gc = irq_data_get_irq_chip_data(d);
+	struct msm_pinctrl *pctrl = to_msm_pinctrl(gc);
 	unsigned long flags;
 
-	pctrl = irq_data_get_irq_chip_data(d);
-
 	spin_lock_irqsave(&pctrl->lock, flags);
 
 	irq_set_irq_wake(pctrl->irq, on);
@@ -789,25 +780,6 @@ static int msm_gpio_irq_set_wake(struct irq_data *d, unsigned int on)
 	return 0;
 }
 
-static int msm_gpio_irq_reqres(struct irq_data *d)
-{
-	struct msm_pinctrl *pctrl = irq_data_get_irq_chip_data(d);
-
-	if (gpio_lock_as_irq(&pctrl->chip, d->hwirq)) {
-		dev_err(pctrl->dev, "unable to lock HW IRQ %lu for IRQ\n",
-			d->hwirq);
-		return -EINVAL;
-	}
-	return 0;
-}
-
-static void msm_gpio_irq_relres(struct irq_data *d)
-{
-	struct msm_pinctrl *pctrl = irq_data_get_irq_chip_data(d);
-
-	gpio_unlock_as_irq(&pctrl->chip, d->hwirq);
-}
-
 static struct irq_chip msm_gpio_irq_chip = {
 	.name           = "msmgpio",
 	.irq_mask       = msm_gpio_irq_mask,
@@ -815,14 +787,13 @@ static struct irq_chip msm_gpio_irq_chip = {
 	.irq_ack        = msm_gpio_irq_ack,
 	.irq_set_type   = msm_gpio_irq_set_type,
 	.irq_set_wake   = msm_gpio_irq_set_wake,
-	.irq_request_resources = msm_gpio_irq_reqres,
-	.irq_release_resources = msm_gpio_irq_relres,
 };
 
 static void msm_gpio_irq_handler(unsigned int irq, struct irq_desc *desc)
 {
+	struct gpio_chip *gc = irq_desc_get_handler_data(desc);
 	const struct msm_pingroup *g;
-	struct msm_pinctrl *pctrl = irq_desc_get_handler_data(desc);
+	struct msm_pinctrl *pctrl = to_msm_pinctrl(gc);
 	struct irq_chip *chip = irq_get_chip(irq);
 	int irq_pin;
 	int handled = 0;
@@ -839,7 +810,7 @@ static void msm_gpio_irq_handler(unsigned int irq, struct irq_desc *desc)
 		g = &pctrl->soc->groups[i];
 		val = readl(pctrl->regs + g->intr_status_reg);
 		if (val & BIT(g->intr_status_bit)) {
-			irq_pin = irq_find_mapping(pctrl->domain, i);
+			irq_pin = irq_find_mapping(gc->irqdomain, i);
 			generic_handle_irq(irq_pin);
 			handled++;
 		}
@@ -852,19 +823,10 @@ static void msm_gpio_irq_handler(unsigned int irq, struct irq_desc *desc)
 	chained_irq_exit(chip, desc);
 }
 
-/*
- * This lock class tells lockdep that GPIO irqs are in a different
- * category than their parents, so it won't report false recursion.
- */
-static struct lock_class_key gpio_lock_class;
-
 static int msm_gpio_init(struct msm_pinctrl *pctrl)
 {
 	struct gpio_chip *chip;
-	int irq;
 	int ret;
-	int i;
-	int r;
 	unsigned ngpio = pctrl->soc->ngpios;
 
 	if (WARN_ON(ngpio > MAX_NR_GPIO))
@@ -890,23 +852,18 @@ static int msm_gpio_init(struct msm_pinctrl *pctrl)
 		return ret;
 	}
 
-	pctrl->domain = irq_domain_add_linear(pctrl->dev->of_node, chip->ngpio,
-					      &irq_domain_simple_ops, NULL);
-	if (!pctrl->domain) {
-		dev_err(pctrl->dev, "Failed to register irq domain\n");
-		r = gpiochip_remove(&pctrl->chip);
+	ret = gpiochip_irqchip_add(chip,
+				   &msm_gpio_irq_chip,
+				   0,
+				   handle_edge_irq,
+				   IRQ_TYPE_NONE);
+	if (ret) {
+		dev_err(pctrl->dev, "Failed to add irqchip to gpiochip\n");
 		return -ENOSYS;
 	}
 
-	for (i = 0; i < chip->ngpio; i++) {
-		irq = irq_create_mapping(pctrl->domain, i);
-		irq_set_lockdep_class(irq, &gpio_lock_class);
-		irq_set_chip_and_handler(irq, &msm_gpio_irq_chip, handle_edge_irq);
-		irq_set_chip_data(irq, pctrl);
-	}
-
-	irq_set_handler_data(pctrl->irq, pctrl);
-	irq_set_chained_handler(pctrl->irq, msm_gpio_irq_handler);
+	gpiochip_set_chained_irqchip(chip, &msm_gpio_irq_chip, pctrl->irq,
+				     msm_gpio_irq_handler);
 
 	return 0;
 }
@@ -974,8 +931,6 @@ int msm_pinctrl_remove(struct platform_device *pdev)
 		return ret;
 	}
 
-	irq_set_chained_handler(pctrl->irq, NULL);
-	irq_domain_remove(pctrl->domain);
 	pinctrl_unregister(pctrl->pctrl);
 
 	return 0;
-- 
1.9.0

