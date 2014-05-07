Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756821AbaEGPn6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 11:43:58 -0400
Received: from www.linutronix.de ([62.245.132.108]:48496 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752262AbaEGPnv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 11:43:51 -0400
Message-Id: <20140507154334.482904047@linutronix.de>
User-Agent: quilt/0.60-1
Date: Wed, 07 May 2014 15:44:06 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Anvin <hpa@zytor.com>,
        Tony Luck <tony.luck@intel.com>, Peter Zijlstra <peterz@infradead.org>
Subject: [patch 04/32] x86: Implement arch_setup/teardown_hwirq()
References: <20140507153622.703412101@linutronix.de>
Content-Disposition: inline; filename=x86-implement-setup-teardown-hwirqs.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is just a cleanup to get rid of the create/destroy_irq variants
which were designed in hell.

The long term solution for x86 is to switch over to irq domains and
cleanup the whole vector allocation mess.

The generic irq_alloc_hwirqs() interface deliberately prevents
multi-MSI vector allocation to further enforce the irq domain
conversion (aside of the desire to support ioapic hotplug).

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: x86@kernel.org
---
 arch/x86/Kconfig               |    1 +
 arch/x86/kernel/apic/io_apic.c |   33 +++++++++++++++++++++++++++++++++
 2 files changed, 34 insertions(+)

Index: tip/arch/x86/Kconfig
===================================================================
--- tip.orig/arch/x86/Kconfig
+++ tip/arch/x86/Kconfig
@@ -831,6 +831,7 @@ config X86_LOCAL_APIC
 config X86_IO_APIC
 	def_bool y
 	depends on X86_64 || SMP || X86_32_NON_STANDARD || X86_UP_IOAPIC || PCI_MSI
+	select GENERIC_IRQ_LEGACY_ALLOC_HWIRQ
 
 config X86_REROUTE_FOR_BROKEN_BOOT_IRQS
 	bool "Reroute for broken boot IRQs"
Index: tip/arch/x86/kernel/apic/io_apic.c
===================================================================
--- tip.orig/arch/x86/kernel/apic/io_apic.c
+++ tip/arch/x86/kernel/apic/io_apic.c
@@ -3010,6 +3010,39 @@ void destroy_irqs(unsigned int irq, unsi
 		destroy_irq(irq + i);
 }
 
+int arch_setup_hwirq(unsigned int irq, int node)
+{
+	struct irq_cfg *cfg;
+	unsigned long flags;
+	int ret;
+
+	cfg = alloc_irq_cfg(irq, node);
+	if (!cfg)
+		return -ENOMEM;
+
+	raw_spin_lock_irqsave(&vector_lock, flags);
+	ret = __assign_irq_vector(irq, cfg, apic->target_cpus());
+	raw_spin_unlock_irqrestore(&vector_lock, flags);
+
+	if (!ret)
+		irq_set_chip_data(irq, cfg);
+	else
+		free_irq_cfg(irq, cfg);
+	return ret;
+}
+
+void arch_teardown_hwirq(unsigned int irq)
+{
+	struct irq_cfg *cfg = irq_get_chip_data(irq);
+	unsigned long flags;
+
+	free_remapped_irq(irq);
+	raw_spin_lock_irqsave(&vector_lock, flags);
+	__clear_irq_vector(irq, cfg);
+	raw_spin_unlock_irqrestore(&vector_lock, flags);
+	free_irq_cfg(irq, cfg);
+}
+
 /*
  * MSI message composition
  */


