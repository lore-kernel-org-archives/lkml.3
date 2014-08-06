Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755143AbaHFMKK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 08:10:10 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:56954 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752588AbaHFMKI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 08:10:08 -0400
Date: Wed, 6 Aug 2014 05:09:59 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, Oleg Nesterov <oleg@redhat.com>,
        linux-kernel@vger.kernel.org, mingo@kernel.org, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, josh@joshtriplett.org,
        tglx@linutronix.de, dhowells@redhat.com, edumazet@google.com,
        dvhart@linux.intel.com, fweisbec@gmail.com, bobby.prani@gmail.com
Subject: Re: [PATCH v3 tip/core/rcu 3/9] rcu: Add synchronous grace-period
 waiting for RCU-tasks
Message-ID: <20140806120958.GZ8101@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1406843709-23396-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1406843709-23396-3-git-send-email-paulmck@linux.vnet.ibm.com>
 <20140801150926.GA845@redhat.com>
 <20140801183251.GJ4784@linux.vnet.ibm.com>
 <20140801194417.GA27141@linux.vnet.ibm.com>
 <20140802144719.GA18018@redhat.com>
 <20140802225857.GC8101@linux.vnet.ibm.com>
 <20140805205711.7a52076c@gandalf.local.home>
 <20140806012139.GY8101@linux.vnet.ibm.com>
 <20140806084708.GR9918@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140806084708.GR9918@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14080612-0928-0000-0000-000003EAC10D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 06, 2014 at 10:47:08AM +0200, Peter Zijlstra wrote:
> On Tue, Aug 05, 2014 at 06:21:39PM -0700, Paul E. McKenney wrote:
> > > Yeah, idle threads can be affected by the trampolines. That is, we can
> > > still hook a trampoline to some function in the idle loop.
> > > 
> > > But we should be able to make the hardware call that puts the CPU to
> > > sleep a quiescent state too. May need to be arch dependent. :-/
> > 
> > OK, my plan for this eventuality is to do the following:
> > 
> > 1.	Ignore the ->on_rq field, as idle tasks are always on a runqueue.
> > 
> > 2.	Watch the context-switch counter.
> > 
> > 3.	Ignore dyntick-idle state for idle tasks.
> > 
> > 4.	If there is no quiescent state from a given idle task after
> > 	a few seconds, schedule rcu_tasks_kthread() on top of the
> > 	offending CPU.
> > 
> > Your idea is an interesting one, but does require another set of
> > dyntick-idle-like functions and counters.  Or moving the current
> > rcu_idle_enter() and rcu_idle_exit() calls deeper into the idle loop.
> > 
> > Not sure which is a better approach.  Alternatively, we could just
> > rely on #4 above, on the grounds that battery life should not be
> > too badly degraded by the occasional RCU-tasks interference.
> > 
> > Note that this is a different situation than NO_HZ_FULL in realtime
> > environments, where the worst case causes trouble even if it happens
> > very infrequently.
> 
> Or you could shoot all CPUs with resched_cpu() which would have them
> cycle through schedule() even if there's nothing but the idle thread to
> run. That guarantees they'll go to sleep again in a !trampoline.

Good point, that would be an easier way to handle the idle threads than
messing with rcu_tasks_kthread()'s affinity.  Thank you!

> But I still very much hate the polling stuff...
> 
> Can't we abuse the preempt notifiers? Say we make it possible to install
> preemption notifiers cross-task, then the task-rcu can install a
> preempt-out notifier which completes the rcu-task wait.
> 
> After all, since we tagged it it was !running, and being scheduled out
> means it ran (once) and therefore isn't on a trampoline anymore.

Maybe I am being overly paranoid, but couldn't the task be preempted
in a trampoline, be resumed, execute one instruction (still in the
tramopoline) and be preempted again?

> And the tick, which checks to see if the task got to userspace can do
> the same, remove the notifier and then complete.

My main concern with this sort of approach is that I have to deal
with full-up concurrency (200 CPUs all complete tasks concurrently,
for example), which would make for a much larger and more complex patch.
Now, I do admit that it is quite possible that I will end up there anyway,
for example, if more people start using RCU-tasks, but I see no need to
hurry this process.  ;-)

							Thanx, Paul

