Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754364AbaESK2u (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 06:28:50 -0400
Received: from mail4.hitachi.co.jp ([133.145.228.5]:38869 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754003AbaESK2p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 06:28:45 -0400
X-AuditID: 85900ec0-d312bb9000001514-16-5379dcd95b01
Subject: [RFC PATCH 2/2] printk: Simplify fragmented line information of the
 header of /dev/kmsg
To: Andrew Morton <akpm@linux-foundation.org>, Kay Sievers <kay@vrfy.org>,
        linux-kernel@vger.kernel.org
From: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
Cc: Kees Cook <keescook@chromium.org>, Randy Dunlap <rdunlap@infradead.org>,
        Petr Mladek <pmladek@suse.cz>,
        Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>,
        yrl.pp-manager.tt@hitachi.com,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Joe Perches <joe@perches.com>, Arun KS <arunks.linux@gmail.com>
Date: Mon, 19 May 2014 19:28:41 +0900
Message-ID: <20140519102841.30455.12481.stgit@yunodevel>
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

Simplify fragmented line information of the 4th flag of the header of /dev/kmsg.

One of the hint of the printk() linebreak is the header information of
/dev/kmsg. 4th flag in the header adds 'c' or '+' when a message is divided.
Users can roughly understand where the printk message was divided, but they
cannot understand exactly which messages are divided or how those messages
should be connected.

According to a comment in printk.c, 'c' is marked for the first fragment of a
line. However, 'c' is not always marked as the first fragment of the line in
current kernel. The kernel outputs the 'c' flag when current message flags has
LOG_CONT and previous message flag does not have LOG_CONT. So, LOG_CONT flag
is needed to add 'c'. However, when the previous message A is being stored in
cont buffer and the current message B is not added to cont buffer, LOG_CONT
flag is added not to the message A but to the message B. In this situation,
'c' flag is added to the message B even though the message A is actually
the first fragmented line. As the result, it seems that the message A is not
divided because the message A is output with '-' (no fragment).

In addition, all following fragments are flagged with '+' according to
Documentation/ABI/testing/dev-kmsg. In kernel, when current message and the
previous message has LOG_CONT flag, '+' flag is added to the current message.
However, if those messages are output in different context and those messages
have LOG_CONT flag, '+' flag is added to the current message but it is
sometimes meaningless. For example, when previous message with LOG_CONT is
output by process C and current message (1st continuous message) with LOG_CONT
is output by process D, adding '+' flag to the current message of process D is
incorrect. This occurs when both return values of both messages without '\n'
are false in cont_add().

This patch simplifies the fragmented line flag policy.
 1) Add 'f' flag if the kernel flushes a fragment message
 2) Delete 'c' and '+'
When fragmentation occurs, the current message flushes the previous message
with LOG_CONT. When the kernel outputs the messages to /dev/kmsg, it
just checks whether messages have LOG_CONT flag or not. If the messages have
LOG_CONT flag, it adds 'f' flag in the header of /dev/kmsg. Then, users can
understand which message was divided by 'f' flag and how these messages
should be connected by checking the fragmented flag and the context information.

<Example>
 - Environment
   Execute 3 kernel threads A, B, and C. Each thread outputs following
  messages:
	/* for {A, B, C} */
	pr_info("{A, B, C}1");
	printk("{A, B, C}2");
	printk("{A, B, C}3\n");

 - Current result of /dev/kmsg
	6,225186,93838029,-,2288/-;B1    <== No fragment?
	6,225187,93838091,c,2289/-;C1
	4,225188,93838092,+,2289/-;C2
	4,225189,93838092,+,2289/-;C3
	6,225190,93842059,c,2289/-;C1
	4,225191,93842409,+,2289/-;C2C3
	4,225192,93842713,-,2288/-;B2    <== No fragment?
	6,225193,93842944,c,2287/-;A1
	4,225194,93842944,+,2287/-;A2
	4,225195,93842945,+,2287/-;A3
	4,225196,93846199,-,2288/-;B3    <== No fragment?
   In this example, fragmented flags of the B thread are incorrect because
   B1, B2, and B3 are actually divided, but there are no flags. So, users cannot
   understand which messages are divided or how those messages should be
   connected in current implementation.

 - Apply this patch
   This patch introduces 'f' flag policy and deletes 'c' and '+' flags. If a
   message is forcibly flushed in the middle, just add 'f'. Moreover, if a
   message includes '\n' meaning the end of the messages, add no fragment flag
   ('-'). So, if users find 'f' flag for a message, they can connect the
   message to next 'f' flag (forcibly flushed) or '-' (the end of the messages)
   in same context.

	6,8219,543073110,f,538/-;B1    <== This message is fragmented.
	6,8220,543073113,f,539/-;C1
	4,8221,543073115,f,539/-;C2
	4,8222,543073116,-,539/-;C3
	4,8223,543073117,f,538/-;B2    <== Stil fragmented
	6,8224,543073120,f,537/-;A1
	4,8225,543073120,-,538/-;B3    <== This is the end of the messages.
	4,8226,543073123,-,537/-;A2A3

   A message merging tool can convert these messages as follows:

	6,8219,543073110,-,538/-;B1B2B3
	6,8220,543073113,-,539/-;C1C2C3
	6,8224,543073120,-,537/-;A1A2A3

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
 Documentation/ABI/testing/dev-kmsg |   15 +++++++--------
 kernel/printk/printk.c             |   31 +++++++++++++++----------------
 2 files changed, 22 insertions(+), 24 deletions(-)

