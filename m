Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757069AbaGWHwp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 03:52:45 -0400
Received: from cantor2.suse.de ([195.135.220.15]:60832 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756212AbaGWHwn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 03:52:43 -0400
From: Jan Kara <jack@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Andreas Bombe <aeb@debian.org>,
        Jan Kara <jack@suse.cz>
Subject: [PATCH] printk: enable interrupts before calling console_trylock_for_printk()
Date: Wed, 23 Jul 2014 09:52:34 +0200
Message-Id: <1406101954-16194-1-git-send-email-jack@suse.cz>
X-Mailer: git-send-email 1.8.1.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We need interrupts disabled when calling console_trylock_for_printk()
only so that cpu id we pass to can_use_console() remains valid (for
other things console_sem provides all the exclusion we need and
deadlocks on console_sem due to interrupts are impossible because we use
down_trylock()).  However if we are rescheduled, we are guaranteed to
run on an online cpu so we can easily just get the cpu id in
can_use_console().

We can lose a bit of performance when we enable interrupts in
vprintk_emit() and then disable them again in console_unlock() but OTOH
it can somewhat reduce interrupt latency caused by console_unlock().

We differ from (reverted) commit 939f04bec1a4 in that we avoid calling
console_unlock() from vprintk_emit() with lockdep enabled as that has
unveiled quite some bugs leading to system freezes during boot (e.g.
https://lkml.org/lkml/2014/5/30/242,
https://lkml.org/lkml/2014/6/28/521).

Tested-by: Andreas Bombe <aeb@debian.org>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 kernel/printk/printk.c | 31 +++++++++++++++++++++----------
 1 file changed, 21 insertions(+), 10 deletions(-)

 Andrew, can you please queue this patch? Thanks.

diff --git a/kernel/printk/printk.c b/kernel/printk/printk.c
index 13e839dbca07..fe4154d83fe4 100644
--- a/kernel/printk/printk.c
+++ b/kernel/printk/printk.c
@@ -1416,10 +1416,9 @@ static int have_callable_console(void)
 /*
  * Can we actually use the console at this time on this cpu?
  *
- * Console drivers may assume that per-cpu resources have
- * been allocated. So unless they're explicitly marked as
- * being able to cope (CON_ANYTIME) don't call them until
- * this CPU is officially up.
+ * Console drivers may assume that per-cpu resources have been allocated. So
+ * unless they're explicitly marked as being able to cope (CON_ANYTIME) don't
+ * call them until this CPU is officially up.
  */
 static inline int can_use_console(unsigned int cpu)
 {
@@ -1432,8 +1431,10 @@ static inline int can_use_console(unsigned int cpu)
  * console_lock held, and 'console_locked' set) if it
  * is successful, false otherwise.
  */
-static int console_trylock_for_printk(unsigned int cpu)
+static int console_trylock_for_printk(void)
 {
+	unsigned int cpu = smp_processor_id();
+
 	if (!console_trylock())
 		return 0;
 	/*
@@ -1608,7 +1609,8 @@ asmlinkage int vprintk_emit(int facility, int level,
 		 */
 		if (!oops_in_progress && !lockdep_recursing(current)) {
 			recursion_bug = 1;
-			goto out_restore_irqs;
+			local_irq_restore(flags);
+			return 0;
 		}
 		zap_locks();
 	}
@@ -1716,21 +1718,30 @@ asmlinkage int vprintk_emit(int facility, int level,
 
 	logbuf_cpu = UINT_MAX;
 	raw_spin_unlock(&logbuf_lock);
+	lockdep_on();
+	local_irq_restore(flags);
 
 	/* If called from the scheduler, we can not call up(). */
 	if (!in_sched) {
+		lockdep_off();
+		/*
+		 * Disable preemption to avoid being preempted while holding
+		 * console_sem which would prevent anyone from printing to
+		 * console
+		 */
+		preempt_disable();
+
 		/*
 		 * Try to acquire and then immediately release the console
 		 * semaphore.  The release will print out buffers and wake up
 		 * /dev/kmsg and syslog() users.
 		 */
-		if (console_trylock_for_printk(this_cpu))
+		if (console_trylock_for_printk())
 			console_unlock();
+		preempt_enable();
+		lockdep_on();
 	}
 
-	lockdep_on();
-out_restore_irqs:
-	local_irq_restore(flags);
 	return printed_len;
 }
 EXPORT_SYMBOL(vprintk_emit);
-- 
1.8.1.4

