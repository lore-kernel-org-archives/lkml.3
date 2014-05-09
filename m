Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756552AbaEIJPO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 05:15:14 -0400
Received: from cantor2.suse.de ([195.135.220.15]:40950 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752624AbaEIJPK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 05:15:10 -0400
From: Petr Mladek <pmladek@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Dave Anderson <anderson@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Kay Sievers <kay@vrfy.org>, Jiri Kosina <jkosina@suse.cz>,
        Michal Hocko <mhocko@suse.cz>, Jan Kara <jack@suse.cz>,
        linux-kernel@vger.kernel.org, Petr Mladek <pmladek@suse.cz>
Subject: [RFC PATCH 09/11] printk: merge and flush NMI buffer predictably via IRQ work
Date: Fri,  9 May 2014 11:11:03 +0200
Message-Id: <1399626665-29817-10-git-send-email-pmladek@suse.cz>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1399626665-29817-1-git-send-email-pmladek@suse.cz>
References: <1399626665-29817-1-git-send-email-pmladek@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It might take ages until users see messages from NMI context. They cannot
be flushed to the console because the operation involves taking and releasing
a bunch of locks. If the main lock is not available then then messages are even
temporary put into the NMI log buf. Everything gets fixed by the followup printk
in normal context but it is not predictable.

The same problem has printk_sched() and this patch reuses the existing solution.

There is no special printk() variant for NMI context. Hence the IRQ work
need to get queued from vprintk_emit(). This is why the functions are
moved to the top of the source file and irq_work_queue() call is removed
from printk_sched().

In addition, wake_up_klogd_work_func() is extended to merge the NMI log buffer
when needed.

Oops messages are still merged and flushed immediately. We need to make sure
that they are visible before the system dies.

Signed-off-by: Petr Mladek <pmladek@suse.cz>
---
 kernel/printk/printk.c | 131 ++++++++++++++++++++++++++++---------------------
 1 file changed, 74 insertions(+), 57 deletions(-)

diff --git a/kernel/printk/printk.c b/kernel/printk/printk.c
index cc6e77f6d72b..874ebab41ba3 100644
--- a/kernel/printk/printk.c
+++ b/kernel/printk/printk.c
@@ -311,6 +311,10 @@ static u64 console_seq;
 static u32 console_idx;
 static enum log_flags console_prev;
 
+/* the next printk record to merge from NMI log buffer */
+static u64 nmi_merge_seq;
+static u32 nmi_merge_idx;
+
 /* the next printk record to read after the last 'clear' command */
 static u64 clear_seq;
 static u32 clear_idx;
@@ -1711,6 +1715,72 @@ static inline void printk_delay(void)
 	}
 }
 
