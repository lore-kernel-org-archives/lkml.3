Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935212AbaDJJoS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 05:44:18 -0400
Received: from cantor2.suse.de ([195.135.220.15]:45703 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934910AbaDJJoN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 05:44:13 -0400
From: Petr Mladek <pmladek@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jan Kara <jack@suse.cz>, Jiri Kosina <jkosina@suse.cz>,
        Kay Sievers <kay@vrfy.org>, linux-kernel@vger.kernel.org,
        Petr Mladek <pmladek@suse.cz>
Subject: [PATCH 1/5] printk: Split code for making free space in the log buffer
Date: Thu, 10 Apr 2014 11:43:12 +0200
Message-Id: <1397122996-15136-2-git-send-email-pmladek@suse.cz>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1397122996-15136-1-git-send-email-pmladek@suse.cz>
References: <1397122996-15136-1-git-send-email-pmladek@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There will be needed some fixes in the check for free space. They will
be easier if the code is moved outside of the quite long log_store()
function.

This patch does not change the existing behavior.

Signed-off-by: Petr Mladek <pmladek@suse.cz>
---
 kernel/printk/printk.c | 44 +++++++++++++++++++++++++++++---------------
 1 file changed, 29 insertions(+), 15 deletions(-)

diff --git a/kernel/printk/printk.c b/kernel/printk/printk.c
index a45b50962295..cc7d7defce24 100644
--- a/kernel/printk/printk.c
+++ b/kernel/printk/printk.c
@@ -297,6 +297,34 @@ static u32 log_next(u32 idx)
 	return idx + msg->len;
 }
 
+/* check whether there is enough free space for the given message */
+static int logbuf_has_space(u32 msg_size)
+{
+	u32 free;
+
+	if (log_next_idx > log_first_idx)
+		free = max(log_buf_len - log_next_idx, log_first_idx);
+	else
+		free = log_first_idx - log_next_idx;
+
+	/*
+	 * We need space also for an empty header that signalizes wrapping
+	 * of the buffer.
+	 */
+	return free >= msg_size + sizeof(struct printk_log);
+}
+
+static void log_make_free_space(u32 msg_size)
+{
+	while (log_first_seq < log_next_seq) {
+		if (logbuf_has_space(msg_size))
+			return;
+		/* drop old messages until we have enough continuous space */
+		log_first_idx = log_next(log_first_idx);
+		log_first_seq++;
+	}
+}
+
 /* insert record into the buffer, discard old ones, update heads */
 static void log_store(int facility, int level,
 		      enum log_flags flags, u64 ts_nsec,
@@ -311,21 +339,7 @@ static void log_store(int facility, int level,
 	pad_len = (-size) & (LOG_ALIGN - 1);
 	size += pad_len;
 
-	while (log_first_seq < log_next_seq) {
-		u32 free;
-
-		if (log_next_idx > log_first_idx)
-			free = max(log_buf_len - log_next_idx, log_first_idx);
-		else
-			free = log_first_idx - log_next_idx;
-
-		if (free >= size + sizeof(struct printk_log))
-			break;
-
-		/* drop old messages until we have enough contiuous space */
-		log_first_idx = log_next(log_first_idx);
-		log_first_seq++;
-	}
+	log_make_free_space(size);
 
 	if (log_next_idx + size + sizeof(struct printk_log) > log_buf_len) {
 		/*
-- 
1.8.4

