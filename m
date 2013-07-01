Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753833Ab3GAKwY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 06:52:24 -0400
Received: from mail-ee0-f54.google.com ([74.125.83.54]:57307 "EHLO
	mail-ee0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752098Ab3GAKwT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 06:52:19 -0400
Date: Mon, 1 Jul 2013 12:52:15 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: [GIT PULL] x86/tracing changes for v3.11
Message-ID: <20130701105214.GA18934@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-tracing-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86-tracing-for-linus

   HEAD: 5236eb968ec21c693d463d0494e39b00c1bc174d Merge remote-tracking branch 'trace/tip/x86/trace' into x86/trace

This tree adds IRQ vector tracepoints that are named after the handler and 
which output the vector #, based on a zero-overhead approach that relies 
on changing the IDT entries, by Seiji Aguchi.

The new tracepoints look like this:

 # perf list | grep -i irq_vector
  irq_vectors:local_timer_entry                      [Tracepoint event]
  irq_vectors:local_timer_exit                       [Tracepoint event]
  irq_vectors:reschedule_entry                       [Tracepoint event]
  irq_vectors:reschedule_exit                        [Tracepoint event]
  irq_vectors:spurious_apic_entry                    [Tracepoint event]
  irq_vectors:spurious_apic_exit                     [Tracepoint event]
  irq_vectors:error_apic_entry                       [Tracepoint event]
  irq_vectors:error_apic_exit                        [Tracepoint event]
 [...]


out-of-topic modifications in x86-tracing-for-linus:
----------------------------------------------------
include/linux/tracepoint.h         # f5abaa1: tracing: Add DEFINE_EVENT_FN() ma
include/trace/define_trace.h       # f5abaa1: tracing: Add DEFINE_EVENT_FN() ma
include/trace/ftrace.h             # f5abaa1: tracing: Add DEFINE_EVENT_FN() ma

 Thanks,

	Ingo

------------------>
Seiji Aguchi (4):
      x86, trace: Introduce entering/exiting_irq()
      x86: Rename variables for debugging
      x86, trace: Add irq vector tracepoints
      x86/tracing: Add config option checking to the definitions of mce handlers

Steven Rostedt (1):
      tracing: Add DEFINE_EVENT_FN() macro

Steven Rostedt (Red Hat) (2):
      trace,x86: Move creation of irq tracepoints from apic.c to irq.c
      trace,x86: Do not call local_irq_save() in load_current_idt()


 arch/x86/include/asm/apic.h              |  27 +++++++
 arch/x86/include/asm/desc.h              | 117 +++++++++++++++++++++++++++++--
 arch/x86/include/asm/entry_arch.h        |   8 ++-
 arch/x86/include/asm/hw_irq.h            |  17 +++++
 arch/x86/include/asm/mshyperv.h          |   3 +
 arch/x86/include/asm/trace/irq_vectors.h | 104 +++++++++++++++++++++++++++
 arch/x86/include/asm/uv/uv_bau.h         |   3 +
 arch/x86/kernel/Makefile                 |   3 +
 arch/x86/kernel/apic/apic.c              |  69 ++++++++++++++----
 arch/x86/kernel/cpu/common.c             |  20 +++---
 arch/x86/kernel/cpu/mcheck/therm_throt.c |  24 +++++--
 arch/x86/kernel/cpu/mcheck/threshold.c   |  24 +++++--
 arch/x86/kernel/entry_32.S               |  12 +++-
 arch/x86/kernel/entry_64.S               |  36 ++++++++--
 arch/x86/kernel/head_64.S                |   8 ++-
 arch/x86/kernel/irq.c                    |  33 ++++++---
 arch/x86/kernel/irq_work.c               |  24 ++++++-
 arch/x86/kernel/smp.c                    |  65 ++++++++++++++---
 arch/x86/kernel/tracepoint.c             |  61 ++++++++++++++++
 arch/x86/kernel/traps.c                  |   2 +-
 include/linux/tracepoint.h               |   2 +
 include/trace/define_trace.h             |   5 ++
 include/trace/ftrace.h                   |   4 ++
 include/xen/events.h                     |   3 +
 24 files changed, 602 insertions(+), 72 deletions(-)
 create mode 100644 arch/x86/include/asm/trace/irq_vectors.h
 create mode 100644 arch/x86/kernel/tracepoint.c

diff --git a/arch/x86/include/asm/apic.h b/arch/x86/include/asm/apic.h
index 3388034..f8119b5 100644
--- a/arch/x86/include/asm/apic.h
+++ b/arch/x86/include/asm/apic.h
@@ -12,6 +12,7 @@
 #include <asm/fixmap.h>
 #include <asm/mpspec.h>
 #include <asm/msr.h>
+#include <asm/idle.h>
 
 #define ARCH_APICTIMER_STOPS_ON_C3	1
 
@@ -687,5 +688,31 @@ extern int default_check_phys_apicid_present(int phys_apicid);
 #endif
 
 #endif /* CONFIG_X86_LOCAL_APIC */
+extern void irq_enter(void);
+extern void irq_exit(void);
+
+static inline void entering_irq(void)
+{
+	irq_enter();
+	exit_idle();
+}
+
+static inline void entering_ack_irq(void)
+{
+	ack_APIC_irq();
+	entering_irq();
+}
+
+static inline void exiting_irq(void)
+{
+	irq_exit();
+}
+
+static inline void exiting_ack_irq(void)
+{
+	irq_exit();
+	/* Ack only at the end to avoid potential reentry */
+	ack_APIC_irq();
+}
 
 #endif /* _ASM_X86_APIC_H */
diff --git a/arch/x86/include/asm/desc.h b/arch/x86/include/asm/desc.h
index 8bf1c06..b90e5df 100644
--- a/arch/x86/include/asm/desc.h
+++ b/arch/x86/include/asm/desc.h
@@ -36,8 +36,8 @@ static inline void fill_ldt(struct desc_struct *desc, const struct user_desc *in
 
 extern struct desc_ptr idt_descr;
 extern gate_desc idt_table[];
-extern struct desc_ptr nmi_idt_descr;
-extern gate_desc nmi_idt_table[];
+extern struct desc_ptr debug_idt_descr;
+extern gate_desc debug_idt_table[];
 
 struct gdt_page {
 	struct desc_struct gdt[GDT_ENTRIES];
@@ -316,7 +316,20 @@ static inline void set_nmi_gate(int gate, void *addr)
 	gate_desc s;
 
 	pack_gate(&s, GATE_INTERRUPT, (unsigned long)addr, 0, 0, __KERNEL_CS);
-	write_idt_entry(nmi_idt_table, gate, &s);
+	write_idt_entry(debug_idt_table, gate, &s);
+}
+#endif
+
+#ifdef CONFIG_TRACING
+extern struct desc_ptr trace_idt_descr;
+extern gate_desc trace_idt_table[];
+static inline void write_trace_idt_entry(int entry, const gate_desc *gate)
+{
+	write_idt_entry(trace_idt_table, entry, gate);
+}
+#else
+static inline void write_trace_idt_entry(int entry, const gate_desc *gate)
+{
 }
 #endif
 
@@ -331,6 +344,7 @@ static inline void _set_gate(int gate, unsigned type, void *addr,
 	 * setup time
 	 */
 	write_idt_entry(idt_table, gate, &s);
+	write_trace_idt_entry(gate, &s);
 }
 
 /*
@@ -360,12 +374,39 @@ static inline void alloc_system_vector(int vector)
 	}
 }
 
-static inline void alloc_intr_gate(unsigned int n, void *addr)
+#ifdef CONFIG_TRACING
+static inline void trace_set_intr_gate(unsigned int gate, void *addr)
+{
+	gate_desc s;
+
+	pack_gate(&s, GATE_INTERRUPT, (unsigned long)addr, 0, 0, __KERNEL_CS);
+	write_idt_entry(trace_idt_table, gate, &s);
+}
+
+static inline void __trace_alloc_intr_gate(unsigned int n, void *addr)
+{
+	trace_set_intr_gate(n, addr);
+}
+#else
+static inline void trace_set_intr_gate(unsigned int gate, void *addr)
+{
+}
+
+#define __trace_alloc_intr_gate(n, addr)
+#endif
+
+static inline void __alloc_intr_gate(unsigned int n, void *addr)
 {
-	alloc_system_vector(n);
 	set_intr_gate(n, addr);
 }
 
+#define alloc_intr_gate(n, addr)				\
+	do {							\
+		alloc_system_vector(n);				\
+		__alloc_intr_gate(n, addr);			\
+		__trace_alloc_intr_gate(n, trace_##addr);	\
+	} while (0)
+
 /*
  * This routine sets up an interrupt gate at directory privilege level 3.
  */
@@ -405,4 +446,70 @@ static inline void set_system_intr_gate_ist(int n, void *addr, unsigned ist)
 	_set_gate(n, GATE_INTERRUPT, addr, 0x3, ist, __KERNEL_CS);
 }
 
+#ifdef CONFIG_X86_64
+DECLARE_PER_CPU(u32, debug_idt_ctr);
+static inline bool is_debug_idt_enabled(void)
+{
+	if (this_cpu_read(debug_idt_ctr))
+		return true;
+
+	return false;
+}
+
+static inline void load_debug_idt(void)
+{
+	load_idt((const struct desc_ptr *)&debug_idt_descr);
+}
+#else
+static inline bool is_debug_idt_enabled(void)
+{
+	return false;
+}
+
+static inline void load_debug_idt(void)
+{
+}
+#endif
+
+#ifdef CONFIG_TRACING
+extern atomic_t trace_idt_ctr;
+static inline bool is_trace_idt_enabled(void)
+{
+	if (atomic_read(&trace_idt_ctr))
+		return true;
+
+	return false;
+}
+
+static inline void load_trace_idt(void)
+{
+	load_idt((const struct desc_ptr *)&trace_idt_descr);
+}
+#else
+static inline bool is_trace_idt_enabled(void)
+{
+	return false;
+}
+
+static inline void load_trace_idt(void)
+{
+}
+#endif
+
+/*
+ * The load_current_idt() must be called with interrupts disabled
+ * to avoid races. That way the IDT will always be set back to the expected
+ * descriptor. It's also called when a CPU is being initialized, and
+ * that doesn't need to disable interrupts, as nothing should be
+ * bothering the CPU then.
+ */
+static inline void load_current_idt(void)
+{
+	if (is_debug_idt_enabled())
+		load_debug_idt();
+	else if (is_trace_idt_enabled())
+		load_trace_idt();
+	else
+		load_idt((const struct desc_ptr *)&idt_descr);
+}
 #endif /* _ASM_X86_DESC_H */
diff --git a/arch/x86/include/asm/entry_arch.h b/arch/x86/include/asm/entry_arch.h
index 9bd4eca..dc5fa66 100644
--- a/arch/x86/include/asm/entry_arch.h
+++ b/arch/x86/include/asm/entry_arch.h
@@ -13,14 +13,16 @@
 BUILD_INTERRUPT(reschedule_interrupt,RESCHEDULE_VECTOR)
 BUILD_INTERRUPT(call_function_interrupt,CALL_FUNCTION_VECTOR)
 BUILD_INTERRUPT(call_function_single_interrupt,CALL_FUNCTION_SINGLE_VECTOR)
-BUILD_INTERRUPT(irq_move_cleanup_interrupt,IRQ_MOVE_CLEANUP_VECTOR)
-BUILD_INTERRUPT(reboot_interrupt,REBOOT_VECTOR)
+BUILD_INTERRUPT3(irq_move_cleanup_interrupt, IRQ_MOVE_CLEANUP_VECTOR,
+		 smp_irq_move_cleanup_interrupt)
+BUILD_INTERRUPT3(reboot_interrupt, REBOOT_VECTOR, smp_reboot_interrupt)
 #endif
 
 BUILD_INTERRUPT(x86_platform_ipi, X86_PLATFORM_IPI_VECTOR)
 
 #ifdef CONFIG_HAVE_KVM
-BUILD_INTERRUPT(kvm_posted_intr_ipi, POSTED_INTR_VECTOR)
+BUILD_INTERRUPT3(kvm_posted_intr_ipi, POSTED_INTR_VECTOR,
+		 smp_kvm_posted_intr_ipi)
 #endif
 
 /*
diff --git a/arch/x86/include/asm/hw_irq.h b/arch/x86/include/asm/hw_irq.h
index 1da97ef..e4ac559 100644
--- a/arch/x86/include/asm/hw_irq.h
+++ b/arch/x86/include/asm/hw_irq.h
@@ -77,6 +77,23 @@ extern void threshold_interrupt(void);
 extern void call_function_interrupt(void);
 extern void call_function_single_interrupt(void);
 
+#ifdef CONFIG_TRACING
+/* Interrupt handlers registered during init_IRQ */
+extern void trace_apic_timer_interrupt(void);
+extern void trace_x86_platform_ipi(void);
+extern void trace_error_interrupt(void);
+extern void trace_irq_work_interrupt(void);
+extern void trace_spurious_interrupt(void);
+extern void trace_thermal_interrupt(void);
+extern void trace_reschedule_interrupt(void);
+extern void trace_threshold_interrupt(void);
+extern void trace_call_function_interrupt(void);
+extern void trace_call_function_single_interrupt(void);
+#define trace_irq_move_cleanup_interrupt  irq_move_cleanup_interrupt
+#define trace_reboot_interrupt  reboot_interrupt
+#define trace_kvm_posted_intr_ipi kvm_posted_intr_ipi
+#endif /* CONFIG_TRACING */
+
 /* IOAPIC */
 #define IO_APIC_IRQ(x) (((x) >= NR_IRQS_LEGACY) || ((1<<(x)) & io_apic_irqs))
 extern unsigned long io_apic_irqs;
diff --git a/arch/x86/include/asm/mshyperv.h b/arch/x86/include/asm/mshyperv.h
index c2934be..cd9c419 100644
--- a/arch/x86/include/asm/mshyperv.h
+++ b/arch/x86/include/asm/mshyperv.h
@@ -12,6 +12,9 @@ struct ms_hyperv_info {
 extern struct ms_hyperv_info ms_hyperv;
 
 void hyperv_callback_vector(void);
+#ifdef CONFIG_TRACING
+#define trace_hyperv_callback_vector hyperv_callback_vector
+#endif
 void hyperv_vector_handler(struct pt_regs *regs);
 void hv_register_vmbus_handler(int irq, irq_handler_t handler);
 
diff --git a/arch/x86/include/asm/trace/irq_vectors.h b/arch/x86/include/asm/trace/irq_vectors.h
new file mode 100644
index 0000000..2874df2
--- /dev/null
+++ b/arch/x86/include/asm/trace/irq_vectors.h
@@ -0,0 +1,104 @@
+#undef TRACE_SYSTEM
+#define TRACE_SYSTEM irq_vectors
+
+#if !defined(_TRACE_IRQ_VECTORS_H) || defined(TRACE_HEADER_MULTI_READ)
+#define _TRACE_IRQ_VECTORS_H
+
+#include <linux/tracepoint.h>
+
+extern void trace_irq_vector_regfunc(void);
+extern void trace_irq_vector_unregfunc(void);
+
+DECLARE_EVENT_CLASS(x86_irq_vector,
+
+	TP_PROTO(int vector),
+
+	TP_ARGS(vector),
+
+	TP_STRUCT__entry(
+		__field(		int,	vector	)
+	),
+
+	TP_fast_assign(
+		__entry->vector = vector;
+	),
+
+	TP_printk("vector=%d", __entry->vector) );
+
+#define DEFINE_IRQ_VECTOR_EVENT(name)		\
+DEFINE_EVENT_FN(x86_irq_vector, name##_entry,	\
+	TP_PROTO(int vector),			\
+	TP_ARGS(vector),			\
+	trace_irq_vector_regfunc,		\
+	trace_irq_vector_unregfunc);		\
+DEFINE_EVENT_FN(x86_irq_vector, name##_exit,	\
+	TP_PROTO(int vector),			\
+	TP_ARGS(vector),			\
+	trace_irq_vector_regfunc,		\
+	trace_irq_vector_unregfunc);
+
+
+/*
+ * local_timer - called when entering/exiting a local timer interrupt
+ * vector handler
+ */
+DEFINE_IRQ_VECTOR_EVENT(local_timer);
+
+/*
+ * reschedule - called when entering/exiting a reschedule vector handler
+ */
+DEFINE_IRQ_VECTOR_EVENT(reschedule);
+
+/*
+ * spurious_apic - called when entering/exiting a spurious apic vector handler
+ */
+DEFINE_IRQ_VECTOR_EVENT(spurious_apic);
+
+/*
+ * error_apic - called when entering/exiting an error apic vector handler
+ */
+DEFINE_IRQ_VECTOR_EVENT(error_apic);
+
+/*
+ * x86_platform_ipi - called when entering/exiting a x86 platform ipi interrupt
+ * vector handler
+ */
+DEFINE_IRQ_VECTOR_EVENT(x86_platform_ipi);
+
+/*
+ * irq_work - called when entering/exiting a irq work interrupt
+ * vector handler
+ */
+DEFINE_IRQ_VECTOR_EVENT(irq_work);
+
+/*
+ * call_function - called when entering/exiting a call function interrupt
+ * vector handler
+ */
+DEFINE_IRQ_VECTOR_EVENT(call_function);
+
+/*
+ * call_function_single - called when entering/exiting a call function
+ * single interrupt vector handler
+ */
+DEFINE_IRQ_VECTOR_EVENT(call_function_single);
+
+/*
+ * threshold_apic - called when entering/exiting a threshold apic interrupt
+ * vector handler
+ */
+DEFINE_IRQ_VECTOR_EVENT(threshold_apic);
+
+/*
+ * thermal_apic - called when entering/exiting a thermal apic interrupt
+ * vector handler
+ */
+DEFINE_IRQ_VECTOR_EVENT(thermal_apic);
+
+#undef TRACE_INCLUDE_PATH
+#define TRACE_INCLUDE_PATH .
+#define TRACE_INCLUDE_FILE irq_vectors
+#endif /*  _TRACE_IRQ_VECTORS_H */
+
+/* This part must be outside protection */
+#include <trace/define_trace.h>
diff --git a/arch/x86/include/asm/uv/uv_bau.h b/arch/x86/include/asm/uv/uv_bau.h
index a06983c..0b46ef2 100644
--- a/arch/x86/include/asm/uv/uv_bau.h
+++ b/arch/x86/include/asm/uv/uv_bau.h
@@ -731,6 +731,9 @@ static inline void bau_cpubits_clear(struct bau_local_cpumask *dstp, int nbits)
 }
 
 extern void uv_bau_message_intr1(void);
+#ifdef CONFIG_TRACING
+#define trace_uv_bau_message_intr1 uv_bau_message_intr1
+#endif
 extern void uv_bau_timeout_intr1(void);
 
 struct atomic_short {
diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
index 7bd3bd3..44e763f 100644
--- a/arch/x86/kernel/Makefile
+++ b/arch/x86/kernel/Makefile
@@ -16,6 +16,8 @@ CFLAGS_REMOVE_ftrace.o = -pg
 CFLAGS_REMOVE_early_printk.o = -pg
 endif
 
+CFLAGS_irq.o := -I$(src)/../include/asm/trace
+
 obj-y			:= process_$(BITS).o signal.o entry_$(BITS).o
 obj-y			+= traps.o irq.o irq_$(BITS).o dumpstack_$(BITS).o
 obj-y			+= time.o ioport.o ldt.o dumpstack.o nmi.o
@@ -102,6 +104,7 @@ obj-$(CONFIG_OF)			+= devicetree.o
 obj-$(CONFIG_UPROBES)			+= uprobes.o
 
 obj-$(CONFIG_PERF_EVENTS)		+= perf_regs.o
+obj-$(CONFIG_TRACING)			+= tracepoint.o
 
 ###
 # 64 bit specific files
diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index 904611b..961676c 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -35,6 +35,7 @@
 #include <linux/smp.h>
 #include <linux/mm.h>
 
+#include <asm/trace/irq_vectors.h>
 #include <asm/irq_remapping.h>
 #include <asm/perf_event.h>
 #include <asm/x86_init.h>
@@ -919,17 +920,35 @@ void __irq_entry smp_apic_timer_interrupt(struct pt_regs *regs)
 	/*
 	 * NOTE! We'd better ACK the irq immediately,
 	 * because timer handling can be slow.
+	 *
+	 * update_process_times() expects us to have done irq_enter().
+	 * Besides, if we don't timer interrupts ignore the global
+	 * interrupt lock, which is the WrongThing (tm) to do.
 	 */
-	ack_APIC_irq();
+	entering_ack_irq();
+	local_apic_timer_interrupt();
+	exiting_irq();
+
+	set_irq_regs(old_regs);
+}
+
+void __irq_entry smp_trace_apic_timer_interrupt(struct pt_regs *regs)
+{
+	struct pt_regs *old_regs = set_irq_regs(regs);
+
 	/*
+	 * NOTE! We'd better ACK the irq immediately,
+	 * because timer handling can be slow.
+	 *
 	 * update_process_times() expects us to have done irq_enter().
 	 * Besides, if we don't timer interrupts ignore the global
 	 * interrupt lock, which is the WrongThing (tm) to do.
 	 */
-	irq_enter();
-	exit_idle();
+	entering_ack_irq();
+	trace_local_timer_entry(LOCAL_TIMER_VECTOR);
 	local_apic_timer_interrupt();
-	irq_exit();
+	trace_local_timer_exit(LOCAL_TIMER_VECTOR);
+	exiting_irq();
 
 	set_irq_regs(old_regs);
 }
@@ -1907,12 +1926,10 @@ int __init APIC_init_uniprocessor(void)
 /*
  * This interrupt should _never_ happen with our APIC/SMP architecture
  */
-void smp_spurious_interrupt(struct pt_regs *regs)
+static inline void __smp_spurious_interrupt(void)
 {
 	u32 v;
 
-	irq_enter();
-	exit_idle();
 	/*
 	 * Check if this really is a spurious interrupt and ACK it
 	 * if it is a vectored one.  Just in case...
@@ -1927,13 +1944,28 @@ void smp_spurious_interrupt(struct pt_regs *regs)
 	/* see sw-dev-man vol 3, chapter 7.4.13.5 */
 	pr_info("spurious APIC interrupt on CPU#%d, "
 		"should never happen.\n", smp_processor_id());
-	irq_exit();
+}
+
+void smp_spurious_interrupt(struct pt_regs *regs)
+{
+	entering_irq();
+	__smp_spurious_interrupt();
+	exiting_irq();
+}
+
+void smp_trace_spurious_interrupt(struct pt_regs *regs)
+{
+	entering_irq();
+	trace_spurious_apic_entry(SPURIOUS_APIC_VECTOR);
+	__smp_spurious_interrupt();
+	trace_spurious_apic_exit(SPURIOUS_APIC_VECTOR);
+	exiting_irq();
 }
 
 /*
  * This interrupt should never happen with our APIC/SMP architecture
  */
-void smp_error_interrupt(struct pt_regs *regs)
+static inline void __smp_error_interrupt(struct pt_regs *regs)
 {
 	u32 v0, v1;
 	u32 i = 0;
@@ -1948,8 +1980,6 @@ void smp_error_interrupt(struct pt_regs *regs)
 		"Illegal register address",	/* APIC Error Bit 7 */
 	};
 
-	irq_enter();
-	exit_idle();
 	/* First tickle the hardware, only then report what went on. -- REW */
 	v0 = apic_read(APIC_ESR);
 	apic_write(APIC_ESR, 0);
@@ -1970,7 +2000,22 @@ void smp_error_interrupt(struct pt_regs *regs)
 
 	apic_printk(APIC_DEBUG, KERN_CONT "\n");
 
-	irq_exit();
+}
+
+void smp_error_interrupt(struct pt_regs *regs)
+{
+	entering_irq();
+	__smp_error_interrupt(regs);
+	exiting_irq();
+}
+
+void smp_trace_error_interrupt(struct pt_regs *regs)
+{
+	entering_irq();
+	trace_error_apic_entry(ERROR_APIC_VECTOR);
+	__smp_error_interrupt(regs);
+	trace_error_apic_exit(ERROR_APIC_VECTOR);
+	exiting_irq();
 }
 
 /**
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index 22018f7..d9c8c09 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -1071,8 +1071,8 @@ __setup("clearcpuid=", setup_disablecpuid);
 
 #ifdef CONFIG_X86_64
 struct desc_ptr idt_descr = { NR_VECTORS * 16 - 1, (unsigned long) idt_table };
-struct desc_ptr nmi_idt_descr = { NR_VECTORS * 16 - 1,
-				    (unsigned long) nmi_idt_table };
+struct desc_ptr debug_idt_descr = { NR_VECTORS * 16 - 1,
+				    (unsigned long) debug_idt_table };
 
 DEFINE_PER_CPU_FIRST(union irq_stack_union,
 		     irq_stack_union) __aligned(PAGE_SIZE);
@@ -1148,20 +1148,20 @@ int is_debug_stack(unsigned long addr)
 		 addr > (__get_cpu_var(debug_stack_addr) - DEBUG_STKSZ));
 }
 
-static DEFINE_PER_CPU(u32, debug_stack_use_ctr);
+DEFINE_PER_CPU(u32, debug_idt_ctr);
 
 void debug_stack_set_zero(void)
 {
-	this_cpu_inc(debug_stack_use_ctr);
-	load_idt((const struct desc_ptr *)&nmi_idt_descr);
+	this_cpu_inc(debug_idt_ctr);
+	load_current_idt();
 }
 
 void debug_stack_reset(void)
 {
-	if (WARN_ON(!this_cpu_read(debug_stack_use_ctr)))
+	if (WARN_ON(!this_cpu_read(debug_idt_ctr)))
 		return;
-	if (this_cpu_dec_return(debug_stack_use_ctr) == 0)
-		load_idt((const struct desc_ptr *)&idt_descr);
+	if (this_cpu_dec_return(debug_idt_ctr) == 0)
+		load_current_idt();
 }
 
 #else	/* CONFIG_X86_64 */
