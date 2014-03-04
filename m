Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758119AbaCDUvR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 15:51:17 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:41322 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756755AbaCDUEW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 15:04:22 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        Jason Cooper <jason@lakedaemon.net>
Subject: [PATCH 3.13 146/172] irqchip: orion: clear stale interrupts in irq_startup
Date: Tue,  4 Mar 2014 12:03:50 -0800
Message-Id: <20140304200304.401256428@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140304200259.626667112@linuxfoundation.org>
References: <20140304200259.626667112@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/irqchip/irq-orion.c |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

--- a/drivers/irqchip/irq-orion.c
+++ b/drivers/irqchip/irq-orion.c
@@ -123,6 +123,19 @@ static void orion_bridge_irq_handler(uns
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
@@ -176,6 +189,7 @@ static int __init orion_bridge_irq_init(
 
 	gc->chip_types[0].regs.ack = ORION_BRIDGE_IRQ_CAUSE;
 	gc->chip_types[0].regs.mask = ORION_BRIDGE_IRQ_MASK;
+	gc->chip_types[0].chip.irq_startup = orion_bridge_irq_startup;
 	gc->chip_types[0].chip.irq_ack = irq_gc_ack_clr_bit;
 	gc->chip_types[0].chip.irq_mask = irq_gc_mask_clr_bit;
 	gc->chip_types[0].chip.irq_unmask = irq_gc_mask_set_bit;


