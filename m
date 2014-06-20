Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934473AbaFTFIb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 01:08:31 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:54762 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933667AbaFTFIa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 01:08:30 -0400
Date: Thu, 19 Jun 2014 22:06:07 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Jiri Kosina <jkosina@suse.cz>,
        Michal Hocko <mhocko@suse.cz>, Jan Kara <jack@suse.cz>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Dave Anderson <anderson@redhat.com>, Petr Mladek <pmladek@suse.cz>
Subject: Re: [RFC][PATCH 1/3] trace_seq: Move the trace_seq code to lib/
Message-Id: <20140619220607.c6da2540.akpm@linux-foundation.org>
In-Reply-To: <20140619213952.058255809@goodmis.org>
References: <20140619213329.478113470@goodmis.org>
	<20140619213952.058255809@goodmis.org>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 19 Jun 2014 17:33:30 -0400 Steven Rostedt <rostedt@goodmis.org> wrote:

> From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>
> 
> The trace_seq functions are rather useful outside of tracing. Instead
> of having it be dependent on CONFIG_TRACING, move the code into lib/
> and allow other users to have access to it even when tracing is not
> configured.

What LT said.  It's pileon time!

> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> ---
>  include/linux/trace_seq.h   |  68 ++--------
>  kernel/trace/trace.c        |  24 ----
>  kernel/trace/trace_output.c | 268 ---------------------------------------
>  kernel/trace/trace_output.h |  16 ---
>  lib/Makefile                |   2 +-
>  lib/trace_seq.c             | 303 ++++++++++++++++++++++++++++++++++++++++++++

Putting it in there makes me look at it ;)

> --- a/include/linux/trace_seq.h
> +++ b/include/linux/trace_seq.h
>
> ...
>
> +#define SEQ_PUT_FIELD_RET(s, x)				\
> +do {							\
> +	if (!trace_seq_putmem(s, &(x), sizeof(x)))	\

hm, does sizeof(x++) increment x?  I guess it does.

> +		return TRACE_TYPE_PARTIAL_LINE;		\
> +} while (0)
>  
>
> ...
>
> +#define SEQ_PUT_HEX_FIELD_RET(s, x)			\
> +do {							\
> +	BUILD_BUG_ON(sizeof(x) > MAX_MEMHEX_BYTES);	\
> +	if (!trace_seq_putmem_hex(s, &(x), sizeof(x)))	\
> +		return TRACE_TYPE_PARTIAL_LINE;		\
> +} while (0)

Also has side-effects.

>  #endif /* _LINUX_TRACE_SEQ_H */
>
> ...
>
> --- /dev/null
> +++ b/lib/trace_seq.c
> @@ -0,0 +1,303 @@
> +/*
> + * trace_seq.c
> + *
> + * Copyright (C) 2008-2014 Red Hat Inc, Steven Rostedt <srostedt@redhat.com>
> + *
> + */
> +#include <linux/uaccess.h>
> +#include <linux/seq_file.h>
> +#include <linux/trace_seq.h>
> +
> +int trace_print_seq(struct seq_file *m, struct trace_seq *s)

-ENODOC

> +{
> +	int len = s->len >= PAGE_SIZE ? PAGE_SIZE - 1 : s->len;

	int = uint >= ulong ? ulog : uint

that's spastic.  Can we choose a type and stick to it?

Also, min().

> +	int ret;
> +
> +	ret = seq_write(m, s->buffer, len);
> +
> +	/*
> +	 * Only reset this buffer if we successfully wrote to the
> +	 * seq_file buffer.

why?

> +	 */
> +	if (!ret)
> +		trace_seq_init(s);
> +
> +	return ret;
> +}
> +
> +/**
> + * trace_seq_printf - sequence printing of trace information
> + * @s: trace sequence descriptor
> + * @fmt: printf format string
> + *
> + * It returns 0 if the trace oversizes the buffer's free
> + * space, 1 otherwise.

s/oversizes/would overrun/?

> + * The tracer may use either sequence operations or its own
> + * copy to user routines. To simplify formating of a trace
> + * trace_seq_printf is used to store strings into a special
> + * buffer (@s). Then the output may be either used by
> + * the sequencer or pulled into another buffer.
> + */
> +int
> +trace_seq_printf(struct trace_seq *s, const char *fmt, ...)

