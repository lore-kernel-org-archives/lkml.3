Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752532AbaBQL23 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 06:28:29 -0500
Received: from www262.sakura.ne.jp ([202.181.97.72]:59480 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752056AbaBQL21 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 06:28:27 -0500
X-Nat-Received: from [202.181.97.72]:54666 [ident-empty]
	by smtp-proxy.isp with TPROXY id 1392636455.20861
To: akpm@linux-foundation.org
Cc: joe@perches.com, keescook@chromium.org, geert@linux-m68k.org,
        jkosina@suse.cz, viro@zeniv.linux.org.uk, davem@davemloft.net,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Change task_struct->comm to use RCU.
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <20140207140536.943daf965008b9428cdcb468@linux-foundation.org>
	<201402081055.BGJ73403.tQMLFVOJSOOFFH@I-love.SAKURA.ne.jp>
	<20140207180647.5944fe3d.akpm@linux-foundation.org>
	<201402092327.JAD12489.QOLSFVMHJtFOOF@I-love.SAKURA.ne.jp>
	<201402102243.IEJ52676.JOFVMOQFOFSLtH@I-love.SAKURA.ne.jp>
In-Reply-To: <201402102243.IEJ52676.JOFVMOQFOFSLtH@I-love.SAKURA.ne.jp>
Message-Id: <201402172027.BFH81210.FJtOQOMLHFSVOF@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Mon, 17 Feb 2014 20:27:31 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for Linux Mail Server 5.6.45.2/RELEASE, bases: 17022014 #7236633, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tetsuo Handa wrote:
> This is a draft patch which changes task_struct->comm to use RCU.

Changes from previous draft version:

  Changed "struct rcu_comm" to use copy-on-write approach. Those multi-thread
  or multi-process applications which do not change comm name will consume
  memory for only one "struct rcu_comm".

  Changed do_commset() not to sleep.

  Changed to tolerate loss of consistency when memory allocation failed.

  Fixed race condition in copy_process().

Regards.
----------
>From ada6c4d94f5afda36c7c21869d38b7111a6fe9bc Mon Sep 17 00:00:00 2001
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Date: Mon, 17 Feb 2014 14:32:11 +0900
Subject: [PATCH] Change task_struct->comm to use RCU.

This patch changes task_struct->comm to be updated using RCU
(unless memory allocation fails).

Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
---
 fs/exec.c                 |  145 +++++++++++++++++++++++++++++++++++++++------
 include/linux/init_task.h |    4 +-
 include/linux/sched.h     |   37 ++++++++++--
 kernel/fork.c             |    9 +++
 kernel/kthread.c          |    4 +-
 kernel/sched/core.c       |    2 +-
 6 files changed, 173 insertions(+), 28 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index a781dec..8a68ab3 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -263,6 +263,11 @@ extern char ___assert_task_state[1 - 2*!!(
 
 /* Task command name length */
 #define TASK_COMM_LEN 16
+struct rcu_comm {
+	char name[TASK_COMM_LEN];
+	atomic_t usage;
+	struct rcu_head rcu;
+};
 
 #include <linux/spinlock.h>
 
@@ -1317,10 +1322,12 @@ struct task_struct {
 					 * credentials (COW) */
 	const struct cred __rcu *cred;	/* effective (overridable) subjective task
 					 * credentials (COW) */
-	char comm[TASK_COMM_LEN]; /* executable name excluding path
-				     - access with [gs]et_task_comm (which lock
-				       it with task_lock())
-				     - initialized normally by setup_new_exec */
+	struct rcu_comm __rcu *rcu_comm; /* executable name excluding path (COW)
+					    - update with set_task_comm() or
+					      do_set_task_comm[_fmt]()
+					    - read with commcpy() or %pT
+					    - initialized normally by
+					      setup_new_exec */
 /* file system info */
 	int link_count, total_link_count;
 #ifdef CONFIG_SYSVIPC
@@ -1792,6 +1799,23 @@ static inline cputime_t task_gtime(struct task_struct *t)
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
+	memcpy(buf, rcu_dereference(tsk->rcu_comm)->name, TASK_COMM_LEN);
+	rcu_read_unlock();
+	buf[TASK_COMM_LEN - 1] = '\0';
+	return buf;
+}
+
 /*
  * Per process flags
  */
@@ -2320,7 +2344,10 @@ struct task_struct *fork_idle(int);
 extern pid_t kernel_thread(int (*fn)(void *), void *arg, unsigned long flags);
 
 extern void set_task_comm(struct task_struct *tsk, char *from);
-extern char *get_task_comm(char *to, struct task_struct *tsk);
+extern void do_set_task_comm(struct task_struct *tsk, const char *buf);
+extern void do_set_task_comm_fmt(struct task_struct *tsk, const char *fmt, ...)
+	__printf(2, 3);
+extern void put_commname(struct rcu_comm *comm);
 
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
index 3d78fcc..85c57a6 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1026,30 +1026,11 @@ killed:
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
-{
-	task_lock(tsk);
-	trace_task_rename(tsk, buf);
-	strlcpy(tsk->comm, buf, sizeof(tsk->comm));
-	task_unlock(tsk);
-	perf_event_comm(tsk);
-}
-
 static void filename_to_taskname(char *tcomm, const char *fn, unsigned int len)
 {
 	int i, ch;
@@ -1626,3 +1607,129 @@ asmlinkage long compat_sys_execve(const char __user * filename,
 	return compat_do_execve(getname(filename), argv, envp);
 }
 #endif
+
+/* Task's comm name handler functions. */
+static struct kmem_cache *commname_cachep __read_mostly;
+
+/* comm name for init_task. */
+struct rcu_comm init_rcu_comm = {
+	.name = "swapper",
+	.usage = ATOMIC_INIT(INT_MAX) /* Mark this object static. */
+};
+
+/**
+ * set_task_comm - Change task_struct->comm with tracer and perf hooks called.
+ *
+ * @tsk: Pointer to "struct task_struct".
+ * @buf: New comm name.
+ *
+ * Returns nothing.
+ */
+void set_task_comm(struct task_struct *tsk, char *buf)
+{
+	/*
+	 * Question: Do we need to use task_lock()/task_unlock() ?
+	 */
+	task_lock(tsk);
+	trace_task_rename(tsk, buf);
+	task_unlock(tsk);
+	do_set_task_comm(tsk, buf);
+	perf_event_comm(tsk);
+}
+
+/**
+ * do_set_task_comm_fmt - Change task_struct->comm.
+ *
+ * @tsk: Pointer to "struct task_struct".
+ * @fmt: Format string, followed by arguments.
+ *
+ * Returns nothing.
+ */
+void do_set_task_comm_fmt(struct task_struct *tsk, const char *fmt, ...)
+{
+	va_list args;
+	char name[TASK_COMM_LEN];
+
+	va_start(args, fmt);
+	vsnprintf(name, TASK_COMM_LEN, fmt, args);
+	va_end(args);
+	do_set_task_comm(tsk, name);
+}
+
+/**
+ * do_set_task_comm - Change task_struct->comm.
+ *
+ * @tsk: Pointer to "struct task_struct".
+ * @buf: New comm name.
+ *
+ * Returns nothing.
+ */
+void do_set_task_comm(struct task_struct *tsk, const char *buf)
+{
+	struct rcu_comm *comm;
+
+	comm = kmem_cache_zalloc(commname_cachep, GFP_ATOMIC | __GFP_NOWARN);
+	if (likely(comm)) {
+		atomic_set(&comm->usage, 1);
+		strncpy(comm->name, buf, TASK_COMM_LEN - 1);
+		smp_wmb(); /* Behave like rcu_assign_pointer(). */
+		comm = xchg(&tsk->rcu_comm, comm);
+		put_commname(comm);
+	} else {
+		/*
+		 * Memory allocation failed. We have to tolerate loss of
+		 * consistency.
+		 *
+		 * Question 1: Do we want to reserve some amount of static
+		 * "struct rcu_comm" arrays for use upon allocation failures?
+		 *
+		 * Question 2: Do we perfer unchanged comm name over
+		 * overwritten comm name because comm name is copy-on-write ?
+		 */
+		WARN_ONCE(1, "Failed to allocate memory for comm name.\n");
+		rcu_read_lock();
+		do {
+			comm = rcu_dereference(tsk->rcu_comm);
+		} while (!atomic_read(&comm->usage));
+		strncpy(comm->name, buf, TASK_COMM_LEN - 1);
+		rcu_read_unlock();
+	}
+}
+
+/**
+ * free_commname - Release "struct rcu_comm".
+ *
+ * @rcu: Pointer to "struct rcu_head".
+ *
+ * Returns nothing.
+ */
+static void free_commname(struct rcu_head *rcu)
+{
+	struct rcu_comm *comm = container_of(rcu, struct rcu_comm, rcu);
+	kmem_cache_free(commname_cachep, comm);
+}
+
+/**
+ * put_commname - Release "struct rcu_comm".
+ *
+ * @comm: Pointer to "struct rcu_comm".
+ *
+ * Returns nothing.
+ */
+void put_commname(struct rcu_comm *comm)
+{
+	if (atomic_dec_and_test(&comm->usage))
+		call_rcu(&comm->rcu, free_commname);
+}
+
+/**
+ * commname_init - Initialize "struct rcu_comm".
+ *
+ * Returns nothing.
+ */
+void __init commname_init(void)
+{
+	commname_cachep = kmem_cache_create("commname",
+					    sizeof(struct rcu_comm),
+					    0, SLAB_PANIC, NULL);
+}
diff --git a/kernel/fork.c b/kernel/fork.c
index a17621c..23be1ef 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -214,6 +214,7 @@ void free_task(struct task_struct *tsk)
 	ftrace_graph_exit_task(tsk);
 	put_seccomp_filter(tsk);
 	arch_release_task_struct(tsk);
+	put_commname(tsk->rcu_comm);
 	free_task_struct(tsk);
 }
 EXPORT_SYMBOL(free_task);
@@ -249,6 +250,8 @@ EXPORT_SYMBOL_GPL(__put_task_struct);
 
 void __init __weak arch_task_cache_init(void) { }
 
+extern void __init commname_init(void);
+
 void __init fork_init(unsigned long mempages)
 {
 #ifndef CONFIG_ARCH_TASK_STRUCT_ALLOCATOR
@@ -260,6 +263,7 @@ void __init fork_init(unsigned long mempages)
 		kmem_cache_create("task_struct", sizeof(struct task_struct),
 			ARCH_MIN_TASKALIGN, SLAB_PANIC | SLAB_NOTRACK, NULL);
 #endif
+	commname_init();
 
 	/* do the arch specific task caches init */
 	arch_task_cache_init();
@@ -1191,6 +1195,11 @@ static struct task_struct *copy_process(unsigned long clone_flags,
 	p = dup_task_struct(current);
 	if (!p)
 		goto fork_out;
+	rcu_read_lock();
+	do {
+		p->rcu_comm = rcu_dereference(current->rcu_comm);
+	} while (!atomic_inc_not_zero(&p->rcu_comm->usage));
+	rcu_read_unlock();
 
 	ftrace_graph_init_task(p);
 	get_seccomp_filter(p);
diff --git a/kernel/kthread.c b/kernel/kthread.c
index b5ae3ee..e83b67c 100644
--- a/kernel/kthread.c
+++ b/kernel/kthread.c
@@ -309,10 +309,12 @@ struct task_struct *kthread_create_on_node(int (*threadfn)(void *data),
 	if (!IS_ERR(task)) {
 		static const struct sched_param param = { .sched_priority = 0 };
 		va_list args;
+		char name[TASK_COMM_LEN];
 
 		va_start(args, namefmt);
-		vsnprintf(task->comm, sizeof(task->comm), namefmt, args);
+		vsnprintf(name, TASK_COMM_LEN, namefmt, args);
 		va_end(args);
+		do_set_task_comm(task, name);
 		/*
 		 * root may have changed our (kthreadd's) priority or CPU mask.
 		 * The kernel thread should not inherit these properties.
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index b46131e..bbb7c94 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -4488,7 +4488,7 @@ void init_idle(struct task_struct *idle, int cpu)
 	ftrace_graph_init_idle_task(idle, cpu);
 	vtime_init_idle(idle, cpu);
 #if defined(CONFIG_SMP)
-	sprintf(idle->comm, "%s/%d", INIT_TASK_COMM, cpu);
+	do_set_task_comm_fmt(idle, "swapper/%d", cpu);
 #endif
 }
 
-- 
1.7.1
