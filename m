Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754864AbaBQWXH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 17:23:07 -0500
Received: from e31.co.us.ibm.com ([32.97.110.149]:35201 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753811AbaBQWNS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 17:13:18 -0500
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        oleg@redhat.com, sbw@mit.edu,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 30/55] rcutorture: Abstract stutter_wait()
Date: Mon, 17 Feb 2014 14:12:34 -0800
Message-Id: <1392675179-11560-30-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1392675179-11560-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20140217221231.GA8419@linux.vnet.ibm.com>
 <1392675179-11560-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14021722-8236-0000-0000-0000074F3828
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

Because stuttering the test load (stopping and restarting it) is useful
for non-RCU testing, this commit moves the load-stuttering functionality
to kernel/torture.c.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 include/linux/torture.h |  7 +++-
 kernel/rcu/rcutorture.c | 69 +++++++--------------------------------
 kernel/torture.c        | 87 ++++++++++++++++++++++++++++++++++++++++++++++++-
 3 files changed, 104 insertions(+), 59 deletions(-)

diff --git a/include/linux/torture.h b/include/linux/torture.h
index 1e2e7cd528c0..791934fa32b9 100644
--- a/include/linux/torture.h
+++ b/include/linux/torture.h
@@ -75,8 +75,13 @@ int torture_shuffle_init(long shuffint);
 /* Shutdown task absorption, for when the tasks cannot safely be killed. */
 void torture_shutdown_absorb(const char *title);
 
+/* Task stuttering, which forces load/no-load transitions. */
+void stutter_wait(const char *title);
+int torture_stutter_init(int s);
+void torture_stutter_cleanup(void);
+
 /* Initialization and cleanup. */
-void torture_init_begin(char *ttype, bool v);
+void torture_init_begin(char *ttype, bool v, int *runnable);
 void torture_init_end(void);
 bool torture_cleanup(void);
 bool torture_must_stop(void);
diff --git a/kernel/rcu/rcutorture.c b/kernel/rcu/rcutorture.c
index 87bd690c5958..506f1c09ed90 100644
--- a/kernel/rcu/rcutorture.c
+++ b/kernel/rcu/rcutorture.c
@@ -102,7 +102,6 @@ static struct task_struct *writer_task;
 static struct task_struct **fakewriter_tasks;
 static struct task_struct **reader_tasks;
 static struct task_struct *stats_task;
-static struct task_struct *stutter_task;
 static struct task_struct *fqs_task;
 static struct task_struct *boost_tasks[NR_CPUS];
 static struct task_struct *shutdown_task;
@@ -144,8 +143,6 @@ static long n_barrier_attempts;
 static long n_barrier_successes;
 static struct list_head rcu_torture_removed;
 
-static int stutter_pause_test;
-
 #if defined(MODULE) || defined(CONFIG_RCU_TORTURE_TEST_RUNNABLE)
 #define RCUTORTURE_RUNNABLE_INIT 1
 #else
@@ -221,18 +218,6 @@ rcu_torture_free(struct rcu_torture *p)
 	spin_unlock_bh(&rcu_torture_lock);
 }
 
-static void
-rcu_stutter_wait(const char *title)
-{
-	while (stutter_pause_test || !rcutorture_runnable) {
-		if (rcutorture_runnable)
-			schedule_timeout_interruptible(1);
-		else
-			schedule_timeout_interruptible(round_jiffies_relative(HZ));
-		torture_shutdown_absorb(title);
-	}
-}
-
 /*
  * Operations vector for selecting different types of tests.
  */
@@ -570,7 +555,7 @@ static int rcu_torture_boost(void *arg)
 		oldstarttime = boost_starttime;
 		while (ULONG_CMP_LT(jiffies, oldstarttime)) {
 			schedule_timeout_interruptible(oldstarttime - jiffies);
-			rcu_stutter_wait("rcu_torture_boost");
+			stutter_wait("rcu_torture_boost");
 			if (torture_must_stop())
 				goto checkwait;
 		}
@@ -592,7 +577,7 @@ static int rcu_torture_boost(void *arg)
 				call_rcu_time = jiffies;
 			}
 			cond_resched();
-			rcu_stutter_wait("rcu_torture_boost");
+			stutter_wait("rcu_torture_boost");
 			if (torture_must_stop())
 				goto checkwait;
 		}
@@ -617,7 +602,7 @@ static int rcu_torture_boost(void *arg)
 		}
 
 		/* Go do the stutter. */
