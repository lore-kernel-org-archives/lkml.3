Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752926AbaEBXyC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2014 19:54:02 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:44395 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752688AbaEBXyA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2014 19:54:00 -0400
Date: Fri, 2 May 2014 16:53:56 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: peterz@infradead.org
Cc: linux-kernel@vger.kernel.org
Subject: Did you still need asynchronous grace-period detection?
Message-ID: <20140502235355.GA13710@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14050223-6688-0000-0000-00000188B51B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Peter,

The following commit seems to have been dropped on the floor.
Given that you haven't complained, I feel the need to ask you
if you still need it.  ;-)

If you do need it, I will push it into 3.16.

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
Acked-by: Peter Zijlstra <peterz@infradead.org>

diff --git a/include/linux/rcutiny.h b/include/linux/rcutiny.h
index e8cb6e3b52a7..425c659d54e5 100644
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
index e9c63884df0a..a59ca05fd4e3 100644
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
index 351faba48b91..0c47e300210a 100644
--- a/kernel/rcu/tree.c
+++ b/kernel/rcu/tree.c
@@ -1421,13 +1421,14 @@ static int rcu_gp_init(struct rcu_state *rsp)
 
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
@@ -1555,10 +1556,11 @@ static void rcu_gp_cleanup(struct rcu_state *rsp)
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
@@ -2637,6 +2639,58 @@ void synchronize_rcu_bh(void)
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

