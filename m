Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751516Ab3FYPFr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 11:05:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21310 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751102Ab3FYPFq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 11:05:46 -0400
From: Denys Vlasenko <dvlasenk@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Denys Vlasenko <dvlasenk@redhat.com>, Oleg Nesterov <oleg@redhat.com>
Subject: [PATCH] epoll_[p]wait: fix spurious -EINTR on ptrace attach
Date: Tue, 25 Jun 2013 17:05:37 +0200
Message-Id: <1372172737-18726-1-git-send-email-dvlasenk@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Before this change, epoll_wait and epoll_pwait
spuriously return with -EINTR on ptrace attach.

By analogy with poll syscall family, epoll_[p]wait should be interruptible
by signals regardless of SA_RESTART, therefore, this change
makes them return -ERESTARTNOHAND if timeout has expired.

If timeout has not expired, and if interrupted by harmless SIG_DFL'ed
signals such as SIGWINCH and other signal-like activity
such as ptrace attach, epoll_[p]wait should restart with decreased timeout.
To that end, set up restart block and return -ERESTART_RESTARTBLOCK.

In order to define a "sigset_t ksigmask" member, I had to add
<asm/signal.h> to linux/thread_info.h, which threw some
build errors about undefined smp barriers and such.
Removing <linux/seqlock.h> include from linux/time.h
solved it.

Run-tested.

Signed-off-by: Denys Vlasenko <dvlasenk@redhat.com>
CC: Oleg Nesterov <oleg@redhat.com>
---
 fs/eventpoll.c              | 146 ++++++++++++++++++++++++++------------------
 include/linux/thread_info.h |  10 +++
 include/linux/time.h        |   1 -
 3 files changed, 98 insertions(+), 59 deletions(-)

diff --git a/fs/eventpoll.c b/fs/eventpoll.c
index 0cff4434..1df35aa 100644
--- a/fs/eventpoll.c
+++ b/fs/eventpoll.c
@@ -1911,16 +1911,16 @@ error_return:
 	return error;
 }
 
-/*
- * Implement the event wait interface for the eventpoll file. It is the kernel
- * part of the user space epoll_wait(2).
- */
-SYSCALL_DEFINE4(epoll_wait, int, epfd, struct epoll_event __user *, events,
-		int, maxevents, int, timeout)
+static long do_restart_epoll_pwait(struct restart_block *restart_block);
+
+static long do_epoll_pwait(int epfd, struct epoll_event __user *events,
+		int maxevents, int timeout, const sigset_t *sigmask)
 {
 	int error;
+	sigset_t ksigmask, ksigsaved;
 	struct fd f;
 	struct eventpoll *ep;
+	struct timespec start;
 
 	/* The maximum number of event must be greater than zero */
 	if (maxevents <= 0 || maxevents > EP_MAX_EVENTS)
@@ -1944,19 +1944,97 @@ SYSCALL_DEFINE4(epoll_wait, int, epfd, struct epoll_event __user *, events,
 		goto error_fput;
 
 	/*
+	 * If the caller wants a certain signal mask to be set during the wait,
+	 * we apply it here.
+	 */
+	if (sigmask) {
+		ksigmask = *sigmask;
+		sigdelsetmask(&ksigmask, sigmask(SIGKILL) | sigmask(SIGSTOP));
+		sigprocmask(SIG_SETMASK, &ksigmask, &ksigsaved);
+	}
+
+	/*
 	 * At this point it is safe to assume that the "private_data" contains
 	 * our own data structure.
 	 */
 	ep = f.file->private_data;
 
+	if (timeout > 0)
+		ktime_get_ts(&start);
+
 	/* Time to fish for events ... */
 	error = ep_poll(ep, events, maxevents, timeout);
 
+	if (error == -EINTR) {
+		error = -ERESTARTNOHAND;
+		if (timeout > 0) {
+			struct restart_block *restart_block;
+			struct timespec end;
+			ktime_t rem;
+			s64 rem_msec;
+
+			ktime_get_ts(&end);
+			rem = ktime_sub(timespec_to_ktime(end), timespec_to_ktime(start));
+			rem_msec = ktime_to_ms(rem);
+			if (rem_msec > 0) {
+				restart_block = &current_thread_info()->restart_block;
+				restart_block->fn = do_restart_epoll_pwait;
+				restart_block->epoll.epfd = epfd;
+				restart_block->epoll.events = events;
+				restart_block->epoll.maxevents = maxevents;
+				restart_block->epoll.timeout = rem_msec;
+				restart_block->epoll.has_ksigmask = (sigmask != NULL);
+				restart_block->epoll.ksigmask = ksigmask;
+				error = -ERESTART_RESTARTBLOCK;
+			}
+		}
+		/*
+		 * We've got a signal while waiting, we do not restore the
+		 * signal mask yet, and we allow do_signal() to deliver the signal on
+		 * the way back to userspace, before the signal mask is restored.
+		 */
+		if (sigmask) {
+			memcpy(&current->saved_sigmask, &ksigsaved,
+			       sizeof(ksigsaved));
+			set_restore_sigmask();
+		}
+	}
+	else
+	/*
+	 * If we changed the signal mask, we need to restore the original one.
+	 */
+	if (sigmask) {
+		sigprocmask(SIG_SETMASK, &ksigsaved, NULL);
+	}
+
 error_fput:
 	fdput(f);
 	return error;
 }
 
+static long do_restart_epoll_pwait(struct restart_block *restart_block)
+{
+	int epfd = restart_block->epoll.epfd;
+	struct epoll_event __user *events = restart_block->epoll.events;
+	int maxevents = restart_block->epoll.maxevents;
+	int timeout = restart_block->epoll.timeout;
+	sigset_t *ksigmask = restart_block->epoll.has_ksigmask
+				? &restart_block->epoll.ksigmask
+				: NULL;
+
+	return do_epoll_pwait(epfd, events, maxevents, timeout, ksigmask);
+}
+
+/*
+ * Implement the event wait interface for the eventpoll file. It is the kernel
+ * part of the user space epoll_wait(2).
+ */
+SYSCALL_DEFINE4(epoll_wait, int, epfd, struct epoll_event __user *, events,
+		int, maxevents, int, timeout)
+{
+	return do_epoll_pwait(epfd, events, maxevents, timeout, NULL);
+}
+
 /*
  * Implement the event wait interface for the eventpoll file. It is the kernel
  * part of the user space epoll_pwait(2).
@@ -1965,40 +2043,16 @@ SYSCALL_DEFINE6(epoll_pwait, int, epfd, struct epoll_event __user *, events,
 		int, maxevents, int, timeout, const sigset_t __user *, sigmask,
 		size_t, sigsetsize)
 {
-	int error;
-	sigset_t ksigmask, sigsaved;
+	sigset_t ksigmask;
 
-	/*
-	 * If the caller wants a certain signal mask to be set during the wait,
-	 * we apply it here.
-	 */
 	if (sigmask) {
 		if (sigsetsize != sizeof(sigset_t))
 			return -EINVAL;
 		if (copy_from_user(&ksigmask, sigmask, sizeof(ksigmask)))
 			return -EFAULT;
-		sigdelsetmask(&ksigmask, sigmask(SIGKILL) | sigmask(SIGSTOP));
-		sigprocmask(SIG_SETMASK, &ksigmask, &sigsaved);
 	}
 
-	error = sys_epoll_wait(epfd, events, maxevents, timeout);
-
-	/*
-	 * If we changed the signal mask, we need to restore the original one.
-	 * In case we've got a signal while waiting, we do not restore the
-	 * signal mask yet, and we allow do_signal() to deliver the signal on
-	 * the way back to userspace, before the signal mask is restored.
-	 */
-	if (sigmask) {
-		if (error == -EINTR) {
-			memcpy(&current->saved_sigmask, &sigsaved,
-			       sizeof(sigsaved));
-			set_restore_sigmask();
-		} else
-			sigprocmask(SIG_SETMASK, &sigsaved, NULL);
-	}
-
-	return error;
+	return do_epoll_pwait(epfd, events, maxevents, timeout, sigmask ? &ksigmask : NULL);
 }
 
 #ifdef CONFIG_COMPAT
