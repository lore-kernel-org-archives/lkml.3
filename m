Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965039Ab3BMWQf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 17:16:35 -0500
Received: from kanga.kvack.org ([205.233.56.17]:54012 "EHLO kanga.kvack.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750736Ab3BMWQd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 17:16:33 -0500
Date: Wed, 13 Feb 2013 17:16:32 -0500
From: Benjamin LaHaise <bcrl@kvack.org>
To: Kent Overstreet <koverstreet@google.com>
Cc: linux-aio@kvack.org, linux-fsdevel@vger.kernel.org,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH][WIP v1] aio: experimental use of threads, demonstration of cancel method
Message-ID: <20130213221632.GA25312@kvack.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch is purely for experimentation purposes, and is by no means
complete or cleaned up for submission yet.  It is, however, useful for
demonstrating the cancellation of a kiocb when the kiocb is being
processed by using a kernel thread.

There are a number of things about this patch that are completely broken:
it uses a very simple thread pool, it does not yet implement vector ops,
it overrides aio operations for read/write/fsync/fdsync, and it has in no
way had any performance tuning done on it.  A subsequent demonstration
patch will be written to make use of queue_work() for the purpose of
examining and comparing the overhead of various APIs.

As for cancellation, the thread based cancellation implemented in this
patch is expected to function correctly.  A test program is available at
http://www.kvack.org/~bcrl/aio_tests/read-pipe-cancel.c and makes use of
io_cancel() on a read from a pipe file descriptor.  Hopefully the
simplicity of the cancel function is useful for providing a starting point
for further discussion of kiocb cancellation.

This change applies on top of the 3 previous aio patches posted earlier
today.  A git repository with the changes is available at
git://git.kvack.org/~bcrl/linux-next-20130213.git and is based off of
today's linux-next tree.  Please note that this is a throw-away repository
that will be rebased.

Not-signed-off-by: Benjamin LaHaise <bcrl@kvack.org>
---
 fs/aio.c              |  240 +++++++++++++++++++++++++++++++++++++++++++++----
 fs/exec.c             |    6 ++
 include/linux/aio.h   |    1 +
 include/linux/sched.h |    3 +
 kernel/exit.c         |    6 ++
 kernel/fork.c         |    5 +
 kernel/sched/core.c   |    2 +
 7 files changed, 244 insertions(+), 19 deletions(-)

diff --git a/fs/aio.c b/fs/aio.c
index 1bcb818..a95d9c5 100644
--- a/fs/aio.c
+++ b/fs/aio.c
@@ -38,6 +38,7 @@
 #include <linux/blkdev.h>
 #include <linux/compat.h>
 #include <linux/percpu-refcount.h>
+#include <linux/kthread.h>
 
 #include <asm/kmap_types.h>
 #include <asm/uaccess.h>
