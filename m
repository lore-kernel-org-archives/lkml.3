Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757585Ab3D3GmI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Apr 2013 02:42:08 -0400
Received: from mail-ee0-f41.google.com ([74.125.83.41]:39244 "EHLO
	mail-ee0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755013Ab3D3GmE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Apr 2013 02:42:04 -0400
Date: Tue, 30 Apr 2013 08:41:58 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Paul E. McKenney" <paulmck@us.ibm.com>, linux-kernel@vger.kernel.org,
        =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] RCU changes for v3.10
Message-ID: <20130430064158.GA19384@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest core-rcu-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git core-rcu-for-linus

   HEAD: 8fcfae31719c0a6c03f2cf63f815b46d378d8be4 Merge branch 'rcu/next' of git://git.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-rcu into core/rcu

The main changes in this cycle are mostly related to preparatory work for 
the full-dynticks work:

      * Remove restrictions on no-CBs CPUs, make RCU_FAST_NO_HZ
        take advantage of numbered callbacks, do callback
        accelerations based on numbered callbacks.  Posted to LKML
        at https://lkml.org/lkml/2013/3/18/960.
    
      * RCU documentation updates.  Posted to LKML at
        https://lkml.org/lkml/2013/3/18/570.
    
      * Miscellaneous fixes.  Posted to LKML at
        https://lkml.org/lkml/2013/3/18/594.

 Thanks,

	Ingo

------------------>
Jiang Fang (1):
      rcu: Fix spacing problem

Paul E. McKenney (21):
      rcu: Remove restrictions on no-CBs CPUs
      rcu: Avoid invoking RCU core on offline CPUs
      rcu: Delete unused rcu_node "wakemask" field
      rcu: Make bugginess of code sample more evident
      rcu: Documentation update
      rcu: Add softirq-stall indications to stall-warning messages
      rcu: Tone down debugging during boot-up and shutdown.
      rcu: Provide compile-time control for no-CBs CPUs
      rcu: Introduce proper blocking to no-CBs kthreads GP waits
      rcu: Add event tracing for no-CBs CPUs' callback registration
      rcu: Add event tracing for no-CBs CPUs' grace periods
      rcu: Distinguish "rcuo" kthreads by RCU flavor
      rcu: Export RCU_FAST_NO_HZ parameters to sysfs
      rcu: Accelerate RCU callbacks at grace-period end
      rcu: Make RCU_FAST_NO_HZ take advantage of numbered callbacks
      rcu: Rearrange locking in rcu_start_gp()
      rcu: Repurpose no-CBs event tracing to future-GP events
      rcu: Push lock release to rcu_start_gp()'s callers
      rcu: Rename n_nocb_gp_requests to need_future_gp
      rcu: Abstract rcu_start_future_gp() from rcu_nocb_wait_gp()
      rcu: Make rcu_accelerate_cbs() note need for future grace periods

Srivatsa S. Bhat (1):
      rcu: Remove comment referring to __stop_machine()

Steven Whitehouse (1):
      rcu: Fix hlist_bl_set_first_rcu() annotation


 Documentation/RCU/checklist.txt     |  26 +-
 Documentation/RCU/lockdep.txt       |   5 +
 Documentation/RCU/rcubarrier.txt    |  15 +-
 Documentation/RCU/stallwarn.txt     |  33 +-
 Documentation/RCU/whatisRCU.txt     |   4 +-
 Documentation/kernel-parameters.txt |  35 ++-
 include/linux/list_bl.h             |   5 +
 include/linux/rculist_bl.h          |   2 +-
 include/linux/rcupdate.h            |   1 +
 include/trace/events/rcu.h          |  55 ++++
 init/Kconfig                        |  73 ++++-
 kernel/rcutree.c                    | 260 ++++++++++++----
 kernel/rcutree.h                    |  41 ++-
 kernel/rcutree_plugin.h             | 601 +++++++++++++-----------------------
 kernel/rcutree_trace.c              |   2 -
 15 files changed, 640 insertions(+), 518 deletions(-)

diff --git a/Documentation/RCU/checklist.txt b/Documentation/RCU/checklist.txt
index 31ef8fe..79e789b8 100644
--- a/Documentation/RCU/checklist.txt
+++ b/Documentation/RCU/checklist.txt
@@ -217,9 +217,14 @@ over a rather long period of time, but improvements are always welcome!
 	whether the increased speed is worth it.
 
 8.	Although synchronize_rcu() is slower than is call_rcu(), it
-	usually results in simpler code.  So, unless update performance
-	is critically important or the updaters cannot block,
-	synchronize_rcu() should be used in preference to call_rcu().
+	usually results in simpler code.  So, unless update performance is
+	critically important, the updaters cannot block, or the latency of
+	synchronize_rcu() is visible from userspace, synchronize_rcu()
+	should be used in preference to call_rcu().  Furthermore,
+	kfree_rcu() usually results in even simpler code than does
+	synchronize_rcu() without synchronize_rcu()'s multi-millisecond
+	latency.  So please take advantage of kfree_rcu()'s "fire and
+	forget" memory-freeing capabilities where it applies.
 
 	An especially important property of the synchronize_rcu()
 	primitive is that it automatically self-limits: if grace periods
@@ -268,7 +273,8 @@ over a rather long period of time, but improvements are always welcome!
 	e.	Periodically invoke synchronize_rcu(), permitting a limited
 		number of updates per grace period.
 
-	The same cautions apply to call_rcu_bh() and call_rcu_sched().
+	The same cautions apply to call_rcu_bh(), call_rcu_sched(),
+	call_srcu(), and kfree_rcu().
 
 9.	All RCU list-traversal primitives, which include
 	rcu_dereference(), list_for_each_entry_rcu(), and
@@ -296,9 +302,9 @@ over a rather long period of time, but improvements are always welcome!
 	all currently executing rcu_read_lock()-protected RCU read-side
 	critical sections complete.  It does -not- necessarily guarantee
 	that all currently running interrupts, NMIs, preempt_disable()
-	code, or idle loops will complete.  Therefore, if you do not have
-	rcu_read_lock()-protected read-side critical sections, do -not-
-	use synchronize_rcu().
+	code, or idle loops will complete.  Therefore, if your
+	read-side critical sections are protected by something other
+	than rcu_read_lock(), do -not- use synchronize_rcu().
 
 	Similarly, disabling preemption is not an acceptable substitute
 	for rcu_read_lock().  Code that attempts to use preemption
@@ -401,9 +407,9 @@ over a rather long period of time, but improvements are always welcome!
 	read-side critical sections.  It is the responsibility of the
 	RCU update-side primitives to deal with this.
 
-17.	Use CONFIG_PROVE_RCU, CONFIG_DEBUG_OBJECTS_RCU_HEAD, and
-	the __rcu sparse checks to validate your RCU code.  These
-	can help find problems as follows:
+17.	Use CONFIG_PROVE_RCU, CONFIG_DEBUG_OBJECTS_RCU_HEAD, and the
+	__rcu sparse checks (enabled by CONFIG_SPARSE_RCU_POINTER) to
+	validate your RCU code.  These can help find problems as follows:
 
 	CONFIG_PROVE_RCU: check that accesses to RCU-protected data
 		structures are carried out under the proper RCU
diff --git a/Documentation/RCU/lockdep.txt b/Documentation/RCU/lockdep.txt
index a102d4b..cd83d23 100644
--- a/Documentation/RCU/lockdep.txt
+++ b/Documentation/RCU/lockdep.txt
@@ -64,6 +64,11 @@ checking of rcu_dereference() primitives:
 		but retain the compiler constraints that prevent duplicating
 		or coalescsing.  This is useful when when testing the
 		value of the pointer itself, for example, against NULL.
+	rcu_access_index(idx):
+		Return the value of the index and omit all barriers, but
+		retain the compiler constraints that prevent duplicating
+		or coalescsing.  This is useful when when testing the
+		value of the index itself, for example, against -1.
 
 The rcu_dereference_check() check expression can be any boolean
 expression, but would normally include a lockdep expression.  However,
diff --git a/Documentation/RCU/rcubarrier.txt b/Documentation/RCU/rcubarrier.txt
index 38428c1..2e319d1 100644
--- a/Documentation/RCU/rcubarrier.txt
+++ b/Documentation/RCU/rcubarrier.txt
@@ -79,7 +79,20 @@ complete. Pseudo-code using rcu_barrier() is as follows:
    2. Execute rcu_barrier().
    3. Allow the module to be unloaded.
 
-The rcutorture module makes use of rcu_barrier in its exit function
+There are also rcu_barrier_bh(), rcu_barrier_sched(), and srcu_barrier()
+functions for the other flavors of RCU, and you of course must match
+the flavor of rcu_barrier() with that of call_rcu().  If your module
+uses multiple flavors of call_rcu(), then it must also use multiple
+flavors of rcu_barrier() when unloading that module.  For example, if
+it uses call_rcu_bh(), call_srcu() on srcu_struct_1, and call_srcu() on
+srcu_struct_2(), then the following three lines of code will be required
+when unloading:
+
+ 1 rcu_barrier_bh();
+ 2 srcu_barrier(&srcu_struct_1);
+ 3 srcu_barrier(&srcu_struct_2);
+
+The rcutorture module makes use of rcu_barrier() in its exit function
 as follows:
 
  1 static void
diff --git a/Documentation/RCU/stallwarn.txt b/Documentation/RCU/stallwarn.txt
index 1927151..e38b8df 100644
--- a/Documentation/RCU/stallwarn.txt
+++ b/Documentation/RCU/stallwarn.txt
@@ -92,14 +92,14 @@ If the CONFIG_RCU_CPU_STALL_INFO kernel configuration parameter is set,
 more information is printed with the stall-warning message, for example:
 
 	INFO: rcu_preempt detected stall on CPU
-	0: (63959 ticks this GP) idle=241/3fffffffffffffff/0
+	0: (63959 ticks this GP) idle=241/3fffffffffffffff/0 softirq=82/543
 	   (t=65000 jiffies)
 
 In kernels with CONFIG_RCU_FAST_NO_HZ, even more information is
 printed:
 
 	INFO: rcu_preempt detected stall on CPU
-	0: (64628 ticks this GP) idle=dd5/3fffffffffffffff/0 drain=0 . timer not pending
+	0: (64628 ticks this GP) idle=dd5/3fffffffffffffff/0 softirq=82/543 last_accelerate: a345/d342 nonlazy_posted: 25 .D
 	   (t=65000 jiffies)
 
 The "(64628 ticks this GP)" indicates that this CPU has taken more
@@ -116,13 +116,28 @@ number between the two "/"s is the value of the nesting, which will
 be a small positive number if in the idle loop and a very large positive
 number (as shown above) otherwise.
 
