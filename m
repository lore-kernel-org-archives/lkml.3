Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933917AbaFLL5z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 07:57:55 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:32848 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933831AbaFLL5H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 07:57:07 -0400
From: Sricharan R <r.sricharan@ti.com>
To: <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: <tony@atomide.com>, <santosh.shilimkar@ti.com>, <nm@ti.com>,
        <rnayak@ti.com>, <linux@arm.linux.org.uk>, <r.sricharan@ti.com>,
        <tglx@linutronix.de>, <jason@lakedaemon.net>
Subject: [PATCH V2 17/19] irqchip: crossbar: introduce centralized check for crossbar write
Date: Thu, 12 Jun 2014 17:23:25 +0530
Message-ID: <1402574007-13987-18-git-send-email-r.sricharan@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1402574007-13987-1-git-send-email-r.sricharan@ti.com>
References: <1402574007-13987-1-git-send-email-r.sricharan@ti.com>
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
---
 drivers/irqchip/irq-crossbar.c |   14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/drivers/irqchip/irq-crossbar.c b/drivers/irqchip/irq-crossbar.c
index cf69c4d..745ad0a 100644
--- a/drivers/irqchip/irq-crossbar.c
+++ b/drivers/irqchip/irq-crossbar.c
@@ -96,10 +96,20 @@ static inline int allocate_free_irq(int cb_no)
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
 
@@ -117,7 +127,7 @@ static void crossbar_domain_unmap(struct irq_domain *d, unsigned int irq)
 {
 	irq_hw_number_t hw = irq_get_irq_data(irq)->hwirq;
 
-	if (hw > GIC_IRQ_START)
+	if (needs_crossbar_write(hw))
 		cb->irq_map[hw - GIC_IRQ_START] = IRQ_FREE;
 }
 
-- 
1.7.9.5

