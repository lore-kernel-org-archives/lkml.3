Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751879AbaEZU6a (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 16:58:30 -0400
Received: from www.linutronix.de ([62.245.132.108]:48214 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751232AbaEZU62 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 16:58:28 -0400
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Jamie Iles <jamie@jamieiles.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Alan Tull <atull@altera.com>, Alexandre Courbot <gnurou@gmail.com>,
        linux-gpio@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>, dinguyen@altera.com,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH v3] gpio: dwapb: use a second irq chip
Date: Mon, 26 May 2014 22:58:14 +0200
Message-Id: <1401137894-6096-1-git-send-email-bigeasy@linutronix.de>
X-Mailer: git-send-email 2.0.0.rc4
In-Reply-To: <CACRpkdY=oVyBCwRkppq11B0tkn2bMw+-h_fDhy538eatVUJ=pQ@mail.gmail.com>
References: <CACRpkdY=oVyBCwRkppq11B0tkn2bMw+-h_fDhy538eatVUJ=pQ@mail.gmail.com>
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

Acked-by: Alan Tull <delicious.quinoa@gmail.com>
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
v2..v3: added acked-by
v1..v2 - using the lopp again but breaking the assignment of type and
	handler out of the loop as suggested by delicious quinoa.

 drivers/gpio/gpio-dwapb.c | 35 ++++++++++++++++++++++-------------
 1 file changed, 22 insertions(+), 13 deletions(-)

diff --git a/drivers/gpio/gpio-dwapb.c b/drivers/gpio/gpio-dwapb.c
index 34b339b..5a51fd0 100644
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
@@ -207,7 +209,7 @@ static void dwapb_configure_irqs(struct dwapb_gpio *gpio,
 	struct irq_chip_generic	*irq_gc;
 	unsigned int hwirq, ngpio = gc->ngpio;
 	struct irq_chip_type *ct;
-	int err, irq;
+	int err, irq, i;
 
 	irq = irq_of_parse_and_map(node, 0);
 	if (!irq) {
@@ -221,7 +223,7 @@ static void dwapb_configure_irqs(struct dwapb_gpio *gpio,
 	if (!gpio->domain)
 		return;
 
-	err = irq_alloc_domain_generic_chips(gpio->domain, ngpio, 1,
+	err = irq_alloc_domain_generic_chips(gpio->domain, ngpio, 2,
 					     "gpio-dwapb", handle_level_irq,
 					     IRQ_NOREQUEST, 0,
 					     IRQ_GC_INIT_NESTED_LOCK);
@@ -242,17 +244,24 @@ static void dwapb_configure_irqs(struct dwapb_gpio *gpio,
 	irq_gc->reg_base = gpio->regs;
 	irq_gc->private = gpio;
 
-	ct = irq_gc->chip_types;
-	ct->chip.irq_ack = irq_gc_ack_set_bit;
-	ct->chip.irq_mask = irq_gc_mask_set_bit;
-	ct->chip.irq_unmask = irq_gc_mask_clr_bit;
-	ct->chip.irq_set_type = dwapb_irq_set_type;
-	ct->chip.irq_enable = dwapb_irq_enable;
-	ct->chip.irq_disable = dwapb_irq_disable;
-	ct->chip.irq_request_resources = dwapb_irq_reqres;
-	ct->chip.irq_release_resources = dwapb_irq_relres;
-	ct->regs.ack = GPIO_PORTA_EOI;
-	ct->regs.mask = GPIO_INTMASK;
+	for (i = 0; i < 2; i++) {
+		ct = &irq_gc->chip_types[i];
+		ct->chip.irq_ack = irq_gc_ack_set_bit;
+		ct->chip.irq_mask = irq_gc_mask_set_bit;
+		ct->chip.irq_unmask = irq_gc_mask_clr_bit;
+		ct->chip.irq_set_type = dwapb_irq_set_type;
+		ct->chip.irq_enable = dwapb_irq_enable;
+		ct->chip.irq_disable = dwapb_irq_disable;
+		ct->chip.irq_request_resources = dwapb_irq_reqres;
+		ct->chip.irq_release_resources = dwapb_irq_relres;
+		ct->regs.ack = GPIO_PORTA_EOI;
+		ct->regs.mask = GPIO_INTMASK;
+		ct->type = IRQ_TYPE_LEVEL_MASK;
+	}
+
+	irq_gc->chip_types[0].type = IRQ_TYPE_LEVEL_MASK;
+	irq_gc->chip_types[1].type = IRQ_TYPE_EDGE_BOTH;
+	irq_gc->chip_types[1].handler = handle_edge_irq;
 
 	irq_set_chained_handler(irq, dwapb_irq_handler);
 	irq_set_handler_data(irq, gpio);
-- 
2.0.0.rc4

