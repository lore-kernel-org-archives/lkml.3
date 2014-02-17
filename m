Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754901AbaBQWXN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 17:23:13 -0500
Received: from e38.co.us.ibm.com ([32.97.110.159]:51049 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753736AbaBQWNS (ORCPT
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
Subject: [PATCH tip/core/rcu 20/55] rcutorture: Abstract torture_shutdown_absorb()
Date: Mon, 17 Feb 2014 14:12:24 -0800
Message-Id: <1392675179-11560-20-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1392675179-11560-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20140217221231.GA8419@linux.vnet.ibm.com>
 <1392675179-11560-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14021722-1344-0000-0000-000005D5BE0B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

Because handling races between rmmod and normal shutdown is not specific
to rcutorture, this commit renames rcutorture_shutdown_absorb() to
torture_shutdown_absorb() and pulls it out into then kernel/torture.c
module.  This implies pulling the fullstop mechanism into kernel/torture.c
as well.

The exporting of fullstop and fullstop_mutex is ugly and must die.
And it does in fact die in later commits that introduce higher-level
APIs that encapsulate both of these variables.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 include/linux/torture.h | 11 +++++++++++
 kernel/rcu/rcutorture.c | 49 ++++++++++++-------------------------------------
 kernel/torture.c        | 20 ++++++++++++++++++++
 3 files changed, 43 insertions(+), 37 deletions(-)

diff --git a/include/linux/torture.h b/include/linux/torture.h
index 8a4088f2f87b..c61b4ce18a13 100644
--- a/include/linux/torture.h
+++ b/include/linux/torture.h
@@ -41,6 +41,14 @@
 	module_param(name, type, 0444); \
 	MODULE_PARM_DESC(name, msg);
 
+/* Mediate rmmod and system shutdown.  Concurrent rmmod & shutdown illegal! */
+#define FULLSTOP_DONTSTOP 0	/* Normal operation. */
+#define FULLSTOP_SHUTDOWN 1	/* System shutdown with rcutorture running. */
+#define FULLSTOP_RMMOD    2	/* Normal rmmod of rcutorture. */
+extern int fullstop;
+/* Protect fullstop transitions and spawning of kthreads.  */
+extern struct mutex fullstop_mutex;
+
 #define TORTURE_FLAG "-torture:"
 #define TOROUT_STRING(s) \
 	pr_alert("%s" TORTURE_FLAG s "\n", torture_type)
@@ -57,4 +65,7 @@ struct torture_random_state {
 #define DEFINE_TORTURE_RANDOM(name) struct torture_random_state name = { 0, 0 }
 unsigned long torture_random(struct torture_random_state *trsp);
 
+/* Shutdown task absorption, for when the tasks cannot safely be killed. */
+void torture_shutdown_absorb(const char *title);
+
 #endif /* __LINUX_TORTURE_H */
diff --git a/kernel/rcu/rcutorture.c b/kernel/rcu/rcutorture.c
index 2bb3dcb67221..3687619b243a 100644
--- a/kernel/rcu/rcutorture.c
+++ b/kernel/rcu/rcutorture.c
@@ -199,17 +199,6 @@ static atomic_t barrier_cbs_invoked;	/* Barrier callbacks invoked. */
 static wait_queue_head_t *barrier_cbs_wq; /* Coordinate barrier testing. */
 static DECLARE_WAIT_QUEUE_HEAD(barrier_wq);
 
-/* Mediate rmmod and system shutdown.  Concurrent rmmod & shutdown illegal! */
-
-#define FULLSTOP_DONTSTOP 0	/* Normal operation. */
-#define FULLSTOP_SHUTDOWN 1	/* System shutdown with rcutorture running. */
-#define FULLSTOP_RMMOD    2	/* Normal rmmod of rcutorture. */
-static int fullstop = FULLSTOP_RMMOD;
-/*
- * Protect fullstop transitions and spawning of kthreads.
- */
-static DEFINE_MUTEX(fullstop_mutex);
-
 /* Forward reference. */
 static void rcu_torture_cleanup(void);
 
@@ -231,20 +220,6 @@ rcutorture_shutdown_notify(struct notifier_block *unused1,
 }
 
 /*
- * Absorb kthreads into a kernel function that won't return, so that
- * they won't ever access module text or data again.
- */
-static void rcutorture_shutdown_absorb(const char *title)
-{
-	if (ACCESS_ONCE(fullstop) == FULLSTOP_SHUTDOWN) {
-		pr_notice(
-		       "rcutorture thread %s parking due to system shutdown\n",
-		       title);
-		schedule_timeout_uninterruptible(MAX_SCHEDULE_TIMEOUT);
-	}
-}
-
-/*
  * Allocate an element from the rcu_tortures pool.
  */
 static struct rcu_torture *
@@ -285,7 +260,7 @@ rcu_stutter_wait(const char *title)
 			schedule_timeout_interruptible(1);
 		else
 			schedule_timeout_interruptible(round_jiffies_relative(HZ));
-		rcutorture_shutdown_absorb(title);
+		torture_shutdown_absorb(title);
 	}
 }
 
@@ -680,7 +655,7 @@ checkwait:	rcu_stutter_wait("rcu_torture_boost");
 
 	/* Clean up and exit. */
 	VERBOSE_TOROUT_STRING("rcu_torture_boost task stopping");
-	rcutorture_shutdown_absorb("rcu_torture_boost");
+	torture_shutdown_absorb("rcu_torture_boost");
 	while (!kthread_should_stop() || rbi.inflight)
 		schedule_timeout_uninterruptible(1);
 	smp_mb(); /* order accesses to ->inflight before stack-frame death. */
@@ -716,7 +691,7 @@ rcu_torture_fqs(void *arg)
 		rcu_stutter_wait("rcu_torture_fqs");
 	} while (!kthread_should_stop() && fullstop == FULLSTOP_DONTSTOP);
 	VERBOSE_TOROUT_STRING("rcu_torture_fqs task stopping");
