Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751983AbaKCIjt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 03:39:49 -0500
Received: from mail.emea.novell.com ([130.57.118.101]:59416 "EHLO
	mail.emea.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751650AbaKCIjq convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:3:1>);
	Mon, 3 Nov 2014 03:39:46 -0500
Message-Id: <54574D5F0200007800044389@mail.emea.novell.com>
X-Mailer: Novell GroupWise Internet Agent 14.0.1 
Date: Mon, 03 Nov 2014 08:39:43 +0000
From: "Jan Beulich" <JBeulich@suse.com>
To: <mingo@elte.hu>, <tglx@linutronix.de>, <hpa@zytor.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86: avoid building unused IRQ entry stubs
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When X86_LOCAL_APIC (i.e. unconditionally on x86-64),
first_system_vector will never end up being higher than
LOCAL_TIMER_VECTOR (0xef), and hence building stubs for vectors
0xef...0xff is pointlessly reducing code density. Deal with this at
build time already.

Taking into consideration that X86_64 implies X86_LOCAL_APIC, also
simplify (and hence make easier to read and more consistent with the
change done here) some #if-s in arch/x86/kernel/irqinit.c.

While we could further improve the packing of the IRQ entry stubs (the
four ones now left in the last set could be fit into the four padding
bytes each of the final four sets have) this doesn't seem to provide
any real benefit: Both irq_entries_start and common_interrupt getting
cache line aligned, eliminating the 30th set would just produce 32
bytes of padding between the 29th and common_interrupt.

Signed-off-by: Jan Beulich <jbeulich@suse.com>
---
 arch/x86/include/asm/hw_irq.h      |    3 ++-
 arch/x86/include/asm/irq_vectors.h |    6 ++++++
 arch/x86/kernel/apic/apic.c        |   22 ++++++++++++----------
 arch/x86/kernel/entry_32.S         |    4 ++--
 arch/x86/kernel/entry_64.S         |    4 ++--
 arch/x86/kernel/irqinit.c          |   13 +++++++++----
 6 files changed, 33 insertions(+), 19 deletions(-)

--- 3.18-rc3/arch/x86/include/asm/hw_irq.h
+++ 3.18-rc3-x86-first-system-vector/arch/x86/include/asm/hw_irq.h
@@ -185,7 +185,8 @@ extern __visible void smp_call_function_
 extern __visible void smp_invalidate_interrupt(struct pt_regs *);
 #endif
 
-extern void (*__initconst interrupt[NR_VECTORS-FIRST_EXTERNAL_VECTOR])(void);
+extern void (*__initconst interrupt[FIRST_SYSTEM_VECTOR
+				    - FIRST_EXTERNAL_VECTOR])(void);
 #ifdef CONFIG_TRACING
 #define trace_interrupt interrupt
 #endif
--- 3.18-rc3/arch/x86/include/asm/irq_vectors.h
+++ 3.18-rc3-x86-first-system-vector/arch/x86/include/asm/irq_vectors.h
@@ -126,6 +126,12 @@
 
 #define NR_VECTORS			 256
 
+#ifdef CONFIG_X86_LOCAL_APIC
+#define FIRST_SYSTEM_VECTOR		LOCAL_TIMER_VECTOR
+#else
+#define FIRST_SYSTEM_VECTOR		NR_VECTORS
+#endif
+
 #define FPU_IRQ				  13
 
 #define	FIRST_VM86_IRQ			   3
--- 3.18-rc3/arch/x86/kernel/apic/apic.c
+++ 3.18-rc3-x86-first-system-vector/arch/x86/kernel/apic/apic.c
@@ -196,7 +196,7 @@ static int disable_apic_timer __initdata
 int local_apic_timer_c2_ok;
 EXPORT_SYMBOL_GPL(local_apic_timer_c2_ok);
 
-int first_system_vector = 0xfe;
+int first_system_vector = FIRST_SYSTEM_VECTOR;
 
 /*
  * Debug level, exported for io_apic.c
@@ -1930,7 +1930,7 @@ int __init APIC_init_uniprocessor(void)
 /*
  * This interrupt should _never_ happen with our APIC/SMP architecture
  */
