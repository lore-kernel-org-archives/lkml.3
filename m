Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755585Ab3HXTZl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Aug 2013 15:25:41 -0400
Received: from mail.openrapids.net ([64.15.138.104]:50790 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755432Ab3HXTZk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Aug 2013 15:25:40 -0400
Date: Sat, 24 Aug 2013 15:25:36 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
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
Message-ID: <20130824192536.GE13216@Krystal>
References: <20130818022453.GA3475@linux.vnet.ibm.com> <1376967074-32530-1-git-send-email-paulmck@linux.vnet.ibm.com> <52133EBF.3020605@cn.fujitsu.com> <20130820183843.GK29406@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130820183843.GK29406@linux.vnet.ibm.com>
X-Editor: vi
X-Info: http://www.efficios.com
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Paul E. McKenney (paulmck@linux.vnet.ibm.com) wrote:
[...]
> The result is as follows.  Better?

Hi Paul,

Pitching in late in the thread, so that I can get a share of the fun ;-)

> 							Thanx, Paul
> 
> #ifdef CONFIG_DEBUG_OBJECTS_RCU_HEAD
> static void rcu_torture_leak_cb(struct rcu_head *rhp)
> {
> }
> 
> static void rcu_torture_err_cb(struct rcu_head *rhp)
> {
> 	/*
> 	 * This -might- happen due to race conditions, but is unlikely.
> 	 * The scenario that leads to this happening is that the
> 	 * first of the pair of duplicate callbacks is queued,
> 	 * someone else starts a grace period that includes that
> 	 * callback, then the second of the pair must wait for the
> 	 * next grace period.  Unlikely, but can happen.  If it
> 	 * does happen, the debug-objects subsystem won't have splatted.
> 	 */
> 	pr_alert("rcutorture: duplicated callback was invoked.\n");
> }
> #endif /* #ifdef CONFIG_DEBUG_OBJECTS_RCU_HEAD */
> 

Hrm. Putting an #ifdef within a function when not utterly needed is
usually a bad idea. How about:

/*
 * Verify that double-free causes debug-objects to complain, but only
 * if CONFIG_DEBUG_OBJECTS_RCU_HEAD=y.  Otherwise, say that the test
 * cannot be carried out.
 */
#ifdef CONFIG_DEBUG_OBJECTS_RCU_HEAD
static void rcu_test_debug_objects(void)
{
 	struct rcu_head rh1;
 	struct rcu_head rh2;
 
 	init_rcu_head_on_stack(&rh1);
 	init_rcu_head_on_stack(&rh2);
 	pr_alert("rcutorture: WARN: Duplicate call_rcu() test starting.\n");
 	preempt_disable(); /* Prevent preemption from interrupting test. */
 	rcu_read_lock(); /* Make it impossible to finish a grace period. */
 	call_rcu(&rh1, rcu_torture_leak_cb); /* Start grace period. */
 	local_irq_disable(); /* Make it harder to start a new grace period. */
 	call_rcu(&rh2, rcu_torture_leak_cb);
 	call_rcu(&rh2, rcu_torture_err_cb); /* Duplicate callback. */
 	local_irq_enable();
 	rcu_read_unlock();
 	preempt_enable();
 	rcu_barrier();
 	pr_alert("rcutorture: WARN: Duplicate call_rcu() test complete.\n");
 	destroy_rcu_head_on_stack(&rh1);
 	destroy_rcu_head_on_stack(&rh2);
}
#else /* #ifdef CONFIG_DEBUG_OBJECTS_RCU_HEAD */
static void rcu_test_debug_objects(void)
{
 	pr_alert("rcutorture: !CONFIG_DEBUG_OBJECTS_RCU_HEAD, not testing duplicate call_rcu()\n");
}
#endif /* #else #ifdef CONFIG_DEBUG_OBJECTS_RCU_HEAD */


More comments inlined in the code below,

> /*
>  * Verify that double-free causes debug-objects to complain, but only
>  * if CONFIG_DEBUG_OBJECTS_RCU_HEAD=y.  Otherwise, say that the test
>  * cannot be carried out.
>  */
> static void rcu_test_debug_objects(void)
> {
> #ifdef CONFIG_DEBUG_OBJECTS_RCU_HEAD
> 	struct rcu_head rh1;
> 	struct rcu_head rh2;
> 
> 	init_rcu_head_on_stack(&rh1);
> 	init_rcu_head_on_stack(&rh2);
> 	pr_alert("rcutorture: WARN: Duplicate call_rcu() test starting.\n");
> 	preempt_disable(); /* Prevent preemption from interrupting test. */
> 	rcu_read_lock(); /* Make it impossible to finish a grace period. */
> 	call_rcu(&rh1, rcu_torture_leak_cb); /* Start grace period. */

Are we really "starting" a grace period ? If rcu_test_debug_objects() is
executed after some callbacks are already queued, are we, by definition,
"starting" the grace period ?

Also, I find it weird to have, in that order:

1) preempt_disable()
2) rcu_read_lock()
3) local_irq_disable()

I would rather expect:

1) rcu_read_lock()
2) preempt_disable()
3) local_irq_disable()

So they come in increasing order of impact on the system: with
non-preemptable RCU, the read-lock and preempt disable mean the same
thing, however, with preemptable RCU, the impact of preempt disable
seems larger than the impact of RCU read lock: preemption is still
enabled when within a RCU critical section. Both will work, but I find
this call order slightly weird.

Also, if your goal is to increase the chances that call_rcu() enqueues
both callbacks into the same grace period, you might want to issue a
rcu_barrier() early in this function, so that call_rcu() has even more
chances to enqueue the callbacks into the same grace period.

However, if you care about testing enqueue into same _and_ different
grace periods, you might want to turn this single-shot test into a
stress-test by calling it repeatedly.

Thanks!

Mathieu

> 	local_irq_disable(); /* Make it harder to start a new grace period. */
> 	call_rcu(&rh2, rcu_torture_leak_cb);
> 	call_rcu(&rh2, rcu_torture_err_cb); /* Duplicate callback. */
> 	local_irq_enable();
> 	rcu_read_unlock();
> 	preempt_enable();
> 	rcu_barrier();
> 	pr_alert("rcutorture: WARN: Duplicate call_rcu() test complete.\n");
> 	destroy_rcu_head_on_stack(&rh1);
> 	destroy_rcu_head_on_stack(&rh2);
> #else /* #ifdef CONFIG_DEBUG_OBJECTS_RCU_HEAD */
> 	pr_alert("rcutorture: !CONFIG_DEBUG_OBJECTS_RCU_HEAD, not testing duplicate call_rcu()\n");
> #endif /* #else #ifdef CONFIG_DEBUG_OBJECTS_RCU_HEAD */
> }
> 
> > > +
> > >  static int __init
> > >  rcu_torture_init(void)
> > >  {
> > > @@ -2163,6 +2206,8 @@ rcu_torture_init(void)
> > >  		firsterr = retval;
> > >  		goto unwind;
> > >  	}
> > > +	if (object_debug)
> > > +		rcu_test_debug_objects();
> > >  	rcutorture_record_test_transition();
> > >  	mutex_unlock(&fullstop_mutex);
> > >  	return 0;
> > 
> 

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
