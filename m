Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933513AbaFLL4P (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 07:56:15 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:32772 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933471AbaFLL4I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 07:56:08 -0400
From: Sricharan R <r.sricharan@ti.com>
To: <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: <tony@atomide.com>, <santosh.shilimkar@ti.com>, <nm@ti.com>,
        <rnayak@ti.com>, <linux@arm.linux.org.uk>, <r.sricharan@ti.com>,
        <tglx@linutronix.de>, <jason@lakedaemon.net>
Subject: [PATCH V2 02/19] irqchip: crossbar: check for premapped crossbar before allocating
Date: Thu, 12 Jun 2014 17:23:10 +0530
Message-ID: <1402574007-13987-3-git-send-email-r.sricharan@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1402574007-13987-1-git-send-email-r.sricharan@ti.com>
References: <1402574007-13987-1-git-send-email-r.sricharan@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nishanth Menon <nm@ti.com>

If irq_of_parse_and_map is executed twice, the same crossbar is mapped to two
different GIC interrupts. This is completely undesirable. Instead, check
if the requested crossbar event is pre-allocated and provide that GIC
mapping back to caller if already allocated.

Signed-off-by: Nishanth Menon <nm@ti.com>
Signed-off-by: Sricharan R <r.sricharan@ti.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
---
 drivers/irqchip/irq-crossbar.c |   16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/drivers/irqchip/irq-crossbar.c b/drivers/irqchip/irq-crossbar.c
index 20105bc..51d4b87 100644
--- a/drivers/irqchip/irq-crossbar.c
+++ b/drivers/irqchip/irq-crossbar.c
@@ -51,6 +51,17 @@ static inline void crossbar_writeb(int irq_no, int cb_no)
 	writeb(cb_no, cb->crossbar_base + cb->register_offsets[irq_no]);
 }
 
+static inline int get_prev_map_irq(int cb_no)
+{
+	int i;
+
+	for (i = 0; i < cb->int_max; i++)
+		if (cb->irq_map[i] == cb_no)
+			return i;
+
+	return -ENODEV;
+}
+
 static inline int allocate_free_irq(int cb_no)
 {
 	int i;
@@ -88,11 +99,16 @@ static int crossbar_domain_xlate(struct irq_domain *d,
 {
 	unsigned long ret;
 
+	ret = get_prev_map_irq(intspec[1]);
+	if (!IS_ERR_VALUE(ret))
+		goto found;
+
 	ret = allocate_free_irq(intspec[1]);
 
 	if (IS_ERR_VALUE(ret))
 		return ret;
 
+found:
 	*out_hwirq = ret + GIC_IRQ_START;
 	return 0;
 }
-- 
1.7.9.5

