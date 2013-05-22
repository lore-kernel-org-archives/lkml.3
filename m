Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753514Ab3EVHKM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 03:10:12 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:56823 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753147Ab3EVHKG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 03:10:06 -0400
From: Philip Avinash <avinashphilip@ti.com>
To: <nsekhar@ti.com>, <khilman@deeprootsystems.com>, <linux@arm.linux.org.uk>,
        <grant.likely@secretlab.ca>, <linus.walleij@linaro.org>
CC: <linux-arm-kernel@lists.infradead.org>,
        <davinci-linux-open-source@linux.davincidsp.com>,
        <linux-kernel@vger.kernel.org>, Philip Avinash <avinashphilip@ti.com>
Subject: [PATCH 02/11] gpio: davinci: coding style correction
Date: Wed, 22 May 2013 12:40:25 +0530
Message-ID: <1369206634-6778-3-git-send-email-avinashphilip@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1369206634-6778-1-git-send-email-avinashphilip@ti.com>
References: <1369206634-6778-1-git-send-email-avinashphilip@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

1. Corrects coding and commenting styles
2. Variables name change to meaningful name
3. Remove unnecessary variable usage
4. Add BINTEN macro definition

Signed-off-by: Philip Avinash <avinashphilip@ti.com>
---
 drivers/gpio/gpio-davinci.c |  182 +++++++++++++++++++++----------------------
 1 file changed, 89 insertions(+), 93 deletions(-)

diff --git a/drivers/gpio/gpio-davinci.c b/drivers/gpio/gpio-davinci.c
index 17df6db..d308955 100644
--- a/drivers/gpio/gpio-davinci.c
+++ b/drivers/gpio/gpio-davinci.c
@@ -9,12 +9,12 @@
  * the Free Software Foundation; either version 2 of the License, or
  * (at your option) any later version.
  */
-#include <linux/gpio.h>
-#include <linux/errno.h>
-#include <linux/kernel.h>
+
 #include <linux/clk.h>
-#include <linux/err.h>
+#include <linux/errno.h>
+#include <linux/gpio.h>
 #include <linux/io.h>
+#include <linux/kernel.h>
 
 #include <asm/mach/irq.h>
 
@@ -31,10 +31,11 @@ struct davinci_gpio_regs {
 	u32	intstat;
 };
 
+#define BINTEN	0x08 /* GPIO Interrupt Per-Bank Enable Register */
 #define chip2controller(chip)	\
 	container_of(chip, struct davinci_gpio_controller, chip)
 
-static struct davinci_gpio_controller chips[DIV_ROUND_UP(DAVINCI_N_GPIO, 32)];
+static struct davinci_gpio_controller ctlrs[DIV_ROUND_UP(DAVINCI_N_GPIO, 32)];
 static void __iomem *gpio_base;
 
 static struct davinci_gpio_regs __iomem __init *gpio2regs(unsigned gpio)
@@ -53,42 +54,37 @@ static struct davinci_gpio_regs __iomem __init *gpio2regs(unsigned gpio)
 		ptr = gpio_base + 0xb0;
 	else
 		ptr = NULL;
+
 	return ptr;
 }
 
 static inline struct davinci_gpio_regs __iomem *irq2regs(int irq)
 {
-	struct davinci_gpio_regs __iomem *g;
-
-	g = (__force struct davinci_gpio_regs __iomem *)irq_get_chip_data(irq);
-
-	return g;
+	return (__force struct davinci_gpio_regs __iomem *)
+		irq_get_chip_data(irq);
 }
 
 static int __init davinci_gpio_irq_setup(void);
 
