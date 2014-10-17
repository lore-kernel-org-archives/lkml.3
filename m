Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753337AbaJQHhD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2014 03:37:03 -0400
Received: from e06smtp13.uk.ibm.com ([195.75.94.109]:39755 "EHLO
	e06smtp13.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751037AbaJQHhA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2014 03:37:00 -0400
Date: Fri, 17 Oct 2014 09:36:53 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org
Subject: Re: [PATCH] kernel/kmod: fix use-after-free of the
 sub_infostructure
Message-ID: <20141017093653.6fa60dff@mschwide>
In-Reply-To: <20141016215834.GA28864@redhat.com>
References: <20141016160042.7f898871@mschwide>
	<201410170157.AFH86961.FQtFHJVLOFSOOM@I-love.SAKURA.ne.jp>
	<20141016174209.GB18318@redhat.com>
	<201410170630.EBH48400.FSOHVQJOFMLtFO@I-love.SAKURA.ne.jp>
	<20141016215834.GA28864@redhat.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14101707-0013-0000-0000-0000017BBD4C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 16 Oct 2014 23:58:34 +0200
Oleg Nesterov <oleg@redhat.com> wrote:

> I also agree that the changelog could mention exec_mmap. Plus a comment
> about UMH_NO_WAIT && sub_info->complete == NULL. So yes, perhaps v2 makes
> sense if Martin agrees.

Version 2 of the patch. All change requests have gone in except for the
mention of exec_mmap. I don't quite get the relevance of it, do_execve
can fail for the various reasons.
---
Subject: [PATCH] kernel/kmod: fix use-after-free of the sub_info structure

From: Martin Schwidefsky <schwidefsky@de.ibm.com>

Found this in the message log on a s390 system:

BUG kmalloc-192 (Not tainted): Poison overwritten
Disabling lock debugging due to kernel taint
INFO: 0x00000000684761f4-0x00000000684761f7. First byte 0xff instead of 0x6b
INFO: Allocated in call_usermodehelper_setup+0x70/0x128 age=71 cpu=2 pid=648
 __slab_alloc.isra.47.constprop.56+0x5f6/0x658
 kmem_cache_alloc_trace+0x106/0x408
 call_usermodehelper_setup+0x70/0x128
 call_usermodehelper+0x62/0x90
 cgroup_release_agent+0x178/0x1c0
 process_one_work+0x36e/0x680
 worker_thread+0x2f0/0x4f8
 kthread+0x10a/0x120
 kernel_thread_starter+0x6/0xc
 kernel_thread_starter+0x0/0xc
INFO: Freed in call_usermodehelper_exec+0x110/0x1b8 age=71 cpu=2 pid=648
 __slab_free+0x94/0x560
 kfree+0x364/0x3e0
 call_usermodehelper_exec+0x110/0x1b8
 cgroup_release_agent+0x178/0x1c0
 process_one_work+0x36e/0x680
 worker_thread+0x2f0/0x4f8
 kthread+0x10a/0x120
 kernel_thread_starter+0x6/0xc
 kernel_thread_starter+0x0/0xc

There is a use-after-free bug on the subprocess_info structure allocated
by the user mode helper. In case do_execve() returns with an error
____call_usermodehelper() stores the error code to sub_info->retval,
but sub_info can already have been freed.

Regarding UMH_NO_WAIT, the sub_info structure can be freed by
__call_usermodehelper() before the worker thread returns from
do_execve(), allowing memory corruption when do_execve() failed
after exec_mmap() is called.

Regarding UMH_WAIT_EXEC, the call to umh_complete() allows
call_usermodehelper_exec() to continue which then frees sub_info.

To fix this race the code needs to make sure that the call to
call_usermodehelper_freeinfo() is always done after the last store
to sub_info->retval.

Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
Reviewed-by: Oleg Nesterov <oleg@redhat.com>
Cc: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
---
 kernel/kmod.c | 76 +++++++++++++++++++++++++++++------------------------------
 1 file changed, 37 insertions(+), 39 deletions(-)

diff --git a/kernel/kmod.c b/kernel/kmod.c
index 8637e04..80f7a6d 100644
--- a/kernel/kmod.c
+++ b/kernel/kmod.c
@@ -196,12 +196,34 @@ int __request_module(bool wait, const char *fmt, ...)
 EXPORT_SYMBOL(__request_module);
 #endif /* CONFIG_MODULES */
 
+static void call_usermodehelper_freeinfo(struct subprocess_info *info)
+{
+	if (info->cleanup)
+		(*info->cleanup)(info);
+	kfree(info);
+}
+
+static void umh_complete(struct subprocess_info *sub_info)
+{
+	struct completion *comp = xchg(&sub_info->complete, NULL);
+	/*
+	 * See call_usermodehelper_exec(). If xchg() returns NULL
+	 * we own sub_info, the UMH_KILLABLE caller has gone away
+	 * or the caller used UMH_NO_WAIT.
+	 */
+	if (comp)
+		complete(comp);
+	else
+		call_usermodehelper_freeinfo(sub_info);
+}
+
 /*
  * This is the task which runs the usermode application
  */
 static int ____call_usermodehelper(void *data)
 {
 	struct subprocess_info *sub_info = data;
+	int wait = sub_info->wait & ~UMH_KILLABLE;
 	struct cred *new;
 	int retval;
 
@@ -221,7 +243,7 @@ static int ____call_usermodehelper(void *data)
 	retval = -ENOMEM;
 	new = prepare_kernel_cred(current);
 	if (!new)
-		goto fail;
+		goto out;
 
 	spin_lock(&umh_sysctl_lock);
 	new->cap_bset = cap_intersect(usermodehelper_bset, new->cap_bset);
@@ -233,7 +255,7 @@ static int ____call_usermodehelper(void *data)
 		retval = sub_info->init(sub_info, new);
 		if (retval) {
 			abort_creds(new);
-			goto fail;
+			goto out;
 		}
 	}
 
@@ -242,12 +264,13 @@ static int ____call_usermodehelper(void *data)
 	retval = do_execve(getname_kernel(sub_info->path),
 			   (const char __user *const __user *)sub_info->argv,
 			   (const char __user *const __user *)sub_info->envp);
+out:
+	sub_info->retval = retval;
+	/* wait_for_helper() will call umh_complete if UHM_WAIT_PROC. */
+	if (wait != UMH_WAIT_PROC)
+		umh_complete(sub_info);
 	if (!retval)
 		return 0;
-
-	/* Exec failed? */
-fail:
-	sub_info->retval = retval;
 	do_exit(0);
 }
 
