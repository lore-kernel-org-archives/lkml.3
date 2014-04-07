Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755210AbaDGKOp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2014 06:14:45 -0400
Received: from www.linutronix.de ([62.245.132.108]:50073 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754790AbaDGKN0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2014 06:13:26 -0400
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: jamie@jamieiles.com
Cc: atull@altera.com, gnurou@gmail.com, linux-gpio@vger.kernel.org,
        linux-kernel@vger.kernel.org, dinguyen@altera.com,
        linus.walleij@linaro.org, sebastian.hesselbarth@gmail.com,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH 4/5] gpio: dwapb: use a second irq chip
Date: Mon,  7 Apr 2014 12:13:08 +0200
Message-Id: <1396865589-9972-5-git-send-email-bigeasy@linutronix.de>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1396865589-9972-1-git-send-email-bigeasy@linutronix.de>
References: <1396865589-9972-1-git-send-email-bigeasy@linutronix.de>
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Right new have one irq chip running always in level mode. It would nicer
to have two irq chips where one is handling level type interrupts and
the other one is doing edge interrupts. So we can have at runtime two users
where one is using edge and the other level.

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 drivers/gpio/gpio-dwapb.c | 21 +++++++++++++++++++--
 1 file changed, 19 insertions(+), 2 deletions(-)

diff --git a/drivers/gpio/gpio-dwapb.c b/drivers/gpio/gpio-dwapb.c
index 752ccb1..13f1ad0 100644
--- a/drivers/gpio/gpio-dwapb.c
+++ b/drivers/gpio/gpio-dwapb.c
@@ -192,6 +192,8 @@ static int dwapb_irq_set_type(struct irq_data *d, u32 type)
 		break;
 	}
 
+	irq_setup_alt_chip(d, type);
+
 	writel(level, gpio->regs + GPIO_INTTYPE_LEVEL);
 	writel(polarity, gpio->regs + GPIO_INT_POLARITY);
 	irq_gc_unlock(igc);
@@ -221,7 +223,7 @@ static void dwapb_configure_irqs(struct dwapb_gpio *gpio,
 	if (!gpio->domain)
 		return;
 
-	err = irq_alloc_domain_generic_chips(gpio->domain, ngpio, 1,
+	err = irq_alloc_domain_generic_chips(gpio->domain, ngpio, 2,
 					     "gpio-dwapb", handle_level_irq,
 					     IRQ_NOREQUEST, 0,
 					     IRQ_GC_INIT_NESTED_LOCK);
@@ -242,7 +244,20 @@ static void dwapb_configure_irqs(struct dwapb_gpio *gpio,
 	irq_gc->reg_base = gpio->regs;
 	irq_gc->private = gpio;
 
-	ct = irq_gc->chip_types;
+	ct = &irq_gc->chip_types[0];
+	ct->chip.irq_ack = irq_gc_ack_set_bit;
+	ct->chip.irq_mask = irq_gc_mask_set_bit;
+	ct->chip.irq_unmask = irq_gc_mask_clr_bit;
+	ct->chip.irq_set_type = dwapb_irq_set_type;
+	ct->chip.irq_enable = dwapb_irq_enable;
+	ct->chip.irq_disable = dwapb_irq_disable;
+	ct->chip.irq_request_resources = dwapb_irq_reqres;
+	ct->chip.irq_release_resources = dwapb_irq_relres;
+	ct->regs.ack = GPIO_PORTA_EOI;
+	ct->regs.mask = GPIO_INTMASK;
+	ct->type = IRQ_TYPE_LEVEL_MASK;
+
+	ct = &irq_gc->chip_types[1];
 	ct->chip.irq_ack = irq_gc_ack_set_bit;
 	ct->chip.irq_mask = irq_gc_mask_set_bit;
 	ct->chip.irq_unmask = irq_gc_mask_clr_bit;
@@ -253,6 +268,8 @@ static void dwapb_configure_irqs(struct dwapb_gpio *gpio,
 	ct->chip.irq_release_resources = dwapb_irq_relres;
 	ct->regs.ack = GPIO_PORTA_EOI;
 	ct->regs.mask = GPIO_INTMASK;
+	ct->type = IRQ_TYPE_EDGE_BOTH;
+	ct->handler = handle_edge_irq;
 
 	irq_set_chained_handler(irq, dwapb_irq_handler);
 	irq_set_handler_data(irq, gpio);
-- 
1.9.1

