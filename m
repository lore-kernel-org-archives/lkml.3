Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757517AbaHZLXj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 07:23:39 -0400
Received: from mail-qa0-f45.google.com ([209.85.216.45]:53018 "EHLO
	mail-qa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754426AbaHZLXh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 07:23:37 -0400
From: Patrick Palka <patrick@parcs.ath.cx>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, pmladek@suse.cz, jack@suse.cz,
        rostedt@goodmis.org, Patrick Palka <patrick@parcs.ath.cx>
Subject: [PATCH] Fix faulty logic in the case of recursive printk
Date: Tue, 26 Aug 2014 07:23:22 -0400
Message-Id: <1409052202-9498-1-git-send-email-patrick@parcs.ath.cx>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <20140826084833.GA1581@quack.suse.cz>
References: <20140826084833.GA1581@quack.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for reviewing!  I have put back the call to strlen() and adjusted
the commit message accordingly.

Patrick

-- >8 --

We shouldn't set text_len in the code path that detects printk recursion
because text_len corresponds to the length of the string inside textbuf.
A few lines down from the line

    text_len = strlen(recursion_msg);

is the line

    text_len += vscnprintf(text + text_len, ...);

So if printk detects recursion, it sets text_len to 29 (the length of
recursion_msg) and logs an error.  Then the message supplied by the
caller of printk is stored inside textbuf but offset by 29 bytes.  This
means that the output of the recursive call to printk will contain 29
bytes of garbage in front of it.

This defect is caused by commit 458df9fd ("printk: remove separate
printk_sched buffers and use printk buf instead") which turned the line

    text_len = vscnprintf(text, ...);

into

    text_len += vscnprintf(text + text_len, ...);

To fix this, this patch avoids setting text_len when logging the printk
recursion error.  This patch also marks unlikely() the branch leading
up to this code.

Signed-off-by: Patrick Palka <patrick@parcs.ath.cx>
---
 kernel/printk/printk.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/kernel/printk/printk.c b/kernel/printk/printk.c
index e04c455..1ce7706 100644
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
+					 strlen(recursion_msg));
 	}
 
 	/*
-- 
2.1.0