@@ -258,26 +281,6 @@ static int call_helper(void *data)
 	return ____call_usermodehelper(data);
 }
 
-static void call_usermodehelper_freeinfo(struct subprocess_info *info)
-{
-	if (info->cleanup)
-		(*info->cleanup)(info);
-	kfree(info);
-}
-
-static void umh_complete(struct subprocess_info *sub_info)
-{
-	struct completion *comp = xchg(&sub_info->complete, NULL);
-	/*
-	 * See call_usermodehelper_exec(). If xchg() returns NULL
-	 * we own sub_info, the UMH_KILLABLE caller has gone away.
-	 */
-	if (comp)
-		complete(comp);
-	else
-		call_usermodehelper_freeinfo(sub_info);
-}
-
 /* Keventd can't block, but this (a child) can. */
 static int wait_for_helper(void *data)
 {
@@ -336,18 +339,8 @@ static void __call_usermodehelper(struct work_struct *work)
 		kmod_thread_locker = NULL;
 	}
 
-	switch (wait) {
-	case UMH_NO_WAIT:
-		call_usermodehelper_freeinfo(sub_info);
-		break;
-
-	case UMH_WAIT_PROC:
-		if (pid > 0)
-			break;
-		/* FALLTHROUGH */
-	case UMH_WAIT_EXEC:
-		if (pid < 0)
-			sub_info->retval = pid;
+	if (pid < 0) {
+		sub_info->retval = pid;
 		umh_complete(sub_info);
 	}
 }
@@ -588,7 +581,12 @@ int call_usermodehelper_exec(struct subprocess_info *sub_info, int wait)
 		goto out;
 	}
 
-	sub_info->complete = &done;
+	/*
+	 * Set the completion pointer only if there is a waiter.
+	 * This makes it possible to use umh_complete to free
+	 * the data structure in case of UMH_NO_WAIT.
+	 */
+	sub_info->complete = (wait == UMH_NO_WAIT) ? NULL : &done;
 	sub_info->wait = wait;
 
 	queue_work(khelper_wq, &sub_info->work);
-- 
1.8.5.5

