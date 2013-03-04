Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755260Ab3CDDGZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Mar 2013 22:06:25 -0500
Received: from dcvr.yhbt.net ([64.71.152.64]:42981 "EHLO dcvr.yhbt.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754503Ab3CDDGX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Mar 2013 22:06:23 -0500
From: Eric Wong <normalperson@yhbt.net>
To: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, Eric Wong <normalperson@yhbt.net>,
        Davide Libenzi <davidel@xmailserver.org>,
        Al Viro <viro@ZenIV.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 1/2] epoll: hoist out duplicated wake up logic
Date: Mon,  4 Mar 2013 03:06:07 +0000
Message-Id: <1362366368-15246-1-git-send-email-normalperson@yhbt.net>
X-Mailer: git-send-email 1.8.1.2.526.gf51a757
In-Reply-To: <20130304030500.GA29365@dcvr.yhbt.net>
References: <20130304030500.GA29365@dcvr.yhbt.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This makes the kernel slightly smaller, and hopefully easier to follow.

Signed-off-by: Eric Wong <normalperson@yhbt.net>
Cc: Davide Libenzi <davidel@xmailserver.org>
Cc: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>
---
 fs/eventpoll.c | 27 +++++++++++----------------
 1 file changed, 11 insertions(+), 16 deletions(-)

diff --git a/fs/eventpoll.c b/fs/eventpoll.c
index 5a1a596..6a70b7d 100644
--- a/fs/eventpoll.c
+++ b/fs/eventpoll.c
@@ -536,6 +536,13 @@ static void ep_unregister_pollwait(struct eventpoll *ep, struct epitem *epi)
 	}
 }
 
+static int __must_check ep_wake_up_locked(struct eventpoll *ep)
+{
+	if (waitqueue_active(&ep->wq))
+		wake_up_locked(&ep->wq);
+	return waitqueue_active(&ep->poll_wait);
+}
+
 /**
  * ep_scan_ready_list - Scans the ready list in a way that makes possible for
  *                      the scan code, to call f_op->poll(). Also allows for
@@ -620,10 +627,7 @@ static int ep_scan_ready_list(struct eventpoll *ep,
 		 * Wake up (if active) both the eventpoll wait list and
 		 * the ->poll() wait list (delayed after we release the lock).
 		 */
-		if (waitqueue_active(&ep->wq))
-			wake_up_locked(&ep->wq);
-		if (waitqueue_active(&ep->poll_wait))
-			pwake++;
+		pwake = ep_wake_up_locked(ep);
 	}
 	spin_unlock_irqrestore(&ep->lock, flags);
 
@@ -991,10 +995,7 @@ static int ep_poll_callback(wait_queue_t *wait, unsigned mode, int sync, void *k
 	 * Wake up ( if active ) both the eventpoll wait list and the ->poll()
 	 * wait list.
 	 */
-	if (waitqueue_active(&ep->wq))
-		wake_up_locked(&ep->wq);
-	if (waitqueue_active(&ep->poll_wait))
-		pwake++;
+	pwake = ep_wake_up_locked(ep);
 
 out_unlock:
 	spin_unlock_irqrestore(&ep->lock, flags);
@@ -1250,10 +1251,7 @@ static int ep_insert(struct eventpoll *ep, struct epoll_event *event,
 		__pm_stay_awake(epi->ws);
 
 		/* Notify waiting tasks that events are available */
-		if (waitqueue_active(&ep->wq))
-			wake_up_locked(&ep->wq);
-		if (waitqueue_active(&ep->poll_wait))
-			pwake++;
+		pwake = ep_wake_up_locked(ep);
 	}
 
 	spin_unlock_irqrestore(&ep->lock, flags);
@@ -1360,10 +1358,7 @@ static int ep_modify(struct eventpoll *ep, struct epitem *epi, struct epoll_even
 			__pm_stay_awake(epi->ws);
 
 			/* Notify waiting tasks that events are available */
-			if (waitqueue_active(&ep->wq))
-				wake_up_locked(&ep->wq);
-			if (waitqueue_active(&ep->poll_wait))
-				pwake++;
+			pwake = ep_wake_up_locked(ep);
 		}
 		spin_unlock_irq(&ep->lock);
 	}
-- 
1.8.1.2.526.gf51a757

