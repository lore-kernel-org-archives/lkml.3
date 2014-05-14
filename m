Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752784AbaENOXb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 10:23:31 -0400
Received: from service87.mimecast.com ([91.220.42.44]:56817 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750973AbaENOXa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 10:23:30 -0400
Date: Wed, 14 May 2014 15:23:24 +0100
From: Javi Merino <javi.merino@arm.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>
Subject: Re: [RFC][PATCH v2] tracing: Add __bitmask() macro to trace events
 to cpumasks and other bitmasks
Message-ID: <20140514142324.GA10024@e102654-lin.cambridge.arm.com>
References: <1399377998-14870-1-git-send-email-javi.merino@arm.com>
 <1399377998-14870-6-git-send-email-javi.merino@arm.com>
 <20140506132238.22e136d1@gandalf.local.home>
 <484888063.12149.1399403794855.JavaMail.zimbra@efficios.com>
 <20140506231238.246c7d3e@gandalf.local.home>
MIME-Version: 1.0
In-Reply-To: <20140506231238.246c7d3e@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginalArrivalTime: 14 May 2014 14:23:35.0051 (UTC) FILETIME=[1710D5B0:01CF6F80]
X-MC-Unique: 114051415232706201
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Steven,

On Wed, May 07, 2014 at 04:12:38AM +0100, Steven Rostedt wrote:
> 
> Being able to show a cpumask of events can be useful as some events
> may affect only some CPUs. There is no standard way to record the
> cpumask and converting it to a string is rather expensive during
> the trace as traces happen in hotpaths. It would be better to record
> the raw event mask and be able to parse it at print time.
> 
> The following macros were added for use with the TRACE_EVENT() macro:
> 
>   __bitmask()
>   __assign_bitmask()
>   __get_bitmask()
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
> 		__bitmask(	cpumask, cpus			)
> 	),
> 
> 	TP_fast_assign(
> 		memcpy(__entry->comm, p->comm, TASK_COMM_LEN);
> 		__entry->pid		= p->pid;
> 		__entry->prio		= p->prio;
> 		__entry->orig_cpu	= task_cpu(p);
> 		__entry->dest_cpu	= dest_cpu;
> 		__assign_bitmask(cpumask, cpumask_bits(cpus));
> 	),
> 
> 	TP_printk("comm=%s pid=%d prio=%d orig_cpu=%d dest_cpu=%d cpumask=%s",
> 		  __entry->comm, __entry->pid, __entry->prio,
> 		  __entry->orig_cpu, __entry->dest_cpu,
> 		  __get_bitmask(cpumask))
> );
> 
> With the output of:
> 
>         ksmtuned-3613  [003] d..2   485.220508: sched_migrate_task: comm=ksmtuned pid=3615 prio=120 orig_cpu=3 dest_cpu=2 cpumask=00000000,0000000f
>      migration/1-13    [001] d..5   485.221202: sched_migrate_task: comm=ksmtuned pid=3614 prio=120 orig_cpu=1 dest_cpu=0 cpumask=00000000,0000000f
>              awk-3615  [002] d.H5   485.221747: sched_migrate_task: comm=rcu_preempt pid=7 prio=120 orig_cpu=0 dest_cpu=1 cpumask=00000000,000000ff
>      migration/2-18    [002] d..5   485.222062: sched_migrate_task: comm=ksmtuned pid=3615 prio=120 orig_cpu=2 dest_cpu=3 cpumask=00000000,0000000f
> 
> Link: http://lkml.kernel.org/r/1399377998-14870-6-git-send-email-javi.merino@arm.com
> 
> Suggested-by: Javi Merino <javi.merino@arm.com>
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> ---
> 
> Changes since v1: Use bitmask name instead of cpumask naming.
> 
> ---
>  include/linux/ftrace_event.h |  3 +++
>  include/linux/trace_seq.h    | 10 ++++++++
>  include/trace/ftrace.h       | 57 +++++++++++++++++++++++++++++++++++++++++++-
>  kernel/trace/trace_output.c  | 41 +++++++++++++++++++++++++++++++
>  4 files changed, 110 insertions(+), 1 deletion(-)
> 
> diff --git a/include/linux/ftrace_event.h b/include/linux/ftrace_event.h
> index d16da3e..cff3106 100644
> --- a/include/linux/ftrace_event.h
> +++ b/include/linux/ftrace_event.h
> @@ -38,6 +38,9 @@ const char *ftrace_print_symbols_seq_u64(struct trace_seq *p,
>  								 *symbol_array);
>  #endif
>  
> +const char *ftrace_print_bitmask_seq(struct trace_seq *p, void *bitmask_ptr,
> +				     unsigned int bitmask_size);
> +
>  const char *ftrace_print_hex_seq(struct trace_seq *p,
>  				 const unsigned char *buf, int len);
>  
> diff --git a/include/linux/trace_seq.h b/include/linux/trace_seq.h
> index a32d86e..1361169 100644
> --- a/include/linux/trace_seq.h
> +++ b/include/linux/trace_seq.h
> @@ -46,6 +46,9 @@ extern int trace_seq_putmem_hex(struct trace_seq *s, const void *mem,
>  extern void *trace_seq_reserve(struct trace_seq *s, size_t len);
>  extern int trace_seq_path(struct trace_seq *s, const struct path *path);
>  
> +extern int trace_seq_bitmask(struct trace_seq *s, const unsigned long *maskp,
> +			     int nmaskbits);
> +
>  #else /* CONFIG_TRACING */
>  static inline int trace_seq_printf(struct trace_seq *s, const char *fmt, ...)
>  {
> @@ -57,6 +60,13 @@ trace_seq_bprintf(struct trace_seq *s, const char *fmt, const u32 *binary)
>  	return 0;
>  }
>  
> +static inline int
> +trace_seq_bitmask(struct trace_seq *s, const unsigned long *maskp,
> +		  int nmaskbits)
> +{
> +	return 0;
> +}
> +
>  static inline int trace_print_seq(struct seq_file *m, struct trace_seq *s)
>  {
>  	return 0;
> diff --git a/include/trace/ftrace.h b/include/trace/ftrace.h
> index 0a1a4f7..d9c44af 100644
> --- a/include/trace/ftrace.h
> +++ b/include/trace/ftrace.h
> @@ -53,6 +53,9 @@
>  #undef __string
>  #define __string(item, src) __dynamic_array(char, item, -1)
>  
> +#undef __bitmask
> +#define __bitmask(item, src) __dynamic_array(char, item, -1)
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

This overrides the previous definition of __string() and looks like it
shouldn't be here.

>  #undef DECLARE_EVENT_CLASS
>  #define DECLARE_EVENT_CLASS(call, proto, args, tstruct, assign, print)	\
>  	struct ftrace_data_offsets_##call {				\
> @@ -200,6 +206,15 @@
>  #undef __get_str
>  #define __get_str(field) (char *)__get_dynamic_array(field)
>  
> +#undef __get_bitmask
> +#define __get_bitmask(field)						\
> +	({								\
> +		void *__bitmask = __get_dynamic_array(field);		\
> +		unsigned int __bitmask_size;				\
> +		__bitmask_size = (__entry->__data_loc_##field >> 16) & 0xffff; \
> +		ftrace_print_bitmask_seq(p, __bitmask, __bitmask_size);	\
> +	})
> +
>  #undef __print_flags
>  #define __print_flags(flag, delim, flag_array...)			\
>  	({								\
> @@ -322,6 +337,9 @@ static struct trace_event_functions ftrace_event_type_funcs_##call = {	\
>  #undef __string
>  #define __string(item, src) __dynamic_array(char, item, -1)
>  
> +#undef __bitmask
> +#define __bitmask(item, src) __dynamic_array(unsigned long, item, -1)
> +
>
>  #undef DECLARE_EVENT_CLASS
>  #define DECLARE_EVENT_CLASS(call, proto, args, tstruct, func, print)	\
>  static int notrace __init						\
> @@ -372,6 +390,29 @@ ftrace_define_fields_##call(struct ftrace_event_call *event_call)	\
>  #define __string(item, src) __dynamic_array(char, item,			\
>  		    strlen((src) ? (const char *)(src) : "(null)") + 1)
>  
> +/*
> + * __bitmask_size_in_bytes_raw is the number of bytes needed to hold
> + * num_possible_cpus().
> + */
> +#define __bitmask_size_in_bytes_raw			\
> +	((num_possible_cpus() + 7) / 8)
> +
> +#define __bitmask_size_in_longs						\
> +	((__bitmask_size_in_bytes_raw + ((BITS_PER_LONG / 8) - 1))	\
> +	 / (BITS_PER_LONG / 8))
> +
> +/*
> + * __bitmask_size_in_bytes is the number of bytes needed to hold
> + * num_possible_cpus() padded out to the nearest long. This is what
> + * is saved in the buffer, just to be consistent.
> + */
> +#define __bitmask_size_in_bytes				\
> +	(__bitmask_size_in_longs * (BITS_PER_LONG / 8))
> +
> +#undef __bitmask
> +#define __bitmask(item, src) __dynamic_array(unsigned long, item,	\
> +					     __bitmask_size_in_longs)
> +
>  #undef DECLARE_EVENT_CLASS
>  #define DECLARE_EVENT_CLASS(call, proto, args, tstruct, assign, print)	\
>  static inline notrace int ftrace_get_offsets_##call(			\
> @@ -513,12 +554,22 @@ static inline notrace int ftrace_get_offsets_##call(			\
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
> +#undef __bitmask
> +#define __bitmask(item, src) __dynamic_array(unsigned long, item, -1)

Why src?  It's not used in any of the definitions of the __bitmask()
macro, can we remove it?

Cheers,
Javi

