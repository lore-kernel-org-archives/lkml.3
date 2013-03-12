Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932802Ab3CLPwo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 11:52:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47730 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754015Ab3CLPwn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 11:52:43 -0400
Date: Tue, 12 Mar 2013 12:52:23 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        David Sharp <dhsharp@google.com>,
        Vaibhav Nagarnaik <vnagarnaik@google.com>, hcochran@lexmark.com
Subject: Re: [for-next][PATCH 5/7] tracing: Fix polling on trace_pipe_raw
Message-ID: <20130312125223.4c2fe25d@redhat.com>
In-Reply-To: <20130302030050.763044060@goodmis.org>
References: <20130302024833.624729274@goodmis.org>
	<20130302030050.763044060@goodmis.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Steven,

Em Fri, 01 Mar 2013 21:48:38 -0500
Steven Rostedt <rostedt@goodmis.org> escreveu:

> From: Steven Rostedt <srostedt@redhat.com>
> 
> The trace_pipe_raw never implemented polling and this was casing
> issues for several utilities. This is now implemented.
> 
> Blocked reads still are on the TODO list.

I tested it and it works fine.

> Reported-by: Mauro Carvalho Chehab <mchehab@redhat.com>

Tested-by: Mauro Carvalho Chehab <mchehab@redhat.com>

> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> ---
>  kernel/trace/trace.c |   78 +++++++++++++++++++++++++++++++++-----------------
>  1 file changed, 51 insertions(+), 27 deletions(-)
> 
> diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
> index 00e5e6e..b958e9d 100644
> --- a/kernel/trace/trace.c
> +++ b/kernel/trace/trace.c
> @@ -3503,10 +3503,8 @@ static int tracing_release_pipe(struct inode *inode, struct file *file)
>  }
>  
>  static unsigned int
> -tracing_poll_pipe(struct file *filp, poll_table *poll_table)
> +trace_poll(struct trace_iterator *iter, struct file *filp, poll_table *poll_table)
>  {
> -	struct trace_iterator *iter = filp->private_data;
> -
>  	if (trace_flags & TRACE_ITER_BLOCK) {
>  		/*
>  		 * Always select as readable when in blocking mode
> @@ -3515,6 +3513,7 @@ tracing_poll_pipe(struct file *filp, poll_table *poll_table)
>  	} else {
>  		if (!trace_empty(iter))
>  			return POLLIN | POLLRDNORM;
> +		trace_wakeup_needed = true;
>  		poll_wait(filp, &trace_wait, poll_table);
>  		if (!trace_empty(iter))
>  			return POLLIN | POLLRDNORM;
> @@ -3523,6 +3522,14 @@ tracing_poll_pipe(struct file *filp, poll_table *poll_table)
>  	}
>  }
>  
> +static unsigned int
> +tracing_poll_pipe(struct file *filp, poll_table *poll_table)
> +{
> +	struct trace_iterator *iter = filp->private_data;
> +
> +	return trace_poll(iter, filp, poll_table);
> +}
> +
>  /*
>   * This is a make-shift waitqueue.
>   * A tracer might use this callback on some rare cases:
> @@ -4312,9 +4319,8 @@ static const struct file_operations snapshot_fops = {
>  #endif /* CONFIG_TRACER_SNAPSHOT */
>  
>  struct ftrace_buffer_info {
> -	struct trace_array	*tr;
> +	struct trace_iterator	iter;
>  	void			*spare;
> -	int			cpu;
>  	unsigned int		read;
>  };
>  
> @@ -4331,22 +4337,32 @@ static int tracing_buffers_open(struct inode *inode, struct file *filp)
>  	if (!info)
>  		return -ENOMEM;
>  
> -	info->tr	= tr;
> -	info->cpu	= tc->cpu;
> -	info->spare	= NULL;
> +	info->iter.tr		= tr;
> +	info->iter.cpu_file	= tc->cpu;
> +	info->spare		= NULL;
>  	/* Force reading ring buffer for first read */
> -	info->read	= (unsigned int)-1;
> +	info->read		= (unsigned int)-1;
>  
>  	filp->private_data = info;
>  
>  	return nonseekable_open(inode, filp);
>  }
>  
> +static unsigned int
> +tracing_buffers_poll(struct file *filp, poll_table *poll_table)
> +{
> +	struct ftrace_buffer_info *info = filp->private_data;
> +	struct trace_iterator *iter = &info->iter;
> +
> +	return trace_poll(iter, filp, poll_table);
> +}
> +
>  static ssize_t
>  tracing_buffers_read(struct file *filp, char __user *ubuf,
>  		     size_t count, loff_t *ppos)
>  {
>  	struct ftrace_buffer_info *info = filp->private_data;
> +	struct trace_iterator *iter = &info->iter;
>  	ssize_t ret;
>  	size_t size;
>  
> @@ -4354,7 +4370,7 @@ tracing_buffers_read(struct file *filp, char __user *ubuf,
>  		return 0;
>  
>  	if (!info->spare)
> -		info->spare = ring_buffer_alloc_read_page(info->tr->buffer, info->cpu);
> +		info->spare = ring_buffer_alloc_read_page(iter->tr->buffer, iter->cpu_file);
>  	if (!info->spare)
>  		return -ENOMEM;
>  
> @@ -4362,12 +4378,12 @@ tracing_buffers_read(struct file *filp, char __user *ubuf,
>  	if (info->read < PAGE_SIZE)
>  		goto read;
>  
> -	trace_access_lock(info->cpu);
> -	ret = ring_buffer_read_page(info->tr->buffer,
> +	trace_access_lock(iter->cpu_file);
> +	ret = ring_buffer_read_page(iter->tr->buffer,
>  				    &info->spare,
>  				    count,
> -				    info->cpu, 0);
> -	trace_access_unlock(info->cpu);
> +				    iter->cpu_file, 0);
> +	trace_access_unlock(iter->cpu_file);
>  	if (ret < 0)
>  		return 0;
>  
> @@ -4392,9 +4408,10 @@ read:
>  static int tracing_buffers_release(struct inode *inode, struct file *file)
>  {
>  	struct ftrace_buffer_info *info = file->private_data;
> +	struct trace_iterator *iter = &info->iter;
>  
>  	if (info->spare)
> -		ring_buffer_free_read_page(info->tr->buffer, info->spare);
> +		ring_buffer_free_read_page(iter->tr->buffer, info->spare);
>  	kfree(info);
>  
>  	return 0;
> @@ -4461,6 +4478,7 @@ tracing_buffers_splice_read(struct file *file, loff_t *ppos,
>  			    unsigned int flags)
>  {
>  	struct ftrace_buffer_info *info = file->private_data;
> +	struct trace_iterator *iter = &info->iter;
>  	struct partial_page partial_def[PIPE_DEF_BUFFERS];
>  	struct page *pages_def[PIPE_DEF_BUFFERS];
>  	struct splice_pipe_desc spd = {
> @@ -4491,8 +4509,9 @@ tracing_buffers_splice_read(struct file *file, loff_t *ppos,
>  		len &= PAGE_MASK;
>  	}
>  
> -	trace_access_lock(info->cpu);
> -	entries = ring_buffer_entries_cpu(info->tr->buffer, info->cpu);
> + again:
> +	trace_access_lock(iter->cpu_file);
> +	entries = ring_buffer_entries_cpu(iter->tr->buffer, iter->cpu_file);
>  
>  	for (i = 0; i < pipe->buffers && len && entries; i++, len -= PAGE_SIZE) {
>  		struct page *page;
> @@ -4503,15 +4522,15 @@ tracing_buffers_splice_read(struct file *file, loff_t *ppos,
>  			break;
>  
>  		ref->ref = 1;
> -		ref->buffer = info->tr->buffer;
> -		ref->page = ring_buffer_alloc_read_page(ref->buffer, info->cpu);
> +		ref->buffer = iter->tr->buffer;
> +		ref->page = ring_buffer_alloc_read_page(ref->buffer, iter->cpu_file);
>  		if (!ref->page) {
>  			kfree(ref);
>  			break;
>  		}
>  
>  		r = ring_buffer_read_page(ref->buffer, &ref->page,
> -					  len, info->cpu, 1);
> +					  len, iter->cpu_file, 1);
>  		if (r < 0) {
>  			ring_buffer_free_read_page(ref->buffer, ref->page);
>  			kfree(ref);
> @@ -4535,20 +4554,24 @@ tracing_buffers_splice_read(struct file *file, loff_t *ppos,
>  		spd.nr_pages++;
>  		*ppos += PAGE_SIZE;
>  
> -		entries = ring_buffer_entries_cpu(info->tr->buffer, info->cpu);
> +		entries = ring_buffer_entries_cpu(iter->tr->buffer, iter->cpu_file);
>  	}
>  
> -	trace_access_unlock(info->cpu);
> +	trace_access_unlock(iter->cpu_file);
>  	spd.nr_pages = i;
>  
>  	/* did we read anything? */
>  	if (!spd.nr_pages) {
> -		if ((file->f_flags & O_NONBLOCK) || (flags & SPLICE_F_NONBLOCK))
> +		if ((file->f_flags & O_NONBLOCK) || (flags & SPLICE_F_NONBLOCK)) {
>  			ret = -EAGAIN;
> -		else
> -			ret = 0;
> -		/* TODO: block */
> -		goto out;
> +			goto out;
> +		}
> +		default_wait_pipe(iter);
> +		if (signal_pending(current)) {
> +			ret = -EINTR;
> +			goto out;
> +		}
> +		goto again;
>  	}
>  
>  	ret = splice_to_pipe(pipe, &spd);
> @@ -4560,6 +4583,7 @@ out:
>  static const struct file_operations tracing_buffers_fops = {
>  	.open		= tracing_buffers_open,
>  	.read		= tracing_buffers_read,
> +	.poll		= tracing_buffers_poll,
>  	.release	= tracing_buffers_release,
>  	.splice_read	= tracing_buffers_splice_read,
>  	.llseek		= no_llseek,


-- 

Cheers,
Mauro
