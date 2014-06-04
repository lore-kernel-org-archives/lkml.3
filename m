Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751889AbaFDTlw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 15:41:52 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.227]:59677 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751197AbaFDTlv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 15:41:51 -0400
Date: Wed, 4 Jun 2014 15:41:49 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Stanislav Fomichev <stfomichev@yandex-team.ru>
Cc: fweisbec@gmail.com, mingo@redhat.com, jovi.zhangwei@huawei.com,
        namhyung.kim@lge.com, tom.zanussi@linux.intel.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHv2] tracing: let user specify tracing_thresh after
 selecting function_graph
Message-ID: <20140604154149.3c2857dc@gandalf.local.home>
In-Reply-To: <20140604133350.GC26511@stfomichev-desktop.yandex.net>
References: <1401815569-10513-1-git-send-email-stfomichev@yandex-team.ru>
	<20140603185720.79552fb8@gandalf.local.home>
	<20140604133350.GC26511@stfomichev-desktop.yandex.net>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 4 Jun 2014 17:33:50 +0400
Stanislav Fomichev <stfomichev@yandex-team.ru> wrote:

> > Ideally there should be a callback for the tracer to deal with it, but
> > instead, you can for now just hardcode a function graph tracer callback
> > into tracing_max_lat_write(). Something like this:
> > 
> > 	if (ptr == &tracing_thresh)
> > 		ftrace_update_func_graph_thresh();
> > 
> > And then if the function tracer is active, stop it, and then restart it
> > with the tracing thresh function.
> Attached new patch which adds new callback and uses it in function_graph
> tracer (not sure whether I need to check graph_array in
> graph_trace_update_thresh). Maybe it makes sense to split it into two commits
> (add callback itself, use it in the function_graph tracer)?

Sometimes it's better to do it in two commits, but as this is rather
a small change, one is good enough.

> 
> Btw, I also tried to use static_keys/jump_labels in places where
> tracing_thresh is checked, but got double faults. Is there a reason I
> can't use jump labels inside tracers?

You mean inside the function tracers. I could envision problems with
that, but I don't know exactly what would cause those problems. Have
patches to show? You may have done something unrelated that caused the
issue.

