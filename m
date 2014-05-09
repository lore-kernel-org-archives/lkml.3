Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756480AbaEIJNK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 05:13:10 -0400
Received: from cantor2.suse.de ([195.135.220.15]:40863 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756448AbaEIJNI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 05:13:08 -0400
From: Petr Mladek <pmladek@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Dave Anderson <anderson@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Kay Sievers <kay@vrfy.org>, Jiri Kosina <jkosina@suse.cz>,
        Michal Hocko <mhocko@suse.cz>, Jan Kara <jack@suse.cz>,
        linux-kernel@vger.kernel.org, Petr Mladek <pmladek@suse.cz>
Subject: [RFC PATCH 03/11] printk: rename "logbuf_lock" to "main_logbuf_lock"
Date: Fri,  9 May 2014 11:10:57 +0200
Message-Id: <1399626665-29817-4-git-send-email-pmladek@suse.cz>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1399626665-29817-1-git-send-email-pmladek@suse.cz>
References: <1399626665-29817-1-git-send-email-pmladek@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make the naming consistent with the "main_log" and "main_cont".

This commit does not change the behavior.

Signed-off-by: Petr Mladek <pmladek@suse.cz>
---
 kernel/printk/printk.c | 98 +++++++++++++++++++++++++-------------------------
 1 file changed, 49 insertions(+), 49 deletions(-)

diff --git a/kernel/printk/printk.c b/kernel/printk/printk.c
index c560ebdecc04..d64533f9e6b2 100644
--- a/kernel/printk/printk.c
+++ b/kernel/printk/printk.c
@@ -148,11 +148,11 @@ EXPORT_SYMBOL(console_set_on_cmdline);
 static int console_may_schedule;
 
 /*
- * The logbuf_lock protects kmsg buffer, indexes, counters. This can be taken
- * within the scheduler's rq lock. It must be released before calling
+ * The main_logbuf_lock protects kmsg buffer, indexes, counters. This can be
+ * taken within the scheduler's rq lock. It must be released before calling
  * console_unlock() or anything else that might wake up a process.
  */
-static DEFINE_RAW_SPINLOCK(logbuf_lock);
+static DEFINE_RAW_SPINLOCK(main_logbuf_lock);
 
 /*
  * The printk log buffer consists of a chain of concatenated variable
@@ -691,21 +691,21 @@ static ssize_t devkmsg_read(struct file *file, char __user *buf,
 	ret = mutex_lock_interruptible(&user->lock);
 	if (ret)
 		return ret;
-	raw_spin_lock_irq(&logbuf_lock);
+	raw_spin_lock_irq(&main_logbuf_lock);
 	while (user->seq == get_next_seq(&main_log)) {
 		if (file->f_flags & O_NONBLOCK) {
 			ret = -EAGAIN;
-			raw_spin_unlock_irq(&logbuf_lock);
+			raw_spin_unlock_irq(&main_logbuf_lock);
 			goto out;
 		}
 
-		raw_spin_unlock_irq(&logbuf_lock);
+		raw_spin_unlock_irq(&main_logbuf_lock);
 		ret = wait_event_interruptible(log_wait,
 					       user->seq !=
 					       get_next_seq(&main_log));
 		if (ret)
 			goto out;
-		raw_spin_lock_irq(&logbuf_lock);
+		raw_spin_lock_irq(&main_logbuf_lock);
 	}
 
 	if (user->seq < get_first_seq(&main_log)) {
@@ -713,7 +713,7 @@ static ssize_t devkmsg_read(struct file *file, char __user *buf,
 		user->idx = get_first_idx(&main_log);
 		user->seq = get_first_seq(&main_log);
 		ret = -EPIPE;
-		raw_spin_unlock_irq(&logbuf_lock);
+		raw_spin_unlock_irq(&main_logbuf_lock);
 		goto out;
 	}
 
@@ -780,7 +780,7 @@ static ssize_t devkmsg_read(struct file *file, char __user *buf,
 
 	user->idx = inc_idx(&main_log, user->idx);
 	user->seq++;
-	raw_spin_unlock_irq(&logbuf_lock);
+	raw_spin_unlock_irq(&main_logbuf_lock);
 
 	if (len > count) {
 		ret = -EINVAL;
@@ -807,7 +807,7 @@ static loff_t devkmsg_llseek(struct file *file, loff_t offset, int whence)
 	if (offset)
 		return -ESPIPE;
 
-	raw_spin_lock_irq(&logbuf_lock);
+	raw_spin_lock_irq(&main_logbuf_lock);
 	switch (whence) {
 	case SEEK_SET:
 		/* the first record */
@@ -831,7 +831,7 @@ static loff_t devkmsg_llseek(struct file *file, loff_t offset, int whence)
 	default:
 		ret = -EINVAL;
 	}
