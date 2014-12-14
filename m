Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751257AbaLNSSp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Dec 2014 13:18:45 -0500
Received: from e38.co.us.ibm.com ([32.97.110.159]:47439 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750948AbaLNSSn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Dec 2014 13:18:43 -0500
Date: Sun, 14 Dec 2014 10:18:35 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: [PATCH 1/3] tracepoints: Do not use call_rcu_sched() before
 early_initcall()
Message-ID: <20141214181835.GG5310@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20141214164104.307127356@goodmis.org>
 <20141214164803.991954802@goodmis.org>
 <20141214115332.76be1b8b@gandalf.local.home>
 <20141214180854.GC5310@linux.vnet.ibm.com>
 <20141214131538.7a6c1438@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141214131538.7a6c1438@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14121418-0029-0000-0000-00000660219B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 14, 2014 at 01:15:38PM -0500, Steven Rostedt wrote:
> On Sun, 14 Dec 2014 10:08:54 -0800
> "Paul E. McKenney" <paulmck@linux.vnet.ibm.com> wrote:
> 
> > On Sun, Dec 14, 2014 at 11:53:32AM -0500, Steven Rostedt wrote:
> > > On Sun, 14 Dec 2014 11:41:05 -0500
> > > Steven Rostedt <rostedt@goodmis.org> wrote:
> > > 
> > > > From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>
> > > > 
> > > > In order to move enabling of trace events to just after mm_init(), the
> > > > tracepoint enable code can not use call_rcu_sched() because rcu isn't
> > > > even initialized yet.  Since this can only happen before SMP is set up
> > > > (and even before interrupts are set up), there's no reason to use
> > > > call_rcu_sched() at this point.
> > > > 
> > > > Instead, create a variable called tracepoint_rcu_safe that gets enabled
> > > > via early_initcall() and if that is not set, free the code directly
> > > > instead of using call_rcu_sched().
> > > > 
> > > > This allows us to enable tracepoints early without issues.
> > > > 
> > > > Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
> > > > Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> > > > Cc: Thomas Gleixner <tglx@linutronix.de>
> > > > Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> > 
> > With the addition of read_mostly, and given that I am not going to mess
> > with call_rcu() this late in the 3.19 process without a blazingly good
> > reason:
> > 
> > Reviewed-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> 
> Thanks!
> 
> > Please note that you can use call_rcu() and friends as soon as rcu_init()
> > returns.  The callbacks won't be invoked until early_initcall() time,
> > but they will be properly queued.
> > 
> > Please note also that there are places where turning a call_rcu() into
> > a direct function call don't work, even at times when preemption is
> > disabled and there is only one CPU.  One example is where single-threaded
> > code uses call_rcu() on a list element of a list that it is traversing
> > within an RCU read-side critical section.  A direct call to the RCU
> > callback could potentially destroy the pointers that the traversal was
> > going to use to find the next element.  This means that we cannot make
> > call_rcu() do direct calls to the callback, as that would break quite
> > a bit of existing code.
> > 
> > Is there some definite point during boot before which you won't need to
> > invoke call_rcu_sched() for tracing?  I am guessing "no", but have to ask.
> > I can probably make call_rcu_sched() work arbitrarily early, but it is a
> > bit uglier.  And this assumes that irqs_disabled_flags(local_irq_save())
> > returns true during early boot.  I would -hope- this would be true!  ;-)
> 
> With your feed back, and because I would like this to go into 3.19, I
> would like to keep the current patch as is (with the read_mostly
> update, which I'm currently testing). We can always change it later
> after call_rcu() has been changed.

Completely agreed!  ;-)

							Thanx, Paul

