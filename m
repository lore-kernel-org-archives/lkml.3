Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752769AbaGQSAA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 14:00:00 -0400
Received: from mail-ig0-f170.google.com ([209.85.213.170]:60290 "EHLO
	mail-ig0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752386AbaGQR7U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 13:59:20 -0400
From: Alex Elder <elder@linaro.org>
To: akpm@linux-foundation.org
Cc: kay@vrfy.org, pmladek@suse.cz, bp@suse.de, john.stultz@linaro.org,
        jack@suse.cz, linux-kernel@vger.kernel.org
Subject: [PATCH 4/5] printk: kill LOG_PREFIX
Date: Thu, 17 Jul 2014 12:59:12 -0500
Message-Id: <1405619953-5475-5-git-send-email-elder@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1405619953-5475-1-git-send-email-elder@linaro.org>
References: <1405619953-5475-1-git-send-email-elder@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The only place that uses LOG_PREFIX is log_store(), and that
now strips it from the flags field before recording it in a log
buffer.

Switch to passing a Boolean flag to log_store() to indicate whether
this record should force a new record--that is, complete the
previous one--and eliminate the LOG_PREFIX flag altogether.  Update
a few comments as well.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 kernel/printk/printk.c | 60 ++++++++++++++++++++++++++------------------------
 1 file changed, 31 insertions(+), 29 deletions(-)

diff --git a/kernel/printk/printk.c b/kernel/printk/printk.c
index df38b5e..bfc2581 100644
--- a/kernel/printk/printk.c
+++ b/kernel/printk/printk.c
@@ -210,7 +210,6 @@ static int console_may_schedule;
 enum log_flags {
 	LOG_NOCONS	= 1,	/* already flushed, do not print to console */
 	LOG_NEWLINE	= 2,	/* text ended with a newline */
-	LOG_PREFIX	= 4,	/* text started with a prefix */
 };
 
 struct printk_log {
@@ -397,7 +396,7 @@ static u32 truncate_msg(u16 *text_len, u16 *trunc_msg_len,
 }
 
 /* insert record into the buffer, discard old ones, update heads */
-static int log_store(int facility, int level,
+static int log_store(int facility, int level, bool force_new,
 		     enum log_flags flags, u64 ts_nsec,
 		     const char *dict, u16 dict_len,
 		     const char *text, u16 text_len)
@@ -432,11 +431,8 @@ static int log_store(int facility, int level,
 	 * If we're forcing a new log record, update the flags for
 	 * the previous one to mark it complete.
 	 */
-	if (flags & LOG_PREFIX) {
-		if (log_last_msg)
-			log_last_msg->flags |= LOG_NEWLINE;
-		flags &= ~LOG_PREFIX;
-	}
+	if (force_new && log_last_msg)
+		log_last_msg->flags |= LOG_NEWLINE;
 
 	msg = (struct printk_log *)(log_buf + log_next_idx);
 	memcpy(log_text(msg), text, text_len);
@@ -1493,7 +1489,7 @@ static struct cont {
 	u64 ts_nsec;			/* time of first print */
 	u8 level;			/* log level of first message */
 	u8 facility;			/* log level of first message */
-	enum log_flags flags;		/* prefix, newline flags */
+	enum log_flags flags;		/* nocons, newline flags */
 	bool flushed:1;			/* buffer sealed and committed */
 } cont;
 
@@ -1510,7 +1506,7 @@ static void cont_flush(enum log_flags flags)
 		 * console; wait for the console to pick up the rest of the
 		 * line. LOG_NOCONS suppresses a duplicated output.
 		 */
-		log_store(cont.facility, cont.level, flags | LOG_NOCONS,
+		log_store(cont.facility, cont.level, false, flags | LOG_NOCONS,
 			  cont.ts_nsec, NULL, 0, cont.buf, cont.len);
 		cont.flags = flags;
 		cont.flushed = true;
@@ -1519,7 +1515,7 @@ static void cont_flush(enum log_flags flags)
 		 * If no fragment of this line ever reached the console,
 		 * just submit it to the store and free the buffer.
 		 */
-		log_store(cont.facility, cont.level, flags, 0,
+		log_store(cont.facility, cont.level, false, flags, 0,
 			  NULL, 0, cont.buf, cont.len);
 		cont.len = 0;
 	}
@@ -1596,6 +1592,7 @@ asmlinkage int vprintk_emit(int facility, int level,
 	int this_cpu;
 	int printed_len = 0;
 	bool in_sched = false;
+	bool force_new = false;
 	/* cpu currently holding logbuf_lock in this function */
 	static volatile unsigned int logbuf_cpu = UINT_MAX;
 
@@ -1640,7 +1637,7 @@ asmlinkage int vprintk_emit(int facility, int level,
 		recursion_bug = 0;
 		text_len = strlen(recursion_msg);
 		/* emit KERN_CRIT message */
-		printed_len += log_store(0, 2, LOG_PREFIX|LOG_NEWLINE, 0,
+		printed_len += log_store(0, 2, true, LOG_NEWLINE, 0,
 					 NULL, 0, recursion_msg, text_len);
 	}
 
@@ -1676,7 +1673,7 @@ asmlinkage int vprintk_emit(int facility, int level,
 				if (level == -1)
 					level = kern_level - '0';
 			case 'd':	/* KERN_DEFAULT */
-				lflags |= LOG_PREFIX;
+				force_new = true;
 			}
 			/*
 			 * No need to check length here because vscnprintf
@@ -1691,36 +1688,40 @@ asmlinkage int vprintk_emit(int facility, int level,
 	if (level == -1)
 		level = default_message_loglevel;
 
-	if (dict)
-		lflags = LOG_PREFIX|LOG_NEWLINE;
+	if (dict) {
+		force_new = true;
+		lflags = LOG_NEWLINE;
+	}
 
 	if (!(lflags & LOG_NEWLINE)) {
 		/*
-		 * Flush the conflicting buffer. An earlier newline was missing,
-		 * or another task also prints continuation lines.
+		 * We're recording an incomplete record.  We'll add it to the
+		 * "cont" buffer if possible, but if it contains data written
+		 * by somebody else we need to flush that to the log first.
 		 */
-		if (cont.len && (lflags & LOG_PREFIX || cont.owner != current))
+		if (cont.len && (force_new || cont.owner != current))
 			cont_flush(LOG_NEWLINE);
 
-		/* buffer line if possible, otherwise store it right away */
+		/* If we're unable to buffer it, store it immediately */
 		if (cont_add(facility, level, text, text_len))
 			printed_len += text_len;
 		else
-			printed_len += log_store(facility, level, lflags, 0,
-						 NULL, 0, text, text_len);
+			printed_len += log_store(facility, level, force_new,
+						lflags, 0, NULL, 0,
+						text, text_len);
 	} else {
 		bool stored = false;
 
 		/*
-		 * If an earlier newline was missing and it was the same task,
-		 * either merge it with the current buffer and flush, or if
-		 * there was a race with interrupts (prefix == true) then just
-		 * flush it out and store this line separately.
-		 * If the preceding printk was from a different task and missed
-		 * a newline, flush and append the newline.
+		 * This record is complete (it should be formatted with a
+		 * newline), so we'll be writing it to the log.  If there
+		 * are any incomplete records buffered we will need to
+		 * flush those to the log first.  If possible, we'll add
+		 * this record to the buffer first.  If there's nothing
+		 * buffered, just write this record to the log.
 		 */
 		if (cont.len) {
-			if (cont.owner == current && !(lflags & LOG_PREFIX))
+			if (cont.owner == current && !force_new)
 				stored = cont_add(facility, level, text,
 						  text_len);
 			cont_flush(LOG_NEWLINE);
@@ -1729,8 +1730,9 @@ asmlinkage int vprintk_emit(int facility, int level,
 		if (stored)
 			printed_len += text_len;
 		else
-			printed_len += log_store(facility, level, lflags, 0,
-						 dict, dictlen, text, text_len);
+			printed_len += log_store(facility, level, force_new,
+						lflags, 0, dict, dictlen,
+						text, text_len);
 	}
 
 	logbuf_cpu = UINT_MAX;
-- 
1.9.1

