Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756976AbaEGPpK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 11:45:10 -0400
Received: from www.linutronix.de ([62.245.132.108]:48702 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756813AbaEGPoH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 11:44:07 -0400
Message-Id: <20140507154340.574437049@linutronix.de>
User-Agent: quilt/0.60-1
Date: Wed, 07 May 2014 15:44:22 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Anvin <hpa@zytor.com>,
        Tony Luck <tony.luck@intel.com>, Peter Zijlstra <peterz@infradead.org>
Subject: [patch 30/32] genirq: Replace dynamic_irq_init/cleanup
References: <20140507153622.703412101@linutronix.de>
Content-Disposition: inline; filename=genirq-replace-dynamic-irq-crap.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Create a new interface and confine it with a config switch which makes
clear that this is just legacy support and not to be used for new code.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 include/linux/irq.h  |    4 ++++
 kernel/irq/Kconfig   |    4 ++++
 kernel/irq/irqdesc.c |    7 +++++++
 3 files changed, 15 insertions(+)

Index: tip/include/linux/irq.h
===================================================================
--- tip.orig/include/linux/irq.h
+++ tip/include/linux/irq.h
@@ -637,6 +637,10 @@ int arch_setup_hwirq(unsigned int irq, i
 void arch_teardown_hwirq(unsigned int irq);
 #endif
 
+#ifdef CONFIG_GENERIC_IRQ_LEGACY
+void irq_init_desc(unsigned int irq);
+#endif
+
 #ifndef irq_reg_writel
 # define irq_reg_writel(val, addr)	writel(val, addr)
 #endif
Index: tip/kernel/irq/Kconfig
===================================================================
--- tip.orig/kernel/irq/Kconfig
+++ tip/kernel/irq/Kconfig
@@ -5,6 +5,10 @@ menu "IRQ subsystem"
 config MAY_HAVE_SPARSE_IRQ
        bool
 
+# Legacy support, required for itanic
+config GENERIC_IRQ_LEGACY
+       bool
+
 # Enable the generic irq autoprobe mechanism
 config GENERIC_IRQ_PROBE
 	bool
Index: tip/kernel/irq/irqdesc.c
===================================================================
--- tip.orig/kernel/irq/irqdesc.c
+++ tip/kernel/irq/irqdesc.c
@@ -306,6 +306,13 @@ void irq_mark_irq(unsigned int irq)
 	mutex_unlock(&sparse_irq_lock);
 }
 
+#ifdef CONFIG_GENERIC_IRQ_LEGACY
+void irq_init_desc(unsigned int irq)
+{
+	dynamic_irq_cleanup(irq);
+}
+#endif
+
 #endif /* !CONFIG_SPARSE_IRQ */
 
 /**


