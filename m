Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932471AbaKRPB7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 10:01:59 -0500
Received: from cantor2.suse.de ([195.135.220.15]:59041 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932343AbaKRPB5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 10:01:57 -0500
Date: Tue, 18 Nov 2014 16:02:04 +0100
From: Petr Mladek <pmladek@suse.cz>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jiri Kosina <jkosina@suse.cz>
Subject: Re: [PATCH 18/26 v5] seq_buf: Create seq_buf_used() to find out how
 much was written
Message-ID: <20141118150204.GI23958@pathway.suse.cz>
References: <20141115045847.712848224@goodmis.org>
 <20141115050603.696625970@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141115050603.696625970@goodmis.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 2014-11-14 23:59:05, Steven Rostedt wrote:
> From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>
> 
> Add a helper function seq_buf_used() that replaces the SEQ_BUF_USED()
> private macro to let callers have a method to know how much of the
> seq_buf was written to.
> 
> Link: http://lkml.kernel.org/r/20141114011412.170377300@goodmis.org
> Link: http://lkml.kernel.org/r/20141114011413.321654244@goodmis.org
> 
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> ---
>  include/linux/seq_buf.h | 6 ++++++
>  kernel/trace/seq_buf.c  | 5 +----
>  2 files changed, 7 insertions(+), 4 deletions(-)
> 
> diff --git a/include/linux/seq_buf.h b/include/linux/seq_buf.h
> index 5d91262433e2..93718e570d4c 100644
> --- a/include/linux/seq_buf.h
> +++ b/include/linux/seq_buf.h
> @@ -64,6 +64,12 @@ seq_buf_buffer_left(struct seq_buf *s)
>  	return (s->size - 1) - s->len;
>  }
>  
> +/* How much buffer was written? */
> +static inline unsigned int seq_buf_used(struct seq_buf *s)
> +{
> +	return min(s->len, s->size);

To be precise, it should do

	return min(s->len, s->size - 1);

at this stage and switch to the above code in ("[PATCH 21/26 v5] tracing: Have
seq_buf use full buffer"). Well, it does not cause any big harm. Feel
free to add:

Reviewed-by: Petr Mladek <pmladek@suse.cz>

for this patch or for the updated one.

Best Regards,
Petr

> +}
> +
>  extern __printf(2, 3)
>  int seq_buf_printf(struct seq_buf *s, const char *fmt, ...);
>  extern __printf(2, 0)
> diff --git a/kernel/trace/seq_buf.c b/kernel/trace/seq_buf.c
> index 7dac34d1235b..9ec5305d9da7 100644
> --- a/kernel/trace/seq_buf.c
> +++ b/kernel/trace/seq_buf.c
> @@ -16,9 +16,6 @@
>  #include <linux/seq_file.h>
>  #include <linux/seq_buf.h>
>  
> -/* How much buffer is written? */
> -#define SEQ_BUF_USED(s) min((s)->len, (s)->size - 1)
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
