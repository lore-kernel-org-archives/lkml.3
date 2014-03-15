Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756518AbaCOAAZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 20:00:25 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:44904 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754765AbaCOAAY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 20:00:24 -0400
Date: Fri, 14 Mar 2014 17:00:09 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>, Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH] [RFC] perf: Fix a race between ring_buffer_detach() and
 ring_buffer_wakeup()
Message-ID: <20140315000009.GA28008@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1394199526-6400-1-git-send-email-alexander.shishkin@linux.intel.com>
 <20140313195816.GJ21124@linux.vnet.ibm.com>
 <20140314095033.GP27965@twins.programming.kicks-ass.net>
 <20140314204736.GG21124@linux.vnet.ibm.com>
 <20140314224317.GQ30956@twins.programming.kicks-ass.net>
 <20140314230231.GM21124@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140314230231.GM21124@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14031500-1542-0000-0000-0000006169A2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 14, 2014 at 04:02:31PM -0700, Paul E. McKenney wrote:
> On Fri, Mar 14, 2014 at 11:43:17PM +0100, Peter Zijlstra wrote:
> > On Fri, Mar 14, 2014 at 01:47:37PM -0700, Paul E. McKenney wrote:
> > > This general idea can be made to work, but it will need some
> > > internal-to-RCU help.  One vulnerability of the patch below is the
> > > following sequence of steps:
> > > 
> > > 1.	RCU has just finished a grace period, and is doing the
> > > 	end-of-grace-period accounting.
> > > 
> > > 2.	The code below invokes rcu_batches_completed().  Let's assume
> > > 	the result returned is 42.
> > > 
> > > 3.	RCU completes the end-of-grace-period accounting, and increments
> > > 	rcu_sched_state.completed.
> > > 
> > > 4.	The code below checks ->rcu_batches against the result from
> > > 	another invocation of rcu_batches_completed() and sees that
> > > 	the 43 is not equal to 42, so skips the synchronize_rcu().
> > > 
> > > Except that a grace period has not actually completed.  Boom!!!
> > > 
> > > The problem is that rcu_batches_completed() is only intended to give
> > > progress information on RCU.
> > 
> > Ah, I thought I was missing something when I was looking through the rcu
> > code in a hurry :-)
> 
> Well, given that I sometimes miss things when looking through RCU code
> carefuly, I guess I cannot give you too much trouble about it.
> 
> > I knew there'd be some subtlety between completed and gpnum and such :-)
> 
> Some of which I have learned about one RCU bug at a time.  ;-)
> 
> > > What I can do is give you a pair of functions, one to take a snapshot of
> > > the current grace-period state (returning an unsigned long) and another
> > > to evaluate a previous snapshot, invoking synchronize_rcu() if there has
> > > not been a full grace period in the meantime.
> > > 
> > > The most straightforward approach would invoke acquiring the global
> > > rcu_state ->lock on each call, which I am guessing just might be
> > > considered to be excessive overhead.  ;-)  I should be able to decrease
> > > the overhead to a memory barrier on each call, and perhaps even down
> > > to an smp_load_acquire().  Accessing the RCU state probably costs you
> > > a cache miss both times.
> > > 
> > > Thoughts?
> > 
> > Sounds fine, the attach isn't a hotpath, so even the locked version
> > should be fine, but I won't keep you from making it all fancy and such
> > :-)
> 
> Fair enough, let me see what I can come up with.

And here is an untested patch.  Thoughts?

(And yes, I need to update documentation and torture tests accordingly.)

							Thanx, Paul

------------------------------------------------------------------------

rcu: Provide grace-period piggybacking API
    
The following pattern is currently not well supported by RCU:
    
1.	Make data element inaccessible to RCU readers.
    
2.	Do work that probably lasts for more than one grace period.
    
3.	Do something to make sure RCU readers in flight before #1 above
    	have completed.
    
Here are some things that could currently be done:
    
a.	Do a synchronize_rcu() unconditionally at either #1 or #3 above.
    	This works, but imposes needless work and latency.
    