-static inline void __smp_spurious_interrupt(void)
+static inline void __smp_spurious_interrupt(u8 vector)
 {
 	u32 v;
 
@@ -1939,30 +1939,32 @@ static inline void __smp_spurious_interr
 	 * if it is a vectored one.  Just in case...
 	 * Spurious interrupts should not be ACKed.
 	 */
-	v = apic_read(APIC_ISR + ((SPURIOUS_APIC_VECTOR & ~0x1f) >> 1));
-	if (v & (1 << (SPURIOUS_APIC_VECTOR & 0x1f)))
+	v = apic_read(APIC_ISR + ((vector & ~0x1f) >> 1));
+	if (v & (1 << (vector & 0x1f)))
 		ack_APIC_irq();
 
 	inc_irq_stat(irq_spurious_count);
 
 	/* see sw-dev-man vol 3, chapter 7.4.13.5 */
-	pr_info("spurious APIC interrupt on CPU#%d, "
-		"should never happen.\n", smp_processor_id());
+	pr_info("spurious APIC interrupt through vector %02x on CPU#%d, "
+		"should never happen.\n", vector, smp_processor_id());
 }
 
 __visible void smp_spurious_interrupt(struct pt_regs *regs)
 {
 	entering_irq();
-	__smp_spurious_interrupt();
+	__smp_spurious_interrupt(~regs->orig_ax);
 	exiting_irq();
 }
 
 __visible void smp_trace_spurious_interrupt(struct pt_regs *regs)
 {
+	u8 vector = ~regs->orig_ax;
+
 	entering_irq();
-	trace_spurious_apic_entry(SPURIOUS_APIC_VECTOR);
-	__smp_spurious_interrupt();
-	trace_spurious_apic_exit(SPURIOUS_APIC_VECTOR);
+	trace_spurious_apic_entry(vector);
+	__smp_spurious_interrupt(vector);
+	trace_spurious_apic_exit(vector);
 	exiting_irq();
 }
 
--- 3.18-rc3/arch/x86/kernel/entry_32.S
+++ 3.18-rc3-x86-first-system-vector/arch/x86/kernel/entry_32.S
@@ -732,10 +732,10 @@ ENTRY(interrupt)
 ENTRY(irq_entries_start)
 	RING0_INT_FRAME
 vector=FIRST_EXTERNAL_VECTOR
-.rept (NR_VECTORS-FIRST_EXTERNAL_VECTOR+6)/7
+.rept (FIRST_SYSTEM_VECTOR-FIRST_EXTERNAL_VECTOR+6)/7
 	.balign 32
   .rept	7
-    .if vector < NR_VECTORS
+    .if vector < FIRST_SYSTEM_VECTOR
       .if vector <> FIRST_EXTERNAL_VECTOR
 	CFI_ADJUST_CFA_OFFSET -4
       .endif
--- 3.18-rc3/arch/x86/kernel/entry_64.S
+++ 3.18-rc3-x86-first-system-vector/arch/x86/kernel/entry_64.S
@@ -712,10 +712,10 @@ ENTRY(interrupt)
 ENTRY(irq_entries_start)
 	INTR_FRAME
 vector=FIRST_EXTERNAL_VECTOR
-.rept (NR_VECTORS-FIRST_EXTERNAL_VECTOR+6)/7
+.rept (FIRST_SYSTEM_VECTOR-FIRST_EXTERNAL_VECTOR+6)/7
 	.balign 32
   .rept	7
-    .if vector < NR_VECTORS
+    .if vector < FIRST_SYSTEM_VECTOR
       .if vector <> FIRST_EXTERNAL_VECTOR
 	CFI_ADJUST_CFA_OFFSET -8
       .endif
--- 3.18-rc3/arch/x86/kernel/irqinit.c
+++ 3.18-rc3-x86-first-system-vector/arch/x86/kernel/irqinit.c
@@ -124,7 +124,6 @@ void setup_vector_irq(int cpu)
 static void __init smp_intr_init(void)
 {
 #ifdef CONFIG_SMP
-#if defined(CONFIG_X86_64) || defined(CONFIG_X86_LOCAL_APIC)
 	/*
 	 * The reschedule interrupt is a CPU-to-CPU reschedule-helper
 	 * IPI, driven by wakeup.
@@ -144,7 +143,6 @@ static void __init smp_intr_init(void)
 
 	/* IPI used for rebooting/stopping */
 	alloc_intr_gate(REBOOT_VECTOR, reboot_interrupt);
-#endif
 #endif /* CONFIG_SMP */
 }
 
@@ -159,7 +157,7 @@ static void __init apic_intr_init(void)
 	alloc_intr_gate(THRESHOLD_APIC_VECTOR, threshold_interrupt);
 #endif
 
-#if defined(CONFIG_X86_64) || defined(CONFIG_X86_LOCAL_APIC)
+#ifdef CONFIG_X86_LOCAL_APIC
 	/* self generated IPI for local APIC timer */
 	alloc_intr_gate(LOCAL_TIMER_VECTOR, apic_timer_interrupt);
 
@@ -197,10 +195,17 @@ void __init native_init_IRQ(void)
 	 * 'special' SMP interrupts)
 	 */
 	i = FIRST_EXTERNAL_VECTOR;
-	for_each_clear_bit_from(i, used_vectors, NR_VECTORS) {
+#ifndef CONFIG_X86_LOCAL_APIC
+#define first_system_vector NR_VECTORS
+#endif
+	for_each_clear_bit_from(i, used_vectors, first_system_vector) {
 		/* IA32_SYSCALL_VECTOR could be used in trap_init already. */
 		set_intr_gate(i, interrupt[i - FIRST_EXTERNAL_VECTOR]);
 	}
+#ifdef CONFIG_X86_LOCAL_APIC
+	for_each_clear_bit_from(i, used_vectors, NR_VECTORS)
+		set_intr_gate(i, spurious_interrupt);
+#endif
 
 	if (!acpi_ioapic && !of_ioapic && nr_legacy_irqs())
 		setup_irq(2, &irq2);


