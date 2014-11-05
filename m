Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755509AbaKEQvl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 11:51:41 -0500
Received: from cantor2.suse.de ([195.135.220.15]:57007 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755341AbaKEQvj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 11:51:39 -0500
Date: Wed, 5 Nov 2014 17:51:25 +0100
From: Petr Mladek <pmladek@suse.cz>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jiri Kosina <jkosina@suse.cz>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [RFC][PATCH 08/12 v3] tracing: Add seq_buf_get_buf() and
 seq_buf_commit() helper functions
Message-ID: <20141105165125.GJ4570@pathway.suse.cz>
References: <20141104155237.228431433@goodmis.org>
 <20141104160222.644881406@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141104160222.644881406@goodmis.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 2014-11-04 10:52:45, Steven Rostedt wrote:
> From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>
> 
> Add two helper functions; seq_buf_get_buf() and seq_buf_commit() that
> are used by seq_buf_path(). This makes the code similar to the
> seq_file: seq_path() function, and will help to be able to consolidate
> the functions between seq_file and trace_seq.
> 
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> ---
>  include/linux/seq_buf.h | 40 ++++++++++++++++++++++++++++++++++++++++
>  kernel/trace/seq_buf.c  |  7 +++----
>  2 files changed, 43 insertions(+), 4 deletions(-)
> 
> diff --git a/include/linux/seq_buf.h b/include/linux/seq_buf.h
> index 3cd25038cb5e..10c17c61c7a4 100644
> --- a/include/linux/seq_buf.h
> +++ b/include/linux/seq_buf.h
> @@ -55,6 +55,46 @@ seq_buf_set_overflow(struct seq_buf *s)
>  	s->len = s->size + 1;
>  }
>  
> +/**
> + * seq_buf_get_buf - get buffer to write arbitrary data to
> + * @s: the seq_buf handle
> + * @bufp: the beginning of the buffer is stored here
> + *
> + * Return the number of bytes available in the buffer, or zero if
> + * there's no space.
> + */
> +static inline size_t seq_buf_get_buf(struct seq_buf *s, char **bufp)
> +{
> +	BUG_ON(s->len > s->size + 1);
> +	if (s->len < s->size) {
> +		*bufp = s->buffer + s->len;
> +		return s->size - s->len;
> +	}
> +	*bufp = NULL;
> +	return 0;
> +}
> +
> +/**
> + * seq_buf_commit - commit data to the buffer
> + * @s: the seq_buf handle
> + * @num: the number of bytes to commit
> + *
> + * Commit @num bytes of data written to a buffer previously acquired
> + * by seq_buf_get.  To signal an error condition, or that the data
> + * didn't fit in the available space, pass a negative @num value.
> + */
> +static inline void seq_buf_commit(struct seq_buf *s, int num)
> +{
> +	if (num < 0) {
> +		s->len = s->size;

I guess that you want to get the buffer into an overflow state. If
yes, it should be:

		s->len = s->size + 1;

or even better

		seq_buf_set_overflow(s);


Note that this whole patch depends on the decision about the 7th patch
("tracing: Have seq_buf use full buffer").

It might make sense to move the SEQ_BUF_LEFT, SEQ_BUF_USED macros to
this header and use them in these two function. Or move the functions
to seq_file.c.

Best Regards,
Petr
