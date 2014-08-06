Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755501AbaHFBVs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 21:21:48 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:48450 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751085AbaHFBVr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 21:21:47 -0400
Date: Tue, 5 Aug 2014 18:21:39 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Oleg Nesterov <oleg@redhat.com>, linux-kernel@vger.kernel.org,
        mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, tglx@linutronix.de, peterz@infradead.org,
        dhowells@redhat.com, edumazet@google.com, dvhart@linux.intel.com,
        fweisbec@gmail.com, bobby.prani@gmail.com
Subject: Re: [PATCH v3 tip/core/rcu 3/9] rcu: Add synchronous grace-period
 waiting for RCU-tasks
Message-ID: <20140806012139.GY8101@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20140731215445.GA21933@linux.vnet.ibm.com>
 <1406843709-23396-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1406843709-23396-3-git-send-email-paulmck@linux.vnet.ibm.com>
 <20140801150926.GA845@redhat.com>
 <20140801183251.GJ4784@linux.vnet.ibm.com>
 <20140801194417.GA27141@linux.vnet.ibm.com>
 <20140802144719.GA18018@redhat.com>
 <20140802225857.GC8101@linux.vnet.ibm.com>
 <20140805205711.7a52076c@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140805205711.7a52076c@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14080601-8236-0000-0000-000004623304
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 05, 2014 at 08:57:11PM -0400, Steven Rostedt wrote:
> On Sat, 2 Aug 2014 15:58:57 -0700
> "Paul E. McKenney" <paulmck@linux.vnet.ibm.com> wrote:
> 
> > On Sat, Aug 02, 2014 at 04:47:19PM +0200, Oleg Nesterov wrote:
> > > On 08/01, Paul E. McKenney wrote:
> > > >
> > > > On Fri, Aug 01, 2014 at 11:32:51AM -0700, Paul E. McKenney wrote:
> > > > > On Fri, Aug 01, 2014 at 05:09:26PM +0200, Oleg Nesterov wrote:
> > > > > > On 07/31, Paul E. McKenney wrote:
> > > > > > >
> > > > > > > +void synchronize_rcu_tasks(void)
> > > > > > > +{
> > > > > > > +	/* Complain if the scheduler has not started.  */
> > > > > > > +	rcu_lockdep_assert(!rcu_scheduler_active,
> > > > > > > +			   "synchronize_rcu_tasks called too soon");
> > > > > > > +
> > > > > > > +	/* Wait for the grace period. */
> > > > > > > +	wait_rcu_gp(call_rcu_tasks);
> > > > > > > +}
> > > > > >
> > > > > > Btw, what about CONFIG_PREEMPT=n ?
> > > > > >
> > > > > > I mean, can't synchronize_rcu_tasks() be synchronize_sched() in this
> > > > > > case?
> > > > >
> > > > > Excellent point, indeed it can!
> > > > >
> > > > > And if I do it right, it will make CONFIG_TASKS_RCU=y safe for kernel
> > > > > tinification.  ;-)
> > > >
> > > > Unless, that is, we need to wait for trampolines in the idle loop...
> > > >
> > > > Sounds like a question for Steven.  ;-)
> > > 
> > > Sure, but the full blown synchronize_rcu_tasks() can't handle the idle threads
> > > anyway. An idle thread can not be deactivated and for_each_process() can't see
> > > it anyway.
> > 
> > Indeed, if idle threads need to be tracked, their tracking will need to
> > be at least partially special-cased.
> 
> Yeah, idle threads can be affected by the trampolines. That is, we can
> still hook a trampoline to some function in the idle loop.
> 
> But we should be able to make the hardware call that puts the CPU to
> sleep a quiescent state too. May need to be arch dependent. :-/

OK, my plan for this eventuality is to do the following:

1.	Ignore the ->on_rq field, as idle tasks are always on a runqueue.

2.	Watch the context-switch counter.

3.	Ignore dyntick-idle state for idle tasks.

4.	If there is no quiescent state from a given idle task after
	a few seconds, schedule rcu_tasks_kthread() on top of the
	offending CPU.

Your idea is an interesting one, but does require another set of
dyntick-idle-like functions and counters.  Or moving the current
rcu_idle_enter() and rcu_idle_exit() calls deeper into the idle loop.

Not sure which is a better approach.  Alternatively, we could just
rely on #4 above, on the grounds that battery life should not be
too badly degraded by the occasional RCU-tasks interference.

Note that this is a different situation than NO_HZ_FULL in realtime
environments, where the worst case causes trouble even if it happens
very infrequently.

						Thanx, Paul

