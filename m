Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752782Ab3FYUCX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 16:02:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37200 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751946Ab3FYUCW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 16:02:22 -0400
Date: Tue, 25 Jun 2013 21:57:59 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Denys Vlasenko <dvlasenk@redhat.com>,
        Eric Wong <normalperson@yhbt.net>, Jason Baron <jbaron@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] signals: eventpoll: set ->saved_sigmask at the start
Message-ID: <20130625195759.GA15252@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130625195738.GA15231@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

task_struct->saved_sigmask has no meaning unless we return with
set_restore_sigmask() and nobody except current can use it.

This means that sys_epoll_pwait() doesn't need to save ->blocked
into the local var and then memcopy it into ->saved_sigmask, we
can simply set ->saved_sigmask right before set_current_blocked().

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 fs/eventpoll.c |   34 +++++++++++++++-------------------
 1 files changed, 15 insertions(+), 19 deletions(-)

diff --git a/fs/eventpoll.c b/fs/eventpoll.c
index 0f0f736..2ea3584 100644
--- a/fs/eventpoll.c
+++ b/fs/eventpoll.c
@@ -1964,23 +1964,23 @@ SYSCALL_DEFINE6(epoll_pwait, int, epfd, struct epoll_event __user *, events,
 		size_t, sigsetsize)
 {
 	int error;
-	sigset_t ksigmask, sigsaved;
-
 	/*
 	 * If the caller wants a certain signal mask to be set during the wait,
 	 * we apply it here.
 	 */
 	if (sigmask) {
+		sigset_t ksigmask;
+
 		if (sigsetsize != sizeof(sigset_t))
 			return -EINVAL;
 		if (copy_from_user(&ksigmask, sigmask, sizeof(ksigmask)))
 			return -EFAULT;
-		sigsaved = current->blocked;
+
+		current->saved_sigmask = current->blocked;
 		set_current_blocked(&ksigmask);
 	}
 
 	error = sys_epoll_wait(epfd, events, maxevents, timeout);
-
 	/*
 	 * If we changed the signal mask, we need to restore the original one.
 	 * In case we've got a signal while waiting, we do not restore the
@@ -1988,12 +1988,10 @@ SYSCALL_DEFINE6(epoll_pwait, int, epfd, struct epoll_event __user *, events,
 	 * the way back to userspace, before the signal mask is restored.
 	 */
 	if (sigmask) {
-		if (error == -EINTR) {
-			memcpy(&current->saved_sigmask, &sigsaved,
-			       sizeof(sigsaved));
+		if (error == -EINTR)
 			set_restore_sigmask();
-		} else
-			set_current_blocked(&sigsaved);
+		else
+			__set_current_blocked(&current->saved_sigmask);
 	}
 
 	return error;
@@ -2007,25 +2005,25 @@ COMPAT_SYSCALL_DEFINE6(epoll_pwait, int, epfd,
 			compat_size_t, sigsetsize)
 {
 	long err;
-	compat_sigset_t csigmask;
-	sigset_t ksigmask, sigsaved;
-
 	/*
 	 * If the caller wants a certain signal mask to be set during the wait,
 	 * we apply it here.
 	 */
 	if (sigmask) {
+		compat_sigset_t csigmask;
+		sigset_t ksigmask;
+
 		if (sigsetsize != sizeof(compat_sigset_t))
 			return -EINVAL;
 		if (copy_from_user(&csigmask, sigmask, sizeof(csigmask)))
 			return -EFAULT;
 		sigset_from_compat(&ksigmask, &csigmask);
-		sigsaved = current->blocked;
+
+		current->saved_sigmask = current->blocked;
 		set_current_blocked(&ksigmask);
 	}
 
 	err = sys_epoll_wait(epfd, events, maxevents, timeout);
-
 	/*
 	 * If we changed the signal mask, we need to restore the original one.
 	 * In case we've got a signal while waiting, we do not restore the
@@ -2033,12 +2031,10 @@ COMPAT_SYSCALL_DEFINE6(epoll_pwait, int, epfd,
 	 * the way back to userspace, before the signal mask is restored.
 	 */
 	if (sigmask) {
-		if (err == -EINTR) {
-			memcpy(&current->saved_sigmask, &sigsaved,
-			       sizeof(sigsaved));
+		if (err == -EINTR)
 			set_restore_sigmask();
-		} else
-			set_current_blocked(&sigsaved);
+		else
+			__set_current_blocked(&current->saved_sigmask);
 	}
 
 	return err;
-- 
1.5.5.1

