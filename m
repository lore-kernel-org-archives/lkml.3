Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756263AbaKSQau (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 11:30:50 -0500
Received: from cantor2.suse.de ([195.135.220.15]:32976 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754066AbaKSQat (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 11:30:49 -0500
Date: Wed, 19 Nov 2014 17:30:43 +0100
From: Petr Mladek <pmladek@suse.cz>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jiri Kosina <jkosina@suse.cz>
Subject: Re: [PATCH 18/26 v5] seq_buf: Create seq_buf_used() to find out how
 much was written
Message-ID: <20141119163043.GD2332@dhcp128.suse.cz>
References: <20141115045847.712848224@goodmis.org>
 <20141115050603.696625970@goodmis.org>
 <20141118150204.GI23958@pathway.suse.cz>
 <20141119104956.14cc30cb@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141119104956.14cc30cb@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 2014-11-19 10:49:56, Steven Rostedt wrote:
> On Tue, 18 Nov 2014 16:02:04 +0100
> Petr Mladek <pmladek@suse.cz> wrote:
> 
> > On Fri 2014-11-14 23:59:05, Steven Rostedt wrote:
> > > From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>
> > > 
> > > Add a helper function seq_buf_used() that replaces the SEQ_BUF_USED()
> > > private macro to let callers have a method to know how much of the
> > > seq_buf was written to.
> > > 
> > > Link: http://lkml.kernel.org/r/20141114011412.170377300@goodmis.org
> > > Link: http://lkml.kernel.org/r/20141114011413.321654244@goodmis.org
> > > 
> > > Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> > > ---
> > >  include/linux/seq_buf.h | 6 ++++++
> > >  kernel/trace/seq_buf.c  | 5 +----
> > >  2 files changed, 7 insertions(+), 4 deletions(-)
> > > 
> > > diff --git a/include/linux/seq_buf.h b/include/linux/seq_buf.h
> > > index 5d91262433e2..93718e570d4c 100644
> > > --- a/include/linux/seq_buf.h
> > > +++ b/include/linux/seq_buf.h
> > > @@ -64,6 +64,12 @@ seq_buf_buffer_left(struct seq_buf *s)
> > >  	return (s->size - 1) - s->len;
> > >  }
> > >  
> > > +/* How much buffer was written? */
> > > +static inline unsigned int seq_buf_used(struct seq_buf *s)
> > > +{
> > > +	return min(s->len, s->size);
> > 
> > To be precise, it should do
> > 
> > 	return min(s->len, s->size - 1);
> > 
> > at this stage and switch to the above code in ("[PATCH 21/26 v5] tracing: Have
> > seq_buf use full buffer"). Well, it does not cause any big harm. Feel
> > free to add:
> 
> I actually thought about it, but realized that this only replaces the
> original use of s->len, and we are only doing this to avoid buffer
> overflows. If you get garbage, then so be it, as the original code
> would give garbage too. Remember, some of the functions did have real
> content in that last byte, even though it was considered "overflowed".

I thought that it was based on ftrace_seq code that had

#define TRACE_SEQ_BUF_USED(s) min((s)->len, (unsigned int)(PAGE_SIZE -
 1))

But you are right that the callers used s->len because the macro was
local in trace_seq.c.

Well, I think that it does not matter much. As you said, there might be
a garbage a the end of the buffer. Callers used "len" directly.
Also it will be min(s->len, s->size); after the commit "Have seq_buf
use full buffer".

Let's leave it as is.

Best Regards,
Petr
