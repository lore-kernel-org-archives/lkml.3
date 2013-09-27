Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753048Ab3I0IEX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Sep 2013 04:04:23 -0400
Received: from e06smtp10.uk.ibm.com ([195.75.94.106]:44932 "EHLO
	e06smtp10.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752792Ab3I0IEC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Sep 2013 04:04:02 -0400
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Tony Luck <tony.luck@intel.com>, Waiman Long <waiman.long@hp.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: [PATCH 1/3] mutex,spinlock: rename arch_mutex_cpu_relax() to cpu_relax_simple()
Date: Fri, 27 Sep 2013 10:03:52 +0200
Message-Id: <1380269034-38521-2-git-send-email-heiko.carstens@de.ibm.com>
X-Mailer: git-send-email 1.8.3.4
In-Reply-To: <1380269034-38521-1-git-send-email-heiko.carstens@de.ibm.com>
References: <1380269034-38521-1-git-send-email-heiko.carstens@de.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13092708-4966-0000-0000-00000706575E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

s390 needs a special version of cpu_relax() for the new lockref code.
The new variant should be a no-op but also have memory barrier semantics,
since that is what the default cpu_relax() variant implements.

Actually s390 had the same problem already in the past where we implemented
arch_mutex_cpu_relax() for nearly the same reason within the common mutex
code.
So before we end up adding a special arch_lockref_cpu_relax() variant which
would only differ in the name from arch_mutex_cpu_relax(), rename the
current arch_mutex_cpu_relax() variant to a more general cpu_relax_simple(),
which can be used also in the lockref code.

Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
---
 arch/Kconfig                      | 2 +-
 arch/s390/Kconfig                 | 2 +-
 arch/s390/include/asm/mutex.h     | 2 --
 arch/s390/include/asm/processor.h | 2 ++
 include/linux/mutex.h             | 4 ----
 include/linux/spinlock_up.h       | 4 ++++
 kernel/mutex.c                    | 8 ++++----
 7 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/arch/Kconfig b/arch/Kconfig
index 1feb169..74069bd 100644
--- a/arch/Kconfig
+++ b/arch/Kconfig
@@ -286,7 +286,7 @@ config HAVE_PERF_USER_STACK_DUMP
 config HAVE_ARCH_JUMP_LABEL
 	bool
 
-config HAVE_ARCH_MUTEX_CPU_RELAX
+config HAVE_CPU_RELAX_SIMPLE
 	bool
 
 config HAVE_RCU_TABLE_FREE
diff --git a/arch/s390/Kconfig b/arch/s390/Kconfig
index dcc6ac2..9789282 100644
--- a/arch/s390/Kconfig
+++ b/arch/s390/Kconfig
@@ -102,13 +102,13 @@ config S390
 	select GENERIC_TIME_VSYSCALL_OLD
 	select HAVE_ALIGNED_STRUCT_PAGE if SLUB
 	select HAVE_ARCH_JUMP_LABEL if !MARCH_G5
-	select HAVE_ARCH_MUTEX_CPU_RELAX
 	select HAVE_ARCH_SECCOMP_FILTER
 	select HAVE_ARCH_TRACEHOOK
 	select HAVE_ARCH_TRANSPARENT_HUGEPAGE if 64BIT
 	select HAVE_BPF_JIT if 64BIT && PACK_STACK
 	select HAVE_CMPXCHG_DOUBLE
 	select HAVE_CMPXCHG_LOCAL
+	select HAVE_CPU_RELAX_SIMPLE
 	select HAVE_C_RECORDMCOUNT
 	select HAVE_DEBUG_KMEMLEAK
 	select HAVE_DYNAMIC_FTRACE
diff --git a/arch/s390/include/asm/mutex.h b/arch/s390/include/asm/mutex.h
index 688271f..458c1f7 100644
--- a/arch/s390/include/asm/mutex.h
+++ b/arch/s390/include/asm/mutex.h
@@ -7,5 +7,3 @@
  */
 
 #include <asm-generic/mutex-dec.h>
-
-#define arch_mutex_cpu_relax()	barrier()
diff --git a/arch/s390/include/asm/processor.h b/arch/s390/include/asm/processor.h
index 0eb3750..338a488 100644
--- a/arch/s390/include/asm/processor.h
+++ b/arch/s390/include/asm/processor.h
@@ -198,6 +198,8 @@ static inline void cpu_relax(void)
 	barrier();
 }
 
+#define cpu_relax_simple()	barrier()
+
 static inline void psw_set_key(unsigned int key)
 {
 	asm volatile("spka 0(%0)" : : "d" (key));
diff --git a/include/linux/mutex.h b/include/linux/mutex.h
index ccd4260..084f799 100644
--- a/include/linux/mutex.h
+++ b/include/linux/mutex.h
@@ -175,8 +175,4 @@ extern void mutex_unlock(struct mutex *lock);
 
 extern int atomic_dec_and_mutex_lock(atomic_t *cnt, struct mutex *lock);
 
-#ifndef CONFIG_HAVE_ARCH_MUTEX_CPU_RELAX
-#define arch_mutex_cpu_relax()	cpu_relax()
-#endif
-
 #endif
diff --git a/include/linux/spinlock_up.h b/include/linux/spinlock_up.h
index 8b3ac0d..7e1cc42 100644
--- a/include/linux/spinlock_up.h
+++ b/include/linux/spinlock_up.h
@@ -7,6 +7,10 @@
 
 #include <asm/processor.h>	/* for cpu_relax() */
 
+#ifndef CONFIG_HAVE_CPU_RELAX_SIMPLE
+#define cpu_relax_simple()	cpu_relax()
+#endif
+
 /*
  * include/linux/spinlock_up.h - UP-debug version of spinlocks.
  *
diff --git a/kernel/mutex.c b/kernel/mutex.c
index 6d647ae..e0ce0da2 100644
--- a/kernel/mutex.c
+++ b/kernel/mutex.c
@@ -139,7 +139,7 @@ void mspin_lock(struct mspin_node **lock, struct mspin_node *node)
 	smp_wmb();
 	/* Wait until the lock holder passes the lock down */
 	while (!ACCESS_ONCE(node->locked))
-		arch_mutex_cpu_relax();
+		cpu_relax_simple();
 }
 
 static void mspin_unlock(struct mspin_node **lock, struct mspin_node *node)
@@ -154,7 +154,7 @@ static void mspin_unlock(struct mspin_node **lock, struct mspin_node *node)
 			return;
 		/* Wait until the next pointer is set */
 		while (!(next = ACCESS_ONCE(node->next)))
-			arch_mutex_cpu_relax();
+			cpu_relax_simple();
 	}
 	ACCESS_ONCE(next->locked) = 1;
 	smp_wmb();
@@ -192,7 +192,7 @@ int mutex_spin_on_owner(struct mutex *lock, struct task_struct *owner)
 		if (need_resched())
 			break;
 
-		arch_mutex_cpu_relax();
+		cpu_relax_simple();
 	}
 	rcu_read_unlock();
 
@@ -509,7 +509,7 @@ __mutex_lock_common(struct mutex *lock, long state, unsigned int subclass,
 		 * memory barriers as we'll eventually observe the right
 		 * values at the cost of a few extra spins.
 		 */
-		arch_mutex_cpu_relax();
+		cpu_relax_simple();
 	}
 slowpath:
 #endif
-- 
1.8.3.4

