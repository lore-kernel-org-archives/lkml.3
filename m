Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757968AbaJaKVj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 06:21:39 -0400
Received: from mail-wi0-f179.google.com ([209.85.212.179]:50530 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756896AbaJaKVh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 06:21:37 -0400
Date: Fri, 31 Oct 2014 11:21:32 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "Paul E. McKenney" <paulmck@us.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] core/urgent fixes
Message-ID: <20141031102132.GA24944@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest core-urgent-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git core-urgent-for-linus

   # HEAD: 21ee24bf5b43ecaeec43a7d5c61edb3cd7f847bf Merge branch 'urgent-for-mingo' of git://git.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-rcu into core/urgent

The tree contains two RCU fixes and a compiler quirk comment fix.

 Thanks,

	Ingo

------------------>
Paul E. McKenney (2):
      rcu: More on deadlock between CPU hotplug and expedited grace periods
      rcu: Make rcu_barrier() understand about missing rcuo kthreads

Steven Noonan (1):
      compiler/gcc4+: Remove inaccurate comment about 'asm goto' miscompiles


 include/linux/compiler-gcc4.h |  1 -
 include/linux/compiler-gcc5.h |  1 -
 include/trace/events/rcu.h    | 18 +++++++++---------
 kernel/cpu.c                  | 14 +++++++++++++-
 kernel/rcu/tree.c             | 15 ++++++++++-----
 kernel/rcu/tree.h             |  1 +
 kernel/rcu/tree_plugin.h      | 33 +++++++++++++++++++++++++++++++++
 7 files changed, 66 insertions(+), 17 deletions(-)

diff --git a/include/linux/compiler-gcc4.h b/include/linux/compiler-gcc4.h
index 2507fd2a1eb4..d1a558239b1a 100644
--- a/include/linux/compiler-gcc4.h
+++ b/include/linux/compiler-gcc4.h
@@ -71,7 +71,6 @@
  *   http://gcc.gnu.org/bugzilla/show_bug.cgi?id=58670
  *
  * Work it around via a compiler barrier quirk suggested by Jakub Jelinek.
- * Fixed in GCC 4.8.2 and later versions.
  *
  * (asm goto is automatically volatile - the naming reflects this.)
  */
diff --git a/include/linux/compiler-gcc5.h b/include/linux/compiler-gcc5.h
index cdd1cc202d51..c8c565952548 100644
--- a/include/linux/compiler-gcc5.h
+++ b/include/linux/compiler-gcc5.h
@@ -53,7 +53,6 @@
  *   http://gcc.gnu.org/bugzilla/show_bug.cgi?id=58670
  *
  * Work it around via a compiler barrier quirk suggested by Jakub Jelinek.
- * Fixed in GCC 4.8.2 and later versions.
  *
  * (asm goto is automatically volatile - the naming reflects this.)
  */