> 
> ---
> 
> Currently, tracing_thresh works only if we specify it before selecting
> function_graph tracer. If we do the opposite, tracing_thresh will change
> it's value, but it will not be applied.
> To fix it, we add update_thresh callback which is called whenever
> tracing_thresh is updated and for function_graph tracer we register
> handler which reinitializes tracer depending on tracing_thresh.
> 
> Signed-off-by: Stanislav Fomichev <stfomichev@yandex-team.ru>
> ---
>  kernel/trace/trace.c                 | 60 +++++++++++++++++++++++++++++++-----
>  kernel/trace/trace.h                 |  2 ++
>  kernel/trace/trace_functions_graph.c | 10 ++++++
>  3 files changed, 65 insertions(+), 7 deletions(-)
> 
> diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
> index 737b0efa1a62..06fbb4b7e646 100644
> --- a/kernel/trace/trace.c
> +++ b/kernel/trace/trace.c
> @@ -4077,10 +4077,9 @@ tracing_set_trace_write(struct file *filp, const char __user *ubuf,
>  }
>  
>  static ssize_t
> -tracing_max_lat_read(struct file *filp, char __user *ubuf,
> -		     size_t cnt, loff_t *ppos)
> +nsecs_read(unsigned long *ptr, char __user *ubuf,

Nit, although these are static functions, I still like to add "trace"
or "tracing" to their names. Makes it easier to grep for.

> +	   size_t cnt, loff_t *ppos)
>  {
> -	unsigned long *ptr = filp->private_data;
>  	char buf[64];
>  	int r;
>  
> @@ -4092,10 +4091,9 @@ tracing_max_lat_read(struct file *filp, char __user *ubuf,
>  }
>  
>  static ssize_t
> -tracing_max_lat_write(struct file *filp, const char __user *ubuf,
> -		      size_t cnt, loff_t *ppos)
> +nsecs_write(unsigned long *ptr, const char __user *ubuf,
> +	    size_t cnt, loff_t *ppos)
>  {
> -	unsigned long *ptr = filp->private_data;
>  	unsigned long val;
>  	int ret;
>  
> @@ -4108,6 +4106,47 @@ tracing_max_lat_write(struct file *filp, const char __user *ubuf,
>  	return cnt;
>  }
>  
> +static ssize_t
> +tracing_thresh_read(struct file *filp, char __user *ubuf,
> +		    size_t cnt, loff_t *ppos)
> +{
> +	return nsecs_read(&tracing_thresh, ubuf, cnt, ppos);
> +}
> +
> +static ssize_t
> +tracing_thresh_write(struct file *filp, const char __user *ubuf,
> +		     size_t cnt, loff_t *ppos)
> +{
> +	struct trace_array *tr = filp->private_data;
> +	int ret;
> +
> +	ret = nsecs_write(&tracing_thresh, ubuf, cnt, ppos);
> +	if (ret < 0)
> +		return ret;
> +

You need to take the trace_types_lock mutex here, otherwise
current_trace can change from under you.

-- Steve


> +	if (tr->current_trace->update_thresh) {
> +		ret = tr->current_trace->update_thresh(tr);
> +		if (ret)
> +			return ret;
> +	}
> +
> +	return cnt;
> +}
> +
> +static ssize_t
> +tracing_max_lat_read(struct file *filp, char __user *ubuf,
> +		     size_t cnt, loff_t *ppos)
> +{
> +	return nsecs_read(filp->private_data, ubuf, cnt, ppos);
> +}
> +
> +static ssize_t
> +tracing_max_lat_write(struct file *filp, const char __user *ubuf,
> +		      size_t cnt, loff_t *ppos)
> +{
> +	return nsecs_write(filp->private_data, ubuf, cnt, ppos);
> +}
> +
>  static int tracing_open_pipe(struct inode *inode, struct file *filp)
>  {
>  	struct trace_array *tr = inode->i_private;
> @@ -5024,6 +5063,13 @@ static int snapshot_raw_open(struct inode *inode, struct file *filp)
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
> @@ -6359,7 +6405,7 @@ static __init int tracer_init_debugfs(void)
>  #endif
>  
>  	trace_create_file("tracing_thresh", 0644, d_tracer,
> -			&tracing_thresh, &tracing_max_lat_fops);
> +			&global_trace, &tracing_thresh_fops);
>  
>  	trace_create_file("README", 0444, d_tracer,
>  			NULL, &tracing_readme_fops);
> diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
> index 2e29d7ba5a52..960c523de47d 100644
> --- a/kernel/trace/trace.h
> +++ b/kernel/trace/trace.h
> @@ -321,6 +321,7 @@ struct tracer_flags {
>   * @reset: called when one switches to another tracer
>   * @start: called when tracing is unpaused (echo 1 > tracing_enabled)
>   * @stop: called when tracing is paused (echo 0 > tracing_enabled)
> + * @update_thresh: called when tracing_thresh is updated
>   * @open: called when the trace file is opened
>   * @pipe_open: called when the trace_pipe file is opened
>   * @wait_pipe: override how the user waits for traces on trace_pipe
> @@ -340,6 +341,7 @@ struct tracer {
>  	void			(*reset)(struct trace_array *tr);
>  	void			(*start)(struct trace_array *tr);
>  	void			(*stop)(struct trace_array *tr);
> +	int			(*update_thresh)(struct trace_array *tr);
>  	void			(*open)(struct trace_iterator *iter);
>  	void			(*pipe_open)(struct trace_iterator *iter);
>  	void			(*wait_pipe)(struct trace_iterator *iter);
> diff --git a/kernel/trace/trace_functions_graph.c b/kernel/trace/trace_functions_graph.c
> index deff11200261..7440541a3b4f 100644
> --- a/kernel/trace/trace_functions_graph.c
> +++ b/kernel/trace/trace_functions_graph.c
> @@ -450,6 +450,15 @@ static void graph_trace_reset(struct trace_array *tr)
>  {
>  	tracing_stop_cmdline_record();
>  	unregister_ftrace_graph();
> +	set_graph_array(NULL);

Hmm, this looks like it can cause issues. Unless you change
trace_graph_entry() and trace_graph_return to have:

	struct trace_array *tr = ACCESS_ONCE(graph_array);
	[..]

	if (!tr)
		return 0;

-- Steve

> +}
> +
> +void graph_trace_update_thresh(struct trace_array *tr)
> +{
> +	if (graph_array) {
> +		graph_trace_reset(tr);
> +		graph_trace_init(tr);
> +	}
>  }
>  
>  static int max_bytes_for_cpu;
> @@ -1501,6 +1510,7 @@ static struct trace_event graph_trace_ret_event = {
>  
>  static struct tracer graph_trace __tracer_data = {
>  	.name		= "function_graph",
> +	.update_thresh	= graph_trace_update_thresh,
>  	.open		= graph_trace_open,
>  	.pipe_open	= graph_trace_open,
>  	.close		= graph_trace_close,

