Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751856AbaKESmn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 13:42:43 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.227]:44443 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751339AbaKESly (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 13:41:54 -0500
Date: Wed, 5 Nov 2014 13:41:47 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Petr Mladek <pmladek@suse.cz>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jiri Kosina <jkosina@suse.cz>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [RFC][PATCH 03/12 v3] tracing: Create seq_buf layer in
 trace_seq
Message-ID: <20141105134147.226a23ef@gandalf.local.home>
In-Reply-To: <20141105142222.GC4570@pathway.suse.cz>
References: <20141104155237.228431433@goodmis.org>
	<20141104160221.864997179@goodmis.org>
	<20141105142222.GC4570@pathway.suse.cz>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.25; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 5 Nov 2014 15:22:22 +0100
Petr Mladek <pmladek@suse.cz> wrote:

> On Tue 2014-11-04 10:52:40, Steven Rostedt wrote:
> > From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>
> > 
> > Create a seq_buf layer that trace_seq sits on. The seq_buf will not
> > be limited to page size. This will allow other usages of seq_buf
> > instead of a hard set PAGE_SIZE one that trace_seq has.
> > 
> > Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> > ---
> >  include/linux/seq_buf.h              |  72 ++++++++
> >  include/linux/trace_seq.h            |  10 +-
> >  kernel/trace/Makefile                |   1 +
> >  kernel/trace/seq_buf.c               | 341 +++++++++++++++++++++++++++++++++++
> >  kernel/trace/trace.c                 |  39 ++--
> >  kernel/trace/trace_events.c          |   6 +-
> >  kernel/trace/trace_functions_graph.c |   6 +-
> >  kernel/trace/trace_seq.c             | 184 +++++++++----------
> >  8 files changed, 534 insertions(+), 125 deletions(-)
> >  create mode 100644 include/linux/seq_buf.h
> >  create mode 100644 kernel/trace/seq_buf.c
> > 
> > diff --git a/include/linux/seq_buf.h b/include/linux/seq_buf.h
> > new file mode 100644
> > index 000000000000..97872154d51c
> > --- /dev/null
> > +++ b/include/linux/seq_buf.h
> > @@ -0,0 +1,72 @@
> > +#ifndef _LINUX_SEQ_BUF_H
> > +#define _LINUX_SEQ_BUF_H
> > +
> > +#include <linux/fs.h>
> > +
> > +#include <asm/page.h>
> > +
> > +/*
> > + * Trace sequences are used to allow a function to call several other functions
> > + * to create a string of data to use.
> > + */
> > +
> > +/**
> > + * seq_buf - seq buffer structure
> > + * @buffer:	pointer to the buffer
> > + * @size:	size of the buffer
> > + * @len:	the amount of data inside the buffer
> > + * @readpos:	The next position to read in the buffer.
> > + * @overflow:	Set if more bytes should have been written to buffer
> 
> There is no @overflow flag in the end.
> 

Crap, that was left over from a previos version.

> Also I would add an explanation of the overall logic. If I get it
> correctly from the code, it is:
> 
> /*
>  * The last byte of the buffer is used to detect an overflow in some
>  * operations. Therefore, the buffer offers (@size - 1) bytes for valid
>  * data.

Well, this will change in the future. And it is commented with the
seq_buf_has_overflowed() function. I don't want to comment about it
with the structure.


>  */
> 
> > + */
> > +struct seq_buf {
> > +	unsigned char		*buffer;
> > +	unsigned int		size;
> > +	unsigned int		len;
> > +	unsigned int		readpos;
> > +};
> > +
> 
> [...]
> 
> > diff --git a/kernel/trace/seq_buf.c b/kernel/trace/seq_buf.c
> > new file mode 100644
> > index 000000000000..2bf582753902
> > --- /dev/null
> > +++ b/kernel/trace/seq_buf.c
> > @@ -0,0 +1,341 @@
> > +/*
> > + * seq_buf.c
> > + *
> > + * Copyright (C) 2014 Red Hat Inc, Steven Rostedt <srostedt@redhat.com>
> > + *
> > + * The seq_buf is a handy tool that allows you to pass a descriptor around
> > + * to a buffer that other functions can write to. It is similar to the
> > + * seq_file functionality but has some differences.
> > + *
> > + * To use it, the seq_buf must be initialized with seq_buf_init().
> > + * This will set up the counters within the descriptor. You can call
> > + * seq_buf_init() more than once to reset the seq_buf to start
> > + * from scratch.
> > + * 
> 
> ^ trailing whitespace :-)

I had that fixed in my latest version. But I'm nuking the extra line
anyway.

> 
> > + */
> > +#include <linux/uaccess.h>
> > +#include <linux/seq_file.h>
> > +#include <linux/seq_buf.h>
> > +
> > +/* How much buffer is left on the seq_buf? */
> 
> I would write the following to explain the -1:

Later patches gets rid of the -1. It's -1 because seq_file is -1 as
well.

> 
> /* How much buffer is left for valid data */
> 
> > +#define SEQ_BUF_LEFT(s) (((s)->size - 1) - (s)->len)
> 
> Hmm, it might overflow when the buffer has overflown (s->len == s->size)
> or when the buffer is not initialized (s->size == 0). Note that the
> result should be unsigned int.

The two places that use it is "unsigned int" so that should not be a
problem.

> 
> I can't find any cool solution as a macro at the moment. It might be
> better to define an inline function for this.
> 
> 
> > +/* How much buffer is written? */
> 
> I would write the following to explain the -1:
> 
> /* How much buffer is written with valid data */
> 

Again, this gets changed in later patches. I don't want to expand too
much time commenting what I want to remove ;-)

