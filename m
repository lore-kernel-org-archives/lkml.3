Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754769AbaBQWUG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 17:20:06 -0500
Received: from e34.co.us.ibm.com ([32.97.110.152]:52172 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753930AbaBQWNU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 17:13:20 -0500
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        oleg@redhat.com, sbw@mit.edu,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 38/55] rcutorture: Abstract torture_stop_kthread()
Date: Mon, 17 Feb 2014 14:12:42 -0800
Message-Id: <1392675179-11560-38-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1392675179-11560-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20140217221231.GA8419@linux.vnet.ibm.com>
 <1392675179-11560-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14021722-1542-0000-0000-00000652DA28
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

Stopping of kthreads is not RCU-specific, so this commit abstracts
out torture_stop_kthread(), saving a few lines of code in the process.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 include/linux/torture.h |  3 +++
 kernel/rcu/rcutorture.c | 72 ++++++++++---------------------------------------
 kernel/torture.c        | 13 +++++++++
 3 files changed, 30 insertions(+), 58 deletions(-)

diff --git a/include/linux/torture.h b/include/linux/torture.h
index e5264c6ecfeb..db88e7c6ff5d 100644
--- a/include/linux/torture.h
+++ b/include/linux/torture.h
@@ -91,9 +91,12 @@ bool torture_must_stop_irq(void);
 void torture_kthread_stopping(char *title);
 int _torture_create_kthread(int (*fn)(void *arg), void *arg, char *s, char *m,
 			     char *f, struct task_struct **tp);
+void _torture_stop_kthread(char *m, struct task_struct **tp);
 
 #define torture_create_kthread(n, arg, tp) \
 	_torture_create_kthread(n, (arg), #n, "Creating " #n " task", \
 				"Failed to create " #n, &(tp))
+#define torture_stop_kthread(n, tp) \
+	_torture_stop_kthread("Stopping " #n " task", &(tp))
 
 #endif /* __LINUX_TORTURE_H */
diff --git a/kernel/rcu/rcutorture.c b/kernel/rcu/rcutorture.c
index 951a5559d9fa..fc88144fd9e5 100644
--- a/kernel/rcu/rcutorture.c
+++ b/kernel/rcu/rcutorture.c
@@ -1032,14 +1032,12 @@ static void rcutorture_booster_cleanup(int cpu)
 	if (boost_tasks[cpu] == NULL)
 		return;
 	mutex_lock(&boost_mutex);
-	VERBOSE_TOROUT_STRING("Stopping rcu_torture_boost task");
 	t = boost_tasks[cpu];
 	boost_tasks[cpu] = NULL;
 	mutex_unlock(&boost_mutex);
 
 	/* This must be outside of the mutex, otherwise deadlock! */
-	kthread_stop(t);
-	boost_tasks[cpu] = NULL;
+	torture_stop_kthread(rcu_torture_boost, t);
 }
 
 static int rcutorture_booster_init(int cpu)
@@ -1109,16 +1107,6 @@ static int __init rcu_torture_stall_init(void)
 	return torture_create_kthread(rcu_torture_stall, NULL, stall_task);
 }
 
