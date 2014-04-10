Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935245AbaDJJof (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 05:44:35 -0400
Received: from cantor2.suse.de ([195.135.220.15]:45709 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934910AbaDJJod (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 05:44:33 -0400
From: Petr Mladek <pmladek@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jan Kara <jack@suse.cz>, Jiri Kosina <jkosina@suse.cz>,
        Kay Sievers <kay@vrfy.org>, linux-kernel@vger.kernel.org,
        Petr Mladek <pmladek@suse.cz>
Subject: [PATCH 2/5] printk: Ignore too long messages
Date: Thu, 10 Apr 2014 11:43:13 +0200
Message-Id: <1397122996-15136-3-git-send-email-pmladek@suse.cz>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1397122996-15136-1-git-send-email-pmladek@suse.cz>
References: <1397122996-15136-1-git-send-email-pmladek@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There was no check for too long messages. The check for free space always passed
when first_seq and next_seq were equal. Enough free space was not guaranteed,
though.

log_store() might be called to store messages up to 64kB + 64kB + 16B. This is
sum of maximal text_len, dict_len values, and the size of the structure
printk_log.

On the other hand, the minimal size for the main log buffer currently is 4kB
and it is enforced only by Kconfig.

The good news is that the usage looks safe right now. log_store() is called only
from vprintk_emit() and cont_flush(). Here the "text" part is always passed
via a static buffer and the length is limited to LOG_LINE_MAX which is 1024.
The "dict" part is NULL in most cases. The only exceptions is when
vprintk_emit() is called from printk_emit() and dev_vprintk_emit().
But printk_emit() is currently used only in devkmsg_writev() and here
"dict" is NULL as well. In dev_vprintk_emit(), "dict" is limited by the
static buffer "hdr" of the size 128 bytes. It meas that the current maximal
printed text is 1024B + 128B + 16B and it always fit the log buffer.

But it is only matter of time when someone calls printk_emit() with unsafe
parameters, especially the "dict" one.

This patch adds a check for the free space when the buffer is empty. It reuses
the already existing log_has_space() function but it has to add an extra
parameter. It defines whether the buffer is empty. Note that the same values
of "first_idx" and "next_idx" might also mean that the buffer is full.

If the buffer is empty, we must respect the current position of the
indexes. We cannot reset them to the beginning of the buffer. Otherwise,
the functions reading the buffer would get crazy.

The question is what to do when the message is too long. This patch uses the
easiest solution and just ignores the problematic message. Let's do something
better in a followup patch.

Signed-off-by: Petr Mladek <pmladek@suse.cz>
---
 kernel/printk/printk.c | 30 +++++++++++++++++++++++-------
 1 file changed, 23 insertions(+), 7 deletions(-)

diff --git a/kernel/printk/printk.c b/kernel/printk/printk.c
index cc7d7defce24..5de686b6b9e1 100644
--- a/kernel/printk/printk.c
+++ b/kernel/printk/printk.c
@@ -297,12 +297,20 @@ static u32 log_next(u32 idx)
 	return idx + msg->len;
 }
 
-/* check whether there is enough free space for the given message */
-static int logbuf_has_space(u32 msg_size)
+/*
+ * Check whether there is enough free space for the given message.
+ *
+ * The same values of first_idx and next_idx mean that the buffer
+ * is either empty or full.
+ *
+ * If the buffer is empty, we must respect the position of the indexes.
+ * They cannot be reset to the beginning of the buffer.
+ */
+static int logbuf_has_space(u32 msg_size, bool empty)
 {
 	u32 free;
 
-	if (log_next_idx > log_first_idx)
+	if (log_next_idx > log_first_idx || empty)
 		free = max(log_buf_len - log_next_idx, log_first_idx);
 	else
 		free = log_first_idx - log_next_idx;
@@ -314,15 +322,21 @@ static int logbuf_has_space(u32 msg_size)
 	return free >= msg_size + sizeof(struct printk_log);
 }
 
-static void log_make_free_space(u32 msg_size)
+static int log_make_free_space(u32 msg_size)
 {
 	while (log_first_seq < log_next_seq) {
-		if (logbuf_has_space(msg_size))
-			return;
+		if (logbuf_has_space(msg_size, false))
+			return 0;
 		/* drop old messages until we have enough continuous space */
 		log_first_idx = log_next(log_first_idx);
 		log_first_seq++;
 	}
+
+	/* sequence numbers are equal, so the log buffer is empty */
+	if (logbuf_has_space(msg_size, true))
+		return 0;
+
+	return -ENOMEM;
 }
 
 /* insert record into the buffer, discard old ones, update heads */
@@ -339,7 +353,9 @@ static void log_store(int facility, int level,
 	pad_len = (-size) & (LOG_ALIGN - 1);
 	size += pad_len;
 
-	log_make_free_space(size);
+	/* if message does not fit empty log buffer, ignore it */
+	if (log_make_free_space(size))
+		return;
 
 	if (log_next_idx + size + sizeof(struct printk_log) > log_buf_len) {
 		/*
-- 
1.8.4

