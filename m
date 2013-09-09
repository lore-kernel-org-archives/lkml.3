Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755949Ab3IIQ6s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 12:58:48 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:59282 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755904Ab3IIQ6n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 12:58:43 -0400
Date: Mon, 9 Sep 2013 09:58:36 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Eric Dumazet <eric.dumazet@gmail.com>, linux-kernel@vger.kernel.org,
        mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        dhowells@redhat.com, edumazet@google.com, darren@dvhart.com,
        sbw@mit.edu
Subject: Re: [PATCH] rcu: Is it safe to enter an RCU read-side critical
 section?
Message-ID: <20130909165836.GB3966@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20130909083926.3eceebef@gandalf.local.home>
 <20130909124547.GB16280@somewhere>
 <20130909085504.2ddd7e69@gandalf.local.home>
 <20130909130851.GC16280@somewhere>
 <20130909092142.05780991@gandalf.local.home>
 <20130909134505.GF16280@somewhere>
 <20130909135656.GT3966@linux.vnet.ibm.com>
 <20130909101629.32df27a2@gandalf.local.home>
 <20130909161708.GX3966@linux.vnet.ibm.com>
 <20130909123422.7936e868@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130909123422.7936e868@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13090916-9332-0000-0000-0000015B350C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 09, 2013 at 12:34:22PM -0400, Steven Rostedt wrote:
> On Mon, 9 Sep 2013 09:17:08 -0700
> "Paul E. McKenney" <paulmck@linux.vnet.ibm.com> wrote:
> 
> > On Mon, Sep 09, 2013 at 10:16:29AM -0400, Steven Rostedt wrote:
> > > On Mon, 9 Sep 2013 06:56:56 -0700
> > > "Paul E. McKenney" <paulmck@linux.vnet.ibm.com> wrote:
> > > 
> > > 
> > > > Indeed, there is on ongoing naming debate as well.  About the only point
> > > > of agreement thus far is that the current names are inadequate. ;-)
> > > > 
> > > > My current feeling is that rcu_is_cpu_idle() should be called
> > > > rcu_watching_this_cpu() and what is called rcu_watching_this_cpu()
> > > > in my local tree should be called __rcu_watching_this_cpu().
> > > 
> > > I disagree. Then it would not make sense if we take a return value of
> > > "__rcu_watching_this_cpu()" and use it on another CPU to make other
> > > decisions for that other CPU.
> > 
> > Frederic and I both went through why this works.
> 
> My concern is people stumbling over why preemption can be enabled here?
> 
> If it must *always* be called with preemption disabled (no
> rcu_watching_this_cpu() version that disables preemption for you) then
> I would be OK with it.
> 
> The problem I'm having is, anything that uses "this_cpu()" can cause
> problems with understanding the code, because the first thing I think
> is "if we get the result for 'this_cpu', it may not be 'this_cpu' when
> I use it".

Yep, this is an exception to the usual rule about not passing per-CPU
variables out of preempt_disable() regions, and will need to be commented
appropriately.

> > > I still think we are confusing concepts with implementation. Yes, the
> > > RCU implementation tracks CPU state, but the concept is still based on
> > > the task.
> > 
> > You keep asserting this, but I am not seeing it.  Sure, you can argue
> > that grace periods are based on tasks as well as or instead of CPUs.
> > But I am not convinced that it helps at the dynticks interface.
> > 
> > > But you are right, with dynamic ticks, things get a little more
> > > complex, as dynamic ticks is a CPU state, not a task state, as it can
> > > be something other than the running task that changes the state
> > > (another task gets scheduled on that CPU).
> > > 
> > > But I think we are coupling RCU a bit too much with dynamic ticks here.
> > > Maybe we need to take a step back to visualize concepts again.
> > 
> > If we don't couple it pretty tightly, it won't work.  And whatever we
> > want to call this thing that determines what RCU is paying attention to
> > has to be at the implementation level.  For things like rcu_read_lock()
> > and synchronize_rcu(), yes, the task view is important -- and in recent
> > documentation is the POV I use.
> > 
> > > The state of being in dynamic tick mode is determined by what a task or
> > > tasks are doing on the CPU. One of those things is if the task needs to
> > > be tracked by RCU. And here, is where I think we are getting our
> > > confusion from. The dynamic tick state needs to check if the running
> > > task is requiring RCU or not, and thus we ask for "is rcu needed on
> > > this CPU?" when the real question is "is the task running on this CPU
> > > requiring RCU?"
> > > 
> > > Again, if we keep things in a conceptual mode, and not look too much at
> > > the implementation details, I think more people will understand what's
> > > going on. Especially those that don't know why something was
> > > implemented the way it was.
> > 
> > All this aside, do you have a name you are nominating?
> 
> Something that doesn't specify "this_cpu" or "cpu" if the result can be
> used on another cpu correctly.
> 
> "rcu_is_ignored()" or "rcu_is_not_active()", "rcu_is_watching_you()"

You know, I am strongly tempted by "rcu_is_watching_you()", but I have
this feeling that it is too cute for its own good.  ;-)

							Thanx, Paul

