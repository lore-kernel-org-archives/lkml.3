Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755135AbaFPL0B (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 07:26:01 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:41692 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753227AbaFPLZz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 07:25:55 -0400
From: Sricharan R <r.sricharan@ti.com>
To: <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: <tony@atomide.com>, <santosh.shilimkar@ti.com>, <nm@ti.com>,
        <rnayak@ti.com>, <linux@arm.linux.org.uk>, <r.sricharan@ti.com>,
        <tglx@linutronix.de>, <jason@lakedaemon.net>, <joe@perches.com>
Subject: [PATCH V3 02/16] irqchip: crossbar: check for premapped crossbar before allocating
Date: Mon, 16 Jun 2014 16:53:02 +0530
Message-ID: <1402917796-31574-3-git-send-email-r.sricharan@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1402917796-31574-1-git-send-email-r.sricharan@ti.com>
References: <1402917796-31574-1-git-send-email-r.sricharan@ti.com>
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

