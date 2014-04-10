Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965667AbaDJJpX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 05:45:23 -0400
Received: from cantor2.suse.de ([195.135.220.15]:45731 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934910AbaDJJpN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 05:45:13 -0400
From: Petr Mladek <pmladek@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jan Kara <jack@suse.cz>, Jiri Kosina <jkosina@suse.cz>,
        Kay Sievers <kay@vrfy.org>, linux-kernel@vger.kernel.org,
        Petr Mladek <pmladek@suse.cz>
Subject: [PATCH 4/5] printk: Shrink too long messages
Date: Thu, 10 Apr 2014 11:43:15 +0200
Message-Id: <1397122996-15136-5-git-send-email-pmladek@suse.cz>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1397122996-15136-1-git-send-email-pmladek@suse.cz>
References: <1397122996-15136-1-git-send-email-pmladek@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We might want to print at least part of too long messages and add some warning
for debugging purpose.

The question is how long the shrunken message should be. If we use the whole
buffer, it might get rotated too soon. Let's try to use only 1/4 of the buffer
for now.

Also shrink the whole dictionary. We do not want to parse it or break it in the
middle of some pair of values. It would not cause any real harm but still.

Signed-off-by: Petr Mladek <pmladek@suse.cz>
---
 kernel/printk/printk.c | 42 +++++++++++++++++++++++++++++++++++++++---
 1 file changed, 39 insertions(+), 3 deletions(-)

diff --git a/kernel/printk/printk.c b/kernel/printk/printk.c
index 7416dfad0a28..68a6950ae9de 100644
--- a/kernel/printk/printk.c
+++ b/kernel/printk/printk.c
@@ -351,6 +351,32 @@ static u32 msg_used_size(u16 text_len, u16 dict_len, u32 *pad_len)
 	return size;
 }
 
+/*
+ * Define how much of the log buffer we could take at maximum. The value
+ * must be greater than two. Note that only half of the buffer is available
+ * when the index points to the middle.
+ */
+#define MAX_LOG_TAKE_PART 4
+static const char trunc_msg[] = "<truncated>";
+
+static u32 truncate_msg(u16 *text_len, u16 *trunc_msg_len,
+			u16 *dict_len, u32 *pad_len)
+{
+	/*
+	 * The message should not take the whole buffer. Otherwise, it might
+	 * get removed too soon.
+	 */
+	u32 max_text_len = log_buf_len / MAX_LOG_TAKE_PART;
+	if (*text_len > max_text_len)
+		*text_len = max_text_len;
+	/* enable the warning message */
+	*trunc_msg_len = strlen(trunc_msg);
+	/* disable the "dict" completely */
+	*dict_len = 0;
+	/* compute the size again, count also the warning message */
+	return msg_used_size(*text_len + *trunc_msg_len, 0, pad_len);
+}
+
 /* insert record into the buffer, discard old ones, update heads */
 static void log_store(int facility, int level,
 		      enum log_flags flags, u64 ts_nsec,
@@ -359,13 +385,19 @@ static void log_store(int facility, int level,
 {
 	struct printk_log *msg;
 	u32 size, pad_len;
+	u16 trunc_msg_len = 0;
 
 	/* number of '\0' padding bytes to next message */
 	size = msg_used_size(text_len, dict_len, &pad_len);
 
-	/* if message does not fit empty log buffer, ignore it */
-	if (log_make_free_space(size))
-		return;
+	if (log_make_free_space(size)) {
+		/* truncate the message if it is too long for empty buffer */
+		size = truncate_msg(&text_len, &trunc_msg_len,
+				    &dict_len, &pad_len);
+		/* survive when the log buffer is too small for trunc_msg */
+		if (log_make_free_space(size))
+			return;
+	}
 
 	if (log_next_idx + size + sizeof(struct printk_log) > log_buf_len) {
 		/*
@@ -381,6 +413,10 @@ static void log_store(int facility, int level,
 	msg = (struct printk_log *)(log_buf + log_next_idx);
 	memcpy(log_text(msg), text, text_len);
 	msg->text_len = text_len;
+	if (trunc_msg_len) {
+		memcpy(log_text(msg) + text_len, trunc_msg, trunc_msg_len);
+		msg->text_len += trunc_msg_len;
+	}
 	memcpy(log_dict(msg), dict, dict_len);
 	msg->dict_len = dict_len;
 	msg->facility = facility;
-- 
1.8.4

