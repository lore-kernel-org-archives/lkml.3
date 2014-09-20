Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755237AbaITGnO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Sep 2014 02:43:14 -0400
Received: from terminus.zytor.com ([198.137.202.10]:36879 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752000AbaITGnM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Sep 2014 02:43:12 -0400
Date: Fri, 19 Sep 2014 23:42:37 -0700
From: tip-bot for Chuck Ebbert <tipbot@zytor.com>
Message-ID: <tip-a3215fb47c7ecb814dc16815245db4f375841268@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        cebbert.lkml@gmail.com, james.hogan@imgtec.com, atomlin@redhat.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        cebbert.lkml@gmail.com, james.hogan@imgtec.com, tglx@linutronix.de,
        atomlin@redhat.com
In-Reply-To: <20140919093505.62681e43@as>
References: <20140919093505.62681e43@as>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/urgent] sched: Fix end_of_stack()
  and location of stack canary for architectures using CONFIG_STACK_GROWSUP
Git-Commit-ID: a3215fb47c7ecb814dc16815245db4f375841268
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a3215fb47c7ecb814dc16815245db4f375841268
Gitweb:     http://git.kernel.org/tip/a3215fb47c7ecb814dc16815245db4f375841268
Author:     Chuck Ebbert <cebbert.lkml@gmail.com>
AuthorDate: Fri, 19 Sep 2014 09:35:05 -0500
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Sat, 20 Sep 2014 08:38:16 +0200

sched: Fix end_of_stack() and location of stack canary for architectures using CONFIG_STACK_GROWSUP

Aaron Tomlin recently posted patches to enable checking the
stack canary on every task switch:

  http://lkml.org/lkml/2014/9/12/293

Looking at the canary code, I realized that every arch
(except ia64, which adds some space for register spill
above the stack) shares a definition of end_of_stack()
that makes it the first long after the threadinfo.

For stacks that grow down, this low address is correct
because the stack starts at the end of the thread area
and grows toward lower addresses. However, for stacks
that grow up, toward higher addresses, this is wrong.
(The stack actually grows away from the canary.)

On these archs end_of_stack() should return the address
of the last long, at the highest possible address for
the stack.

Signed-off-by: Chuck Ebbert <cebbert.lkml@gmail.com>
Tested-by: James Hogan <james.hogan@imgtec.com> [metag]
Acked-by: James Hogan <james.hogan@imgtec.com>
Acked-by: Aaron Tomlin <atomlin@redhat.com>
Link: http://lkml.kernel.org/r/20140919093505.62681e43@as
[ Added comments to end_of_stack(). ]
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 include/linux/sched.h | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 5c2c885..0e20a24 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -2608,9 +2608,22 @@ static inline void setup_thread_stack(struct task_struct *p, struct task_struct
 	task_thread_info(p)->task = p;
 }
 
+/*
+ * Return the address of the first long before (or after,
+ * depending on the architecture's default stack growth
+ * direction) * a task's task_info structure, which is the
+ * kernel stack's last usable spot.
+ *
+ * This is the point of no return, if the stack grows
+ * beyond that position, we corrupt the task's state.
+ */
 static inline unsigned long *end_of_stack(struct task_struct *p)
 {
+#ifdef CONFIG_STACK_GROWSUP
+	return (unsigned long *)((unsigned long)task_thread_info(p) + THREAD_SIZE) - 1;
+#else
 	return (unsigned long *)(task_thread_info(p) + 1);
+#endif
 }
 
 #endif
