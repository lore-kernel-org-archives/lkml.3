Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965740AbaDJJph (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 05:45:37 -0400
Received: from cantor2.suse.de ([195.135.220.15]:45738 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965484AbaDJJpe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 05:45:34 -0400
From: Petr Mladek <pmladek@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jan Kara <jack@suse.cz>, Jiri Kosina <jkosina@suse.cz>,
        Kay Sievers <kay@vrfy.org>, linux-kernel@vger.kernel.org,
        Petr Mladek <pmladek@suse.cz>
Subject: [PATCH 5/5] printk: Return really stored message length
Date: Thu, 10 Apr 2014 11:43:16 +0200
Message-Id: <1397122996-15136-6-git-send-email-pmladek@suse.cz>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1397122996-15136-1-git-send-email-pmladek@suse.cz>
References: <1397122996-15136-1-git-send-email-pmladek@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I wonder if anyone uses printk return value but it is there and should be
counted correctly.

This patch modifies log_store() to return the number of really stored bytes
from the 'text' part. Also it handles the return value in vprintk_emit().

Note that log_store() is used also in cont_flush() but we could ignore the
return value there. The function works with characters that were already
counted earlier. In addition, the store could newer fail here because the
length of the printed text is limited by the "cont" buffer and "dict" is NULL.

Signed-off-by: Petr Mladek <pmladek@suse.cz>
---
 kernel/printk/printk.c | 36 +++++++++++++++++++++---------------
 1 file changed, 21 insertions(+), 15 deletions(-)

diff --git a/kernel/printk/printk.c b/kernel/printk/printk.c
index 68a6950ae9de..d3aa0c92b28b 100644
--- a/kernel/printk/printk.c
+++ b/kernel/printk/printk.c
@@ -378,10 +378,10 @@ static u32 truncate_msg(u16 *text_len, u16 *trunc_msg_len,
 }
 
 /* insert record into the buffer, discard old ones, update heads */
-static void log_store(int facility, int level,
-		      enum log_flags flags, u64 ts_nsec,
-		      const char *dict, u16 dict_len,
-		      const char *text, u16 text_len)
+static int log_store(int facility, int level,
+		     enum log_flags flags, u64 ts_nsec,
+		     const char *dict, u16 dict_len,
+		     const char *text, u16 text_len)
 {
 	struct printk_log *msg;
 	u32 size, pad_len;
@@ -396,7 +396,7 @@ static void log_store(int facility, int level,
 				    &dict_len, &pad_len);
 		/* survive when the log buffer is too small for trunc_msg */
 		if (log_make_free_space(size))
-			return;
+			return 0;
 	}
 
 	if (log_next_idx + size + sizeof(struct printk_log) > log_buf_len) {
@@ -432,6 +432,8 @@ static void log_store(int facility, int level,
 	/* insert message */
 	log_next_idx += msg->len;
 	log_next_seq++;
+
+	return msg->text_len;
 }
 
 #ifdef CONFIG_SECURITY_DMESG_RESTRICT
@@ -1606,10 +1608,10 @@ asmlinkage int vprintk_emit(int facility, int level,
 			"BUG: recent printk recursion!";
 
 		recursion_bug = 0;
-		printed_len += strlen(recursion_msg);
+		text_len = strlen(recursion_msg);
 		/* emit KERN_CRIT message */
-		log_store(0, 2, LOG_PREFIX|LOG_NEWLINE, 0,
-			  NULL, 0, recursion_msg, printed_len);
+		printed_len += log_store(0, 2, LOG_PREFIX|LOG_NEWLINE, 0,
+					 NULL, 0, recursion_msg, text_len);
 	}
 
 	/*
@@ -1662,9 +1664,12 @@ asmlinkage int vprintk_emit(int facility, int level,
 			cont_flush(LOG_NEWLINE);
 
 		/* buffer line if possible, otherwise store it right away */
-		if (!cont_add(facility, level, text, text_len))
-			log_store(facility, level, lflags | LOG_CONT, 0,
-				  dict, dictlen, text, text_len);
+		if (cont_add(facility, level, text, text_len))
+			printed_len += text_len;
+		else
+			printed_len += log_store(facility, level,
+						 lflags | LOG_CONT, 0,
+						 dict, dictlen, text, text_len);
 	} else {
 		bool stored = false;
 
@@ -1683,11 +1688,12 @@ asmlinkage int vprintk_emit(int facility, int level,
 			cont_flush(LOG_NEWLINE);
 		}
 
-		if (!stored)
-			log_store(facility, level, lflags, 0,
-				  dict, dictlen, text, text_len);
+		if (stored)
+			printed_len += text_len;
+		else
+			printed_len += log_store(facility, level, lflags, 0,
+						 dict, dictlen, text, text_len);
 	}
-	printed_len += text_len;
 
 	/*
 	 * Try to acquire and then immediately release the console semaphore.
-- 
1.8.4

