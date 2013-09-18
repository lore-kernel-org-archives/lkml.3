Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753502Ab3IRTJd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Sep 2013 15:09:33 -0400
Received: from prod-mail-xrelay07.akamai.com ([72.246.2.115]:14801 "EHLO
	prod-mail-xrelay07.akamai.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752678Ab3IRTJb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Sep 2013 15:09:31 -0400
Message-ID: <5239FA69.8030202@akamai.com>
Date: Wed, 18 Sep 2013 15:09:29 -0400
From: Jason Baron <jbaron@akamai.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Nathan Zimmer <nzimmer@sgi.com>
CC: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [RFC] eventpoll: Move a kmem_cache_alloc and kmem_cache_free
References: <1379087642-131349-1-git-send-email-nzimmer@sgi.com>
In-Reply-To: <1379087642-131349-1-git-send-email-nzimmer@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/13/2013 11:54 AM, Nathan Zimmer wrote:
> We noticed some scaling issue in the SPECjbb benchmark.  Running perf
> we found that the it was spending lots of time in SYS_epoll_ctl.
> In particular it is holding the epmutex.
> This patch helps by moving out the kmem_cache_alloc and kmem_cache_free out
> from under the lock.  It improves throughput by around 15% on 16 sockets.
> 
> While this patch should be fine as it is there are probably is more things
> that can be done out side the lock, like wakeup_source_unregister, but I am
> not familar with the area and I don't know of many tests.  I did find the
> one posted by Jason Baron at https://lkml.org/lkml/2011/2/25/297.
> 
> Any thoughts?
>

Hi,

Intersting - I think its also possible to completely drop taking the
'epmutex' for EPOLL_CTL_DEL by using rcu, and restricting it on add
to more 'complex' topologies. That is when we have an epoll descriptor
that doesn't nest with other epoll descriptors, we don't need the
global 'epmutex' either. Any chance you can re-run with this? Its a bit
hacky, but we can clean it up if it makes sense.

Thanks,

-Jason

    epoll: reduce usage of global 'epmutex' lock
    
    Epoll file descriptors that are 1 link from a wakeup source and are not nested
    within other epoll descriptors, or pointing to other epoll descriptors, don't
    need to check for loop creation or the creation of wakeup storms. Because of
    this we can avoid taking the global 'epmutex' in these cases. This state for
    the epoll file descriptor is marked as 'EVENTPOLL_BASIC'. Once the epoll file
    descriptor is attached to another epoll file descriptor it is labeled as
    'EVENTPOLL_COMPLEX', and full loop checking and wakeup storm creation are
    checked using the the global 'epmutex'. It does not transition back. Hopefully,
    this is a common usecase...
    
    Also optimize EPOLL_CTL_DEL so that it does not require the 'epmutex' by
    converting the file->f_ep_links list into an rcu one. In this way, we can
    traverse the epoll network on the add path in parallel with deletes. Since
    deletes can't create loops or worse wakeup paths, this is safe. In order,
    to not expand the 'struct epitem' data structure, use the 'struct rb_node rbn',
    which is embedded in the 'stuct epitem' as the 'rcu_head' callback point. This
    is ok, since the 'rbn' is no longer in use when we go to free the epitem. There
    is currently a build-time error check for expanding the epi which I am trying
    to work around (Yes, this is a hack). In addition, we add a check to make sure
    that 'struct rb_node' is >= 'struct rcu_head'.
    
    Signed-off-by: Jason Baron <jbaron@akamai.com>

diff --git a/fs/eventpoll.c b/fs/eventpoll.c
index 473e09d..d98105d 100644
--- a/fs/eventpoll.c
+++ b/fs/eventpoll.c
@@ -42,6 +42,7 @@
 #include <linux/proc_fs.h>
 #include <linux/seq_file.h>
 #include <linux/compat.h>
+#include <linux/rculist.h>
 
 /*
  * LOCKING:
@@ -166,6 +167,14 @@ struct epitem {
 
 	/* The structure that describe the interested events and the source fd */
 	struct epoll_event event;
+
+	/* TODO: really necessary? */
+	int on_list;
+};
+
+enum eventpoll_type {
+	EVENTPOLL_BASIC,
+	EVENTPOLL_COMPLEX
 };
 
 /*
@@ -215,6 +224,9 @@ struct eventpoll {
 	/* used to optimize loop detection check */
 	int visited;
 	struct list_head visited_list_link;
+
+	/* used to optimized loop checking */
+	int type;
 };
 
 /* Wait structure used by the poll hooks */
