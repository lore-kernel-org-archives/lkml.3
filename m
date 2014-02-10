Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752594AbaBJNoS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 08:44:18 -0500
Received: from www262.sakura.ne.jp ([202.181.97.72]:59072 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751779AbaBJNoQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 08:44:16 -0500
X-Nat-Received: from [202.181.97.72]:62521 [ident-empty]
	by smtp-proxy.isp with TPROXY id 1392039803.12300
To: akpm@linux-foundation.org
Cc: joe@perches.com, keescook@chromium.org, geert@linux-m68k.org,
        jkosina@suse.cz, viro@zeniv.linux.org.uk, davem@davemloft.net,
        linux-kernel@vger.kernel.org
Subject: [PATCH (draft)] Change task_struct->comm to use RCU.
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <201402072303.DJD13007.JFFMSLHOOFQOtV@I-love.SAKURA.ne.jp>
	<20140207140536.943daf965008b9428cdcb468@linux-foundation.org>
	<201402081055.BGJ73403.tQMLFVOJSOOFFH@I-love.SAKURA.ne.jp>
	<20140207180647.5944fe3d.akpm@linux-foundation.org>
	<201402092327.JAD12489.QOLSFVMHJtFOOF@I-love.SAKURA.ne.jp>
In-Reply-To: <201402092327.JAD12489.QOLSFVMHJtFOOF@I-love.SAKURA.ne.jp>
Message-Id: <201402102243.IEJ52676.JOFVMOQFOFSLtH@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Mon, 10 Feb 2014 22:43:19 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for Linux Mail Server 5.6.45.2/RELEASE, bases: 10022014 #7499336, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Tetsuo Handa wrote:
> I think there is some point in applying the preparatory patches (commcpy() and
> %pT patches) now, for they fix time-to-call-strlen()-to-time-to-call-memcpy()
> problem by making sure that the comm string passed to strlen() etc. is also
> passed to memcpy() etc. by taking a snapshot of the comm string.
> 
> What the preparatory patches cannot fix is that the comm string is modified
> while taking a snapshot of the comm string. The RCU work will fix it.
> 
> Anyway, you want to see the RCU work before you merge commcpy() and %pT
> patches. OK. I'll start making the RCU work.

This is a draft patch which changes task_struct->comm to use RCU.

This patch currently does not build, for this patch can be applied only after
commcpy() and %pT patches are merged and all direct ->comm users are killed.

This patch sleeps when kmalloc() fails when changing task_struct->comm. But are
we allowed to sleep when changing task_struct->comm ? If yes, there is no need
to rename set_task_comm() to commset() in this patch. If no, I need to find a
different answer.

Regards.
----------
>From c1d907a109a5407c7eaf0e81741f99b4715ba55d Mon Sep 17 00:00:00 2001
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Date: Mon, 10 Feb 2014 19:25:51 +0900
Subject: [PATCH (draft)] Change task_struct->comm to use RCU.

This patch guarantees that the task_struct->comm is updated atomically.

Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
---
 fs/exec.c                 |   94 ++++++++++++++++++++++++++++++++++++++------
 fs/proc/base.c            |    2 +-
 include/linux/init_task.h |    4 +-
 include/linux/sched.h     |   35 ++++++++++++++---
 kernel/fork.c             |   11 +++++
 kernel/kthread.c          |    6 ++-
 kernel/sched/core.c       |    7 +++-
 kernel/sys.c              |    2 +-
 8 files changed, 135 insertions(+), 26 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 69c6089..d71fd63 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -263,6 +263,11 @@ extern char ___assert_task_state[1 - 2*!!(
 
 /* Task command name length */
 #define TASK_COMM_LEN 16
+struct rcu_comm {
+	char name[TASK_COMM_LEN];
+	struct rcu_head rcu;
+	bool is_static;
+};
 
 #include <linux/spinlock.h>
 
@@ -1317,10 +1322,11 @@ struct task_struct {
 					 * credentials (COW) */
 	const struct cred __rcu *cred;	/* effective (overridable) subjective task
 					 * credentials (COW) */
-	char comm[TASK_COMM_LEN]; /* executable name excluding path
-				     - access with [gs]et_task_comm (which lock
-				       it with task_lock())
-				     - initialized normally by setup_new_exec */
+	struct rcu_comm __rcu *rcu_comm; /* executable name excluding path
+					    - update with commset()
+					    - read with commcpy() or %pT
+					    - initialized normally by
+					      setup_new_exec */
 /* file system info */
 	int link_count, total_link_count;
 #ifdef CONFIG_SYSVIPC
@@ -1805,6 +1811,23 @@ static inline cputime_t task_gtime(struct task_struct *t)
 extern void task_cputime_adjusted(struct task_struct *p, cputime_t *ut, cputime_t *st);
 extern void thread_group_cputime_adjusted(struct task_struct *p, cputime_t *ut, cputime_t *st);
 
+/**
+ * commcpy - Copy task_struct->comm to buffer.
+ *
+ * @buf: Buffer to copy @tsk->comm which must be at least TASK_COMM_LEN bytes.
+ * @tsk: Pointer to "struct task_struct".
+ *
+ * Returns @buf .
+ */
+static inline char *commcpy(char *buf, const struct task_struct *tsk)
+{
+	rcu_read_lock();
+	memcpy(buf, rcu_dereference(p->rcu_comm)->name, TASK_COMM_LEN);
+	rcu_read_unlock();
+	buf[TASK_COMM_LEN - 1] = '\0';
+	return buf;
+}
+
 /*
  * Per process flags
  */
@@ -2332,8 +2355,8 @@ extern long do_fork(unsigned long, unsigned long, unsigned long, int __user *, i
 struct task_struct *fork_idle(int);
 extern pid_t kernel_thread(int (*fn)(void *), void *arg, unsigned long flags);
 
-extern void set_task_comm(struct task_struct *tsk, char *from);
-extern char *get_task_comm(char *to, struct task_struct *tsk);
+void do_commset(struct task_struct *tsk, const char *buf);
+void commset(struct task_struct *tsk, const char *buf);
 
 #ifdef CONFIG_SMP
 void scheduler_ipi(void);
diff --git a/include/linux/init_task.h b/include/linux/init_task.h
index 6df7f9f..b217f8c 100644
--- a/include/linux/init_task.h
+++ b/include/linux/init_task.h
@@ -154,7 +154,7 @@ extern struct task_group root_task_group;
 # define INIT_VTIME(tsk)
 #endif
 
-#define INIT_TASK_COMM "swapper"
+extern struct rcu_comm init_rcu_comm;
 
 #ifdef CONFIG_RT_MUTEXES
 # define INIT_RT_MUTEXES(tsk)						\
@@ -201,7 +201,7 @@ extern struct task_group root_task_group;
 	.group_leader	= &tsk,						\
 	RCU_POINTER_INITIALIZER(real_cred, &init_cred),			\
 	RCU_POINTER_INITIALIZER(cred, &init_cred),			\
-	.comm		= INIT_TASK_COMM,				\
+	.rcu_comm       = &init_rcu_comm,				\
 	.thread		= INIT_THREAD,					\
 	.fs		= &init_fs,					\
 	.files		= &init_files,					\
diff --git a/fs/exec.c b/fs/exec.c
index 3d78fcc..8c2b1c3 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -67,6 +67,9 @@
 
 int suid_dumpable = 0;
 
+/* comm name for init_task. */
+struct rcu_comm init_rcu_comm = { .name = "swapper", .is_static = 1 };
+
 static LIST_HEAD(formats);
 static DEFINE_RWLOCK(binfmt_lock);
 
@@ -1026,27 +1029,92 @@ killed:
 	return -EAGAIN;
 }
 
-char *get_task_comm(char *buf, struct task_struct *tsk)
-{
-	/* buf must be at least sizeof(tsk->comm) in size */
-	task_lock(tsk);
-	strncpy(buf, tsk->comm, sizeof(tsk->comm));
-	task_unlock(tsk);
-	return buf;
-}
-EXPORT_SYMBOL_GPL(get_task_comm);
-
 /*
  * These functions flushes out all traces of the currently running executable
  * so that a new one can be started
  */
 
-void set_task_comm(struct task_struct *tsk, char *buf)
+/**
+ * do_commset - Change task_struct->comm.
+ *
+ * @tsk: Pointer to "struct task_struct".
+ * @buf: New comm name.
+ *
+ * Returns nothing.
+ *
+ * This function will sleep if kmalloc() failed.
+ *
+ * Question: Are we allowed to sleep?
+ */
+void do_commset(struct task_struct *tsk, const char *buf)
+{
+	struct rcu_comm *new;
+	struct rcu_comm *old;
+	struct rcu_comm tmp;
+
+	new = kzalloc(sizeof(*new), GFP_KERNEL | __GFP_NOWARN);
+	if (likely(new)) {
+		strncpy(new->name, buf, TASK_COMM_LEN - 1);
+		/* No need to wait because the "new" is kmalloc()ed. */
+		smp_wmb();
+		old = xchg(tsk->rcu_comm, new);
+	} else {
+		/* Memory allocation failed. Use slowpath. */
+		static DEFINE_MUTEX(lock);
+
+		memset(&tmp, 0, sizeof(tmp));
+		tmp.is_static = 1;
+		strncpy(tmp.name, buf, TASK_COMM_LEN - 1);
+		mutex_lock(&lock);
+		/*
+		 * Publish the "tmp" rcu_comm.
+		 * The mutex_lock() above guarantees that the "new" obtained by
+		 * the xchg() below refers either kmemdup()ed rcu_comm as of
+		 * copy_process() or kmalloc()ed rcu_comm as of commset().
+		 */
+		smp_wmb();
+		new = xchg(tsk->rcu_comm, &tmp);
+		/* Wait for readers of the "new" rcu_comm. */
+		synchronize_rcu();
+		/* Reuse the "new" rcu_comm. */
+		memcpy(new->name, tmp.name, TASK_COMM_LEN);
+		/* Publish the "new" rcu_comm. */
+		smp_wmb();
+		old = xchg(tsk->rcu_comm, new);
+		/*
+		 * Wait for readers of the "old" rcu_comm. Note that
+		 * old == &tmp will be false if kmalloc() above by somebody
+		 * else succeeded. Therefore, use the .is_static flag to
+		 * determine whether to kfree() or not.
+		 */
+		synchronize_rcu();
+		mutex_unlock(&lock);
+	}
+	if (!old->is_static)
+		kfree_rcu(old, rcu);
+}
+
+/**
+ * commset - Change task_struct->comm.
+ *
+ * @tsk: Pointer to "struct task_struct".
+ * @buf: New comm name.
+ *
+ * Returns nothing.
+ *
+ * This function will sleep if kmalloc() failed.
+ *
+ * Question: Are we allowed to sleep?
+ */
+void commset(struct task_struct *tsk, const char *buf)
 {
+	/*
+	 * Question: Do we need to use task_lock()/task_unlock() ?
+	 */
 	task_lock(tsk);
 	trace_task_rename(tsk, buf);
-	strlcpy(tsk->comm, buf, sizeof(tsk->comm));
 	task_unlock(tsk);
+	do_commset(tsk, buf);
 	perf_event_comm(tsk);
 }
 
@@ -1122,7 +1190,7 @@ void setup_new_exec(struct linux_binprm * bprm)
 	else
 		set_dumpable(current->mm, suid_dumpable);
 
-	set_task_comm(current, bprm->tcomm);
+	commset(current, bprm->tcomm);
 
 	/* Set the new mm task size. We have to do that late because it may
 	 * depend on TIF_32BIT which is only updated in flush_thread() on
diff --git a/kernel/fork.c b/kernel/fork.c
index a17621c..5ce989d 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -214,6 +214,12 @@ void free_task(struct task_struct *tsk)
 	ftrace_graph_exit_task(tsk);
 	put_seccomp_filter(tsk);
 	arch_release_task_struct(tsk);
+	/*
+	 * It is safe to unconditionally kfree() immediately because this
+	 * function must not be called if somebody is doing do_commset(tsk),
+	 * and tsk->rcu_comm != &init_rcu_comm because tsk != &init_task .
+	 */
+	kfree(tsk->rcu_comm);
 	free_task_struct(tsk);
 }
 EXPORT_SYMBOL(free_task);
@@ -1191,6 +1197,11 @@ static struct task_struct *copy_process(unsigned long clone_flags,
 	p = dup_task_struct(current);
 	if (!p)
 		goto fork_out;
+	/* This is safe because p is not visible yet. */
+	p->rcu_comm = kmemdup(current->rcu_comm, sizeof(current->rcu_comm),
+			      GFP_KERNEL);
+	if (!p->rcu_comm)
+		goto bad_fork_free;
 
 	ftrace_graph_init_task(p);
 	get_seccomp_filter(p);
diff --git a/kernel/kthread.c b/kernel/kthread.c
index 2c355bf..f73d6e0 100644
--- a/kernel/kthread.c
+++ b/kernel/kthread.c
@@ -318,10 +318,12 @@ struct task_struct *kthread_create_on_node(int (*threadfn)(void *data),
 	if (!IS_ERR(task)) {
 		static const struct sched_param param = { .sched_priority = 0 };
 		va_list args;
+		char name[TASK_COMM_LEN];
 
 		va_start(args, namefmt);
-		vsnprintf(task->comm, sizeof(task->comm), namefmt, args);
+		vsnprintf(name, TASK_COMM_LEN, namefmt, args);
 		va_end(args);
+		do_commset(task, name);
 		/*
 		 * root may have changed our (kthreadd's) priority or CPU mask.
 		 * The kernel thread should not inherit these properties.
@@ -494,7 +496,7 @@ int kthreadd(void *unused)
 	struct task_struct *tsk = current;
 
 	/* Setup a clean context for our children to inherit. */
-	set_task_comm(tsk, "kthreadd");
+	commset(tsk, "kthreadd");
 	ignore_signals(tsk);
 	set_cpus_allowed_ptr(tsk, cpu_all_mask);
 	set_mems_allowed(node_states[N_MEMORY]);
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index feb6630..81f7b16 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -4490,7 +4490,12 @@ void init_idle(struct task_struct *idle, int cpu)
 	ftrace_graph_init_idle_task(idle, cpu);
 	vtime_init_idle(idle, cpu);
 #if defined(CONFIG_SMP)
-	sprintf(idle->comm, "%s/%d", INIT_TASK_COMM, cpu);
+	{
+		char name[TASK_COMM_LEN];
+
+		snprintf(name, TASK_COMM_LEN, "swapper/%d", cpu);
+		do_commset(idle, name);
+	}
 #endif
 }
 
diff --git a/kernel/sys.c b/kernel/sys.c
index c0a58be..d6dcaee 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -1897,7 +1897,7 @@ SYSCALL_DEFINE5(prctl, int, option, unsigned long, arg2, unsigned long, arg3,
 		if (strncpy_from_user(comm, (char __user *)arg2,
 				      sizeof(me->comm) - 1) < 0)
 			return -EFAULT;
-		set_task_comm(me, comm);
+		commset(me, comm);
 		proc_comm_connector(me);
 		break;
 	case PR_GET_NAME:
diff --git a/fs/proc/base.c b/fs/proc/base.c
index 5150706..064f6c3 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -1396,7 +1396,7 @@ static ssize_t comm_write(struct file *file, const char __user *buf,
 		return -ESRCH;
 
 	if (same_thread_group(current, p))
-		set_task_comm(p, buffer);
+		commset(p, buffer);
 	else
 		count = -EINVAL;
 
-- 
1.7.1
