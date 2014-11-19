Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755870AbaKSQRW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 11:17:22 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.228]:58029 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754452AbaKSQRV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 11:17:21 -0500
Date: Wed, 19 Nov 2014 11:17:18 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Petr Mladek <pmladek@suse.cz>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jiri Kosina <jkosina@suse.cz>
Subject: Re: [PATCH 1/2] tracing: Clean up tracing_fill_pipe_page()
Message-ID: <20141119111718.11df478d@gandalf.local.home>
In-Reply-To: <20141118161546.GJ23958@pathway.suse.cz>
References: <20141115045847.712848224@goodmis.org>
	<20141115050603.904875201@goodmis.org>
	<20141117123250.10f6f57c@gandalf.local.home>
	<20141117141108.347a30e5@gandalf.local.home>
	<20141118161546.GJ23958@pathway.suse.cz>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.25; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 18 Nov 2014 17:15:46 +0100
Petr Mladek <pmladek@suse.cz> wrote:

> On Mon 2014-11-17 14:11:08, Steven Rostedt wrote:
> > > 
> > > I don't like the fact that I did a code structure change with this
> > > patch. This patch should be just a simple conversion of len to
> > > seq_buf_used(). I'm going to strip this change out and put it before
> > > this patch.
> > 
> > 
> > The function tracing_fill_pipe_page() logic is a little confusing with the
> > use of count saving the seq.len and reusing it.
> > 
> > Instead of subtracting a number that is calculated from the saved
> > value of the seq.len from seq.len, just save the seq.len at the start
> > and if we need to reset it, just assign it again.
> > 
> > When the seq_buf overflow is len == size + 1, the current logic will
> > break. Changing it to use a saved length for resetting back to the
> > original value is more robust and will work when we change the way
> > seq_buf sets the overflow.
> > 
> > Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> > ---
> >  kernel/trace/trace.c | 26 ++++++++++++++++++++------
> >  1 file changed, 20 insertions(+), 6 deletions(-)
> > 
> > diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
> > index 7d7a07e9b9e9..2dbc18e5f929 100644
> > --- a/kernel/trace/trace.c
> > +++ b/kernel/trace/trace.c
> > @@ -4575,23 +4575,37 @@ static size_t
> >  tracing_fill_pipe_page(size_t rem, struct trace_iterator *iter)
> >  {
> >  	size_t count;
> > +	int save_len;
> >  	int ret;
> >  
> >  	/* Seq buffer is page-sized, exactly what we need. */
> >  	for (;;) {
> > -		count = iter->seq.seq.len;
> > +		save_len = iter->seq.seq.len;
> >  		ret = print_trace_line(iter);
> > -		count = iter->seq.seq.len - count;
> > -		if (rem < count) {
> > -			rem = 0;
> > -			iter->seq.seq.len -= count;
> > +
> > +		if (trace_seq_has_overflowed(&iter->seq)) {
> > +			iter->seq.seq.len = save_len;
> >  			break;
> >  		}
> > +
> > +		/*
> > +		 * This should not be hit, because it should only
> > +		 * be set if the iter->seq overflowed. But check it
> > +		 * anyway to be safe.
> > +		 */
> >  		if (ret == TRACE_TYPE_PARTIAL_LINE) {
> > -			iter->seq.seq.len -= count;
> > +			iter->seq.seq.len = save_len;
> >  			break;
> >  		}
> 
> The two ifs has the same body. Small optimization would be to do:
> 
> 		/*
> 		 * The two checks should be equivalent but rather be
> 		 * on the safe side.
> 		 */
> 		if (trace_seq_has_overflowed(&iter->seq) ||
> 		    ret == TRACE_TYPE_PARTIAL_LINE) {
> 			iter->seq.seq.len = save_len;
> 			break;
> 		}

Yeah, I originally had something like that, but I wanted to remove that
second check. I left it separate to make it stand out as something that
might be removed in the future. Just a preference I guess.

> 
> To be honest, the code seems to be a bit twisted. This function
> is called from tracing_splice_read_pipe(). It copies the
> trace_seq buffer into spd.page and call trace_seq_init()
> in a for cycle.

Yeah, that splice code confused me too. I'll start looking at it some
more and see if it can be fixed up.

> 
> Therefore if the overflow happens, trace_find_next_entry_inc()
> is not called in tracing_fill_pipe_page() and we work with the same
> iterator instance next time. It means that the overflow happens most
> likely again and we fill all remaining spd.pages with no data and
> are stacked on the same iterator instance.

Luckily, overflows never happen. But if they do, things might break.

> 
> BTW: The trace_seq_to_buffer() in tracing_splice_read_pipe()
> is suspicious as well. It passes trace_seq_used(&iter->seq)
> as the "cnt" parameter. I guess that it should pass the
> size of the "spd.page" instead.

Wow, I should have looked harder at that code when I accepted it. It
just "worked" and I was happy. Oh well, another thing to fix up.

> 
> Also we should somehow handle the situation when some data are not
> copied. Well, it seems the spd.page has the page size, so it is
> the same size as the trace_seq buffer.
> 
> 
> Well, this patch does not change the behavior. We could solve the
> above problem later if it is there. Maybe I got it wrong.

No, that code doesn't look too good. That's some old stuff that got in
when we were still learning, and if it worked, we added it ;-)

That needs to be cleaned up. I'll put it on my ever growing todo list.
Of course if you want to clean it up, feel free to send some patches on
top of this. That is, if we get the OK from Linus or Andrew.


> 
> Reviewed-by: Petr Mladek <pmladek@suse.cz>
> 

Thanks,

-- Steve
