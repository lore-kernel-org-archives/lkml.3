Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752213AbaHKDgG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Aug 2014 23:36:06 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:36604 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751862AbaHKDgD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Aug 2014 23:36:03 -0400
Date: Sun, 10 Aug 2014 20:23:12 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, josh@joshtriplett.org,
        tglx@linutronix.de, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, dvhart@linux.intel.com, fweisbec@gmail.com,
        oleg@redhat.com, bobby.prani@gmail.com
Subject: Re: [PATCH v3 tip/core/rcu 1/9] rcu: Add call_rcu_tasks()
Message-ID: <20140811032312.GR5821@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20140731215445.GA21933@linux.vnet.ibm.com>
 <1406843709-23396-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <20140808191326.GE3935@laptop>
 <20140808205826.GG5821@linux.vnet.ibm.com>
 <20140809061514.GK9918@twins.programming.kicks-ass.net>
 <20140809160137.GJ5821@linux.vnet.ibm.com>
 <20140809181920.GO9918@twins.programming.kicks-ass.net>
 <20140810012612.GN5821@linux.vnet.ibm.com>
 <20140810081254.GS9918@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140810081254.GS9918@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14081103-0928-0000-0000-000004051D2A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 10, 2014 at 10:12:54AM +0200, Peter Zijlstra wrote:
> On Sat, Aug 09, 2014 at 06:26:12PM -0700, Paul E. McKenney wrote:
> > On Sat, Aug 09, 2014 at 08:19:20PM +0200, Peter Zijlstra wrote:
> > > On Sat, Aug 09, 2014 at 09:01:37AM -0700, Paul E. McKenney wrote:
> > > > > That's so wrong its not funny. If you need some abortion to deal with
> > > > > NOHZ_FULL then put it under CONFIG_NOHZ_FULL, don't burden the entire
> > > > > world with it.
> > > > 
> > > > Peter, the polling approach actually -reduces- the common-case
> > > > per-context-switch burden, as in when RCU-tasks isn't doing anything.
> > > > See your own code above.
> > > 
> > > I'm not seeing it, CONFIG_PREEMPT already touches a per task cacheline
> > > for each context switch. And for !PREEMPT this thing should pretty much
> > > reduce to rcu_sched.
> > 
> > Except when you do the wakeup operation, in which case you have something
> > that is either complex, slow and non-scalable, or both.  I am surprised
> > that you want anything like that on that path.
> 
> Its a nr_cpus problem at that point, which is massively better than a
> nr_tasks problem, and I'm sure we've solved this counter thing many
> times, we can do it again.
> 
> But for clarity of purpose the single atomic+waitqueue is far easier.

Either way, it is very likely an NR_CPUS problem after the first scan
of the task list.  Sure, you could have a million preempted tasks on an
eight-CPU system, but if that is the case, an occasional poll loop is
the very least of your worries.

And if we were trying to produce a textbook example, I might agree with
your "clarity of purpose" point.  As it is, sorry, but no.

> > > Would not the thing I proposed be a valid rcu_preempt implementation?
> > > one where its rcu read side primitives run from (voluntary) schedule()
> > > to (voluntary) schedule() call and therefore entirely cover smaller
> > > sections.
> > 
> > In theory, sure.  In practice, blocking on tasks that are preempted
> > outside of an RCU read-side critical section would not be a good thing
> > for normal RCU, which has frequent update operations.  Among other things.
> 
> Sure, just looking for parallels and verifying understanding here. By
> the very nature of not having read side primitives to limit coverage its
> a pessimistic thing.

Fair enough!

> > > > > As for idle tasks, I'm not sure about those, I think that we should say
> > > > > NO to anything that would require waking idle CPUs, push the pain to
> > > > > ftrace/kprobes, we should _not_ be waking idle cpus.
> > > > 
> > > > So the current patch set wakes an idle task once per RCU-tasks grace
> > > > period, but only when that idle task did not otherwise get awakened.
> > > > This is not a real problem.
> > > 
> > > And on the other hand we're trying to reduce random wakeups, so this
> > > sure is a problem. If we don't start, we don't have to fix later.
> > 
> > I doubt that a wakeup at the end of certain ftrace operations is going
> > to be a real problem.
> 
> But its not ftrace, its rcu_task, and if we put it out there, we'll grow
> more and more customers, and soon we'll always have users and never let
> CPUs sleep.
> 
> That's how these things go, so we should really try and push back on
> these things, and that's the thing that worries me most in this
> discussion, you seem very happy to provide what's asked for without due
> consideration of the negatives.

Good point.

So I could make all the entry points static, and call into ftrace and
friends passing them the addresses of the entry points.  I would also
need to pass them to rcutorture.  Then no one uses this stuff without
express permission.

> > > > So I don't believe that the current wakeup rate is a problem, and it
> > > > can be reduced if it proves to be a problem.
> > > 
> > > How about we simply assume 'idle' code, as defined by the rcu idle hooks
> > > are safe? Why do we want to bend over backwards to cover this?
> > 
> > Steven covered this earlier in this thread.  One addition might be "For
> > the same reason that event tracing provides the _rcuidle suffix."
> 
> I really don't think its worth the cost.

That part has been coming in loud and clear for quite some time now.  ;-)

							Thanx, Paul

