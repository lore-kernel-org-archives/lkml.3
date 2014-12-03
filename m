Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752594AbaLCHwm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 02:52:42 -0500
Received: from mga11.intel.com ([192.55.52.93]:1928 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752401AbaLCHuy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 02:50:54 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,506,1413270000"; 
   d="scan'208";a="631852487"
From: Feng Wu <feng.wu@intel.com>
To: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
        gleb@kernel.org, pbonzini@redhat.com, dwmw2@infradead.org,
        joro@8bytes.org, alex.williamson@redhat.com, jiang.liu@linux.intel.com
Cc: linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
        kvm@vger.kernel.org, Feng Wu <feng.wu@intel.com>
Subject: [v2 20/25] x86, irq: Define a global vector for VT-d Posted-Interrupts
Date: Wed,  3 Dec 2014 15:39:49 +0800
Message-Id: <1417592394-24343-21-git-send-email-feng.wu@intel.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1417592394-24343-1-git-send-email-feng.wu@intel.com>
References: <1417592394-24343-1-git-send-email-feng.wu@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, we use a global vector as the Posted-Interrupts
Notification Event for all the vCPUs in the system. We need
to introduce another global vector for VT-d Posted-Interrtups,
which will be used to wakeup the sleep vCPU when an external
interrupt from a direct-assigned device happens for that vCPU.

Signed-off-by: Feng Wu <feng.wu@intel.com>
---
 arch/x86/include/asm/entry_arch.h  |    2 ++
 arch/x86/include/asm/hardirq.h     |    1 +
 arch/x86/include/asm/hw_irq.h      |    2 ++
 arch/x86/include/asm/irq_vectors.h |    1 +
 arch/x86/kernel/entry_64.S         |    2 ++
 arch/x86/kernel/irq.c              |   27 +++++++++++++++++++++++++++
 arch/x86/kernel/irqinit.c          |    2 ++
 7 files changed, 37 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/entry_arch.h b/arch/x86/include/asm/entry_arch.h
index dc5fa66..27ca0af 100644
--- a/arch/x86/include/asm/entry_arch.h
+++ b/arch/x86/include/asm/entry_arch.h
@@ -23,6 +23,8 @@ BUILD_INTERRUPT(x86_platform_ipi, X86_PLATFORM_IPI_VECTOR)
 #ifdef CONFIG_HAVE_KVM
 BUILD_INTERRUPT3(kvm_posted_intr_ipi, POSTED_INTR_VECTOR,
 		 smp_kvm_posted_intr_ipi)
+BUILD_INTERRUPT3(kvm_posted_intr_wakeup_ipi, POSTED_INTR_WAKEUP_VECTOR,
+		 smp_kvm_posted_intr_wakeup_ipi)
 #endif
 
 /*
diff --git a/arch/x86/include/asm/hardirq.h b/arch/x86/include/asm/hardirq.h
index 0f5fb6b..9866065 100644
--- a/arch/x86/include/asm/hardirq.h
+++ b/arch/x86/include/asm/hardirq.h
@@ -14,6 +14,7 @@ typedef struct {
 #endif
 #ifdef CONFIG_HAVE_KVM
 	unsigned int kvm_posted_intr_ipis;
+	unsigned int kvm_posted_intr_wakeup_ipis;
 #endif
 	unsigned int x86_platform_ipis;	/* arch dependent */
 	unsigned int apic_perf_irqs;
diff --git a/arch/x86/include/asm/hw_irq.h b/arch/x86/include/asm/hw_irq.h
index e7ae6eb..38fac9b 100644
--- a/arch/x86/include/asm/hw_irq.h
+++ b/arch/x86/include/asm/hw_irq.h
@@ -29,6 +29,7 @@
 extern asmlinkage void apic_timer_interrupt(void);
 extern asmlinkage void x86_platform_ipi(void);
 extern asmlinkage void kvm_posted_intr_ipi(void);
+extern asmlinkage void kvm_posted_intr_wakeup_ipi(void);
 extern asmlinkage void error_interrupt(void);
 extern asmlinkage void irq_work_interrupt(void);
 
@@ -92,6 +93,7 @@ extern void trace_call_function_single_interrupt(void);
 #define trace_irq_move_cleanup_interrupt  irq_move_cleanup_interrupt
 #define trace_reboot_interrupt  reboot_interrupt
 #define trace_kvm_posted_intr_ipi kvm_posted_intr_ipi
+#define trace_kvm_posted_intr_wakeup_ipi kvm_posted_intr_wakeup_ipi
 #endif /* CONFIG_TRACING */
 
 struct irq_domain;
diff --git a/arch/x86/include/asm/irq_vectors.h b/arch/x86/include/asm/irq_vectors.h
index b26cb12..dca94f2 100644
--- a/arch/x86/include/asm/irq_vectors.h
+++ b/arch/x86/include/asm/irq_vectors.h
@@ -105,6 +105,7 @@
 /* Vector for KVM to deliver posted interrupt IPI */
 #ifdef CONFIG_HAVE_KVM
 #define POSTED_INTR_VECTOR		0xf2
+#define POSTED_INTR_WAKEUP_VECTOR	0xf1
 #endif
 
 /*
diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
index e61c14a..a598447 100644
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -960,6 +960,8 @@ apicinterrupt X86_PLATFORM_IPI_VECTOR \
 #ifdef CONFIG_HAVE_KVM
 apicinterrupt3 POSTED_INTR_VECTOR \
 	kvm_posted_intr_ipi smp_kvm_posted_intr_ipi
+apicinterrupt3 POSTED_INTR_WAKEUP_VECTOR \
+	kvm_posted_intr_wakeup_ipi smp_kvm_posted_intr_wakeup_ipi
 #endif
 
 #ifdef CONFIG_X86_MCE_THRESHOLD
diff --git a/arch/x86/kernel/irq.c b/arch/x86/kernel/irq.c
index 922d285..47408c3 100644
--- a/arch/x86/kernel/irq.c
+++ b/arch/x86/kernel/irq.c
@@ -237,6 +237,9 @@ __visible void smp_x86_platform_ipi(struct pt_regs *regs)
 }
 
 #ifdef CONFIG_HAVE_KVM
+void (*wakeup_handler_callback)(void) = NULL;
+EXPORT_SYMBOL_GPL(wakeup_handler_callback);
+
 /*
  * Handler for POSTED_INTERRUPT_VECTOR.
  */
@@ -256,6 +259,30 @@ __visible void smp_kvm_posted_intr_ipi(struct pt_regs *regs)
 
 	set_irq_regs(old_regs);
 }
