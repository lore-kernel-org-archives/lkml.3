Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935296AbaKNQ1A (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 11:27:00 -0500
Received: from cantor2.suse.de ([195.135.220.15]:37394 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934046AbaKNQ06 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 11:26:58 -0500
Date: Fri, 14 Nov 2014 17:26:52 +0100
From: Petr Mladek <pmladek@suse.cz>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jiri Kosina <jkosina@suse.cz>
Subject: Re: [RFC][PATCH 13/23 v4] tracing: Create seq_buf layer in trace_seq
Message-ID: <20141114162652.GA14538@dhcp128.suse.cz>
References: <20141114011244.256115061@goodmis.org>
 <20141114011412.170377300@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141114011412.170377300@goodmis.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 2014-11-13 20:12:57, Steven Rostedt wrote:
> From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>
> 
> Create a seq_buf layer that trace_seq sits on. The seq_buf will not
> be limited to page size. This will allow other usages of seq_buf
> instead of a hard set PAGE_SIZE one that trace_seq has.
> 
> Link: http://lkml.kernel.org/r/20141104160221.864997179@goodmis.org
> 
> Tested-by: Jiri Kosina <jkosina@suse.cz>
> Acked-by: Jiri Kosina <jkosina@suse.cz>
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> ---
>  include/linux/seq_buf.h              |  81 +++++++++
>  include/linux/trace_seq.h            |  12 +-
>  kernel/trace/Makefile                |   1 +
>  kernel/trace/seq_buf.c               | 341 +++++++++++++++++++++++++++++++++++
>  kernel/trace/trace.c                 |  39 ++--
>  kernel/trace/trace_events.c          |   6 +-
>  kernel/trace/trace_functions_graph.c |   6 +-
>  kernel/trace/trace_seq.c             | 172 +++++++++---------
>  8 files changed, 538 insertions(+), 120 deletions(-)
>  create mode 100644 include/linux/seq_buf.h
>  create mode 100644 kernel/trace/seq_buf.c
> 
> diff --git a/kernel/trace/seq_buf.c b/kernel/trace/seq_buf.c
> new file mode 100644
> index 000000000000..e9a7861595d2
> --- /dev/null
> +++ b/kernel/trace/seq_buf.c
[...]
> +/**
> + * seq_buf_to_user - copy the squence buffer to user space
> + * @s: seq_buf descriptor
> + * @ubuf: The userspace memory location to copy to
> + * @cnt: The amount to copy
> + *
> + * Copies the sequence buffer into the userspace memory pointed to
> + * by @ubuf. It starts from the last read position (@s->readpos)
> + * and writes up to @cnt characters or till it reaches the end of
> + * the content in the buffer (@s->len), which ever comes first.
> + *
> + * On success, it returns a positive number of the number of bytes
> + * it copied.
> + *
> + * On failure it returns -EBUSY if all of the content in the
> + * sequence has been already read, which includes nothing in the
> + * sequence (@s->len == @s->readpos).
> + *
> + * Returns -EFAULT if the copy to userspace fails.
> + */
> +int seq_buf_to_user(struct seq_buf *s, char __user *ubuf, int cnt)
> +{
> +	int len;
> +	int ret;
> +
> +	if (!cnt)
> +		return 0;
> +
> +	if (s->len <= s->readpos)
> +		return -EBUSY;

Ah, we should add here:

	if (seq_buf_has_overflowed(s))
		return -EINVAL;

It will be especially important after appyling "[RFC][PATCH 17/23 v4]
tracing: Have seq_buf use full buffer".

The patch will make "seq.len = seq.size + 1" when there is an
 overflow. It could cause overflow in the following copy_to_user().

It is pity that I have not realized this in the earlier review.
Ach, it was OK in this patch.

> +	len = s->len - s->readpos;
> +	if (cnt > len)
> +		cnt = len;
> +	ret = copy_to_user(ubuf, s->buffer + s->readpos, cnt);
> +	if (ret == cnt)
> +		return -EFAULT;
> +
> +	cnt -= ret;
> +
> +	s->readpos += cnt;
> +	return cnt;
> +}
> diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
> index f5a435a6e8fb..dd43a0d3843a 100644
> --- a/kernel/trace/trace.c
> +++ b/kernel/trace/trace.c
> @@ -938,19 +938,20 @@ out:
>  	return ret;
>  }
>  
> +/* TODO add a seq_buf_to_buffer() */
>  static ssize_t trace_seq_to_buffer(struct trace_seq *s, void *buf, size_t cnt)
>  {
>  	int len;
>  
> -	if (s->len <= s->readpos)
> +	if (s->seq.len <= s->seq.readpos)
>  		return -EBUSY;
>  
> -	len = s->len - s->readpos;
> +	len = s->seq.len - s->seq.readpos;

Similar problem is here. if (seq.len = seq.size + 1) the
following memcpy might access outside of the buffer.

I am afraid that we need to get rid of all direct uses
of seq.len outside of the seq_buf implemetation.

>  	if (cnt > len)
>  		cnt = len;
> -	memcpy(buf, s->buffer + s->readpos, cnt);
> +	memcpy(buf, s->buffer + s->seq.readpos, cnt);
>  
> -	s->readpos += cnt;
> +	s->seq.readpos += cnt;
>  	return cnt;
>  }
>  
> @@ -4314,6 +4315,8 @@ static int tracing_open_pipe(struct inode *inode, struct file *filp)
>  		goto out;
>  	}
>  
> +	trace_seq_init(&iter->seq);
> +
>  	/*
>  	 * We make a copy of the current tracer to avoid concurrent
>  	 * changes on it while we are reading.
> @@ -4510,18 +4513,18 @@ waitagain:
>  	trace_access_lock(iter->cpu_file);
>  	while (trace_find_next_entry_inc(iter) != NULL) {
>  		enum print_line_t ret;
> -		int len = iter->seq.len;
> +		int len = iter->seq.seq.len;
>  
>  		ret = print_trace_line(iter);
>  		if (ret == TRACE_TYPE_PARTIAL_LINE) {
>  			/* don't print partial lines */
> -			iter->seq.len = len;
> +			iter->seq.seq.len = len;

