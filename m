Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933145Ab3CNO0q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 10:26:46 -0400
Received: from mail-vb0-f47.google.com ([209.85.212.47]:41530 "EHLO
	mail-vb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756873Ab3CNO0o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 10:26:44 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        James Hogan <james.hogan@imgtec.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 2/2] printk: Provide a wake_up_klogd() off-case
Date: Thu, 14 Mar 2013 15:26:29 +0100
Message-Id: <1363271189-6631-3-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1363271189-6631-1-git-send-email-fweisbec@gmail.com>
References: <1363271189-6631-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

wake_up_klogd() is useless when CONFIG_PRINTK=n because
neither printk() nor printk_sched() are in use and there
are actually no waiter on log_wait waitqueue. It should
be a stub in this case for users like bust_spinlocks().

Otherwise this results in this warning when CONFIG_PRINTK=n
and CONFIG_IRQ_WORK=n:

	kernel/built-in.o In function `wake_up_klogd':
	(.text.wake_up_klogd+0xb4): undefined reference to `irq_work_queue'

To fix this, provide an off-case for wake_up_klogd() when
CONFIG_PRINTK=n.

There is much more from console_unlock() and other console
related code in printk.c that should be moved under
CONFIG_PRINTK. But for now, focus on a minimal fix as we passed
the merged window already.

Reported-by: James Hogan <james.hogan@imgtec.com>
Cc: James Hogan <james.hogan@imgtec.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 include/linux/kernel.h |    1 -
 include/linux/printk.h |    6 +++
 kernel/printk.c        |   80 +++++++++++++++++++++++------------------------
 3 files changed, 45 insertions(+), 42 deletions(-)

diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index 80d3687..79fdd80 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -390,7 +390,6 @@ extern struct pid *session_of_pgrp(struct pid *pgrp);
 unsigned long int_sqrt(unsigned long);
 
 extern void bust_spinlocks(int yes);
-extern void wake_up_klogd(void);
 extern int oops_in_progress;		/* If set, an oops, panic(), BUG() or die() is in progress */
 extern int panic_timeout;
 extern int panic_on_oops;
diff --git a/include/linux/printk.h b/include/linux/printk.h
index 1249a54..822171f 100644
--- a/include/linux/printk.h
+++ b/include/linux/printk.h
@@ -134,6 +134,8 @@ extern int printk_delay_msec;
 extern int dmesg_restrict;
 extern int kptr_restrict;
 
+extern void wake_up_klogd(void);
+
 void log_buf_kexec_setup(void);
 void __init setup_log_buf(int early);
 #else
@@ -162,6 +164,10 @@ static inline bool printk_timed_ratelimit(unsigned long *caller_jiffies,
 	return false;
 }
 
+static inline void wake_up_klogd(void)
+{
+}
+
 static inline void log_buf_kexec_setup(void)
 {
 }
diff --git a/kernel/printk.c b/kernel/printk.c
index 0b31715..abbdd9e 100644
--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -63,8 +63,6 @@ void asmlinkage __attribute__((weak)) early_printk(const char *fmt, ...)
 #define MINIMUM_CONSOLE_LOGLEVEL 1 /* Minimum loglevel we let people use */
 #define DEFAULT_CONSOLE_LOGLEVEL 7 /* anything MORE serious than KERN_DEBUG */
 
-DECLARE_WAIT_QUEUE_HEAD(log_wait);
-
 int console_printk[4] = {
 	DEFAULT_CONSOLE_LOGLEVEL,	/* console_loglevel */
 	DEFAULT_MESSAGE_LOGLEVEL,	/* default_message_loglevel */
@@ -224,6 +222,7 @@ struct log {
 static DEFINE_RAW_SPINLOCK(logbuf_lock);
 
 #ifdef CONFIG_PRINTK
+DECLARE_WAIT_QUEUE_HEAD(log_wait);
 /* the next printk record to read by syslog(READ) or /proc/kmsg */
 static u64 syslog_seq;
 static u32 syslog_idx;
@@ -1957,45 +1956,6 @@ int is_console_locked(void)
 	return console_locked;
 }
 
-/*
- * Delayed printk version, for scheduler-internal messages:
- */
-#define PRINTK_BUF_SIZE		512
-
-#define PRINTK_PENDING_WAKEUP	0x01
-#define PRINTK_PENDING_SCHED	0x02
-
-static DEFINE_PER_CPU(int, printk_pending);
-static DEFINE_PER_CPU(char [PRINTK_BUF_SIZE], printk_sched_buf);
-
-static void wake_up_klogd_work_func(struct irq_work *irq_work)
-{
-	int pending = __this_cpu_xchg(printk_pending, 0);
-
-	if (pending & PRINTK_PENDING_SCHED) {
-		char *buf = __get_cpu_var(printk_sched_buf);
-		printk(KERN_WARNING "[sched_delayed] %s", buf);
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
 static void console_cont_flush(char *text, size_t size)
 {
 	unsigned long flags;
@@ -2458,6 +2418,44 @@ static int __init printk_late_init(void)
 late_initcall(printk_late_init);
 
 #if defined CONFIG_PRINTK
+/*
+ * Delayed printk version, for scheduler-internal messages:
+ */
+#define PRINTK_BUF_SIZE		512
+
+#define PRINTK_PENDING_WAKEUP	0x01
+#define PRINTK_PENDING_SCHED	0x02
+
+static DEFINE_PER_CPU(int, printk_pending);
+static DEFINE_PER_CPU(char [PRINTK_BUF_SIZE], printk_sched_buf);
+
+static void wake_up_klogd_work_func(struct irq_work *irq_work)
+{
+	int pending = __this_cpu_xchg(printk_pending, 0);
+
+	if (pending & PRINTK_PENDING_SCHED) {
+		char *buf = __get_cpu_var(printk_sched_buf);
+		printk(KERN_WARNING "[sched_delayed] %s", buf);
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
 
 int printk_sched(const char *fmt, ...)
 {
-- 
1.7.5.4

