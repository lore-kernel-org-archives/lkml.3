Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751156AbaDTV5S (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Apr 2014 17:57:18 -0400
Received: from mxip4-inbound.gatech.edu ([130.207.182.13]:2501 "EHLO
	mxip4-inbound.gatech.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750967AbaDTV5P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Apr 2014 17:57:15 -0400
X-RemoteIP: 130.207.185.163
X-Group: ZimbraSenderGroup
X-Policy: $ZIMBRA
X-MID: 79926639
X-SBRS: None
X-IronPort-AV: E=Sophos;i="4.97,894,1389762000"; 
   d="scan'208";a="79926639"
X-GT-Spam-Rating: (0%)
Message-ID: <535442DB.80208@gatech.edu>
Date: Sun, 20 Apr 2014 17:57:47 -0400
From: Pranith Kumar <pranith@gatech.edu>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: paulmck@linux.vnet.ibm.com
CC: linux-kernel@vger.kernel.org
Subject: [PATCH 1/1] rcu: cleanup: make rcutorture specific definitions depend
 on config value
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

make rcutorture specific variables in tree.c depend on CONFIG_RCU_TORTURE_TEST
This avoid having to have them when no torture tests are running.
Also cleanup some macros which are rcutorture specific.

Tested with rcutorture both in-built and as a module


Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>
---
 include/linux/rcupdate.h |   13 +++----------
 kernel/rcu/tree.c        |   29 +++++++++++++++++------------
 kernel/rcu/tree_trace.c  |    7 +++++++
 3 files changed, 27 insertions(+), 22 deletions(-)

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
index 0c47e30..d1dc83b 100644
--- a/kernel/rcu/tree.c
+++ b/kernel/rcu/tree.c
@@ -161,18 +161,6 @@ static void invoke_rcu_core(void);
 static void invoke_rcu_callbacks(struct rcu_state *rsp, struct rcu_data *rdp);
 
 /*
- * Track the rcutorture test sequence number and the update version
- * number within a given test.  The rcutorture_testseq is incremented
- * on every rcutorture module load and unload, so has an odd value
- * when a test is running.  The rcutorture_vernum is set to zero
- * when rcutorture starts and is incremented on each rcutorture update.
- * These variables enable correlating rcutorture output with the
- * RCU tracing information.
- */
-unsigned long rcutorture_testseq;
-unsigned long rcutorture_vernum;
-
-/*
  * Return true if an RCU grace period is in progress.  The ACCESS_ONCE()s
  * permit this function to be invoked without holding the root rcu_node
  * structure's ->lock, but of course results can be subject to change.
@@ -279,6 +267,21 @@ void rcu_bh_force_quiescent_state(void)
 }
 EXPORT_SYMBOL_GPL(rcu_bh_force_quiescent_state);
 
+#ifdef CONFIG_RCU_TORTURE_TEST
+
+/*
+ * Track the rcutorture test sequence number and the update version
+ * number within a given test.  The rcutorture_testseq is incremented
+ * on every rcutorture module load and unload, so has an odd value
+ * when a test is running.  The rcutorture_vernum is set to zero
+ * when rcutorture starts and is incremented on each rcutorture update.
+ * These variables enable correlating rcutorture output with the
+ * RCU tracing information.
+ */
+unsigned long rcutorture_testseq;
+unsigned long rcutorture_vernum;
+
+
 /*
