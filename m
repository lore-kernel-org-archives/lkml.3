Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753535AbaF0Npm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2014 09:45:42 -0400
Received: from cantor2.suse.de ([195.135.220.15]:58978 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752740AbaF0Npl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2014 09:45:41 -0400
Date: Fri, 27 Jun 2014 15:45:38 +0200
From: Petr =?iso-8859-1?Q?Ml=E1dek?= <pmladek@suse.cz>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jiri Kosina <jkosina@suse.cz>, Michal Hocko <mhocko@suse.cz>,
        Jan Kara <jack@suse.cz>, Frederic Weisbecker <fweisbec@gmail.com>,
        Dave Anderson <anderson@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Konstantin Khlebnikov <koct9i@gmail.com>
Subject: Re: [RFC][PATCH 2/5 v2] tracing: Create seq_buf layer in trace_seq
Message-ID: <20140627134538.GB23205@pathway.suse.cz>
References: <20140626214901.596791200@goodmis.org>
 <20140626220129.620409461@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140626220129.620409461@goodmis.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 2014-06-26 17:49:03, Steven Rostedt wrote:
> From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>
> 
> Create a seq_buf layer that trace_seq sits on. The seq_buf will not
> be limited to page size. This will allow other usages of seq_buf
> instead of a hard set PAGE_SIZE one that trace_seq has.
>
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> ---
>  include/linux/seq_buf.h              |  58 ++++++
>  include/linux/trace_seq.h            |  10 +-
>  kernel/trace/Makefile                |   1 +
>  kernel/trace/seq_buf.c               | 348 +++++++++++++++++++++++++++++++++++
>  kernel/trace/trace.c                 |  39 ++--
>  kernel/trace/trace_events.c          |   6 +-
>  kernel/trace/trace_functions_graph.c |   6 +-
>  kernel/trace/trace_seq.c             | 184 +++++++++---------
>  8 files changed, 527 insertions(+), 125 deletions(-)
>  create mode 100644 include/linux/seq_buf.h
>  create mode 100644 kernel/trace/seq_buf.c

There is a lot of similar code in the two layers. Do you have any
plans to transform the trace stuff to seq_buf and get rid of the
trace_seq layer in long term?

If I get it correctly, the two layers are needed because:

   1. seq_buf works with any buffer but
      trace_seq with static buffer

   2. seq_buf writes even part of the message until the buffer is full but
      trace_buf writes only full messages or nothing

   3. seq_buf returns the number of written characters but
      trace_seq returns 1 on success and 0 on failure

   4. seq_buf sets "overflow" flag when an operation failed but
      trace_seq sets "full" when this happens


I wounder if we could get a compromise and use only one layer.

ad 1st:

   I have checked many locations and it seems that trace_seq_init() is
   called before the other functions as used. There is the WARN_ON()
   in the generic seq_buf() functions, so they would not crash. If
   there is some init missing, we could fix it later.

   But I haven't really tested it yet.


ad 2nd and 3rd:

   These are connected.

   On solution is to disable writing part of the text even in the
   generic seq_buf functions. I think that it is perfectly fine.
   If we do not print the entire line, we are in troubles anyway.
   Note that we could not allocate another buffer in NMI, so
   we will lose part of the message anyway.

   Another solution would be to live with incomplete lines in tracing.
   I wonder if any of the functions tries to write the line again when the
   write failed.

   IMHO, the most important thing is that both functions return 0 on
   failure.


ad 4th:

   Both "full" and "overflow" flags seems to have the same meaning.
   For example, trace_seq_printf() sets "full" on failure even
   when s->seq.len != s->size.


Best Regards,
Petr

[...]

> --- /dev/null
> +++ b/kernel/trace/seq_buf.c
> @@ -0,0 +1,348 @@
> +/*
> + * seq_buf.c
> + *
> + * Copyright (C) 2014 Red Hat Inc, Steven Rostedt <srostedt@redhat.com>
> + *
> + * The seq_buf is a handy tool that allows you to pass a descriptor around
> + * to a buffer that other functions can write to. It is similar to the
> + * seq_file functionality but has some differences.
> + *
> + * To use it, the seq_buf must be initialized with seq_buf_init().
> + * This will set up the counters within the descriptor. You can call
> + * seq_buf_init() more than once to reset the seq_buf to start
> + * from scratch.
> + * 
> + */
> +#include <linux/uaccess.h>
> +#include <linux/seq_file.h>
> +#include <linux/seq_buf.h>
> +
> +/* How much buffer is left on the seq_buf? */
> +#define SEQ_BUF_LEFT(s) (((s)->size - 1) - (s)->len)
> +
> +/* How much buffer is written? */
> +#define SEQ_BUF_USED(s) min((s)->len, (s)->size - 1)
> +
> +static inline void seq_buf_check_len(struct seq_buf *s)
> +{
> +	if (unlikely(s->len > (s->size - 1))) {

I would create macro for this check. It is repeated many times. I mean

#define SEQ_BUF_OVERFLOW(s) (s->len > (s->size - 1))

if (unlikely(SEQ_BUF_OVERFLOW))

> +		s->len = s->size - 1;
> +		s->overflow = 1;
> +	}
> +}
> +

[...]

> +#define MAX_MEMHEX_BYTES	8U
> +#define HEX_CHARS		(MAX_MEMHEX_BYTES*2 + 1)
> +
> +/**
> + * seq_buf_putmem_hex - write raw memory into the buffer in ASCII hex
> + * @s: seq_buf descriptor
> + * @mem: The raw memory to write its hex ASCII representation of
> + * @len: The length of the raw memory to copy (in bytes)
> + *
> + * This is similar to seq_buf_putmem() except instead of just copying the
> + * raw memory into the buffer it writes its ASCII representation of it
> + * in hex characters.
> + *
> + * Returns how much it wrote to the buffer.
> + */
> +int seq_buf_putmem_hex(struct seq_buf *s, const void *mem,
> +		       unsigned int len)
> +{
> +	unsigned char hex[HEX_CHARS];
> +	const unsigned char *data = mem;
> +	unsigned int start_len;
> +	int i, j;
> +	int cnt = 0;
> +
> +	while (len) {
> +		start_len = min(len, HEX_CHARS - 1);

I would do s/start_len/end_len/

I know that it depends on the point of view. But iteration between "0"
and "end" is better understandable for me :-)

> +#ifdef __BIG_ENDIAN
> +		for (i = 0, j = 0; i < start_len; i++) {
> +#else
> +		for (i = start_len-1, j = 0; i >= 0; i--) {
> +#endif
> +			hex[j++] = hex_asc_hi(data[i]);
> +			hex[j++] = hex_asc_lo(data[i]);
> +		}
> +		if (WARN_ON_ONCE(j == 0 || j/2 > len))
> +			break;
> +
> +		/* j increments twice per loop */
> +		len -= j / 2;
> +		hex[j++] = ' ';
> +
> +		cnt += seq_buf_putmem(s, hex, j);
> +	}
> +	return cnt;
> +}
> +
> +/**
> + * seq_buf_path - copy a path into the sequence buffer
> + * @s: seq_buf descriptor
> + * @path: path to write into the sequence buffer.
> + *
> + * Write a path name into the sequence buffer.
> + *
> + * Returns the number of bytes written into the buffer.
> + */
> +int seq_buf_path(struct seq_buf *s, const struct path *path)
> +{
> +	unsigned int len = SEQ_BUF_LEFT(s);
> +	unsigned char *p;
> +	unsigned int start = s->len;
> +
> +	WARN_ON((int)len < 0);
> +	p = d_path(path, s->buffer + s->len, len);
> +	if (!IS_ERR(p)) {
> +		p = mangle_path(s->buffer + s->len, p, "\n");
> +		if (p) {
> +			s->len = p - s->buffer;
> +	WARN_ON(s->len > (s->size - 1));

strange indentation

> +			return s->len - start;
> +		}
> +	} else {
> +		s->buffer[s->len++] = '?';
> +	WARN_ON(s->len > (s->size - 1));

same here

> +		return s->len - start;
> +	}
> +
> +	s->overflow = 1;
> +	return 0;
> +}
> +


Best Regards,
Petr
