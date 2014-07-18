Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935324AbaGRV2o (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 17:28:44 -0400
Received: from mail-ie0-f180.google.com ([209.85.223.180]:58310 "EHLO
	mail-ie0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946107AbaGRV2P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 17:28:15 -0400
From: Alex Elder <elder@linaro.org>
To: akpm@linux-foundation.org
Cc: kay@vrfy.org, pmladek@suse.cz, bp@suse.de, john.stultz@linaro.org,
        jack@suse.cz, linux-kernel@vger.kernel.org
Subject: [PATCH v4 6/7] printk: insert newline for truncated records
Date: Fri, 18 Jul 2014 16:28:04 -0500
Message-Id: <1405718885-11227-7-git-send-email-elder@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1405718885-11227-1-git-send-email-elder@linaro.org>
References: <1405718885-11227-1-git-send-email-elder@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If a log record has LOG_PREFIX set, its predecessor record should be
terminated if it was marked LOG_CONT.

In devkmsg_read(), this condition was being ignored, which would
lead to such records showing up combined when reading /dev/kmsg.
Fix this oversight.

We should similarly insert a newline in msg_print_text() in this
case, to avoid formatted records getting merged.

Suggested-by: Petr Mládek <pmladek@suse.cz>
Signed-off-by: Alex Elder <elder@linaro.org>
---
 kernel/printk/printk.c | 18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

diff --git a/kernel/printk/printk.c b/kernel/printk/printk.c
index e9f0632..a5ad81c 100644
--- a/kernel/printk/printk.c
+++ b/kernel/printk/printk.c
@@ -575,6 +575,7 @@ static ssize_t devkmsg_read(struct file *file, char __user *buf,
 	char cont;
 	size_t len;
 	ssize_t ret;
+	bool insert_newline;
 
 	if (!user)
 		return -EBADF;
@@ -626,7 +627,10 @@ static ssize_t devkmsg_read(struct file *file, char __user *buf,
 	else
 		cont = '-';
 
-	len = sprintf(user->buf, "%u,%llu,%llu,%c;",
+	/* Insert a newline if the previous line was not terminated properly */
+	insert_newline = (user->prev & LOG_CONT) && (msg->flags & LOG_PREFIX);
+	len = sprintf(user->buf, "%s%u,%llu,%llu,%c;",
+		      insert_newline ? "\n" : "",
 		      (msg->facility << 3) | msg->level,
 		      user->seq, ts_usec, cont);
 	user->prev = msg->flags;
@@ -999,10 +1003,12 @@ static size_t msg_print_text(const struct printk_log *msg, enum log_flags prev,
 {
 	const char *text = log_text(msg);
 	size_t text_size = msg->text_len;
+	size_t len = 0;
+	bool insert_newline;
 	bool prefix = true;
 	bool newline = true;
-	size_t len = 0;
 
+	insert_newline = (prev & LOG_CONT) && (msg->flags & LOG_PREFIX);
 	if ((prev & LOG_CONT) && !(msg->flags & LOG_PREFIX))
 		prefix = false;
 
@@ -1023,9 +1029,13 @@ static size_t msg_print_text(const struct printk_log *msg, enum log_flags prev,
 
 		if (buf) {
 			if (print_prefix(msg, syslog, NULL) +
-			    text_len + 1 >= size - len)
+			    text_len + 2 >= size - len)
 				break;
 
+			if (insert_newline) {
+				insert_newline = false;
+				buf[len++] = '\n';
+			}
 			if (prefix)
 				len += print_prefix(msg, syslog, buf + len);
 			memcpy(buf + len, text, text_len);
@@ -1034,6 +1044,8 @@ static size_t msg_print_text(const struct printk_log *msg, enum log_flags prev,
 				buf[len++] = '\n';
 		} else {
 			/* SYSLOG_ACTION_* buffer size only calculation */
+			if (insert_newline)
+				len++;
 			if (prefix)
 				len += print_prefix(msg, syslog, NULL);
 			len += text_len;
-- 
1.9.1

