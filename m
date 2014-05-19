Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754383AbaESK2v (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 06:28:51 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:58299 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753715AbaESK2m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 06:28:42 -0400
X-AuditID: 85900ec0-d312bb9000001514-15-5379dcd781df
Subject: [RFC PATCH 1/2] printk: Add context information to the header of
 /dev/kmsg
To: Andrew Morton <akpm@linux-foundation.org>, Kay Sievers <kay@vrfy.org>,
        linux-kernel@vger.kernel.org
From: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
Cc: Kees Cook <keescook@chromium.org>, Randy Dunlap <rdunlap@infradead.org>,
        Petr Mladek <pmladek@suse.cz>,
        Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>,
        yrl.pp-manager.tt@hitachi.com,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Joe Perches <joe@perches.com>, Arun KS <arunks.linux@gmail.com>
Date: Mon, 19 May 2014 19:28:38 +0900
Message-ID: <20140519102838.30455.86863.stgit@yunodevel>
In-Reply-To: <20140519102835.30455.10437.stgit@yunodevel>
References: <20140519102835.30455.10437.stgit@yunodevel>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add context information to the header of /dev/kmsg.

Two printk messages connected with KERN_CONT can be divided in multiple lines
by a different process context message. If the different context message seems
like the 1st divided message, it is difficult to understand which the 2nd
divided message belongs to. This problem can also occur for the situation where
multiple message lines without KERN_CONT are broken into by similar messages.
For example, SCSI disk error messages can be show as follows:

	[110781.736171] sd 2:0:0:0: [sdb]
	[110781.736170] sd 3:0:0:0: [sdc] Unhandled sense code
	[110781.736172] sd 3:0:0:0: [sdc]
	[110781.736175] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
	[110781.736177] sd 3:0:0:0: [sdc]
	[110781.736178] Sense Key : Medium Error [current]
	[110781.736187] Sense Key : Recovered Error
	[110781.736189] [current]

This patch adds PID and interrupt context flag to the header of /dev/kmsg as
the context information in order to understand relation of output messages. If
PID values of two messages and the interrupt context flags are same, it means
that those messages are same context, so those message have some relation. If
not so, it means that those messages are different context, so users do not
need to take care about the relation of the messages.

The header information is changed as follows:
   <prefix>,<seq#>,<timestamp>,<fragmented>,<PID>/<interrupt context>;<msg>
                                            |                       |
                                            +-----------------------+
                                                   context info.
Interrupt context indicates as follows:
   n: NMI context
   h: Hard IRQ context
   s: Soft IRQ context
   -: No interrupt context

<Examples>
 - Output same 3 printk messages in two kernel threads.
   Run two kernel threads in same time in order to make the messages compete.
	pr_info("A1");
	printk("A2");
	printk("A3\n");

 - Current implementation (without context information)
	6,3321,31629088,-;A1    <== Who output this message?
	6,3322,31629091,c;A1         |
	4,3323,31629094,+;A2    <----+
	4,3324,31629095,+;A3         | Which?
	4,3325,31629097,c;A2    <----+
	4,3326,31629099,+;A3
 A1, A2, and A3 messages of two threads are clearly fragmented in this result,
 but we cannot understand who output the 1st line message and which messages
 were output by whom. So, the relation of divided messages is unclear from this
 test.

 - Applying this patch (with context information)
	6,2308,36687114,-,622/-;A1    <== Output by PID=622
	6,2309,36687118,c,621/-;A1         |
	4,2310,36687121,+,621/-;A2         | Relate
	4,2311,36687123,+,621/-;A3         |
	4,2312,36687124,c,622/-;A2    <----+   (1)
	4,2313,36687126,+,622/-;A3    <----+   (2)
   We can understand the relation of divided messages. For example,
   the 1st line indicates PID=622 and no interrupt context. The same context
   is the lines of (1) and (2). So, users can understand these three messages
   are output by the same thread.

Note:
According to Documentation/ABI/testing/dev-kmsg, we can add comma separated
values before ';' as the header information of /dev/kmsg. So, this change does
not affect ABI.

Signed-off-by: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
Signed-off-by: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Kay Sievers <kay@vrfy.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Joe Perches <joe@perches.com>
Cc: Petr Mladek <pmladek@suse.cz>
Cc: Arun KS <arunks.linux@gmail.com>
Cc: Kees Cook <keescook@chromium.org>
---
 Documentation/ABI/testing/dev-kmsg |   21 ++++++++--
 kernel/printk/printk.c             |   77 ++++++++++++++++++++++++++++--------
 2 files changed, 76 insertions(+), 22 deletions(-)

diff --git a/Documentation/ABI/testing/dev-kmsg b/Documentation/ABI/testing/dev-kmsg
index bb820be..d8128ac 100644
--- a/Documentation/ABI/testing/dev-kmsg
+++ b/Documentation/ABI/testing/dev-kmsg
@@ -77,11 +77,11 @@ Description:	The /dev/kmsg character device node provides userspace access
 		userspace.
 
 		Example:
-		7,160,424069,-;pci_root PNP0A03:00: host bridge window [io  0x0000-0x0cf7] (ignored)
+		7,160,424069,-,1/-;pci_root PNP0A03:00: host bridge window [io  0x0000-0x0cf7] (ignored)
 		 SUBSYSTEM=acpi
 		 DEVICE=+acpi:PNP0A03:00
-		6,339,5140900,-;NET: Registered protocol family 10
-		30,340,5690716,-;udevd[80]: starting version 181
+		6,339,5140900,-,1/-;NET: Registered protocol family 10
+		30,340,5690716,-,80/-;udevd[80]: starting version 181
 
 		The DEVICE= key uniquely identifies devices the following way:
 		  b12:8        - block dev_t
@@ -89,7 +89,7 @@ Description:	The /dev/kmsg character device node provides userspace access
 		  n8           - netdev ifindex
 		  +sound:card0 - subsystem:devname
 
-		The flags field carries '-' by default. A 'c' indicates a
+		The 4th flags field carries '-' by default. A 'c' indicates a
 		fragment of a line. All following fragments are flagged with
 		'+'. Note, that these hints about continuation lines are not
 		necessarily correct, and the stream could be interleaved with
@@ -98,4 +98,17 @@ Description:	The /dev/kmsg character device node provides userspace access
 		logic is used internally when messages are printed to the
 		console, /proc/kmsg or the syslog() syscall.
 
+		The 5th field is context information to separate mixed messages
+		from different contexts. The field indicates PID and interrupt
+		context information like '<PID>/<interrupt context info.>'. In
+		interrupt context information, 'n' indicates NMI context, 'h'
+		indicates hard IRQ context, 's' indicates soft IRQ context, and
+		'-' indicates no interrupt context. This 5th context field tells
+		users which messages are output in the same context. If PID
+		values of two messages and interrupt context are same, it means
+		that those messages are output by the same process, so those
+		message may have any relation. If not so, it means that those
+		messages are different context, so users do not need to care
+		about the relation of the messages.
+
 Users:		dmesg(1), userspace kernel log consumers
diff --git a/kernel/printk/printk.c b/kernel/printk/printk.c
index 7228258..8105431 100644
--- a/kernel/printk/printk.c
+++ b/kernel/printk/printk.c
@@ -197,6 +197,8 @@ enum log_flags {
 
 struct printk_log {
 	u64 ts_nsec;		/* timestamp in nanoseconds */
+	pid_t pid;		/* identify PID */
+	u32 irq_count;		/* identify irq_count */
 	u16 len;		/* length of entire record */
 	u16 text_len;		/* length of text buffer */
 	u16 dict_len;		/* length of dictionary buffer */
@@ -298,10 +300,11 @@ static u32 log_next(u32 idx)
 }
 
 /* insert record into the buffer, discard old ones, update heads */
-static void log_store(int facility, int level,
-		      enum log_flags flags, u64 ts_nsec,
-		      const char *dict, u16 dict_len,
-		      const char *text, u16 text_len)
+static void __log_store(int facility, int level,
+			enum log_flags flags, u64 ts_nsec,
+			const char *dict, u16 dict_len,
+			const char *text, u16 text_len,
+			pid_t pid, u32 irq_count)
 {
 	struct printk_log *msg;
 	u32 size, pad_len;
@@ -339,6 +342,8 @@ static void log_store(int facility, int level,
 
 	/* fill message */
 	msg = (struct printk_log *)(log_buf + log_next_idx);
+	msg->pid = pid;
+	msg->irq_count = irq_count;
 	memcpy(log_text(msg), text, text_len);
 	msg->text_len = text_len;
 	memcpy(log_dict(msg), dict, dict_len);
@@ -470,6 +475,18 @@ out:
 	return ret;
 }
 
+static char show_irq_count_flag(u32 irq_count)
+{
+	if (irq_count & NMI_MASK)
+		return 'n';
+	else if (irq_count & HARDIRQ_MASK)
+		return 'h';
+	else if (irq_count & SOFTIRQ_MASK)
+		return 's';
+	else
+		return '-';
+}
+
 static ssize_t devkmsg_read(struct file *file, char __user *buf,
 			    size_t count, loff_t *ppos)
 {
@@ -530,9 +547,10 @@ static ssize_t devkmsg_read(struct file *file, char __user *buf,
 		 ((user->prev & LOG_CONT) && !(msg->flags & LOG_PREFIX)))
 		cont = '+';
 
-	len = sprintf(user->buf, "%u,%llu,%llu,%c;",
+	len = sprintf(user->buf, "%u,%llu,%llu,%c,%d/%c;",
 		      (msg->facility << 3) | msg->level,
-		      user->seq, ts_usec, cont);
+		      user->seq, ts_usec, cont, msg->pid,
+		      show_irq_count_flag(msg->irq_count));
 	user->prev = msg->flags;
 
 	/* escape non-printable characters */
@@ -1391,12 +1409,31 @@ static struct cont {
 	size_t cons;			/* bytes written to console */
 	struct task_struct *owner;	/* task of first print*/
 	u64 ts_nsec;			/* time of first print */
+	u32 irq_count;			/* irq_count of first print */
 	u8 level;			/* log level of first message */
 	u8 facility;			/* log level of first message */
 	enum log_flags flags;		/* prefix, newline flags */
 	bool flushed:1;			/* buffer sealed and committed */
 } cont;
 
+static inline void log_store_cont(int facility, int level,
+				  enum log_flags flags, u64 ts_nsec,
+				  const char *dict, u16 dict_len,
+				  const char *text, u16 text_len)
+{
+	__log_store(facility, level, flags, ts_nsec, dict, dict_len,
+		    text, text_len, cont.owner->tgid, cont.irq_count);
+}
+
+static inline void log_store_current(int facility, int level,
+				     enum log_flags flags, u64 ts_nsec,
+				     const char *dict, u16 dict_len,
+				     const char *text, u16 text_len)
+{
+	__log_store(facility, level, flags, ts_nsec, dict, dict_len,
+		    text, text_len, current->tgid, irq_count());
+}
+
 static void cont_flush(enum log_flags flags)
 {
 	if (cont.flushed)
@@ -1410,8 +1447,8 @@ static void cont_flush(enum log_flags flags)
 		 * console; wait for the console to pick up the rest of the
 		 * line. LOG_NOCONS suppresses a duplicated output.
 		 */
-		log_store(cont.facility, cont.level, flags | LOG_NOCONS,
-			  cont.ts_nsec, NULL, 0, cont.buf, cont.len);
+		log_store_cont(cont.facility, cont.level, flags | LOG_NOCONS,
+			       cont.ts_nsec, NULL, 0, cont.buf, cont.len);
 		cont.flags = flags;
 		cont.flushed = true;
 	} else {
@@ -1419,8 +1456,8 @@ static void cont_flush(enum log_flags flags)
 		 * If no fragment of this line ever reached the console,
 		 * just submit it to the store and free the buffer.
 		 */
-		log_store(cont.facility, cont.level, flags, 0,
-			  NULL, 0, cont.buf, cont.len);
+		log_store_cont(cont.facility, cont.level, flags, 0,
+			       NULL, 0, cont.buf, cont.len);
 		cont.len = 0;
 	}
 }
@@ -1441,6 +1478,7 @@ static bool cont_add(int facility, int level, const char *text, size_t len)
 		cont.level = level;
 		cont.owner = current;
 		cont.ts_nsec = local_clock();
+		cont.irq_count = irq_count();
 		cont.flags = 0;
 		cont.cons = 0;
 		cont.flushed = false;
@@ -1532,8 +1570,8 @@ asmlinkage int vprintk_emit(int facility, int level,
 		recursion_bug = 0;
 		printed_len += strlen(recursion_msg);
 		/* emit KERN_CRIT message */
-		log_store(0, 2, LOG_PREFIX|LOG_NEWLINE, 0,
-			  NULL, 0, recursion_msg, printed_len);
+		log_store_current(0, 2, LOG_PREFIX|LOG_NEWLINE, 0,
+				  NULL, 0, recursion_msg, printed_len);
 	}
 
 	/*
@@ -1582,13 +1620,14 @@ asmlinkage int vprintk_emit(int facility, int level,
 		 * Flush the conflicting buffer. An earlier newline was missing,
 		 * or another task also prints continuation lines.
 		 */
-		if (cont.len && (lflags & LOG_PREFIX || cont.owner != current))
+		if (cont.len && (lflags & LOG_PREFIX || cont.owner != current
+				 || cont.irq_count != irq_count()))
 			cont_flush(LOG_NEWLINE);
 
 		/* buffer line if possible, otherwise store it right away */
 		if (!cont_add(facility, level, text, text_len))
-			log_store(facility, level, lflags | LOG_CONT, 0,
-				  dict, dictlen, text, text_len);
+			log_store_current(facility, level, lflags | LOG_CONT, 0,
+					  dict, dictlen, text, text_len);
 	} else {
 		bool stored = false;
 
@@ -1601,15 +1640,17 @@ asmlinkage int vprintk_emit(int facility, int level,
 		 * a newline, flush and append the newline.
 		 */
 		if (cont.len) {
-			if (cont.owner == current && !(lflags & LOG_PREFIX))
+			if ((cont.owner == current &&
+			     cont.irq_count == irq_count())
+			    && !(lflags & LOG_PREFIX))
 				stored = cont_add(facility, level, text,
 						  text_len);
 			cont_flush(LOG_NEWLINE);
 		}
 
 		if (!stored)
-			log_store(facility, level, lflags, 0,
-				  dict, dictlen, text, text_len);
+			log_store_current(facility, level, lflags, 0,
+					  dict, dictlen, text, text_len);
 	}
 	printed_len += text_len;
 

