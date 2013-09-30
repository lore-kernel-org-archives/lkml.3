Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932094Ab3I3WZx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 18:25:53 -0400
Received: from prod-mail-xrelay07.akamai.com ([72.246.2.115]:30003 "EHLO
	prod-mail-xrelay07.akamai.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756490Ab3I3WZn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 18:25:43 -0400
To: akpm@linux-foundation.org
Cc: normalperson@yhbt.net, nzimmer@sgi.com, viro@zeniv.linux.org.uk,
        nelhage@nelhage.com, davidel@xmailserver.org,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Message-Id: <ddf3b5e4f546a5541903eae890a11febeeb90510.1380577995.git.jbaron@akamai.com>
In-Reply-To: <cover.1380577995.git.jbaron@akamai.com>
References: <cover.1380577995.git.jbaron@akamai.com>
From: Jason Baron <jbaron@akamai.com>
Subject: [PATCH 2/3] epoll: Do not take global 'epmutex' for simple topologies
Date: Mon, 30 Sep 2013 22:25:42 +0000 (GMT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When calling EPOLL_CTL_ADD for an epoll file descriptor that is attached
directly to a wakeup source, we do not need to take the global 'epmutex',
unless the epoll file descriptor is nested. The purpose of taking
the 'epmutex' on add is to prevent complex topologies such as loops and
deep wakeup paths from forming in parallel through multiple EPOLL_CTL_ADD
operations. However, for the simple case of an epoll file descriptor
attached directly to a wakeup source (with no nesting), we should not
have to pay by taking the 'epmutex'.

This patch along with 'epoll: optimize EPOLL_CTL_DEL using rcu' improves
scalability on larger systems. Quoting Nathan Zimmer's mail on SPECjbb
performance:

"
On the 16 socket run the performance went from 35k jOPS to 125k jOPS.
In addition the benchmark when from scaling well on 10 sockets to scaling well
on just over 40 sockets.

...

Currently the benchmark stops scaling at around 40-44 sockets but it seems like
I found a second unrelated bottleneck.
"

Tested-by: Nathan Zimmer <nzimmer@sgi.com>
Signed-off-by: Jason Baron <jbaron@akamai.com>
---
 fs/eventpoll.c | 94 ++++++++++++++++++++++++++++++++++++++++++----------------
 1 file changed, 68 insertions(+), 26 deletions(-)

diff --git a/fs/eventpoll.c b/fs/eventpoll.c
index f4251a6..daaec16 100644
--- a/fs/eventpoll.c
+++ b/fs/eventpoll.c
@@ -595,8 +595,7 @@ static inline void ep_pm_stay_awake_rcu(struct epitem *epi)
 static int ep_scan_ready_list(struct eventpoll *ep,
 			      int (*sproc)(struct eventpoll *,
 					   struct list_head *, void *),
-			      void *priv,
-			      int depth)
+			      void *priv, int depth, int ep_locked)
 {
 	int error, pwake = 0;
 	unsigned long flags;
@@ -607,7 +606,9 @@ static int ep_scan_ready_list(struct eventpoll *ep,
 	 * We need to lock this because we could be hit by
 	 * eventpoll_release_file() and epoll_ctl().
 	 */
-	mutex_lock_nested(&ep->mtx, depth);
+
+	if (!ep_locked)
+		mutex_lock_nested(&ep->mtx, depth);
 
 	/*
 	 * Steal the ready list, and re-init the original one to the
@@ -671,7 +672,8 @@ static int ep_scan_ready_list(struct eventpoll *ep,
 	}
 	spin_unlock_irqrestore(&ep->lock, flags);
 
-	mutex_unlock(&ep->mtx);
+	if (!ep_locked)
+		mutex_unlock(&ep->mtx);
 
 	/* We have to call this outside the lock */
 	if (pwake)
@@ -824,15 +826,34 @@ static int ep_read_events_proc(struct eventpoll *ep, struct list_head *head,
 	return 0;
 }
 
+static void ep_ptable_queue_proc(struct file *file, wait_queue_head_t *whead,
+				 poll_table *pt);
+
+struct readyevents_arg {
+	struct eventpoll *ep;
+	int locked;
+};
+
 static int ep_poll_readyevents_proc(void *priv, void *cookie, int call_nests)
 {
-	return ep_scan_ready_list(priv, ep_read_events_proc, NULL, call_nests + 1);
+	struct readyevents_arg *arg = (struct readyevents_arg *)priv;
+
+	return ep_scan_ready_list(arg->ep, ep_read_events_proc, NULL,
+				  call_nests + 1, arg->locked);
 }
 
 static unsigned int ep_eventpoll_poll(struct file *file, poll_table *wait)
 {
 	int pollflags;
 	struct eventpoll *ep = file->private_data;
+	struct readyevents_arg arg;
+
+	/*
+	 * During ep_insert() we already hold the ep->mtx for the tfile.
+	 * Prevent re-aquisition.
+	 */
+	arg.locked = ((wait && (wait->_qproc == ep_ptable_queue_proc)) ? 1 : 0);
+	arg.ep = ep;
 
 	/* Insert inside our poll wait queue */
 	poll_wait(file, &ep->poll_wait, wait);
@@ -844,7 +865,7 @@ static unsigned int ep_eventpoll_poll(struct file *file, poll_table *wait)
 	 * could re-enter here.
 	 */
 	pollflags = ep_call_nested(&poll_readywalk_ncalls, EP_MAX_NESTS,
-				   ep_poll_readyevents_proc, ep, ep, current);
+				   ep_poll_readyevents_proc, &arg, ep, current);
 
 	return pollflags != -1 ? pollflags : 0;
 }
@@ -1245,7 +1266,7 @@ static noinline void ep_destroy_wakeup_source(struct epitem *epi)
  * Must be called with "mtx" held.
  */
 static int ep_insert(struct eventpoll *ep, struct epoll_event *event,
-		     struct file *tfile, int fd)
+		     struct file *tfile, int fd, int full_check)
 {
 	int error, revents, pwake = 0;
 	unsigned long flags;
@@ -1313,7 +1334,7 @@ static int ep_insert(struct eventpoll *ep, struct epoll_event *event,
 
 	/* now check if we've created too many backpaths */
 	error = -EINVAL;
-	if (reverse_path_check())
+	if (full_check && reverse_path_check())
 		goto error_remove_epi;
 
 	/* We have to drop the new item inside our item list to keep track of it */
@@ -1537,7 +1558,7 @@ static int ep_send_events(struct eventpoll *ep,
 	esed.maxevents = maxevents;
 	esed.events = events;
 
-	return ep_scan_ready_list(ep, ep_send_events_proc, &esed, 0);
+	return ep_scan_ready_list(ep, ep_send_events_proc, &esed, 0, 0);
 }
 
 static inline struct timespec ep_set_mstimeout(long ms)
@@ -1808,11 +1829,12 @@ SYSCALL_DEFINE4(epoll_ctl, int, epfd, int, op, int, fd,
 		struct epoll_event __user *, event)
 {
 	int error;
-	int did_lock_epmutex = 0;
+	int full_check = 0;
 	struct fd f, tf;
 	struct eventpoll *ep;
 	struct epitem *epi;
 	struct epoll_event epds;
+	struct eventpoll *tep = NULL;
 
 	error = -EFAULT;
 	if (ep_op_has_event(op) &&
@@ -1861,23 +1883,40 @@ SYSCALL_DEFINE4(epoll_ctl, int, epfd, int, op, int, fd,
 	 * and hang them on the tfile_check_list, so we can check that we
 	 * haven't created too many possible wakeup paths.
 	 *
-	 * We need to hold the epmutex across both ep_insert to prevent
-	 * multple adds from creating loops in parallel.
+	 * We do not need to take the global 'epumutex' on EPOLL_CTL_ADD when
+	 * the epoll file descriptor is attaching directly to a wakeup source,
+	 * unless the epoll file descriptor is nested. The purpose of taking the
+	 * 'epmutex' on add is to prevent complex toplogies such as loops and
+	 * deep wakeup paths from forming in parallel through multiple
+	 * EPOLL_CTL_ADD operations.
 	 */
+	mutex_lock_nested(&ep->mtx, 0);
 	if (op == EPOLL_CTL_ADD) {
-		mutex_lock(&epmutex);
-		did_lock_epmutex = 1;
-		if (is_file_epoll(tf.file)) {
-			error = -ELOOP;
-			if (ep_loop_check(ep, tf.file) != 0) {
-				clear_tfile_check_list();
-				goto error_tgt_fput;
+		if (!list_empty(&f.file->f_ep_links) ||
+						is_file_epoll(tf.file)) {
+			full_check = 1;
+			mutex_unlock(&ep->mtx);
+			mutex_lock(&epmutex);
+			if (is_file_epoll(tf.file)) {
+				error = -ELOOP;
+				if (ep_loop_check(ep, tf.file) != 0) {
+					clear_tfile_check_list();
+					goto error_tgt_fput;
+				}
+			} else
+				list_add(&tf.file->f_tfile_llink,
+							&tfile_check_list);
+			mutex_lock_nested(&ep->mtx, 0);
+			if (is_file_epoll(tf.file)) {
+				tep = tf.file->private_data;
+				mutex_lock_nested(&tep->mtx, 1);
 			}
-		} else
-			list_add(&tf.file->f_tfile_llink, &tfile_check_list);
+		}
+	}
+	if (op == EPOLL_CTL_DEL && is_file_epoll(tf.file)) {
+		tep = tf.file->private_data;
+		mutex_lock_nested(&tep->mtx, 1);
 	}
-
-	mutex_lock_nested(&ep->mtx, 0);
 
 	/*
 	 * Try to lookup the file inside our RB tree, Since we grabbed "mtx"
@@ -1891,10 +1930,11 @@ SYSCALL_DEFINE4(epoll_ctl, int, epfd, int, op, int, fd,
 	case EPOLL_CTL_ADD:
 		if (!epi) {
 			epds.events |= POLLERR | POLLHUP;
-			error = ep_insert(ep, &epds, tf.file, fd);
+			error = ep_insert(ep, &epds, tf.file, fd, full_check);
 		} else
 			error = -EEXIST;
-		clear_tfile_check_list();
+		if (full_check)
+			clear_tfile_check_list();
 		break;
 	case EPOLL_CTL_DEL:
 		if (epi)
@@ -1910,10 +1950,12 @@ SYSCALL_DEFINE4(epoll_ctl, int, epfd, int, op, int, fd,
 			error = -ENOENT;
 		break;
 	}
+	if (tep != NULL)
+		mutex_unlock(&tep->mtx);
 	mutex_unlock(&ep->mtx);
 
 error_tgt_fput:
-	if (did_lock_epmutex)
+	if (full_check)
 		mutex_unlock(&epmutex);
 
 	fdput(tf);
-- 
1.8.2

