Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932377AbaAWWi5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 17:38:57 -0500
Received: from mail-ee0-f41.google.com ([74.125.83.41]:60731 "EHLO
	mail-ee0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755086AbaAWWiQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 17:38:16 -0500
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Jason Cooper <jason@lakedaemon.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] irqchip: orion: clear stale interrupts in irq_enable
Date: Thu, 23 Jan 2014 23:38:06 +0100
Message-Id: <1390516686-2224-4-git-send-email-sebastian.hesselbarth@gmail.com>
In-Reply-To: <1390516686-2224-1-git-send-email-sebastian.hesselbarth@gmail.com>
References: <1390516686-2224-1-git-send-email-sebastian.hesselbarth@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bridge IRQ_CAUSE bits are asserted regardless of the corresponding bit in
IRQ_MASK register. To avoid interrupt events on stale irqs, we have to clear
them before unmask. This installs an .irq_enable callback to ensure stale
irqs are cleared before initial unmask.

Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
---
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Jason Cooper <jason@lakedaemon.net>
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: Gregory Clement <gregory.clement@free-electrons.com>
Cc: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/irqchip/irq-orion.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/drivers/irqchip/irq-orion.c b/drivers/irqchip/irq-orion.c
index 1f636f719065..80b13c1a0947 100644
--- a/drivers/irqchip/irq-orion.c
+++ b/drivers/irqchip/irq-orion.c
@@ -123,6 +123,18 @@ static void orion_bridge_irq_handler(unsigned int irq, struct irq_desc *desc)
 	}
 }
 
+/*
+ * Bridge IRQ_CAUSE is asserted regardless of IRQ_MASK register.
+ * To avoid interrupt events on stale irqs, we clear them before unmask.
+ */
+static void orion_bridge_irq_enable(struct irq_data *d)
+{
+	struct irq_chip_type *ct = irq_data_get_chip_type(d);
+
+	ct->chip.irq_ack(d);
+	ct->chip.irq_unmask(d);
+}
+
 static int __init orion_bridge_irq_init(struct device_node *np,
 					struct device_node *parent)
 {
@@ -176,6 +188,7 @@ static int __init orion_bridge_irq_init(struct device_node *np,
 
 	gc->chip_types[0].regs.ack = ORION_BRIDGE_IRQ_CAUSE;
 	gc->chip_types[0].regs.mask = ORION_BRIDGE_IRQ_MASK;
+	gc->chip_types[0].chip.irq_enable = orion_bridge_irq_enable;
 	gc->chip_types[0].chip.irq_ack = irq_gc_ack_clr_bit;
 	gc->chip_types[0].chip.irq_mask = irq_gc_mask_clr_bit;
 	gc->chip_types[0].chip.irq_unmask = irq_gc_mask_set_bit;
-- 
1.8.5.2

