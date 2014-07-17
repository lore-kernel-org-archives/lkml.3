Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752380AbaGQR7T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 13:59:19 -0400
Received: from mail-ig0-f179.google.com ([209.85.213.179]:43875 "EHLO
	mail-ig0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752050AbaGQR7R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 13:59:17 -0400
From: Alex Elder <elder@linaro.org>
To: akpm@linux-foundation.org
Cc: kay@vrfy.org, pmladek@suse.cz, bp@suse.de, john.stultz@linaro.org,
        jack@suse.cz, linux-kernel@vger.kernel.org
Subject: [PATCH 1/5] printk: kill LOG_CONT
Date: Thu, 17 Jul 2014 12:59:09 -0500
Message-Id: <1405619953-5475-2-git-send-email-elder@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1405619953-5475-1-git-send-email-elder@linaro.org>
References: <1405619953-5475-1-git-send-email-elder@linaro.org>
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
 kernel/printk/printk.c | 29 ++++++++++++++---------------
 1 file changed, 14 insertions(+), 15 deletions(-)

diff --git a/kernel/printk/printk.c b/kernel/printk/printk.c
index eff68a4..e35d91a 100644
--- a/kernel/printk/printk.c
+++ b/kernel/printk/printk.c
@@ -211,7 +211,6 @@ enum log_flags {
 	LOG_NOCONS	= 1,	/* already flushed, do not print to console */
 	LOG_NEWLINE	= 2,	/* text ended with a newline */
 	LOG_PREFIX	= 4,	/* text started with a prefix */
-	LOG_CONT	= 8,	/* text is a fragment of a continuation line */
 };
 
 struct printk_log {
@@ -613,16 +612,18 @@ static ssize_t devkmsg_read(struct file *file, char __user *buf,
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
@@ -1007,10 +1008,10 @@ static size_t msg_print_text(const struct printk_log *msg, enum log_flags prev,
 	bool newline = true;
 	size_t len = 0;
 
-	if ((prev & LOG_CONT) && !(msg->flags & LOG_PREFIX))
+	if (!(prev & LOG_NEWLINE) && !(msg->flags & LOG_PREFIX))
 		prefix = false;
 
-	if (msg->flags & LOG_CONT)
+	if (!(msg->flags & LOG_NEWLINE))
 		newline = false;
 
 	do {
@@ -1516,7 +1517,7 @@ static bool cont_add(int facility, int level, const char *text, size_t len)
 
 	if (cont.len + len > sizeof(cont.buf)) {
 		/* the line gets too long, split it up in separate records */
-		cont_flush(LOG_CONT);
+		cont_flush(0);
 		return false;
 	}
 
@@ -1534,7 +1535,7 @@ static bool cont_add(int facility, int level, const char *text, size_t len)
 	cont.len += len;
 
 	if (cont.len > (sizeof(cont.buf) * 80) / 100)
-		cont_flush(LOG_CONT);
+		cont_flush(0);
 
 	return true;
 }
@@ -1647,8 +1648,6 @@ asmlinkage int vprintk_emit(int facility, int level,
 	if (text_len && text[text_len-1] == '\n') {
 		text_len--;
 		lflags = LOG_NEWLINE;
-	} else {
-		lflags = LOG_CONT;
 	}
 
 	/* strip kernel syslog prefix and extract log level or control flags */
-- 
1.9.1

