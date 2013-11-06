Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755099Ab3KFTIW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 14:08:22 -0500
Received: from g6t0187.atlanta.hp.com ([15.193.32.64]:18651 "EHLO
	g6t0187.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754524Ab3KFTIU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 14:08:20 -0500
From: Waiman Long <Waiman.Long@hp.com>
To: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org, x86@kernel.org,
        Rik van Riel <riel@redhat.com>,
        Peter Hurley <peter@hurleysoftware.com>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>,
        Alex Shi <alex.shi@linaro.org>, Tim Chen <tim.c.chen@linux.intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Matthew R Wilcox <matthew.r.wilcox@intel.com>,
        Dave Hansen <dave.hansen@intel.com>,
        Michel Lespinasse <walken@google.com>,
        Andi Kleen <andi@firstfloor.org>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        George Spelvin <linux@horizon.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Arnd Bergmann <arnd@arndb.de>, Will Deacon <will.deacon@arm.com>,
        Aswin Chandramouleeswaran <aswin@hp.com>,
        Scott J Norton <scott.norton@hp.com>,
        Davidlohr Bueso <davidlohr@hp.com>, Jason Low <jason.low2@hp.com>,
        Waiman Long <Waiman.Long@hp.com>
Subject: [PATCH v2 5/5] MCS Lock: Allow architecture specific memory barrier in lock/unlock
Date: Wed,  6 Nov 2013 14:07:35 -0500
Message-Id: <1383764855-28949-1-git-send-email-Waiman.Long@hp.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch moves the decision of what kind of memory barriers to be
used in the MCS lock and unlock functions to the architecture specific
layer. It also moves the actual lock/unlock code to mcs_spinlock.c
file.

A full memory barrier will be used if the following macros are not
defined:
 1) smp_mb__before_critical_section()
 2) smp_mb__after_critical_section()

For the x86 architecture, only compiler barrier will be needed.

Signed-off-by: Waiman Long <Waiman.Long@hp.com>
---
 arch/x86/include/asm/barrier.h |    6 +++
 include/linux/mcs_spinlock.h   |   78 +-------------------------------------
 kernel/mcs_spinlock.c          |   81 ++++++++++++++++++++++++++++++++++++++-
 3 files changed, 86 insertions(+), 79 deletions(-)

diff --git a/arch/x86/include/asm/barrier.h b/arch/x86/include/asm/barrier.h
index c6cd358..6d0172c 100644
--- a/arch/x86/include/asm/barrier.h
+++ b/arch/x86/include/asm/barrier.h
@@ -92,6 +92,12 @@
 #endif
 #define smp_read_barrier_depends()	read_barrier_depends()
 #define set_mb(var, value) do { (void)xchg(&var, value); } while (0)
+
+#if !defined(CONFIG_X86_PPRO_FENCE) && !defined(CONFIG_X86_OOSTORE)
+# define smp_mb__before_critical_section()	barrier()
+# define smp_mb__after_critical_section()	barrier()
+#endif
+
 #else
 #define smp_mb()	barrier()
 #define smp_rmb()	barrier()
diff --git a/include/linux/mcs_spinlock.h b/include/linux/mcs_spinlock.h
index f2c71e8..d54bb23 100644
--- a/include/linux/mcs_spinlock.h
+++ b/include/linux/mcs_spinlock.h
@@ -12,19 +12,6 @@
 #ifndef __LINUX_MCS_SPINLOCK_H
 #define __LINUX_MCS_SPINLOCK_H
 
