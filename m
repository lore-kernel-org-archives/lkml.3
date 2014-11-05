Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754803AbaKEOqK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 09:46:10 -0500
Received: from cantor2.suse.de ([195.135.220.15]:52581 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751198AbaKEOqI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 09:46:08 -0500
Date: Wed, 5 Nov 2014 15:45:53 +0100
From: Petr Mladek <pmladek@suse.cz>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jiri Kosina <jkosina@suse.cz>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [RFC][PATCH 04/12 v3] tracing: Convert seq_buf_path() to be like
 seq_path()
Message-ID: <20141105144553.GE4570@pathway.suse.cz>
References: <20141104155237.228431433@goodmis.org>
 <20141104160222.048795666@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141104160222.048795666@goodmis.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 2014-11-04 10:52:41, Steven Rostedt wrote:
> From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>
> 
> Rewrite seq_buf_path() like it is done in seq_path() and allow
> it to accept any escape character instead of just "\n".
> 
> Making seq_buf_path() like seq_path() will help prevent problems
> when converting seq_file to use the seq_buf logic.
> 
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> ---
>  include/linux/seq_buf.h  |  2 +-
>  kernel/trace/seq_buf.c   | 30 ++++++++++++++++--------------
>  kernel/trace/trace_seq.c |  2 +-
>  3 files changed, 18 insertions(+), 16 deletions(-)
> 
> diff --git a/include/linux/seq_buf.h b/include/linux/seq_buf.h
> index 97872154d51c..6d1c57d6073f 100644
> --- a/include/linux/seq_buf.h
> +++ b/include/linux/seq_buf.h
> @@ -64,7 +64,7 @@ extern int seq_buf_putc(struct seq_buf *s, unsigned char c);
>  extern int seq_buf_putmem(struct seq_buf *s, const void *mem, unsigned int len);
>  extern int seq_buf_putmem_hex(struct seq_buf *s, const void *mem,
>  			      unsigned int len);
> -extern int seq_buf_path(struct seq_buf *s, const struct path *path);
> +extern int seq_buf_path(struct seq_buf *s, const struct path *path, const char *esc);
>  
>  extern int seq_buf_bitmask(struct seq_buf *s, const unsigned long *maskp,
>  			   int nmaskbits);
> diff --git a/kernel/trace/seq_buf.c b/kernel/trace/seq_buf.c
> index 2bf582753902..243123b12d16 100644
> --- a/kernel/trace/seq_buf.c
> +++ b/kernel/trace/seq_buf.c
> @@ -272,28 +272,30 @@ int seq_buf_putmem_hex(struct seq_buf *s, const void *mem,
>   * seq_buf_path - copy a path into the sequence buffer
>   * @s: seq_buf descriptor
>   * @path: path to write into the sequence buffer.
> + * @esc: set of characters to escape in the output
>   *
>   * Write a path name into the sequence buffer.
>   *
>   * Returns zero on success, -1 on overflow
>
>   */
> -int seq_buf_path(struct seq_buf *s, const struct path *path)
> +int seq_buf_path(struct seq_buf *s, const struct path *path, const char *esc)
>  {
> -	unsigned int len = SEQ_BUF_LEFT(s);
> -	unsigned char *p;
> -
> -	WARN_ON(s->size == 0);

I would keep this check.

> -	p = d_path(path, s->buffer + s->len, len);
> -	if (!IS_ERR(p)) {
> -		p = mangle_path(s->buffer + s->len, p, "\n");
> -		if (p) {
> -			s->len = p - s->buffer;
> -			return 0;
> +	char *buf = s->buffer + s->len;
> +	size_t size = SEQ_BUF_LEFT(s);

I would use the variable name "len" to make it consistent with
the other fucntions in seq_buf.c.

> +	int res = -1;
> +
> +	if (size) {
> +		char *p = d_path(path, buf, size);
> +		if (!IS_ERR(p)) {
> +			char *end = mangle_path(buf, p, esc);
> +			if (end)
> +				res = end - buf;
>  		}
>  	}
> -	seq_buf_set_overflow(s);

We still should set overflow on failure.

> -	return -1;
> +	if (res > 0)
> +		s->len += res;
> +
> +	return res;

It returns -1 on failure and the number of written characters on
success. This is incompatible with the other seq_buf functions
and with the comment above this function. Also it changes the
return value from trace_seq_path().

I do not mind about the used scheme but I think that we should
make it consistent.

Best Regards,
Petr
