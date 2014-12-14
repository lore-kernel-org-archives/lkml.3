Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751069AbaLNSPm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Dec 2014 13:15:42 -0500
Received: from smtprelay0038.hostedemail.com ([216.40.44.38]:40596 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750785AbaLNSPl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Dec 2014 13:15:41 -0500
X-Session-Marker: 6E657665747340676F6F646D69732E6F7267
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,rostedt@goodmis.org,:::::::::::::,RULES_HIT:41:355:379:541:599:800:960:966:973:988:989:1260:1277:1311:1313:1314:1345:1359:1437:1515:1516:1518:1534:1542:1593:1594:1711:1730:1747:1777:1792:2194:2196:2198:2199:2200:2201:2393:2553:2559:2562:2693:2731:2895:3138:3139:3140:3141:3142:3355:3622:3865:3866:3867:3868:3870:3871:3872:3873:3874:4250:4362:4385:4398:5007:6119:6261:7576:7875:8660:8957:9010:9040:10004:10400:10450:10455:10462:10464:10848:10967:11026:11232:11658:11914:12043:12296:12517:12519:12663:12740:13148:13230:13255:14096:14097:19904:19999:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: sleet87_88c2772ab804c
X-Filterd-Recvd-Size: 4048
Date: Sun, 14 Dec 2014 13:15:38 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: [PATCH 1/3] tracepoints: Do not use call_rcu_sched() before
 early_initcall()
Message-ID: <20141214131538.7a6c1438@gandalf.local.home>
In-Reply-To: <20141214180854.GC5310@linux.vnet.ibm.com>
References: <20141214164104.307127356@goodmis.org>
	<20141214164803.991954802@goodmis.org>
	<20141214115332.76be1b8b@gandalf.local.home>
	<20141214180854.GC5310@linux.vnet.ibm.com>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 14 Dec 2014 10:08:54 -0800
"Paul E. McKenney" <paulmck@linux.vnet.ibm.com> wrote:

> On Sun, Dec 14, 2014 at 11:53:32AM -0500, Steven Rostedt wrote:
> > On Sun, 14 Dec 2014 11:41:05 -0500
> > Steven Rostedt <rostedt@goodmis.org> wrote:
> > 
> > > From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>
> > > 
> > > In order to move enabling of trace events to just after mm_init(), the
> > > tracepoint enable code can not use call_rcu_sched() because rcu isn't
> > > even initialized yet.  Since this can only happen before SMP is set up
> > > (and even before interrupts are set up), there's no reason to use
> > > call_rcu_sched() at this point.
> > > 
> > > Instead, create a variable called tracepoint_rcu_safe that gets enabled
> > > via early_initcall() and if that is not set, free the code directly
> > > instead of using call_rcu_sched().
> > > 
> > > This allows us to enable tracepoints early without issues.
> > > 
> > > Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
> > > Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> > > Cc: Thomas Gleixner <tglx@linutronix.de>
> > > Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> 
> With the addition of read_mostly, and given that I am not going to mess
> with call_rcu() this late in the 3.19 process without a blazingly good
> reason:
> 
> Reviewed-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

Thanks!

> 
> Please note that you can use call_rcu() and friends as soon as rcu_init()
> returns.  The callbacks won't be invoked until early_initcall() time,
> but they will be properly queued.
> 
> Please note also that there are places where turning a call_rcu() into
> a direct function call don't work, even at times when preemption is
> disabled and there is only one CPU.  One example is where single-threaded
> code uses call_rcu() on a list element of a list that it is traversing
> within an RCU read-side critical section.  A direct call to the RCU
> callback could potentially destroy the pointers that the traversal was
> going to use to find the next element.  This means that we cannot make
> call_rcu() do direct calls to the callback, as that would break quite
> a bit of existing code.
> 
> Is there some definite point during boot before which you won't need to
> invoke call_rcu_sched() for tracing?  I am guessing "no", but have to ask.
> I can probably make call_rcu_sched() work arbitrarily early, but it is a
> bit uglier.  And this assumes that irqs_disabled_flags(local_irq_save())
> returns true during early boot.  I would -hope- this would be true!  ;-)
> 

With your feed back, and because I would like this to go into 3.19, I
would like to keep the current patch as is (with the read_mostly
update, which I'm currently testing). We can always change it later
after call_rcu() has been changed.

-- Steve
