Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752928AbaGQSAy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 14:00:54 -0400
Received: from mail-ig0-f176.google.com ([209.85.213.176]:39417 "EHLO
	mail-ig0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751328AbaGQR7S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 13:59:18 -0400
From: Alex Elder <elder@linaro.org>
To: akpm@linux-foundation.org
Cc: kay@vrfy.org, pmladek@suse.cz, bp@suse.de, john.stultz@linaro.org,
        jack@suse.cz, linux-kernel@vger.kernel.org
Subject: [PATCH 2/5] printk: update previous message for LOG_PREFIX
Date: Thu, 17 Jul 2014 12:59:10 -0500
Message-Id: <1405619953-5475-3-git-send-email-elder@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1405619953-5475-1-git-send-email-elder@linaro.org>
References: <1405619953-5475-1-git-send-email-elder@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If log_store() gets flags containing LOG_PREFIX, it indicates the
record getting stored should implicitly complete the previous log
record and start a new one.

We can also ensure the previous record is completed by keeping
track of the previously-logged record, and adding the LOG_NEWLINE
flag to it when log_store() sees a LOG_PREFIX flag.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 kernel/printk/printk.c | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/kernel/printk/printk.c b/kernel/printk/printk.c
index e35d91a..6b72a77 100644
--- a/kernel/printk/printk.c
+++ b/kernel/printk/printk.c
@@ -242,6 +242,9 @@ static size_t syslog_partial;
 static u64 log_first_seq;
 static u32 log_first_idx;
 
+/* Pointer to the last record written into the log */
+static struct printk_log *log_last_msg;
+
 /* index and sequence number of the next record to store in the buffer */
 static u64 log_next_seq;
 static u32 log_next_idx;
@@ -425,7 +428,13 @@ static int log_store(int facility, int level,
 		log_next_idx = 0;
 	}
 
-	/* fill message */
+	/*
+	 * If we're forcing a new log record, update the flags for
+	 * the previous one to mark it complete.
+	 */
+	if (flags & LOG_PREFIX && log_last_msg)
+		log_last_msg->flags |= LOG_NEWLINE;
+
 	msg = (struct printk_log *)(log_buf + log_next_idx);
 	memcpy(log_text(msg), text, text_len);
 	msg->text_len = text_len;
@@ -449,6 +458,9 @@ static int log_store(int facility, int level,
 	log_next_idx += msg->len;
 	log_next_seq++;
 
+	/* Save our previous record address for next time. */
+	log_last_msg = msg;
+
 	return msg->text_len;
 }
 
-- 
1.9.1

