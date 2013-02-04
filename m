Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755753Ab3BDWRR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 17:17:17 -0500
Received: from cantor2.suse.de ([195.135.220.15]:51079 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755425Ab3BDWRP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 17:17:15 -0500
From: Jan Kara <jack@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jan Kara <jack@suse.cz>
Subject: [PATCH v2] printk: Avoid softlockups in console_unlock()
Date: Mon,  4 Feb 2013 23:17:10 +0100
Message-Id: <1360016230-26696-1-git-send-email-jack@suse.cz>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A CPU can be caught in console_unlock() for a long time (tens of seconds are
reported by our customers) when other CPUs are using printk heavily and serial
console makes printing slow. Despite serial console drivers are calling
touch_nmi_watchdog() this triggers softlockup warnings because
interrupts are disabled for the whole time console_unlock() runs (e.g.
vprintk() calls console_unlock() with interrupts disabled). Thus IPIs
cannot be processed and other CPUs get stuck spinning in calls like
smp_call_function_many(). Also RCU eventually starts reporting lockups.

In my artifical testing I also managed to trigger a situation when disk
disappeared from the system apparently because commands to / from it
could not be delivered for long enough. This is why just silencing
watchdogs isn't a reliable solution to the problem and we simply have to
avoid spending too long in console_unlock().

We fix the issue by limiting the time we spend in console_unlock() to
watchdog_thresh() / 4 (unless we are in an early boot stage or oops is
happening). The rest of the buffer will be printed either by further
callers to printk() or by a queued work.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 include/linux/nmi.h |   18 +++++++++++++++
 kernel/printk.c     |   59 ++++++++++++++++++++++++++++++++++++++++++++-------
 2 files changed, 69 insertions(+), 8 deletions(-)

So this version has cleverer logic of when to offload the printing work. It
made the lockup warnings go away... Does it look better Andrew?

diff --git a/include/linux/nmi.h b/include/linux/nmi.h
index db50840..c7a01e0 100644
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
+	return watchdog_thresh * NSEC_PER_SEC / 2;
+}
+#else
+static inline u64 max_interrupt_disabled_duration(void)
+{
+	/* About the value we'd get with the default watchdog setting */
+	return 5 * NSEC_PER_SEC;
+}
 #endif
 
 #endif
diff --git a/kernel/printk.c b/kernel/printk.c
index 357f714..80172f7 100644
--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -246,6 +246,10 @@ static enum log_flags console_prev;
 static u64 clear_seq;
 static u32 clear_idx;
 
+/* Worker to print accumulated data to console when there's too much of it */
+static void printk_worker(struct work_struct *work);
+static DECLARE_WORK(printk_work, printk_worker);
+
 #define PREFIX_MAX		32
 #define LOG_LINE_MAX		1024 - PREFIX_MAX
 
@@ -2028,28 +2032,39 @@ out:
  * Releases the console_lock which the caller holds on the console system
  * and the console driver list.
  *
- * While the console_lock was held, console output may have been buffered
- * by printk().  If this is the case, console_unlock(); emits
- * the output prior to releasing the lock.
+ * While the console_lock was held, console output may have been buffered by
+ * printk(). If this is the case, console_unlock() emits the output prior to
+ * releasing the lock. However we need not write all the data in the buffer if
+ * we would hog the CPU for too long. Function returns true, if there's more
+ * data that needs printing in the buffer.
  *
  * If there is output waiting, we wake /dev/kmsg and syslog() users.
  *
- * console_unlock(); may be called from any context.
+ * __console_unlock() may be called from any context.
  */
-void console_unlock(void)
+static bool __console_unlock(void)
 {
 	static char text[LOG_LINE_MAX + PREFIX_MAX];
 	static u64 seen_seq;
 	unsigned long flags;
 	bool wake_klogd = false;
 	bool retry;
+	u64 end_time, now;
+	int cur_cpu;
 
 	if (console_suspended) {
 		up(&console_sem);
-		return;
+		return false;
 	}
 
 	console_may_schedule = 0;
+	cur_cpu = smp_processor_id();
+	/*
+	 * We give us some headroom because we check the time only after
+	 * printing the whole message
+	 */
+	end_time = sched_clock_cpu(cur_cpu) +
+				max_interrupt_disabled_duration() / 2;
 
 	/* flush buffered message fragment immediately to console */
 	console_cont_flush(text, sizeof(text));
@@ -2072,7 +2087,9 @@ again:
 			console_prev = 0;
 		}
 skip:
-		if (console_seq == log_next_seq)
+		now = sched_clock_cpu(cur_cpu);
+		if (console_seq == log_next_seq ||
+		    (now > end_time && !oops_in_progress && keventd_up()))
 			break;
 
 		msg = log_from_idx(console_idx);
@@ -2127,14 +2144,40 @@ skip:
 	retry = console_seq != log_next_seq;
 	raw_spin_unlock_irqrestore(&logbuf_lock, flags);
 
-	if (retry && console_trylock())
+	if (retry &&
+	    (now <= end_time || oops_in_progress || !keventd_up()) &&
+	    console_trylock())
 		goto again;
 
 	if (wake_klogd)
 		wake_up_klogd();
+	return retry;
+}
+
+void console_unlock(void)
+{
+	if (__console_unlock()) {
+		/* Let worker do the rest of printing */
+		schedule_work(&printk_work);
+	}
 }
 EXPORT_SYMBOL(console_unlock);
 
+/*
+ * This is a worker function to print data from printk buffer when
+ * console_unlock() didn't write it all. The advantage of this function is that
+ * it does the printing in a well known context where we can reschedule to
+ * avoid locking up one CPU with printing.
+ */
+static void printk_worker(struct work_struct *work)
+{
+	console_lock();
+	while (__console_unlock()) {
+		cond_resched();
+		console_lock();
+	}
+}
+
 /**
  * console_conditional_schedule - yield the CPU if required
  *
-- 
1.7.1

