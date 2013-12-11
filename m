Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751742Ab3LKXI7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 18:08:59 -0500
Received: from e34.co.us.ibm.com ([32.97.110.152]:41809 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751507Ab3LKXI4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 18:08:56 -0500
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        oleg@redhat.com, sbw@mit.edu,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH v2 tip/core/rcu 4/4] rcu: Add an RCU_INITIALIZER for global RCU-protected pointers
Date: Wed, 11 Dec 2013 15:08:48 -0800
Message-Id: <1386803328-13272-4-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1386803328-13272-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20131211230823.GA12448@linux.vnet.ibm.com>
 <1386803328-13272-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13121123-1542-0000-0000-00000424C83B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

There is currently no way to initialize a global RCU-protected pointer
without either putting up with sparse complaints or open-coding an
obscure cast.  This commit therefore creates RCU_INITIALIZER(), which
is intended to be used as follows:

	struct foo __rcu *p = RCU_INITIALIZER(&my_rcu_structure);

This commit also applies RCU_INITIALIZER() to eliminate repeated
open-coded obscure casts in __rcu_assign_pointer(), RCU_INIT_POINTER(),
and RCU_POINTER_INITIALIZER().  This commit also inlines
__rcu_assign_pointer() into its only caller, rcu_assign_pointer().

Suggested-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

Conflicts:
	include/linux/rcupdate.h
---
 include/linux/rcupdate.h | 80 +++++++++++++++++++++++++-----------------------
 1 file changed, 42 insertions(+), 38 deletions(-)

diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index 97853cd2d7b4..ea3816cf1a13 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -548,10 +548,48 @@ static inline void rcu_preempt_sleep_check(void)
 		smp_read_barrier_depends(); \
 		(_________p1); \
 	})
-#define __rcu_assign_pointer(p, v, space) \
+
+/**
+ * RCU_INITIALIZER() - statically initialize an RCU-protected global variable
+ * @v: The value to statically initialize with.
+ */
+#define RCU_INITIALIZER(v) (typeof(*(v)) __force __rcu *)(v)
+
+/**
+ * rcu_assign_pointer() - assign to RCU-protected pointer
+ * @p: pointer to assign to
+ * @v: value to assign (publish)
+ *
+ * Assigns the specified value to the specified RCU-protected
+ * pointer, ensuring that any concurrent RCU readers will see
+ * any prior initialization.
+ *
+ * Inserts memory barriers on architectures that require them
+ * (which is most of them), and also prevents the compiler from
+ * reordering the code that initializes the structure after the pointer
+ * assignment.  More importantly, this call documents which pointers
+ * will be dereferenced by RCU read-side code.
+ *
+ * In some special cases, you may use RCU_INIT_POINTER() instead
+ * of rcu_assign_pointer().  RCU_INIT_POINTER() is a bit faster due
+ * to the fact that it does not constrain either the CPU or the compiler.
+ * That said, using RCU_INIT_POINTER() when you should have used
+ * rcu_assign_pointer() is a very bad thing that results in
+ * impossible-to-diagnose memory corruption.  So please be careful.
+ * See the RCU_INIT_POINTER() comment header for details.
+ *
+ * Note that rcu_assign_pointer() evaluates each of its arguments only
+ * once, appearances notwithstanding.  One of the "extra" evaluations
+ * is in typeof() and the other visible only to sparse (__CHECKER__),
+ * neither of which actually execute the argument.  As with most cpp
+ * macros, this execute-arguments-only-once property is important, so
+ * please be careful when making changes to rcu_assign_pointer() and the
+ * other macros that it invokes.
+ */
+#define rcu_assign_pointer(p, v) \
 	do { \
 		smp_wmb(); \
-		ACCESS_ONCE(p) = (typeof(*(v)) __force space *)(v); \
+		ACCESS_ONCE(p) = RCU_INITIALIZER(v); \
 	} while (0)
 
 
@@ -890,40 +928,6 @@ static inline notrace void rcu_read_unlock_sched_notrace(void)
 }
 
 /**
- * rcu_assign_pointer() - assign to RCU-protected pointer
- * @p: pointer to assign to
- * @v: value to assign (publish)
- *
- * Assigns the specified value to the specified RCU-protected
- * pointer, ensuring that any concurrent RCU readers will see
- * any prior initialization.
- *
- * Inserts memory barriers on architectures that require them
- * (which is most of them), and also prevents the compiler from
- * reordering the code that initializes the structure after the pointer
- * assignment.  More importantly, this call documents which pointers
- * will be dereferenced by RCU read-side code.
- *
- * In some special cases, you may use RCU_INIT_POINTER() instead
- * of rcu_assign_pointer().  RCU_INIT_POINTER() is a bit faster due
- * to the fact that it does not constrain either the CPU or the compiler.
- * That said, using RCU_INIT_POINTER() when you should have used
- * rcu_assign_pointer() is a very bad thing that results in
- * impossible-to-diagnose memory corruption.  So please be careful.
- * See the RCU_INIT_POINTER() comment header for details.
- *
- * Note that rcu_assign_pointer() evaluates each of its arguments only
- * once, appearances notwithstanding.  One of the "extra" evaluations
- * is in typeof() and the other visible only to sparse (__CHECKER__),
- * neither of which actually execute the argument.  As with most cpp
- * macros, this execute-arguments-only-once property is important, so
- * please be careful when making changes to rcu_assign_pointer() and the
- * other macros that it invokes.
- */
-#define rcu_assign_pointer(p, v) \
-	__rcu_assign_pointer((p), (v), __rcu)
-
-/**
  * RCU_INIT_POINTER() - initialize an RCU protected pointer
  *
  * Initialize an RCU-protected pointer in special cases where readers
@@ -957,7 +961,7 @@ static inline notrace void rcu_read_unlock_sched_notrace(void)
  */
 #define RCU_INIT_POINTER(p, v) \
 	do { \
-		p = (typeof(*v) __force __rcu *)(v); \
+		p = RCU_INITIALIZER(v); \
 	} while (0)
 
 /**
@@ -966,7 +970,7 @@ static inline notrace void rcu_read_unlock_sched_notrace(void)
  * GCC-style initialization for an RCU-protected pointer in a structure field.
  */
 #define RCU_POINTER_INITIALIZER(p, v) \
-		.p = (typeof(*v) __force __rcu *)(v)
+		.p = RCU_INITIALIZER(v)
 
 /*
  * Does the specified offset indicate that the corresponding rcu_head
-- 
1.8.1.5