-	raw_spin_unlock_irq(&logbuf_lock);
+	raw_spin_unlock_irq(&main_logbuf_lock);
 	return ret;
 }
 
@@ -845,7 +845,7 @@ static unsigned int devkmsg_poll(struct file *file, poll_table *wait)
 
 	poll_wait(file, &log_wait, wait);
 
-	raw_spin_lock_irq(&logbuf_lock);
+	raw_spin_lock_irq(&main_logbuf_lock);
 	if (user->seq < get_next_seq(&main_log)) {
 		/* return error when data has vanished underneath us */
 		if (user->seq < get_first_seq(&main_log))
@@ -853,7 +853,7 @@ static unsigned int devkmsg_poll(struct file *file, poll_table *wait)
 		else
 			ret = POLLIN|POLLRDNORM;
 	}
-	raw_spin_unlock_irq(&logbuf_lock);
+	raw_spin_unlock_irq(&main_logbuf_lock);
 
 	return ret;
 }
@@ -878,10 +878,10 @@ static int devkmsg_open(struct inode *inode, struct file *file)
 
 	mutex_init(&user->lock);
 
-	raw_spin_lock_irq(&logbuf_lock);
+	raw_spin_lock_irq(&main_logbuf_lock);
 	user->idx = get_first_idx(&main_log);
 	user->seq = get_first_seq(&main_log);
-	raw_spin_unlock_irq(&logbuf_lock);
+	raw_spin_unlock_irq(&main_logbuf_lock);
 
 	file->private_data = user;
 	return 0;
@@ -977,13 +977,13 @@ void __init setup_log_buf(int early)
 		return;
 	}
 
-	raw_spin_lock_irqsave(&logbuf_lock, flags);
+	raw_spin_lock_irqsave(&main_logbuf_lock, flags);
 	main_log.buf_len = new_log_buf_len;
 	main_log.buf = new_log_buf;
 	new_log_buf_len = 0;
 	free = __LOG_BUF_LEN - get_next_idx(&main_log);
 	memcpy(main_log.buf, __log_buf, __LOG_BUF_LEN);
-	raw_spin_unlock_irqrestore(&logbuf_lock, flags);
+	raw_spin_unlock_irqrestore(&main_logbuf_lock, flags);
 
 	pr_info("log_buf_len: %d\n", main_log.buf_len);
 	pr_info("early log buf free: %d(%d%%)\n",
@@ -1179,7 +1179,7 @@ static int syslog_print(char __user *buf, int size)
 		size_t n;
 		size_t skip;
 
-		raw_spin_lock_irq(&logbuf_lock);
+		raw_spin_lock_irq(&main_logbuf_lock);
 		if (syslog_seq < get_first_seq(&main_log)) {
 			/* messages are gone, move to first one */
 			syslog_seq = get_first_seq(&main_log);
@@ -1188,7 +1188,7 @@ static int syslog_print(char __user *buf, int size)
 			syslog_partial = 0;
 		}
 		if (syslog_seq == get_next_seq(&main_log)) {
-			raw_spin_unlock_irq(&logbuf_lock);
+			raw_spin_unlock_irq(&main_logbuf_lock);
 			break;
 		}
 
@@ -1209,7 +1209,7 @@ static int syslog_print(char __user *buf, int size)
 			syslog_partial += n;
 		} else
 			n = 0;
-		raw_spin_unlock_irq(&logbuf_lock);
+		raw_spin_unlock_irq(&main_logbuf_lock);
 
 		if (!n)
 			break;
@@ -1238,7 +1238,7 @@ static int syslog_print_all(char __user *buf, int size, bool clear)
 	if (!text)
 		return -ENOMEM;
 