It is fine here because it just restore the original value but...

>  			break;
>  		}
>  		if (ret != TRACE_TYPE_NO_CONSUME)
>  			trace_consume(iter);
>  
> -		if (iter->seq.len >= cnt)
> +		if (iter->seq.seq.len >= cnt)
>  			break;
>  
>  		/*
> @@ -4537,7 +4540,7 @@ waitagain:
>  
>  	/* Now copy what we have to the user */
>  	sret = trace_seq_to_user(&iter->seq, ubuf, cnt);
> -	if (iter->seq.readpos >= iter->seq.len)
> +	if (iter->seq.seq.readpos >= iter->seq.seq.len)
>  		trace_seq_init(&iter->seq);
>  
>  	/*
> @@ -4575,16 +4578,16 @@ tracing_fill_pipe_page(size_t rem, struct trace_iterator *iter)
>  
>  	/* Seq buffer is page-sized, exactly what we need. */
>  	for (;;) {
> -		count = iter->seq.len;
> +		count = iter->seq.seq.len;
>  		ret = print_trace_line(iter);
> -		count = iter->seq.len - count;
> +		count = iter->seq.seq.len - count;

this looks safe as well;

>  		if (rem < count) {
>  			rem = 0;
> -			iter->seq.len -= count;
> +			iter->seq.seq.len -= count;
>  			break;
>  		}
>  		if (ret == TRACE_TYPE_PARTIAL_LINE) {
> -			iter->seq.len -= count;
> +			iter->seq.seq.len -= count;
>  			break;
>  		}
>  
> @@ -4665,13 +4668,13 @@ static ssize_t tracing_splice_read_pipe(struct file *filp,
>  		/* Copy the data into the page, so we can start over. */
>  		ret = trace_seq_to_buffer(&iter->seq,
>  					  page_address(spd.pages[i]),
> -					  iter->seq.len);
> +					  iter->seq.seq.len);
>  		if (ret < 0) {
>  			__free_page(spd.pages[i]);
>  			break;
>  		}
>  		spd.partial[i].offset = 0;
> -		spd.partial[i].len = iter->seq.len;
> +		spd.partial[i].len = iter->seq.seq.len;
>  
>  		trace_seq_init(&iter->seq);
>  	}
> @@ -5672,7 +5675,7 @@ tracing_stats_read(struct file *filp, char __user *ubuf,
>  	cnt = ring_buffer_read_events_cpu(trace_buf->buffer, cpu);
>  	trace_seq_printf(s, "read events: %ld\n", cnt);
>  
> -	count = simple_read_from_buffer(ubuf, count, ppos, s->buffer, s->len);
> +	count = simple_read_from_buffer(ubuf, count, ppos, s->buffer, s->seq.len);

but this looks dangerous.

>  	kfree(s);
>  
> @@ -6635,11 +6638,11 @@ void
>  trace_printk_seq(struct trace_seq *s)
>  {
>  	/* Probably should print a warning here. */
> -	if (s->len >= TRACE_MAX_PRINT)
> -		s->len = TRACE_MAX_PRINT;
> +	if (s->seq.len >= TRACE_MAX_PRINT)
> +		s->seq.len = TRACE_MAX_PRINT;

looks safe


>  	/* should be zero ended, but we are paranoid. */
> -	s->buffer[s->len] = 0;
> +	s->buffer[s->seq.len] = 0;
>  
>  	printk(KERN_TRACE "%s", s->buffer);
>  
> diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
> index 0cc51edde3a8..33525bf6cbf5 100644
> --- a/kernel/trace/trace_events.c
> +++ b/kernel/trace/trace_events.c
> @@ -1044,7 +1044,7 @@ event_filter_read(struct file *filp, char __user *ubuf, size_t cnt,
>  	mutex_unlock(&event_mutex);
>  
>  	if (file)
> -		r = simple_read_from_buffer(ubuf, cnt, ppos, s->buffer, s->len);
> +		r = simple_read_from_buffer(ubuf, cnt, ppos, s->buffer, s->seq.len);

dangerous...

[...]

> diff --git a/kernel/trace/trace_seq.c b/kernel/trace/trace_seq.c
> index e54c0a1fb3f0..3c63b619d6b7 100644
> --- a/kernel/trace/trace_seq.c
> +++ b/kernel/trace/trace_seq.c
[...]
> @@ -72,24 +82,24 @@ int trace_print_seq(struct seq_file *m, struct trace_seq *s)
>   */
>  void trace_seq_printf(struct trace_seq *s, const char *fmt, ...)
>  {
> -	unsigned int len = TRACE_SEQ_BUF_LEFT(s);
> +	unsigned int save_len = s->seq.len;
>  	va_list ap;
> -	int ret;
>  
> -	if (s->full || !len)
> +	if (s->full)
>  		return;
>  
> +	__trace_seq_init(s);
> +
>  	va_start(ap, fmt);
> -	ret = vsnprintf(s->buffer + s->len, len, fmt, ap);
> +	seq_buf_vprintf(&s->seq, fmt, ap);
>  	va_end(ap);
>  
>  	/* If we can't write it all, don't bother writing anything */
> -	if (ret >= len) {
> +	if (unlikely(seq_buf_has_overflowed(&s->seq))) {
> +		s->seq.len = save_len;
>  		s->full = 1;
>  		return;

The return is redundant here.

>  	}
> -
> -	s->len += ret;
>  }
>  EXPORT_SYMBOL_GPL(trace_seq_printf);
>  
> @@ -104,14 +114,19 @@ EXPORT_SYMBOL_GPL(trace_seq_printf);
>  void trace_seq_bitmask(struct trace_seq *s, const unsigned long *maskp,
>  		      int nmaskbits)
>  {
> -	unsigned int len = TRACE_SEQ_BUF_LEFT(s);
> -	int ret;
> +	unsigned int save_len = s->seq.len;
>  
> -	if (s->full || !len)
> +	if (s->full)
>  		return;
>  
> -	ret = bitmap_scnprintf(s->buffer + s->len, len, maskp, nmaskbits);
> -	s->len += ret;
> +	__trace_seq_init(s);
> +
> +	seq_buf_bitmask(&s->seq, maskp, nmaskbits);
> +
> +	if (unlikely(seq_buf_has_overflowed(&s->seq))) {
> +		s->seq.len = save_len;
> +		s->full = 1;
> +	}
>  }
>  EXPORT_SYMBOL_GPL(trace_seq_bitmask);
>  
> @@ -128,21 +143,22 @@ EXPORT_SYMBOL_GPL(trace_seq_bitmask);
>   */
>  void trace_seq_vprintf(struct trace_seq *s, const char *fmt, va_list args)
>  {
> -	unsigned int len = TRACE_SEQ_BUF_LEFT(s);
> +	unsigned int save_len = s->seq.len;
>  	int ret;
>  
> -	if (s->full || !len)
> +	if (s->full)
>  		return;
>  
> -	ret = vsnprintf(s->buffer + s->len, len, fmt, args);
> +	__trace_seq_init(s);
> +
> +	ret = seq_buf_vprintf(&s->seq, fmt, args);

The ret value is not used.

>  	/* If we can't write it all, don't bother writing anything */
> -	if (ret >= len) {
> +	if (unlikely(seq_buf_has_overflowed(&s->seq))) {
> +		s->seq.len = save_len;
>  		s->full = 1;
>  		return;

The return is redundant.

The above mentioned potential overflows happen only if
we apply "[RFC][PATCH 17/23 v4]
tracing: Have seq_buf use full buffer". The code is safe
at this stage. The other problems are minor.

If you decide to address the potential overflows in another
patch, feel free to add to this one:

Reviewed-by: Petr Mladek <pmladek@suse.cz>

Best Regards,
Petr
