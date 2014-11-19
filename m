Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755808AbaKSOvp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 09:51:45 -0500
Received: from cantor2.suse.de ([195.135.220.15]:58275 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753808AbaKSOvo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 09:51:44 -0500
Date: Wed, 19 Nov 2014 15:51:38 +0100
From: Petr Mladek <pmladek@suse.cz>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jiri Kosina <jkosina@suse.cz>
Subject: Re: [PATCH 14/26 v5] tracing: Create seq_buf layer in trace_seq
Message-ID: <20141119145133.GC2332@dhcp128.suse.cz>
References: <20141115045847.712848224@goodmis.org>
 <20141115050602.986728758@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141115050602.986728758@goodmis.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 2014-11-14 23:59:01, Steven Rostedt wrote:
> From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>
> 
> Create a seq_buf layer that trace_seq sits on. The seq_buf will not
> be limited to page size. This will allow other usages of seq_buf
> instead of a hard set PAGE_SIZE one that trace_seq has.
> 
> Link: http://lkml.kernel.org/r/20141104160221.864997179@goodmis.org
> Link: http://lkml.kernel.org/r/20141114011412.170377300@goodmis.org
> 
> Tested-by: Jiri Kosina <jkosina@suse.cz>
> Acked-by: Jiri Kosina <jkosina@suse.cz>
> Reviewed-by: Petr Mladek <pmladek@suse.cz>
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> ---
>  include/linux/seq_buf.h              |  81 +++++++++
>  include/linux/trace_seq.h            |  12 +-
>  kernel/trace/Makefile                |   1 +
>  kernel/trace/seq_buf.c               | 341 +++++++++++++++++++++++++++++++++++
>  kernel/trace/trace.c                 |  39 ++--
>  kernel/trace/trace_events.c          |   6 +-
>  kernel/trace/trace_functions_graph.c |   6 +-
>  kernel/trace/trace_seq.c             | 177 +++++++++---------
>  8 files changed, 538 insertions(+), 125 deletions(-)
>  create mode 100644 include/linux/seq_buf.h
>  create mode 100644 kernel/trace/seq_buf.c

[...]
 
> diff --git a/kernel/trace/trace_functions_graph.c b/kernel/trace/trace_functions_graph.c
> index 100288d10e1f..6d1342ae7a44 100644
> --- a/kernel/trace/trace_functions_graph.c
> +++ b/kernel/trace/trace_functions_graph.c

[...]

> @@ -163,21 +176,22 @@ EXPORT_SYMBOL_GPL(trace_seq_vprintf);
>   */
>  void trace_seq_bprintf(struct trace_seq *s, const char *fmt, const u32 *binary)
>  {
> -	unsigned int len = TRACE_SEQ_BUF_LEFT(s);
> +	unsigned int save_len = s->seq.len;
>  	int ret;

Last but one small thing. The "ret" is assigned but not longer used.

JFYI, I have skipped this patch yesterday because it was long and already
marked as reviewed. I could not help myself and double checked it today.

> -	if (s->full || !len)
> +	if (s->full)
>  		return;
>  
> -	ret = bstr_printf(s->buffer + s->len, len, fmt, binary);
> +	__trace_seq_init(s);
> +
> +	ret = seq_buf_bprintf(&s->seq, fmt, binary);
>  
>  	/* If we can't write it all, don't bother writing anything */
> -	if (ret >= len) {
> +	if (unlikely(seq_buf_has_overflowed(&s->seq))) {
> +		s->seq.len = save_len;
>  		s->full = 1;
>  		return;
>  	}
> -
> -	s->len += ret;
>  }
>  EXPORT_SYMBOL_GPL(trace_seq_bprintf);

The last small thing is the same unused "ret" in trace_seq_path(). But
this one should get fixed in "[PATCH 15/26 v5] tracing: Convert
seq_buf_path() to be like seq_path()".

Both these changes are rather cosmetic. Feel free to leave them for
some later clean up.


Eureka, I have finished review of the patchset and am happy with it \o/
I am looking forward to see it in the main tree.

Thanks a lot for the hard work.

Best Regards,
Petr
