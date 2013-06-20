Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758108Ab3FTPrn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 11:47:43 -0400
Received: from usindpps06.hds.com ([207.126.252.19]:50040 "EHLO
	usindpps06.hds.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758090Ab3FTPrl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 11:47:41 -0400
Message-ID: <51C323ED.5050708@hds.com>
Date: Thu, 20 Jun 2013 11:46:53 -0400
From: Seiji Aguchi <seiji.aguchi@hds.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, hpa@zytor.com, rostedt@goodmis.org
CC: tglx@linutronix.de, mingo@elte.hu, bp@alien8.de,
        linux-edac@vger.kernel.org, tony.luck@intel.com,
        tomoki.sekiyama@hds.com, dle-develop@lists.sourceforge.net
Subject: [PATCH v17 4/4] trace,x86: Add irq vector tracepoints
References: <51C32343.7080901@hds.com>
In-Reply-To: <51C32343.7080901@hds.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 mx ip4:207.126.244.0/26 ip4:207.126.252.0/25 include:mktomail.com
 include:cloud.hds.com ~all
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.10.8794,1.0.431,0.0.0000
 definitions=2013-06-20_06:2013-06-20,2013-06-20,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=outbound_policy score=0
 kscore.is_bulkscore=3.04756220259605e-13 kscore.compositescore=0
 circleOfTrustscore=0 compositescore=0.997215366458519
 urlsuspect_oldscore=0.997215366458519 suspectscore=0
 recipient_domain_to_sender_totalscore=0 phishscore=0 bulkscore=0
 kscore.is_spamscore=0 recipient_to_sender_totalscore=0
 recipient_domain_to_sender_domain_totalscore=0 rbsscore=0.997215366458519
 spamscore=0 recipient_to_sender_domain_totalscore=0 urlsuspectscore=0.9
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=7.0.1-1305240000 definitions=main-1306200119
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Purpose of this patch]

As Vaibhav explained in the thread below, tracepoints for irq vectors
are useful.

http://www.spinics.net/lists/mm-commits/msg85707.html

<snip>
The current interrupt traces from irq_handler_entry and irq_handler_exit
provide when an interrupt is handled.  They provide good data about when
the system has switched to kernel space and how it affects the currently
running processes.

There are some IRQ vectors which trigger the system into kernel space,
which are not handled in generic IRQ handlers.  Tracing such events gives
us the information about IRQ interaction with other system events.

The trace also tells where the system is spending its time.  We want to
know which cores are handling interrupts and how they are affecting other
processes in the system.  Also, the trace provides information about when
the cores are idle and which interrupts are changing that state.
<snip>

On the other hand, my usecase is tracing just local timer event and
getting a value of instruction pointer.

I suggested to add an argument local timer event to get instruction pointer before.
But there is another way to get it with external module like systemtap.
So, I don't need to add any argument to irq vector tracepoints now.

[Patch Description]

Vaibhav's patch shared a trace point ,irq_vector_entry/irq_vector_exit, in all events.
But there is an above use case to trace specific irq_vector rather than tracing all events.
In this case, we are concerned about overhead due to unwanted events.

So, add following tracepoints instead of introducing irq_vector_entry/exit.
so that we can enable them independently.
   - local_timer_vector
   - reschedule_vector
   - call_function_vector
   - call_function_single_vector
   - irq_work_entry_vector
   - error_apic_vector
   - thermal_apic_vector
   - threshold_apic_vector
   - spurious_apic_vector
   - x86_platform_ipi_vector

Also, introduce a logic switching IDT at enabling/disabling time so that a time penalty
makes a zero when tracepoints are disabled. Detailed explanations are as follows.
 - Create trace irq handlers with entering_irq()/exiting_irq().
 - Create a new IDT, trace_idt_table, at boot time by adding a logic to
   _set_gate(). It is just a copy of original idt table.
 - Register the new handlers for tracpoints to the new IDT by introducing
   macros to alloc_intr_gate() called at registering time of irq_vector handlers.
 - Add checking, whether irq vector tracing is on/off, into load_current_idt().
   This has to be done below debug checking for these reasons.
   - Switching to debug IDT may be kicked while tracing is enabled.
   - On the other hands, switching to trace IDT is kicked only when debugging
     is disabled.

In addition, the new IDT is created only when CONFIG_TRACING is enabled to avoid being
used for other purposes.

