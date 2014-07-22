Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754696AbaGVOB5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 10:01:57 -0400
Received: from mail-ie0-f173.google.com ([209.85.223.173]:64336 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750893AbaGVOBz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 10:01:55 -0400
From: Alex Elder <elder@linaro.org>
To: akpm@linux-foundation.org
Cc: kay@vrfy.org, pmladek@suse.cz, bp@suse.de, john.stultz@linaro.org,
        jack@suse.cz, linux-kernel@vger.kernel.org
Subject: [PATCH v2 2/2] printk: improve some commentary; tidy up
Date: Tue, 22 Jul 2014 09:01:57 -0500
Message-Id: <1406037717-9670-3-git-send-email-elder@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1406037717-9670-1-git-send-email-elder@linaro.org>
References: <1406037717-9670-1-git-send-email-elder@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add some comments to explain how the log flags are used to control
how records get formatted.  Also add and refine some comments in
vprintk_emit().

Now that we're done fixing up log record flags, simplify how they're
used in computing some local variable values in msg_print_text().

Use a local variable "flush_cont" in vprintk_emit() to factor out a
common expression used later in that function.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 kernel/printk/printk.c | 63 ++++++++++++++++++++++++++++++++------------------
 1 file changed, 41 insertions(+), 22 deletions(-)

diff --git a/kernel/printk/printk.c b/kernel/printk/printk.c
index 49c9238..cecdc1b 100644
--- a/kernel/printk/printk.c
+++ b/kernel/printk/printk.c
@@ -141,6 +141,12 @@ EXPORT_SYMBOL(console_set_on_cmdline);
 static int console_may_schedule;
 
 /*
+ * Each call to printk() fills a record in a circular log buffer.
+ * The contents of the log buffer are read by various subsystems
+ * (including the console subsystem), each of which formats the
+ * content of log buffers for human consumption.  Flags in each
+ * log record are used to track formatting-related state.
+ *
  * The printk log buffer consists of a chain of concatenated variable
  * length records. Every record starts with a record header, containing
  * the overall length of the record.
@@ -150,7 +156,7 @@ static int console_may_schedule;
  * are stored..
  *
  * If the heads indicate available messages, the length in the header
- * tells the start next message. A length == 0 for the next message
+ * tells the start of the next message. A length == 0 for the next message
  * indicates a wrap-around to the beginning of the buffer.
  *
  * Every record carries the monotonic timestamp in microseconds, as well as
@@ -192,6 +198,16 @@ static int console_may_schedule;
  *         67                           "g"
  *   0032     00 00 00                  padding to next message header
  *
+ * If a printk() call contains no newline, its content is saved in a
+ * special "cont" buffer rather than being written directly into the
+ * log.  One or more follow-in printk() calls from the same source
+ * can then be combined into a single newline-terminated message (if
+ * possible) before the combined result is saved into a log record.
+ * Occasionally a buffered/partial message needs to be flushed to
+ * the log before the logically next printk() call is seen.  When
+ * this occurs, the incomplete record (with no LOG_NEWLINE) will
+ * be followed by a new record marked LOG_PREFIX.
+ *
  * The 'struct printk_log' buffer header must never be directly exported to
  * userspace, it is a kernel-private implementation detail that might
  * need to be changed in the future, when the requirements change.
@@ -1005,17 +1021,14 @@ static size_t msg_print_text(const struct printk_log *msg, enum log_flags prev,
 {
 	const char *text = log_text(msg);
 	size_t text_size = msg->text_len;
-	bool prefix = true;
-	bool newline = true;
 	size_t len = 0;
+	bool prefix;
+	bool newline;
 
-	if (!(prev & LOG_NEWLINE) && !(msg->flags & LOG_PREFIX))
-		prefix = false;
-
-	if (!(msg->flags & LOG_NEWLINE))
-		newline = false;
-
-	if (!(prev & LOG_NEWLINE) && (msg->flags & LOG_PREFIX) && len < size) {
+	prefix = (prev & LOG_NEWLINE) || (msg->flags & LOG_PREFIX);
+	newline = !!(msg->flags & LOG_NEWLINE);
+	/* Insert a newline if we're terminating the previous line early */
+	if (prefix && !(prev & LOG_NEWLINE) && len < size) {
 		if (buf)
 			buf[len++] = '\n';
 		else
@@ -1600,6 +1613,7 @@ asmlinkage int vprintk_emit(int facility, int level,
 	int this_cpu;
 	int printed_len = 0;
 	bool in_sched = false;
+	bool flush_cont = false;
 	/* cpu currently holding logbuf_lock in this function */
 	static volatile unsigned int logbuf_cpu = UINT_MAX;
 
@@ -1698,12 +1712,16 @@ asmlinkage int vprintk_emit(int facility, int level,
 	if (dict)
 		lflags = LOG_PREFIX|LOG_NEWLINE;
 
+	/*
+	 * If the previous printk() call had no newline, it will be buffered.
+	 * If the buffered message was produced by someone else, or if this
+	 * call is forcing a new record, we will need to flush the buffer
+	 * rather than merge this message into it.
+	 */
+	flush_cont = (cont.owner != current) || (lflags & LOG_PREFIX);
 	if (!(lflags & LOG_NEWLINE)) {
-		/*
-		 * Flush the conflicting buffer. An earlier newline was missing,
-		 * or another task also prints continuation lines.
-		 */
-		if (cont.len && (lflags & LOG_PREFIX || cont.owner != current))
+		/* If the buffered record conflicts, flush it first. */
+		if (cont.len && flush_cont)
 			cont_flush(LOG_NEWLINE);
 
 		/* buffer line if possible, otherwise store it right away */
@@ -1716,20 +1734,21 @@ asmlinkage int vprintk_emit(int facility, int level,
 		bool stored = false;
 
 		/*
-		 * If an earlier newline was missing and it was the same task,
-		 * either merge it with the current buffer and flush, or if
-		 * there was a race with interrupts (prefix == true) then just
-		 * flush it out and store this line separately.
-		 * If the preceding printk was from a different task and missed
-		 * a newline, flush and append the newline.
+		 * If there's a buffered message, try to merge with
+		 * it, then flush whatever's buffered to the log.
 		 */
 		if (cont.len) {
-			if (cont.owner == current && !(lflags & LOG_PREFIX))
+			if (!flush_cont)
 				stored = cont_add(facility, level, text,
 						  text_len);
 			cont_flush(LOG_NEWLINE);
 		}
 
+		/*
+		 * Record how much we just formatted.  If cont_add() didn't
+		 * combine this message with the buffered one we still have
+		 * to store this one to the log.
+		 */
 		if (stored)
 			printed_len += text_len;
 		else
-- 
1.9.1

