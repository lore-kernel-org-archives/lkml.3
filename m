Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754327AbaCMP6r (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 11:58:47 -0400
Received: from cantor2.suse.de ([195.135.220.15]:42974 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754262AbaCMP6p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 11:58:45 -0400
From: Jan Kara <jack@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, pmladek@suse.cz,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jan Kara <jack@suse.cz>
Subject: [PATCH 5/6] printk: Hand over printing to console if printing too long
Date: Thu, 13 Mar 2014 16:58:37 +0100
Message-Id: <1394726318-2757-6-git-send-email-jack@suse.cz>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1394726318-2757-1-git-send-email-jack@suse.cz>
References: <1394726318-2757-1-git-send-email-jack@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, console_unlock() prints messages from kernel printk buffer to
console while the buffer is non-empty. When serial console is attached,
printing is slow and thus other CPUs in the system have plenty of time
to append new messages to the buffer while one CPU is printing. Thus the
CPU can spend unbounded amount of time doing printing in console_unlock().
This is especially serious problem if the printk() calling
console_unlock() was called with interrupts disabled.

In practice users have observed a CPU can spend tens of seconds printing
in console_unlock() (usually during boot when hundreds of SCSI devices
are discovered) resulting in RCU stalls (CPU doing printing doesn't
reach quiescent state for a long time), softlockup reports (IPIs for the
printing CPU don't get served and thus other CPUs are spinning waiting
for the printing CPU to process IPIs), and eventually a machine death
(as messages from stalls and lockups append to printk buffer faster than
we are able to print). So these machines are unable to boot with serial
console attached. Also during artificial stress testing SATA disk
disappears from the system because its interrupts aren't served for too
long.

This patch implements a mechanism where after printing specified number
of characters (tunable as a kernel parameter printk.offload_chars), CPU
doing printing asks for help by setting PRINTK_HANDOVER_B bit in
printk_handover_state variable and wakes up one of dedicated kthreads.
As soon as the printing CPU notices kthread got scheduled and is
spinning on console_sem, it drops console_sem and exits
console_unlock(). kthread then takes over printing instead.  This way no
CPU should spend printing too long even if there is heavy printk
traffic.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 Documentation/kernel-parameters.txt |  16 +++
 kernel/printk/printk.c              | 196 ++++++++++++++++++++++++++++++++----
 2 files changed, 195 insertions(+), 17 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 7116fda7077f..bb4318a6a2c7 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -2621,6 +2621,22 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 			Format: <bool>  (1/Y/y=enable, 0/N/n=disable)
 			default: disabled
 
+	printk.offload_chars=
+			Printing to console can be relatively slow especially
+			in case of serial console. When there is intensive
+			printing happening from several cpus (as is the case
+			during boot), a cpu can be spending significant time
+			(seconds or more) doing printing. To avoid softlockups,
+			lost interrupts, and similar problems other cpus
+			will take over printing after the currently printing
+			cpu has printed 'printk.offload_chars' characters.
+			Higher value means possibly longer interrupt and other
+			latencies but lower latency of printing and lower
+			chance something goes wrong during system crash and
+			important message is not printed.
+			Format: <number>
+			default: 0 (disabled)
+
 	printk.time=	Show timing data prefixed to each printk message line
 			Format: <bool>  (1/Y/y=enable, 0/N/n=disable)
 
diff --git a/kernel/printk/printk.c b/kernel/printk/printk.c
index 91c554e027c5..8ef179b170d4 100644
--- a/kernel/printk/printk.c
+++ b/kernel/printk/printk.c
@@ -45,6 +45,7 @@
 #include <linux/poll.h>
 #include <linux/irq_work.h>
 #include <linux/utsname.h>
+#include <linux/kthread.h>
 
 #include <asm/uaccess.h>
 
@@ -87,6 +88,31 @@ static DEFINE_SEMAPHORE(console_sem);
 struct console *console_drivers;
 EXPORT_SYMBOL_GPL(console_drivers);
 
+/* State machine for handing over printing */
+enum {
+	/*
+	 * Set by the holder of console_sem if currently printing task wants to
+	 * hand over printing. Cleared before console_sem is released.
+	 */
+	PRINTK_HANDOVER_B,
+	/*
+	 * Set if there's someone spinning on console_sem to take over printing.
+	 * Cleared after acquiring console_sem.
+	 */
+	PRINTK_CONSOLE_SPIN_B,
+};
+static long printk_handover_state;
+
+/*
+ * Number of kernel threads for offloading printing. We need at least two so
+ * that they can hand over printing from one to another one and thus switch
+ * CPUs.
+ */
+#define PRINTING_TASKS 2
+
+/* Wait queue printing tasks sleep on when idle */
+static DECLARE_WAIT_QUEUE_HEAD(print_queue); 
+
 #ifdef CONFIG_LOCKDEP
 static struct lockdep_map console_lock_dep_map = {
 	.name = "console_lock"
@@ -254,6 +280,19 @@ static char __log_buf[__LOG_BUF_LEN] __aligned(LOG_ALIGN);
 static char *log_buf = __log_buf;
 static u32 log_buf_len = __LOG_BUF_LEN;
 
+/*
+ * How many characters can we print in one call of printk before asking
+ * other cpus to continue printing. 0 means infinity. Tunable via
+ * printk.offload_chars kernel parameter. Our default 1000 means about
+ * 0.1s maximum latency due to printing.
+ */
+static unsigned int __read_mostly printk_offload_chars = 1000;
+
+module_param_named(offload_chars, printk_offload_chars, uint,
+		   S_IRUGO | S_IWUSR);
+MODULE_PARM_DESC(offload_chars, "offload printing to console to a different"
+	" cpu after this number of characters");
+
 /* human readable text of the record */
 static char *log_text(const struct printk_log *msg)
 {
@@ -1942,6 +1981,7 @@ void console_lock(void)
 	if (console_suspended)
 		return;
 	console_locked = 1;
+	printk_handover_state = 0;
 	console_may_schedule = 1;
 	mutex_acquire(&console_lock_dep_map, 0, 0, _RET_IP_);
 }
@@ -1964,12 +2004,45 @@ int console_trylock(void)
 		return 0;
 	}
 	console_locked = 1;
+	printk_handover_state = 0;
 	console_may_schedule = 0;
 	mutex_acquire(&console_lock_dep_map, 0, 1, _RET_IP_);
 	return 1;
 }
 EXPORT_SYMBOL(console_trylock);
 
+/*
+ * This is a version of console_lock() which spins to acquire console_sem.
+ * It is only for use by threads that take care of flushing printk buffer so
+ * that they can be sure they are not preempted while waiting for console_sem.
+ *
+ * The function returns 1 if we acquired console_sem, 0 if we failed (either
+ * someone else is already spinning, someone acquired console_sem, or console
+ * is suspended).
+ */
+static int console_lock_try_spin(void)
+{
+	WARN_ON_ONCE(!in_atomic());
+	/* Someone already spinning? Don't waste cpu time... */
+	if (test_and_set_bit(PRINTK_CONSOLE_SPIN_B, &printk_handover_state))
+		return 0;
+	while (down_trylock(&console_sem)) {
+		/* Someone else took console_sem? */
+		if (!test_bit(PRINTK_CONSOLE_SPIN_B, &printk_handover_state))
+			return 0;
+		cpu_relax();
+	}
+	printk_handover_state = 0;
+	if (console_suspended) {
+		up(&console_sem);
+		return 0;
+	}
+	console_locked = 1;
+	console_may_schedule = 0;
+	mutex_acquire(&console_lock_dep_map, 0, 0, _RET_IP_);
+	return 1;
+}
+
 int is_console_locked(void)
 {
 	return console_locked;
@@ -2004,15 +2077,44 @@ out:
 	raw_spin_unlock_irqrestore(&logbuf_lock, flags);
 }
 
+/*
+ * Returns true iff there is other cpu waiting to take over printing. This
+ * function also takes are of setting PRINTK_HANDOVER_B if we want to hand over
+ * printing to some other cpu.
+ */
+static bool cpu_stop_printing(int printed_chars)
+{
+	/* Oops? Print everything now to maximize chances user will see it */
+	if (oops_in_progress)
+		return false;
+	if (!printk_offload_chars || printed_chars < printk_offload_chars)
+		return false;
+	/* Someone is spinning on console_sem? Give away to him. */
+	if (test_bit(PRINTK_CONSOLE_SPIN_B, &printk_handover_state))
+		return true;
+	if (!test_bit(PRINTK_HANDOVER_B, &printk_handover_state)) {
+		set_bit(PRINTK_HANDOVER_B, &printk_handover_state);
+		/*
+		 * Paired with barrier in prepare_to_wait_exclusive() in
+		 * printing_task()
+		 */
+		smp_mb();
+		wake_up(&print_queue);
+	}
+	return false;
+}
+
 /**
  * console_unlock - unlock the console system
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
+ * we would hog the CPU for too long. In such case we try to hand over printing
+ * to a different cpu.
  *
  * If there is output waiting, we wake /dev/kmsg and syslog() users.
  *
@@ -2025,6 +2127,8 @@ void console_unlock(void)
 	unsigned long flags;
 	bool wake_klogd = false;
 	bool retry;
+	bool hand_over = false;
+	int printed_chars = 0;
 
 	if (console_suspended) {
 		up(&console_sem);
@@ -2041,6 +2145,11 @@ again:
 		size_t len;
 		int level;
 
+		if (cpu_stop_printing(printed_chars)) {
+			hand_over = true;
+			break;
+		}
+
 		raw_spin_lock_irqsave(&logbuf_lock, flags);
 		if (seen_seq != log_next_seq) {
 			wake_klogd = true;
@@ -2054,8 +2163,10 @@ again:
 			console_prev = 0;
 		}
 skip:
-		if (console_seq == log_next_seq)
+		if (console_seq == log_next_seq) {
+			raw_spin_unlock(&logbuf_lock);
 			break;
+		}
 
 		msg = log_from_idx(console_idx);
 		if (msg->flags & LOG_NOCONS) {
@@ -2086,31 +2197,39 @@ skip:
 		stop_critical_timings();	/* don't trace print latency */
 		call_console_drivers(level, text, len);
 		start_critical_timings();
+		printed_chars += len;
 		local_irq_restore(flags);
 	}
