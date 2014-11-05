Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752208AbaKEVR0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 16:17:26 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.227]:56842 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752176AbaKEVRW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 16:17:22 -0500
Date: Wed, 5 Nov 2014 16:17:20 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Petr Mladek <pmladek@suse.cz>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jiri Kosina <jkosina@suse.cz>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [RFC][PATCH 03/12 v3] tracing: Create seq_buf layer in
 trace_seq
Message-ID: <20141105161720.71abdbdb@gandalf.local.home>
In-Reply-To: <20141105150007.1c543b9e@gandalf.local.home>
References: <20141104155237.228431433@goodmis.org>
	<20141104160221.864997179@goodmis.org>
	<20141105142222.GC4570@pathway.suse.cz>
	<20141105134147.226a23ef@gandalf.local.home>
	<20141105150007.1c543b9e@gandalf.local.home>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.25; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 5 Nov 2014 15:00:07 -0500
Steven Rostedt <rostedt@goodmis.org> wrote:

> On Wed, 5 Nov 2014 13:41:47 -0500
> Steven Rostedt <rostedt@goodmis.org> wrote:
> 
> > > 
> > > > + */
> > > > +int seq_buf_bitmask(struct seq_buf *s, const unsigned long *maskp,
> > > > +		    int nmaskbits)
> > > > +{
> > > > +	unsigned int len = SEQ_BUF_LEFT(s);
> > > >
> > > > +	int ret;
> > > > +
> > > > +	WARN_ON(s->size == 0);
> > > > +
> > > > +	if (s->len < s->size) {
> > > > +		ret = bitmap_scnprintf(s->buffer, len, maskp, nmaskbits);
> > > 
> > > It writes to the beginning of the buffer. It should be
> > > 
> > > 		ret = bitmap_scnprintf(s->buffer + s->len, len,
> > > 				       maskp, nmaskbits);
> > >
> > 
> > Yep thanks. Luckily its only user didn't care.
> > 
> > Will fix.
> >  
> > > 
> > > > +		if (s->len + ret < s->size) {
> > > 
> > > This will always happen because bitmap_scnprintf() is limited by SEQ_BUF_LEFT(s)
> > > and it currently returns the remaining size - len - 1.
> > 
> > Hmm, that's correct, as bitmap_scnprintf() returns the amount written
> > instead of the amount that it would write like snprintf() would.
> > 
> > 
> > > 
> > > You might want to use "s->size - s->len" instead of SEQ_BUF_LEFT(s).
> > 
> > That wont help when we make overflow len > size.
> > 
> > Probably should see if ret == the amount of bits required for the
> > bitmask.
> 
> Here's the new version:
> 

Take 2:

int seq_buf_bitmask(struct seq_buf *s, const unsigned long *maskp,
		    int nmaskbits)
{
	unsigned int len = seq_buf_buffer_left(s);
	int ret;

	WARN_ON(s->size == 0);

	if (s->len < s->size) {
		ret = bitmap_scnprintf(s->buffer, len, maskp, nmaskbits);
		/*
		 * Note, because bitmap_scnprintf() only returns the
		 * number of bytes written and not the number that
		 * would be written, we use the last byte of the buffer
		 * to let us know if we overflowed. There's a small
		 * chance that the bitmap could have fit exactly inside
		 * the buffer, but it's not that critical if that does
		 * happen.
		 */
		if (s->len + ret < s->size) {
			s->len += ret;
			return 0;
		}
	}
	seq_buf_set_overflow(s);
	return -1;
}

-- Steve
