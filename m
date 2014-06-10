Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752146AbaFJMbW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 08:31:22 -0400
Received: from mail-lb0-f177.google.com ([209.85.217.177]:43572 "EHLO
	mail-lb0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750906AbaFJMbU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 08:31:20 -0400
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>, Rik van Riel <riel@redhat.com>,
        David Rientjes <rientjes@google.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Davidlohr Bueso <davidlohr@hp.com>,
        Michal Simek <michal.simek@xilinx.com>
Cc: linux-kernel@vger.kernel.org, Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: [PATCH 1/2] wait: Introduce per-task wait_queue_t
Date: Tue, 10 Jun 2014 14:29:18 +0200
Message-Id: <1402403359-6023-2-git-send-email-linux@rasmusvillemoes.dk>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1402403359-6023-1-git-send-email-linux@rasmusvillemoes.dk>
References: <CA+55aFyYQES1CbEfYzRkFas_aw=+YNSbDoLRJpjh2sDFxVV3vg@mail.gmail.com>
 <1402403359-6023-1-git-send-email-linux@rasmusvillemoes.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This introduces a single wait_queue_t into the task structure.
Functions which need to wait, but which do not call other functions
that might wait while on the wait queue, may use current->__wq for
bookkeeping instead of allocating an instance on the stack. To help
ensure that the users are indeed "leaf waiters", make all access
through two helper functions.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
---
 include/linux/sched.h | 23 +++++++++++++++++++++++
 include/linux/wait.h  |  1 +
 kernel/fork.c         |  1 +
 3 files changed, 25 insertions(+)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 221b2bd..c7c97fe 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1303,6 +1303,15 @@ struct task_struct {
 	struct list_head thread_group;
 	struct list_head thread_node;
 
+	/*
+	 * "Leaf" waiters may use this instead of allocating a
+	 * wait_queue_t on the stack. To help ensure exclusive use of
+	 * __wq, one should use the helper functions current_wq_get(),
+	 * current_wq_put() below. Leaf waiters include the
+	 * wait_event_* macros.
+	 */
+	wait_queue_t __wq;
+
 	struct completion *vfork_done;		/* for vfork() */
 	int __user *set_child_tid;		/* CLONE_CHILD_SETTID */
 	int __user *clear_child_tid;		/* CLONE_CHILD_CLEARTID */
@@ -1612,6 +1621,20 @@ struct task_struct {
 #endif
 };
 
+static inline wait_queue_t *current_wq_get(void)
+{
+	wait_queue_t *wq = &current->__wq;
+	BUG_ON(wq->flags != WQ_FLAG_AVAILABLE);
+	wq->flags = 0;
+	return wq;
+}
+static inline void current_wq_put(wait_queue_t *wq)
+{
+	BUG_ON(wq != &current->__wq);
+	wq->flags = WQ_FLAG_AVAILABLE;
+}
+
+
 /* Future-safe accessor for struct task_struct's cpus_allowed. */
 #define tsk_cpus_allowed(tsk) (&(tsk)->cpus_allowed)
 
diff --git a/include/linux/wait.h b/include/linux/wait.h
index bd68819..94279be 100644
--- a/include/linux/wait.h
+++ b/include/linux/wait.h
@@ -16,6 +16,7 @@ int default_wake_function(wait_queue_t *wait, unsigned mode, int flags, void *ke
 struct __wait_queue {
 	unsigned int		flags;
 #define WQ_FLAG_EXCLUSIVE	0x01
+#define WQ_FLAG_AVAILABLE	0x80000000U
 	void			*private;
 	wait_queue_func_t	func;
 	struct list_head	task_list;
diff --git a/kernel/fork.c b/kernel/fork.c
index 54a8d26..7166955 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1315,6 +1315,7 @@ static struct task_struct *copy_process(unsigned long clone_flags,
 	p->sequential_io	= 0;
 	p->sequential_io_avg	= 0;
 #endif
+	p->__wq.flags = WQ_FLAG_AVAILABLE;
 
 	/* Perform scheduler related setup. Assign this task to a CPU. */
 	retval = sched_fork(clone_flags, p);
-- 
1.9.2

