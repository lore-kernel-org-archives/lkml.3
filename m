Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751640AbaGQSJC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 14:09:02 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.231]:30465 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750763AbaGQSJA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 14:09:00 -0400
Date: Thu, 17 Jul 2014 14:08:51 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Stanislav Fomichev <stfomichev@yandex-team.ru>
Cc: fweisbec@gmail.com, mingo@redhat.com, jovi.zhangwei@huawei.com,
        namhyung.kim@lge.com, tom.zanussi@linux.intel.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHv3] tracing: let user specify tracing_thresh after
 selecting function_graph
Message-ID: <20140717140851.3aa616f0@gandalf.local.home>
In-Reply-To: <20140715153157.GC5127@stfomichev-desktop.yandex.net>
References: <1401815569-10513-1-git-send-email-stfomichev@yandex-team.ru>
	<20140603185720.79552fb8@gandalf.local.home>
	<20140604133350.GC26511@stfomichev-desktop.yandex.net>
	<20140604154149.3c2857dc@gandalf.local.home>
	<20140605073839.GG26511@stfomichev-desktop.yandex.net>
	<20140715092719.GB5127@stfomichev-desktop.yandex.net>
	<20140715090436.1d660119@gandalf.local.home>
	<20140715153157.GC5127@stfomichev-desktop.yandex.net>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Jul 2014 19:31:57 +0400
Stanislav Fomichev <stfomichev@yandex-team.ru> wrote:

