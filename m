Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755321Ab3CVTYZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 15:24:25 -0400
Received: from dcvr.yhbt.net ([64.71.152.64]:35190 "EHLO dcvr.yhbt.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755193Ab3CVTYY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 15:24:24 -0400
Date: Fri, 22 Mar 2013 19:24:23 +0000
From: Eric Wong <normalperson@yhbt.net>
To: Arve =?utf-8?B?SGrDuG5uZXbDpWc=?= <arve@android.com>
Cc: linux-kernel@vger.kernel.org, Davide Libenzi <davidel@xmailserver.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        linux-fsdevel@vger.kernel.org
Subject: Re: [RFC v3 1/2] epoll: avoid spinlock contention with wfcqueue
Message-ID: <20130322192423.GA25561@dcvr.yhbt.net>
References: <20130321115259.GA17883@dcvr.yhbt.net>
 <CAMP5XgfKfuF4Lo1PVoqBnjynB6COWVhVcqzKV3PAic7HLP7FaQ@mail.gmail.com>
 <20130322032410.GA19377@dcvr.yhbt.net>
 <CAMP5XgcPG6-ikNE5jQHL9vNVPrM4wrMb8HYfYcEfT2hW6a2pUA@mail.gmail.com>
 <20130322103102.GA4818@dcvr.yhbt.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20130322103102.GA4818@dcvr.yhbt.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric Wong <normalperson@yhbt.net> wrote:
> Arve Hjønnevåg <arve@android.com> wrote:
> > On Thu, Mar 21, 2013 at 8:24 PM, Eric Wong <normalperson@yhbt.net> wrote:
> > >
> > > With EPOLLET and improper usage (not hitting EAGAIN), the event now
> > > has a larger window to be lost (as mentioned in my changelog).
> > >
> > 
> > What about the case where EPOLLET is not set? The old code did not
> > drop events in that case.
> 
> Nothing is dropped, if the event wasn't on the ready list before,
> ep_poll_callback may still append the ready list while __put_user
> is running.
> 
> If the event was on the ready list:
> 
> 1) It does not matter for EPOLLONESHOT, it'll get masked out and
>    discarded in the next ep_send_events call until ep_modify reenables
>    it.  Since ep_modify and ep_send_events both take ep->mtx, there's
>    no conflict.
> 
> 2) Level Trigger - event stays ready, so nothing is dropped.
> 
> > > As far as correct __pm_stay_awake/__pm_relax handling, perhaps adding
> > > an atomic counter to struct eventpoll (or each epitem) will work?
> > 
> > The wakeup_source should stay in sync with the epoll state. I don't
> > think any additional state is needed.
> 
> The problem is epi->state is not set atomically in ep_send_events,
> 
> Having atomic operations in the loop hurts performance (early versions
> of this patch did that, and hurt the single-threaded case).
> 
> Maybe I'll only set epi->state atomically if epi->ws is used...
> 
> > > If we go with atomic counter in struct eventpoll, is per-epitem
> > > wakeup_source still necessary?  We have space in epitem now, but
> > > maybe one day we will might need it.
> > >
> > 
> > The wakeup_source per epitem is useful for accounting reasons. If
> > suspend fails, it is useful to know which device caused it.
> 
> OK.  I'll keep epitem->ws

Perhaps just using epitem->ws and removing ep->ws can work.

I think the following change to keep wakeup_source in sync with
epi->state is sufficient to prevent suspend.

But I'm not familiar with suspend.  Is it possible to suspend while
a) spinning on a lock?
b) holding a spinlock?

Since we avoid spinlocks in the main ep_poll_callback path, maybe the
chance of entering suspend is reduced anyways since we may activate
the ws sooner.

What do you think?

diff --git a/fs/eventpoll.c b/fs/eventpoll.c
index 1e04175..531ad46 100644
--- a/fs/eventpoll.c
+++ b/fs/eventpoll.c
@@ -214,9 +214,6 @@ struct eventpoll {
 	/* RB tree root used to store monitored fd structs */
 	struct rb_root rbr;
 
-	/* wakeup_source used when ep_send_events is running */
-	struct wakeup_source *ws;
-
 	/* The user that created the eventpoll descriptor */
 	struct user_struct *user;
 
@@ -718,7 +715,6 @@ static void ep_free(struct eventpoll *ep)
 	mutex_unlock(&epmutex);
 	mutex_destroy(&ep->mtx);
 	free_uid(ep->user);
-	wakeup_source_unregister(ep->ws);
 	kfree(ep);
 }
 
@@ -1137,12 +1133,6 @@ static int ep_create_wakeup_source(struct epitem *epi)
 	const char *name;
 	struct wakeup_source *ws;
 
-	if (!epi->ep->ws) {
-		epi->ep->ws = wakeup_source_register("eventpoll");
-		if (!epi->ep->ws)
-			return -ENOMEM;
-	}
-
 	name = epi->ffd.file->f_path.dentry->d_name.name;
 	ws = wakeup_source_register(name);
 
@@ -1390,22 +1380,6 @@ static int ep_send_events(struct eventpoll *ep, bool *eavail,
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
@@ -1419,7 +1393,6 @@ static int ep_send_events(struct eventpoll *ep, bool *eavail,
 			    __put_user(epi->event.data, &uevent->data)) {
 				wfcq_enqueue_local(&ep->txlhead, &ep->txltail,
 							&epi->rdllink);
-				ep_pm_stay_awake(epi);
 				if (!eventcnt)
 					eventcnt = -EFAULT;
 				break;
@@ -1441,13 +1414,34 @@ static int ep_send_events(struct eventpoll *ep, bool *eavail,
 				 */
 				wfcq_enqueue_local(&lthead, &lttail,
 							&epi->rdllink);
-				ep_pm_stay_awake(epi);
 				continue;
 			}
 		}
 
 		/*
-		 * reset item state for EPOLLONESHOT and EPOLLET
+		 * Deactivate the wakeup source before marking it idle.
+		 * The barrier implied by the spinlock in __pm_relax ensures
+		 * any ep_poll_callback callers running will see the
+		 * deactivated ws before epi->state == EP_STATE_IDLE.
+		 *
+		 * For EPOLLET, the event may still be merged into the one
+		 * that is currently on its way into userspace, but it has
+		 * always been the responsibility of userspace to trigger
+		 * EAGAIN on the file before it expects the item to appear
+		 * again in epoll_wait.
+		 *
+		 * Level Trigger never gets here, so the ws remains active.
+		 *
+		 * EPOLLONESHOT will either be dropped by ep_poll_callback
+		 * or dropped the next time ep_send_events is called, so the
+		 * ws is irrelevant until it is hit by ep_modify
+		 */
+		ws = ep_wakeup_source(epi);
+		if (ws)
+			__pm_relax(ws);
+
+		/*
+		 * reset item state for EPOLLONESHOT and EPOLLET.
 		 * no barrier here, rely on ep->mtx release for write barrier
 		 */
 		epi->state = EP_STATE_IDLE;

-- 
Eric Wong
