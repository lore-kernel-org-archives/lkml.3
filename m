Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754987AbaCQQsX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 12:48:23 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:54084 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754577AbaCQQsU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 12:48:20 -0400
Date: Mon, 17 Mar 2014 09:48:15 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>, Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH] [RFC] perf: Fix a race between ring_buffer_detach() and
 ring_buffer_wakeup()
Message-ID: <20140317164815.GF21124@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1394199526-6400-1-git-send-email-alexander.shishkin@linux.intel.com>
 <20140313195816.GJ21124@linux.vnet.ibm.com>
 <20140314095033.GP27965@twins.programming.kicks-ass.net>
 <20140314204736.GG21124@linux.vnet.ibm.com>
 <20140314224317.GQ30956@twins.programming.kicks-ass.net>
 <20140314230231.GM21124@linux.vnet.ibm.com>
 <20140315000009.GA28008@linux.vnet.ibm.com>
 <20140317111807.GE27965@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140317111807.GE27965@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14031716-0928-0000-0000-0000007AF74A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 17, 2014 at 12:18:07PM +0100, Peter Zijlstra wrote:
> > rcu: Provide grace-period piggybacking API
> >     
> > The following pattern is currently not well supported by RCU:
> >     
> > 1.	Make data element inaccessible to RCU readers.
> >     
> > 2.	Do work that probably lasts for more than one grace period.
> >     
> > 3.	Do something to make sure RCU readers in flight before #1 above
> >     	have completed.
> >     
> > Here are some things that could currently be done:
> >     
> > a.	Do a synchronize_rcu() unconditionally at either #1 or #3 above.
> >     	This works, but imposes needless work and latency.
> >     
> > b.	Post an RCU callback at #1 above that does a wakeup, then
> >     	wait for the wakeup at #3.  This works well, but likely results
> >     	in an extra unneeded grace period.  Open-coding this is also
> >     	a bit more semi-tricky code than would be good.
> > 
> > This commit therefore adds get_state_synchronize_rcu() and
> > cond_synchronize_rcu() APIs.  Call get_state_synchronize_rcu() at #1
> > above and pass its return value to cond_synchronize_rcu() at #3 above.
> > This results in a call to synchronize_rcu() if no grace period has
> > elapsed between #1 and #3, but requires only a load, comparison, and
> > memory barrier if a full grace period did elapse.
> > 
> > Reported-by: Peter Zijlstra <peterz@infradead.org>
> 
> More a requested-by, I'd say.

Fair enough...

> > Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> > +/**
> > + * get_state_synchronize_rcu - Snapshot current RCU state
> > + *
> > + * Returns a cookie that is used by a later call to cond_synchronize_rcu()
> > + * to determine whether or not a full grace period has elapsed in the
> > + * meantime.
> > + */
> > +unsigned long get_state_synchronize_rcu(void)
> > +{
> 
> /*
>  * Make sure this load happens before anything following it; such that
>  * ... ?
>  */

Good point, this barrier is a bit obsure.  Here you go:

	/*
	 * Make sure this load happens before the purportedly
	 * time-consuming work between get_state_synchronize_rcu()
	 * and cond_synchronize_rcu().
	 */

So all you lose by leaving this barrier out is a slightly higher
probability of invoking synchronize_rcu() at cond_synchronize_rcu() time.
And without the barrier there is some chance of the CPU doing the load in
cond_synchronize_rcu() before this load in get_state_synchronize_rcu().
Which should be OK, but simpler to exclude this than have to worry about
counters out of sync.  Besides, you are taking a grace-period delay in
here somewhere, so the memory barrier is way down in the noise.

> The way I imaged using this is taking this snapshot after the RCU
> operation, such that we err towards seeing a later grace period and
> synchronizing too much in stead of seeing an earlier and sync'ing too
> little.
> 
> Such use would suggest the barrier the other way around.

Ah, but that ordering happens at the updater's end.  And there
are in fact memory barriers before and after the increment of
->gpnum in rcu_gp_init():

	/* Advance to a new grace period and initialize state. */
	record_gp_stall_check_time(rsp);
	/* Record GP times before starting GP, hence smp_store_release(). */
	smp_store_release(&rsp->gpnum, rsp->gpnum + 1);
	trace_rcu_grace_period(rsp->name, rsp->gpnum, TPS("start"));
	raw_spin_unlock_irq(&rnp->lock);

	/* Exclude any concurrent CPU-hotplug operations. */
	mutex_lock(&rsp->onoff_mutex);
	smp_mb__after_unlock_lock(); /* ->gpnum increment before GP! */

The smp_store_release() provides the memory barrier before, and the
smp_mb__after_unlock_lock() provides it after.

> > +	return smp_load_acquire(&rcu_state->gpnum);
> > +}
> > +EXPORT_SYMBOL_GPL(get_state_synchronize_rcu);
> 
> I can't say I'm excited about that function name; but I'm also
> completely lacking in alternatives.

