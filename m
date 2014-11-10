Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753056AbaKJWAw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 17:00:52 -0500
Received: from mx1.redhat.com ([209.132.183.28]:52361 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752392AbaKJWAt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 17:00:49 -0500
Date: Mon, 10 Nov 2014 23:00:38 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Aaron Tomlin <atomlin@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Roland McGrath <roland@hack.frob.com>,
        Sterling Alexander <stalexan@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 5/5] exit: ptrace: shift "reap dead" code from
	exit_ptrace() to forget_original_parent()
Message-ID: <20141110220038.GA31247@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141110215959.GA31106@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that forget_original_parent() uses ->ptrace_entry for EXIT_DEAD
tasks, we can simply pass "dead_children" list to exit_ptrace() and
remove another release_task() loop. Plus this way we do not need to
drop and reacquire tasklist_lock.

Also shift the list_empty(ptraced) check, if we want this optimization
it makes sense to eliminate the function call altogether.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 include/linux/ptrace.h |    2 +-
 kernel/exit.c          |   10 ++++------
 kernel/ptrace.c        |   23 +++--------------------
 3 files changed, 8 insertions(+), 27 deletions(-)

diff --git a/include/linux/ptrace.h b/include/linux/ptrace.h
index cc79eff..987a73a 100644
--- a/include/linux/ptrace.h
+++ b/include/linux/ptrace.h
@@ -52,7 +52,7 @@ extern void ptrace_notify(int exit_code);
 extern void __ptrace_link(struct task_struct *child,
 			  struct task_struct *new_parent);
 extern void __ptrace_unlink(struct task_struct *child);
-extern void exit_ptrace(struct task_struct *tracer);
+extern void exit_ptrace(struct task_struct *tracer, struct list_head *dead);
 #define PTRACE_MODE_READ	0x01
 #define PTRACE_MODE_ATTACH	0x02
 #define PTRACE_MODE_NOAUDIT	0x04
diff --git a/kernel/exit.c b/kernel/exit.c
index e3e7379..ee5399b 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -553,13 +553,11 @@ static void forget_original_parent(struct task_struct *father)
 	LIST_HEAD(dead_children);
 
 	write_lock_irq(&tasklist_lock);
-	/*
-	 * Note that exit_ptrace() and find_new_reaper() might
-	 * drop tasklist_lock and reacquire it.
-	 */
-	exit_ptrace(father);
-	reaper = find_new_reaper(father);
+	if (unlikely(!list_empty(&father->ptraced)))
+		exit_ptrace(father, &dead_children);
 
+	/* Can drop and reacquire tasklist_lock */
+	reaper = find_new_reaper(father);
 	list_for_each_entry(p, &father->children, sibling) {
 		for_each_thread(p, t) {
 			t->real_parent = reaper;
diff --git a/kernel/ptrace.c b/kernel/ptrace.c
index 54e7522..1eb9d90 100644
--- a/kernel/ptrace.c
+++ b/kernel/ptrace.c
@@ -485,36 +485,19 @@ static int ptrace_detach(struct task_struct *child, unsigned int data)
 
 /*
  * Detach all tasks we were using ptrace on. Called with tasklist held
- * for writing, and returns with it held too. But note it can release
- * and reacquire the lock.
+ * for writing.
  */
-void exit_ptrace(struct task_struct *tracer)
-	__releases(&tasklist_lock)
-	__acquires(&tasklist_lock)
+void exit_ptrace(struct task_struct *tracer, struct list_head *dead)
 {
 	struct task_struct *p, *n;
-	LIST_HEAD(ptrace_dead);
-
-	if (likely(list_empty(&tracer->ptraced)))
-		return;
 
 	list_for_each_entry_safe(p, n, &tracer->ptraced, ptrace_entry) {
 		if (unlikely(p->ptrace & PT_EXITKILL))
 			send_sig_info(SIGKILL, SEND_SIG_FORCED, p);
 
 		if (__ptrace_detach(tracer, p))
-			list_add(&p->ptrace_entry, &ptrace_dead);
-	}
-
-	write_unlock_irq(&tasklist_lock);
-	BUG_ON(!list_empty(&tracer->ptraced));
-
-	list_for_each_entry_safe(p, n, &ptrace_dead, ptrace_entry) {
-		list_del_init(&p->ptrace_entry);
-		release_task(p);
+			list_add(&p->ptrace_entry, dead);
 	}
-
-	write_lock_irq(&tasklist_lock);
 }
 
 int ptrace_readdata(struct task_struct *tsk, unsigned long src, char __user *dst, int len)
-- 
1.5.5.1

