Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752989AbaKGTKp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 14:10:45 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.231]:13169 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751459AbaKGTKo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 14:10:44 -0500
Date: Fri, 7 Nov 2014 14:10:32 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Joe Perches <joe@perches.com>
Cc: Petr Mladek <pmladek@suse.cz>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jiri Kosina <jkosina@suse.cz>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [RFC][PATCH 03/12 v3] tracing: Create seq_buf layer in
 trace_seq
Message-ID: <20141107141032.6dce6cf0@gandalf.local.home>
In-Reply-To: <1415386767.23530.14.camel@perches.com>
References: <20141104155237.228431433@goodmis.org>
	<20141104160221.864997179@goodmis.org>
	<20141105142222.GC4570@pathway.suse.cz>
	<20141105134147.226a23ef@gandalf.local.home>
	<20141105150007.1c543b9e@gandalf.local.home>
	<20141105161720.71abdbdb@gandalf.local.home>
	<20141105162146.6edc1567@gandalf.local.home>
	<20141106163352.GJ2001@dhcp128.suse.cz>
	<20141107133017.0d0ecd2e@gandalf.local.home>
	<1415386767.23530.14.camel@perches.com>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.25; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 07 Nov 2014 10:59:27 -0800
Joe Perches <joe@perches.com> wrote:


> > Create a seq_buf layer that trace_seq sits on. The seq_buf will not
> > be limited to page size. This will allow other usages of seq_buf
> > instead of a hard set PAGE_SIZE one that trace_seq has.
> > 
> > Link: http://lkml.kernel.org/r/20141104160221.864997179@goodmis.org
> []
> > diff --git a/include/linux/seq_buf.h b/include/linux/seq_buf.h
> []
> > +extern __printf(2, 3)
> > +int seq_buf_printf(struct seq_buf *s, const char *fmt, ...);
> > +extern __printf(2, 0)
> > +int seq_buf_vprintf(struct seq_buf *s, const char *fmt, va_list args);
> > +extern int
> > +seq_buf_bprintf(struct seq_buf *s, const char *fmt, const u32 *binary);
> > +extern int seq_buf_print_seq(struct seq_file *m, struct seq_buf *s);
> > +extern int seq_buf_to_user(struct seq_buf *s, char __user *ubuf,
> > +			   int cnt);
> > +extern int seq_buf_puts(struct seq_buf *s, const char *str);
> > +extern int seq_buf_putc(struct seq_buf *s, unsigned char c);
> > +extern int seq_buf_putmem(struct seq_buf *s, const void *mem, unsigned int len);
> > +extern int seq_buf_putmem_hex(struct seq_buf *s, const void *mem,
> > +			      unsigned int len);
> > +extern int seq_buf_path(struct seq_buf *s, const struct path *path);
> > +
> > +extern int seq_buf_bitmask(struct seq_buf *s, const unsigned long *maskp,
> > +			   int nmaskbits);
> 
> Maybe remove the extern bits from the function definitions?

Yeah, probably should have done that. Not sure why I kept them. Cut and
paste?

> And maybe the unsigned int len/cnt could be size_t

The struct does get changed later to match seq_file.

> 
> > diff --git a/include/linux/trace_seq.h b/include/linux/trace_seq.h
> []
> > @@ -12,16 +12,14 @@
> >  
> >  struct trace_seq {
> >  	unsigned char		buffer[PAGE_SIZE];
> > -	unsigned int		len;
> > -	unsigned int		readpos;
> > +	struct seq_buf		seq;
> >  	int			full;
> >  };
> >  
> >  static inline void
> >  trace_seq_init(struct trace_seq *s)
> >  {
> > -	s->len = 0;
> > -	s->readpos = 0;
> > +	seq_buf_init(&s->seq, s->buffer, PAGE_SIZE);
> 
> Maybe the PAGE_SIZE uses could be ARRAY_SIZE(s->buffer)
> 
> > diff --git a/kernel/trace/trace_seq.c b/kernel/trace/trace_seq.c
> []
> >  /* How much buffer is written? */
> > -#define TRACE_SEQ_BUF_USED(s) min((s)->len, (unsigned int)(PAGE_SIZE - 1))
> > +#define TRACE_SEQ_BUF_USED(s) min((s)->seq.len, (unsigned int)(PAGE_SIZE - 1))
> 
> min_t?
> maybe this should be FIELD_SIZEOF(struct trace_seq, buffer) - 1

These can be done at a later time. This patch set is focusing on
creation of seq_buf, not cleaning up trace_seq.

-- Steve

