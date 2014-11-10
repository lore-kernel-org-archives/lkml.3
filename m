Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754052AbaKJRhz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 12:37:55 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.229]:41970 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753367AbaKJRhx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 12:37:53 -0500
Date: Mon, 10 Nov 2014 12:37:47 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Petr Mladek <pmladek@suse.cz>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jiri Kosina <jkosina@suse.cz>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [RFC][PATCH 03/12 v3] tracing: Create seq_buf layer in
 trace_seq
Message-ID: <20141110123747.6ef3dd07@gandalf.local.home>
In-Reply-To: <20141110135330.GC2160@pathway.suse.cz>
References: <20141104155237.228431433@goodmis.org>
	<20141104160221.864997179@goodmis.org>
	<20141105142222.GC4570@pathway.suse.cz>
	<20141105134147.226a23ef@gandalf.local.home>
	<20141105150007.1c543b9e@gandalf.local.home>
	<20141105161720.71abdbdb@gandalf.local.home>
	<20141105162146.6edc1567@gandalf.local.home>
	<20141106163352.GJ2001@dhcp128.suse.cz>
	<20141107133017.0d0ecd2e@gandalf.local.home>
	<20141110135330.GC2160@pathway.suse.cz>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.25; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 10 Nov 2014 14:53:30 +0100
Petr Mladek <pmladek@suse.cz> wrote:

