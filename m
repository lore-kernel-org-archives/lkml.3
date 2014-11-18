Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753829AbaKRRhg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 12:37:36 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.228]:33317 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753041AbaKRRhf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 12:37:35 -0500
Date: Tue, 18 Nov 2014 12:37:32 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Petr Mladek <pmladek@suse.cz>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jiri Kosina <jkosina@suse.cz>
Subject: Re: [PATCH 2/2] tracing: Use trace_seq_used() and seq_buf_used()
 instead of len
Message-ID: <20141118123732.462b1ad8@gandalf.local.home>
In-Reply-To: <20141118163354.GK23958@pathway.suse.cz>
References: <20141115045847.712848224@goodmis.org>
	<20141115050603.904875201@goodmis.org>
	<20141117123250.10f6f57c@gandalf.local.home>
	<20141117141215.2dbd5f12@gandalf.local.home>
	<20141118163354.GK23958@pathway.suse.cz>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.25; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 18 Nov 2014 17:33:54 +0100
Petr Mladek <pmladek@suse.cz> wrote:

> On Mon 2014-11-17 14:12:15, Steven Rostedt wrote:
> > 
> > > I don't like the fact that I did a code structure change with this
> > > patch. This patch should be just a simple conversion of len to
> > > seq_buf_used(). I'm going to strip this change out and put it before
> > > this patch.
> > 
> > 
> > As the seq_buf->len will soon be +1 size when there's an overflow, we
> > must use trace_seq_used() or seq_buf_used() methods to get the real
> > length. This will prevent buffer overflow issues if just the len
> > of the seq_buf descriptor is used to copy memory.
> > 
> > Link: http://lkml.kernel.org/r/20141114121911.09ba3d38@gandalf.local.home
> > 
> > Reported-by: Petr Mladek <pmladek@suse.cz>
> > Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> > ---
> >  include/linux/trace_seq.h            | 20 +++++++++++++++++++-
> >  kernel/trace/seq_buf.c               |  2 +-
> >  kernel/trace/trace.c                 | 22 +++++++++++-----------
> >  kernel/trace/trace_events.c          |  9 ++++++---
> >  kernel/trace/trace_functions_graph.c |  5 ++++-
> >  kernel/trace/trace_seq.c             |  2 +-
> >  6 files changed, 42 insertions(+), 18 deletions(-)
> 
> [...]
> 
> 
> > --- a/kernel/trace/trace.c
> > +++ b/kernel/trace/trace.c
> > @@ -944,10 +944,10 @@ static ssize_t trace_seq_to_buffer(struct trace_seq *s, void *buf, size_t cnt)
> >  {
> >  	int len;
> >  
> > -	if (s->seq.len <= s->seq.readpos)
> > +	if (trace_seq_used(s) <= s->seq.readpos)
> >  		return -EBUSY;
> >  
> > -	len = s->seq.len - s->seq.readpos;
> > +	len = trace_seq_used(s) - s->seq.readpos;
> >  	if (cnt > len)
> >  		cnt = len;
> >  	memcpy(buf, s->buffer + s->seq.readpos, cnt);
> 
> 
> There is one more dangerous usage in trace_printk_seq(). It is on
> three lines there.

You totally confused me. What usage in trace_printk_seq(), and what
three lines?

In this patch, trace_printk_seq() looks like this:

int trace_print_seq(struct seq_file *m, struct trace_seq *s)
{
        int ret;

        __trace_seq_init(s);

        ret = seq_buf_print_seq(m, &s->seq);

        /*
         * Only reset this buffer if we successfully wrote to the
         * seq_file buffer. This lets the caller try again or
         * do something else with the contents.
         */
        if (!ret)
                trace_seq_init(s);

        return ret;
}



-- Steve


> 
> The rest looks good.
> 
> Best Regards,
> Petr

