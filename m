Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757991Ab3LWUkR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Dec 2013 15:40:17 -0500
Received: from cantor2.suse.de ([195.135.220.15]:33562 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757933Ab3LWUjz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Dec 2013 15:39:55 -0500
From: Jan Kara <jack@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: pmladek@suse.cz, Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, Jan Kara <jack@suse.cz>
Subject: [PATCH 9/9] printk: Hand over printing to console if printing too long
Date: Mon, 23 Dec 2013 21:39:30 +0100
Message-Id: <1387831171-5264-10-git-send-email-jack@suse.cz>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1387831171-5264-1-git-send-email-jack@suse.cz>
References: <1387831171-5264-1-git-send-email-jack@suse.cz>
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
doing printing asks for help by setting a 'hand over' state. The CPU
still keeps printing until another CPU running printk() or a CPU being
pinged by an IPI comes and takes over printing.  This way no CPU should
spend printing too long if there is heavy printk traffic.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 Documentation/kernel-parameters.txt |  16 +++
 kernel/printk/printk.c              | 201 ++++++++++++++++++++++++++++++++----
 2 files changed, 198 insertions(+), 19 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 50680a59a2ff..5124bc82a9f5 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -2557,6 +2557,22 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
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
index bfbe1a5f6804..8abbb5373999 100644
--- a/kernel/printk/printk.c
+++ b/kernel/printk/printk.c
@@ -84,6 +84,45 @@ static DEFINE_SEMAPHORE(console_sem);
 struct console *console_drivers;
 EXPORT_SYMBOL_GPL(console_drivers);
 
+/*
+ * State of printing to console.
+ * 0 - noone is printing
+ * 1 - the CPU doing printing is happy doing so
+ * 2 - the printing CPU wants some other CPU to take over
+ * 3 - some CPU is waiting to take over printing
+ *
+ * Allowed state transitions are:
+ * 0 -> 1, 1 -> 0, 1 -> 2, 2 -> 0, 2 -> 3, 3 -> 0
+ * All state transitions except for 2 -> 3 are done by the holder of
+ * console_sem. Transition 2 -> 3 happens using cmpxchg from a task not owning
+ * console_sem. Thus it can race with other state transitions from state 2.
+ * However these races are harmless since the only transition we can race with
+ * is 2 -> 0. If cmpxchg comes after we have moved from state 2, it does
+ * nothing and we end in state 0. If cmpxchg comes before, we end in state 0 as
+ * desired.
+ */
+static enum {
+	PS_NONE,
+	PS_PRINTING,
+	PS_HANDOVER,
+	PS_WAITING
+} printing_state;
+/* CPU which is handing over printing */
+static unsigned int hand_over_cpu;
+/*
+ * Structure for IPI to hand printing to another CPU. We have actually two
+ * structures for the case we need to send IPI from an IPI handler...
+ */
+static void printk_take_over(void *info);
+static struct call_single_data hand_over_csd[2] = {
+	{ .func = printk_take_over, },
+	{ .func = printk_take_over, }
+};
+/* Index of csd to use for sending IPI now */
+static int current_csd;
+/* Set if there is IPI pending to take over printing */
+static bool printk_ipi_sent;
+
 #ifdef CONFIG_LOCKDEP
 static struct lockdep_map console_lock_dep_map = {
 	.name = "console_lock"
@@ -253,6 +292,18 @@ static char __log_buf[__LOG_BUF_LEN] __aligned(LOG_ALIGN);
 static char *log_buf = __log_buf;
 static u32 log_buf_len = __LOG_BUF_LEN;
 
+/*
+ * How many characters can we print in one call of printk before asking
+ * other cpus to continue printing (0 means infinity). Tunable via
+ * printk.offload_chars kernel parameter.
+ */
+static unsigned int __read_mostly printk_offload_chars = 0;
+
+module_param_named(offload_chars, printk_offload_chars, uint,
+		   S_IRUGO | S_IWUSR);
+MODULE_PARM_DESC(offload_chars, "offload printing to console to a different"
+	" cpu after this number of characters");
+
 /* human readable text of the record */
 static char *log_text(const struct printk_log *msg)
 {
@@ -1342,8 +1393,40 @@ static int console_trylock_for_printk(void)
 {
 	unsigned int cpu = smp_processor_id();
 
-	if (!console_trylock())
-		return 0;
+	if (!console_trylock()) {
+		int state;
+
+		if (printing_state != PS_HANDOVER || console_suspended)
+			return 0;
+		smp_rmb();	/* Paired with smp_wmb() in cpu_stop_printing */
+		/*
+		 * Avoid deadlocks when CPU holding console_sem takes an
+		 * interrupt which does printk.
+		 */
+		if (hand_over_cpu == cpu)
+			return 0;
+
+		state = cmpxchg(&printing_state, PS_HANDOVER, PS_WAITING);
+		if (state != PS_HANDOVER)
+			return 0;
+
+		/*
+		 * Since PS_HANDOVER state is set only in console_unlock()
+		 * we shouldn't spin for long here. And we cannot sleep because
+		 * the printk() might be called from atomic context.
+		 */
+		while (!console_trylock()) {
+			if (console_suspended)
+				return 0;
+			/*
+			 * Someone else took console_sem? Exit as we don't want
+			 * to spin for a long time here.
+			 */
+			if (ACCESS_ONCE(printing_state) == PS_PRINTING)
+				return 0;
+			__delay(1);
+		}
+	}
 	/*
 	 * If we can't use the console, we need to release the console
 	 * semaphore by hand to avoid flushing the buffer. We need to hold the
@@ -1351,6 +1434,7 @@ static int console_trylock_for_printk(void)
 	 */
 	if (!can_use_console(cpu)) {
 		console_locked = 0;
+		printing_state = PS_NONE;
 		up(&console_sem);
 		return 0;
 	}
@@ -1944,6 +2028,7 @@ void console_lock(void)
 		return;
 	console_locked = 1;
 	console_may_schedule = 1;
+	printing_state = PS_PRINTING;
 	mutex_acquire(&console_lock_dep_map, 0, 0, _RET_IP_);
 }
 EXPORT_SYMBOL(console_lock);
@@ -1966,6 +2051,7 @@ int console_trylock(void)
 	}
 	console_locked = 1;
 	console_may_schedule = 0;
+	printing_state = PS_PRINTING;
 	mutex_acquire(&console_lock_dep_map, 0, 1, _RET_IP_);
 	return 1;
 }
@@ -2005,15 +2091,77 @@ out:
 	raw_spin_unlock_irqrestore(&logbuf_lock, flags);
 }
 
