Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757285Ab3ETOyl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 10:54:41 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:42861 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752024Ab3ETOyh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 10:54:37 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, edumazet@google.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 1/2] rcu: Remove srcu_read_lock_raw() and srcu_read_unlock_raw().
Date: Mon, 20 May 2013 07:52:32 -0700
Message-Id: <1369061553-31811-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <20130520145213.GA31538@linux.vnet.ibm.com>
References: <20130520145213.GA31538@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13052014-9360-0000-0000-000012433BDB
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

These interfaces never did get used, so this commit removes them,
their rcutorture tests, and documentation referencing them.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Reviewed-by: Lai Jiangshan <laijs@cn.fujitsu.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 Documentation/RCU/checklist.txt |  6 ------
 Documentation/RCU/torture.txt   |  6 ------
 Documentation/RCU/whatisRCU.txt | 22 +++++++--------------
 include/linux/srcu.h            | 43 -----------------------------------------
 kernel/rcutorture.c             | 39 -------------------------------------
 5 files changed, 7 insertions(+), 109 deletions(-)

diff --git a/Documentation/RCU/checklist.txt b/Documentation/RCU/checklist.txt
index 79e789b8..7703ec7 100644
--- a/Documentation/RCU/checklist.txt
+++ b/Documentation/RCU/checklist.txt
@@ -354,12 +354,6 @@ over a rather long period of time, but improvements are always welcome!
 	using RCU rather than SRCU, because RCU is almost always faster
 	and easier to use than is SRCU.
 
-	If you need to enter your read-side critical section in a
-	hardirq or exception handler, and then exit that same read-side
-	critical section in the task that was interrupted, then you need
-	to srcu_read_lock_raw() and srcu_read_unlock_raw(), which avoid
-	the lockdep checking that would otherwise this practice illegal.
-
 	Also unlike other forms of RCU, explicit initialization
 	and cleanup is required via init_srcu_struct() and
 	cleanup_srcu_struct().	These are passed a "struct srcu_struct"
diff --git a/Documentation/RCU/torture.txt b/Documentation/RCU/torture.txt
index 7dce8a1..d8a5023 100644
--- a/Documentation/RCU/torture.txt
+++ b/Documentation/RCU/torture.txt
@@ -182,12 +182,6 @@ torture_type	The type of RCU to test, with string values as follows:
 		"srcu_expedited": srcu_read_lock(), srcu_read_unlock() and
 			synchronize_srcu_expedited().
 
-		"srcu_raw": srcu_read_lock_raw(), srcu_read_unlock_raw(),
-			and call_srcu().
-
-		"srcu_raw_sync": srcu_read_lock_raw(), srcu_read_unlock_raw(),
-			and synchronize_srcu().
-
 		"sched": preempt_disable(), preempt_enable(), and
 			call_rcu_sched().
 
diff --git a/Documentation/RCU/whatisRCU.txt b/Documentation/RCU/whatisRCU.txt
index 10df0b8..0f0fb7c 100644
--- a/Documentation/RCU/whatisRCU.txt
+++ b/Documentation/RCU/whatisRCU.txt
@@ -842,9 +842,7 @@ SRCU:	Critical sections	Grace period		Barrier
 
 	srcu_read_lock		synchronize_srcu	srcu_barrier
 	srcu_read_unlock	call_srcu
-	srcu_read_lock_raw	synchronize_srcu_expedited
-	srcu_read_unlock_raw
-	srcu_dereference
+	srcu_dereference	synchronize_srcu_expedited
 
 SRCU:	Initialization/cleanup
 	init_srcu_struct
@@ -865,38 +863,32 @@ list can be helpful:
 
 a.	Will readers need to block?  If so, you need SRCU.
 
-b.	Is it necessary to start a read-side critical section in a
-	hardirq handler or exception handler, and then to complete
-	this read-side critical section in the task that was
-	interrupted?  If so, you need SRCU's srcu_read_lock_raw() and
-	srcu_read_unlock_raw() primitives.
-
-c.	What about the -rt patchset?  If readers would need to block
+b.	What about the -rt patchset?  If readers would need to block
 	in an non-rt kernel, you need SRCU.  If readers would block
 	in a -rt kernel, but not in a non-rt kernel, SRCU is not
 	necessary.
 
-d.	Do you need to treat NMI handlers, hardirq handlers,
+c.	Do you need to treat NMI handlers, hardirq handlers,
 	and code segments with preemption disabled (whether
 	via preempt_disable(), local_irq_save(), local_bh_disable(),
 	or some other mechanism) as if they were explicit RCU readers?
 	If so, RCU-sched is the only choice that will work for you.
 
-e.	Do you need RCU grace periods to complete even in the face
+d.	Do you need RCU grace periods to complete even in the face
 	of softirq monopolization of one or more of the CPUs?  For
 	example, is your code subject to network-based denial-of-service
 	attacks?  If so, you need RCU-bh.
 
-f.	Is your workload too update-intensive for normal use of
+e.	Is your workload too update-intensive for normal use of
 	RCU, but inappropriate for other synchronization mechanisms?
 	If so, consider SLAB_DESTROY_BY_RCU.  But please be careful!
 
