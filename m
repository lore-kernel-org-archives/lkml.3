Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751810AbaAOEpF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 23:45:05 -0500
Received: from g6t0187.atlanta.hp.com ([15.193.32.64]:34616 "EHLO
	g6t0187.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751538AbaAOEoc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 23:44:32 -0500
From: Waiman Long <Waiman.Long@hp.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Arnd Bergmann <arnd@arndb.de>
Cc: linux-arch@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michel Lespinasse <walken@google.com>,
        Andi Kleen <andi@firstfloor.org>, Rik van Riel <riel@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        George Spelvin <linux@horizon.com>,
        Tim Chen <tim.c.chen@linux.intel.com>,
        "Aswin Chandramouleeswaran\"" <aswin@hp.com>,
        Scott J Norton <scott.norton@hp.com>, Waiman Long <Waiman.Long@hp.com>
Subject: [PATCH v9 4/5] qrwlock: Use smp_store_release() in write_unlock()
Date: Tue, 14 Jan 2014 23:44:06 -0500
Message-Id: <1389761047-47566-5-git-send-email-Waiman.Long@hp.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1389761047-47566-1-git-send-email-Waiman.Long@hp.com>
References: <1389761047-47566-1-git-send-email-Waiman.Long@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch modifies the queue_write_unlock() function to use the new
smp_store_release() function (currently in tip). It also removes the
temporary implementation of smp_load_acquire() and smp_store_release()
function in qrwlock.c.

This patch will use atomic subtraction instead if the writer field is
not atomic.

Signed-off-by: Waiman Long <Waiman.Long@hp.com>
---
 include/asm-generic/qrwlock.h |   10 ++++++----
 kernel/locking/qrwlock.c      |   34 ----------------------------------
 2 files changed, 6 insertions(+), 38 deletions(-)

diff --git a/include/asm-generic/qrwlock.h b/include/asm-generic/qrwlock.h
index 5abb6ca..68f488b 100644
--- a/include/asm-generic/qrwlock.h
+++ b/include/asm-generic/qrwlock.h
@@ -181,11 +181,13 @@ static inline void queue_read_unlock(struct qrwlock *lock)
 static inline void queue_write_unlock(struct qrwlock *lock)
 {
 	/*
-	 * Make sure that none of the critical section will be leaked out.
+	 * If the writer field is atomic, it can be cleared directly.
+	 * Otherwise, an atomic subtraction will be used to clear it.
 	 */
-	smp_mb__before_clear_bit();
-	ACCESS_ONCE(lock->cnts.writer) = 0;
-	smp_mb__after_clear_bit();
+	if (__native_word(lock->cnts.writer))
+		smp_store_release(&lock->cnts.writer, 0);
+	else
+		atomic_sub(_QW_LOCKED, &lock->cnts.rwa);
 }
 
 /*
diff --git a/kernel/locking/qrwlock.c b/kernel/locking/qrwlock.c
index 053be4d..2727188 100644
--- a/kernel/locking/qrwlock.c
+++ b/kernel/locking/qrwlock.c
@@ -47,40 +47,6 @@
 # define arch_mutex_cpu_relax() cpu_relax()
 #endif
 
-#ifndef smp_load_acquire
-# ifdef CONFIG_X86
-#   define smp_load_acquire(p)				\
-	({						\
-		typeof(*p) ___p1 = ACCESS_ONCE(*p);	\
-		barrier();				\
-		___p1;					\
-	})
-# else
-#   define smp_load_acquire(p)				\
-	({						\
-		typeof(*p) ___p1 = ACCESS_ONCE(*p);	\
-		smp_mb();				\
-		___p1;					\
-	})
-# endif
-#endif
-
-#ifndef smp_store_release
-# ifdef CONFIG_X86
-#   define smp_store_release(p, v)			\
-	do {						\
-		barrier();				\
-		ACCESS_ONCE(*p) = v;			\
-	} while (0)
-# else
-#   define smp_store_release(p, v)			\
-	do {						\
-		smp_mb();				\
-		ACCESS_ONCE(*p) = v;			\
-	} while (0)
-# endif
-#endif
-
 /*
  * If an xadd (exchange-add) macro isn't available, simulate one with
  * the atomic_add_return() function.
-- 
1.7.1

