Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758979Ab3DASbV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 14:31:21 -0400
Received: from dcvr.yhbt.net ([64.71.152.64]:49672 "EHLO dcvr.yhbt.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758591Ab3DASbS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 14:31:18 -0400
Date: Mon, 1 Apr 2013 18:31:18 +0000
From: Eric Wong <normalperson@yhbt.net>
To: linux-kernel@vger.kernel.org
Cc: Davide Libenzi <davidel@xmailserver.org>,
        Al Viro <viro@ZenIV.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Arve =?utf-8?B?SGrDuG5uZXbDpWc=?= <arve@android.com>,
        linux-fsdevel@vger.kernel.org
Subject: [PATCH v4] epoll: avoid spinlock contention with wfcqueue
Message-ID: <20130401183118.GA9968@dcvr.yhbt.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ep->lock contention was shown to be high with both perf and
lock_stat for under a workload with concurrent sys_epoll_wait
callers and frequent ep_poll_callback occurences.

By replacing the spinlock-protected ready list with wfcqueue and
using separate locks for the ovflist and wait queue, we are able
to reduce spinlock contention with many events firing and
concurrent waiters.

Results from my multi-threaded EPOLLONESHOT microbenchmark,
performance is improves significantly on my 4-core KVM image
running 4 concurrent writers and 4 concurent waiter:

$ eponeshotmt -t 4 -w 4 -f 10 -c 1000000

Before:
real    0m 9.58s
user    0m 1.22s
sys     0m 37.08s

After:
real    0m 5.88s
user    0m 1.29s
sys     0m 22.22s

ref: http://yhbt.net/eponeshotmt.c

Since the majority of epoll users nowadays are single-threaded
and use Level Trigger, it is important to avoid regressions for
common cases.  Using Davide's epwbench, performance is slightly
better, too:

Before:
AVG: 5.448400
SIG: 0.003056

After:
AVG: 5.256352
SIG: 0.000233

ref: http://www.xmailserver.org/epwbench.c

Things changed/removed:

* ep->ovflist - the scope of this list is now limited to items inside
  the ready list, not all potential epitems as before.

* ep_scan_ready_list removed.  There is not enough generic code
  between users anymore to warrant this.  ep_poll_readyevents_proc
  (used for poll/select) is read-only, using __wfcq_for_each, while
  ep_send_events (used for epoll_wait) dequeues and needs
  __wfcq_for_each_safe.  ep->ovflist is only needed for the
  ep_send_events case and not the ep_poll_readyevents_proc case.

* ep->lock removed, ep->ovflock only protects ep->ovflist access
  while transferring events to user space.

* we also rely on ep->wq.lock for protecting the waitqueue, but
  now use trylock to avoid redundant wakeups.

* EPOLL_CTL_DEL/close() on a ready file will no longer immediately
  release epitem memory, epoll_wait() must be called since there is
  no way to delete a ready item from wfcqueue in O(1) time.  In
  practice this should not be a problem, any valid app using epoll
  must call epoll_wait occasionally.  Unfreed epitems still count
  against max_user_watches to protect against local DoS.  This should
  be the only possibly-noticeable change (in case there's an app that
  blindly adds/deletes items from the rbtree but never calls epoll_wait)

Changes since v1:
* fix memory leak with pre-existing zombies in ep_free
* updated to use the latest wfcqueue.h APIs
* switched to using __wfcq_splice and a global transaction list
  (this is like the old txlist in ep_scan_ready_list)
* redundant wakeups avoided in ep_notify_waiters:
  - only attempt a wakeup when an item is enqueued the first time
  - use spin_trylock_irqsave when attempting notification, since a
    failed lock means either another task is already waking, or
    ep_poll is already running and will check anyways upon releasing
    wqlock, anyways.
* explicitly cache-aligned rdltail in SMP
* added ep_item_state for atomically reading epi->state with barrier
  (avoids WARN_ON in ep_send_events)
* reverted epi->nwait removal, it was not necessary
  sizeof(epitem) is still <= 128 bytes on 64-bit machines

Changes since v2:
* epi->state is no longer atomic, we only cmpxchg in ep_poll_callback
  now and rely on implicit barriers in other places for reading.
* intermediate EP_STATE_DEQUEUE removed, this (with xchg) caused too
  much overhead in the ep_send_events loop and could not eliminate
  starvation dangers from improper EPOLLET usage.
* minor code cleanups

Changes since v3:
* restore ep->ovflist, we still need it to avoid losing events which
  fire immediately after the ->poll call in ep_send_events.
  Rearranging the deactivation to occur before the ->poll hurts
  Level Trigger performance while transferring events to user space.
  The increased window for starvation with EPOLLET in v2 is gone.
* use newly-introduced wfcqueue functions to operate on local queues
  guarded by ep->mtx, these were necessary to preserve performance when
  working with Level Trigger items.
* epi->state removed, we use EP_UNACTIVE_PTR to denote an unqueued item
  (like the ovflist already does), and null epi->ep to determine if an
  item is a zombie.
* the smaller wfcqueue node overhead allows us to rearrange "struct epitem"
  so we only access the top 64-bytes of the struct in common code paths
  on 64-bit.  On machines with 64-byte cache line sizes (or less), this
  saves us from accessing the extra cache line and helps improve performance.
* destroy wakeup source immediately for zombie epitems, there is no need
  to wait until ep_send_events.

Signed-off-by: Eric Wong <normalperson@yhbt.net>
Cc: Davide Libenzi <davidel@xmailserver.org>
Cc: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Arve Hjønnevåg <arve@android.com>
---
  This depends on some patches previous posted to LKML, some are already
  in -mm:

  Andrew Morton (1):
        epoll-trim-epitem-by-one-cache-line-on-x86_64-fix

  Eric Wong (10):
        epoll: trim epitem by one cache line
        epoll: comment + BUILD_BUG_ON to prevent epitem bloat
        epoll: fix sparse error on RCU assignment
        epoll: use RCU to protect wakeup_source in epitem
        epoll: lock ep->mtx in ep_free to silence lockdep
        epoll: fix suspicious RCU usage in ep
        epoll: cleanup: use RCU_INIT_POINTER when nulling
        epoll: cleanup: hoist out f_op->poll calls
        wfcqueue: functions for local append and enqueue
        wfcqueue: add function for unsynchronized prepend

  Mathieu Desnoyers (1):
        Linux kernel Wait-Free Concurrent Queue Implementation (v2)

  For convenience, the entire series on top of v3.8.x/3.9.x is
  available as an mbox: http://yhbt.net/epoll-wfcqueue-v3.8.5-20130401.mbox

  I will need much help testing this, I do not have access to a machine
  with more than 4 cores.

  I've been running this on my 4 core and 2 core machines under heavy
  load with this patch for several hours without issue, though.

  Any feedback greatly appreciated, thanks!

 fs/eventpoll.c | 784 ++++++++++++++++++++++++++++++---------------------------
 1 file changed, 411 insertions(+), 373 deletions(-)

diff --git a/fs/eventpoll.c b/fs/eventpoll.c
index e6b0724..b5edf01 100644
--- a/fs/eventpoll.c
+++ b/fs/eventpoll.c
@@ -40,6 +40,7 @@
 #include <linux/atomic.h>
 #include <linux/proc_fs.h>
 #include <linux/seq_file.h>
+#include <linux/wfcqueue.h>
 
 /*
  * LOCKING:
@@ -47,15 +48,16 @@
  *
  * 1) epmutex (mutex)
  * 2) ep->mtx (mutex)
- * 3) ep->lock (spinlock)
+ * 3) ep->ovflock (spinlock)
  *
  * The acquire order is the one listed above, from 1 to 3.
- * We need a spinlock (ep->lock) because we manipulate objects
- * from inside the poll callback, that might be triggered from
- * a wake_up() that in turn might be called from IRQ context.
- * So we can't sleep inside the poll callback and hence we need
- * a spinlock. During the event transfer loop (from kernel to
- * user space) we could end up sleeping due a copy_to_user(), so
+ *
+ * We only use ep->ovflock when ep_send_events is running.
+ * We also use the waitqueue lock (ep->wq.lock) ourselves to
+ * manipulate the waitqueues and use trylock when possible to avoid
+ * redundant wakeups.
+ * During the event transfer loop (from kernel to user space)
+ * we could end up sleeping due a copy_to_user(), so
  * we need a lock that will allow us to sleep. This lock is a
  * mutex (ep->mtx). It is acquired during the event transfer loop,
  * during epoll_ctl(EPOLL_CTL_DEL) and during eventpoll_release_file().
@@ -82,8 +84,8 @@
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
@@ -135,35 +137,49 @@ struct epitem {
 	/* RB tree node used to link this structure to the eventpoll RB tree */
 	struct rb_node rbn;
 
-	/* List header used to link this structure to the eventpoll ready list */
-	struct list_head rdllink;
-
 	/*
-	 * Works together "struct eventpoll"->ovflist in keeping the
-	 * single linked chain of items.
+	 * List header used to link this structure to the eventpoll ready list
+	 * The state of the item (ready vs idle) is encoded within the "next"
+	 * pointer of this.
 	 */
-	struct epitem *next;
+	struct wfcq_node rdllink;
 
 	/* The file descriptor information this item refers to */
 	struct epoll_filefd ffd;
 
-	/* Number of active wait queue attached to poll operations */
-	int nwait;
-
-	/* List containing poll wait queues */
-	struct list_head pwqlist;
+	/*
+	 * The structure that describe the interested events and the source fd
+	 */
+	struct epoll_event event;
 
 	/* The "container" of this item */
 	struct eventpoll *ep;
 
+	/*
+	 * --> 64-byte boundary for 64-bit systems <--
+	 * frequently accessed (read/written) items are above this comment
+	 * infrequently accessed items are below this comment
+	 * Keeping frequently accessed items within the 64-byte boundary
+	 * prevents extra cache line usage on common x86-64 machines
+	 */
+
+	/* List containing poll wait queues */
+	struct list_head pwqlist;
+
 	/* List header used to link this item to the "struct file" items list */
 	struct list_head fllink;
 
 	/* wakeup_source used when EPOLLWAKEUP is set */
 	struct wakeup_source __rcu *ws;
 
-	/* The structure that describe the interested events and the source fd */
-	struct epoll_event event;
+	/*
+	 * Works together "struct eventpoll"->ovflist in keeping the
+	 * single linked chain of items.
+	 */
+	struct epitem *next;
+
+	/* Number of active wait queue attached to poll operations */
+	int nwait;
 };
 
 /*
@@ -172,37 +188,35 @@ struct epitem {
  * interface.
  */
 struct eventpoll {
-	/* Protect the access to this structure */
-	spinlock_t lock;
-
 	/*
 	 * This mutex is used to ensure that files are not removed
 	 * while epoll is using them. This is held during the event
 	 * collection loop, the file cleanup path, the epoll file exit
 	 * code and the ctl operations.
+	 * This also protects rdlhead, txlhead, and txltail.
 	 */
 	struct mutex mtx;
 
+	/* head of the enqueue ready list */
+	struct wfcq_head rdlhead;
+
+	/*
+	 * transactional ready list, these are only accessed when ep->mtx
+	 * is held.  We splice into these (from rdlhead) and work on this list
+	 */
+	struct wfcq_head txlhead;
+	struct wfcq_tail txltail;
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
-	/* wakeup_source used when ep_scan_ready_list is running */
+	/* wakeup_source used when ep_send_events is running */
 	struct wakeup_source *ws;
 
 	/* The user that created the eventpoll descriptor */
@@ -213,6 +227,18 @@ struct eventpoll {
 	/* used to optimize loop detection check */
 	int visited;
 	struct list_head visited_list_link;
+
+	/* this only protects ovflist */
+	spinlock_t ovflock;
+
+	/*
+	 * This is a single linked list that chains all the "struct epitem" that
+	 * happened while transferring ready events to userspace w/out
+	 * holding ->lock.
+	 */
+	struct epitem *ovflist;
+
+	struct wfcq_tail rdltail ____cacheline_aligned_in_smp;
 };
 
 /* Wait structure used by the poll hooks */
@@ -239,12 +265,6 @@ struct ep_pqueue {
 	struct epitem *epi;
 };
 
-/* Used by the ep_send_events() function as callback private data */
-struct ep_send_events_data {
-	int maxevents;
-	struct epoll_event __user *events;
-};
-
 /*
  * Configuration options available inside /proc/sys/fs/epoll/
  */
@@ -330,6 +350,18 @@ static inline int ep_is_linked(struct list_head *p)
 	return !list_empty(p);
 }
 
