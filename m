Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753581AbaCRCp2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 22:45:28 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:35558 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753277AbaCRCp1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 22:45:27 -0400
Date: Mon, 17 Mar 2014 19:45:22 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>, Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH] [RFC] perf: Fix a race between ring_buffer_detach() and
 ring_buffer_wakeup()
Message-ID: <20140318024522.GF4420@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1394199526-6400-1-git-send-email-alexander.shishkin@linux.intel.com>
 <20140313195816.GJ21124@linux.vnet.ibm.com>
 <20140314095033.GP27965@twins.programming.kicks-ass.net>
 <20140314204736.GG21124@linux.vnet.ibm.com>
 <20140314224317.GQ30956@twins.programming.kicks-ass.net>
 <20140314230231.GM21124@linux.vnet.ibm.com>
 <20140315000009.GA28008@linux.vnet.ibm.com>
 <20140317111807.GE27965@twins.programming.kicks-ass.net>
 <20140317164815.GF21124@linux.vnet.ibm.com>
 <20140317173038.GK25546@laptop.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140317173038.GK25546@laptop.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14031802-9332-0000-0000-00000024EFE4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 17, 2014 at 06:30:38PM +0100, Peter Zijlstra wrote:
> On Mon, Mar 17, 2014 at 09:48:15AM -0700, Paul E. McKenney wrote:
> > Good point, this barrier is a bit obsure.  Here you go:
> > 
> > 	/*
> > 	 * Make sure this load happens before the purportedly
> > 	 * time-consuming work between get_state_synchronize_rcu()
> > 	 * and cond_synchronize_rcu().
> > 	 */
> > 
> > So all you lose by leaving this barrier out is a slightly higher
> > probability of invoking synchronize_rcu() at cond_synchronize_rcu() time.
> > And without the barrier there is some chance of the CPU doing the load in
> > cond_synchronize_rcu() before this load in get_state_synchronize_rcu().
> > Which should be OK, but simpler to exclude this than have to worry about
> > counters out of sync.  Besides, you are taking a grace-period delay in
> > here somewhere, so the memory barrier is way down in the noise.
> 
> Oh sure; expense wasn't my concern. But I always question barriers
> without comments, and I couldn't come up with a reason for this one.
> 
> > > The way I imaged using this is taking this snapshot after the RCU
> > > operation, such that we err towards seeing a later grace period and
> > > synchronizing too much in stead of seeing an earlier and sync'ing too
> > > little.
> > > 
> > > Such use would suggest the barrier the other way around.
> > 
> > Ah, but that ordering happens at the updater's end.  And there
> > are in fact memory barriers before and after the increment of
> > ->gpnum in rcu_gp_init():
> > 
> > 	/* Advance to a new grace period and initialize state. */
> > 	record_gp_stall_check_time(rsp);
> > 	/* Record GP times before starting GP, hence smp_store_release(). */
> > 	smp_store_release(&rsp->gpnum, rsp->gpnum + 1);
> > 	trace_rcu_grace_period(rsp->name, rsp->gpnum, TPS("start"));
> > 	raw_spin_unlock_irq(&rnp->lock);
> > 
> > 	/* Exclude any concurrent CPU-hotplug operations. */
> > 	mutex_lock(&rsp->onoff_mutex);
> > 	smp_mb__after_unlock_lock(); /* ->gpnum increment before GP! */
> > 
> > The smp_store_release() provides the memory barrier before, and the
> > smp_mb__after_unlock_lock() provides it after.
> 
> That wasn't exactly what I was talking about.
> 
> So suppose:
> 
>   spin_lock(&lock)
>   list_del_rcu(&entry->foo);
>   spin_unlock(&lock);
> 
>   rcu_stamp = get_state_sync_rcu();
> 
> Now we very much want to ensure to get the gpnum _after_ completing that
> list_del_rcu(), because if we were to observe the gpnum before it could
> complete before and we'd fail to wait long enough.
> 
> Now in the above, and with your proposed implementation, there is in
> fact no guarantee the load doesn't slip up past the list_del_rcu().
> 
> The RELEASE per the spin_unlock() only guarantees the list_del_rcu()
> happens before it, but the gpnum load can slip in, and in fact pass over
> the list_del_rcu().

Right you are!  Fixed patch below.