I did it this way to match seq_file, and I have patches to change
seq_file to have overflow be len > size too.


> > +#define SEQ_BUF_USED(s) min((s)->len, (s)->size - 1)
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
> > + * Returns the number of bytes written.
> 
> The text should be:
> 
>  * Returns zero on success, -1 on overflow.

Darn, I thought I caught all the updates of the return value.

Will fix.

> 
> > + */
> > +int seq_buf_bitmask(struct seq_buf *s, const unsigned long *maskp,
> > +		    int nmaskbits)
> > +{
> > +	unsigned int len = SEQ_BUF_LEFT(s);
> >
> > +	int ret;
> > +
> > +	WARN_ON(s->size == 0);
> > +
> > +	if (s->len < s->size) {
> > +		ret = bitmap_scnprintf(s->buffer, len, maskp, nmaskbits);
> 
> It writes to the beginning of the buffer. It should be
> 
> 		ret = bitmap_scnprintf(s->buffer + s->len, len,
> 				       maskp, nmaskbits);
>

Yep thanks. Luckily its only user didn't care.

Will fix.
 
> 
> > +		if (s->len + ret < s->size) {
> 
> This will always happen because bitmap_scnprintf() is limited by SEQ_BUF_LEFT(s)
> and it currently returns the remaining size - len - 1.

Hmm, that's correct, as bitmap_scnprintf() returns the amount written
instead of the amount that it would write like snprintf() would.


> 
> You might want to use "s->size - s->len" instead of SEQ_BUF_LEFT(s).

That wont help when we make overflow len > size.

Probably should see if ret == the amount of bits required for the
bitmask.

> 
> 
> > +			s->len += ret;
> > +			return 0;
> > +		}
> > +	}
> > +	seq_buf_set_overflow(s);
> > +	return -1;
> > +}
> > +
> > +/**
> > + * seq_buf_bprintf - Write the printf string from binary arguments
> > + * @s: seq_buf descriptor
> > + * @fmt: The format string for the @binary arguments
> > + * @binary: The binary arguments for @fmt.
> > + *
> > + * When recording in a fast path, a printf may be recorded with just
> > + * saving the format and the arguments as they were passed to the
> > + * function, instead of wasting cycles converting the arguments into
> > + * ASCII characters. Instead, the arguments are saved in a 32 bit
> > + * word array that is defined by the format string constraints.
> > + *
> > + * This function will take the format and the binary array and finish
> > + * the conversion into the ASCII string within the buffer.
> > + *
> > + * Returns zero on success, -1 on overflow.
> > + */
> > +int seq_buf_bprintf(struct seq_buf *s, const char *fmt, const u32 *binary)
> > +{
> > +	unsigned int len = SEQ_BUF_LEFT(s);
> > +	int ret;
> > +
> > +	WARN_ON(s->size == 0);
> > +
> > +	if (s->len < s->size) {
> 
> Always true. It is the same problem as in seq_buf_bitmask().

No this is not the same. This will not be true if we have overflowed.

> 
> > +		ret = bstr_printf(s->buffer + s->len, len, fmt, binary);
> > +		if (s->len + ret < s->size) {

This is the "if" you are thinking of with seq_buf_bitmask(). But unlike
bitmap_scnprintf(), bstr_printf() returns the number of characters that
would be written. Not the number that were. This condition does make
sense.


> > +			s->len += ret;
> > +			return 0;
> > +		}
> > +	}
> > +	seq_buf_set_overflow(s);
> > +	return -1;
> > +}
> > +
> > +/**
> > + * seq_buf_puts - sequence printing of simple string
> > + * @s: seq_buf descriptor
> > + * @str: simple string to record
> > + *
> > + * Copy a simple string into the sequence buffer.
> > + *
> > + * Returns zero on success, -1 on overflow
> > + */
> > +int seq_buf_puts(struct seq_buf *s, const char *str)
> > +{
> > +	unsigned int len = strlen(str);
> > +
> > +	WARN_ON(s->size == 0);
> > +
> > +	if (s->len + len < s->size) {
> > +		memcpy(s->buffer + s->len, str, len);
> > +		s->len += len;
> > +		return 0;
> > +	}
> 
> We might want to copy the maximum possible number of bytes.
> It will then behave the same as the other functions.

I'm converting all this to be like seq_file in the other patches.


> 
> > +	seq_buf_set_overflow(s);
> > +	return -1;
> > +}
> > +
> 
> [...]
> 
> > +
> > +/**
> > + * seq_buf_putmem - write raw data into the sequenc buffer
> > + * @s: seq_buf descriptor
> > + * @mem: The raw memory to copy into the buffer
> > + * @len: The length of the raw memory to copy (in bytes)
> > + *
> > + * There may be cases where raw memory needs to be written into the
> > + * buffer and a strcpy() would not work. Using this function allows
> > + * for such cases.
> > + *
> > + * Returns zero on success, -1 on overflow
> > + */
> > +int seq_buf_putmem(struct seq_buf *s, const void *mem, unsigned int len)
> > +{
> > +	WARN_ON(s->size == 0);
> > +
> > +	if (s->len + len < s->size) {
> > +		memcpy(s->buffer + s->len, mem, len);
> > +		s->len += len;
> > +		return 0;
> > +	}
> 
> Same as seq_buf_puts(). Do we want to always copy the possible number of
> bytes?

Again, this will be made to be like seq_file.

> 
> > +	seq_buf_set_overflow(s);
> > +	return -1;
> > +}
> > +
> > +#define MAX_MEMHEX_BYTES	8U
> > +#define HEX_CHARS		(MAX_MEMHEX_BYTES*2 + 1)
> > +
> > +/**
> > + * seq_buf_putmem_hex - write raw memory into the buffer in ASCII hex
> > + * @s: seq_buf descriptor
> > + * @mem: The raw memory to write its hex ASCII representation of
> > + * @len: The length of the raw memory to copy (in bytes)
> > + *
> > + * This is similar to seq_buf_putmem() except instead of just copying the
> > + * raw memory into the buffer it writes its ASCII representation of it
> > + * in hex characters.
> > + *
> > + * Returns zero on success, -1 on overflow
> > + */
> > +int seq_buf_putmem_hex(struct seq_buf *s, const void *mem,
> > +		       unsigned int len)
> > +{
> > +	unsigned char hex[HEX_CHARS];
> > +	const unsigned char *data = mem;
> > +	unsigned int start_len;
> > +	int i, j;
> > +
> > +	WARN_ON(s->size == 0);
> > +
> > +	while (len) {
> > +		start_len = min(len, HEX_CHARS - 1);
> > +#ifdef __BIG_ENDIAN
> > +		for (i = 0, j = 0; i < start_len; i++) {
> > +#else
> > +		for (i = start_len-1, j = 0; i >= 0; i--) {
> > +#endif
> > +			hex[j++] = hex_asc_hi(data[i]);
> > +			hex[j++] = hex_asc_lo(data[i]);
> > +		}
> > +		if (WARN_ON_ONCE(j == 0 || j/2 > len))
> > +			break;
> > +
> > +		/* j increments twice per loop */
> > +		len -= j / 2;
> > +		hex[j++] = ' ';
> > +
> > +		seq_buf_putmem(s, hex, j);
> > +		if (seq_buf_has_overflowed(s))
> 
> We might want to use the seq_buf_putmem() return value here.

We could do that.

> 
> > +			return -1;
> > +	}
> > +	return 0;
> > +}
> > +
> 
> [...]
> 
> > +
> > +/**
> > + * seq_buf_to_user - copy the squence buffer to user space
> > + * @s: seq_buf descriptor
> > + * @ubuf: The userspace memory location to copy to
> > + * @cnt: The amount to copy
> > + *
> > + * Copies the sequence buffer into the userspace memory pointed to
> > + * by @ubuf. It starts from the last read position (@s->readpos)
> > + * and writes up to @cnt characters or till it reaches the end of
> > + * the content in the buffer (@s->len), which ever comes first.
> > + *
> > + * On success, it returns a positive number of the number of bytes
> > + * it copied.
> > + *
> > + * On failure it returns -EBUSY if all of the content in the
> > + * sequence has been already read, which includes nothing in the
> > + * sequenc (@s->len == @s->readpos).
> 
> sequenc -> sequence

Thanks.

> 
> > + *
> > + * Returns -EFAULT if the copy to userspace fails.
> > + */
> > +int seq_buf_to_user(struct seq_buf *s, char __user *ubuf, int cnt)
> > +{
> > +	int len;
> > +	int ret;
> > +
> > +	if (!cnt)
> > +		return 0;
> > +
> > +	if (s->len <= s->readpos)
> > +		return -EBUSY;
> > +
> > +	len = s->len - s->readpos;
> > +	if (cnt > len)
> > +		cnt = len;
> > +	ret = copy_to_user(ubuf, s->buffer + s->readpos, cnt);
> > +	if (ret == cnt)
> > +		return -EFAULT;
> > +
> > +	cnt -= ret;
> > +
> > +	s->readpos += cnt;
> > +	return cnt;
> > +}
> 
> [...]
> 
> > diff --git a/kernel/trace/trace_seq.c b/kernel/trace/trace_seq.c
> > index 1f24ed99dca2..960ccfb2f50c 100644
> > --- a/kernel/trace/trace_seq.c
> > +++ b/kernel/trace/trace_seq.c
> > @@ -27,10 +27,19 @@
> >  #include <linux/trace_seq.h>
> >  
> >  /* How much buffer is left on the trace_seq? */
> > -#define TRACE_SEQ_BUF_LEFT(s) ((PAGE_SIZE - 1) - (s)->len)
> > +#define TRACE_SEQ_BUF_LEFT(s) ((PAGE_SIZE - 1) - (s)->seq.len)
> 
> This might overflow when s->len == PAGE_SIZE. I think that it
> newer happenes because we always check s->full before. The question
> is if we really want to depend on this.

Yeah, we should make this check seq_buf itself. Maybe make a static
inline function that is in seq_buf.h.


> 
> >  /* How much buffer is written? */
> > -#define TRACE_SEQ_BUF_USED(s) min((s)->len, (unsigned int)(PAGE_SIZE - 1))
> > +#define TRACE_SEQ_BUF_USED(s) min((s)->seq.len, (unsigned int)(PAGE_SIZE - 1))
> > +
> > +/*
> > + * trace_seq should work with being initialized with 0s.
> > + */
> > +static inline void __trace_seq_init(struct trace_seq *s)
> > +{
> > +	if (unlikely(!s->seq.size))
> > +		trace_seq_init(s);
> > +}
> >  
> >  /**
> >   * trace_print_seq - move the contents of trace_seq into a seq_file
> > @@ -43,10 +52,11 @@
> >   */
> >  int trace_print_seq(struct seq_file *m, struct trace_seq *s)
> >  {
> > -	unsigned int len = TRACE_SEQ_BUF_USED(s);
> >  	int ret;
> >  
> > -	ret = seq_write(m, s->buffer, len);
> > +	__trace_seq_init(s);
> > +
> > +	ret = seq_buf_print_seq(m, &s->seq);
> >  
> >  	/*
> >  	 * Only reset this buffer if we successfully wrote to the
> > @@ -77,25 +87,25 @@ int trace_print_seq(struct seq_file *m, struct trace_seq *s)
> >   */
> >  int trace_seq_printf(struct trace_seq *s, const char *fmt, ...)
> >  {
> > -	unsigned int len = TRACE_SEQ_BUF_LEFT(s);
> > +	unsigned int save_len = s->seq.len;
> >  	va_list ap;
> > -	int ret;
> >  
> > -	if (s->full || !len)
> > +	if (s->full)
> >  		return 0;
> >  
> > +	__trace_seq_init(s);
> > +
> >  	va_start(ap, fmt);
> > -	ret = vsnprintf(s->buffer + s->len, len, fmt, ap);
> > +	seq_buf_vprintf(&s->seq, fmt, ap);
> >  	va_end(ap);
> >  
> >  	/* If we can't write it all, don't bother writing anything */
> > -	if (ret >= len) {
> > +	if (unlikely(seq_buf_has_overflowed(&s->seq))) {
> 
> We might check the return value from seq_buf_vprintf() here.

No, we are working to get rid of the return values for the seq_*()
functions (with a few exceptions). One now must check if the buffer has
overflowed, and not the return value of the seq_*() functions
themselves.

There's already patches out to convert the seq_file calls as well.

-- Steve


> 
> We could do similar thing also in the other functions. We even
> already store the ret value in some of them.
> 
> Best Regards,
> Petr

