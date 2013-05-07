Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758232Ab3EGEGt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 00:06:49 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:26614 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760140Ab3EGD6v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 23:58:51 -0400
X-Authority-Analysis: v=2.0 cv=DKcNElxb c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=6F3_6QC1e2kA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=bVDunnr4JToA:10 a=Z4Rwk6OoAAAA:8 a=VwQbUJbxAAAA:8 a=20KFwNOVAAAA:8 a=JfrnYn6hAAAA:8 a=DCx0ZCupzBAmvdwRGRsA:9 a=jbrJJM5MRmoA:10 a=jEp0ucaQiEUA:10 a=3Rfx1nUSh_UA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130507035845.231490192@goodmis.org>
User-Agent: quilt/0.60-1
Date: Mon, 06 May 2013 23:57:38 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Steven Rostedt <srostedt@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: [026/126] spinlocks and preemption points need to be at least compiler
 barriers
References: <20130507035712.909872333@goodmis.org>
Content-Disposition: inline; filename=0026-spinlocks-and-preemption-points-need-to-be-at-least-.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.3 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Linus Torvalds <torvalds@linux-foundation.org>

[ Upstream commit 386afc91144b36b42117b0092893f15bc8798a80 ]

In UP and non-preempt respectively, the spinlocks and preemption
disable/enable points are stubbed out entirely, because there is no
regular code that can ever hit the kind of concurrency they are meant to
protect against.

However, while there is no regular code that can cause scheduling, we
_do_ end up having some exceptional (literally!) code that can do so,
and that we need to make sure does not ever get moved into the critical
region by the compiler.

In particular, get_user() and put_user() is generally implemented as
inline asm statements (even if the inline asm may then make a call
instruction to call out-of-line), and can obviously cause a page fault
and IO as a result.  If that inline asm has been scheduled into the
middle of a preemption-safe (or spinlock-protected) code region, we
obviously lose.

Now, admittedly this is *very* unlikely to actually ever happen, and
we've not seen examples of actual bugs related to this.  But partly
exactly because it's so hard to trigger and the resulting bug is so
subtle, we should be extra careful to get this right.

So make sure that even when preemption is disabled, and we don't have to
generate any actual *code* to explicitly tell the system that we are in
a preemption-disabled region, we need to at least tell the compiler not
to move things around the critical region.