> > +/*
> > + * How much buffer is left on the seq_buf?
> > + */
> > +static inline unsigned int
> > +seq_buf_buffer_left(struct seq_buf *s)
> > +{
> > +	return (s->size - 1) - s->len;
> 
> This should be
> 
> 	if (seq_buf_has_overflowed(s)
> 		return 0;
> 	return (s->size - 1) - s->len;
> 
> otherwise, it would return UNIT_MAX for the overflown state. If I am
> not mistaken.

I guess I could add that. Probably the safer bet. Or document it that
this is undefined if buffer has overflowed. I have to check how my use
cases worked.

Probably best to add the overflow check anyway.

> 
> [...]
> 
> > diff --git a/kernel/trace/seq_buf.c b/kernel/trace/seq_buf.c
> > new file mode 100644
> > index 000000000000..88738b200bf3
> > --- /dev/null
> > +++ b/kernel/trace/seq_buf.c
> 
> [...]
> 
> > +
> > +/**
> > + * seq_buf_bitmask - write a bitmask array in its ASCII representation
> > + * @s:		seq_buf descriptor
> > + * @maskp:	points to an array of unsigned longs that represent a bitmask
> > + * @nmaskbits:	The number of bits that are valid in @maskp
> > + *
> > + * Writes a ASCII representation of a bitmask string into @s.
> > + *
> > + * Returns zero on success, -1 on overflow.
> > + */
> > +int seq_buf_bitmask(struct seq_buf *s, const unsigned long *maskp,
> > +		    int nmaskbits)
> > +{
> > +	unsigned int len = seq_buf_buffer_left(s);
> > +	int ret;
> > +
> > +	WARN_ON(s->size == 0);
> > +
> > +	/*
> > +	 * The last byte of the buffer is used to determine if we
> > +	 * overflowed or not.
> > +	 */
> > +	if (len > 1) {
> > +		ret = bitmap_scnprintf(s->buffer, len, maskp, nmaskbits);
> 
> It should be:
> 
> 		ret = bitmap_scnprintf(s->buffer + s->len, len,
> 				       maskp, nmaskbits);
> 
> otherwise, we would write to the beginning to the buffer.

You are correct. But I'll make that a separate patch. This is just
keeping the bug that was in the original code.

> 
> > +		if (ret < len) {
> > +			s->len += ret;
> > +			return 0;
> > +		}
> > +	}
> > +	seq_buf_set_overflow(s);
> > +	return -1;
> > +}
> > +
> 
> [...]
> 
> > diff --git a/kernel/trace/trace_seq.c b/kernel/trace/trace_seq.c
> > index 1f24ed99dca2..3ad8738aea19 100644
> > --- a/kernel/trace/trace_seq.c
> > +++ b/kernel/trace/trace_seq.c
> 
> [...]
> 
> > @@ -144,23 +160,24 @@ EXPORT_SYMBOL_GPL(trace_seq_bitmask);
> >   */
> >  int trace_seq_vprintf(struct trace_seq *s, const char *fmt, va_list args)
> >  {
> > -	unsigned int len = TRACE_SEQ_BUF_LEFT(s);
> > +	unsigned int save_len = s->seq.len;
> >  	int ret;
> >  
> > -	if (s->full || !len)
> > +	if (s->full)
> >  		return 0;
> >  
> > -	ret = vsnprintf(s->buffer + s->len, len, fmt, args);
> > +	__trace_seq_init(s);
> > +
> > +	ret = seq_buf_vprintf(&s->seq, fmt, args);
> 
> Note that this returns 0 on success => we do not need to store it
> 
> >  	/* If we can't write it all, don't bother writing anything */
> > -	if (ret >= len) {
> > +	if (unlikely(seq_buf_has_overflowed(&s->seq))) {
> > +		s->seq.len = save_len;
> >  		s->full = 1;
> >  		return 0;
> >  	}
> >  
> > -	s->len += ret;
> > -
> > -	return len;
> > +	return ret;
> 
> Instead, we have to do something like:
> 
> 	return s->seq.len - save_len;

Actually, I need to make the trace_seq_*() functions return the same as
the seq_buf_*() functions.

I'll update this for now, but it's gotta change later. Probably why I
wasn't so careful about it.

> 
> >  }
> >  EXPORT_SYMBOL_GPL(trace_seq_vprintf);
> >  
> > @@ -183,23 +200,24 @@ EXPORT_SYMBOL_GPL(trace_seq_vprintf);
> >   */
> >  int trace_seq_bprintf(struct trace_seq *s, const char *fmt, const u32 *binary)
> >  {
> > -	unsigned int len = TRACE_SEQ_BUF_LEFT(s);
> > +	unsigned int save_len = s->seq.len;
> >  	int ret;
> >  
> > -	if (s->full || !len)
> > +	if (s->full)
> >  		return 0;
> >  
> > -	ret = bstr_printf(s->buffer + s->len, len, fmt, binary);
> > +	__trace_seq_init(s);
> > +
> > +	ret = seq_buf_bprintf(&s->seq, fmt, binary);
> 
> Same here, it returns 0 on success => no need to store.
> 
> >  	/* If we can't write it all, don't bother writing anything */
> > -	if (ret >= len) {
> > +	if (unlikely(seq_buf_has_overflowed(&s->seq))) {
> > +		s->seq.len = save_len;
> >  		s->full = 1;
> >  		return 0;
> >  	}
> >  
> > -	s->len += ret;
> > -
> > -	return len;
> > +	return ret;
> 
> and

same thing.

> 
> 	return s->seq.len - save_len;
> 
> >  }
> >  EXPORT_SYMBOL_GPL(trace_seq_bprintf);
> >  
> 
> [...]
> 
> >  /**
> >   * trace_seq_putmem_hex - write raw memory into the buffer in ASCII hex
> >   * @s: trace sequence descriptor
> > @@ -309,35 +328,30 @@ EXPORT_SYMBOL_GPL(trace_seq_putmem);
> >  int trace_seq_putmem_hex(struct trace_seq *s, const void *mem,
> >  			 unsigned int len)
> >  {
> > -	unsigned char hex[HEX_CHARS];
> > -	const unsigned char *data = mem;
> > -	unsigned int start_len;
> > -	int i, j;
> > -	int cnt = 0;
> > +	unsigned int save_len = s->seq.len;
> > +	int ret;
> >  
> >  	if (s->full)
> >  		return 0;
> >  
> > -	while (len) {
> > -		start_len = min(len, HEX_CHARS - 1);
> > -#ifdef __BIG_ENDIAN
> > -		for (i = 0, j = 0; i < start_len; i++) {
> > -#else
> > -		for (i = start_len-1, j = 0; i >= 0; i--) {
> > -#endif
> > -			hex[j++] = hex_asc_hi(data[i]);
> > -			hex[j++] = hex_asc_lo(data[i]);
> > -		}
> > -		if (WARN_ON_ONCE(j == 0 || j/2 > len))
> > -			break;
> > -
> > -		/* j increments twice per loop */
> > -		len -= j / 2;
> > -		hex[j++] = ' ';
> > -
> > -		cnt += trace_seq_putmem(s, hex, j);
> > +	__trace_seq_init(s);
> > +
> > +	/* Each byte is represented by two chars */
> > +	if (len * 2 > TRACE_SEQ_BUF_LEFT(s)) {
> > +		s->full = 1;
> > +		return 0;
> > +	}
> > +
> > +	/* The added spaces can still cause an overflow */
> > +	ret = seq_buf_putmem_hex(&s->seq, mem, len);
> 
> and here, it returns zero on success
> 
> > +
> > +	if (unlikely(seq_buf_has_overflowed(&s->seq))) {
> > +		s->seq.len = save_len;
> > +		s->full = 1;
> > +		return 0;
> >  	}
> > -	return cnt;
> > +
> > +	return ret;
> 
> Therefore we need something like:
> 
> 	return s->seq.len - save_len;
> 

Hmm, I may make the trace_seq_*() functions not return length written
first, before pulling out the seq_buf_*() code. That is, make the
trace_seq_*() behave more like what the seq_buf_*() code does first,
before pulling out the seq_buf_*() code.



> >  }
> >  EXPORT_SYMBOL_GPL(trace_seq_putmem_hex);
> >  
> > @@ -355,30 +369,28 @@ EXPORT_SYMBOL_GPL(trace_seq_putmem_hex);
> >   */
> >  int trace_seq_path(struct trace_seq *s, const struct path *path)
> >  {
> > -	unsigned char *p;
> > +	unsigned int save_len = s->seq.len;
> > +	int ret;
> >  
> >  	if (s->full)
> >  		return 0;
> >  
> > +	__trace_seq_init(s);
> > +
> >  	if (TRACE_SEQ_BUF_LEFT(s) < 1) {
> >  		s->full = 1;
> >  		return 0;
> >  	}
> >  
> > -	p = d_path(path, s->buffer + s->len, PAGE_SIZE - s->len);
> > -	if (!IS_ERR(p)) {
> > -		p = mangle_path(s->buffer + s->len, p, "\n");
> > -		if (p) {
> > -			s->len = p - s->buffer;
> > -			return 1;
> > -		}
> > -	} else {
> > -		s->buffer[s->len++] = '?';
> > -		return 1;
> > +	ret = seq_buf_path(&s->seq, path);
> 
> This returns zero on sucess.
> 
> > +	if (unlikely(seq_buf_has_overflowed(&s->seq))) {
> > +		s->seq.len = save_len;
> > +		s->full = 1;
> > +		return 0;
> >  	}
> >  
> > -	s->full = 1;
> > -	return 0;
> > +	return ret;
> 
> and we want to return 1 on success =>
> 
> 	return 1;
> 
> >  }
> >  EXPORT_SYMBOL_GPL(trace_seq_path);
> 
> Best Regards,
> Petr
> 
> 
> PS: I have to leave for a bit now. I hope that I will be able to look
> at the other patches later today.


Thanks for the review. Most of this will be fixed by doing the change
to the return value of the trace_seq_*() code first. I think I'll do
that.

-- Steve
