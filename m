Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751774AbaCVQSG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Mar 2014 12:18:06 -0400
Received: from www.linutronix.de ([62.245.132.108]:55419 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751314AbaCVQQx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Mar 2014 12:16:53 -0400
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: atull@altera.com
Cc: linus.walleij@linaro.org, gnurou@gmail.com, linux-gpio@vger.kernel.org,
        linux-kernel@vger.kernel.org, dinguyen@altera.com,
        delicious.quinoa@gmail.com,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH 5/7] gpio: dwapb: use irq_gc_lock() for locking instead bc's  lock
Date: Sat, 22 Mar 2014 17:16:42 +0100
Message-Id: <1395505004-22650-6-git-send-email-bigeasy@linutronix.de>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1395505004-22650-1-git-send-email-bigeasy@linutronix.de>
References: <1395505004-22650-1-git-send-email-bigeasy@linutronix.de>
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The generic irq chip uses irq_gc_lock() for locking so the
enable/startup and type callbacks should use the same lock. None of
those registers (polarity, mask, enable) are used by the gpio part.

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 drivers/gpio/gpio-dwapb.c | 20 +++++++-------------
 1 file changed, 7 insertions(+), 13 deletions(-)

diff --git a/drivers/gpio/gpio-dwapb.c b/drivers/gpio/gpio-dwapb.c
index 541b893..752ccb1 100644
--- a/drivers/gpio/gpio-dwapb.c
+++ b/drivers/gpio/gpio-dwapb.c
@@ -20,7 +20,6 @@
 #include <linux/of_address.h>
 #include <linux/of_irq.h>
 #include <linux/platform_device.h>
-#include <linux/spinlock.h>
 
 #define GPIO_SWPORTA_DR		0x00
 #define GPIO_SWPORTA_DDR	0x04
@@ -110,30 +109,26 @@ static void dwapb_irq_enable(struct irq_data *d)
 {
 	struct irq_chip_generic *igc = irq_data_get_irq_chip_data(d);
 	struct dwapb_gpio *gpio = igc->private;
-	struct bgpio_chip *bgc = &gpio->ports[0].bgc;
-	unsigned long flags;
 	u32 val;
 
-	spin_lock_irqsave(&bgc->lock, flags);
+	irq_gc_lock(igc);
 	val = readl(gpio->regs + GPIO_INTEN);
 	val |= BIT(d->hwirq);
 	writel(val, gpio->regs + GPIO_INTEN);
-	spin_unlock_irqrestore(&bgc->lock, flags);
+	irq_gc_unlock(igc);
 }
 
 static void dwapb_irq_disable(struct irq_data *d)
 {
 	struct irq_chip_generic *igc = irq_data_get_irq_chip_data(d);
 	struct dwapb_gpio *gpio = igc->private;
-	struct bgpio_chip *bgc = &gpio->ports[0].bgc;
-	unsigned long flags;
 	u32 val;
 
-	spin_lock_irqsave(&bgc->lock, flags);
+	irq_gc_lock(igc);
 	val = readl(gpio->regs + GPIO_INTEN);
 	val &= ~BIT(d->hwirq);
 	writel(val, gpio->regs + GPIO_INTEN);
-	spin_unlock_irqrestore(&bgc->lock, flags);
+	irq_gc_unlock(igc);
 }
 
 static int dwapb_irq_reqres(struct irq_data *d)
@@ -163,15 +158,14 @@ static int dwapb_irq_set_type(struct irq_data *d, u32 type)
 {
 	struct irq_chip_generic *igc = irq_data_get_irq_chip_data(d);
 	struct dwapb_gpio *gpio = igc->private;
-	struct bgpio_chip *bgc = &gpio->ports[0].bgc;
 	int bit = d->hwirq;
-	unsigned long level, polarity, flags;
+	unsigned long level, polarity;
 
 	if (type & ~(IRQ_TYPE_EDGE_RISING | IRQ_TYPE_EDGE_FALLING |
 		     IRQ_TYPE_LEVEL_HIGH | IRQ_TYPE_LEVEL_LOW))
 		return -EINVAL;
 
-	spin_lock_irqsave(&bgc->lock, flags);
+	irq_gc_lock(igc);
 	level = readl(gpio->regs + GPIO_INTTYPE_LEVEL);
 	polarity = readl(gpio->regs + GPIO_INT_POLARITY);
 
@@ -200,7 +194,7 @@ static int dwapb_irq_set_type(struct irq_data *d, u32 type)
 
 	writel(level, gpio->regs + GPIO_INTTYPE_LEVEL);
 	writel(polarity, gpio->regs + GPIO_INT_POLARITY);
-	spin_unlock_irqrestore(&bgc->lock, flags);
+	irq_gc_unlock(igc);
 
 	return 0;
 }
-- 
1.9.1

