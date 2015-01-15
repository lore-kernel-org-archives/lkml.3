Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754935AbbAOVCf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 16:02:35 -0500
Received: from prod-mail-xrelay02.akamai.com ([72.246.2.14]:35290 "EHLO
	prod-mail-xrelay02.akamai.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754094AbbAOVCb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 16:02:31 -0500
To: akpm@linux-foundation.org, famz@redhat.com
Cc: normalperson@yhbt.net, nzimmer@sgi.com, viro@zeniv.linux.org.uk,
        davidel@xmailserver.org, rostedt@goodmis.org,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Message-Id: <ccd8cbe1cf046c2036c100781a9122e3153577c4.1421337657.git.jbaron@akamai.com>
In-Reply-To: <cover.1421337657.git.jbaron@akamai.com>
References: <cover.1421337657.git.jbaron@akamai.com>
From: Jason Baron <jbaron@akamai.com>
Subject: [RFC PATCH 1/5] epoll: remove ep_call_nested() from ep_eventpoll_poll()
Date: Thu, 15 Jan 2015 21:02:30 +0000 (GMT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The use of ep_call_nested() in ep_eventpoll_poll(), which is the .poll
routine for an epoll fd, is used to prevent excessively deep epoll
nesting, and to prevent circular paths. However, we are already preventing
circular paths during EPOLL_CTL_ADD. In terms of too deep epoll chains,
we do in fact allow deep nesting of the epoll fds themselves (deeper
than EP_MAX_NESTS), however we don't allow more than EP_MAX_NESTS when
an epoll file descriptor is actually connected to a wakeup source. Thus,
any deeper nesting than EP_MAX_NESTS must terminate after only 1 level
nesting during poll(), since the poll() is called through ep_scan_ready_list(),
which only calls deeper nests, if there are events available. In the
case of no wakeup sources this is then not possible.

Removing ep_call_nested(), reduces the function call stack for deep epoll
chains, and in addition prevents the acquisition of a global spin_lock()
that was in use in ep_call_nested().

Signed-off-by: Jason Baron <jbaron@akamai.com>
---
 fs/eventpoll.c | 59 +++++++++++++++++++++++-----------------------------------
 1 file changed, 23 insertions(+), 36 deletions(-)

diff --git a/fs/eventpoll.c b/fs/eventpoll.c
index d77f944..e7b0c9e 100644
--- a/fs/eventpoll.c
+++ b/fs/eventpoll.c
@@ -268,9 +268,6 @@ static struct nested_calls poll_loop_ncalls;
 /* Used for safe wake up implementation */
 static struct nested_calls poll_safewake_ncalls;
 
-/* Used to call file's f_op->poll() under the nested calls boundaries */
-static struct nested_calls poll_readywalk_ncalls;
-
 /* Slab cache used to allocate "struct epitem" */
 static struct kmem_cache *epi_cache __read_mostly;
 
@@ -793,6 +790,9 @@ static int ep_eventpoll_release(struct inode *inode, struct file *file)
 	return 0;
 }
 
+static int ep_read_events_proc(struct eventpoll *ep, struct list_head *head,
+			       void *priv);
+
 static inline unsigned int ep_item_poll(struct epitem *epi, poll_table *pt)
 {
 	pt->_key = epi->event.events;
@@ -800,16 +800,31 @@ static inline unsigned int ep_item_poll(struct epitem *epi, poll_table *pt)
 	return epi->ffd.file->f_op->poll(epi->ffd.file, pt) & epi->event.events;
 }
 
+static inline unsigned int ep_item_poll_recurse(struct epitem *epi,
+						poll_table *pt, int depth)
+{
+	pt->_key = epi->event.events;
+
+	if (is_file_epoll(epi->ffd.file)) {
+		depth++;
+		return ep_scan_ready_list(epi->ffd.file->private_data,
+					  ep_read_events_proc, &depth, depth,
+					  false) & epi->event.events;
+	}
+	return epi->ffd.file->f_op->poll(epi->ffd.file, pt) & epi->event.events;
+}
+
 static int ep_read_events_proc(struct eventpoll *ep, struct list_head *head,
 			       void *priv)
 {
 	struct epitem *epi, *tmp;
 	poll_table pt;
+	int depth = *(int *)priv;
 
 	init_poll_funcptr(&pt, NULL);
 
 	list_for_each_entry_safe(epi, tmp, head, rdllink) {
-		if (ep_item_poll(epi, &pt))
+		if (ep_item_poll_recurse(epi, &pt, depth))
 			return POLLIN | POLLRDNORM;
 		else {
 			/*
@@ -828,45 +843,20 @@ static int ep_read_events_proc(struct eventpoll *ep, struct list_head *head,
 static void ep_ptable_queue_proc(struct file *file, wait_queue_head_t *whead,
 				 poll_table *pt);
 
-struct readyevents_arg {
-	struct eventpoll *ep;
-	bool locked;
-};
-
-static int ep_poll_readyevents_proc(void *priv, void *cookie, int call_nests)
-{
-	struct readyevents_arg *arg = priv;
-
-	return ep_scan_ready_list(arg->ep, ep_read_events_proc, NULL,
-				  call_nests + 1, arg->locked);
-}
-
 static unsigned int ep_eventpoll_poll(struct file *file, poll_table *wait)
 {
-	int pollflags;
 	struct eventpoll *ep = file->private_data;
-	struct readyevents_arg arg;
-
-	/*
-	 * During ep_insert() we already hold the ep->mtx for the tfile.
-	 * Prevent re-aquisition.
-	 */
-	arg.locked = wait && (wait->_qproc == ep_ptable_queue_proc);
-	arg.ep = ep;
+	int depth = 0;
 
 	/* Insert inside our poll wait queue */
 	poll_wait(file, &ep->poll_wait, wait);
 
 	/*
 	 * Proceed to find out if wanted events are really available inside
-	 * the ready list. This need to be done under ep_call_nested()
-	 * supervision, since the call to f_op->poll() done on listed files
-	 * could re-enter here.
+	 * the ready list.
 	 */
-	pollflags = ep_call_nested(&poll_readywalk_ncalls, EP_MAX_NESTS,
-				   ep_poll_readyevents_proc, &arg, ep, current);
-
-	return pollflags != -1 ? pollflags : 0;
+	return ep_scan_ready_list(ep, ep_read_events_proc, &depth, depth,
+				wait && (wait->_qproc == ep_ptable_queue_proc));
 }
 
 #ifdef CONFIG_PROC_FS
@@ -2111,9 +2101,6 @@ static int __init eventpoll_init(void)
 	/* Initialize the structure used to perform safe poll wait head wake ups */
 	ep_nested_calls_init(&poll_safewake_ncalls);
 
-	/* Initialize the structure used to perform file's f_op->poll() calls */
-	ep_nested_calls_init(&poll_readywalk_ncalls);
-
 	/*
 	 * We can have many thousands of epitems, so prevent this from
 	 * using an extra cache line on 64-bit (and smaller) CPUs
-- 
1.8.2.rc2