-/*--------------------------------------------------------------------------*/
-
-/* board setup code *MUST* setup pinmux and enable the GPIO clock. */
 static inline int __davinci_direction(struct gpio_chip *chip,
 			unsigned offset, bool out, int value)
 {
-	struct davinci_gpio_controller *d = chip2controller(chip);
-	struct davinci_gpio_regs __iomem *g = d->regs;
+	struct davinci_gpio_controller *ctlr = chip2controller(chip);
+	struct davinci_gpio_regs __iomem *regs = ctlr->regs;
 	unsigned long flags;
 	u32 temp;
 	u32 mask = 1 << offset;
 
-	spin_lock_irqsave(&d->lock, flags);
-	temp = __raw_readl(&g->dir);
+	spin_lock_irqsave(&ctlr->lock, flags);
+	temp = __raw_readl(&regs->dir);
 	if (out) {
 		temp &= ~mask;
-		__raw_writel(mask, value ? &g->set_data : &g->clr_data);
+		__raw_writel(mask, value ? &regs->set_data : &regs->clr_data);
 	} else {
 		temp |= mask;
 	}
-	__raw_writel(temp, &g->dir);
-	spin_unlock_irqrestore(&d->lock, flags);
+	__raw_writel(temp, &regs->dir);
+	spin_unlock_irqrestore(&ctlr->lock, flags);
 
 	return 0;
 }
@@ -98,8 +94,8 @@ static int davinci_direction_in(struct gpio_chip *chip, unsigned offset)
 	return __davinci_direction(chip, offset, false, 0);
 }
 
-static int
-davinci_direction_out(struct gpio_chip *chip, unsigned offset, int value)
+static int davinci_direction_out(struct gpio_chip *chip, unsigned offset,
+		int value)
 {
 	return __davinci_direction(chip, offset, true, value);
 }
@@ -113,22 +109,22 @@ davinci_direction_out(struct gpio_chip *chip, unsigned offset, int value)
  */
 static int davinci_gpio_get(struct gpio_chip *chip, unsigned offset)
 {
-	struct davinci_gpio_controller *d = chip2controller(chip);
-	struct davinci_gpio_regs __iomem *g = d->regs;
+	struct davinci_gpio_controller *ctlr = chip2controller(chip);
+	struct davinci_gpio_regs __iomem *regs = ctlr->regs;
 
-	return (1 << offset) & __raw_readl(&g->in_data);
+	return (1 << offset) & __raw_readl(&regs->in_data);
 }
 
 /*
  * Assuming the pin is muxed as a gpio output, set its output value.
  */
-static void
-davinci_gpio_set(struct gpio_chip *chip, unsigned offset, int value)
+static void davinci_gpio_set(struct gpio_chip *chip, unsigned offset,
+		int value)
 {
-	struct davinci_gpio_controller *d = chip2controller(chip);
-	struct davinci_gpio_regs __iomem *g = d->regs;
+	struct davinci_gpio_controller *ctlr = chip2controller(chip);
+	struct davinci_gpio_regs __iomem *regs = ctlr->regs;
 
-	__raw_writel((1 << offset), value ? &g->set_data : &g->clr_data);
+	__raw_writel((1 << offset), value ? &regs->set_data : &regs->clr_data);
 }
 
 static int __init davinci_gpio_setup(void)
@@ -160,30 +156,30 @@ static int __init davinci_gpio_setup(void)
 		return -ENOMEM;
 
 	for (i = 0, base = 0; base < ngpio; i++, base += 32) {
-		chips[i].chip.label = "DaVinci";
+		ctlrs[i].chip.label = "DaVinci";
 
-		chips[i].chip.direction_input = davinci_direction_in;
-		chips[i].chip.get = davinci_gpio_get;
-		chips[i].chip.direction_output = davinci_direction_out;
-		chips[i].chip.set = davinci_gpio_set;
+		ctlrs[i].chip.direction_input = davinci_direction_in;
+		ctlrs[i].chip.direction_output = davinci_direction_out;
+		ctlrs[i].chip.get = davinci_gpio_get;
+		ctlrs[i].chip.set = davinci_gpio_set;
 
-		chips[i].chip.base = base;
-		chips[i].chip.ngpio = ngpio - base;
-		if (chips[i].chip.ngpio > 32)
-			chips[i].chip.ngpio = 32;
+		ctlrs[i].chip.base = base;
+		ctlrs[i].chip.ngpio = ngpio - base;
+		if (ctlrs[i].chip.ngpio > 32)
+			ctlrs[i].chip.ngpio = 32;
 
-		spin_lock_init(&chips[i].lock);
+		spin_lock_init(&ctlrs[i].lock);
 
 		regs = gpio2regs(base);
-		chips[i].regs = regs;
-		chips[i].set_data = &regs->set_data;
-		chips[i].clr_data = &regs->clr_data;
-		chips[i].in_data = &regs->in_data;
+		ctlrs[i].regs = regs;
+		ctlrs[i].set_data = &regs->set_data;
+		ctlrs[i].clr_data = &regs->clr_data;
+		ctlrs[i].in_data = &regs->in_data;
 
-		gpiochip_add(&chips[i].chip);
+		gpiochip_add(&ctlrs[i].chip);
 	}
 
