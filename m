Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752700Ab3FYUCV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 16:02:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43627 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751946Ab3FYUCT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 16:02:19 -0400
Date: Tue, 25 Jun 2013 21:57:56 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Denys Vlasenko <dvlasenk@redhat.com>,
        Eric Wong <normalperson@yhbt.net>, Jason Baron <jbaron@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] signals: eventpoll: do not use sigprocmask()
Message-ID: <20130625195756.GA15249@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130625195738.GA15231@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sigprocmask() should die. None of the current callers actually
need this strange interface.

Change fs/eventpoll.c to use set_current_blocked(). This also
means we should not worry about SIGKILL/SIGSTOP.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 fs/eventpoll.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/fs/eventpoll.c b/fs/eventpoll.c
index deecc72..0f0f736 100644
--- a/fs/eventpoll.c
+++ b/fs/eventpoll.c
@@ -1975,8 +1975,8 @@ SYSCALL_DEFINE6(epoll_pwait, int, epfd, struct epoll_event __user *, events,
 			return -EINVAL;
 		if (copy_from_user(&ksigmask, sigmask, sizeof(ksigmask)))
 			return -EFAULT;
-		sigdelsetmask(&ksigmask, sigmask(SIGKILL) | sigmask(SIGSTOP));
-		sigprocmask(SIG_SETMASK, &ksigmask, &sigsaved);
+		sigsaved = current->blocked;
+		set_current_blocked(&ksigmask);
 	}
 
 	error = sys_epoll_wait(epfd, events, maxevents, timeout);
@@ -1993,7 +1993,7 @@ SYSCALL_DEFINE6(epoll_pwait, int, epfd, struct epoll_event __user *, events,
 			       sizeof(sigsaved));
 			set_restore_sigmask();
 		} else
-			sigprocmask(SIG_SETMASK, &sigsaved, NULL);
+			set_current_blocked(&sigsaved);
 	}
 
 	return error;
@@ -2020,8 +2020,8 @@ COMPAT_SYSCALL_DEFINE6(epoll_pwait, int, epfd,
 		if (copy_from_user(&csigmask, sigmask, sizeof(csigmask)))
 			return -EFAULT;
 		sigset_from_compat(&ksigmask, &csigmask);
-		sigdelsetmask(&ksigmask, sigmask(SIGKILL) | sigmask(SIGSTOP));
-		sigprocmask(SIG_SETMASK, &ksigmask, &sigsaved);
+		sigsaved = current->blocked;
+		set_current_blocked(&ksigmask);
 	}
 
 	err = sys_epoll_wait(epfd, events, maxevents, timeout);
@@ -2038,7 +2038,7 @@ COMPAT_SYSCALL_DEFINE6(epoll_pwait, int, epfd,
 			       sizeof(sigsaved));
 			set_restore_sigmask();
 		} else
-			sigprocmask(SIG_SETMASK, &sigsaved, NULL);
+			set_current_blocked(&sigsaved);
 	}
 
 	return err;
-- 
1.5.5.1

