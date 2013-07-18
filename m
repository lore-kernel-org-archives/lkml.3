Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933122Ab3GRQbb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 12:31:31 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:23826 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932660Ab3GRQb3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 12:31:29 -0400
X-Authority-Analysis: v=2.0 cv=KJ7Y/S5o c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=rxMKrXxpLKgA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=vDktvXBGtYUA:10 a=1XWaLZrsAAAA:8 a=pGLkceISAAAA:8 a=nkW9qR943R_xdZEl3EgA:9 a=QEXdDO2ut3YA:10 a=UTB_XpHje0EA:10 a=MSl-tDqOz04A:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-ID: <1374165087.6458.247.camel@gandalf.local.home>
Subject: Re: [PATCH 1/2] tracing: Miscellaneous fixes for trace_array ref
 counting
From: Steven Rostedt <rostedt@goodmis.org>
To: Alexander Z Lam <azl@google.com>
Cc: linux-kernel@vger.kernel.org, David Sharp <dhsharp@google.com>,
        Vaibhav Nagarnaik <vnagarnaik@google.com>,
        Alexander Z Lam <lambchop468@gmail.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Date: Thu, 18 Jul 2013 12:31:27 -0400
In-Reply-To: <1373502874-1706-1-git-send-email-azl@google.com>
References: <1373502874-1706-1-git-send-email-azl@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-07-10 at 17:34 -0700, Alexander Z Lam wrote:
> Some error paths did not handle ref counting properly, and some trace files need
> ref counting.
> 
> Cc: Vaibhav Nagarnaik <vnagarnaik@google.com>
> Cc: David Sharp <dhsharp@google.com>
> Cc: Alexander Z Lam <lambchop468@gmail.com>
> Signed-off-by: Alexander Z Lam <azl@google.com>
> ---
>  kernel/trace/trace.c        | 34 +++++++++++++++++++++++-----------
>  kernel/trace/trace_events.c | 21 +++++++++++++++++++--
>  2 files changed, 42 insertions(+), 13 deletions(-)
> 
> diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
> index 0cd500b..ca2743b 100644
> --- a/kernel/trace/trace.c
> +++ b/kernel/trace/trace.c
> @@ -3008,7 +3008,6 @@ static int tracing_release(struct inode *inode, struct file *file)
>  
>  	iter = m->private;
>  	tr = iter->tr;
> -	trace_array_put(tr);
>  
>  	mutex_lock(&trace_types_lock);
>  
> @@ -3023,6 +3022,9 @@ static int tracing_release(struct inode *inode, struct file *file)
>  	if (!iter->snapshot)
>  		/* reenable tracing if it was previously enabled */
>  		tracing_start_tr(tr);
> +
> +	__trace_array_put(tr);
> +
>  	mutex_unlock(&trace_types_lock);
>  
>  	mutex_destroy(&iter->mutex);
> @@ -3447,6 +3449,7 @@ tracing_trace_options_write(struct file *filp, const char __user *ubuf,
>  static int tracing_trace_options_open(struct inode *inode, struct file *file)
>  {
>  	struct trace_array *tr = inode->i_private;
> +	int ret;
>  
>  	if (tracing_disabled)
>  		return -ENODEV;
> @@ -3454,7 +3457,11 @@ static int tracing_trace_options_open(struct inode *inode, struct file *file)
>  	if (trace_array_get(tr) < 0)
>  		return -ENODEV;
>  
> -	return single_open(file, tracing_trace_options_show, inode->i_private);
> +	ret = single_open(file, tracing_trace_options_show, inode->i_private);
> +	if (ret < 0)
> +		trace_array_put(tr);
> +
> +	return ret;
>  }
>  
>  static const struct file_operations tracing_iter_fops = {
> @@ -3958,7 +3965,7 @@ static int tracing_open_pipe(struct inode *inode, struct file *filp)
>  	iter = kzalloc(sizeof(*iter), GFP_KERNEL);
>  	if (!iter) {
>  		ret = -ENOMEM;
> -		goto out;
> +		goto fail_iter;

It would be cleaner to not add the extra label, and just do a
trace_array_put() in the if statement.


>  	}
>  
>  	/*
> @@ -3968,13 +3975,13 @@ static int tracing_open_pipe(struct inode *inode, struct file *filp)
>  	iter->trace = kmalloc(sizeof(*iter->trace), GFP_KERNEL);
>  	if (!iter->trace) {
>  		ret = -ENOMEM;
> -		goto fail;
> +		goto fail_trace;
>  	}
>  	*iter->trace = *tr->current_trace;
>  
>  	if (!alloc_cpumask_var(&iter->started, GFP_KERNEL)) {
>  		ret = -ENOMEM;
> -		goto fail;
> +		goto fail_trace;
>  	}
>  
>  	/* trace pipe does not show start of buffer */
> @@ -4001,9 +4008,10 @@ out:
>  	mutex_unlock(&trace_types_lock);
>  	return ret;
>  
> -fail:
> +fail_trace:
>  	kfree(iter->trace);
>  	kfree(iter);
> +fail_iter:
>  	__trace_array_put(tr);
>  	mutex_unlock(&trace_types_lock);
>  	return ret;
> @@ -4705,12 +4713,15 @@ static int tracing_snapshot_open(struct inode *inode, struct file *file)
>  	} else {
>  		/* Writes still need the seq_file to hold the private data */
>  		m = kzalloc(sizeof(*m), GFP_KERNEL);
> -		if (!m)
> -			return -ENOMEM;
> +		if (!m) {
> +			ret = -ENOMEM;
> +			goto out;
> +		}

Instead of adding the complex if statement, do this:


	int ret = -ENOMEM;

	[..]

	if (!m)
		goto out;

And then after the if statements:

	ret = 0;

>  		iter = kzalloc(sizeof(*iter), GFP_KERNEL);
>  		if (!iter) {
>  			kfree(m);
> -			return -ENOMEM;
> +			ret = -ENOMEM;
> +			goto out;
>  		}
>  		iter->tr = tr;
>  		iter->trace_buffer = &tc->tr->max_buffer;
> @@ -4718,7 +4729,7 @@ static int tracing_snapshot_open(struct inode *inode, struct file *file)
>  		m->private = iter;
>  		file->private_data = m;
>  	}
> -
> +out:
>  	if (ret < 0)
>  		trace_array_put(tr);
>  

The rest looks good. Although, we may be rewriting all this code because
there still exists some races. See the email threads between Oleg and
Masami.

-- Steve


> @@ -5328,9 +5339,10 @@ tracing_stats_read(struct file *filp, char __user *ubuf,
>  }
>  
>  static const struct file_operations tracing_stats_fops = {
> -	.open		= tracing_open_generic,
> +	.open		= tracing_open_generic_tc,
>  	.read		= tracing_stats_read,
>  	.llseek		= generic_file_llseek,
> +	.release	= tracing_release_generic_tc,
>  };
>  
>  #ifdef CONFIG_DYNAMIC_FTRACE
> diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
> index 7d85429..7a75cb2 100644
> --- a/kernel/trace/trace_events.c
> +++ b/kernel/trace/trace_events.c
> @@ -1218,6 +1218,7 @@ show_header(struct file *filp, char __user *ubuf, size_t cnt, loff_t *ppos)
>  
>  static int ftrace_event_avail_open(struct inode *inode, struct file *file);
>  static int ftrace_event_set_open(struct inode *inode, struct file *file);
> +static int ftrace_event_release(struct inode *inode, struct file *file);
>  
>  static const struct seq_operations show_event_seq_ops = {
>  	.start = t_start,
> @@ -1245,7 +1246,7 @@ static const struct file_operations ftrace_set_event_fops = {
>  	.read = seq_read,
>  	.write = ftrace_event_write,
>  	.llseek = seq_lseek,
> -	.release = seq_release,
> +	.release = ftrace_event_release,
>  };
>  
>  static const struct file_operations ftrace_enable_fops = {
> @@ -1323,6 +1324,15 @@ ftrace_event_open(struct inode *inode, struct file *file,
>  	return ret;
>  }
>  
> +static int ftrace_event_release(struct inode *inode, struct file *file)
> +{
> +	struct trace_array *tr = inode->i_private;
> +
> +	trace_array_put(tr);
> +
> +	return seq_release(inode, file);
> +}
> +
>  static int
>  ftrace_event_avail_open(struct inode *inode, struct file *file)
>  {
> @@ -1336,12 +1346,19 @@ ftrace_event_set_open(struct inode *inode, struct file *file)
>  {
>  	const struct seq_operations *seq_ops = &show_set_event_seq_ops;
>  	struct trace_array *tr = inode->i_private;
> +	int ret;
> +
> +	if (trace_array_get(tr) < 0)
> +		return -ENODEV;
>  
>  	if ((file->f_mode & FMODE_WRITE) &&
>  	    (file->f_flags & O_TRUNC))
>  		ftrace_clear_events(tr);
>  
> -	return ftrace_event_open(inode, file, seq_ops);
> +	ret = ftrace_event_open(inode, file, seq_ops);
> +	if (ret < 0)
> +		trace_array_put(tr);
> +	return ret;
>  }
>  
>  static struct event_subsystem *


