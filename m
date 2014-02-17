Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754739AbaBQWUB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 17:20:01 -0500
Received: from e35.co.us.ibm.com ([32.97.110.153]:45022 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753948AbaBQWNU (ORCPT
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
Subject: [PATCH tip/core/rcu 27/55] rcutorture: Abstract torture_shutdown_notify()
Date: Mon, 17 Feb 2014 14:12:31 -0800
Message-Id: <1392675179-11560-27-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1392675179-11560-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20140217221231.GA8419@linux.vnet.ibm.com>
 <1392675179-11560-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14021722-6688-0000-0000-000006AEB024
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

Because handling the race between rmmod and system shutdown is not
specific to RCU, this commit abstracts torture_shutdown_notify(),
placing this code into kernel/torture.c.  This change also allows
fullstop_mutex to be private to kernel/torture.c.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 include/linux/torture.h |  2 --
 kernel/rcu/rcutorture.c | 23 -----------------------
 kernel/torture.c        | 29 ++++++++++++++++++++++++-----
 3 files changed, 24 insertions(+), 30 deletions(-)

diff --git a/include/linux/torture.h b/include/linux/torture.h
index 1588e0009c70..a12ed5ba5996 100644
--- a/include/linux/torture.h
+++ b/include/linux/torture.h
@@ -46,8 +46,6 @@
 #define FULLSTOP_SHUTDOWN 1	/* System shutdown with rcutorture running. */
 #define FULLSTOP_RMMOD    2	/* Normal rmmod of rcutorture. */
 extern int fullstop;
-/* Protect fullstop transitions and spawning of kthreads.  */
-extern struct mutex fullstop_mutex;
 
 #define TORTURE_FLAG "-torture:"
 #define TOROUT_STRING(s) \
diff --git a/kernel/rcu/rcutorture.c b/kernel/rcu/rcutorture.c
index 9cda8ac30e86..14a045fa3d2e 100644
--- a/kernel/rcu/rcutorture.c
+++ b/kernel/rcu/rcutorture.c
@@ -189,23 +189,6 @@ static DECLARE_WAIT_QUEUE_HEAD(barrier_wq);
 static void rcu_torture_cleanup(void);
 
 /*
- * Detect and respond to a system shutdown.
- */
-static int
-rcutorture_shutdown_notify(struct notifier_block *unused1,
-			   unsigned long unused2, void *unused3)
-{
-	mutex_lock(&fullstop_mutex);
-	if (fullstop == FULLSTOP_DONTSTOP)
-		fullstop = FULLSTOP_SHUTDOWN;
-	else
-		pr_warn(/* but going down anyway, so... */
-		       "Concurrent 'rmmod rcutorture' and shutdown illegal!\n");
-	mutex_unlock(&fullstop_mutex);
-	return NOTIFY_DONE;
-}
-
-/*
  * Allocate an element from the rcu_tortures pool.
  */
 static struct rcu_torture *
@@ -1097,10 +1080,6 @@ rcu_torture_print_module_parms(struct rcu_torture_ops *cur_ops, const char *tag)
 		 onoff_interval, onoff_holdoff);
 }
 
-static struct notifier_block rcutorture_shutdown_nb = {
-	.notifier_call = rcutorture_shutdown_notify,
-};
-
 static void rcutorture_booster_cleanup(int cpu)
 {
 	struct task_struct *t;
@@ -1427,7 +1406,6 @@ rcu_torture_cleanup(void)
 			cur_ops->cb_barrier();
 		return;
 	}
-	unregister_reboot_notifier(&rcutorture_shutdown_nb);
 
 	rcu_torture_barrier_cleanup();
 	rcu_torture_stall_cleanup();
@@ -1773,7 +1751,6 @@ rcu_torture_init(void)
 		firsterr = i;
 		goto unwind;
 	}
-	register_reboot_notifier(&rcutorture_shutdown_nb);
 	i = rcu_torture_stall_init();
 	if (i != 0) {
 		firsterr = i;
diff --git a/kernel/torture.c b/kernel/torture.c
index 41ae5cc3c4c3..b02fa2785bbb 100644
--- a/kernel/torture.c
+++ b/kernel/torture.c
@@ -54,8 +54,7 @@ static bool verbose;
 
 int fullstop = FULLSTOP_RMMOD;
 EXPORT_SYMBOL_GPL(fullstop);
-DEFINE_MUTEX(fullstop_mutex);
-EXPORT_SYMBOL_GPL(fullstop_mutex);
+static DEFINE_MUTEX(fullstop_mutex);
 
 #ifdef CONFIG_HOTPLUG_CPU
 
@@ -422,15 +421,33 @@ EXPORT_SYMBOL_GPL(torture_shuffle_cleanup);
 void torture_shutdown_absorb(const char *title)
 {
 	while (ACCESS_ONCE(fullstop) == FULLSTOP_SHUTDOWN) {
-		pr_notice(
-		       "torture thread %s parking due to system shutdown\n",
-		       title);
+		pr_notice("torture thread %s parking due to system shutdown\n",
+			  title);
 		schedule_timeout_uninterruptible(MAX_SCHEDULE_TIMEOUT);
 	}
 }
 EXPORT_SYMBOL_GPL(torture_shutdown_absorb);
 
 /*
+ * Detect and respond to a system shutdown.
+ */
+static int torture_shutdown_notify(struct notifier_block *unused1,
+				   unsigned long unused2, void *unused3)
+{
+	mutex_lock(&fullstop_mutex);
+	if (fullstop == FULLSTOP_DONTSTOP)
+		fullstop = FULLSTOP_SHUTDOWN;
+	else
+		pr_warn("Concurrent rmmod and shutdown illegal!\n");
+	mutex_unlock(&fullstop_mutex);
+	return NOTIFY_DONE;
+}
+
+static struct notifier_block torture_shutdown_nb = {
+	.notifier_call = torture_shutdown_notify,
+};
+
+/*
  * Initialize torture module.  Please note that this is -not- invoked via
  * the usual module_init() mechanism, but rather by an explicit call from
  * the client torture module.  This call must be paired with a later
@@ -451,6 +468,7 @@ EXPORT_SYMBOL_GPL(torture_init_begin);
 void __init torture_init_end(void)
 {
 	mutex_unlock(&fullstop_mutex);
+	register_reboot_notifier(&torture_shutdown_nb);
 }
 EXPORT_SYMBOL_GPL(torture_init_end);
 
@@ -474,6 +492,7 @@ bool torture_cleanup(void)
 	}
 	fullstop = FULLSTOP_RMMOD;
 	mutex_unlock(&fullstop_mutex);
+	unregister_reboot_notifier(&torture_shutdown_nb);
 	torture_shuffle_cleanup();
 	torture_onoff_cleanup();
 	return false;
-- 
1.8.1.5

