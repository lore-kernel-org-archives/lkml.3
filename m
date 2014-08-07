Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755370AbaHGUGf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 16:06:35 -0400
Received: from casper.infradead.org ([85.118.1.10]:48596 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755194AbaHGUGc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 16:06:32 -0400
Date: Thu, 7 Aug 2014 22:06:25 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Oleg Nesterov <oleg@redhat.com>, linux-kernel@vger.kernel.org,
        mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, tglx@linutronix.de, dhowells@redhat.com,
        edumazet@google.com, dvhart@linux.intel.com, fweisbec@gmail.com,
        bobby.prani@gmail.com
Subject: Re: [PATCH v3 tip/core/rcu 3/9] rcu: Add synchronous grace-period
 waiting for RCU-tasks
Message-ID: <20140807200625.GA3935@laptop>
References: <20140806084708.GR9918@twins.programming.kicks-ass.net>
 <20140806120958.GZ8101@linux.vnet.ibm.com>
 <20140806163035.GG19379@twins.programming.kicks-ass.net>
 <20140806224518.GA8101@linux.vnet.ibm.com>
 <20140807084544.GJ19379@twins.programming.kicks-ass.net>
 <20140807150031.GB5821@linux.vnet.ibm.com>
 <20140807152600.GW9918@twins.programming.kicks-ass.net>
 <20140807172753.GG3588@twins.programming.kicks-ass.net>
 <20140807184635.GI3588@twins.programming.kicks-ass.net>
 <20140807154907.6f59cf6e@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140807154907.6f59cf6e@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 07, 2014 at 03:49:07PM -0400, Steven Rostedt wrote:
> On Thu, 7 Aug 2014 20:46:35 +0200
> Peter Zijlstra <peterz@infradead.org> wrote:
> 
> > On Thu, Aug 07, 2014 at 07:27:53PM +0200, Peter Zijlstra wrote:
> > > Right, Steve (and Paul) please explain _why_ this is an 'RCU' at all?
> > > _Why_ do we have call_rcu_task(), and why is it entwined in the 'normal'
> > > RCU stuff? We've got SRCU -- which btw started out simple, without
> > > call_srcu() -- and that lives entirely independent. And SRCU is far more
> > > an actual RCU than this thing is, its got read side primitives and
> > > everything.
> > > 
> > > Also, I cannot think of any other use besides trampolines for this
> > > thing, but that might be my limited imagination.
> > 
> > Also, trampolines can end up in the return frames, right? So how can you
> > be sure when to wipe them? Passing through schedule() isn't enough for
> > that.
> 
> Not sure what you mean.

void bar()
{
	mutex_lock();
	...
	mutex_unlock();
}

void foo()
{
	bar();
}

Normally that'll give you a stack/return frame like:

 foo()
   bar()
     mutex_lock()
       schedule();

Now suppose there's a trampoline around bar(), that would give:

  foo()
    __trampoline()
      bar()
        mutex_lock()
	  schedule()

so the function return of bar doesn't point to foo, but to the
trampoline. But we call schedule() from mutex_lock() and think we're all
good.

> > Userspace is, but kernel threads typically don't ever end up there.

> Hence, once something calls schedule() directly, we know that it is not
> on a trampoline, nor is it going to return to one.

How can you say its not going to return to one?

