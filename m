Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754043AbaEFTQi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 15:16:38 -0400
Received: from mail.efficios.com ([78.47.125.74]:37151 "EHLO mail.efficios.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751425AbaEFTQg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 15:16:36 -0400
Date: Tue, 6 May 2014 19:16:34 +0000 (UTC)
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Javi Merino <javi.merino@arm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>
Message-ID: <484888063.12149.1399403794855.JavaMail.zimbra@efficios.com>
In-Reply-To: <20140506132238.22e136d1@gandalf.local.home>
References: <1399377998-14870-1-git-send-email-javi.merino@arm.com> <1399377998-14870-6-git-send-email-javi.merino@arm.com> <20140506132238.22e136d1@gandalf.local.home>
Subject: Re: [RFC][PATCH] tracing: Add __cpumask() macro to trace events to
 record cpumasks
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [206.248.138.119]
X-Mailer: Zimbra 8.0.5_GA_5839 (ZimbraWebClient - FF29 (Linux)/8.0.5_GA_5839)
Thread-Topic: tracing: Add __cpumask() macro to trace events to record cpumasks
Thread-Index: obqpxlX2arDPDShBPmDH0JRh8XpmVQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

----- Original Message -----
> From: "Steven Rostedt" <rostedt@goodmis.org>
> To: "LKML" <linux-kernel@vger.kernel.org>
> Cc: "Javi Merino" <javi.merino@arm.com>, "Andrew Morton" <akpm@linux-foundation.org>, "Mathieu Desnoyers"
> <mathieu.desnoyers@efficios.com>, "Ingo Molnar" <mingo@kernel.org>, "Namhyung Kim" <namhyung@kernel.org>, "Jiri
> Olsa" <jolsa@redhat.com>
> Sent: Tuesday, May 6, 2014 1:22:38 PM
> Subject: [RFC][PATCH] tracing: Add __cpumask() macro to trace events to record cpumasks
> 
> 
> Being able to show a cpumask of events can be useful as some events
> may affect only some CPUs. There is no standard way to record the
> cpumask and converting it to a string is rather expensive during
> the trace as traces happen in hotpaths. It would be better to record
> the raw event mask and be able to parse it at print time.

Why name the type cpumask especially ? The type could be a "bitmask",
and the specific field semantic in this case (field name) could
be "cpus", thus implying that this is a cpu mask. This would allow
using bitmasks for other things than cpu masks.

Moreover, I've been thinking about eventually adding a bitmask associated
with an enumeration, so each bit of the bitmask could be associated with
an entry from an enumeration (a string). So having a bitmask type would
be a good step in that direction. For instance, the block layer
instrumentation could use this for the rwbs field, instead of
printing characters with blk_fill_rwbs(). This would save space and
cpu time at trace collection.

Thoughts ?

Thanks,

Mathieu


> 
> The following macros were added for use with the TRACE_EVENT() macro:
> 
>   __cpumask()
>   __assign_cpumask()
>   __get_cpumask()
> 
> To test this, I added this to the sched_migrate_task event, which
> looked like this:
> 
> TRACE_EVENT(sched_migrate_task,
> 
> 	TP_PROTO(struct task_struct *p, int dest_cpu, const struct cpumask *cpus),
> 
> 	TP_ARGS(p, dest_cpu, cpus),
> 
> 	TP_STRUCT__entry(
> 		__array(	char,	comm,	TASK_COMM_LEN	)
> 		__field(	pid_t,	pid			)
> 		__field(	int,	prio			)
> 		__field(	int,	orig_cpu		)
> 		__field(	int,	dest_cpu		)
> 		__cpumask(	cpumask, cpus			)
> 	),
> 
> 	TP_fast_assign(
> 		memcpy(__entry->comm, p->comm, TASK_COMM_LEN);
> 		__entry->pid		= p->pid;
> 		__entry->prio		= p->prio;
> 		__entry->orig_cpu	= task_cpu(p);
> 		__entry->dest_cpu	= dest_cpu;
> 		__assign_cpumask(cpumask, cpus);
> 	),
> 
> 	TP_printk("comm=%s pid=%d prio=%d orig_cpu=%d dest_cpu=%d cpumask=%s",
> 		  __entry->comm, __entry->pid, __entry->prio,
> 		  __entry->orig_cpu, __entry->dest_cpu,
> 		  __get_cpumask(cpumask))
> );
> 
> With the output of:
> 
>         ksmtuned-3613  [003] d..2   485.220508: sched_migrate_task:
>         comm=ksmtuned pid=3615 prio=120 orig_cpu=3 dest_cpu=2
>         cpumask=00000000,0000000f
>      migration/1-13    [001] d..5   485.221202: sched_migrate_task:
>      comm=ksmtuned pid=3614 prio=120 orig_cpu=1 dest_cpu=0
>      cpumask=00000000,0000000f
>              awk-3615  [002] d.H5   485.221747: sched_migrate_task:
>              comm=rcu_preempt pid=7 prio=120 orig_cpu=0 dest_cpu=1
>              cpumask=00000000,000000ff
>      migration/2-18    [002] d..5   485.222062: sched_migrate_task:
>      comm=ksmtuned pid=3615 prio=120 orig_cpu=2 dest_cpu=3
>      cpumask=00000000,0000000f
> 
> Link:
> http://lkml.kernel.org/r/1399377998-14870-6-git-send-email-javi.merino@arm.com
> 
> Suggested-by: Javi Merino <javi.merino@arm.com>
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> ---
> 
> Note, the tools/lib/traceevent will need to be updated to handle the
> new __get_cpumask() macro in the TP_printk().
> 
> ---
>  include/linux/ftrace_event.h |  4 ++++
>  include/linux/trace_seq.h    | 10 ++++++++
>  include/trace/ftrace.h       | 57
>  +++++++++++++++++++++++++++++++++++++++++++-
>  kernel/trace/trace_output.c  | 43 +++++++++++++++++++++++++++++++++
>  4 files changed, 113 insertions(+), 1 deletion(-)
> 
> diff --git a/include/linux/ftrace_event.h b/include/linux/ftrace_event.h
> index d16da3e..f68ae9b 100644
> --- a/include/linux/ftrace_event.h
> +++ b/include/linux/ftrace_event.h
> @@ -7,6 +7,7 @@
>  #include <linux/percpu.h>
>  #include <linux/hardirq.h>
>  #include <linux/perf_event.h>
> +#include <linux/cpumask.h>
>  #include <linux/tracepoint.h>
>  
>  struct trace_array;
> @@ -38,6 +39,9 @@ const char *ftrace_print_symbols_seq_u64(struct trace_seq
> *p,
>  								 *symbol_array);
>  #endif
>  
> +const char *ftrace_print_cpumask_seq(struct trace_seq *p, void *cpumask_ptr,
> +				     unsigned int cpumask_size);
> +
>  const char *ftrace_print_hex_seq(struct trace_seq *p,
>  				 const unsigned char *buf, int len);
>  
> diff --git a/include/linux/trace_seq.h b/include/linux/trace_seq.h
> index a32d86e..052b675 100644
> --- a/include/linux/trace_seq.h
> +++ b/include/linux/trace_seq.h
> @@ -46,6 +46,9 @@ extern int trace_seq_putmem_hex(struct trace_seq *s, const
> void *mem,
>  extern void *trace_seq_reserve(struct trace_seq *s, size_t len);
>  extern int trace_seq_path(struct trace_seq *s, const struct path *path);
>  
> +extern int trace_seq_cpumask(struct trace_seq *s, const unsigned long
> *maskp,
> +			     int nmaskbits);
> +
>  #else /* CONFIG_TRACING */
>  static inline int trace_seq_printf(struct trace_seq *s, const char *fmt,
>  ...)
>  {
> @@ -57,6 +60,13 @@ trace_seq_bprintf(struct trace_seq *s, const char *fmt,
> const u32 *binary)
>  	return 0;
>  }
>  
> +static inline int
> +trace_seq_cpumask(struct trace_seq *s, const unsigned long *maskp,
> +		  int nmaskbits)
> +{
> +	return 0;
> +}
> +
>  static inline int trace_print_seq(struct seq_file *m, struct trace_seq *s)
>  {
>  	return 0;
> diff --git a/include/trace/ftrace.h b/include/trace/ftrace.h
> index 0a1a4f7..ff3c64e 100644
> --- a/include/trace/ftrace.h
> +++ b/include/trace/ftrace.h
> @@ -53,6 +53,9 @@
>  #undef __string
>  #define __string(item, src) __dynamic_array(char, item, -1)
>  
> +#undef __cpumask
> +#define __cpumask(item, src) __dynamic_array(char, item, -1)
> +
>  #undef TP_STRUCT__entry
>  #define TP_STRUCT__entry(args...) args
>  
> @@ -128,6 +131,9 @@
>  #undef __string
>  #define __string(item, src) __dynamic_array(char, item, -1)
>  
> +#undef __string
> +#define __string(item, src) __dynamic_array(unsigned long, item, -1)
> +
>  #undef DECLARE_EVENT_CLASS
>  #define DECLARE_EVENT_CLASS(call, proto, args, tstruct, assign, print)	\
>  	struct ftrace_data_offsets_##call {				\
> @@ -200,6 +206,15 @@
>  #undef __get_str
>  #define __get_str(field) (char *)__get_dynamic_array(field)
>  
> +#undef __get_cpumask
> +#define __get_cpumask(field)						\
> +	({								\
> +		void *__cpumask = __get_dynamic_array(field);		\
> +		unsigned int __cpumask_size;				\
> +		__cpumask_size = (__entry->__data_loc_##field >> 16) & 0xffff; \
> +		ftrace_print_cpumask_seq(p, __cpumask, __cpumask_size);	\
> +	})
> +
>  #undef __print_flags
>  #define __print_flags(flag, delim, flag_array...)			\
>  	({								\
> @@ -322,6 +337,9 @@ static struct trace_event_functions
> ftrace_event_type_funcs_##call = {	\
>  #undef __string
>  #define __string(item, src) __dynamic_array(char, item, -1)
>  
> +#undef __cpumask
> +#define __cpumask(item, src) __dynamic_array(unsigned long, item, -1)
> +
>  #undef DECLARE_EVENT_CLASS
>  #define DECLARE_EVENT_CLASS(call, proto, args, tstruct, func, print)	\
>  static int notrace __init						\
> @@ -372,6 +390,29 @@ ftrace_define_fields_##call(struct ftrace_event_call
> *event_call)	\
>  #define __string(item, src) __dynamic_array(char, item,			\
>  		    strlen((src) ? (const char *)(src) : "(null)") + 1)
>  
> +/*
> + * __cpumask_size_in_bytes_raw is the number of bytes needed to hold
> + * num_possible_cpus().
> + */
> +#define __cpumask_size_in_bytes_raw			\
> +	((num_possible_cpus() + 7) / 8)
> +
> +#define __cpumask_size_in_longs						\
> +	((__cpumask_size_in_bytes_raw + ((BITS_PER_LONG / 8) - 1))	\
> +	 / (BITS_PER_LONG / 8))
> +
> +/*
> + * __cpumask_size_in_bytes is the number of bytes needed to hold
> + * num_possible_cpus() padded out to the nearest long. This is what
> + * is saved in the buffer, just to be consistent.
> + */
> +#define __cpumask_size_in_bytes				\
> +	(__cpumask_size_in_longs * (BITS_PER_LONG / 8))
> +
> +#undef __cpumask
> +#define __cpumask(item, src) __dynamic_array(unsigned long, item,	\
> +					     __cpumask_size_in_longs)
> +
>  #undef DECLARE_EVENT_CLASS
>  #define DECLARE_EVENT_CLASS(call, proto, args, tstruct, assign, print)	\
>  static inline notrace int ftrace_get_offsets_##call(			\
> @@ -513,12 +554,22 @@ static inline notrace int ftrace_get_offsets_##call(
> 			\
>  	__entry->__data_loc_##item = __data_offsets.item;
>  
>  #undef __string
> -#define __string(item, src) __dynamic_array(char, item, -1)       	\
> +#define __string(item, src) __dynamic_array(char, item, -1)
>  
>  #undef __assign_str
>  #define __assign_str(dst, src)						\
>  	strcpy(__get_str(dst), (src) ? (const char *)(src) : "(null)");
>  
> +#undef __cpumask
> +#define __cpumask(item, src) __dynamic_array(unsigned long, item, -1)
> +
> +#undef __get_cpumask
> +#define __get_cpumask(field) (char *)__get_dynamic_array(field)
> +
> +#undef __assign_cpumask
> +#define __assign_cpumask(dst, src)					\
> +	memcpy(__get_cpumask(dst), (src), __cpumask_size_in_bytes)
> +
>  #undef TP_fast_assign
>  #define TP_fast_assign(args...) args
>  
> @@ -586,6 +637,7 @@ static inline void ftrace_test_probe_##call(void)			\
>  #undef __print_hex
>  #undef __get_dynamic_array
>  #undef __get_str
> +#undef __get_cpumask
>  
>  #undef TP_printk
>  #define TP_printk(fmt, args...) "\"" fmt "\", "  __stringify(args)
> @@ -651,6 +703,9 @@ __attribute__((section("_ftrace_events")))
> *__event_##call = &event_##call
>  #undef __get_str
>  #define __get_str(field) (char *)__get_dynamic_array(field)
>  
> +#undef __get_cpumask
> +#define __get_cpumask(field) (char *)__get_dynamic_array(field)
> +
>  #undef __perf_addr
>  #define __perf_addr(a)	(__addr = (a))
>  
> diff --git a/kernel/trace/trace_output.c b/kernel/trace/trace_output.c
> index a436de1..de43631 100644
> --- a/kernel/trace/trace_output.c
> +++ b/kernel/trace/trace_output.c
> @@ -126,6 +126,36 @@ trace_seq_printf(struct trace_seq *s, const char *fmt,
> ...)
>  EXPORT_SYMBOL_GPL(trace_seq_printf);
>  
>  /**
> + * trace_seq_cpumask - put a list of longs as a cpumask print output
> + * @s:		trace sequence descriptor
> + * @maskp:	points to an array of unsigned longs that represent a cpumask
> + * @nmaskbits:	The number of bits that are valid in @maskp
> + *
> + * It returns 0 if the trace oversizes the buffer's free
> + * space, 1 otherwise.
> + *
> + * Although the name has cpumask, it does not use the cpumask structure,
> + * but instead the internal bitmask structure used by cpumask. This
> + * is used for printing cpumasks in tracepoints.
> + */
> +int
> +trace_seq_cpumask(struct trace_seq *s, const unsigned long *maskp,
> +		  int nmaskbits)
> +{
> +	int len = (PAGE_SIZE - 1) - s->len;
> +	int ret;
> +
> +	if (s->full || !len)
> +		return 0;
> +
> +	ret = bitmap_scnprintf(s->buffer, len, maskp, nmaskbits);
> +	s->len += ret;
> +
> +	return 1;
> +}
> +EXPORT_SYMBOL_GPL(trace_seq_cpumask);
> +
> +/**
>   * trace_seq_vprintf - sequence printing of trace information
>   * @s: trace sequence descriptor
>   * @fmt: printf format string
> @@ -399,6 +429,19 @@ EXPORT_SYMBOL(ftrace_print_symbols_seq_u64);
>  #endif
>  
>  const char *
> +ftrace_print_cpumask_seq(struct trace_seq *p, void *cpumask_ptr,
> +			 unsigned int cpumask_size)
> +{
> +	const char *ret = p->buffer + p->len;
> +
> +	trace_seq_cpumask(p, cpumask_ptr, cpumask_size * 8);
> +	trace_seq_putc(p, 0);
> +
> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(ftrace_print_cpumask_seq);
> +
> +const char *
>  ftrace_print_hex_seq(struct trace_seq *p, const unsigned char *buf, int
>  buf_len)
>  {
>  	int i;
> --
> 1.8.1.4
> 
> 

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
