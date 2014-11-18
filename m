Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932918AbaKRVbB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 16:31:01 -0500
Received: from mx1.redhat.com ([209.132.183.28]:56525 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932873AbaKRVa3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 16:30:29 -0500
Date: Tue, 18 Nov 2014 22:30:26 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Aaron Tomlin <atomlin@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Kay Sievers <kay@vrfy.org>,
        Lennart Poettering <lennart@poettering.net>,
        Sterling Alexander <stalexan@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 5/6] exit: reparent: introduce find_child_reaper()
Message-ID: <20141118213026.GA5030@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141118212952.GA4754@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

find_new_reaper() does 2 completely different things. Not only it
finds a reaper, it also updates pid_ns->child_reaper or kills the
whole namespace if the caller is ->child_reaper.

Now that has_child_subreaper logic doesn't depend on child_reaper
check we can move that pid_ns code into a separate helper. IMHO
this makes the code more clean, and this allows the next changes.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 kernel/exit.c |   56 +++++++++++++++++++++++++++++++++++---------------------
 1 files changed, 35 insertions(+), 21 deletions(-)

diff --git a/kernel/exit.c b/kernel/exit.c
index 266e4f4..00c6139 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -459,6 +459,34 @@ static void exit_mm(struct task_struct *tsk)
 	clear_thread_flag(TIF_MEMDIE);
 }
 
+static struct task_struct *find_child_reaper(struct task_struct *father)
+	__releases(&tasklist_lock)
+	__acquires(&tasklist_lock)
+{
+	struct pid_namespace *pid_ns = task_active_pid_ns(father);
+	struct task_struct *reaper = pid_ns->child_reaper;
+
+	if (likely(reaper != father))
+		return reaper;
+
+	for_each_thread(father, reaper) {
+		if (reaper->flags & PF_EXITING)
+			continue;
+		pid_ns->child_reaper = reaper;
+		return reaper;
+	}
+
+	write_unlock_irq(&tasklist_lock);
+	if (unlikely(pid_ns == &init_pid_ns)) {
+		panic("Attempted to kill init! exitcode=0x%08x\n",
+			father->signal->group_exit_code ?: father->exit_code);
+	}
+	zap_pid_ns_processes(pid_ns);
+	write_lock_irq(&tasklist_lock);
+
+	return father;
+}
+
 /*
  * When we die, we re-parent all our children, and try to:
  * 1. give them to another thread in our thread group, if such a member exists
@@ -466,33 +494,17 @@ static void exit_mm(struct task_struct *tsk)
  *    child_subreaper for its children (like a service manager)
  * 3. give it to the init process (PID 1) in our pid namespace
  */
-static struct task_struct *find_new_reaper(struct task_struct *father)
-	__releases(&tasklist_lock)
-	__acquires(&tasklist_lock)
+static struct task_struct *find_new_reaper(struct task_struct *father,
+					   struct task_struct *child_reaper)
 {
-	struct pid_namespace *pid_ns = task_active_pid_ns(father);
 	struct task_struct *thread;
 
 	for_each_thread(father, thread) {
 		if (thread->flags & PF_EXITING)
 			continue;
-		if (unlikely(pid_ns->child_reaper == father))
-			pid_ns->child_reaper = thread;
 		return thread;
 	}
 
-	if (unlikely(pid_ns->child_reaper == father)) {
-		write_unlock_irq(&tasklist_lock);
-		if (unlikely(pid_ns == &init_pid_ns)) {
-			panic("Attempted to kill init! exitcode=0x%08x\n",
-				father->signal->group_exit_code ?:
-					father->exit_code);
-		}
-
-		zap_pid_ns_processes(pid_ns);
-		write_lock_irq(&tasklist_lock);
-	}
-
 	if (father->signal->has_child_subreaper) {
 		struct task_struct *reaper;
 		/*
@@ -501,7 +513,7 @@ static struct task_struct *find_new_reaper(struct task_struct *father)
 		 * namespace, this is safe because all its threads are dead.
 		 */
 		for (reaper = father;
-		     !same_thread_group(reaper, pid_ns->child_reaper);
+		     !same_thread_group(reaper, child_reaper);
 		     reaper = reaper->real_parent) {
 			/* call_usermodehelper() descendants need this check */
 			if (reaper == &init_task)
@@ -515,7 +527,7 @@ static struct task_struct *find_new_reaper(struct task_struct *father)
 		}
 	}
 
-	return pid_ns->child_reaper;
+	return child_reaper;
 }
 
 /*
@@ -552,7 +564,9 @@ static void forget_original_parent(struct task_struct *father)
 		exit_ptrace(father, &dead_children);
 
 	/* Can drop and reacquire tasklist_lock */
-	reaper = find_new_reaper(father);
+	reaper = find_child_reaper(father);
+
+	reaper = find_new_reaper(father, reaper);
 	list_for_each_entry(p, &father->children, sibling) {
 		for_each_thread(p, t) {
 			t->real_parent = reaper;
-- 
1.5.5.1

