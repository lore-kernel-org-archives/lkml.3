Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933766AbaEGPsr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 11:48:47 -0400
Received: from www.linutronix.de ([62.245.132.108]:48609 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750810AbaEGPoC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 11:44:02 -0400
Message-Id: <20140507154338.423715783@linutronix.de>
User-Agent: quilt/0.60-1
Date: Wed, 07 May 2014 15:44:16 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Anvin <hpa@zytor.com>,
        Tony Luck <tony.luck@intel.com>, Peter Zijlstra <peterz@infradead.org>,
        Chris Metcalf <cmetcalf@tilera.com>
Subject: [patch 21/32] tile: Use SPARSE_IRQ
References: <20140507153622.703412101@linutronix.de>
Content-Disposition: inline; filename=tile-use-sparse-irq.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Get rid of the private allocator and switch over to sparse IRQs.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Chris Metcalf <cmetcalf@tilera.com>
---
 arch/tile/Kconfig           |    2 +
 arch/tile/include/asm/irq.h |    9 +++----
 arch/tile/kernel/irq.c      |   52 ++------------------------------------------
 3 files changed, 9 insertions(+), 54 deletions(-)

Index: tip/arch/tile/Kconfig
===================================================================
--- tip.orig/arch/tile/Kconfig
+++ tip/arch/tile/Kconfig
@@ -125,6 +125,8 @@ config HVC_TILE
 
 config TILEGX
 	bool "Building for TILE-Gx (64-bit) processor"
+	select SPARSE_IRQ
+	select GENERIC_IRQ_LEGACY_ALLOC_HWIRQ
 	select HAVE_FUNCTION_TRACER
 	select HAVE_FUNCTION_TRACE_MCOUNT_TEST
 	select HAVE_FUNCTION_GRAPH_TRACER
Index: tip/arch/tile/include/asm/irq.h
===================================================================
--- tip.orig/arch/tile/include/asm/irq.h
+++ tip/arch/tile/include/asm/irq.h
@@ -18,10 +18,12 @@
 #include <linux/hardirq.h>
 
 /* The hypervisor interface provides 32 IRQs. */
-#define NR_IRQS 32
+#define NR_IRQS			32
 
 /* IRQ numbers used for linux IPIs. */
-#define IRQ_RESCHEDULE 0
+#define IRQ_RESCHEDULE	0
+/* Interrupts for dynamic allocation start at 1. Let the core allocate irq0 */
+#define NR_IRQS_LEGACY	1
 
 #define irq_canonicalize(irq)   (irq)
 
@@ -76,7 +78,4 @@ void tile_irq_activate(unsigned int irq,
 
 void setup_irq_regs(void);
 
-unsigned int irq_alloc_hwirq(int node);
-void irq_free_hwirq(unsigned int irq);
-
 #endif /* _ASM_TILE_IRQ_H */
Index: tip/arch/tile/kernel/irq.c
===================================================================
--- tip.orig/arch/tile/kernel/irq.c
+++ tip/arch/tile/kernel/irq.c
@@ -54,13 +54,6 @@ static DEFINE_PER_CPU(unsigned long, irq
  */
 static DEFINE_PER_CPU(int, irq_depth);
 
-/* State for allocating IRQs on Gx. */
-#if CHIP_HAS_IPI()
-static unsigned long available_irqs = ((1UL << NR_IRQS) - 1) &
-				      (~(1UL << IRQ_RESCHEDULE));
-static DEFINE_SPINLOCK(available_irqs_lock);
-#endif
-
 #if CHIP_HAS_IPI()
 /* Use SPRs to manipulate device interrupts. */
 #define mask_irqs(irq_mask) __insn_mtspr(SPR_IPI_MASK_SET_K, irq_mask)
@@ -278,50 +271,11 @@ int arch_show_interrupts(struct seq_file
 	return 0;
 }
 
-/*
- * Generic, controller-independent functions:
- */
-
 #if CHIP_HAS_IPI()
-int create_irq(void)
-{
-	unsigned long flags;
-	int result;
-
-	spin_lock_irqsave(&available_irqs_lock, flags);
-	if (available_irqs == 0)
-		result = -ENOMEM;
-	else {
-		result = __ffs(available_irqs);
-		available_irqs &= ~(1UL << result);
-		dynamic_irq_init(result);
-	}
-	spin_unlock_irqrestore(&available_irqs_lock, flags);
-
-	return result;
-}
-EXPORT_SYMBOL(create_irq);
-
-void destroy_irq(unsigned int irq)
-{
-	unsigned long flags;
-
-	spin_lock_irqsave(&available_irqs_lock, flags);
-	available_irqs |= (1UL << irq);
-	dynamic_irq_cleanup(irq);
-	spin_unlock_irqrestore(&available_irqs_lock, flags);
-}
-EXPORT_SYMBOL(destroy_irq);
-
-unsigned int irq_alloc_hwirq(int node)
-{
-	int ret = create_irq();
-	return ret < 0 ? 0 : ret;
-}
-
-void irq_free_hwirq(unsigned int irq)
+int arch_setup_hwirq(unsigned int irq, int node)
 {
-	destroy_irq();
+	return irq >= NR_IRQS ? -EINVAL : 0;
 }
 
+void arch_teardown_hwirq(unsigned int irq) { }
 #endif