b.	Post an RCU callback at #1 above that does a wakeup, then
    	wait for the wakeup at #3.  This works well, but likely results
    	in an extra unneeded grace period.  Open-coding this is also
    	a bit more semi-tricky code than would be good.

This commit therefore adds get_state_synchronize_rcu() and
cond_synchronize_rcu() APIs.  Call get_state_synchronize_rcu() at #1
above and pass its return value to cond_synchronize_rcu() at #3 above.
This results in a call to synchronize_rcu() if no grace period has
elapsed between #1 and #3, but requires only a load, comparison, and
memory barrier if a full grace period did elapse.

Reported-by: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

diff --git a/kernel/rcu/tree.c b/kernel/rcu/tree.c
index c9be2235712c..dbf0f225bca0 100644
--- a/kernel/rcu/tree.c
+++ b/kernel/rcu/tree.c
@@ -1503,13 +1503,14 @@ static int rcu_gp_init(struct rcu_state *rsp)
 
 	/* Advance to a new grace period and initialize state. */
 	record_gp_stall_check_time(rsp);
-	smp_wmb(); /* Record GP times before starting GP. */
-	rsp->gpnum++;
+	/* Record GP times before starting GP, hence smp_store_release(). */
+	smp_store_release(&rsp->gpnum, rsp->gpnum + 1);
 	trace_rcu_grace_period(rsp->name, rsp->gpnum, TPS("start"));
 	raw_spin_unlock_irq(&rnp->lock);
 
 	/* Exclude any concurrent CPU-hotplug operations. */
 	mutex_lock(&rsp->onoff_mutex);
+	smp_mb__after_unlock_lock(); /* ->gpnum increment before GP! */
 
 	/*
 	 * Set the quiescent-state-needed bits in all the rcu_node
@@ -1638,10 +1639,11 @@ static void rcu_gp_cleanup(struct rcu_state *rsp)
 	}
 	rnp = rcu_get_root(rsp);
 	raw_spin_lock_irq(&rnp->lock);
-	smp_mb__after_unlock_lock();
+	smp_mb__after_unlock_lock(); /* Order GP before ->completed update. */
 	rcu_nocb_gp_set(rnp, nocb);
 
-	rsp->completed = rsp->gpnum; /* Declare grace period done. */
+	/* Declare grace period done. */
+	ACCESS_ONCE(rsp->completed) = rsp->gpnum;
 	trace_rcu_grace_period(rsp->name, rsp->completed, TPS("end"));
 	rsp->fqs_state = RCU_GP_IDLE;
 	rdp = this_cpu_ptr(rsp->rda);
@@ -2728,6 +2730,37 @@ void synchronize_rcu_bh(void)
 }
 EXPORT_SYMBOL_GPL(synchronize_rcu_bh);
 
+/**
+ * get_state_synchronize_rcu - Snapshot current RCU state
+ *
+ * Returns a cookie that is used by a later call to cond_synchronize_rcu()
+ * to determine whether or not a full grace period has elapsed in the
+ * meantime.
+ */
+unsigned long get_state_synchronize_rcu(void)
+{
+	return smp_load_acquire(&rcu_state->gpnum);
+}
+EXPORT_SYMBOL_GPL(get_state_synchronize_rcu);
+
+/**
+ * cond_synchronize_rcu - Conditionally wait for an RCU grace period
+ *
+ * @oldstate: return value from earlier call to get_state_synchronize_rcu()
+ *
+ * If a full RCU grace period has elapsed since the earlier call to
+ * get_state_synchronize_rcu(), just return.  Otherwise, invoke
+ * synchronize_rcu() to wait for a full grace period.
+ */
+void cond_synchronize_rcu(unsigned long oldstate)
+{
+	unsigned long newstate = smp_load_acquire(&rcu_state->completed);
+
+	if (ULONG_CMP_GE(oldstate, newstate))
+		synchronize_rcu();
+}
+EXPORT_SYMBOL_GPL(cond_synchronize_rcu);
+
 static int synchronize_sched_expedited_cpu_stop(void *data)
 {
 	/*

