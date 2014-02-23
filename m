Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752783AbaBWVnu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Feb 2014 16:43:50 -0500
Received: from www.linutronix.de ([62.245.132.108]:52311 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752088AbaBWVkL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Feb 2014 16:40:11 -0500
Message-Id: <20140223212738.681855582@linutronix.de>
User-Agent: quilt/0.60-1
Date: Sun, 23 Feb 2014 21:40:20 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        x86 <x86@kernel.org>, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [patch 22/26] x86: Add proper vector accounting for HyperV
References: <20140223212703.511977310@linutronix.de>
Content-Disposition: inline; filename=x86-add-a-proper-vector-accounting.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

HyperV abuses a device interrupt to account for the
HYPERVISOR_CALLBACK_VECTOR.

Provide proper accounting as we have for the other vectors as well.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: x86 <x86@kernel.org>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
---
 arch/x86/include/asm/hardirq.h |    3 +++
 arch/x86/kernel/irq.c          |    6 ++++++
 2 files changed, 9 insertions(+)

Index: tip/arch/x86/include/asm/hardirq.h
===================================================================
--- tip.orig/arch/x86/include/asm/hardirq.h
+++ tip/arch/x86/include/asm/hardirq.h
@@ -33,6 +33,9 @@ typedef struct {
 #ifdef CONFIG_X86_MCE_THRESHOLD
 	unsigned int irq_threshold_count;
 #endif
+#if defined(CONFIG_HYPERV) || defined(CONFIG_XEN)
+	unsigned int irq_hv_callback_count;
+#endif
 } ____cacheline_aligned irq_cpustat_t;
 
 DECLARE_PER_CPU_SHARED_ALIGNED(irq_cpustat_t, irq_stat);
Index: tip/arch/x86/kernel/irq.c
===================================================================
--- tip.orig/arch/x86/kernel/irq.c
+++ tip/arch/x86/kernel/irq.c
@@ -125,6 +125,12 @@ int arch_show_interrupts(struct seq_file
 		seq_printf(p, "%10u ", per_cpu(mce_poll_count, j));
 	seq_printf(p, "  Machine check polls\n");
 #endif
+#if defined(CONFIG_HYPERV) || defined(CONFIG_XEN)
+	seq_printf(p, "%*s: ", prec, "THR");
+	for_each_online_cpu(j)
+		seq_printf(p, "%10u ", irq_stats(j)->irq_hv_callback_count);
+	seq_printf(p, "  Hypervisor callback interrupts\n");
+#endif
 	seq_printf(p, "%*s: %10u\n", prec, "ERR", atomic_read(&irq_err_count));
 #if defined(CONFIG_X86_IO_APIC)
 	seq_printf(p, "%*s: %10u\n", prec, "MIS", atomic_read(&irq_mis_count));


