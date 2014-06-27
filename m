Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753919AbaF0OVh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2014 10:21:37 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:52231 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753189AbaF0OVg convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2014 10:21:36 -0400
Date: Fri, 27 Jun 2014 10:21:34 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Petr =?UTF-8?B?TWzDoWRlaw==?= <pmladek@suse.cz>
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
Message-ID: <20140627102134.5d2cae41@gandalf.local.home>
In-Reply-To: <20140627134538.GB23205@pathway.suse.cz>
References: <20140626214901.596791200@goodmis.org>
	<20140626220129.620409461@goodmis.org>
	<20140627134538.GB23205@pathway.suse.cz>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 27 Jun 2014 15:45:38 +0200
Petr Mládek <pmladek@suse.cz> wrote:

> ad 4th:
> 
>    Both "full" and "overflow" flags seems to have the same meaning.
>    For example, trace_seq_printf() sets "full" on failure even
>    when s->seq.len != s->size.
> 
> 
> Best Regards,
> Petr
> 
> [...]


BTW, you shouldn't sign off if you have more comments, I usually stop
reading when I see someone's signature. Or at the very least, state
that you have more comments below.
 
> > --- /dev/null
> > +++ b/kernel/trace/seq_buf.c
> > @@ -0,0 +1,348 @@
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
> > + */
> > +#include <linux/uaccess.h>
> > +#include <linux/seq_file.h>
> > +#include <linux/seq_buf.h>
> > +
> > +/* How much buffer is left on the seq_buf? */
> > +#define SEQ_BUF_LEFT(s) (((s)->size - 1) - (s)->len)
> > +
> > +/* How much buffer is written? */
> > +#define SEQ_BUF_USED(s) min((s)->len, (s)->size - 1)
> > +
> > +static inline void seq_buf_check_len(struct seq_buf *s)
> > +{
> > +	if (unlikely(s->len > (s->size - 1))) {
> 
> I would create macro for this check. It is repeated many times. I mean
> 
> #define SEQ_BUF_OVERFLOW(s) (s->len > (s->size - 1))
> 
> if (unlikely(SEQ_BUF_OVERFLOW))

Yeah, I was hoping that the static inline would be enough, but then it
didn't fit into the functions at the end. I never got around to then
adding a macro.

Everything was open coded when I first created it.

> 
> > +		s->len = s->size - 1;
> > +		s->overflow = 1;
> > +	}
> > +}
> > +
> 
> [...]
> 
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
> > + * Returns how much it wrote to the buffer.
> > + */
> > +int seq_buf_putmem_hex(struct seq_buf *s, const void *mem,
> > +		       unsigned int len)
> > +{
> > +	unsigned char hex[HEX_CHARS];
> > +	const unsigned char *data = mem;
> > +	unsigned int start_len;
> > +	int i, j;
> > +	int cnt = 0;
> > +
> > +	while (len) {
> > +		start_len = min(len, HEX_CHARS - 1);
> 
> I would do s/start_len/end_len/
> 
> I know that it depends on the point of view. But iteration between "0"
> and "end" is better understandable for me :-)

Yeah, I didn't like the name of that variable. I guess end_len is
better, but still not exactly what I want to call it. Unfortunately, I
don't know what exactly I want to call it ;-)

> 
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
> > +		cnt += seq_buf_putmem(s, hex, j);
> > +	}
> > +	return cnt;
> > +}
> > +
> > +/**
> > + * seq_buf_path - copy a path into the sequence buffer
> > + * @s: seq_buf descriptor
> > + * @path: path to write into the sequence buffer.
> > + *
> > + * Write a path name into the sequence buffer.
> > + *
> > + * Returns the number of bytes written into the buffer.
> > + */
> > +int seq_buf_path(struct seq_buf *s, const struct path *path)
> > +{
> > +	unsigned int len = SEQ_BUF_LEFT(s);
> > +	unsigned char *p;
> > +	unsigned int start = s->len;
> > +
> > +	WARN_ON((int)len < 0);
> > +	p = d_path(path, s->buffer + s->len, len);
> > +	if (!IS_ERR(p)) {
> > +		p = mangle_path(s->buffer + s->len, p, "\n");
> > +		if (p) {
> > +			s->len = p - s->buffer;
> > +	WARN_ON(s->len > (s->size - 1));
> 
> strange indentation
> 
> > +			return s->len - start;
> > +		}
> > +	} else {
> > +		s->buffer[s->len++] = '?';
> > +	WARN_ON(s->len > (s->size - 1));
> 
> same here

Heh, I added those for debugging, and then decided to keep it. Never
went back to clean it up :-/

-- Steve

> 
> > +		return s->len - start;
> > +	}
> > +
> > +	s->overflow = 1;
> > +	return 0;
> > +}
> > +
> 
> 
> Best Regards,
> Petr

