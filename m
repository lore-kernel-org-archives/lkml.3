Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752609Ab3CJLub (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Mar 2013 07:50:31 -0400
Received: from dcvr.yhbt.net ([64.71.152.64]:45488 "EHLO dcvr.yhbt.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751974Ab3CJLu3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Mar 2013 07:50:29 -0400
Date: Sun, 10 Mar 2013 11:50:28 +0000
From: Eric Wong <normalperson@yhbt.net>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Arve =?utf-8?B?SGrDuG5uZXbDpWc=?= <arve@android.com>,
        NeilBrown <neilb@suse.de>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        linux-kernel@vger.kernel.org, Davide Libenzi <davidel@xmailserver.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] epoll: use RCU protect wakeup_source in epitem
Message-ID: <20130310115028.GB16551@dcvr.yhbt.net>
References: <20130307112639.GA25130@dcvr.yhbt.net>
 <20130308013027.GA31830@dcvr.yhbt.net>
 <CAMP5Xgdsam2DGLshL5Uu5Q4La_nAq=u1YRNBwAxDstgCvJiqfw@mail.gmail.com>
 <20130308204944.GA27379@dcvr.yhbt.net>
 <CAMP5Xgc4-oX=-V57Mu5PARCWdfpkjck0VnZNAXH-JisvKi5tAg@mail.gmail.com>
 <20130309071037.GA13360@dcvr.yhbt.net>
 <20130310011136.GA4815@dcvr.yhbt.net>
 <1362891577.4051.21.camel@edumazet-glaptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1362891577.4051.21.camel@edumazet-glaptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric Dumazet <eric.dumazet@gmail.com> wrote:
> On Sun, 2013-03-10 at 01:11 +0000, Eric Wong wrote:
> >  
> >  static void ep_destroy_wakeup_source(struct epitem *epi)
> >  {
> > -	wakeup_source_unregister(epi->ws);
> > -	epi->ws = NULL;
> > +	struct wakeup_source *ws = epi->ws;
> > +
> > +	rcu_assign_pointer(epi->ws, NULL);
> 
> There is no need to use a memory barrier before setting epi->ws to NULL
> 
> You should use RCU_POINTER_INIT()

Thanks for looking at this patch.  Using RCU_POINTER_INIT in my
updated patch below.

> > +	synchronize_rcu(); /* wait for ep_pm_stay_awake to finish */
> 
> Wont this add a significant slowdown ?

Maybe, but this is a very rare code path (using EPOLL_CTL_MOD to remove
a wakeup source), and synchronize_rcu gets called later, too:

	wakeup_source_unregister
		wakeup_source_remove
			synchronize_rcu

> > +	wakeup_source_unregister(ws);
> >  }
> 
> Please add the following in your .config
> 
> CONFIG_SPARSE_RCU_POINTER=y
> 
> and try :
> 
> make C=2 fs/eventpoll.o
> 
> And fix all warnings ;)

Done.

---------------------------------8<------------------------------
>From 24e5ee6222cc91208119973248fc4f8a6d1a31da Mon Sep 17 00:00:00 2001
From: Eric Wong <normalperson@yhbt.net>
Date: Sun, 10 Mar 2013 01:06:50 +0000
Subject: [PATCH] epoll: use RCU protect wakeup_source in epitem

This prevents wakeup_source destruction when a user hits the item with
EPOLL_CTL_MOD while ep_poll_callback is running.

Tested with CONFIG_SPARSE_RCU_POINTER=y and "make fs/eventpoll.o C=2"

Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Arve Hjønnevåg <arve@android.com>
Cc: Davide Libenzi <davidel@xmailserver.org>
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Cc: NeilBrown <neilb@suse.de>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Signed-off-by: Eric Wong <normalperson@yhbt.net>
---
 fs/eventpoll.c | 92 ++++++++++++++++++++++++++++++++++++++++++++--------------
 1 file changed, 71 insertions(+), 21 deletions(-)

diff --git a/fs/eventpoll.c b/fs/eventpoll.c
index 1326409..15d0f27 100644
--- a/fs/eventpoll.c
+++ b/fs/eventpoll.c
@@ -158,7 +158,7 @@ struct epitem {
 	struct list_head fllink;
 
 	/* wakeup_source used when EPOLLWAKEUP is set */
-	struct wakeup_source *ws;
+	struct wakeup_source __rcu *ws;
 
 	/* The structure that describe the interested events and the source fd */
 	struct epoll_event event;
@@ -536,6 +536,38 @@ static void ep_unregister_pollwait(struct eventpoll *ep, struct epitem *epi)
 	}
 }
 
