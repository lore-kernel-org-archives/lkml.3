Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756616AbaEGPys (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 11:54:48 -0400
Received: from www.linutronix.de ([62.245.132.108]:48512 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756705AbaEGPnx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 11:43:53 -0400
Message-Id: <20140507154335.252789823@linutronix.de>
User-Agent: quilt/0.60-1
Date: Wed, 07 May 2014 15:44:08 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Anvin <hpa@zytor.com>,
        Tony Luck <tony.luck@intel.com>, Peter Zijlstra <peterz@infradead.org>
Subject: [patch 07/32] x86: uv: Use irq_alloc/free_hwirq()
References: <20140507153622.703412101@linutronix.de>
Content-Disposition: inline; filename=x86-uv-use-irq-alloc-free-hwirq.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No functional change. The request to allocate the irq above
NR_IRQS_LEGACY is completely pointless as the implementation enforces
that the dynamic allocations are above the GSI interrupts, which
includes the legacy PIT irqs.

This does not replace the requirement to move x86 to irq domains, but
it limits the mess to some degree.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: x86@kernel.org
---
 arch/x86/platform/uv/uv_irq.c |   10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

Index: tip/arch/x86/platform/uv/uv_irq.c
===================================================================
--- tip.orig/arch/x86/platform/uv/uv_irq.c
+++ tip/arch/x86/platform/uv/uv_irq.c
@@ -238,11 +238,9 @@ uv_set_irq_affinity(struct irq_data *dat
 int uv_setup_irq(char *irq_name, int cpu, int mmr_blade,
 		 unsigned long mmr_offset, int limit)
 {
-	int irq, ret;
+	int ret, irq = irq_alloc_hwirq(uv_blade_to_memory_nid(mmr_blade));
 
-	irq = create_irq_nr(NR_IRQS_LEGACY, uv_blade_to_memory_nid(mmr_blade));
-
-	if (irq <= 0)
+	if (!irq)
 		return -EBUSY;
 
 	ret = arch_enable_uv_irq(irq_name, irq, cpu, mmr_blade, mmr_offset,
@@ -250,7 +248,7 @@ int uv_setup_irq(char *irq_name, int cpu
 	if (ret == irq)
 		uv_set_irq_2_mmr_info(irq, mmr_offset, mmr_blade);
 	else
-		destroy_irq(irq);
+		irq_free_hwirq(irq);
 
 	return ret;
 }
@@ -285,6 +283,6 @@ void uv_teardown_irq(unsigned int irq)
 			n = n->rb_right;
 	}
 	spin_unlock_irqrestore(&uv_irq_lock, irqflags);
-	destroy_irq(irq);
+	irq_free_hwirq(irq);
 }
 EXPORT_SYMBOL_GPL(uv_teardown_irq);


