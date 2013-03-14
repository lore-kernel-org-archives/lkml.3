Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752031Ab3CNEmV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 00:42:21 -0400
Received: from dcvr.yhbt.net ([64.71.152.64]:51532 "EHLO dcvr.yhbt.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751309Ab3CNEmQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 00:42:16 -0400
Date: Thu, 14 Mar 2013 04:42:15 +0000
From: Eric Wong <normalperson@yhbt.net>
To: linux-kernel@vger.kernel.org
Cc: Davide Libenzi <davidel@xmailserver.org>,
        Al Viro <viro@ZenIV.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        linux-fsdevel@vger.kernel.org
Subject: [RFC] epoll: avoid spinlock contention with wfcqueue
Message-ID: <20130314044215.GA27312@dcvr.yhbt.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm posting this lightly tested version since I may not be able to do
more testing/benchmarking until the weekend.

Davide's totalmess is still running, so that's probably a good sign :)
http://www.xmailserver.org/totalmess.c
I will look for more ways to break this (and benchmark when I stop
finding ways to break it).  No real applications tested, yet, and
I think I can improve upon this, too.

This depends on a couple of patches sitting in -mm and a few
more I've posted on LKML, for convenience everything is here:

	http://yhbt.net/epoll-wfcqueue-v3.8.2-20130314.mbox
