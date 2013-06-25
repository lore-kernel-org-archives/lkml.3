Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753998Ab3FYTMl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 15:12:41 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:40847 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751887Ab3FYSdd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 14:33:33 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Helge Deller <deller@gmx.de>
Subject: [ 14/95] parisc: tlb flush counting fix for SMP and UP
Date: Tue, 25 Jun 2013 11:32:01 -0700
Message-Id: <20130625182155.265685059@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130625182153.605455184@linuxfoundation.org>
References: <20130625182153.605455184@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Helge Deller <deller@gmx.de>

commit 0fc537d1d655cdae69b489dbba46ad617cfc1373 upstream.

Fix up build error on UP and show correctly number of function call
(ipi) irqs.

Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/parisc/include/asm/hardirq.h  |    6 +-----
 arch/parisc/include/asm/tlbflush.h |    2 ++
 arch/parisc/kernel/irq.c           |    5 ++---
 arch/parisc/kernel/smp.c           |   11 -----------
 4 files changed, 5 insertions(+), 19 deletions(-)

--- a/arch/parisc/include/asm/hardirq.h
+++ b/arch/parisc/include/asm/hardirq.h
@@ -19,12 +19,8 @@ typedef struct {
 #ifdef CONFIG_SMP
 	unsigned int irq_resched_count;
 	unsigned int irq_call_count;
-	/*
-	 * irq_tlb_count is double-counted in irq_call_count, so it must be
-	 * subtracted from irq_call_count when displaying irq_call_count
-	 */
-	unsigned int irq_tlb_count;
 #endif
+	unsigned int irq_tlb_count;
 } ____cacheline_aligned irq_cpustat_t;
 
 DECLARE_PER_CPU_SHARED_ALIGNED(irq_cpustat_t, irq_stat);
--- a/arch/parisc/include/asm/tlbflush.h
+++ b/arch/parisc/include/asm/tlbflush.h
@@ -22,6 +22,8 @@ extern spinlock_t pa_tlb_lock;
 extern void flush_tlb_all(void);
 extern void flush_tlb_all_local(void *);
 
+#define smp_flush_tlb_all()	flush_tlb_all()
+
 /*
  * flush_tlb_mm()
  *
--- a/arch/parisc/kernel/irq.c
+++ b/arch/parisc/kernel/irq.c
@@ -175,14 +175,13 @@ int arch_show_interrupts(struct seq_file
 	seq_printf(p, "  Rescheduling interrupts\n");
 	seq_printf(p, "%*s: ", prec, "CAL");
 	for_each_online_cpu(j)
-		seq_printf(p, "%10u ", irq_stats(j)->irq_call_count -
-					irq_stats(j)->irq_tlb_count);
+		seq_printf(p, "%10u ", irq_stats(j)->irq_call_count);
 	seq_printf(p, "  Function call interrupts\n");
+#endif
 	seq_printf(p, "%*s: ", prec, "TLB");
 	for_each_online_cpu(j)
 		seq_printf(p, "%10u ", irq_stats(j)->irq_tlb_count);
 	seq_printf(p, "  TLB shootdowns\n");
-#endif
 	return 0;
 }
 
--- a/arch/parisc/kernel/smp.c
+++ b/arch/parisc/kernel/smp.c
@@ -264,17 +264,6 @@ void arch_send_call_function_single_ipi(
 }
 
 /*
- * Flush all other CPU's tlb and then mine.  Do this with on_each_cpu()
- * as we want to ensure all TLB's flushed before proceeding.
- */
-
-void
-smp_flush_tlb_all(void)
-{
-	on_each_cpu(flush_tlb_all_local, NULL, 1);
-}
-
-/*
  * Called by secondaries to update state and initialize CPU registers.
  */
 static void __init


