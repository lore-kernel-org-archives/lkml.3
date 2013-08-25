Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756338Ab3HYTeZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Aug 2013 15:34:25 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:51943 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755320Ab3HYTeY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Aug 2013 15:34:24 -0400
Date: Sun, 25 Aug 2013 12:34:14 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>, linux-kernel@vger.kernel.org,
        mingo@elte.hu, dipankar@in.ibm.com, akpm@linux-foundation.org,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        sbw@mit.edu, Sedat Dilek <sedat.dilek@gmail.com>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>,
        Rik van Riel <riel@surriel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH tip/core/rcu 1/5] rcu: Add duplicate-callback tests to
 rcutorture
Message-ID: <20130825193414.GN3871@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20130818022453.GA3475@linux.vnet.ibm.com>
 <1376967074-32530-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <52133EBF.3020605@cn.fujitsu.com>
 <20130820183843.GK29406@linux.vnet.ibm.com>
 <20130824192536.GE13216@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130824192536.GE13216@Krystal>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13082519-7606-0000-0000-00000E998694
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 24, 2013 at 03:25:36PM -0400, Mathieu Desnoyers wrote:
> * Paul E. McKenney (paulmck@linux.vnet.ibm.com) wrote:
> [...]
> > The result is as follows.  Better?
> 
> Hi Paul,
> 
> Pitching in late in the thread, so that I can get a share of the fun ;-)
> 
> > 							Thanx, Paul
> > 
> > #ifdef CONFIG_DEBUG_OBJECTS_RCU_HEAD
> > static void rcu_torture_leak_cb(struct rcu_head *rhp)
> > {
> > }
> > 
> > static void rcu_torture_err_cb(struct rcu_head *rhp)
> > {
> > 	/*
> > 	 * This -might- happen due to race conditions, but is unlikely.
> > 	 * The scenario that leads to this happening is that the
> > 	 * first of the pair of duplicate callbacks is queued,
> > 	 * someone else starts a grace period that includes that
> > 	 * callback, then the second of the pair must wait for the
> > 	 * next grace period.  Unlikely, but can happen.  If it
> > 	 * does happen, the debug-objects subsystem won't have splatted.
> > 	 */
> > 	pr_alert("rcutorture: duplicated callback was invoked.\n");
> > }
> > #endif /* #ifdef CONFIG_DEBUG_OBJECTS_RCU_HEAD */
> > 
> 
> Hrm. Putting an #ifdef within a function when not utterly needed is
> usually a bad idea. How about:
> 
> /*
>  * Verify that double-free causes debug-objects to complain, but only
>  * if CONFIG_DEBUG_OBJECTS_RCU_HEAD=y.  Otherwise, say that the test
>  * cannot be carried out.
>  */
> #ifdef CONFIG_DEBUG_OBJECTS_RCU_HEAD
> static void rcu_test_debug_objects(void)
> {
>  	struct rcu_head rh1;
>  	struct rcu_head rh2;
> 
>  	init_rcu_head_on_stack(&rh1);
>  	init_rcu_head_on_stack(&rh2);
>  	pr_alert("rcutorture: WARN: Duplicate call_rcu() test starting.\n");
>  	preempt_disable(); /* Prevent preemption from interrupting test. */
>  	rcu_read_lock(); /* Make it impossible to finish a grace period. */
>  	call_rcu(&rh1, rcu_torture_leak_cb); /* Start grace period. */
>  	local_irq_disable(); /* Make it harder to start a new grace period. */
>  	call_rcu(&rh2, rcu_torture_leak_cb);
>  	call_rcu(&rh2, rcu_torture_err_cb); /* Duplicate callback. */
>  	local_irq_enable();
>  	rcu_read_unlock();
>  	preempt_enable();
>  	rcu_barrier();
>  	pr_alert("rcutorture: WARN: Duplicate call_rcu() test complete.\n");
>  	destroy_rcu_head_on_stack(&rh1);
>  	destroy_rcu_head_on_stack(&rh2);
> }
> #else /* #ifdef CONFIG_DEBUG_OBJECTS_RCU_HEAD */
> static void rcu_test_debug_objects(void)
> {
>  	pr_alert("rcutorture: !CONFIG_DEBUG_OBJECTS_RCU_HEAD, not testing duplicate call_rcu()\n");
> }
> #endif /* #else #ifdef CONFIG_DEBUG_OBJECTS_RCU_HEAD */

The objection to this is that it duplicates the function header, both
copies of which must be updated.  See Josh's and my discussion on this
point earlier in the thread.  Who knows, Josh might eventually convince
me to individually ifdef the functions in kernel/rcutree_plugin.h,
but I am not quite there yet.  ;-)

That said, I do see two benefits of individual ifdef:

1.	It is easy to see when a given function is included.
	As it is, there are runs of many hundreds of lines of
	code where it might not be obvious to the casual reader.