-	console_locked = 0;
-	mutex_release(&console_lock_dep_map, 1, _RET_IP_);
 
 	/* Release the exclusive_console once it is used */
 	if (unlikely(exclusive_console))
 		exclusive_console = NULL;
 
-	raw_spin_unlock(&logbuf_lock);
-
+	/* Save modification of printk_handover_state in the common fast path */
+	if (test_bit(PRINTK_HANDOVER_B, &printk_handover_state))
+		clear_bit(PRINTK_HANDOVER_B, &printk_handover_state);
+	console_locked = 0;
+	mutex_release(&console_lock_dep_map, 1, _RET_IP_);
 	up(&console_sem);
 
 	/*
-	 * Someone could have filled up the buffer again, so re-check if there's
-	 * something to flush. In case we cannot trylock the console_sem again,
-	 * there's a new owner and the console_unlock() from them will do the
-	 * flush, no worries.
+	 * Subtlety: We have interrupts disabled iff hand_over == false (to
+	 * save one cli/sti pair in the fast path.
 	 */
-	raw_spin_lock(&logbuf_lock);
-	retry = console_seq != log_next_seq;
-	raw_spin_unlock_irqrestore(&logbuf_lock, flags);
+	if (!hand_over) {
+		/*
+		 * Someone could have filled up the buffer again, so re-check
+		 * if there's something to flush. In case we cannot trylock the
+		 * console_sem again, there's a new owner and the
+		 * console_unlock() from them will do the flush, no worries.
+		 */
+		raw_spin_lock(&logbuf_lock);
+		retry = console_seq != log_next_seq;
+		raw_spin_unlock_irqrestore(&logbuf_lock, flags);
 
-	if (retry && console_trylock())
-		goto again;
+		if (retry && console_trylock())
+			goto again;
+	}
 
 	if (wake_klogd)
 		wake_up_klogd();