diff --git a/Documentation/ABI/testing/dev-kmsg b/Documentation/ABI/testing/dev-kmsg
index d8128ac..ccb7cf3 100644
--- a/Documentation/ABI/testing/dev-kmsg
+++ b/Documentation/ABI/testing/dev-kmsg
@@ -89,14 +89,13 @@ Description:	The /dev/kmsg character device node provides userspace access
 		  n8           - netdev ifindex
 		  +sound:card0 - subsystem:devname
 
-		The 4th flags field carries '-' by default. A 'c' indicates a
-		fragment of a line. All following fragments are flagged with
-		'+'. Note, that these hints about continuation lines are not
-		necessarily correct, and the stream could be interleaved with
-		unrelated messages, but merging the lines in the output
-		usually produces better human readable results. A similar
-		logic is used internally when messages are printed to the
-		console, /proc/kmsg or the syslog() syscall.
+		The 4th flags field carries '-' by default. A 'f' indicates a
+		fragment of a line. If a message is forcibly flushed in the
+		middle, just add 'f'. Moreover, if a message includes '\n'
+		meaning the end of the messages, no add flag ('-'). So, if
+		users find 'f' flag for a message, they can connect the message
+		to next 'f' flag (forcibly flushed) or '-' (the end of the
+		messages) in same context information output in the 5th field.
 
 		The 5th field is context information to separate mixed messages
 		from different contexts. The field indicates PID and interrupt
diff --git a/kernel/printk/printk.c b/kernel/printk/printk.c
index 8105431..d8c3716 100644
--- a/kernel/printk/printk.c
+++ b/kernel/printk/printk.c
@@ -414,7 +414,6 @@ static int check_syslog_permissions(int type, bool from_file)
 struct devkmsg_user {
 	u64 seq;
 	u32 idx;
-	enum log_flags prev;
 	struct mutex lock;
 	char buf[8192];
 };
@@ -535,23 +534,16 @@ static ssize_t devkmsg_read(struct file *file, char __user *buf,
 
 	/*
 	 * If we couldn't merge continuation line fragments during the print,
-	 * export the stored flags to allow an optional external merge of the
-	 * records. Merging the records isn't always neccessarily correct, like
-	 * when we hit a race during printing. In most cases though, it produces
-	 * better readable output. 'c' in the record flags mark the first
-	 * fragment of a line, '+' the following.
+	 * export the stored flags 'f' to allow an optional external merge of
+	 * the records.
 	 */
-	if (msg->flags & LOG_CONT && !(user->prev & LOG_CONT))
-		cont = 'c';
-	else if ((msg->flags & LOG_CONT) ||
-		 ((user->prev & LOG_CONT) && !(msg->flags & LOG_PREFIX)))
-		cont = '+';
+	if (msg->flags & LOG_CONT)
+		cont = 'f';
 
 	len = sprintf(user->buf, "%u,%llu,%llu,%c,%d/%c;",
 		      (msg->facility << 3) | msg->level,
 		      user->seq, ts_usec, cont, msg->pid,
 		      show_irq_count_flag(msg->irq_count));
-	user->prev = msg->flags;
 
 	/* escape non-printable characters */
 	for (i = 0; i < msg->text_len; i++) {
@@ -1620,9 +1612,13 @@ asmlinkage int vprintk_emit(int facility, int level,
 		 * Flush the conflicting buffer. An earlier newline was missing,
 		 * or another task also prints continuation lines.
 		 */
-		if (cont.len && (lflags & LOG_PREFIX || cont.owner != current
-				 || cont.irq_count != irq_count()))
-			cont_flush(LOG_NEWLINE);
+		if (cont.len) {
+			if (cont.owner != current ||
+			    cont.irq_count != irq_count())
+				cont_flush(LOG_CONT);
+			else if (lflags & LOG_PREFIX)
+				cont_flush(LOG_NEWLINE);
+		}
 
 		/* buffer line if possible, otherwise store it right away */
 		if (!cont_add(facility, level, text, text_len))
@@ -1645,7 +1641,10 @@ asmlinkage int vprintk_emit(int facility, int level,
 			    && !(lflags & LOG_PREFIX))
 				stored = cont_add(facility, level, text,
 						  text_len);
-			cont_flush(LOG_NEWLINE);
+			if (!stored)
+				cont_flush(LOG_CONT);
+			else
+				cont_flush(LOG_NEWLINE);
 		}
 
 		if (!stored)

