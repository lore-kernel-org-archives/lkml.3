Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754796AbaITPR6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Sep 2014 11:17:58 -0400
Received: from mail-oa0-f53.google.com ([209.85.219.53]:61984 "EHLO
	mail-oa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751558AbaITPR4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Sep 2014 11:17:56 -0400
Date: Sat, 20 Sep 2014 10:17:51 -0500
From: Chuck Ebbert <cebbert.lkml@gmail.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, james.hogan@imgtec.com,
        atomlin@redhat.com, tglx@linutronix.de
Subject: [PATCH v3] sched: Fix end_of_stack() and location of stack canary
 for architectures using CONFIG_STACK_GROWSUP
Message-ID: <20140920101751.6c5166b6@as>
In-Reply-To: <20140920142800.GA25366@gmail.com>
References: <20140919093505.62681e43@as>
	<tip-a3215fb47c7ecb814dc16815245db4f375841268@git.kernel.org>
	<20140920065810.794d6bbd@as>
	<20140920142800.GA25366@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Aaron Tomlin recently posted patches [1] to enable checking the stack
canary on every task switch. Looking at the canary code, I realized
that every arch (except ia64, which adds some space for register spill
above the stack) shares a definition of end_of_stack() that makes it
the first long after the threadinfo.

For stacks that grow down, this low address is correct because the stack starts
at the end of the thread area and grows toward lower addresses. However, for
stacks that grow up, toward higher addresses, this is wrong. (The stack actually
grows away from the canary.) On these archs end_of_stack() should return the 
address of the last long, at the highest possible address for the stack.

[1] http://lkml.org/lkml/2014/9/12/293

Signed-off-by: Chuck Ebbert <cebbert.lkml@gmail.com>
Tested-by: James Hogan <james.hogan@imgtec.com> [metag]
Acked-by: James Hogan <james.hogan@imgtec.com>
Acked-by: Aaron Tomlin <atomlin@redhat.com>
---

V3: Fix line length, add comment.

diff a/include/linux/sched.h b/include/linux/sched.h
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -2609,9 +2609,23 @@ static inline void setup_thread_stack(struct task_struct *p, struct task_struct
 	task_thread_info(p)->task = p;
 }
 
+/*
+ * Return the address of the last usable long on the stack.
+ *
+ * When the stack grows down, this is just above the thread
+ * info struct. Going any lower will corrupt the threadinfo.
+ *
+ * When the stack grows up, this is the highest address.
+ * Beyond that position, we corrupt data on the next page.
+ */
 static inline unsigned long *end_of_stack(struct task_struct *p)
 {
+#ifdef CONFIG_STACK_GROWSUP
+	return (unsigned long *)
+	       ((unsigned long)task_thread_info(p) + THREAD_SIZE) - 1;
+#else
 	return (unsigned long *)(task_thread_info(p) + 1);
+#endif
 }
 
 #endif