-	rcutorture_shutdown_absorb("rcu_torture_fqs");
+	torture_shutdown_absorb("rcu_torture_fqs");
 	while (!kthread_should_stop())
 		schedule_timeout_uninterruptible(1);
 	return 0;
@@ -788,7 +763,7 @@ rcu_torture_writer(void *arg)
 		rcu_stutter_wait("rcu_torture_writer");
 	} while (!kthread_should_stop() && fullstop == FULLSTOP_DONTSTOP);
 	VERBOSE_TOROUT_STRING("rcu_torture_writer task stopping");
-	rcutorture_shutdown_absorb("rcu_torture_writer");
+	torture_shutdown_absorb("rcu_torture_writer");
 	while (!kthread_should_stop())
 		schedule_timeout_uninterruptible(1);
 	return 0;
@@ -826,7 +801,7 @@ rcu_torture_fakewriter(void *arg)
 	} while (!kthread_should_stop() && fullstop == FULLSTOP_DONTSTOP);
 
 	VERBOSE_TOROUT_STRING("rcu_torture_fakewriter task stopping");
-	rcutorture_shutdown_absorb("rcu_torture_fakewriter");
+	torture_shutdown_absorb("rcu_torture_fakewriter");
 	while (!kthread_should_stop())
 		schedule_timeout_uninterruptible(1);
 	return 0;
@@ -970,7 +945,7 @@ rcu_torture_reader(void *arg)
 		rcu_stutter_wait("rcu_torture_reader");
 	} while (!kthread_should_stop() && fullstop == FULLSTOP_DONTSTOP);
 	VERBOSE_TOROUT_STRING("rcu_torture_reader task stopping");
-	rcutorture_shutdown_absorb("rcu_torture_reader");
+	torture_shutdown_absorb("rcu_torture_reader");
 	if (irqreader && cur_ops->irq_capable)
 		del_timer_sync(&t);
 	while (!kthread_should_stop())
@@ -1094,7 +1069,7 @@ rcu_torture_stats(void *arg)
 	do {
 		schedule_timeout_interruptible(stat_interval * HZ);
 		rcu_torture_stats_print();
-		rcutorture_shutdown_absorb("rcu_torture_stats");
+		torture_shutdown_absorb("rcu_torture_stats");
 	} while (!kthread_should_stop());
 	VERBOSE_TOROUT_STRING("rcu_torture_stats task stopping");
 	return 0;
