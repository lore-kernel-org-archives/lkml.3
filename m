Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932164AbaKSPuK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 10:50:10 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.227]:35341 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754921AbaKSPuG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 10:50:06 -0500
Date: Wed, 19 Nov 2014 10:49:56 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Petr Mladek <pmladek@suse.cz>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jiri Kosina <jkosina@suse.cz>
Subject: Re: [PATCH 18/26 v5] seq_buf: Create seq_buf_used() to find out how
 much was written
Message-ID: <20141119104956.14cc30cb@gandalf.local.home>
In-Reply-To: <20141118150204.GI23958@pathway.suse.cz>
References: <20141115045847.712848224@goodmis.org>
	<20141115050603.696625970@goodmis.org>
	<20141118150204.GI23958@pathway.suse.cz>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.25; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 18 Nov 2014 16:02:04 +0100
Petr Mladek <pmladek@suse.cz> wrote:

> On Fri 2014-11-14 23:59:05, Steven Rostedt wrote:
> > From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>
> > 
> > Add a helper function seq_buf_used() that replaces the SEQ_BUF_USED()
> > private macro to let callers have a method to know how much of the
> > seq_buf was written to.
> > 
> > Link: http://lkml.kernel.org/r/20141114011412.170377300@goodmis.org
> > Link: http://lkml.kernel.org/r/20141114011413.321654244@goodmis.org
> > 
> > Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> > ---
> >  include/linux/seq_buf.h | 6 ++++++
> >  kernel/trace/seq_buf.c  | 5 +----
> >  2 files changed, 7 insertions(+), 4 deletions(-)
> > 
> > diff --git a/include/linux/seq_buf.h b/include/linux/seq_buf.h
> > index 5d91262433e2..93718e570d4c 100644
> > --- a/include/linux/seq_buf.h
> > +++ b/include/linux/seq_buf.h
> > @@ -64,6 +64,12 @@ seq_buf_buffer_left(struct seq_buf *s)
> >  	return (s->size - 1) - s->len;
> >  }
> >  
> > +/* How much buffer was written? */
> > +static inline unsigned int seq_buf_used(struct seq_buf *s)
> > +{
> > +	return min(s->len, s->size);
> 
> To be precise, it should do
> 
> 	return min(s->len, s->size - 1);
> 
> at this stage and switch to the above code in ("[PATCH 21/26 v5] tracing: Have
> seq_buf use full buffer"). Well, it does not cause any big harm. Feel
> free to add:

I actually thought about it, but realized that this only replaces the
original use of s->len, and we are only doing this to avoid buffer
overflows. If you get garbage, then so be it, as the original code
would give garbage too. Remember, some of the functions did have real
content in that last byte, even though it was considered "overflowed".

-- Steve


> 
> Reviewed-by: Petr Mladek <pmladek@suse.cz>
> 
> for this patch or for the updated one.
> 