+/* call only when ep->mtx is held */
+static inline struct wakeup_source *ep_wakeup_source(struct epitem *epi)
+{
+	return rcu_dereference_check(epi->ws, lockdep_is_held(&epi->ep->mtx));
+}
+
+/* call only when ep->mtx is held */
+static inline void ep_pm_stay_awake(struct epitem *epi)
+{
+	struct wakeup_source *ws = ep_wakeup_source(epi);
+
+	if (ws)
+		__pm_stay_awake(ws);
+}
+
+static inline bool ep_has_wakeup_source(struct epitem *epi)
+{
+	return rcu_access_pointer(epi->ws) ? true : false;
+}
+
+/* call when ep->mtx cannot be held (ep_poll_callback) */
+static inline void ep_pm_stay_awake_rcu(struct epitem *epi)
+{
+	struct wakeup_source *ws;
+
+	rcu_read_lock();
+	ws = rcu_dereference(epi->ws);
+	if (ws)
+		__pm_stay_awake(ws);
+	rcu_read_unlock();
+}
+
 /**
  * ep_scan_ready_list - Scans the ready list in a way that makes possible for
  *                      the scan code, to call f_op->poll(). Also allows for
@@ -599,7 +631,7 @@ static int ep_scan_ready_list(struct eventpoll *ep,
 		 */
 		if (!ep_is_linked(&epi->rdllink)) {
 			list_add_tail(&epi->rdllink, &ep->rdllist);
-			__pm_stay_awake(epi->ws);
+			ep_pm_stay_awake(epi);
 		}
 	}
 	/*
@@ -668,7 +700,7 @@ static int ep_remove(struct eventpoll *ep, struct epitem *epi)
 		list_del_init(&epi->rdllink);
 	spin_unlock_irqrestore(&ep->lock, flags);
 
-	wakeup_source_unregister(epi->ws);
+	wakeup_source_unregister(ep_wakeup_source(epi));
 
 	/* At this point it is safe to free the eventpoll item */
 	kmem_cache_free(epi_cache, epi);
@@ -752,7 +784,7 @@ static int ep_read_events_proc(struct eventpoll *ep, struct list_head *head,
 			 * callback, but it's not actually ready, as far as
 			 * caller requested events goes. We can remove it here.
 			 */
-			__pm_relax(epi->ws);
+			__pm_relax(ep_wakeup_source(epi));
 			list_del_init(&epi->rdllink);
 		}
 	}