+/* prepare the item for ep_reap_and_dec in ep_send_events */
+static inline void ep_make_zombie(struct epitem *epi)
+{
+	epi->ep = NULL;
+}
+
+/* can we call ep_reap_and_dec on this item? */
+static inline bool ep_is_zombie(struct epitem *epi)
+{
+	return epi->ep == NULL;
+}
+
 static inline struct eppoll_entry *ep_pwq_from_wait(wait_queue_t *p)
 {
 	return container_of(p, struct eppoll_entry, wait);
@@ -347,6 +379,12 @@ static inline struct epitem *ep_item_from_epqueue(poll_table *p)
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
@@ -360,17 +398,30 @@ static void ep_nested_calls_init(struct nested_calls *ncalls)
 	spin_lock_init(&ncalls->lock);
 }
 
+/* splice newly queued ready items onto our transaction list */
+static inline enum wfcq_ret ep_ready_prepare(struct eventpoll *ep)
+{
+	lockdep_assert_held(&ep->mtx);
+
+	return __wfcq_splice(&ep->txlhead, &ep->txltail,
+				&ep->rdlhead, &ep->rdltail);
+}
+
 /**
  * ep_events_available - Checks if ready events might be available.
+ *                       This must be called with ep->mtx held
  *
  * @ep: Pointer to the eventpoll context.
  *
- * Returns: Returns a value different than zero if ready events are available,
- *          or zero otherwise.
+ * Returns: Returns true ready events are available, or false otherwise.
  */
