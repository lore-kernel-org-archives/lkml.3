Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753119AbaIPHhn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 03:37:43 -0400
Received: from mail-ob0-f177.google.com ([209.85.214.177]:34680 "EHLO
	mail-ob0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751740AbaIPHhm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 03:37:42 -0400
Date: Tue, 16 Sep 2014 02:37:36 -0500
From: Chuck Ebbert <cebbert.lkml@gmail.com>
To: Helge Deller <deller@gmx.de>
Cc: linux-kernel@vger.kernel.org, linux-parisc@vger.kernel.org,
        Aaron Tomlin <atomlin@redhat.com>,
        James Hogan <james.hogan@imgtec.com>
Subject: [PATCH] Fix end_of_stack() fn and location of stack canary for
 archs using STACK_GROWSUP
Message-ID: <20140916023736.49db964e@as>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Aaron Tomlin recently posted patches [1] to enable checking the stack canary on
every task switch. Looking at the canary code, I realized that every arch
(except ia64, which adds some space for register spill above the stack) shares a
definition of end_of_stack() that makes it the first long after the threadinfo.

For stacks that grow down, this low address is correct because the stack starts
at the end of the thread area and grows toward lower addresses. However, for
stacks that grow up, toward higher addresses, this is wrong. (The stack actually
grows away from the canary.) On these archs end_of_stack() should return the 
address of the last long, at the highest possible address for the stack.

[1] http://lkml.org/lkml/2014/9/12/293

Signed-off-by: Chuck Ebbert <cebbert.lkml@gmail.com>

---

Compile tested only, with Aaron's patches applied and the new option
CONFIG_SCHED_STACK_END_CHECK they add enabled. I have no way to test
this any further.

diff a/include/linux/sched.h b/include/linux/sched.h
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


