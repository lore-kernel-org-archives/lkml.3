Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753567Ab3IWXH2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 19:07:28 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:56723 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752482Ab3IWXH0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 19:07:26 -0400
Date: Mon, 23 Sep 2013 16:07:25 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Cc: oleg@redhat.com, security@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] kthread: Make kthread_create() killable.
Message-Id: <20130923160725.49093c565dcf6df7037dcc6b@linux-foundation.org>
In-Reply-To: <201309160953.IGI12418.FOQHOFVJLOMFSt@I-love.SAKURA.ne.jp>
References: <201309132318.HEC05218.OtVOFOFMLJHFQS@I-love.SAKURA.ne.jp>
	<20130914160515.GA8627@redhat.com>
	<201309150846.HED51521.tJOFOMVFSOHQFL@I-love.SAKURA.ne.jp>
	<20130915163919.GC13344@redhat.com>
	<201309160953.IGI12418.FOQHOFVJLOMFSt@I-love.SAKURA.ne.jp>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 16 Sep 2013 09:53:59 +0900 Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp> wrote:

> Subject: [PATCH v2] kthread: Make kthread_create() killable.
> 
> Any users of wait_for_completion() might be chosen by the OOM killer while
> waiting for completion() call by some process which does memory allocation.
> kthread_create() is one of such users.
> 
> When such users are chosen by the OOM killer when they are waiting for
> completion() in TASK_UNINTERRUPTIBLE, problem similar to CVE-2012-4398
> "kernel: request_module() OOM local DoS" can happen.
> 
> This patch makes kthread_create() killable, using the same approach used for
> fixing CVE-2012-4398.

That's a pretty big patch.  What's the status of this?  Do you think
it's ready to go?  Oleg?

I don't like the changelog much - it doesn't really describe the bug. 
I can google "CVE-2012-4398" and that turns up a bunch of stuff but
it's more oriented toward sysadmins etc, rather than kernel developers.

Can we please have a conventional description?  When the user does A,
the kernel does B because C, so we fix it via D?



From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Subject: kthread: make kthread_create() killable

Any users of wait_for_completion() might be chosen by the OOM killer while
waiting for completion() call by some process which does memory
allocation.  kthread_create() is one of such users.

When such users are chosen by the OOM killer when they are waiting for
completion() in TASK_UNINTERRUPTIBLE, problem similar to CVE-2012-4398
"kernel: request_module() OOM local DoS" can happen.

This patch makes kthread_create() killable, using the same approach used for
fixing CVE-2012-4398.

Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kthread.c |   73 +++++++++++++++++++++++++++++++++------------
 1 file changed, 55 insertions(+), 18 deletions(-)

diff -puN kernel/kthread.c~kthread-make-kthread_create-killable kernel/kthread.c
--- a/kernel/kthread.c~kthread-make-kthread_create-killable
+++ a/kernel/kthread.c
@@ -33,7 +33,7 @@ struct kthread_create_info
 
 	/* Result passed back to kthread_create() from kthreadd. */
 	struct task_struct *result;
-	struct completion done;
+	struct completion *done;
 
 	struct list_head list;
 };
@@ -178,6 +178,7 @@ static int kthread(void *_create)
 	struct kthread_create_info *create = _create;
 	int (*threadfn)(void *data) = create->threadfn;
 	void *data = create->data;
+	struct completion *done;
 	struct kthread self;
 	int ret;
 
@@ -187,10 +188,16 @@ static int kthread(void *_create)
 	init_completion(&self.parked);
 	current->vfork_done = &self.exited;
 
+	/* If user was SIGKILLed, I release the structure. */
+	done = xchg(&create->done, NULL);
+	if (!done) {
+		kfree(create);
+		do_exit(-EINTR);
+	}
 	/* OK, tell user we're spawned, wait for stop or wakeup */
 	__set_current_state(TASK_UNINTERRUPTIBLE);
 	create->result = current;
-	complete(&create->done);
+	complete(done);
 	schedule();
 
 	ret = -EINTR;
@@ -223,8 +230,15 @@ static void create_kthread(struct kthrea
 	/* We want our own signal handler (we take no signals by default). */
 	pid = kernel_thread(kthread, create, CLONE_FS | CLONE_FILES | SIGCHLD);
 	if (pid < 0) {
+		/* If user was SIGKILLed, I release the structure. */
+		struct completion *done = xchg(&create->done, NULL);
+
+		if (!done) {
+			kfree(create);
+			return;
+		}
 		create->result = ERR_PTR(pid);
-		complete(&create->done);
+		complete(done);
 	}
 }
 
@@ -255,36 +269,59 @@ struct task_struct *kthread_create_on_no
 					   const char namefmt[],
 					   ...)
 {
-	struct kthread_create_info create;
-
-	create.threadfn = threadfn;
-	create.data = data;
-	create.node = node;
-	init_completion(&create.done);
+	DECLARE_COMPLETION_ONSTACK(done);
+	struct task_struct *task;
+	struct kthread_create_info *create = kmalloc(sizeof(*create),
+						     GFP_KERNEL);
+
+	if (!create)
+		return ERR_PTR(-ENOMEM);
+	create->threadfn = threadfn;
+	create->data = data;
+	create->node = node;
+	create->done = &done;
 
 	spin_lock(&kthread_create_lock);
-	list_add_tail(&create.list, &kthread_create_list);
+	list_add_tail(&create->list, &kthread_create_list);
 	spin_unlock(&kthread_create_lock);
 
 	wake_up_process(kthreadd_task);
-	wait_for_completion(&create.done);
-
-	if (!IS_ERR(create.result)) {
+	/*
+	 * Wait for completion in killable state, for I might be chosen by
+	 * the OOM killer while kthreadd is trying to allocate memory for
+	 * new kernel thread.
+	 */
+	if (unlikely(wait_for_completion_killable(&done))) {
+		/*
+		 * If I was SIGKILLed before kthreadd (or new kernel thread)
+		 * calls complete(), leave the cleanup of this structure to
+		 * that thread.
+		 */
+		if (xchg(&create->done, NULL))
+			return ERR_PTR(-ENOMEM);
+		/*
+		 * kthreadd (or new kernel thread) will call complete()
+		 * shortly.
+		 */
+		wait_for_completion(&done);
+	}
+	task = create->result;
+	if (!IS_ERR(task)) {
 		static const struct sched_param param = { .sched_priority = 0 };
 		va_list args;
 
 		va_start(args, namefmt);
-		vsnprintf(create.result->comm, sizeof(create.result->comm),
-			  namefmt, args);
+		vsnprintf(task->comm, sizeof(task->comm), namefmt, args);
 		va_end(args);
 		/*
 		 * root may have changed our (kthreadd's) priority or CPU mask.
 		 * The kernel thread should not inherit these properties.
 		 */
-		sched_setscheduler_nocheck(create.result, SCHED_NORMAL, &param);
-		set_cpus_allowed_ptr(create.result, cpu_all_mask);
+		sched_setscheduler_nocheck(task, SCHED_NORMAL, &param);
+		set_cpus_allowed_ptr(task, cpu_all_mask);
 	}
-	return create.result;
+	kfree(create);
+	return task;
 }
 EXPORT_SYMBOL(kthread_create_on_node);
 
_

