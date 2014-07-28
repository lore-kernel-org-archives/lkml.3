Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752364AbaG1N32 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 09:29:28 -0400
Received: from mail-ie0-f182.google.com ([209.85.223.182]:54418 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752730AbaG1N3X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 09:29:23 -0400
From: Alex Elder <elder@linaro.org>
To: akpm@linux-foundation.org
Cc: kay@vrfy.org, pmladek@suse.cz, john.stultz@linaro.org, jack@suse.cz,
        linux-kernel@vger.kernel.org
Subject: [PATCH v7 3/7] printk: initialize syslog_prev and console_prev
Date: Mon, 28 Jul 2014 08:29:16 -0500
Message-Id: <1406554160-9562-4-git-send-email-elder@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1406554160-9562-1-git-send-email-elder@linaro.org>
References: <1406554160-9562-1-git-send-email-elder@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Two global variables, "syslog_prev" and "console_prev", maintain a
copy of the flags value used in the log record most recently
formatted for syslog or the console, respectively.

Initially there is no previous formatted log record, and these
variables simply have an initial value 0.  And occasionally log
records can get consumed at a rate such that syslog or the console
can't keep up, in which case those variables (along with their
corresponding position variables) must be reset.  Here too, they're
reset to 0.

This patch changes it so the initial value used is LOG_NEWLINE.
That is, if we know nothing about the prevously-formatted log
record, we can assume it was complete, and ended with a newline.
One exception is that occasionally we reset our syslog or console
(etc.) position variables.  In that case the previously-formatted
record flags value is still valid, so we preserve that information.

This is being done to support the next patch.  Initializing
these variables this way makes LOG_NEWLINE and LOG_CONT be
mutually exclusive, and the next patch uses that fact to simplify
some logic.

Signed-off-by: Alex Elder <elder@linaro.org>
Reviewed-by: Petr Mládek <pmladek@suse.cz>
---
 kernel/printk/printk.c | 40 ++++++++++++++++++++++++++--------------
 1 file changed, 26 insertions(+), 14 deletions(-)

diff --git a/kernel/printk/printk.c b/kernel/printk/printk.c
index 7dfa658..5c32938 100644
--- a/kernel/printk/printk.c
+++ b/kernel/printk/printk.c
@@ -236,7 +236,7 @@ DECLARE_WAIT_QUEUE_HEAD(log_wait);
 /* the next printk record to read by syslog(READ) or /proc/kmsg */
 static u64 syslog_seq;
 static u32 syslog_idx;
-static enum log_flags syslog_prev;
+static enum log_flags syslog_prev = LOG_NEWLINE;
 static size_t syslog_partial;
 
 /* index and sequence number of the first record stored in the buffer */
@@ -250,7 +250,7 @@ static u32 log_next_idx;
 /* the next printk record to write to the console */
 static u64 console_seq;
 static u32 console_idx;
-static enum log_flags console_prev;
+static enum log_flags console_prev = LOG_NEWLINE;
 
 /* the next printk record to read after the last 'clear' command */
 static u64 clear_seq;
@@ -1074,10 +1074,14 @@ static int syslog_print(char __user *buf, int size)
 
 		raw_spin_lock_irq(&logbuf_lock);
 		if (syslog_seq < log_first_seq) {
-			/* messages are gone, move to first one */
+			/*
+			 * Messages are gone, move to first one.
+			 * Don't discard what we know about the
+			 * previously-formatted record.
+			 */
 			syslog_seq = log_first_seq;
 			syslog_idx = log_first_idx;
-			syslog_prev = 0;
+			syslog_prev &= LOG_NEWLINE|LOG_CONT;
 			syslog_partial = 0;
 		}
 		if (syslog_seq == log_next_seq) {
@@ -1150,7 +1154,7 @@ static int syslog_print_all(char __user *buf, int size, bool clear)
 		 */
 		seq = clear_seq;
 		idx = clear_idx;
-		prev = 0;
+		prev = LOG_NEWLINE;
 		while (seq < log_next_seq) {
 			struct printk_log *msg = log_from_idx(idx);
 
@@ -1163,7 +1167,7 @@ static int syslog_print_all(char __user *buf, int size, bool clear)
 		/* move first record forward until length fits into the buffer */
 		seq = clear_seq;
 		idx = clear_idx;
-		prev = 0;
+		prev = LOG_NEWLINE;
 		while (len > size && seq < log_next_seq) {
 			struct printk_log *msg = log_from_idx(idx);
 
@@ -1199,10 +1203,14 @@ static int syslog_print_all(char __user *buf, int size, bool clear)
 			raw_spin_lock_irq(&logbuf_lock);
 
 			if (seq < log_first_seq) {
-				/* messages are gone, move to next one */
+				/*
+				 * Messages are gone, move to first one.
+				 * Don't discard what we know about the
+				 * previously-formatted record.
+				 */
 				seq = log_first_seq;
 				idx = log_first_idx;
-				prev = 0;
+				prev &= LOG_NEWLINE|LOG_CONT;
 			}
 		}
 	}
@@ -1304,10 +1312,14 @@ int do_syslog(int type, char __user *buf, int len, bool from_file)
 	case SYSLOG_ACTION_SIZE_UNREAD:
 		raw_spin_lock_irq(&logbuf_lock);
 		if (syslog_seq < log_first_seq) {
-			/* messages are gone, move to first one */
+			/*
+			 * Messages are gone, move to first one.
+			 * Don't discard what we know about the
+			 * previously-formatted record.
+			 */
 			syslog_seq = log_first_seq;
 			syslog_idx = log_first_idx;
-			syslog_prev = 0;
+			syslog_prev &= LOG_NEWLINE|LOG_CONT;
 			syslog_partial = 0;
 		}
 		if (from_file) {
@@ -2152,10 +2164,10 @@ again:
 				      "%s** %u printk messages dropped **\n",
 				      (console_prev & LOG_CONT) ? "\n" : "",
 				      (unsigned)(log_first_seq - console_seq));
-			/* messages are gone, move to first one */
+			/* Messages are gone, move to first one. */
 			console_seq = log_first_seq;
 			console_idx = log_first_idx;
-			console_prev = 0;
+			console_prev = LOG_NEWLINE;
 		} else {
 			len = 0;
 		}
@@ -2869,7 +2881,7 @@ bool kmsg_dump_get_buffer(struct kmsg_dumper *dumper, bool syslog,
 	/* calculate length of entire buffer */
 	seq = dumper->cur_seq;
 	idx = dumper->cur_idx;
-	prev = 0;
+	prev = LOG_NEWLINE;
 	while (seq < dumper->next_seq) {
 		struct printk_log *msg = log_from_idx(idx);
 
@@ -2882,7 +2894,7 @@ bool kmsg_dump_get_buffer(struct kmsg_dumper *dumper, bool syslog,
 	/* move first record forward until length fits into the buffer */
 	seq = dumper->cur_seq;
 	idx = dumper->cur_idx;
-	prev = 0;
+	prev = LOG_NEWLINE;
 	while (l > size && seq < dumper->next_seq) {
 		struct printk_log *msg = log_from_idx(idx);
 
-- 
1.9.1