2.	Duplicated code is asking for silent rebase and merge errors.
	This can happen when a change to the function header collides
	with a change that duplicates the function under ifdef.

So perhaps I will eventually convert to the individual-ifdef style.
At the moment, I am in no hurry.

> More comments inlined in the code below,
> 
> > /*
> >  * Verify that double-free causes debug-objects to complain, but only
> >  * if CONFIG_DEBUG_OBJECTS_RCU_HEAD=y.  Otherwise, say that the test
> >  * cannot be carried out.
> >  */
> > static void rcu_test_debug_objects(void)
> > {
> > #ifdef CONFIG_DEBUG_OBJECTS_RCU_HEAD
> > 	struct rcu_head rh1;
> > 	struct rcu_head rh2;
> > 
> > 	init_rcu_head_on_stack(&rh1);
> > 	init_rcu_head_on_stack(&rh2);
> > 	pr_alert("rcutorture: WARN: Duplicate call_rcu() test starting.\n");
> > 	preempt_disable(); /* Prevent preemption from interrupting test. */
> > 	rcu_read_lock(); /* Make it impossible to finish a grace period. */
> > 	call_rcu(&rh1, rcu_torture_leak_cb); /* Start grace period. */
> 
> Are we really "starting" a grace period ? If rcu_test_debug_objects() is
> executed after some callbacks are already queued, are we, by definition,
> "starting" the grace period ?
> 
> Also, I find it weird to have, in that order:
> 
> 1) preempt_disable()
> 2) rcu_read_lock()
> 3) local_irq_disable()
> 
> I would rather expect:
> 
> 1) rcu_read_lock()
> 2) preempt_disable()
> 3) local_irq_disable()
> 
> So they come in increasing order of impact on the system: with
> non-preemptable RCU, the read-lock and preempt disable mean the same
> thing, however, with preemptable RCU, the impact of preempt disable
> seems larger than the impact of RCU read lock: preemption is still
> enabled when within a RCU critical section. Both will work, but I find
> this call order slightly weird.

If this was code that ran normally, I would agree with you.  Your
suggested ordering would reduce the scheduling-latency impact due to
this code, among other things.

However, this code is a one-off that runs only once during an rcutorture
run that explicitly calls for it using rcutorture's new object_debug
module parameter.

> Also, if your goal is to increase the chances that call_rcu() enqueues
> both callbacks into the same grace period, you might want to issue a
> rcu_barrier() early in this function, so that call_rcu() has even more
> chances to enqueue the callbacks into the same grace period.

The problem is that neither rcu_barrier() nor synchronize_rcu() clean
up at a well-defined point in time.  In both cases, the task will be
awakened at some time after the operation completes, by which time
any number of new grace periods might have started and completed.

> However, if you care about testing enqueue into same _and_ different
> grace periods, you might want to turn this single-shot test into a
> stress-test by calling it repeatedly.

Good point, and I might do that.  However, the above code has not yet
failed to produce a debug-objects splat.  When and if it does fail to
splat, then running the code repeatedly would definitely be one of the
fixes that I would consider.  (Another potential fix being to simply load
the rcutorture module a few times in succession, though your suggestion
would in fact work better for my current testing setup.)

Thank you for your review and comments!

							Thanx, Paul

> Thanks!
> 
> Mathieu
> 
> > 	local_irq_disable(); /* Make it harder to start a new grace period. */
> > 	call_rcu(&rh2, rcu_torture_leak_cb);
> > 	call_rcu(&rh2, rcu_torture_err_cb); /* Duplicate callback. */
> > 	local_irq_enable();
> > 	rcu_read_unlock();
> > 	preempt_enable();
> > 	rcu_barrier();
> > 	pr_alert("rcutorture: WARN: Duplicate call_rcu() test complete.\n");
> > 	destroy_rcu_head_on_stack(&rh1);
> > 	destroy_rcu_head_on_stack(&rh2);
> > #else /* #ifdef CONFIG_DEBUG_OBJECTS_RCU_HEAD */
> > 	pr_alert("rcutorture: !CONFIG_DEBUG_OBJECTS_RCU_HEAD, not testing duplicate call_rcu()\n");
> > #endif /* #else #ifdef CONFIG_DEBUG_OBJECTS_RCU_HEAD */
> > }
> > 
> > > > +
> > > >  static int __init
> > > >  rcu_torture_init(void)
> > > >  {
> > > > @@ -2163,6 +2206,8 @@ rcu_torture_init(void)
> > > >  		firsterr = retval;
> > > >  		goto unwind;
> > > >  	}
> > > > +	if (object_debug)
> > > > +		rcu_test_debug_objects();
> > > >  	rcutorture_record_test_transition();
> > > >  	mutex_unlock(&fullstop_mutex);
> > > >  	return 0;
> > > 
> > 
> 
> -- 
> Mathieu Desnoyers
> EfficiOS Inc.
> http://www.efficios.com
> 