-For CONFIG_RCU_FAST_NO_HZ kernels, the "drain=0" indicates that the CPU is
-not in the process of trying to force itself into dyntick-idle state, the
-"." indicates that the CPU has not given up forcing RCU into dyntick-idle
-mode (it would be "H" otherwise), and the "timer not pending" indicates
-that the CPU has not recently forced RCU into dyntick-idle mode (it
-would otherwise indicate the number of microseconds remaining in this
-forced state).
+The "softirq=" portion of the message tracks the number of RCU softirq
+handlers that the stalled CPU has executed.  The number before the "/"
+is the number that had executed since boot at the time that this CPU
+last noted the beginning of a grace period, which might be the current
+(stalled) grace period, or it might be some earlier grace period (for
+example, if the CPU might have been in dyntick-idle mode for an extended
+time period.  The number after the "/" is the number that have executed
+since boot until the current time.  If this latter number stays constant
+across repeated stall-warning messages, it is possible that RCU's softirq
+handlers are no longer able to execute on this CPU.  This can happen if
+the stalled CPU is spinning with interrupts are disabled, or, in -rt
+kernels, if a high-priority process is starving RCU's softirq handler.
+
+For CONFIG_RCU_FAST_NO_HZ kernels, the "last_accelerate:" prints the
+low-order 16 bits (in hex) of the jiffies counter when this CPU last
+invoked rcu_try_advance_all_cbs() from rcu_needs_cpu() or last invoked
+rcu_accelerate_cbs() from rcu_prepare_for_idle().  The "nonlazy_posted:"
+prints the number of non-lazy callbacks posted since the last call to
+rcu_needs_cpu().  Finally, an "L" indicates that there are currently
+no non-lazy callbacks ("." is printed otherwise, as shown above) and
+"D" indicates that dyntick-idle processing is enabled ("." is printed
+otherwise, for example, if disabled via the "nohz=" kernel boot parameter).
 
 
 Multiple Warnings From One Stall
diff --git a/Documentation/RCU/whatisRCU.txt b/Documentation/RCU/whatisRCU.txt
index 0cc7820..10df0b8 100644
--- a/Documentation/RCU/whatisRCU.txt
+++ b/Documentation/RCU/whatisRCU.txt
@@ -265,9 +265,9 @@ rcu_dereference()
 		rcu_read_lock();
 		p = rcu_dereference(head.next);
 		rcu_read_unlock();
-		x = p->address;
+		x = p->address;	/* BUG!!! */
 		rcu_read_lock();
-		y = p->data;
+		y = p->data;	/* BUG!!! */
 		rcu_read_unlock();
 
 	Holding a reference from one RCU read-side critical section
diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 4609e81..22303b2 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -2461,9 +2461,12 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 			In kernels built with CONFIG_RCU_NOCB_CPU=y, set
 			the specified list of CPUs to be no-callback CPUs.
 			Invocation of these CPUs' RCU callbacks will
-			be offloaded to "rcuoN" kthreads created for
-			that purpose.  This reduces OS jitter on the
+			be offloaded to "rcuox/N" kthreads created for
+			that purpose, where "x" is "b" for RCU-bh, "p"
+			for RCU-preempt, and "s" for RCU-sched, and "N"
+			is the CPU number.  This reduces OS jitter on the
 			offloaded CPUs, which can be useful for HPC and
+
 			real-time workloads.  It can also improve energy
 			efficiency for asymmetric multiprocessors.
 
@@ -2487,6 +2490,17 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 			leaf rcu_node structure.  Useful for very large
 			systems.
 
+	rcutree.jiffies_till_first_fqs= [KNL,BOOT]
+			Set delay from grace-period initialization to
+			first attempt to force quiescent states.
+			Units are jiffies, minimum value is zero,
+			and maximum value is HZ.
+
+	rcutree.jiffies_till_next_fqs= [KNL,BOOT]
+			Set delay between subsequent attempts to force
+			quiescent states.  Units are jiffies, minimum
+			value is one, and maximum value is HZ.
+
 	rcutree.qhimark=	[KNL,BOOT]
 			Set threshold of queued
 			RCU callbacks over which batch limiting is disabled.
@@ -2501,16 +2515,15 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 	rcutree.rcu_cpu_stall_timeout= [KNL,BOOT]
 			Set timeout for RCU CPU stall warning messages.
 
-	rcutree.jiffies_till_first_fqs= [KNL,BOOT]
-			Set delay from grace-period initialization to
-			first attempt to force quiescent states.
-			Units are jiffies, minimum value is zero,
-			and maximum value is HZ.
+	rcutree.rcu_idle_gp_delay=	[KNL,BOOT]
+			Set wakeup interval for idle CPUs that have
+			RCU callbacks (RCU_FAST_NO_HZ=y).
 
-	rcutree.jiffies_till_next_fqs= [KNL,BOOT]
-			Set delay between subsequent attempts to force
-			quiescent states.  Units are jiffies, minimum
-			value is one, and maximum value is HZ.
+	rcutree.rcu_idle_lazy_gp_delay=	[KNL,BOOT]
+			Set wakeup interval for idle CPUs that have
+			only "lazy" RCU callbacks (RCU_FAST_NO_HZ=y).
+			Lazy RCU callbacks are those which RCU can
+			prove do nothing more than free memory.
 
 	rcutorture.fqs_duration= [KNL,BOOT]
 			Set duration of force_quiescent_state bursts.
diff --git a/include/linux/list_bl.h b/include/linux/list_bl.h
index 31f9d75..2eb8855 100644
--- a/include/linux/list_bl.h
+++ b/include/linux/list_bl.h
@@ -125,6 +125,11 @@ static inline void hlist_bl_unlock(struct hlist_bl_head *b)
 	__bit_spin_unlock(0, (unsigned long *)b);
 }
 
+static inline bool hlist_bl_is_locked(struct hlist_bl_head *b)
+{
+	return bit_spin_is_locked(0, (unsigned long *)b);
+}
+
 /**
  * hlist_bl_for_each_entry	- iterate over list of given type
  * @tpos:	the type * to use as a loop cursor.
diff --git a/include/linux/rculist_bl.h b/include/linux/rculist_bl.h
index cf1244f..4f216c5 100644
--- a/include/linux/rculist_bl.h
+++ b/include/linux/rculist_bl.h
@@ -20,7 +20,7 @@ static inline void hlist_bl_set_first_rcu(struct hlist_bl_head *h,
 static inline struct hlist_bl_node *hlist_bl_first_rcu(struct hlist_bl_head *h)
 {
 	return (struct hlist_bl_node *)
-		((unsigned long)rcu_dereference(h->first) & ~LIST_BL_LOCKMASK);
+		((unsigned long)rcu_dereference_check(h->first, hlist_bl_is_locked(h)) & ~LIST_BL_LOCKMASK);
 }
 
 /**
diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index b758ce1..9ed2c9a 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -80,6 +80,7 @@ extern void do_trace_rcu_torture_read(char *rcutorturename,
 #define UINT_CMP_LT(a, b)	(UINT_MAX / 2 < (a) - (b))
 #define ULONG_CMP_GE(a, b)	(ULONG_MAX / 2 >= (a) - (b))
 #define ULONG_CMP_LT(a, b)	(ULONG_MAX / 2 < (a) - (b))
+#define ulong2long(a)		(*(long *)(&(a)))
 
 /* Exported common interfaces */
 