-checkwait:	rcu_stutter_wait("rcu_torture_boost");
+checkwait:	stutter_wait("rcu_torture_boost");
 	} while (!torture_must_stop());
 
 	/* Clean up and exit. */
@@ -655,7 +640,7 @@ rcu_torture_fqs(void *arg)
 			udelay(fqs_holdoff);
 			fqs_burst_remaining -= fqs_holdoff;
 		}
-		rcu_stutter_wait("rcu_torture_fqs");
+		stutter_wait("rcu_torture_fqs");
 	} while (!torture_must_stop());
 	VERBOSE_TOROUT_STRING("rcu_torture_fqs task stopping");
 	torture_shutdown_absorb("rcu_torture_fqs");
@@ -727,7 +712,7 @@ rcu_torture_writer(void *arg)
 			}
 		}
 		rcutorture_record_progress(++rcu_torture_current_version);
-		rcu_stutter_wait("rcu_torture_writer");
+		stutter_wait("rcu_torture_writer");
 	} while (!torture_must_stop());
 	VERBOSE_TOROUT_STRING("rcu_torture_writer task stopping");
 	torture_shutdown_absorb("rcu_torture_writer");
@@ -764,7 +749,7 @@ rcu_torture_fakewriter(void *arg)
 		} else {
 			cur_ops->exp_sync();
 		}
-		rcu_stutter_wait("rcu_torture_fakewriter");
+		stutter_wait("rcu_torture_fakewriter");
 	} while (!torture_must_stop());
 
 	VERBOSE_TOROUT_STRING("rcu_torture_fakewriter task stopping");
@@ -909,7 +894,7 @@ rcu_torture_reader(void *arg)
 		preempt_enable();
 		cur_ops->readunlock(idx);
 		schedule();
-		rcu_stutter_wait("rcu_torture_reader");
+		stutter_wait("rcu_torture_reader");
 	} while (!torture_must_stop());
 	VERBOSE_TOROUT_STRING("rcu_torture_reader task stopping");
 	torture_shutdown_absorb("rcu_torture_reader");
@@ -1033,25 +1018,6 @@ rcu_torture_stats(void *arg)
 	return 0;
 }
 
