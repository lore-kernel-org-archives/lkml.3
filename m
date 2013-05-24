Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755409Ab3EXN3n (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 May 2013 09:29:43 -0400
Received: from usindpps04.hds.com ([207.126.252.17]:45429 "EHLO
	usindpps04.hds.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751285Ab3EXN3l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 May 2013 09:29:41 -0400
From: Seiji Aguchi <seiji.aguchi@hds.com>
To: Steven Rostedt <rostedt@goodmis.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>, "hpa@zytor.com" <hpa@zytor.com>,
        "Thomas Gleixner (tglx@linutronix.de)" <tglx@linutronix.de>,
        "'mingo@elte.hu' (mingo@elte.hu)" <mingo@elte.hu>,
        "Borislav Petkov (bp@alien8.de)" <bp@alien8.de>,
        "linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>,
        "Luck, Tony (tony.luck@intel.com)" <tony.luck@intel.com>,
        "dle-develop@lists.sourceforge.net" 
	<dle-develop@lists.sourceforge.net>,
        Tomoki Sekiyama <tomoki.sekiyama@hds.com>
Subject: RE: [PATCH v12 2/3] trace,x86: add x86 irq vector tracepoints
Thread-Topic: [PATCH v12 2/3] trace,x86: add x86 irq vector tracepoints
Thread-Index: Ac4yMqXGUQm3sCjHRiiXwHWbNviUCgl3c5GAABxXvZA=
Date: Fri, 24 May 2013 13:28:09 +0000
Message-ID: <A5ED84D3BB3A384992CBB9C77DEDA4D41B0031F4@USINDEM103.corp.hds.com>
References: <A5ED84D3BB3A384992CBB9C77DEDA4D41AF86271@USINDEM103.corp.hds.com>
 <1369338693.6828.212.camel@gandalf.local.home>
In-Reply-To: <1369338693.6828.212.camel@gandalf.local.home>
Accept-Language: ja-JP, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.74.73.11]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 mx ip4:207.126.244.0/26 ip4:207.126.252.0/25 include:mktomail.com
 include:cloud.hds.com ~all
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.10.8626,1.0.431,0.0.0000
 definitions=2013-05-24_06:2013-05-24,2013-05-24,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=outbound_policy score=0 spamscore=0 ipscore=0
 suspectscore=1 phishscore=0 bulkscore=0 adultscore=0 classifier=spam
 adjust=0 reason=mlx scancount=1 engine=6.0.2-1211240000
 definitions=main-1305240117
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r4ODTrQ3012203


> > @@ -1156,8 +1156,14 @@ void debug_stack_reset(void)
Thank you for reviewing.

> >  {
> >  	if (WARN_ON(!this_cpu_read(debug_stack_use_ctr)))
> >  		return;
> > -	if (this_cpu_dec_return(debug_stack_use_ctr) == 0)
> > -		load_idt((const struct desc_ptr *)&idt_descr);
> > +	if (this_cpu_dec_return(debug_stack_use_ctr) == 0) {
> > +#ifdef CONFIG_TRACING
> > +		if (this_cpu_read(trace_idt_in_use))
> > +			load_idt((const struct desc_ptr *)&trace_idt_descr);
> > +		else
> > +#endif
> > +			load_idt((const struct desc_ptr *)&idt_descr);
> > +	}
> 
> I have a patch that makes this more generic. I'm wondering if that would
> be better than having everything so coupled.
>

Do you mean it should be discussed in another thread as you posted "[PATCH] x86: Have debug/nmi restore the IDT it replaced"?

Anyway, I will update my patch in accordance with your comments.

Seiji

> -----Original Message-----
> From: Steven Rostedt [mailto:rostedt@goodmis.org]
> Sent: Thursday, May 23, 2013 3:52 PM
> To: Seiji Aguchi
> Cc: linux-kernel@vger.kernel.org; x86@kernel.org; hpa@zytor.com; Thomas Gleixner (tglx@linutronix.de); 'mingo@elte.hu'
> (mingo@elte.hu); Borislav Petkov (bp@alien8.de); linux-edac@vger.kernel.org; Luck, Tony (tony.luck@intel.com); dle-
> develop@lists.sourceforge.net; Tomoki Sekiyama
> Subject: Re: [PATCH v12 2/3] trace,x86: add x86 irq vector tracepoints
> 
> On Fri, 2013-04-05 at 19:20 +0000, Seiji Aguchi wrote:
> > Signed-off-by: Seiji Aguchi <seiji.aguchi@hds.com>
> > ---
> >  arch/x86/include/asm/desc.h              |   36 +++++++-
> >  arch/x86/include/asm/entry_arch.h        |    5 +-
> >  arch/x86/include/asm/hw_irq.h            |   16 +++
> >  arch/x86/include/asm/mshyperv.h          |    1 +
> >  arch/x86/include/asm/trace/irq_vectors.h |  159 ++++++++++++++++++++++++++++++
> >  arch/x86/kernel/Makefile                 |    1 +
> >  arch/x86/kernel/apic/apic.c              |   94 ++++++++++++++++++
> >  arch/x86/kernel/cpu/common.c             |   12 ++-
> >  arch/x86/kernel/cpu/mcheck/therm_throt.c |   14 +++
> >  arch/x86/kernel/cpu/mcheck/threshold.c   |   14 +++
> >  arch/x86/kernel/entry_32.S               |   12 ++-
> >  arch/x86/kernel/entry_64.S               |   29 +++++-
> >  arch/x86/kernel/head_64.S                |    6 +
> >  arch/x86/kernel/irq.c                    |   23 +++++
> >  arch/x86/kernel/irq_work.c               |   12 +++
> >  arch/x86/kernel/smp.c                    |   35 +++++++
> >  arch/x86/kernel/tracepoint.c             |   71 +++++++++++++
> >  include/xen/events.h                     |    3 +
> >  18 files changed, 529 insertions(+), 14 deletions(-)
> >  create mode 100644 arch/x86/include/asm/trace/irq_vectors.h
> >  create mode 100644 arch/x86/kernel/tracepoint.c
> >
> > diff --git a/arch/x86/include/asm/desc.h b/arch/x86/include/asm/desc.h
> > index 8bf1c06..e718c72 100644
> > --- a/arch/x86/include/asm/desc.h
> > +++ b/arch/x86/include/asm/desc.h
> > @@ -39,6 +39,9 @@ extern gate_desc idt_table[];
> >  extern struct desc_ptr nmi_idt_descr;
> >  extern gate_desc nmi_idt_table[];
> >
> > +extern struct desc_ptr trace_idt_descr;
> > +extern DEFINE_PER_CPU(u32, trace_idt_in_use);
> > +extern DEFINE_PER_CPU(u32, debug_stack_use_ctr);
> 
> Header files should use DECLARE_PER_CPU() not DEFINE_PER_CPU. And drop
> the "extern" when doing so, as it's implicit in the macro.
> 
> 
> >  struct gdt_page {
> >  	struct desc_struct gdt[GDT_ENTRIES];
> >  } __attribute__((aligned(PAGE_SIZE)));
> > @@ -320,6 +323,17 @@ static inline void set_nmi_gate(int gate, void *addr)
> >  }
> >  #endif
> >
> > +#ifdef CONFIG_TRACING
> > +extern gate_desc trace_idt_table[];
> > +static inline void trace_set_intr_gate(unsigned int gate, void *addr)
> > +{
> > +	gate_desc s;
> > +
> > +	pack_gate(&s, GATE_INTERRUPT, (unsigned long)addr, 0, 0, __KERNEL_CS);
> > +	write_idt_entry(trace_idt_table, gate, &s);
> > +}
> 
> Perhaps add a:
> 
> static inline void write_trace_idt_entry(gate_desc *idt, int entry,
> 				const gate_desc *gate)
> {
> 	write_idt_entry(idt, entry, gate);
> }
> #else
> static inline void write_trace_idt_entry(gate_desc *idt, int entry,
> 				const gate_desc *gate)
> {
> }
> > +#endif
> 
> Then you can below just do:
> 
> 
> > +
> >  static inline void _set_gate(int gate, unsigned type, void *addr,
> >  			     unsigned dpl, unsigned ist, unsigned seg)
> >  {
> > @@ -331,6 +345,9 @@ static inline void _set_gate(int gate, unsigned type, void *addr,
> >  	 * setup time
> >  	 */
> >  	write_idt_entry(idt_table, gate, &s);
> 
> 	write_trace_idt_entry(idt_table, gate, &s);
> 
> and remove the #ifdef. Makes it nice to read.
> 
> > +#ifdef CONFIG_TRACING
> > +	write_idt_entry(trace_idt_table, gate, &s);
> > +#endif
> >  }
> >
> >  /*
> > @@ -360,12 +377,27 @@ static inline void alloc_system_vector(int vector)
> >  	}
> >  }
> >
> > -static inline void alloc_intr_gate(unsigned int n, void *addr)
> > +#ifdef CONFIG_TRACING
> > +static inline void __trace_alloc_intr_gate(unsigned int n, void *addr)
> > +{
> > +	trace_set_intr_gate(n, addr);
> > +}
> > +#else
> > +#define __trace_alloc_intr_gate(n, addr)
> > +#endif
> > +
> > +static inline void __alloc_intr_gate(unsigned int n, void *addr)
> >  {
> > -	alloc_system_vector(n);
> >  	set_intr_gate(n, addr);
> >  }
> >
> > +#define alloc_intr_gate(n, addr)				\
> > +	do {							\
> > +		alloc_system_vector(n);				\
> > +		__alloc_intr_gate(n, addr);			\
> > +		__trace_alloc_intr_gate(n, trace_##addr);	\
> > +	} while (0)
> > +
> >  /*
> >   * This routine sets up an interrupt gate at directory privilege level 3.
> >   */
> > diff --git a/arch/x86/include/asm/entry_arch.h b/arch/x86/include/asm/entry_arch.h
> > index 40afa00..0bb99d8 100644
> > --- a/arch/x86/include/asm/entry_arch.h
> > +++ b/arch/x86/include/asm/entry_arch.h
> > @@ -13,8 +13,9 @@
> >  BUILD_INTERRUPT(reschedule_interrupt,RESCHEDULE_VECTOR)
> >  BUILD_INTERRUPT(call_function_interrupt,CALL_FUNCTION_VECTOR)
> >  BUILD_INTERRUPT(call_function_single_interrupt,CALL_FUNCTION_SINGLE_VECTOR)
> > -BUILD_INTERRUPT(irq_move_cleanup_interrupt,IRQ_MOVE_CLEANUP_VECTOR)
> > -BUILD_INTERRUPT(reboot_interrupt,REBOOT_VECTOR)
> > +BUILD_INTERRUPT3(irq_move_cleanup_interrupt, IRQ_MOVE_CLEANUP_VECTOR,
> > +		 smp_irq_move_cleanup_interrupt)
> > +BUILD_INTERRUPT3(reboot_interrupt, REBOOT_VECTOR, smp_reboot_interrupt)
> >  #endif
> >
> >  BUILD_INTERRUPT(x86_platform_ipi, X86_PLATFORM_IPI_VECTOR)
> > diff --git a/arch/x86/include/asm/hw_irq.h b/arch/x86/include/asm/hw_irq.h
> > index 10a78c3..e84e91a 100644
> > --- a/arch/x86/include/asm/hw_irq.h
> > +++ b/arch/x86/include/asm/hw_irq.h
> > @@ -76,6 +76,22 @@ extern void threshold_interrupt(void);
> >  extern void call_function_interrupt(void);
> >  extern void call_function_single_interrupt(void);
> >
> > +#ifdef CONFIG_TRACING
> > +/* Interrupt handlers registered during init_IRQ */
> > +extern void trace_apic_timer_interrupt(void);
> > +extern void trace_x86_platform_ipi(void);
> > +extern void trace_error_interrupt(void);
> > +extern void trace_irq_work_interrupt(void);
> > +extern void trace_spurious_interrupt(void);
> > +extern void trace_thermal_interrupt(void);
> > +extern void trace_reschedule_interrupt(void);
> > +extern void trace_threshold_interrupt(void);
> > +extern void trace_call_function_interrupt(void);
> > +extern void trace_call_function_single_interrupt(void);
> > +#define trace_irq_move_cleanup_interrupt  irq_move_cleanup_interrupt
> > +#define trace_reboot_interrupt  reboot_interrupt
> > +#endif /* CONFIG_TRACING */
> > +
> >  /* IOAPIC */
> >  #define IO_APIC_IRQ(x) (((x) >= NR_IRQS_LEGACY) || ((1<<(x)) & io_apic_irqs))
> >  extern unsigned long io_apic_irqs;
> > diff --git a/arch/x86/include/asm/mshyperv.h b/arch/x86/include/asm/mshyperv.h
> > index c2934be..cc40e03 100644
> > --- a/arch/x86/include/asm/mshyperv.h
> > +++ b/arch/x86/include/asm/mshyperv.h
> > @@ -12,6 +12,7 @@ struct ms_hyperv_info {
> >  extern struct ms_hyperv_info ms_hyperv;
> >
> >  void hyperv_callback_vector(void);
> > +#define trace_hyperv_callback_vector hyperv_callback_vector
> >  void hyperv_vector_handler(struct pt_regs *regs);
> >  void hv_register_vmbus_handler(int irq, irq_handler_t handler);
> >
> > diff --git a/arch/x86/include/asm/trace/irq_vectors.h b/arch/x86/include/asm/trace/irq_vectors.h
> > new file mode 100644
> > index 0000000..b4f1c53
> > --- /dev/null
> > +++ b/arch/x86/include/asm/trace/irq_vectors.h
> > @@ -0,0 +1,159 @@
> > +#undef TRACE_SYSTEM
> > +#define TRACE_SYSTEM irq_vectors
> > +
> > +#if !defined(_TRACE_IRQ_VECTORS_H) || defined(TRACE_HEADER_MULTI_READ)
> > +#define _TRACE_IRQ_VECTORS_H
> > +
> > +#include <linux/tracepoint.h>
> > +
> > +extern void trace_irq_vector_regfunc(void);
> > +extern void trace_irq_vector_unregfunc(void);
> > +
> > +DECLARE_EVENT_CLASS(x86_irq_vector,
> > +
> > +	TP_PROTO(int vector),
> > +
> > +	TP_ARGS(vector),
> > +
> > +	TP_STRUCT__entry(
> > +		__field(		int,	vector	)
> > +	),
> > +
> > +	TP_fast_assign(
> > +		__entry->vector = vector;
> > +	),
> > +
> > +	TP_printk("vector=%d", __entry->vector) );
> > +
> > +#define DEFINE_IRQ_VECTOR_EVENT(name)	\
> > +DEFINE_EVENT_FN(x86_irq_vector, name,	\
> > +	TP_PROTO(int vector),		\
> > +	TP_ARGS(vector),		\
> > +	trace_irq_vector_regfunc,	\
> > +	trace_irq_vector_unregfunc);
> > +
> > +/*
> > + * local_timer_entry - called before entering a local timer interrupt
> > + * vector handler
> > + */
> > +DEFINE_IRQ_VECTOR_EVENT(local_timer_entry);
> > +
> > +/*
> > + * local_timer_exit - called immediately after the interrupt vector
> > + * handler returns
> > + */
> > +DEFINE_IRQ_VECTOR_EVENT(local_timer_exit);
> 
> Looks like you can save on repeat code by doing the following:
> 
> #define DEFINE_IRQ_VECTOR_EVENT(name)		\
> DEFINE_EVENT_FN(x86_irq_vector, name##_entry,	\
> 	TP_PROTO(int vector),			\
> 	TP_ARGS(vector),			\
> 	trace_irq_vector_regfunc,		\
> 	trace_irq_vector_unregfunc);		\
> DEFINE_EVENT_FN(x86_irq_vector, name##_exit,	\
> 	TP_PROTO(int vector),			\
> 	TP_ARGS(vector),			\
> 	trace_irq_vector_regfunc,		\
> 	trace_irq_vector_unregfunc);		\
> 
> Then just do for each:
> 
> DEFINE_IRQ_VECTOR_EVENT(local_timer);
> 
> [...]
> 
> > +
> > +/*
> > + * reschedule_entry - called before entering a reschedule vector handler
> > + */
> > +DEFINE_IRQ_VECTOR_EVENT(reschedule_entry);
> > +
> > +/*
> > + * reschedule_exit - called immediately after the interrupt vector
> > + * handler returns
> > + */
> > +DEFINE_IRQ_VECTOR_EVENT(reschedule_exit);
> > +
> > +/*
> > + * spurious_apic_entry - called before entering a spurious apic vector handler
> > + */
> > +DEFINE_IRQ_VECTOR_EVENT(spurious_apic_entry);
> > +
> > +/*
> > + * spurious_apic_exit - called immediately after the interrupt vector
> > + * handler returns
> > + */
> > +DEFINE_IRQ_VECTOR_EVENT(spurious_apic_exit);
> > +
> > +/*
> > + * error_apic_entry - called before entering an error apic vector handler
> > + */
> > +DEFINE_IRQ_VECTOR_EVENT(error_apic_entry);
> > +
> > +/*
> > + * error_apic_exit - called immediately after the interrupt vector
> > + * handler returns
> > + */
> > +DEFINE_IRQ_VECTOR_EVENT(error_apic_exit);
> > +
> > +/*
> > + * x86_platform_ipi_entry - called before entering a x86 platform ipi interrupt
> > + * vector handler
> > + */
> > +DEFINE_IRQ_VECTOR_EVENT(x86_platform_ipi_entry);
> > +
> > +/*
> > + * x86_platform_ipi_exit - called immediately after the interrupt vector
> > + * handler returns
> > + */
> > +DEFINE_IRQ_VECTOR_EVENT(x86_platform_ipi_exit);
> > +
> > +/*
> > + * irq_work_entry - called before entering a irq work interrupt
> > + * vector handler
> > + */
> > +DEFINE_IRQ_VECTOR_EVENT(irq_work_entry);
> > +
> > +/*
> > + * irq_work_exit - called immediately after the interrupt vector
> > + * handler returns
> > + */
> > +DEFINE_IRQ_VECTOR_EVENT(irq_work_exit);
> > +
> > +/*
> > + * call_function_entry - called before entering a call function interrupt
> > + * vector handler
> > + */
> > +DEFINE_IRQ_VECTOR_EVENT(call_function_entry);
> > +
> > +/*
> > + * call_function_exit - called immediately after the interrupt vector
> > + * handler returns
> > + */
> > +DEFINE_IRQ_VECTOR_EVENT(call_function_exit);
> > +
> > +/*
> > + * call_function_single_entry - called before entering a call function
> > + * single interrupt vector handler
> > + */
> > +DEFINE_IRQ_VECTOR_EVENT(call_function_single_entry);
> > +
> > +/*
> > + * call_function_single_exit - called immediately after the interrupt vector
> > + * handler returns
> > + */
> > +DEFINE_IRQ_VECTOR_EVENT(call_function_single_exit);
> > +
> > +/*
> > + * threshold_apic_entry - called before entering a threshold apic interrupt
> > + * vector handler
> > + */
> > +DEFINE_IRQ_VECTOR_EVENT(threshold_apic_entry);
> > +
> > +/*
> > + * threshold_apic_exit - called immediately after the interrupt vector
> > + * handler returns
> > + */
> > +DEFINE_IRQ_VECTOR_EVENT(threshold_apic_exit);
> > +
> > +/*
> > + * thermal_apic_entry - called before entering a thermal apic interrupt
> > + * vector handler
> > + */
> > +DEFINE_IRQ_VECTOR_EVENT(thermal_apic_entry);
> > +
> > +/*
> > + * thrmal_apic_exit - called immediately after the interrupt vector
> > + * handler returns
> > + */
> > +DEFINE_IRQ_VECTOR_EVENT(thermal_apic_exit);
> > +
> > +#undef TRACE_INCLUDE_PATH
> > +#define TRACE_INCLUDE_PATH ../../arch/x86/include/asm/trace
> 
> Hmm, this is dangerous. It's better to use the Makefile.
> 
> here do:
> 
> #define TRACE_INCLUDE_PATH .
> 
> > +#define TRACE_INCLUDE_FILE irq_vectors
> > +#endif /*  _TRACE_IRQ_VECTORS_H */
> 
> Then in arch/x86/kernel/apic/Makefile:
> 
> CFLAGS_apic.o := -I$(src)
> 
> > +
> > +/* This part must be outside protection */
> > +#include <trace/define_trace.h>
> > +
> > diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
> > index 7bd3bd3..74b3891 100644
> > --- a/arch/x86/kernel/Makefile
> > +++ b/arch/x86/kernel/Makefile
> > @@ -102,6 +102,7 @@ obj-$(CONFIG_OF)			+= devicetree.o
> >  obj-$(CONFIG_UPROBES)			+= uprobes.o
> >
> >  obj-$(CONFIG_PERF_EVENTS)		+= perf_regs.o
> > +obj-$(CONFIG_TRACING)			+= tracepoint.o
> >
> >  ###
> >  # 64 bit specific files
> > diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
> > index 904611b..7d39c68 100644
> > --- a/arch/x86/kernel/apic/apic.c
> > +++ b/arch/x86/kernel/apic/apic.c
> > @@ -55,6 +55,9 @@
> >  #include <asm/tsc.h>
> >  #include <asm/hypervisor.h>
> >
> > +#define CREATE_TRACE_POINTS
> > +#include <asm/trace/irq_vectors.h>
> > +
> >  unsigned int num_processors;
> >
> >  unsigned disabled_cpus __cpuinitdata;
> > @@ -934,6 +937,30 @@ void __irq_entry smp_apic_timer_interrupt(struct pt_regs *regs)
> >  	set_irq_regs(old_regs);
> >  }
> >
> > +void __irq_entry smp_trace_apic_timer_interrupt(struct pt_regs *regs)
> > +{
> > +	struct pt_regs *old_regs = set_irq_regs(regs);
> > +
> > +	/*
> > +	 * NOTE! We'd better ACK the irq immediately,
> > +	 * because timer handling can be slow.
> > +	 */
> > +	ack_APIC_irq();
> > +	/*
> > +	 * update_process_times() expects us to have done irq_enter().
> > +	 * Besides, if we don't timer interrupts ignore the global
> > +	 * interrupt lock, which is the WrongThing (tm) to do.
> > +	 */
> > +	irq_enter();
> > +	exit_idle();
> > +	trace_local_timer_entry(LOCAL_TIMER_VECTOR);
> > +	local_apic_timer_interrupt();
> > +	trace_local_timer_exit(LOCAL_TIMER_VECTOR);
> > +	irq_exit();
> > +
> > +	set_irq_regs(old_regs);
> > +}
> > +
> >  int setup_profiling_timer(unsigned int multiplier)
> >  {
> >  	return -EINVAL;
> > @@ -1930,6 +1957,31 @@ void smp_spurious_interrupt(struct pt_regs *regs)
> >  	irq_exit();
> >  }
> >
> > +void smp_trace_spurious_interrupt(struct pt_regs *regs)
> > +{
> > +	u32 v;
> > +
> > +	irq_enter();
> > +	exit_idle();
> > +	trace_spurious_apic_entry(SPURIOUS_APIC_VECTOR);
> > +	/*
> > +	 * Check if this really is a spurious interrupt and ACK it
> > +	 * if it is a vectored one.  Just in case...
> > +	 * Spurious interrupts should not be ACKed.
> > +	 */
> > +	v = apic_read(APIC_ISR + ((SPURIOUS_APIC_VECTOR & ~0x1f) >> 1));
> > +	if (v & (1 << (SPURIOUS_APIC_VECTOR & 0x1f)))
> > +		ack_APIC_irq();
> > +
> > +	inc_irq_stat(irq_spurious_count);
> > +
> > +	/* see sw-dev-man vol 3, chapter 7.4.13.5 */
> > +	pr_info("spurious APIC interrupt on CPU#%d, "
> > +		"should never happen.\n", smp_processor_id());
> > +	trace_spurious_apic_exit(SPURIOUS_APIC_VECTOR);
> > +	irq_exit();
> > +}
> > +
> >  /*
> >   * This interrupt should never happen with our APIC/SMP architecture
> >   */
> > @@ -1973,6 +2025,48 @@ void smp_error_interrupt(struct pt_regs *regs)
> >  	irq_exit();
> >  }
> >
> > +void smp_trace_error_interrupt(struct pt_regs *regs)
> > +{
> > +	u32 v0, v1;
> > +	u32 i = 0;
> > +	static const char * const error_interrupt_reason[] = {
> > +		"Send CS error",		/* APIC Error Bit 0 */
> > +		"Receive CS error",		/* APIC Error Bit 1 */
> > +		"Send accept error",		/* APIC Error Bit 2 */
> > +		"Receive accept error",		/* APIC Error Bit 3 */
> > +		"Redirectable IPI",		/* APIC Error Bit 4 */
> > +		"Send illegal vector",		/* APIC Error Bit 5 */
> > +		"Received illegal vector",	/* APIC Error Bit 6 */
> > +		"Illegal register address",	/* APIC Error Bit 7 */
> > +	};
> > +
> > +	irq_enter();
> > +	exit_idle();
> > +	trace_error_apic_entry(ERROR_APIC_VECTOR);
> > +	/* First tickle the hardware, only then report what went on. -- REW */
> > +	v0 = apic_read(APIC_ESR);
> > +	apic_write(APIC_ESR, 0);
> > +	v1 = apic_read(APIC_ESR);
> > +	ack_APIC_irq();
> > +	atomic_inc(&irq_err_count);
> > +
> > +	apic_printk(APIC_DEBUG, KERN_DEBUG "APIC error on CPU%d: %02x(%02x)",
> > +		    smp_processor_id(), v0 , v1);
> > +
> > +	v1 = v1 & 0xff;
> > +	while (v1) {
> > +		if (v1 & 0x1)
> > +			apic_printk(APIC_DEBUG, KERN_CONT " : %s", error_interrupt_reason[i]);
> > +		i++;
> > +		v1 >>= 1;
> > +	}
> > +
> > +	apic_printk(APIC_DEBUG, KERN_CONT "\n");
> > +
> > +	trace_error_apic_exit(ERROR_APIC_VECTOR);
> > +	irq_exit();
> > +}
> > +
> >  /**
> >   * connect_bsp_APIC - attach the APIC to the interrupt system
> >   */
> > diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
> > index d814772..23045cd 100644
> > --- a/arch/x86/kernel/cpu/common.c
> > +++ b/arch/x86/kernel/cpu/common.c
> > @@ -1144,7 +1144,7 @@ int is_debug_stack(unsigned long addr)
> >  		 addr > (__get_cpu_var(debug_stack_addr) - DEBUG_STKSZ));
> >  }
> >
> > -static DEFINE_PER_CPU(u32, debug_stack_use_ctr);
> > +DEFINE_PER_CPU(u32, debug_stack_use_ctr);
> >
> >  void debug_stack_set_zero(void)
> >  {
> > @@ -1156,8 +1156,14 @@ void debug_stack_reset(void)
> >  {
> >  	if (WARN_ON(!this_cpu_read(debug_stack_use_ctr)))
> >  		return;
> > -	if (this_cpu_dec_return(debug_stack_use_ctr) == 0)
> > -		load_idt((const struct desc_ptr *)&idt_descr);
> > +	if (this_cpu_dec_return(debug_stack_use_ctr) == 0) {
> > +#ifdef CONFIG_TRACING
> > +		if (this_cpu_read(trace_idt_in_use))
> > +			load_idt((const struct desc_ptr *)&trace_idt_descr);
> > +		else
> > +#endif
> > +			load_idt((const struct desc_ptr *)&idt_descr);
> > +	}
> 
> I have a patch that makes this more generic. I'm wondering if that would
> be better than having everything so coupled.
> 
> >  }
> >
> >  #else	/* CONFIG_X86_64 */
> > diff --git a/arch/x86/kernel/cpu/mcheck/therm_throt.c b/arch/x86/kernel/cpu/mcheck/therm_throt.c
> > index 47a1870..e7aa7fc 100644
> > --- a/arch/x86/kernel/cpu/mcheck/therm_throt.c
> > +++ b/arch/x86/kernel/cpu/mcheck/therm_throt.c
> > @@ -29,6 +29,7 @@
> >  #include <asm/idle.h>
> >  #include <asm/mce.h>
> >  #include <asm/msr.h>
> > +#include <asm/trace/irq_vectors.h>
> >
> >  /* How long to wait between reporting thermal events */
> >  #define CHECK_INTERVAL		(300 * HZ)
> > @@ -389,6 +390,19 @@ asmlinkage void smp_thermal_interrupt(struct pt_regs *regs)
> >  	ack_APIC_irq();
> >  }
> >
> > +asmlinkage void smp_trace_thermal_interrupt(struct pt_regs *regs)
> > +{
> > +	irq_enter();
> > +	exit_idle();
> > +	trace_thermal_apic_entry(THERMAL_APIC_VECTOR);
> > +	inc_irq_stat(irq_thermal_count);
> > +	smp_thermal_vector();
> > +	trace_thermal_apic_exit(THERMAL_APIC_VECTOR);
> > +	irq_exit();
> > +	/* Ack only at the end to avoid potential reentry */
> > +	ack_APIC_irq();
> > +}
> > +
> >  /* Thermal monitoring depends on APIC, ACPI and clock modulation */
> >  static int intel_thermal_supported(struct cpuinfo_x86 *c)
> >  {
> > diff --git a/arch/x86/kernel/cpu/mcheck/threshold.c b/arch/x86/kernel/cpu/mcheck/threshold.c
> > index aa578ca..0cbef99 100644
> > --- a/arch/x86/kernel/cpu/mcheck/threshold.c
> > +++ b/arch/x86/kernel/cpu/mcheck/threshold.c
> > @@ -8,6 +8,7 @@
> >  #include <asm/apic.h>
> >  #include <asm/idle.h>
> >  #include <asm/mce.h>
> > +#include <asm/trace/irq_vectors.h>
> >
> >  static void default_threshold_interrupt(void)
> >  {
> > @@ -27,3 +28,16 @@ asmlinkage void smp_threshold_interrupt(void)
> >  	/* Ack only at the end to avoid potential reentry */
> >  	ack_APIC_irq();
> >  }
> > +
> > +asmlinkage void smp_trace_threshold_interrupt(void)
> > +{
> > +	irq_enter();
> > +	exit_idle();
> > +	trace_threshold_apic_entry(THRESHOLD_APIC_VECTOR);
> > +	inc_irq_stat(irq_threshold_count);
> > +	mce_threshold_vector();
> > +	trace_threshold_apic_exit(THRESHOLD_APIC_VECTOR);
> > +	irq_exit();
> > +	/* Ack only at the end to avoid potential reentry */
> > +	ack_APIC_irq();
> > +}
> > diff --git a/arch/x86/kernel/entry_32.S b/arch/x86/kernel/entry_32.S
> > index 8f3e2de..2cfbc3a 100644
> > --- a/arch/x86/kernel/entry_32.S
> > +++ b/arch/x86/kernel/entry_32.S
> > @@ -801,7 +801,17 @@ ENTRY(name)				\
> >  	CFI_ENDPROC;			\
> >  ENDPROC(name)
> >
> > -#define BUILD_INTERRUPT(name, nr)	BUILD_INTERRUPT3(name, nr, smp_##name)
> > +
> > +#ifdef CONFIG_TRACING
> > +#define TRACE_BUILD_INTERRUPT(name, nr)		\
> > +	BUILD_INTERRUPT3(trace_##name, nr, smp_trace_##name)
> > +#else
> > +#define TRACE_BUILD_INTERRUPT(name, nr)
> > +#endif
> > +
> > +#define BUILD_INTERRUPT(name, nr) \
> > +	BUILD_INTERRUPT3(name, nr, smp_##name); \
> > +	TRACE_BUILD_INTERRUPT(name, nr)
> >
> >  /* The include is where all of the SMP etc. interrupts come from */
> >  #include <asm/entry_arch.h>
> > diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
> > index c1d01e6..4570477 100644
> > --- a/arch/x86/kernel/entry_64.S
> > +++ b/arch/x86/kernel/entry_64.S
> > @@ -1138,7 +1138,7 @@ END(common_interrupt)
> >  /*
> >   * APIC interrupts.
> >   */
> > -.macro apicinterrupt num sym do_sym
> > +.macro apicinterrupt3 num sym do_sym
> >  ENTRY(\sym)
> >  	INTR_FRAME
> >  	ASM_CLAC
> > @@ -1150,15 +1150,32 @@ ENTRY(\sym)
> >  END(\sym)
> >  .endm
> >
> > +#ifdef CONFIG_TRACING
> > +#define trace(sym) trace_##sym
> > +#define smp_trace(sym) smp_trace_##sym
> > +
> > +.macro trace_apicinterrupt num sym
> > +apicinterrupt3 \num trace(\sym) smp_trace(\sym)
> > +.endm
> > +#else
> > +.macro trace_apicinterrupt num sym do_sym
> > +.endm
> > +#endif
> > +
> > +.macro apicinterrupt num sym do_sym
> > +apicinterrupt3 \num \sym \do_sym
> > +trace_apicinterrupt \num \sym
> > +.endm
> > +
> >  #ifdef CONFIG_SMP
> > -apicinterrupt IRQ_MOVE_CLEANUP_VECTOR \
> > +apicinterrupt3 IRQ_MOVE_CLEANUP_VECTOR \
> >  	irq_move_cleanup_interrupt smp_irq_move_cleanup_interrupt
> > -apicinterrupt REBOOT_VECTOR \
> > +apicinterrupt3 REBOOT_VECTOR \
> >  	reboot_interrupt smp_reboot_interrupt
> >  #endif
> >
> >  #ifdef CONFIG_X86_UV
> > -apicinterrupt UV_BAU_MESSAGE \
> > +apicinterrupt3 UV_BAU_MESSAGE \
> >  	uv_bau_message_intr1 uv_bau_message_interrupt
> >  #endif
> >  apicinterrupt LOCAL_TIMER_VECTOR \
> > @@ -1446,13 +1463,13 @@ ENTRY(xen_failsafe_callback)
> >  	CFI_ENDPROC
> >  END(xen_failsafe_callback)
> >
> > -apicinterrupt HYPERVISOR_CALLBACK_VECTOR \
> > +apicinterrupt3 HYPERVISOR_CALLBACK_VECTOR \
> >  	xen_hvm_callback_vector xen_evtchn_do_upcall
> >
> >  #endif /* CONFIG_XEN */
> >
> >  #if IS_ENABLED(CONFIG_HYPERV)
> > -apicinterrupt HYPERVISOR_CALLBACK_VECTOR \
> > +apicinterrupt3 HYPERVISOR_CALLBACK_VECTOR \
> >  	hyperv_callback_vector hyperv_vector_handler
> >  #endif /* CONFIG_HYPERV */
> >
> > diff --git a/arch/x86/kernel/head_64.S b/arch/x86/kernel/head_64.S
> > index 6859e96..e827e67 100644
> > --- a/arch/x86/kernel/head_64.S
> > +++ b/arch/x86/kernel/head_64.S
> > @@ -518,6 +518,12 @@ ENTRY(idt_table)
> >  ENTRY(nmi_idt_table)
> >  	.skip IDT_ENTRIES * 16
> >
> > +#ifdef CONFIG_TRACING
> > +	.align L1_CACHE_BYTES
> > +ENTRY(trace_idt_table)
> > +	.skip IDT_ENTRIES * 16
> > +#endif
> > +
> >  	__PAGE_ALIGNED_BSS
> >  NEXT_PAGE(empty_zero_page)
> >  	.skip PAGE_SIZE
> > diff --git a/arch/x86/kernel/irq.c b/arch/x86/kernel/irq.c
> > index e4595f1..216bec1 100644
> > --- a/arch/x86/kernel/irq.c
> > +++ b/arch/x86/kernel/irq.c
> > @@ -17,6 +17,7 @@
> >  #include <asm/idle.h>
> >  #include <asm/mce.h>
> >  #include <asm/hw_irq.h>
> > +#include <asm/trace/irq_vectors.h>
> >
> >  atomic_t irq_err_count;
> >
> > @@ -228,6 +229,28 @@ void smp_x86_platform_ipi(struct pt_regs *regs)
> >  	set_irq_regs(old_regs);
> >  }
> >
> > +void smp_trace_x86_platform_ipi(struct pt_regs *regs)
> > +{
> > +	struct pt_regs *old_regs = set_irq_regs(regs);
> > +
> > +	ack_APIC_irq();
> > +
> > +	irq_enter();
> > +
> > +	exit_idle();
> > +
> > +	trace_x86_platform_ipi_entry(X86_PLATFORM_IPI_VECTOR);
> > +	inc_irq_stat(x86_platform_ipis);
> > +
> > +	if (x86_platform_ipi_callback)
> > +		x86_platform_ipi_callback();
> > +
> > +	trace_x86_platform_ipi_exit(X86_PLATFORM_IPI_VECTOR);
> > +	irq_exit();
> > +
> > +	set_irq_regs(old_regs);
> > +}
> > +
> >  EXPORT_SYMBOL_GPL(vector_used_by_percpu_irq);
> >
> >  #ifdef CONFIG_HOTPLUG_CPU
> > diff --git a/arch/x86/kernel/irq_work.c b/arch/x86/kernel/irq_work.c
> > index ca8f703..09e6262 100644
> > --- a/arch/x86/kernel/irq_work.c
> > +++ b/arch/x86/kernel/irq_work.c
> > @@ -8,6 +8,7 @@
> >  #include <linux/irq_work.h>
> >  #include <linux/hardirq.h>
> >  #include <asm/apic.h>
> > +#include <asm/trace/irq_vectors.h>
> >
> >  void smp_irq_work_interrupt(struct pt_regs *regs)
> >  {
> > @@ -18,6 +19,17 @@ void smp_irq_work_interrupt(struct pt_regs *regs)
> >  	irq_exit();
> >  }
> >
> > +void smp_trace_irq_work_interrupt(struct pt_regs *regs)
> > +{
> > +	irq_enter();
> > +	ack_APIC_irq();
> > +	trace_irq_work_entry(IRQ_WORK_VECTOR);
> > +	inc_irq_stat(apic_irq_work_irqs);
> > +	irq_work_run();
> > +	trace_irq_work_exit(IRQ_WORK_VECTOR);
> > +	irq_exit();
> > +}
> > +
> >  void arch_irq_work_raise(void)
> >  {
> >  #ifdef CONFIG_X86_LOCAL_APIC
> > diff --git a/arch/x86/kernel/smp.c b/arch/x86/kernel/smp.c
> > index 48d2b7d..aad58af 100644
> > --- a/arch/x86/kernel/smp.c
> > +++ b/arch/x86/kernel/smp.c
> > @@ -30,6 +30,7 @@
> >  #include <asm/proto.h>
> >  #include <asm/apic.h>
> >  #include <asm/nmi.h>
> > +#include <asm/trace/irq_vectors.h>
> >  /*
> >   *	Some notes on x86 processor bugs affecting SMP operation:
> >   *
> > @@ -259,6 +260,18 @@ void smp_reschedule_interrupt(struct pt_regs *regs)
> >  	 */
> >  }
> >
> > +void smp_trace_reschedule_interrupt(struct pt_regs *regs)
> > +{
> > +	ack_APIC_irq();
> > +	trace_reschedule_entry(RESCHEDULE_VECTOR);
> > +	inc_irq_stat(irq_resched_count);
> > +	scheduler_ipi();
> > +	trace_reschedule_exit(RESCHEDULE_VECTOR);
> > +	/*
> > +	 * KVM uses this interrupt to force a cpu out of guest mode
> > +	 */
> > +}
> > +
> >  void smp_call_function_interrupt(struct pt_regs *regs)
> >  {
> >  	ack_APIC_irq();
> > @@ -268,6 +281,17 @@ void smp_call_function_interrupt(struct pt_regs *regs)
> >  	irq_exit();
> >  }
> >
> > +void smp_trace_call_function_interrupt(struct pt_regs *regs)
> > +{
> > +	ack_APIC_irq();
> > +	irq_enter();
> > +	trace_call_function_entry(CALL_FUNCTION_VECTOR);
> > +	generic_smp_call_function_interrupt();
> > +	inc_irq_stat(irq_call_count);
> > +	trace_call_function_exit(CALL_FUNCTION_VECTOR);
> > +	irq_exit();
> > +}
> > +
> >  void smp_call_function_single_interrupt(struct pt_regs *regs)
> >  {
> >  	ack_APIC_irq();
> > @@ -277,6 +301,17 @@ void smp_call_function_single_interrupt(struct pt_regs *regs)
> >  	irq_exit();
> >  }
> >
> > +void smp_trace_call_function_single_interrupt(struct pt_regs *regs)
> > +{
> > +	ack_APIC_irq();
> > +	irq_enter();
> > +	trace_call_function_single_entry(CALL_FUNCTION_SINGLE_VECTOR);
> > +	generic_smp_call_function_single_interrupt();
> > +	inc_irq_stat(irq_call_count);
> > +	trace_call_function_single_exit(CALL_FUNCTION_SINGLE_VECTOR);
> > +	irq_exit();
> > +}
> > +
> >  static int __init nonmi_ipi_setup(char *str)
> >  {
> >  	smp_no_nmi_ipi = true;
> > diff --git a/arch/x86/kernel/tracepoint.c b/arch/x86/kernel/tracepoint.c
> > new file mode 100644
> > index 0000000..3403dc3
> > --- /dev/null
> > +++ b/arch/x86/kernel/tracepoint.c
> > @@ -0,0 +1,71 @@
> > +/*
> > + * Code for supporting irq vector tracepoints.
> > + *
> > + * Copyright (C) 2013 Seiji Aguchi <seiji.aguchi@hds.com>
> > + *
> > + */
> > +#include <asm/hw_irq.h>
> > +#include <asm/desc.h>
> > +
> > +struct desc_ptr trace_idt_descr = { NR_VECTORS * 16 - 1,
> > +				(unsigned long) trace_idt_table };
> > +
> > +#ifndef CONFIG_X86_64
> > +gate_desc trace_idt_table[NR_VECTORS] __page_aligned_data
> > +					= { { { { 0, 0 } } }, };
> > +#endif
> > +
> > +static int trace_irq_vector_refcount;
> > +static DEFINE_MUTEX(irq_vector_mutex);
> > +DEFINE_PER_CPU(u32, trace_idt_in_use);
> > +
> > +static void switch_to_trace_idt(void *arg)
> > +{
> > +
> > +	this_cpu_inc(trace_idt_in_use);
> > +	load_idt(&trace_idt_descr);
> > +
> > +	return;
> > +}
> > +
> > +static void restore_original_idt(void *arg)
> > +{
> > +	if (WARN_ON(!this_cpu_read(trace_idt_in_use)))
> > +		return;
> > +	this_cpu_dec(trace_idt_in_use);
> > +
> > +#ifdef CONFIG_X86_64
> > +	if (this_cpu_read(debug_stack_use_ctr))
> > +		load_idt(&nmi_idt_descr);
> > +	else
> > +#endif
> 
> This is unneeded, as debug_stack_use_ctr should never be set here. It
> only gets set when interrupts are disabled and cleared before they are
> enabled again, and this is called from interrupt context. If it is set,
> then it is truly a bug.
> 
> Only NMIs themselves can see this set, if it wasn't the one to set it.
> 
> > +		load_idt(&idt_descr);
> > +	return;
> > +}
> > +
> > +void trace_irq_vector_regfunc(void)
> > +{
> > +	mutex_lock(&irq_vector_mutex);
> > +	if (!trace_irq_vector_refcount) {
> > +		smp_call_function(switch_to_trace_idt, NULL, 0);
> > +		local_irq_disable();
> > +		switch_to_trace_idt(NULL);
> > +		local_irq_enable();
> > +	}
> > +	trace_irq_vector_refcount++;
> > +	mutex_unlock(&irq_vector_mutex);
> > +}
> > +
> > +void trace_irq_vector_unregfunc(void)
> > +{
> > +	mutex_lock(&irq_vector_mutex);
> > +	trace_irq_vector_refcount--;
> > +	if (!trace_irq_vector_refcount) {
> 
> Hmm, this needs to handle cpu hotplug. I just did the following:
> 
> echo 0 > /sys/devices/system/cpu/cpu3/online
> echo 1 > /debug/tracing/events/irq_vectors/enable
> echo 1 > /sys/devices/systems/cpu/cpu3/online
> echo 0 > /debug/tracing/events/irq/vectors/enable
> 
> and got this:
> 
> [  224.595931] ------------[ cut here ]------------
> [  224.596928] WARNING: at /home/rostedt/work/git/linux-trace.git/arch/x86/kernel/tracepoint.c:33 restore_original_idt+0x26/0x4e()
> [  224.596928] Modules linked in: ebtables ipt_MASQUERADE sunrpc bridge stp llc ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6
> ip6table_filter ip6_tables ipv6 uinput snd_hda_codec_idt snd_hda_intel snd_hda_codec kvm_intel snd_hwdep snd_seq kvm
> snd_seq_device snd_pcm snd_timer snd soundcore snd_page_alloc shpchp microcode i2c_i801 pata_acpi firewire_ohci firewire_core
> crc_itu_t ata_generic i915 drm_kms_helper drm i2c_algo_bit i2c_core video
> [  224.596928] CPU: 3 PID: 0 Comm: swapper/3 Not tainted 3.10.0-rc2-test+ #137
> [  224.596928] Hardware name: To Be Filled By O.E.M. To Be Filled By O.E.M./To be filled by O.E.M., BIOS SDBLI944.86P 05/08/2007
> [  224.596928]  ffffffff817c948b ffff88007d583ef8 ffffffff814c9ec6 ffff88007d583f38
> [  224.596928]  ffffffff810363a5 ffff88007d5971b8 0000000000000000 ffff88007d5971b8
> [  224.596928]  ffff88007d583f68 0000000000000001 0000000000000000 ffff88007d583f48
> [  224.596928] Call Trace:
> [  224.596928]  <IRQ>  [<ffffffff814c9ec6>] dump_stack+0x19/0x1b
> [  224.596928]  [<ffffffff810363a5>] warn_slowpath_common+0x67/0x80
> [  224.596928]  [<ffffffff810363d8>] warn_slowpath_null+0x1a/0x1c
> [  224.596928]  [<ffffffff8102864c>] restore_original_idt+0x26/0x4e
> [  224.596928]  [<ffffffff8108bd52>] generic_smp_call_function_single_interrupt+0xb5/0xee
> [  224.596928]  [<ffffffff8101f500>] smp_call_function_interrupt+0x18/0x27
> [  224.596928]  [<ffffffff814d646f>] call_function_interrupt+0x6f/0x80
> [  224.596928]  <EOI>  [<ffffffff81009727>] ? default_idle+0x21/0x32
> [  224.596928]  [<ffffffff81009725>] ? default_idle+0x1f/0x32
> [  224.596928]  [<ffffffff81009e37>] arch_cpu_idle+0x18/0x22
> [  224.596928]  [<ffffffff810799da>] cpu_startup_entry+0xc8/0x12e
> [  224.596928]  [<ffffffff814bc6ad>] start_secondary+0x250/0x257
> 
> -- Steve
> 
> 
> > +		smp_call_function(restore_original_idt, NULL, 0);
> > +		local_irq_disable();
> > +		restore_original_idt(NULL);
> > +		local_irq_enable();
> > +	}
> > +	mutex_unlock(&irq_vector_mutex);
> > +}
> > +
> > diff --git a/include/xen/events.h b/include/xen/events.h
> > index c6bfe01..9216d07 100644
> > --- a/include/xen/events.h
> > +++ b/include/xen/events.h
> > @@ -76,6 +76,9 @@ unsigned irq_from_evtchn(unsigned int evtchn);
> >
> >  /* Xen HVM evtchn vector callback */
> >  void xen_hvm_callback_vector(void);
> > +#ifdef CONFIG_TRACING
> > +#define trace_xen_hvm_callback_vector xen_hvm_callback_vector
> > +#endif
> >  extern int xen_have_vector_callback;
> >  int xen_set_callback_via(uint64_t via);
> >  void xen_evtchn_do_upcall(struct pt_regs *regs);
> 

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
