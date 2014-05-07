Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933312AbaEGPou (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 11:44:50 -0400
Received: from www.linutronix.de ([62.245.132.108]:48708 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756950AbaEGPoI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 11:44:08 -0400
Message-Id: <20140507154340.782586778@linutronix.de>
User-Agent: quilt/0.60-1
Date: Wed, 07 May 2014 15:44:22 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Anvin <hpa@zytor.com>,
        Tony Luck <tony.luck@intel.com>, Peter Zijlstra <peterz@infradead.org>,
        Fenghua Yu <fenghua.yu@intel.com>
Subject: [patch 31/32] ia64: Use irq_init_desc
References: <20140507153622.703412101@linutronix.de>
Content-Disposition: inline; filename=ia64-use-irq-init-desc.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Switch over to the new interface. No functional change.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>
---
 arch/ia64/Kconfig           |    1 +
 arch/ia64/kernel/iosapic.c  |    2 +-
 arch/ia64/kernel/irq_ia64.c |    7 +++----
 3 files changed, 5 insertions(+), 5 deletions(-)

Index: tip/arch/ia64/Kconfig
===================================================================
--- tip.orig/arch/ia64/Kconfig
+++ tip/arch/ia64/Kconfig
@@ -32,6 +32,7 @@ config IA64
 	select GENERIC_IRQ_PROBE
 	select GENERIC_PENDING_IRQ if SMP
 	select GENERIC_IRQ_SHOW
+	select GENERIC_IRQ_LEGACY
 	select ARCH_WANT_OPTIONAL_GPIOLIB
 	select ARCH_HAVE_NMI_SAFE_CMPXCHG
 	select GENERIC_IOMAP
Index: tip/arch/ia64/kernel/iosapic.c
===================================================================
--- tip.orig/arch/ia64/kernel/iosapic.c
+++ tip/arch/ia64/kernel/iosapic.c
@@ -735,7 +735,7 @@ iosapic_register_intr (unsigned int gsi,
 		rte = find_rte(irq, gsi);
 		if(iosapic_intr_info[irq].count == 0) {
 			assign_irq_vector(irq);
-			dynamic_irq_init(irq);
+			irq_init_desc(irq);
 		} else if (rte->refcnt != NO_REF_RTE) {
 			rte->refcnt++;
 			goto unlock_iosapic_lock;
Index: tip/arch/ia64/kernel/irq_ia64.c
===================================================================
--- tip.orig/arch/ia64/kernel/irq_ia64.c
+++ tip/arch/ia64/kernel/irq_ia64.c
@@ -382,8 +382,7 @@ void destroy_and_reserve_irq(unsigned in
 {
 	unsigned long flags;
 
-	dynamic_irq_cleanup(irq);
-
+	irq_init_desc(irq);
 	spin_lock_irqsave(&vector_lock, flags);
 	__clear_irq_vector(irq);
 	irq_status[irq] = IRQ_RSVD;
@@ -416,13 +415,13 @@ int create_irq(void)
  out:
 	spin_unlock_irqrestore(&vector_lock, flags);
 	if (irq >= 0)
-		dynamic_irq_init(irq);
+		irq_init_desc(irq);
 	return irq;
 }
 
 void destroy_irq(unsigned int irq)
 {
-	dynamic_irq_cleanup(irq);
+	irq_init_desc(irq);
 	clear_irq_vector(irq);
 }
 