-	soc_info->gpio_ctlrs = chips;
+	soc_info->gpio_ctlrs = ctlrs;
 	soc_info->gpio_ctlrs_num = DIV_ROUND_UP(ngpio, 32);
 
 	davinci_gpio_irq_setup();
@@ -191,7 +187,6 @@ static int __init davinci_gpio_setup(void)
 }
 pure_initcall(davinci_gpio_setup);
 
-/*--------------------------------------------------------------------------*/
 /*
  * We expect irqs will normally be set up as input pins, but they can also be
  * used as output pins ... which is convenient for testing.
@@ -205,16 +200,16 @@ pure_initcall(davinci_gpio_setup);
 
 static void gpio_irq_disable(struct irq_data *d)
 {
-	struct davinci_gpio_regs __iomem *g = irq2regs(d->irq);
+	struct davinci_gpio_regs __iomem *regs = irq2regs(d->irq);
 	u32 mask = (u32) irq_data_get_irq_handler_data(d);
 
-	__raw_writel(mask, &g->clr_falling);
-	__raw_writel(mask, &g->clr_rising);
+	__raw_writel(mask, &regs->clr_falling);
+	__raw_writel(mask, &regs->clr_rising);
 }
 
 static void gpio_irq_enable(struct irq_data *d)
 {
-	struct davinci_gpio_regs __iomem *g = irq2regs(d->irq);
+	struct davinci_gpio_regs __iomem *regs = irq2regs(d->irq);
 	u32 mask = (u32) irq_data_get_irq_handler_data(d);
 	unsigned status = irqd_get_trigger_type(d);
 
@@ -223,9 +218,9 @@ static void gpio_irq_enable(struct irq_data *d)
 		status = IRQ_TYPE_EDGE_FALLING | IRQ_TYPE_EDGE_RISING;
 
 	if (status & IRQ_TYPE_EDGE_FALLING)
-		__raw_writel(mask, &g->set_falling);
+		__raw_writel(mask, &regs->set_falling);
 	if (status & IRQ_TYPE_EDGE_RISING)
-		__raw_writel(mask, &g->set_rising);
+		__raw_writel(mask, &regs->set_rising);
 }
 
 static int gpio_irq_type(struct irq_data *d, unsigned trigger)
@@ -244,15 +239,15 @@ static struct irq_chip gpio_irqchip = {
 	.flags		= IRQCHIP_SET_TYPE_MASKED,
 };
 
-static void
-gpio_irq_handler(unsigned irq, struct irq_desc *desc)
+static void gpio_irq_handler(unsigned irq, struct irq_desc *desc)
 {
-	struct davinci_gpio_regs __iomem *g;
 	u32 mask = 0xffff;
-	struct davinci_gpio_controller *d;
+	struct davinci_gpio_controller *ctlr;
+	struct davinci_gpio_regs __iomem *regs;
 
-	d = (struct davinci_gpio_controller *)irq_desc_get_handler_data(desc);
-	g = (struct davinci_gpio_regs __iomem *)d->regs;
+	ctlr = (struct davinci_gpio_controller *)
+		irq_desc_get_handler_data(desc);
+	regs = ctlr->regs;
 
 	/* we only care about one bank */
 	if (irq & 1)
@@ -267,13 +262,13 @@ gpio_irq_handler(unsigned irq, struct irq_desc *desc)
 		int		res;
 
 		/* ack any irqs */
-		status = __raw_readl(&g->intstat) & mask;
+		status = __raw_readl(&regs->intstat) & mask;
 		if (!status)
 			break;
