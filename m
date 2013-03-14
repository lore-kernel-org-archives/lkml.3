Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751172Ab3CNEFO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 00:05:14 -0400
Received: from dcvr.yhbt.net ([64.71.152.64]:51290 "EHLO dcvr.yhbt.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750862Ab3CNEFM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 00:05:12 -0400
Date: Thu, 14 Mar 2013 04:05:12 +0000
From: Eric Wong <normalperson@yhbt.net>
To: Davide Libenzi <davidel@xmailserver.org>
Cc: Al Viro <viro@ZenIV.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] epoll: cleanup: hoist out f_op->poll calls
Message-ID: <20130314040512.GA12607@dcvr.yhbt.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This reduces the amount of code inside the ready list iteration loops
for better readability IMHO.

Signed-off-by: Eric Wong <normalperson@yhbt.net>
Cc: Davide Libenzi <davidel@xmailserver.org>
Cc: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>
---
 (I think this depends on my RCU wakeup source patch sitting in -mm)

 fs/eventpoll.c | 22 ++++++++++++----------
 1 file changed, 12 insertions(+), 10 deletions(-)

diff --git a/fs/eventpoll.c b/fs/eventpoll.c
index d71b754..a4e4ad7 100644
--- a/fs/eventpoll.c
+++ b/fs/eventpoll.c
@@ -772,6 +772,13 @@ static int ep_eventpoll_release(struct inode *inode, struct file *file)
 	return 0;
 }
 
+static inline unsigned int ep_item_poll(struct epitem *epi, poll_table *pt)
+{
+	pt->_key = epi->event.events;
+
+	return epi->ffd.file->f_op->poll(epi->ffd.file, pt) & epi->event.events;
+}
+
 static int ep_read_events_proc(struct eventpoll *ep, struct list_head *head,
 			       void *priv)
 {
@@ -779,10 +786,9 @@ static int ep_read_events_proc(struct eventpoll *ep, struct list_head *head,
 	poll_table pt;
 
 	init_poll_funcptr(&pt, NULL);
+
 	list_for_each_entry_safe(epi, tmp, head, rdllink) {
-		pt._key = epi->event.events;
-		if (epi->ffd.file->f_op->poll(epi->ffd.file, &pt) &
-		    epi->event.events)
+		if (ep_item_poll(epi, &pt))
 			return POLLIN | POLLRDNORM;
 		else {
 			/*
@@ -1256,7 +1262,6 @@ static int ep_insert(struct eventpoll *ep, struct epoll_event *event,
 	/* Initialize the poll table using the queue callback */
 	epq.epi = epi;
 	init_poll_funcptr(&epq.pt, ep_ptable_queue_proc);
-	epq.pt._key = event->events;
 
 	/*
 	 * Attach the item to the poll hooks and get current event bits.
@@ -1265,7 +1270,7 @@ static int ep_insert(struct eventpoll *ep, struct epoll_event *event,
 	 * this operation completes, the poll callback can start hitting
 	 * the new item.
 	 */
-	revents = tfile->f_op->poll(tfile, &epq.pt);
+	revents = ep_item_poll(epi, &epq.pt);
 
 	/*
 	 * We have to check if something went wrong during the poll wait queue
@@ -1365,7 +1370,6 @@ static int ep_modify(struct eventpoll *ep, struct epitem *epi, struct epoll_even
 	 * f_op->poll() call and the new event set registering.
 	 */
 	epi->event.events = event->events; /* need barrier below */
-	pt._key = event->events;
 	epi->event.data = event->data; /* protected by mtx */
 	if (epi->event.events & EPOLLWAKEUP) {
 		if (!ep_has_wakeup_source(epi))
@@ -1398,7 +1402,7 @@ static int ep_modify(struct eventpoll *ep, struct epitem *epi, struct epoll_even
 	 * Get current event bits. We can safely use the file* here because
 	 * its usage count has been increased by the caller of this function.
 	 */
-	revents = epi->ffd.file->f_op->poll(epi->ffd.file, &pt);
+	revents = ep_item_poll(epi, &pt);
 
 	/*
 	 * If the item is "hot" and it is not registered inside the ready
@@ -1466,9 +1470,7 @@ static int ep_send_events_proc(struct eventpoll *ep, struct list_head *head,
 
 		list_del_init(&epi->rdllink);
 
-		pt._key = epi->event.events;
-		revents = epi->ffd.file->f_op->poll(epi->ffd.file, &pt) &
-			epi->event.events;
+		revents = ep_item_poll(epi, &pt);
 
 		/*
 		 * If the event mask intersect the caller-requested one,
-- 
Eric Wong
