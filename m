Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756907AbaEGPoE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 11:44:04 -0400
Received: from www.linutronix.de ([62.245.132.108]:48558 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752250AbaEGPn5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 11:43:57 -0400
Message-Id: <20140507154336.760446122@linutronix.de>
User-Agent: quilt/0.60-1
Date: Wed, 07 May 2014 15:44:12 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Anvin <hpa@zytor.com>,
        Tony Luck <tony.luck@intel.com>, Peter Zijlstra <peterz@infradead.org>
Subject: [patch 14/32] x86: Remove create/dstroy_irq()
References: <20140507153622.703412101@linutronix.de>
Content-Disposition: inline; filename=x86-remove-create-distroy-irq.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No more users. Remove the cruft

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: x86@kernel.org
---
 arch/x86/kernel/apic/io_apic.c |  106 -----------------------------------------
 include/linux/irq.h            |    4 -
 2 files changed, 1 insertion(+), 109 deletions(-)

Index: tip/arch/x86/kernel/apic/io_apic.c
===================================================================
--- tip.orig/arch/x86/kernel/apic/io_apic.c
+++ tip/arch/x86/kernel/apic/io_apic.c
@@ -281,18 +281,6 @@ static struct irq_cfg *alloc_irq_and_cfg
 	return cfg;
 }
 
-static int alloc_irqs_from(unsigned int from, unsigned int count, int node)
-{
-	return irq_alloc_descs_from(from, count, node);
-}
-
-static void free_irq_at(unsigned int at, struct irq_cfg *cfg)
-{
-	free_irq_cfg(at, cfg);
-	irq_free_desc(at);
-}
-
-
 struct io_apic {
 	unsigned int index;
 	unsigned int unused[3];
@@ -2916,100 +2904,8 @@ static int __init ioapic_init_ops(void)
 device_initcall(ioapic_init_ops);
 
 /*
- * Dynamic irq allocate and deallocation
+ * Dynamic irq allocate and deallocation. Should be replaced by irq domains!
  */
-unsigned int __create_irqs(unsigned int from, unsigned int count, int node)
-{
-	struct irq_cfg **cfg;
-	unsigned long flags;
-	int irq, i;
-
-	if (from < nr_irqs_gsi)
-		from = nr_irqs_gsi;
-
-	cfg = kzalloc_node(count * sizeof(cfg[0]), GFP_KERNEL, node);
-	if (!cfg)
-		return 0;
-
-	irq = alloc_irqs_from(from, count, node);
-	if (irq < 0)
-		goto out_cfgs;
-
-	for (i = 0; i < count; i++) {
-		cfg[i] = alloc_irq_cfg(irq + i, node);
-		if (!cfg[i])
-			goto out_irqs;
-	}
-
-	raw_spin_lock_irqsave(&vector_lock, flags);
-	for (i = 0; i < count; i++)
-		if (__assign_irq_vector(irq + i, cfg[i], apic->target_cpus()))
-			goto out_vecs;
-	raw_spin_unlock_irqrestore(&vector_lock, flags);
-
-	for (i = 0; i < count; i++) {
-		irq_set_chip_data(irq + i, cfg[i]);
-		irq_clear_status_flags(irq + i, IRQ_NOREQUEST);
-	}
-
-	kfree(cfg);
-	return irq;
-
-out_vecs:
-	for (i--; i >= 0; i--)
-		__clear_irq_vector(irq + i, cfg[i]);
-	raw_spin_unlock_irqrestore(&vector_lock, flags);
-out_irqs:
-	for (i = 0; i < count; i++)
-		free_irq_at(irq + i, cfg[i]);
-out_cfgs:
-	kfree(cfg);
-	return 0;
-}
-
-unsigned int create_irq_nr(unsigned int from, int node)
-{
-	return __create_irqs(from, 1, node);
-}
-
-int create_irq(void)
-{
-	int node = cpu_to_node(0);
-	unsigned int irq_want;
-	int irq;
-
-	irq_want = nr_irqs_gsi;
-	irq = create_irq_nr(irq_want, node);
-
-	if (irq == 0)
-		irq = -1;
-
-	return irq;
-}
-
-void destroy_irq(unsigned int irq)
-{
-	struct irq_cfg *cfg = irq_get_chip_data(irq);
-	unsigned long flags;
-
-	irq_set_status_flags(irq, IRQ_NOREQUEST|IRQ_NOPROBE);
-
-	free_remapped_irq(irq);
-
-	raw_spin_lock_irqsave(&vector_lock, flags);
-	__clear_irq_vector(irq, cfg);
-	raw_spin_unlock_irqrestore(&vector_lock, flags);
-	free_irq_at(irq, cfg);
-}
-
-void destroy_irqs(unsigned int irq, unsigned int count)
-{
-	unsigned int i;
-
-	for (i = 0; i < count; i++)
-		destroy_irq(irq + i);
-}
-
 int arch_setup_hwirq(unsigned int irq, int node)
 {
 	struct irq_cfg *cfg;
Index: tip/include/linux/irq.h
===================================================================
--- tip.orig/include/linux/irq.h
+++ tip/include/linux/irq.h
@@ -526,12 +526,8 @@ static inline void irq_set_percpu_devid_
 }
 
 /* Handle dynamic irq creation and destruction */
-extern unsigned int create_irq_nr(unsigned int irq_want, int node);
-extern unsigned int __create_irqs(unsigned int from, unsigned int count,
-				  int node);
 extern int create_irq(void);
 extern void destroy_irq(unsigned int irq);
-extern void destroy_irqs(unsigned int irq, unsigned int count);
 
 /*
  * Dynamic irq helper functions. Obsolete. Use irq_alloc_desc* and


