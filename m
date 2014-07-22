Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755373AbaGVMNw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 08:13:52 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:60502 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755332AbaGVMNt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 08:13:49 -0400
From: Alex Elder <elder@linaro.org>
To: akpm@linux-foundation.org
Cc: kay@vrfy.org, pmladek@suse.cz, bp@suse.de, john.stultz@linaro.org,
        jack@suse.cz, linux-kernel@vger.kernel.org
Subject: [PATCH v6 2/7] printk: insert newline for truncated records
Date: Tue, 22 Jul 2014 07:13:45 -0500
Message-Id: <1406031230-18107-3-git-send-email-elder@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1406031230-18107-1-git-send-email-elder@linaro.org>
References: <1406031230-18107-1-git-send-email-elder@linaro.org>
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
Reviewed-by: Petr Mládek <pmladek@suse.cz>
---
 kernel/printk/printk.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/kernel/printk/printk.c b/kernel/printk/printk.c
index ffc9928..9f11eab 100644
--- a/kernel/printk/printk.c
+++ b/kernel/printk/printk.c
@@ -575,6 +575,7 @@ static ssize_t devkmsg_read(struct file *file, char __user *buf,
 	char cont = '-';
 	size_t len;
 	ssize_t ret;
+	bool insert_newline;
 
 	if (!user)
 		return -EBADF;
@@ -625,7 +626,10 @@ static ssize_t devkmsg_read(struct file *file, char __user *buf,
 		 ((user->prev & LOG_CONT) && !(msg->flags & LOG_PREFIX)))
 		cont = '+';
 
-	len = sprintf(user->buf, "%u,%llu,%llu,%c;",
+	/* Insert a newline if the previous line was not terminated properly */
+	insert_newline = (user->prev & LOG_CONT) && (msg->flags & LOG_PREFIX);
+	len = sprintf(user->buf, "%s%u,%llu,%llu,%c;",
+		      insert_newline ? "\n" : "",
 		      (msg->facility << 3) | msg->level,
 		      user->seq, ts_usec, cont);
 	user->prev = msg->flags;
@@ -1013,6 +1017,12 @@ static size_t msg_print_text(const struct printk_log *msg, enum log_flags prev,
 			newline = false;
 	}
 
+	if ((prev & LOG_CONT) && (msg->flags & LOG_PREFIX) && len < size) {
+		if (buf)
+			buf[len++] = '\n';
+		else
+			len++;
+	}
 	do {
 		const char *next = memchr(text, '\n', text_size);
 		size_t text_len;
-- 
1.9.1

