Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750915AbaLNSUZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Dec 2014 13:20:25 -0500
Received: from smtprelay0220.hostedemail.com ([216.40.44.220]:43517 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750708AbaLNSUY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Dec 2014 13:20:24 -0500
X-Session-Marker: 6E657665747340676F6F646D69732E6F7267
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,rostedt@goodmis.org,:::::::::::::,RULES_HIT:41:355:379:541:599:800:960:968:973:988:989:1260:1277:1311:1313:1314:1345:1359:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2553:2559:2562:3138:3139:3140:3141:3142:3352:3622:3865:3867:3868:3870:3871:3872:3873:3874:4321:4419:5007:6261:7875:7903:8957:10004:10400:10848:10967:11026:11232:11658:11914:12517:12519:12555:12663:12740:13069:13161:13229:13311:13357:14096:14097:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: bikes83_205f9038a7424
X-Filterd-Recvd-Size: 2307
Date: Sun, 14 Dec 2014 13:20:20 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: [PATCH 2/3] tracing: Move enabling tracepoints to just after
 mm_init()
Message-ID: <20141214132020.4ddf323b@gandalf.local.home>
In-Reply-To: <20141214181444.GE5310@linux.vnet.ibm.com>
References: <20141214164104.307127356@goodmis.org>
	<20141214164804.150181588@goodmis.org>
	<20141214181444.GE5310@linux.vnet.ibm.com>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 14 Dec 2014 10:14:44 -0800
"Paul E. McKenney" <paulmck@linux.vnet.ibm.com> wrote:


> > diff --git a/init/main.c b/init/main.c
> > index 800a0daede7e..060e60b6aa59 100644
> > --- a/init/main.c
> > +++ b/init/main.c
> > @@ -561,6 +561,9 @@ asmlinkage __visible void __init start_kernel(void)
> >  	trap_init();
> >  	mm_init();
> > 
> > +	/* trace_printk() and trace points may be used after this */
> > +	trace_init();
> 
> Or if you aren't going to use call_rcu_sched() before this point, I could
> move the call_rcu_sched()-relevant initialization to this point.  Or make
> the compiler do it -- I am pretty sure that the per-CPU variables are in
> place at this point.
> 

Well, we could move trace_init() after rcu_init() for now too, and
remove my tracepoint patch. But I'd like to have trace_init() go before
sched_init() since that could possibly use debugging tracepoints as
well.

So if you could add a rcu_partial_init() that makes calling
call_rcu_sched() work, that would be great. That could be for 3.20
then, and for now, I just move trace_init() after rcu_init() which is
still before irq_init() that Thomas needs for his work.

-- Steve