@@ -1257,7 +1257,7 @@ void __cpuinit cpu_init(void)
 	switch_to_new_gdt(cpu);
 	loadsegment(fs, 0);
 
-	load_idt((const struct desc_ptr *)&idt_descr);
+	load_current_idt();
 
 	memset(me->thread.tls_array, 0, GDT_ENTRY_TLS_ENTRIES * 8);
 	syscall_init();
@@ -1334,7 +1334,7 @@ void __cpuinit cpu_init(void)
 	if (cpu_has_vme || cpu_has_tsc || cpu_has_de)
 		clear_in_cr4(X86_CR4_VME|X86_CR4_PVI|X86_CR4_TSD|X86_CR4_DE);
 
-	load_idt(&idt_descr);
+	load_current_idt();
 	switch_to_new_gdt(cpu);
 
 	/*
diff --git a/arch/x86/kernel/cpu/mcheck/therm_throt.c b/arch/x86/kernel/cpu/mcheck/therm_throt.c
index 47a1870..2f3a799 100644
--- a/arch/x86/kernel/cpu/mcheck/therm_throt.c
+++ b/arch/x86/kernel/cpu/mcheck/therm_throt.c
@@ -29,6 +29,7 @@
 #include <asm/idle.h>
 #include <asm/mce.h>
 #include <asm/msr.h>
+#include <asm/trace/irq_vectors.h>
 
 /* How long to wait between reporting thermal events */
 #define CHECK_INTERVAL		(300 * HZ)
