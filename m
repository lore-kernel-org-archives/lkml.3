Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752684AbaJPOAw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 10:00:52 -0400
Received: from e06smtp14.uk.ibm.com ([195.75.94.110]:45440 "EHLO
	e06smtp14.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752632AbaJPOAv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 10:00:51 -0400
Date: Thu, 16 Oct 2014 16:00:42 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Subject: [PATCH] kernel/kmod: fix use-after-free of the sub_info structure
Message-ID: <20141016160042.7f898871@mschwide>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14101614-0017-0000-0000-000001785D12
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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

For UMH_NO_WAIT and UMH_WAIT_EXEC the call to kernel_thread() in
__call_usermodehelper() can return while do_execve() is still running.
For UMH_NO_WAIT __call_usermodehelper() frees the sub_info structure
directly, for UMH_WAIT_EXEC the call to umh_complete() allows
call_usermodehelper_exec() to continue which then frees sub_info.

To fix this race the code needs to make sure that the call to
call_usermodehelper_freeinfo() is always done after the last store
to sub_info->retval.

Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
---
 kernel/kmod.c | 74 ++++++++++++++++++++++++++---------------------------------
 1 file changed, 33 insertions(+), 41 deletions(-)

diff --git a/kernel/kmod.c b/kernel/kmod.c
index 8637e04..641c44b 100644
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
+	 * we own sub_info, the UMH_KILLABLE caller has gone away.
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
 
@@ -221,7 +242,7 @@ static int ____call_usermodehelper(void *data)
 	retval = -ENOMEM;
 	new = prepare_kernel_cred(current);
 	if (!new)
-		goto fail;
+		goto out;
 
 	spin_lock(&umh_sysctl_lock);
 	new->cap_bset = cap_intersect(usermodehelper_bset, new->cap_bset);
@@ -233,7 +254,7 @@ static int ____call_usermodehelper(void *data)
 		retval = sub_info->init(sub_info, new);
 		if (retval) {
 			abort_creds(new);
-			goto fail;
+			goto out;
 		}
 	}
 
@@ -242,13 +263,14 @@ static int ____call_usermodehelper(void *data)
 	retval = do_execve(getname_kernel(sub_info->path),
 			   (const char __user *const __user *)sub_info->argv,
 			   (const char __user *const __user *)sub_info->envp);
-	if (!retval)
-		return 0;
-
-	/* Exec failed? */
-fail:
+out:
 	sub_info->retval = retval;
-	do_exit(0);
+	if (wait != UMH_WAIT_PROC)
+		/* For UMH_WAIT_PROC wait_for_helper calls umh_complete */
+		umh_complete(sub_info);
+	if (retval)
+		do_exit(0);
+	return 0;
 }
 
 static int call_helper(void *data)
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
1.8.5.5

