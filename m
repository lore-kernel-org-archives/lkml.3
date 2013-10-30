Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754849Ab3J3Umb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 16:42:31 -0400
Received: from usindpps04.hds.com ([207.126.252.17]:58894 "EHLO
	usindpps04.hds.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752817Ab3J3Um1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 16:42:27 -0400
Message-ID: <52716DEC.5050204@hds.com>
Date: Wed, 30 Oct 2013 16:37:00 -0400
From: Seiji Aguchi <seiji.aguchi@hds.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, x86@kernel.org
CC: hpa@zytor.com, rostedt@goodmis.org, mingo@elte.hu, bp@alien8.de,
        tglx@linutronix.de, fdeslaur@gmail.com, raphael.beamonte@gmail.com,
        dle-develop@lists.sourceforge.net, tomoki.sekiyama@hds.com
Subject: [PATCH v4 2/4] Register exception handler to trace IDT
References: <52716D74.3070201@hds.com>
In-Reply-To: <52716D74.3070201@hds.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 mx ip4:207.126.244.0/26 ip4:207.126.252.0/25 include:mktomail.com
 include:cloud.hds.com ~all
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.10.8794,1.0.431,0.0.0000
 definitions=2013-10-30_06:2013-10-30,2013-10-30,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=outbound_policy score=0 spamscore=0 suspectscore=0
 phishscore=0 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=7.0.1-1305240000 definitions=main-1310300176
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch registers exception handlers for tracing to a trace IDT.

To implemented it in set_intr_gate(), this patch does followings.
 - Register the exception handlers to
   the trace IDT by prepending "trace_" to the handler's names.
 - Also, newly introduce trace_page_fault() to add tracepoints
   in a subsequent patch.

Signed-off-by: Seiji Aguchi <seiji.aguchi@hds.com>
---
 arch/x86/include/asm/desc.h    | 28 +++++++++++++++++++++++-----
 arch/x86/include/asm/hw_irq.h  |  3 +++
 arch/x86/include/asm/segment.h |  3 +++
 arch/x86/include/asm/traps.h   | 20 ++++++++++++++++++++
 arch/x86/kernel/entry_32.S     | 10 ++++++++++
 arch/x86/kernel/entry_64.S     | 13 ++++++++++++-
 arch/x86/kernel/head64.c       |  2 +-
 arch/x86/kernel/kvm.c          |  2 +-
 arch/x86/kernel/traps.c        | 28 ++++++++++++++--------------
 arch/x86/mm/fault.c            | 10 ++++++++++
 10 files changed, 97 insertions(+), 22 deletions(-)

diff --git a/arch/x86/include/asm/desc.h b/arch/x86/include/asm/desc.h
index d939567..3d73437 100644
--- a/arch/x86/include/asm/desc.h
+++ b/arch/x86/include/asm/desc.h
@@ -327,10 +327,25 @@ static inline void write_trace_idt_entry(int entry, const gate_desc *gate)
 {
 	write_idt_entry(trace_idt_table, entry, gate);
 }
+
+static inline void _trace_set_gate(int gate, unsigned type, void *addr,
+				   unsigned dpl, unsigned ist, unsigned seg)
+{
+	gate_desc s;
+
+	pack_gate(&s, type, (unsigned long)addr, dpl, ist, seg);
+	/*
+	 * does not need to be atomic because it is only done once at
+	 * setup time
+	 */
+	write_trace_idt_entry(gate, &s);
+}
 #else
 static inline void write_trace_idt_entry(int entry, const gate_desc *gate)
 {
 }
+
+#define _trace_set_gate(gate, type, addr, dpl, ist, seg)
 #endif
 
 static inline void _set_gate(int gate, unsigned type, void *addr,
@@ -353,11 +368,14 @@ static inline void _set_gate(int gate, unsigned type, void *addr,
  * Pentium F0 0F bugfix can have resulted in the mapped
  * IDT being write-protected.
  */
-static inline void set_intr_gate(unsigned int n, void *addr)
-{
-	BUG_ON((unsigned)n > 0xFF);
-	_set_gate(n, GATE_INTERRUPT, addr, 0, 0, __KERNEL_CS);
-}
+#define set_intr_gate(n, addr)						\
+	do {								\
+		BUG_ON((unsigned)n > 0xFF);				\
+		_set_gate(n, GATE_INTERRUPT, (void *)addr, 0, 0,	\
+			  __KERNEL_CS);					\
+		_trace_set_gate(n, GATE_INTERRUPT, (void *)trace_##addr,\
+				0, 0, __KERNEL_CS);			\
+	} while (0)
 
 extern int first_system_vector;
 /* used_vectors is BITMAP for irq is not managed by percpu vector_irq */
diff --git a/arch/x86/include/asm/hw_irq.h b/arch/x86/include/asm/hw_irq.h
index 92b3bae..cba45d9 100644
--- a/arch/x86/include/asm/hw_irq.h
+++ b/arch/x86/include/asm/hw_irq.h
@@ -187,6 +187,9 @@ extern __visible void smp_invalidate_interrupt(struct pt_regs *);
 #endif
 
 extern void (*__initconst interrupt[NR_VECTORS-FIRST_EXTERNAL_VECTOR])(void);
+#ifdef CONFIG_TRACING
+#define trace_interrupt interrupt
+#endif
 
 typedef int vector_irq_t[NR_VECTORS];
 DECLARE_PER_CPU(vector_irq_t, vector_irq);
diff --git a/arch/x86/include/asm/segment.h b/arch/x86/include/asm/segment.h
index c48a950..6f1c3a8 100644
--- a/arch/x86/include/asm/segment.h
+++ b/arch/x86/include/asm/segment.h
@@ -214,6 +214,9 @@
 #ifdef __KERNEL__
 #ifndef __ASSEMBLY__
 extern const char early_idt_handlers[NUM_EXCEPTION_VECTORS][2+2+5];
+#ifdef CONFIG_TRACING
+#define trace_early_idt_handlers early_idt_handlers
+#endif
 
 /*
  * Load a segment. Fall back on loading the zero
diff --git a/arch/x86/include/asm/traps.h b/arch/x86/include/asm/traps.h
index 7036cb6..58d66fe 100644
--- a/arch/x86/include/asm/traps.h
+++ b/arch/x86/include/asm/traps.h
@@ -37,6 +37,23 @@ asmlinkage void machine_check(void);
 #endif /* CONFIG_X86_MCE */
 asmlinkage void simd_coprocessor_error(void);
 
+#ifdef CONFIG_TRACING
+asmlinkage void trace_page_fault(void);
+#define trace_divide_error divide_error
+#define trace_bounds bounds
+#define trace_invalid_op invalid_op
+#define trace_device_not_available device_not_available
+#define trace_coprocessor_segment_overrun coprocessor_segment_overrun
+#define trace_invalid_TSS invalid_TSS
+#define trace_segment_not_present segment_not_present
+#define trace_general_protection general_protection
+#define trace_spurious_interrupt_bug spurious_interrupt_bug
+#define trace_coprocessor_error coprocessor_error
+#define trace_alignment_check alignment_check
+#define trace_simd_coprocessor_error simd_coprocessor_error
+#define trace_async_page_fault async_page_fault
+#endif
+
 dotraplinkage void do_divide_error(struct pt_regs *, long);
 dotraplinkage void do_debug(struct pt_regs *, long);
 dotraplinkage void do_nmi(struct pt_regs *, long);
@@ -55,6 +72,9 @@ asmlinkage __kprobes struct pt_regs *sync_regs(struct pt_regs *);
 #endif
 dotraplinkage void do_general_protection(struct pt_regs *, long);
 dotraplinkage void do_page_fault(struct pt_regs *, unsigned long);
+#ifdef CONFIG_TRACING
+dotraplinkage void trace_do_page_fault(struct pt_regs *, unsigned long);
+#endif
 dotraplinkage void do_spurious_interrupt_bug(struct pt_regs *, long);
 dotraplinkage void do_coprocessor_error(struct pt_regs *, long);
 dotraplinkage void do_alignment_check(struct pt_regs *, long);
diff --git a/arch/x86/kernel/entry_32.S b/arch/x86/kernel/entry_32.S
index f0dcb0c..0661abe 100644
--- a/arch/x86/kernel/entry_32.S
+++ b/arch/x86/kernel/entry_32.S
@@ -1247,6 +1247,16 @@ return_to_handler:
  */
 	.pushsection .kprobes.text, "ax"
 
+#ifdef CONFIG_TRACING
+ENTRY(trace_page_fault)
+	RING0_EC_FRAME
+	ASM_CLAC
+	pushl_cfi $trace_do_page_fault
+	jmp error_code
+	CFI_ENDPROC
+END(trace_page_fault)
+#endif
+
 ENTRY(page_fault)
 	RING0_EC_FRAME
 	ASM_CLAC
diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
index b077f4c..8b7b169 100644
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -1280,6 +1280,17 @@ ENTRY(\sym)
 END(\sym)
 .endm
 
+#ifdef CONFIG_TRACING
+.macro trace_errorentry sym do_sym
+errorentry trace(\sym) trace(\do_sym)
+errorentry \sym \do_sym
+.endm
+#else
+.macro trace_errorentry sym do_sym
+errorentry \sym \do_sym
+.endm
+#endif
+
 	/* error code is on the stack already */
 .macro paranoiderrorentry sym do_sym
 ENTRY(\sym)
@@ -1482,7 +1493,7 @@ zeroentry xen_int3 do_int3
 errorentry xen_stack_segment do_stack_segment
 #endif
 errorentry general_protection do_general_protection
-errorentry page_fault do_page_fault
+trace_errorentry page_fault do_page_fault
 #ifdef CONFIG_KVM_GUEST
 errorentry async_page_fault do_async_page_fault
 #endif
diff --git a/arch/x86/kernel/head64.c b/arch/x86/kernel/head64.c
index 1be8e43..85126cc 100644
--- a/arch/x86/kernel/head64.c
+++ b/arch/x86/kernel/head64.c
@@ -162,7 +162,7 @@ asmlinkage void __init x86_64_start_kernel(char * real_mode_data)
 	clear_bss();
 
 	for (i = 0; i < NUM_EXCEPTION_VECTORS; i++)
-		set_intr_gate(i, &early_idt_handlers[i]);
+		set_intr_gate(i, early_idt_handlers[i]);
 	load_idt((const struct desc_ptr *)&idt_descr);
 
 	copy_bootdata(__va(real_mode_data));
diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
index a0e2a8a..028d7a4 100644
--- a/arch/x86/kernel/kvm.c
+++ b/arch/x86/kernel/kvm.c
@@ -464,7 +464,7 @@ static struct notifier_block kvm_cpu_notifier = {
 
 static void __init kvm_apf_trap_init(void)
 {
-	set_intr_gate(14, &async_page_fault);
+	set_intr_gate(14, async_page_fault);
 }
 
 void __init kvm_guest_init(void)
diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
index 8c8093b..1c9d0ad 100644
--- a/arch/x86/kernel/traps.c
+++ b/arch/x86/kernel/traps.c
@@ -713,7 +713,7 @@ void __init early_trap_init(void)
 	/* int3 can be called from all */
 	set_system_intr_gate_ist(X86_TRAP_BP, &int3, DEBUG_STACK);
 #ifdef CONFIG_X86_32
-	set_intr_gate(X86_TRAP_PF, &page_fault);
+	set_intr_gate(X86_TRAP_PF, page_fault);
 #endif
 	load_idt(&idt_descr);
 }
@@ -721,7 +721,7 @@ void __init early_trap_init(void)
 void __init early_trap_pf_init(void)
 {
 #ifdef CONFIG_X86_64
-	set_intr_gate(X86_TRAP_PF, &page_fault);
+	set_intr_gate(X86_TRAP_PF, page_fault);
 #endif
 }
 
@@ -737,30 +737,30 @@ void __init trap_init(void)
 	early_iounmap(p, 4);
 #endif
 
-	set_intr_gate(X86_TRAP_DE, &divide_error);
+	set_intr_gate(X86_TRAP_DE, divide_error);
 	set_intr_gate_ist(X86_TRAP_NMI, &nmi, NMI_STACK);
 	/* int4 can be called from all */
 	set_system_intr_gate(X86_TRAP_OF, &overflow);
-	set_intr_gate(X86_TRAP_BR, &bounds);
-	set_intr_gate(X86_TRAP_UD, &invalid_op);
-	set_intr_gate(X86_TRAP_NM, &device_not_available);
+	set_intr_gate(X86_TRAP_BR, bounds);
+	set_intr_gate(X86_TRAP_UD, invalid_op);
+	set_intr_gate(X86_TRAP_NM, device_not_available);
 #ifdef CONFIG_X86_32
 	set_task_gate(X86_TRAP_DF, GDT_ENTRY_DOUBLEFAULT_TSS);
 #else
 	set_intr_gate_ist(X86_TRAP_DF, &double_fault, DOUBLEFAULT_STACK);
 #endif
-	set_intr_gate(X86_TRAP_OLD_MF, &coprocessor_segment_overrun);
-	set_intr_gate(X86_TRAP_TS, &invalid_TSS);
-	set_intr_gate(X86_TRAP_NP, &segment_not_present);
+	set_intr_gate(X86_TRAP_OLD_MF, coprocessor_segment_overrun);
+	set_intr_gate(X86_TRAP_TS, invalid_TSS);
+	set_intr_gate(X86_TRAP_NP, segment_not_present);
 	set_intr_gate_ist(X86_TRAP_SS, &stack_segment, STACKFAULT_STACK);
-	set_intr_gate(X86_TRAP_GP, &general_protection);
-	set_intr_gate(X86_TRAP_SPURIOUS, &spurious_interrupt_bug);
-	set_intr_gate(X86_TRAP_MF, &coprocessor_error);
-	set_intr_gate(X86_TRAP_AC, &alignment_check);
+	set_intr_gate(X86_TRAP_GP, general_protection);
+	set_intr_gate(X86_TRAP_SPURIOUS, spurious_interrupt_bug);
+	set_intr_gate(X86_TRAP_MF, coprocessor_error);
+	set_intr_gate(X86_TRAP_AC, alignment_check);
 #ifdef CONFIG_X86_MCE
 	set_intr_gate_ist(X86_TRAP_MC, &machine_check, MCE_STACK);
 #endif
-	set_intr_gate(X86_TRAP_XF, &simd_coprocessor_error);
+	set_intr_gate(X86_TRAP_XF, simd_coprocessor_error);
 
 	/* Reserve all the builtin and the syscall vector: */
 	for (i = 0; i < FIRST_EXTERNAL_VECTOR; i++)
diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
index 3aaeffc..fd3e281 100644
--- a/arch/x86/mm/fault.c
+++ b/arch/x86/mm/fault.c
@@ -1231,3 +1231,13 @@ do_page_fault(struct pt_regs *regs, unsigned long error_code)
 	__do_page_fault(regs, error_code);
 	exception_exit(prev_state);
 }
+
+dotraplinkage void __kprobes
+trace_do_page_fault(struct pt_regs *regs, unsigned long error_code)
+{
+	enum ctx_state prev_state;
+
+	prev_state = exception_enter();
+	__do_page_fault(regs, error_code);
+	exception_exit(prev_state);
+}
-- 
1.8.3.1