unneeded newline

> +{
> +	int len = (PAGE_SIZE - 1) - s->len;

	int = ulong - uint;

> +	va_list ap;
> +	int ret;
> +
> +	if (s->full || !len)
> +		return 0;
> +
> +	va_start(ap, fmt);
> +	ret = vsnprintf(s->buffer + s->len, len, fmt, ap);
> +	va_end(ap);
> +
> +	/* If we can't write it all, don't bother writing anything */

This is somewhat unusual behavior for a write()-style thing.  Comment
should explain "why", not "what".

> +	if (ret >= len) {
> +		s->full = 1;
> +		return 0;
> +	}
> +
> +	s->len += ret;
> +
> +	return 1;
> +}
> +EXPORT_SYMBOL_GPL(trace_seq_printf);
> +
> +/**
> + * trace_seq_bitmask - put a list of longs as a bitmask print output

Is that grammatical?

> + * @s:		trace sequence descriptor
> + * @maskp:	points to an array of unsigned longs that represent a bitmask
> + * @nmaskbits:	The number of bits that are valid in @maskp
> + *
> + * It returns 0 if the trace oversizes the buffer's free
> + * space, 1 otherwise.

Ditto

> + * Writes a ASCII representation of a bitmask string into @s.
> + */
> +int
> +trace_seq_bitmask(struct trace_seq *s, const unsigned long *maskp,
> +		  int nmaskbits)
> +{
> +	int len = (PAGE_SIZE - 1) - s->len;
> +	int ret;
> +
> +	if (s->full || !len)
> +		return 0;
> +
> +	ret = bitmap_scnprintf(s->buffer, len, maskp, nmaskbits);
> +	s->len += ret;
> +
> +	return 1;
> +}
> +EXPORT_SYMBOL_GPL(trace_seq_bitmask);

More dittos.

> +/**
> + * trace_seq_vprintf - sequence printing of trace information
> + * @s: trace sequence descriptor
> + * @fmt: printf format string
> + *
> + * The tracer may use either sequence operations or its own
> + * copy to user routines. To simplify formating of a trace
> + * trace_seq_printf is used to store strings into a special

"trace_seq_printf()".  Apparently it makes the kerneldoc output come
out right.

> + * buffer (@s). Then the output may be either used by
> + * the sequencer or pulled into another buffer.
> + */
> +int
> +trace_seq_vprintf(struct trace_seq *s, const char *fmt, va_list args)
> +{
> +	int len = (PAGE_SIZE - 1) - s->len;
> +	int ret;
> +
> +	if (s->full || !len)
> +		return 0;
> +
> +	ret = vsnprintf(s->buffer + s->len, len, fmt, args);
> +
> +	/* If we can't write it all, don't bother writing anything */
> +	if (ret >= len) {
> +		s->full = 1;
> +		return 0;
> +	}
> +
> +	s->len += ret;
> +
> +	return len;
> +}
> +EXPORT_SYMBOL_GPL(trace_seq_vprintf);

Several dittos.

> +int trace_seq_bprintf(struct trace_seq *s, const char *fmt, const u32 *binary)

-ENODOC

> +{
> +	int len = (PAGE_SIZE - 1) - s->len;
> +	int ret;
> +
> +	if (s->full || !len)
> +		return 0;
> +
> +	ret = bstr_printf(s->buffer + s->len, len, fmt, binary);
> +
> +	/* If we can't write it all, don't bother writing anything */
> +	if (ret >= len) {
> +		s->full = 1;
> +		return 0;
> +	}
> +
> +	s->len += ret;
> +
> +	return len;
> +}

Dittos.

> +/**
> + * trace_seq_puts - trace sequence printing of simple string
> + * @s: trace sequence descriptor
> + * @str: simple string to record
> + *
> + * The tracer may use either the sequence operations or its own
> + * copy to user routines. This function records a simple string
> + * into a special buffer (@s) for later retrieval by a sequencer
> + * or other mechanism.
> + */
> +int trace_seq_puts(struct trace_seq *s, const char *str)
> +{
> +	int len = strlen(str);
> +
> +	if (s->full)
> +		return 0;
> +
> +	if (len > ((PAGE_SIZE - 1) - s->len)) {
> +		s->full = 1;
> +		return 0;
> +	}
> +
> +	memcpy(s->buffer + s->len, str, len);
> +	s->len += len;
> +
> +	return len;
> +}