Signed-off-by: Seiji Aguchi <seiji.aguchi@hds.com>
---
 arch/x86/include/asm/desc.h              |   72 ++++++++++++++++++++-
 arch/x86/include/asm/entry_arch.h        |    8 ++-
 arch/x86/include/asm/hw_irq.h            |   17 +++++
 arch/x86/include/asm/mshyperv.h          |    3 +
 arch/x86/include/asm/trace/irq_vectors.h |  104 ++++++++++++++++++++++++++++++
 arch/x86/include/asm/uv/uv_bau.h         |    3 +
 arch/x86/kernel/Makefile                 |    1 +
 arch/x86/kernel/apic/Makefile            |    1 +
 arch/x86/kernel/apic/apic.c              |   42 ++++++++++++
 arch/x86/kernel/cpu/common.c             |    4 +-
 arch/x86/kernel/cpu/mcheck/therm_throt.c |   10 +++
 arch/x86/kernel/cpu/mcheck/threshold.c   |    9 +++
 arch/x86/kernel/entry_32.S               |   12 +++-
 arch/x86/kernel/entry_64.S               |   31 +++++++--
 arch/x86/kernel/head_64.S                |    6 ++
 arch/x86/kernel/irq.c                    |   13 ++++
 arch/x86/kernel/irq_work.c               |   10 +++
 arch/x86/kernel/smp.c                    |   30 +++++++++
 arch/x86/kernel/tracepoint.c             |   57 ++++++++++++++++
 include/xen/events.h                     |    3 +
 20 files changed, 421 insertions(+), 15 deletions(-)
 create mode 100644 arch/x86/include/asm/trace/irq_vectors.h
 create mode 100644 arch/x86/kernel/tracepoint.c

diff --git a/arch/x86/include/asm/desc.h b/arch/x86/include/asm/desc.h
index af290b8..1377ecb 100644
--- a/arch/x86/include/asm/desc.h
+++ b/arch/x86/include/asm/desc.h
@@ -320,6 +320,19 @@ static inline void set_nmi_gate(int gate, void *addr)
 }
 #endif
 
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
+}
+#endif
+
 static inline void _set_gate(int gate, unsigned type, void *addr,
 			     unsigned dpl, unsigned ist, unsigned seg)
 {
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
@@ -430,6 +471,31 @@ static inline void load_debug_idt(void)
 }
 #endif
 
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
 /*
  * the load_current_idt() is called with interrupt disabled by local_irq_save()
  * to avoid races. That way the IDT will always be set back to the expected
@@ -442,6 +508,8 @@ static inline void load_current_idt(void)
 	local_irq_save(flags);
 	if (is_debug_idt_enabled())
 		load_debug_idt();
+	else if (is_trace_idt_enabled())
+		load_trace_idt();
 	else
 		load_idt((const struct desc_ptr *)&idt_descr);
 	local_irq_restore(flags);
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
index 7bd3bd3..74b3891 100644
--- a/arch/x86/kernel/Makefile
+++ b/arch/x86/kernel/Makefile
@@ -102,6 +102,7 @@ obj-$(CONFIG_OF)			+= devicetree.o
 obj-$(CONFIG_UPROBES)			+= uprobes.o
 
 obj-$(CONFIG_PERF_EVENTS)		+= perf_regs.o
+obj-$(CONFIG_TRACING)			+= tracepoint.o
 
 ###
 # 64 bit specific files
diff --git a/arch/x86/kernel/apic/Makefile b/arch/x86/kernel/apic/Makefile
index 0ae0323..5274c3a 100644
--- a/arch/x86/kernel/apic/Makefile
+++ b/arch/x86/kernel/apic/Makefile
@@ -2,6 +2,7 @@
 # Makefile for local APIC drivers and for the IO-APIC code
 #
 
+CFLAGS_apic.o := -I$(src)/../../include/asm/trace
 obj-$(CONFIG_X86_LOCAL_APIC)	+= apic.o apic_noop.o ipi.o
 obj-y				+= hw_nmi.o
 
diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index 59ee76f..61ced40 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -55,6 +55,9 @@
 #include <asm/tsc.h>
 #include <asm/hypervisor.h>
 
+#define CREATE_TRACE_POINTS
+#include <asm/trace/irq_vectors.h>
+
 unsigned int num_processors;
 
 unsigned disabled_cpus __cpuinitdata;
@@ -931,6 +934,27 @@ void __irq_entry smp_apic_timer_interrupt(struct pt_regs *regs)
 	set_irq_regs(old_regs);
 }
 
+void __irq_entry smp_trace_apic_timer_interrupt(struct pt_regs *regs)
+{
+	struct pt_regs *old_regs = set_irq_regs(regs);
+
+	/*
+	 * NOTE! We'd better ACK the irq immediately,
+	 * because timer handling can be slow.
+	 *
+	 * update_process_times() expects us to have done irq_enter().
+	 * Besides, if we don't timer interrupts ignore the global
+	 * interrupt lock, which is the WrongThing (tm) to do.
+	 */
+	entering_ack_irq();
+	trace_local_timer_entry(LOCAL_TIMER_VECTOR);
+	local_apic_timer_interrupt();
+	trace_local_timer_exit(LOCAL_TIMER_VECTOR);
+	exiting_irq();
+
+	set_irq_regs(old_regs);
+}
+
 int setup_profiling_timer(unsigned int multiplier)
 {
 	return -EINVAL;
@@ -1931,6 +1955,15 @@ void smp_spurious_interrupt(struct pt_regs *regs)
 	exiting_irq();
 }
 