-/*
- * asm/processor.h may define arch_mutex_cpu_relax().
- * If it is not defined, cpu_relax() will be used.
- */
-#include <asm/barrier.h>
-#include <asm/cmpxchg.h>
-#include <asm/processor.h>
-#include <linux/compiler.h>
-
-#ifndef arch_mutex_cpu_relax
-# define arch_mutex_cpu_relax() cpu_relax()
-#endif
-
 struct mcs_spinlock {
 	struct mcs_spinlock *next;
 	int locked; /* 1 if lock acquired */
@@ -32,68 +19,7 @@ struct mcs_spinlock {
 
 extern
 void mcs_spin_lock(struct mcs_spinlock **lock, struct mcs_spinlock *node);
-
-/*
- * In order to acquire the lock, the caller should declare a local node and
- * pass a reference of the node to this function in addition to the lock.
- * If the lock has already been acquired, then this will proceed to spin
- * on this node->locked until the previous lock holder sets the node->locked
- * in mcs_spin_unlock().
- *
- * The _raw_mcs_spin_lock() function should not be called directly. Instead,
- * users should call mcs_spin_lock().
- */
-static inline
-void _raw_mcs_spin_lock(struct mcs_spinlock **lock, struct mcs_spinlock *node)
-{
-	struct mcs_spinlock *prev;
-
-	/* Init node */
-	node->locked = 0;
-	node->next   = NULL;
-
-	/* xchg() provides a memory barrier */
-	prev = xchg(lock, node);
-	if (likely(prev == NULL)) {
-		/* Lock acquired */
-		return;
-	}
-	ACCESS_ONCE(prev->next) = node;
-	/* Wait until the lock holder passes the lock down */
-	while (!ACCESS_ONCE(node->locked))
-		arch_mutex_cpu_relax();
-
-	/* Make sure subsequent operations happen after the lock is acquired */
-	smp_rmb();
-}
-
-/*
- * Releases the lock. The caller should pass in the corresponding node that
- * was used to acquire the lock.
- */
-static inline
-void mcs_spin_unlock(struct mcs_spinlock **lock, struct mcs_spinlock *node)
-{
-	struct mcs_spinlock *next = ACCESS_ONCE(node->next);
-
-	if (likely(!next)) {
-		/*
-		 * cmpxchg() provides a memory barrier.
-		 * Release the lock by setting it to NULL
-		 */
-		if (likely(cmpxchg(lock, node, NULL) == node))
-			return;
-		/* Wait until the next pointer is set */
-		while (!(next = ACCESS_ONCE(node->next)))
-			arch_mutex_cpu_relax();
-	} else {
-		/*
-		 * Make sure all operations within the critical section
-		 * happen before the lock is released.
-		 */
-		smp_wmb();
-	}
-	ACCESS_ONCE(next->locked) = 1;
-}
+extern
+void mcs_spin_unlock(struct mcs_spinlock **lock, struct mcs_spinlock *node);
 
 #endif /* __LINUX_MCS_SPINLOCK_H */
diff --git a/kernel/mcs_spinlock.c b/kernel/mcs_spinlock.c
index 309dd42..4a7bc4a 100644
--- a/kernel/mcs_spinlock.c
+++ b/kernel/mcs_spinlock.c
@@ -7,15 +7,90 @@
  * It avoids expensive cache bouncings that common test-and-set spin-lock
  * implementations incur.
  */
+/*
+ * asm/processor.h may define arch_mutex_cpu_relax().
+ * If it is not defined, cpu_relax() will be used.
+ */
+#include <asm/barrier.h>
+#include <asm/cmpxchg.h>
+#include <asm/processor.h>
+#include <linux/compiler.h>
 #include <linux/mcs_spinlock.h>
 #include <linux/export.h>
 
+#ifndef arch_mutex_cpu_relax
+# define arch_mutex_cpu_relax() cpu_relax()
+#endif
+
 /*
- * We don't inline mcs_spin_lock() so that perf can correctly account for the
- * time spent in this lock function.
+ * Fall back to use full memory barrier if those macros are not defined
+ * in a architecture specific header file.
+ */
+#ifndef smp_mb__before_critical_section
+#define	smp_mb__before_critical_section()	smp_mb()
+#endif
+
+#ifndef smp_mb__after_critical_section
+#define	smp_mb__after_critical_section()	smp_mb()
+#endif
+
+
+/*
+ * In order to acquire the lock, the caller should declare a local node and
+ * pass a reference of the node to this function in addition to the lock.
+ * If the lock has already been acquired, then this will proceed to spin
+ * on this node->locked until the previous lock holder sets the node->locked
+ * in mcs_spin_unlock().
  */
 void mcs_spin_lock(struct mcs_spinlock **lock, struct mcs_spinlock *node)
 {
-	_raw_mcs_spin_lock(lock, node);
+	struct mcs_spinlock *prev;
+
+	/* Init node */
+	node->locked = 0;
+	node->next   = NULL;
+
+	/* xchg() provides a memory barrier */
+	prev = xchg(lock, node);
+	if (likely(prev == NULL)) {
+		/* Lock acquired */
+		return;
+	}
+	ACCESS_ONCE(prev->next) = node;
+	/* Wait until the lock holder passes the lock down */
+	while (!ACCESS_ONCE(node->locked))
+		arch_mutex_cpu_relax();
+
+	/* Make sure subsequent operations happen after the lock is acquired */
+	smp_mb__before_critical_section();
 }
 EXPORT_SYMBOL(mcs_spin_lock);
+
+/*
+ * Releases the lock. The caller should pass in the corresponding node that
+ * was used to acquire the lock.
+ */
+void mcs_spin_unlock(struct mcs_spinlock **lock, struct mcs_spinlock *node)
+{
+	struct mcs_spinlock *next = ACCESS_ONCE(node->next);
+
+	if (likely(!next)) {
+		/*
+		 * cmpxchg() provides a memory barrier.
+		 * Release the lock by setting it to NULL
+		 */
+		if (likely(cmpxchg(lock, node, NULL) == node))
+			return;
+		/* Wait until the next pointer is set */
+		while (!(next = ACCESS_ONCE(node->next)))
+			arch_mutex_cpu_relax();
+	} else {
+		/*
+		 * Make sure all operations within the critical section
+		 * happen before the lock is released.
+		 */
+		smp_mb__after_critical_section();
+	}
+	ACCESS_ONCE(next->locked) = 1;
+}
+EXPORT_SYMBOL(mcs_spin_unlock);
-- 
1.7.1