Missing EXPORT_SYMBOL?

> +int trace_seq_putc(struct trace_seq *s, unsigned char c)
> +{
> +	if (s->full)
> +		return 0;
> +
> +	if (s->len >= (PAGE_SIZE - 1)) {
> +		s->full = 1;
> +		return 0;
> +	}
> +
> +	s->buffer[s->len++] = c;
> +
> +	return 1;
> +}
> +EXPORT_SYMBOL(trace_seq_putc);

Mix of EXPORT_SYMBOL() and EXPORT_SYMBOL_GPL()

> +int trace_seq_putmem(struct trace_seq *s, const void *mem, size_t len)
> +{
> +	if (s->full)
> +		return 0;
> +
> +	if (len > ((PAGE_SIZE - 1) - s->len)) {
> +		s->full = 1;
> +		return 0;
> +	}
> +
> +	memcpy(s->buffer + s->len, mem, len);
> +	s->len += len;
> +
> +	return len;
> +}
> +

Lotsa dittos

> +#define HEX_CHARS		(MAX_MEMHEX_BYTES*2 + 1)
> +
> +int trace_seq_putmem_hex(struct trace_seq *s, const void *mem, size_t len)
> +{
> +	unsigned char hex[HEX_CHARS];
> +	const unsigned char *data = mem;
> +	int i, j;
> +
> +	if (s->full)
> +		return 0;

What's this ->full thing all about anyway?  Some central comment which
explains the design is needed.

Is this test really needed?  trace_seq_putmem() will handle this.

> +#ifdef __BIG_ENDIAN
> +	for (i = 0, j = 0; i < len; i++) {
> +#else
> +	for (i = len-1, j = 0; i >= 0; i--) {
> +#endif
> +		hex[j++] = hex_asc_hi(data[i]);
> +		hex[j++] = hex_asc_lo(data[i]);
> +	}
> +	hex[j++] = ' ';
> +
> +	return trace_seq_putmem(s, hex, j);
> +}

-ENODOC, missing EXPORT_SYMBOL.

> +void *trace_seq_reserve(struct trace_seq *s, size_t len)

`len' is a size_t here, a uint in trace_seq and an int when it's a local.

> +{
> +	void *ret;
> +
> +	if (s->full)
> +		return NULL;
> +
> +	if (len > ((PAGE_SIZE - 1) - s->len)) {
> +		s->full = 1;
> +		return NULL;
> +	}
> +
> +	ret = s->buffer + s->len;
> +	s->len += len;
> +
> +	return ret;
> +}

Dittos

> +int trace_seq_path(struct trace_seq *s, const struct path *path)
> +{
> +	unsigned char *p;
> +
> +	if (s->full)
> +		return 0;
> +
> +	if (s->len >= (PAGE_SIZE - 1)) {
> +		s->full = 1;
> +		return 0;
> +	}
> +
> +	p = d_path(path, s->buffer + s->len, PAGE_SIZE - s->len);
> +	if (!IS_ERR(p)) {
> +		p = mangle_path(s->buffer + s->len, p, "\n");
> +		if (p) {
> +			s->len = p - s->buffer;
> +			return 1;
> +		}
> +	} else {
> +		s->buffer[s->len++] = '?';
> +		return 1;
> +	}
> +
> +	s->full = 1;
> +	return 0;
> +}

Dittos

> +ssize_t trace_seq_to_user(struct trace_seq *s, char __user *ubuf, size_t cnt)
> +{
> +	int len;
> +	int ret;
> +
> +	if (!cnt)
> +		return 0;
> +
> +	if (s->len <= s->readpos)
> +		return -EBUSY;
> +
> +	len = s->len - s->readpos;
> +	if (cnt > len)
> +		cnt = len;
> +	ret = copy_to_user(ubuf, s->buffer + s->readpos, cnt);
> +	if (ret == cnt)
> +		return -EFAULT;
> +
> +	cnt -= ret;
> +
> +	s->readpos += cnt;
> +	return cnt;
> +}

Dittos