> > > > +void cond_synchronize_rcu(unsigned long oldstate)
> > > > +{
> > > > +	unsigned long newstate = smp_load_acquire(&rcu_state->completed);
> > > 
> > > Again, uncommented barriers; the load_acquire seems to suggest you want
> > > to make sure the sync_rcu() bits happen after this read. But seeing how
> > > sync_rcu() will invariably read the same data again and you get an
> > > address dep this seems somewhat superfluous.
> > 
> > Not quite!  The get_state_synchronize_rcu() function reads ->gpnum,
> > but cond_synchronize_rcu() reads ->completed.  The
> 
> I was talking about the synchronize_rcu() call later in
> cond_synchronize_rcu().
> 
> But looking at its implementation; they don't in fact load either gpnum
> or completed.

They don't directly, but they register callbacks, which causes the
RCU core code to access them.  But if we invoke synchronize_rcu(),
it really doesn't matter what either get_state_synchronize_rcu() or
cond_synchronize_rcu().  The memory barrier from cond_synchronize_rcu()'s
smp_load_acquire() is instead needed for the case where we -don't-
invoke synchornize_rcu().  In that case, whatever was supposed to follow
the grace period had better really follow the grace period.

> > > > +	if (ULONG_CMP_GE(oldstate, newstate))
> > > 
> > > So if the observed active gp (oldstate) is ahead or equal to the last
> > > completed gp, then we wait?
> > 
> > Yep!  I will risk an ASCII diagram:
> > 
> > 
> > 3:	                                                  +----gpnum----+-- ...
> > 	                                                  |             |
> > 2:	                            +----gpnum----+-------+--completed--+
> > 	                            |             |
> > 1:	      +----gpnum----+-------+--completed--+
> > 	      |             |
> > 0:	+-----+--completed--+
> > 
> > 
> > A full RCU grace period happens between a pair of "|"s on the same line.
> > By inspection, if your snapshot of ->gpnum is greater than the current
> > value of ->completed, a grace period has passed.
> 
> OK, so I get the > part, but I'm not sure I get the = part of the above.
> The way I read the diagram, when completed matches gpnum the grace
> period is done and we don't have to wait anymore.

Absolutely not!  Let's try laying out the scenario:

1.	Someone calls get_state_synchronize_rcu() when ->gpnum==->completed==0.
	It returns zero.

2.	That someone immediately calls cond_synchronize_rcu().  Nothing
	has changed, so oldstate==newstate==0.

	We had better call synchronize_rcu() in this case!!!

Another way of looking at it...  At any point in time, either gpnum and
completed have the same value, or gpnum is one greater than completed.

A.	They are equal, say to zero.  In this case, we need one grace
	period.  For this to happen, ->gpnum first increases by one
	(but our snapshot remains zero), then after the grace period
	completes, ->completed catches up.  So as long as ->completed
	is less than or equal to our snapshot, we need to call
	synchronize_rcu().

B.	They differ, say ->gpnum is equal to one and ->completed is
	equal to zero.  This means that there is a grace period in
	progress.  We must first wait for this grace period to
	complete, then wait for the next grace period to complete.

	After the first grace period completes, we will have
	both ->gpnum and ->completed equal to one, that is to
	say, equal to our snapshot.  We still haven't waited for
	a full grace period, so if cond_synchronize_rcu() gets called
	at this point, it needs to invoke synchronize_rcu().

	After the second grace period starts, we will have ->gpnum
	equal to two and ->completed still equal to one.  We still
	have not waited a full grace period, so any call to
	cond_synchronize_rcu() must invoke synchronize_rcu().
	Which it will, because ->completed is still equal to the
	snapshot returned by get_state_synchronize_rcu().

	After the second grace period completes, we will have waited
	for a full grace period, and therefore need not wait any
	longer.  But at this point, ->completed will be equal to
	two, and will thus be greater than our snapshot.  Now,
	cond_synchronize_rcu() need not invoke synchronize_rcu(),
	and because ->completed is now greater than our snapshot,
	it won't.

Make sense?

Updated patch below.  Added the memory barrier to get_state_synchronize_rcu()
as you suggested, and also added more comments.

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

Requested-by: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

diff --git a/include/linux/rcutiny.h b/include/linux/rcutiny.h
index 7b62ecdd75e8..d40a6a451330 100644
--- a/include/linux/rcutiny.h
+++ b/include/linux/rcutiny.h
@@ -27,6 +27,16 @@
 
 #include <linux/cache.h>
 
+static inline unsigned long get_state_synchronize_rcu(void)
+{
+	return 0;
+}
+
+static inline void cond_synchronize_rcu(unsigned long oldstate)
+{
+	might_sleep();
+}
+
 static inline void rcu_barrier_bh(void)
 {
 	wait_rcu_gp(call_rcu_bh);
diff --git a/include/linux/rcutree.h b/include/linux/rcutree.h
index 44211ff34b9a..3e2f5d432743 100644
--- a/include/linux/rcutree.h
+++ b/include/linux/rcutree.h
@@ -76,6 +76,8 @@ static inline void synchronize_rcu_bh_expedited(void)
 void rcu_barrier(void);
 void rcu_barrier_bh(void);
 void rcu_barrier_sched(void);
+unsigned long get_state_synchronize_rcu(void);
+void cond_synchronize_rcu(unsigned long oldstate);
 
 extern unsigned long rcutorture_testseq;
 extern unsigned long rcutorture_vernum;
diff --git a/kernel/rcu/tree.c b/kernel/rcu/tree.c
index c9be2235712c..2631399e73de 100644
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
@@ -2728,6 +2730,58 @@ void synchronize_rcu_bh(void)
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
+	/*
+	 * Any prior manipulation of RCU-protected data must happen
+	 * before the load from ->gpnum.
+	 */
+	smp_mb();  /* ^^^ */
+
+	/*
+	 * Make sure this load happens before the purportedly
+	 * time-consuming work between get_state_synchronize_rcu()
+	 * and cond_synchronize_rcu().
+	 */
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
+ *
+ * Yes, this function does not take counter wrap into account.  But
+ * counter wrap is harmless.  If the counter wraps, we have waited for
+ * more than 2 billion grace periods (and way more on a 64-bit system!),
+ * so waiting for one additional grace period should be just fine.
+ */
+void cond_synchronize_rcu(unsigned long oldstate)
+{
+	unsigned long newstate;
+
+	/*
+	 * Ensure that this load happens before any RCU-destructive
+	 * actions the caller might carry out after we return.
+	 */
+	newstate = smp_load_acquire(&rcu_state->completed);
+	if (ULONG_CMP_GE(oldstate, newstate))
+		synchronize_rcu();
+}
+EXPORT_SYMBOL_GPL(cond_synchronize_rcu);
+
 static int synchronize_sched_expedited_cpu_stop(void *data)
 {
 	/*

