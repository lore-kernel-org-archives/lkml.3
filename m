Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756594Ab3KLUNV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 15:13:21 -0500
Received: from mail-ee0-f53.google.com ([74.125.83.53]:39682 "EHLO
	mail-ee0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755290Ab3KLUNO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 15:13:14 -0500
Date: Tue, 12 Nov 2013 21:13:10 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86/trace changes for v3.13
Message-ID: <20131112201310.GA25576@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-trace-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86-trace-for-linus

   # HEAD: a4f61dec55c1bdebb84ba77212ebf98f7247736c x86, trace: Change user|kernel_page_fault to page_fault_user|kernel

This adds page fault tracepoints which have zero runtime cost in the 
disabled case via IDT trickery. (no NOPs in the page fault hotpath)

 Thanks,

	Ingo

------------------>
H. Peter Anvin (1):
      x86, trace: Change user|kernel_page_fault to page_fault_user|kernel

Seiji Aguchi (4):
      x86, trace: Remove __alloc_intr_gate()
      x86, trace: Register exception handler to trace IDT
      x86, trace: Delete __trace_alloc_intr_gate()
      x86, trace: Add page fault tracepoints


 arch/x86/include/asm/desc.h             | 57 ++++++++++++++-------------------
 arch/x86/include/asm/hw_irq.h           |  3 ++
 arch/x86/include/asm/segment.h          |  3 ++
 arch/x86/include/asm/trace/exceptions.h | 52 ++++++++++++++++++++++++++++++
 arch/x86/include/asm/traps.h            | 20 ++++++++++++
 arch/x86/kernel/entry_32.S              | 10 ++++++
 arch/x86/kernel/entry_64.S              | 13 +++++++-
 arch/x86/kernel/head64.c                |  2 +-
 arch/x86/kernel/kvm.c                   |  2 +-
 arch/x86/kernel/traps.c                 | 28 ++++++++--------
 arch/x86/mm/Makefile                    |  2 ++
 arch/x86/mm/fault.c                     | 23 +++++++++++++
 12 files changed, 165 insertions(+), 50 deletions(-)
 create mode 100644 arch/x86/include/asm/trace/exceptions.h

diff --git a/arch/x86/include/asm/desc.h b/arch/x86/include/asm/desc.h
index b90e5df..50d033a 100644
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
@@ -374,37 +392,10 @@ static inline void alloc_system_vector(int vector)
 	}
 }
 
