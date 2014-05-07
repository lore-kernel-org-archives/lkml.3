Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933332AbaEGPpf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 11:45:35 -0400
Received: from www.linutronix.de ([62.245.132.108]:48694 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756932AbaEGPoG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 11:44:06 -0400
Message-Id: <20140507154340.302183048@linutronix.de>
User-Agent: quilt/0.60-1
Date: Wed, 07 May 2014 15:44:21 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Anvin <hpa@zytor.com>,
        Tony Luck <tony.luck@intel.com>, Peter Zijlstra <peterz@infradead.org>
Subject: [patch 29/32] genirq: Remove irq_reserve_irq[s]
References: <20140507153622.703412101@linutronix.de>
Content-Disposition: inline; filename=genirq-remove-irq-reserve.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No more users. And it's not going to come back. If you need
hotplugable irq chips, use irq domains.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 include/linux/irq.h  |    7 -------
 kernel/irq/irqdesc.c |   25 -------------------------
 2 files changed, 32 deletions(-)

Index: tip/include/linux/irq.h
===================================================================
--- tip.orig/include/linux/irq.h
+++ tip/include/linux/irq.h
@@ -617,18 +617,11 @@ int __irq_alloc_descs(int irq, unsigned
 	irq_alloc_descs(-1, from, cnt, node)
 
 void irq_free_descs(unsigned int irq, unsigned int cnt);
-int irq_reserve_irqs(unsigned int from, unsigned int cnt);
-
 static inline void irq_free_desc(unsigned int irq)
 {
 	irq_free_descs(irq, 1);
 }
 
-static inline int irq_reserve_irq(unsigned int irq)
-{
-	return irq_reserve_irqs(irq, 1);
-}
-
 #ifdef CONFIG_GENERIC_IRQ_LEGACY_ALLOC_HWIRQ
 unsigned int irq_alloc_hwirqs(int cnt, int node);
 static inline unsigned int irq_alloc_hwirq(int node)
Index: tip/kernel/irq/irqdesc.c
===================================================================
--- tip.orig/kernel/irq/irqdesc.c
+++ tip/kernel/irq/irqdesc.c
@@ -455,31 +455,6 @@ EXPORT_SYMBOL_GPL(irq_free_hwirqs);
 #endif
 
 /**
- * irq_reserve_irqs - mark irqs allocated
- * @from:	mark from irq number
- * @cnt:	number of irqs to mark
- *
- * Returns 0 on success or an appropriate error code
- */
-int irq_reserve_irqs(unsigned int from, unsigned int cnt)
-{
-	unsigned int start;
-	int ret = 0;
-
-	if (!cnt || (from + cnt) > nr_irqs)
-		return -EINVAL;
-
-	mutex_lock(&sparse_irq_lock);
-	start = bitmap_find_next_zero_area(allocated_irqs, nr_irqs, from, cnt, 0);
-	if (start == from)
-		bitmap_set(allocated_irqs, start, cnt);
-	else
-		ret = -EEXIST;
-	mutex_unlock(&sparse_irq_lock);
-	return ret;
-}
-
-/**
  * irq_get_next_irq - get next allocated irq number
  * @offset:	where to start the search
  *


