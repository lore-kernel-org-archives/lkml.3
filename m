Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757213Ab3APBZe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 20:25:34 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:20057 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756264Ab3APBZc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 20:25:32 -0500
X-Authority-Analysis: v=2.0 cv=UsXhxpMB c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=upmiaRri9ugA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=vw99MyFtH44A:10 a=6n3r0VZ_rVv3qROvMsUA:9 a=PUjeQqilurYA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1358299528.4068.38.camel@gandalf.local.home>
Subject: Re: [RFC][PATCH v7 1/2] trace,x86: add x86 irq vector tracepoints
From: Steven Rostedt <rostedt@goodmis.org>
To: Seiji Aguchi <seiji.aguchi@hds.com>
Cc: "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin (hpa@zytor.com)" <hpa@zytor.com>,
        "Thomas Gleixner (tglx@linutronix.de)" <tglx@linutronix.de>,
        "'mingo@elte.hu' (mingo@elte.hu)" <mingo@elte.hu>,
        "Borislav Petkov (bp@alien8.de)" <bp@alien8.de>,
        Satoru Moriya <satoru.moriya@hds.com>,
        "dle-develop@lists.sourceforge.net" 
	<dle-develop@lists.sourceforge.net>,
        "linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>,
        "Luck, Tony (tony.luck@intel.com)" <tony.luck@intel.com>
Date: Tue, 15 Jan 2013 20:25:28 -0500
In-Reply-To: <A5ED84D3BB3A384992CBB9C77DEDA4D414A3D281@USINDEM103.corp.hds.com>
References: <A5ED84D3BB3A384992CBB9C77DEDA4D414A3D281@USINDEM103.corp.hds.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-01-10 at 17:33 +0000, Seiji Aguchi wrote:

> diff --git a/arch/x86/include/asm/trace/irq_vectors.h b/arch/x86/include/asm/trace/irq_vectors.h
> new file mode 100644
> index 0000000..9bcb27b
> --- /dev/null
> +++ b/arch/x86/include/asm/trace/irq_vectors.h
> @@ -0,0 +1,154 @@
> +#undef TRACE_SYSTEM
> +#define TRACE_SYSTEM irq_vectors
> +
> +#if !defined(_TRACE_IRQ_VECTORS_H) || defined(TRACE_HEADER_MULTI_READ)
> +#define _TRACE_IRQ_VECTORS_H
> +
> +#include <linux/tracepoint.h>
> +
> +extern void trace_irq_vector_regfunc(void);
> +extern void trace_irq_vector_unregfunc(void);
> +
> +#define DECLARE_IRQ_VECTOR_EVENT(name)				\
> +TRACE_EVENT_FN(name,						\
> +	TP_PROTO(int vector),					\
> +								\
> +	TP_ARGS(vector),					\
> +								\
> +	TP_STRUCT__entry(					\
> +		__field(	int,	vector	)		\
> +	),							\
> +								\
> +	TP_fast_assign(						\
> +		__entry->vector = vector;			\
> +	),							\
> +								\
> +	TP_printk("vector=%d", __entry->vector),		\
> +	trace_irq_vector_regfunc, trace_irq_vector_unregfunc	\
> +);
> +
> +/*
> + * local_timer_entry - called before entering a local timer interrupt
> + * vector handler
> + */
> +DECLARE_IRQ_VECTOR_EVENT(local_timer_entry)

This is a great big waste of space. Add the below patch to your series
and then just do:

DECLARE_EVENT_CLASS(x86_irq_vector,

	TP_PROTO(int vector),

	TP_ARGS(vector),

	TP_STRUCT__entry(
		__field(		int,	vector	)
	),

	TP_fast_assign(
		__entry->vector = vector;
	),

	TP_printk("vector=%d", __entry->vector)
);

#define DEFINE_IRQ_VECTOR_EVENT(name) \	
DEFINE_EVENT_FN(name, \
	TP_PROTO(int vector), \
	TP_ARGS(vector), \
	trace_irq_vector_regfunc, \
	trace_irq_vector_unregfunc);

And keep the rest the same.

