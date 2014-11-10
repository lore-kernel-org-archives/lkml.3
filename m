Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751678AbaKJSdh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 13:33:37 -0500
Received: from cantor2.suse.de ([195.135.220.15]:48762 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751306AbaKJSdg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 13:33:36 -0500
Date: Mon, 10 Nov 2014 19:33:29 +0100
From: Petr Mladek <pmladek@suse.cz>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jiri Kosina <jkosina@suse.cz>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [RFC][PATCH 08/12 v3] tracing: Add seq_buf_get_buf() and
 seq_buf_commit() helper functions
Message-ID: <20141110183329.GA2552@dhcp128.suse.cz>
References: <20141104155237.228431433@goodmis.org>
 <20141104160222.644881406@goodmis.org>
 <20141105165125.GJ4570@pathway.suse.cz>
 <20141107133929.7aa1dfe9@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141107133929.7aa1dfe9@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 2014-11-07 13:39:29, Steven Rostedt wrote:
> More updates. Hmm, maybe I should have posted the full series ;-)
> 
> -- Steve
> 
> From 41a3f3f5e772ca26ef4441a0312d3f108693d7dc Mon Sep 17 00:00:00 2001
> From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>
> Date: Wed, 29 Oct 2014 17:30:50 -0400
> Subject: [PATCH] tracing: Add seq_buf_get_buf() and seq_buf_commit() helper
>  functions
> 
> Add two helper functions; seq_buf_get_buf() and seq_buf_commit() that
> are used by seq_buf_path(). This makes the code similar to the
> seq_file: seq_path() function, and will help to be able to consolidate
> the functions between seq_file and trace_seq.
> 
> Link: http://lkml.kernel.org/r/20141104160222.644881406@goodmis.org
> 
> Tested-by: Jiri Kosina <jkosina@suse.cz>
> Acked-by: Jiri Kosina <jkosina@suse.cz>
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

Reviewed-by: Petr Mladek <pmladek@suse.cz>

Well, I am curious about the BUG_ONs, see below.

> ---
>  include/linux/seq_buf.h | 40 ++++++++++++++++++++++++++++++++++++++++
>  kernel/trace/seq_buf.c  |  7 +++----
>  2 files changed, 43 insertions(+), 4 deletions(-)
> 
> diff --git a/include/linux/seq_buf.h b/include/linux/seq_buf.h
> index 4aab47d10760..7dacdc791225 100644
> --- a/include/linux/seq_buf.h
> +++ b/include/linux/seq_buf.h
> @@ -61,6 +61,46 @@ seq_buf_buffer_left(struct seq_buf *s)
>  	return s->size - s->len;
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

I just wonder if the BUG_ON() is appropriate here. There is used
WARN_ON() for the other similar checks.

On one hand. This function will be used by a code that manipulates
the buffer its own way. Therefore the BUG() would help to debug
potential problems.

On the other hand, this function is used just to get the buffer.
Therefore the BUG() might come too late. The buffer was broken
somewhere else.

> +
> +	if (s->len < s->size) {
> +		*bufp = s->buffer + s->len;
> +		return s->size - s->len;
> +	}
> +
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
> +		seq_buf_set_overflow(s);
> +	} else {
> +		BUG_ON(s->len + num > s->size + 1);

I agree that the BUG_ON makes sense here. If someone passed too big
"num", she probably also wrote too many bytes and the memory is
corrupted at this point.

> +		s->len += num;
> +	}
> +}
> +

Best Regards,
Petr