;-)

> > +
> > +/**
> > + * cond_synchronize_rcu - Conditionally wait for an RCU grace period
> > + *
> > + * @oldstate: return value from earlier call to get_state_synchronize_rcu()
> > + *
> > + * If a full RCU grace period has elapsed since the earlier call to
> > + * get_state_synchronize_rcu(), just return.  Otherwise, invoke
> > + * synchronize_rcu() to wait for a full grace period.
> > + */
> > +void cond_synchronize_rcu(unsigned long oldstate)
> > +{
> > +	unsigned long newstate = smp_load_acquire(&rcu_state->completed);
> 
> Again, uncommented barriers; the load_acquire seems to suggest you want
> to make sure the sync_rcu() bits happen after this read. But seeing how
> sync_rcu() will invariably read the same data again and you get an
> address dep this seems somewhat superfluous.

Not quite!  The get_state_synchronize_rcu() function reads ->gpnum,
but cond_synchronize_rcu() reads ->completed.  The

> Then again, can't hurt I suppose :-)
> 
> > +	if (ULONG_CMP_GE(oldstate, newstate))
> 
> So if the observed active gp (oldstate) is ahead or equal to the last
> completed gp, then we wait?

Yep!  I will risk an ASCII diagram:


3:	                                                  +----gpnum----+-- ...
	                                                  |             |
2:	                            +----gpnum----+-------+--completed--+
	                            |             |
1:	      +----gpnum----+-------+--completed--+
	      |             |
0:	+-----+--completed--+


A full RCU grace period happens between a pair of "|"s on the same line.
By inspection, if your snapshot of ->gpnum is greater than the current
value of ->completed, a grace period has passed.

> I thought the double grace period thing was for preemptible rcu; is it
> done here because you don't want to special case the preemptible rcu and
> make do with a single implementation?

No, we are waiting for only one grace period.  We -would- need a double
grace period if we were using the ->gpnum and ->completed values from the
rcu_node structures because these values can each be one unit out of sync
with the global values.  And we might someday need to take this step,
for example if large machines and heavy use of these primitives someday
results in excessive memory contention on the ->gpnum and ->completed
values in the global rcu_state structure.  And then the ASCII diagram
is as follows:

3:	                                                  +-+--gpnum----+--+...
	                                                  | ^           |  ^
2:	                            +-+--gpnum----+-------+-+completed--+>>+
	                            | ^           |  ^
1:	      +-+--gpnum----+--+----+-+completed--+>>+
	      | ^           |  ^
0:	+-----+-+completed--+>>+

Here the "^"s represent the later transitions of the ->gpnum and ->completed
values in the rcu_node structures.  But we still have to wait for the
interval between a pair of "|" characters: The interval between a pair
of "^" characters does -not- suffice, because there might not be a full
set of quiescent states between the "^"s!  So we have to wait for two, so
that the conditional would become:

	if (ULONG_CMP_GE(oldstate + 1, newstate))

Referring to the second ASCII diagram above, if oldstate is zero, we might
have missed the beginning of the first grace period.  We must therefore
wait until the end of the second grace period, at which point newstate
will be 2.  Which works out, as 1+1>=2.

> And I suppose that on wrap around; we do extra sync_rcu() calls, which
> can never be wrong.

Yep!  Ah, I suppose I should comment that, shouldn't I?  How about the
following in the header comment?

 * Yes, this function does not take counter wrap into account.  But
 * counter wrap is harmless.  If the counter wraps, you have waited
 * at least 4 billion grace periods already (more on a 64-bit system!),
 * so waiting for one extra grace period should not be a problem.

> > +		synchronize_rcu();
> > +}
> > +EXPORT_SYMBOL_GPL(cond_synchronize_rcu);

Ugh.  And I also forgot rcutiny.  It is pretty straightforward.  ;-)

	static inline unsigned long get_state_synchronize_rcu(void)
	{
		return 0;
	}

	static inline void cond_synchronize_rcu(unsigned long oldstate)
	{
		might_sleep();
	}

This works because on a !SMP system, might_sleep() is a grace period.
These are in include/linux/rcutiny.h.

I also added the needed declarations in include/linux/rcutree.h.

Updated patch below.

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
index c9be2235712c..65e99cf080e0 100644
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
@@ -2728,6 +2730,47 @@ void synchronize_rcu_bh(void)
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