+
+/*
+ * Handler for POSTED_INTERRUPT_WAKEUP_VECTOR.
+ */
+__visible void smp_kvm_posted_intr_wakeup_ipi(struct pt_regs *regs)
+{
+	struct pt_regs *old_regs = set_irq_regs(regs);
+
+	ack_APIC_irq();
+
+	irq_enter();
+
+	exit_idle();
+
+	inc_irq_stat(kvm_posted_intr_wakeup_ipis);
+
+	if (wakeup_handler_callback)
+		wakeup_handler_callback();
+
+	irq_exit();
+
+	set_irq_regs(old_regs);
+}
+
 #endif
 
 __visible void smp_trace_x86_platform_ipi(struct pt_regs *regs)
diff --git a/arch/x86/kernel/irqinit.c b/arch/x86/kernel/irqinit.c
index 70e181e..844673c 100644
--- a/arch/x86/kernel/irqinit.c
+++ b/arch/x86/kernel/irqinit.c
@@ -144,6 +144,8 @@ static void __init apic_intr_init(void)
 #ifdef CONFIG_HAVE_KVM
 	/* IPI for KVM to deliver posted interrupt */
 	alloc_intr_gate(POSTED_INTR_VECTOR, kvm_posted_intr_ipi);
+	/* IPI for KVM to deliver interrupt to wake up tasks */
+	alloc_intr_gate(POSTED_INTR_WAKEUP_VECTOR, kvm_posted_intr_wakeup_ipi);
 #endif
 
 	/* IPI vectors for APIC spurious and error interrupts */
-- 
1.7.1

