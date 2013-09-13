Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757472Ab3IMPyN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 11:54:13 -0400
Received: from relay1.sgi.com ([192.48.179.29]:43578 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757321Ab3IMPyL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 11:54:11 -0400
From: Nathan Zimmer <nzimmer@sgi.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Nathan Zimmer <nzimmer@sgi.com>, Al Viro <viro@zeniv.linux.org.uk>,
        Jason Baron <jbaron@redhat.com>
Subject: [RFC] eventpoll: Move a kmem_cache_alloc and kmem_cache_free
Date: Fri, 13 Sep 2013 10:54:02 -0500
Message-Id: <1379087642-131349-1-git-send-email-nzimmer@sgi.com>
X-Mailer: git-send-email 1.8.2.1
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We noticed some scaling issue in the SPECjbb benchmark.  Running perf
we found that the it was spending lots of time in SYS_epoll_ctl.
In particular it is holding the epmutex.
This patch helps by moving out the kmem_cache_alloc and kmem_cache_free out
from under the lock.  It improves throughput by around 15% on 16 sockets.

While this patch should be fine as it is there are probably is more things
that can be done out side the lock, like wakeup_source_unregister, but I am
not familar with the area and I don't know of many tests.  I did find the
one posted by Jason Baron at https://lkml.org/lkml/2011/2/25/297.

Any thoughts?

Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Jason Baron <jbaron@redhat.com>
Reported-by: Jerry Lohr <glohr@sgi.com>
Signed-off-by: Nathan Zimmer <nzimmer@sgi.com>
---
 fs/eventpoll.c | 27 ++++++++++++++++++---------
 1 file changed, 18 insertions(+), 9 deletions(-)

diff --git a/fs/eventpoll.c b/fs/eventpoll.c
index 9ad17b15..752e5ff 100644
--- a/fs/eventpoll.c
+++ b/fs/eventpoll.c
@@ -707,7 +707,6 @@ static int ep_remove(struct eventpoll *ep, struct epitem *epi)
 	wakeup_source_unregister(ep_wakeup_source(epi));
 
 	/* At this point it is safe to free the eventpoll item */
-	kmem_cache_free(epi_cache, epi);
 
 	atomic_long_dec(&ep->user->epoll_watches);
 
@@ -754,6 +753,7 @@ static void ep_free(struct eventpoll *ep)
 	while ((rbp = rb_first(&ep->rbr)) != NULL) {
 		epi = rb_entry(rbp, struct epitem, rbn);
 		ep_remove(ep, epi);
+		kmem_cache_free(epi_cache, epi);
 	}
 	mutex_unlock(&ep->mtx);
 
@@ -1230,18 +1230,17 @@ static noinline void ep_destroy_wakeup_source(struct epitem *epi)
  * Must be called with "mtx" held.
  */
 static int ep_insert(struct eventpoll *ep, struct epoll_event *event,
-		     struct file *tfile, int fd)
+		     struct file *tfile, int fd, struct epitem *epi)
 {
 	int error, revents, pwake = 0;
 	unsigned long flags;
 	long user_watches;
-	struct epitem *epi;
 	struct ep_pqueue epq;
 
 	user_watches = atomic_long_read(&ep->user->epoll_watches);
 	if (unlikely(user_watches >= max_user_watches))
 		return -ENOSPC;
-	if (!(epi = kmem_cache_alloc(epi_cache, GFP_KERNEL)))
+	if (!epi)
 		return -ENOMEM;
 
 	/* Item initialization follow here ... */
@@ -1349,7 +1348,6 @@ error_unregister:
 	wakeup_source_unregister(ep_wakeup_source(epi));
 
 error_create_wakeup_source:
-	kmem_cache_free(epi_cache, epi);
 
 	return error;
 }
@@ -1795,6 +1793,8 @@ SYSCALL_DEFINE4(epoll_ctl, int, epfd, int, op, int, fd,
 	struct file *file, *tfile;
 	struct eventpoll *ep;
 	struct epitem *epi;
+	struct epitem *epi_prepped = NULL;
+	struct epitem *epi_dropped = NULL;
 	struct epoll_event epds;
 
 	error = -EFAULT;
@@ -1849,6 +1849,9 @@ SYSCALL_DEFINE4(epoll_ctl, int, epfd, int, op, int, fd,
 	 * b/c we want to make sure we are looking at a coherent view of
 	 * epoll network.
 	 */
+	if (op == EPOLL_CTL_ADD)
+		epi_prepped = kmem_cache_alloc(epi_cache, GFP_KERNEL);
+
 	if (op == EPOLL_CTL_ADD || op == EPOLL_CTL_DEL) {
 		mutex_lock(&epmutex);
 		did_lock_epmutex = 1;
@@ -1878,15 +1881,19 @@ SYSCALL_DEFINE4(epoll_ctl, int, epfd, int, op, int, fd,
 	case EPOLL_CTL_ADD:
 		if (!epi) {
 			epds.events |= POLLERR | POLLHUP;
-			error = ep_insert(ep, &epds, tfile, fd);
-		} else
+			error = ep_insert(ep, &epds, tfile, fd, epi_prepped);
+			if (error)
+				epi_dropped = epi_prepped;
+		} else {
 			error = -EEXIST;
+		}
 		clear_tfile_check_list();
 		break;
 	case EPOLL_CTL_DEL:
-		if (epi)
+		if (epi) {
 			error = ep_remove(ep, epi);
-		else
+			epi_dropped = epi;
+		} else
 			error = -ENOENT;
 		break;
 	case EPOLL_CTL_MOD:
@@ -1902,6 +1909,8 @@ SYSCALL_DEFINE4(epoll_ctl, int, epfd, int, op, int, fd,
 error_tgt_fput:
 	if (did_lock_epmutex)
 		mutex_unlock(&epmutex);
+	if (epi_dropped)
+		kmem_cache_free(epi_cache, epi_dropped);
 
 	fput(tfile);
 error_fput:
-- 
1.8.2.1

