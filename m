Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752968AbaHXQBq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Aug 2014 12:01:46 -0400
Received: from mail-qc0-f175.google.com ([209.85.216.175]:41226 "EHLO
	mail-qc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752520AbaHXQBp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Aug 2014 12:01:45 -0400
From: Patrick Palka <patrick@parcs.ath.cx>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, pmladek@suse.cz, jack@suse.cz,
        rostedt@goodmis.org, Patrick Palka <patrick@parcs.ath.cx>
Subject: [PATCH] Fix faulty logic in the case of recursive printk
Date: Sun, 24 Aug 2014 12:01:36 -0400
Message-Id: <1408896096-16605-1-git-send-email-patrick@parcs.ath.cx>
X-Mailer: git-send-email 2.1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We shouldn't set text_len in the code path that detects printk recursion
because text_len corresponds to the length of the string inside textbuf.
A few lines down from the line

    text_len = strlen(recursion_msg);

is the line

    text_len += vscnprintf(text + text_len, ...);

So if printk detects recursion, it sets text_len to 29 and logs an
error.  Then the message supplied by the caller of printk is stored
inside textbuf but offset by 29 bytes.  This means that the output of
the recursive call to printk will contain 29 bytes of garbage in front
of it.

This defect is caused by commit 458df9fd ("printk: remove separate
printk_sched buffers and use printk buf instead") which turned

    text_len = vscnprintf(text + text_len, ...);

into

    text_len += vscnprintf(text + text_len, ...);

To fix this, this patch avoids setting text_len when logging the printk
recursion error.  This patch also performs a couple of local
micro-optimizations (use unlikely() and ARRAY_SIZE()).

Signed-off-by: Patrick Palka <patrick@parcs.ath.cx>
---
 kernel/printk/printk.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/kernel/printk/printk.c b/kernel/printk/printk.c
index e04c455..c101ec2 100644
--- a/kernel/printk/printk.c
+++ b/kernel/printk/printk.c
@@ -1665,15 +1665,15 @@ asmlinkage int vprintk_emit(int facility, int level,
 	raw_spin_lock(&logbuf_lock);
 	logbuf_cpu = this_cpu;
 
-	if (recursion_bug) {
+	if (unlikely(recursion_bug)) {
 		static const char recursion_msg[] =
 			"BUG: recent printk recursion!";
 
 		recursion_bug = 0;
-		text_len = strlen(recursion_msg);
 		/* emit KERN_CRIT message */
 		printed_len += log_store(0, 2, LOG_PREFIX|LOG_NEWLINE, 0,
-					 NULL, 0, recursion_msg, text_len);
+					 NULL, 0, recursion_msg,
+					 ARRAY_SIZE(recursion_msg) - 1);
 	}
 
 	/*
-- 
2.1.0

