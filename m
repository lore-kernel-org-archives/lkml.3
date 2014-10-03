Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757156AbaJCWCu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 18:02:50 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45998 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932183AbaJCVxj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 17:53:39 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Patrick Palka <patrick@parcs.ath.cx>, Petr Mladek <pmladek@suse.cz>,
        Jan Kara <jack@suse.cz>, Steven Rostedt <rostedt@goodmis.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 3.16 271/357] kernel/printk/printk.c: fix faulty logic in the case of recursive printk
Date: Fri,  3 Oct 2014 14:30:57 -0700
Message-Id: <20141003212941.639103854@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141003212933.458851516@linuxfoundation.org>
References: <20141003212933.458851516@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Patrick Palka <patrick@parcs.ath.cx>

commit 000a7d66ec30898f46869be01ab8205b056385d0 upstream.

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

This defect is caused by commit 458df9fd4815 ("printk: remove separate
printk_sched buffers and use printk buf instead") which turned the line

    text_len = vscnprintf(text, ...);

into

    text_len += vscnprintf(text + text_len, ...);

To fix this, this patch avoids setting text_len when logging the printk
recursion error.  This patch also marks unlikely() the branch leading up
to this code.

Fixes: 458df9fd4815b478 ("printk: remove separate printk_sched buffers and use printk buf instead")
Signed-off-by: Patrick Palka <patrick@parcs.ath.cx>
Reviewed-by: Petr Mladek <pmladek@suse.cz>
Reviewed-by: Jan Kara <jack@suse.cz>
Acked-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/printk/printk.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/kernel/printk/printk.c
+++ b/kernel/printk/printk.c
@@ -1617,15 +1617,15 @@ asmlinkage int vprintk_emit(int facility
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


