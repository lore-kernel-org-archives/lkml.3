Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755404AbaHZNxb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 09:53:31 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.231]:16545 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754404AbaHZNx3 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 09:53:29 -0400
Date: Tue, 26 Aug 2014 09:53:27 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Petr =?ISO-8859-1?B?TWzhZGVr?= <pmladek@suse.cz>
Cc: Patrick Palka <patrick@parcs.ath.cx>, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, jack@suse.cz
Subject: Re: [PATCH] Fix faulty logic in the case of recursive printk
Message-ID: <20140826095327.3348e19e@gandalf.local.home>
In-Reply-To: <20140826091941.GA2360@dhcp128.suse.cz>
References: <1408896096-16605-1-git-send-email-patrick@parcs.ath.cx>
	<20140826091941.GA2360@dhcp128.suse.cz>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 26 Aug 2014 11:19:41 +0200
Petr Mládek <pmladek@suse.cz> wrote:

> On Sun 24-08-14 12:01:36, Patrick Palka wrote:
> > We shouldn't set text_len in the code path that detects printk recursion
> > because text_len corresponds to the length of the string inside textbuf.
> > A few lines down from the line
> > 
> >     text_len = strlen(recursion_msg);
> > 
> > is the line
> > 
> >     text_len += vscnprintf(text + text_len, ...);
> > 
> > So if printk detects recursion, it sets text_len to 29 and logs an
> > error.  Then the message supplied by the caller of printk is stored
> > inside textbuf but offset by 29 bytes.  This means that the output of
> > the recursive call to printk will contain 29 bytes of garbage in front
> > of it.
> > 
> > This defect is caused by commit 458df9fd ("printk: remove separate
> > printk_sched buffers and use printk buf instead") which turned
> > 
> >     text_len = vscnprintf(text + text_len, ...);
> > 
> > into
> > 
> >     text_len += vscnprintf(text + text_len, ...);
> > 
> > To fix this, this patch avoids setting text_len when logging the printk
> > recursion error.  This patch also performs a couple of local
> > micro-optimizations (use unlikely() and ARRAY_SIZE()).
> 
> Great catch! And I agree with Jack about that strlen.

Although I will say that ARRAY_SIZE() is used elsewhere in the kernel
like this.

But as this isn't a critical section, either is fine.

Acked-by: Steven Rostedt <rostedt@goodmis.org>


-- Steve

>  
> > Signed-off-by: Patrick Palka <patrick@parcs.ath.cx>
> > ---
> >  kernel/printk/printk.c | 6 +++---
> >  1 file changed, 3 insertions(+), 3 deletions(-)
> > 
> > diff --git a/kernel/printk/printk.c b/kernel/printk/printk.c
> > index e04c455..c101ec2 100644
> > --- a/kernel/printk/printk.c
> > +++ b/kernel/printk/printk.c
> > @@ -1665,15 +1665,15 @@ asmlinkage int vprintk_emit(int facility, int level,
> >  	raw_spin_lock(&logbuf_lock);
> >  	logbuf_cpu = this_cpu;
> >  
> > -	if (recursion_bug) {
> > +	if (unlikely(recursion_bug)) {
> >  		static const char recursion_msg[] =
> >  			"BUG: recent printk recursion!";
> >  
> >  		recursion_bug = 0;
> > -		text_len = strlen(recursion_msg);
> >  		/* emit KERN_CRIT message */
> >  		printed_len += log_store(0, 2, LOG_PREFIX|LOG_NEWLINE, 0,
> > -					 NULL, 0, recursion_msg, text_len);
> > +					 NULL, 0, recursion_msg,
> > +					 ARRAY_SIZE(recursion_msg) - 1);
> >  	}
> >  
> >  	/*
> > -- 
> > 2.1.0
> > 

