Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752815AbaKJODK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 09:03:10 -0500
Received: from cantor2.suse.de ([195.135.220.15]:40165 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751999AbaKJODJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 09:03:09 -0500
Date: Mon, 10 Nov 2014 15:03:25 +0100
From: Petr Mladek <pmladek@suse.cz>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jiri Kosina <jkosina@suse.cz>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [RFC][PATCH 04/12 v3] tracing: Convert seq_buf_path() to be like
 seq_path()
Message-ID: <20141110140324.GD2160@pathway.suse.cz>
References: <20141104155237.228431433@goodmis.org>
 <20141104160222.048795666@goodmis.org>
 <20141106150143.GF2001@dhcp128.suse.cz>
 <20141107133413.6e37755e@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141107133413.6e37755e@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 2014-11-07 13:34:13, Steven Rostedt wrote:
> 
> I made a few touch ups on this patch.
> 
> -- Steve
> 
> From 309e8ce4cc1605d3038b16b8e43219a2867f47b1 Mon Sep 17 00:00:00 2001
> From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>
> Date: Wed, 29 Oct 2014 13:48:37 -0400
> Subject: [PATCH] tracing: Convert seq_buf_path() to be like seq_path()
> 
> Rewrite seq_buf_path() like it is done in seq_path() and allow
> it to accept any escape character instead of just "\n".
> 
> Making seq_buf_path() like seq_path() will help prevent problems
> when converting seq_file to use the seq_buf logic.
> 
> Link: http://lkml.kernel.org/r/20141104160222.048795666@goodmis.org
> 
> Tested-by: Jiri Kosina <jkosina@suse.cz>
> Acked-by: Jiri Kosina <jkosina@suse.cz>
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> ---
>  include/linux/seq_buf.h  |  2 +-
>  kernel/trace/seq_buf.c   | 26 +++++++++++++++-----------
>  kernel/trace/trace_seq.c |  4 ++--
>  3 files changed, 18 insertions(+), 14 deletions(-)
> 
> diff --git a/include/linux/seq_buf.h b/include/linux/seq_buf.h
> index 64bf5a43411e..aec09b126082 100644
> --- a/include/linux/seq_buf.h
> +++ b/include/linux/seq_buf.h
> @@ -70,7 +70,7 @@ extern int seq_buf_putc(struct seq_buf *s, unsigned char c);
>  extern int seq_buf_putmem(struct seq_buf *s, const void *mem, unsigned int len);
>  extern int seq_buf_putmem_hex(struct seq_buf *s, const void *mem,
>  			      unsigned int len);
> -extern int seq_buf_path(struct seq_buf *s, const struct path *path);
> +extern int seq_buf_path(struct seq_buf *s, const struct path *path, const char *esc);
>  
>  extern int seq_buf_bitmask(struct seq_buf *s, const unsigned long *maskp,
>  			   int nmaskbits);
> diff --git a/kernel/trace/seq_buf.c b/kernel/trace/seq_buf.c
> index 88738b200bf3..ac6eb864c946 100644
> --- a/kernel/trace/seq_buf.c
> +++ b/kernel/trace/seq_buf.c
> @@ -272,28 +272,32 @@ int seq_buf_putmem_hex(struct seq_buf *s, const void *mem,
>   * seq_buf_path - copy a path into the sequence buffer
>   * @s: seq_buf descriptor
>   * @path: path to write into the sequence buffer.
> + * @esc: set of characters to escape in the output
>   *
>   * Write a path name into the sequence buffer.
>   *
>   * Returns zero on success, -1 on overflow

This should be

   * Returns the number of written bytes on success, -1 on overflow


This is just a minor issue. I believe the you would fix it. Feel free to add:

Reviewed-by: Petr Mladek <pmladek@suse.cz>

Best Regards,
Petr

> -int seq_buf_path(struct seq_buf *s, const struct path *path)
> +int seq_buf_path(struct seq_buf *s, const struct path *path, const char *esc)
>  {
> -	unsigned int len = seq_buf_buffer_left(s);
> -	unsigned char *p;
> +	char *buf = s->buffer + s->len;
> +	size_t size = seq_buf_buffer_left(s);
> +	int res = -1;
>  
>  	WARN_ON(s->size == 0);
>  
> -	p = d_path(path, s->buffer + s->len, len);
> -	if (!IS_ERR(p)) {
> -		p = mangle_path(s->buffer + s->len, p, "\n");
> -		if (p) {
> -			s->len = p - s->buffer;
> -			return 0;
> +	if (size) {
> +		char *p = d_path(path, buf, size);
> +		if (!IS_ERR(p)) {
> +			char *end = mangle_path(buf, p, esc);
> +			if (end)
> +				res = end - buf;
>  		}
>  	}
> -	seq_buf_set_overflow(s);
> -	return -1;
> +	if (res > 0)
> +		s->len += res;
> +
> +	return res;
>  }
>  
>  /**
> diff --git a/kernel/trace/trace_seq.c b/kernel/trace/trace_seq.c
> index 3ad8738aea19..64550ed28e76 100644
> --- a/kernel/trace/trace_seq.c
> +++ b/kernel/trace/trace_seq.c
> @@ -382,7 +382,7 @@ int trace_seq_path(struct trace_seq *s, const struct path *path)
>  		return 0;
>  	}
>  
> -	ret = seq_buf_path(&s->seq, path);
> +	ret = seq_buf_path(&s->seq, path, "\n");
>  
>  	if (unlikely(seq_buf_has_overflowed(&s->seq))) {
>  		s->seq.len = save_len;
> @@ -390,7 +390,7 @@ int trace_seq_path(struct trace_seq *s, const struct path *path)
>  		return 0;
>  	}
>  
> -	return ret;
> +	return 1;
>  }
>  EXPORT_SYMBOL_GPL(trace_seq_path);
>  
> -- 
> 2.1.1
> 
