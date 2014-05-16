Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932591AbaEPNge (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 09:36:34 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54266 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754454AbaEPNgc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 09:36:32 -0400
Date: Fri, 16 May 2014 06:35:35 -0700
From: tip-bot for Thomas Gleixner <tipbot@zytor.com>
Message-ID: <tip-b26d851ff1928b56242c4c5e16cb62bac2d9526c@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, grant.likely@linaro.org, hpa@zytor.com,
        mingo@kernel.org, peterz@infradead.org, cmetcalf@tilera.com,
        tony.luck@intel.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, grant.likely@linaro.org,
        linux-kernel@vger.kernel.org, peterz@infradead.org,
        cmetcalf@tilera.com, tony.luck@intel.com, tglx@linutronix.de
In-Reply-To: <20140507154338.423715783@linutronix.de>
References: <20140507154338.423715783@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:irq/core] tile: Use SPARSE_IRQ
Git-Commit-ID: b26d851ff1928b56242c4c5e16cb62bac2d9526c
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b26d851ff1928b56242c4c5e16cb62bac2d9526c
Gitweb:     http://git.kernel.org/tip/b26d851ff1928b56242c4c5e16cb62bac2d9526c
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Wed, 7 May 2014 15:44:16 +0000
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Fri, 16 May 2014 14:05:21 +0200

tile: Use SPARSE_IRQ

Get rid of the private allocator and switch over to sparse IRQs.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Grant Likely <grant.likely@linaro.org>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Acked-by: Chris Metcalf <cmetcalf@tilera.com>
Link: http://lkml.kernel.org/r/20140507154338.423715783@linutronix.de
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/tile/Kconfig           |  2 ++
 arch/tile/include/asm/irq.h |  9 ++++----
 arch/tile/kernel/irq.c      | 52 +++------------------------------------------
 3 files changed, 9 insertions(+), 54 deletions(-)

diff --git a/arch/tile/Kconfig b/arch/tile/Kconfig
index 85258ca..4f3006b 100644
--- a/arch/tile/Kconfig
+++ b/arch/tile/Kconfig
@@ -125,6 +125,8 @@ config HVC_TILE
 
 config TILEGX
 	bool "Building for TILE-Gx (64-bit) processor"
+	select SPARSE_IRQ
+	select GENERIC_IRQ_LEGACY_ALLOC_HWIRQ
 	select HAVE_FUNCTION_TRACER
 	select HAVE_FUNCTION_TRACE_MCOUNT_TEST
 	select HAVE_FUNCTION_GRAPH_TRACER
diff --git a/arch/tile/include/asm/irq.h b/arch/tile/include/asm/irq.h
index 9670a39..1fe8691 100644
--- a/arch/tile/include/asm/irq.h
+++ b/arch/tile/include/asm/irq.h
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
 
@@ -76,7 +78,4 @@ void tile_irq_activate(unsigned int irq, int tile_irq_type);
 
 void setup_irq_regs(void);
 
-unsigned int irq_alloc_hwirq(int node);
-void irq_free_hwirq(unsigned int irq);
-
 #endif /* _ASM_TILE_IRQ_H */
diff --git a/arch/tile/kernel/irq.c b/arch/tile/kernel/irq.c
index 5fd197e..637f2ff 100644
--- a/arch/tile/kernel/irq.c
+++ b/arch/tile/kernel/irq.c
@@ -54,13 +54,6 @@ static DEFINE_PER_CPU(unsigned long, irq_disable_mask)
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
@@ -278,50 +271,11 @@ int arch_show_interrupts(struct seq_file *p, int prec)
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
-	destroy_irq(irq);
+	return irq >= NR_IRQS ? -EINVAL : 0;
 }
 
+void arch_teardown_hwirq(unsigned int irq) { }
 #endif
