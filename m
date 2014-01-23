Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932314AbaAWTq6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 14:46:58 -0500
Received: from mail-ie0-f170.google.com ([209.85.223.170]:43511 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751805AbaAWTq4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 14:46:56 -0500
MIME-Version: 1.0
In-Reply-To: <1385146260-28261-1-git-send-email-rbharath@google.com>
References: <1385146260-28261-1-git-send-email-rbharath@google.com>
From: Bharath Ravi <rbharath@google.com>
Date: Thu, 23 Jan 2014 11:46:33 -0800
Message-ID: <CAHN2JJ8D+p_ZkEmjrpWk5T4yy8Gb++rW3W8f6EJQ5D28igEnng@mail.gmail.com>
Subject: Re: [PATCH] tracing: Allow instances to have independent trace
 flags/trace options.
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Vaibhav Nagarnaik <vnagarnaik@google.com>,
        David Sharp <dhsharp@google.com>, Bharath Ravi <rbharath@google.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Steven,

This patch allows instances to have their own independent trace
options (as opposed to the current globally shared trace options)

Does this look like a reasonable change?
Bharath Ravi |  rbharath@google.com


On Fri, Nov 22, 2013 at 10:51 AM, Bharath Ravi <rbharath@google.com> wrote:
> Currently, the trace options are global, and shared among all
> instances. This change divides the set of trace options into global
> options and instance specific options. Instance specific options may be
> set independently by an instance without affecting either the global
> tracer or other instances. Global options are viewable and modifiable
> only from the global tracer, preventing tracers from modifying shared
> flags.
>
> Currently, only the "overwrite" flag is a per-instance flag. Others may
> be supported as and when instances are modified to support more tracers.
>
> As a side-effect, the global trace_flags variable is replaced by
> instance specific trace_flags in trace_array. References to the old
> global flags variable are replaced with accessors to the global_tracer's
> trace_flags.
>
> Signed-off-by: Bharath Ravi <rbharath@google.com>
> ---
>  kernel/trace/blktrace.c              |   5 +-
>  kernel/trace/ftrace.c                |   4 +-
>  kernel/trace/trace.c                 | 131 +++++++++++++++++++++++++----------
>  kernel/trace/trace.h                 |  51 +++++++-------
>  kernel/trace/trace_events.c          |   2 +-
>  kernel/trace/trace_functions_graph.c |  10 +--
>  kernel/trace/trace_irqsoff.c         |   3 +-
>  kernel/trace/trace_kdb.c             |   6 +-
>  kernel/trace/trace_output.c          |   8 +--
>  kernel/trace/trace_printk.c          |   8 +--
>  kernel/trace/trace_sched_wakeup.c    |   3 +-
>  kernel/trace/trace_syscalls.c        |   2 +-
>  12 files changed, 149 insertions(+), 84 deletions(-)
>
> diff --git a/kernel/trace/blktrace.c b/kernel/trace/blktrace.c
> index b8b8560..0d71009 100644
> --- a/kernel/trace/blktrace.c
> +++ b/kernel/trace/blktrace.c
> @@ -1350,7 +1350,7 @@ static enum print_line_t print_one_line(struct trace_iterator *iter,
>
>         t          = te_blk_io_trace(iter->ent);
>         what       = t->action & ((1 << BLK_TC_SHIFT) - 1);
> -       long_act   = !!(trace_flags & TRACE_ITER_VERBOSE);
> +       long_act   = !!(global_trace_flags() & TRACE_ITER_VERBOSE);
>         log_action = classic ? &blk_log_action_classic : &blk_log_action;
>
>         if (t->action == BLK_TN_MESSAGE) {
> @@ -1411,12 +1411,15 @@ static enum print_line_t blk_tracer_print_line(struct trace_iterator *iter)
>
>  static int blk_tracer_set_flag(u32 old_flags, u32 bit, int set)
>  {
> +       unsigned long trace_flags = global_trace_flags();
>         /* don't output context-info for blk_classic output */
>         if (bit == TRACE_BLK_OPT_CLASSIC) {
>                 if (set)
>                         trace_flags &= ~TRACE_ITER_CONTEXT_INFO;
>                 else
>                         trace_flags |= TRACE_ITER_CONTEXT_INFO;
> +
> +               set_global_trace_flags(trace_flags);
>         }
>         return 0;
>  }
> diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
> index 03cf44a..c356d5d 100644
> --- a/kernel/trace/ftrace.c
> +++ b/kernel/trace/ftrace.c
> @@ -911,7 +911,7 @@ static void profile_graph_return(struct ftrace_graph_ret *trace)
>
>         calltime = trace->rettime - trace->calltime;
>
> -       if (!(trace_flags & TRACE_ITER_GRAPH_TIME)) {
> +       if (!(global_trace_flags() & TRACE_ITER_GRAPH_TIME)) {
>                 int index;
>
>                 index = trace->depth;
> @@ -4836,7 +4836,7 @@ ftrace_graph_probe_sched_switch(void *ignore,
>          * Does the user want to count the time a function was asleep.
>          * If so, do not update the time stamps.
>          */
> -       if (trace_flags & TRACE_ITER_SLEEP_TIME)
> +       if (global_trace_flags() & TRACE_ITER_SLEEP_TIME)
>                 return;
>
>         timestamp = trace_clock_local();
> diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
> index 7974ba2..7add8bc 100644
> --- a/kernel/trace/trace.c
> +++ b/kernel/trace/trace.c
> @@ -386,11 +386,16 @@ static inline void trace_access_lock_init(void)
>
>  #endif
>
> -/* trace_flags holds trace_options default values */
> -unsigned long trace_flags = TRACE_ITER_PRINT_PARENT | TRACE_ITER_PRINTK |
> -       TRACE_ITER_ANNOTATE | TRACE_ITER_CONTEXT_INFO | TRACE_ITER_SLEEP_TIME |
> -       TRACE_ITER_GRAPH_TIME | TRACE_ITER_RECORD_CMD | TRACE_ITER_OVERWRITE |
> -       TRACE_ITER_IRQ_INFO | TRACE_ITER_MARKERS | TRACE_ITER_FUNCTION;
> +/* Sets default values for a tracer's trace_options */
> +static inline void init_trace_flags(unsigned long *trace_flags)
> +{
> +       *trace_flags = TRACE_ITER_PRINT_PARENT | TRACE_ITER_PRINTK |
> +               TRACE_ITER_ANNOTATE | TRACE_ITER_CONTEXT_INFO |
> +               TRACE_ITER_SLEEP_TIME | TRACE_ITER_GRAPH_TIME |
> +               TRACE_ITER_RECORD_CMD | TRACE_ITER_IRQ_INFO |
> +               TRACE_ITER_MARKERS | TRACE_ITER_FUNCTION |
> +               TRACE_ITER_OVERWRITE;
> +}
>
>  static void tracer_tracing_on(struct trace_array *tr)
>  {
> @@ -705,8 +710,9 @@ unsigned long nsecs_to_usecs(unsigned long nsecs)
>         return nsecs / 1000;
>  }
>
> -/* These must match the bit postions in trace_iterator_flags */
> -static const char *trace_options[] = {
> +/* These must match the bit positions in trace_iterator_flags */
> +static const char * const trace_options[] = {
> +       "overwrite",
>         "print-parent",
>         "sym-offset",
>         "sym-addr",
> @@ -728,7 +734,6 @@ static const char *trace_options[] = {
>         "sleep-time",
>         "graph-time",
>         "record-cmd",
> -       "overwrite",
>         "disable_on_free",
>         "irq-info",
>         "markers",
> @@ -736,6 +741,13 @@ static const char *trace_options[] = {
>         NULL
>  };
>
> +/*
> + * The index of the first global flag in trace_options. Indices higher than or
> + * equal to this are global flags, while indices smaller than this are
> + * per-instance flags.
> + */
> +static const int global_flags_start = 1;
> +
>  static struct {
>         u64 (*func)(void);
>         const char *name;
> @@ -1260,6 +1272,17 @@ int is_tracing_stopped(void)
>         return global_trace.stop_count;
>  }
>
> +unsigned long global_trace_flags(void)
> +{
> +       return global_trace.trace_flags;
> +}
> +
> +void set_global_trace_flags(unsigned long flags)
> +{
> +       global_trace.trace_flags = flags;
> +}
> +
> +
>  /**
>   * ftrace_off_permanent - disable all ftrace code permanently
>   *
> @@ -1728,7 +1751,7 @@ static void __ftrace_trace_stack(struct ring_buffer *buffer,
>  void ftrace_trace_stack_regs(struct ring_buffer *buffer, unsigned long flags,
>                              int skip, int pc, struct pt_regs *regs)
>  {
> -       if (!(trace_flags & TRACE_ITER_STACKTRACE))
> +       if (!(global_trace_flags() & TRACE_ITER_STACKTRACE))
>                 return;
>
>         __ftrace_trace_stack(buffer, flags, skip, pc, regs);
> @@ -1737,7 +1760,7 @@ void ftrace_trace_stack_regs(struct ring_buffer *buffer, unsigned long flags,
>  void ftrace_trace_stack(struct ring_buffer *buffer, unsigned long flags,
>                         int skip, int pc)
>  {
> -       if (!(trace_flags & TRACE_ITER_STACKTRACE))
> +       if (!(global_trace_flags() & TRACE_ITER_STACKTRACE))
>                 return;
>
>         __ftrace_trace_stack(buffer, flags, skip, pc, NULL);
> @@ -1781,7 +1804,7 @@ ftrace_trace_userstack(struct ring_buffer *buffer, unsigned long flags, int pc)
>         struct userstack_entry *entry;
>         struct stack_trace trace;
>
> -       if (!(trace_flags & TRACE_ITER_USERSTACKTRACE))
> +       if (!(global_trace_flags() & TRACE_ITER_USERSTACKTRACE))
>                 return;
>
>         /*
> @@ -2086,7 +2109,7 @@ int trace_array_printk(struct trace_array *tr,
>         int ret;
>         va_list ap;
>
> -       if (!(trace_flags & TRACE_ITER_PRINTK))
> +       if (!(global_trace_flags() & TRACE_ITER_PRINTK))
>                 return 0;
>
>         va_start(ap, fmt);
> @@ -2101,7 +2124,7 @@ int trace_array_printk_buf(struct ring_buffer *buffer,
>         int ret;
>         va_list ap;
>
> -       if (!(trace_flags & TRACE_ITER_PRINTK))
> +       if (!(global_trace_flags() & TRACE_ITER_PRINTK))
>                 return 0;
>
>         va_start(ap, fmt);
> @@ -2442,7 +2465,7 @@ static void print_func_help_header_irq(struct trace_buffer *buf, struct seq_file
>  void
>  print_trace_header(struct seq_file *m, struct trace_iterator *iter)
>  {
> -       unsigned long sym_flags = (trace_flags & TRACE_ITER_SYM_MASK);
> +       unsigned long sym_flags = (global_trace_flags() & TRACE_ITER_SYM_MASK);
>         struct trace_buffer *buf = iter->trace_buffer;
>         struct trace_array_cpu *data = per_cpu_ptr(buf->data, buf->cpu);
>         struct tracer *type = iter->trace;
> @@ -2505,7 +2528,7 @@ static void test_cpu_buff_start(struct trace_iterator *iter)
>  {
>         struct trace_seq *s = &iter->seq;
>
> -       if (!(trace_flags & TRACE_ITER_ANNOTATE))
> +       if (!(global_trace_flags() & TRACE_ITER_ANNOTATE))
>                 return;
>
>         if (!(iter->iter_flags & TRACE_FILE_ANNOTATE))
> @@ -2528,7 +2551,7 @@ static void test_cpu_buff_start(struct trace_iterator *iter)
>  static enum print_line_t print_trace_fmt(struct trace_iterator *iter)
>  {
>         struct trace_seq *s = &iter->seq;
> -       unsigned long sym_flags = (trace_flags & TRACE_ITER_SYM_MASK);
> +       unsigned long sym_flags = (global_trace_flags() & TRACE_ITER_SYM_MASK);
>         struct trace_entry *entry;
>         struct trace_event *event;
>
> @@ -2538,7 +2561,7 @@ static enum print_line_t print_trace_fmt(struct trace_iterator *iter)
>
>         event = ftrace_find_event(entry->type);
>
> -       if (trace_flags & TRACE_ITER_CONTEXT_INFO) {
> +       if (global_trace_flags() & TRACE_ITER_CONTEXT_INFO) {
>                 if (iter->iter_flags & TRACE_FILE_LAT_FMT) {
>                         if (!trace_print_lat_context(iter))
>                                 goto partial;
> @@ -2567,7 +2590,7 @@ static enum print_line_t print_raw_fmt(struct trace_iterator *iter)
>
>         entry = iter->ent;
>
> -       if (trace_flags & TRACE_ITER_CONTEXT_INFO) {
> +       if (global_trace_flags() & TRACE_ITER_CONTEXT_INFO) {
>                 if (!trace_seq_printf(s, "%d %d %llu ",
>                                       entry->pid, iter->cpu, iter->ts))
>                         goto partial;
> @@ -2594,7 +2617,7 @@ static enum print_line_t print_hex_fmt(struct trace_iterator *iter)
>
>         entry = iter->ent;
>
> -       if (trace_flags & TRACE_ITER_CONTEXT_INFO) {
> +       if (global_trace_flags() & TRACE_ITER_CONTEXT_INFO) {
>                 SEQ_PUT_HEX_FIELD_RET(s, entry->pid);
>                 SEQ_PUT_HEX_FIELD_RET(s, iter->cpu);
>                 SEQ_PUT_HEX_FIELD_RET(s, iter->ts);
> @@ -2620,7 +2643,7 @@ static enum print_line_t print_bin_fmt(struct trace_iterator *iter)
>
>         entry = iter->ent;
>
> -       if (trace_flags & TRACE_ITER_CONTEXT_INFO) {
> +       if (global_trace_flags() & TRACE_ITER_CONTEXT_INFO) {
>                 SEQ_PUT_FIELD_RET(s, entry->pid);
>                 SEQ_PUT_FIELD_RET(s, iter->cpu);
>                 SEQ_PUT_FIELD_RET(s, iter->ts);
> @@ -2667,6 +2690,7 @@ int trace_empty(struct trace_iterator *iter)
>  /*  Called with trace_event_read_lock() held. */
>  enum print_line_t print_trace_line(struct trace_iterator *iter)
>  {
> +       unsigned long trace_flags = global_trace_flags();
>         enum print_line_t ret;
>
>         if (iter->lost_events &&
> @@ -2718,12 +2742,13 @@ void trace_latency_header(struct seq_file *m)
>         if (iter->iter_flags & TRACE_FILE_LAT_FMT)
>                 print_trace_header(m, iter);
>
> -       if (!(trace_flags & TRACE_ITER_VERBOSE))
> +       if (!(global_trace_flags() & TRACE_ITER_VERBOSE))
>                 print_lat_help_header(m);
>  }
>
>  void trace_default_header(struct seq_file *m)
>  {
> +       unsigned long trace_flags = global_trace_flags();
>         struct trace_iterator *iter = m->private;
>
>         if (!(trace_flags & TRACE_ITER_CONTEXT_INFO))
> @@ -3064,7 +3089,7 @@ static int tracing_open(struct inode *inode, struct file *file)
>                 iter = __tracing_open(inode, file, false);
>                 if (IS_ERR(iter))
>                         ret = PTR_ERR(iter);
> -               else if (trace_flags & TRACE_ITER_LATENCY_FMT)
> +               else if (global_trace_flags() & TRACE_ITER_LATENCY_FMT)
>                         iter->iter_flags |= TRACE_FILE_LAT_FMT;
>         }
>
> @@ -3270,13 +3295,23 @@ static int tracing_trace_options_show(struct seq_file *m, void *v)
>         tracer_flags = tr->current_trace->flags->val;
>         trace_opts = tr->current_trace->flags->opts;
>
> -       for (i = 0; trace_options[i]; i++) {
> -               if (trace_flags & (1 << i))
> +       for (i = 0; i < global_flags_start; i++) {
> +               if (tr->trace_flags & (1 << i))
>                         seq_printf(m, "%s\n", trace_options[i]);
>                 else
>                         seq_printf(m, "no%s\n", trace_options[i]);
>         }
>
> +       /* For the global trace, also display global options*/
> +       if (tr->flags & TRACE_ARRAY_FL_GLOBAL) {
> +               for (i = global_flags_start; trace_options[i]; i++) {
> +                       if (global_trace_flags() & (1 << i))
> +                               seq_printf(m, "%s\n", trace_options[i]);
> +                       else
> +                               seq_printf(m, "no%s\n", trace_options[i]);
> +               }
> +       }
> +
>         for (i = 0; trace_opts[i].name; i++) {
>                 if (tracer_flags & trace_opts[i].bit)
>                         seq_printf(m, "%s\n", trace_opts[i].name);
> @@ -3334,8 +3369,13 @@ int trace_keep_overwrite(struct tracer *tracer, u32 mask, int set)
>
>  int set_tracer_flag(struct trace_array *tr, unsigned int mask, int enabled)
>  {
> +       /* If this is a global flag, disallow instances from modifying it. */
> +       if (mask >= (1 << global_flags_start) &&
> +           !(tr->flags & TRACE_ARRAY_FL_GLOBAL))
> +               return -EINVAL;
> +
>         /* do nothing if flag is already set */
> -       if (!!(trace_flags & mask) == !!enabled)
> +       if (!!(tr->trace_flags & mask) == !!enabled)
>                 return 0;
>
>         /* Give the tracer a chance to approve the change */
> @@ -3344,9 +3384,9 @@ int set_tracer_flag(struct trace_array *tr, unsigned int mask, int enabled)
>                         return -EINVAL;
>
>         if (enabled)
> -               trace_flags |= mask;
> +               tr->trace_flags |= mask;
>         else
> -               trace_flags &= ~mask;
> +               tr->trace_flags &= ~mask;
>
>         if (mask == TRACE_ITER_RECORD_CMD)
>                 trace_event_enable_cmd_record(enabled);
> @@ -3370,6 +3410,7 @@ static int trace_set_options(struct trace_array *tr, char *option)
>         int neg = 0;
>         int ret = -ENODEV;
>         int i;
> +       bool option_found = false;
>
>         cmp = strstrip(option);
>
> @@ -3380,15 +3421,27 @@ static int trace_set_options(struct trace_array *tr, char *option)
>
>         mutex_lock(&trace_types_lock);
>
> -       for (i = 0; trace_options[i]; i++) {
> +       for (i = 0; i < global_flags_start; i++) {
>                 if (strcmp(cmp, trace_options[i]) == 0) {
>                         ret = set_tracer_flag(tr, 1 << i, !neg);
>                         break;
>                 }
>         }
> +       if (i < global_flags_start) {
> +               option_found = true;
> +       } else if (tr->flags & TRACE_ARRAY_FL_GLOBAL) {
> +               /* If this is the global trace, try the global options */
> +               for (i = global_flags_start; trace_options[i]; i++) {
> +                       if (strcmp(cmp, trace_options[i]) == 0) {
> +                               ret = set_tracer_flag(tr, 1 << i, !neg);
> +                               break;
> +                       }
> +               }
> +               option_found = trace_options[i];
> +       }
>
>         /* If no option could be set, test the specific tracer options */
> -       if (!trace_options[i])
> +       if (!option_found)
>                 ret = set_tracer_option(tr->current_trace, cmp, neg);
>
>         mutex_unlock(&trace_types_lock);
> @@ -3963,7 +4016,7 @@ static int tracing_open_pipe(struct inode *inode, struct file *filp)
>         /* trace pipe does not show start of buffer */
>         cpumask_setall(iter->started);
>
> -       if (trace_flags & TRACE_ITER_LATENCY_FMT)
> +       if (global_trace_flags() & TRACE_ITER_LATENCY_FMT)
>                 iter->iter_flags |= TRACE_FILE_LAT_FMT;
>
>         /* Output in nanoseconds only if we are using a clock in nanoseconds. */
> @@ -4021,7 +4074,7 @@ trace_poll(struct trace_iterator *iter, struct file *filp, poll_table *poll_tabl
>         if (trace_buffer_iter(iter, iter->cpu_file))
>                 return POLLIN | POLLRDNORM;
>
> -       if (trace_flags & TRACE_ITER_BLOCK)
> +       if (global_trace_flags() & TRACE_ITER_BLOCK)
>                 /*
>                  * Always select as readable when in blocking mode
>                  */
> @@ -4465,7 +4518,7 @@ tracing_free_buffer_release(struct inode *inode, struct file *filp)
>         struct trace_array *tr = inode->i_private;
>
>         /* disable tracing ? */
> -       if (trace_flags & TRACE_ITER_STOP_ON_FREE)
> +       if (global_trace_flags() & TRACE_ITER_STOP_ON_FREE)
>                 tracer_tracing_off(tr);
>         /* resize the ring buffer to 0 */
>         tracing_resize_ring_buffer(tr, 0, RING_BUFFER_ALL_CPUS);
> @@ -4498,7 +4551,7 @@ tracing_mark_write(struct file *filp, const char __user *ubuf,
>         if (tracing_disabled)
>                 return -EINVAL;
>
> -       if (!(trace_flags & TRACE_ITER_MARKERS))
> +       if (!(global_trace_flags() & TRACE_ITER_MARKERS))
>                 return -EINVAL;
>
>         if (cnt > TRACE_BUF_SIZE)
> @@ -5628,7 +5681,7 @@ trace_options_core_read(struct file *filp, char __user *ubuf, size_t cnt,
>         long index = (long)filp->private_data;
>         char *buf;
>
> -       if (trace_flags & (1 << index))
> +       if (global_trace_flags() & (1 << index))
>                 buf = "1\n";
>         else
>                 buf = "0\n";
> @@ -5867,7 +5920,7 @@ allocate_trace_buffer(struct trace_array *tr, struct trace_buffer *buf, int size
>  {
>         enum ring_buffer_flags rb_flags;
>
> -       rb_flags = trace_flags & TRACE_ITER_OVERWRITE ? RB_FL_OVERWRITE : 0;
> +       rb_flags = tr->trace_flags & TRACE_ITER_OVERWRITE ? RB_FL_OVERWRITE : 0;
>
>         buf->buffer = ring_buffer_alloc(size, rb_flags);
>         if (!buf->buffer)
> @@ -5941,6 +5994,7 @@ static int new_instance_create(const char *name)
>         cpumask_copy(tr->tracing_cpumask, cpu_all_mask);
>
>         raw_spin_lock_init(&tr->start_lock);
> +       init_trace_flags(&(tr->trace_flags));
>
>         tr->current_trace = &nop_trace;
>
> @@ -6289,10 +6343,10 @@ void ftrace_dump(enum ftrace_dump_mode oops_dump_mode)
>                 atomic_inc(&per_cpu_ptr(iter.tr->trace_buffer.data, cpu)->disabled);
>         }
>
> -       old_userobj = trace_flags & TRACE_ITER_SYM_USEROBJ;
> +       old_userobj = global_trace_flags() & TRACE_ITER_SYM_USEROBJ;
>
>         /* don't look at user memory in panic mode */
> -       trace_flags &= ~TRACE_ITER_SYM_USEROBJ;
> +       set_global_trace_flags(global_trace_flags() & ~TRACE_ITER_SYM_USEROBJ);
>
>         switch (oops_dump_mode) {
>         case DUMP_ALL:
> @@ -6355,7 +6409,7 @@ void ftrace_dump(enum ftrace_dump_mode oops_dump_mode)
>                 printk(KERN_TRACE "---------------------------------\n");
>
>   out_enable:
> -       trace_flags |= old_userobj;
> +       set_global_trace_flags(global_trace_flags() | old_userobj);
>
>         for_each_tracing_cpu(cpu) {
>                 atomic_dec(&per_cpu_ptr(iter.trace_buffer->data, cpu)->disabled);
> @@ -6392,6 +6446,7 @@ __init static int tracer_alloc_buffers(void)
>         cpumask_copy(global_trace.tracing_cpumask, cpu_all_mask);
>
>         raw_spin_lock_init(&global_trace.start_lock);
> +       init_trace_flags(&global_trace.trace_flags);
>
>         /* TODO: make the number of buffers hot pluggable with CPUS */
>         if (allocate_trace_buffers(&global_trace, ring_buf_size) < 0) {
> diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
> index 10c86fb..10e2984 100644
> --- a/kernel/trace/trace.h
> +++ b/kernel/trace/trace.h
> @@ -199,6 +199,7 @@ struct trace_array {
>         int                     clock_id;
>         struct tracer           *current_trace;
>         unsigned int            flags;
> +       unsigned long           trace_flags;
>         raw_spinlock_t          start_lock;
>         struct dentry           *dir;
>         struct dentry           *options;
> @@ -584,6 +585,8 @@ void tracing_stop_sched_switch_record(void);
>  void tracing_start_sched_switch_record(void);
>  int register_tracer(struct tracer *type);
>  int is_tracing_stopped(void);
> +unsigned long global_trace_flags(void);
> +void set_global_trace_flags(unsigned long flags);
>
>  extern cpumask_var_t __read_mostly tracing_buffer_mask;
>
> @@ -699,8 +702,6 @@ int trace_array_printk_buf(struct ring_buffer *buffer,
>  void trace_printk_seq(struct trace_seq *s);
>  enum print_line_t print_trace_line(struct trace_iterator *iter);
>
> -extern unsigned long trace_flags;
> -
>  /* Standard output formatting function used for function return traces */
>  #ifdef CONFIG_FUNCTION_GRAPH_TRACER
>
> @@ -837,28 +838,30 @@ extern int trace_get_user(struct trace_parser *parser, const char __user *ubuf,
>   *       trace.c.
>   */
>  enum trace_iterator_flags {
> -       TRACE_ITER_PRINT_PARENT         = 0x01,
> -       TRACE_ITER_SYM_OFFSET           = 0x02,
> -       TRACE_ITER_SYM_ADDR             = 0x04,
> -       TRACE_ITER_VERBOSE              = 0x08,
> -       TRACE_ITER_RAW                  = 0x10,
> -       TRACE_ITER_HEX                  = 0x20,
> -       TRACE_ITER_BIN                  = 0x40,
> -       TRACE_ITER_BLOCK                = 0x80,
> -       TRACE_ITER_STACKTRACE           = 0x100,
> -       TRACE_ITER_PRINTK               = 0x200,
> -       TRACE_ITER_PREEMPTONLY          = 0x400,
> -       TRACE_ITER_BRANCH               = 0x800,
> -       TRACE_ITER_ANNOTATE             = 0x1000,
> -       TRACE_ITER_USERSTACKTRACE       = 0x2000,
> -       TRACE_ITER_SYM_USEROBJ          = 0x4000,
> -       TRACE_ITER_PRINTK_MSGONLY       = 0x8000,
> -       TRACE_ITER_CONTEXT_INFO         = 0x10000, /* Print pid/cpu/time */
> -       TRACE_ITER_LATENCY_FMT          = 0x20000,
> -       TRACE_ITER_SLEEP_TIME           = 0x40000,
> -       TRACE_ITER_GRAPH_TIME           = 0x80000,
> -       TRACE_ITER_RECORD_CMD           = 0x100000,
> -       TRACE_ITER_OVERWRITE            = 0x200000,
> +       /* Instance specific flags */
> +       TRACE_ITER_OVERWRITE            = 0x01,
> +       /* Global flags */
> +       TRACE_ITER_PRINT_PARENT         = 0x02,
> +       TRACE_ITER_SYM_OFFSET           = 0x04,
> +       TRACE_ITER_SYM_ADDR             = 0x08,
> +       TRACE_ITER_VERBOSE              = 0x10,
> +       TRACE_ITER_RAW                  = 0x20,
> +       TRACE_ITER_HEX                  = 0x40,
> +       TRACE_ITER_BIN                  = 0x80,
> +       TRACE_ITER_BLOCK                = 0x100,
> +       TRACE_ITER_STACKTRACE           = 0x200,
> +       TRACE_ITER_PRINTK               = 0x400,
> +       TRACE_ITER_PREEMPTONLY          = 0x800,
> +       TRACE_ITER_BRANCH               = 0x1000,
> +       TRACE_ITER_ANNOTATE             = 0x2000,
> +       TRACE_ITER_USERSTACKTRACE       = 0x4000,
> +       TRACE_ITER_SYM_USEROBJ          = 0x8000,
> +       TRACE_ITER_PRINTK_MSGONLY       = 0x10000,
> +       TRACE_ITER_CONTEXT_INFO         = 0x20000, /* Print pid/cpu/time */
> +       TRACE_ITER_LATENCY_FMT          = 0x40000,
> +       TRACE_ITER_SLEEP_TIME           = 0x80000,
> +       TRACE_ITER_GRAPH_TIME           = 0x100000,
> +       TRACE_ITER_RECORD_CMD           = 0x200000,
>         TRACE_ITER_STOP_ON_FREE         = 0x400000,
>         TRACE_ITER_IRQ_INFO             = 0x800000,
>         TRACE_ITER_MARKERS              = 0x1000000,
> diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
> index 368a4d5..e04cc60 100644
> --- a/kernel/trace/trace_events.c
> +++ b/kernel/trace/trace_events.c
> @@ -320,7 +320,7 @@ static int __ftrace_event_enable_disable(struct ftrace_event_file *file,
>                         if (soft_disable)
>                                 set_bit(FTRACE_EVENT_FL_SOFT_DISABLED_BIT, &file->flags);
>
> -                       if (trace_flags & TRACE_ITER_RECORD_CMD) {
> +                       if (global_trace_flags() & TRACE_ITER_RECORD_CMD) {
>                                 tracing_start_cmdline_record();
>                                 set_bit(FTRACE_EVENT_FL_RECORDED_CMD_BIT, &file->flags);
>                         }
> diff --git a/kernel/trace/trace_functions_graph.c b/kernel/trace/trace_functions_graph.c
> index b5c0924..d6cc96b 100644
> --- a/kernel/trace/trace_functions_graph.c
> +++ b/kernel/trace/trace_functions_graph.c
> @@ -625,7 +625,7 @@ print_graph_irq(struct trace_iterator *iter, unsigned long addr,
>                 addr >= (unsigned long)__irqentry_text_end)
>                 return TRACE_TYPE_UNHANDLED;
>
> -       if (trace_flags & TRACE_ITER_CONTEXT_INFO) {
> +       if (global_trace_flags() & TRACE_ITER_CONTEXT_INFO) {
>                 /* Absolute time */
>                 if (flags & TRACE_GRAPH_PRINT_ABS_TIME) {
>                         ret = print_graph_abs_time(iter->ts, s);
> @@ -725,7 +725,7 @@ print_graph_duration(unsigned long long duration, struct trace_seq *s,
>         int ret = -1;
>
>         if (!(flags & TRACE_GRAPH_PRINT_DURATION) ||
> -           !(trace_flags & TRACE_ITER_CONTEXT_INFO))
> +           !(global_trace_flags() & TRACE_ITER_CONTEXT_INFO))
>                         return TRACE_TYPE_HANDLED;
>
>         /* No real adata, just filling the column with spaces */
> @@ -882,6 +882,7 @@ print_graph_prologue(struct trace_iterator *iter, struct trace_seq *s,
>         struct trace_entry *ent = iter->ent;
>         int cpu = iter->cpu;
>         int ret;
> +       unsigned long trace_flags = global_trace_flags();
>
>         /* Pid */
>         if (verif_pid(s, ent->pid, cpu, data) == TRACE_TYPE_PARTIAL_LINE)
> @@ -1158,7 +1159,7 @@ static enum print_line_t
>  print_graph_comment(struct trace_seq *s, struct trace_entry *ent,
>                     struct trace_iterator *iter, u32 flags)
>  {
> -       unsigned long sym_flags = (trace_flags & TRACE_ITER_SYM_MASK);
> +       unsigned long sym_flags = (global_trace_flags() & TRACE_ITER_SYM_MASK);
>         struct fgraph_data *data = iter->private;
>         struct trace_event *event;
>         int depth = 0;
> @@ -1321,7 +1322,7 @@ static void print_lat_header(struct seq_file *s, u32 flags)
>
>  static void __print_graph_headers_flags(struct seq_file *s, u32 flags)
>  {
> -       int lat = trace_flags & TRACE_ITER_LATENCY_FMT;
> +       int lat = global_trace_flags() & TRACE_ITER_LATENCY_FMT;
>
>         if (lat)
>                 print_lat_header(s, flags);
> @@ -1362,6 +1363,7 @@ void print_graph_headers(struct seq_file *s)
>
>  void print_graph_headers_flags(struct seq_file *s, u32 flags)
>  {
> +       unsigned long trace_flags = global_trace_flags();
>         struct trace_iterator *iter = s->private;
>
>         if (!(trace_flags & TRACE_ITER_CONTEXT_INFO))
> diff --git a/kernel/trace/trace_irqsoff.c b/kernel/trace/trace_irqsoff.c
> index 2aefbee..bc90b07 100644
> --- a/kernel/trace/trace_irqsoff.c
> +++ b/kernel/trace/trace_irqsoff.c
> @@ -532,6 +532,7 @@ void trace_preempt_off(unsigned long a0, unsigned long a1)
>  static int register_irqsoff_function(int graph, int set)
>  {
>         int ret;
> +       unsigned long trace_flags = global_trace_flags();
>
>         /* 'set' is set if TRACE_ITER_FUNCTION is about to be set */
>         if (function_enabled || (!set && !(trace_flags & TRACE_ITER_FUNCTION)))
> @@ -601,7 +602,7 @@ static void stop_irqsoff_tracer(struct trace_array *tr, int graph)
>
>  static void __irqsoff_tracer_init(struct trace_array *tr)
>  {
> -       save_flags = trace_flags;
> +       save_flags = global_trace_flags();
>
>         /* non overwrite screws up the latency tracers */
>         set_tracer_flag(tr, TRACE_ITER_OVERWRITE, 1);
> diff --git a/kernel/trace/trace_kdb.c b/kernel/trace/trace_kdb.c
> index bd90e1b..752759e 100644
> --- a/kernel/trace/trace_kdb.c
> +++ b/kernel/trace/trace_kdb.c
> @@ -29,10 +29,10 @@ static void ftrace_dump_buf(int skip_lines, long cpu_file)
>                 atomic_inc(&per_cpu_ptr(iter.trace_buffer->data, cpu)->disabled);
>         }
>
> -       old_userobj = trace_flags;
> +       old_userobj = global_trace_flags();
>
>         /* don't look at user memory in panic mode */
> -       trace_flags &= ~TRACE_ITER_SYM_USEROBJ;
> +       set_global_trace_flags(global_trace_flags() & ~TRACE_ITER_SYM_USEROBJ);
>
>         kdb_printf("Dumping ftrace buffer:\n");
>
> @@ -80,7 +80,7 @@ static void ftrace_dump_buf(int skip_lines, long cpu_file)
>                 kdb_printf("---------------------------------\n");
>
>  out:
> -       trace_flags = old_userobj;
> +       set_global_trace_flags(old_userobj);
>
>         for_each_tracing_cpu(cpu) {
>                 atomic_dec(&per_cpu_ptr(iter.trace_buffer->data, cpu)->disabled);
> diff --git a/kernel/trace/trace_output.c b/kernel/trace/trace_output.c
> index 34e7cba..ee536d0 100644
> --- a/kernel/trace/trace_output.c
> +++ b/kernel/trace/trace_output.c
> @@ -534,7 +534,7 @@ seq_print_userip_objs(const struct userstack_entry *entry, struct trace_seq *s,
>         int ret = 1;
>         unsigned int i;
>
> -       if (trace_flags & TRACE_ITER_SYM_USEROBJ) {
> +       if (global_trace_flags() & TRACE_ITER_SYM_USEROBJ) {
>                 struct task_struct *task;
>                 /*
>                  * we do the lookup on the thread group leader,
> @@ -657,7 +657,7 @@ static unsigned long preempt_mark_thresh_us = 100;
>  static int
>  lat_print_timestamp(struct trace_iterator *iter, u64 next_ts)
>  {
> -       unsigned long verbose = trace_flags & TRACE_ITER_VERBOSE;
> +       unsigned long verbose = global_trace_flags() & TRACE_ITER_VERBOSE;
>         unsigned long in_ns = iter->iter_flags & TRACE_FILE_TIME_IN_NS;
>         unsigned long long abs_ts = iter->ts - iter->trace_buffer->time_start;
>         unsigned long long rel_ts = next_ts - iter->ts;
> @@ -710,7 +710,7 @@ int trace_print_context(struct trace_iterator *iter)
>         if (!ret)
>                 return 0;
>
> -       if (trace_flags & TRACE_ITER_IRQ_INFO) {
> +       if (global_trace_flags() & TRACE_ITER_IRQ_INFO) {
>                 ret = trace_print_lat_fmt(s, entry);
>                 if (!ret)
>                         return 0;
> @@ -735,7 +735,7 @@ int trace_print_lat_context(struct trace_iterator *iter)
>         struct trace_entry *entry = iter->ent,
>                            *next_entry = trace_find_next_entry(iter, NULL,
>                                                                &next_ts);
> -       unsigned long verbose = (trace_flags & TRACE_ITER_VERBOSE);
> +       unsigned long verbose = global_trace_flags() & TRACE_ITER_VERBOSE;
>
>         /* Restore the original ent_size */
>         iter->ent_size = ent_size;
> diff --git a/kernel/trace/trace_printk.c b/kernel/trace/trace_printk.c
> index 2900817..7c9ce2e 100644
> --- a/kernel/trace/trace_printk.c
> +++ b/kernel/trace/trace_printk.c
> @@ -194,7 +194,7 @@ int __trace_bprintk(unsigned long ip, const char *fmt, ...)
>         if (unlikely(!fmt))
>                 return 0;
>
> -       if (!(trace_flags & TRACE_ITER_PRINTK))
> +       if (!(global_trace_flags() & TRACE_ITER_PRINTK))
>                 return 0;
>
>         va_start(ap, fmt);
> @@ -209,7 +209,7 @@ int __ftrace_vbprintk(unsigned long ip, const char *fmt, va_list ap)
>         if (unlikely(!fmt))
>                 return 0;
>
> -       if (!(trace_flags & TRACE_ITER_PRINTK))
> +       if (!(global_trace_flags() & TRACE_ITER_PRINTK))
>                 return 0;
>
>         return trace_vbprintk(ip, fmt, ap);
> @@ -221,7 +221,7 @@ int __trace_printk(unsigned long ip, const char *fmt, ...)
>         int ret;
>         va_list ap;
>
> -       if (!(trace_flags & TRACE_ITER_PRINTK))
> +       if (!(global_trace_flags() & TRACE_ITER_PRINTK))
>                 return 0;
>
>         va_start(ap, fmt);
> @@ -233,7 +233,7 @@ EXPORT_SYMBOL_GPL(__trace_printk);
>
>  int __ftrace_vprintk(unsigned long ip, const char *fmt, va_list ap)
>  {
> -       if (!(trace_flags & TRACE_ITER_PRINTK))
> +       if (!(global_trace_flags() & TRACE_ITER_PRINTK))
>                 return 0;
>
>         return trace_vprintk(ip, fmt, ap);
> diff --git a/kernel/trace/trace_sched_wakeup.c b/kernel/trace/trace_sched_wakeup.c
> index fee77e1..87dc330 100644
> --- a/kernel/trace/trace_sched_wakeup.c
> +++ b/kernel/trace/trace_sched_wakeup.c
> @@ -138,6 +138,7 @@ static struct ftrace_ops trace_ops __read_mostly =
>  static int register_wakeup_function(int graph, int set)
>  {
>         int ret;
> +       int trace_flags = global_trace_flags();
>
>         /* 'set' is set if TRACE_ITER_FUNCTION is about to be set */
>         if (function_enabled || (!set && !(trace_flags & TRACE_ITER_FUNCTION)))
> @@ -583,7 +584,7 @@ static void stop_wakeup_tracer(struct trace_array *tr)
>
>  static int __wakeup_tracer_init(struct trace_array *tr)
>  {
> -       save_flags = trace_flags;
> +       save_flags = global_trace_flags();
>
>         /* non overwrite screws up the latency tracers */
>         set_tracer_flag(tr, TRACE_ITER_OVERWRITE, 1);
> diff --git a/kernel/trace/trace_syscalls.c b/kernel/trace/trace_syscalls.c
> index 559329d..c496eb5 100644
> --- a/kernel/trace/trace_syscalls.c
> +++ b/kernel/trace/trace_syscalls.c
> @@ -134,7 +134,7 @@ print_syscall_enter(struct trace_iterator *iter, int flags,
>
>         for (i = 0; i < entry->nb_args; i++) {
>                 /* parameter types */
> -               if (trace_flags & TRACE_ITER_VERBOSE) {
> +               if (global_trace_flags() & TRACE_ITER_VERBOSE) {
>                         ret = trace_seq_printf(s, "%s ", entry->types[i]);
>                         if (!ret)
>                                 return TRACE_TYPE_PARTIAL_LINE;
> --
> 1.8.4.1
>
