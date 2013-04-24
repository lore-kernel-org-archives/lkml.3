Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757373Ab3DXAeB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 20:34:01 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:47919 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756598Ab3DXAd5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 20:33:57 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, edumazet@google.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Sedat Dilek <sedat.dilek@gmail.com>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>,
        Rik van Riel <riel@surriel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH tip/core/rcu 4/4] rcu: Add duplicate-callback tests to rcutorture
Date: Tue, 23 Apr 2013 17:33:46 -0700
Message-Id: <1366763626-16712-4-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1366763626-16712-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20130424003312.GA15819@linux.vnet.ibm.com>
 <1366763626-16712-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13042400-7408-0000-0000-00000F59D563
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
---
 kernel/rcutorture.c | 37 +++++++++++++++++++++++++++++++++++++
 1 file changed, 37 insertions(+)

diff --git a/kernel/rcutorture.c b/kernel/rcutorture.c
index b1fa551..2f34ebf 100644
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
@@ -1934,6 +1937,18 @@ rcu_torture_cleanup(void)
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
 static int __init
 rcu_torture_init(void)
 {
@@ -2163,6 +2178,28 @@ rcu_torture_init(void)
 		firsterr = retval;
 		goto unwind;
 	}
+	if (object_debug) {
+#ifdef CONFIG_DEBUG_OBJECTS_RCU_HEAD
+		struct rcu_head rh1;
+		struct rcu_head rh2;
+
+		init_rcu_head_on_stack(&rh1);
+		init_rcu_head_on_stack(&rh2);
+		pr_alert("rcutorture: Duplicate call_rcu() test starting.\n");
+		local_irq_disable(); /* Make it hard to finish grace period. */
+		call_rcu(&rh1, rcu_torture_leak_cb); /* start grace period. */
+		call_rcu(&rh2, rcu_torture_err_cb);
+		call_rcu(&rh2, rcu_torture_err_cb); /* duplicate callback. */
+		local_irq_enable();
+		rcu_barrier();
+		pr_alert("rcutorture: Duplicate call_rcu() test complete.\n");
+		destroy_rcu_head_on_stack(&rh1);
+		destroy_rcu_head_on_stack(&rh2);
+#else /* #ifdef CONFIG_DEBUG_OBJECTS_RCU_HEAD */
+		pr_alert("rcutorture: !%s, not testing duplicate call_rcu()\n",
+			 "CONFIG_DEBUG_OBJECTS_RCU_HEAD");
+#endif /* #else #ifdef CONFIG_DEBUG_OBJECTS_RCU_HEAD */
+	}
 	rcutorture_record_test_transition();
 	mutex_unlock(&fullstop_mutex);
 	return 0;
-- 
1.8.1.5

