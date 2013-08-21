Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752173Ab3HUDDe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 23:03:34 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:52193 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752045Ab3HUDDd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 23:03:33 -0400
Date: Tue, 20 Aug 2013 20:03:24 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        sbw@mit.edu, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Sedat Dilek <sedat.dilek@gmail.com>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>,
        Rik van Riel <riel@surriel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH tip/core/rcu 1/5] rcu: Add duplicate-callback tests to
 rcutorture
Message-ID: <20130821030324.GQ29406@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20130818022453.GA3475@linux.vnet.ibm.com>
 <1376967074-32530-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <52133EBF.3020605@cn.fujitsu.com>
 <20130820183843.GK29406@linux.vnet.ibm.com>
 <5214288F.7040308@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5214288F.7040308@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13082103-5406-0000-0000-00000BA32F4F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 21, 2013 at 10:40:15AM +0800, Lai Jiangshan wrote:
> On 08/21/2013 02:38 AM, Paul E. McKenney wrote:
> > On Tue, Aug 20, 2013 at 06:02:39PM +0800, Lai Jiangshan wrote:
> >> On 08/20/2013 10:51 AM, Paul E. McKenney wrote:
> >>> From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
> >>>
> >>> This commit adds a object_debug option to rcutorture to allow the
> >>> debug-object-based checks for duplicate call_rcu() invocations to
> >>> be deterministically tested.
> >>>
> >>> Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> >>> Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
> >>> Cc: Sedat Dilek <sedat.dilek@gmail.com>
> >>> Cc: Davidlohr Bueso <davidlohr.bueso@hp.com>
> >>> Cc: Rik van Riel <riel@surriel.com>
> >>> Cc: Thomas Gleixner <tglx@linutronix.de>
> >>> Cc: Linus Torvalds <torvalds@linux-foundation.org>
> >>> Tested-by: Sedat Dilek <sedat.dilek@gmail.com>
> >>> [ paulmck: Banish mid-function ifdef, more or less per Josh Triplett. ]
> >>> ---
> >>>  kernel/rcutorture.c | 45 +++++++++++++++++++++++++++++++++++++++++++++
> >>>  1 file changed, 45 insertions(+)
> >>>
> >>> diff --git a/kernel/rcutorture.c b/kernel/rcutorture.c
> >>> index 3d936f0f..f5cf2bb 100644
> >>> --- a/kernel/rcutorture.c
> >>> +++ b/kernel/rcutorture.c
> >>> @@ -66,6 +66,7 @@ static int fqs_duration;	/* Duration of bursts (us), 0 to disable. */
> >>>  static int fqs_holdoff;		/* Hold time within burst (us). */
> >>>  static int fqs_stutter = 3;	/* Wait time between bursts (s). */
> >>>  static int n_barrier_cbs;	/* Number of callbacks to test RCU barriers. */
> >>> +static int object_debug;	/* Test object-debug double call_rcu()?. */
> >>>  static int onoff_interval;	/* Wait time between CPU hotplugs, 0=disable. */
> >>>  static int onoff_holdoff;	/* Seconds after boot before CPU hotplugs. */
> >>>  static int shutdown_secs;	/* Shutdown time (s).  <=0 for no shutdown. */
> >>> @@ -100,6 +101,8 @@ module_param(fqs_stutter, int, 0444);
> >>>  MODULE_PARM_DESC(fqs_stutter, "Wait time between fqs bursts (s)");
> >>>  module_param(n_barrier_cbs, int, 0444);
> >>>  MODULE_PARM_DESC(n_barrier_cbs, "# of callbacks/kthreads for barrier testing");
> >>> +module_param(object_debug, int, 0444);
> >>> +MODULE_PARM_DESC(object_debug, "Enable debug-object double call_rcu() testing");
> >>>  module_param(onoff_interval, int, 0444);
> >>>  MODULE_PARM_DESC(onoff_interval, "Time between CPU hotplugs (s), 0=disable");
> >>>  module_param(onoff_holdoff, int, 0444);
> >>> @@ -1934,6 +1937,46 @@ rcu_torture_cleanup(void)
> >>>  		rcu_torture_print_module_parms(cur_ops, "End of test: SUCCESS");
> >>>  }
> >>>  
> >>> +#ifdef CONFIG_DEBUG_OBJECTS_RCU_HEAD
> >>> +static void rcu_torture_leak_cb(struct rcu_head *rhp)
> >>> +{
> >>> +}
> >>> +
> >>> +static void rcu_torture_err_cb(struct rcu_head *rhp)
> >>> +{
> >>> +	/* This -might- happen due to race conditions, but is unlikely. */
> >>> +	pr_alert("rcutorture: duplicated callback was invoked.\n");
> >>> +}
> >>> +#endif /* #ifdef CONFIG_DEBUG_OBJECTS_RCU_HEAD */
> >>> +
> >>> +/*
> >>> + * Verify that double-free causes debug-objects to complain, but only
> >>> + * if CONFIG_DEBUG_OBJECTS_RCU_HEAD=y.  Otherwise, say that the test
> >>> + * cannot be carried out.
> >>> + */
> >>> +static void rcu_test_debug_objects(void)
> >>> +{
> >>> +#ifdef CONFIG_DEBUG_OBJECTS_RCU_HEAD
> >>> +	struct rcu_head rh1;
> >>> +	struct rcu_head rh2;
> >>> +
> >>> +	init_rcu_head_on_stack(&rh1);
> >>> +	init_rcu_head_on_stack(&rh2);
> >>> +	pr_alert("rcutorture: WARN: Duplicate call_rcu() test starting.\n");
> >>> +	local_irq_disable(); /* Make it hard to finish grace period. */
> >>
> >> you can use rcu_read_lock() directly.
> > 
> > I could do that as well, but it doesn't do everything that local_irq_disable()
> > does.
> > 
> > Right, which means that my comment is bad.  Fixing both, thank you!
> > 
> >>> +	call_rcu(&rh1, rcu_torture_leak_cb); /* start grace period. */
> > 
> > And the one above cannot start a grace period due to irqs being enabled.
> > Which is -almost- always OK, but...
> > 
> >>> +	call_rcu(&rh2, rcu_torture_err_cb);
> > 
> > And this one should invoke rcu_torture_leak_cb instead of
> > rcu_torture_err_cb().  Just results in a confusing error message, but...
> 
> I still don't understand why rcu_torture_err_cb() will be called when:
> 
> rcu_read_lock();
> call_rcu(&rh2, rcu_torture_leak_cb);
> call_rcu(&rh2, rcu_torture_err_cb); // rh2 will be still queued here,
> 				    // debug-objects will find it and
> 				    // change it to rcu_leak_callback()
> rcu_read_unlock();

Fair point, no chance of the second rh2 callback being queued after the
first one is invoked!  I will leave the message.  Whoever sees it with
the current code will have something to tell their grandchildren.

							Thanx, Paul

> > OK, a few more fixes, then!
> > 
> >>> +	call_rcu(&rh2, rcu_torture_err_cb); /* duplicate callback. */
> >>> +	local_irq_enable();
> >>> +	rcu_barrier();
> >>> +	pr_alert("rcutorture: WARN: Duplicate call_rcu() test complete.\n");
> >>> +	destroy_rcu_head_on_stack(&rh1);
> >>> +	destroy_rcu_head_on_stack(&rh2);
> >>> +#else /* #ifdef CONFIG_DEBUG_OBJECTS_RCU_HEAD */
> >>> +	pr_alert("rcutorture: !CONFIG_DEBUG_OBJECTS_RCU_HEAD, not testing duplicate call_rcu()\n");
> >>> +#endif /* #else #ifdef CONFIG_DEBUG_OBJECTS_RCU_HEAD */
> >>> +}
> > 
> > The result is as follows.  Better?
> > 
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
> >>> +
> >>>  static int __init
> >>>  rcu_torture_init(void)
> >>>  {
> >>> @@ -2163,6 +2206,8 @@ rcu_torture_init(void)
> >>>  		firsterr = retval;
> >>>  		goto unwind;
> >>>  	}
> >>> +	if (object_debug)
> >>> +		rcu_test_debug_objects();
> >>>  	rcutorture_record_test_transition();
> >>>  	mutex_unlock(&fullstop_mutex);
> >>>  	return 0;
> >>
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/
> > 
> 

