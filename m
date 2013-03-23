Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751560Ab3CWKQj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Mar 2013 06:16:39 -0400
Received: from dcvr.yhbt.net ([64.71.152.64]:39825 "EHLO dcvr.yhbt.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750838Ab3CWKQh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Mar 2013 06:16:37 -0400
Date: Sat, 23 Mar 2013 10:16:36 +0000
From: Eric Wong <normalperson@yhbt.net>
To: Arve =?utf-8?B?SGrDuG5uZXbDpWc=?= <arve@android.com>
Cc: linux-kernel@vger.kernel.org, Davide Libenzi <davidel@xmailserver.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        linux-fsdevel@vger.kernel.org
Subject: Re: [RFC v3 1/2] epoll: avoid spinlock contention with wfcqueue
Message-ID: <20130323101636.GA4439@dcvr.yhbt.net>
References: <20130321115259.GA17883@dcvr.yhbt.net>
 <CAMP5XgfKfuF4Lo1PVoqBnjynB6COWVhVcqzKV3PAic7HLP7FaQ@mail.gmail.com>
 <20130322032410.GA19377@dcvr.yhbt.net>
 <CAMP5XgcPG6-ikNE5jQHL9vNVPrM4wrMb8HYfYcEfT2hW6a2pUA@mail.gmail.com>
 <20130322103102.GA4818@dcvr.yhbt.net>
 <CAMP5XgcN+qBJ7FryzXJEG11F=3ajHDoBncMyShZOksd14SaptA@mail.gmail.com>
 <20130322225428.GA7596@dcvr.yhbt.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20130322225428.GA7596@dcvr.yhbt.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric Wong <normalperson@yhbt.net> wrote:
> Arve Hjønnevåg <arve@android.com> wrote:
> > 
> > At some point the level triggered event has to get cleared. As far as
> > I can tell, your new code will drop new events that occur between
> > "revents = ep_item_poll(epi, &pt);" and "epi->state = EP_STATE_IDLE;"
> > in that case.
> 
> Thanks for catching that, I'll need to fix that.  Maybe reintroduce
> EP_STATE_DEQUEUE, but just for the (LT && !revents) case.

I reintroduced ovflist (with less locking) instead.
I think the problem with !revents you pointed out affects non-LT, as well.

Will post an updated series (including wfcq changes, and some other
cleanups/fixes) this weekend.  Here's a work-in-progress on top of
my original [RFC v3 2/2]   Comments greatly appreciated, thanks.

diff --git a/fs/eventpoll.c b/fs/eventpoll.c
index 1e04175..c3b2ad8 100644
--- a/fs/eventpoll.c
+++ b/fs/eventpoll.c
@@ -152,6 +152,12 @@ struct epitem {
 	/* List header used to link this structure to the eventpoll ready list */
 	struct wfcq_node rdllink;
 
+	/*
+	 * Works together "struct eventpoll"->ovflist in keeping the
+	 * single linked chain of items.
+	 */
+	struct epitem *next;
+
 	/* The file descriptor information this item refers to */
 	struct epoll_filefd ffd;
 
@@ -226,6 +232,16 @@ struct eventpoll {
 	int visited;
 	struct list_head visited_list_link;
 
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
 	struct wfcq_tail rdltail ____cacheline_aligned_in_smp;
 };
 
@@ -890,12 +906,14 @@ static int ep_alloc(struct eventpoll **pep)
 		goto free_uid;
 
 	spin_lock_init(&ep->wqlock);
+	spin_lock_init(&ep->ovflock);
 	mutex_init(&ep->mtx);
 	init_waitqueue_head(&ep->wq);
 	init_waitqueue_head(&ep->poll_wait);
 	wfcq_init(&ep->rdlhead, &ep->rdltail);
 	wfcq_init(&ep->txlhead, &ep->txltail);
 	ep->rbr = RB_ROOT;
+	ep->ovflist = EP_UNACTIVE_PTR;
 	ep->user = user;
 
 	*pep = ep;
@@ -953,6 +971,7 @@ static int ep_poll_callback(wait_queue_t *wait, unsigned mode, int sync, void *k
 {
 	struct epitem *epi = ep_item_from_wait(wait);
 	struct eventpoll *ep = epi->ep;
+	unsigned long flags;
 
 	if ((unsigned long)key & POLLFREE) {
 		RCU_INIT_POINTER(ep_pwq_from_wait(wait)->whead, NULL);
@@ -990,7 +1009,31 @@ static int ep_poll_callback(wait_queue_t *wait, unsigned mode, int sync, void *k
 		wfcq_enqueue(&ep->rdlhead, &ep->rdltail, &epi->rdllink);
 		ep_pm_stay_awake_rcu(epi);
 		ep_notify_waiters(ep);
+		return 1;
+	}
+
+	/*
+	 * If we are transferring events to userspace, we can hold no locks
+	 * (because we're accessing user memory, and because of linux f_op->poll()
+	 * semantics). All the events that happen during that period of time are
+	 * chained in ep->ovflist and requeued later on.
+	 */
+	spin_lock_irqsave(&ep->ovflock, flags);
+	if (unlikely(ep->ovflist != EP_UNACTIVE_PTR)) {
+		if (epi->next == EP_UNACTIVE_PTR) {
+			epi->next = ep->ovflist;
+			ep->ovflist = epi;
+			if (epi->ws) {
+				/*
+				 * Activate ep->ws since epi->ws may get
+				 * deactivated at any time.
+				 */
+				__pm_stay_awake(ep->ws);
+			}
+		}
+		/* no need to wake up waiters, ep_send_events */
 	}
+	spin_unlock_irqrestore(&ep->ovflock, flags);
 
 	return 1;
 }
@@ -1204,6 +1247,7 @@ static int ep_insert(struct eventpoll *ep, struct epoll_event *event,
 	epi->state = EP_STATE_IDLE;
 	ep_set_ffd(&epi->ffd, tfile, fd);
 	epi->nwait = 0;
+	epi->next = EP_UNACTIVE_PTR;
 	epi->event = *event;
 	if (epi->event.events & EPOLLWAKEUP) {
 		error = ep_create_wakeup_source(epi);
@@ -1356,6 +1400,61 @@ static int ep_modify(struct eventpoll *ep, struct epitem *epi, struct epoll_even
 	return 0;
 }
 
+static void ep_ovf_enable(struct eventpoll *ep)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&ep->ovflock, flags);
+	ep->ovflist = NULL;
+	spin_unlock_irqrestore(&ep->ovflock, flags);
+}
+
+/*
+ * disables the ovf queue and reinjects events that went into ovf queue
+ * into txlist.
+ */
+static void ep_ovf_disable(struct eventpoll *ep)
+{
+	unsigned long flags;
+	struct epitem *epi, *nepi;
+
+	spin_lock_irqsave(&ep->ovflock, flags);
+	nepi = ep->ovflist;
+	ep->ovflist = EP_UNACTIVE_PTR;
+	spin_unlock_irqrestore(&ep->ovflock, flags);
+
+	/*
+	 * We can work on ovflist without the ovflock since we are certain
+	 * ep_poll_callback will not append to ovflist anymore.
+	 *
+	 * We still need ep->mtx to be held during this, though.
+	 *
+	 * During the time we spent inside the ep_send_events, some
+	 * other events might have been queued by the poll callback.
+	 * We re-insert them inside the main ready-list here.
+	 */
+	for (; (epi = nepi) != NULL;
+	     nepi = epi->next, epi->next = EP_UNACTIVE_PTR) {
+		/*
+		 * We need to check if the item is already in the list.
+		 * During the ep_send_events loop execution time, items are
+		 * queued into ->ovflist but the "txlhead/tail" might already
+		 * contain them, and the ep_mark_ready takes care of them
+		 */
+		if (!ep_mark_ready(epi))
+			continue;
+
+		wfcq_enqueue_local(&ep->txlhead, &ep->txltail, &epi->rdllink);
+		ep_pm_stay_awake(epi);
+	}
+
+	/*
+	 * we've now activated all the epi->ws we could not activate from
+	 * ep_poll_callback while ovflist was active, we may now relax this
+	 */
+	__pm_relax(ep->ws);
+}
+
 static int ep_send_events(struct eventpoll *ep, bool *eavail,
 			  struct epoll_event __user *uevent, int maxevents)
 {
@@ -1372,6 +1471,8 @@ static int ep_send_events(struct eventpoll *ep, bool *eavail,
 	wfcq_init(&lthead, &lttail);
 	init_poll_funcptr(&pt, NULL);
 
+	ep_ovf_enable(ep);
+
 	/*
 	 * Items cannot vanish during the loop because we are holding
 	 * "mtx" during this call.
@@ -1390,22 +1491,6 @@ static int ep_send_events(struct eventpoll *ep, bool *eavail,
 		WARN_ON(state != EP_STATE_READY);
 		wfcq_node_init(&epi->rdllink);
 
-		/*
-		 * Activate ep->ws before deactivating epi->ws to prevent
-		 * triggering auto-suspend here (in case we reactive epi->ws
-		 * below).
-		 *
-		 * This could be rearranged to delay the deactivation of epi->ws
-		 * instead, but then epi->ws would temporarily be out of sync
-		 * with epi->state.
-		 */
-		ws = ep_wakeup_source(epi);
-		if (ws) {
-			if (ws->active)
-				__pm_stay_awake(ep->ws);
-			__pm_relax(ws);
-		}
-
 		revents = ep_item_poll(epi, &pt);
 
 		/*
@@ -1419,7 +1504,6 @@ static int ep_send_events(struct eventpoll *ep, bool *eavail,
 			    __put_user(epi->event.data, &uevent->data)) {
 				wfcq_enqueue_local(&ep->txlhead, &ep->txltail,
 							&epi->rdllink);
-				ep_pm_stay_awake(epi);
 				if (!eventcnt)
 					eventcnt = -EFAULT;
 				break;
@@ -1441,19 +1525,28 @@ static int ep_send_events(struct eventpoll *ep, bool *eavail,
 				 */
 				wfcq_enqueue_local(&lthead, &lttail,
 							&epi->rdllink);
-				ep_pm_stay_awake(epi);
 				continue;
 			}
 		}
 
 		/*
-		 * reset item state for EPOLLONESHOT and EPOLLET
-		 * no barrier here, rely on ep->mtx release for write barrier
+		 * Deactivate the wakeup source before marking it idle.
+		 * The barrier implied by the spinlock in __pm_relax ensures
+		 * any future ep_poll_callback callers running will see the
+		 * deactivated ws before epi->state == EP_STATE_IDLE.
 		 */
+		ws = ep_wakeup_source(epi);
+		if (ws)
+			__pm_relax(ws);
+
+		/* no barrier needed, wait until ep_ovf_disable */
 		epi->state = EP_STATE_IDLE;
 	}
 
-	/* grab any events we got while copying */
+	/* grab any (possibly redundant) events we got while copying */
+	ep_ovf_disable(ep);
+
+	/* see if we have any more items left (or very new ones) */
 	*eavail = ep_events_available(ep);
 
 	/* requeue level-triggered items */
