Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933374AbaD2A2B (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 20:28:01 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:36950 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933110AbaD2AZw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 20:25:52 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        oleg@redhat.com, sbw@mit.edu,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 43/45] torture: Check for multiple concurrent torture tests
Date: Mon, 28 Apr 2014 17:25:31 -0700
Message-Id: <1398731133-18925-43-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1398731133-18925-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20140429002455.GA15461@linux.vnet.ibm.com>
 <1398731133-18925-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14042900-0928-0000-0000-000001809EFA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

The torture tests are designed to run in isolation, but do not enforce
this isolation.  This commit therefore checks for concurrent torture
tests, and refuses to start new tests while old tests are running.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 include/linux/torture.h      |  2 +-
 kernel/locking/locktorture.c |  3 ++-
 kernel/rcu/rcutorture.c      |  3 ++-
 kernel/torture.c             | 13 +++++++++++--
 4 files changed, 16 insertions(+), 5 deletions(-)

diff --git a/include/linux/torture.h b/include/linux/torture.h
index b2e2b468e511..f998574247fd 100644
--- a/include/linux/torture.h
+++ b/include/linux/torture.h
@@ -81,7 +81,7 @@ void stutter_wait(const char *title);
 int torture_stutter_init(int s);
 
 /* Initialization and cleanup. */
-void torture_init_begin(char *ttype, bool v, int *runnable);
+bool torture_init_begin(char *ttype, bool v, int *runnable);
 void torture_init_end(void);
 bool torture_cleanup(void);
 bool torture_must_stop(void);
diff --git a/kernel/locking/locktorture.c b/kernel/locking/locktorture.c
index 1952466c7db5..dbafeac18e4d 100644
--- a/kernel/locking/locktorture.c
+++ b/kernel/locking/locktorture.c
@@ -355,7 +355,8 @@ static int __init lock_torture_init(void)
 		&lock_busted_ops, &spin_lock_ops, &spin_lock_irq_ops,
 	};
 
-	torture_init_begin(torture_type, verbose, &locktorture_runnable);
+	if (!torture_init_begin(torture_type, verbose, &locktorture_runnable))
+		return -EBUSY;
 
 	/* Process args and tell the world that the torturer is on the job. */
 	for (i = 0; i < ARRAY_SIZE(torture_ops); i++) {
diff --git a/kernel/rcu/rcutorture.c b/kernel/rcu/rcutorture.c
index b181b11c398e..1d8559198bd5 100644
--- a/kernel/rcu/rcutorture.c
+++ b/kernel/rcu/rcutorture.c
@@ -1535,7 +1535,8 @@ rcu_torture_init(void)
 		&rcu_ops, &rcu_bh_ops, &rcu_busted_ops, &srcu_ops, &sched_ops,
 	};
 
-	torture_init_begin(torture_type, verbose, &rcutorture_runnable);
+	if (!torture_init_begin(torture_type, verbose, &rcutorture_runnable))
+		return -EBUSY;
 
 	/* Process args and tell the world that the torturer is on the job. */
 	for (i = 0; i < ARRAY_SIZE(torture_ops); i++) {
diff --git a/kernel/torture.c b/kernel/torture.c
index c1d57e83e8fe..de440a46331c 100644
--- a/kernel/torture.c
+++ b/kernel/torture.c
@@ -599,14 +599,20 @@ static void torture_stutter_cleanup(void)
  * The runnable parameter points to a flag that controls whether or not
  * the test is currently runnable.  If there is no such flag, pass in NULL.
  */
-void __init torture_init_begin(char *ttype, bool v, int *runnable)
+bool __init torture_init_begin(char *ttype, bool v, int *runnable)
 {
 	mutex_lock(&fullstop_mutex);
+	if (torture_type != NULL) {
+		pr_alert("torture_init_begin: refusing %s init: %s running",
+			 ttype, torture_type);
+		mutex_unlock(&fullstop_mutex);
+		return false;
+	}
 	torture_type = ttype;
 	verbose = v;
 	torture_runnable = runnable;
 	fullstop = FULLSTOP_DONTSTOP;
-
+	return true;
 }
 EXPORT_SYMBOL_GPL(torture_init_begin);
 
@@ -645,6 +651,9 @@ bool torture_cleanup(void)
 	torture_shuffle_cleanup();
 	torture_stutter_cleanup();
 	torture_onoff_cleanup();
+	mutex_lock(&fullstop_mutex);
+	torture_type = NULL;
+	mutex_unlock(&fullstop_mutex);
 	return false;
 }
 EXPORT_SYMBOL_GPL(torture_cleanup);
-- 
1.8.1.5

