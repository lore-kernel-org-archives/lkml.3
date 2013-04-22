Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755545Ab3DVOhy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Apr 2013 10:37:54 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:51617 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754969Ab3DVOaR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Apr 2013 10:30:17 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org,
        "Linus Torvalds" <torvalds@linux-foundation.org>,
        "Peter Zijlstra" <peterz@infradead.org>,
        "Steven Rostedt" <srostedt@redhat.com>
Date: Mon, 22 Apr 2013 15:25:59 +0100
Message-ID: <lsq.1366640759.309572631@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [32/75] spinlocks and preemption points need to be at least
 compiler barriers
In-Reply-To: <lsq.1366640759.151900666@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:6834:ff73:7553:7f84
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.44-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Linus Torvalds <torvalds@linux-foundation.org>

commit 386afc91144b36b42117b0092893f15bc8798a80 upstream.

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

Cc: Steven Rostedt <srostedt@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
[bwh: Backported to 3.2: drop sched_preempt_enable_no_resched()]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 include/linux/preempt.h     |   22 ++++++++++++++--------
 include/linux/spinlock_up.h |   29 ++++++++++++++++++-----------
 2 files changed, 32 insertions(+), 19 deletions(-)

--- a/include/linux/preempt.h
+++ b/include/linux/preempt.h
@@ -91,13 +91,19 @@ do { \
 
 #else /* !CONFIG_PREEMPT_COUNT */
 
-#define preempt_disable()		do { } while (0)
-#define preempt_enable_no_resched()	do { } while (0)
-#define preempt_enable()		do { } while (0)
+/*
+ * Even if we don't have any preemption, we need preempt disable/enable
+ * to be barriers, so that we don't have things like get_user/put_user
+ * that can cause faults and scheduling migrate into our preempt-protected
+ * region.
+ */
+#define preempt_disable()		barrier()
+#define preempt_enable_no_resched()	barrier()
+#define preempt_enable()		barrier()
 
-#define preempt_disable_notrace()		do { } while (0)
-#define preempt_enable_no_resched_notrace()	do { } while (0)
-#define preempt_enable_notrace()		do { } while (0)
+#define preempt_disable_notrace()		barrier()
+#define preempt_enable_no_resched_notrace()	barrier()
+#define preempt_enable_notrace()		barrier()
 
 #endif /* CONFIG_PREEMPT_COUNT */
 
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
@@ -32,6 +36,7 @@ arch_spin_lock_flags(arch_spinlock_t *lo
 {
 	local_irq_save(flags);
 	lock->slock = 0;
+	barrier();
 }
 
 static inline int arch_spin_trylock(arch_spinlock_t *lock)
@@ -39,32 +44,34 @@ static inline int arch_spin_trylock(arch
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

