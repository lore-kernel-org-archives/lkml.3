Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751667Ab3HUIJK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 04:09:10 -0400
Received: from cantor2.suse.de ([195.135.220.15]:57444 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751576Ab3HUIIq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 04:08:46 -0400
From: Jan Kara <jack@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, mhocko@suse.cz, hare@suse.de,
        Steven Rostedt <rostedt@goodmis.org>, Jan Kara <jack@suse.cz>
Subject: [PATCH 3/4] printk: Defer printing to irq work when we printed too much
Date: Wed, 21 Aug 2013 10:08:31 +0200
Message-Id: <1377072512-7986-4-git-send-email-jack@suse.cz>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1377072512-7986-1-git-send-email-jack@suse.cz>
References: <1377072512-7986-1-git-send-email-jack@suse.cz>
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
 Documentation/sysctl/kernel.txt | 19 +++++++++++++
 include/linux/printk.h          |  1 +
 kernel/printk/printk.c          | 62 ++++++++++++++++++++++++++++++++++-------
 kernel/sysctl.c                 |  8 ++++++
 4 files changed, 80 insertions(+), 10 deletions(-)

diff --git a/Documentation/sysctl/kernel.txt b/Documentation/sysctl/kernel.txt
index ab7d16e..0967bcc 100644
--- a/Documentation/sysctl/kernel.txt
+++ b/Documentation/sysctl/kernel.txt
@@ -57,6 +57,7 @@ show up in /proc/sys/kernel:
 - printk_delay
 - printk_ratelimit
 - printk_ratelimit_burst
+- printk_offload_chars
 - randomize_va_space
 - real-root-dev               ==> Documentation/initrd.txt
 - reboot-cmd                  [ SPARC only ]
@@ -524,6 +525,24 @@ send before ratelimiting kicks in.
 
 ==============================================================
 
+printk_offload_chars:
+
+Printing to console can be relatively slow especially in case of
+serial console. When there is intensive printing happening from
+several cpus (as is the case during boot), a cpu can be spending
+significant time (seconds or more) doing printing. To avoid
+softlockups, lost interrupts, and similar problems a cpu stops
+printing to console after printing 'printk_offload_chars' characters.
+Another cpu will then continue printing. Higher value means possibly
+longer interrupt and other latencies but lower latency of printing
+and lower chance something goes wrong during system crash and
+important message is not printed.
+
+By default we offload printing from a cpu after printing 1000
+characters. Setting printk_offload_chars to 0 disables offloading.
+
+==============================================================
+
 randomize_va_space:
 
 This option can be used to select the type of process address
diff --git a/include/linux/printk.h b/include/linux/printk.h
index 22c7052..135d958 100644
--- a/include/linux/printk.h
+++ b/include/linux/printk.h
@@ -141,6 +141,7 @@ extern bool printk_timed_ratelimit(unsigned long *caller_jiffies,
 extern int printk_delay_msec;
 extern int dmesg_restrict;
 extern int kptr_restrict;
+extern int printk_offload_chars;
 
 extern void wake_up_klogd(void);
 
diff --git a/kernel/printk/printk.c b/kernel/printk/printk.c
index 9208e17..e97971b 100644
--- a/kernel/printk/printk.c
+++ b/kernel/printk/printk.c
@@ -253,6 +253,12 @@ static char __log_buf[__LOG_BUF_LEN] __aligned(LOG_ALIGN);
 static char *log_buf = __log_buf;
 static u32 log_buf_len = __LOG_BUF_LEN;
 
+/*
+ * How much characters can we print in one call of printk before offloading
+ * printing work. Tunable via /proc/sys/kernel/printk_offload_chars.
+ */
+int __read_mostly printk_offload_chars = 1000;
+
 /* cpu currently holding logbuf_lock */
 static volatile unsigned int logbuf_cpu = UINT_MAX;
 
@@ -2026,31 +2032,43 @@ out:
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
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index 07f6fc4..002788f 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -772,6 +772,14 @@ static struct ctl_table kern_table[] = {
 		.extra2		= &ten_thousand,
 	},
 	{
+		.procname	= "printk_offload_chars",
+		.data		= &printk_offload_chars,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec_minmax,
+		.extra1		= &zero,
+	},
+	{
 		.procname	= "dmesg_restrict",
 		.data		= &dmesg_restrict,
 		.maxlen		= sizeof(int),
-- 
1.8.1.4

