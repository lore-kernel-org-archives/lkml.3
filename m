Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751960AbaKEUK4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 15:10:56 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.227]:61949 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751133AbaKEUKz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 15:10:55 -0500
Date: Wed, 5 Nov 2014 15:10:53 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Petr Mladek <pmladek@suse.cz>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jiri Kosina <jkosina@suse.cz>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [RFC][PATCH 04/12 v3] tracing: Convert seq_buf_path() to be
 like seq_path()
Message-ID: <20141105151053.744b77f2@gandalf.local.home>
In-Reply-To: <20141105144553.GE4570@pathway.suse.cz>
References: <20141104155237.228431433@goodmis.org>
	<20141104160222.048795666@goodmis.org>
	<20141105144553.GE4570@pathway.suse.cz>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.25; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 5 Nov 2014 15:45:53 +0100
Petr Mladek <pmladek@suse.cz> wrote:


> >   */
> > -int seq_buf_path(struct seq_buf *s, const struct path *path)
> > +int seq_buf_path(struct seq_buf *s, const struct path *path, const char *esc)
> >  {
> > -	unsigned int len = SEQ_BUF_LEFT(s);
> > -	unsigned char *p;
> > -
> > -	WARN_ON(s->size == 0);
> 
> I would keep this check.

Yeah, I could.

> 
> > -	p = d_path(path, s->buffer + s->len, len);
> > -	if (!IS_ERR(p)) {
> > -		p = mangle_path(s->buffer + s->len, p, "\n");
> > -		if (p) {
> > -			s->len = p - s->buffer;
> > -			return 0;
> > +	char *buf = s->buffer + s->len;
> > +	size_t size = SEQ_BUF_LEFT(s);
> 
> I would use the variable name "len" to make it consistent with
> the other fucntions in seq_buf.c.

Note, seq_path() is a different beast than the other seq_*() functions
(this will be keeping a return code). And the inconsistency is in
seq_file.c as well. I'm not saying we shouldn't keep it consistent. But
as this patch is to make seq_buf like seq_file, I'll keep the
inconsistencies the same too.

We can always do a clean up later.


> 
> > +	int res = -1;
> > +
> > +	if (size) {
> > +		char *p = d_path(path, buf, size);
> > +		if (!IS_ERR(p)) {
> > +			char *end = mangle_path(buf, p, esc);
> > +			if (end)
> > +				res = end - buf;
> >  		}
> >  	}
> > -	seq_buf_set_overflow(s);
> 
> We still should set overflow on failure.

Again, this is different in seq_file too. I'm leaving it as is.

> 
> > -	return -1;
> > +	if (res > 0)
> > +		s->len += res;
> > +
> > +	return res;
> 
> It returns -1 on failure and the number of written characters on
> success. This is incompatible with the other seq_buf functions
> and with the comment above this function. Also it changes the
> return value from trace_seq_path().
> 
> I do not mind about the used scheme but I think that we should
> make it consistent.
> 

As seq_file has had this inconsistency for a long time, and this code
is to try to merge the code between trace_seq and seq_file, I'm going
to follow seq_file as that has been around much longer than trace_seq.

-- Steve

