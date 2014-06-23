Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756434AbaFWRDx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 13:03:53 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.227]:58265 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756260AbaFWRDw convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 13:03:52 -0400
Date: Mon, 23 Jun 2014 13:03:36 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Petr =?UTF-8?B?TWzDoWRlaw==?= <pmladek@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Jiri Kosina <jkosina@suse.cz>,
        Michal Hocko <mhocko@suse.cz>, Jan Kara <jack@suse.cz>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Dave Anderson <anderson@redhat.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
Subject: Re: [RFC][PATCH 1/3] trace_seq: Move the trace_seq code to lib/
Message-ID: <20140623130336.5f9ba216@gandalf.local.home>
In-Reply-To: <20140623163306.GE8769@pathway.suse.cz>
References: <20140619213329.478113470@goodmis.org>
	<20140619213952.058255809@goodmis.org>
	<20140619220607.c6da2540.akpm@linux-foundation.org>
	<20140620125823.5acb12dd@gandalf.local.home>
	<20140620101244.a1f4534e.akpm@linux-foundation.org>
	<20140620162845.256360e5@gandalf.local.home>
	<20140620165145.2fab6626@gandalf.local.home>
	<20140623163306.GE8769@pathway.suse.cz>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 23 Jun 2014 18:33:06 +0200
Petr Mládek <pmladek@suse.cz> wrote:


> >  * A write to the buffer will either succed or fail. That is, unlike
> >  * sprintf() there will not be a partial write (well it may write into
> >  * the buffer but it wont update the pointers). This allows users to
> >  * try to write something into the trace_seq buffer and if it fails
> >  * they can flush it and try again.
> 
> We might want to write as much as possible to the buffer if it is used
> for the backtrace.

Understood, but there is a reason for this way of doing things.

> 
> Well, if I understand it correctly, this is only about the last
> line. If the trace does not fit, we are in troubles anyway. We might
> solve this later when needed.
> 
> >  */
> > #include <linux/uaccess.h>
> > #include <linux/seq_file.h>
> > #include <linux/trace_seq.h>
> > 
> > /* How much buffer is left on the trace_seq? */
> > #define TRACE_SEQ_BUF_LEFT(s) ((PAGE_SIZE - 1) - (s)->len)
> > 
> > /* How much buffer is written? */
> > #define TRACE_SEQ_BUF_USED(s) min((s)->len, (unsigned int)(PAGE_SIZE - 1))
> 
> [...]
>  
> > /**
> >  * trace_seq_printf - sequence printing of trace information
> >  * @s: trace sequence descriptor
> >  * @fmt: printf format string
> >  *
> >  * The tracer may use either sequence operations or its own
> >  * copy to user routines. To simplify formating of a trace
> >  * trace_seq_printf() is used to store strings into a special
> >  * buffer (@s). Then the output may be either used by
> >  * the sequencer or pulled into another buffer.
> >  *
> >  * Returns 1 if we successfully written all the contents to
> >  *   the buffer.
> >   * Returns 0 if we the length to write is bigger than the
> >  *   reserved buffer space. In this case, nothing gets written.
> >  */
> > int trace_seq_printf(struct trace_seq *s, const char *fmt, ...)
> > {
> > 	unsigned int len = TRACE_SEQ_BUF_LEFT(s);
> > 	va_list ap;
> > 	int ret;
> > 
> > 	if (s->full || !len)
> > 		return 0;
> > 
> > 	va_start(ap, fmt);
> > 	ret = vsnprintf(s->buffer + s->len, len, fmt, ap);
> > 	va_end(ap);
> > 
> > 	/* If we can't write it all, don't bother writing anything */
> > 	if (ret >= len) {
> > 		s->full = 1;
> > 		return 0;
> > 	}
> > 
> > 	s->len += ret;
> > 
> > 	return 1;
> > }
> > EXPORT_SYMBOL_GPL(trace_seq_printf);
> > 
> > /**
> >  * trace_seq_bitmask - write a bitmask array in its ASCII representation
> >  * @s:		trace sequence descriptor
> >  * @maskp:	points to an array of unsigned longs that represent a bitmask
> >  * @nmaskbits:	The number of bits that are valid in @maskp
> >  *
> >  * Writes a ASCII representation of a bitmask string into @s.
> >  *
> >  * Returns 1 if we successfully written all the contents to
> >  *   the buffer.
> >  * Returns 0 if we the length to write is bigger than the
> >  *   reserved buffer space. In this case, nothing gets written.
> >  */
> > int trace_seq_bitmask(struct trace_seq *s, const unsigned long *maskp,
> > 		      int nmaskbits)
> > {
> > 	unsigned int len = TRACE_SEQ_BUF_LEFT(s);
> > 	int ret;
> > 
> > 	if (s->full || !len)
> > 		return 0;
> > 
> > 	ret = bitmap_scnprintf(s->buffer, len, maskp, nmaskbits);
> 
> We do not detect here if the whole bitmap is written. Hmm, the perfect
> solution is not easy. What about using the following workaround?

Ah right. Nice catch.

> 
> If we wrote until the end of the buffer, the write was most likely
> incomplete:
> 
> 	if (ret == len) {
> 		s->full = 1;
> 		return 0;
> 	}
> 
> It is more consistent with what we do in the other functions.
> 
> > 	s->len += ret;
> >
> > 	return 1;
> > }

