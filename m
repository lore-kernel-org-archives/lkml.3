Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751260AbaDUAH6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Apr 2014 20:07:58 -0400
Received: from mail-yk0-f177.google.com ([209.85.160.177]:45546 "EHLO
	mail-yk0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750908AbaDUAHz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Apr 2014 20:07:55 -0400
Message-ID: <53546158.3020906@gmail.com>
Date: Sun, 20 Apr 2014 20:07:52 -0400
From: Pranith Kumar <bobby.prani@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: paulmck@linux.vnet.ibm.com
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/1] rcu: cleanup: make rcutorture specific definitions
 depend on config value
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Seems that my previous mail was borked while copying the patch. Please find the fixed patch below:

make rcutorture specific variables in tree.c depend on CONFIG_RCU_TORTURE_TEST
This avoid having to have them when no torture tests are running.
Also cleanup some macros which are rcutorture specific.

Tested with rcutorture both in-built and as a module

Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>
---
 include/linux/rcupdate.h | 13 +++---------
 kernel/rcu/tree.c        | 54 ++++++++++++++++++++++++++----------------------
 kernel/rcu/tree_trace.c  |  7 +++++++
 3 files changed, 39 insertions(+), 35 deletions(-)

diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index 00a7fd6..b49e46b 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -49,16 +49,8 @@
 extern int rcu_expedited; /* for sysctl */
 #ifdef CONFIG_RCU_TORTURE_TEST
 extern int rcutorture_runnable; /* for sysctl */
-#endif /* #ifdef CONFIG_RCU_TORTURE_TEST */
-
-#if defined(CONFIG_TREE_RCU) || defined(CONFIG_TREE_PREEMPT_RCU)
 void rcutorture_record_test_transition(void);
 void rcutorture_record_progress(unsigned long vernum);
-void do_trace_rcu_torture_read(const char *rcutorturename,
-			       struct rcu_head *rhp,
-			       unsigned long secs,
-			       unsigned long c_old,
-			       unsigned long c);
 #else
 static inline void rcutorture_record_test_transition(void)
 {
@@ -66,7 +58,9 @@ static inline void rcutorture_record_test_transition(void)
 static inline void rcutorture_record_progress(unsigned long vernum)
 {
 }
-#ifdef CONFIG_RCU_TRACE
+#endif /* CONFIG_RCU_TORTURE_TEST */
+
+#if defined(CONFIG_TREE_RCU) || defined(CONFIG_TREE_PREEMPT_RCU) || defined(CONFIG_RCU_TRACE)
 void do_trace_rcu_torture_read(const char *rcutorturename,
 			       struct rcu_head *rhp,
 			       unsigned long secs,
@@ -76,7 +70,6 @@ void do_trace_rcu_torture_read(const char *rcutorturename,
 #define do_trace_rcu_torture_read(rcutorturename, rhp, secs, c_old, c) \
 	do { } while (0)
 #endif
-#endif
 
 #define UINT_CMP_GE(a, b)	(UINT_MAX / 2 >= (a) - (b))
 #define UINT_CMP_LT(a, b)	(UINT_MAX / 2 < (a) - (b))
diff --git a/kernel/rcu/tree.c b/kernel/rcu/tree.c
index 0c47e30..b455cd4 100644
--- a/kernel/rcu/tree.c
+++ b/kernel/rcu/tree.c
@@ -160,6 +160,8 @@ static void rcu_boost_kthread_setaffinity(struct rcu_node *rnp, int outgoingcpu)
 static void invoke_rcu_core(void);
 static void invoke_rcu_callbacks(struct rcu_state *rsp, struct rcu_data *rdp);
 
+#ifdef CONFIG_RCU_TORTURE_TEST
+
 /*
  * Track the rcutorture test sequence number and the update version
  * number within a given test.  The rcutorture_testseq is incremented
@@ -173,6 +175,33 @@ unsigned long rcutorture_testseq;
 unsigned long rcutorture_vernum;
 
 /*
+ * Record the number of times rcutorture tests have been initiated and
+ * terminated.  This information allows the debugfs tracing stats to be
+ * correlated to the rcutorture messages, even when the rcutorture module
+ * is being repeatedly loaded and unloaded.  In other words, we cannot
+ * store this state in rcutorture itself.
+ */
+void rcutorture_record_test_transition(void)
+{
+	rcutorture_testseq++;
+	rcutorture_vernum = 0;
+}
+EXPORT_SYMBOL_GPL(rcutorture_record_test_transition);
+
+/*
+ * Record the number of writer passes through the current rcutorture test.
+ * This is also used to correlate debugfs tracing stats with the rcutorture
+ * messages.
+ */
+void rcutorture_record_progress(unsigned long vernum)
+{
+	rcutorture_vernum++;
+}
+EXPORT_SYMBOL_GPL(rcutorture_record_progress);
+
+#endif /* CONFIG_RCU_TORTURE_TEST */
+
+/*
  * Return true if an RCU grace period is in progress.  The ACCESS_ONCE()s
  * permit this function to be invoked without holding the root rcu_node
  * structure's ->lock, but of course results can be subject to change.
@@ -280,31 +309,6 @@ void rcu_bh_force_quiescent_state(void)
 EXPORT_SYMBOL_GPL(rcu_bh_force_quiescent_state);
 
 /*
- * Record the number of times rcutorture tests have been initiated and
- * terminated.  This information allows the debugfs tracing stats to be
- * correlated to the rcutorture messages, even when the rcutorture module
- * is being repeatedly loaded and unloaded.  In other words, we cannot
- * store this state in rcutorture itself.
- */
-void rcutorture_record_test_transition(void)
-{
-	rcutorture_testseq++;
-	rcutorture_vernum = 0;
-}
-EXPORT_SYMBOL_GPL(rcutorture_record_test_transition);
-
-/*
- * Record the number of writer passes through the current rcutorture test.
- * This is also used to correlate debugfs tracing stats with the rcutorture
- * messages.
- */
-void rcutorture_record_progress(unsigned long vernum)
-{
-	rcutorture_vernum++;
-}
-EXPORT_SYMBOL_GPL(rcutorture_record_progress);
-
-/*
  * Force a quiescent state for RCU-sched.
  */
 void rcu_sched_force_quiescent_state(void)
diff --git a/kernel/rcu/tree_trace.c b/kernel/rcu/tree_trace.c
index 5cdc62e..3d10505 100644
--- a/kernel/rcu/tree_trace.c
+++ b/kernel/rcu/tree_trace.c
@@ -397,6 +397,8 @@ static const struct file_operations rcu_pending_fops = {
 	.release = seq_release,
 };
 
+#ifdef CONFIG_RCU_TORTURE_TEST
+
 static int show_rcutorture(struct seq_file *m, void *unused)
 {
 	seq_printf(m, "rcutorture test sequence: %lu %s\n",
@@ -420,6 +422,8 @@ static const struct file_operations rcutorture_fops = {
 	.release = single_release,
 };
 
+#endif /* CONFIG_RCU_TORTURE_TEST */
+
 static struct dentry *rcudir;
 
 static int __init rcutree_trace_init(void)
@@ -477,10 +481,13 @@ static int __init rcutree_trace_init(void)
 			goto free_out;
 	}
 
+#ifdef CONFIG_RCU_TORTURE_TEST
 	retval = debugfs_create_file("rcutorture", 0444, rcudir,
 						NULL, &rcutorture_fops);
 	if (!retval)
 		goto free_out;
+#endif
+
 	return 0;
 free_out:
 	debugfs_remove_recursive(rcudir);
-- 
1.9.1
