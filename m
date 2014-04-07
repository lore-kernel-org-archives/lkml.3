Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755223AbaDGKOw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2014 06:14:52 -0400
Received: from www.linutronix.de ([62.245.132.108]:50080 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754792AbaDGKN0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2014 06:13:26 -0400
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: jamie@jamieiles.com
Cc: atull@altera.com, gnurou@gmail.com, linux-gpio@vger.kernel.org,
        linux-kernel@vger.kernel.org, dinguyen@altera.com,
        linus.walleij@linaro.org, sebastian.hesselbarth@gmail.com,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH 5/5] gpio: dwapb: use d->mask instead od BIT(bit)
Date: Mon,  7 Apr 2014 12:13:09 +0200
Message-Id: <1396865589-9972-6-git-send-email-bigeasy@linutronix.de>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1396865589-9972-1-git-send-email-bigeasy@linutronix.de>
References: <1396865589-9972-1-git-send-email-bigeasy@linutronix.de>
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

d->mask contains exact the same information as BIT(bit) so we could save
a few cycles here.

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 drivers/gpio/gpio-dwapb.c | 26 +++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)

diff --git a/drivers/gpio/gpio-dwapb.c b/drivers/gpio/gpio-dwapb.c
index 13f1ad0..d85fc2e 100644
--- a/drivers/gpio/gpio-dwapb.c
+++ b/drivers/gpio/gpio-dwapb.c
@@ -113,7 +113,7 @@ static void dwapb_irq_enable(struct irq_data *d)
 
 	irq_gc_lock(igc);
 	val = readl(gpio->regs + GPIO_INTEN);
-	val |= BIT(d->hwirq);
+	val |= d->mask;
 	writel(val, gpio->regs + GPIO_INTEN);
 	irq_gc_unlock(igc);
 }
@@ -126,7 +126,7 @@ static void dwapb_irq_disable(struct irq_data *d)
 
 	irq_gc_lock(igc);
 	val = readl(gpio->regs + GPIO_INTEN);
-	val &= ~BIT(d->hwirq);
+	val &= ~d->mask;
 	writel(val, gpio->regs + GPIO_INTEN);
 	irq_gc_unlock(igc);
 }
@@ -158,7 +158,7 @@ static int dwapb_irq_set_type(struct irq_data *d, u32 type)
 {
 	struct irq_chip_generic *igc = irq_data_get_irq_chip_data(d);
 	struct dwapb_gpio *gpio = igc->private;
-	int bit = d->hwirq;
+	u32 mask = d->mask;
 	unsigned long level, polarity;
 
 	if (type & ~(IRQ_TYPE_EDGE_RISING | IRQ_TYPE_EDGE_FALLING |
@@ -171,24 +171,24 @@ static int dwapb_irq_set_type(struct irq_data *d, u32 type)
 
 	switch (type) {
 	case IRQ_TYPE_EDGE_BOTH:
-		level |= BIT(bit);
-		dwapb_toggle_trigger(gpio, bit);
+		level |= mask;
+		dwapb_toggle_trigger(gpio, d->hwirq);
 		break;
 	case IRQ_TYPE_EDGE_RISING:
-		level |= BIT(bit);
-		polarity |= BIT(bit);
+		level |= mask;
+		polarity |= mask;
 		break;
 	case IRQ_TYPE_EDGE_FALLING:
-		level |= BIT(bit);
-		polarity &= ~BIT(bit);
+		level |= mask;
+		polarity &= ~mask;
 		break;
 	case IRQ_TYPE_LEVEL_HIGH:
-		level &= ~BIT(bit);
-		polarity |= BIT(bit);
+		level &= ~mask;
+		polarity |= mask;
 		break;
 	case IRQ_TYPE_LEVEL_LOW:
-		level &= ~BIT(bit);
-		polarity &= ~BIT(bit);
+		level &= ~mask;
+		polarity &= ~mask;
 		break;
 	}
 
-- 
1.9.1

