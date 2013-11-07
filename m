Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755519Ab3KGVtR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 16:49:17 -0500
Received: from cantor2.suse.de ([195.135.220.15]:43781 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755228Ab3KGVs5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 16:48:57 -0500
From: Jan Kara <jack@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, mhocko@suse.cz,
        Steven Rostedt <rostedt@goodmis.org>, Jan Kara <jack@suse.cz>
Subject: [PATCH 4/4] printk: Use unbound irq work for printing and waking
Date: Thu,  7 Nov 2013 22:48:39 +0100
Message-Id: <1383860919-1883-5-git-send-email-jack@suse.cz>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1383860919-1883-1-git-send-email-jack@suse.cz>
References: <1383860919-1883-1-git-send-email-jack@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now when per-cpu printk buffers are gone, there's no need to have printk
flags or printk irq_work per cpu. Just make printk_pending a single
variable operated by atomic operations and have single unbound irq work
doing the waking and printing. This has an advantage that any cpu can do the
printing / wakeup work thus lowering the latency of printing and better
distributing the printing work over cpus.

Reviewed-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 kernel/printk/printk.c | 47 ++++++++++++++++++++++++++---------------------
 1 file changed, 26 insertions(+), 21 deletions(-)

diff --git a/kernel/printk/printk.c b/kernel/printk/printk.c
index 35bb70ea6427..dc314f074e8f 100644
--- a/kernel/printk/printk.c
+++ b/kernel/printk/printk.c
@@ -2499,36 +2499,41 @@ late_initcall(printk_late_init);
 /*
  * Delayed printk version, for scheduler-internal messages:
  */
-#define PRINTK_PENDING_WAKEUP	0x01
-#define PRINTK_PENDING_OUTPUT	0x02
+#define PRINTK_PENDING_WAKEUP	0
+#define PRINTK_PENDING_OUTPUT	1
 
-static DEFINE_PER_CPU(int, printk_pending);
+static unsigned long printk_pending;
 
-static void wake_up_klogd_work_func(struct irq_work *irq_work)
+static void printk_irq_work_func(struct irq_work *irq_work)
 {
-	int pending = __this_cpu_xchg(printk_pending, 0);
+	if (printk_pending) {
+		unsigned long pending = xchg(&printk_pending, 0);
 
-	if (pending & PRINTK_PENDING_OUTPUT) {
-		/* If trylock fails, someone else is doing the printing */
-		if (console_trylock())
-			console_unlock();
-	}
+		if (test_bit(PRINTK_PENDING_OUTPUT, &pending)) {
+			/*
+			 * If trylock fails, someone else is doing the
+			 * printing
+			 */
+			if (console_trylock())
+				console_unlock();
+		}
 
-	if (pending & PRINTK_PENDING_WAKEUP)
-		wake_up_interruptible(&log_wait);
+		if (test_bit(PRINTK_PENDING_WAKEUP, &pending))
+			wake_up_interruptible(&log_wait);
+	}
 }
 
-static DEFINE_PER_CPU(struct irq_work, wake_up_klogd_work) = {
-	.func = wake_up_klogd_work_func,
-	.flags = IRQ_WORK_LAZY,
+static struct irq_work printk_irq_work = {
+	.func = printk_irq_work_func,
+	.flags = IRQ_WORK_UNBOUND,
 };
 
 void wake_up_klogd(void)
 {
 	preempt_disable();
 	if (waitqueue_active(&log_wait)) {
-		this_cpu_or(printk_pending, PRINTK_PENDING_WAKEUP);
-		irq_work_queue(&__get_cpu_var(wake_up_klogd_work));
+		set_bit(PRINTK_PENDING_WAKEUP, &printk_pending);
+		irq_work_queue(&printk_irq_work);
 	}
 	preempt_enable();
 }
@@ -2542,8 +2547,8 @@ int printk_sched(const char *fmt, ...)
 	r = vprintk_emit(0, -2, NULL, 0, fmt, args);
 	va_end(args);
 
-	__this_cpu_or(printk_pending, PRINTK_PENDING_OUTPUT);
-	irq_work_queue(&__get_cpu_var(wake_up_klogd_work));
+	set_bit(PRINTK_PENDING_OUTPUT, &printk_pending);
+	irq_work_queue(&printk_irq_work);
 
 	return r;
 }
@@ -2556,8 +2561,8 @@ void console_unlock(void)
 {
        if (__console_unlock()) {
                /* Leave the rest of printing for a timer tick */
-		__this_cpu_or(printk_pending, PRINTK_PENDING_OUTPUT);
-		irq_work_queue(&__get_cpu_var(wake_up_klogd_work));
+		set_bit(PRINTK_PENDING_OUTPUT, &printk_pending);
+		irq_work_queue(&printk_irq_work);
 	}
 }
 EXPORT_SYMBOL(console_unlock);
-- 
1.8.1.4

