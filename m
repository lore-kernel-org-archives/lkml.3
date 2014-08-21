Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752613AbaHUOzd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 10:55:33 -0400
Received: from mail-wi0-f171.google.com ([209.85.212.171]:65377 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751999AbaHUOxI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 10:53:08 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Catalin Iacob <iacobcatalin@gmail.com>, Dave Jones <davej@redhat.com>,
        Ingo Molnar <mingo@kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [RFC PATCH 4/9] x86: Build irq work only if local apic support
Date: Thu, 21 Aug 2014 16:52:52 +0200
Message-Id: <1408632777-3348-5-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1408632777-3348-1-git-send-email-fweisbec@gmail.com>
References: <1408632777-3348-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Irq work won't run without local apic support. This check is currently
hacked-up through ifdeffery. Lets do conditional build instead. That
way we avoid further ifdefs with the implementation of
arch_irq_work_has_own_interrupt().

Cc: Catalin Iacob <iacobcatalin@gmail.com>
Cc: Dave Jones <davej@redhat.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 arch/x86/Kconfig                  | 4 ++++
 arch/x86/include/asm/entry_arch.h | 2 +-
 arch/x86/kernel/Makefile          | 2 +-
 arch/x86/kernel/entry_64.S        | 2 +-
 arch/x86/kernel/irq_work.c        | 2 --
 arch/x86/kernel/irqinit.c         | 2 +-
 6 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 5d0bf1a..147772f 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -837,6 +837,10 @@ config X86_LOCAL_APIC
 	def_bool y
 	depends on X86_64 || SMP || X86_32_NON_STANDARD || X86_UP_APIC || PCI_MSI
 
+config X86_IRQ_WORK
+	def_bool y
+	depends on X86_LOCAL_APIC && IRQ_WORK
+
 config X86_IO_APIC
 	def_bool y
 	depends on X86_64 || SMP || X86_32_NON_STANDARD || X86_UP_IOAPIC || PCI_MSI
diff --git a/arch/x86/include/asm/entry_arch.h b/arch/x86/include/asm/entry_arch.h
index dc5fa66..f8344d2 100644
--- a/arch/x86/include/asm/entry_arch.h
+++ b/arch/x86/include/asm/entry_arch.h
@@ -38,7 +38,7 @@ BUILD_INTERRUPT(apic_timer_interrupt,LOCAL_TIMER_VECTOR)
 BUILD_INTERRUPT(error_interrupt,ERROR_APIC_VECTOR)
 BUILD_INTERRUPT(spurious_interrupt,SPURIOUS_APIC_VECTOR)
 
-#ifdef CONFIG_IRQ_WORK
+#ifdef CONFIG_X86_IRQ_WORK
 BUILD_INTERRUPT(irq_work_interrupt, IRQ_WORK_VECTOR)
 #endif
 
diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
index b5ea75c..ddb4994 100644
--- a/arch/x86/kernel/Makefile
+++ b/arch/x86/kernel/Makefile
@@ -22,7 +22,7 @@ obj-y			:= process_$(BITS).o signal.o entry_$(BITS).o
 obj-y			+= traps.o irq.o irq_$(BITS).o dumpstack_$(BITS).o
 obj-y			+= time.o ioport.o ldt.o dumpstack.o nmi.o
 obj-y			+= setup.o x86_init.o i8259.o irqinit.o jump_label.o
-obj-$(CONFIG_IRQ_WORK)  += irq_work.o
+obj-$(CONFIG_X86_IRQ_WORK)  += irq_work.o
 obj-y			+= probe_roms.o
 obj-$(CONFIG_X86_32)	+= i386_ksyms_32.o
 obj-$(CONFIG_X86_64)	+= sys_x86_64.o x8664_ksyms_64.o
diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
index 2fac134..85056bd7 100644
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -1043,7 +1043,7 @@ apicinterrupt ERROR_APIC_VECTOR \
 apicinterrupt SPURIOUS_APIC_VECTOR \
 	spurious_interrupt smp_spurious_interrupt
 
-#ifdef CONFIG_IRQ_WORK
+#ifdef CONFIG_X86_IRQ_WORK
 apicinterrupt IRQ_WORK_VECTOR \
 	irq_work_interrupt smp_irq_work_interrupt
 #endif
diff --git a/arch/x86/kernel/irq_work.c b/arch/x86/kernel/irq_work.c
index 1de84e3..54f60a2 100644
--- a/arch/x86/kernel/irq_work.c
+++ b/arch/x86/kernel/irq_work.c
@@ -40,11 +40,9 @@ __visible void smp_trace_irq_work_interrupt(struct pt_regs *regs)
 
 void arch_irq_work_raise(void)
 {
-#ifdef CONFIG_X86_LOCAL_APIC
 	if (!cpu_has_apic)
 		return;
 
 	apic->send_IPI_self(IRQ_WORK_VECTOR);
 	apic_wait_icr_idle();
-#endif
 }
diff --git a/arch/x86/kernel/irqinit.c b/arch/x86/kernel/irqinit.c
index 1e6cff5..566d377 100644
--- a/arch/x86/kernel/irqinit.c
+++ b/arch/x86/kernel/irqinit.c
@@ -176,7 +176,7 @@ static void __init apic_intr_init(void)
 	alloc_intr_gate(ERROR_APIC_VECTOR, error_interrupt);
 
 	/* IRQ work interrupts: */
-# ifdef CONFIG_IRQ_WORK
+# ifdef CONFIG_X86_IRQ_WORK
 	alloc_intr_gate(IRQ_WORK_VECTOR, irq_work_interrupt);
 # endif
 
-- 
1.8.3.1

