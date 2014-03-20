Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759702AbaCTTzi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 15:55:38 -0400
Received: from www.linutronix.de ([62.245.132.108]:45259 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758973AbaCTTzd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 15:55:33 -0400
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Alan Tull <atull@altera.com>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>, linux-gpio@vger.kernel.org,
        linux-kernel@vger.kernel.org, Dinh Nguyen <dinguyen@altera.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH 2/3] gpio: dwapb: do not create the irq mapping upfront.
Date: Thu, 20 Mar 2014 20:55:23 +0100
Message-Id: <1395345324-18299-3-git-send-email-bigeasy@linutronix.de>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1395345324-18299-1-git-send-email-bigeasy@linutronix.de>
References: <1395345324-18299-1-git-send-email-bigeasy@linutronix.de>
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After the irq chip got registered the driver creates a mapping for every
gpio line. This mapping be useless if the gpio in question never is
beeing used a irq line. The mapping should be created by the core on
request.

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 drivers/gpio/gpio-dwapb.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/gpio/gpio-dwapb.c b/drivers/gpio/gpio-dwapb.c
index 4d25a06b..0db0b94 100644
--- a/drivers/gpio/gpio-dwapb.c
+++ b/drivers/gpio/gpio-dwapb.c
@@ -211,7 +211,7 @@ static void dwapb_configure_irqs(struct dwapb_gpio *gpio,
 	struct gpio_chip *gc = &port->bgc.gc;
 	struct device_node *node =  gc->of_node;
 	struct irq_chip_generic	*irq_gc;
-	unsigned int hwirq, ngpio = gc->ngpio;
+	unsigned int ngpio = gc->ngpio;
 	struct irq_chip_type *ct;
 	int err, irq;
 
@@ -263,9 +263,6 @@ static void dwapb_configure_irqs(struct dwapb_gpio *gpio,
 	irq_set_chained_handler(irq, dwapb_irq_handler);
 	irq_set_handler_data(irq, gpio);
 
-	for (hwirq = 0 ; hwirq < ngpio ; hwirq++)
-		irq_create_mapping(gpio->domain, hwirq);
-
 	port->bgc.gc.to_irq = dwapb_gpio_to_irq;
 }
 
-- 
1.9.1

