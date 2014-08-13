Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752946AbaHMOSS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 10:18:18 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:55226 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752031AbaHMOSR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 10:18:17 -0400
Date: Wed, 13 Aug 2014 07:18:10 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Amit Shah <amit.shah@redhat.com>
Cc: linux-kernel@vger.kernel.org, riel@redhat.com, mingo@kernel.org,
        laijs@cn.fujitsu.com, dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        dhowells@redhat.com, edumazet@google.com, dvhart@linux.intel.com,
        fweisbec@gmail.com, oleg@redhat.com, sbw@mit.edu
Subject: Re: [PATCH tip/core/rcu 1/2] rcu: Parallelize and economize NOCB
 kthread wakeups
Message-ID: <20140813141810.GA17741@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20140811201102.GD5821@linux.vnet.ibm.com>
 <20140811201845.GG4184@grmbl.mre>
 <20140811203421.GE5821@linux.vnet.ibm.com>
 <20140812034531.GA13801@linux.vnet.ibm.com>
 <20140812053321.GK4184@grmbl.mre>
 <20140812160621.GC4752@linux.vnet.ibm.com>
 <20140812213936.GA3106@linux.vnet.ibm.com>
 <20140812214151.GB3106@linux.vnet.ibm.com>
 <20140813054439.GA29913@grmbl.mre>
 <20140813130049.GS4752@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140813130049.GS4752@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14081314-3532-0000-0000-000003D048A7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 13, 2014 at 06:00:49AM -0700, Paul E. McKenney wrote:
> On Wed, Aug 13, 2014 at 11:14:39AM +0530, Amit Shah wrote:
> > On (Tue) 12 Aug 2014 [14:41:51], Paul E. McKenney wrote:
> > > On Tue, Aug 12, 2014 at 02:39:36PM -0700, Paul E. McKenney wrote:
> > > > On Tue, Aug 12, 2014 at 09:06:21AM -0700, Paul E. McKenney wrote:
> > > > > On Tue, Aug 12, 2014 at 11:03:21AM +0530, Amit Shah wrote:
> > > > 
> > > > [ . . . ]
> > > > 
> > > > > > I know of only virtio-console doing this (via userspace only,
> > > > > > though).
> > > > > 
> > > > > As in userspace within the guest?  That would not work.  The userspace
> > > > > that the qemu is running in might.  There is a way to extract ftrace info
> > > > > from crash dumps, so one approach would be "sendkey alt-sysrq-c", then
> > > > > pull the buffer from the resulting dump.  For all I know, there might also
> > > > > be some script that uses the qemu "x" command to get at the ftrace buffer.
> > > > > 
> > > > > Again, I cannot reproduce this, and I have been through the code several
> > > > > times over the past few days, and am not seeing it.  I could start
> > > > > sending you random diagnostic patches, but it would be much better if
> > > > > we could get the trace data from the failure.
> > 
> > I think the only recourse I now have is to dump the guest state from
> > qemu, and attempt to find the ftrace buffers by poking pages and
> > finding some ftrace-like struct... and then dumping the buffers.
> 
> The data exists in the qemu guest state, so it would be good to have
> it one way or another.  My current (perhaps self-serving) guess is that
> you have come up with a way to trick qemu into dropping IPIs.

Oh, and I wrote up my last inspection of the nocb code.  Please see below.

							Thanx, Paul

------------------------------------------------------------------------

Given that specifying rcu_nocb_poll avoids the hang, the natural focus
is on checks for rcu_nocb_poll:

o	__call_rcu_nocb_enqueue() skips the wakeup if rcu_nocb_poll,
	which is legitimate because the rcuo kthreads do their own
	wakeups in this case.