+void smp_trace_spurious_interrupt(struct pt_regs *regs)
+{
+	entering_irq();
+	trace_spurious_apic_entry(SPURIOUS_APIC_VECTOR);
+	__smp_spurious_interrupt();
+	trace_spurious_apic_exit(SPURIOUS_APIC_VECTOR);
+	exiting_irq();
+}
+
 /*
  * This interrupt should never happen with our APIC/SMP architecture
  */
@@ -1978,6 +2011,15 @@ void smp_error_interrupt(struct pt_regs *regs)
 	exiting_irq();
 }
 
+void smp_trace_error_interrupt(struct pt_regs *regs)
+{
+	entering_irq();
+	trace_error_apic_entry(ERROR_APIC_VECTOR);
+	__smp_error_interrupt(regs);
+	trace_error_apic_exit(ERROR_APIC_VECTOR);
+	exiting_irq();
+}
+
 /**
  * connect_bsp_APIC - attach the APIC to the interrupt system
  */
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index 8f6a0f9..d9c8c09 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
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
index f6b35f2..2f3a799 100644
--- a/arch/x86/kernel/cpu/mcheck/therm_throt.c
+++ b/arch/x86/kernel/cpu/mcheck/therm_throt.c
@@ -29,6 +29,7 @@
 #include <asm/idle.h>
 #include <asm/mce.h>
 #include <asm/msr.h>
+#include <asm/trace/irq_vectors.h>
 
 /* How long to wait between reporting thermal events */
 #define CHECK_INTERVAL		(300 * HZ)
@@ -391,6 +392,15 @@ asmlinkage void smp_thermal_interrupt(struct pt_regs *regs)
 	exiting_ack_irq();
 }
 
