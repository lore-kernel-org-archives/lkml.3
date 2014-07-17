Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752583AbaGQR7Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 13:59:24 -0400
Received: from mail-ig0-f181.google.com ([209.85.213.181]:50340 "EHLO
	mail-ig0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752417AbaGQR7V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 13:59:21 -0400
From: Alex Elder <elder@linaro.org>
To: akpm@linux-foundation.org
Cc: kay@vrfy.org, pmladek@suse.cz, bp@suse.de, john.stultz@linaro.org,
        jack@suse.cz, linux-kernel@vger.kernel.org
Subject: [PATCH 5/5] printk: rename LOG_NEWLINE and tidy up
Date: Thu, 17 Jul 2014 12:59:13 -0500
Message-Id: <1405619953-5475-6-git-send-email-elder@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1405619953-5475-1-git-send-email-elder@linaro.org>
References: <1405619953-5475-1-git-send-email-elder@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rename LOG_NEWLINE to be LOG_COMPLETE, so it makes more sense in the
context of a log record (or a string of them) rather than how a
record gets formatted.

Add a block of commentary explaining how the log flags indicate that
consecutive log records should be treated as a single logical log
entry.

Do some other tidying of the code now that a lot of the former flags
complexity has been eliminated.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 kernel/printk/printk.c | 73 +++++++++++++++++++++++++++++---------------------
 1 file changed, 42 insertions(+), 31 deletions(-)

diff --git a/kernel/printk/printk.c b/kernel/printk/printk.c
index bfc2581..69bfd39 100644
--- a/kernel/printk/printk.c
+++ b/kernel/printk/printk.c
@@ -150,7 +150,7 @@ static int console_may_schedule;
  * are stored..
  *
  * If the heads indicate available messages, the length in the header
- * tells the start next message. A length == 0 for the next message
+ * tells the start of the next message. A length == 0 for the next message
  * indicates a wrap-around to the beginning of the buffer.
  *
  * Every record carries the monotonic timestamp in microseconds, as well as
@@ -159,6 +159,17 @@ static int console_may_schedule;
  * a matching syslog facility, by default LOG_USER. The origin of every
  * message can be reliably determined that way.
  *
+ * If a printk() call doesn't end in a newline, the content of the message
+ * is buffered temporarily so that a subsequent printk() call can be
+ * appended to it.  Occasionally a buffered/partial message needs to be
+ * flushed to the log before the logically next printk() call is seen.
+ * This is distinguished in log records by the presence (or absence) of a
+ * LOG_COMPLETE flag.  In this case the last log record comprising a
+ * the original message has LOG_COMPLETE set; the rest do not.  When
+ * formatted, a log record will include a prefix (including a time stamp
+ * and possibly a syslog value) whenever its predecessor in the log was
+ * marked LOG_COMPLETE.
+ *
  * The human readable log message directly follows the message header. The
  * length of the message text is stored in the header, the stored message
  * is not terminated.
@@ -209,7 +220,7 @@ static int console_may_schedule;
 
 enum log_flags {
 	LOG_NOCONS	= 1,	/* already flushed, do not print to console */
-	LOG_NEWLINE	= 2,	/* text ended with a newline */
+	LOG_COMPLETE	= 2,	/* this record ends a log entry */
 };
 
 struct printk_log {
@@ -432,7 +443,7 @@ static int log_store(int facility, int level, bool force_new,
 	 * the previous one to mark it complete.
 	 */
 	if (force_new && log_last_msg)
-		log_last_msg->flags |= LOG_NEWLINE;
+		log_last_msg->flags |= LOG_COMPLETE;
 
 	msg = (struct printk_log *)(log_buf + log_next_idx);
 	memcpy(log_text(msg), text, text_len);
@@ -632,9 +643,9 @@ static ssize_t devkmsg_read(struct file *file, char __user *buf,
 	 * a record that should be merged with one or more earlier records.
 	 * And a '-' indicates a "normal" self-contained single record.
 	 */
-	if (!(user->prev & LOG_NEWLINE))
+	if (!(user->prev & LOG_COMPLETE))
 		cont = '+';
-	else if (!(msg->flags & LOG_NEWLINE))
+	else if (!(msg->flags & LOG_COMPLETE))
 		cont = 'c';
 	else
 		cont = '-';
@@ -1015,15 +1026,9 @@ static size_t msg_print_text(const struct printk_log *msg, enum log_flags prev,
 {
 	const char *text = log_text(msg);
 	size_t text_size = msg->text_len;
-	bool prefix = true;
-	bool newline = true;
 	size_t len = 0;
-
-	if (!(prev & LOG_NEWLINE))
-		prefix = false;
-
-	if (!(msg->flags & LOG_NEWLINE))
-		newline = false;
+	bool prefix = !!(prev & LOG_COMPLETE);
+	bool newline = !!(msg->flags & LOG_COMPLETE);
 
 	do {
 		const char *next = memchr(text, '\n', text_size);
@@ -1556,7 +1561,8 @@ static size_t cont_print_text(char *text, size_t size)
 	size_t textlen = 0;
 	size_t len;
 
-	if (cont.cons == 0 && (console_prev & LOG_NEWLINE)) {
+	/* If we're starting a new one, format a time stamp */
+	if (cont.cons == 0 && console_prev & LOG_COMPLETE) {
 		textlen += print_time(cont.ts_nsec, text);
 		size -= textlen;
 	}
@@ -1571,7 +1577,7 @@ static size_t cont_print_text(char *text, size_t size)
 	}
 
 	if (cont.flushed) {
-		if (cont.flags & LOG_NEWLINE)
+		if (cont.flags & LOG_COMPLETE)
 			text[textlen++] = '\n';
 		/* got everything, release buffer */
 		cont.len = 0;
@@ -1637,7 +1643,7 @@ asmlinkage int vprintk_emit(int facility, int level,
 		recursion_bug = 0;
 		text_len = strlen(recursion_msg);
 		/* emit KERN_CRIT message */
-		printed_len += log_store(0, 2, true, LOG_NEWLINE, 0,
+		printed_len += log_store(0, 2, true, LOG_COMPLETE, 0,
 					 NULL, 0, recursion_msg, text_len);
 	}
 
@@ -1659,7 +1665,7 @@ asmlinkage int vprintk_emit(int facility, int level,
 	 */
 	if (text_len && text[text_len-1] == '\n') {
 		text_len--;
-		lflags = LOG_NEWLINE;
+		lflags = LOG_COMPLETE;
 	}
 
 	/* strip kernel syslog prefix and extract log level or control flags */
@@ -1690,17 +1696,23 @@ asmlinkage int vprintk_emit(int facility, int level,
 
 	if (dict) {
 		force_new = true;
-		lflags = LOG_NEWLINE;
+		lflags = LOG_COMPLETE;
 	}
 
-	if (!(lflags & LOG_NEWLINE)) {
+	/*
+	 * If there's a partial record buffered by someone else
+	 * we'll want to force a new entry to be started.
+	 */
+	if (cont.len)
+		force_new |= cont.owner != current;
+	if (!(lflags & LOG_COMPLETE)) {
 		/*
 		 * We're recording an incomplete record.  We'll add it to the
-		 * "cont" buffer if possible, but if it contains data written
-		 * by somebody else we need to flush that to the log first.
+		 * "cont" buffer if possible, but if we're forcing a new
+		 * entry we need to flush the buffer to the log first.
 		 */
-		if (cont.len && (force_new || cont.owner != current))
-			cont_flush(LOG_NEWLINE);
+		if (cont.len && force_new)
+			cont_flush(LOG_COMPLETE);
 
 		/* If we're unable to buffer it, store it immediately */
 		if (cont_add(facility, level, text, text_len))
@@ -1713,18 +1725,17 @@ asmlinkage int vprintk_emit(int facility, int level,
 		bool stored = false;
 
 		/*
-		 * This record is complete (it should be formatted with a
-		 * newline), so we'll be writing it to the log.  If there
-		 * are any incomplete records buffered we will need to
-		 * flush those to the log first.  If possible, we'll add
-		 * this record to the buffer first.  If there's nothing
-		 * buffered, just write this record to the log.
+		 * This record is complete, so we'll be writing it to the log.
+		 * If there are any incomplete records buffered we'll try to
+		 * add this record to the buffer before flushing it to the log.
+		 * Otherwise if there's nothing buffered, just write this
+		 * record to the log directly.
 		 */
 		if (cont.len) {
-			if (cont.owner == current && !force_new)
+			if (!force_new)
 				stored = cont_add(facility, level, text,
 						  text_len);
-			cont_flush(LOG_NEWLINE);
+			cont_flush(LOG_COMPLETE);
 		}
 
 		if (stored)
-- 
1.9.1

