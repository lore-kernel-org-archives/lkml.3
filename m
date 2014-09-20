Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757275AbaITRqH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Sep 2014 13:46:07 -0400
Received: from terminus.zytor.com ([198.137.202.10]:41073 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755665AbaITRqG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Sep 2014 13:46:06 -0400
Date: Sat, 20 Sep 2014 10:45:35 -0700
From: tip-bot for Chuck Ebbert <tipbot@zytor.com>
Message-ID: <tip-6a40281ab5c1ed8ba2253857118a5d400a2d084b@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        cebbert.lkml@gmail.com, james.hogan@imgtec.com, atomlin@redhat.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        cebbert.lkml@gmail.com, james.hogan@imgtec.com, tglx@linutronix.de,
        atomlin@redhat.com
In-Reply-To: <20140920101751.6c5166b6@as>
References: <20140920101751.6c5166b6@as>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/urgent] sched: Fix end_of_stack()
  and location of stack canary for architectures using CONFIG_STACK_GROWSUP
Git-Commit-ID: 6a40281ab5c1ed8ba2253857118a5d400a2d084b
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

Commit-ID:  6a40281ab5c1ed8ba2253857118a5d400a2d084b
Gitweb:     http://git.kernel.org/tip/6a40281ab5c1ed8ba2253857118a5d400a2d084b
Author:     Chuck Ebbert <cebbert.lkml@gmail.com>
AuthorDate: Sat, 20 Sep 2014 10:17:51 -0500
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Sat, 20 Sep 2014 19:44:04 +0200

sched: Fix end_of_stack() and location of stack canary for architectures using CONFIG_STACK_GROWSUP

Aaron Tomlin recently posted patches [1] to enable checking the
stack canary on every task switch. Looking at the canary code, I
realized that every arch (except ia64, which adds some space for
register spill above the stack) shares a definition of
end_of_stack() that makes it the first long after the
threadinfo.

For stacks that grow down, this low address is correct because
the stack starts at the end of the thread area and grows toward
lower addresses. However, for stacks that grow up, toward higher
addresses, this is wrong. (The stack actually grows away from
the canary.) On these archs end_of_stack() should return the
address of the last long, at the highest possible address for the stack.

[1] http://lkml.org/lkml/2014/9/12/293

Signed-off-by: Chuck Ebbert <cebbert.lkml@gmail.com>
Link: http://lkml.kernel.org/r/20140920101751.6c5166b6@as
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Tested-by: James Hogan <james.hogan@imgtec.com> [metag]
Acked-by: James Hogan <james.hogan@imgtec.com>
Acked-by: Aaron Tomlin <atomlin@redhat.com>
---
 include/linux/sched.h | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 5c2c885..1f07040 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -2608,9 +2608,22 @@ static inline void setup_thread_stack(struct task_struct *p, struct task_struct
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
+	return (unsigned long *)((unsigned long)task_thread_info(p) + THREAD_SIZE) - 1;
+#else
 	return (unsigned long *)(task_thread_info(p) + 1);
+#endif
 }
 
 #endif
