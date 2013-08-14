Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759796Ab3HNN3W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 09:29:22 -0400
Received: from cantor2.suse.de ([195.135.220.15]:40427 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755381Ab3HNN2j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 09:28:39 -0400
From: Jan Kara <jack@suse.cz>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Steven Rostedt <rostedt@goodmis.org>, mhocko@suse.cz,
        Jan Kara <jack@suse.cz>
Subject: [PATCH 3/4] printk: Defer printing to irq work when we printed too much
Date: Wed, 14 Aug 2013 15:28:27 +0200
Message-Id: <1376486908-26063-4-git-send-email-jack@suse.cz>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1376486908-26063-1-git-send-email-jack@suse.cz>
References: <1376486908-26063-1-git-send-email-jack@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A CPU can be caught in console_unlock() for a long time (tens of seconds
are reported by our customers) when other CPUs are using printk heavily
and serial console makes printing slow. Despite serial console drivers
are calling touch_nmi_watchdog() this triggers softlockup warnings
because interrupts are disabled for the whole time console_unlock() runs
(e.g. vprintk() calls console_unlock() with interrupts disabled). Thus
IPIs cannot be processed and other CPUs get stuck spinning in calls like
smp_call_function_many(). Also RCU eventually starts reporting lockups.

In my artifical testing I can also easily trigger a situation when disk
disappears from the system apparently because commands to / from it
could not be delivered for long enough. This is why just silencing
watchdogs isn't a reliable solution to the problem and we simply have to
avoid spending too long in console_unlock() with interrupts disabled.

The solution this patch works toward is to postpone printing to a later
moment / different CPU when we already printed over 1000 characters in
current console_unlock() invocation. This is a crude heuristic but
measuring time we spent printing doesn't seem to be really viable - we
cannot rely on high resolution time being available and with interrupts
disabled jiffies are not updated. The value 1000 was chosen so that
things are still bearable with 9600 baud serial console and OTOH it
shouldn't cause offloading of printing in common cases.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 kernel/printk/printk.c | 62 ++++++++++++++++++++++++++++++++++++++++++--------
 1 file changed, 52 insertions(+), 10 deletions(-)

diff --git a/kernel/printk/printk.c b/kernel/printk/printk.c
index 9208e17..28c220a 100644
--- a/kernel/printk/printk.c
+++ b/kernel/printk/printk.c
@@ -2026,31 +2026,49 @@ out:
 	raw_spin_unlock_irqrestore(&logbuf_lock, flags);
 }
 
+/*
+ * How much characters can we print in one call of printk before offloading
+ * printing work
+ */
+#define MAX_PRINTK_CHARS 1000
+
+/* Should we stop printing on this cpu? */
+static bool cpu_stop_printing(int printed_chars)
+{
+	/* Oops? Print everything now to maximize chances user will see it */
+	if (oops_in_progress)
+		return false;
+	return printed_chars > MAX_PRINTK_CHARS;
+}
+
 /**
- * console_unlock - unlock the console system
+ * __console_unlock - unlock the console system
  *
  * Releases the console_lock which the caller holds on the console system
  * and the console driver list.
  *
- * While the console_lock was held, console output may have been buffered
- * by printk().  If this is the case, console_unlock(); emits
- * the output prior to releasing the lock.
+ * While the console_lock was held, console output may have been buffered by
+ * printk(). If this is the case, __console_unlock() emits the output prior to
+ * releasing the lock. However we need not write all the data in the buffer if
+ * we would hog the CPU for too long. Function returns true, if there's more
+ * data that needs printing in the buffer.
  *
  * If there is output waiting, we wake /dev/kmsg and syslog() users.
  *
- * console_unlock(); may be called from any context.
+ * __console_unlock(); may be called from any context.
  */
-void console_unlock(void)
+static bool __console_unlock(void)
 {
 	static char text[LOG_LINE_MAX + PREFIX_MAX];
 	static u64 seen_seq;
 	unsigned long flags;
 	bool wake_klogd = false;
 	bool retry;
+	int printed_chars = 0;
 
 	if (console_suspended) {
 		up(&console_sem);
-		return;
+		return false;
 	}
 
 	console_may_schedule = 0;
@@ -2078,6 +2096,8 @@ again:
 skip:
 		if (console_seq == log_next_seq)
 			break;
+		if (cpu_stop_printing(printed_chars))
+			break;
 
 		msg = log_from_idx(console_idx);
 		if (msg->flags & LOG_NOCONS) {
@@ -2108,6 +2128,7 @@ skip:
 		stop_critical_timings();	/* don't trace print latency */
 		call_console_drivers(level, text, len);
 		start_critical_timings();
+		printed_chars += len;
 		local_irq_restore(flags);
 	}
 	console_locked = 0;
@@ -2131,13 +2152,20 @@ skip:
 	retry = console_seq != log_next_seq;
 	raw_spin_unlock_irqrestore(&logbuf_lock, flags);
 
-	if (retry && console_trylock())
-		goto again;
+	if (retry && !cpu_stop_printing(printed_chars)) {
+		if (console_trylock())
+			goto again;
+		/*
+		 * Someone else is printing so the caller doesn't have to
+		 * schedule irq work
+		 */
+		retry = false;
+	}
 
 	if (wake_klogd)
 		wake_up_klogd();
+	return retry;
 }
-EXPORT_SYMBOL(console_unlock);
 
 /**
  * console_conditional_schedule - yield the CPU if required
@@ -2508,6 +2536,20 @@ int printk_sched(const char *fmt, ...)
 }
 
 /*
+ * This is a wrapper for __console_unlock() that makes sure the rest of buffer
+ * is printed in future.
+ */
+void console_unlock(void)
+{
+       if (__console_unlock()) {
+               /* Leave the rest of printing for a timer tick */
+		__this_cpu_or(printk_pending, PRINTK_PENDING_OUTPUT);
+		irq_work_queue(&__get_cpu_var(wake_up_klogd_work));
+	}
+}
+EXPORT_SYMBOL(console_unlock);
+
+/*
  * printk rate limiting, lifted from the networking subsystem.
  *
  * This enforces a rate limit: not more than 10 kernel messages
-- 
1.8.1.4