-static inline int ep_events_available(struct eventpoll *ep)
+static inline bool ep_events_available(struct eventpoll *ep)
 {
-	return !list_empty(&ep->rdllist) || ep->ovflist != EP_UNACTIVE_PTR;
+	enum wfcq_ret ret = ep_ready_prepare(ep);
+
+	if (ret == WFCQ_RET_SRC_EMPTY)
+		return !wfcq_empty(&ep->txlhead, &ep->txltail);
+	return true;
 }
 
 /**
@@ -507,6 +558,34 @@ static void ep_poll_safewake(wait_queue_head_t *wq)
 	put_cpu();
 }
 
+/* try to wake up any processes in epoll_(p)wait or poll() users with epoll */
+static void ep_notify_waiters(struct eventpoll *ep)
+{
+	unsigned long flags;
+	int pwake;
+
+	/*
+	 * If we can't get the wq.lock, this means either:
+	 * ep_poll is working on it and will recheck the ready list when
+	 * it releases wq.lock anyways
+	 * ...Or another task is running this function and another wakeup
+	 * would be redundant
+	 */
+	if (spin_trylock_irqsave(&ep->wq.lock, flags)) {
+		/* Notify epoll_wait tasks  */
+		if (waitqueue_active(&ep->wq))
+			wake_up_locked(&ep->wq);
+
+		pwake = waitqueue_active(&ep->poll_wait);
+
+		spin_unlock_irqrestore(&ep->wq.lock, flags);
+
+		/* Notify the ->poll() wait list (may be outside lock) */
+		if (pwake)
+			ep_poll_safewake(&ep->poll_wait);
+	}
+}
+
 static void ep_remove_wait_queue(struct eppoll_entry *pwq)
 {
 	wait_queue_head_t *whead;
@@ -547,127 +626,48 @@ static inline struct wakeup_source *ep_wakeup_source(struct epitem *epi)
 /* call only when ep->mtx is held */
 static inline void ep_pm_stay_awake(struct epitem *epi)
 {
-	struct wakeup_source *ws = ep_wakeup_source(epi);
-
-	if (ws)
-		__pm_stay_awake(ws);
-}
-
-static inline bool ep_has_wakeup_source(struct epitem *epi)
-{
-	return rcu_access_pointer(epi->ws) ? true : false;
+	__pm_stay_awake(ep_wakeup_source(epi));
 }
 
 /* call when ep->mtx cannot be held (ep_poll_callback) */
 static inline void ep_pm_stay_awake_rcu(struct epitem *epi)
 {
-	struct wakeup_source *ws;
-
 	rcu_read_lock();
-	ws = rcu_dereference(epi->ws);
-	if (ws)
-		__pm_stay_awake(ws);
+	__pm_stay_awake(rcu_dereference(epi->ws));
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
- */
-static int ep_scan_ready_list(struct eventpoll *ep,
-			      int (*sproc)(struct eventpoll *,
-					   struct list_head *, void *),
-			      void *priv,
-			      int depth)
+static void ep_reap_and_dec(struct eventpoll *ep, struct epitem *epi)
 {
-	int error, pwake = 0;
-	unsigned long flags;
-	struct epitem *epi, *nepi;
-	LIST_HEAD(txlist);
+	kmem_cache_free(epi_cache, epi);
+	atomic_long_dec(&ep->user->epoll_watches);
+}
 
-	/*
-	 * We need to lock this because we could be hit by
-	 * eventpoll_release_file() and epoll_ctl().
-	 */
-	mutex_lock_nested(&ep->mtx, depth);
+/* returns true if successfully marked ready, false if it was already ready */
+static inline bool ep_mark_ready(struct epitem *epi)
+{
+	/* We only want to go from idle -> ready */
+	return (cmpxchg(&epi->rdllink.next, EP_UNACTIVE_PTR, NULL)
+		== EP_UNACTIVE_PTR);
+}
 
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
+static void ep_destroy_wakeup_source(struct epitem *epi)
+{
+	struct wakeup_source *ws = ep_wakeup_source(epi);
 
-	/*
-	 * Now call the callback function.
-	 */
-	error = (*sproc)(ep, &txlist, priv);
+	if (!ws)
+		return;
 
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
+	/* rare code path, not many wakeup source users */
+	RCU_INIT_POINTER(epi->ws, NULL);
 
 	/*
-	 * Quickly re-inject items left on "txlist".
+	 * wait for ep_pm_stay_awake_rcu to finish, synchronize_rcu is
+	 * used internally by wakeup_source_remove, too (called by
+	 * wakeup_source_unregister), so we cannot use call_rcu
 	 */
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
+	synchronize_rcu();
+	wakeup_source_unregister(ws);
 }
 
 /*
@@ -676,17 +676,9 @@ static int ep_scan_ready_list(struct eventpoll *ep,
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
+	/* Removes poll wait queue hooks */
 	ep_unregister_pollwait(ep, epi);
 
 	/* Remove the current item from the list of epoll hooks */
@@ -697,17 +689,17 @@ static int ep_remove(struct eventpoll *ep, struct epitem *epi)
 
 	rb_erase(&epi->rbn, &ep->rbr);
 
-	spin_lock_irqsave(&ep->lock, flags);
-	if (ep_is_linked(&epi->rdllink))
-		list_del_init(&epi->rdllink);
-	spin_unlock_irqrestore(&ep->lock, flags);
-
-	wakeup_source_unregister(ep_wakeup_source(epi));
+	ep_destroy_wakeup_source(epi);
 
-	/* At this point it is safe to free the eventpoll item */
-	kmem_cache_free(epi_cache, epi);
-
-	atomic_long_dec(&ep->user->epoll_watches);
+	/*
+	 * Try marking it ready and hope it succeeds.  If we fail, that means
+	 * the epitem was already ready and this needs to become a zombie
+	 */
+	if (ep_mark_ready(epi))
+		/* At this point it is safe to free the eventpoll item */
+		ep_reap_and_dec(ep, epi);
+	else
+		ep_make_zombie(epi);
 
 	return 0;
 }
@@ -716,6 +708,7 @@ static void ep_free(struct eventpoll *ep)
 {
 	struct rb_node *rbp;
 	struct epitem *epi;
+	struct wfcq_node *node, *n;
 
 	/* We need to release all tasks waiting for these file */
 	if (waitqueue_active(&ep->poll_wait))
@@ -724,19 +717,18 @@ static void ep_free(struct eventpoll *ep)
 	/*
 	 * We need to lock this because we could be hit by
 	 * eventpoll_release_file() while we're freeing the "struct eventpoll".
-	 * We do not need to hold "ep->mtx" here because the epoll file
-	 * is on the way to be removed and no one has references to it
-	 * anymore. The only hit might come from eventpoll_release_file() but
-	 * holding "epmutex" is sufficient here.
+	 * The only hit might come from eventpoll_release_file().
 	 */
 	mutex_lock(&epmutex);
 
+	/* We only lock ep->mtx to prevent a lockdep warning */
+	mutex_lock(&ep->mtx);
+
 	/*
 	 * Walks through the whole tree by unregistering poll callbacks.
 	 */
 	for (rbp = rb_first(&ep->rbr); rbp; rbp = rb_next(rbp)) {
 		epi = rb_entry(rbp, struct epitem, rbn);
-
 		ep_unregister_pollwait(ep, epi);
 	}
 
@@ -744,15 +736,24 @@ static void ep_free(struct eventpoll *ep)
 	 * Walks through the whole tree by freeing each "struct epitem". At this
 	 * point we are sure no poll callbacks will be lingering around, and also by
 	 * holding "epmutex" we can be sure that no file cleanup code will hit
-	 * us during this operation. So we can avoid the lock on "ep->lock".
-	 * We do not need to lock ep->mtx, either, we only do it to prevent
-	 * a lockdep warning.
+	 * us during this operation.
 	 */
-	mutex_lock(&ep->mtx);
 	while ((rbp = rb_first(&ep->rbr)) != NULL) {
 		epi = rb_entry(rbp, struct epitem, rbn);
 		ep_remove(ep, epi);
 	}
+
+	/*
+	 * Reap zombies which were ready when we hit them with ep_remove,
+	 * these are no longer in ep->rbr
+	 */
+	ep_ready_prepare(ep);
+	__wfcq_for_each_safe(&ep->txlhead, &ep->txltail, node, n) {
+		epi = ep_item_from_node(node);
+		__wfcq_dequeue(&ep->txlhead, &ep->txltail);
+		ep_reap_and_dec(ep, epi);
+	}
+
 	mutex_unlock(&ep->mtx);
 
 	mutex_unlock(&epmutex);
@@ -779,34 +780,48 @@ static inline unsigned int ep_item_poll(struct epitem *epi, poll_table *pt)
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
+	struct wfcq_node *node;
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
+	ep_ready_prepare(ep);
+	__wfcq_for_each(&ep->txlhead, &ep->txltail, node) {
+		epi = ep_item_from_node(node);
+
+		/* zombie item, let ep_send_events cleanup */
+		if (ep_is_zombie(epi))
+			continue;
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
@@ -913,11 +928,12 @@ static int ep_alloc(struct eventpoll **pep)
 	if (unlikely(!ep))
 		goto free_uid;
 
-	spin_lock_init(&ep->lock);
+	spin_lock_init(&ep->ovflock);
 	mutex_init(&ep->mtx);
 	init_waitqueue_head(&ep->wq);
 	init_waitqueue_head(&ep->poll_wait);
-	INIT_LIST_HEAD(&ep->rdllist);
+	wfcq_init(&ep->rdlhead, &ep->rdltail);
+	wfcq_init(&ep->txlhead, &ep->txltail);
 	ep->rbr = RB_ROOT;
 	ep->ovflist = EP_UNACTIVE_PTR;
 	ep->user = user;
@@ -967,10 +983,9 @@ static struct epitem *ep_find(struct eventpoll *ep, struct file *file, int fd)
  */
 static int ep_poll_callback(wait_queue_t *wait, unsigned mode, int sync, void *key)
 {
-	int pwake = 0;
-	unsigned long flags;
 	struct epitem *epi = ep_item_from_wait(wait);
 	struct eventpoll *ep = epi->ep;
+	unsigned long flags;
 
 	if ((unsigned long)key & POLLFREE) {
 		RCU_INIT_POINTER(ep_pwq_from_wait(wait)->whead, NULL);
@@ -983,8 +998,6 @@ static int ep_poll_callback(wait_queue_t *wait, unsigned mode, int sync, void *k
 		list_del_init(&wait->task_list);
 	}
 
-	spin_lock_irqsave(&ep->lock, flags);
-
 	/*
 	 * If the event mask does not contain any poll(2) event, we consider the
 	 * descriptor to be disabled. This condition is likely the effect of the
@@ -992,7 +1005,7 @@ static int ep_poll_callback(wait_queue_t *wait, unsigned mode, int sync, void *k
 	 * until the next EPOLL_CTL_MOD will be issued.
 	 */
 	if (!(epi->event.events & ~EP_PRIVATE_BITS))
-		goto out_unlock;
+		return 1;
 
 	/*
 	 * Check the events coming with the callback. At this stage, not
@@ -1001,14 +1014,25 @@ static int ep_poll_callback(wait_queue_t *wait, unsigned mode, int sync, void *k
 	 * test for "key" != NULL before the event match test.
 	 */
 	if (key && !((unsigned long) key & epi->event.events))
-		goto out_unlock;
+		return 1;
+
+	if (ep_mark_ready(epi)) {
+		wfcq_enqueue(&ep->rdlhead, &ep->rdltail, &epi->rdllink);
+
+		/* avoid reading extra cache line for epi->ws */
+		if (epi->event.events & EPOLLWAKEUP)
+			ep_pm_stay_awake_rcu(epi);
+		ep_notify_waiters(ep);
+		return 1;
+	}
 
 	/*
 	 * If we are transferring events to userspace, we can hold no locks
 	 * (because we're accessing user memory, and because of linux f_op->poll()
-	 * semantics). All the events that happen during that period of time are
-	 * chained in ep->ovflist and requeued later on.
+	 * semantics). All the (already active) events that happen during that
+	 * period of time are chained in ep->ovflist and requeued later on.
 	 */
+	spin_lock_irqsave(&ep->ovflock, flags);
 	if (unlikely(ep->ovflist != EP_UNACTIVE_PTR)) {
 		if (epi->next == EP_UNACTIVE_PTR) {
 			epi->next = ep->ovflist;
@@ -1020,32 +1044,10 @@ static int ep_poll_callback(wait_queue_t *wait, unsigned mode, int sync, void *k
 				 */
 				__pm_stay_awake(ep->ws);
 			}
-
 		}
-		goto out_unlock;
-	}
-
-	/* If this file is already in the ready list we exit soon */
-	if (!ep_is_linked(&epi->rdllink)) {
-		list_add_tail(&epi->rdllink, &ep->rdllist);
-		ep_pm_stay_awake_rcu(epi);
+		/* no need to wake up waiters, ep_send_events is running */
 	}
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
+	spin_unlock_irqrestore(&ep->ovflock, flags);
 
 	return 1;
 }
@@ -1208,20 +1210,17 @@ static int ep_create_wakeup_source(struct epitem *epi)
 	return 0;
 }
 
-/* rare code path, only used when EPOLL_CTL_MOD removes a wakeup source */
-static noinline void ep_destroy_wakeup_source(struct epitem *epi)
+/* enqueue an epitem in process context via epoll_ctl */
+static void ep_enqueue_process(struct eventpoll *ep, struct epitem *epi)
 {
-	struct wakeup_source *ws = ep_wakeup_source(epi);
+	if (ep_mark_ready(epi)) {
+		wfcq_enqueue(&ep->rdlhead, &ep->rdltail, &epi->rdllink);
 
-	RCU_INIT_POINTER(epi->ws, NULL);
-
-	/*
-	 * wait for ep_pm_stay_awake_rcu to finish, synchronize_rcu is
-	 * used internally by wakeup_source_remove, too (called by
-	 * wakeup_source_unregister), so we cannot use call_rcu
-	 */
-	synchronize_rcu();
-	wakeup_source_unregister(ws);
+		/* avoid reading extra cache line for epi->ws */
+		if (epi->event.events & EPOLLWAKEUP)
+			ep_pm_stay_awake(epi);
+		ep_notify_waiters(ep);
+	}
 }
 
 /*
@@ -1230,8 +1229,7 @@ static noinline void ep_destroy_wakeup_source(struct epitem *epi)
 static int ep_insert(struct eventpoll *ep, struct epoll_event *event,
 		     struct file *tfile, int fd)
 {
-	int error, revents, pwake = 0;
-	unsigned long flags;
+	int error, revents;
 	long user_watches;
 	struct epitem *epi;
 	struct ep_pqueue epq;
@@ -1243,14 +1241,14 @@ static int ep_insert(struct eventpoll *ep, struct epoll_event *event,
 		return -ENOMEM;
 
 	/* Item initialization follow here ... */
-	INIT_LIST_HEAD(&epi->rdllink);
+	epi->rdllink.next = EP_UNACTIVE_PTR;
 	INIT_LIST_HEAD(&epi->fllink);
 	INIT_LIST_HEAD(&epi->pwqlist);
 	epi->ep = ep;
 	ep_set_ffd(&epi->ffd, tfile, fd);
-	epi->event = *event;
 	epi->nwait = 0;
 	epi->next = EP_UNACTIVE_PTR;
+	epi->event = *event;
 	if (epi->event.events & EPOLLWAKEUP) {
 		error = ep_create_wakeup_source(epi);
 		if (error)
@@ -1297,28 +1295,11 @@ static int ep_insert(struct eventpoll *ep, struct epoll_event *event,
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
+	if (revents)
+		ep_enqueue_process(ep, epi);
 
 	return 0;
 
@@ -1333,18 +1314,19 @@ error_remove_epi:
 error_unregister:
 	ep_unregister_pollwait(ep, epi);
 
+	ep_destroy_wakeup_source(epi);
+
 	/*
-	 * We need to do this because an event could have been arrived on some
-	 * allocated wait queue. Note that we don't care about the ep->ovflist
-	 * list, since that is used/cleaned only inside a section bound by "mtx".
-	 * And ep_insert() is called with "mtx" held.
+	 * Try marking it ready and hope it succeeds.  If we fail, that means
+	 * the epitem was already hit by ep_poll_callback and needs to
+	 * become a zombie.
 	 */
-	spin_lock_irqsave(&ep->lock, flags);
-	if (ep_is_linked(&epi->rdllink))
-		list_del_init(&epi->rdllink);
-	spin_unlock_irqrestore(&ep->lock, flags);
-
-	wakeup_source_unregister(ep_wakeup_source(epi));
+	if (!ep_mark_ready(epi)) {
+		/* count the zombie against user watches to prevent OOM DoS */
+		atomic_long_inc(&ep->user->epoll_watches);
+		ep_make_zombie(epi);
+		return error;
+	}
 
 error_create_wakeup_source:
 	kmem_cache_free(epi_cache, epi);
@@ -1358,12 +1340,22 @@ error_create_wakeup_source:
  */
 static int ep_modify(struct eventpoll *ep, struct epitem *epi, struct epoll_event *event)
 {
-	int pwake = 0;
 	unsigned int revents;
 	poll_table pt;
 
 	init_poll_funcptr(&pt, NULL);
 
+	/* check if the _new_ event mask will create/destroy wakeup source */
+	if (event->events & EPOLLWAKEUP) {
+		if (!(epi->event.events & EPOLLWAKEUP)) {
+			/* perhaps we should return ENOMEM on error, here */
+			if (ep_create_wakeup_source(epi) != 0)
+				event->events &= ~EPOLLWAKEUP;
+		}
+	} else if (epi->event.events & EPOLLWAKEUP) {
+		ep_destroy_wakeup_source(epi);
+	}
+
 	/*
 	 * Set the new event interest mask before calling f_op->poll();
 	 * otherwise we might miss an event that happens between the
@@ -1371,12 +1363,6 @@ static int ep_modify(struct eventpoll *ep, struct epitem *epi, struct epoll_even
 	 */
 	epi->event.events = event->events; /* need barrier below */
 	epi->event.data = event->data; /* protected by mtx */
-	if (epi->event.events & EPOLLWAKEUP) {
-		if (!ep_has_wakeup_source(epi))
-			ep_create_wakeup_source(epi);
-	} else if (ep_has_wakeup_source(epi)) {
-		ep_destroy_wakeup_source(epi);
-	}
 
 	/*
 	 * The following barrier has two effects:
@@ -1384,9 +1370,8 @@ static int ep_modify(struct eventpoll *ep, struct epitem *epi, struct epoll_even
 	 * 1) Flush epi changes above to other CPUs.  This ensures
 	 *    we do not miss events from ep_poll_callback if an
 	 *    event occurs immediately after we call f_op->poll().
-	 *    We need this because we did not take ep->lock while
-	 *    changing epi above (but ep_poll_callback does take
-	 *    ep->lock).
+	 *    ep_poll_callback is fired always fired under a lock
+	 *    via __wake_up.
 	 *
 	 * 2) We also need to ensure we do not miss _past_ events
 	 *    when calling f_op->poll().  This barrier also
@@ -1408,85 +1393,81 @@ static int ep_modify(struct eventpoll *ep, struct epitem *epi, struct epoll_even
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
+	if (revents)
+		ep_enqueue_process(ep, epi);
 
 	return 0;
 }
 
-static int ep_send_events_proc(struct eventpoll *ep, struct list_head *head,
-			       void *priv)
+static int ep_send_events(struct eventpoll *ep, bool *eavail,
+			  struct epoll_event __user *uevent, int maxevents)
 {
-	struct ep_send_events_data *esed = priv;
-	int eventcnt;
+	int eventcnt = 0;
 	unsigned int revents;
-	struct epitem *epi;
-	struct epoll_event __user *uevent;
+	struct epitem *epi, *nepi;
 	struct wakeup_source *ws;
+	struct wfcq_node *node, *n;
 	poll_table pt;
+	struct wfcq_head lthead;
+	struct wfcq_tail lttail;
+	unsigned long flags;
 
+	wfcq_init(&lthead, &lttail);
 	init_poll_funcptr(&pt, NULL);
 
 	/*
-	 * We can loop without lock because we are passed a task private list.
-	 * Items cannot vanish during the loop because ep_scan_ready_list() is
-	 * holding "mtx" during this call.
+	 * Enable the ovflist without a lock.  We've already spliced all
+	 * the relevant items without a lock, so only epitems already in
+	 * txl* at this point may go into ovflist.  Readers will take
+	 * ep->ovflock to read this and to delay us from disabling ovflist
+	 * after our loop
 	 */
-	for (eventcnt = 0, uevent = esed->events;
-	     !list_empty(head) && eventcnt < esed->maxevents;) {
-		epi = list_first_entry(head, struct epitem, rdllink);
+	set_mb(ep->ovflist, NULL);
 
-		/*
-		 * Activate ep->ws before deactivating epi->ws to prevent
-		 * triggering auto-suspend here (in case we reactive epi->ws
-		 * below).
-		 *
-		 * This could be rearranged to delay the deactivation of epi->ws
-		 * instead, but then epi->ws would temporarily be out of sync
-		 * with ep_is_linked().
-		 */
-		ws = ep_wakeup_source(epi);
-		if (ws) {
-			if (ws->active)
-				__pm_stay_awake(ep->ws);
-			__pm_relax(ws);
+	/*
+	 * Items cannot vanish during the loop because we are holding
+	 * "mtx" during this call.
+	 */
+	__wfcq_for_each_safe(&ep->txlhead, &ep->txltail, node, n) {
+		epi = ep_item_from_node(node);
+		__wfcq_dequeue(&ep->txlhead, &ep->txltail);
+
+		if (ep_is_zombie(epi)) {
+			ep_reap_and_dec(ep, epi);
+			continue;
 		}
 
-		list_del_init(&epi->rdllink);
+		/*
+		 * Prepare to the item for enqueue in case it is LT.  This does
+		 * not need a barrier since this pointer was _not_
+		 * EP_UNACTIVE_PTR before and cannot be marked ready again.
+		 * We optimize for LT since events cycle through this loop
+		 * most frequently.  This is also needed for the -EFAULT case,
+		 * but not EPOLLET/EPOLLONESHOT.
+		 */
+		epi->rdllink.next = NULL;
 
 		revents = ep_item_poll(epi, &pt);
 
 		/*
 		 * If the event mask intersect the caller-requested one,
-		 * deliver the event to userspace. Again, ep_scan_ready_list()
+		 * deliver the event to userspace. Again, ep_poll()
 		 * is holding "mtx", so no operations coming from userspace
 		 * can change the item.
 		 */
 		if (revents) {
 			if (__put_user(revents, &uevent->events) ||
 			    __put_user(epi->event.data, &uevent->data)) {
-				list_add(&epi->rdllink, head);
-				ep_pm_stay_awake(epi);
-				return eventcnt ? eventcnt : -EFAULT;
+				__wfcq_prepend(&ep->txlhead, &ep->txltail,
+						&epi->rdllink);
+				if (!eventcnt)
+					eventcnt = -EFAULT;
+				break;
 			}
-			eventcnt++;
 			uevent++;
+			if (++eventcnt == maxevents)
+				n = NULL; /* stop iteration */
+
 			if (epi->event.events & EPOLLONESHOT)
 				epi->event.events &= EP_PRIVATE_BITS;
 			else if (!(epi->event.events & EPOLLET)) {
@@ -1495,30 +1476,83 @@ static int ep_send_events_proc(struct eventpoll *ep, struct list_head *head,
 				 * Trigger mode, we need to insert back inside
 				 * the ready list, so that the next call to
 				 * epoll_wait() will check again the events
-				 * availability. At this point, no one can insert
-				 * into ep->rdllist besides us. The epoll_ctl()
-				 * callers are locked out by
-				 * ep_scan_ready_list() holding "mtx" and the
-				 * poll callback will queue them in ep->ovflist.
+				 * availability.
 				 */
-				list_add_tail(&epi->rdllink, &ep->rdllist);
-				ep_pm_stay_awake(epi);
+				__wfcq_enqueue(&lthead, &lttail, &epi->rdllink);
+				continue;
 			}
 		}
+
+		/*
+		 * Deactivate the wakeup source before marking it idle.
+		 * The barrier implied by the spinlock in __pm_relax ensures
+		 * any future ep_poll_callback callers running will see the
+		 * deactivated ws before epi->rdllink.next == EP_UNACTIVE_PTR.
+		 */
+		ws = ep_wakeup_source(epi);
+		if (ws)
+			__pm_relax(ws);
+
+		/*
+		 * Mark the item as idle, we need the barrier so ep_mark_ready
+		 * can succeed after this and not place us in ovflist if this
+		 * item is hit by ep_poll_callback shortly after.
+		 *
+		 * We could do without ovflist by doing this before the
+		 * ep_item_poll above, but that slows down the Level Trigger
+		 * case.
+		 */
+		set_mb(epi->rdllink.next, EP_UNACTIVE_PTR);
 	}
 
-	return eventcnt;
-}
+	/*
+	 * Disable ovflist, we need this lock to ensure ovflist writers in
+	 * ep_poll_callback are done before we may disable ovflist
+	 */
+	spin_lock_irqsave(&ep->ovflock, flags);
+	nepi = ep->ovflist;
+	ep->ovflist = EP_UNACTIVE_PTR;
+	spin_unlock_irqrestore(&ep->ovflock, flags);
 
-static int ep_send_events(struct eventpoll *ep,
-			  struct epoll_event __user *events, int maxevents)
-{
-	struct ep_send_events_data esed;
+	/* see if we have any more items left (or very new ones) */
+	*eavail = ep_events_available(ep);
 
-	esed.maxevents = maxevents;
-	esed.events = events;
+	/*
+	 * We can work on ovflist without the ovflock since we are certain
+	 * ep_poll_callback will not append to ovflist anymore once we've
+	 * disabled it.
+	 *
+	 * During the time we spent inside the __put_user loop, some
+	 * other events might have been queued by the poll callback.
+	 * We re-insert them inside the Level Trigger ready-list here.
+	 */
+	for (; (epi = nepi) != NULL;
+	     nepi = epi->next, epi->next = EP_UNACTIVE_PTR) {
+		if (!ep_mark_ready(epi))
+			continue;
+
+		/*
+		 * Any valid events in ovflist are already on their way to
+		 * user space, so put them at the tip of the Level Trigger
+		 * list since we want to prioritize previously unseen events
+		 * which currently exist in txl* and rdl*
+		 */
+		__wfcq_prepend(&lthead, &lttail, &epi->rdllink);
+		ep_pm_stay_awake(epi);
+	}
 
-	return ep_scan_ready_list(ep, ep_send_events_proc, &esed, 0);
+	/*
+	 * we've now activated all the epi->ws we could not activate from
+	 * ep_poll_callback while ovflist was active, we may now relax this
+	 */
+	__pm_relax(ep->ws);
+
+	/* re-enqueue level-triggered items last */
+	if (__wfcq_splice(&ep->txlhead, &ep->txltail, &lthead, &lttail)
+						!= WFCQ_RET_SRC_EMPTY)
+		*eavail = true;
+
+	return eventcnt;
 }
 
 static inline struct timespec ep_set_mstimeout(long ms)
@@ -1552,11 +1586,12 @@ static inline struct timespec ep_set_mstimeout(long ms)
 static int ep_poll(struct eventpoll *ep, struct epoll_event __user *events,
 		   int maxevents, long timeout)
 {
-	int res = 0, eavail, timed_out = 0;
+	int res = 0;
 	unsigned long flags;
 	long slack = 0;
 	wait_queue_t wait;
 	ktime_t expires, *to = NULL;
+	bool eavail;
 
 	if (timeout > 0) {
 		struct timespec end_time = ep_set_mstimeout(timeout);
@@ -1564,27 +1599,23 @@ static int ep_poll(struct eventpoll *ep, struct epoll_event __user *events,
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
+	mutex_lock(&ep->mtx);
+	eavail = ep_events_available(ep);
+
+	if (!eavail && timeout) {
+wait_queue_loop:
 
-	if (!ep_events_available(ep)) {
 		/*
 		 * We don't have any available event to return to the caller.
 		 * We need to sleep here, and we will be wake up by
 		 * ep_poll_callback() when events will become available.
 		 */
 		init_waitqueue_entry(&wait, current);
+		spin_lock_irqsave(&ep->wq.lock, flags);
 		__add_wait_queue_exclusive(&ep->wq, &wait);
+		spin_unlock_irqrestore(&ep->wq.lock, flags);
 
 		for (;;) {
 			/*
@@ -1593,37 +1624,44 @@ fetch_events:
 			 * to TASK_INTERRUPTIBLE before doing the checks.
 			 */
 			set_current_state(TASK_INTERRUPTIBLE);
-			if (ep_events_available(ep) || timed_out)
+			eavail = ep_events_available(ep);
+			if (eavail || !timeout)
 				break;
 			if (signal_pending(current)) {
 				res = -EINTR;
 				break;
 			}
+			mutex_unlock(&ep->mtx);
 
-			spin_unlock_irqrestore(&ep->lock, flags);
 			if (!schedule_hrtimeout_range(to, slack, HRTIMER_MODE_ABS))
-				timed_out = 1;
+				timeout = 0;
 
-			spin_lock_irqsave(&ep->lock, flags);
+			mutex_lock(&ep->mtx);
 		}
+
+		spin_lock_irqsave(&ep->wq.lock, flags);
 		__remove_wait_queue(&ep->wq, &wait);
+		spin_unlock_irqrestore(&ep->wq.lock, flags);
 
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
+		res = ep_send_events(ep, &eavail, events, maxevents);
+		if (!res && timeout)
+			goto wait_queue_loop;
+	}
+
+	mutex_unlock(&ep->mtx);
+
+	/* we may not have transferred everything, wake up others */
+	if (eavail)
+		ep_notify_waiters(ep);
 
 	return res;
 }
-- 
1.8.2.rc3.2.geae6cf5