@@ -378,15 +379,26 @@ static void unexpected_thermal_interrupt(void)
 
 static void (*smp_thermal_vector)(void) = unexpected_thermal_interrupt;
 
-asmlinkage void smp_thermal_interrupt(struct pt_regs *regs)
+static inline void __smp_thermal_interrupt(void)
 {
-	irq_enter();
-	exit_idle();
 	inc_irq_stat(irq_thermal_count);
 	smp_thermal_vector();
-	irq_exit();
-	/* Ack only at the end to avoid potential reentry */
-	ack_APIC_irq();
+}
+
+asmlinkage void smp_thermal_interrupt(struct pt_regs *regs)
+{
+	entering_irq();
+	__smp_thermal_interrupt();
+	exiting_ack_irq();
+}
+
+asmlinkage void smp_trace_thermal_interrupt(struct pt_regs *regs)
+{
+	entering_irq();
+	trace_thermal_apic_entry(THERMAL_APIC_VECTOR);
+	__smp_thermal_interrupt();
+	trace_thermal_apic_exit(THERMAL_APIC_VECTOR);
+	exiting_ack_irq();
 }
 
 /* Thermal monitoring depends on APIC, ACPI and clock modulation */
diff --git a/arch/x86/kernel/cpu/mcheck/threshold.c b/arch/x86/kernel/cpu/mcheck/threshold.c
index aa578ca..fe6b1c8 100644
--- a/arch/x86/kernel/cpu/mcheck/threshold.c
+++ b/arch/x86/kernel/cpu/mcheck/threshold.c
@@ -8,6 +8,7 @@
 #include <asm/apic.h>
 #include <asm/idle.h>
 #include <asm/mce.h>
