Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760085Ab3B0BRS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 20:17:18 -0500
Received: from cantor2.suse.de ([195.135.220.15]:41689 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759870Ab3B0BRM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 20:17:12 -0500
From: Jan Kara <jack@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Jan Kara <jack@suse.cz>
Subject: [PATCH v3] printk: Avoid softlockups in console_unlock()
Date: Wed, 27 Feb 2013 02:16:59 +0100
Message-Id: <1361927819-1570-1-git-send-email-jack@suse.cz>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A CPU can be caught in console_unlock() for a long time (tens of seconds
are reported by our customers) when other CPUs are using printk heavily
and serial console makes printing slow. Despite serial console drivers
are calling touch_nmi_watchdog() this triggers softlockup warnings
because interrupts are effectively disabled for the whole time printing
takes place. Thus IPIs cannot be processed and other CPUs get stuck
spinning in calls like smp_call_function_many(). Also RCU eventually
starts reporting lockups.

In my artifical testing I also managed to trigger a situation when disk
disappeared from the system apparently because commands to / from it
could not be delivered for long enough. This is why just silencing
watchdogs isn't a reliable solution to the problem.

One part of fixing the issue is changing vprintk_emit() to call
console_unlock() with interrupts enabled (this isn't perfect as printk()
itself can be called with interrupts disabled but it improves the
situation in lots of cases). Another part is limiting the time we spend
in console_unlock() printing loop to watchdog_thresh() / 4. Then we
release console_sem and wait for watchdog_thresh() / 4 to give a chance
to other printk() users to get the semaphore and start printing. If
printk() was called with interrupts enabled, it also gives CPU a chance
to process blocked interrupts. Then we recheck if there's still anything
to print, try to grab console_sem again and if we succeed, we go on with
printing.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 include/linux/nmi.h |   18 ++++++++++++++++++
 kernel/printk.c     |   44 ++++++++++++++++++++++++++++++++++++++------
 2 files changed, 56 insertions(+), 6 deletions(-)

Andrew, I was playing with this problem some more and this patch is the least
scary fix I found ;). It may slow down printing in heavy-printk cases though.
What do you think?

diff --git a/include/linux/nmi.h b/include/linux/nmi.h
index db50840..ce32959 100644
--- a/include/linux/nmi.h
+++ b/include/linux/nmi.h
@@ -51,6 +51,24 @@ extern int watchdog_thresh;
 struct ctl_table;
 extern int proc_dowatchdog(struct ctl_table *, int ,
 			   void __user *, size_t *, loff_t *);
+/*
+ * Return the maximum number of nanosecond for which interrupts may be disabled
+ * on the current CPU
+ */
+static inline u64 max_interrupt_disabled_duration(void)
+{
+	/*
+	 * We give us some headroom because timers need time to fire before the
+	 * watchdog period expires.
+	 */
+	return ((u64)watchdog_thresh) * NSEC_PER_SEC / 2;
+}
+#else
+static inline u64 max_interrupt_disabled_duration(void)
+{
+	/* About the value we'd get with the default watchdog setting */
+	return 5ULL * NSEC_PER_SEC;
+}
 #endif
 
 #endif
diff --git a/kernel/printk.c b/kernel/printk.c
index 0b31715..2f4d9a4 100644
--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -1522,7 +1522,8 @@ asmlinkage int vprintk_emit(int facility, int level,
 		 */
 		if (!oops_in_progress && !lockdep_recursing(current)) {
 			recursion_bug = 1;
-			goto out_restore_irqs;
+			local_irq_restore(flags);
+			return printed_len;
 		}
 		zap_locks();
 	}
@@ -1616,17 +1617,19 @@ asmlinkage int vprintk_emit(int facility, int level,
 	/*
 	 * Try to acquire and then immediately release the console semaphore.
 	 * The release will print out buffers and wake up /dev/kmsg and syslog()
-	 * users.
+	 * users. We call console_unlock() with interrupts enabled if possible
+	 * since printing can take a long time.
 	 *
 	 * The console_trylock_for_printk() function will release 'logbuf_lock'
 	 * regardless of whether it actually gets the console semaphore or not.
 	 */
-	if (console_trylock_for_printk(this_cpu))
+	if (console_trylock_for_printk(this_cpu)) {
+		local_irq_restore(flags);
 		console_unlock();
+	} else
+		local_irq_restore(flags);
 
 	lockdep_on();
-out_restore_irqs:
-	local_irq_restore(flags);
 
 	return printed_len;
 }
@@ -2046,6 +2049,8 @@ void console_unlock(void)
 	unsigned long flags;
 	bool wake_klogd = false;
 	bool retry;
+	u64 end_time, now;
+	int cur_cpu;
 
 	if (console_suspended) {
 		up(&console_sem);
@@ -2053,6 +2058,15 @@ void console_unlock(void)
 	}
 
 	console_may_schedule = 0;
+	preempt_disable();
+	cur_cpu = smp_processor_id();
+	/*
+	 * We give us some headroom because we check the time only after
+	 * printing the whole message
+	 */
+	end_time = cpu_clock(cur_cpu) + max_interrupt_disabled_duration() / 2;
+	preempt_enable();
+
 
 	/* flush buffered message fragment immediately to console */
 	console_cont_flush(text, sizeof(text));
@@ -2075,7 +2089,8 @@ again:
 			console_prev = 0;
 		}
 skip:
-		if (console_seq == log_next_seq)
+		now = sched_clock_cpu(cur_cpu);
+		if (console_seq == log_next_seq || now > end_time)
 			break;
 
 		msg = log_from_idx(console_idx);
@@ -2121,6 +2136,23 @@ skip:
 	up(&console_sem);
 
 	/*
+	 * If the printing took too long, wait a bit to give other CPUs a
+	 * chance to take console_sem or at least provide some time for
+	 * interrupts to be processed (if we are lucky enough and they are
+	 * enabled at this point).
+	 */
+	if (now > end_time) {
+		/*
+		 * We won't reach RCU quiescent state anytime soon, silence
+		 * the warnings.
+		 */
+		local_irq_save(flags);
+		rcu_cpu_stall_reset();
+		local_irq_restore(flags);
+		ndelay(max_interrupt_disabled_duration() / 2);
+	}
+
+	/*
 	 * Someone could have filled up the buffer again, so re-check if there's
 	 * something to flush. In case we cannot trylock the console_sem again,
 	 * there's a new owner and the console_unlock() from them will do the
-- 
1.7.1