diff --git a/include/trace/events/rcu.h b/include/trace/events/rcu.h
index 1918e83..59ebcc8 100644
--- a/include/trace/events/rcu.h
+++ b/include/trace/events/rcu.h
@@ -72,6 +72,58 @@ TRACE_EVENT(rcu_grace_period,
 );
 
 /*
+ * Tracepoint for future grace-period events, including those for no-callbacks
+ * CPUs.  The caller should pull the data from the rcu_node structure,
+ * other than rcuname, which comes from the rcu_state structure, and event,
+ * which is one of the following:
+ *
+ * "Startleaf": Request a nocb grace period based on leaf-node data.
+ * "Startedleaf": Leaf-node start proved sufficient.
+ * "Startedleafroot": Leaf-node start proved sufficient after checking root.
+ * "Startedroot": Requested a nocb grace period based on root-node data.
+ * "StartWait": Start waiting for the requested grace period.
+ * "ResumeWait": Resume waiting after signal.
+ * "EndWait": Complete wait.
+ * "Cleanup": Clean up rcu_node structure after previous GP.
+ * "CleanupMore": Clean up, and another no-CB GP is needed.
+ */
+TRACE_EVENT(rcu_future_grace_period,
+
+	TP_PROTO(char *rcuname, unsigned long gpnum, unsigned long completed,
+		 unsigned long c, u8 level, int grplo, int grphi,
+		 char *gpevent),
+
+	TP_ARGS(rcuname, gpnum, completed, c, level, grplo, grphi, gpevent),
+
+	TP_STRUCT__entry(
+		__field(char *, rcuname)
+		__field(unsigned long, gpnum)
+		__field(unsigned long, completed)
+		__field(unsigned long, c)
+		__field(u8, level)
+		__field(int, grplo)
+		__field(int, grphi)
+		__field(char *, gpevent)
+	),
+
+	TP_fast_assign(
+		__entry->rcuname = rcuname;
+		__entry->gpnum = gpnum;
+		__entry->completed = completed;
+		__entry->c = c;
+		__entry->level = level;
+		__entry->grplo = grplo;
+		__entry->grphi = grphi;
+		__entry->gpevent = gpevent;
+	),
+
+	TP_printk("%s %lu %lu %lu %u %d %d %s",
+		  __entry->rcuname, __entry->gpnum, __entry->completed,
+		  __entry->c, __entry->level, __entry->grplo, __entry->grphi,
+		  __entry->gpevent)
+);
+
+/*
  * Tracepoint for grace-period-initialization events.  These are
  * distinguished by the type of RCU, the new grace-period number, the
  * rcu_node structure level, the starting and ending CPU covered by the
@@ -601,6 +653,9 @@ TRACE_EVENT(rcu_barrier,
 #define trace_rcu_grace_period(rcuname, gpnum, gpevent) do { } while (0)
 #define trace_rcu_grace_period_init(rcuname, gpnum, level, grplo, grphi, \
 				    qsmask) do { } while (0)
+#define trace_rcu_future_grace_period(rcuname, gpnum, completed, c, \
+				      level, grplo, grphi, event) \
+				      do { } while (0)
 #define trace_rcu_preempt_task(rcuname, pid, gpnum) do { } while (0)
 #define trace_rcu_unlock_preempted_task(rcuname, gpnum, pid) do { } while (0)
 #define trace_rcu_quiescent_state_report(rcuname, gpnum, mask, qsmask, level, \
diff --git a/init/Kconfig b/init/Kconfig
index 5341d72..71bb9e7 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -578,13 +578,16 @@ config RCU_FAST_NO_HZ
 	depends on NO_HZ && SMP
 	default n
 	help
-	  This option causes RCU to attempt to accelerate grace periods in
-	  order to allow CPUs to enter dynticks-idle state more quickly.
-	  On the other hand, this option increases the overhead of the
-	  dynticks-idle checking, thus degrading scheduling latency.
+	  This option permits CPUs to enter dynticks-idle state even if
+	  they have RCU callbacks queued, and prevents RCU from waking
+	  these CPUs up more than roughly once every four jiffies (by
+	  default, you can adjust this using the rcutree.rcu_idle_gp_delay
+	  parameter), thus improving energy efficiency.  On the other
+	  hand, this option increases the duration of RCU grace periods,
+	  for example, slowing down synchronize_rcu().
 
-	  Say Y if energy efficiency is critically important, and you don't
-	  	care about real-time response.
+	  Say Y if energy efficiency is critically important, and you
+	  	don't care about increased grace-period durations.
 
 	  Say N if you are unsure.
 
@@ -651,7 +654,7 @@ config RCU_BOOST_DELAY
 	  Accept the default if unsure.
 
 config RCU_NOCB_CPU
-	bool "Offload RCU callback processing from boot-selected CPUs"
+	bool "Offload RCU callback processing from boot-selected CPUs (EXPERIMENTAL"
 	depends on TREE_RCU || TREE_PREEMPT_RCU
 	default n
 	help
@@ -662,16 +665,56 @@ config RCU_NOCB_CPU
 
 	  This option offloads callback invocation from the set of
 	  CPUs specified at boot time by the rcu_nocbs parameter.
-	  For each such CPU, a kthread ("rcuoN") will be created to
-	  invoke callbacks, where the "N" is the CPU being offloaded.
-	  Nothing prevents this kthread from running on the specified
-	  CPUs, but (1) the kthreads may be preempted between each
-	  callback, and (2) affinity or cgroups can be used to force
-	  the kthreads to run on whatever set of CPUs is desired.
-
-	  Say Y here if you want reduced OS jitter on selected CPUs.
+	  For each such CPU, a kthread ("rcuox/N") will be created to
+	  invoke callbacks, where the "N" is the CPU being offloaded,
+	  and where the "x" is "b" for RCU-bh, "p" for RCU-preempt, and
+	  "s" for RCU-sched.  Nothing prevents this kthread from running
+	  on the specified CPUs, but (1) the kthreads may be preempted
+	  between each callback, and (2) affinity or cgroups can be used
+	  to force the kthreads to run on whatever set of CPUs is desired.
+
+	  Say Y here if you want to help to debug reduced OS jitter.
 	  Say N here if you are unsure.
 
+choice
+	prompt "Build-forced no-CBs CPUs"
+	default RCU_NOCB_CPU_NONE
+	help
+	  This option allows no-CBs CPUs to be specified at build time.
+	  Additional no-CBs CPUs may be specified by the rcu_nocbs=
+	  boot parameter.
+
+config RCU_NOCB_CPU_NONE
+	bool "No build_forced no-CBs CPUs"
+	depends on RCU_NOCB_CPU
+	help
+	  This option does not force any of the CPUs to be no-CBs CPUs.
+	  Only CPUs designated by the rcu_nocbs= boot parameter will be
+	  no-CBs CPUs.
+
+config RCU_NOCB_CPU_ZERO
+	bool "CPU 0 is a build_forced no-CBs CPU"
+	depends on RCU_NOCB_CPU
+	help
+	  This option forces CPU 0 to be a no-CBs CPU.  Additional CPUs
+	  may be designated as no-CBs CPUs using the rcu_nocbs= boot
+	  parameter will be no-CBs CPUs.
+
+	  Select this if CPU 0 needs to be a no-CBs CPU for real-time
+	  or energy-efficiency reasons.
+
+config RCU_NOCB_CPU_ALL
+	bool "All CPUs are build_forced no-CBs CPUs"
+	depends on RCU_NOCB_CPU
+	help
+	  This option forces all CPUs to be no-CBs CPUs.  The rcu_nocbs=
+	  boot parameter will be ignored.
+
+	  Select this if all CPUs need to be no-CBs CPUs for real-time
+	  or energy-efficiency reasons.
+
+endchoice
+
 endmenu # "RCU Subsystem"
 
 config IKCONFIG
diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index 5b8ad82..2d5f94c 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -64,7 +64,7 @@
 static struct lock_class_key rcu_node_class[RCU_NUM_LVLS];
 static struct lock_class_key rcu_fqs_class[RCU_NUM_LVLS];
 
-#define RCU_STATE_INITIALIZER(sname, cr) { \
+#define RCU_STATE_INITIALIZER(sname, sabbr, cr) { \
 	.level = { &sname##_state.node[0] }, \
 	.call = cr, \
 	.fqs_state = RCU_GP_IDLE, \
@@ -76,13 +76,14 @@ static struct lock_class_key rcu_fqs_class[RCU_NUM_LVLS];
 	.barrier_mutex = __MUTEX_INITIALIZER(sname##_state.barrier_mutex), \
 	.onoff_mutex = __MUTEX_INITIALIZER(sname##_state.onoff_mutex), \
 	.name = #sname, \
+	.abbr = sabbr, \
 }
 
 struct rcu_state rcu_sched_state =
-	RCU_STATE_INITIALIZER(rcu_sched, call_rcu_sched);
+	RCU_STATE_INITIALIZER(rcu_sched, 's', call_rcu_sched);
 DEFINE_PER_CPU(struct rcu_data, rcu_sched_data);
 
-struct rcu_state rcu_bh_state = RCU_STATE_INITIALIZER(rcu_bh, call_rcu_bh);
+struct rcu_state rcu_bh_state = RCU_STATE_INITIALIZER(rcu_bh, 'b', call_rcu_bh);
 DEFINE_PER_CPU(struct rcu_data, rcu_bh_data);
 
 static struct rcu_state *rcu_state;
@@ -223,6 +224,8 @@ static ulong jiffies_till_next_fqs = RCU_JIFFIES_TILL_FORCE_QS;
 module_param(jiffies_till_first_fqs, ulong, 0644);
 module_param(jiffies_till_next_fqs, ulong, 0644);
 
+static void rcu_start_gp_advanced(struct rcu_state *rsp, struct rcu_node *rnp,
+				  struct rcu_data *rdp);
 static void force_qs_rnp(struct rcu_state *rsp, int (*f)(struct rcu_data *));
 static void force_quiescent_state(struct rcu_state *rsp);
 static int rcu_pending(int cpu);
@@ -310,6 +313,8 @@ cpu_needs_another_gp(struct rcu_state *rsp, struct rcu_data *rdp)
 
 	if (rcu_gp_in_progress(rsp))
 		return 0;  /* No, a grace period is already in progress. */
+	if (rcu_nocb_needs_gp(rsp))
+		return 1;  /* Yes, a no-CBs CPU needs one. */
 	if (!rdp->nxttail[RCU_NEXT_TAIL])
 		return 0;  /* No, this is a no-CBs (or offline) CPU. */
 	if (*rdp->nxttail[RCU_NEXT_READY_TAIL])
@@ -1035,10 +1040,11 @@ static void init_callback_list(struct rcu_data *rdp)
 {
 	int i;
 
+	if (init_nocb_callback_list(rdp))
+		return;
 	rdp->nxtlist = NULL;
 	for (i = 0; i < RCU_NEXT_SIZE; i++)
 		rdp->nxttail[i] = &rdp->nxtlist;
-	init_nocb_callback_list(rdp);
 }
 
 /*
@@ -1071,6 +1077,120 @@ static unsigned long rcu_cbs_completed(struct rcu_state *rsp,
 }
 
 /*
+ * Trace-event helper function for rcu_start_future_gp() and
+ * rcu_nocb_wait_gp().
+ */
+static void trace_rcu_future_gp(struct rcu_node *rnp, struct rcu_data *rdp,
+				unsigned long c, char *s)
+{
+	trace_rcu_future_grace_period(rdp->rsp->name, rnp->gpnum,
+				      rnp->completed, c, rnp->level,
+				      rnp->grplo, rnp->grphi, s);
+}
+
+/*
+ * Start some future grace period, as needed to handle newly arrived
+ * callbacks.  The required future grace periods are recorded in each
+ * rcu_node structure's ->need_future_gp field.
+ *
+ * The caller must hold the specified rcu_node structure's ->lock.
+ */
+static unsigned long __maybe_unused
+rcu_start_future_gp(struct rcu_node *rnp, struct rcu_data *rdp)
+{
+	unsigned long c;
+	int i;
+	struct rcu_node *rnp_root = rcu_get_root(rdp->rsp);
+
+	/*
+	 * Pick up grace-period number for new callbacks.  If this
+	 * grace period is already marked as needed, return to the caller.
+	 */
+	c = rcu_cbs_completed(rdp->rsp, rnp);
+	trace_rcu_future_gp(rnp, rdp, c, "Startleaf");
+	if (rnp->need_future_gp[c & 0x1]) {
+		trace_rcu_future_gp(rnp, rdp, c, "Prestartleaf");
+		return c;
+	}
+
+	/*
+	 * If either this rcu_node structure or the root rcu_node structure
+	 * believe that a grace period is in progress, then we must wait
+	 * for the one following, which is in "c".  Because our request
+	 * will be noticed at the end of the current grace period, we don't
+	 * need to explicitly start one.
+	 */
+	if (rnp->gpnum != rnp->completed ||
+	    ACCESS_ONCE(rnp->gpnum) != ACCESS_ONCE(rnp->completed)) {
+		rnp->need_future_gp[c & 0x1]++;
+		trace_rcu_future_gp(rnp, rdp, c, "Startedleaf");
+		return c;
+	}
+
+	/*
+	 * There might be no grace period in progress.  If we don't already
+	 * hold it, acquire the root rcu_node structure's lock in order to
+	 * start one (if needed).
+	 */
+	if (rnp != rnp_root)
+		raw_spin_lock(&rnp_root->lock);
+
+	/*
+	 * Get a new grace-period number.  If there really is no grace
+	 * period in progress, it will be smaller than the one we obtained
+	 * earlier.  Adjust callbacks as needed.  Note that even no-CBs
+	 * CPUs have a ->nxtcompleted[] array, so no no-CBs checks needed.
+	 */
+	c = rcu_cbs_completed(rdp->rsp, rnp_root);
+	for (i = RCU_DONE_TAIL; i < RCU_NEXT_TAIL; i++)
+		if (ULONG_CMP_LT(c, rdp->nxtcompleted[i]))
+			rdp->nxtcompleted[i] = c;
+
+	/*
+	 * If the needed for the required grace period is already
+	 * recorded, trace and leave.
+	 */
+	if (rnp_root->need_future_gp[c & 0x1]) {
+		trace_rcu_future_gp(rnp, rdp, c, "Prestartedroot");
+		goto unlock_out;
+	}
+
+	/* Record the need for the future grace period. */
+	rnp_root->need_future_gp[c & 0x1]++;
+
+	/* If a grace period is not already in progress, start one. */
+	if (rnp_root->gpnum != rnp_root->completed) {
+		trace_rcu_future_gp(rnp, rdp, c, "Startedleafroot");
+	} else {
+		trace_rcu_future_gp(rnp, rdp, c, "Startedroot");
+		rcu_start_gp_advanced(rdp->rsp, rnp_root, rdp);
+	}
+unlock_out:
+	if (rnp != rnp_root)
+		raw_spin_unlock(&rnp_root->lock);
+	return c;
+}
+
+/*
+ * Clean up any old requests for the just-ended grace period.  Also return
+ * whether any additional grace periods have been requested.  Also invoke
+ * rcu_nocb_gp_cleanup() in order to wake up any no-callbacks kthreads
+ * waiting for this grace period to complete.
+ */
+static int rcu_future_gp_cleanup(struct rcu_state *rsp, struct rcu_node *rnp)
+{
+	int c = rnp->completed;
+	int needmore;
+	struct rcu_data *rdp = this_cpu_ptr(rsp->rda);
+
+	rcu_nocb_gp_cleanup(rsp, rnp);
+	rnp->need_future_gp[c & 0x1] = 0;
+	needmore = rnp->need_future_gp[(c + 1) & 0x1];
+	trace_rcu_future_gp(rnp, rdp, c, needmore ? "CleanupMore" : "Cleanup");
+	return needmore;
+}
+
+/*
  * If there is room, assign a ->completed number to any callbacks on
  * this CPU that have not already been assigned.  Also accelerate any
  * callbacks that were previously assigned a ->completed number that has
@@ -1129,6 +1249,8 @@ static void rcu_accelerate_cbs(struct rcu_state *rsp, struct rcu_node *rnp,
 		rdp->nxttail[i] = rdp->nxttail[RCU_NEXT_TAIL];
 		rdp->nxtcompleted[i] = c;
 	}
+	/* Record any needed additional grace periods. */
+	rcu_start_future_gp(rnp, rdp);
 
 	/* Trace depending on how much we were able to accelerate. */
 	if (!*rdp->nxttail[RCU_WAIT_TAIL])