> Currently, tracing_thresh works only if we specify it before selecting
> function_graph tracer. If we do the opposite, tracing_thresh will change
> it's value, but it will not be applied.
> To fix it, we add update_thresh callback which is called whenever
> tracing_thresh is updated and for function_graph tracer we register
> handler which reinitializes tracer depending on tracing_thresh.
> 
> Signed-off-by: Stanislav Fomichev <stfomichev@yandex-team.ru>
> ---
>  kernel/trace/trace.c                 | 65 ++++++++++++++++++++++++++++++++----
>  kernel/trace/trace.h                 |  2 ++
>  kernel/trace/trace_functions_graph.c | 20 +++++++++--
>  3 files changed, 77 insertions(+), 10 deletions(-)
> 
> diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
> index f243444a3772..986e6cad27d7 100644
> --- a/kernel/trace/trace.c
> +++ b/kernel/trace/trace.c
> @@ -4224,10 +4224,9 @@ tracing_set_trace_write(struct file *filp, const char __user *ubuf,
>  }
>  
>  static ssize_t
> -tracing_max_lat_read(struct file *filp, char __user *ubuf,
> -		     size_t cnt, loff_t *ppos)
> +tracing_nsecs_read(unsigned long *ptr, char __user *ubuf,
> +		   size_t cnt, loff_t *ppos)
>  {
> -	unsigned long *ptr = filp->private_data;
>  	char buf[64];
>  	int r;
>  
> @@ -4239,10 +4238,9 @@ tracing_max_lat_read(struct file *filp, char __user *ubuf,
>  }
>  
>  static ssize_t
> -tracing_max_lat_write(struct file *filp, const char __user *ubuf,
> -		      size_t cnt, loff_t *ppos)
> +tracing_nsecs_write(unsigned long *ptr, const char __user *ubuf,
> +		    size_t cnt, loff_t *ppos)
>  {
> -	unsigned long *ptr = filp->private_data;
>  	unsigned long val;
>  	int ret;
>  
> @@ -4255,6 +4253,52 @@ tracing_max_lat_write(struct file *filp, const char __user *ubuf,
>  	return cnt;
>  }
>  
> +static ssize_t
> +tracing_thresh_read(struct file *filp, char __user *ubuf,
> +		    size_t cnt, loff_t *ppos)
> +{
> +	return tracing_nsecs_read(&tracing_thresh, ubuf, cnt, ppos);
> +}
> +
> +static ssize_t
> +tracing_thresh_write(struct file *filp, const char __user *ubuf,
> +		     size_t cnt, loff_t *ppos)
> +{
> +	struct trace_array *tr = filp->private_data;
> +	int ret;
> +
> +	mutex_lock(&trace_types_lock);
> +	ret = tracing_nsecs_write(&tracing_thresh, ubuf, cnt, ppos);
> +	if (ret < 0)
> +		goto out;
> +
> +	if (tr->current_trace->update_thresh) {
> +		ret = tr->current_trace->update_thresh(tr);
> +		if (ret < 0)
> +			goto out;
> +	}
> +
> +	ret = cnt;
> +out:
> +	mutex_unlock(&trace_types_lock);
> +
> +	return ret;
> +}
> +
> +static ssize_t
> +tracing_max_lat_read(struct file *filp, char __user *ubuf,
> +		     size_t cnt, loff_t *ppos)
> +{
> +	return tracing_nsecs_read(filp->private_data, ubuf, cnt, ppos);
> +}
> +
> +static ssize_t
> +tracing_max_lat_write(struct file *filp, const char __user *ubuf,
> +		      size_t cnt, loff_t *ppos)
> +{
> +	return tracing_nsecs_write(filp->private_data, ubuf, cnt, ppos);
> +}
> +
>  static int tracing_open_pipe(struct inode *inode, struct file *filp)
>  {
>  	struct trace_array *tr = inode->i_private;
> @@ -5156,6 +5200,13 @@ static int snapshot_raw_open(struct inode *inode, struct file *filp)
>  #endif /* CONFIG_TRACER_SNAPSHOT */
>  
>  
> +static const struct file_operations tracing_thresh_fops = {
> +	.open		= tracing_open_generic,
> +	.read		= tracing_thresh_read,
> +	.write		= tracing_thresh_write,
> +	.llseek		= generic_file_llseek,
> +};
> +
>  static const struct file_operations tracing_max_lat_fops = {
>  	.open		= tracing_open_generic,
>  	.read		= tracing_max_lat_read,
> @@ -6519,7 +6570,7 @@ static __init int tracer_init_debugfs(void)
>  	init_tracer_debugfs(&global_trace, d_tracer);
>  
>  	trace_create_file("tracing_thresh", 0644, d_tracer,
> -			&tracing_thresh, &tracing_max_lat_fops);
> +			&global_trace, &tracing_thresh_fops);
>  
>  	trace_create_file("README", 0444, d_tracer,
>  			NULL, &tracing_readme_fops);
> diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
> index 9258f5a815db..385391fb1d3b 100644
> --- a/kernel/trace/trace.h
> +++ b/kernel/trace/trace.h
> @@ -339,6 +339,7 @@ struct tracer_flags {
>   * @reset: called when one switches to another tracer
>   * @start: called when tracing is unpaused (echo 1 > tracing_enabled)
>   * @stop: called when tracing is paused (echo 0 > tracing_enabled)
> + * @update_thresh: called when tracing_thresh is updated
>   * @open: called when the trace file is opened
>   * @pipe_open: called when the trace_pipe file is opened
>   * @close: called when the trace file is released
> @@ -357,6 +358,7 @@ struct tracer {
>  	void			(*reset)(struct trace_array *tr);
>  	void			(*start)(struct trace_array *tr);
>  	void			(*stop)(struct trace_array *tr);
> +	int			(*update_thresh)(struct trace_array *tr);
>  	void			(*open)(struct trace_iterator *iter);
>  	void			(*pipe_open)(struct trace_iterator *iter);
>  	void			(*close)(struct trace_iterator *iter);
> diff --git a/kernel/trace/trace_functions_graph.c b/kernel/trace/trace_functions_graph.c
> index 4de3e57f723c..10d86cf83cb8 100644
> --- a/kernel/trace/trace_functions_graph.c
> +++ b/kernel/trace/trace_functions_graph.c
> @@ -279,7 +279,7 @@ static inline int ftrace_graph_ignore_irqs(void)
>  
>  int trace_graph_entry(struct ftrace_graph_ent *trace)
>  {
> -	struct trace_array *tr = graph_array;
> +	struct trace_array *tr = ACCESS_ONCE(graph_array);
>  	struct trace_array_cpu *data;
>  	unsigned long flags;
>  	long disabled;
> @@ -287,7 +287,7 @@ int trace_graph_entry(struct ftrace_graph_ent *trace)
>  	int cpu;
>  	int pc;
>  
> -	if (!ftrace_trace_task(current))
> +	if (!tr || !ftrace_trace_task(current))
>  		return 0;
>  
>  	/* trace it when it is-nested-in or is a function enabled. */
> @@ -384,13 +384,16 @@ void __trace_graph_return(struct trace_array *tr,
>  
>  void trace_graph_return(struct ftrace_graph_ret *trace)
>  {
> -	struct trace_array *tr = graph_array;
> +	struct trace_array *tr = ACCESS_ONCE(graph_array);
>  	struct trace_array_cpu *data;
>  	unsigned long flags;
>  	long disabled;
>  	int cpu;
>  	int pc;
>  
> +	if (!tr)
> +		return;
> +

Let's not add branches into the fast path. This isn't needed. I'll
explain below.


>  	local_irq_save(flags);
>  	cpu = raw_smp_processor_id();
>  	data = per_cpu_ptr(tr->trace_buffer.data, cpu);
> @@ -443,6 +446,16 @@ static void graph_trace_reset(struct trace_array *tr)
>  {
>  	tracing_stop_cmdline_record();
>  	unregister_ftrace_graph();
> +	set_graph_array(NULL);
> +}
> +
> +int graph_trace_update_thresh(struct trace_array *tr)

The only way graph_trace_update_thresh() can be called is if the
current tracer happens to be the function graph tracer. Which means
that we are currently tracing and graph_array will be set. This will
not be called if function graph tracing is not set, because it is
called with the trace_types_lock mutex held.

Get rid of the graph_array tests and don't modify it. That is, just do
the reset and init unconditionally here.

-- Steve

> +{
> +	if (graph_array) {
> +		graph_trace_reset(tr);
> +		return graph_trace_init(tr);
> +	}
> +	return 0;
>  }
>  
>  static int max_bytes_for_cpu;
> @@ -1495,6 +1508,7 @@ static struct trace_event graph_trace_ret_event = {
>  
>  static struct tracer graph_trace __tracer_data = {
>  	.name		= "function_graph",
> +	.update_thresh	= graph_trace_update_thresh,
>  	.open		= graph_trace_open,
>  	.pipe_open	= graph_trace_open,
>  	.close		= graph_trace_close,