@@ -2148,6 +2267,7 @@ void console_unblank(void)
 		console_lock();
 
 	console_locked = 1;
+	printk_handover_state = 0;
 	console_may_schedule = 0;
 	for_each_console(c)
 		if ((c->flags & CON_ENABLED) && c->unblank)
@@ -2424,9 +2544,38 @@ int unregister_console(struct console *console)
 }
 EXPORT_SYMBOL(unregister_console);
 
+/* Kthread which takes over printing from a CPU which asks for help */
+static int printing_task(void *arg)
+{
+	DEFINE_WAIT(wait);
+
+	while (1) {
+		prepare_to_wait_exclusive(&print_queue, &wait,
+					  TASK_INTERRUPTIBLE);
+		if (!test_bit(PRINTK_HANDOVER_B, &printk_handover_state))
+			schedule();
+		finish_wait(&print_queue, &wait);
+		/*
+		 * We don't want to be scheduled away once we got the CPU (that
+		 * would be especially problematic if we hold console_sem at
+		 * that moment since noone else could print to console). So
+		 * disable preemption and spin on console_sem. We shouldn't
+		 * spin for long since printing CPU drops console_sem as soon
+		 * as it notices there is someone spinning on it.
+		 */
+		preempt_disable();
+		if (console_lock_try_spin())
+			console_unlock();
+		preempt_enable();
+	}
+	return 0;
+}
+
 static int __init printk_late_init(void)
 {
 	struct console *con;
+	int i;
+	struct task_struct *task;
 
 	for_each_console(con) {
 		if (!keep_bootcon && con->flags & CON_BOOT) {
@@ -2434,6 +2583,19 @@ static int __init printk_late_init(void)
 		}
 	}
 	hotcpu_notifier(console_cpu_notify, 0);
+
+	/* Does any handover of printing have any sence? */
+	if (num_possible_cpus() <= 1)
+		return 0;
+
+	for (i = 0; i < PRINTING_TASKS; i++) {
+		task = kthread_run(printing_task, NULL, "print/%d", i);
+		if (IS_ERR(task)) {
+			pr_err("printk: Cannot create printing thread: %ld\n",
+			       PTR_ERR(task));
+		}
+	}
+
 	return 0;
 }
 late_initcall(printk_late_init);
-- 
1.8.1.4

