Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754539Ab3HLU0s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 16:26:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:30358 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752728Ab3HLU0r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 16:26:47 -0400
Date: Mon, 12 Aug 2013 16:26:29 -0400
From: David Teigland <teigland@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Christine Caulfield <ccaulfie@redhat.com>,
        Long Gao <gaolong@kylinos.com.cn>, Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/1] dlm: kill the unnecessary and wrong
 device_close()->recalc_sigpending()
Message-ID: <20130812202629.GB29118@redhat.com>
References: <tencent_26310211398C21034BD3B2F9@qq.com>
 <CA+55aFwAnWZGkXbyLmL3RxQGW-dX_jjDBPfA5PjxeVWn==a6tA@mail.gmail.com>
 <20130808191749.GA12062@redhat.com>
 <20130809151852.GA4619@redhat.com>
 <20130809151913.GB4619@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130809151913.GB4619@redhat.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 09, 2013 at 05:19:13PM +0200, Oleg Nesterov wrote:
> device_close()->recalc_sigpending() is not needed, sigprocmask()
> takes care of TIF_SIGPENDING correctly.
> 
> And without ->siglock it is racy and wrong, it can wrongly clear
> TIF_SIGPENDING and miss a signal.
> 
> But even with this patch device_close() is still buggy:
> 
> 	1. sigprocmask() should not be used, we have set_task_blocked(),
> 	   but this is minor.
> 
> 	2. We should never block SIGKILL or SIGSTOP, and this is what
> 	   the code tries to do.
> 
> 	3. This can't protect against SIGKILL or SIGSTOP anyway. Another
> 	   thread can do signal_wake_up(), say, do_signal_stop() or
> 	   complete_signal() or debugger.
> 
> 	4. sigprocmask(SIG_BLOCK, allsigs) doesn't necessarily clears
> 	   TIF_SIGPENDING, say, freezing() or ->jobctl.
> 
> 	5. device_write() looks equally wrong by the same reason.
> 
> Looks like, this tries to protect some wait_event_interruptible() logic
> from signals, it should be turned into uninterruptible wait. Or we need
> to implement something like signals_stop/start for such a use-case.

I can't remember why that signal code exists, or if I ever knew; it was
there when the code was added seven years ago.  I agree that if there's
something we cannot interrupt, we should use uninterruptible, but I don't
see any cases of that either.  I think we should just remove it all
(untested):

From: David Teigland <teigland@redhat.com>
Date: Mon, 12 Aug 2013 15:22:43 -0500
Subject: [PATCH] dlm: remove signal blocking

The signal blocking was incorrect and unnecessary
so just remove it.

Signed-off-by: David Teigland <teigland@redhat.com>
---
 fs/dlm/user.c | 25 ++++++-------------------
 1 file changed, 6 insertions(+), 19 deletions(-)

diff --git a/fs/dlm/user.c b/fs/dlm/user.c
index 911649a..142e216 100644
--- a/fs/dlm/user.c
+++ b/fs/dlm/user.c
@@ -493,7 +493,6 @@ static ssize_t device_write(struct file *file, const char __user *buf,
 {
 	struct dlm_user_proc *proc = file->private_data;
 	struct dlm_write_request *kbuf;
-	sigset_t tmpsig, allsigs;
 	int error;
 
 #ifdef CONFIG_COMPAT
@@ -557,9 +556,6 @@ static ssize_t device_write(struct file *file, const char __user *buf,
 		goto out_free;
 	}
 
-	sigfillset(&allsigs);
-	sigprocmask(SIG_BLOCK, &allsigs, &tmpsig);
-
 	error = -EINVAL;
 
 	switch (kbuf->cmd)
@@ -567,7 +563,7 @@ static ssize_t device_write(struct file *file, const char __user *buf,
 	case DLM_USER_LOCK:
 		if (!proc) {
 			log_print("no locking on control device");
-			goto out_sig;
+			goto out_free;
 		}
 		error = device_user_lock(proc, &kbuf->i.lock);
 		break;
@@ -575,7 +571,7 @@ static ssize_t device_write(struct file *file, const char __user *buf,
 	case DLM_USER_UNLOCK:
 		if (!proc) {
 			log_print("no locking on control device");
-			goto out_sig;
+			goto out_free;
 		}
 		error = device_user_unlock(proc, &kbuf->i.lock);
 		break;
@@ -583,7 +579,7 @@ static ssize_t device_write(struct file *file, const char __user *buf,
 	case DLM_USER_DEADLOCK:
 		if (!proc) {
 			log_print("no locking on control device");
-			goto out_sig;
+			goto out_free;
 		}
 		error = device_user_deadlock(proc, &kbuf->i.lock);
 		break;
@@ -591,7 +587,7 @@ static ssize_t device_write(struct file *file, const char __user *buf,
 	case DLM_USER_CREATE_LOCKSPACE:
 		if (proc) {
 			log_print("create/remove only on control device");
-			goto out_sig;
+			goto out_free;
 		}
 		error = device_create_lockspace(&kbuf->i.lspace);
 		break;
@@ -599,7 +595,7 @@ static ssize_t device_write(struct file *file, const char __user *buf,
 	case DLM_USER_REMOVE_LOCKSPACE:
 		if (proc) {
 			log_print("create/remove only on control device");
-			goto out_sig;
+			goto out_free;
 		}
 		error = device_remove_lockspace(&kbuf->i.lspace);
 		break;
@@ -607,7 +603,7 @@ static ssize_t device_write(struct file *file, const char __user *buf,
 	case DLM_USER_PURGE:
 		if (!proc) {
 			log_print("no locking on control device");
-			goto out_sig;
+			goto out_free;
 		}
 		error = device_user_purge(proc, &kbuf->i.purge);
 		break;
@@ -617,8 +613,6 @@ static ssize_t device_write(struct file *file, const char __user *buf,
 			  kbuf->cmd);
 	}
 
- out_sig:
-	sigprocmask(SIG_SETMASK, &tmpsig, NULL);
  out_free:
 	kfree(kbuf);
 	return error;
@@ -659,15 +653,11 @@ static int device_close(struct inode *inode, struct file *file)
 {
 	struct dlm_user_proc *proc = file->private_data;
 	struct dlm_ls *ls;
-	sigset_t tmpsig, allsigs;
 
 	ls = dlm_find_lockspace_local(proc->lockspace);
 	if (!ls)
 		return -ENOENT;
 
-	sigfillset(&allsigs);
-	sigprocmask(SIG_BLOCK, &allsigs, &tmpsig);
-
 	set_bit(DLM_PROC_FLAGS_CLOSING, &proc->flags);
 
 	dlm_clear_proc_locks(ls, proc);
@@ -685,9 +675,6 @@ static int device_close(struct inode *inode, struct file *file)
 	/* FIXME: AUTOFREE: if this ls is no longer used do
 	   device_remove_lockspace() */
 
-	sigprocmask(SIG_SETMASK, &tmpsig, NULL);
-	recalc_sigpending();
-
 	return 0;
 }
 
-- 
1.8.3.1

