Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751725AbaDRAYp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 20:24:45 -0400
Received: from smtp.outflux.net ([198.145.64.163]:42873 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751132AbaDRAYf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 20:24:35 -0400
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>, Andy Lutomirski <luto@amacapital.net>,
        Oleg Nesterov <oleg@redhat.com>,
        John Johansen <john.johansen@canonical.com>,
        Will Drewry <wad@chromium.org>, Julien Tinnes <jln@chromium.org>,
        linux-doc@vger.kernel.org, linux-security-module@vger.kernel.org
Subject: [PATCH v3 1/5] seccomp: introduce writer locking
Date: Thu, 17 Apr 2014 17:24:16 -0700
Message-Id: <1397780660-24750-2-git-send-email-keescook@chromium.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1397780660-24750-1-git-send-email-keescook@chromium.org>
References: <1397780660-24750-1-git-send-email-keescook@chromium.org>
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Normally, task_struck.seccomp.filter is only ever read or modified by
the task that owns it (current). This property aids in fast access
during system call filtering as read access is lockless.

Updating the pointer from another task, however, opens up race
conditions. To allow cross-task filter pointer updates, writes to the
seccomp fields are now protected via a spinlock.  Read access remains
lockless because pointer updates themselves are atomic.  However, writes
(or cloning) often entail additional checking (like maximum instruction
counts) which require locking to perform safely.

In the case of cloning threads, the child is invisible to the system
until it enters the task list. To make sure a child can't be cloned
from a thread and left in a prior state, seccomp duplication is moved
under the tasklist_lock. Then parent and child are certain have the same
seccomp state when they exit the lock.

Based on patches by Will Drewry.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 include/linux/init_task.h |    8 ++++++++
 include/linux/sched.h     |   18 ++++++++++++++++++
 include/linux/seccomp.h   |    6 ++++--
 kernel/fork.c             |   33 ++++++++++++++++++++++++++++++++-
 kernel/seccomp.c          |   13 ++++++++-----
 5 files changed, 70 insertions(+), 8 deletions(-)

diff --git a/include/linux/init_task.h b/include/linux/init_task.h
index 6df7f9fe0d01..e2370ec3102b 100644
--- a/include/linux/init_task.h
+++ b/include/linux/init_task.h
@@ -154,6 +154,13 @@ extern struct task_group root_task_group;
 # define INIT_VTIME(tsk)
 #endif
 
+#ifdef CONFIG_SECCOMP
+# define INIT_SECCOMP(tsk)						\
+	.seccomp.lock	= __SPIN_LOCK_UNLOCKED(tsk.seccomp.lock),
+#else
+# define INIT_SECCOMP(tsk)
+#endif
+
 #define INIT_TASK_COMM "swapper"
 
 #ifdef CONFIG_RT_MUTEXES
@@ -234,6 +241,7 @@ extern struct task_group root_task_group;
 	INIT_CPUSET_SEQ(tsk)						\
 	INIT_RT_MUTEXES(tsk)						\
 	INIT_VTIME(tsk)							\
+	INIT_SECCOMP(tsk)						\
 }
 
 
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 25f54c79f757..50a21e527eb2 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -2480,6 +2480,24 @@ static inline void task_unlock(struct task_struct *p)
 	spin_unlock(&p->alloc_lock);
 }
 
+#ifdef CONFIG_SECCOMP
+/*
+ * Protects changes to ->seccomp
+ */
+static inline void seccomp_lock(struct task_struct *p)
+{
+	spin_lock(&p->seccomp.lock);
+}
+
+static inline void seccomp_unlock(struct task_struct *p)
+{
+	spin_unlock(&p->seccomp.lock);
+}
+#else
+static inline void seccomp_lock(struct task_struct *p) { }
+static inline void seccomp_unlock(struct task_struct *p) { }
+#endif
+
 extern struct sighand_struct *__lock_task_sighand(struct task_struct *tsk,
 							unsigned long *flags);
 
diff --git a/include/linux/seccomp.h b/include/linux/seccomp.h
index 4054b0994071..c47be00e8ffb 100644
--- a/include/linux/seccomp.h
+++ b/include/linux/seccomp.h
@@ -14,14 +14,16 @@ struct seccomp_filter;
  *
  * @mode:  indicates one of the valid values above for controlled
  *         system calls available to a process.
- * @filter: The metadata and ruleset for determining what system calls
- *          are allowed for a task.
+ * @lock:  held when making changes to avoid thread races.
+ * @filter: must always point to a valid seccomp-filter or NULL as it is
+ *          accessed without locking during system call entry.
  *
  *          @filter must only be accessed from the context of current as there
  *          is no locking.
  */
 struct seccomp {
 	int mode;
+	spinlock_t lock;
 	struct seccomp_filter *filter;
 };
 
diff --git a/kernel/fork.c b/kernel/fork.c
index 54a8d26f612f..b33f886fe3a1 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -315,6 +315,15 @@ static struct task_struct *dup_task_struct(struct task_struct *orig)
 		goto free_ti;
 
 	tsk->stack = ti;
