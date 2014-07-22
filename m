Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755558AbaGVMQX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 08:16:23 -0400
Received: from mail-ig0-f178.google.com ([209.85.213.178]:49085 "EHLO
	mail-ig0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754033AbaGVMNu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 08:13:50 -0400
From: Alex Elder <elder@linaro.org>
To: akpm@linux-foundation.org
Cc: kay@vrfy.org, pmladek@suse.cz, bp@suse.de, john.stultz@linaro.org,
        jack@suse.cz, linux-kernel@vger.kernel.org
Subject: [PATCH v6 3/7] printk: initialize syslog_prev and console_prev
Date: Tue, 22 Jul 2014 07:13:46 -0500
Message-Id: <1406031230-18107-4-git-send-email-elder@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1406031230-18107-1-git-send-email-elder@linaro.org>
References: <1406031230-18107-1-git-send-email-elder@linaro.org>
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
index 9f11eab..847e941 100644
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
@@ -1078,10 +1078,14 @@ static int syslog_print(char __user *buf, int size)
 
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
@@ -1154,7 +1158,7 @@ static int syslog_print_all(char __user *buf, int size, bool clear)
 		 */
 		seq = clear_seq;
 		idx = clear_idx;
-		prev = 0;
+		prev = LOG_NEWLINE;
 		while (seq < log_next_seq) {
 			struct printk_log *msg = log_from_idx(idx);
 
@@ -1167,7 +1171,7 @@ static int syslog_print_all(char __user *buf, int size, bool clear)
 		/* move first record forward until length fits into the buffer */
 		seq = clear_seq;
 		idx = clear_idx;
-		prev = 0;
+		prev = LOG_NEWLINE;
 		while (len > size && seq < log_next_seq) {
 			struct printk_log *msg = log_from_idx(idx);
 
@@ -1203,10 +1207,14 @@ static int syslog_print_all(char __user *buf, int size, bool clear)
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
@@ -1308,10 +1316,14 @@ int do_syslog(int type, char __user *buf, int len, bool from_file)
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
@@ -2156,10 +2168,10 @@ again:
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
@@ -2873,7 +2885,7 @@ bool kmsg_dump_get_buffer(struct kmsg_dumper *dumper, bool syslog,
 	/* calculate length of entire buffer */
 	seq = dumper->cur_seq;
 	idx = dumper->cur_idx;
-	prev = 0;
+	prev = LOG_NEWLINE;
 	while (seq < dumper->next_seq) {
 		struct printk_log *msg = log_from_idx(idx);
 
@@ -2886,7 +2898,7 @@ bool kmsg_dump_get_buffer(struct kmsg_dumper *dumper, bool syslog,
 	/* move first record forward until length fits into the buffer */
 	seq = dumper->cur_seq;
 	idx = dumper->cur_idx;
-	prev = 0;
+	prev = LOG_NEWLINE;
 	while (l > size && seq < dumper->next_seq) {
 		struct printk_log *msg = log_from_idx(idx);
 
-- 
1.9.1

