Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755361Ab3IPAyK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Sep 2013 20:54:10 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:58650 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754249Ab3IPAyI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Sep 2013 20:54:08 -0400
X-Nat-Received: from [202.181.97.72]:56654 [ident-empty]
	by smtp-proxy.isp with TPROXY id 1379292839.7197
To: oleg@redhat.com
Cc: security@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] kthread: Make kthread_create() killable.
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <201309132318.HEC05218.OtVOFOFMLJHFQS@I-love.SAKURA.ne.jp>
	<20130914160515.GA8627@redhat.com>
	<201309150846.HED51521.tJOFOMVFSOHQFL@I-love.SAKURA.ne.jp>
	<20130915163919.GC13344@redhat.com>
In-Reply-To: <20130915163919.GC13344@redhat.com>
Message-Id: <201309160953.IGI12418.FOQHOFVJLOMFSt@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Mon, 16 Sep 2013 09:53:59 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for Linux Mail Server 5.6.45.2/RELEASE, bases: 15092013 #11074950, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg Nesterov wrote:
> Please look at call_usermodehelper_exec() which does this trick. The
> logic is the same, just you need to xchg(create->completion) instead
> of create->owner.

OK. I understood that we can use the same logic.
----------------------------------------
>From 87373d6938f045abffe8d9b4910bd132036eccaa Mon Sep 17 00:00:00 2001
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Date: Mon, 16 Sep 2013 09:39:17 +0900
Subject: [PATCH v2] kthread: Make kthread_create() killable.

Any users of wait_for_completion() might be chosen by the OOM killer while
waiting for completion() call by some process which does memory allocation.
kthread_create() is one of such users.

When such users are chosen by the OOM killer when they are waiting for
completion() in TASK_UNINTERRUPTIBLE, problem similar to CVE-2012-4398
"kernel: request_module() OOM local DoS" can happen.

This patch makes kthread_create() killable, using the same approach used for
fixing CVE-2012-4398.

Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
---
 kernel/kthread.c |   73 ++++++++++++++++++++++++++++++++++++++++-------------
 1 files changed, 55 insertions(+), 18 deletions(-)

diff --git a/kernel/kthread.c b/kernel/kthread.c
index 760e86d..b5ae3ee 100644
--- a/kernel/kthread.c
+++ b/kernel/kthread.c
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
@@ -223,8 +230,15 @@ static void create_kthread(struct kthread_create_info *create)
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
 
@@ -255,36 +269,59 @@ struct task_struct *kthread_create_on_node(int (*threadfn)(void *data),
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
 
-- 
1.7.1