o	nocb_leader_wait() does wait_event_interruptible() on
	my_rdp->nocb_leader_wake if !rcu_nocb_poll.  So one further
	question is the handling of ->nocb_leader_wake.

	The thing to check for is if ->nocb_leader_wake can get set to
	true without a wakeup while the leader sleeps, as this would
	clearly lead to a hang.  Checking each use:

	o	wake_nocb_leader() tests ->nocb_leader_wake, and
		if false, sets it and does a wakeup.  The set is
		ordered after the test due to control dependencies.
		Multiple followers might concurrently attempt to
		wake their leader, and this can result in multiple
		wakeups, which should be OK -- we only need one
		wakeup, so more won't hurt.

		Here, every time ->nocb_leader_wake is set, we
		follow up with a wakeup, so this particular use
		avoids the sleep-while-set problem.

		It is also important to note that

	o	nocb_leader_wait() waits for ->nocb_leader_wake, as
		noted above.

	o	nocb_leader_wait() checks for spurious wakeups, but
		before sleeping again, it clears ->nocb_leader_wake,
		does a memory barrier, and rescans the callback
		queues, and sets ->nocb_leader_wake if any have
		callbacks.  Either way, it goes to wait again.  If it
		set ->nocb_leader_wake, then the wait won't wait,
		as required.

		The check for spurious wakeups also moves callbacks
		to an intermediate list for the grace-period-wait
		operation.  This ensures that we don't prematurely
		invoke any callbacks that arrive while the grace period
		is in progress.

	o	If the wakeup was real, nocb_leader_wait() clears
		->nocb_leader_wake, does a memory barrier, and moves
		callbacks from the intermediate lists to the followers'
		lists (including itself, as a leader is its own first
		follower).  During this move, the leader checks for
		new callbacks having arrived during the grace period,
		and sets ->nocb_leader_wake if there are any, again
		short-circuiting the following wake.

	o	Note that nocb_leader_wait() never sets ->nocb_leader_wake
		unless it has found callbacks waiting for it, and that
		setting ->nocb_leader_wake short-circuits the next wait,
		so that a wakeup is not required.

		Note also that every time nocb_leader_wait() clears
		->nocb_leader_wake, it does a memory barrier and
		scans all the lists before sleeping again.  This means
		that if a wakeup arrives just before nocb_leader_wait()
		clears ->nocb_leader_wake, then nocb_leader_wait() will
		be guaranteed to see the newly arrived callback, and
		thus not need a wakeup.

o	Because nocb_leader_wait() always checks the queue head, it is
	necessary that the callers of wake_nocb_leader() ensure that
	the head is updated before the call to wake_nocb_leader().
	This is a problem, and smp_mb__after_atomic() is added after
	the atomic_add_long() in __call_rcu_nocb_enqueue() to fix
	this.  Note that atomic_add_long() does not have a barrier()
	directive, so this misordering could in theory happen even on
	strongly-ordered systems, courtesy of the compiler.

o	The leader-follower wakeups also need attention, as it references
	rcu_nocb_poll.

	nocb_follower_wait() does a wait on rdp->nocb_follower_head, and
	ensures ordering with the later smp_load_acquire() from that same
	variable.

	The wakeup happens in nocb_leader_wait().  This has the same
	sequence as __call_rcu_nocb_enqueue(), but there is no _wake
	flag.  This means that the only way that confusion could result
	is if the assignment to *tail was moved to after the wake_up().
	Now, wake_up() unconditionally acquires a lock, but in theory
	only guarantees that stuff before the lock acquisition happens
	before the lock release.  So might as well also add
	smp_mb__after_atomic here, also.  (This will not affect x86,
	which has strong ordering on lock acquisition.)

o	Check use of do_nocb_deferred_wakeup().  If any of these has
	been omitted, then a wakeup could be lost.

	This is invoked on next entry to an extended quiescent state and
	on exit from __rcu_process_callbacks().  It is checked on every
	scheduling-clock interrupt via rcu_nocb_need_deferred_wakeup(),
	and if needed, an RCU_SOFTIRQ is issued, which will result in
	a later invocation of __rcu_process_callbacks().

	So the only vulnerability is a call_rcu() with irqs disabled from
	idle.  This needs a check.  Note that there is a similar check
	in __call_rcu_core(), though not for irqs disabled.  Check added.