@@ -587,8 +599,7 @@ static inline void ep_pm_stay_awake_rcu(struct epitem *epi)
 static int ep_scan_ready_list(struct eventpoll *ep,
 			      int (*sproc)(struct eventpoll *,
 					   struct list_head *, void *),
-			      void *priv,
-			      int depth)
+			      void *priv, int depth, int locked)
 {
 	int error, pwake = 0;
 	unsigned long flags;
@@ -599,7 +610,9 @@ static int ep_scan_ready_list(struct eventpoll *ep,
 	 * We need to lock this because we could be hit by
 	 * eventpoll_release_file() and epoll_ctl().
 	 */
-	mutex_lock_nested(&ep->mtx, depth);
+
+	if (!locked)
+		mutex_lock_nested(&ep->mtx, depth);
 
 	/*
 	 * Steal the ready list, and re-init the original one to the
@@ -663,7 +676,8 @@ static int ep_scan_ready_list(struct eventpoll *ep,
 	}
 	spin_unlock_irqrestore(&ep->lock, flags);
 
-	mutex_unlock(&ep->mtx);
+	if (!locked)
+		mutex_unlock(&ep->mtx);
 
 	/* We have to call this outside the lock */
 	if (pwake)
@@ -672,6 +686,13 @@ static int ep_scan_ready_list(struct eventpoll *ep,
 	return error;
 }
 
+static void epi_rcu_free(struct rcu_head *rcu)
+{
+	struct epitem *epi = (struct epitem *)((char *)rcu - offsetof(struct epitem, rbn));
+
+	kmem_cache_free(epi_cache, epi);
+}
+
 /*
  * Removes a "struct epitem" from the eventpoll RB tree and deallocates
  * all the associated resources. Must be called with "mtx" held.
@@ -693,8 +714,10 @@ static int ep_remove(struct eventpoll *ep, struct epitem *epi)
 
 	/* Remove the current item from the list of epoll hooks */
 	spin_lock(&file->f_lock);
-	if (ep_is_linked(&epi->fllink))
-		list_del_init(&epi->fllink);
+	if (epi->on_list) {
+		list_del_rcu(&epi->fllink);
+		epi->on_list = 0;
+	}
 	spin_unlock(&file->f_lock);
 
 	rb_erase(&epi->rbn, &ep->rbr);
@@ -707,7 +730,11 @@ static int ep_remove(struct eventpoll *ep, struct epitem *epi)
 	wakeup_source_unregister(ep_wakeup_source(epi));
 
 	/* At this point it is safe to free the eventpoll item */
-	kmem_cache_free(epi_cache, epi);
+	/*
+	   hacky but don't want to increase size, access must use
+	   protected by ep->mtx
+	 */
+	call_rcu((struct rcu_head *)&epi->rbn, epi_rcu_free);
 
 	atomic_long_dec(&ep->user->epoll_watches);
 
@@ -733,6 +760,8 @@ static void ep_free(struct eventpoll *ep)
 	 */
 	mutex_lock(&epmutex);
 
+	/* TODO: move ep->mtx locking up to avoid CTL_DEL vs. this in rcu usage of rbp */
+	mutex_lock(&ep->mtx);
 	/*
 	 * Walks through the whole tree by unregistering poll callbacks.
 	 */
@@ -751,7 +780,6 @@ static void ep_free(struct eventpoll *ep)
 	 * We do not need to lock ep->mtx, either, we only do it to prevent
 	 * a lockdep warning.
 	 */
-	mutex_lock(&ep->mtx);
 	while ((rbp = rb_first(&ep->rbr)) != NULL) {
 		epi = rb_entry(rbp, struct epitem, rbn);
 		ep_remove(ep, epi);
@@ -808,15 +836,29 @@ static int ep_read_events_proc(struct eventpoll *ep, struct list_head *head,
 	return 0;
 }
 
+struct readyevents_params {
+	struct eventpoll *ep;
+	int locked;
+};
+
 static int ep_poll_readyevents_proc(void *priv, void *cookie, int call_nests)
 {
-	return ep_scan_ready_list(priv, ep_read_events_proc, NULL, call_nests + 1);
+	struct readyevents_params *params = (struct readyevents_params *)priv;
+
+	return ep_scan_ready_list(params->ep, ep_read_events_proc, NULL, call_nests + 1, params->locked);
 }
 
+static void ep_ptable_queue_proc(struct file *file, wait_queue_head_t *whead,
+				 poll_table *pt);
+
 static unsigned int ep_eventpoll_poll(struct file *file, poll_table *wait)
 {
 	int pollflags;
 	struct eventpoll *ep = file->private_data;
+	struct readyevents_params params;
+
+	params.locked = ((wait->_qproc == ep_ptable_queue_proc) ? 1 : 0);
+	params.ep = ep;
 
 	/* Insert inside our poll wait queue */
 	poll_wait(file, &ep->poll_wait, wait);
@@ -828,7 +870,7 @@ static unsigned int ep_eventpoll_poll(struct file *file, poll_table *wait)
 	 * could re-enter here.
 	 */
 	pollflags = ep_call_nested(&poll_readywalk_ncalls, EP_MAX_NESTS,
-				   ep_poll_readyevents_proc, ep, ep, current);
+				   ep_poll_readyevents_proc, &params, ep, current);
 
 	return pollflags != -1 ? pollflags : 0;
 }
@@ -873,7 +915,6 @@ static const struct file_operations eventpoll_fops = {
  */
 void eventpoll_release_file(struct file *file)
 {
-	struct list_head *lsthead = &file->f_ep_links;
 	struct eventpoll *ep;
 	struct epitem *epi;
 
@@ -891,17 +932,12 @@ void eventpoll_release_file(struct file *file)
 	 * Besides, ep_remove() acquires the lock, so we can't hold it here.
 	 */
 	mutex_lock(&epmutex);
-
-	while (!list_empty(lsthead)) {
-		epi = list_first_entry(lsthead, struct epitem, fllink);
-
+	list_for_each_entry_rcu(epi, &file->f_ep_links, fllink) {
 		ep = epi->ep;
-		list_del_init(&epi->fllink);
 		mutex_lock_nested(&ep->mtx, 0);
 		ep_remove(ep, epi);
 		mutex_unlock(&ep->mtx);
 	}
-
 	mutex_unlock(&epmutex);
 }
 
@@ -925,6 +961,7 @@ static int ep_alloc(struct eventpoll **pep)
 	ep->rbr = RB_ROOT;
 	ep->ovflist = EP_UNACTIVE_PTR;
 	ep->user = user;
+	ep->type = EVENTPOLL_BASIC;
 
 	*pep = ep;
 
@@ -1139,7 +1176,9 @@ static int reverse_path_check_proc(void *priv, void *cookie, int call_nests)
 	struct file *child_file;
 	struct epitem *epi;
 
-	list_for_each_entry(epi, &file->f_ep_links, fllink) {
+	/* could be removed but shouldn't effect the count */
+	rcu_read_lock();
+	list_for_each_entry_rcu(epi, &file->f_ep_links, fllink) {
 		child_file = epi->ep->file;
 		if (is_file_epoll(child_file)) {
 			if (list_empty(&child_file->f_ep_links)) {
@@ -1161,6 +1200,7 @@ static int reverse_path_check_proc(void *priv, void *cookie, int call_nests)
 				"file is not an ep!\n");
 		}
 	}
+	rcu_read_unlock();
 	return error;
 }
 
@@ -1232,7 +1272,7 @@ static noinline void ep_destroy_wakeup_source(struct epitem *epi)
  * Must be called with "mtx" held.
  */
 static int ep_insert(struct eventpoll *ep, struct epoll_event *event,
-		     struct file *tfile, int fd)
+		     struct file *tfile, int fd, int full_check)
 {
 	int error, revents, pwake = 0;
 	unsigned long flags;
@@ -1255,6 +1295,7 @@ static int ep_insert(struct eventpoll *ep, struct epoll_event *event,
 	epi->event = *event;
 	epi->nwait = 0;
 	epi->next = EP_UNACTIVE_PTR;
+	epi->on_list = 0;
 	if (epi->event.events & EPOLLWAKEUP) {
 		error = ep_create_wakeup_source(epi);
 		if (error)
@@ -1287,7 +1328,8 @@ static int ep_insert(struct eventpoll *ep, struct epoll_event *event,
 
 	/* Add the current item to the list of active epoll hook for this file */
 	spin_lock(&tfile->f_lock);
-	list_add_tail(&epi->fllink, &tfile->f_ep_links);
+	list_add_tail_rcu(&epi->fllink, &tfile->f_ep_links);
+	epi->on_list = 1;
 	spin_unlock(&tfile->f_lock);
 
 	/*
@@ -1298,7 +1340,7 @@ static int ep_insert(struct eventpoll *ep, struct epoll_event *event,
 
 	/* now check if we've created too many backpaths */
 	error = -EINVAL;
-	if (reverse_path_check())
+	if (full_check && reverse_path_check())
 		goto error_remove_epi;
 
 	/* We have to drop the new item inside our item list to keep track of it */
@@ -1328,8 +1370,8 @@ static int ep_insert(struct eventpoll *ep, struct epoll_event *event,
 
 error_remove_epi:
 	spin_lock(&tfile->f_lock);
-	if (ep_is_linked(&epi->fllink))
-		list_del_init(&epi->fllink);
+	if (epi->on_list)
+		list_del_rcu(&epi->fllink);
 	spin_unlock(&tfile->f_lock);
 
 	rb_erase(&epi->rbn, &ep->rbr);
@@ -1522,7 +1564,7 @@ static int ep_send_events(struct eventpoll *ep,
 	esed.maxevents = maxevents;
 	esed.events = events;
 
-	return ep_scan_ready_list(ep, ep_send_events_proc, &esed, 0);
+	return ep_scan_ready_list(ep, ep_send_events_proc, &esed, 0, 0);
 }
 
 static inline struct timespec ep_set_mstimeout(long ms)
@@ -1793,7 +1835,7 @@ SYSCALL_DEFINE4(epoll_ctl, int, epfd, int, op, int, fd,
 		struct epoll_event __user *, event)
 {
 	int error;
-	int did_lock_epmutex = 0;
+	int full_check = 0;
 	struct fd f, tf;
 	struct eventpoll *ep;
 	struct epitem *epi;
@@ -1850,23 +1892,29 @@ SYSCALL_DEFINE4(epoll_ctl, int, epfd, int, op, int, fd,
 	 * b/c we want to make sure we are looking at a coherent view of
 	 * epoll network.
 	 */
-	if (op == EPOLL_CTL_ADD || op == EPOLL_CTL_DEL) {
-		mutex_lock(&epmutex);
-		did_lock_epmutex = 1;
-	}
+	mutex_lock_nested(&ep->mtx, 0);
 	if (op == EPOLL_CTL_ADD) {
-		if (is_file_epoll(tf.file)) {
-			error = -ELOOP;
-			if (ep_loop_check(ep, tf.file) != 0) {
-				clear_tfile_check_list();
-				goto error_tgt_fput;
+		if (ep->type == EVENTPOLL_COMPLEX || is_file_epoll(tf.file)) {
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
+				list_add(&tf.file->f_tfile_llink, &tfile_check_list);
+			mutex_lock_nested(&ep->mtx, 0);
+			ep->type = EVENTPOLL_COMPLEX;
+			if (is_file_epoll(tf.file)) {
+				mutex_lock_nested(&(((struct eventpoll *)tf.file->private_data)->mtx), 1);
+				((struct eventpoll *)tf.file->private_data)->type = EVENTPOLL_COMPLEX;
 			}
-		} else
-			list_add(&tf.file->f_tfile_llink, &tfile_check_list);
+		}
 	}
 
-	mutex_lock_nested(&ep->mtx, 0);
-
 	/*
 	 * Try to lookup the file inside our RB tree, Since we grabbed "mtx"
 	 * above, we can be sure to be able to use the item looked up by
@@ -1879,10 +1927,11 @@ SYSCALL_DEFINE4(epoll_ctl, int, epfd, int, op, int, fd,
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
@@ -1898,10 +1947,12 @@ SYSCALL_DEFINE4(epoll_ctl, int, epfd, int, op, int, fd,
 			error = -ENOENT;
 		break;
 	}
+	if (full_check && is_file_epoll(tf.file))
+		mutex_unlock(&(((struct eventpoll *)tf.file->private_data)->mtx));
 	mutex_unlock(&ep->mtx);
 
 error_tgt_fput:
-	if (did_lock_epmutex)
+	if (full_check)
 		mutex_unlock(&epmutex);
 
 	fdput(tf);
@@ -2078,6 +2129,9 @@ static int __init eventpoll_init(void)
 	 */
 	BUILD_BUG_ON(sizeof(void *) <= 8 && sizeof(struct epitem) > 128);
 
+	/* make sure the overloading continues to work */
+	BUILD_BUG_ON(sizeof(struct rb_node) < sizeof(struct rcu_head));
+
 	/* Allocates slab cache used to allocate "struct epitem" items */
 	epi_cache = kmem_cache_create("eventpoll_epi", sizeof(struct epitem),
 			0, SLAB_HWCACHE_ALIGN | SLAB_PANIC, NULL);

