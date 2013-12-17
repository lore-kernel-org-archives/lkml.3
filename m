Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754293Ab3LQOsU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 09:48:20 -0500
Received: from cantor2.suse.de ([195.135.220.15]:57447 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752800Ab3LQOsS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 09:48:18 -0500
From: Jan Kara <jack@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, mhocko@suse.cz, pmladek@suse.cz,
        Steven Rostedt <rostedt@goodmis.org>, Jan Kara <jack@suse.cz>
Subject: [PATCH 2/3] printk: Enable interrupts before calling console_trylock_for_printk()
Date: Tue, 17 Dec 2013 15:48:09 +0100
Message-Id: <1387291691-2224-3-git-send-email-jack@suse.cz>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1387291691-2224-1-git-send-email-jack@suse.cz>
References: <1387291691-2224-1-git-send-email-jack@suse.cz>
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

We can loose a bit of performance when we enable interrupts in
vprintk_emit() and then disable them again in console_unlock() but OTOH
it can somewhat reduce interrupt latency caused by console_unlock()
especially since later in the patch series we will want to spin on
console_sem in console_trylock_for_printk().

Signed-off-by: Jan Kara <jack@suse.cz>
---
 kernel/printk/printk.c | 29 ++++++++++++++++++-----------
 1 file changed, 18 insertions(+), 11 deletions(-)

diff --git a/kernel/printk/printk.c b/kernel/printk/printk.c
index 72ec3637115f..ab0d24a9ab7c 100644
--- a/kernel/printk/printk.c
+++ b/kernel/printk/printk.c
@@ -1320,10 +1320,9 @@ static int have_callable_console(void)
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
@@ -1336,8 +1335,10 @@ static inline int can_use_console(unsigned int cpu)
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
@@ -1507,7 +1508,8 @@ asmlinkage int vprintk_emit(int facility, int level,
 		 */
 		if (!oops_in_progress && !lockdep_recursing(current)) {
 			recursion_bug = 1;
-			goto out_restore_irqs;
+			local_irq_restore(flags);
+			return 0;
 		}
 		zap_locks();
 	}
@@ -1600,17 +1602,22 @@ asmlinkage int vprintk_emit(int facility, int level,
 
 	logbuf_cpu = UINT_MAX;
 	raw_spin_unlock(&logbuf_lock);
+	lockdep_on();
+	local_irq_restore(flags);
+
+	/*
+	 * Disable preemption to avoid being preempted while holding
+	 * console_sem which would prevent anyone from printing to console
+	 */
+	preempt_disable();
 	/*
 	 * Try to acquire and then immediately release the console semaphore.
 	 * The release will print out buffers and wake up /dev/kmsg and syslog()
 	 * users.
 	 */
-	if (console_trylock_for_printk(this_cpu))
+	if (console_trylock_for_printk())
 		console_unlock();
-
-	lockdep_on();
-out_restore_irqs:
-	local_irq_restore(flags);
+	preempt_enable();
 
 	return printed_len;
 }
-- 
1.8.1.4

