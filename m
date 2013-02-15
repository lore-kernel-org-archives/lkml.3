Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755744Ab3BOQ5P (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 11:57:15 -0500
Received: from cantor2.suse.de ([195.135.220.15]:35133 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754861Ab3BOQ5N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 11:57:13 -0500
Date: Fri, 15 Feb 2013 17:57:10 +0100
From: Jan Kara <jack@suse.cz>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>,
        jslaby@suse.cz, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        "kay.sievers" <kay.sievers@vrfy.org>
Subject: [PATCH 3/3] printk: Avoid softlockups in console_unlock()
Message-ID: <20130215165710.GB12734@quack.suse.cz>
References: <1360112748.2621.25.camel@gandalf.local.home>
 <20130206230220.GA18329@quack.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130206230220.GA18329@quack.suse.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
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
callers to printk() or during next timer tick.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 include/linux/nmi.h |   18 +++++++++++++
 kernel/printk.c     |   70 +++++++++++++++++++++++++++++++++++++++++---------
 2 files changed, 75 insertions(+), 13 deletions(-)

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
index 2fe917d..c4f7f6f 100644
--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -1990,17 +1990,31 @@ int is_console_locked(void)
 #define PRINTK_PENDING_OUTPUT	2
 
 static unsigned long printk_pending;
+static int last_printing_cpu = -1;
+
+static bool __console_unlock(void);
 
 void printk_tick(void)
 {
 	if (printk_pending) {
-		unsigned long pending = xchg(&printk_pending, 0);
+		unsigned long pending;
+		int cpu = smp_processor_id();
+
+		/*
+		 * Did we last print? Give other cpus a chance to do it but
+		 * reset the variable so that we do printing in the next tick
+		 * if noone else got to it.
+		 */
+		if (cmpxchg(&last_printing_cpu, cpu, -1))
+			return;
 
+		pending = xchg(&printk_pending, 0);
 		if (test_bit(PRINTK_PENDING_OUTPUT, &pending)) {
+			bool more_work = true;
+
 			if (console_trylock())
-				console_unlock();
-			else
-				/* Try again later */
+				more_work = __console_unlock();
+			if (more_work)
 				set_bit(PRINTK_PENDING_OUTPUT, &printk_pending);
 		}
 		if (test_bit(PRINTK_PENDING_WAKEUP, &pending))
@@ -2051,33 +2065,46 @@ out:
 }
 
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
+	preempt_disable();
+	cur_cpu = smp_processor_id();
+	/*
+	 * We give us some headroom because we check the time only after
+	 * printing the whole message
+	 */
+	end_time = cpu_clock(cur_cpu) +
+				max_interrupt_disabled_duration() / 2;
+	preempt_enable();
 
 	/* flush buffered message fragment immediately to console */
 	console_cont_flush(text, sizeof(text));
@@ -2100,7 +2127,9 @@ again:
 			console_prev = 0;
 		}
 skip:
-		if (console_seq == log_next_seq)
+		now = sched_clock_cpu(cur_cpu);
+		if (console_seq == log_next_seq ||
+		    (now > end_time && !oops_in_progress))
 			break;
 
 		msg = log_from_idx(console_idx);
@@ -2143,6 +2172,7 @@ skip:
 
 	raw_spin_unlock(&logbuf_lock);
 
+	last_printing_cpu = cur_cpu;
 	up(&console_sem);
 
 	/*
@@ -2155,11 +2185,25 @@ skip:
 	retry = console_seq != log_next_seq;
 	raw_spin_unlock_irqrestore(&logbuf_lock, flags);
 
-	if (retry && console_trylock())
+	if (retry && (now <= end_time || oops_in_progress) &&
+	    console_trylock())
 		goto again;
 
 	if (wake_klogd)
 		wake_up_klogd();
+	return retry;
+}
+
+/*
+ * This is a wrapper against __console_unlock() that makes sure the rest of
+ * buffer is printed in future.
+ */
+void console_unlock(void)
+{
+	if (__console_unlock()) {
+		/* Leave the rest of printing for a timer tick */
+		set_bit(PRINTK_PENDING_OUTPUT, &printk_pending);
+	}
 }
 EXPORT_SYMBOL(console_unlock);
 
-- 
1.7.1