+asmlinkage void smp_trace_thermal_interrupt(struct pt_regs *regs)
+{
+	entering_irq();
+	trace_thermal_apic_entry(THERMAL_APIC_VECTOR);
+	__smp_thermal_interrupt();
+	trace_thermal_apic_exit(THERMAL_APIC_VECTOR);
+	exiting_ack_irq();
+}
+
 /* Thermal monitoring depends on APIC, ACPI and clock modulation */
 static int intel_thermal_supported(struct cpuinfo_x86 *c)
 {
diff --git a/arch/x86/kernel/cpu/mcheck/threshold.c b/arch/x86/kernel/cpu/mcheck/threshold.c
index f20988a..fe6b1c8 100644
--- a/arch/x86/kernel/cpu/mcheck/threshold.c
+++ b/arch/x86/kernel/cpu/mcheck/threshold.c
@@ -8,6 +8,7 @@
 #include <asm/apic.h>
 #include <asm/idle.h>
 #include <asm/mce.h>
+#include <asm/trace/irq_vectors.h>
 
 static void default_threshold_interrupt(void)
 {
@@ -30,3 +31,11 @@ asmlinkage void smp_threshold_interrupt(void)
 	exiting_ack_irq();
 }
 
+asmlinkage void smp_trace_threshold_interrupt(void)
+{
+	entering_irq();
+	trace_threshold_apic_entry(THRESHOLD_APIC_VECTOR);
+	__smp_threshold_interrupt();
+	trace_threshold_apic_exit(THRESHOLD_APIC_VECTOR);
+	exiting_ack_irq();
+}
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
index 7272089..11eef43 100644
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
@@ -1167,7 +1184,7 @@ apicinterrupt X86_PLATFORM_IPI_VECTOR \
 	x86_platform_ipi smp_x86_platform_ipi
 
 #ifdef CONFIG_HAVE_KVM
-apicinterrupt POSTED_INTR_VECTOR \
+apicinterrupt3 POSTED_INTR_VECTOR \
 	kvm_posted_intr_ipi smp_kvm_posted_intr_ipi
 #endif
 
@@ -1451,13 +1468,13 @@ ENTRY(xen_failsafe_callback)
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
index 84fb779..5e4d8a8 100644
--- a/arch/x86/kernel/head_64.S
+++ b/arch/x86/kernel/head_64.S
@@ -521,6 +521,12 @@ ENTRY(idt_table)
 ENTRY(debug_idt_table)
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
index e3b8df1..06af119 100644
--- a/arch/x86/kernel/irq.c
+++ b/arch/x86/kernel/irq.c
@@ -17,6 +17,7 @@
 #include <asm/idle.h>
 #include <asm/mce.h>
 #include <asm/hw_irq.h>
+#include <asm/trace/irq_vectors.h>
 
 atomic_t irq_err_count;
 
@@ -244,6 +245,18 @@ void smp_kvm_posted_intr_ipi(struct pt_regs *regs)
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
index 074d46f..636a55e 100644
--- a/arch/x86/kernel/irq_work.c
+++ b/arch/x86/kernel/irq_work.c
@@ -8,6 +8,7 @@
 #include <linux/irq_work.h>
 #include <linux/hardirq.h>
 #include <asm/apic.h>
+#include <asm/trace/irq_vectors.h>
 
 static inline void irq_work_entering_irq(void)
 {
@@ -28,6 +29,15 @@ void smp_irq_work_interrupt(struct pt_regs *regs)
 	exiting_irq();
 }
 
+void smp_trace_irq_work_interrupt(struct pt_regs *regs)
+{
+	irq_work_entering_irq();
+	trace_irq_work_entry(IRQ_WORK_VECTOR);
+	__smp_irq_work_interrupt();
+	trace_irq_work_exit(IRQ_WORK_VECTOR);
+	exiting_irq();
+}
+
 void arch_irq_work_raise(void)
 {
 #ifdef CONFIG_X86_LOCAL_APIC
diff --git a/arch/x86/kernel/smp.c b/arch/x86/kernel/smp.c
index d858375..f4fe0b8 100644
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
@@ -264,6 +265,17 @@ void smp_reschedule_interrupt(struct pt_regs *regs)
 	 */
 }
 
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
 static inline void call_function_entering_irq(void)
 {
 	ack_APIC_irq();
@@ -283,6 +295,15 @@ void smp_call_function_interrupt(struct pt_regs *regs)
 	exiting_irq();
 }
 
+void smp_trace_call_function_interrupt(struct pt_regs *regs)
+{
+	call_function_entering_irq();
+	trace_call_function_entry(CALL_FUNCTION_VECTOR);
+	__smp_call_function_interrupt();
+	trace_call_function_exit(CALL_FUNCTION_VECTOR);
+	exiting_irq();
+}
+
 static inline void __smp_call_function_single_interrupt(void)
 {
 	generic_smp_call_function_single_interrupt();
@@ -296,6 +317,15 @@ void smp_call_function_single_interrupt(struct pt_regs *regs)
 	exiting_irq();
 }
 
+void smp_trace_call_function_single_interrupt(struct pt_regs *regs)
+{
+	call_function_entering_irq();
+	trace_call_function_single_entry(CALL_FUNCTION_SINGLE_VECTOR);
+	__smp_call_function_single_interrupt();
+	trace_call_function_single_exit(CALL_FUNCTION_SINGLE_VECTOR);
+	exiting_irq();
+}
+
 static int __init nonmi_ipi_setup(char *str)
 {
 	smp_no_nmi_ipi = true;
diff --git a/arch/x86/kernel/tracepoint.c b/arch/x86/kernel/tracepoint.c
new file mode 100644
index 0000000..1423efe
--- /dev/null
+++ b/arch/x86/kernel/tracepoint.c
@@ -0,0 +1,57 @@
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
+	load_current_idt();
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
-- 
1.7.1