-g.	Do you need read-side critical sections that are respected
+f.	Do you need read-side critical sections that are respected
 	even though they are in the middle of the idle loop, during
 	user-mode execution, or on an offlined CPU?  If so, SRCU is the
 	only choice that will work for you.
 
-h.	Otherwise, use RCU.
+g.	Otherwise, use RCU.
 
 Of course, this all assumes that you have determined that RCU is in fact
 the right tool for your job.
diff --git a/include/linux/srcu.h b/include/linux/srcu.h
index 04f4121..c114614 100644
--- a/include/linux/srcu.h
+++ b/include/linux/srcu.h
@@ -237,47 +237,4 @@ static inline void srcu_read_unlock(struct srcu_struct *sp, int idx)
 	__srcu_read_unlock(sp, idx);
 }
 
-/**
- * srcu_read_lock_raw - register a new reader for an SRCU-protected structure.
- * @sp: srcu_struct in which to register the new reader.
- *
- * Enter an SRCU read-side critical section.  Similar to srcu_read_lock(),
- * but avoids the RCU-lockdep checking.  This means that it is legal to
- * use srcu_read_lock_raw() in one context, for example, in an exception
- * handler, and then have the matching srcu_read_unlock_raw() in another
- * context, for example in the task that took the exception.
- *
- * However, the entire SRCU read-side critical section must reside within a
- * single task.  For example, beware of using srcu_read_lock_raw() in
- * a device interrupt handler and srcu_read_unlock() in the interrupted
- * task:  This will not work if interrupts are threaded.
- */
-static inline int srcu_read_lock_raw(struct srcu_struct *sp)
-{
-	unsigned long flags;
-	int ret;
-
-	local_irq_save(flags);
-	ret =  __srcu_read_lock(sp);
-	local_irq_restore(flags);
-	return ret;
-}
-
-/**
- * srcu_read_unlock_raw - unregister reader from an SRCU-protected structure.
- * @sp: srcu_struct in which to unregister the old reader.
- * @idx: return value from corresponding srcu_read_lock_raw().
- *
- * Exit an SRCU read-side critical section without lockdep-RCU checking.
- * See srcu_read_lock_raw() for more details.
- */
-static inline void srcu_read_unlock_raw(struct srcu_struct *sp, int idx)
-{
-	unsigned long flags;
-
-	local_irq_save(flags);
-	__srcu_read_unlock(sp, idx);
-	local_irq_restore(flags);
-}
-
 #endif
diff --git a/kernel/rcutorture.c b/kernel/rcutorture.c
index e1f3a8c..b1fa551 100644
--- a/kernel/rcutorture.c
+++ b/kernel/rcutorture.c
@@ -695,44 +695,6 @@ static struct rcu_torture_ops srcu_sync_ops = {
 	.name		= "srcu_sync"
 };
 
-static int srcu_torture_read_lock_raw(void) __acquires(&srcu_ctl)
-{
-	return srcu_read_lock_raw(&srcu_ctl);
-}
-
-static void srcu_torture_read_unlock_raw(int idx) __releases(&srcu_ctl)
-{
-	srcu_read_unlock_raw(&srcu_ctl, idx);
-}
-
-static struct rcu_torture_ops srcu_raw_ops = {
-	.init		= rcu_sync_torture_init,
-	.readlock	= srcu_torture_read_lock_raw,
-	.read_delay	= srcu_read_delay,
-	.readunlock	= srcu_torture_read_unlock_raw,
-	.completed	= srcu_torture_completed,
-	.deferred_free	= srcu_torture_deferred_free,
-	.sync		= srcu_torture_synchronize,
-	.call		= NULL,
-	.cb_barrier	= NULL,
-	.stats		= srcu_torture_stats,
-	.name		= "srcu_raw"
-};
-
-static struct rcu_torture_ops srcu_raw_sync_ops = {
-	.init		= rcu_sync_torture_init,
-	.readlock	= srcu_torture_read_lock_raw,
-	.read_delay	= srcu_read_delay,
-	.readunlock	= srcu_torture_read_unlock_raw,
-	.completed	= srcu_torture_completed,
-	.deferred_free	= rcu_sync_torture_deferred_free,
-	.sync		= srcu_torture_synchronize,
-	.call		= NULL,
-	.cb_barrier	= NULL,
-	.stats		= srcu_torture_stats,
-	.name		= "srcu_raw_sync"
-};
-
 static void srcu_torture_synchronize_expedited(void)
 {
 	synchronize_srcu_expedited(&srcu_ctl);
@@ -1983,7 +1945,6 @@ rcu_torture_init(void)
 		{ &rcu_ops, &rcu_sync_ops, &rcu_expedited_ops,
 		  &rcu_bh_ops, &rcu_bh_sync_ops, &rcu_bh_expedited_ops,
 		  &srcu_ops, &srcu_sync_ops, &srcu_expedited_ops,
-		  &srcu_raw_ops, &srcu_raw_sync_ops,
 		  &sched_ops, &sched_sync_ops, &sched_expedited_ops, };
 
 	mutex_lock(&fullstop_mutex);
-- 
1.8.1.5