-/* Clean up after the CPU-stall kthread, if one was spawned. */
-static void rcu_torture_stall_cleanup(void)
-{
-	if (stall_task == NULL)
-		return;
-	VERBOSE_TOROUT_STRING("Stopping rcu_torture_stall_task.");
-	kthread_stop(stall_task);
-	stall_task = NULL;
-}
-
 /* Callback function for RCU barrier testing. */
 void rcu_torture_barrier_cbf(struct rcu_head *rcu)
 {
@@ -1229,19 +1217,11 @@ static void rcu_torture_barrier_cleanup(void)
 {
 	int i;
 
-	if (barrier_task != NULL) {
-		VERBOSE_TOROUT_STRING("Stopping rcu_torture_barrier task");
-		kthread_stop(barrier_task);
-		barrier_task = NULL;
-	}
+	torture_stop_kthread(rcu_torture_barrier, barrier_task);
 	if (barrier_cbs_tasks != NULL) {
-		for (i = 0; i < n_barrier_cbs; i++) {
-			if (barrier_cbs_tasks[i] != NULL) {
-				VERBOSE_TOROUT_STRING("Stopping rcu_torture_barrier_cbs task");
-				kthread_stop(barrier_cbs_tasks[i]);
-				barrier_cbs_tasks[i] = NULL;
-			}
-		}
+		for (i = 0; i < n_barrier_cbs; i++)
+			torture_stop_kthread(rcu_torture_barrier_cbs,
+					     barrier_cbs_tasks[i]);
 		kfree(barrier_cbs_tasks);
 		barrier_cbs_tasks = NULL;
 	}
@@ -1287,53 +1267,29 @@ rcu_torture_cleanup(void)
 	}
 
 	rcu_torture_barrier_cleanup();
-	rcu_torture_stall_cleanup();
+	torture_stop_kthread(rcu_torture_stall, stall_task);
 	torture_stutter_cleanup();
-
-	if (writer_task) {
-		VERBOSE_TOROUT_STRING("Stopping rcu_torture_writer task");
-		kthread_stop(writer_task);
-	}
-	writer_task = NULL;
+	torture_stop_kthread(rcu_torture_writer, writer_task);
 
 	if (reader_tasks) {
-		for (i = 0; i < nrealreaders; i++) {
-			if (reader_tasks[i]) {
-				VERBOSE_TOROUT_STRING(
-					"Stopping rcu_torture_reader task");
-				kthread_stop(reader_tasks[i]);
-			}
-			reader_tasks[i] = NULL;
-		}
+		for (i = 0; i < nrealreaders; i++)
+			torture_stop_kthread(rcu_torture_reader,
+					     reader_tasks[i]);
 		kfree(reader_tasks);
-		reader_tasks = NULL;
 	}
 	rcu_torture_current = NULL;
 
 	if (fakewriter_tasks) {
 		for (i = 0; i < nfakewriters; i++) {
-			if (fakewriter_tasks[i]) {
-				VERBOSE_TOROUT_STRING(
-					"Stopping rcu_torture_fakewriter task");
-				kthread_stop(fakewriter_tasks[i]);
-			}
-			fakewriter_tasks[i] = NULL;
+			torture_stop_kthread(rcu_torture_fakewriter,
+					     fakewriter_tasks[i]);
 		}
 		kfree(fakewriter_tasks);
 		fakewriter_tasks = NULL;
 	}
 
-	if (stats_task) {
-		VERBOSE_TOROUT_STRING("Stopping rcu_torture_stats task");
-		kthread_stop(stats_task);
-	}
-	stats_task = NULL;
-
-	if (fqs_task) {
-		VERBOSE_TOROUT_STRING("Stopping rcu_torture_fqs task");
-		kthread_stop(fqs_task);
-	}
-	fqs_task = NULL;
+	torture_stop_kthread(rcu_torture_stats, stats_task);
+	torture_stop_kthread(rcu_torture_fqs, fqs_task);
 	if ((test_boost == 1 && cur_ops->can_boost) ||
 	    test_boost == 2) {
 		unregister_cpu_notifier(&rcutorture_cpu_nb);
diff --git a/kernel/torture.c b/kernel/torture.c
index 94760f0f2923..c0df3b66d084 100644
--- a/kernel/torture.c
+++ b/kernel/torture.c
@@ -700,3 +700,16 @@ int _torture_create_kthread(int (*fn)(void *arg), void *arg, char *s, char *m,
 	return ret;
 }
 EXPORT_SYMBOL_GPL(_torture_create_kthread);
+
+/*
+ * Stop a generic kthread, emitting a message.
+ */
+void _torture_stop_kthread(char *m, struct task_struct **tp)
+{
+	if (*tp == NULL)
+		return;
+	VERBOSE_TOROUT_STRING(m);
+	kthread_stop(*tp);
+	*tp = NULL;
+}
+EXPORT_SYMBOL_GPL(_torture_stop_kthread);
-- 
1.8.1.5