-		__raw_writel(status, &g->intstat);
+		__raw_writel(status, &regs->intstat);
 
 		/* now demux them to the right lowlevel handler */
-		n = d->irq_base;
+		n = ctlr->irq_base;
 		if (irq & 1) {
 			n += 16;
 			status >>= 16;
@@ -292,10 +287,10 @@ gpio_irq_handler(unsigned irq, struct irq_desc *desc)
 
 static int gpio_to_irq_banked(struct gpio_chip *chip, unsigned offset)
 {
-	struct davinci_gpio_controller *d = chip2controller(chip);
+	struct davinci_gpio_controller *ctlr = chip2controller(chip);
 
-	if (d->irq_base >= 0)
-		return d->irq_base + offset;
+	if (ctlr->irq_base >= 0)
+		return ctlr->irq_base + offset;
 	else
 		return -ENODEV;
 }
@@ -304,7 +299,8 @@ static int gpio_to_irq_unbanked(struct gpio_chip *chip, unsigned offset)
 {
 	struct davinci_soc_info *soc_info = &davinci_soc_info;
 
-	/* NOTE:  we assume for now that only irqs in the first gpio_chip
+	/*
+	 * NOTE:  we assume for now that only irqs in the first gpio_chip
 	 * can provide direct-mapped IRQs to AINTC (up to 32 GPIOs).
 	 */
 	if (offset < soc_info->gpio_unbanked)
@@ -315,22 +311,22 @@ static int gpio_to_irq_unbanked(struct gpio_chip *chip, unsigned offset)
 
 static int gpio_irq_type_unbanked(struct irq_data *data, unsigned trigger)
 {
-	struct davinci_gpio_controller *d;
-	struct davinci_gpio_regs __iomem *g;
+	struct davinci_gpio_controller *ctlr;
+	struct davinci_gpio_regs __iomem *regs;
 	struct davinci_soc_info *soc_info = &davinci_soc_info;
 	u32 mask;
 
-	d = (struct davinci_gpio_controller *)data->handler_data;
-	g = (struct davinci_gpio_regs __iomem *)d->regs;
+	ctlr = (struct davinci_gpio_controller *)data->handler_data;
+	regs = (struct davinci_gpio_regs __iomem *)ctlr->regs;
 	mask = __gpio_mask(data->irq - soc_info->gpio_irq);
 
 	if (trigger & ~(IRQ_TYPE_EDGE_FALLING | IRQ_TYPE_EDGE_RISING))
 		return -EINVAL;
 
 	__raw_writel(mask, (trigger & IRQ_TYPE_EDGE_FALLING)
-		     ? &g->set_falling : &g->clr_falling);
+		     ? &regs->set_falling : &regs->clr_falling);
 	__raw_writel(mask, (trigger & IRQ_TYPE_EDGE_RISING)
-		     ? &g->set_rising : &g->clr_rising);
+		     ? &regs->set_rising : &regs->clr_rising);
 
 	return 0;
 }
@@ -345,12 +341,11 @@ static int gpio_irq_type_unbanked(struct irq_data *data, unsigned trigger)
 
 static int __init davinci_gpio_irq_setup(void)
 {
-	unsigned	gpio, irq, bank;
-	struct clk	*clk;
 	u32		binten = 0;
-	unsigned	ngpio, bank_irq;
+	unsigned	gpio, irq, bank, ngpio, bank_irq;
+	struct clk	*clk;
+	struct davinci_gpio_regs __iomem *regs;
 	struct davinci_soc_info *soc_info = &davinci_soc_info;
-	struct davinci_gpio_regs	__iomem *g;
 
 	ngpio = soc_info->gpio_num;
 
@@ -368,16 +363,16 @@ static int __init davinci_gpio_irq_setup(void)
 	}
 	clk_prepare_enable(clk);
 
