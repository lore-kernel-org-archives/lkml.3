Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756242Ab3AOR6m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 12:58:42 -0500
Received: from cantor2.suse.de ([195.135.220.15]:37637 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750863Ab3AOR6l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 12:58:41 -0500
From: Jan Kara <jack@suse.cz>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, jslaby@suse.cz,
        Jan Kara <jack@suse.cz>
Subject: [PATCH] printk: Avoid softlockups in console_unlock()
Date: Tue, 15 Jan 2013 18:58:34 +0100
Message-Id: <1358272714-23375-1-git-send-email-jack@suse.cz>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A CPU can be caught in console_unlock() for a long time (tens of seconds are
reported by our customers) when other CPUs are using printk heavily and serial
console makes printing slow.  This triggers softlockup warnings because
interrupts are disabled for the whole time console_unlock() runs (e.g.
vprintk() calls console_unlock() with interrupts disabled).

We fix the issue by printing at most 1 KB of messages (unless we are in an
early boot stage or oops is happening) in one console_unlock() call. The rest
of the buffer will be printed either by further callers to printk() or by a
queued work.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 kernel/printk.c |   54 +++++++++++++++++++++++++++++++++++++++++++++++++-----
 1 files changed, 49 insertions(+), 5 deletions(-)

diff --git a/kernel/printk.c b/kernel/printk.c
index 357f714..13a633f 100644
--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -246,9 +246,22 @@ static enum log_flags console_prev;
 static u64 clear_seq;
 static u32 clear_idx;
 
+/* Worker to print accumulated data to console when there's too much of it */
+static void printk_worker(struct work_struct *work);
+static DECLARE_WORK(printk_work, printk_worker);
+
 #define PREFIX_MAX		32
 #define LOG_LINE_MAX		1024 - PREFIX_MAX
 
+/*
+ * How much do we print in one console_unlock(). We have this limit so that we
+ * don't have interrupts disabled on one CPU for too long when there a lot to
+ * write. We are conservative because we can be printing to a 9600 baud serial
+ * console... Note that we check each time after printing one line so
+ * LOG_LINE_MAX actually limits granularity of our checks.
+ */
+#define PRINT_LIMIT		1024
+
 /* record buffer */
 #if defined(CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS)
 #define LOG_ALIGN 4
@@ -2030,23 +2043,26 @@ out:
  *
  * While the console_lock was held, console output may have been buffered
  * by printk().  If this is the case, console_unlock(); emits
- * the output prior to releasing the lock.
+ * the output prior to releasing the lock. We print at most PRINT_LIMIT
+ * characters. Function returns true, if there's more data that needs
+ * printing in the buffer.
  *
  * If there is output waiting, we wake /dev/kmsg and syslog() users.
  *
  * console_unlock(); may be called from any context.
  */
-void console_unlock(void)
+static bool __console_unlock(void)
 {
 	static char text[LOG_LINE_MAX + PREFIX_MAX];
 	static u64 seen_seq;
 	unsigned long flags;
 	bool wake_klogd = false;
 	bool retry;
+	unsigned printed = 0;
 
 	if (console_suspended) {
 		up(&console_sem);
-		return;
+		return false;
 	}
 
 	console_may_schedule = 0;
@@ -2072,7 +2088,8 @@ again:
 			console_prev = 0;
 		}
 skip:
-		if (console_seq == log_next_seq)
+		if (console_seq == log_next_seq ||
+		    (printed >= PRINT_LIMIT && !oops_in_progress && keventd_up()))
 			break;
 
 		msg = log_from_idx(console_idx);
@@ -2105,6 +2122,7 @@ skip:
 		call_console_drivers(level, text, len);
 		start_critical_timings();
 		local_irq_restore(flags);
+		printed += len;
 	}
 	console_locked = 0;
 	mutex_release(&console_lock_dep_map, 1, _RET_IP_);
@@ -2127,14 +2145,40 @@ skip:
 	retry = console_seq != log_next_seq;
 	raw_spin_unlock_irqrestore(&logbuf_lock, flags);
 
-	if (retry && console_trylock())
+	if (retry &&
+	    (printed < PRINT_LIMIT || oops_in_progress || !keventd_up()) &&
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

