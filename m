Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754878AbaBQWXJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 17:23:09 -0500
Received: from e32.co.us.ibm.com ([32.97.110.150]:44708 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753801AbaBQWNS (ORCPT
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
Subject: [PATCH tip/core/rcu 24/55] rcutorture: Abstract torture-test initialization
Date: Mon, 17 Feb 2014 14:12:28 -0800
Message-Id: <1392675179-11560-24-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1392675179-11560-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20140217221231.GA8419@linux.vnet.ibm.com>
 <1392675179-11560-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14021722-0928-0000-0000-000006C34F02
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

This commit creates torture_init_begin() and torture_init_end() functions
to abstract locking and allow the torture_type and verbose variables
in kernel/torture.o to become static.  With a bit more abstraction,
fullstop_mutex will also become static.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 include/linux/torture.h |  9 +++++----
 kernel/rcu/rcutorture.c | 19 ++++++++-----------
 kernel/torture.c        | 27 +++++++++++++++++++++++++++
 3 files changed, 40 insertions(+), 15 deletions(-)

diff --git a/include/linux/torture.h b/include/linux/torture.h
index 553c90111585..394638724605 100644
--- a/include/linux/torture.h
+++ b/include/linux/torture.h
@@ -49,10 +49,6 @@ extern int fullstop;
 /* Protect fullstop transitions and spawning of kthreads.  */
 extern struct mutex fullstop_mutex;
 
-/* Common module parameters. */
-extern char *torture_type;
-extern bool verbose;
-
 #define TORTURE_FLAG "-torture:"
 #define TOROUT_STRING(s) \
 	pr_alert("%s" TORTURE_FLAG s "\n", torture_type)
@@ -89,4 +85,9 @@ void torture_shuffle_cleanup(void);
 /* Shutdown task absorption, for when the tasks cannot safely be killed. */
 void torture_shutdown_absorb(const char *title);
 
+/* Initialization and cleanup. */
+
+void torture_init_begin(char *ttype, bool v);
+void torture_init_end(void);
+
 #endif /* __LINUX_TORTURE_H */
diff --git a/kernel/rcu/rcutorture.c b/kernel/rcu/rcutorture.c
index 001e5a42a4b2..0609256df6af 100644
--- a/kernel/rcu/rcutorture.c
+++ b/kernel/rcu/rcutorture.c
@@ -90,15 +90,12 @@ torture_parm(int, test_boost_interval, 7,
 	     "Interval between boost tests, seconds.");
 torture_parm(bool, test_no_idle_hz, true,
 	     "Test support for tickless idle CPUs");
+torture_parm(bool, verbose, true,
+	     "Enable verbose debugging printk()s");
 
-char *torture_type = "rcu";
-EXPORT_SYMBOL_GPL(torture_type);
+static char *torture_type = "rcu";
 module_param(torture_type, charp, 0444);
 MODULE_PARM_DESC(torture_type, "Type of RCU to torture (rcu, rcu_bh, ...)");
-bool verbose;
-EXPORT_SYMBOL_GPL(verbose);
-module_param(verbose, bool, 0444);
-MODULE_PARM_DESC(verbose, "Enable verbose debugging printk()s");
 
 static int nrealreaders;
 static struct task_struct *writer_task;
@@ -1424,8 +1421,8 @@ rcu_torture_cleanup(void)
 {
 	int i;
 
-	mutex_lock(&fullstop_mutex);
 	rcutorture_record_test_transition();
+	mutex_lock(&fullstop_mutex);
 	if (fullstop == FULLSTOP_SHUTDOWN) {
 		pr_warn(/* but going down anyway, so... */
 		       "Concurrent 'rmmod rcutorture' and shutdown illegal!\n");
@@ -1588,7 +1585,7 @@ rcu_torture_init(void)
 		&rcu_ops, &rcu_bh_ops, &srcu_ops, &sched_ops,
 	};
 
-	mutex_lock(&fullstop_mutex);
+	torture_init_begin(torture_type, verbose);
 
 	/* Process args and tell the world that the torturer is on the job. */
 	for (i = 0; i < ARRAY_SIZE(torture_ops); i++) {
@@ -1603,7 +1600,7 @@ rcu_torture_init(void)
 		for (i = 0; i < ARRAY_SIZE(torture_ops); i++)
 			pr_alert(" %s", torture_ops[i]->name);
 		pr_alert("\n");
-		mutex_unlock(&fullstop_mutex);
+		torture_init_end();
 		return -EINVAL;
 	}
 	if (cur_ops->fqs == NULL && fqs_duration != 0) {
@@ -1799,11 +1796,11 @@ rcu_torture_init(void)
 	if (object_debug)
 		rcu_test_debug_objects();
 	rcutorture_record_test_transition();
-	mutex_unlock(&fullstop_mutex);
+	torture_init_end();
 	return 0;
 
 unwind:
-	mutex_unlock(&fullstop_mutex);
+	torture_init_end();
 	rcu_torture_cleanup();
 	return firsterr;
 }
diff --git a/kernel/torture.c b/kernel/torture.c
index a7ec8a7d561e..828d0b1a49b8 100644
--- a/kernel/torture.c
+++ b/kernel/torture.c
@@ -49,6 +49,9 @@
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Paul E. McKenney <paulmck@us.ibm.com>");
 
+static char *torture_type;
+static bool verbose;
+
 int fullstop = FULLSTOP_RMMOD;
 EXPORT_SYMBOL_GPL(fullstop);
 DEFINE_MUTEX(fullstop_mutex);
@@ -426,3 +429,27 @@ void torture_shutdown_absorb(const char *title)
 	}
 }
 EXPORT_SYMBOL_GPL(torture_shutdown_absorb);
+
+/*
+ * Initialize torture module.  Please note that this is -not- invoked via
+ * the usual module_init() mechanism, but rather by an explicit call from
+ * the client torture module.  This call must be paired with a later
+ * torture_init_end().
+ */
+void __init torture_init_begin(char *ttype, bool v)
+{
+	mutex_lock(&fullstop_mutex);
+	torture_type = ttype;
+	verbose = v;
+
+}
+EXPORT_SYMBOL_GPL(torture_init_begin);
+
+/*
+ * Tell the torture module that initialization is complete.
+ */
+void __init torture_init_end(void)
+{
+	mutex_unlock(&fullstop_mutex);
+}
+EXPORT_SYMBOL_GPL(torture_init_end);
-- 
1.8.1.5

