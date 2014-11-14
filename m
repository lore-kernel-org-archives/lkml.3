Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161356AbaKNQxP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 11:53:15 -0500
Received: from cantor2.suse.de ([195.135.220.15]:38003 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161065AbaKNQxO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 11:53:14 -0500
Date: Fri, 14 Nov 2014 17:53:08 +0100
From: Petr Mladek <pmladek@suse.cz>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jiri Kosina <jkosina@suse.cz>
Subject: Re: [RFC][PATCH 14/23 v4] tracing: Convert seq_buf_path() to be like
 seq_path()
Message-ID: <20141114165308.GB14538@dhcp128.suse.cz>
References: <20141114011244.256115061@goodmis.org>
 <20141114011412.338523371@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141114011412.338523371@goodmis.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 2014-11-13 20:12:58, Steven Rostedt wrote:
> From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>
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
> Reviewed-by: Petr Mladek <pmladek@suse.cz>
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> ---
>  include/linux/seq_buf.h  |  2 +-
>  kernel/trace/seq_buf.c   | 28 ++++++++++++++++------------
>  kernel/trace/trace_seq.c |  4 ++--
>  3 files changed, 19 insertions(+), 15 deletions(-)
> 
> diff --git a/include/linux/seq_buf.h b/include/linux/seq_buf.h
> index 4f7a96a9d71a..38770688a627 100644
> --- a/include/linux/seq_buf.h
> +++ b/include/linux/seq_buf.h
> @@ -73,7 +73,7 @@ extern int seq_buf_putc(struct seq_buf *s, unsigned char c);
>  extern int seq_buf_putmem(struct seq_buf *s, const void *mem, unsigned int len);
>  extern int seq_buf_putmem_hex(struct seq_buf *s, const void *mem,
>  			      unsigned int len);
> -extern int seq_buf_path(struct seq_buf *s, const struct path *path);
> +extern int seq_buf_path(struct seq_buf *s, const struct path *path, const char *esc);
>  
>  extern int seq_buf_bitmask(struct seq_buf *s, const unsigned long *maskp,
>  			   int nmaskbits);
> diff --git a/kernel/trace/seq_buf.c b/kernel/trace/seq_buf.c
> index e9a7861595d2..7dac34d1235b 100644
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
> - * Returns zero on success, -1 on overflow
> + * Returns the number of written bytes on success, -1 on overflow
>   */
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
> index 3c63b619d6b7..475412e31de5 100644
> --- a/kernel/trace/trace_seq.c
> +++ b/kernel/trace/trace_seq.c
> @@ -342,7 +342,7 @@ int trace_seq_path(struct trace_seq *s, const struct path *path)
>  		return 0;
>  	}
>  
> -	ret = seq_buf_path(&s->seq, path);
> +	ret = seq_buf_path(&s->seq, path, "\n");
>  
>  	if (unlikely(seq_buf_has_overflowed(&s->seq))) {
>  		s->seq.len = save_len;
> @@ -350,7 +350,7 @@ int trace_seq_path(struct trace_seq *s, const struct path *path)
>  		return 0;
>  	}
>  
> -	return ret;
> +	return 1;

Ah, I have just realized that this should return -1 when
seq_buf_path() returns -1.

Note that set_buf_path() does not longer calls seq_buf_set_overflow(s)
when the path handling fails. Therefore the above check for overflow
will probably never happen.

Best Regards,
Petr

>  }
>  EXPORT_SYMBOL_GPL(trace_seq_path);
>  
> -- 
> 2.1.1
> 
> 