+#include <asm/trace/irq_vectors.h>
 
 static void default_threshold_interrupt(void)
 {
@@ -17,13 +18,24 @@ static void default_threshold_interrupt(void)
 
 void (*mce_threshold_vector)(void) = default_threshold_interrupt;
 
-asmlinkage void smp_threshold_interrupt(void)
+static inline void __smp_threshold_interrupt(void)
 {
-	irq_enter();
-	exit_idle();
 	inc_irq_stat(irq_threshold_count);
 	mce_threshold_vector();
-	irq_exit();
-	/* Ack only at the end to avoid potential reentry */
-	ack_APIC_irq();
+}
+
+asmlinkage void smp_threshold_interrupt(void)
+{
+	entering_irq();
+	__smp_threshold_interrupt();
+	exiting_ack_irq();
+}
+
+asmlinkage void smp_trace_threshold_interrupt(void)
+{
+	entering_irq();
+	trace_threshold_apic_entry(THRESHOLD_APIC_VECTOR);
+	__smp_threshold_interrupt();
+	trace_threshold_apic_exit(THRESHOLD_APIC_VECTOR);
+	exiting_ack_irq();
 }
diff --git a/arch/x86/kernel/entry_32.S b/arch/x86/kernel/entry_32.S
index 8f3e2de..2cfbc3a 100644
--- a/arch/x86/kernel/entry_32.S
+++ b/arch/x86/kernel/entry_32.S
@@ -801,7 +801,17 @@ ENTRY(name)				\
 	CFI_ENDPROC;			\
 ENDPROC(name)
 
-#define BUILD_INTERRUPT(name, nr)	BUILD_INTERRUPT3(name, nr, smp_##name)
+
+#ifdef CONFIG_TRACING
+#define TRACE_BUILD_INTERRUPT(name, nr)		\
+	BUILD_INTERRUPT3(trace_##name, nr, smp_trace_##name)
+#else
+#define TRACE_BUILD_INTERRUPT(name, nr)
+#endif
+
+#define BUILD_INTERRUPT(name, nr) \
+	BUILD_INTERRUPT3(name, nr, smp_##name); \
+	TRACE_BUILD_INTERRUPT(name, nr)
 
 /* The include is where all of the SMP etc. interrupts come from */
 #include <asm/entry_arch.h>
diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
index 7272089..53d6398 100644
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -1138,7 +1138,7 @@ END(common_interrupt)
 /*
  * APIC interrupts.
  */
-.macro apicinterrupt num sym do_sym
+.macro apicinterrupt3 num sym do_sym
 ENTRY(\sym)
 	INTR_FRAME
 	ASM_CLAC
@@ -1150,15 +1150,32 @@ ENTRY(\sym)
 END(\sym)
 .endm
 
+#ifdef CONFIG_TRACING
+#define trace(sym) trace_##sym
+#define smp_trace(sym) smp_trace_##sym
+
+.macro trace_apicinterrupt num sym
+apicinterrupt3 \num trace(\sym) smp_trace(\sym)
+.endm
+#else
+.macro trace_apicinterrupt num sym do_sym
+.endm
+#endif
+
+.macro apicinterrupt num sym do_sym
+apicinterrupt3 \num \sym \do_sym
+trace_apicinterrupt \num \sym
+.endm
+
 #ifdef CONFIG_SMP
-apicinterrupt IRQ_MOVE_CLEANUP_VECTOR \
+apicinterrupt3 IRQ_MOVE_CLEANUP_VECTOR \
 	irq_move_cleanup_interrupt smp_irq_move_cleanup_interrupt
-apicinterrupt REBOOT_VECTOR \
+apicinterrupt3 REBOOT_VECTOR \
 	reboot_interrupt smp_reboot_interrupt
 #endif
 
 #ifdef CONFIG_X86_UV
-apicinterrupt UV_BAU_MESSAGE \
+apicinterrupt3 UV_BAU_MESSAGE \
 	uv_bau_message_intr1 uv_bau_message_interrupt
 #endif
 apicinterrupt LOCAL_TIMER_VECTOR \
@@ -1167,14 +1184,19 @@ apicinterrupt X86_PLATFORM_IPI_VECTOR \
 	x86_platform_ipi smp_x86_platform_ipi
 
 #ifdef CONFIG_HAVE_KVM
-apicinterrupt POSTED_INTR_VECTOR \
+apicinterrupt3 POSTED_INTR_VECTOR \
 	kvm_posted_intr_ipi smp_kvm_posted_intr_ipi
 #endif
 
+#ifdef CONFIG_X86_MCE_THRESHOLD
 apicinterrupt THRESHOLD_APIC_VECTOR \
 	threshold_interrupt smp_threshold_interrupt
+#endif
+
+#ifdef CONFIG_X86_THERMAL_VECTOR
 apicinterrupt THERMAL_APIC_VECTOR \
 	thermal_interrupt smp_thermal_interrupt
+#endif
 
 #ifdef CONFIG_SMP
 apicinterrupt CALL_FUNCTION_SINGLE_VECTOR \
@@ -1451,13 +1473,13 @@ ENTRY(xen_failsafe_callback)
 	CFI_ENDPROC
 END(xen_failsafe_callback)
 
-apicinterrupt HYPERVISOR_CALLBACK_VECTOR \
+apicinterrupt3 HYPERVISOR_CALLBACK_VECTOR \
 	xen_hvm_callback_vector xen_evtchn_do_upcall
 
 #endif /* CONFIG_XEN */
 
 #if IS_ENABLED(CONFIG_HYPERV)
-apicinterrupt HYPERVISOR_CALLBACK_VECTOR \
+apicinterrupt3 HYPERVISOR_CALLBACK_VECTOR \
 	hyperv_callback_vector hyperv_vector_handler
 #endif /* CONFIG_HYPERV */
 
diff --git a/arch/x86/kernel/head_64.S b/arch/x86/kernel/head_64.S
index 321d65e..5e4d8a8 100644
--- a/arch/x86/kernel/head_64.S
+++ b/arch/x86/kernel/head_64.S
@@ -518,9 +518,15 @@ ENTRY(idt_table)
 	.skip IDT_ENTRIES * 16
 
 	.align L1_CACHE_BYTES
-ENTRY(nmi_idt_table)
+ENTRY(debug_idt_table)
 	.skip IDT_ENTRIES * 16
 
+#ifdef CONFIG_TRACING
+	.align L1_CACHE_BYTES
+ENTRY(trace_idt_table)
+	.skip IDT_ENTRIES * 16
+#endif
+
 	__PAGE_ALIGNED_BSS
 NEXT_PAGE(empty_zero_page)
 	.skip PAGE_SIZE
diff --git a/arch/x86/kernel/irq.c b/arch/x86/kernel/irq.c
index ac0631d..3a8185c 100644
--- a/arch/x86/kernel/irq.c
+++ b/arch/x86/kernel/irq.c
@@ -18,6 +18,9 @@
 #include <asm/mce.h>
 #include <asm/hw_irq.h>
 
+#define CREATE_TRACE_POINTS
+#include <asm/trace/irq_vectors.h>
+
 atomic_t irq_err_count;
 
 /* Function pointer for generic interrupt vector handling */
@@ -204,23 +207,21 @@ unsigned int __irq_entry do_IRQ(struct pt_regs *regs)
 /*
  * Handler for X86_PLATFORM_IPI_VECTOR.
  */
-void smp_x86_platform_ipi(struct pt_regs *regs)
+void __smp_x86_platform_ipi(void)
 {
-	struct pt_regs *old_regs = set_irq_regs(regs);
-
-	ack_APIC_irq();
-
-	irq_enter();
-
-	exit_idle();
-
 	inc_irq_stat(x86_platform_ipis);
 
 	if (x86_platform_ipi_callback)
 		x86_platform_ipi_callback();
+}
 
-	irq_exit();
+void smp_x86_platform_ipi(struct pt_regs *regs)
+{
+	struct pt_regs *old_regs = set_irq_regs(regs);
 
+	entering_ack_irq();
+	__smp_x86_platform_ipi();
+	exiting_irq();
 	set_irq_regs(old_regs);
 }
 
@@ -246,6 +247,18 @@ void smp_kvm_posted_intr_ipi(struct pt_regs *regs)
 }
 #endif
 
+void smp_trace_x86_platform_ipi(struct pt_regs *regs)
+{
+	struct pt_regs *old_regs = set_irq_regs(regs);
+
+	entering_ack_irq();
+	trace_x86_platform_ipi_entry(X86_PLATFORM_IPI_VECTOR);
+	__smp_x86_platform_ipi();
+	trace_x86_platform_ipi_exit(X86_PLATFORM_IPI_VECTOR);
+	exiting_irq();
+	set_irq_regs(old_regs);
+}
+
 EXPORT_SYMBOL_GPL(vector_used_by_percpu_irq);
 
 #ifdef CONFIG_HOTPLUG_CPU
diff --git a/arch/x86/kernel/irq_work.c b/arch/x86/kernel/irq_work.c
index ca8f703..636a55e 100644
--- a/arch/x86/kernel/irq_work.c
+++ b/arch/x86/kernel/irq_work.c
@@ -8,14 +8,34 @@
 #include <linux/irq_work.h>
 #include <linux/hardirq.h>
 #include <asm/apic.h>
+#include <asm/trace/irq_vectors.h>
 
-void smp_irq_work_interrupt(struct pt_regs *regs)
+static inline void irq_work_entering_irq(void)
 {
 	irq_enter();
 	ack_APIC_irq();
+}
+
+static inline void __smp_irq_work_interrupt(void)
+{
 	inc_irq_stat(apic_irq_work_irqs);
 	irq_work_run();
-	irq_exit();
+}
+
+void smp_irq_work_interrupt(struct pt_regs *regs)
+{
+	irq_work_entering_irq();
+	__smp_irq_work_interrupt();
+	exiting_irq();
+}
+
+void smp_trace_irq_work_interrupt(struct pt_regs *regs)
+{
+	irq_work_entering_irq();
+	trace_irq_work_entry(IRQ_WORK_VECTOR);
+	__smp_irq_work_interrupt();
+	trace_irq_work_exit(IRQ_WORK_VECTOR);
+	exiting_irq();
 }
 
 void arch_irq_work_raise(void)
diff --git a/arch/x86/kernel/smp.c b/arch/x86/kernel/smp.c
index 48d2b7d..f4fe0b8 100644
--- a/arch/x86/kernel/smp.c
+++ b/arch/x86/kernel/smp.c
@@ -30,6 +30,7 @@
 #include <asm/proto.h>
 #include <asm/apic.h>
 #include <asm/nmi.h>
+#include <asm/trace/irq_vectors.h>
 /*
  *	Some notes on x86 processor bugs affecting SMP operation:
  *
@@ -249,32 +250,80 @@ finish:
 /*
  * Reschedule call back.
  */
-void smp_reschedule_interrupt(struct pt_regs *regs)
+static inline void __smp_reschedule_interrupt(void)
 {
-	ack_APIC_irq();
 	inc_irq_stat(irq_resched_count);
 	scheduler_ipi();
+}
+
+void smp_reschedule_interrupt(struct pt_regs *regs)
+{
+	ack_APIC_irq();
+	__smp_reschedule_interrupt();
 	/*
 	 * KVM uses this interrupt to force a cpu out of guest mode
 	 */
 }
 
-void smp_call_function_interrupt(struct pt_regs *regs)
+void smp_trace_reschedule_interrupt(struct pt_regs *regs)
+{
+	ack_APIC_irq();
+	trace_reschedule_entry(RESCHEDULE_VECTOR);
+	__smp_reschedule_interrupt();
+	trace_reschedule_exit(RESCHEDULE_VECTOR);
+	/*
+	 * KVM uses this interrupt to force a cpu out of guest mode
+	 */
+}
+
+static inline void call_function_entering_irq(void)
 {
 	ack_APIC_irq();
 	irq_enter();
+}
+
+static inline void __smp_call_function_interrupt(void)
+{
 	generic_smp_call_function_interrupt();
 	inc_irq_stat(irq_call_count);
-	irq_exit();
 }
 
-void smp_call_function_single_interrupt(struct pt_regs *regs)
+void smp_call_function_interrupt(struct pt_regs *regs)
+{
+	call_function_entering_irq();
+	__smp_call_function_interrupt();
+	exiting_irq();
+}
+
+void smp_trace_call_function_interrupt(struct pt_regs *regs)
+{
+	call_function_entering_irq();
+	trace_call_function_entry(CALL_FUNCTION_VECTOR);
+	__smp_call_function_interrupt();
+	trace_call_function_exit(CALL_FUNCTION_VECTOR);
+	exiting_irq();
+}
+
+static inline void __smp_call_function_single_interrupt(void)
 {
-	ack_APIC_irq();
-	irq_enter();
 	generic_smp_call_function_single_interrupt();
 	inc_irq_stat(irq_call_count);
-	irq_exit();
+}
+
+void smp_call_function_single_interrupt(struct pt_regs *regs)
+{
+	call_function_entering_irq();
+	__smp_call_function_single_interrupt();
+	exiting_irq();
+}
+
+void smp_trace_call_function_single_interrupt(struct pt_regs *regs)
+{
+	call_function_entering_irq();
+	trace_call_function_single_entry(CALL_FUNCTION_SINGLE_VECTOR);
+	__smp_call_function_single_interrupt();
+	trace_call_function_single_exit(CALL_FUNCTION_SINGLE_VECTOR);
+	exiting_irq();
 }
 
 static int __init nonmi_ipi_setup(char *str)
diff --git a/arch/x86/kernel/tracepoint.c b/arch/x86/kernel/tracepoint.c
new file mode 100644
index 0000000..4e584a8
--- /dev/null
+++ b/arch/x86/kernel/tracepoint.c
@@ -0,0 +1,61 @@
+/*
+ * Code for supporting irq vector tracepoints.
+ *
+ * Copyright (C) 2013 Seiji Aguchi <seiji.aguchi@hds.com>
+ *
+ */
+#include <asm/hw_irq.h>
+#include <asm/desc.h>
+#include <linux/atomic.h>
+
+atomic_t trace_idt_ctr = ATOMIC_INIT(0);
+struct desc_ptr trace_idt_descr = { NR_VECTORS * 16 - 1,
+				(unsigned long) trace_idt_table };
+
+#ifndef CONFIG_X86_64
+gate_desc trace_idt_table[NR_VECTORS] __page_aligned_data
+					= { { { { 0, 0 } } }, };
+#endif
+
+static int trace_irq_vector_refcount;
+static DEFINE_MUTEX(irq_vector_mutex);
+
+static void set_trace_idt_ctr(int val)
+{
+	atomic_set(&trace_idt_ctr, val);
+	/* Ensure the trace_idt_ctr is set before sending IPI */
+	wmb();
+}
+
+static void switch_idt(void *arg)
+{
+	unsigned long flags;
+
+	local_irq_save(flags);
+	load_current_idt();
+	local_irq_restore(flags);
+}
+
+void trace_irq_vector_regfunc(void)
+{
+	mutex_lock(&irq_vector_mutex);
+	if (!trace_irq_vector_refcount) {
+		set_trace_idt_ctr(1);
+		smp_call_function(switch_idt, NULL, 0);
+		switch_idt(NULL);
+	}
+	trace_irq_vector_refcount++;
+	mutex_unlock(&irq_vector_mutex);
+}
+
+void trace_irq_vector_unregfunc(void)
+{
+	mutex_lock(&irq_vector_mutex);
+	trace_irq_vector_refcount--;
+	if (!trace_irq_vector_refcount) {
+		set_trace_idt_ctr(0);
+		smp_call_function(switch_idt, NULL, 0);
+		switch_idt(NULL);
+	}
+	mutex_unlock(&irq_vector_mutex);
+}
diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
index 772e2a8..d27182d 100644
--- a/arch/x86/kernel/traps.c
+++ b/arch/x86/kernel/traps.c
@@ -785,7 +785,7 @@ void __init trap_init(void)
 	x86_init.irqs.trap_init();
 
 #ifdef CONFIG_X86_64
-	memcpy(&nmi_idt_table, &idt_table, IDT_ENTRIES * 16);
+	memcpy(&debug_idt_table, &idt_table, IDT_ENTRIES * 16);
 	set_nmi_gate(X86_TRAP_DB, &debug);
 	set_nmi_gate(X86_TRAP_BP, &int3);
 #endif
diff --git a/include/linux/tracepoint.h b/include/linux/tracepoint.h
index f8e084d..ebeab36 100644
--- a/include/linux/tracepoint.h
+++ b/include/linux/tracepoint.h
@@ -378,6 +378,8 @@ static inline void tracepoint_synchronize_unregister(void)
 #define DECLARE_EVENT_CLASS(name, proto, args, tstruct, assign, print)
 #define DEFINE_EVENT(template, name, proto, args)		\
 	DECLARE_TRACE(name, PARAMS(proto), PARAMS(args))
+#define DEFINE_EVENT_FN(template, name, proto, args, reg, unreg)\
+	DECLARE_TRACE(name, PARAMS(proto), PARAMS(args))
 #define DEFINE_EVENT_PRINT(template, name, proto, args, print)	\
 	DECLARE_TRACE(name, PARAMS(proto), PARAMS(args))
 #define DEFINE_EVENT_CONDITION(template, name, proto,		\
diff --git a/include/trace/define_trace.h b/include/trace/define_trace.h
index 1905ca8..02e1003 100644
--- a/include/trace/define_trace.h
+++ b/include/trace/define_trace.h
@@ -44,6 +44,10 @@
 #define DEFINE_EVENT(template, name, proto, args) \
 	DEFINE_TRACE(name)
 
+#undef DEFINE_EVENT_FN
+#define DEFINE_EVENT_FN(template, name, proto, args, reg, unreg) \
+	DEFINE_TRACE_FN(name, reg, unreg)
+
 #undef DEFINE_EVENT_PRINT
 #define DEFINE_EVENT_PRINT(template, name, proto, args, print)	\
 	DEFINE_TRACE(name)
@@ -91,6 +95,7 @@
 #undef TRACE_EVENT_CONDITION
 #undef DECLARE_EVENT_CLASS
 #undef DEFINE_EVENT
+#undef DEFINE_EVENT_FN
 #undef DEFINE_EVENT_PRINT
 #undef DEFINE_EVENT_CONDITION
 #undef TRACE_HEADER_MULTI_READ
diff --git a/include/trace/ftrace.h b/include/trace/ftrace.h
index 19edd7f..d615f78 100644
--- a/include/trace/ftrace.h
+++ b/include/trace/ftrace.h
@@ -71,6 +71,10 @@
 	static struct ftrace_event_call	__used		\
 	__attribute__((__aligned__(4))) event_##name
 
+#undef DEFINE_EVENT_FN
+#define DEFINE_EVENT_FN(template, name, proto, args, reg, unreg)	\
+	DEFINE_EVENT(template, name, PARAMS(proto), PARAMS(args))
+
 #undef DEFINE_EVENT_PRINT
 #define DEFINE_EVENT_PRINT(template, name, proto, args, print)	\
 	DEFINE_EVENT(template, name, PARAMS(proto), PARAMS(args))
diff --git a/include/xen/events.h b/include/xen/events.h
index b2b27c6..c9ea10e 100644
--- a/include/xen/events.h
+++ b/include/xen/events.h
@@ -76,6 +76,9 @@ unsigned irq_from_evtchn(unsigned int evtchn);
 
 /* Xen HVM evtchn vector callback */
 void xen_hvm_callback_vector(void);
+#ifdef CONFIG_TRACING
+#define trace_xen_hvm_callback_vector xen_hvm_callback_vector
+#endif
 extern int xen_have_vector_callback;
 int xen_set_callback_via(uint64_t via);
 void xen_evtchn_do_upcall(struct pt_regs *regs);