@@ -2008,42 +2062,18 @@ COMPAT_SYSCALL_DEFINE6(epoll_pwait, int, epfd,
 			const compat_sigset_t __user *, sigmask,
 			compat_size_t, sigsetsize)
 {
-	long err;
 	compat_sigset_t csigmask;
-	sigset_t ksigmask, sigsaved;
+	sigset_t ksigmask;
 
-	/*
-	 * If the caller wants a certain signal mask to be set during the wait,
-	 * we apply it here.
-	 */
 	if (sigmask) {
 		if (sigsetsize != sizeof(compat_sigset_t))
 			return -EINVAL;
 		if (copy_from_user(&csigmask, sigmask, sizeof(csigmask)))
 			return -EFAULT;
 		sigset_from_compat(&ksigmask, &csigmask);
-		sigdelsetmask(&ksigmask, sigmask(SIGKILL) | sigmask(SIGSTOP));
-		sigprocmask(SIG_SETMASK, &ksigmask, &sigsaved);
-	}
-
-	err = sys_epoll_wait(epfd, events, maxevents, timeout);
-
-	/*
-	 * If we changed the signal mask, we need to restore the original one.
-	 * In case we've got a signal while waiting, we do not restore the
-	 * signal mask yet, and we allow do_signal() to deliver the signal on
-	 * the way back to userspace, before the signal mask is restored.
-	 */
-	if (sigmask) {
-		if (err == -EINTR) {
-			memcpy(&current->saved_sigmask, &sigsaved,
-			       sizeof(sigsaved));
-			set_restore_sigmask();
-		} else
-			sigprocmask(SIG_SETMASK, &sigsaved, NULL);
 	}
 
-	return err;
+	return do_epoll_pwait(epfd, events, maxevents, timeout, sigmask ? &ksigmask : NULL);
 }
 #endif
 
diff --git a/include/linux/thread_info.h b/include/linux/thread_info.h
index e7e0473..1a7e0c6 100644
--- a/include/linux/thread_info.h
+++ b/include/linux/thread_info.h
@@ -8,6 +8,7 @@
 #define _LINUX_THREAD_INFO_H
 
 #include <linux/types.h>
+#include <asm/signal.h>
 #include <linux/bug.h>
 
 struct timespec;
@@ -45,6 +46,15 @@ struct restart_block {
 			unsigned long tv_sec;
 			unsigned long tv_nsec;
 		} poll;
+		/* For epoll_[p]wait */
+		struct {
+			int epfd;
+			int maxevents;
+			int timeout;
+			int has_ksigmask;
+			struct epoll_event __user *events;
+			sigset_t ksigmask;
+		} epoll;
 	};
 };
 
diff --git a/include/linux/time.h b/include/linux/time.h
index d5d229b..f0c1152 100644
--- a/include/linux/time.h
+++ b/include/linux/time.h
@@ -2,7 +2,6 @@
 #define _LINUX_TIME_H
 
 # include <linux/cache.h>
-# include <linux/seqlock.h>
 # include <linux/math64.h>
 #include <uapi/linux/time.h>
 
-- 
1.8.1.4

