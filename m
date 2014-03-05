Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759438AbaCEPeu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 10:34:50 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:40711 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756070AbaCEOY3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 09:24:29 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Jason Cooper <jason@lakedaemon.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 005/131] irqchip: orion: clear stale interrupts in irq_startup
Date: Wed,  5 Mar 2014 14:22:09 +0000
Message-Id: <1394029455-23128-6-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1394029455-23128-1-git-send-email-luis.henriques@canonical.com>
References: <1394029455-23128-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.6 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>

commit e0318ec3bf3f1502cd11b21b1eb00aa355b40b67 upstream.

Bridge IRQ_CAUSE bits are asserted regardless of the corresponding bit in
IRQ_MASK register. To avoid interrupt events on stale irqs, we have to clear
them before unmask. This installs an .irq_startup callback to ensure stale
irqs are cleared before initial unmask.

Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Tested-by: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
Signed-off-by: Jason Cooper <jason@lakedaemon.net>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/irqchip/irq-orion.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/drivers/irqchip/irq-orion.c b/drivers/irqchip/irq-orion.c
index 1f636f7..0dfdc5c 100644
--- a/drivers/irqchip/irq-orion.c
+++ b/drivers/irqchip/irq-orion.c
@@ -123,6 +123,19 @@ static void orion_bridge_irq_handler(unsigned int irq, struct irq_desc *desc)
 	}
 }
 
+/*
+ * Bridge IRQ_CAUSE is asserted regardless of IRQ_MASK register.
+ * To avoid interrupt events on stale irqs, we clear them before unmask.
+ */
+static unsigned int orion_bridge_irq_startup(struct irq_data *d)
+{
+	struct irq_chip_type *ct = irq_data_get_chip_type(d);
+
+	ct->chip.irq_ack(d);
+	ct->chip.irq_unmask(d);
+	return 0;
+}
+
 static int __init orion_bridge_irq_init(struct device_node *np,
 					struct device_node *parent)
 {
@@ -176,6 +189,7 @@ static int __init orion_bridge_irq_init(struct device_node *np,
 
 	gc->chip_types[0].regs.ack = ORION_BRIDGE_IRQ_CAUSE;
 	gc->chip_types[0].regs.mask = ORION_BRIDGE_IRQ_MASK;
+	gc->chip_types[0].chip.irq_startup = orion_bridge_irq_startup;
 	gc->chip_types[0].chip.irq_ack = irq_gc_ack_clr_bit;
 	gc->chip_types[0].chip.irq_mask = irq_gc_mask_clr_bit;
 	gc->chip_types[0].chip.irq_unmask = irq_gc_mask_set_bit;
-- 
1.9.0