+#ifdef CONFIG_SECCOMP
+	/*
+	 * We must handle setting up seccomp filters once we're under
+	 * the tasklist_lock in case orig has changed between now and
+	 * then. Until then, filter must be NULL to avoid messing up
+	 * the usage counts on the error path calling free_task.
+	 */
+	tsk->seccomp.filter = NULL;
+#endif
 
 	setup_thread_stack(tsk, orig);
 	clear_user_return_notifier(tsk);
@@ -1081,6 +1090,23 @@ static int copy_signal(unsigned long clone_flags, struct task_struct *tsk)
 	return 0;
 }
 
+static void copy_seccomp(struct task_struct *p)
+{
+#ifdef CONFIG_SECCOMP
+	/* Child lock not needed since it is not yet in tasklist. */
+	seccomp_lock(current);
+
+	get_seccomp_filter(current);
+	p->seccomp = current->seccomp;
+	spin_lock_init(&p->seccomp.lock);
+
+	if (p->seccomp.mode != SECCOMP_MODE_DISABLED)
+		set_tsk_thread_flag(p, TIF_SECCOMP);
+
+	seccomp_unlock(current);
+#endif
+}
+
 SYSCALL_DEFINE1(set_tid_address, int __user *, tidptr)
 {
 	current->clear_child_tid = tidptr;
@@ -1196,7 +1222,6 @@ static struct task_struct *copy_process(unsigned long clone_flags,
 		goto fork_out;
 
 	ftrace_graph_init_task(p);
-	get_seccomp_filter(p);
 
 	rt_mutex_init_task(p);
 
@@ -1425,6 +1450,12 @@ static struct task_struct *copy_process(unsigned long clone_flags,
 	 */
 	write_lock_irq(&tasklist_lock);
 
+	/*
+	 * Copy seccomp details explicitly here, in case they were changed
+	 * before holding tasklist_lock.
+	 */
+	copy_seccomp(p);
+
 	/* CLONE_PARENT re-uses the old parent */
 	if (clone_flags & (CLONE_PARENT|CLONE_THREAD)) {
 		p->real_parent = current->real_parent;
diff --git a/kernel/seccomp.c b/kernel/seccomp.c
index 590c37925084..6d61a0b5080c 100644
--- a/kernel/seccomp.c
+++ b/kernel/seccomp.c
@@ -174,12 +174,12 @@ static int seccomp_check_filter(struct sock_filter *filter, unsigned int flen)
  */
 static u32 seccomp_run_filters(int syscall)
 {
-	struct seccomp_filter *f;
+	struct seccomp_filter *f = ACCESS_ONCE(current->seccomp.filter);
 	struct seccomp_data sd;
 	u32 ret = SECCOMP_RET_ALLOW;
 
 	/* Ensure unexpected behavior doesn't result in failing open. */
-	if (WARN_ON(current->seccomp.filter == NULL))
+	if (WARN_ON(f == NULL))
 		return SECCOMP_RET_KILL;
 
 	populate_seccomp_data(&sd);
@@ -188,7 +188,7 @@ static u32 seccomp_run_filters(int syscall)
 	 * All filters in the list are evaluated and the lowest BPF return
 	 * value always takes priority (ignoring the DATA).
 	 */
-	for (f = current->seccomp.filter; f; f = f->prev) {
+	for (; f; f = ACCESS_ONCE(f->prev)) {
 		u32 cur_ret = sk_run_filter_int_seccomp(&sd, f->insnsi);
 		if ((cur_ret & SECCOMP_RET_ACTION) < (ret & SECCOMP_RET_ACTION))
 			ret = cur_ret;
@@ -313,7 +313,7 @@ out:
 /* get_seccomp_filter - increments the reference count of the filter on @tsk */
 void get_seccomp_filter(struct task_struct *tsk)
 {
-	struct seccomp_filter *orig = tsk->seccomp.filter;
+	struct seccomp_filter *orig = ACCESS_ONCE(tsk->seccomp.filter);
 	if (!orig)
 		return;
 	/* Reference count is bounded by the number of total processes. */
@@ -327,7 +327,7 @@ void put_seccomp_filter(struct task_struct *tsk)
 	/* Clean up single-reference branches iteratively. */
 	while (orig && atomic_dec_and_test(&orig->usage)) {
 		struct seccomp_filter *freeme = orig;
-		orig = orig->prev;
+		orig = ACCESS_ONCE(orig->prev);
 		kfree(freeme);
 	}
 }
@@ -480,6 +480,8 @@ long prctl_set_seccomp(unsigned long seccomp_mode, char __user *filter)
 {
 	long ret = -EINVAL;
 
+	seccomp_lock(current);
+
 	if (current->seccomp.mode &&
 	    current->seccomp.mode != seccomp_mode)
 		goto out;
@@ -505,5 +507,6 @@ long prctl_set_seccomp(unsigned long seccomp_mode, char __user *filter)
 	current->seccomp.mode = seccomp_mode;
 	set_thread_flag(TIF_SECCOMP);
 out:
+	seccomp_unlock(current);
 	return ret;
 }
-- 
1.7.9.5

