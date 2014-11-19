Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752741AbaKSLkp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 06:40:45 -0500
Received: from cantor2.suse.de ([195.135.220.15]:52995 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751587AbaKSLko (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 06:40:44 -0500
Date: Wed, 19 Nov 2014 12:40:17 +0100
From: Petr Mladek <pmladek@suse.cz>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jiri Kosina <jkosina@suse.cz>
Subject: Re: [PATCH 2/2] tracing: Use trace_seq_used() and seq_buf_used()
 instead of len
Message-ID: <20141119114017.GA2332@dhcp128.suse.cz>
References: <20141115045847.712848224@goodmis.org>
 <20141115050603.904875201@goodmis.org>
 <20141117123250.10f6f57c@gandalf.local.home>
 <20141117141215.2dbd5f12@gandalf.local.home>
 <20141118163354.GK23958@pathway.suse.cz>
 <20141118123732.462b1ad8@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141118123732.462b1ad8@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 2014-11-18 12:37:32, Steven Rostedt wrote:
> On Tue, 18 Nov 2014 17:33:54 +0100
> Petr Mladek <pmladek@suse.cz> wrote:
> 
> > On Mon 2014-11-17 14:12:15, Steven Rostedt wrote:
> > > 
> > > > I don't like the fact that I did a code structure change with this
> > > > patch. This patch should be just a simple conversion of len to
> > > > seq_buf_used(). I'm going to strip this change out and put it before
> > > > this patch.
> > > 
> > > 
> > > As the seq_buf->len will soon be +1 size when there's an overflow, we
> > > must use trace_seq_used() or seq_buf_used() methods to get the real
> > > length. This will prevent buffer overflow issues if just the len
> > > of the seq_buf descriptor is used to copy memory.
> > > 
> > > Link: http://lkml.kernel.org/r/20141114121911.09ba3d38@gandalf.local.home
> > > 
> > > Reported-by: Petr Mladek <pmladek@suse.cz>
> > > Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> > > ---
> > >  include/linux/trace_seq.h            | 20 +++++++++++++++++++-
> > >  kernel/trace/seq_buf.c               |  2 +-
> > >  kernel/trace/trace.c                 | 22 +++++++++++-----------
> > >  kernel/trace/trace_events.c          |  9 ++++++---
> > >  kernel/trace/trace_functions_graph.c |  5 ++++-
> > >  kernel/trace/trace_seq.c             |  2 +-
> > >  6 files changed, 42 insertions(+), 18 deletions(-)
> > 
> > [...]
> > 
> > 
> > > --- a/kernel/trace/trace.c
> > > +++ b/kernel/trace/trace.c
> > > @@ -944,10 +944,10 @@ static ssize_t trace_seq_to_buffer(struct trace_seq *s, void *buf, size_t cnt)
> > >  {
> > >  	int len;
> > >  
> > > -	if (s->seq.len <= s->seq.readpos)
> > > +	if (trace_seq_used(s) <= s->seq.readpos)
> > >  		return -EBUSY;
> > >  
> > > -	len = s->seq.len - s->seq.readpos;
> > > +	len = trace_seq_used(s) - s->seq.readpos;
> > >  	if (cnt > len)
> > >  		cnt = len;
> > >  	memcpy(buf, s->buffer + s->seq.readpos, cnt);
> > 
> > 
> > There is one more dangerous usage in trace_printk_seq(). It is on
> > three lines there.
> 
> You totally confused me. What usage in trace_printk_seq(), and what
> three lines?
> 
> In this patch, trace_printk_seq() looks like this:
> 
> int trace_print_seq(struct seq_file *m, struct trace_seq *s)
> {
>         int ret;
> 
>         __trace_seq_init(s);
> 
>         ret = seq_buf_print_seq(m, &s->seq);
> 
>         /*
>          * Only reset this buffer if we successfully wrote to the
>          * seq_file buffer. This lets the caller try again or
>          * do something else with the contents.
>          */
>         if (!ret)
>                 trace_seq_init(s);
> 
>         return ret;
> }

The confusion is caused by the 'k' ("print" vs. "printk") in the
function name. I was talking about the following function from
kernel/trace/trace.c:

void
trace_printk_seq(struct trace_seq *s)
{
	/* Probably should print a warning here. */
	if (s->seq.len >= TRACE_MAX_PRINT)
		s->seq.len = TRACE_MAX_PRINT;

	/* should be zero ended, but we are paranoid. */
	s->buffer[s->seq.len] = 0;

	printk(KERN_TRACE "%s", s->buffer);

	trace_seq_init(s);
}

I found it when checking the applied patches in origin/rfc/seq-buf
branch. I hope that it was the correct place.

Best Regards,
Petr