-	raw_spin_lock_irq(&logbuf_lock);
+	raw_spin_lock_irq(&main_logbuf_lock);
 	if (buf) {
 		u64 next_seq;
 		u64 seq;
@@ -1298,12 +1298,12 @@ static int syslog_print_all(char __user *buf, int size, bool clear)
 			seq++;
 			prev = msg->flags;
 
-			raw_spin_unlock_irq(&logbuf_lock);
+			raw_spin_unlock_irq(&main_logbuf_lock);
 			if (copy_to_user(buf + len, text, textlen))
 				len = -EFAULT;
 			else
 				len += textlen;
-			raw_spin_lock_irq(&logbuf_lock);
+			raw_spin_lock_irq(&main_logbuf_lock);
 
 			if (seq < get_first_seq(&main_log)) {
 				/* messages are gone, move to next one */
@@ -1318,7 +1318,7 @@ static int syslog_print_all(char __user *buf, int size, bool clear)
 		clear_seq = get_next_seq(&main_log);
 		clear_idx = get_next_idx(&main_log);
 	}
-	raw_spin_unlock_irq(&logbuf_lock);
+	raw_spin_unlock_irq(&main_logbuf_lock);
 
 	kfree(text);
 	return len;
@@ -1410,7 +1410,7 @@ int do_syslog(int type, char __user *buf, int len, bool from_file)
 		break;
 	/* Number of chars in the log buffer */
 	case SYSLOG_ACTION_SIZE_UNREAD:
-		raw_spin_lock_irq(&logbuf_lock);
+		raw_spin_lock_irq(&main_logbuf_lock);
 		if (syslog_seq < get_first_seq(&main_log)) {
 			/* messages are gone, move to first one */
 			syslog_seq = get_first_seq(&main_log);
@@ -1443,7 +1443,7 @@ int do_syslog(int type, char __user *buf, int len, bool from_file)
 			}
 			error -= syslog_partial;
 		}
-		raw_spin_unlock_irq(&logbuf_lock);
+		raw_spin_unlock_irq(&main_logbuf_lock);
 		break;
 	/* Size of the log buffer */
 	case SYSLOG_ACTION_SIZE_BUFFER:
@@ -1509,7 +1509,7 @@ static void zap_locks(void)
 
 	debug_locks_off();
 	/* If a crash is occurring, make sure we can't deadlock */
-	raw_spin_lock_init(&logbuf_lock);
+	raw_spin_lock_init(&main_logbuf_lock);
 	/* And make sure that we print immediately */
 	sema_init(&console_sem, 1);
 }
@@ -1726,7 +1726,7 @@ asmlinkage int vprintk_emit(int facility, int level,
 	}
 
 	lockdep_off();
-	raw_spin_lock(&logbuf_lock);
+	raw_spin_lock(&main_logbuf_lock);
 	logbuf_cpu = this_cpu;
 
 	if (recursion_bug) {
@@ -1829,7 +1829,7 @@ asmlinkage int vprintk_emit(int facility, int level,
 	}
 
 	logbuf_cpu = UINT_MAX;
-	raw_spin_unlock(&logbuf_lock);
+	raw_spin_unlock(&main_logbuf_lock);
 	lockdep_on();
 	local_irq_restore(flags);
 
@@ -2206,7 +2206,7 @@ static void console_cont_flush(char *text, size_t size)
 	unsigned long flags;
 	size_t len;
 
-	raw_spin_lock_irqsave(&logbuf_lock, flags);
+	raw_spin_lock_irqsave(&main_logbuf_lock, flags);
 
 	if (!main_cont.len)
 		goto out;
@@ -2220,14 +2220,14 @@ static void console_cont_flush(char *text, size_t size)
 		goto out;
 
 	len = cont_print_text(text, size);
-	raw_spin_unlock(&logbuf_lock);
+	raw_spin_unlock(&main_logbuf_lock);
 	stop_critical_timings();
 	call_console_drivers(main_cont.level, text, len);
 	start_critical_timings();
 	local_irq_restore(flags);
 	return;
 out:
-	raw_spin_unlock_irqrestore(&logbuf_lock, flags);
+	raw_spin_unlock_irqrestore(&main_logbuf_lock, flags);
 }
 
 /**
@@ -2268,7 +2268,7 @@ again:
 		size_t len;
 		int level;
 
-		raw_spin_lock_irqsave(&logbuf_lock, flags);
+		raw_spin_lock_irqsave(&main_logbuf_lock, flags);
 		console_end_seq = get_next_seq(&main_log);
 again_noirq:
 		if (seen_seq != get_next_seq(&main_log)) {
@@ -2316,14 +2316,14 @@ skip:
 		console_idx = inc_idx(&main_log, console_idx);
 		console_seq++;
 		console_prev = msg->flags;
-		raw_spin_unlock(&logbuf_lock);
+		raw_spin_unlock(&main_logbuf_lock);
 
 		stop_critical_timings();	/* don't trace print latency */
 		call_console_drivers(level, text, len);
 		start_critical_timings();
 
 		if (console_seq < console_end_seq) {
-			raw_spin_lock(&logbuf_lock);
+			raw_spin_lock(&main_logbuf_lock);
 			goto again_noirq;
 		}
 
@@ -2335,7 +2335,7 @@ skip:
 	if (unlikely(exclusive_console))
 		exclusive_console = NULL;
 
-	raw_spin_unlock(&logbuf_lock);
+	raw_spin_unlock(&main_logbuf_lock);
 
 	up_console_sem();
 