+/* Handler for IPI to take over printing from another CPU */
+static void printk_take_over(void *info)
+{
+	/*
+	 * We have to clear printk_ipi_sent only after we succeed / fail the
+	 * trylock. That way we make sure there is at most one IPI spinning
+	 * on console_sem and thus we cannot deadlock on csd_lock
+	 */
+	if (console_trylock_for_printk()) {
+		printk_ipi_sent = false;
+		/* Switch csd as the current one is locked until we finish */
+		current_csd ^= 1;
+		console_unlock();
+	} else
+		printk_ipi_sent = false;
+}
+
+/*
+ * Returns true iff there is other cpu waiting to take over printing. This
+ * function also takes are of changing printing_state if we want to hand over
+ * printing to some other cpu.
+ */
+static bool cpu_stop_printing(int printed_chars)
+{
+	cpumask_var_t mask;
+
+	/* Oops? Print everything now to maximize chances user will see it */
+	if (oops_in_progress)
+		return false;
+	/* Someone is waiting. Stop printing. */
+	if (printing_state == PS_WAITING)
+		return true;
+	if (!printk_offload_chars || printed_chars <= printk_offload_chars)
+		return false;
+	if (printing_state == PS_PRINTING) {
+		hand_over_cpu = smp_processor_id();
+		/* Paired with smp_rmb() in console_trylock_for_printk() */
+		smp_wmb();
+		printing_state = PS_HANDOVER;
+		return false;
+	}
+	/*
+	 * We ping another CPU with IPI only if noone took over printing for a
+	 * long time - we prefer other printk() to take over printing since it
+	 * has chances to happen from a better context than IPI handler.
+	 */
+	if (!printk_ipi_sent && printed_chars > 2 * printk_offload_chars) {
+		struct call_single_data *csd = &hand_over_csd[current_csd];
+
+		/* Ping another cpu to take printing from us */
+		cpumask_copy(mask, cpu_online_mask);
+		cpumask_clear_cpu(hand_over_cpu, mask);
+		if (!cpumask_empty(mask)) {
+			printk_ipi_sent = true;
+			__smp_call_function_any(mask, csd, 0);
+		}
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
@@ -2026,6 +2174,8 @@ void console_unlock(void)
 	unsigned long flags;
 	bool wake_klogd = false;
 	bool retry;
+	bool hand_over = false;
+	int printed_chars = 0;
 
 	if (console_suspended) {
 		up(&console_sem);
@@ -2042,6 +2192,11 @@ again:
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
@@ -2055,8 +2210,10 @@ again:
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
@@ -2087,31 +2244,37 @@ skip:
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
+	printing_state = PS_NONE;
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
-- 
1.8.1.4