@@ -1308,9 +1430,9 @@ static int rcu_gp_init(struct rcu_state *rsp)
 		rdp = this_cpu_ptr(rsp->rda);
 		rcu_preempt_check_blocked_tasks(rnp);
 		rnp->qsmask = rnp->qsmaskinit;
-		rnp->gpnum = rsp->gpnum;
+		ACCESS_ONCE(rnp->gpnum) = rsp->gpnum;
 		WARN_ON_ONCE(rnp->completed != rsp->completed);
-		rnp->completed = rsp->completed;
+		ACCESS_ONCE(rnp->completed) = rsp->completed;
 		if (rnp == rdp->mynode)
 			rcu_start_gp_per_cpu(rsp, rnp, rdp);
 		rcu_preempt_boost_start_gp(rnp);
@@ -1319,7 +1441,8 @@ static int rcu_gp_init(struct rcu_state *rsp)
 					    rnp->grphi, rnp->qsmask);
 		raw_spin_unlock_irq(&rnp->lock);
 #ifdef CONFIG_PROVE_RCU_DELAY
-		if ((random32() % (rcu_num_nodes * 8)) == 0)
+		if ((random32() % (rcu_num_nodes * 8)) == 0 &&
+		    system_state == SYSTEM_RUNNING)
 			schedule_timeout_uninterruptible(2);
 #endif /* #ifdef CONFIG_PROVE_RCU_DELAY */
 		cond_resched();
