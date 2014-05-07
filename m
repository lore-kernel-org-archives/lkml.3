Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752287AbaEGPog (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 11:44:36 -0400
Received: from www.linutronix.de ([62.245.132.108]:48714 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756952AbaEGPoI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 11:44:08 -0400
Message-Id: <20140507154341.012847637@linutronix.de>
User-Agent: quilt/0.60-1
Date: Wed, 07 May 2014 15:44:23 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Anvin <hpa@zytor.com>,
        Tony Luck <tony.luck@intel.com>, Peter Zijlstra <peterz@infradead.org>
Subject: [patch 32/32] genirq: Remove dynamic_irq mess
References: <20140507153622.703412101@linutronix.de>
Content-Disposition: inline; filename=genirq-remove-dynamic-irq-mess.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No more users. Get rid of the cruft.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 include/linux/irq.h  |   10 ----------
 kernel/irq/irqdesc.c |   23 +++++++----------------
 2 files changed, 7 insertions(+), 26 deletions(-)

Index: tip/include/linux/irq.h
===================================================================
--- tip.orig/include/linux/irq.h
+++ tip/include/linux/irq.h
@@ -525,16 +525,6 @@ static inline void irq_set_percpu_devid_
 			     IRQ_NOPROBE | IRQ_PER_CPU_DEVID);
 }
 
-/*
- * Dynamic irq helper functions. Obsolete. Use irq_alloc_desc* and
- * irq_free_desc instead.
- */
-extern void dynamic_irq_cleanup(unsigned int irq);
-static inline void dynamic_irq_init(unsigned int irq)
-{
-	dynamic_irq_cleanup(irq);
-}
-
 /* Set/get chip/data for an IRQ: */
 extern int irq_set_chip(unsigned int irq, struct irq_chip *chip);
 extern int irq_set_handler_data(unsigned int irq, void *data);
Index: tip/kernel/irq/irqdesc.c
===================================================================
--- tip.orig/kernel/irq/irqdesc.c
+++ tip/kernel/irq/irqdesc.c
@@ -278,7 +278,12 @@ EXPORT_SYMBOL(irq_to_desc);
 
 static void free_desc(unsigned int irq)
 {
-	dynamic_irq_cleanup(irq);
+	struct irq_desc *desc = irq_to_desc(irq);
+	unsigned long flags;
+
+	raw_spin_lock_irqsave(&desc->lock, flags);
+	desc_set_defaults(irq, desc, desc_node(desc), NULL);
+	raw_spin_unlock_irqrestore(&desc->lock, flags);
 }
 
 static inline int alloc_descs(unsigned int start, unsigned int cnt, int node,
@@ -309,7 +314,7 @@ void irq_mark_irq(unsigned int irq)
 #ifdef CONFIG_GENERIC_IRQ_LEGACY
 void irq_init_desc(unsigned int irq)
 {
-	dynamic_irq_cleanup(irq);
+	free_desc(irq);
 }
 #endif
 
@@ -522,20 +527,6 @@ int irq_set_percpu_devid(unsigned int ir
 	return 0;
 }
 
-/**
- * dynamic_irq_cleanup - cleanup a dynamically allocated irq
- * @irq:	irq number to initialize
- */
-void dynamic_irq_cleanup(unsigned int irq)
-{
-	struct irq_desc *desc = irq_to_desc(irq);
-	unsigned long flags;
-
-	raw_spin_lock_irqsave(&desc->lock, flags);
-	desc_set_defaults(irq, desc, desc_node(desc), NULL);
-	raw_spin_unlock_irqrestore(&desc->lock, flags);
-}
-
 void kstat_incr_irq_this_cpu(unsigned int irq)
 {
 	kstat_incr_irqs_this_cpu(irq, irq_to_desc(irq));


