Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754754AbaBQWUE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 17:20:04 -0500
Received: from e36.co.us.ibm.com ([32.97.110.154]:54992 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753938AbaBQWNU (ORCPT
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
Subject: [PATCH tip/core/rcu 39/55] rcutorture: Stop generic kthreads in torture_cleanup()
Date: Mon, 17 Feb 2014 14:12:43 -0800
Message-Id: <1392675179-11560-39-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1392675179-11560-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20140217221231.GA8419@linux.vnet.ibm.com>
 <1392675179-11560-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14021722-3532-0000-0000-000005BEDCD6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

The specific torture modules (like rcutorture) need to call
torture_cleanup() in any case, so this commit makes torture_cleanup()
deal with torture_shutdown_cleanup() and torture_stutter_cleanup() so
that the specific modules don't have to deal with these details.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 include/linux/torture.h |  2 --
 kernel/rcu/rcutorture.c |  2 --
 kernel/torture.c        | 37 +++++++++++++++++++------------------
 3 files changed, 19 insertions(+), 22 deletions(-)

diff --git a/include/linux/torture.h b/include/linux/torture.h
index db88e7c6ff5d..5440f7f4f14b 100644
--- a/include/linux/torture.h
+++ b/include/linux/torture.h
@@ -75,12 +75,10 @@ int torture_shuffle_init(long shuffint);
 /* Test auto-shutdown handling. */
 void torture_shutdown_absorb(const char *title);
 int torture_shutdown_init(int ssecs, void (*cleanup)(void));
-void torture_shutdown_cleanup(void);
 
 /* Task stuttering, which forces load/no-load transitions. */
 void stutter_wait(const char *title);
 int torture_stutter_init(int s);
-void torture_stutter_cleanup(void);
 
 /* Initialization and cleanup. */
 void torture_init_begin(char *ttype, bool v, int *runnable);
diff --git a/kernel/rcu/rcutorture.c b/kernel/rcu/rcutorture.c
index fc88144fd9e5..390189ecda05 100644
--- a/kernel/rcu/rcutorture.c
+++ b/kernel/rcu/rcutorture.c
@@ -1268,7 +1268,6 @@ rcu_torture_cleanup(void)
 
 	rcu_torture_barrier_cleanup();
 	torture_stop_kthread(rcu_torture_stall, stall_task);
-	torture_stutter_cleanup();
 	torture_stop_kthread(rcu_torture_writer, writer_task);
 
 	if (reader_tasks) {
@@ -1296,7 +1295,6 @@ rcu_torture_cleanup(void)
 		for_each_possible_cpu(i)
 			rcutorture_booster_cleanup(i);
 	}
-	torture_shutdown_cleanup();
 
 	/* Wait for all RCU callbacks to fire.  */
 
diff --git a/kernel/torture.c b/kernel/torture.c
index c0df3b66d084..a93ee5722b50 100644
--- a/kernel/torture.c
+++ b/kernel/torture.c
@@ -478,20 +478,6 @@ int torture_shutdown_init(int ssecs, void (*cleanup)(void))
 EXPORT_SYMBOL_GPL(torture_shutdown_init);
 
 /*
- * Shut down the shutdown task.  Say what???  Heh!  This can happen if
- * the torture module gets an rmmod before the shutdown time arrives.  ;-)
- */
-void torture_shutdown_cleanup(void)
-{
-	if (shutdown_task != NULL) {
-		VERBOSE_TOROUT_STRING("Stopping torture_shutdown task");
-		kthread_stop(shutdown_task);
-	}
-	shutdown_task = NULL;
-}
-EXPORT_SYMBOL_GPL(torture_shutdown_cleanup);
-
-/*
  * Detect and respond to a system shutdown.
  */
 static int torture_shutdown_notify(struct notifier_block *unused1,
@@ -513,6 +499,20 @@ static struct notifier_block torture_shutdown_nb = {
 };
 
 /*
+ * Shut down the shutdown task.  Say what???  Heh!  This can happen if
+ * the torture module gets an rmmod before the shutdown time arrives.  ;-)
+ */
+static void torture_shutdown_cleanup(void)
+{
+	unregister_reboot_notifier(&torture_shutdown_nb);
+	if (shutdown_task != NULL) {
+		VERBOSE_TOROUT_STRING("Stopping torture_shutdown task");
+		kthread_stop(shutdown_task);
+	}
+	shutdown_task = NULL;
+}
+
+/*
  * Variables for stuttering, which means to periodically pause and
  * restart testing in order to catch bugs that appear when load is
  * suddenly applied to or removed from the system.
@@ -575,7 +575,7 @@ EXPORT_SYMBOL_GPL(torture_stutter_init);
 /*
  * Cleanup after the torture_stutter kthread.
  */
-void torture_stutter_cleanup(void)
+static void torture_stutter_cleanup(void)
 {
 	if (!stutter_task)
 		return;
@@ -583,7 +583,6 @@ void torture_stutter_cleanup(void)
 	kthread_stop(stutter_task);
 	stutter_task = NULL;
 }
-EXPORT_SYMBOL_GPL(torture_stutter_cleanup);
 
 /*
  * Initialize torture module.  Please note that this is -not- invoked via
@@ -619,7 +618,8 @@ EXPORT_SYMBOL_GPL(torture_init_end);
  * Clean up torture module.  Please note that this is -not- invoked via
  * the usual module_exit() mechanism, but rather by an explicit call from
  * the client torture module.  Returns true if a race with system shutdown
- * is detected.
+ * is detected, otherwise, all kthreads started by functions in this file
+ * will be shut down.
  *
  * This must be called before the caller starts shutting down its own
  * kthreads.
@@ -635,8 +635,9 @@ bool torture_cleanup(void)
 	}
 	ACCESS_ONCE(fullstop) = FULLSTOP_RMMOD;
 	mutex_unlock(&fullstop_mutex);
-	unregister_reboot_notifier(&torture_shutdown_nb);
+	torture_shutdown_cleanup();
 	torture_shuffle_cleanup();
+	torture_stutter_cleanup();
 	torture_onoff_cleanup();
 	return false;
 }
-- 
1.8.1.5