-	/* Arrange gpio_to_irq() support, handling either direct IRQs or
+	/*
+	 * Arrange gpio_to_irq() support, handling either direct IRQs or
 	 * banked IRQs.  Having GPIOs in the first GPIO bank use direct
 	 * IRQs, while the others use banked IRQs, would need some setup
 	 * tweaks to recognize hardware which can do that.
 	 */
 	for (gpio = 0, bank = 0; gpio < ngpio; bank++, gpio += 32) {
-		chips[bank].chip.to_irq = gpio_to_irq_banked;
-		chips[bank].irq_base = soc_info->gpio_unbanked
-			? -EINVAL
-			: (soc_info->intc_irq_num + gpio);
+		ctlrs[bank].chip.to_irq = gpio_to_irq_banked;
+		ctlrs[bank].irq_base = soc_info->gpio_unbanked ?
+			-EINVAL : (soc_info->intc_irq_num + gpio);
 	}
 
 	/*
@@ -389,7 +384,7 @@ static int __init davinci_gpio_irq_setup(void)
 		static struct irq_chip_type gpio_unbanked;
 
 		/* pass "bank 0" GPIO IRQs to AINTC */
-		chips[0].chip.to_irq = gpio_to_irq_unbanked;
+		ctlrs[0].chip.to_irq = gpio_to_irq_unbanked;
 		binten = BIT(0);
 
 		/* AINTC handles mask/unmask; GPIO handles triggering */
@@ -400,14 +395,14 @@ static int __init davinci_gpio_irq_setup(void)
 		gpio_unbanked.chip.irq_set_type = gpio_irq_type_unbanked;
 
 		/* default trigger: both edges */
-		g = gpio2regs(0);
-		__raw_writel(~0, &g->set_falling);
-		__raw_writel(~0, &g->set_rising);
+		regs = gpio2regs(0);
+		__raw_writel(~0, &regs->set_falling);
+		__raw_writel(~0, &regs->set_rising);
 
 		/* set the direct IRQs up to use that irqchip */
 		for (gpio = 0; gpio < soc_info->gpio_unbanked; gpio++, irq++) {
 			irq_set_chip(irq, &gpio_unbanked.chip);
-			irq_set_handler_data(irq, &chips[gpio / 32]);
+			irq_set_handler_data(irq, &ctlrs[gpio / 32]);
 			irq_set_status_flags(irq, IRQ_TYPE_EDGE_BOTH);
 		}
 
@@ -424,9 +419,9 @@ static int __init davinci_gpio_irq_setup(void)
 		unsigned		i;
 
 		/* disabled by default, enabled only as needed */
-		g = gpio2regs(gpio);
-		__raw_writel(~0, &g->clr_falling);
-		__raw_writel(~0, &g->clr_rising);
+		regs = gpio2regs(gpio);
+		__raw_writel(~0, &regs->clr_falling);
+		__raw_writel(~0, &regs->clr_rising);
 
 		/* set up all irqs in this bank */
 		irq_set_chained_handler(bank_irq, gpio_irq_handler);
@@ -436,11 +431,11 @@ static int __init davinci_gpio_irq_setup(void)
 		 * gpio irqs. Pass the irq bank's corresponding controller to
 		 * the chained irq handler.
 		 */
-		irq_set_handler_data(bank_irq, &chips[gpio / 32]);
+		irq_set_handler_data(bank_irq, &ctlrs[gpio / 32]);
 
 		for (i = 0; i < 16 && gpio < ngpio; i++, irq++, gpio++) {
 			irq_set_chip(irq, &gpio_irqchip);
-			irq_set_chip_data(irq, (__force void *)g);
+			irq_set_chip_data(irq, (__force void *)regs);
 			irq_set_handler_data(irq, (void *)__gpio_mask(gpio));
 			irq_set_handler(irq, handle_simple_irq);
 			set_irq_flags(irq, IRQF_VALID);
@@ -450,10 +445,11 @@ static int __init davinci_gpio_irq_setup(void)
 	}
 
 done:
-	/* BINTEN -- per-bank interrupt enable. genirq would also let these
+	/*
+	 * BINTEN -- per-bank interrupt enable. genirq would also let these
 	 * bits be set/cleared dynamically.
 	 */
-	__raw_writel(binten, gpio_base + 0x08);
+	__raw_writel(binten, gpio_base + BINTEN);
 
 	printk(KERN_INFO "DaVinci: %d gpio irqs\n", irq - gpio_to_irq(0));
 
-- 
1.7.9.5