This patch grew out of the same discussion that caused commits
79e5f05edcbf ("ARC: Add implicit compiler barrier to raw_local_irq*
functions") and 3e2e0d2c222b ("tile: comment assumption about
__insn_mtspr for <asm/irqflags.h>") to come about.

Note for stable: use discretion when/if applying this.  As mentioned,
this bug may never have actually bitten anybody, and gcc may never have
done the required code motion for it to possibly ever trigger in
practice.

Cc: stable@vger.kernel.org
Cc: Steven Rostedt <srostedt@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/linux/preempt.h     |   22 ++++++++++++++--------
 include/linux/spinlock_up.h |   29 ++++++++++++++++++-----------
 2 files changed, 32 insertions(+), 19 deletions(-)

diff --git a/include/linux/preempt.h b/include/linux/preempt.h
index 5a710b9..87a03c7 100644
--- a/include/linux/preempt.h
+++ b/include/linux/preempt.h
@@ -93,14 +93,20 @@ do { \
 
 #else /* !CONFIG_PREEMPT_COUNT */
 
-#define preempt_disable()		do { } while (0)
-#define sched_preempt_enable_no_resched()	do { } while (0)
-#define preempt_enable_no_resched()	do { } while (0)
-#define preempt_enable()		do { } while (0)
-
-#define preempt_disable_notrace()		do { } while (0)
-#define preempt_enable_no_resched_notrace()	do { } while (0)
-#define preempt_enable_notrace()		do { } while (0)
+/*
+ * Even if we don't have any preemption, we need preempt disable/enable
+ * to be barriers, so that we don't have things like get_user/put_user
+ * that can cause faults and scheduling migrate into our preempt-protected
+ * region.
+ */
+#define preempt_disable()		barrier()
+#define sched_preempt_enable_no_resched()	barrier()
+#define preempt_enable_no_resched()	barrier()
+#define preempt_enable()		barrier()
+
+#define preempt_disable_notrace()		barrier()
+#define preempt_enable_no_resched_notrace()	barrier()
+#define preempt_enable_notrace()		barrier()
 
 #endif /* CONFIG_PREEMPT_COUNT */
 
diff --git a/include/linux/spinlock_up.h b/include/linux/spinlock_up.h
index a26e2fb..e2369c1 100644
--- a/include/linux/spinlock_up.h
+++ b/include/linux/spinlock_up.h
@@ -16,7 +16,10 @@
  * In the debug case, 1 means unlocked, 0 means locked. (the values
  * are inverted, to catch initialization bugs)
  *
- * No atomicity anywhere, we are on UP.
+ * No atomicity anywhere, we are on UP. However, we still need
+ * the compiler barriers, because we do not want the compiler to
+ * move potentially faulting instructions (notably user accesses)
+ * into the locked sequence, resulting in non-atomic execution.
  */
 
 #ifdef CONFIG_DEBUG_SPINLOCK
@@ -25,6 +28,7 @@
 static inline void arch_spin_lock(arch_spinlock_t *lock)
 {
 	lock->slock = 0;
+	barrier();
 }
 
 static inline void
@@ -32,6 +36,7 @@ arch_spin_lock_flags(arch_spinlock_t *lock, unsigned long flags)
 {
 	local_irq_save(flags);
 	lock->slock = 0;
+	barrier();
 }
 
 static inline int arch_spin_trylock(arch_spinlock_t *lock)
@@ -39,32 +44,34 @@ static inline int arch_spin_trylock(arch_spinlock_t *lock)
 	char oldval = lock->slock;
 
 	lock->slock = 0;
+	barrier();
 
 	return oldval > 0;
 }
 
 static inline void arch_spin_unlock(arch_spinlock_t *lock)
 {
+	barrier();
 	lock->slock = 1;
 }
 
 /*
  * Read-write spinlocks. No debug version.
  */
-#define arch_read_lock(lock)		do { (void)(lock); } while (0)
-#define arch_write_lock(lock)		do { (void)(lock); } while (0)
-#define arch_read_trylock(lock)	({ (void)(lock); 1; })
-#define arch_write_trylock(lock)	({ (void)(lock); 1; })
-#define arch_read_unlock(lock)		do { (void)(lock); } while (0)
-#define arch_write_unlock(lock)	do { (void)(lock); } while (0)
+#define arch_read_lock(lock)		do { barrier(); (void)(lock); } while (0)
+#define arch_write_lock(lock)		do { barrier(); (void)(lock); } while (0)
+#define arch_read_trylock(lock)	({ barrier(); (void)(lock); 1; })
+#define arch_write_trylock(lock)	({ barrier(); (void)(lock); 1; })
+#define arch_read_unlock(lock)		do { barrier(); (void)(lock); } while (0)
+#define arch_write_unlock(lock)	do { barrier(); (void)(lock); } while (0)
 
 #else /* DEBUG_SPINLOCK */
 #define arch_spin_is_locked(lock)	((void)(lock), 0)
 /* for sched.c and kernel_lock.c: */
-# define arch_spin_lock(lock)		do { (void)(lock); } while (0)
-# define arch_spin_lock_flags(lock, flags)	do { (void)(lock); } while (0)
-# define arch_spin_unlock(lock)	do { (void)(lock); } while (0)
-# define arch_spin_trylock(lock)	({ (void)(lock); 1; })
+# define arch_spin_lock(lock)		do { barrier(); (void)(lock); } while (0)
+# define arch_spin_lock_flags(lock, flags)	do { barrier(); (void)(lock); } while (0)
+# define arch_spin_unlock(lock)	do { barrier(); (void)(lock); } while (0)
+# define arch_spin_trylock(lock)	({ barrier(); (void)(lock); 1; })
 #endif /* DEBUG_SPINLOCK */
 
 #define arch_spin_is_contended(lock)	(((void)(lock), 0))
-- 
1.7.10.4


