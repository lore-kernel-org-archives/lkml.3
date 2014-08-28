Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752216AbaH1S0s (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 14:26:48 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:50675 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751679AbaH1S0o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 14:26:44 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, tglx@linutronix.de, peterz@infradead.org,
        rostedt@goodmis.org, dhowells@redhat.com, edumazet@google.com,
        dvhart@linux.intel.com, fweisbec@gmail.com, oleg@redhat.com,
        bobby.prani@gmail.com, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 07/15] rcu: Uninline rcu_read_lock_held()
Date: Thu, 28 Aug 2014 11:26:26 -0700
Message-Id: <1409250394-25159-7-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1409250394-25159-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20140828182614.GA23877@linux.vnet.ibm.com>
 <1409250394-25159-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14082818-1542-0000-0000-0000045F4DFE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Oleg Nesterov <oleg@redhat.com>

This commit uninlines rcu_read_lock_held(). According to "size vmlinux"
this saves 28549 in .text:

	- 5541731 3014560 14757888 23314179
	+ 5513182 3026848 14757888 23297918

Note: it looks as if the data grows by 12288 bytes but this is not true,
it does not actually grow. But .data starts with ALIGN(THREAD_SIZE) and
since .text shrinks the padding grows, and thus .data grows too as it
seen by /bin/size. diff System.map:

	- ffffffff81510000 D _sdata
	- ffffffff81510000 D init_thread_union
	+ ffffffff81509000 D _sdata
	+ ffffffff8150c000 D init_thread_union

Perhaps we can change vmlinux.lds.S to .data itself, so that /bin/size
can't "wrongly" report that .data grows if .text shinks.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 include/linux/rcupdate.h | 36 +-----------------------------------
 kernel/rcu/update.c      | 32 ++++++++++++++++++++++++++++++++
 2 files changed, 33 insertions(+), 35 deletions(-)

diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index 7e47e44bce03..321ed0d4e675 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -371,41 +371,7 @@ extern struct lockdep_map rcu_sched_lock_map;
 extern struct lockdep_map rcu_callback_map;
 int debug_lockdep_rcu_enabled(void);
 
-/**
- * rcu_read_lock_held() - might we be in RCU read-side critical section?
- *
- * If CONFIG_DEBUG_LOCK_ALLOC is selected, returns nonzero iff in an RCU
- * read-side critical section.  In absence of CONFIG_DEBUG_LOCK_ALLOC,
- * this assumes we are in an RCU read-side critical section unless it can
- * prove otherwise.  This is useful for debug checks in functions that
- * require that they be called within an RCU read-side critical section.
- *
- * Checks debug_lockdep_rcu_enabled() to prevent false positives during boot
- * and while lockdep is disabled.
- *
- * Note that rcu_read_lock() and the matching rcu_read_unlock() must
- * occur in the same context, for example, it is illegal to invoke
- * rcu_read_unlock() in process context if the matching rcu_read_lock()
- * was invoked from within an irq handler.
- *
- * Note that rcu_read_lock() is disallowed if the CPU is either idle or
- * offline from an RCU perspective, so check for those as well.
- */
-static inline int rcu_read_lock_held(void)
-{
-	if (!debug_lockdep_rcu_enabled())
-		return 1;
-	if (!rcu_is_watching())
-		return 0;
-	if (!rcu_lockdep_current_cpu_online())
-		return 0;
-	return lock_is_held(&rcu_lock_map);
-}
-
-/*
- * rcu_read_lock_bh_held() is defined out of line to avoid #include-file
- * hell.
- */
+int rcu_read_lock_held(void);
 int rcu_read_lock_bh_held(void);
 
 /**
diff --git a/kernel/rcu/update.c b/kernel/rcu/update.c
index 4056d7992a6c..ea8ea7b16e11 100644
--- a/kernel/rcu/update.c
+++ b/kernel/rcu/update.c
@@ -137,6 +137,38 @@ int notrace debug_lockdep_rcu_enabled(void)
 EXPORT_SYMBOL_GPL(debug_lockdep_rcu_enabled);
 
 /**
+ * rcu_read_lock_held() - might we be in RCU read-side critical section?
+ *
+ * If CONFIG_DEBUG_LOCK_ALLOC is selected, returns nonzero iff in an RCU
+ * read-side critical section.  In absence of CONFIG_DEBUG_LOCK_ALLOC,
+ * this assumes we are in an RCU read-side critical section unless it can
+ * prove otherwise.  This is useful for debug checks in functions that
+ * require that they be called within an RCU read-side critical section.
+ *
+ * Checks debug_lockdep_rcu_enabled() to prevent false positives during boot
+ * and while lockdep is disabled.
+ *
+ * Note that rcu_read_lock() and the matching rcu_read_unlock() must
+ * occur in the same context, for example, it is illegal to invoke
+ * rcu_read_unlock() in process context if the matching rcu_read_lock()
+ * was invoked from within an irq handler.
+ *
+ * Note that rcu_read_lock() is disallowed if the CPU is either idle or
+ * offline from an RCU perspective, so check for those as well.
+ */
+int rcu_read_lock_held(void)
+{
+	if (!debug_lockdep_rcu_enabled())
+		return 1;
+	if (!rcu_is_watching())
+		return 0;
+	if (!rcu_lockdep_current_cpu_online())
+		return 0;
+	return lock_is_held(&rcu_lock_map);
+}
+EXPORT_SYMBOL_GPL(rcu_read_lock_held);
+
+/**
  * rcu_read_lock_bh_held() - might we be in RCU-bh read-side critical section?
  *
  * Check for bottom half being disabled, which covers both the
-- 
1.8.1.5

