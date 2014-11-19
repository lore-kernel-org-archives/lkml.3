Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755145AbaKSNsM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 08:48:12 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.231]:54897 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753776AbaKSNsJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 08:48:09 -0500
Date: Wed, 19 Nov 2014 08:48:00 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Petr Mladek <pmladek@suse.cz>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jiri Kosina <jkosina@suse.cz>
Subject: Re: [PATCH 2/2] tracing: Use trace_seq_used() and seq_buf_used()
 instead of len
Message-ID: <20141119084800.524beb62@gandalf.local.home>
In-Reply-To: <20141119114017.GA2332@dhcp128.suse.cz>
References: <20141115045847.712848224@goodmis.org>
	<20141115050603.904875201@goodmis.org>
	<20141117123250.10f6f57c@gandalf.local.home>
	<20141117141215.2dbd5f12@gandalf.local.home>
	<20141118163354.GK23958@pathway.suse.cz>
	<20141118123732.462b1ad8@gandalf.local.home>
	<20141119114017.GA2332@dhcp128.suse.cz>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.25; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 19 Nov 2014 12:40:17 +0100
Petr Mladek <pmladek@suse.cz> wrote:

> > > 
> > > There is one more dangerous usage in trace_printk_seq(). It is on
> > > three lines there.
> > 
> > You totally confused me. What usage in trace_printk_seq(), and what
> > three lines?
> > 
> > In this patch, trace_printk_seq() looks like this:
> > 
> > int trace_print_seq(struct seq_file *m, struct trace_seq *s)
> > {
> >         int ret;
> > 
> >         __trace_seq_init(s);
> > 
> >         ret = seq_buf_print_seq(m, &s->seq);
> > 
> >         /*
> >          * Only reset this buffer if we successfully wrote to the
> >          * seq_file buffer. This lets the caller try again or
> >          * do something else with the contents.
> >          */
> >         if (!ret)
> >                 trace_seq_init(s);
> > 
> >         return ret;
> > }
> 
> The confusion is caused by the 'k' ("print" vs. "printk") in the
> function name. I was talking about the following function from
> kernel/trace/trace.c:

Silly 'k', Trix are for kids!

> 
> void
> trace_printk_seq(struct trace_seq *s)
> {
> 	/* Probably should print a warning here. */
> 	if (s->seq.len >= TRACE_MAX_PRINT)
> 		s->seq.len = TRACE_MAX_PRINT;
> 
> 	/* should be zero ended, but we are paranoid. */
> 	s->buffer[s->seq.len] = 0;
> 
> 	printk(KERN_TRACE "%s", s->buffer);
> 
> 	trace_seq_init(s);
> }
> 
> I found it when checking the applied patches in origin/rfc/seq-buf
> branch. I hope that it was the correct place.

Yes, that's the working branch for this code.

Anyway, I saw this and thought about using trace_seq_used(), but then I
realized that this is trace_seq code which has a hard coded buffer
length of PAGE_SIZE which on all archs is more than 1000
(TRACE_MAX_PRINT).

Regardless of overflow or not (or even if trace_seq is full), that if
statement will prevent this from doing any buffer overflows.

s->seq.len will never be more than s->seq.size after the test against
TRACE_MAX_PRINT. So I see no harm here.

trace_printk_seq() is for dumping the ring buffer to console, which is
usually something done on panic. It's special.

-- Steve
