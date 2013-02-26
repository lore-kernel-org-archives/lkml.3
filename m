Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758763Ab3BZLxQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 06:53:16 -0500
Received: from mail-da0-f53.google.com ([209.85.210.53]:62496 "EHLO
	mail-da0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757864Ab3BZLxN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 06:53:13 -0500
From: Magnus Damm <magnus.damm@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: kuninori.morimoto.gx@renesas.com, linux-sh@vger.kernel.org,
        benh@kernel.crashing.org, grant.likely@secretlab.ca,
        horms@verge.net.au, Magnus Damm <magnus.damm@gmail.com>,
        tglx@linutronix.de
Date: Tue, 26 Feb 2013 20:58:54 +0900
Message-Id: <20130226115854.5630.51016.sendpatchset@w520>
In-Reply-To: <20130226115834.5630.45471.sendpatchset@w520>
References: <20130226115834.5630.45471.sendpatchset@w520>
Subject: [PATCH 02/05] irqchip: intc-irqpin: Cache mapped IRQ
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Magnus Damm <damm@opensource.se>

Cache IRQ in domain_irq variable instead of
making use of irq_find_mapping(). While at it
rename the irq variable to requested_irq.

Signed-off-by: Magnus Damm <damm@opensource.se>
---

 Thanks to Thomas Gleixner for this suggestion.

 drivers/irqchip/irq-renesas-intc-irqpin.c |   30 +++++++++++++++--------------
 1 file changed, 16 insertions(+), 14 deletions(-)

--- 0003/drivers/irqchip/irq-renesas-intc-irqpin.c
+++ work/drivers/irqchip/irq-renesas-intc-irqpin.c	2013-02-26 19:29:56.000000000 +0900
@@ -61,7 +61,8 @@ struct intc_irqpin_iomem {
 
 struct intc_irqpin_irq {
 	int hw_irq;
-	int irq;
+	int requested_irq;
+	int domain_irq;
 	struct intc_irqpin_priv *p;
 };
 
@@ -171,8 +172,7 @@ static int intc_irqpin_set_sense(struct
 static void intc_irqpin_dbg(struct intc_irqpin_irq *i, char *str)
 {
 	dev_dbg(&i->p->pdev->dev, "%s (%d:%d:%d)\n",
-		str, i->irq, i->hw_irq,
-		irq_find_mapping(i->p->irq_domain, i->hw_irq));
+		str, i->requested_irq, i->hw_irq, i->domain_irq);
 }
 
 static void intc_irqpin_irq_enable(struct irq_data *d)
@@ -196,7 +196,7 @@ static void intc_irqpin_irq_disable(stru
 static void intc_irqpin_irq_enable_force(struct irq_data *d)
 {
 	struct intc_irqpin_priv *p = irq_data_get_irq_chip_data(d);
-	int irq = p->irq[irqd_to_hwirq(d)].irq;
+	int irq = p->irq[irqd_to_hwirq(d)].requested_irq;
 
 	intc_irqpin_irq_enable(d);
 	irq_get_chip(irq)->irq_unmask(irq_get_irq_data(irq));
@@ -205,7 +205,7 @@ static void intc_irqpin_irq_enable_force
 static void intc_irqpin_irq_disable_force(struct irq_data *d)
 {
 	struct intc_irqpin_priv *p = irq_data_get_irq_chip_data(d);
-	int irq = p->irq[irqd_to_hwirq(d)].irq;
+	int irq = p->irq[irqd_to_hwirq(d)].requested_irq;
 
 	irq_get_chip(irq)->irq_mask(irq_get_irq_data(irq));
 	intc_irqpin_irq_disable(d);
@@ -246,7 +246,7 @@ static irqreturn_t intc_irqpin_irq_handl
 	if (intc_irqpin_read(p, INTC_IRQPIN_REG_SOURCE) & bit) {
 		intc_irqpin_write(p, INTC_IRQPIN_REG_SOURCE, ~bit);
 		intc_irqpin_dbg(i, "demux2");
-		generic_handle_irq(irq_find_mapping(p->irq_domain, i->hw_irq));
+		generic_handle_irq(i->domain_irq);
 		return IRQ_HANDLED;
 	}
 	return IRQ_NONE;
@@ -257,6 +257,9 @@ static int intc_irqpin_irq_domain_map(st
 {
 	struct intc_irqpin_priv *p = h->host_data;
 
+	p->irq[hw].domain_irq = virq;
+	p->irq[hw].hw_irq = hw;
+
 	intc_irqpin_dbg(&p->irq[hw], "map");
 	irq_set_chip_data(virq, h->host_data);
 	irq_set_chip_and_handler(virq, &p->irq_chip, handle_level_irq);
@@ -314,9 +317,8 @@ static int intc_irqpin_probe(struct plat
 		if (!irq)
 			break;
 
-		p->irq[k].hw_irq = k;
 		p->irq[k].p = p;
-		p->irq[k].irq = irq->start;
+		p->irq[k].requested_irq = irq->start;
 	}
 
 	p->number_of_irqs = k;
@@ -389,7 +391,8 @@ static int intc_irqpin_probe(struct plat
 
 	/* request and set priority on interrupts one by one */
 	for (k = 0; k < p->number_of_irqs; k++) {
-		if (request_irq(p->irq[k].irq, intc_irqpin_irq_handler,
+		if (request_irq(p->irq[k].requested_irq,
+				intc_irqpin_irq_handler,
 				0, name, &p->irq[k])) {
 			dev_err(&pdev->dev, "failed to request low IRQ\n");
 			ret = -ENOENT;
@@ -402,17 +405,16 @@ static int intc_irqpin_probe(struct plat
 
 	/* warn in case of mismatch if irq base is specified */
 	if (p->config.irq_base) {
-		k = irq_find_mapping(p->irq_domain, 0);
-		if (p->config.irq_base != k)
+		if (p->config.irq_base != p->irq[0].domain_irq)
 			dev_warn(&pdev->dev, "irq base mismatch (%d/%d)\n",
-				 p->config.irq_base, k);
+				 p->config.irq_base, p->irq[0].domain_irq);
 	}
 
 	return 0;
 
 err3:
 	for (; k >= 0; k--)
-		free_irq(p->irq[k - 1].irq, &p->irq[k - 1]);
+		free_irq(p->irq[k - 1].requested_irq, &p->irq[k - 1]);
 
 	irq_domain_remove(p->irq_domain);
 err2:
@@ -430,7 +432,7 @@ static int intc_irqpin_remove(struct pla
 	int k;
 
 	for (k = 0; k < p->number_of_irqs; k++)
-		free_irq(p->irq[k].irq, &p->irq[k]);
+		free_irq(p->irq[k].requested_irq, &p->irq[k]);
 
 	irq_domain_remove(p->irq_domain);
 
