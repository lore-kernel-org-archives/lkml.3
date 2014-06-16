Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751275AbaFPL1u (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 07:27:50 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:41738 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752066AbaFPL0v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 07:26:51 -0400
From: Sricharan R <r.sricharan@ti.com>
To: <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: <tony@atomide.com>, <santosh.shilimkar@ti.com>, <nm@ti.com>,
        <rnayak@ti.com>, <linux@arm.linux.org.uk>, <r.sricharan@ti.com>,
        <tglx@linutronix.de>, <jason@lakedaemon.net>, <joe@perches.com>
Subject: [PATCH V3 14/16] irqchip: crossbar: introduce centralized check for crossbar write
Date: Mon, 16 Jun 2014 16:53:14 +0530
Message-ID: <1402917796-31574-15-git-send-email-r.sricharan@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1402917796-31574-1-git-send-email-r.sricharan@ti.com>
References: <1402917796-31574-1-git-send-email-r.sricharan@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nishanth Menon <nm@ti.com>

This is a basic check to ensure that crossbar register needs to be
written. This ensures that we have a common check which is used in
both map and unmap logic.

Signed-off-by: Nishanth Menon <nm@ti.com>
Signed-off-by: Sricharan R <r.sricharan@ti.com>
---
 drivers/irqchip/irq-crossbar.c |   14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/drivers/irqchip/irq-crossbar.c b/drivers/irqchip/irq-crossbar.c
index c46e14b..ef613c4 100644
--- a/drivers/irqchip/irq-crossbar.c
+++ b/drivers/irqchip/irq-crossbar.c
@@ -84,10 +84,20 @@ static inline int allocate_free_irq(int cb_no)
 	return -ENODEV;
 }
 
+static inline bool needs_crossbar_write(irq_hw_number_t hw)
+{
+	if (hw > GIC_IRQ_START)
+		return true;
+
+	return false;
+}
+
 static int crossbar_domain_map(struct irq_domain *d, unsigned int irq,
 			       irq_hw_number_t hw)
 {
-	cb->write(hw - GIC_IRQ_START, cb->irq_map[hw - GIC_IRQ_START]);
+	if (needs_crossbar_write(hw))
+		cb->write(hw - GIC_IRQ_START, cb->irq_map[hw - GIC_IRQ_START]);
+
 	return 0;
 }
 
@@ -106,7 +116,7 @@ static void crossbar_domain_unmap(struct irq_domain *d, unsigned int irq)
 {
 	irq_hw_number_t hw = irq_get_irq_data(irq)->hwirq;
 
-	if (hw > GIC_IRQ_START) {
+	if (needs_crossbar_write(hw)) {
 		cb->irq_map[hw - GIC_IRQ_START] = IRQ_FREE;
 		cb->write(hw - GIC_IRQ_START, cb->safe_map);
 	}
-- 
1.7.9.5

