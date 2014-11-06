Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751408AbaKFQNU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 11:13:20 -0500
Received: from cantor2.suse.de ([195.135.220.15]:56524 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750963AbaKFQNR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 11:13:17 -0500
Date: Thu, 6 Nov 2014 17:13:13 +0100
From: Petr Mladek <pmladek@suse.cz>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jiri Kosina <jkosina@suse.cz>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [RFC][PATCH 03/12 v3] tracing: Create seq_buf layer in trace_seq
Message-ID: <20141106161313.GI2001@dhcp128.suse.cz>
References: <20141104155237.228431433@goodmis.org>
 <20141104160221.864997179@goodmis.org>
 <20141105142222.GC4570@pathway.suse.cz>
 <20141105134147.226a23ef@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141105134147.226a23ef@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 2014-11-05 13:41:47, Steven Rostedt wrote:
> On Wed, 5 Nov 2014 15:22:22 +0100
> Petr Mladek <pmladek@suse.cz> wrote:
> 
> > On Tue 2014-11-04 10:52:40, Steven Rostedt wrote:
> > > From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>
> > Also I would add an explanation of the overall logic. If I get it
> > correctly from the code, it is:
> > 
> > /*
> >  * The last byte of the buffer is used to detect an overflow in some
> >  * operations. Therefore, the buffer offers (@size - 1) bytes for valid
> >  * data.
> 
> Well, this will change in the future. And it is commented with the
> seq_buf_has_overflowed() function. I don't want to comment about it
> with the structure.

Fair enough.

> > > + */
> > > +#include <linux/uaccess.h>
> > > +#include <linux/seq_file.h>
> > > +#include <linux/seq_buf.h>
> > > +
> > > +/* How much buffer is left on the seq_buf? */
> > 
> > I would write the following to explain the -1:
> 
> Later patches gets rid of the -1. It's -1 because seq_file is -1 as
> well.

Yup. Let's leave it as is.
 
> > 
> > /* How much buffer is left for valid data */
> > 
> > > +#define SEQ_BUF_LEFT(s) (((s)->size - 1) - (s)->len)
> > 
> > Hmm, it might overflow when the buffer has overflown (s->len == s->size)
> > or when the buffer is not initialized (s->size == 0). Note that the
> > result should be unsigned int.
> 
> The two places that use it is "unsigned int" so that should not be a
> problem.

It might overflow. If ("size == len"), the result will be -1
which is UINT_MAX.

Well, this should not happen if callers check the overflow before
any use. Also we are going to remove the -1 in the followup patches.
I am fine with it after all.

> > > +
> > > +/**
> > > + * seq_buf_puts - sequence printing of simple string
> > > + * @s: seq_buf descriptor
> > > + * @str: simple string to record
> > > + *
> > > + * Copy a simple string into the sequence buffer.
> > > + *
> > > + * Returns zero on success, -1 on overflow
> > > + */
> > > +int seq_buf_puts(struct seq_buf *s, const char *str)
> > > +{
> > > +	unsigned int len = strlen(str);
> > > +
> > > +	WARN_ON(s->size == 0);
> > > +
> > > +	if (s->len + len < s->size) {
> > > +		memcpy(s->buffer + s->len, str, len);
> > > +		s->len += len;
> > > +		return 0;
> > > +	}
> > 
> > We might want to copy the maximum possible number of bytes.
> > It will then behave the same as the other functions.
> 
> I'm converting all this to be like seq_file in the other patches.

Fair enough.

> 
> > 
> > > + *
> > > + * Returns -EFAULT if the copy to userspace fails.
> > > + */
> > > +int seq_buf_to_user(struct seq_buf *s, char __user *ubuf, int cnt)
> > > +{
> > > +	int len;
> > > +	int ret;
> > > +
> > > +	if (!cnt)
> > > +		return 0;
> > > +
> > > +	if (s->len <= s->readpos)
> > > +		return -EBUSY;
> > > +
> > > +	len = s->len - s->readpos;
> > > +	if (cnt > len)
> > > +		cnt = len;
> > > +	ret = copy_to_user(ubuf, s->buffer + s->readpos, cnt);
> > > +	if (ret == cnt)
> > > +		return -EFAULT;
> > > +
> > > +	cnt -= ret;
> > > +
> > > +	s->readpos += cnt;
> > > +	return cnt;
> > > +}
> > 
> > [...]
> > 
> > > diff --git a/kernel/trace/trace_seq.c b/kernel/trace/trace_seq.c
> > > index 1f24ed99dca2..960ccfb2f50c 100644
> > > --- a/kernel/trace/trace_seq.c
> > > +++ b/kernel/trace/trace_seq.c
> > > @@ -27,10 +27,19 @@
> > >  #include <linux/trace_seq.h>
> > >  
> > >  /* How much buffer is left on the trace_seq? */
> > > -#define TRACE_SEQ_BUF_LEFT(s) ((PAGE_SIZE - 1) - (s)->len)
> > > +#define TRACE_SEQ_BUF_LEFT(s) ((PAGE_SIZE - 1) - (s)->seq.len)
> > 
> > This might overflow when s->len == PAGE_SIZE. I think that it
> > newer happenes because we always check s->full before. The question
> > is if we really want to depend on this.
> 
> Yeah, we should make this check seq_buf itself. Maybe make a static
> inline function that is in seq_buf.h.

The inline function in seq_buf.h looks like a good idea.

> > 
> > >  /* How much buffer is written? */
> > > -#define TRACE_SEQ_BUF_USED(s) min((s)->len, (unsigned int)(PAGE_SIZE - 1))
> > > +#define TRACE_SEQ_BUF_USED(s) min((s)->seq.len, (unsigned int)(PAGE_SIZE - 1))
> > > +
> > > +/*
> > > + * trace_seq should work with being initialized with 0s.
> > > + */
> > > +static inline void __trace_seq_init(struct trace_seq *s)
> > > +{
> > > +	if (unlikely(!s->seq.size))
> > > +		trace_seq_init(s);
> > > +}
> > >  
> > >  /**
> > >   * trace_print_seq - move the contents of trace_seq into a seq_file
> > > @@ -43,10 +52,11 @@
> > >   */
> > >  int trace_print_seq(struct seq_file *m, struct trace_seq *s)
> > >  {
> > > -	unsigned int len = TRACE_SEQ_BUF_USED(s);
> > >  	int ret;
> > >  
> > > -	ret = seq_write(m, s->buffer, len);
> > > +	__trace_seq_init(s);
> > > +
> > > +	ret = seq_buf_print_seq(m, &s->seq);
> > >  
> > >  	/*
> > >  	 * Only reset this buffer if we successfully wrote to the
> > > @@ -77,25 +87,25 @@ int trace_print_seq(struct seq_file *m, struct trace_seq *s)
> > >   */
> > >  int trace_seq_printf(struct trace_seq *s, const char *fmt, ...)
> > >  {
> > > -	unsigned int len = TRACE_SEQ_BUF_LEFT(s);
> > > +	unsigned int save_len = s->seq.len;
> > >  	va_list ap;
> > > -	int ret;
> > >  
> > > -	if (s->full || !len)
> > > +	if (s->full)
> > >  		return 0;
> > >  
> > > +	__trace_seq_init(s);
> > > +
> > >  	va_start(ap, fmt);
> > > -	ret = vsnprintf(s->buffer + s->len, len, fmt, ap);
> > > +	seq_buf_vprintf(&s->seq, fmt, ap);
> > >  	va_end(ap);
> > >  
> > >  	/* If we can't write it all, don't bother writing anything */
> > > -	if (ret >= len) {
> > > +	if (unlikely(seq_buf_has_overflowed(&s->seq))) {
> > 
> > We might check the return value from seq_buf_vprintf() here.
> 
> No, we are working to get rid of the return values for the seq_*()
> functions (with a few exceptions). One now must check if the buffer has
> overflowed, and not the return value of the seq_*() functions
> themselves.

I see.
 
> There's already patches out to convert the seq_file calls as well.

Good to know.

Best Regards,
Petr
