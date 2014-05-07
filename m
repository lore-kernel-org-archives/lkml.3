Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933462AbaEGPqf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 11:46:35 -0400
Received: from www.linutronix.de ([62.245.132.108]:48680 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756913AbaEGPoG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 11:44:06 -0400
Message-Id: <20140507154340.061990194@linutronix.de>
User-Agent: quilt/0.60-1
Date: Wed, 07 May 2014 15:44:21 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Anvin <hpa@zytor.com>,
        Tony Luck <tony.luck@intel.com>, Peter Zijlstra <peterz@infradead.org>
Subject: [patch 28/32] genirq: Replace reserve_irqs in core code
References: <20140507153622.703412101@linutronix.de>
Content-Disposition: inline; filename=genirq-replace-irq-reserve.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We want to get rid of the public interface.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/irq/chip.c      |    5 ++---
 kernel/irq/internals.h |    6 ++++++
 kernel/irq/irqdesc.c   |    7 +++++++
 3 files changed, 15 insertions(+), 3 deletions(-)

Index: tip/kernel/irq/chip.c
===================================================================
--- tip.orig/kernel/irq/chip.c
+++ tip/kernel/irq/chip.c
@@ -40,10 +40,9 @@ int irq_set_chip(unsigned int irq, struc
 	irq_put_desc_unlock(desc, flags);
 	/*
 	 * For !CONFIG_SPARSE_IRQ make the irq show up in
-	 * allocated_irqs. For the CONFIG_SPARSE_IRQ case, it is
-	 * already marked, and this call is harmless.
+	 * allocated_irqs.
 	 */
-	irq_reserve_irq(irq);
+	irq_mark_irq(irq);
 	return 0;
 }
 EXPORT_SYMBOL(irq_set_chip);
Index: tip/kernel/irq/internals.h
===================================================================
--- tip.orig/kernel/irq/internals.h
+++ tip/kernel/irq/internals.h
@@ -76,6 +76,12 @@ extern void mask_irq(struct irq_desc *de
 extern void unmask_irq(struct irq_desc *desc);
 extern void unmask_threaded_irq(struct irq_desc *desc);
 
+#ifdef CONFIG_SPARSE_IRQ
+static inline void irq_mark_irq(unsigned int irq) { }
+#else
+extern void irq_mark_irq(unsigned int irq);
+#endif
+
 extern void init_kstat_irqs(struct irq_desc *desc, int node, int nr);
 
 irqreturn_t handle_irq_event_percpu(struct irq_desc *desc, struct irqaction *action);
Index: tip/kernel/irq/irqdesc.c
===================================================================
--- tip.orig/kernel/irq/irqdesc.c
+++ tip/kernel/irq/irqdesc.c
@@ -299,6 +299,13 @@ static int irq_expand_nr_irqs(unsigned i
 	return -ENOMEM;
 }
 
+void irq_mark_irq(unsigned int irq)
+{
+	mutex_lock(&sparse_irq_lock);
+	bitmap_set(allocated_irqs, irq, 1);
+	mutex_unlock(&sparse_irq_lock);
+}
+
 #endif /* !CONFIG_SPARSE_IRQ */
 
 /**