(should apply cleanly to 3.9-rc* since there's no epoll changes in that)

--------------------------8<-------------------------------
>From 139f0d4528c3fabc6a54e47be73ba9990b42cdd8 Mon Sep 17 00:00:00 2001
From: Eric Wong <normalperson@yhbt.net>
Date: Thu, 14 Mar 2013 02:37:12 +0000
Subject: [PATCH] epoll: avoid spinlock contention with wfcqueue

This is not a proper commit, I've barely tested this.

Replace the spinlock-protected linked list ready list with wfcqueue.

There is still a per-epitem atomic variable which may still spin.  The
likelyhood of contention is very low since it's not shared by the entire
structure, the state is private to each epitem.

Things changed/removed:

* ep->ovflist - the atomic, per-epitem state field prevents
  event loss during ep_send_events.

* ep_scan_ready_list - not enough generic code between users
  anymore to warrant this.  ep_poll_readyevents_proc (used for
  poll) is read-only, ep_send_events (used for epoll_wait)
  dequeues.

* ep->lock renamed to ep->wqlock; this only protects waitqueues now.
  (will experiment with making it trylock in some places, next)

* EPOLL_CTL_DEL/close() on a ready file will not immediately release
  epitem memory, epoll_wait() must be called since there's no way to
  delete a ready item from wfcqueue in O(1) time.  In practice this
  should not be a problem, any valid app using epoll must call
  epoll_wait occasionally.  Unfreed epitems still count against
  max_user_watches to protect against local DoS.  This should be the
  only possibly-noticeable change (in case there's an app that blindly
  adds/deletes things from the rbtree but never calls epoll_wait)

Barely-tested-by: Eric Wong <normalperson@yhbt.net>
Cc: Davide Libenzi <davidel@xmailserver.org>
Cc: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
---
 fs/eventpoll.c | 631 ++++++++++++++++++++++++++-------------------------------
 1 file changed, 292 insertions(+), 339 deletions(-)

diff --git a/fs/eventpoll.c b/fs/eventpoll.c
index a4e4ad7..6159b85 100644
--- a/fs/eventpoll.c
+++ b/fs/eventpoll.c
@@ -40,6 +40,7 @@
 #include <linux/atomic.h>
 #include <linux/proc_fs.h>
 #include <linux/seq_file.h>
+#include <linux/wfcqueue.h>
 
 /*
  * LOCKING:
@@ -47,15 +48,13 @@
  *
  * 1) epmutex (mutex)
  * 2) ep->mtx (mutex)
- * 3) ep->lock (spinlock)
+ * 3) ep->wqlock (spinlock)
  *
- * The acquire order is the one listed above, from 1 to 3.
- * We need a spinlock (ep->lock) because we manipulate objects
- * from inside the poll callback, that might be triggered from
- * a wake_up() that in turn might be called from IRQ context.
- * So we can't sleep inside the poll callback and hence we need
- * a spinlock. During the event transfer loop (from kernel to
- * user space) we could end up sleeping due a copy_to_user(), so
+ * The acquire order is the one listed above, from 1 to 2.
+ *
+ * We only have a spinlock (ep->wqlock) to manipulate the waitqueues.
+ * During the event transfer loop (from kernel to user space)
+ * we could end up sleeping due a copy_to_user(), so
  * we need a lock that will allow us to sleep. This lock is a
  * mutex (ep->mtx). It is acquired during the event transfer loop,
  * during epoll_ctl(EPOLL_CTL_DEL) and during eventpoll_release_file().
@@ -82,8 +81,8 @@
  * of epoll file descriptors, we use the current recursion depth as
  * the lockdep subkey.
  * It is possible to drop the "ep->mtx" and to use the global
- * mutex "epmutex" (together with "ep->lock") to have it working,
- * but having "ep->mtx" will make the interface more scalable.
+ * mutex "epmutex" to have it working,  but having "ep->mtx" will
+ * make the interface more scalable.
  * Events that require holding "epmutex" are very rare, while for
  * normal operations the epoll private "ep->mtx" will guarantee
  * a better scalability.
@@ -126,6 +125,23 @@ struct nested_calls {
 };
 
 /*
+ * epitem state transitions               callers
+ * ---------------------------------------------------------------------------
+ * EP_STATE_IDLE    -> EP_STATE_READY     ep_poll_callback, ep_enqueue_process
+ * EP_STATE_READY   -> EP_STATE_DEQUEUE   ep_send_events
+ * EP_STATE_DEQUEUE -> EP_STATE_IDLE      ep_send_events
+ * EP_STATE_IDLE    -> kmem_cache_free    ep_remove
+ * EP_STATE_READY   -> EP_STATE_ZOMBIE    ep_remove
+ * EP_STATE_ZOMBIE  -> kmem_cache_free    ep_send_events
+ */
+enum epoll_item_state {
+	EP_STATE_ZOMBIE = -1,
+	EP_STATE_IDLE = 0,
+	EP_STATE_READY = 1,
+	EP_STATE_DEQUEUE = 2
+};
+
+/*
  * Each file descriptor added to the eventpoll interface will
  * have an entry of this type linked to the "rbr" RB tree.
  * Avoid increasing the size of this struct, there can be many thousands
@@ -136,19 +152,13 @@ struct epitem {
 	struct rb_node rbn;
 
 	/* List header used to link this structure to the eventpoll ready list */
-	struct list_head rdllink;
-
-	/*
-	 * Works together "struct eventpoll"->ovflist in keeping the
-	 * single linked chain of items.
-	 */
-	struct epitem *next;
+	struct wfcq_node rdllink;
 
 	/* The file descriptor information this item refers to */
 	struct epoll_filefd ffd;
 
-	/* Number of active wait queue attached to poll operations */
-	int nwait;
+	/* state of this item, see epoll_item_state */
+	atomic_t state;
 
 	/* List containing poll wait queues */
 	struct list_head pwqlist;
@@ -172,8 +182,8 @@ struct epitem {
  * interface.
  */
 struct eventpoll {
-	/* Protect the access to this structure */
-	spinlock_t lock;
+	/* head of the ready list */
+	struct wfcq_head rdlhead;
 
 	/*
 	 * This mutex is used to ensure that files are not removed
@@ -183,25 +193,18 @@ struct eventpoll {
 	 */
 	struct mutex mtx;
 
+	/* Protect the access to wait queues */
+	spinlock_t wqlock;
+
 	/* Wait queue used by sys_epoll_wait() */
 	wait_queue_head_t wq;
 
 	/* Wait queue used by file->poll() */
 	wait_queue_head_t poll_wait;
 
-	/* List of ready file descriptors */
-	struct list_head rdllist;
-
 	/* RB tree root used to store monitored fd structs */
 	struct rb_root rbr;
 
-	/*
-	 * This is a single linked list that chains all the "struct epitem" that
-	 * happened while transferring ready events to userspace w/out
-	 * holding ->lock.
-	 */
-	struct epitem *ovflist;
-
 	/* wakeup_source used when ep_scan_ready_list is running */
 	struct wakeup_source *ws;
 
@@ -213,6 +216,9 @@ struct eventpoll {
 	/* used to optimize loop detection check */
 	int visited;
 	struct list_head visited_list_link;
+
+	/* hopefully a different cache line than rdlhead */
+	struct wfcq_tail rdltail;
 };
 
 /* Wait structure used by the poll hooks */
@@ -347,6 +353,12 @@ static inline struct epitem *ep_item_from_epqueue(poll_table *p)
 	return container_of(p, struct ep_pqueue, pt)->epi;
 }
 
+/* Get the "struct epitem" from a wfcq node */
+static inline struct epitem *ep_item_from_node(struct wfcq_node *p)
+{
+	return container_of(p, struct epitem, rdllink);
+}
+
 /* Tells if the epoll_ctl(2) operation needs an event copy from userspace */
 static inline int ep_op_has_event(int op)
 {
@@ -368,9 +380,9 @@ static void ep_nested_calls_init(struct nested_calls *ncalls)
  * Returns: Returns a value different than zero if ready events are available,
  *          or zero otherwise.
  */
-static inline int ep_events_available(struct eventpoll *ep)
+static inline bool ep_events_available(struct eventpoll *ep)
 {
-	return !list_empty(&ep->rdllist) || ep->ovflist != EP_UNACTIVE_PTR;
+	return !wfcq_empty(&ep->rdlhead, &ep->rdltail);
 }
 
 /**
@@ -507,6 +519,27 @@ static void ep_poll_safewake(wait_queue_head_t *wq)
 	put_cpu();
 }
 
+static void ep_notify_waiters(struct eventpoll *ep)
+{
+	int pwake;
+	unsigned long flags;
+
+	spin_lock_irqsave(&ep->wqlock, flags);
+
+	/* Notify epoll_wait tasks  */
+	if (waitqueue_active(&ep->wq))
+		wake_up_locked(&ep->wq);
+
+	/* Notify the ->poll() wait list  */
+	pwake = waitqueue_active(&ep->poll_wait);
+
+	spin_unlock_irqrestore(&ep->wqlock, flags);
+
+	/* We have to call this outside the lock */
+	if (pwake)
+		ep_poll_safewake(&ep->poll_wait);
+}
+
 static void ep_remove_wait_queue(struct eppoll_entry *pwq)
 {
 	wait_queue_head_t *whead;
@@ -570,104 +603,17 @@ static inline void ep_pm_stay_awake_rcu(struct epitem *epi)
 	rcu_read_unlock();
 }
 
-/**
- * ep_scan_ready_list - Scans the ready list in a way that makes possible for
- *                      the scan code, to call f_op->poll(). Also allows for
- *                      O(NumReady) performance.
- *
- * @ep: Pointer to the epoll private data structure.
- * @sproc: Pointer to the scan callback.
- * @priv: Private opaque data passed to the @sproc callback.
- * @depth: The current depth of recursive f_op->poll calls.
- *
- * Returns: The same integer error code returned by the @sproc callback.
+/*
+ * We mark epitems as zombies if they are deleted while in the ready list,
+ * so the next invocation of ep_send_events can get rid of them.  We cannot
+ * delete abitrary elements from the wfcq ready list in O(1) time.
  */
-static int ep_scan_ready_list(struct eventpoll *ep,
-			      int (*sproc)(struct eventpoll *,
-					   struct list_head *, void *),
-			      void *priv,
-			      int depth)
+static noinline void ep_reap_zombie(struct eventpoll *ep, struct epitem *epi)
 {
-	int error, pwake = 0;
-	unsigned long flags;
-	struct epitem *epi, *nepi;
-	LIST_HEAD(txlist);
-
-	/*
-	 * We need to lock this because we could be hit by
-	 * eventpoll_release_file() and epoll_ctl().
-	 */
-	mutex_lock_nested(&ep->mtx, depth);
-
-	/*
-	 * Steal the ready list, and re-init the original one to the
-	 * empty list. Also, set ep->ovflist to NULL so that events
-	 * happening while looping w/out locks, are not lost. We cannot
-	 * have the poll callback to queue directly on ep->rdllist,
-	 * because we want the "sproc" callback to be able to do it
-	 * in a lockless way.
-	 */
-	spin_lock_irqsave(&ep->lock, flags);
-	list_splice_init(&ep->rdllist, &txlist);
-	ep->ovflist = NULL;
-	spin_unlock_irqrestore(&ep->lock, flags);
-
-	/*
-	 * Now call the callback function.
-	 */
-	error = (*sproc)(ep, &txlist, priv);
-
-	spin_lock_irqsave(&ep->lock, flags);
-	/*
-	 * During the time we spent inside the "sproc" callback, some
-	 * other events might have been queued by the poll callback.
-	 * We re-insert them inside the main ready-list here.
-	 */
-	for (nepi = ep->ovflist; (epi = nepi) != NULL;
-	     nepi = epi->next, epi->next = EP_UNACTIVE_PTR) {
-		/*
-		 * We need to check if the item is already in the list.
-		 * During the "sproc" callback execution time, items are
-		 * queued into ->ovflist but the "txlist" might already
-		 * contain them, and the list_splice() below takes care of them.
-		 */
-		if (!ep_is_linked(&epi->rdllink)) {
-			list_add_tail(&epi->rdllink, &ep->rdllist);
-			ep_pm_stay_awake(epi);
-		}
-	}
-	/*
-	 * We need to set back ep->ovflist to EP_UNACTIVE_PTR, so that after
-	 * releasing the lock, events will be queued in the normal way inside
-	 * ep->rdllist.
-	 */
-	ep->ovflist = EP_UNACTIVE_PTR;
-
-	/*
-	 * Quickly re-inject items left on "txlist".
-	 */
-	list_splice(&txlist, &ep->rdllist);
-	__pm_relax(ep->ws);
-
-	if (!list_empty(&ep->rdllist)) {
-		/*
-		 * Wake up (if active) both the eventpoll wait list and
-		 * the ->poll() wait list (delayed after we release the lock).
-		 */
-		if (waitqueue_active(&ep->wq))
-			wake_up_locked(&ep->wq);
-		if (waitqueue_active(&ep->poll_wait))
-			pwake++;
-	}
-	spin_unlock_irqrestore(&ep->lock, flags);
-
-	mutex_unlock(&ep->mtx);
-
-	/* We have to call this outside the lock */
-	if (pwake)
-		ep_poll_safewake(&ep->poll_wait);
-
-	return error;
+	__wfcq_dequeue(&ep->rdlhead, &ep->rdltail, 0);
+	wakeup_source_unregister(ep_wakeup_source(epi));
+	kmem_cache_free(epi_cache, epi);
+	atomic_long_dec(&ep->user->epoll_watches);
 }
 
 /*
@@ -676,17 +622,9 @@ static int ep_scan_ready_list(struct eventpoll *ep,
  */
 static int ep_remove(struct eventpoll *ep, struct epitem *epi)
 {
-	unsigned long flags;
 	struct file *file = epi->ffd.file;
 
-	/*
-	 * Removes poll wait queue hooks. We _have_ to do this without holding
-	 * the "ep->lock" otherwise a deadlock might occur. This because of the
-	 * sequence of the lock acquisition. Here we do "ep->lock" then the wait
-	 * queue head lock when unregistering the wait queue. The wakeup callback
-	 * will run by holding the wait queue head lock and will call our callback
-	 * that will try to get "ep->lock".
-	 */
+	/* Removes poll wait queue hooks. */
 	ep_unregister_pollwait(ep, epi);
 
 	/* Remove the current item from the list of epoll hooks */
@@ -697,19 +635,56 @@ static int ep_remove(struct eventpoll *ep, struct epitem *epi)
 
 	rb_erase(&epi->rbn, &ep->rbr);
 
-	spin_lock_irqsave(&ep->lock, flags);
-	if (ep_is_linked(&epi->rdllink))
-		list_del_init(&epi->rdllink);
-	spin_unlock_irqrestore(&ep->lock, flags);
+	/* rely on ep_send_events to cleanup if we got enqueued */
+	if (atomic_read(&epi->state) == EP_STATE_READY) {
+		atomic_set(&epi->state, EP_STATE_ZOMBIE);
+	} else {
+		/* At this point it is safe to free the eventpoll item */
+		wakeup_source_unregister(ep_wakeup_source(epi));
+		kmem_cache_free(epi_cache, epi);
+		atomic_long_dec(&ep->user->epoll_watches);
+	}
 
-	wakeup_source_unregister(ep_wakeup_source(epi));
+	return 0;
+}
 
-	/* At this point it is safe to free the eventpoll item */
-	kmem_cache_free(epi_cache, epi);
+/*
+ * Returns the first ready epitem, but does not dequeue it.
+ * Returns NULL if there is nothing ready.
+ */
+static inline struct epitem *ep_item_ready_first(struct eventpoll *ep)
+{
+	struct wfcq_node *p;
 
-	atomic_long_dec(&ep->user->epoll_watches);
+	p = __wfcq_first_nonblocking(&ep->rdlhead, &ep->rdltail);
 
-	return 0;
+	return p ? ep_item_from_node(p) : NULL;
+}
+
+/*
+ * We use the current tail as a sentinel value for iterating,
+ * we do not want to end up looping over the same epitem as we
+ * dequeue while ep_poll_callback may be enqueueing.
+ */
+static struct epitem *ep_item_ready_last(struct eventpoll *ep)
+{
+	struct wfcq_node *p = CMM_LOAD_SHARED(ep->rdltail.p);
+
+	return ep_item_from_node(p);
+}
+
+/*
+ * Only used for read-only iteration of the ready list (for our own poll())
+ * returns NULL upon reaching the end of the list.
+ */
+static struct epitem *ep_item_ready_next(struct eventpoll *ep,
+					 struct epitem *epi)
+{
+	struct wfcq_node *p;
+
+	p = __wfcq_next_nonblocking(&ep->rdlhead, &ep->rdltail, &epi->rdllink);
+
+	return p ? ep_item_from_node(p) : NULL;
 }
 
 static void ep_free(struct eventpoll *ep)
@@ -744,19 +719,21 @@ static void ep_free(struct eventpoll *ep)
 	 * Walks through the whole tree by freeing each "struct epitem". At this
 	 * point we are sure no poll callbacks will be lingering around, and also by
 	 * holding "epmutex" we can be sure that no file cleanup code will hit
-	 * us during this operation. So we can avoid the lock on "ep->lock".
+	 * us during this operation.
 	 * We do not need to lock ep->mtx, either, we only do it to prevent
 	 * a lockdep warning.
 	 */
 	mutex_lock(&ep->mtx);
 	while ((rbp = rb_first(&ep->rbr)) != NULL) {
 		epi = rb_entry(rbp, struct epitem, rbn);
+		atomic_set(&epi->state, EP_STATE_IDLE); /* prevent zombies */
 		ep_remove(ep, epi);
 	}
 	mutex_unlock(&ep->mtx);
 
 	mutex_unlock(&epmutex);
 	mutex_destroy(&ep->mtx);
+	mutex_destroy(&ep->rdlhead.lock);
 	free_uid(ep->user);
 	wakeup_source_unregister(ep->ws);
 	kfree(ep);
@@ -779,34 +756,49 @@ static inline unsigned int ep_item_poll(struct epitem *epi, poll_table *pt)
 	return epi->ffd.file->f_op->poll(epi->ffd.file, pt) & epi->event.events;
 }
 
-static int ep_read_events_proc(struct eventpoll *ep, struct list_head *head,
-			       void *priv)
+/* used our own poll() implementation */
+static int ep_poll_readyevents_proc(void *priv, void *cookie, int call_nests)
 {
-	struct epitem *epi, *tmp;
+	struct eventpoll *ep = priv;
+	struct epitem *epi;
+	int ret = 0;
 	poll_table pt;
 
 	init_poll_funcptr(&pt, NULL);
 
-	list_for_each_entry_safe(epi, tmp, head, rdllink) {
-		if (ep_item_poll(epi, &pt))
-			return POLLIN | POLLRDNORM;
-		else {
+	/*
+	 * this iteration should be safe because:
+	 * 1) ep->mtx is locked, preventing dequeue and epi invalidation
+	 * 2) stops at the tail when we started iteration
+	 */
+	mutex_lock_nested(&ep->mtx, call_nests + 1);
+	for (epi = ep_item_ready_first(ep);
+	     epi;
+	     epi = ep_item_ready_next(ep, epi)) {
+
+		/* zombie item, let ep_send_events cleanup */
+		if (atomic_read(&epi->state) == EP_STATE_ZOMBIE)
+			continue;
+
+		pt._key = epi->event.events;
+
+		if (ep_item_poll(epi, &pt)) {
+			ret = POLLIN | POLLRDNORM;
+			break;
+		} else {
 			/*
 			 * Item has been dropped into the ready list by the poll
 			 * callback, but it's not actually ready, as far as
-			 * caller requested events goes. We can remove it here.
+			 * caller requested events goes.
+			 * We cannot remove it here, ep_send_events will
+			 * recheck and remove if possible
 			 */
 			__pm_relax(ep_wakeup_source(epi));
-			list_del_init(&epi->rdllink);
 		}
 	}
+	mutex_unlock(&ep->mtx);
 
-	return 0;
-}
-
-static int ep_poll_readyevents_proc(void *priv, void *cookie, int call_nests)
-{
-	return ep_scan_ready_list(priv, ep_read_events_proc, NULL, call_nests + 1);
+	return ret;
 }
 
 static unsigned int ep_eventpoll_poll(struct file *file, poll_table *wait)
@@ -913,13 +905,12 @@ static int ep_alloc(struct eventpoll **pep)
 	if (unlikely(!ep))
 		goto free_uid;
 
-	spin_lock_init(&ep->lock);
+	spin_lock_init(&ep->wqlock);
 	mutex_init(&ep->mtx);
 	init_waitqueue_head(&ep->wq);
 	init_waitqueue_head(&ep->poll_wait);
-	INIT_LIST_HEAD(&ep->rdllist);
+	wfcq_init(&ep->rdlhead, &ep->rdltail);
 	ep->rbr = RB_ROOT;
-	ep->ovflist = EP_UNACTIVE_PTR;
 	ep->user = user;
 
 	*pep = ep;
@@ -960,6 +951,30 @@ static struct epitem *ep_find(struct eventpoll *ep, struct file *file, int fd)
 	return epir;
 }
 
+/* returns true if successfully marked ready, false if it was already ready */
+static inline bool ep_mark_ready(struct epitem *epi)
+{
+	int s;
+
+	/*
+	 * We only want to go from idle -> ready
+	 * If another task is in the middle of dequeueing (in ep_send_events),
+	 * we busy wait until the dequeue finishes and sets EP_STATE_IDLE
+	 */
+	for (; ; cpu_relax()) {
+		s = atomic_cmpxchg(&epi->state, EP_STATE_IDLE, EP_STATE_READY);
+		if (s != EP_STATE_DEQUEUE)
+			break;
+	}
+	return (s == EP_STATE_IDLE);
+}
+
+static inline void ep_enqueue(struct eventpoll *ep, struct epitem *epi)
+{
+	wfcq_node_init(&epi->rdllink);
+	wfcq_enqueue(&ep->rdlhead, &ep->rdltail, &epi->rdllink);
+}
+
 /*
  * This is the callback that is passed to the wait queue wakeup
  * mechanism. It is called by the stored file descriptors when they
@@ -967,8 +982,6 @@ static struct epitem *ep_find(struct eventpoll *ep, struct file *file, int fd)
  */
 static int ep_poll_callback(wait_queue_t *wait, unsigned mode, int sync, void *key)
 {
-	int pwake = 0;
-	unsigned long flags;
 	struct epitem *epi = ep_item_from_wait(wait);
 	struct eventpoll *ep = epi->ep;
 
@@ -983,7 +996,8 @@ static int ep_poll_callback(wait_queue_t *wait, unsigned mode, int sync, void *k
 		list_del_init(&wait->task_list);
 	}
 
-	spin_lock_irqsave(&ep->lock, flags);
+	/* pairs with smp_mb in ep_modify */
+	smp_rmb();
 
 	/*
 	 * If the event mask does not contain any poll(2) event, we consider the
@@ -992,7 +1006,7 @@ static int ep_poll_callback(wait_queue_t *wait, unsigned mode, int sync, void *k
 	 * until the next EPOLL_CTL_MOD will be issued.
 	 */
 	if (!(epi->event.events & ~EP_PRIVATE_BITS))
-		goto out_unlock;
+		return 1;
 
 	/*
 	 * Check the events coming with the callback. At this stage, not
@@ -1001,51 +1015,14 @@ static int ep_poll_callback(wait_queue_t *wait, unsigned mode, int sync, void *k
 	 * test for "key" != NULL before the event match test.
 	 */
 	if (key && !((unsigned long) key & epi->event.events))
-		goto out_unlock;
+		return 1;
 
-	/*
-	 * If we are transferring events to userspace, we can hold no locks
-	 * (because we're accessing user memory, and because of linux f_op->poll()
-	 * semantics). All the events that happen during that period of time are
-	 * chained in ep->ovflist and requeued later on.
-	 */
-	if (unlikely(ep->ovflist != EP_UNACTIVE_PTR)) {
-		if (epi->next == EP_UNACTIVE_PTR) {
-			epi->next = ep->ovflist;
-			ep->ovflist = epi;
-			if (epi->ws) {
-				/*
-				 * Activate ep->ws since epi->ws may get
-				 * deactivated at any time.
-				 */
-				__pm_stay_awake(ep->ws);
-			}
-
-		}
-		goto out_unlock;
+	if (ep_mark_ready(epi)) {
+		ep_enqueue(ep, epi);
+		ep_pm_stay_awake_rcu(epi);
 	}
 
-	/* If this file is already in the ready list we exit soon */
-	if (!ep_is_linked(&epi->rdllink)) {
-		list_add_tail(&epi->rdllink, &ep->rdllist);
-		ep_pm_stay_awake(epi);
-	}
-
-	/*
-	 * Wake up ( if active ) both the eventpoll wait list and the ->poll()
-	 * wait list.
-	 */
-	if (waitqueue_active(&ep->wq))
-		wake_up_locked(&ep->wq);
-	if (waitqueue_active(&ep->poll_wait))
-		pwake++;
-
-out_unlock:
-	spin_unlock_irqrestore(&ep->lock, flags);
-
-	/* We have to call this outside the lock */
-	if (pwake)
-		ep_poll_safewake(&ep->poll_wait);
+	ep_notify_waiters(ep);
 
 	return 1;
 }
@@ -1060,16 +1037,19 @@ static void ep_ptable_queue_proc(struct file *file, wait_queue_head_t *whead,
 	struct epitem *epi = ep_item_from_epqueue(pt);
 	struct eppoll_entry *pwq;
 
-	if (epi->nwait >= 0 && (pwq = kmem_cache_alloc(pwq_cache, GFP_KERNEL))) {
+	if (atomic_read(&epi->state) == EP_STATE_ZOMBIE)
+		return;
+
+	pwq = kmem_cache_alloc(pwq_cache, GFP_KERNEL);
+	if (pwq) {
 		init_waitqueue_func_entry(&pwq->wait, ep_poll_callback);
 		RCU_INIT_POINTER(pwq->whead, whead);
 		pwq->base = epi;
 		add_wait_queue(whead, &pwq->wait);
 		list_add_tail(&pwq->llink, &epi->pwqlist);
-		epi->nwait++;
 	} else {
 		/* We have to signal that an error occurred */
-		epi->nwait = -1;
+		atomic_set(&epi->state, EP_STATE_ZOMBIE);
 	}
 }
 
@@ -1224,14 +1204,25 @@ static noinline void ep_destroy_wakeup_source(struct epitem *epi)
 	wakeup_source_unregister(ws);
 }
 
+/* enqueue an epitem in process context via epoll_ctl */
+static bool ep_enqueue_process(struct eventpoll *ep, struct epitem *epi)
+{
+	if (!ep_mark_ready(epi))
+		return false;
+
+	ep_enqueue(ep, epi);
+	ep_pm_stay_awake(epi);
+	ep_notify_waiters(ep);
+	return true;
+}
+
 /*
  * Must be called with "mtx" held.
  */
 static int ep_insert(struct eventpoll *ep, struct epoll_event *event,
 		     struct file *tfile, int fd)
 {
-	int error, revents, pwake = 0;
-	unsigned long flags;
+	int error, revents;
 	long user_watches;
 	struct epitem *epi;
 	struct ep_pqueue epq;
@@ -1243,14 +1234,12 @@ static int ep_insert(struct eventpoll *ep, struct epoll_event *event,
 		return -ENOMEM;
 
 	/* Item initialization follow here ... */
-	INIT_LIST_HEAD(&epi->rdllink);
 	INIT_LIST_HEAD(&epi->fllink);
 	INIT_LIST_HEAD(&epi->pwqlist);
+	atomic_set(&epi->state, EP_STATE_IDLE);
 	epi->ep = ep;
 	ep_set_ffd(&epi->ffd, tfile, fd);
 	epi->event = *event;
-	epi->nwait = 0;
-	epi->next = EP_UNACTIVE_PTR;
 	if (epi->event.events & EPOLLWAKEUP) {
 		error = ep_create_wakeup_source(epi);
 		if (error)
@@ -1278,7 +1267,7 @@ static int ep_insert(struct eventpoll *ep, struct epoll_event *event,
 	 * high memory pressure.
 	 */
 	error = -ENOMEM;
-	if (epi->nwait < 0)
+	if (atomic_read(&epi->state) == EP_STATE_ZOMBIE)
 		goto error_unregister;
 
 	/* Add the current item to the list of active epoll hook for this file */
@@ -1297,28 +1286,11 @@ static int ep_insert(struct eventpoll *ep, struct epoll_event *event,
 	if (reverse_path_check())
 		goto error_remove_epi;
 
-	/* We have to drop the new item inside our item list to keep track of it */
-	spin_lock_irqsave(&ep->lock, flags);
-
-	/* If the file is already "ready" we drop it inside the ready list */
-	if ((revents & event->events) && !ep_is_linked(&epi->rdllink)) {
-		list_add_tail(&epi->rdllink, &ep->rdllist);
-		ep_pm_stay_awake(epi);
-
-		/* Notify waiting tasks that events are available */
-		if (waitqueue_active(&ep->wq))
-			wake_up_locked(&ep->wq);
-		if (waitqueue_active(&ep->poll_wait))
-			pwake++;
-	}
-
-	spin_unlock_irqrestore(&ep->lock, flags);
-
 	atomic_long_inc(&ep->user->epoll_watches);
 
-	/* We have to call this outside the lock */
-	if (pwake)
-		ep_poll_safewake(&ep->poll_wait);
+	/* If the file is already "ready" we drop it inside the ready list */
+	if (revents & event->events)
+		ep_enqueue_process(ep, epi);
 
 	return 0;
 
@@ -1331,18 +1303,20 @@ error_remove_epi:
 	rb_erase(&epi->rbn, &ep->rbr);
 
 error_unregister:
+	/* ep->state cannot be set to EP_STATE_READY after this: */
 	ep_unregister_pollwait(ep, epi);
 
 	/*
+	 * Rely on ep_send_events to free epi if we got enqueued.
 	 * We need to do this because an event could have been arrived on some
-	 * allocated wait queue. Note that we don't care about the ep->ovflist
-	 * list, since that is used/cleaned only inside a section bound by "mtx".
-	 * And ep_insert() is called with "mtx" held.
+	 * allocated wait queue.
 	 */
-	spin_lock_irqsave(&ep->lock, flags);
-	if (ep_is_linked(&epi->rdllink))
-		list_del_init(&epi->rdllink);
-	spin_unlock_irqrestore(&ep->lock, flags);
+	if (atomic_read(&epi->state) == EP_STATE_READY) {
+		/* count the zombie against user watches to prevent OOM DoS */
+		atomic_long_inc(&ep->user->epoll_watches);
+		atomic_set(&epi->state, EP_STATE_ZOMBIE);
+		return error;
+	}
 
 	wakeup_source_unregister(ep_wakeup_source(epi));
 
@@ -1358,7 +1332,6 @@ error_create_wakeup_source:
  */
 static int ep_modify(struct eventpoll *ep, struct epitem *epi, struct epoll_event *event)
 {
-	int pwake = 0;
 	unsigned int revents;
 	poll_table pt;
 
@@ -1384,9 +1357,7 @@ static int ep_modify(struct eventpoll *ep, struct epitem *epi, struct epoll_even
 	 * 1) Flush epi changes above to other CPUs.  This ensures
 	 *    we do not miss events from ep_poll_callback if an
 	 *    event occurs immediately after we call f_op->poll().
-	 *    We need this because we did not take ep->lock while
-	 *    changing epi above (but ep_poll_callback does take
-	 *    ep->lock).
+	 *    This pairs with the first smb_rmb in ep_poll_callback
 	 *
 	 * 2) We also need to ensure we do not miss _past_ events
 	 *    when calling f_op->poll().  This barrier also
@@ -1408,49 +1379,50 @@ static int ep_modify(struct eventpoll *ep, struct epitem *epi, struct epoll_even
 	 * If the item is "hot" and it is not registered inside the ready
 	 * list, push it inside.
 	 */
-	if (revents & event->events) {
-		spin_lock_irq(&ep->lock);
-		if (!ep_is_linked(&epi->rdllink)) {
-			list_add_tail(&epi->rdllink, &ep->rdllist);
-			ep_pm_stay_awake(epi);
-
-			/* Notify waiting tasks that events are available */
-			if (waitqueue_active(&ep->wq))
-				wake_up_locked(&ep->wq);
-			if (waitqueue_active(&ep->poll_wait))
-				pwake++;
-		}
-		spin_unlock_irq(&ep->lock);
-	}
-
-	/* We have to call this outside the lock */
-	if (pwake)
-		ep_poll_safewake(&ep->poll_wait);
+	if (revents & event->events)
+		ep_enqueue_process(ep, epi);
 
 	return 0;
 }
 
-static int ep_send_events_proc(struct eventpoll *ep, struct list_head *head,
-			       void *priv)
+/*
+ * If this file has been added with Level Trigger mode,
+ * we need to insert back inside the ready list, so that the next call to
+ * epoll_wait() will check again the events availability.
+ */
+static void ep_level_trigger(struct eventpoll *ep, struct epitem *epi)
+{
+	__wfcq_dequeue_nonblocking(&ep->rdlhead, &ep->rdltail);
+	ep_enqueue(ep, epi);
+	ep_pm_stay_awake(epi);
+}
+
+static int ep_send_events(struct eventpoll *ep,
+			  struct epoll_event __user *uevent, int maxevents)
 {
-	struct ep_send_events_data *esed = priv;
-	int eventcnt;
+	int eventcnt = 0;
 	unsigned int revents;
-	struct epitem *epi;
-	struct epoll_event __user *uevent;
+	struct epitem *epi, *end;
 	struct wakeup_source *ws;
 	poll_table pt;
 
 	init_poll_funcptr(&pt, NULL);
 
 	/*
-	 * We can loop without lock because we are passed a task private list.
-	 * Items cannot vanish during the loop because ep_scan_ready_list() is
-	 * holding "mtx" during this call.
+	 * Items cannot vanish during the loop because we are holding
+	 * "mtx" during this call.
 	 */
-	for (eventcnt = 0, uevent = esed->events;
-	     !list_empty(head) && eventcnt < esed->maxevents;) {
-		epi = list_first_entry(head, struct epitem, rdllink);
+	mutex_lock(&ep->mtx);
+	for (epi = ep_item_ready_first(ep), end = ep_item_ready_last(ep);
+	     epi && eventcnt < maxevents;
+	     epi = epi == end ? NULL : ep_item_ready_first(ep)) {
+		int state = atomic_read(&epi->state);
+
+		if (state == EP_STATE_ZOMBIE) {
+			ep_reap_zombie(ep, epi);
+			continue;
+		}
+		WARN_ON(state != EP_STATE_READY);
 
 		/*
 		 * Activate ep->ws before deactivating epi->ws to prevent
@@ -1459,7 +1431,7 @@ static int ep_send_events_proc(struct eventpoll *ep, struct list_head *head,
 		 *
 		 * This could be rearranged to delay the deactivation of epi->ws
 		 * instead, but then epi->ws would temporarily be out of sync
-		 * with ep_is_linked().
+		 * with epi->state.
 		 */
 		ws = ep_wakeup_source(epi);
 		if (ws) {
@@ -1468,8 +1440,6 @@ static int ep_send_events_proc(struct eventpoll *ep, struct list_head *head,
 			__pm_relax(ws);
 		}
 
-		list_del_init(&epi->rdllink);
-
 		revents = ep_item_poll(epi, &pt);
 
 		/*
@@ -1481,46 +1451,37 @@ static int ep_send_events_proc(struct eventpoll *ep, struct list_head *head,
 		if (revents) {
 			if (__put_user(revents, &uevent->events) ||
 			    __put_user(epi->event.data, &uevent->data)) {
-				list_add(&epi->rdllink, head);
-				ep_pm_stay_awake(epi);
-				return eventcnt ? eventcnt : -EFAULT;
+				if (!eventcnt)
+					eventcnt = -EFAULT;
+				break;
 			}
+
 			eventcnt++;
 			uevent++;
-			if (epi->event.events & EPOLLONESHOT)
+
+			if (epi->event.events & EPOLLONESHOT) {
 				epi->event.events &= EP_PRIVATE_BITS;
-			else if (!(epi->event.events & EPOLLET)) {
-				/*
-				 * If this file has been added with Level
-				 * Trigger mode, we need to insert back inside
-				 * the ready list, so that the next call to
-				 * epoll_wait() will check again the events
-				 * availability. At this point, no one can insert
-				 * into ep->rdllist besides us. The epoll_ctl()
-				 * callers are locked out by
-				 * ep_scan_ready_list() holding "mtx" and the
-				 * poll callback will queue them in ep->ovflist.
-				 */
-				list_add_tail(&epi->rdllink, &ep->rdllist);
-				ep_pm_stay_awake(epi);
+			} else if (!(epi->event.events & EPOLLET)) {
+				ep_level_trigger(ep, epi);
+				continue;
 			}
 		}
+
+		/*
+		 * we set EP_STATE_DEQUEUE before dequeueing to prevent losing
+		 * events during ep_poll_callback that fire before we can set
+		 * EP_STATE_IDLE ep_poll_callback must spin while we're
+		 * EP_STATE_DEQUEUE (for the dequeue)
+		 */
+		atomic_set(&epi->state, EP_STATE_DEQUEUE);
+		__wfcq_dequeue_nonblocking(&ep->rdlhead, &ep->rdltail);
+		atomic_set(&epi->state, EP_STATE_IDLE);
 	}
+	mutex_unlock(&ep->mtx);
 
 	return eventcnt;
 }
 
-static int ep_send_events(struct eventpoll *ep,
-			  struct epoll_event __user *events, int maxevents)
-{
-	struct ep_send_events_data esed;
-
-	esed.maxevents = maxevents;
-	esed.events = events;
-
-	return ep_scan_ready_list(ep, ep_send_events_proc, &esed, 0);
-}
-
 static inline struct timespec ep_set_mstimeout(long ms)
 {
 	struct timespec now, ts = {
@@ -1552,7 +1513,7 @@ static inline struct timespec ep_set_mstimeout(long ms)
 static int ep_poll(struct eventpoll *ep, struct epoll_event __user *events,
 		   int maxevents, long timeout)
 {
-	int res = 0, eavail, timed_out = 0;
+	int res = 0;
 	unsigned long flags;
 	long slack = 0;
 	wait_queue_t wait;
@@ -1564,20 +1525,11 @@ static int ep_poll(struct eventpoll *ep, struct epoll_event __user *events,
 		slack = select_estimate_accuracy(&end_time);
 		to = &expires;
 		*to = timespec_to_ktime(end_time);
-	} else if (timeout == 0) {
-		/*
-		 * Avoid the unnecessary trip to the wait queue loop, if the
-		 * caller specified a non blocking operation.
-		 */
-		timed_out = 1;
-		spin_lock_irqsave(&ep->lock, flags);
-		goto check_events;
 	}
 
-fetch_events:
-	spin_lock_irqsave(&ep->lock, flags);
+	if (!ep_events_available(ep) && timeout) {
+wait_queue_loop:
 
-	if (!ep_events_available(ep)) {
 		/*
 		 * We don't have any available event to return to the caller.
 		 * We need to sleep here, and we will be wake up by
@@ -1593,37 +1545,38 @@ fetch_events:
 			 * to TASK_INTERRUPTIBLE before doing the checks.
 			 */
 			set_current_state(TASK_INTERRUPTIBLE);
-			if (ep_events_available(ep) || timed_out)
+			if (ep_events_available(ep) || !timeout)
 				break;
 			if (signal_pending(current)) {
 				res = -EINTR;
 				break;
 			}
 
-			spin_unlock_irqrestore(&ep->lock, flags);
 			if (!schedule_hrtimeout_range(to, slack, HRTIMER_MODE_ABS))
-				timed_out = 1;
-
-			spin_lock_irqsave(&ep->lock, flags);
+				timeout = 0;
 		}
+
+		spin_lock_irqsave(&ep->wqlock, flags);
 		__remove_wait_queue(&ep->wq, &wait);
+		spin_unlock_irqrestore(&ep->wqlock, flags);
 
 		set_current_state(TASK_RUNNING);
 	}
-check_events:
-	/* Is it worth to try to dig for events ? */
-	eavail = ep_events_available(ep);
-
-	spin_unlock_irqrestore(&ep->lock, flags);
 
 	/*
 	 * Try to transfer events to user space. In case we get 0 events and
 	 * there's still timeout left over, we go trying again in search of
 	 * more luck.
 	 */
-	if (!res && eavail &&
-	    !(res = ep_send_events(ep, events, maxevents)) && !timed_out)
-		goto fetch_events;
+	if (!res) {
+		res = ep_send_events(ep, events, maxevents);
+		if (!res && timeout)
+			goto wait_queue_loop;
+	}
+
+	/* we may not have transferred everything, wake up others */
+	if (ep_events_available(ep))
+		ep_notify_waiters(ep);
 
 	return res;
 }
-- 
Eric Wong