@@ -1178,7 +1153,7 @@ rcu_torture_shuffle(void *arg)
 	do {
 		schedule_timeout_interruptible(shuffle_interval * HZ);
 		rcu_torture_shuffle_tasks();
-		rcutorture_shutdown_absorb("rcu_torture_shuffle");
+		torture_shutdown_absorb("rcu_torture_shuffle");
 	} while (!kthread_should_stop());
 	VERBOSE_TOROUT_STRING("rcu_torture_shuffle task stopping");
 	return 0;
@@ -1197,7 +1172,7 @@ rcu_torture_stutter(void *arg)
 		if (!kthread_should_stop())
 			schedule_timeout_interruptible(stutter * HZ);
 		stutter_pause_test = 0;
-		rcutorture_shutdown_absorb("rcu_torture_stutter");
+		torture_shutdown_absorb("rcu_torture_stutter");
 	} while (!kthread_should_stop());
 	VERBOSE_TOROUT_STRING("rcu_torture_stutter task stopping");
 	return 0;
@@ -1469,7 +1444,7 @@ static int rcu_torture_stall(void *args)
 		rcu_read_unlock();
 		pr_alert("rcu_torture_stall end.\n");
 	}
-	rcutorture_shutdown_absorb("rcu_torture_stall");
+	torture_shutdown_absorb("rcu_torture_stall");
 	while (!kthread_should_stop())
 		schedule_timeout_interruptible(10 * HZ);
 	return 0;
@@ -1533,7 +1508,7 @@ static int rcu_torture_barrier_cbs(void *arg)
 			wake_up(&barrier_wq);
 	} while (!kthread_should_stop() && fullstop == FULLSTOP_DONTSTOP);
 	VERBOSE_TOROUT_STRING("rcu_torture_barrier_cbs task stopping");
-	rcutorture_shutdown_absorb("rcu_torture_barrier_cbs");
+	torture_shutdown_absorb("rcu_torture_barrier_cbs");
 	while (!kthread_should_stop())
 		schedule_timeout_interruptible(1);
 	cur_ops->cb_barrier();
@@ -1570,7 +1545,7 @@ static int rcu_torture_barrier(void *arg)
 		schedule_timeout_interruptible(HZ / 10);
 	} while (!kthread_should_stop() && fullstop == FULLSTOP_DONTSTOP);
 	VERBOSE_TOROUT_STRING("rcu_torture_barrier task stopping");
-	rcutorture_shutdown_absorb("rcu_torture_barrier");
+	torture_shutdown_absorb("rcu_torture_barrier");
 	while (!kthread_should_stop())
 		schedule_timeout_interruptible(1);
 	return 0;
diff --git a/kernel/torture.c b/kernel/torture.c
index c82c70f7828e..f05042036ae8 100644
--- a/kernel/torture.c
+++ b/kernel/torture.c
@@ -49,6 +49,11 @@
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Paul E. McKenney <paulmck@us.ibm.com>");
 
+int fullstop = FULLSTOP_RMMOD;
+EXPORT_SYMBOL_GPL(fullstop);
+DEFINE_MUTEX(fullstop_mutex);
+EXPORT_SYMBOL_GPL(fullstop_mutex);
+
 #define TORTURE_RANDOM_MULT	39916801  /* prime */
 #define TORTURE_RANDOM_ADD	479001701 /* prime */
 #define TORTURE_RANDOM_REFRESH	10000
@@ -69,3 +74,18 @@ torture_random(struct torture_random_state *trsp)
 	return swahw32(trsp->trs_state);
 }
 EXPORT_SYMBOL_GPL(torture_random);
+
+/*
+ * Absorb kthreads into a kernel function that won't return, so that
+ * they won't ever access module text or data again.
+ */
+void torture_shutdown_absorb(const char *title)
+{
+	while (ACCESS_ONCE(fullstop) == FULLSTOP_SHUTDOWN) {
+		pr_notice(
+		       "torture thread %s parking due to system shutdown\n",
+		       title);
+		schedule_timeout_uninterruptible(MAX_SCHEDULE_TIMEOUT);
+	}
+}
+EXPORT_SYMBOL_GPL(torture_shutdown_absorb);
-- 
1.8.1.5

