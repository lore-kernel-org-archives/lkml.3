Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752231Ab3HTCv2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 22:51:28 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:35761 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751876Ab3HTCv0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 22:51:26 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        sbw@mit.edu, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Sedat Dilek <sedat.dilek@gmail.com>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>,
        Rik van Riel <riel@surriel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH tip/core/rcu 1/5] rcu: Add duplicate-callback tests to rcutorture
Date: Mon, 19 Aug 2013 19:51:10 -0700
Message-Id: <1376967074-32530-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <20130818022453.GA3475@linux.vnet.ibm.com>
References: <20130818022453.GA3475@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13082002-2398-0000-0000-000001A4784E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

This commit adds a object_debug option to rcutorture to allow the
debug-object-based checks for duplicate call_rcu() invocations to
be deterministically tested.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Sedat Dilek <sedat.dilek@gmail.com>
Cc: Davidlohr Bueso <davidlohr.bueso@hp.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Tested-by: Sedat Dilek <sedat.dilek@gmail.com>
[ paulmck: Banish mid-function ifdef, more or less per Josh Triplett. ]
---
 kernel/rcutorture.c | 45 +++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 45 insertions(+)

diff --git a/kernel/rcutorture.c b/kernel/rcutorture.c
index 3d936f0f..f5cf2bb 100644
--- a/kernel/rcutorture.c
+++ b/kernel/rcutorture.c
@@ -66,6 +66,7 @@ static int fqs_duration;	/* Duration of bursts (us), 0 to disable. */
 static int fqs_holdoff;		/* Hold time within burst (us). */
 static int fqs_stutter = 3;	/* Wait time between bursts (s). */
 static int n_barrier_cbs;	/* Number of callbacks to test RCU barriers. */
+static int object_debug;	/* Test object-debug double call_rcu()?. */
 static int onoff_interval;	/* Wait time between CPU hotplugs, 0=disable. */
 static int onoff_holdoff;	/* Seconds after boot before CPU hotplugs. */
 static int shutdown_secs;	/* Shutdown time (s).  <=0 for no shutdown. */
@@ -100,6 +101,8 @@ module_param(fqs_stutter, int, 0444);
 MODULE_PARM_DESC(fqs_stutter, "Wait time between fqs bursts (s)");
 module_param(n_barrier_cbs, int, 0444);
 MODULE_PARM_DESC(n_barrier_cbs, "# of callbacks/kthreads for barrier testing");
+module_param(object_debug, int, 0444);
+MODULE_PARM_DESC(object_debug, "Enable debug-object double call_rcu() testing");
 module_param(onoff_interval, int, 0444);
 MODULE_PARM_DESC(onoff_interval, "Time between CPU hotplugs (s), 0=disable");
 module_param(onoff_holdoff, int, 0444);
@@ -1934,6 +1937,46 @@ rcu_torture_cleanup(void)
 		rcu_torture_print_module_parms(cur_ops, "End of test: SUCCESS");
 }
 
+#ifdef CONFIG_DEBUG_OBJECTS_RCU_HEAD
+static void rcu_torture_leak_cb(struct rcu_head *rhp)
+{
+}
+
+static void rcu_torture_err_cb(struct rcu_head *rhp)
+{
+	/* This -might- happen due to race conditions, but is unlikely. */
+	pr_alert("rcutorture: duplicated callback was invoked.\n");
+}
+#endif /* #ifdef CONFIG_DEBUG_OBJECTS_RCU_HEAD */
+
+/*
+ * Verify that double-free causes debug-objects to complain, but only
+ * if CONFIG_DEBUG_OBJECTS_RCU_HEAD=y.  Otherwise, say that the test
+ * cannot be carried out.
+ */
+static void rcu_test_debug_objects(void)
+{
+#ifdef CONFIG_DEBUG_OBJECTS_RCU_HEAD
+	struct rcu_head rh1;
+	struct rcu_head rh2;
+
+	init_rcu_head_on_stack(&rh1);
+	init_rcu_head_on_stack(&rh2);
+	pr_alert("rcutorture: WARN: Duplicate call_rcu() test starting.\n");
+	local_irq_disable(); /* Make it hard to finish grace period. */
+	call_rcu(&rh1, rcu_torture_leak_cb); /* start grace period. */
+	call_rcu(&rh2, rcu_torture_err_cb);
+	call_rcu(&rh2, rcu_torture_err_cb); /* duplicate callback. */
+	local_irq_enable();
+	rcu_barrier();
+	pr_alert("rcutorture: WARN: Duplicate call_rcu() test complete.\n");
+	destroy_rcu_head_on_stack(&rh1);
+	destroy_rcu_head_on_stack(&rh2);
+#else /* #ifdef CONFIG_DEBUG_OBJECTS_RCU_HEAD */
+	pr_alert("rcutorture: !CONFIG_DEBUG_OBJECTS_RCU_HEAD, not testing duplicate call_rcu()\n");
+#endif /* #else #ifdef CONFIG_DEBUG_OBJECTS_RCU_HEAD */
+}
+
 static int __init
 rcu_torture_init(void)
 {
@@ -2163,6 +2206,8 @@ rcu_torture_init(void)
 		firsterr = retval;
 		goto unwind;
 	}
+	if (object_debug)
+		rcu_test_debug_objects();
 	rcutorture_record_test_transition();
 	mutex_unlock(&fullstop_mutex);
 	return 0;
-- 
1.8.1.5