-#ifdef CONFIG_TRACING
-static inline void trace_set_intr_gate(unsigned int gate, void *addr)
-{
-	gate_desc s;
-
-	pack_gate(&s, GATE_INTERRUPT, (unsigned long)addr, 0, 0, __KERNEL_CS);
-	write_idt_entry(trace_idt_table, gate, &s);
-}
-
-static inline void __trace_alloc_intr_gate(unsigned int n, void *addr)
-{
-	trace_set_intr_gate(n, addr);
-}
-#else
-static inline void trace_set_intr_gate(unsigned int gate, void *addr)
-{
-}
-
-#define __trace_alloc_intr_gate(n, addr)
-#endif
-
-static inline void __alloc_intr_gate(unsigned int n, void *addr)
-{
-	set_intr_gate(n, addr);
-}
-
 #define alloc_intr_gate(n, addr)				\
 	do {							\
 		alloc_system_vector(n);				\
-		__alloc_intr_gate(n, addr);			\
-		__trace_alloc_intr_gate(n, trace_##addr);	\
+		set_intr_gate(n, addr);				\
 	} while (0)
 
 /*
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
diff --git a/arch/x86/include/asm/trace/exceptions.h b/arch/x86/include/asm/trace/exceptions.h
new file mode 100644
index 0000000..2fbc66c
--- /dev/null
+++ b/arch/x86/include/asm/trace/exceptions.h
@@ -0,0 +1,52 @@
+#undef TRACE_SYSTEM
+#define TRACE_SYSTEM exceptions
+
+#if !defined(_TRACE_PAGE_FAULT_H) || defined(TRACE_HEADER_MULTI_READ)
+#define _TRACE_PAGE_FAULT_H
+
+#include <linux/tracepoint.h>
+
+extern void trace_irq_vector_regfunc(void);
+extern void trace_irq_vector_unregfunc(void);
+
+DECLARE_EVENT_CLASS(x86_exceptions,
+
+	TP_PROTO(unsigned long address, struct pt_regs *regs,
+		 unsigned long error_code),
+
+	TP_ARGS(address, regs, error_code),
+
+	TP_STRUCT__entry(
+		__field(		unsigned long, address	)
+		__field(		unsigned long, ip	)
+		__field(		unsigned long, error_code )
+	),
+
+	TP_fast_assign(
+		__entry->address = address;
+		__entry->ip = regs->ip;
+		__entry->error_code = error_code;
+	),
+
+	TP_printk("address=%pf ip=%pf error_code=0x%lx",
+		  (void *)__entry->address, (void *)__entry->ip,
+		  __entry->error_code) );
+
+#define DEFINE_PAGE_FAULT_EVENT(name)				\
+DEFINE_EVENT_FN(x86_exceptions, name,				\
+	TP_PROTO(unsigned long address,	struct pt_regs *regs,	\
+		 unsigned long error_code),			\
+	TP_ARGS(address, regs, error_code),			\
+	trace_irq_vector_regfunc,				\
+	trace_irq_vector_unregfunc);
+
+DEFINE_PAGE_FAULT_EVENT(page_fault_user);
+DEFINE_PAGE_FAULT_EVENT(page_fault_kernel);
+
+#undef TRACE_INCLUDE_PATH
+#define TRACE_INCLUDE_PATH .
+#define TRACE_INCLUDE_FILE exceptions
+#endif /*  _TRACE_PAGE_FAULT_H */
+
+/* This part must be outside protection */
+#include <trace/define_trace.h>
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
index b2046e4..6dd802c 100644
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
diff --git a/arch/x86/mm/Makefile b/arch/x86/mm/Makefile
index 23d8e5f..6a19ad9 100644
--- a/arch/x86/mm/Makefile
+++ b/arch/x86/mm/Makefile
@@ -6,6 +6,8 @@ nostackp := $(call cc-option, -fno-stack-protector)
 CFLAGS_physaddr.o		:= $(nostackp)
 CFLAGS_setup_nx.o		:= $(nostackp)
 
+CFLAGS_fault.o := -I$(src)/../include/asm/trace
+
 obj-$(CONFIG_X86_PAT)		+= pat_rbtree.o
 obj-$(CONFIG_SMP)		+= tlb.o
 
diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
index 3aaeffc..e532230 100644
--- a/arch/x86/mm/fault.c
+++ b/arch/x86/mm/fault.c
@@ -20,6 +20,9 @@
 #include <asm/kmemcheck.h>		/* kmemcheck_*(), ...		*/
 #include <asm/fixmap.h>			/* VSYSCALL_START		*/
 
+#define CREATE_TRACE_POINTS
+#include <asm/trace/exceptions.h>
+
 /*
  * Page fault error code bits:
  *
@@ -1231,3 +1234,23 @@ do_page_fault(struct pt_regs *regs, unsigned long error_code)
 	__do_page_fault(regs, error_code);
 	exception_exit(prev_state);
 }
+
+static void trace_page_fault_entries(struct pt_regs *regs,
+				     unsigned long error_code)
+{
+	if (user_mode(regs))
+		trace_page_fault_user(read_cr2(), regs, error_code);
+	else
+		trace_page_fault_kernel(read_cr2(), regs, error_code);
+}
+
+dotraplinkage void __kprobes
+trace_do_page_fault(struct pt_regs *regs, unsigned long error_code)
+{
+	enum ctx_state prev_state;
+
+	prev_state = exception_enter();
+	trace_page_fault_entries(regs, error_code);
+	__do_page_fault(regs, error_code);
+	exception_exit(prev_state);
+}
