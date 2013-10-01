Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755985Ab3JAD65 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 23:58:57 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:5768 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755629Ab3JAD6z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 23:58:55 -0400
Message-ID: <1380599926.16752.7.camel@pippen.local.home>
Subject: Re: [RFC/PATCH] ftrace: add set_graph_notrace filter
From: Steven Rostedt <rostedt@goodmis.org>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>
Date: Mon, 30 Sep 2013 23:58:46 -0400
In-Reply-To: <87txh2okn9.fsf@sejong.aot.lge.com>
References: <1378184708-31385-1-git-send-email-namhyung@kernel.org>
	 <87txh2okn9.fsf@sejong.aot.lge.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-4+b1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-09-30 at 16:04 +0900, Namhyung Kim wrote:
> Ping!

Ah I missed this patch. And I'm currently traveling.

I'll start testing it when I get back on Friday, but feel free to ping
me again next Monday.

-- Steve

> 
> On Tue,  3 Sep 2013 14:05:08 +0900, Namhyung Kim wrote:
> > From: Namhyung Kim <namhyung.kim@lge.com>
> >
> > The set_graph_notrace filter is analogous to set_ftrace_notrace and
> > can be used for eliminating uninteresting part of function graph trace
> > output.  It also works with set_graph_function nicely.
> >
> >   # cd /sys/kernel/debug/tracing/
> >   # echo do_page_fault > set_graph_function
> >   # perf ftrace live true
> >    2)               |  do_page_fault() {
> >    2)               |    __do_page_fault() {
> >    2)   0.381 us    |      down_read_trylock();
> >    2)   0.055 us    |      __might_sleep();
> >    2)   0.696 us    |      find_vma();
> >    2)               |      handle_mm_fault() {
> >    2)               |        handle_pte_fault() {
> >    2)               |          __do_fault() {
> >    2)               |            filemap_fault() {
> >    2)               |              find_get_page() {
> >    2)   0.033 us    |                __rcu_read_lock();
> >    2)   0.035 us    |                __rcu_read_unlock();
> >    2)   1.696 us    |              }
> >    2)   0.031 us    |              __might_sleep();
> >    2)   2.831 us    |            }
> >    2)               |            _raw_spin_lock() {
> >    2)   0.046 us    |              add_preempt_count();
> >    2)   0.841 us    |            }
> >    2)   0.033 us    |            page_add_file_rmap();
> >    2)               |            _raw_spin_unlock() {
> >    2)   0.057 us    |              sub_preempt_count();
> >    2)   0.568 us    |            }
> >    2)               |            unlock_page() {
> >    2)   0.084 us    |              page_waitqueue();
> >    2)   0.126 us    |              __wake_up_bit();
> >    2)   1.117 us    |            }
> >    2)   7.729 us    |          }
> >    2)   8.397 us    |        }
> >    2)   8.956 us    |      }
> >    2)   0.085 us    |      up_read();
> >    2) + 12.745 us   |    }
> >    2) + 13.401 us   |  }
> >   ...
> >
> >   # echo handle_mm_fault > set_graph_notrace
> >   # perf ftrace live true
> >    1)               |  do_page_fault() {
> >    1)               |    __do_page_fault() {
> >    1)   0.205 us    |      down_read_trylock();
> >    1)   0.041 us    |      __might_sleep();
> >    1)   0.344 us    |      find_vma();
> >    1)   0.069 us    |      up_read();
> >    1)   4.692 us    |    }
> >    1)   5.311 us    |  }
> >   ...
> >
> > Signed-off-by: Namhyung Kim <namhyung@kernel.org>
> > ---
> >  include/linux/ftrace.h               |   1 +
> >  kernel/trace/ftrace.c                | 118 ++++++++++++++++++++++++++++++++++-
> >  kernel/trace/trace.h                 |  23 +++++++
> >  kernel/trace/trace_functions_graph.c |  21 ++++++-
> >  4 files changed, 159 insertions(+), 4 deletions(-)
> >
> > diff --git a/include/linux/ftrace.h b/include/linux/ftrace.h
> > index 9f15c0064c50..ec85d48619e1 100644
> > --- a/include/linux/ftrace.h
> > +++ b/include/linux/ftrace.h
> > @@ -721,6 +721,7 @@ ftrace_push_return_trace(unsigned long ret, unsigned long func, int *depth,
> >  extern char __irqentry_text_start[];
> >  extern char __irqentry_text_end[];
> >  
> > +#define FTRACE_NOTRACE_DEPTH 65536
> >  #define FTRACE_RETFUNC_DEPTH 50
> >  #define FTRACE_RETSTACK_ALLOC_SIZE 32
> >  extern int register_ftrace_graph(trace_func_graph_ret_t retfunc,
> > diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
> > index a6d098c6df3f..1b1f3409f788 100644
> > --- a/kernel/trace/ftrace.c
> > +++ b/kernel/trace/ftrace.c
> > @@ -3819,6 +3819,43 @@ static const struct seq_operations ftrace_graph_seq_ops = {
> >  	.show = g_show,
> >  };
> >  
> > +int ftrace_graph_notrace_count;
> > +int ftrace_graph_notrace_enabled;
> > +unsigned long ftrace_graph_notrace_funcs[FTRACE_GRAPH_MAX_FUNCS] __read_mostly;
> > +
> > +static void *
> > +__n_next(struct seq_file *m, loff_t *pos)
> > +{
> > +	if (*pos >= ftrace_graph_notrace_count)
> > +		return NULL;
> > +	return &ftrace_graph_notrace_funcs[*pos];
> > +}
> > +
> > +static void *
> > +n_next(struct seq_file *m, void *v, loff_t *pos)
> > +{
> > +	(*pos)++;
> > +	return __n_next(m, pos);
> > +}
> > +
> > +static void *n_start(struct seq_file *m, loff_t *pos)
> > +{
> > +	mutex_lock(&graph_lock);
> > +
> > +	/* Nothing, tell g_show to print all functions are enabled */
> > +	if (!ftrace_graph_notrace_enabled && !*pos)
> > +		return (void *)1;
> > +
> > +	return __n_next(m, pos);
> > +}
> > +
> > +static const struct seq_operations ftrace_graph_notrace_seq_ops = {
> > +	.start = n_start,
> > +	.next = n_next,
> > +	.stop = g_stop,
> > +	.show = g_show,
> > +};
> > +
> >  static int
> >  ftrace_graph_open(struct inode *inode, struct file *file)
> >  {
> > @@ -3843,6 +3880,30 @@ ftrace_graph_open(struct inode *inode, struct file *file)
> >  }
> >  
> >  static int
> > +ftrace_graph_notrace_open(struct inode *inode, struct file *file)
> > +{
> > +	int ret = 0;
> > +
> > +	if (unlikely(ftrace_disabled))
> > +		return -ENODEV;
> > +
> > +	mutex_lock(&graph_lock);
> > +	if ((file->f_mode & FMODE_WRITE) &&
> > +	    (file->f_flags & O_TRUNC)) {
> > +		ftrace_graph_notrace_enabled = 0;
> > +		ftrace_graph_notrace_count = 0;
> > +		memset(ftrace_graph_notrace_funcs, 0,
> > +		       sizeof(ftrace_graph_notrace_funcs));
> > +	}
> > +	mutex_unlock(&graph_lock);
> > +
> > +	if (file->f_mode & FMODE_READ)
> > +		ret = seq_open(file, &ftrace_graph_notrace_seq_ops);
> > +
> > +	return ret;
> > +}
> > +
> > +static int
> >  ftrace_graph_release(struct inode *inode, struct file *file)
> >  {
> >  	if (file->f_mode & FMODE_READ)
> > @@ -3910,8 +3971,6 @@ out:
> >  	if (fail)
> >  		return -EINVAL;
> >  
> > -	ftrace_graph_filter_enabled = !!(*idx);
> > -
> >  	return 0;
> >  }
> >  
> > @@ -3946,6 +4005,50 @@ ftrace_graph_write(struct file *file, const char __user *ubuf,
> >  
> >  	ret = read;
> >  
> > +	ftrace_graph_filter_enabled = ftrace_graph_count > 0;
> > +
> > +out_free:
> > +	trace_parser_put(&parser);
> > +out_unlock:
> > +	mutex_unlock(&graph_lock);
> > +
> > +	return ret;
> > +}
> > +
> > +static ssize_t
> > +ftrace_graph_notrace_write(struct file *file, const char __user *ubuf,
> > +			   size_t cnt, loff_t *ppos)
> > +{
> > +	struct trace_parser parser;
> > +	ssize_t read, ret;
> > +
> > +	if (!cnt)
> > +		return 0;
> > +
> > +	mutex_lock(&graph_lock);
> > +
> > +	if (trace_parser_get_init(&parser, FTRACE_BUFF_MAX)) {
> > +		ret = -ENOMEM;
> > +		goto out_unlock;
> > +	}
> > +
> > +	read = trace_get_user(&parser, ubuf, cnt, ppos);
> > +
> > +	if (read >= 0 && trace_parser_loaded((&parser))) {
> > +		parser.buffer[parser.idx] = 0;
> > +
> > +		/* we allow only one expression at a time */
> > +		ret = ftrace_set_func(ftrace_graph_notrace_funcs,
> > +				      &ftrace_graph_notrace_count,
> > +				      parser.buffer);
> > +		if (ret)
> > +			goto out_free;
> > +	}
> > +
> > +	ret = read;
> > +
> > +	ftrace_graph_notrace_enabled = ftrace_graph_notrace_count > 0;
> > +
> >  out_free:
> >  	trace_parser_put(&parser);
> >  out_unlock:
> > @@ -3961,6 +4064,14 @@ static const struct file_operations ftrace_graph_fops = {
> >  	.llseek		= ftrace_filter_lseek,
> >  	.release	= ftrace_graph_release,
> >  };
> > +
> > +static const struct file_operations ftrace_graph_notrace_fops = {
> > +	.open		= ftrace_graph_notrace_open,
> > +	.read		= seq_read,
> > +	.write		= ftrace_graph_notrace_write,
> > +	.llseek		= ftrace_filter_lseek,
> > +	.release	= ftrace_graph_release,
> > +};
> >  #endif /* CONFIG_FUNCTION_GRAPH_TRACER */
> >  
> >  static __init int ftrace_init_dyn_debugfs(struct dentry *d_tracer)
> > @@ -3982,6 +4093,9 @@ static __init int ftrace_init_dyn_debugfs(struct dentry *d_tracer)
> >  	trace_create_file("set_graph_function", 0444, d_tracer,
> >  				    NULL,
> >  				    &ftrace_graph_fops);
> > +	trace_create_file("set_graph_notrace", 0444, d_tracer,
> > +				    NULL,
> > +				    &ftrace_graph_notrace_fops);
> >  #endif /* CONFIG_FUNCTION_GRAPH_TRACER */
> >  
> >  	return 0;
> > diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
> > index fe39acd4c1aa..797f6f7f3f56 100644
> > --- a/kernel/trace/trace.h
> > +++ b/kernel/trace/trace.h
> > @@ -732,6 +732,9 @@ extern void __trace_graph_return(struct trace_array *tr,
> >  extern int ftrace_graph_filter_enabled;
> >  extern int ftrace_graph_count;
> >  extern unsigned long ftrace_graph_funcs[FTRACE_GRAPH_MAX_FUNCS];
> > +extern int ftrace_graph_notrace_enabled;
> > +extern int ftrace_graph_notrace_count;
> > +extern unsigned long ftrace_graph_notrace_funcs[FTRACE_GRAPH_MAX_FUNCS];
> >  
> >  static inline int ftrace_graph_addr(unsigned long addr)
> >  {
> > @@ -757,11 +760,31 @@ static inline int ftrace_graph_addr(unsigned long addr)
> >  
> >  	return 0;
> >  }
> > +
> > +static inline int ftrace_graph_notrace_addr(unsigned long addr)
> > +{
> > +	int i;
> > +
> > +	if (!ftrace_graph_notrace_enabled)
> > +		return 0;
> > +
> > +	for (i = 0; i < ftrace_graph_notrace_count; i++) {
> > +		if (addr == ftrace_graph_notrace_funcs[i])
> > +			return 1;
> > +	}
> > +
> > +	return 0;
> > +}
> >  #else
> >  static inline int ftrace_graph_addr(unsigned long addr)
> >  {
> >  	return 1;
> >  }
> > +
> > +static inline int ftrace_graph_notrace_addr(unsigned long addr)
> > +{
> > +	return 0;
> > +}
> >  #endif /* CONFIG_DYNAMIC_FTRACE */
> >  #else /* CONFIG_FUNCTION_GRAPH_TRACER */
> >  static inline enum print_line_t
> > diff --git a/kernel/trace/trace_functions_graph.c b/kernel/trace/trace_functions_graph.c
> > index b5c09242683d..3ba240daa5e0 100644
> > --- a/kernel/trace/trace_functions_graph.c
> > +++ b/kernel/trace/trace_functions_graph.c
> > @@ -114,16 +114,22 @@ ftrace_push_return_trace(unsigned long ret, unsigned long func, int *depth,
> >  		return -EBUSY;
> >  	}
> >  
> > +	/* The function was filtered out */
> > +	if (current->curr_ret_stack < -1)
> > +		return -EBUSY;
> > +
> >  	calltime = trace_clock_local();
> >  
> >  	index = ++current->curr_ret_stack;
> > +	if (ftrace_graph_notrace_addr(func))
> > +		current->curr_ret_stack -= FTRACE_NOTRACE_DEPTH;
> >  	barrier();
> >  	current->ret_stack[index].ret = ret;
> >  	current->ret_stack[index].func = func;
> >  	current->ret_stack[index].calltime = calltime;
> >  	current->ret_stack[index].subtime = 0;
> >  	current->ret_stack[index].fp = frame_pointer;
> > -	*depth = index;
> > +	*depth = current->curr_ret_stack;
> >  
> >  	return 0;
> >  }
> > @@ -137,6 +143,9 @@ ftrace_pop_return_trace(struct ftrace_graph_ret *trace, unsigned long *ret,
> >  
> >  	index = current->curr_ret_stack;
> >  
> > +	if (index < 0)
> > +		index += FTRACE_NOTRACE_DEPTH;
> > +
> >  	if (unlikely(index < 0)) {
> >  		ftrace_graph_stop();
> >  		WARN_ON(1);
> > @@ -193,6 +202,10 @@ unsigned long ftrace_return_to_handler(unsigned long frame_pointer)
> >  	trace.rettime = trace_clock_local();
> >  	barrier();
> >  	current->curr_ret_stack--;
> > +	if (current->curr_ret_stack < -1) {
> > +		current->curr_ret_stack += FTRACE_NOTRACE_DEPTH;
> > +		return ret;
> > +	}
> >  
> >  	/*
> >  	 * The trace should run after decrementing the ret counter
> > @@ -259,10 +272,14 @@ int trace_graph_entry(struct ftrace_graph_ent *trace)
> >  
> >  	/* trace it when it is-nested-in or is a function enabled. */
> >  	if ((!(trace->depth || ftrace_graph_addr(trace->func)) ||
> > -	     ftrace_graph_ignore_irqs()) ||
> > +	     ftrace_graph_ignore_irqs()) || (trace->depth < 0) ||
> >  	    (max_depth && trace->depth >= max_depth))
> >  		return 0;
> >  
> > +	/* need to reserve a ret_stack entry to recover the depth */
> > +	if (ftrace_graph_notrace_addr(trace->func))
> > +		return 1;
> > +
> >  	local_irq_save(flags);
> >  	cpu = raw_smp_processor_id();
> >  	data = per_cpu_ptr(tr->trace_buffer.data, cpu);


