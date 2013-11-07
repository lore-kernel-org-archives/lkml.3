Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755597Ab3KGVtm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 16:49:42 -0500
Received: from cantor2.suse.de ([195.135.220.15]:43778 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755174Ab3KGVs4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 16:48:56 -0500
From: Jan Kara <jack@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, mhocko@suse.cz,
        Steven Rostedt <rostedt@goodmis.org>, Jan Kara <jack@suse.cz>
Subject: [PATCH 3/4] printk: Defer printing to irq work when we printed too much
Date: Thu,  7 Nov 2013 22:48:38 +0100
Message-Id: <1383860919-1883-4-git-send-email-jack@suse.cz>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1383860919-1883-1-git-send-email-jack@suse.cz>
References: <1383860919-1883-1-git-send-email-jack@suse.cz>
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
disappears from the system apparently because interrupt from it wasn't
served for too long. This is why just silencing watchdogs isn't a
reliable solution to the problem and we simply have to avoid spending
too long in console_unlock() with interrupts disabled.

The solution this patch works toward is to postpone printing to a later
moment / different CPU when we already printed over X characters in
current console_unlock() invocation. This is a crude heuristic but
measuring time we spent printing doesn't seem to be really viable - we
cannot rely on high resolution time being available and with interrupts
disabled jiffies are not updated. User can tune the value X via
printk.offload_chars kernel parameter.

Reviewed-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 Documentation/kernel-parameters.txt | 17 ++++++++++
 kernel/printk/printk.c              | 68 +++++++++++++++++++++++++++++++------
 2 files changed, 75 insertions(+), 10 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index fcbb736d55fe..579815bd90eb 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -2540,6 +2540,23 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 			Format: <bool>  (1/Y/y=enable, 0/N/n=disable)
 			default: disabled
 
+	printk.offload_chars=
+			Printing to console can be relatively slow especially
+			in case of serial console. When there is intensive
+			printing happening from several cpus (as is the case
+			during boot), a cpu can be spending significant time
+			(seconds or more) doing printing. To avoid softlockups,
+			lost interrupts, and similar problems a cpu stops
+			printing to console after printing
+			'printk.offload_chars' characters.  Another cpu will
+			then continue printing. Higher value means possibly
+			longer interrupt and other latencies but lower latency
+			of printing and lower chance something goes wrong
+			during system crash and important message is not
+			printed.
+			Format: <number>
+			default: 0 (disabled)
+
 	printk.time=	Show timing data prefixed to each printk message line
 			Format: <bool>  (1/Y/y=enable, 0/N/n=disable)
 
diff --git a/kernel/printk/printk.c b/kernel/printk/printk.c
index 572fb1f438b6..35bb70ea6427 100644
--- a/kernel/printk/printk.c
+++ b/kernel/printk/printk.c
@@ -253,6 +253,18 @@ static char __log_buf[__LOG_BUF_LEN] __aligned(LOG_ALIGN);
 static char *log_buf = __log_buf;
 static u32 log_buf_len = __LOG_BUF_LEN;
 
+/*
+ * How much characters can we print in one call of printk before offloading
+ * printing work (0 means infinity). Tunable via
+ * /proc/sys/kernel/printk_offload_chars.
+ */
+static unsigned int __read_mostly printk_offload_chars = 0;
+
+module_param_named(offload_chars, printk_offload_chars, uint,
+		   S_IRUGO | S_IWUSR);
+MODULE_PARM_DESC(offload_chars, "offload printing to console to a different"
+	" cpu after this number of characters");
+
 /* cpu currently holding logbuf_lock */
 static volatile unsigned int logbuf_cpu = UINT_MAX;
 
@@ -2026,31 +2038,43 @@ out:
 	raw_spin_unlock_irqrestore(&logbuf_lock, flags);
 }
 
+/* Should we stop printing on this cpu? */
+static bool cpu_stop_printing(int printed_chars)
+{
+	/* Oops? Print everything now to maximize chances user will see it */
+	if (oops_in_progress)
+		return false;
+	return printk_offload_chars && printed_chars > printk_offload_chars;
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
@@ -2078,6 +2102,8 @@ again:
 skip:
 		if (console_seq == log_next_seq)
 			break;
+		if (cpu_stop_printing(printed_chars))
+			break;
 
 		msg = log_from_idx(console_idx);
 		if (msg->flags & LOG_NOCONS) {
@@ -2108,6 +2134,7 @@ skip:
 		stop_critical_timings();	/* don't trace print latency */
 		call_console_drivers(level, text, len);
 		start_critical_timings();
+		printed_chars += len;
 		local_irq_restore(flags);
 	}
 	console_locked = 0;
@@ -2131,13 +2158,20 @@ skip:
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
@@ -2515,6 +2549,20 @@ int printk_sched(const char *fmt, ...)
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