@@ -1361,6 +1484,7 @@ int rcu_gp_fqs(struct rcu_state *rsp, int fqs_state_in)
 static void rcu_gp_cleanup(struct rcu_state *rsp)
 {
 	unsigned long gp_duration;
+	int nocb = 0;
 	struct rcu_data *rdp;
 	struct rcu_node *rnp = rcu_get_root(rsp);
 
@@ -1390,17 +1514,23 @@ static void rcu_gp_cleanup(struct rcu_state *rsp)
 	 */
 	rcu_for_each_node_breadth_first(rsp, rnp) {
 		raw_spin_lock_irq(&rnp->lock);
-		rnp->completed = rsp->gpnum;
+		ACCESS_ONCE(rnp->completed) = rsp->gpnum;
+		rdp = this_cpu_ptr(rsp->rda);
+		if (rnp == rdp->mynode)
+			__rcu_process_gp_end(rsp, rnp, rdp);
+		nocb += rcu_future_gp_cleanup(rsp, rnp);
 		raw_spin_unlock_irq(&rnp->lock);
 		cond_resched();
 	}
 	rnp = rcu_get_root(rsp);
 	raw_spin_lock_irq(&rnp->lock);
+	rcu_nocb_gp_set(rnp, nocb);
 
 	rsp->completed = rsp->gpnum; /* Declare grace period done. */
 	trace_rcu_grace_period(rsp->name, rsp->completed, "end");
 	rsp->fqs_state = RCU_GP_IDLE;
 	rdp = this_cpu_ptr(rsp->rda);
+	rcu_advance_cbs(rsp, rnp, rdp);  /* Reduce false positives below. */
 	if (cpu_needs_another_gp(rsp, rdp))
 		rsp->gp_flags = 1;
 	raw_spin_unlock_irq(&rnp->lock);
@@ -1476,57 +1606,62 @@ static int __noreturn rcu_gp_kthread(void *arg)
 /*
  * Start a new RCU grace period if warranted, re-initializing the hierarchy
  * in preparation for detecting the next grace period.  The caller must hold
- * the root node's ->lock, which is released before return.  Hard irqs must
- * be disabled.
+ * the root node's ->lock and hard irqs must be disabled.
  *
  * Note that it is legal for a dying CPU (which is marked as offline) to
  * invoke this function.  This can happen when the dying CPU reports its
  * quiescent state.
  */
 static void
-rcu_start_gp(struct rcu_state *rsp, unsigned long flags)
-	__releases(rcu_get_root(rsp)->lock)
+rcu_start_gp_advanced(struct rcu_state *rsp, struct rcu_node *rnp,
+		      struct rcu_data *rdp)
 {
-	struct rcu_data *rdp = this_cpu_ptr(rsp->rda);
-	struct rcu_node *rnp = rcu_get_root(rsp);
-
-	if (!rsp->gp_kthread ||
-	    !cpu_needs_another_gp(rsp, rdp)) {
+	if (!rsp->gp_kthread || !cpu_needs_another_gp(rsp, rdp)) {
 		/*
 		 * Either we have not yet spawned the grace-period
 		 * task, this CPU does not need another grace period,
 		 * or a grace period is already in progress.
 		 * Either way, don't start a new grace period.
 		 */
-		raw_spin_unlock_irqrestore(&rnp->lock, flags);
 		return;
 	}
-
-	/*
-	 * Because there is no grace period in progress right now,
-	 * any callbacks we have up to this point will be satisfied
-	 * by the next grace period.  So this is a good place to
-	 * assign a grace period number to recently posted callbacks.
-	 */
-	rcu_accelerate_cbs(rsp, rnp, rdp);
-
 	rsp->gp_flags = RCU_GP_FLAG_INIT;
-	raw_spin_unlock(&rnp->lock); /* Interrupts remain disabled. */
-
-	/* Ensure that CPU is aware of completion of last grace period. */
-	rcu_process_gp_end(rsp, rdp);
-	local_irq_restore(flags);
 
 	/* Wake up rcu_gp_kthread() to start the grace period. */
 	wake_up(&rsp->gp_wq);
 }
 
 /*
+ * Similar to rcu_start_gp_advanced(), but also advance the calling CPU's
+ * callbacks.  Note that rcu_start_gp_advanced() cannot do this because it
+ * is invoked indirectly from rcu_advance_cbs(), which would result in
+ * endless recursion -- or would do so if it wasn't for the self-deadlock
+ * that is encountered beforehand.
+ */
+static void
+rcu_start_gp(struct rcu_state *rsp)
+{
+	struct rcu_data *rdp = this_cpu_ptr(rsp->rda);
+	struct rcu_node *rnp = rcu_get_root(rsp);
+
+	/*
+	 * If there is no grace period in progress right now, any
+	 * callbacks we have up to this point will be satisfied by the
+	 * next grace period.  Also, advancing the callbacks reduces the
+	 * probability of false positives from cpu_needs_another_gp()
+	 * resulting in pointless grace periods.  So, advance callbacks
+	 * then start the grace period!
+	 */
+	rcu_advance_cbs(rsp, rnp, rdp);
+	rcu_start_gp_advanced(rsp, rnp, rdp);
+}
+
+/*
  * Report a full set of quiescent states to the specified rcu_state
  * data structure.  This involves cleaning up after the prior grace
  * period and letting rcu_start_gp() start up the next grace period
- * if one is needed.  Note that the caller must hold rnp->lock, as
- * required by rcu_start_gp(), which will release it.
+ * if one is needed.  Note that the caller must hold rnp->lock, which
+ * is released before return.
  */
 static void rcu_report_qs_rsp(struct rcu_state *rsp, unsigned long flags)
 	__releases(rcu_get_root(rsp)->lock)
@@ -2124,7 +2259,8 @@ __rcu_process_callbacks(struct rcu_state *rsp)
 	local_irq_save(flags);
 	if (cpu_needs_another_gp(rsp, rdp)) {
 		raw_spin_lock(&rcu_get_root(rsp)->lock); /* irqs disabled. */
-		rcu_start_gp(rsp, flags);  /* releases above lock */
+		rcu_start_gp(rsp);
+		raw_spin_unlock_irqrestore(&rcu_get_root(rsp)->lock, flags);
 	} else {
 		local_irq_restore(flags);
 	}
@@ -2169,7 +2305,8 @@ static void invoke_rcu_callbacks(struct rcu_state *rsp, struct rcu_data *rdp)
 
 static void invoke_rcu_core(void)
 {
-	raise_softirq(RCU_SOFTIRQ);
+	if (cpu_online(smp_processor_id()))
+		raise_softirq(RCU_SOFTIRQ);
 }
 
 /*
@@ -2204,11 +2341,11 @@ static void __call_rcu_core(struct rcu_state *rsp, struct rcu_data *rdp,
 
 		/* Start a new grace period if one not already started. */
 		if (!rcu_gp_in_progress(rsp)) {
-			unsigned long nestflag;
 			struct rcu_node *rnp_root = rcu_get_root(rsp);
 
-			raw_spin_lock_irqsave(&rnp_root->lock, nestflag);
-			rcu_start_gp(rsp, nestflag);  /* rlses rnp_root->lock */
+			raw_spin_lock(&rnp_root->lock);
+			rcu_start_gp(rsp);
+			raw_spin_unlock(&rnp_root->lock);
 		} else {
 			/* Give the grace period a kick. */
 			rdp->blimit = LONG_MAX;
@@ -2628,19 +2765,27 @@ static int rcu_pending(int cpu)
 }
 
 /*
- * Check to see if any future RCU-related work will need to be done
- * by the current CPU, even if none need be done immediately, returning
- * 1 if so.
+ * Return true if the specified CPU has any callback.  If all_lazy is
+ * non-NULL, store an indication of whether all callbacks are lazy.
+ * (If there are no callbacks, all of them are deemed to be lazy.)
  */
-static int rcu_cpu_has_callbacks(int cpu)
+static int rcu_cpu_has_callbacks(int cpu, bool *all_lazy)
 {
+	bool al = true;
+	bool hc = false;
+	struct rcu_data *rdp;
 	struct rcu_state *rsp;
 
-	/* RCU callbacks either ready or pending? */
-	for_each_rcu_flavor(rsp)
-		if (per_cpu_ptr(rsp->rda, cpu)->nxtlist)
-			return 1;
-	return 0;
+	for_each_rcu_flavor(rsp) {
+		rdp = per_cpu_ptr(rsp->rda, cpu);
+		if (rdp->qlen != rdp->qlen_lazy)
+			al = false;
+		if (rdp->nxtlist)
+			hc = true;
+	}
+	if (all_lazy)
+		*all_lazy = al;
+	return hc;
 }
 
 /*
@@ -2859,7 +3004,6 @@ rcu_init_percpu_data(int cpu, struct rcu_state *rsp, int preemptible)
 	rdp->dynticks->dynticks_nesting = DYNTICK_TASK_EXIT_IDLE;
 	atomic_set(&rdp->dynticks->dynticks,
 		   (atomic_read(&rdp->dynticks->dynticks) & ~0x1) + 1);
-	rcu_prepare_for_idle_init(cpu);
 	raw_spin_unlock(&rnp->lock);		/* irqs remain disabled. */
 
 	/* Add CPU to rcu_node bitmasks. */
@@ -2909,7 +3053,6 @@ static int __cpuinit rcu_cpu_notify(struct notifier_block *self,
 	struct rcu_data *rdp = per_cpu_ptr(rcu_state->rda, cpu);
 	struct rcu_node *rnp = rdp->mynode;
 	struct rcu_state *rsp;
-	int ret = NOTIFY_OK;
 
 	trace_rcu_utilization("Start CPU hotplug");
 	switch (action) {
@@ -2923,21 +3066,12 @@ static int __cpuinit rcu_cpu_notify(struct notifier_block *self,
 		rcu_boost_kthread_setaffinity(rnp, -1);
 		break;
 	case CPU_DOWN_PREPARE:
-		if (nocb_cpu_expendable(cpu))
-			rcu_boost_kthread_setaffinity(rnp, cpu);
-		else
-			ret = NOTIFY_BAD;
+		rcu_boost_kthread_setaffinity(rnp, cpu);
 		break;
 	case CPU_DYING:
 	case CPU_DYING_FROZEN:
-		/*
-		 * The whole machine is "stopped" except this CPU, so we can
-		 * touch any data without introducing corruption. We send the
-		 * dying CPU's callbacks to an arbitrarily chosen online CPU.
-		 */
 		for_each_rcu_flavor(rsp)
 			rcu_cleanup_dying_cpu(rsp);
-		rcu_cleanup_after_idle(cpu);
 		break;
 	case CPU_DEAD:
 	case CPU_DEAD_FROZEN:
@@ -2950,7 +3084,7 @@ static int __cpuinit rcu_cpu_notify(struct notifier_block *self,
 		break;
 	}
 	trace_rcu_utilization("End CPU hotplug");
-	return ret;
+	return NOTIFY_OK;
 }
 
 /*
@@ -3085,6 +3219,7 @@ static void __init rcu_init_one(struct rcu_state *rsp,
 			}
 			rnp->level = i;
 			INIT_LIST_HEAD(&rnp->blkd_tasks);
+			rcu_init_one_nocb(rnp);
 		}
 	}
 
@@ -3170,8 +3305,7 @@ void __init rcu_init(void)
 	rcu_init_one(&rcu_sched_state, &rcu_sched_data);
 	rcu_init_one(&rcu_bh_state, &rcu_bh_data);
 	__rcu_init_preempt();
-	rcu_init_nocb();
-	 open_softirq(RCU_SOFTIRQ, rcu_process_callbacks);
+	open_softirq(RCU_SOFTIRQ, rcu_process_callbacks);
 
 	/*
 	 * We don't need protection against CPU-hotplug here because
diff --git a/kernel/rcutree.h b/kernel/rcutree.h
index c896b50..14ee407 100644
--- a/kernel/rcutree.h
+++ b/kernel/rcutree.h
@@ -88,18 +88,13 @@ struct rcu_dynticks {
 	int dynticks_nmi_nesting;   /* Track NMI nesting level. */
 	atomic_t dynticks;	    /* Even value for idle, else odd. */
 #ifdef CONFIG_RCU_FAST_NO_HZ
-	int dyntick_drain;	    /* Prepare-for-idle state variable. */
-	unsigned long dyntick_holdoff;
-				    /* No retries for the jiffy of failure. */
-	struct timer_list idle_gp_timer;
-				    /* Wake up CPU sleeping with callbacks. */
-	unsigned long idle_gp_timer_expires;
-				    /* When to wake up CPU (for repost). */
-	bool idle_first_pass;	    /* First pass of attempt to go idle? */
+	bool all_lazy;		    /* Are all CPU's CBs lazy? */
 	unsigned long nonlazy_posted;
 				    /* # times non-lazy CBs posted to CPU. */
 	unsigned long nonlazy_posted_snap;
 				    /* idle-period nonlazy_posted snapshot. */
+	unsigned long last_accelerate;
+				    /* Last jiffy CBs were accelerated. */
 	int tick_nohz_enabled_snap; /* Previously seen value from sysfs. */
 #endif /* #ifdef CONFIG_RCU_FAST_NO_HZ */
 };
@@ -134,9 +129,6 @@ struct rcu_node {
 				/*  elements that need to drain to allow the */
 				/*  current expedited grace period to */
 				/*  complete (only for TREE_PREEMPT_RCU). */
-	atomic_t wakemask;	/* CPUs whose kthread needs to be awakened. */
-				/*  Since this has meaning only for leaf */
-				/*  rcu_node structures, 32 bits suffices. */
 	unsigned long qsmaskinit;
 				/* Per-GP initial value for qsmask & expmask. */
 	unsigned long grpmask;	/* Mask to apply to parent qsmask. */
@@ -196,6 +188,12 @@ struct rcu_node {
 				/* Refused to boost: not sure why, though. */
 				/*  This can happen due to race conditions. */
 #endif /* #ifdef CONFIG_RCU_BOOST */
+#ifdef CONFIG_RCU_NOCB_CPU
+	wait_queue_head_t nocb_gp_wq[2];
+				/* Place for rcu_nocb_kthread() to wait GP. */
+#endif /* #ifdef CONFIG_RCU_NOCB_CPU */
+	int need_future_gp[2];
+				/* Counts of upcoming no-CB GP requests. */
 	raw_spinlock_t fqslock ____cacheline_internodealigned_in_smp;
 } ____cacheline_internodealigned_in_smp;
 
@@ -328,6 +326,11 @@ struct rcu_data {
 	struct task_struct *nocb_kthread;
 #endif /* #ifdef CONFIG_RCU_NOCB_CPU */
 
+	/* 8) RCU CPU stall data. */
+#ifdef CONFIG_RCU_CPU_STALL_INFO
+	unsigned int softirq_snap;	/* Snapshot of softirq activity. */
+#endif /* #ifdef CONFIG_RCU_CPU_STALL_INFO */
+
 	int cpu;
 	struct rcu_state *rsp;
 };
@@ -375,12 +378,6 @@ struct rcu_state {
 	struct rcu_data __percpu *rda;		/* pointer of percu rcu_data. */
 	void (*call)(struct rcu_head *head,	/* call_rcu() flavor. */
 		     void (*func)(struct rcu_head *head));
-#ifdef CONFIG_RCU_NOCB_CPU
-	void (*call_remote)(struct rcu_head *head,
-		     void (*func)(struct rcu_head *head));
-						/* call_rcu() flavor, but for */
-						/*  placing on remote CPU. */
-#endif /* #ifdef CONFIG_RCU_NOCB_CPU */
 
 	/* The following fields are guarded by the root rcu_node's lock. */
 
@@ -443,6 +440,7 @@ struct rcu_state {
 	unsigned long gp_max;			/* Maximum GP duration in */
 						/*  jiffies. */
 	char *name;				/* Name of structure. */
+	char abbr;				/* Abbreviated name. */
 	struct list_head flavors;		/* List of RCU flavors. */
 };
 
@@ -520,7 +518,6 @@ static int __cpuinit rcu_spawn_one_boost_kthread(struct rcu_state *rsp,
 						 struct rcu_node *rnp);
 #endif /* #ifdef CONFIG_RCU_BOOST */
 static void __cpuinit rcu_prepare_kthreads(int cpu);
-static void rcu_prepare_for_idle_init(int cpu);
 static void rcu_cleanup_after_idle(int cpu);
 static void rcu_prepare_for_idle(int cpu);
 static void rcu_idle_count_callbacks_posted(void);
@@ -529,16 +526,18 @@ static void print_cpu_stall_info(struct rcu_state *rsp, int cpu);
 static void print_cpu_stall_info_end(void);
 static void zero_cpu_stall_ticks(struct rcu_data *rdp);
 static void increment_cpu_stall_ticks(void);
+static int rcu_nocb_needs_gp(struct rcu_state *rsp);
+static void rcu_nocb_gp_set(struct rcu_node *rnp, int nrq);
+static void rcu_nocb_gp_cleanup(struct rcu_state *rsp, struct rcu_node *rnp);
+static void rcu_init_one_nocb(struct rcu_node *rnp);
 static bool is_nocb_cpu(int cpu);
 static bool __call_rcu_nocb(struct rcu_data *rdp, struct rcu_head *rhp,
 			    bool lazy);
 static bool rcu_nocb_adopt_orphan_cbs(struct rcu_state *rsp,
 				      struct rcu_data *rdp);
-static bool nocb_cpu_expendable(int cpu);
 static void rcu_boot_init_nocb_percpu_data(struct rcu_data *rdp);
 static void rcu_spawn_nocb_kthreads(struct rcu_state *rsp);
-static void init_nocb_callback_list(struct rcu_data *rdp);
-static void __init rcu_init_nocb(void);
+static bool init_nocb_callback_list(struct rcu_data *rdp);
 
 #endif /* #ifndef RCU_TREE_NONCORE */
 
diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
index c1cc7e1..d084ae3 100644
--- a/kernel/rcutree_plugin.h
+++ b/kernel/rcutree_plugin.h
@@ -85,11 +85,21 @@ static void __init rcu_bootup_announce_oddness(void)
 	if (nr_cpu_ids != NR_CPUS)
 		printk(KERN_INFO "\tRCU restricting CPUs from NR_CPUS=%d to nr_cpu_ids=%d.\n", NR_CPUS, nr_cpu_ids);
 #ifdef CONFIG_RCU_NOCB_CPU
+#ifndef CONFIG_RCU_NOCB_CPU_NONE
+	if (!have_rcu_nocb_mask) {
+		alloc_bootmem_cpumask_var(&rcu_nocb_mask);
+		have_rcu_nocb_mask = true;
+	}
+#ifdef CONFIG_RCU_NOCB_CPU_ZERO
+	pr_info("\tExperimental no-CBs CPU 0\n");
+	cpumask_set_cpu(0, rcu_nocb_mask);
+#endif /* #ifdef CONFIG_RCU_NOCB_CPU_ZERO */
+#ifdef CONFIG_RCU_NOCB_CPU_ALL
+	pr_info("\tExperimental no-CBs for all CPUs\n");
+	cpumask_setall(rcu_nocb_mask);
+#endif /* #ifdef CONFIG_RCU_NOCB_CPU_ALL */
+#endif /* #ifndef CONFIG_RCU_NOCB_CPU_NONE */
 	if (have_rcu_nocb_mask) {
-		if (cpumask_test_cpu(0, rcu_nocb_mask)) {
-			cpumask_clear_cpu(0, rcu_nocb_mask);
-			pr_info("\tCPU 0: illegal no-CBs CPU (cleared).\n");
-		}
 		cpulist_scnprintf(nocb_buf, sizeof(nocb_buf), rcu_nocb_mask);
 		pr_info("\tExperimental no-CBs CPUs: %s.\n", nocb_buf);
 		if (rcu_nocb_poll)
@@ -101,7 +111,7 @@ static void __init rcu_bootup_announce_oddness(void)
 #ifdef CONFIG_TREE_PREEMPT_RCU
 
 struct rcu_state rcu_preempt_state =
-	RCU_STATE_INITIALIZER(rcu_preempt, call_rcu);
+	RCU_STATE_INITIALIZER(rcu_preempt, 'p', call_rcu);
 DEFINE_PER_CPU(struct rcu_data, rcu_preempt_data);
 static struct rcu_state *rcu_state = &rcu_preempt_state;
 
@@ -1533,14 +1543,7 @@ static void __cpuinit rcu_prepare_kthreads(int cpu)
 int rcu_needs_cpu(int cpu, unsigned long *delta_jiffies)
 {
 	*delta_jiffies = ULONG_MAX;
-	return rcu_cpu_has_callbacks(cpu);
-}
-
-/*
- * Because we do not have RCU_FAST_NO_HZ, don't bother initializing for it.
- */
-static void rcu_prepare_for_idle_init(int cpu)
-{
+	return rcu_cpu_has_callbacks(cpu, NULL);
 }
 
 /*
@@ -1577,16 +1580,6 @@ static void rcu_idle_count_callbacks_posted(void)
  *
  * The following three proprocessor symbols control this state machine:
  *
- * RCU_IDLE_FLUSHES gives the maximum number of times that we will attempt
- *	to satisfy RCU.  Beyond this point, it is better to incur a periodic
- *	scheduling-clock interrupt than to loop through the state machine
- *	at full power.
- * RCU_IDLE_OPT_FLUSHES gives the number of RCU_IDLE_FLUSHES that are
- *	optional if RCU does not need anything immediately from this
- *	CPU, even if this CPU still has RCU callbacks queued.  The first
- *	times through the state machine are mandatory: we need to give
- *	the state machine a chance to communicate a quiescent state
- *	to the RCU core.
  * RCU_IDLE_GP_DELAY gives the number of jiffies that a CPU is permitted
  *	to sleep in dyntick-idle mode with RCU callbacks pending.  This
  *	is sized to be roughly one RCU grace period.  Those energy-efficiency
@@ -1602,186 +1595,108 @@ static void rcu_idle_count_callbacks_posted(void)
  * adjustment, they can be converted into kernel config parameters, though
  * making the state machine smarter might be a better option.
  */
-#define RCU_IDLE_FLUSHES 5		/* Number of dyntick-idle tries. */
-#define RCU_IDLE_OPT_FLUSHES 3		/* Optional dyntick-idle tries. */
 #define RCU_IDLE_GP_DELAY 4		/* Roughly one grace period. */
 #define RCU_IDLE_LAZY_GP_DELAY (6 * HZ)	/* Roughly six seconds. */
 
-extern int tick_nohz_enabled;
-
-/*
- * Does the specified flavor of RCU have non-lazy callbacks pending on
- * the specified CPU?  Both RCU flavor and CPU are specified by the
- * rcu_data structure.
- */
-static bool __rcu_cpu_has_nonlazy_callbacks(struct rcu_data *rdp)
-{
-	return rdp->qlen != rdp->qlen_lazy;
-}
+static int rcu_idle_gp_delay = RCU_IDLE_GP_DELAY;
+module_param(rcu_idle_gp_delay, int, 0644);
+static int rcu_idle_lazy_gp_delay = RCU_IDLE_LAZY_GP_DELAY;
+module_param(rcu_idle_lazy_gp_delay, int, 0644);
 
-#ifdef CONFIG_TREE_PREEMPT_RCU
+extern int tick_nohz_enabled;
 
 /*
- * Are there non-lazy RCU-preempt callbacks?  (There cannot be if there
- * is no RCU-preempt in the kernel.)
+ * Try to advance callbacks for all flavors of RCU on the current CPU.
+ * Afterwards, if there are any callbacks ready for immediate invocation,
+ * return true.
  */
-static bool rcu_preempt_cpu_has_nonlazy_callbacks(int cpu)
+static bool rcu_try_advance_all_cbs(void)
 {
-	struct rcu_data *rdp = &per_cpu(rcu_preempt_data, cpu);
-
-	return __rcu_cpu_has_nonlazy_callbacks(rdp);
-}
-
-#else /* #ifdef CONFIG_TREE_PREEMPT_RCU */
+	bool cbs_ready = false;
+	struct rcu_data *rdp;
+	struct rcu_node *rnp;
+	struct rcu_state *rsp;
 
-static bool rcu_preempt_cpu_has_nonlazy_callbacks(int cpu)
-{
-	return 0;
-}
+	for_each_rcu_flavor(rsp) {
+		rdp = this_cpu_ptr(rsp->rda);
+		rnp = rdp->mynode;
 
-#endif /* else #ifdef CONFIG_TREE_PREEMPT_RCU */
+		/*
+		 * Don't bother checking unless a grace period has
+		 * completed since we last checked and there are
+		 * callbacks not yet ready to invoke.
+		 */
+		if (rdp->completed != rnp->completed &&
+		    rdp->nxttail[RCU_DONE_TAIL] != rdp->nxttail[RCU_NEXT_TAIL])
+			rcu_process_gp_end(rsp, rdp);
 
-/*
- * Does any flavor of RCU have non-lazy callbacks on the specified CPU?
- */
-static bool rcu_cpu_has_nonlazy_callbacks(int cpu)
-{
-	return __rcu_cpu_has_nonlazy_callbacks(&per_cpu(rcu_sched_data, cpu)) ||
-	       __rcu_cpu_has_nonlazy_callbacks(&per_cpu(rcu_bh_data, cpu)) ||
-	       rcu_preempt_cpu_has_nonlazy_callbacks(cpu);
+		if (cpu_has_callbacks_ready_to_invoke(rdp))
+			cbs_ready = true;
+	}
+	return cbs_ready;
 }
 
 /*
- * Allow the CPU to enter dyntick-idle mode if either: (1) There are no
- * callbacks on this CPU, (2) this CPU has not yet attempted to enter
- * dyntick-idle mode, or (3) this CPU is in the process of attempting to
- * enter dyntick-idle mode.  Otherwise, if we have recently tried and failed
- * to enter dyntick-idle mode, we refuse to try to enter it.  After all,
- * it is better to incur scheduling-clock interrupts than to spin
- * continuously for the same time duration!
+ * Allow the CPU to enter dyntick-idle mode unless it has callbacks ready
+ * to invoke.  If the CPU has callbacks, try to advance them.  Tell the
+ * caller to set the timeout based on whether or not there are non-lazy
+ * callbacks.
  *
- * The delta_jiffies argument is used to store the time when RCU is
- * going to need the CPU again if it still has callbacks.  The reason
- * for this is that rcu_prepare_for_idle() might need to post a timer,
- * but if so, it will do so after tick_nohz_stop_sched_tick() has set
- * the wakeup time for this CPU.  This means that RCU's timer can be
- * delayed until the wakeup time, which defeats the purpose of posting
- * a timer.
+ * The caller must have disabled interrupts.
  */
-int rcu_needs_cpu(int cpu, unsigned long *delta_jiffies)
+int rcu_needs_cpu(int cpu, unsigned long *dj)
 {
 	struct rcu_dynticks *rdtp = &per_cpu(rcu_dynticks, cpu);
 
-	/* Flag a new idle sojourn to the idle-entry state machine. */
-	rdtp->idle_first_pass = 1;
+	/* Snapshot to detect later posting of non-lazy callback. */
+	rdtp->nonlazy_posted_snap = rdtp->nonlazy_posted;
+
 	/* If no callbacks, RCU doesn't need the CPU. */
-	if (!rcu_cpu_has_callbacks(cpu)) {
-		*delta_jiffies = ULONG_MAX;
+	if (!rcu_cpu_has_callbacks(cpu, &rdtp->all_lazy)) {
+		*dj = ULONG_MAX;
 		return 0;
 	}
-	if (rdtp->dyntick_holdoff == jiffies) {
-		/* RCU recently tried and failed, so don't try again. */
-		*delta_jiffies = 1;
+
+	/* Attempt to advance callbacks. */
+	if (rcu_try_advance_all_cbs()) {
+		/* Some ready to invoke, so initiate later invocation. */
+		invoke_rcu_core();
 		return 1;
 	}
-	/* Set up for the possibility that RCU will post a timer. */
-	if (rcu_cpu_has_nonlazy_callbacks(cpu)) {
-		*delta_jiffies = round_up(RCU_IDLE_GP_DELAY + jiffies,
-					  RCU_IDLE_GP_DELAY) - jiffies;
+	rdtp->last_accelerate = jiffies;
+
+	/* Request timer delay depending on laziness, and round. */
+	if (rdtp->all_lazy) {
+		*dj = round_up(rcu_idle_gp_delay + jiffies,
+			       rcu_idle_gp_delay) - jiffies;
 	} else {
-		*delta_jiffies = jiffies + RCU_IDLE_LAZY_GP_DELAY;
-		*delta_jiffies = round_jiffies(*delta_jiffies) - jiffies;
+		*dj = round_jiffies(rcu_idle_lazy_gp_delay + jiffies) - jiffies;
 	}
 	return 0;
 }
 
 /*
- * Handler for smp_call_function_single().  The only point of this
- * handler is to wake the CPU up, so the handler does only tracing.
- */
-void rcu_idle_demigrate(void *unused)
-{
-	trace_rcu_prep_idle("Demigrate");
-}
-
-/*
- * Timer handler used to force CPU to start pushing its remaining RCU
- * callbacks in the case where it entered dyntick-idle mode with callbacks
- * pending.  The hander doesn't really need to do anything because the
- * real work is done upon re-entry to idle, or by the next scheduling-clock
- * interrupt should idle not be re-entered.
- *
- * One special case: the timer gets migrated without awakening the CPU
- * on which the timer was scheduled on.  In this case, we must wake up
- * that CPU.  We do so with smp_call_function_single().
- */
-static void rcu_idle_gp_timer_func(unsigned long cpu_in)
-{
-	int cpu = (int)cpu_in;
-
-	trace_rcu_prep_idle("Timer");
-	if (cpu != smp_processor_id())
-		smp_call_function_single(cpu, rcu_idle_demigrate, NULL, 0);
-	else
-		WARN_ON_ONCE(1); /* Getting here can hang the system... */
-}
-
-/*
- * Initialize the timer used to pull CPUs out of dyntick-idle mode.
- */
-static void rcu_prepare_for_idle_init(int cpu)
-{
-	struct rcu_dynticks *rdtp = &per_cpu(rcu_dynticks, cpu);
-
-	rdtp->dyntick_holdoff = jiffies - 1;
-	setup_timer(&rdtp->idle_gp_timer, rcu_idle_gp_timer_func, cpu);
-	rdtp->idle_gp_timer_expires = jiffies - 1;
-	rdtp->idle_first_pass = 1;
-}
-
-/*
- * Clean up for exit from idle.  Because we are exiting from idle, there
- * is no longer any point to ->idle_gp_timer, so cancel it.  This will
- * do nothing if this timer is not active, so just cancel it unconditionally.
- */
-static void rcu_cleanup_after_idle(int cpu)
-{
-	struct rcu_dynticks *rdtp = &per_cpu(rcu_dynticks, cpu);
-
-	del_timer(&rdtp->idle_gp_timer);
-	trace_rcu_prep_idle("Cleanup after idle");
-	rdtp->tick_nohz_enabled_snap = ACCESS_ONCE(tick_nohz_enabled);
-}
-
-/*
- * Check to see if any RCU-related work can be done by the current CPU,
- * and if so, schedule a softirq to get it done.  This function is part
- * of the RCU implementation; it is -not- an exported member of the RCU API.
- *
- * The idea is for the current CPU to clear out all work required by the
- * RCU core for the current grace period, so that this CPU can be permitted
- * to enter dyntick-idle mode.  In some cases, it will need to be awakened
- * at the end of the grace period by whatever CPU ends the grace period.
- * This allows CPUs to go dyntick-idle more quickly, and to reduce the
- * number of wakeups by a modest integer factor.
- *
- * Because it is not legal to invoke rcu_process_callbacks() with irqs
- * disabled, we do one pass of force_quiescent_state(), then do a
- * invoke_rcu_core() to cause rcu_process_callbacks() to be invoked
- * later.  The ->dyntick_drain field controls the sequencing.
+ * Prepare a CPU for idle from an RCU perspective.  The first major task
+ * is to sense whether nohz mode has been enabled or disabled via sysfs.
+ * The second major task is to check to see if a non-lazy callback has
+ * arrived at a CPU that previously had only lazy callbacks.  The third
+ * major task is to accelerate (that is, assign grace-period numbers to)
+ * any recently arrived callbacks.
  *
  * The caller must have disabled interrupts.
  */
 static void rcu_prepare_for_idle(int cpu)
 {
-	struct timer_list *tp;
+	struct rcu_data *rdp;
 	struct rcu_dynticks *rdtp = &per_cpu(rcu_dynticks, cpu);
+	struct rcu_node *rnp;
+	struct rcu_state *rsp;
 	int tne;
 
 	/* Handle nohz enablement switches conservatively. */
 	tne = ACCESS_ONCE(tick_nohz_enabled);
 	if (tne != rdtp->tick_nohz_enabled_snap) {
-		if (rcu_cpu_has_callbacks(cpu))
+		if (rcu_cpu_has_callbacks(cpu, NULL))
 			invoke_rcu_core(); /* force nohz to see update. */
 		rdtp->tick_nohz_enabled_snap = tne;
 		return;
@@ -1789,125 +1704,56 @@ static void rcu_prepare_for_idle(int cpu)
 	if (!tne)
 		return;
 
-	/* Adaptive-tick mode, where usermode execution is idle to RCU. */
-	if (!is_idle_task(current)) {
-		rdtp->dyntick_holdoff = jiffies - 1;
-		if (rcu_cpu_has_nonlazy_callbacks(cpu)) {
-			trace_rcu_prep_idle("User dyntick with callbacks");
-			rdtp->idle_gp_timer_expires =
-				round_up(jiffies + RCU_IDLE_GP_DELAY,
-					 RCU_IDLE_GP_DELAY);
-		} else if (rcu_cpu_has_callbacks(cpu)) {
-			rdtp->idle_gp_timer_expires =
-				round_jiffies(jiffies + RCU_IDLE_LAZY_GP_DELAY);
-			trace_rcu_prep_idle("User dyntick with lazy callbacks");
-		} else {
-			return;
-		}
-		tp = &rdtp->idle_gp_timer;
-		mod_timer_pinned(tp, rdtp->idle_gp_timer_expires);
+	/* If this is a no-CBs CPU, no callbacks, just return. */
+	if (is_nocb_cpu(cpu))
 		return;
-	}
 
 	/*
-	 * If this is an idle re-entry, for example, due to use of
-	 * RCU_NONIDLE() or the new idle-loop tracing API within the idle
-	 * loop, then don't take any state-machine actions, unless the
-	 * momentary exit from idle queued additional non-lazy callbacks.
-	 * Instead, repost the ->idle_gp_timer if this CPU has callbacks
-	 * pending.
+	 * If a non-lazy callback arrived at a CPU having only lazy
+	 * callbacks, invoke RCU core for the side-effect of recalculating
+	 * idle duration on re-entry to idle.
 	 */
-	if (!rdtp->idle_first_pass &&
-	    (rdtp->nonlazy_posted == rdtp->nonlazy_posted_snap)) {
-		if (rcu_cpu_has_callbacks(cpu)) {
-			tp = &rdtp->idle_gp_timer;
-			mod_timer_pinned(tp, rdtp->idle_gp_timer_expires);
-		}
+	if (rdtp->all_lazy &&
+	    rdtp->nonlazy_posted != rdtp->nonlazy_posted_snap) {
+		invoke_rcu_core();
 		return;
 	}
-	rdtp->idle_first_pass = 0;
-	rdtp->nonlazy_posted_snap = rdtp->nonlazy_posted - 1;
 
 	/*
-	 * If there are no callbacks on this CPU, enter dyntick-idle mode.
-	 * Also reset state to avoid prejudicing later attempts.
+	 * If we have not yet accelerated this jiffy, accelerate all
+	 * callbacks on this CPU.
 	 */
-	if (!rcu_cpu_has_callbacks(cpu)) {
-		rdtp->dyntick_holdoff = jiffies - 1;
-		rdtp->dyntick_drain = 0;
-		trace_rcu_prep_idle("No callbacks");
+	if (rdtp->last_accelerate == jiffies)
 		return;
+	rdtp->last_accelerate = jiffies;
+	for_each_rcu_flavor(rsp) {
+		rdp = per_cpu_ptr(rsp->rda, cpu);
+		if (!*rdp->nxttail[RCU_DONE_TAIL])
+			continue;
+		rnp = rdp->mynode;
+		raw_spin_lock(&rnp->lock); /* irqs already disabled. */
+		rcu_accelerate_cbs(rsp, rnp, rdp);
+		raw_spin_unlock(&rnp->lock); /* irqs remain disabled. */
 	}
+}
 
-	/*
-	 * If in holdoff mode, just return.  We will presumably have
-	 * refrained from disabling the scheduling-clock tick.
-	 */
-	if (rdtp->dyntick_holdoff == jiffies) {
-		trace_rcu_prep_idle("In holdoff");
-		return;
-	}
+/*
+ * Clean up for exit from idle.  Attempt to advance callbacks based on
+ * any grace periods that elapsed while the CPU was idle, and if any
+ * callbacks are now ready to invoke, initiate invocation.
+ */
+static void rcu_cleanup_after_idle(int cpu)
+{
+	struct rcu_data *rdp;
+	struct rcu_state *rsp;
 
-	/* Check and update the ->dyntick_drain sequencing. */
-	if (rdtp->dyntick_drain <= 0) {
-		/* First time through, initialize the counter. */
-		rdtp->dyntick_drain = RCU_IDLE_FLUSHES;
-	} else if (rdtp->dyntick_drain <= RCU_IDLE_OPT_FLUSHES &&
-		   !rcu_pending(cpu) &&
-		   !local_softirq_pending()) {
-		/* Can we go dyntick-idle despite still having callbacks? */
-		rdtp->dyntick_drain = 0;
-		rdtp->dyntick_holdoff = jiffies;
-		if (rcu_cpu_has_nonlazy_callbacks(cpu)) {
-			trace_rcu_prep_idle("Dyntick with callbacks");
-			rdtp->idle_gp_timer_expires =
-				round_up(jiffies + RCU_IDLE_GP_DELAY,
-					 RCU_IDLE_GP_DELAY);
-		} else {
-			rdtp->idle_gp_timer_expires =
-				round_jiffies(jiffies + RCU_IDLE_LAZY_GP_DELAY);
-			trace_rcu_prep_idle("Dyntick with lazy callbacks");
-		}
-		tp = &rdtp->idle_gp_timer;
-		mod_timer_pinned(tp, rdtp->idle_gp_timer_expires);
-		rdtp->nonlazy_posted_snap = rdtp->nonlazy_posted;
-		return; /* Nothing more to do immediately. */
-	} else if (--(rdtp->dyntick_drain) <= 0) {
-		/* We have hit the limit, so time to give up. */
-		rdtp->dyntick_holdoff = jiffies;
-		trace_rcu_prep_idle("Begin holdoff");
-		invoke_rcu_core();  /* Force the CPU out of dyntick-idle. */
+	if (is_nocb_cpu(cpu))
 		return;
-	}
-
-	/*
-	 * Do one step of pushing the remaining RCU callbacks through
-	 * the RCU core state machine.
-	 */
-#ifdef CONFIG_TREE_PREEMPT_RCU
-	if (per_cpu(rcu_preempt_data, cpu).nxtlist) {
-		rcu_preempt_qs(cpu);
-		force_quiescent_state(&rcu_preempt_state);
-	}
-#endif /* #ifdef CONFIG_TREE_PREEMPT_RCU */
-	if (per_cpu(rcu_sched_data, cpu).nxtlist) {
-		rcu_sched_qs(cpu);
-		force_quiescent_state(&rcu_sched_state);
-	}
-	if (per_cpu(rcu_bh_data, cpu).nxtlist) {
-		rcu_bh_qs(cpu);
-		force_quiescent_state(&rcu_bh_state);
-	}
-
-	/*
-	 * If RCU callbacks are still pending, RCU still needs this CPU.
-	 * So try forcing the callbacks through the grace period.
-	 */
-	if (rcu_cpu_has_callbacks(cpu)) {
-		trace_rcu_prep_idle("More callbacks");
-		invoke_rcu_core();
-	} else {
-		trace_rcu_prep_idle("Callbacks drained");
+	rcu_try_advance_all_cbs();
+	for_each_rcu_flavor(rsp) {
+		rdp = per_cpu_ptr(rsp->rda, cpu);
+		if (cpu_has_callbacks_ready_to_invoke(rdp))
+			invoke_rcu_core();
 	}
 }
 
@@ -2015,16 +1861,13 @@ early_initcall(rcu_register_oom_notifier);
 static void print_cpu_stall_fast_no_hz(char *cp, int cpu)
 {
 	struct rcu_dynticks *rdtp = &per_cpu(rcu_dynticks, cpu);
-	struct timer_list *tltp = &rdtp->idle_gp_timer;
-	char c;
+	unsigned long nlpd = rdtp->nonlazy_posted - rdtp->nonlazy_posted_snap;
 
-	c = rdtp->dyntick_holdoff == jiffies ? 'H' : '.';
-	if (timer_pending(tltp))
-		sprintf(cp, "drain=%d %c timer=%lu",
-			rdtp->dyntick_drain, c, tltp->expires - jiffies);
-	else
-		sprintf(cp, "drain=%d %c timer not pending",
-			rdtp->dyntick_drain, c);
+	sprintf(cp, "last_accelerate: %04lx/%04lx, nonlazy_posted: %ld, %c%c",
+		rdtp->last_accelerate & 0xffff, jiffies & 0xffff,
+		ulong2long(nlpd),
+		rdtp->all_lazy ? 'L' : '.',
+		rdtp->tick_nohz_enabled_snap ? '.' : 'D');
 }
 
 #else /* #ifdef CONFIG_RCU_FAST_NO_HZ */
@@ -2070,10 +1913,11 @@ static void print_cpu_stall_info(struct rcu_state *rsp, int cpu)
 		ticks_value = rsp->gpnum - rdp->gpnum;
 	}
 	print_cpu_stall_fast_no_hz(fast_no_hz, cpu);
-	printk(KERN_ERR "\t%d: (%lu %s) idle=%03x/%llx/%d %s\n",
+	printk(KERN_ERR "\t%d: (%lu %s) idle=%03x/%llx/%d softirq=%u/%u %s\n",
 	       cpu, ticks_value, ticks_title,
 	       atomic_read(&rdtp->dynticks) & 0xfff,
 	       rdtp->dynticks_nesting, rdtp->dynticks_nmi_nesting,
+	       rdp->softirq_snap, kstat_softirqs_cpu(RCU_SOFTIRQ, cpu),
 	       fast_no_hz);
 }
 
@@ -2087,6 +1931,7 @@ static void print_cpu_stall_info_end(void)
 static void zero_cpu_stall_ticks(struct rcu_data *rdp)
 {
 	rdp->ticks_this_gp = 0;
+	rdp->softirq_snap = kstat_softirqs_cpu(RCU_SOFTIRQ, smp_processor_id());
 }
 
 /* Increment ->ticks_this_gp for all flavors of RCU. */
@@ -2165,6 +2010,47 @@ static int __init parse_rcu_nocb_poll(char *arg)
 }
 early_param("rcu_nocb_poll", parse_rcu_nocb_poll);
 
+/*
+ * Do any no-CBs CPUs need another grace period?
+ *
+ * Interrupts must be disabled.  If the caller does not hold the root
+ * rnp_node structure's ->lock, the results are advisory only.
+ */
+static int rcu_nocb_needs_gp(struct rcu_state *rsp)
+{
+	struct rcu_node *rnp = rcu_get_root(rsp);
+
+	return rnp->need_future_gp[(ACCESS_ONCE(rnp->completed) + 1) & 0x1];
+}
+
+/*
+ * Wake up any no-CBs CPUs' kthreads that were waiting on the just-ended
+ * grace period.
+ */
+static void rcu_nocb_gp_cleanup(struct rcu_state *rsp, struct rcu_node *rnp)
+{
+	wake_up_all(&rnp->nocb_gp_wq[rnp->completed & 0x1]);
+}
+
+/*
+ * Set the root rcu_node structure's ->need_future_gp field
+ * based on the sum of those of all rcu_node structures.  This does
+ * double-count the root rcu_node structure's requests, but this
+ * is necessary to handle the possibility of a rcu_nocb_kthread()
+ * having awakened during the time that the rcu_node structures
+ * were being updated for the end of the previous grace period.
+ */
+static void rcu_nocb_gp_set(struct rcu_node *rnp, int nrq)
+{
+	rnp->need_future_gp[(rnp->completed + 1) & 0x1] += nrq;
+}
+
+static void rcu_init_one_nocb(struct rcu_node *rnp)
+{
+	init_waitqueue_head(&rnp->nocb_gp_wq[0]);
+	init_waitqueue_head(&rnp->nocb_gp_wq[1]);
+}
+
 /* Is the specified CPU a no-CPUs CPU? */
 static bool is_nocb_cpu(int cpu)
 {
@@ -2227,6 +2113,13 @@ static bool __call_rcu_nocb(struct rcu_data *rdp, struct rcu_head *rhp,
 	if (!is_nocb_cpu(rdp->cpu))
 		return 0;
 	__call_rcu_nocb_enqueue(rdp, rhp, &rhp->next, 1, lazy);
+	if (__is_kfree_rcu_offset((unsigned long)rhp->func))
+		trace_rcu_kfree_callback(rdp->rsp->name, rhp,
+					 (unsigned long)rhp->func,
+					 rdp->qlen_lazy, rdp->qlen);
+	else
+		trace_rcu_callback(rdp->rsp->name, rhp,
+				   rdp->qlen_lazy, rdp->qlen);
 	return 1;
 }
 
@@ -2265,95 +2158,36 @@ static bool __maybe_unused rcu_nocb_adopt_orphan_cbs(struct rcu_state *rsp,
 }
 
 /*
- * There must be at least one non-no-CBs CPU in operation at any given
- * time, because no-CBs CPUs are not capable of initiating grace periods
- * independently.  This function therefore complains if the specified
- * CPU is the last non-no-CBs CPU, allowing the CPU-hotplug system to
- * avoid offlining the last such CPU.  (Recursion is a wonderful thing,
- * but you have to have a base case!)
+ * If necessary, kick off a new grace period, and either way wait
+ * for a subsequent grace period to complete.
  */
-static bool nocb_cpu_expendable(int cpu)
+static void rcu_nocb_wait_gp(struct rcu_data *rdp)
 {
-	cpumask_var_t non_nocb_cpus;
-	int ret;
+	unsigned long c;
+	bool d;
+	unsigned long flags;
+	struct rcu_node *rnp = rdp->mynode;
+
+	raw_spin_lock_irqsave(&rnp->lock, flags);
+	c = rcu_start_future_gp(rnp, rdp);
+	raw_spin_unlock_irqrestore(&rnp->lock, flags);
 
 	/*
-	 * If there are no no-CB CPUs or if this CPU is not a no-CB CPU,
-	 * then offlining this CPU is harmless.  Let it happen.
+	 * Wait for the grace period.  Do so interruptibly to avoid messing
+	 * up the load average.
 	 */
-	if (!have_rcu_nocb_mask || is_nocb_cpu(cpu))
-		return 1;
-
-	/* If no memory, play it safe and keep the CPU around. */
-	if (!alloc_cpumask_var(&non_nocb_cpus, GFP_NOIO))
-		return 0;
-	cpumask_andnot(non_nocb_cpus, cpu_online_mask, rcu_nocb_mask);
-	cpumask_clear_cpu(cpu, non_nocb_cpus);
-	ret = !cpumask_empty(non_nocb_cpus);
-	free_cpumask_var(non_nocb_cpus);
-	return ret;
-}
-
-/*
- * Helper structure for remote registry of RCU callbacks.
- * This is needed for when a no-CBs CPU needs to start a grace period.
- * If it just invokes call_rcu(), the resulting callback will be queued,
- * which can result in deadlock.
- */
-struct rcu_head_remote {
-	struct rcu_head *rhp;
-	call_rcu_func_t *crf;
-	void (*func)(struct rcu_head *rhp);
-};
-
-/*
- * Register a callback as specified by the rcu_head_remote struct.
- * This function is intended to be invoked via smp_call_function_single().
- */
-static void call_rcu_local(void *arg)
-{
-	struct rcu_head_remote *rhrp =
-		container_of(arg, struct rcu_head_remote, rhp);
-
-	rhrp->crf(rhrp->rhp, rhrp->func);
-}
-
-/*
- * Set up an rcu_head_remote structure and the invoke call_rcu_local()
- * on CPU 0 (which is guaranteed to be a non-no-CBs CPU) via
- * smp_call_function_single().
- */
-static void invoke_crf_remote(struct rcu_head *rhp,
-			      void (*func)(struct rcu_head *rhp),
-			      call_rcu_func_t crf)
-{
-	struct rcu_head_remote rhr;
-
-	rhr.rhp = rhp;
-	rhr.crf = crf;
-	rhr.func = func;
-	smp_call_function_single(0, call_rcu_local, &rhr, 1);
-}
-
-/*
- * Helper functions to be passed to wait_rcu_gp(), each of which
- * invokes invoke_crf_remote() to register a callback appropriately.
- */
-static void __maybe_unused
-call_rcu_preempt_remote(struct rcu_head *rhp,
-			void (*func)(struct rcu_head *rhp))
-{
-	invoke_crf_remote(rhp, func, call_rcu);
-}
-static void call_rcu_bh_remote(struct rcu_head *rhp,
-			       void (*func)(struct rcu_head *rhp))
-{
-	invoke_crf_remote(rhp, func, call_rcu_bh);
-}
-static void call_rcu_sched_remote(struct rcu_head *rhp,
-				  void (*func)(struct rcu_head *rhp))
-{
-	invoke_crf_remote(rhp, func, call_rcu_sched);
+	trace_rcu_future_gp(rnp, rdp, c, "StartWait");
+	for (;;) {
+		wait_event_interruptible(
+			rnp->nocb_gp_wq[c & 0x1],
+			(d = ULONG_CMP_GE(ACCESS_ONCE(rnp->completed), c)));
+		if (likely(d))
+			break;
+		flush_signals(current);
+		trace_rcu_future_gp(rnp, rdp, c, "ResumeWait");
+	}
+	trace_rcu_future_gp(rnp, rdp, c, "EndWait");
+	smp_mb(); /* Ensure that CB invocation happens after GP end. */
 }
 
 /*
@@ -2390,7 +2224,7 @@ static int rcu_nocb_kthread(void *arg)
 		cl = atomic_long_xchg(&rdp->nocb_q_count_lazy, 0);
 		ACCESS_ONCE(rdp->nocb_p_count) += c;
 		ACCESS_ONCE(rdp->nocb_p_count_lazy) += cl;
-		wait_rcu_gp(rdp->rsp->call_remote);
+		rcu_nocb_wait_gp(rdp);
 
 		/* Each pass through the following loop invokes a callback. */
 		trace_rcu_batch_start(rdp->rsp->name, cl, c, -1);
@@ -2436,32 +2270,41 @@ static void __init rcu_spawn_nocb_kthreads(struct rcu_state *rsp)
 		return;
 	for_each_cpu(cpu, rcu_nocb_mask) {
 		rdp = per_cpu_ptr(rsp->rda, cpu);
-		t = kthread_run(rcu_nocb_kthread, rdp, "rcuo%d", cpu);
+		t = kthread_run(rcu_nocb_kthread, rdp,
+				"rcuo%c/%d", rsp->abbr, cpu);
 		BUG_ON(IS_ERR(t));
 		ACCESS_ONCE(rdp->nocb_kthread) = t;
 	}
 }
 
 /* Prevent __call_rcu() from enqueuing callbacks on no-CBs CPUs */
-static void init_nocb_callback_list(struct rcu_data *rdp)
+static bool init_nocb_callback_list(struct rcu_data *rdp)
 {
 	if (rcu_nocb_mask == NULL ||
 	    !cpumask_test_cpu(rdp->cpu, rcu_nocb_mask))
-		return;
+		return false;
 	rdp->nxttail[RCU_NEXT_TAIL] = NULL;
+	return true;
+}
+
+#else /* #ifdef CONFIG_RCU_NOCB_CPU */
+
+static int rcu_nocb_needs_gp(struct rcu_state *rsp)
+{
+	return 0;
 }
 
-/* Initialize the ->call_remote fields in the rcu_state structures. */
-static void __init rcu_init_nocb(void)
+static void rcu_nocb_gp_cleanup(struct rcu_state *rsp, struct rcu_node *rnp)
 {
-#ifdef CONFIG_PREEMPT_RCU
-	rcu_preempt_state.call_remote = call_rcu_preempt_remote;
-#endif /* #ifdef CONFIG_PREEMPT_RCU */
-	rcu_bh_state.call_remote = call_rcu_bh_remote;
-	rcu_sched_state.call_remote = call_rcu_sched_remote;
 }
 
-#else /* #ifdef CONFIG_RCU_NOCB_CPU */
+static void rcu_nocb_gp_set(struct rcu_node *rnp, int nrq)
+{
+}
+
+static void rcu_init_one_nocb(struct rcu_node *rnp)
+{
+}
 
 static bool is_nocb_cpu(int cpu)
 {
@@ -2480,11 +2323,6 @@ static bool __maybe_unused rcu_nocb_adopt_orphan_cbs(struct rcu_state *rsp,
 	return 0;
 }
 
-static bool nocb_cpu_expendable(int cpu)
-{
-	return 1;
-}
-
 static void __init rcu_boot_init_nocb_percpu_data(struct rcu_data *rdp)
 {
 }
@@ -2493,12 +2331,9 @@ static void __init rcu_spawn_nocb_kthreads(struct rcu_state *rsp)
 {
 }
 
-static void init_nocb_callback_list(struct rcu_data *rdp)
-{
-}
-
-static void __init rcu_init_nocb(void)
+static bool init_nocb_callback_list(struct rcu_data *rdp)
 {
+	return false;
 }
 
 #endif /* #else #ifdef CONFIG_RCU_NOCB_CPU */
diff --git a/kernel/rcutree_trace.c b/kernel/rcutree_trace.c
index 0d095dc..49099e8 100644
--- a/kernel/rcutree_trace.c
+++ b/kernel/rcutree_trace.c
@@ -46,8 +46,6 @@
 #define RCU_TREE_NONCORE
 #include "rcutree.h"
 
-#define ulong2long(a) (*(long *)(&(a)))
-
 static int r_open(struct inode *inode, struct file *file,
 					const struct seq_operations *op)
 {
