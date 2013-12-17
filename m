Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754393Ab3LQOs4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 09:48:56 -0500
Received: from cantor2.suse.de ([195.135.220.15]:57446 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753322Ab3LQOsS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 09:48:18 -0500
From: Jan Kara <jack@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, mhocko@suse.cz, pmladek@suse.cz,
        Steven Rostedt <rostedt@goodmis.org>, Jan Kara <jack@suse.cz>
Subject: [PATCH 3/3] printk: Remove separate printk_sched buffers and use printk buf instead
Date: Tue, 17 Dec 2013 15:48:10 +0100
Message-Id: <1387291691-2224-4-git-send-email-jack@suse.cz>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1387291691-2224-1-git-send-email-jack@suse.cz>
References: <1387291691-2224-1-git-send-email-jack@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <rostedt@goodmis.org>

To prevent deadlocks with doing a printk inside the scheduler,
printk_sched() was created. The issue is that printk has a console_sem
that it can grab and release. The release does a wake up if there's a
task pending on the sem, and this wake up grabs the rq locks that is
held in the scheduler. This leads to a possible deadlock if the wake up
uses the same rq as the one with the rq lock held already.

What printk_sched() does is to save the printk write in a per cpu buffer
and sets the PRINTK_PENDING_SCHED flag. On a timer tick, if this flag is
set, the printk() is done against the buffer.

There's a couple of issues with this approach.

1) If two printk_sched()s are called before the tick, the second one
will overwrite the first one.

2) The temporary buffer is 512 bytes and is per cpu. This is a quite a
bit of space wasted for something that is seldom used.

In order to remove this, the printk_sched() can use the printk buffer
instead, and delay the console_trylock()/console_unlock() to the queued
work.

Because printk_sched() would then be taking the logbuf_lock, the
logbuf_lock must not be held while doing anything that may call into the
scheduler functions, which includes wake ups. Unfortunately, printk()
also has a console_sem that it uses, and on release, the
up(&console_sem) may do a wake up of any pending waiters. This must be
avoided while holding the logbuf_lock.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 kernel/printk/printk.c | 43 ++++++++++++++++++++++++++-----------------
 1 file changed, 26 insertions(+), 17 deletions(-)

diff --git a/kernel/printk/printk.c b/kernel/printk/printk.c
index ab0d24a9ab7c..bfbe1a5f6804 100644
--- a/kernel/printk/printk.c
+++ b/kernel/printk/printk.c
@@ -208,6 +208,9 @@ struct printk_log {
 /*
  * The logbuf_lock protects kmsg buffer, indices, counters. It is also
  * used in interesting ways to provide interlocking in console_unlock();
+ * This can be taken within the scheduler's rq lock. It must be released
+ * before calling console_unlock() or anything else that might wake up
+ * a process.
  */
 static DEFINE_RAW_SPINLOCK(logbuf_lock);
 
@@ -1479,14 +1482,19 @@ asmlinkage int vprintk_emit(int facility, int level,
 	static int recursion_bug;
 	static char textbuf[LOG_LINE_MAX];
 	char *text = textbuf;
-	size_t text_len;
+	size_t text_len = 0;
 	enum log_flags lflags = 0;
 	unsigned long flags;
 	int this_cpu;
 	int printed_len = 0;
+	bool in_sched = false;
 	/* cpu currently holding logbuf_lock in this function */
 	static volatile unsigned int logbuf_cpu = UINT_MAX;
 
+	if (level == -2) {
+		level = -1;
+		in_sched = true;
+	}
 
 	boot_delay_msec(level);
 	printk_delay();
@@ -1533,7 +1541,12 @@ asmlinkage int vprintk_emit(int facility, int level,
 	 * The printf needs to come first; we need the syslog
 	 * prefix which might be passed-in as a parameter.
 	 */
-	text_len = vscnprintf(text, sizeof(textbuf), fmt, args);
+	if (in_sched)
+		text_len = scnprintf(text, sizeof(textbuf),
+				     KERN_WARNING "[sched_delayed] ");
+
+	text_len += vscnprintf(text + text_len,
+			       sizeof(textbuf) - text_len, fmt, args);
 
 	/* mark and strip a trailing newline */
 	if (text_len && text[text_len-1] == '\n') {
@@ -1605,6 +1618,10 @@ asmlinkage int vprintk_emit(int facility, int level,
 	lockdep_on();
 	local_irq_restore(flags);
 
+	/* If called from the scheduler, we can not call up(). */
+	if (in_sched)
+		return printed_len;
+
 	/*
 	 * Disable preemption to avoid being preempted while holding
 	 * console_sem which would prevent anyone from printing to console
@@ -2426,21 +2443,19 @@ late_initcall(printk_late_init);
 /*
  * Delayed printk version, for scheduler-internal messages:
  */
-#define PRINTK_BUF_SIZE		512
-
 #define PRINTK_PENDING_WAKEUP	0x01
-#define PRINTK_PENDING_SCHED	0x02
+#define PRINTK_PENDING_OUTPUT	0x02
 
 static DEFINE_PER_CPU(int, printk_pending);
-static DEFINE_PER_CPU(char [PRINTK_BUF_SIZE], printk_sched_buf);
 
 static void wake_up_klogd_work_func(struct irq_work *irq_work)
 {
 	int pending = __this_cpu_xchg(printk_pending, 0);
 
-	if (pending & PRINTK_PENDING_SCHED) {
-		char *buf = __get_cpu_var(printk_sched_buf);
-		pr_warn("[sched_delayed] %s", buf);
+	if (pending & PRINTK_PENDING_OUTPUT) {
+		/* If trylock fails, someone else is doing the printing */
+		if (console_trylock())
+			console_unlock();
 	}
 
 	if (pending & PRINTK_PENDING_WAKEUP)
@@ -2464,21 +2479,15 @@ void wake_up_klogd(void)
 
 int printk_sched(const char *fmt, ...)
 {
-	unsigned long flags;
 	va_list args;
-	char *buf;
 	int r;
 
-	local_irq_save(flags);
-	buf = __get_cpu_var(printk_sched_buf);
-
 	va_start(args, fmt);
-	r = vsnprintf(buf, PRINTK_BUF_SIZE, fmt, args);
+	r = vprintk_emit(0, -2, NULL, 0, fmt, args);
 	va_end(args);
 
-	__this_cpu_or(printk_pending, PRINTK_PENDING_SCHED);
+	__this_cpu_or(printk_pending, PRINTK_PENDING_OUTPUT);
 	irq_work_queue(&__get_cpu_var(wake_up_klogd_work));
-	local_irq_restore(flags);
 
 	return r;
 }
-- 
1.8.1.4

