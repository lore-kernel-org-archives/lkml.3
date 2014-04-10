Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935348AbaDJJo7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 05:44:59 -0400
Received: from cantor2.suse.de ([195.135.220.15]:45726 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934910AbaDJJox (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 05:44:53 -0400
From: Petr Mladek <pmladek@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jan Kara <jack@suse.cz>, Jiri Kosina <jkosina@suse.cz>,
        Kay Sievers <kay@vrfy.org>, linux-kernel@vger.kernel.org,
        Petr Mladek <pmladek@suse.cz>
Subject: [PATCH 3/5] printk: Split message size computation
Date: Thu, 10 Apr 2014 11:43:14 +0200
Message-Id: <1397122996-15136-4-git-send-email-pmladek@suse.cz>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1397122996-15136-1-git-send-email-pmladek@suse.cz>
References: <1397122996-15136-1-git-send-email-pmladek@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We will want to recompute the message size when shrinking too long messages.
Let's put the code into separate function.

The side effect of setting "pad_len" is not nice but it is worth removing
the code duplication. Note that I will probably have one more usage for this
function when handling messages safe way in NMI context.

This patch does not change the existing behavior.

Signed-off-by: Petr Mladek <pmladek@suse.cz>
---
 kernel/printk/printk.c | 16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

diff --git a/kernel/printk/printk.c b/kernel/printk/printk.c
index 5de686b6b9e1..7416dfad0a28 100644
--- a/kernel/printk/printk.c
+++ b/kernel/printk/printk.c
@@ -339,6 +339,18 @@ static int log_make_free_space(u32 msg_size)
 	return -ENOMEM;
 }
 
+/* compute the message size including the padding bytes */
+static u32 msg_used_size(u16 text_len, u16 dict_len, u32 *pad_len)
+{
+	u32 size;
+
+	size = sizeof(struct printk_log) + text_len + dict_len;
+	*pad_len = (-size) & (LOG_ALIGN - 1);
+	size += *pad_len;
+
+	return size;
+}
+
 /* insert record into the buffer, discard old ones, update heads */
 static void log_store(int facility, int level,
 		      enum log_flags flags, u64 ts_nsec,
@@ -349,9 +361,7 @@ static void log_store(int facility, int level,
 	u32 size, pad_len;
 
 	/* number of '\0' padding bytes to next message */
-	size = sizeof(struct printk_log) + text_len + dict_len;
-	pad_len = (-size) & (LOG_ALIGN - 1);
-	size += pad_len;
+	size = msg_used_size(text_len, dict_len, &pad_len);
 
 	/* if message does not fit empty log buffer, ignore it */
 	if (log_make_free_space(size))
-- 
1.8.4

