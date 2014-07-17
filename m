Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752471AbaGQR7V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 13:59:21 -0400
Received: from mail-ie0-f182.google.com ([209.85.223.182]:41981 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752377AbaGQR7T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 13:59:19 -0400
From: Alex Elder <elder@linaro.org>
To: akpm@linux-foundation.org
Cc: kay@vrfy.org, pmladek@suse.cz, bp@suse.de, john.stultz@linaro.org,
        jack@suse.cz, linux-kernel@vger.kernel.org
Subject: [PATCH 3/5] printk: stop actually recording LOG_PREFIX
Date: Thu, 17 Jul 2014 12:59:11 -0500
Message-Id: <1405619953-5475-4-git-send-email-elder@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1405619953-5475-1-git-send-email-elder@linaro.org>
References: <1405619953-5475-1-git-send-email-elder@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Whenever log_store() sees a LOG_PREFIX flag it marks the previous
log entry (if there is one) with LOG_NEWLINE, which (also) produces
the desired effect.

There's therefore no need to record LOG_PREFIX in log records.

If no log entries contain LOG_PREFIX, devkmsg_read() and
msg_print_text() don't need to check for it.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 kernel/printk/printk.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/kernel/printk/printk.c b/kernel/printk/printk.c
index 6b72a77..df38b5e 100644
--- a/kernel/printk/printk.c
+++ b/kernel/printk/printk.c
@@ -432,8 +432,11 @@ static int log_store(int facility, int level,
 	 * If we're forcing a new log record, update the flags for
 	 * the previous one to mark it complete.
 	 */
-	if (flags & LOG_PREFIX && log_last_msg)
-		log_last_msg->flags |= LOG_NEWLINE;
+	if (flags & LOG_PREFIX) {
+		if (log_last_msg)
+			log_last_msg->flags |= LOG_NEWLINE;
+		flags &= ~LOG_PREFIX;
+	}
 
 	msg = (struct printk_log *)(log_buf + log_next_idx);
 	memcpy(log_text(msg), text, text_len);
@@ -633,7 +636,7 @@ static ssize_t devkmsg_read(struct file *file, char __user *buf,
 	 * a record that should be merged with one or more earlier records.
 	 * And a '-' indicates a "normal" self-contained single record.
 	 */
-	if (!(user->prev & LOG_NEWLINE) && !(msg->flags & LOG_PREFIX))
+	if (!(user->prev & LOG_NEWLINE))
 		cont = '+';
 	else if (!(msg->flags & LOG_NEWLINE))
 		cont = 'c';
@@ -1020,7 +1023,7 @@ static size_t msg_print_text(const struct printk_log *msg, enum log_flags prev,
 	bool newline = true;
 	size_t len = 0;
 
-	if (!(prev & LOG_NEWLINE) && !(msg->flags & LOG_PREFIX))
+	if (!(prev & LOG_NEWLINE))
 		prefix = false;
 
 	if (!(msg->flags & LOG_NEWLINE))
-- 
1.9.1

