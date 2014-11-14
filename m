Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161622AbaKNRXM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 12:23:12 -0500
Received: from cantor2.suse.de ([195.135.220.15]:39256 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161017AbaKNRXL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 12:23:11 -0500
Date: Fri, 14 Nov 2014 18:23:06 +0100
From: Petr Mladek <pmladek@suse.cz>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jiri Kosina <jkosina@suse.cz>
Subject: Re: [RFC][PATCH 19/23 v4] seq_buf: Create seq_buf_used() to find out
 how much was written
Message-ID: <20141114172306.GE14538@dhcp128.suse.cz>
References: <20141114011244.256115061@goodmis.org>
 <20141114011413.321654244@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141114011413.321654244@goodmis.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 2014-11-13 20:13:03, Steven Rostedt wrote:
> From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>
> 
> Add a helper function seq_buf_used() that replaces the SEQ_BUF_USED()
> private macro to let callers have a method to know how much of the
> seq_buf was written to.
> 
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

Reviewed-by: Petr Mladek <pmladek@suse.cz>

The patch is correct. But we should move it before "[RFC][PATCH 17/23
v4] tracing: Have seq_buf use full buffer" and use it everywhere
any code is accessing the internal buffer using the seq.len value.
I mean to solve the potential buffer overflows mentioned for
"[RFC][PATCH 13/23 v4] tracing: Create seq_buf layer in trace_seq"

Best Regards,
Petr

> ---
>  include/linux/seq_buf.h | 6 ++++++
>  kernel/trace/seq_buf.c  | 5 +----
>  2 files changed, 7 insertions(+), 4 deletions(-)
> 
> diff --git a/include/linux/seq_buf.h b/include/linux/seq_buf.h
> index 3e550d214187..8fda502ee630 100644
> --- a/include/linux/seq_buf.h
> +++ b/include/linux/seq_buf.h
> @@ -64,6 +64,12 @@ seq_buf_buffer_left(struct seq_buf *s)
>  	return s->size - s->len;
>  }
>  
> +/* How much buffer was written? */
> +static inline unsigned int seq_buf_used(struct seq_buf *s)
> +{
> +	return min((s)->len, (s)->size);
> +}
> +
>  /**
>   * seq_buf_get_buf - get buffer to write arbitrary data to
>   * @s: the seq_buf handle
> diff --git a/kernel/trace/seq_buf.c b/kernel/trace/seq_buf.c
> index 4f35a783b82f..3657af4b5f53 100644
> --- a/kernel/trace/seq_buf.c
> +++ b/kernel/trace/seq_buf.c
> @@ -16,9 +16,6 @@
>  #include <linux/seq_file.h>
>  #include <linux/seq_buf.h>
>  
> -/* How much buffer is written? */
> -#define SEQ_BUF_USED(s) min((s)->len, (s)->size)
> -
>  /**
>   * seq_buf_print_seq - move the contents of seq_buf into a seq_file
>   * @m: the seq_file descriptor that is the destination
> @@ -28,7 +25,7 @@
>   */
>  int seq_buf_print_seq(struct seq_file *m, struct seq_buf *s)
>  {
> -	unsigned int len = SEQ_BUF_USED(s);
> +	unsigned int len = seq_buf_used(s);
>  
>  	return seq_write(m, s->buffer, len);
>  }
> -- 
> 2.1.1
> 
> 
