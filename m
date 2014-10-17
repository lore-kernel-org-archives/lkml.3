Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753907AbaJQTTz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2014 15:19:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38536 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753805AbaJQTTy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2014 15:19:54 -0400
Date: Fri, 17 Oct 2014 21:16:43 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org
Subject: [PATCH 2/2] usermodehelper: kill the kmod_thread_locker logic
Message-ID: <20141017191643.GC22270@redhat.com>
References: <20141016160042.7f898871@mschwide> <201410170157.AFH86961.FQtFHJVLOFSOOM@I-love.SAKURA.ne.jp> <20141016174209.GB18318@redhat.com> <201410170630.EBH48400.FSOHVQJOFMLtFO@I-love.SAKURA.ne.jp> <20141016215834.GA28864@redhat.com> <20141017093653.6fa60dff@mschwide> <20141017191557.GA22270@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141017191557.GA22270@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that we do not call kernel_thread(CLONE_VFORK) from the worker
thread we can not deadlock if do_execve() in turn triggers another
call_usermodehelper(), we can remove the kmod_thread_locker code.

Note: we should probably kill khelper_wq and simply use one of the
global workqueues, say, system_unbound_wq, this special wq for umh
buys nothing nowadays.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 kernel/kmod.c |   33 +++------------------------------
 1 files changed, 3 insertions(+), 30 deletions(-)

diff --git a/kernel/kmod.c b/kernel/kmod.c
index 4621771..2777f40 100644
--- a/kernel/kmod.c
+++ b/kernel/kmod.c
@@ -47,13 +47,6 @@ extern int max_threads;
 
 static struct workqueue_struct *khelper_wq;
 
-/*
- * kmod_thread_locker is used for deadlock avoidance.  There is no explicit
- * locking to protect this global - it is private to the singleton khelper
- * thread and should only ever be modified by that thread.
- */
-static const struct task_struct *kmod_thread_locker;
-
 #define CAP_BSET	(void *)1
 #define CAP_PI		(void *)2
 
@@ -273,13 +266,6 @@ out:
 	do_exit(0);
 }
 
-static int call_helper(void *data)
-{
-	/* Worker thread started blocking khelper thread. */
-	kmod_thread_locker = current;
-	return ____call_usermodehelper(data);
-}
-
 /* Keventd can't block, but this (a child) can. */
 static int wait_for_helper(void *data)
 {
@@ -327,11 +313,9 @@ static void __call_usermodehelper(struct work_struct *work)
 	if (sub_info->wait & UMH_WAIT_PROC)
 		pid = kernel_thread(wait_for_helper, sub_info,
 				    CLONE_FS | CLONE_FILES | SIGCHLD);
-	else {
-		pid = kernel_thread(call_helper, sub_info, SIGCHLD);
-		/* Worker thread stopped blocking khelper thread. */
-		kmod_thread_locker = NULL;
-	}
+	else
+		pid = kernel_thread(____call_usermodehelper, sub_info,
+				    SIGCHLD);
 
 	if (pid < 0) {
 		sub_info->retval = pid;
@@ -565,17 +549,6 @@ int call_usermodehelper_exec(struct subprocess_info *sub_info, int wait)
 		goto out;
 	}
 	/*
-	 * Worker thread must not wait for khelper thread at below
-	 * wait_for_completion() if the thread was created with CLONE_VFORK
-	 * flag, for khelper thread is already waiting for the thread at
-	 * wait_for_completion() in do_fork().
-	 */
-	if (wait != UMH_NO_WAIT && current == kmod_thread_locker) {
-		retval = -EBUSY;
-		goto out;
-	}
-
-	/*
 	 * Set the completion pointer only if there is a waiter.
 	 * This makes it possible to use umh_complete to free
 	 * the data structure in case of UMH_NO_WAIT.
-- 
1.5.5.1


