Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752843AbaBWVol (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Feb 2014 16:44:41 -0500
Received: from www.linutronix.de ([62.245.132.108]:52283 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752274AbaBWVkK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Feb 2014 16:40:10 -0500
Message-Id: <20140223212738.334260926@linutronix.de>
User-Agent: quilt/0.60-1
Date: Sun, 23 Feb 2014 21:40:19 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [patch 19/26] genirq: Provide irqd_irq_has_actions()
References: <20140223212703.511977310@linutronix.de>
Content-Disposition: inline; filename=genirq-provide-info-about-actions.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Xen has an oddball probing_irq() function. Provide a proper interface
unless Konrad decides that this probing_irq() function can be ripped
out completely.

Not-Yet-Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 include/linux/irq.h |    7 +++++++
 kernel/irq/manage.c |    6 +++++-
 2 files changed, 12 insertions(+), 1 deletion(-)

Index: tip/include/linux/irq.h
===================================================================
--- tip.orig/include/linux/irq.h
+++ tip/include/linux/irq.h
@@ -173,6 +173,7 @@ struct irq_data {
  * IRQD_IRQ_DISABLED		- Disabled state of the interrupt
  * IRQD_IRQ_MASKED		- Masked state of the interrupt
  * IRQD_IRQ_INPROGRESS		- In progress state of the interrupt
+ * IRQD_IRQ_HAS_ACTION		- Set if action(s) installed
  */
 enum {
 	IRQD_TRIGGER_MASK		= 0xf,
@@ -186,6 +187,7 @@ enum {
 	IRQD_IRQ_DISABLED		= (1 << 16),
 	IRQD_IRQ_MASKED			= (1 << 17),
 	IRQD_IRQ_INPROGRESS		= (1 << 18),
+	IRQD_IRQ_HAS_ACTION		= (1 << 19),
 };
 
 static inline bool irqd_is_setaffinity_pending(struct irq_data *d)
@@ -257,6 +259,11 @@ static inline bool irqd_irq_inprogress(s
 	return d->state_use_accessors & IRQD_IRQ_INPROGRESS;
 }
 
+static inline bool irqd_irq_has_actions(struct irq_data *d)
+{
+	return d->state_use_accessors & IRQD_IRQ_HAS_ACTION;
+}
+
 /*
  * Functions for chained handlers which can be enabled/disabled by the
  * standard disable_irq/enable_irq calls. Must be called with
Index: tip/kernel/irq/manage.c
===================================================================
--- tip.orig/kernel/irq/manage.c
+++ tip/kernel/irq/manage.c
@@ -1204,6 +1204,8 @@ __setup_irq(unsigned int irq, struct irq
 	desc->irq_count = 0;
 	desc->irqs_unhandled = 0;
 
+	irqd_set(irq_desc_get_irq_data(desc), IRQD_IRQ_HAS_ACTION);
+
 	/*
 	 * Check whether we disabled the irq via the spurious handler
 	 * before. Reenable it and give it another chance.
@@ -1319,8 +1321,10 @@ static struct irqaction *__free_irq(unsi
 	*action_ptr = action->next;
 
 	/* If this was the last handler, shut down the IRQ line: */
-	if (!desc->action)
+	if (!desc->action) {
+		irqd_clear(irq_desc_get_irq_data(desc), IRQD_IRQ_HAS_ACTION);
 		irq_shutdown(desc);
+	}
 
 #ifdef CONFIG_SMP
 	/* make sure affinity_hint is cleaned up */