> +
> +/*
> + * local_timer_exit - called immediately after the interrupt vector
> + * handler returns
> + */
> +DECLARE_IRQ_VECTOR_EVENT(local_timer_exit)
> +
> +/*
> + * reschedule_entry - called before entering a reschedule vector handler
> + */
> +DECLARE_IRQ_VECTOR_EVENT(reschedule_entry)
> +
> +/*
> + * reschedule_exit - called immediately after the interrupt vector
> + * handler returns
> + */
> +DECLARE_IRQ_VECTOR_EVENT(reschedule_exit)
> +
> +/*
> + * spurious_apic_entry - called before entering a spurious apic vector handler
> + */
> +DECLARE_IRQ_VECTOR_EVENT(spurious_apic_entry)
> +
> +/*
> + * spurious_apic_exit - called immediately after the interrupt vector
> + * handler returns
> + */
> +DECLARE_IRQ_VECTOR_EVENT(spurious_apic_exit)
> +
> +/*
> + * error_apic_entry - called before entering an error apic vector handler
> + */
> +DECLARE_IRQ_VECTOR_EVENT(error_apic_entry)
> +
> +/*
> + * error_apic_exit - called immediately after the interrupt vector
> + * handler returns
> + */
> +DECLARE_IRQ_VECTOR_EVENT(error_apic_exit)
> +
> +/*
> + * x86_platform_ipi_entry - called before entering a x86 platform ipi interrupt
> + * vector handler
> + */
> +DECLARE_IRQ_VECTOR_EVENT(x86_platform_ipi_entry)
> +
> +/*
> + * x86_platform_ipi_exit - called immediately after the interrupt vector
> + * handler returns
> + */
> +DECLARE_IRQ_VECTOR_EVENT(x86_platform_ipi_exit)
> +
> +/*
> + * irq_work_entry - called before entering a irq work interrupt
> + * vector handler
> + */
> +DECLARE_IRQ_VECTOR_EVENT(irq_work_entry)
> +
> +/*
> + * irq_work_exit - called immediately after the interrupt vector
> + * handler returns
> + */
> +DECLARE_IRQ_VECTOR_EVENT(irq_work_exit)
> +
> +/*
> + * call_function_entry - called before entering a call function interrupt
> + * vector handler
> + */
> +DECLARE_IRQ_VECTOR_EVENT(call_function_entry)
> +
> +/*
> + * call_function_exit - called immediately after the interrupt vector
> + * handler returns
> + */
> +DECLARE_IRQ_VECTOR_EVENT(call_function_exit)
> +
> +/*
> + * call_function_single_entry - called before entering a call function
> + * single interrupt vector handler
> + */
> +DECLARE_IRQ_VECTOR_EVENT(call_function_single_entry)
> +
> +/*
> + * call_function_single_exit - called immediately after the interrupt vector
> + * handler returns
> + */
> +DECLARE_IRQ_VECTOR_EVENT(call_function_single_exit)
> +
> +/*
> + * threshold_apic_entry - called before entering a threshold apic interrupt
> + * vector handler
> + */
> +DECLARE_IRQ_VECTOR_EVENT(threshold_apic_entry)
> +
> +/*
> + * threshold_apic_exit - called immediately after the interrupt vector
> + * handler returns
> + */
> +DECLARE_IRQ_VECTOR_EVENT(threshold_apic_exit)
> +
> +/*
> + * thermal_apic_entry - called before entering a thermal apic interrupt
> + * vector handler
> + */
> +DECLARE_IRQ_VECTOR_EVENT(thermal_apic_entry)
> +
> +/*
> + * thrmal_apic_exit - called immediately after the interrupt vector
> + * handler returns
> + */
> +DECLARE_IRQ_VECTOR_EVENT(thermal_apic_exit)
> +
> +#undef TRACE_INCLUDE_PATH
> +#define TRACE_INCLUDE_PATH ../../arch/x86/include/asm/trace
> +#define TRACE_INCLUDE_FILE irq_vectors
> +#endif /*  _TRACE_IRQ_VECTORS_H */
> +
> +/* This part must be outside protection */
> +#include <trace/define_trace.h>
> +

---
tracing: Add DEFINE_EVENT_FN() macro

Each TRACE_EVENT() adds several helper functions. If two or more trace
events share the same structure and print format, they can also share
most of these helper functions and save a lot of space from duplicate
code. This is why the DECLARE_EVENT_CLASS() and DEFINE_EVENT() were
created.

Some events require a trigger to be called at registering and
unregistering of the event and to do so they use TRACE_EVENT_FN().

If multiple events require a trigger, they currently have no choice but
to use TRACE_EVENT_FN() as there's no DEFINE_EVENT_FN() available. This
unfortunately causes a lot of wasted duplicate code created.

By adding a DEFINE_EVENT_FN(), these events can still use a
DECLARE_EVENT_CLASS() and then define their own triggers.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

diff --git a/include/linux/tracepoint.h b/include/linux/tracepoint.h
index 2f322c3..9bf59e5 100644
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
index 40dc5e8..7bab676 100644
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


