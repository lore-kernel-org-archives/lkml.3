Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754621Ab3HWPjh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 11:39:37 -0400
Received: from usindpps04.hds.com ([207.126.252.17]:57608 "EHLO
	usindpps04.hds.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753869Ab3HWPjf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 11:39:35 -0400
Message-ID: <521781C7.3050906@hds.com>
Date: Fri, 23 Aug 2013 11:37:43 -0400
From: Seiji Aguchi <seiji.aguchi@hds.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, x86@kernel.org
CC: hpa@zytor.com, rostedt@goodmis.org, mingo@elte.hu, bp@alien8.de,
        tglx@linutronix.de, fdeslaur@gmail.com, raphael.beamonte@gmail.com,
        dle-develop@lists.sourceforge.net, tomoki.sekiyama@hds.com
Subject: [PATCH v2] Introduce page fault tracepoint
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 mx ip4:207.126.244.0/26 ip4:207.126.252.0/25 include:mktomail.com
 include:cloud.hds.com ~all
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.10.8794,1.0.431,0.0.0000
 definitions=2013-08-23_04:2013-08-23,2013-08-23,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=outbound_policy score=0 spamscore=0 suspectscore=4
 phishscore=0 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=7.0.1-1305240000 definitions=main-1308230049
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change from v1
 - Print regs->ip instead of regs to know where the page fault event happened
   (Suggested by Steven Rostedt)


This patch introduces page fault tracepoints to x86 architecture
by switching IDT.

[Use case of page fault events]

  Two events, for user and kernel spaces, are introduced at the beginning of
  page fault handler.

  - User space event
    There is a request of page fault event for user space as below.

    http://marc.info/?l=linux-mm&m=136807959830182&w=2
    http://marc.info/?l=linux-mm&m=136807959130175&w=2

  - Kernel space event:
    Overhead in kernel space is measurable by enabling it.

[Creating IDT]

 A way to create IDT is as below.

 - Introduce set_intr_gate_raw() to register just non-trace handler to IDT.
   This is used at boot time which tracing is disabled.
 - Make set_intr_gate() macro so that it can register trace handler to
   trace IDT and non-trace handler to normal IDT.

Signed-off-by: Seiji Aguchi <seiji.aguchi@hds.com>
---
 arch/x86/include/asm/desc.h             | 33 +++++++++++++++++----
 arch/x86/include/asm/hw_irq.h           | 14 ++++++++-
 arch/x86/include/asm/trace/exceptions.h | 51 +++++++++++++++++++++++++++++++++
 arch/x86/include/asm/traps.h            | 22 ++++++++++++++
 arch/x86/kernel/entry_32.S              | 10 +++++++
 arch/x86/kernel/entry_64.S              | 13 ++++++++-
 arch/x86/kernel/head64.c                |  2 +-
 arch/x86/kernel/irqinit.c               |  2 +-
 arch/x86/kernel/kvm.c                   |  2 +-
 arch/x86/kernel/traps.c                 | 28 +++++++++---------
 arch/x86/mm/Makefile                    |  2 ++
 arch/x86/mm/fault.c                     | 22 ++++++++++++++
 12 files changed, 177 insertions(+), 24 deletions(-)
 create mode 100644 arch/x86/include/asm/trace/exceptions.h

diff --git a/arch/x86/include/asm/desc.h b/arch/x86/include/asm/desc.h
index b90e5df..c04302b 100644
--- a/arch/x86/include/asm/desc.h
+++ b/arch/x86/include/asm/desc.h
@@ -327,10 +327,28 @@ static inline void write_trace_idt_entry(int entry, const gate_desc *gate)
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
+static inline void _trace_set_gate(int gate, unsigned type, void *addr,
+				   unsigned dpl, unsigned ist, unsigned seg)
+{
+}
 #endif
 
 static inline void _set_gate(int gate, unsigned type, void *addr,
@@ -353,12 +371,20 @@ static inline void _set_gate(int gate, unsigned type, void *addr,
  * Pentium F0 0F bugfix can have resulted in the mapped
  * IDT being write-protected.
  */
-static inline void set_intr_gate(unsigned int n, void *addr)
+static inline void set_intr_gate_raw(unsigned int n, void *addr)
 {
 	BUG_ON((unsigned)n > 0xFF);
 	_set_gate(n, GATE_INTERRUPT, addr, 0, 0, __KERNEL_CS);
 }
 
+#define set_intr_gate(n, addr)						\
+	do {								\
+		BUG_ON((unsigned)n > 0xFF);				\
+		_set_gate(n, GATE_INTERRUPT, addr, 0, 0, __KERNEL_CS);	\
+		_trace_set_gate(n, GATE_INTERRUPT, trace_##addr, 0, 0,	\
+				__KERNEL_CS);				\
+	} while (0)
+
 extern int first_system_vector;
 /* used_vectors is BITMAP for irq is not managed by percpu vector_irq */
 extern unsigned long used_vectors[];
@@ -395,10 +421,7 @@ static inline void trace_set_intr_gate(unsigned int gate, void *addr)
 #define __trace_alloc_intr_gate(n, addr)
 #endif
 
-static inline void __alloc_intr_gate(unsigned int n, void *addr)
-{
-	set_intr_gate(n, addr);
-}
+#define __alloc_intr_gate(n, addr) set_intr_gate(n, addr)
 
 #define alloc_intr_gate(n, addr)				\
 	do {							\
diff --git a/arch/x86/include/asm/hw_irq.h b/arch/x86/include/asm/hw_irq.h
index e4ac559..fbd73b7 100644
--- a/arch/x86/include/asm/hw_irq.h
+++ b/arch/x86/include/asm/hw_irq.h
@@ -89,10 +89,22 @@ extern void trace_reschedule_interrupt(void);
 extern void trace_threshold_interrupt(void);
 extern void trace_call_function_interrupt(void);
 extern void trace_call_function_single_interrupt(void);
+#else /* CONFIG_TRACING */
+#define trace_apic_timer_interrupt apic_timer_interrupt
+#define trace_x86_platform_ipi x86_platform_ipi
+#define trace_error_interrupt error_interrupt
+#define trace_irq_work_interrupt irq_work_interrupt
+#define trace_spurious_interrupt spurious_interrupt
+#define trace_thermal_interrupt thermal_interrupt
+#define trace_reschedule_interrupt reschedule_interrupt
+#define trace_threshold_interrupt threshold_interrupt
+#define trace_call_function_interrupt call_function_interrupt
+#define trace_call_function_single_interrupt call_function_single_interrupt
+#endif
+
 #define trace_irq_move_cleanup_interrupt  irq_move_cleanup_interrupt
 #define trace_reboot_interrupt  reboot_interrupt
 #define trace_kvm_posted_intr_ipi kvm_posted_intr_ipi
-#endif /* CONFIG_TRACING */
 
 /* IOAPIC */
 #define IO_APIC_IRQ(x) (((x) >= NR_IRQS_LEGACY) || ((1<<(x)) & io_apic_irqs))
diff --git a/arch/x86/include/asm/trace/exceptions.h b/arch/x86/include/asm/trace/exceptions.h
new file mode 100644
index 0000000..a379a49
--- /dev/null
+++ b/arch/x86/include/asm/trace/exceptions.h
@@ -0,0 +1,51 @@
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
+		__field(		struct pt_regs *, regs	)
+		__field(		unsigned long, error_code )
+	),
+
+	TP_fast_assign(
+		__entry->address = address;
+		__entry->regs = regs;
+		__entry->error_code = error_code;
+	),
+
+	TP_printk("address=0x%lx ip=0x%lx error_code=0x%lx",
+		  __entry->address, __entry->regs->ip, __entry->error_code) );
+
+#define DEFINE_PAGE_FAULT_EVENT(name)				\
+DEFINE_EVENT_FN(x86_exceptions, name,				\
+	TP_PROTO(unsigned long address,	struct pt_regs *regs,	\
+		 unsigned long error_code),			\
+	TP_ARGS(address, regs, error_code),			\
+	trace_irq_vector_regfunc,				\
+	trace_irq_vector_unregfunc);
+
+DEFINE_PAGE_FAULT_EVENT(user_page_fault);
+DEFINE_PAGE_FAULT_EVENT(kernel_page_fault);
+
+#undef TRACE_INCLUDE_PATH
+#define TRACE_INCLUDE_PATH .
+#define TRACE_INCLUDE_FILE exceptions
+#endif /*  _TRACE_PAGE_FAULT_H */
+
+/* This part must be outside protection */
+#include <trace/define_trace.h>
diff --git a/arch/x86/include/asm/traps.h b/arch/x86/include/asm/traps.h
index 88eae2a..adf9258 100644
--- a/arch/x86/include/asm/traps.h
+++ b/arch/x86/include/asm/traps.h
@@ -41,6 +41,25 @@ asmlinkage void machine_check(void);
 #endif /* CONFIG_X86_MCE */
 asmlinkage void simd_coprocessor_error(void);
 
+#ifdef CONFIG_TRACING
+asmlinkage void trace_page_fault(void);
+#else
+#define trace_page_fault page_fault
+#endif
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
+
 dotraplinkage void do_divide_error(struct pt_regs *, long);
 dotraplinkage void do_debug(struct pt_regs *, long);
 dotraplinkage void do_nmi(struct pt_regs *, long);
@@ -59,6 +78,9 @@ asmlinkage __kprobes struct pt_regs *sync_regs(struct pt_regs *);
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
index 2cfbc3a..c9eb4e2 100644
--- a/arch/x86/kernel/entry_32.S
+++ b/arch/x86/kernel/entry_32.S
@@ -1244,6 +1244,16 @@ return_to_handler:
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
index 1b69951..5136404 100644
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -1295,6 +1295,17 @@ ENTRY(\sym)
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
@@ -1497,7 +1508,7 @@ zeroentry xen_int3 do_int3
 errorentry xen_stack_segment do_stack_segment
 #endif
 errorentry general_protection do_general_protection
-errorentry page_fault do_page_fault
+trace_errorentry page_fault do_page_fault
 #ifdef CONFIG_KVM_GUEST
 errorentry async_page_fault do_async_page_fault
 #endif
diff --git a/arch/x86/kernel/head64.c b/arch/x86/kernel/head64.c
index 55b6761..67a0649 100644
--- a/arch/x86/kernel/head64.c
+++ b/arch/x86/kernel/head64.c
@@ -162,7 +162,7 @@ void __init x86_64_start_kernel(char * real_mode_data)
 	clear_bss();
 
 	for (i = 0; i < NUM_EXCEPTION_VECTORS; i++)
-		set_intr_gate(i, &early_idt_handlers[i]);
+		set_intr_gate_raw(i, &early_idt_handlers[i]);
 	load_idt((const struct desc_ptr *)&idt_descr);
 
 	copy_bootdata(__va(real_mode_data));
diff --git a/arch/x86/kernel/irqinit.c b/arch/x86/kernel/irqinit.c
index a2a1fbc..2ca2354 100644
--- a/arch/x86/kernel/irqinit.c
+++ b/arch/x86/kernel/irqinit.c
@@ -206,7 +206,7 @@ void __init native_init_IRQ(void)
 	i = FIRST_EXTERNAL_VECTOR;
 	for_each_clear_bit_from(i, used_vectors, NR_VECTORS) {
 		/* IA32_SYSCALL_VECTOR could be used in trap_init already. */
-		set_intr_gate(i, interrupt[i - FIRST_EXTERNAL_VECTOR]);
+		set_intr_gate_raw(i, interrupt[i - FIRST_EXTERNAL_VECTOR]);
 	}
 
 	if (!acpi_ioapic && !of_ioapic)
diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
index a96d32c..12b384e 100644
--- a/arch/x86/kernel/kvm.c
+++ b/arch/x86/kernel/kvm.c
@@ -462,7 +462,7 @@ static struct notifier_block kvm_cpu_notifier = {
 
 static void __init kvm_apf_trap_init(void)
 {
-	set_intr_gate(14, &async_page_fault);
+	set_intr_gate(14, async_page_fault);
 }
 
 void __init kvm_guest_init(void)
diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
index 1b23a1c..eadd251 100644
--- a/arch/x86/kernel/traps.c
+++ b/arch/x86/kernel/traps.c
@@ -709,7 +709,7 @@ void __init early_trap_init(void)
 	/* int3 can be called from all */
 	set_system_intr_gate_ist(X86_TRAP_BP, &int3, DEBUG_STACK);
 #ifdef CONFIG_X86_32
-	set_intr_gate(X86_TRAP_PF, &page_fault);
+	set_intr_gate(X86_TRAP_PF, page_fault);
 #endif
 	load_idt(&idt_descr);
 }
@@ -717,7 +717,7 @@ void __init early_trap_init(void)
 void __init early_trap_pf_init(void)
 {
 #ifdef CONFIG_X86_64
-	set_intr_gate(X86_TRAP_PF, &page_fault);
+	set_intr_gate(X86_TRAP_PF, page_fault);
 #endif
 }
 
@@ -733,30 +733,30 @@ void __init trap_init(void)
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
index 654be4a..f515154 100644
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
@@ -1230,3 +1233,22 @@ do_page_fault(struct pt_regs *regs, unsigned long error_code)
 	__do_page_fault(regs, error_code);
 	exception_exit(prev_state);
 }
+
+static void trace_page_fault_entries(struct pt_regs *regs,
+				     unsigned long error_code)
+{
+	if (user_mode(regs))
+		trace_user_page_fault(read_cr2(), regs, error_code);
+	else
+		trace_kernel_page_fault(read_cr2(), regs, error_code);
+}
+
+dotraplinkage void __kprobes
+trace_do_page_fault(struct pt_regs *regs, unsigned long error_code)
+{
+	enum ctx_state prev_state;
+	prev_state = exception_enter();
+	trace_page_fault_entries(regs, error_code);
+	__do_page_fault(regs, error_code);
+	exception_exit(prev_state);
+}
-- 
1.8.2.1

