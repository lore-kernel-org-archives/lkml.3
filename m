Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754802AbaGVOCY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 10:02:24 -0400
Received: from mail-ie0-f179.google.com ([209.85.223.179]:41653 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751751AbaGVOBy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 10:01:54 -0400
From: Alex Elder <elder@linaro.org>
To: akpm@linux-foundation.org
Cc: kay@vrfy.org, pmladek@suse.cz, bp@suse.de, john.stultz@linaro.org,
        jack@suse.cz, linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/2] printk: kill LOG_CONT
Date: Tue, 22 Jul 2014 09:01:56 -0500
Message-Id: <1406037717-9670-2-git-send-email-elder@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1406037717-9670-1-git-send-email-elder@linaro.org>
References: <1406037717-9670-1-git-send-email-elder@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The LOG_CONT and LOG_NEWLINE flags are mutually exclusive, i.e.,
the presence of LOG_NEWLINE implies the absense of LOG_CONT, and
vice-versa.  As a result, wherever LOG_CONT is used, we can
equivalently substitute !LOG_NEWLINE; and we can use LOG_NEWLINE
wherever !LOG_CONT is used.

Switch to using LOG_NEWLINE only, and get rid of LOG_CONT.  Make
some refinements on a nearby block of comments.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 kernel/printk/printk.c | 42 +++++++++++++++++++++---------------------
 1 file changed, 21 insertions(+), 21 deletions(-)

diff --git a/kernel/printk/printk.c b/kernel/printk/printk.c
index 6848e7d..49c9238 100644
--- a/kernel/printk/printk.c
+++ b/kernel/printk/printk.c
@@ -211,7 +211,6 @@ enum log_flags {
 	LOG_NOCONS	= 1,	/* already flushed, do not print to console */
 	LOG_NEWLINE	= 2,	/* text ended with a newline */
 	LOG_PREFIX	= 4,	/* text started with a prefix */
-	LOG_CONT	= 8,	/* text is a fragment of a continuation line */
 };
 
 struct printk_log {
@@ -613,22 +612,25 @@ static ssize_t devkmsg_read(struct file *file, char __user *buf,
 	do_div(ts_usec, 1000);
 
 	/*
-	 * If we couldn't merge continuation line fragments during the print,
-	 * export the stored flags to allow an optional external merge of the
-	 * records. Merging the records isn't always necessarily correct, like
-	 * when we hit a race during printing. In most cases though, it produces
-	 * better readable output. 'c' in the record flags mark the first
-	 * fragment of a line, '+' the following.
+	 * Sometimes it's necessary to flush an incomplete record to the log.
+	 * When this happens, consecutive records should be merged to produce
+	 * a logically complete message.
+	 *
+	 * Indicate this to user space with a flag character.  A 'c' indicates
+	 * the first of a series of incomplete log records.  A '+' indicates
+	 * a record that should be merged with one or more earlier records.
+	 * And a '-' indicates a "normal" self-contained single record.
 	 */
-	if ((user->prev & LOG_CONT) && !(msg->flags & LOG_PREFIX))
+	if (!(user->prev & LOG_NEWLINE) && !(msg->flags & LOG_PREFIX))
 		cont = '+';
-	else if (msg->flags & LOG_CONT)
+	else if (!(msg->flags & LOG_NEWLINE))
 		cont = 'c';
 	else
 		cont = '-';
 
 	/* Insert a newline if the previous line was not terminated properly */
-	insert_newline = (user->prev & LOG_CONT) && (msg->flags & LOG_PREFIX);
+	insert_newline = !(user->prev & LOG_NEWLINE) &&
+			    (msg->flags & LOG_PREFIX);
 	len = sprintf(user->buf, "%s%u,%llu,%llu,%c;",
 		      insert_newline ? "\n" : "",
 		      (msg->facility << 3) | msg->level,
@@ -1007,13 +1009,13 @@ static size_t msg_print_text(const struct printk_log *msg, enum log_flags prev,
 	bool newline = true;
 	size_t len = 0;
 
-	if ((prev & LOG_CONT) && !(msg->flags & LOG_PREFIX))
+	if (!(prev & LOG_NEWLINE) && !(msg->flags & LOG_PREFIX))
 		prefix = false;
 
-	if (msg->flags & LOG_CONT)
+	if (!(msg->flags & LOG_NEWLINE))
 		newline = false;
 
-	if ((prev & LOG_CONT) && (msg->flags & LOG_PREFIX) && len < size) {
+	if (!(prev & LOG_NEWLINE) && (msg->flags & LOG_PREFIX) && len < size) {
 		if (buf)
 			buf[len++] = '\n';
 		else
@@ -1081,7 +1083,7 @@ static int syslog_print(char __user *buf, int size)
 			 */
 			syslog_seq = log_first_seq;
 			syslog_idx = log_first_idx;
-			syslog_prev &= LOG_NEWLINE|LOG_CONT;
+			syslog_prev &= LOG_NEWLINE;
 			syslog_partial = 0;
 		}
 		if (syslog_seq == log_next_seq) {
@@ -1210,7 +1212,7 @@ static int syslog_print_all(char __user *buf, int size, bool clear)
 				 */
 				seq = log_first_seq;
 				idx = log_first_idx;
-				prev &= LOG_NEWLINE|LOG_CONT;
+				prev &= LOG_NEWLINE;
 			}
 		}
 	}
@@ -1319,7 +1321,7 @@ int do_syslog(int type, char __user *buf, int len, bool from_file)
 			 */
 			syslog_seq = log_first_seq;
 			syslog_idx = log_first_idx;
-			syslog_prev &= LOG_NEWLINE|LOG_CONT;
+			syslog_prev &= LOG_NEWLINE;
 			syslog_partial = 0;
 		}
 		if (from_file) {
@@ -1534,7 +1536,7 @@ static bool cont_add(int facility, int level, const char *text, size_t len)
 
 	if (cont.len + len > sizeof(cont.buf)) {
 		/* the line gets too long, split it up in separate records */
-		cont_flush(LOG_CONT);
+		cont_flush(0);
 		return false;
 	}
 
@@ -1552,7 +1554,7 @@ static bool cont_add(int facility, int level, const char *text, size_t len)
 	cont.len += len;
 
 	if (cont.len > (sizeof(cont.buf) * 80) / 100)
-		cont_flush(LOG_CONT);
+		cont_flush(0);
 
 	return true;
 }
@@ -1665,8 +1667,6 @@ asmlinkage int vprintk_emit(int facility, int level,
 	if (text_len && text[text_len-1] == '\n') {
 		text_len--;
 		lflags = LOG_NEWLINE;
-	} else {
-		lflags = LOG_CONT;
 	}
 
 	/* strip kernel syslog prefix and extract log level or control flags */
@@ -2167,7 +2167,7 @@ again:
 		if (console_seq < log_first_seq) {
 			len = sprintf(text,
 				      "%s** %u printk messages dropped **\n",
-				      (console_prev & LOG_CONT) ? "\n" : "",
+				      (console_prev & LOG_NEWLINE) ? "" : "\n",
 				      (unsigned)(log_first_seq - console_seq));
 			/* Messages are gone, move to first one. */
 			console_seq = log_first_seq;
-- 
1.9.1