I'll have to look into this too. Yeah, the results should be more
consistent. Maybe have zero be it fit, and return how much buffer is
left when it doesn't fit?

> > EXPORT_SYMBOL_GPL(trace_seq_bitmask);
> > 
> 
> [...]
> 
> > /**
> >  * trace_seq_putmem_hex - write raw memory into the buffer in ASCII hex
> >  * @s: trace sequence descriptor
> >  * @mem: The raw memory to write its hex ASCII representation of
> >  * @len: The length of the raw memory to copy (in bytes)
> >  *
> >  * This is similar to trace_seq_putmem() except instead of just copying the
> >  * raw memory into the buffer it writes its ASCII representation of it
> >  * in hex characters.
> >  *
> >  * Returns 1 if we successfully written all the contents to
> >  *   the buffer.
> >  * Returns 0 if we the length to write is bigger than the
> >  *   reserved buffer space. In this case, nothing gets written.
> >  */
> > int trace_seq_putmem_hex(struct trace_seq *s, const void *mem,
> > 			 unsigned int len)
> > {
> > 	unsigned char hex[HEX_CHARS];
> > 	const unsigned char *data = mem;
> > 	int i, j;
> > 
> > 	if (s->full)
> > 		return 0;
> > 
> > #ifdef __BIG_ENDIAN
> > 	for (i = 0, j = 0; i < len; i++) {
> > #else
> > 	for (i = len-1, j = 0; i >= 0; i--) {
> > #endif
> 
> This might overflow when "len" > (HEX_CHARS-1)/2.

Yes I caught this while doing updates per Andrew's replies. Currently
it's fine because the only user of it is wrapped in the macro. It
originally had a BUG_ON() if len > HEX_CHARS but that was moved to the
macro to make it a build bug on. I hate this function, but we need to
keep it to keep backward compatibility for what was in the original -rt
latency tracer :-p

Anyway, last week I rewrote this function to be much more robust. You
can look at my branch ftrace/next (caution, it rebases constantly).



> 
> I think that we should either limit "len" or make it in two cycles.
> 
> Hmm, if we use two cycles, it might be problem how to solve the endianity.
> IMHO, it depends on what type of data is written into the buffer
> (single vs. set of values).
> 
> > 		hex[j++] = hex_asc_hi(data[i]);
> > 		hex[j++] = hex_asc_lo(data[i]);
> > 	}
> > 	hex[j++] = ' ';
> > 
> > 	return trace_seq_putmem(s, hex, j);
> > }
> > EXPORT_SYMBOL_GPL(trace_seq_putmem_hex);
> > 
> > /**
> >  * trace_seq_reserve - reserve space on the sequence buffer
> >  * @s: trace sequence descriptor
> >  * @len: The amount to reserver.
> >  *
> >  * If for some reason there is a need to save some space on the
> >  * buffer to fill in later, this function is used for that purpose.
> >  * The given length will be reserved and the pointer to that
> >  * location on the buffer is returned, unless there is not enough
> >  * buffer left to hold the given length then NULL is returned.
> >  */
> > void *trace_seq_reserve(struct trace_seq *s, unsigned int len)
> > {
> > 	void *ret;
> > 
> > 	if (s->full)
> > 		return NULL;
> > 
> > 	if (len > TRACE_SEQ_BUF_LEFT(s)) {
> > 		s->full = 1;
> > 		return NULL;
> > 	}
> > 
> > 	ret = s->buffer + s->len;
> > 	s->len += len;
> > 
> > 	return ret;
> > }
> > EXPORT_SYMBOL_GPL(trace_seq_reserve);
> 
> This sounds like a slightly dangerous operation. The reserve is valid only
> until the buffer is re-initialized. Is this really intended?

Well, the only on reserving it should be whoever is using it. It is
like allocating memory and then letting something else free it.

> Do we really want to export it?

Honestly, I don't know why this was added. It was created by Eduard and
pulled in by Ingo. There's no users in the kernel. I think I may just
nuke it.


> 
> Well, the whole buffer need to be used carefully. IMHO, it can't be accessed
> in parallel without extra locks. So, this might be fine after all. We
> could only warn about this in the function description.
> 

Well, neither can seq_file. It's based on that. Take a look at some of
my changes in ftrace/next and see .

> [...]
> 
> The rest looks fine to me.
> 
> Also the proposed name "seq_buf" sounds fine to me.

Yeah, that may change soon too. Right now I'm working on cleaning up
the code within the trace directory, and then I'll push it to lib if
this is the way we are going.

-- Steve


> 
> 
> Best Regards,
> Petr

