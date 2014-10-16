Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752801AbaJPVan (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 17:30:43 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:31369 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750993AbaJPVal (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 17:30:41 -0400
To: oleg@redhat.com
Cc: schwidefsky@de.ibm.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org
Subject: Re: [PATCH] kernel/kmod: fix use-after-free of the sub_infostructure
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <20141016160042.7f898871@mschwide>
	<201410170157.AFH86961.FQtFHJVLOFSOOM@I-love.SAKURA.ne.jp>
	<20141016174209.GB18318@redhat.com>
In-Reply-To: <20141016174209.GB18318@redhat.com>
Message-Id: <201410170630.EBH48400.FSOHVQJOFMLtFO@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Fri, 17 Oct 2014 06:30:29 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg Nesterov wrote:
> On 10/17, Tetsuo Handa wrote:
> >
> > For both UMH_NO_WAIT and UMH_WAIT_EXEC cases,
> >
> >   kernel_thread(call_helper, sub_info, CLONE_VFORK | SIGCHLD)
> >
> > in __call_usermodehelper() waits for do_execve() to succeed or do_exit(),
> 
> Well, not really. kernel_thread(CLONE_VFORK) waits for do_exit() or
> exec_mmap(), and exec can fail after that.

Ah, I see. Here is a draft of an updated patch.

Can we rewrite

Martin Schwidefsky wrote:
> for UMH_WAIT_EXEC the call to umh_complete() allows
> call_usermodehelper_exec() to continue which then frees sub_info.

lines?

By the way, it seems to me that nothing prevents

        if (info->cleanup)
                (*info->cleanup)(info);

>from crashing when info->cleanup points to a function in a loadable kernel
module and the loadable kernel module got unloaded before the worker thread
calls call_usermodehelper_freeinfo().
----------
[PATCH] kernel/kmod: fix use-after-free of the sub_info structure

A use-after-free bug was found on the subprocess_info structure allocated
by the user mode helper.

The message log on a s390 system:
-----
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
-----

Regarding UMH_NO_WAIT, the sub_info structure can be freed by
__call_usermodehelper() before the worker thread returns from
do_execve(), allowing memory corruption when do_execve() failed
after exec_mmap() is called.

Regarding UMH_WAIT_EXEC, the call to umh_complete() allows
call_usermodehelper_exec() to continue which then frees sub_info.

To fix this race, we need to make sure that the call to
call_usermodehelper_freeinfo() in call_usermodehelper_exec() is
always made after the last store to sub_info->retval.

Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
---
 kernel/kmod.c |   66 +++++++++++++++++++++++++--------------------------------
 1 files changed, 29 insertions(+), 37 deletions(-)

diff --git a/kernel/kmod.c b/kernel/kmod.c
index 8637e04..378b47f 100644
--- a/kernel/kmod.c
+++ b/kernel/kmod.c
@@ -196,12 +196,33 @@ int __request_module(bool wait, const char *fmt, ...)
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
+	 * we own sub_info, the caller has gone away.
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
 
@@ -242,12 +263,13 @@ static int ____call_usermodehelper(void *data)
 	retval = do_execve(getname_kernel(sub_info->path),
 			   (const char __user *const __user *)sub_info->argv,
 			   (const char __user *const __user *)sub_info->envp);
-	if (!retval)
-		return 0;
-
-	/* Exec failed? */
 fail:
 	sub_info->retval = retval;
+	/* wait_for_helper() will call umh_complete() if UMH_WAIT_PROC. */
+	if (wait != UMH_WAIT_PROC)
+		umh_complete(sub_info);
+	if (!retval)
+		return 0;
 	do_exit(0);
 }
 
@@ -258,26 +280,6 @@ static int call_helper(void *data)
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
@@ -336,18 +338,8 @@ static void __call_usermodehelper(struct work_struct *work)
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
@@ -588,7 +580,7 @@ int call_usermodehelper_exec(struct subprocess_info *sub_info, int wait)
 		goto out;
 	}
 
-	sub_info->complete = &done;
+	sub_info->complete = (wait == UMH_NO_WAIT) ? NULL : &done;
 	sub_info->wait = wait;
 
 	queue_work(khelper_wq, &sub_info->work);
-- 
1.7.1
