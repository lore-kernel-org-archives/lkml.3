Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031577Ab3HIXEc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Aug 2013 19:04:32 -0400
Received: from mga11.intel.com ([192.55.52.93]:10655 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031549Ab3HIXE3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Aug 2013 19:04:29 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,849,1367996400"; 
   d="scan'208";a="384045633"
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: x86@kernel.org, mingo@kernel.org, torvalds@linux-foundation.org,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 04/13] Move might_sleep and friends from kernel.h to sched.h
Date: Fri,  9 Aug 2013 16:04:11 -0700
Message-Id: <1376089460-5459-5-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1376089460-5459-1-git-send-email-andi@firstfloor.org>
References: <1376089460-5459-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

These are really related to scheduling, so they should be in sched.h
Users usually will need to schedule anyways.

The advantage of having them there is that we can access some of the
scheduler inlines to make their fast path more efficient. This will come
in a followon patch.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 include/linux/kernel.h | 35 -----------------------------------
 include/linux/sched.h  | 38 ++++++++++++++++++++++++++++++++++++++
 2 files changed, 38 insertions(+), 35 deletions(-)

diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index 482ad2d..badcc13 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -141,35 +141,6 @@ struct completion;
 struct pt_regs;
 struct user;
 
-#ifdef CONFIG_PREEMPT_VOLUNTARY
-extern int _cond_resched(void);
-# define might_resched() _cond_resched()
-#else
-# define might_resched() do { } while (0)
-#endif
-
-#ifdef CONFIG_DEBUG_ATOMIC_SLEEP
-  void __might_sleep(const char *file, int line, int preempt_offset);
-/**
- * might_sleep - annotation for functions that can sleep
- *
- * this macro will print a stack trace if it is executed in an atomic
- * context (spinlock, irq-handler, ...).
- *
- * This is a useful debugging help to be able to catch problems early and not
- * be bitten later when the calling function happens to sleep when it is not
- * supposed to.
- */
-# define might_sleep() \
-	do { __might_sleep(__FILE__, __LINE__, 0); might_resched(); } while (0)
-#else
-  static inline void __might_sleep(const char *file, int line,
-				   int preempt_offset) { }
-# define might_sleep() do { might_resched(); } while (0)
-#endif
-
-#define might_sleep_if(cond) do { if (cond) might_sleep(); } while (0)
-
 /*
  * abs() handles unsigned and signed longs, ints, shorts and chars.  For all
  * input types abs() returns a signed long.
@@ -193,12 +164,6 @@ extern int _cond_resched(void);
 		(__x < 0) ? -__x : __x;		\
 	})
 
-#if defined(CONFIG_PROVE_LOCKING) || defined(CONFIG_DEBUG_ATOMIC_SLEEP)
-void might_fault(void);
-#else
-static inline void might_fault(void) { }
-#endif
-
 extern struct atomic_notifier_head panic_notifier_list;
 extern long (*panic_blink)(int state);
 __printf(1, 2)
diff --git a/include/linux/sched.h b/include/linux/sched.h
index d722490..773f21d 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -2433,6 +2433,35 @@ extern int __cond_resched_softirq(void);
 	__cond_resched_softirq();					\
 })
 
+#ifdef CONFIG_PREEMPT_VOLUNTARY
+extern int _cond_resched(void);
+# define might_resched() _cond_resched()
+#else
+# define might_resched() do { } while (0)
+#endif
+
+#ifdef CONFIG_DEBUG_ATOMIC_SLEEP
+ void __might_sleep(const char *file, int line, int preempt_offset);
+/**
+ * might_sleep - annotation for functions that can sleep
+ *
+ * this macro will print a stack trace if it is executed in an atomic
+ * context (spinlock, irq-handler, ...).
+ *
+ * This is a useful debugging help to be able to catch problems early and not
+ * be bitten later when the calling function happens to sleep when it is not
+ * supposed to.
+ */
+# define might_sleep() \
+	do { __might_sleep(__FILE__, __LINE__, 0); might_resched(); } while (0)
+#else
+  static inline void __might_sleep(const char *file, int line,
+				   int preempt_offset) { }
+# define might_sleep() do { might_resched(); } while (0)
+#endif
+
+#define might_sleep_if(cond) do { if (cond) might_sleep(); } while (0)
+
 static inline void cond_resched_rcu(void)
 {
 #if defined(CONFIG_DEBUG_ATOMIC_SLEEP) || !defined(CONFIG_PREEMPT_RCU)
@@ -2442,6 +2471,15 @@ static inline void cond_resched_rcu(void)
 #endif
 }
 
+#ifdef CONFIG_PROVE_LOCKING
+void might_fault(void);
+#else
+static inline void might_fault(void)
+{
+	might_sleep();
+}
+#endif
+
 /*
  * Does a critical section need to be broken due to another
  * task waiting?: (technically does not depend on CONFIG_PREEMPT,
-- 
1.8.3.1

