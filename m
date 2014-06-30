Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754400AbaF3UUd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 16:20:33 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:41582 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751284AbaF3UUb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 16:20:31 -0400
Date: Mon, 30 Jun 2014 13:20:30 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Andreas Bombe <aeb@debian.org>
Cc: linux-kernel@vger.kernel.org, Jan Kara <jack@suse.cz>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [REGRESSION] Boot hang with 939f04bec printk: enable interrupts
 before calling console_trylock_for_printk()
Message-Id: <20140630132030.fa6ac8c8f040e6f5b05071f3@linux-foundation.org>
In-Reply-To: <20140628225050.GA3484@amos.fritz.box>
References: <20140628225050.GA3484@amos.fritz.box>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 29 Jun 2014 00:50:50 +0200 Andreas Bombe <aeb@debian.org> wrote:

> None of the post 3.15 kernel boot for me. They all hang at the GRUB
> screen telling me it loaded and started the kernel, but the kernel
> itself stops before it prints anything (or even replaces the GRUB
> background graphics).
> 
> I bisected it down to 939f04bec1a4ef6ba4370b0f34b01decc844b1b1 "printk:
> enable interrupts before calling console_trylock_for_printk()".
> Reverting that patch on the latest kernel (git 24b414d5a7) allows me to
> boot normally.

OK, thanks, I queued the below reversion.  I'll hold off for a week or
two in case we come up with a fix.

> I fixed the conflict in the revert by leaving in the "if
> (in_sched) return printed_len;".

hm, that might have been buggy - we still need to the lockdep_on() and
local_irq_restore().  You're a victim of
someone-stuck-a-random-return-in-the-middle-of-a-function.

Please review this and if possible, run-time test it?  Against current
mainline.


From: Andrew Morton <akpm@linux-foundation.org>
Subject: kernel/printk/printk.c: revert "printk: enable interrupts before calling console_trylock_for_printk()"

Revert 939f04bec1a4 ("printk: enable interrupts before calling
console_trylock_for_printk()").

Andreas reported:

: None of the post 3.15 kernel boot for me. They all hang at the GRUB
: screen telling me it loaded and started the kernel, but the kernel
: itself stops before it prints anything (or even replaces the GRUB
: background graphics).

939f04bec1a4 is modest latency reduction.  Revert it until we understand
the reason for these failures.

Reported-by: Andreas Bombe <aeb@debian.org>
Cc: Jan Kara <jack@suse.cz>
Cc: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/printk/printk.c |   44 +++++++++++++++------------------------
 1 file changed, 18 insertions(+), 26 deletions(-)

diff -puN kernel/printk/printk.c~kernel-printk-printkc-revert-printk-enable-interrupts-before-calling-console_trylock_for_printk kernel/printk/printk.c
--- a/kernel/printk/printk.c~kernel-printk-printkc-revert-printk-enable-interrupts-before-calling-console_trylock_for_printk
+++ a/kernel/printk/printk.c
@@ -1416,9 +1416,10 @@ static int have_callable_console(void)
 /*
  * Can we actually use the console at this time on this cpu?
  *
- * Console drivers may assume that per-cpu resources have been allocated. So
- * unless they're explicitly marked as being able to cope (CON_ANYTIME) don't
- * call them until this CPU is officially up.
+ * Console drivers may assume that per-cpu resources have
+ * been allocated. So unless they're explicitly marked as
+ * being able to cope (CON_ANYTIME) don't call them until
+ * this CPU is officially up.
  */
 static inline int can_use_console(unsigned int cpu)
 {
@@ -1431,10 +1432,8 @@ static inline int can_use_console(unsign
  * console_lock held, and 'console_locked' set) if it
  * is successful, false otherwise.
  */
-static int console_trylock_for_printk(void)
+static int console_trylock_for_printk(unsigned int cpu)
 {
-	unsigned int cpu = smp_processor_id();
-
 	if (!console_trylock())
 		return 0;
 	/*
@@ -1609,8 +1608,7 @@ asmlinkage int vprintk_emit(int facility
 		 */
 		if (!oops_in_progress && !lockdep_recursing(current)) {
 			recursion_bug = 1;
-			local_irq_restore(flags);
-			return 0;
+			goto out_restore_irqs;
 		}
 		zap_locks();
 	}
@@ -1718,27 +1716,21 @@ asmlinkage int vprintk_emit(int facility
 
 	logbuf_cpu = UINT_MAX;
 	raw_spin_unlock(&logbuf_lock);
-	lockdep_on();
-	local_irq_restore(flags);
 
 	/* If called from the scheduler, we can not call up(). */
-	if (in_sched)
-		return printed_len;
-
-	/*
-	 * Disable preemption to avoid being preempted while holding
-	 * console_sem which would prevent anyone from printing to console
-	 */
-	preempt_disable();
-	/*
-	 * Try to acquire and then immediately release the console semaphore.
-	 * The release will print out buffers and wake up /dev/kmsg and syslog()
-	 * users.
-	 */
-	if (console_trylock_for_printk())
-		console_unlock();
-	preempt_enable();
+	if (!in_sched) {
+		/*
+		 * Try to acquire and then immediately release the console
+		 * semaphore.  The release will print out buffers and wake up
+		 * /dev/kmsg and syslog() users.
+		 */
+		if (console_trylock_for_printk(this_cpu))
+			console_unlock();
+	}
 
+	lockdep_on();
+out_restore_irqs:
+	local_irq_restore(flags);
 	return printed_len;
 }
 EXPORT_SYMBOL(vprintk_emit);
_