@@ -2345,9 +2345,9 @@ skip:
 	 * there's a new owner and the console_unlock() from them will do the
 	 * flush, no worries.
 	 */
-	raw_spin_lock(&logbuf_lock);
+	raw_spin_lock(&main_logbuf_lock);
 	retry = console_seq != get_next_seq(&main_log);
-	raw_spin_unlock_irqrestore(&logbuf_lock, flags);
+	raw_spin_unlock_irqrestore(&main_logbuf_lock, flags);
 
 	if (retry && console_trylock())
 		goto again;
@@ -2584,11 +2584,11 @@ void register_console(struct console *newcon)
 		 * console_unlock(); will print out the buffered messages
 		 * for us.
 		 */
-		raw_spin_lock_irqsave(&logbuf_lock, flags);
+		raw_spin_lock_irqsave(&main_logbuf_lock, flags);
 		console_seq = syslog_seq;
 		console_idx = syslog_idx;
 		console_prev = syslog_prev;
-		raw_spin_unlock_irqrestore(&logbuf_lock, flags);
+		raw_spin_unlock_irqrestore(&main_logbuf_lock, flags);
 		/*
 		 * We're about to replay the log buffer.  Only do this to the
 		 * just-registered console to avoid excessive message spam to
@@ -2855,12 +2855,12 @@ void kmsg_dump(enum kmsg_dump_reason reason)
 		/* initialize iterator with data about the stored records */
 		dumper->active = true;
 
-		raw_spin_lock_irqsave(&logbuf_lock, flags);
+		raw_spin_lock_irqsave(&main_logbuf_lock, flags);
 		dumper->cur_seq = clear_seq;
 		dumper->cur_idx = clear_idx;
 		dumper->next_seq = get_next_seq(&main_log);
 		dumper->next_idx = get_next_idx(&main_log);
-		raw_spin_unlock_irqrestore(&logbuf_lock, flags);
+		raw_spin_unlock_irqrestore(&main_logbuf_lock, flags);
 
 		/* invoke dumper which will iterate over records */
 		dumper->dump(dumper, reason);
@@ -2945,9 +2945,9 @@ bool kmsg_dump_get_line(struct kmsg_dumper *dumper, bool syslog,
 	unsigned long flags;
 	bool ret;
 
-	raw_spin_lock_irqsave(&logbuf_lock, flags);
+	raw_spin_lock_irqsave(&main_logbuf_lock, flags);
 	ret = kmsg_dump_get_line_nolock(dumper, syslog, line, size, len);
-	raw_spin_unlock_irqrestore(&logbuf_lock, flags);
+	raw_spin_unlock_irqrestore(&main_logbuf_lock, flags);
 
 	return ret;
 }
@@ -2987,7 +2987,7 @@ bool kmsg_dump_get_buffer(struct kmsg_dumper *dumper, bool syslog,
 	if (!dumper->active)
 		goto out;
 
-	raw_spin_lock_irqsave(&logbuf_lock, flags);
+	raw_spin_lock_irqsave(&main_logbuf_lock, flags);
 	if (dumper->cur_seq < get_first_seq(&main_log)) {
 		/* messages are gone, move to first available one */
 		dumper->cur_seq = get_first_seq(&main_log);
@@ -2996,7 +2996,7 @@ bool kmsg_dump_get_buffer(struct kmsg_dumper *dumper, bool syslog,
 
 	/* last entry */
 	if (dumper->cur_seq >= dumper->next_seq) {
-		raw_spin_unlock_irqrestore(&logbuf_lock, flags);
+		raw_spin_unlock_irqrestore(&main_logbuf_lock, flags);
 		goto out;
 	}
 
@@ -3043,7 +3043,7 @@ bool kmsg_dump_get_buffer(struct kmsg_dumper *dumper, bool syslog,
 	dumper->next_seq = next_seq;
 	dumper->next_idx = next_idx;
 	ret = true;
-	raw_spin_unlock_irqrestore(&logbuf_lock, flags);
+	raw_spin_unlock_irqrestore(&main_logbuf_lock, flags);
 out:
 	if (len)
 		*len = l;
@@ -3081,9 +3081,9 @@ void kmsg_dump_rewind(struct kmsg_dumper *dumper)
 {
 	unsigned long flags;
 
-	raw_spin_lock_irqsave(&logbuf_lock, flags);
+	raw_spin_lock_irqsave(&main_logbuf_lock, flags);
 	kmsg_dump_rewind_nolock(dumper);
-	raw_spin_unlock_irqrestore(&logbuf_lock, flags);
+	raw_spin_unlock_irqrestore(&main_logbuf_lock, flags);
 }
 EXPORT_SYMBOL_GPL(kmsg_dump_rewind);
 
-- 
1.8.4