@@ -984,7 +1016,7 @@ static int ep_poll_callback(wait_queue_t *wait, unsigned mode, int sync, void *k
 	/* If this file is already in the ready list we exit soon */
 	if (!ep_is_linked(&epi->rdllink)) {
 		list_add_tail(&epi->rdllink, &ep->rdllist);
-		__pm_stay_awake(epi->ws);
+		ep_pm_stay_awake(epi);
 	}
 
 	/*
@@ -1146,6 +1178,7 @@ static int reverse_path_check(void)
 static int ep_create_wakeup_source(struct epitem *epi)
 {
 	const char *name;
+	struct wakeup_source *ws;
 
 	if (!epi->ep->ws) {
 		epi->ep->ws = wakeup_source_register("eventpoll");
@@ -1154,17 +1187,29 @@ static int ep_create_wakeup_source(struct epitem *epi)
 	}
 
 	name = epi->ffd.file->f_path.dentry->d_name.name;
-	epi->ws = wakeup_source_register(name);
-	if (!epi->ws)
+	ws = wakeup_source_register(name);
+
+	if (!ws)
 		return -ENOMEM;
+	rcu_assign_pointer(epi->ws, ws);
 
 	return 0;
 }
 
-static void ep_destroy_wakeup_source(struct epitem *epi)
+/* rare code path, only used when EPOLL_CTL_MOD removes a wakeup source */
+static noinline void ep_destroy_wakeup_source(struct epitem *epi)
 {
-	wakeup_source_unregister(epi->ws);
-	epi->ws = NULL;
+	struct wakeup_source *ws = ep_wakeup_source(epi);
+
+	rcu_assign_pointer(epi->ws, NULL);
+
+	/*
+	 * wait for ep_pm_stay_awake_rcu to finish, synchronize_rcu is
+	 * used internally by wakeup_source_remove, too (called by
+	 * wakeup_source_unregister), so we cannot use call_rcu
+	 */
+	synchronize_rcu();
+	wakeup_source_unregister(ws);
 }
 
 /*
@@ -1199,7 +1244,7 @@ static int ep_insert(struct eventpoll *ep, struct epoll_event *event,
 		if (error)
 			goto error_create_wakeup_source;
 	} else {
-		epi->ws = NULL;
+		RCU_INIT_POINTER(epi->ws, NULL);
 	}
 
 	/* Initialize the poll table using the queue callback */
@@ -1247,7 +1292,7 @@ static int ep_insert(struct eventpoll *ep, struct epoll_event *event,
 	/* If the file is already "ready" we drop it inside the ready list */
 	if ((revents & event->events) && !ep_is_linked(&epi->rdllink)) {
 		list_add_tail(&epi->rdllink, &ep->rdllist);
-		__pm_stay_awake(epi->ws);
+		ep_pm_stay_awake(epi);
 
 		/* Notify waiting tasks that events are available */
 		if (waitqueue_active(&ep->wq))
@@ -1288,7 +1333,7 @@ error_unregister:
 		list_del_init(&epi->rdllink);
 	spin_unlock_irqrestore(&ep->lock, flags);
 
-	wakeup_source_unregister(epi->ws);
+	wakeup_source_unregister(ep_wakeup_source(epi));
 
 error_create_wakeup_source:
 	kmem_cache_free(epi_cache, epi);
@@ -1317,9 +1362,9 @@ static int ep_modify(struct eventpoll *ep, struct epitem *epi, struct epoll_even
 	pt._key = event->events;
 	epi->event.data = event->data; /* protected by mtx */
 	if (epi->event.events & EPOLLWAKEUP) {
-		if (!epi->ws)
+		if (!ep_has_wakeup_source(epi))
 			ep_create_wakeup_source(epi);
-	} else if (epi->ws) {
+	} else if (ep_has_wakeup_source(epi)) {
 		ep_destroy_wakeup_source(epi);
 	}
 
@@ -1357,7 +1402,7 @@ static int ep_modify(struct eventpoll *ep, struct epitem *epi, struct epoll_even
 		spin_lock_irq(&ep->lock);
 		if (!ep_is_linked(&epi->rdllink)) {
 			list_add_tail(&epi->rdllink, &ep->rdllist);
-			__pm_stay_awake(epi->ws);
+			ep_pm_stay_awake(epi);
 
 			/* Notify waiting tasks that events are available */
 			if (waitqueue_active(&ep->wq))
@@ -1383,6 +1428,7 @@ static int ep_send_events_proc(struct eventpoll *ep, struct list_head *head,
 	unsigned int revents;
 	struct epitem *epi;
 	struct epoll_event __user *uevent;
+	struct wakeup_source *ws;
 	poll_table pt;
 
 	init_poll_funcptr(&pt, NULL);
@@ -1405,9 +1451,13 @@ static int ep_send_events_proc(struct eventpoll *ep, struct list_head *head,
 		 * instead, but then epi->ws would temporarily be out of sync
 		 * with ep_is_linked().
 		 */
-		if (epi->ws && epi->ws->active)
-			__pm_stay_awake(ep->ws);
-		__pm_relax(epi->ws);
+		ws = ep_wakeup_source(epi);
+		if (ws) {
+			if (ws->active)
+				__pm_stay_awake(ep->ws);
+			__pm_relax(ws);
+		}
+
 		list_del_init(&epi->rdllink);
 
 		pt._key = epi->event.events;
@@ -1424,7 +1474,7 @@ static int ep_send_events_proc(struct eventpoll *ep, struct list_head *head,
 			if (__put_user(revents, &uevent->events) ||
 			    __put_user(epi->event.data, &uevent->data)) {
 				list_add(&epi->rdllink, head);
-				__pm_stay_awake(epi->ws);
+				ep_pm_stay_awake(epi);
 				return eventcnt ? eventcnt : -EFAULT;
 			}
 			eventcnt++;
@@ -1444,7 +1494,7 @@ static int ep_send_events_proc(struct eventpoll *ep, struct list_head *head,
 				 * poll callback will queue them in ep->ovflist.
 				 */
 				list_add_tail(&epi->rdllink, &ep->rdllist);
-				__pm_stay_awake(epi->ws);
+				ep_pm_stay_awake(epi);
 			}
 		}
 	}
-- 
1.8.2.rc3.2.g89ce8d6

