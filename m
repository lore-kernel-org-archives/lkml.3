Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752070AbaKJTC4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 14:02:56 -0500
Received: from cantor2.suse.de ([195.135.220.15]:49243 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750928AbaKJTCz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 14:02:55 -0500
Date: Mon, 10 Nov 2014 20:02:49 +0100
From: Petr Mladek <pmladek@suse.cz>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jiri Kosina <jkosina@suse.cz>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [RFC][PATCH 03/12 v3] tracing: Create seq_buf layer in trace_seq
Message-ID: <20141110190249.GD2552@dhcp128.suse.cz>
References: <20141104160221.864997179@goodmis.org>
 <20141105142222.GC4570@pathway.suse.cz>
 <20141105134147.226a23ef@gandalf.local.home>
 <20141105150007.1c543b9e@gandalf.local.home>
 <20141105161720.71abdbdb@gandalf.local.home>
 <20141105162146.6edc1567@gandalf.local.home>
 <20141106163352.GJ2001@dhcp128.suse.cz>
 <20141107133017.0d0ecd2e@gandalf.local.home>
 <20141110135330.GC2160@pathway.suse.cz>
 <20141110123747.6ef3dd07@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141110123747.6ef3dd07@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 2014-11-10 12:37:47, Steven Rostedt wrote:
> On Mon, 10 Nov 2014 14:53:30 +0100
> Petr Mladek <pmladek@suse.cz> wrote:
> 
> > > +/*
> > > + * How much buffer is left on the seq_buf?
> > > + */
> > > +static inline unsigned int
> > > +seq_buf_buffer_left(struct seq_buf *s)
> > > +{
> > > +	return (s->size - 1) - s->len;
> > 
> > This should be
> > 
> > 	if (seq_buf_has_overflowed(s)
> > 		return 0;
> > 	return (s->size - 1) - s->len;
> > 
> > otherwise, it would return UNIT_MAX for the overflown state. If I am
> > not mistaken.
> 
> I guess I could add that. Probably the safer bet. Or document it that
> this is undefined if buffer has overflowed. I have to check how my use
> cases worked.
> 
> Probably best to add the overflow check anyway.

I vote for it :-)
 
> > [...]
> > 
> > > diff --git a/kernel/trace/seq_buf.c b/kernel/trace/seq_buf.c
> > > new file mode 100644
> > > index 000000000000..88738b200bf3
> > > --- /dev/null
> > > +++ b/kernel/trace/seq_buf.c
> > 
> > [...]
> > 
> > > +
> > > +/**
> > > + * seq_buf_bitmask - write a bitmask array in its ASCII representation
> > > + * @s:		seq_buf descriptor
> > > + * @maskp:	points to an array of unsigned longs that represent a bitmask
> > > + * @nmaskbits:	The number of bits that are valid in @maskp
> > > + *
> > > + * Writes a ASCII representation of a bitmask string into @s.
> > > + *
> > > + * Returns zero on success, -1 on overflow.
> > > + */
> > > +int seq_buf_bitmask(struct seq_buf *s, const unsigned long *maskp,
> > > +		    int nmaskbits)
> > > +{
> > > +	unsigned int len = seq_buf_buffer_left(s);
> > > +	int ret;
> > > +
> > > +	WARN_ON(s->size == 0);
> > > +
> > > +	/*
> > > +	 * The last byte of the buffer is used to determine if we
> > > +	 * overflowed or not.
> > > +	 */
> > > +	if (len > 1) {
> > > +		ret = bitmap_scnprintf(s->buffer, len, maskp, nmaskbits);
> > 
> > It should be:
> > 
> > 		ret = bitmap_scnprintf(s->buffer + s->len, len,
> > 				       maskp, nmaskbits);
> > 
> > otherwise, we would write to the beginning to the buffer.
> 
> You are correct. But I'll make that a separate patch. This is just
> keeping the bug that was in the original code.

Fair enough.

> > 
> > > +		if (ret < len) {
> > > +			s->len += ret;
> > > +			return 0;
> > > +		}
> > > +	}
> > > +	seq_buf_set_overflow(s);
> > > +	return -1;
> > > +}
> > > +
> > 
> > [...]
> > 
> > > diff --git a/kernel/trace/trace_seq.c b/kernel/trace/trace_seq.c
> > > index 1f24ed99dca2..3ad8738aea19 100644
> > > --- a/kernel/trace/trace_seq.c
> > > +++ b/kernel/trace/trace_seq.c
> > 
> > [...]
> > 
> > > @@ -144,23 +160,24 @@ EXPORT_SYMBOL_GPL(trace_seq_bitmask);
> > >   */
> > >  int trace_seq_vprintf(struct trace_seq *s, const char *fmt, va_list args)
> > >  {
> > > -	unsigned int len = TRACE_SEQ_BUF_LEFT(s);
> > > +	unsigned int save_len = s->seq.len;
> > >  	int ret;
> > >  
> > > -	if (s->full || !len)
> > > +	if (s->full)
> > >  		return 0;
> > >  
> > > -	ret = vsnprintf(s->buffer + s->len, len, fmt, args);
> > > +	__trace_seq_init(s);
> > > +
> > > +	ret = seq_buf_vprintf(&s->seq, fmt, args);
> > 
> > Note that this returns 0 on success => we do not need to store it
> > 
> > >  	/* If we can't write it all, don't bother writing anything */
> > > -	if (ret >= len) {
> > > +	if (unlikely(seq_buf_has_overflowed(&s->seq))) {
> > > +		s->seq.len = save_len;
> > >  		s->full = 1;
> > >  		return 0;
> > >  	}
> > >  
> > > -	s->len += ret;
> > > -
> > > -	return len;
> > > +	return ret;
> > 
> > Instead, we have to do something like:
> > 
> > 	return s->seq.len - save_len;
> 
> Actually, I need to make the trace_seq_*() functions return the same as
> the seq_buf_*() functions.
> 
> I'll update this for now, but it's gotta change later. Probably why I
> wasn't so careful about it.
> 
> Hmm, I may make the trace_seq_*() functions not return length written
> first, before pulling out the seq_buf_*() code. That is, make the
> trace_seq_*() behave more like what the seq_buf_*() code does first,
> before pulling out the seq_buf_*() code.

Sounds like the best solution if it does not cause too many changes in
the trace_seq() callers.

Best Regards,
Petr
