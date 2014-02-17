Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754579AbaBQW07 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 17:26:59 -0500
Received: from e31.co.us.ibm.com ([32.97.110.149]:35144 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753508AbaBQWNQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 17:13:16 -0500
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        oleg@redhat.com, sbw@mit.edu,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 25/55] rcutorture: Abstract torture-test cleanup
Date: Mon, 17 Feb 2014 14:12:29 -0800
Message-Id: <1392675179-11560-25-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1392675179-11560-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20140217221231.GA8419@linux.vnet.ibm.com>
 <1392675179-11560-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14021722-8236-0000-0000-0000074F37F5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

This commit creates a torture_cleanup() that handles the generic
cleanup actions local to kernel/torture.c.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 include/linux/torture.h |  4 +---
 kernel/rcu/rcutorture.c | 11 +----------
 kernel/torture.c        | 30 ++++++++++++++++++++++++++++--
 3 files changed, 30 insertions(+), 15 deletions(-)

diff --git a/include/linux/torture.h b/include/linux/torture.h
index 394638724605..1588e0009c70 100644
--- a/include/linux/torture.h
+++ b/include/linux/torture.h
@@ -65,7 +65,6 @@ extern struct mutex fullstop_mutex;
 
 /* Definitions for online/offline exerciser. */
 int torture_onoff_init(long ooholdoff, long oointerval);
-void torture_onoff_cleanup(void);
 char *torture_onoff_stats(char *page);
 bool torture_onoff_failures(void);
 
@@ -80,14 +79,13 @@ unsigned long torture_random(struct torture_random_state *trsp);
 /* Task shuffler, which causes CPUs to occasionally go idle. */
 void torture_shuffle_task_register(struct task_struct *tp);
 int torture_shuffle_init(long shuffint);
-void torture_shuffle_cleanup(void);
 
 /* Shutdown task absorption, for when the tasks cannot safely be killed. */
 void torture_shutdown_absorb(const char *title);
 
 /* Initialization and cleanup. */
-
 void torture_init_begin(char *ttype, bool v);
 void torture_init_end(void);
+bool torture_cleanup(void);
 
 #endif /* __LINUX_TORTURE_H */
diff --git a/kernel/rcu/rcutorture.c b/kernel/rcu/rcutorture.c
index 0609256df6af..9cda8ac30e86 100644
--- a/kernel/rcu/rcutorture.c
+++ b/kernel/rcu/rcutorture.c
@@ -1422,21 +1422,13 @@ rcu_torture_cleanup(void)
 	int i;
 
 	rcutorture_record_test_transition();
-	mutex_lock(&fullstop_mutex);
-	if (fullstop == FULLSTOP_SHUTDOWN) {
-		pr_warn(/* but going down anyway, so... */
-		       "Concurrent 'rmmod rcutorture' and shutdown illegal!\n");
-		mutex_unlock(&fullstop_mutex);
-		schedule_timeout_uninterruptible(10);
+	if (torture_cleanup()) {
 		if (cur_ops->cb_barrier != NULL)
 			cur_ops->cb_barrier();
 		return;
 	}
-	fullstop = FULLSTOP_RMMOD;
-	mutex_unlock(&fullstop_mutex);
 	unregister_reboot_notifier(&rcutorture_shutdown_nb);
 
-	torture_shuffle_cleanup(); /* Must be first task cleaned up. */
 	rcu_torture_barrier_cleanup();
 	rcu_torture_stall_cleanup();
 	if (stutter_task) {
@@ -1500,7 +1492,6 @@ rcu_torture_cleanup(void)
 		kthread_stop(shutdown_task);
 	}
 	shutdown_task = NULL;
-	torture_onoff_cleanup();
 
 	/* Wait for all RCU callbacks to fire.  */
 
diff --git a/kernel/torture.c b/kernel/torture.c
index 828d0b1a49b8..41ae5cc3c4c3 100644
--- a/kernel/torture.c
+++ b/kernel/torture.c
@@ -199,7 +199,7 @@ EXPORT_SYMBOL_GPL(torture_onoff_init);
 /*
  * Clean up after online/offline testing.
  */
-void torture_onoff_cleanup(void)
+static void torture_onoff_cleanup(void)
 {
 #ifdef CONFIG_HOTPLUG_CPU
 	if (onoff_task == NULL)
@@ -403,7 +403,7 @@ EXPORT_SYMBOL_GPL(torture_shuffle_init);
 /*
  * Stop the shuffling.
  */
-void torture_shuffle_cleanup(void)
+static void torture_shuffle_cleanup(void)
 {
 	torture_shuffle_task_unregister_all();
 	if (shuffler_task) {
@@ -453,3 +453,29 @@ void __init torture_init_end(void)
 	mutex_unlock(&fullstop_mutex);
 }
 EXPORT_SYMBOL_GPL(torture_init_end);
+
+/*
+ * Clean up torture module.  Please note that this is -not- invoked via
+ * the usual module_exit() mechanism, but rather by an explicit call from
+ * the client torture module.  Returns true if a race with system shutdown
+ * is detected.
+ *
+ * This must be called before the caller starts shutting down its own
+ * kthreads.
+ */
+bool torture_cleanup(void)
+{
+	mutex_lock(&fullstop_mutex);
+	if (fullstop == FULLSTOP_SHUTDOWN) {
+		pr_warn("Concurrent rmmod and shutdown illegal!\n");
+		mutex_unlock(&fullstop_mutex);
+		schedule_timeout_uninterruptible(10);
+		return true;
+	}
+	fullstop = FULLSTOP_RMMOD;
+	mutex_unlock(&fullstop_mutex);
+	torture_shuffle_cleanup();
+	torture_onoff_cleanup();
+	return false;
+}
+EXPORT_SYMBOL_GPL(torture_cleanup);
-- 
1.8.1.5

