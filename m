Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933555AbaGQOKp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 10:10:45 -0400
Received: from mail-ie0-f179.google.com ([209.85.223.179]:35821 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932361AbaGQOJN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 10:09:13 -0400
From: Alex Elder <elder@linaro.org>
To: akpm@linux-foundation.org
Cc: pmladek@suse.cz, bp@suse.de, john.stultz@linaro.org, jack@suse.cz,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/6] printk: initialize syslog_prev and console_prev
Date: Thu, 17 Jul 2014 09:09:06 -0500
Message-Id: <1405606151-19875-2-git-send-email-elder@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1405606151-19875-1-git-send-email-elder@linaro.org>
References: <1405606151-19875-1-git-send-email-elder@linaro.org>
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

This is being done to support the next patch.  Initializing
these variables this way makes LOG_NEWLINE and LOG_CONT be
mutually exclusive, and the next patch uses that fact to simplify
some logic.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 kernel/printk/printk.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/kernel/printk/printk.c b/kernel/printk/printk.c
index 13e839d..ff1c7ad 100644
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
@@ -1071,7 +1071,7 @@ static int syslog_print(char __user *buf, int size)
 			/* messages are gone, move to first one */
 			syslog_seq = log_first_seq;
 			syslog_idx = log_first_idx;
-			syslog_prev = 0;
+			syslog_prev = LOG_NEWLINE;
 			syslog_partial = 0;
 		}
 		if (syslog_seq == log_next_seq) {
@@ -1301,7 +1301,7 @@ int do_syslog(int type, char __user *buf, int len, bool from_file)
 			/* messages are gone, move to first one */
 			syslog_seq = log_first_seq;
 			syslog_idx = log_first_idx;
-			syslog_prev = 0;
+			syslog_prev = LOG_NEWLINE;
 			syslog_partial = 0;
 		}
 		if (from_file) {
@@ -2148,7 +2148,7 @@ again:
 			/* messages are gone, move to first one */
 			console_seq = log_first_seq;
 			console_idx = log_first_idx;
-			console_prev = 0;
+			console_prev = LOG_NEWLINE;
 		} else {
 			len = 0;
 		}
-- 
1.9.1

