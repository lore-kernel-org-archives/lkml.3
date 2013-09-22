Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752113Ab3IVOlu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Sep 2013 10:41:50 -0400
Received: from bhuna.collabora.co.uk ([93.93.135.160]:57373 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751933Ab3IVOls (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Sep 2013 10:41:48 -0400
From: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
To: Santosh Shilimkar <santosh.shilimkar@ti.com>
Cc: Kevin Hilman <khilman@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Lars Poeschel <larsi@wh2.tu-dresden.de>,
        Grant Likely <grant.likely@linaro.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ian.campbell@citrix.com>,
        Kumar Gala <galak@codeaurora.org>, Pawel Moll <pawel.moll@arm.com>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Enric Balletbo i Serra <eballetbo@gmail.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Balaji T K <balajitk@ti.com>, Tony Lindgren <tony@atomide.com>,
        Jon Hunter <jgchunter@gmail.com>, linux-gpio@vger.kernel.org,
        linux-omap@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Subject: [RFC] gpio/omap: auto-setup a GPIO when used as an IRQ 
Date: Sun, 22 Sep 2013 16:40:48 +0200
Message-Id: <1379860848-29020-1-git-send-email-javier.martinez@collabora.co.uk>
X-Mailer: git-send-email 1.8.4.rc3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To use a GPIO pin as an interrupt line, two previous configurations
have to be made:

a) Map the GPIO pin as an interrupt line into the Linux irq space
b) Enable the GPIO bank and configure the GPIO direction as input

Most GPIO/IRQ chip drivers just create a mapping for every single
GPIO pin with irq_create_mapping() on .probe so users usually can
assume a) and only have to do b) by using the following sequence:

gpio_request(gpio, "foo IRQ");
gpio_direction_input(gpio);

and then request a IRQ with:

irq = gpio_to_irq(gpio);
request_irq(irq, ...);

Some drivers know that their IRQ line is being driven by a GPIO
and use a similar sequence as the described above but others are
not aware or don't care wether their IRQ is a real line from an
interrupt controller or a GPIO pin acting as an IRQ.

In these cases board files did all the necessary GPIO setup so the
drivers could only call request_irq() on the provided IRQ.

Unfortuntaly this does not work when booting with Device Trees since
the OF irq core does neither request the GPIO nor set its direction.

A DTS just defines the GPIO controller phandle as a interrupt-parent
so drivers get the mapped GPIO-IRQ line but request_irq() fails since
the setup was never made.

The first attemp to solve this issue was by adding a custom .map()
irq_domain_ops function handler in the gpio-omap driver that called
gpio_request_one() to request and setup the GPIO direction as input.

This was made on commits:

0e970cec ("gpio/omap: don't create an IRQ mapping for every GPIO on DT")
b4419e1a ("gpio/omap: auto request GPIO as input if used as IRQ via DT")

but they got reverted since broke OMAP1 platforms.

This patch solves this issue with a different approach, by doing all
the needed hardware setup on the GPIO/IRQ chip driver when a call to
request_irq() is made.

Signed-off-by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
---

Hello,

This patch is an attempt to solve the long standing issue that we have been
discussing in thread:

"[PATCH v3] gpio: interrupt consistency check for OF GPIO IRQs" [1]

The fix is just for OMAP of course and not a kernel wide solution but Linus
approach (which I think is the best general solution proposed so far) has
some resistance so it seems that it won't be merged and we really need a
solution for OMAP if we want to finish our migration to Device Tree soon.

The patch is based on 3.12-rc1 but is not meant to be merged as a fix for
this -rc cycle. I would like it to be tested ideally on every OMAP platform
supported in mainline. So is better to wait until we are sure that this does
not cause a regression on any platform than ending reverting the patch like
it happened last time.

Thanks a lot and best regards,
Javier

[1]: https://lkml.org/lkml/2013/8/26/260 

 drivers/gpio/gpio-omap.c | 54 +++++++++++++++++++++++++++---------------------
 1 file changed, 31 insertions(+), 23 deletions(-)

diff --git a/drivers/gpio/gpio-omap.c b/drivers/gpio/gpio-omap.c
index 0ff4355..218ce3d 100644
--- a/drivers/gpio/gpio-omap.c
+++ b/drivers/gpio/gpio-omap.c
@@ -420,6 +420,29 @@ static int _set_gpio_triggering(struct gpio_bank *bank, int gpio,
 	return 0;
 }
 
+static void _set_gpio_mode(struct gpio_bank *bank, unsigned offset)
+{
+	if (bank->regs->pinctrl) {
+		void __iomem *reg = bank->base + bank->regs->pinctrl;
+
+		/* Claim the pin for MPU */
+		__raw_writel(__raw_readl(reg) | (1 << offset), reg);
+	}
+
+	if (bank->regs->ctrl && !bank->mod_usage) {
+		void __iomem *reg = bank->base + bank->regs->ctrl;
+		u32 ctrl;
+
+		ctrl = __raw_readl(reg);
+		/* Module is enabled, clocks are not gated */
+		ctrl &= ~GPIO_MOD_CTRL_BIT;
+		__raw_writel(ctrl, reg);
+		bank->context.ctrl = ctrl;
+	}
+
+	bank->mod_usage |= 1 << offset;
+}
+
 static int gpio_irq_type(struct irq_data *d, unsigned type)
 {
 	struct gpio_bank *bank = irq_data_get_irq_chip_data(d);
@@ -427,8 +450,8 @@ static int gpio_irq_type(struct irq_data *d, unsigned type)
 	int retval;
 	unsigned long flags;
 
-	if (WARN_ON(!bank->mod_usage))
-		return -EINVAL;
+	if (!bank->mod_usage)
+		pm_runtime_get_sync(bank->dev);
 
 #ifdef CONFIG_ARCH_OMAP1
 	if (d->irq > IH_MPUIO_BASE)
@@ -438,6 +461,11 @@ static int gpio_irq_type(struct irq_data *d, unsigned type)
 	if (!gpio)
 		gpio = irq_to_gpio(bank, d->hwirq);
 
+	spin_lock_irqsave(&bank->lock, flags);
+	_set_gpio_mode(bank, GPIO_INDEX(bank, gpio));
+	_set_gpio_direction(bank, GPIO_INDEX(bank, gpio), 1);
+	spin_unlock_irqrestore(&bank->lock, flags);
+
 	if (type & ~IRQ_TYPE_SENSE_MASK)
 		return -EINVAL;
 
@@ -611,27 +639,7 @@ static int omap_gpio_request(struct gpio_chip *chip, unsigned offset)
 	 * request_irq() or set_irq_type().
 	 */
 	_set_gpio_triggering(bank, offset, IRQ_TYPE_NONE);
-
-	if (bank->regs->pinctrl) {
-		void __iomem *reg = bank->base + bank->regs->pinctrl;
-
-		/* Claim the pin for MPU */
-		__raw_writel(__raw_readl(reg) | (1 << offset), reg);
-	}
-
-	if (bank->regs->ctrl && !bank->mod_usage) {
-		void __iomem *reg = bank->base + bank->regs->ctrl;
-		u32 ctrl;
-
-		ctrl = __raw_readl(reg);
-		/* Module is enabled, clocks are not gated */
-		ctrl &= ~GPIO_MOD_CTRL_BIT;
-		__raw_writel(ctrl, reg);
-		bank->context.ctrl = ctrl;
-	}
-
-	bank->mod_usage |= 1 << offset;
-
+	_set_gpio_mode(bank, offset);
 	spin_unlock_irqrestore(&bank->lock, flags);
 
 	return 0;
-- 
1.8.4.rc3