+/*
+ * Delayed printk version, for scheduler-internal messages. The IRQ work is
+ * also used to handle delayed messages from NMI context.
+ */
+#define PRINTK_PENDING_WAKEUP	0x01
+#define PRINTK_PENDING_OUTPUT	0x02
+
+static DEFINE_PER_CPU(int, printk_pending);
+
+static void merge_nmi_delayed_printk(void);
+
+static void wake_up_klogd_work_func(struct irq_work *irq_work)
+{
+	int pending = __this_cpu_xchg(printk_pending, 0);
+	u64 nmi_next_id = ACCESS_ONCE(nmi_log.nmi.next_id);
+
+	/*
+	 * Check if there are any pending messages in NMI log buffer.
+	 * We do not need any lock. If new message are being added,
+	 * another IRQ work is automatically scheduled.
+	 */
+	if (ACCESS_ONCE(nmi_merge_seq) != seq_from_id(nmi_next_id)) {
+		raw_spin_lock(&main_logbuf_lock);
+		merge_nmi_delayed_printk();
+		raw_spin_unlock(&main_logbuf_lock);
+	}
+
+	if (pending & PRINTK_PENDING_OUTPUT) {
+		/* If trylock fails, someone else is doing the printing */
+		if (console_trylock())
+			console_unlock();
+	}
+
+	if (pending & PRINTK_PENDING_WAKEUP)
+		wake_up_interruptible(&log_wait);
+}
+
+static DEFINE_PER_CPU(struct irq_work, wake_up_klogd_work) = {
+	.func = wake_up_klogd_work_func,
+	.flags = IRQ_WORK_LAZY,
+};
+
+void wake_up_klogd(void)
+{
+	preempt_disable();
+	if (waitqueue_active(&log_wait)) {
+		this_cpu_or(printk_pending, PRINTK_PENDING_WAKEUP);
+		irq_work_queue(&__get_cpu_var(wake_up_klogd_work));
+	}
+	preempt_enable();
+}
+
+int printk_deferred(const char *fmt, ...)
+{
+	va_list args;
+	int r;
+
+	preempt_disable();
+	va_start(args, fmt);
+	r = vprintk_emit(0, SCHED_MESSAGE_LOGLEVEL, NULL, 0, fmt, args);
+	va_end(args);
+	preempt_enable();
+
+	return r;
+}
+
 static void cont_flush(struct printk_log *log, enum log_flags flags)
 {
 	struct printk_cont *cont = log->cont;
@@ -1900,8 +1970,6 @@ static int nmi_seq_is_invalid(u64 seq, u64 first_seq)
  */
 static void merge_nmi_delayed_printk(void)
 {
-	static u64 nmi_merge_seq;
-	static u32 nmi_merge_idx;
 	unsigned long nmi_first_id, nmi_next_id;
 	u32 old_main_next_idx;
 	u64 old_main_next_seq;
@@ -2193,8 +2261,11 @@ asmlinkage int vprintk_emit(int facility, int level,
 	 * relevant locks have been forcefully dropped above. We have to try
 	 * to get the console, otherwise the last messages would get lost.
 	 */
-	if (in_sched || (in_nmi() && !oops_in_progress))
+	if (in_sched || (in_nmi() && !oops_in_progress)) {
+		__this_cpu_or(printk_pending, PRINTK_PENDING_OUTPUT);
+		irq_work_queue(&__get_cpu_var(wake_up_klogd_work));
 		return printed_len;
+	}
 
 	/*
 	 * Disable preemption to avoid being preempted while holding
@@ -3039,60 +3110,6 @@ late_initcall(printk_late_init);
 
 #if defined CONFIG_PRINTK
 /*
- * Delayed printk version, for scheduler-internal messages:
- */
-#define PRINTK_PENDING_WAKEUP	0x01
-#define PRINTK_PENDING_OUTPUT	0x02
-
-static DEFINE_PER_CPU(int, printk_pending);
-
-static void wake_up_klogd_work_func(struct irq_work *irq_work)
-{
-	int pending = __this_cpu_xchg(printk_pending, 0);
-
-	if (pending & PRINTK_PENDING_OUTPUT) {
-		/* If trylock fails, someone else is doing the printing */
-		if (console_trylock())
-			console_unlock();
-	}
-
-	if (pending & PRINTK_PENDING_WAKEUP)
-		wake_up_interruptible(&log_wait);
-}
-
-static DEFINE_PER_CPU(struct irq_work, wake_up_klogd_work) = {
-	.func = wake_up_klogd_work_func,
-	.flags = IRQ_WORK_LAZY,
-};
-
-void wake_up_klogd(void)
-{
-	preempt_disable();
-	if (waitqueue_active(&log_wait)) {
-		this_cpu_or(printk_pending, PRINTK_PENDING_WAKEUP);
-		irq_work_queue(&__get_cpu_var(wake_up_klogd_work));
-	}
-	preempt_enable();
-}
-
-int printk_deferred(const char *fmt, ...)
-{
-	va_list args;
-	int r;
-
-	preempt_disable();
-	va_start(args, fmt);
-	r = vprintk_emit(0, SCHED_MESSAGE_LOGLEVEL, NULL, 0, fmt, args);
-	va_end(args);
-
-	__this_cpu_or(printk_pending, PRINTK_PENDING_OUTPUT);
-	irq_work_queue(&__get_cpu_var(wake_up_klogd_work));
-	preempt_enable();
-
-	return r;
-}
-
-/*
  * printk rate limiting, lifted from the networking subsystem.
  *
  * This enforces a rate limit: not more than 10 kernel messages
-- 
1.8.4

