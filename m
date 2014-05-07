Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756937AbaEGPoG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 11:44:06 -0400
Received: from www.linutronix.de ([62.245.132.108]:48565 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756813AbaEGPn6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 11:43:58 -0400
Message-Id: <20140507154336.947853241@linutronix.de>
User-Agent: quilt/0.60-1
Date: Wed, 07 May 2014 15:44:13 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Anvin <hpa@zytor.com>,
        Tony Luck <tony.luck@intel.com>, Peter Zijlstra <peterz@infradead.org>,
        Chris Metcalf <cmetcalf@tilera.com>
Subject: [patch 15/32] tile: Implement irq_alloc/free_hwirq() for migration
References: <20140507153622.703412101@linutronix.de>
Content-Disposition: inline;
 filename=tile-implement-temporay-irq-alloc-free-hwirq.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We want to convert the drivers over to the new interface and finally
tile to sparse irqs. Implement irq_alloc/free_hwirq() for step by step
migration.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Chris Metcalf <cmetcalf@tilera.com>
---
 arch/tile/include/asm/irq.h |    3 +++
 arch/tile/kernel/irq.c      |   12 ++++++++++++
 2 files changed, 15 insertions(+)

Index: tip/arch/tile/include/asm/irq.h
===================================================================
--- tip.orig/arch/tile/include/asm/irq.h
+++ tip/arch/tile/include/asm/irq.h
@@ -76,4 +76,7 @@ void tile_irq_activate(unsigned int irq,
 
 void setup_irq_regs(void);
 
+unsigned int irq_alloc_hwirq(int node);
+void irq_free_hwirq(unsigned int irq);
+
 #endif /* _ASM_TILE_IRQ_H */
Index: tip/arch/tile/kernel/irq.c
===================================================================
--- tip.orig/arch/tile/kernel/irq.c
+++ tip/arch/tile/kernel/irq.c
@@ -312,4 +312,16 @@ void destroy_irq(unsigned int irq)
 	spin_unlock_irqrestore(&available_irqs_lock, flags);
 }
 EXPORT_SYMBOL(destroy_irq);
+
+unsigned int irq_alloc_hwirq(int node)
+{
+	int ret = create_irq();
+	return ret < 0 ? 0 : ret;
+}
+
+void irq_free_hwirq(unsigned int irq)
+{
+	destroy_irq();
+}
+
 #endif


