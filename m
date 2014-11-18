Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756083AbaKRQPk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 11:15:40 -0500
Received: from cantor2.suse.de ([195.135.220.15]:60634 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754913AbaKRQPj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 11:15:39 -0500
Date: Tue, 18 Nov 2014 17:15:46 +0100
From: Petr Mladek <pmladek@suse.cz>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jiri Kosina <jkosina@suse.cz>
Subject: Re: [PATCH 1/2] tracing: Clean up tracing_fill_pipe_page()
Message-ID: <20141118161546.GJ23958@pathway.suse.cz>
References: <20141115045847.712848224@goodmis.org>
 <20141115050603.904875201@goodmis.org>
 <20141117123250.10f6f57c@gandalf.local.home>
 <20141117141108.347a30e5@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141117141108.347a30e5@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 2014-11-17 14:11:08, Steven Rostedt wrote:
> > 
> > I don't like the fact that I did a code structure change with this
> > patch. This patch should be just a simple conversion of len to
> > seq_buf_used(). I'm going to strip this change out and put it before
> > this patch.
> 
> 
> The function tracing_fill_pipe_page() logic is a little confusing with the
> use of count saving the seq.len and reusing it.
> 
> Instead of subtracting a number that is calculated from the saved
> value of the seq.len from seq.len, just save the seq.len at the start
> and if we need to reset it, just assign it again.
> 
> When the seq_buf overflow is len == size + 1, the current logic will
> break. Changing it to use a saved length for resetting back to the
> original value is more robust and will work when we change the way
> seq_buf sets the overflow.
> 
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> ---
>  kernel/trace/trace.c | 26 ++++++++++++++++++++------
>  1 file changed, 20 insertions(+), 6 deletions(-)
> 
> diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
> index 7d7a07e9b9e9..2dbc18e5f929 100644
> --- a/kernel/trace/trace.c
> +++ b/kernel/trace/trace.c
> @@ -4575,23 +4575,37 @@ static size_t
>  tracing_fill_pipe_page(size_t rem, struct trace_iterator *iter)
>  {
>  	size_t count;
> +	int save_len;
>  	int ret;
>  
>  	/* Seq buffer is page-sized, exactly what we need. */
>  	for (;;) {
> -		count = iter->seq.seq.len;
> +		save_len = iter->seq.seq.len;
>  		ret = print_trace_line(iter);
> -		count = iter->seq.seq.len - count;
> -		if (rem < count) {
> -			rem = 0;
> -			iter->seq.seq.len -= count;
> +
> +		if (trace_seq_has_overflowed(&iter->seq)) {
> +			iter->seq.seq.len = save_len;
>  			break;
>  		}
> +
> +		/*
> +		 * This should not be hit, because it should only
> +		 * be set if the iter->seq overflowed. But check it
> +		 * anyway to be safe.
> +		 */
>  		if (ret == TRACE_TYPE_PARTIAL_LINE) {
> -			iter->seq.seq.len -= count;
> +			iter->seq.seq.len = save_len;
>  			break;
>  		}

The two ifs has the same body. Small optimization would be to do:

		/*
		 * The two checks should be equivalent but rather be
		 * on the safe side.
		 */
		if (trace_seq_has_overflowed(&iter->seq) ||
		    ret == TRACE_TYPE_PARTIAL_LINE) {
			iter->seq.seq.len = save_len;
			break;
		}

To be honest, the code seems to be a bit twisted. This function
is called from tracing_splice_read_pipe(). It copies the
trace_seq buffer into spd.page and call trace_seq_init()
in a for cycle.

Therefore if the overflow happens, trace_find_next_entry_inc()
is not called in tracing_fill_pipe_page() and we work with the same
iterator instance next time. It means that the overflow happens most
likely again and we fill all remaining spd.pages with no data and
are stacked on the same iterator instance.

BTW: The trace_seq_to_buffer() in tracing_splice_read_pipe()
is suspicious as well. It passes trace_seq_used(&iter->seq)
as the "cnt" parameter. I guess that it should pass the
size of the "spd.page" instead.

Also we should somehow handle the situation when some data are not
copied. Well, it seems the spd.page has the page size, so it is
the same size as the trace_seq buffer.


Well, this patch does not change the behavior. We could solve the
above problem later if it is there. Maybe I got it wrong.

Reviewed-by: Petr Mladek <pmladek@suse.cz>

Best Regards,
Petr

> +		count = iter->seq.seq.len - save_len;
> +		if (rem < count) {
> +			rem = 0;
> +			iter->seq.seq.len = save_len;
> +			break;
> +		}
> +
> +
>  		if (ret != TRACE_TYPE_NO_CONSUME)
>  			trace_consume(iter);
>  		rem -= count;
> -- 
> 1.8.1.4
> 