diff --git a/include/trace/events/rcu.h b/include/trace/events/rcu.h
index 9b56f37148cf..e335e7d8c6c2 100644
--- a/include/trace/events/rcu.h
+++ b/include/trace/events/rcu.h
@@ -660,18 +660,18 @@ TRACE_EVENT(rcu_torture_read,
 /*
  * Tracepoint for _rcu_barrier() execution.  The string "s" describes
  * the _rcu_barrier phase:
- *	"Begin": rcu_barrier_callback() started.
- *	"Check": rcu_barrier_callback() checking for piggybacking.
- *	"EarlyExit": rcu_barrier_callback() piggybacked, thus early exit.
- *	"Inc1": rcu_barrier_callback() piggyback check counter incremented.
- *	"Offline": rcu_barrier_callback() found offline CPU
- *	"OnlineNoCB": rcu_barrier_callback() found online no-CBs CPU.
- *	"OnlineQ": rcu_barrier_callback() found online CPU with callbacks.
- *	"OnlineNQ": rcu_barrier_callback() found online CPU, no callbacks.
+ *	"Begin": _rcu_barrier() started.
+ *	"Check": _rcu_barrier() checking for piggybacking.
+ *	"EarlyExit": _rcu_barrier() piggybacked, thus early exit.
+ *	"Inc1": _rcu_barrier() piggyback check counter incremented.
+ *	"OfflineNoCB": _rcu_barrier() found callback on never-online CPU
+ *	"OnlineNoCB": _rcu_barrier() found online no-CBs CPU.
+ *	"OnlineQ": _rcu_barrier() found online CPU with callbacks.
+ *	"OnlineNQ": _rcu_barrier() found online CPU, no callbacks.
  *	"IRQ": An rcu_barrier_callback() callback posted on remote CPU.
  *	"CB": An rcu_barrier_callback() invoked a callback, not the last.
  *	"LastCB": An rcu_barrier_callback() invoked the last callback.
- *	"Inc2": rcu_barrier_callback() piggyback check counter incremented.
+ *	"Inc2": _rcu_barrier() piggyback check counter incremented.
  * The "cpu" argument is the CPU or -1 if meaningless, the "cnt" argument
  * is the count of remaining callbacks, and "done" is the piggybacking count.
  */
diff --git a/kernel/cpu.c b/kernel/cpu.c
index 356450f09c1f..90a3d017b90c 100644
--- a/kernel/cpu.c
+++ b/kernel/cpu.c
@@ -64,6 +64,8 @@ static struct {
 	 * an ongoing cpu hotplug operation.
 	 */
 	int refcount;
+	/* And allows lockless put_online_cpus(). */
+	atomic_t puts_pending;
 
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
 	struct lockdep_map dep_map;
@@ -113,7 +115,11 @@ void put_online_cpus(void)
 {
 	if (cpu_hotplug.active_writer == current)
 		return;
-	mutex_lock(&cpu_hotplug.lock);
+	if (!mutex_trylock(&cpu_hotplug.lock)) {
+		atomic_inc(&cpu_hotplug.puts_pending);
+		cpuhp_lock_release();
+		return;
+	}
 
 	if (WARN_ON(!cpu_hotplug.refcount))
 		cpu_hotplug.refcount++; /* try to fix things up */
@@ -155,6 +161,12 @@ void cpu_hotplug_begin(void)
 	cpuhp_lock_acquire();
 	for (;;) {
 		mutex_lock(&cpu_hotplug.lock);
+		if (atomic_read(&cpu_hotplug.puts_pending)) {
+			int delta;
+
+			delta = atomic_xchg(&cpu_hotplug.puts_pending, 0);
+			cpu_hotplug.refcount -= delta;
+		}
 		if (likely(!cpu_hotplug.refcount))
 			break;
 		__set_current_state(TASK_UNINTERRUPTIBLE);
diff --git a/kernel/rcu/tree.c b/kernel/rcu/tree.c
index 133e47223095..9815447d22e0 100644
--- a/kernel/rcu/tree.c
+++ b/kernel/rcu/tree.c
@@ -3299,11 +3299,16 @@ static void _rcu_barrier(struct rcu_state *rsp)
 			continue;
 		rdp = per_cpu_ptr(rsp->rda, cpu);
 		if (rcu_is_nocb_cpu(cpu)) {
-			_rcu_barrier_trace(rsp, "OnlineNoCB", cpu,
-					   rsp->n_barrier_done);
-			atomic_inc(&rsp->barrier_cpu_count);
-			__call_rcu(&rdp->barrier_head, rcu_barrier_callback,
-				   rsp, cpu, 0);
+			if (!rcu_nocb_cpu_needs_barrier(rsp, cpu)) {
+				_rcu_barrier_trace(rsp, "OfflineNoCB", cpu,
+						   rsp->n_barrier_done);
+			} else {
+				_rcu_barrier_trace(rsp, "OnlineNoCB", cpu,
+						   rsp->n_barrier_done);
+				atomic_inc(&rsp->barrier_cpu_count);
+				__call_rcu(&rdp->barrier_head,
+					   rcu_barrier_callback, rsp, cpu, 0);
+			}
 		} else if (ACCESS_ONCE(rdp->qlen)) {
 			_rcu_barrier_trace(rsp, "OnlineQ", cpu,
 					   rsp->n_barrier_done);
diff --git a/kernel/rcu/tree.h b/kernel/rcu/tree.h
index d03764652d91..bbdc45d8d74f 100644
--- a/kernel/rcu/tree.h
+++ b/kernel/rcu/tree.h
@@ -587,6 +587,7 @@ static void print_cpu_stall_info(struct rcu_state *rsp, int cpu);
 static void print_cpu_stall_info_end(void);
 static void zero_cpu_stall_ticks(struct rcu_data *rdp);
 static void increment_cpu_stall_ticks(void);
+static bool rcu_nocb_cpu_needs_barrier(struct rcu_state *rsp, int cpu);
 static void rcu_nocb_gp_set(struct rcu_node *rnp, int nrq);
 static void rcu_nocb_gp_cleanup(struct rcu_state *rsp, struct rcu_node *rnp);
 static void rcu_init_one_nocb(struct rcu_node *rnp);
diff --git a/kernel/rcu/tree_plugin.h b/kernel/rcu/tree_plugin.h
index 387dd4599344..c1d7f27bd38f 100644
--- a/kernel/rcu/tree_plugin.h
+++ b/kernel/rcu/tree_plugin.h
@@ -2050,6 +2050,33 @@ static void wake_nocb_leader(struct rcu_data *rdp, bool force)
 }
 
 /*
+ * Does the specified CPU need an RCU callback for the specified flavor
+ * of rcu_barrier()?
+ */
+static bool rcu_nocb_cpu_needs_barrier(struct rcu_state *rsp, int cpu)
+{
+	struct rcu_data *rdp = per_cpu_ptr(rsp->rda, cpu);
+	struct rcu_head *rhp;
+
+	/* No-CBs CPUs might have callbacks on any of three lists. */
+	rhp = ACCESS_ONCE(rdp->nocb_head);
+	if (!rhp)
+		rhp = ACCESS_ONCE(rdp->nocb_gp_head);
+	if (!rhp)
+		rhp = ACCESS_ONCE(rdp->nocb_follower_head);
+
+	/* Having no rcuo kthread but CBs after scheduler starts is bad! */
+	if (!ACCESS_ONCE(rdp->nocb_kthread) && rhp) {
+		/* RCU callback enqueued before CPU first came online??? */
+		pr_err("RCU: Never-onlined no-CBs CPU %d has CB %p\n",
+		       cpu, rhp->func);
+		WARN_ON_ONCE(1);
+	}
+
+	return !!rhp;
+}
+
+/*
  * Enqueue the specified string of rcu_head structures onto the specified
  * CPU's no-CBs lists.  The CPU is specified by rdp, the head of the
  * string by rhp, and the tail of the string by rhtp.  The non-lazy/lazy
@@ -2642,6 +2669,12 @@ static bool init_nocb_callback_list(struct rcu_data *rdp)
 
 #else /* #ifdef CONFIG_RCU_NOCB_CPU */
 
+static bool rcu_nocb_cpu_needs_barrier(struct rcu_state *rsp, int cpu)
+{
+	WARN_ON_ONCE(1); /* Should be dead code. */
+	return false;
+}
+
 static void rcu_nocb_gp_cleanup(struct rcu_state *rsp, struct rcu_node *rnp)
 {
 }