@@ -73,6 +74,8 @@ struct kioctx {
 	unsigned long		user_id;
 	struct hlist_node	list;
 
+	struct mm_struct	*mm;
+
 	struct __percpu kioctx_cpu *cpu;
 
 	unsigned		req_batch;
@@ -102,6 +105,11 @@ struct kioctx {
 	} ____cacheline_aligned_in_smp;
 
 	struct {
+		spinlock_t		worker_lock;
+		struct list_head	worker_list;
+	} ____cacheline_aligned_in_smp;
+
+	struct {
 		struct mutex	ring_lock;
 		wait_queue_head_t wait;
 
@@ -136,6 +144,8 @@ unsigned long aio_max_nr = 0x10000; /* system wide maximum number of aio request
 static struct kmem_cache	*kiocb_cachep;
 static struct kmem_cache	*kioctx_cachep;
 
+static int make_helper_thread(struct kioctx *ctx);
+
 /* aio_setup
  *	Creates the slab caches used by the aio routines, panic on
  *	failure as this is done early during the boot sequence.
@@ -295,9 +305,25 @@ static int kiocb_cancel(struct kioctx *ctx, struct kiocb *kiocb,
 static void free_ioctx_rcu(struct rcu_head *head)
 {
 	struct kioctx *ctx = container_of(head, struct kioctx, rcu_head);
+	struct task_struct *task;
+	int nr = 0;
 
 	free_percpu(ctx->cpu);
+	do {
+		spin_lock(&ctx->worker_lock);
+		if (!list_empty(&ctx->worker_list)) {
+			task = list_entry(ctx->worker_list.next,
+					  struct task_struct, aio_list);
+			list_del(&task->aio_list);
+			nr++;
+		} else
+			task = NULL;
+		spin_unlock(&ctx->worker_lock);
+		if (task)
+			wake_up_process(task);
+	} while (task) ;
 	kmem_cache_free(kioctx_cachep, ctx);
+	printk("free_ioctx_rcu: nr of worker threads: %d\n", nr);
 }
 
 /*
@@ -339,7 +365,7 @@ static void free_ioctx(struct kioctx *ctx)
 	while (atomic_read(&ctx->reqs_available) < ctx->nr) {
 		wait_event(ctx->wait,
 			   (head != ctx->shadow_tail) ||
-			   (atomic_read(&ctx->reqs_available) != ctx->nr));
+			   (atomic_read(&ctx->reqs_available) == ctx->nr));
 
 		avail = (head <= ctx->shadow_tail ?
 			 ctx->shadow_tail : ctx->nr) - head;
@@ -360,6 +386,10 @@ static void free_ioctx(struct kioctx *ctx)
 
 	pr_debug("freeing %p\n", ctx);
 
+	if (ctx->mm)
+		mmdrop(ctx->mm);
+	ctx->mm = NULL;
+
 	/*
 	 * Here the call_rcu() is between the wait_event() for reqs_active to
 	 * hit 0, and freeing the ioctx.
@@ -407,6 +437,8 @@ static struct kioctx *ioctx_alloc(unsigned nr_events)
 	rcu_read_unlock();
 
 	spin_lock_init(&ctx->ctx_lock);
+	spin_lock_init(&ctx->worker_lock);
+	INIT_LIST_HEAD(&ctx->worker_list);
 	mutex_init(&ctx->ring_lock);
 	init_waitqueue_head(&ctx->wait);
 
@@ -433,6 +465,9 @@ static struct kioctx *ioctx_alloc(unsigned nr_events)
 	aio_nr += ctx->max_reqs;
 	spin_unlock(&aio_nr_lock);
 
+	ctx->mm = current->mm;
+	atomic_inc(&current->mm->mm_count);
+
 	/* now link into global list. */
 	spin_lock(&mm->ioctx_lock);
 	hlist_add_head_rcu(&ctx->list, &mm->ioctx_list);
@@ -629,6 +664,7 @@ static void kiocb_free(struct kiocb *req)
 
 void aio_put_req(struct kiocb *req)
 {
+	BUG_ON(atomic_read(&req->ki_users) <= 0);
 	if (atomic_dec_and_test(&req->ki_users))
 		kiocb_free(req);
 }
@@ -681,6 +717,7 @@ static inline unsigned kioctx_ring_put(struct kioctx *ctx, struct kiocb *req,
 
 static inline unsigned kioctx_ring_lock(struct kioctx *ctx)
 {
+	struct aio_ring *ring;
 	unsigned tail;
 
 	/*
@@ -690,6 +727,15 @@ static inline unsigned kioctx_ring_lock(struct kioctx *ctx)
 	while ((tail = xchg(&ctx->tail, UINT_MAX)) == UINT_MAX)
 		cpu_relax();
 
+	ring = kmap_atomic(ctx->ring_pages[0]);
+#if 0
+	if (ring->head == ring->tail) {
+		ring->head = ring->tail = 0;
+		tail = 0;
+	}
+#endif
+	kunmap_atomic(ring);
+
 	return tail;
 }
 
@@ -892,7 +938,7 @@ static long aio_read_events_ring(struct kioctx *ctx,
 		goto out;
 
 	while (ret < nr) {
-		long avail = (head <= ctx->shadow_tail
+		long avail = (head < ctx->shadow_tail
 			      ? ctx->shadow_tail : ctx->nr) - head;
 		struct io_event *ev;
 		struct page *page;
@@ -1031,6 +1077,9 @@ SYSCALL_DEFINE2(io_setup, unsigned, nr_events, aio_context_t __user *, ctxp)
 		put_ioctx(ioctx);
 	}
 
+	if (!ret)
+		make_helper_thread(ioctx);
+
 out:
 	return ret;
 }
@@ -1156,12 +1205,24 @@ static ssize_t aio_setup_single_vector(int rw, struct kiocb *kiocb)
 	return 0;
 }
 
+static int aio_thread_cancel_fn(struct kiocb *iocb, struct io_event *event)
+{
+	struct task_struct *task = iocb->private;
+
+	barrier();
+	aio_put_req(iocb);
+	if (task == NULL)
+		return -EAGAIN;
+	force_sig(SIGSEGV, task);
+	return -EINPROGRESS;	/* the cancelled iocb will complete */
+}
+
 /*
  * aio_setup_iocb:
  *	Performs the initial checks and aio retry method
  *	setup for the kiocb at the time of io submission.
  */
-static ssize_t aio_run_iocb(struct kiocb *req, bool compat)
+static ssize_t aio_run_iocb(struct kiocb *req)
 {
 	struct file *file = req->ki_filp;
 	ssize_t ret;
@@ -1187,12 +1248,9 @@ rw_common:
 		if (unlikely(!(file->f_mode & mode)))
 			return -EBADF;
 
-		if (!rw_op)
-			return -EINVAL;
-
 		ret = (req->ki_opcode == IOCB_CMD_PREADV ||
 		       req->ki_opcode == IOCB_CMD_PWRITEV)
-			? aio_setup_vectored_rw(rw, req, compat)
+			? aio_setup_vectored_rw(rw, req, req->ki_compat)
 			: aio_setup_single_vector(rw, req);
 		if (ret)
 			return ret;
@@ -1204,23 +1262,36 @@ rw_common:
 		req->ki_nbytes = ret;
 		req->ki_left = ret;
 
+		if (current->aio_data)
+			goto aio_submit_task;
+		if (!rw_op)
+			return -EINVAL;
 		ret = aio_rw_vect_retry(req, rw, rw_op);
 		break;
 
 	case IOCB_CMD_FDSYNC:
-		if (!file->f_op->aio_fsync)
-			return -EINVAL;
-
-		ret = file->f_op->aio_fsync(req, 1);
-		break;
-
 	case IOCB_CMD_FSYNC:
-		if (!file->f_op->aio_fsync)
-			return -EINVAL;
-
-		ret = file->f_op->aio_fsync(req, 0);
+	{
+		struct task_struct *task;
+
+aio_submit_task:
+		task = current->aio_data;
+		BUG_ON(task->aio_data != NULL);
+		if (task) {
+			current->aio_data = NULL;
+			req->private = task;
+			task->aio_data = req;
+			kiocb_set_cancel_fn(req, aio_thread_cancel_fn);
+			wake_up_process(task);
+			ret = -EIOCBQUEUED;
+		} else {
+			if (!file->f_op->aio_fsync)
+				return -EINVAL;
+			ret = file->f_op->aio_fsync(req, req->ki_opcode ==
+							 IOCB_CMD_FDSYNC);
+		}
 		break;
-
+	}
 	default:
 		pr_debug("EINVAL: no operation provided\n");
 		return -EINVAL;
@@ -1240,6 +1311,128 @@ rw_common:
 	return 0;
 }
 
+static int aio_thread_fn(void *data)
+{
+	kiocb_cancel_fn *cancel;
+	struct kiocb *iocb;
+	struct kioctx *ctx;
+	ssize_t ret;
+
+again:
+	iocb = current->aio_data;
+	current->aio_data = NULL;
+
+	if (!iocb)
+		return 0;
+
+	ctx = iocb->ki_ctx;
+	use_mm(ctx->mm);
+	set_fs(USER_DS);
+
+	iocb->private = current;
+	ret = -EINVAL;
+
+	switch (iocb->ki_opcode) {
+	case IOCB_CMD_PREAD:
+		if (!iocb->ki_filp->f_op->read)
+			break;
+		ret = iocb->ki_filp->f_op->read(iocb->ki_filp, iocb->ki_buf,
+						iocb->ki_nbytes, &iocb->ki_pos);
+		break;
+
+	case IOCB_CMD_PWRITE:
+		if (!iocb->ki_filp->f_op->write)
+			break;
+		ret = iocb->ki_filp->f_op->write(iocb->ki_filp,
+						 iocb->ki_buf,
+						 iocb->ki_nbytes,
+						 &iocb->ki_pos);
+		break;
+
+	case IOCB_CMD_FSYNC:
+	case IOCB_CMD_FDSYNC:
+		ret = iocb->ki_filp->f_op->fsync(iocb->ki_filp, 0, LLONG_MAX,
+						 iocb->ki_opcode == IOCB_CMD_FDSYNC);
+	default:
+		break;
+	}
+
+	cancel = cmpxchg(&iocb->ki_cancel, aio_thread_cancel_fn, NULL);
+	if (cancel == KIOCB_CANCELLED) {
+		set_current_state(TASK_INTERRUPTIBLE);
+		while (!signal_pending(current)) {
+			schedule();
+			if (signal_pending(current))
+				break;
+			set_current_state(TASK_INTERRUPTIBLE);
+		}
+	} else
+		BUG_ON(cancel != aio_thread_cancel_fn);
+
+	if (signal_pending(current))
+		flush_signals(current);
+
+	set_current_state(TASK_INTERRUPTIBLE);
+
+	spin_lock(&ctx->worker_lock);
+	list_add(&current->aio_list, &ctx->worker_list);
+	spin_unlock(&ctx->worker_lock);
+
+	if (ret != -EIOCBQUEUED) {
+		/*
+		 * There's no easy way to restart the syscall since other AIO's
+		 * may be already running. Just fail this IO with EINTR.
+		 */
+		if (unlikely(ret == -ERESTARTSYS || ret == -ERESTARTNOINTR ||
+			     ret == -ERESTARTNOHAND ||
+			     ret == -ERESTART_RESTARTBLOCK))
+			ret = -EINTR;
+		aio_complete(iocb, ret, 0);
+	}
+
+	set_fs(KERNEL_DS);
+	unuse_mm(current->mm);
+
+	if (current->aio_data) {
+		set_current_state(TASK_RUNNING);
+		goto again;
+	}
+
+	schedule();
+	if (current->aio_data)
+		goto again;
+	return 0;
+}
+
+static int make_helper_thread(struct kioctx *ctx)
+{
+	struct task_struct *task;
+	char name[32];
+
+	if (current->aio_data)
+		return 0;
+
+	spin_lock(&ctx->worker_lock);
+	if (!list_empty(&ctx->worker_list)) {
+		struct task_struct *task;
+		task = list_entry(ctx->worker_list.next, struct task_struct,
+				  aio_list);
+		list_del(&task->aio_list);
+		spin_unlock(&ctx->worker_lock);
+		current->aio_data = task;
+		return 0;
+	}
+	spin_unlock(&ctx->worker_lock);
+
+	snprintf(name, sizeof(name), "aio-helper-%d", current->pid);
+	task = kthread_create(aio_thread_fn, NULL, name);
+	if (IS_ERR(task))
+		return PTR_ERR(task);
+
+	current->aio_data = task;
+	return 0;
+}
+
 static int io_submit_one(struct kioctx *ctx, struct iocb __user *user_iocb,
 			 struct iocb *iocb, bool compat)
 {
@@ -1293,6 +1486,10 @@ static int io_submit_one(struct kioctx *ctx, struct iocb __user *user_iocb,
 		goto out_put_req;
 	}
 
+	ret = -ENOMEM;
+	if (make_helper_thread(ctx))
+		goto out_put_req;
+
 	req->ki_obj.user = user_iocb;
 	req->ki_user_data = iocb->aio_data;
 	req->ki_pos = iocb->aio_offset;
@@ -1300,8 +1497,11 @@ static int io_submit_one(struct kioctx *ctx, struct iocb __user *user_iocb,
 	req->ki_buf = (char __user *)(unsigned long)iocb->aio_buf;
 	req->ki_left = req->ki_nbytes = iocb->aio_nbytes;
 	req->ki_opcode = iocb->aio_lio_opcode;
+	req->ki_compat = compat;
 
-	ret = aio_run_iocb(req, compat);
+	current->in_aio_submit = 1;
+	ret = aio_run_iocb(req);
+	current->in_aio_submit = 0;
 	if (ret)
 		goto out_put_req;
 
@@ -1488,3 +1688,5 @@ SYSCALL_DEFINE5(io_getevents, aio_context_t, ctx_id,
 	asmlinkage_protect(5, ret, ctx_id, min_nr, nr, events, timeout);
 	return ret;
 }
+
+/* foo */
diff --git a/fs/exec.c b/fs/exec.c
index dc38755..be39eff 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -826,6 +826,12 @@ static int exec_mmap(struct mm_struct *mm)
 			return -EINTR;
 		}
 	}
+	if (tsk->aio_data) {
+		struct task_struct *p = tsk->aio_data;
+		tsk->aio_data = NULL;
+		wake_up_process(p);
+	}
+
 	task_lock(tsk);
 	active_mm = tsk->active_mm;
 	tsk->mm = mm;
diff --git a/include/linux/aio.h b/include/linux/aio.h
index a7e4c59..c2ac93f 100644
--- a/include/linux/aio.h
+++ b/include/linux/aio.h
@@ -54,6 +54,7 @@ struct kiocb {
 	void			*private;
 	/* State that we remember to be able to restart/retry  */
 	unsigned short		ki_opcode;
+	unsigned short		ki_compat;
 	size_t			ki_nbytes; 	/* copy of iocb->aio_nbytes */
 	char 			__user *ki_buf;	/* remaining iocb->aio_buf */
 	size_t			ki_left; 	/* remaining bytes */
diff --git a/include/linux/sched.h b/include/linux/sched.h
index f0e3a11..34011b3 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1318,6 +1318,7 @@ struct task_struct {
 	/* Revert to default priority/policy when forking */
 	unsigned sched_reset_on_fork:1;
 	unsigned sched_contributes_to_load:1;
+	unsigned in_aio_submit:1;
 
 	pid_t pid;
 	pid_t tgid;
@@ -1607,6 +1608,8 @@ struct task_struct {
 #ifdef CONFIG_UPROBES
 	struct uprobe_task *utask;
 #endif
+	void *aio_data;
+	struct list_head aio_list;
 };
 
 /* Future-safe accessor for struct task_struct's cpus_allowed. */
diff --git a/kernel/exit.c b/kernel/exit.c
index 7dd2040..5202018 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -785,6 +785,12 @@ void do_exit(long code)
 	tsk->exit_code = code;
 	taskstats_exit(tsk, group_dead);
 
+	if (tsk->aio_data) {
+		wake_up_process(tsk->aio_data);
+		tsk->aio_data = NULL;
+	}
+
+
 	exit_mm(tsk);
 
 	if (group_dead)
diff --git a/kernel/fork.c b/kernel/fork.c
index e6d16bb..83c532d 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -207,6 +207,10 @@ static void account_kernel_stack(struct thread_info *ti, int account)
 
 void free_task(struct task_struct *tsk)
 {
+	if (current->aio_data) {
+		wake_up_process(current->aio_data);
+		current->aio_data = NULL;
+	}
 	account_kernel_stack(tsk->stack, -1);
 	arch_release_thread_info(tsk->stack);
 	free_thread_info(tsk->stack);
@@ -332,6 +336,7 @@ static struct task_struct *dup_task_struct(struct task_struct *orig)
 #endif
 	tsk->splice_pipe = NULL;
 	tsk->task_frag.page = NULL;
+	tsk->aio_data = NULL;
 
 	account_kernel_stack(ti, 1);
 
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 55a5ae3..626d6c0 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -2895,6 +2895,8 @@ static void __sched __schedule(void)
 	struct rq *rq;
 	int cpu;
 
+	WARN_ON(current->in_aio_submit);
+
 need_resched:
 	preempt_disable();
 	cpu = smp_processor_id();
-- 
1.7.4.1


-- 
"Thought is the essence of where you are now."
