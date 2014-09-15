Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753078AbaIOEXM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 00:23:12 -0400
Received: from mail-ob0-f195.google.com ([209.85.214.195]:41835 "EHLO
	mail-ob0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750831AbaIOEXL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 00:23:11 -0400
Date: Sun, 14 Sep 2014 23:23:05 -0500
From: Chuck Ebbert <cebbert.lkml@gmail.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: Aaron Tomlin <atomlin@redhat.com>, Helge Deller <deller@gmx.de>,
        James Hogan <james.hogan@imgtec.com>
Subject: [RFC/PATCH] Fix end_of_stack() and stack_not_used() for archs using
 CONFIG_STACK_GROWSUP
Message-ID: <20140914232305.5390b996@as>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When looking at Aaron's patches adding extra checks of the stack canary, I
realized the code almost certainly never worked if the stack grows up. Something
like this is needed, I think.

Not-Signed-Off-By: Chuck Ebbert <cebbert.lkml@gmail.com>

---

Not even compile tested.

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 5c2c885..da7f597 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -2610,7 +2610,11 @@ static inline void setup_thread_stack(struct task_struct *p, struct task_struct
 
 static inline unsigned long *end_of_stack(struct task_struct *p)
 {
+#ifdef CONFIG_STACK_GROWSUP
+	return (unsigned long *)((unsigned long)task_thread_info(p) + THREAD_SIZE) - 1;
+#else
 	return (unsigned long *)(task_thread_info(p) + 1);
+#endif
 }
 
 #endif
@@ -2629,13 +2633,21 @@ static inline unsigned long stack_not_used(struct task_struct *p)
 {
 	unsigned long *n = end_of_stack(p);
 
+#ifdef CONFIG_STACK_GROWSUP
+	do { 	/* Skip over canary */
+		n--;
+	} while (!*n);
+
+	return (unsigned long)end_of_stack(p) - (unsigned long)n;
+#else
 	do { 	/* Skip over canary */
 		n++;
 	} while (!*n);
 
 	return (unsigned long)n - (unsigned long)end_of_stack(p);
-}
 #endif
+}
+#endif /* CONFIG_DEBUG_STACK_USAGE */
 
 /* set thread flags in other task's structures
  * - see asm/thread_info.h for TIF_xxxx flags available