-/* Cause the rcutorture test to "stutter", starting and stopping all
- * threads periodically.
- */
-static int
-rcu_torture_stutter(void *arg)
-{
-	VERBOSE_TOROUT_STRING("rcu_torture_stutter task started");
-	do {
-		schedule_timeout_interruptible(stutter * HZ);
-		stutter_pause_test = 1;
-		if (!kthread_should_stop())
-			schedule_timeout_interruptible(stutter * HZ);
-		stutter_pause_test = 0;
-		torture_shutdown_absorb("rcu_torture_stutter");
-	} while (!kthread_should_stop());
-	VERBOSE_TOROUT_STRING("rcu_torture_stutter task stopping");
-	return 0;
-}
-
 static inline void
 rcu_torture_print_module_parms(struct rcu_torture_ops *cur_ops, const char *tag)
 {
@@ -1402,11 +1368,7 @@ rcu_torture_cleanup(void)
 
 	rcu_torture_barrier_cleanup();
 	rcu_torture_stall_cleanup();
-	if (stutter_task) {
-		VERBOSE_TOROUT_STRING("Stopping rcu_torture_stutter task");
-		kthread_stop(stutter_task);
-	}
-	stutter_task = NULL;
+	torture_stutter_cleanup();
 
 	if (writer_task) {
 		VERBOSE_TOROUT_STRING("Stopping rcu_torture_writer task");
@@ -1547,7 +1509,7 @@ rcu_torture_init(void)
 		&rcu_ops, &rcu_bh_ops, &srcu_ops, &sched_ops,
 	};
 
-	torture_init_begin(torture_type, verbose);
+	torture_init_begin(torture_type, verbose, &rcutorture_runnable);
 
 	/* Process args and tell the world that the torturer is on the job. */
 	for (i = 0; i < ARRAY_SIZE(torture_ops); i++) {
@@ -1681,21 +1643,14 @@ rcu_torture_init(void)
 	if (stutter < 0)
 		stutter = 0;
 	if (stutter) {
-		/* Create the stutter thread */
-		stutter_task = kthread_run(rcu_torture_stutter, NULL,
-					  "rcu_torture_stutter");
-		if (IS_ERR(stutter_task)) {
-			firsterr = PTR_ERR(stutter_task);
-			VERBOSE_TOROUT_ERRSTRING("Failed to create stutter");
-			stutter_task = NULL;
+		firsterr = torture_stutter_init(stutter * HZ);
+		if (firsterr)
 			goto unwind;
-		}
-		torture_shuffle_task_register(stutter_task);
 	}
 	if (fqs_duration < 0)
 		fqs_duration = 0;
 	if (fqs_duration) {
-		/* Create the stutter thread */
+		/* Create the fqs thread */
 		fqs_task = kthread_run(rcu_torture_fqs, NULL,
 				       "rcu_torture_fqs");
 		if (IS_ERR(fqs_task)) {
diff --git a/kernel/torture.c b/kernel/torture.c
index d51de3029a5c..317b49d8ff79 100644
--- a/kernel/torture.c
+++ b/kernel/torture.c
@@ -58,6 +58,7 @@ static bool verbose;
 #define FULLSTOP_RMMOD    2	/* Normal rmmod of torture. */
 static int fullstop = FULLSTOP_RMMOD;
 static DEFINE_MUTEX(fullstop_mutex);
+static int *torture_runnable;
 
 #ifdef CONFIG_HOTPLUG_CPU
 
@@ -453,16 +454,100 @@ static struct notifier_block torture_shutdown_nb = {
 };
 
 /*
+ * Variables for stuttering, which means to periodically pause and
+ * restart testing in order to catch bugs that appear when load is
+ * suddenly applied to or removed from the system.
+ */
+static struct task_struct *stutter_task;
+static int stutter_pause_test;
+static int stutter;
+
+/*
+ * Block until the stutter interval ends.  This must be called periodically
+ * by all running kthreads that need to be subject to stuttering.
+ */
+void stutter_wait(const char *title)
+{
+	while (ACCESS_ONCE(stutter_pause_test) ||
+	       (torture_runnable && !ACCESS_ONCE(*torture_runnable))) {
+		if (!torture_runnable || ACCESS_ONCE(*torture_runnable))
+			schedule_timeout_interruptible(1);
+		else
+			schedule_timeout_interruptible(round_jiffies_relative(HZ));
+		torture_shutdown_absorb(title);
+	}
+}
+EXPORT_SYMBOL_GPL(stutter_wait);
+
+/*
+ * Cause the torture test to "stutter", starting and stopping all
+ * threads periodically.
+ */
+static int torture_stutter(void *arg)
+{
+	VERBOSE_TOROUT_STRING("torture_stutter task started");
+	do {
+		if (!torture_must_stop()) {
+			schedule_timeout_interruptible(stutter * HZ);
+			ACCESS_ONCE(stutter_pause_test) = 1;
+		}
+		if (!torture_must_stop())
+			schedule_timeout_interruptible(stutter * HZ);
+		ACCESS_ONCE(stutter_pause_test) = 0;
+		torture_shutdown_absorb("torture_stutter");
+	} while (!torture_must_stop());
+	VERBOSE_TOROUT_STRING("torture_stutter task stopping");
+	return 0;
+}
+
+/*
+ * Initialize and kick off the torture_stutter kthread.
+ */
+int torture_stutter_init(int s)
+{
+	int ret;
+
+	stutter = s;
+	stutter_task = kthread_run(torture_stutter, NULL, "torture_stutter");
+	if (IS_ERR(stutter_task)) {
+		ret = PTR_ERR(stutter_task);
+		VERBOSE_TOROUT_ERRSTRING("Failed to create stutter");
+		stutter_task = NULL;
+		return ret;
+	}
+	torture_shuffle_task_register(stutter_task);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(torture_stutter_init);
+
+/*
+ * Cleanup after the torture_stutter kthread.
+ */
+void torture_stutter_cleanup(void)
+{
+	if (!stutter_task)
+		return;
+	VERBOSE_TOROUT_STRING("Stopping torture_stutter task");
+	kthread_stop(stutter_task);
+	stutter_task = NULL;
+}
+EXPORT_SYMBOL_GPL(torture_stutter_cleanup);
+
+/*
  * Initialize torture module.  Please note that this is -not- invoked via
  * the usual module_init() mechanism, but rather by an explicit call from
  * the client torture module.  This call must be paired with a later
  * torture_init_end().
+ *
+ * The runnable parameter points to a flag that controls whether or not
+ * the test is currently runnable.  If there is no such flag, pass in NULL.
  */
-void __init torture_init_begin(char *ttype, bool v)
+void __init torture_init_begin(char *ttype, bool v, int *runnable)
 {
 	mutex_lock(&fullstop_mutex);
 	torture_type = ttype;
 	verbose = v;
+	torture_runnable = runnable;
 	fullstop = FULLSTOP_DONTSTOP;
 
 }
-- 
1.8.1.5

