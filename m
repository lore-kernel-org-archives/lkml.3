Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751856Ab3CJBLi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Mar 2013 20:11:38 -0500
Received: from dcvr.yhbt.net ([64.71.152.64]:41730 "EHLO dcvr.yhbt.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751357Ab3CJBLh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Mar 2013 20:11:37 -0500
Date: Sun, 10 Mar 2013 01:11:36 +0000
From: Eric Wong <normalperson@yhbt.net>
To: Arve =?utf-8?B?SGrDuG5uZXbDpWc=?= <arve@android.com>
Cc: NeilBrown <neilb@suse.de>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        linux-kernel@vger.kernel.org, Davide Libenzi <davidel@xmailserver.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: epoll: possible bug from wakeup_source activation
Message-ID: <20130310011136.GA4815@dcvr.yhbt.net>
References: <20130307112639.GA25130@dcvr.yhbt.net>
 <20130308013027.GA31830@dcvr.yhbt.net>
 <CAMP5Xgdsam2DGLshL5Uu5Q4La_nAq=u1YRNBwAxDstgCvJiqfw@mail.gmail.com>
 <20130308204944.GA27379@dcvr.yhbt.net>
 <CAMP5Xgc4-oX=-V57Mu5PARCWdfpkjck0VnZNAXH-JisvKi5tAg@mail.gmail.com>
 <20130309071037.GA13360@dcvr.yhbt.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20130309071037.GA13360@dcvr.yhbt.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric Wong <normalperson@yhbt.net> wrote:
> Arve Hjønnevåg <arve@android.com> wrote:
> > On Fri, Mar 8, 2013 at 12:49 PM, Eric Wong <normalperson@yhbt.net> wrote:
> > > What happens if ep_modify calls ep_destroy_wakeup_source
> > > while __pm_stay_awake is running on the same epi->ws?
> > 
> > Yes, that looks like a problem. I think calling
> > ep_destroy_wakeup_source with ep->lock held should fix that. It is not
> > clear how useful changing EPOLLWAKEUP in ep_modify is, so
> > alternatively we could remove that feature and instead only allow it
> > to be set in ep_insert.
> 
> ep->lock would work, but ep->lock is already a source of heavy
> contention in my multithreaded+epoll webservers.
> 
> Perhaps RCU can be used?  I've no experience with RCU, but I've been
> meaning to get acquainted with RCU.

The following is lightly tested, at least I haven't gotten lockdep
to complain.

--------------------------------- 8< ----------------------------
>From 2bcd549893aa204bd858cc1500a70f20b28e47c1 Mon Sep 17 00:00:00 2001
From: Eric Wong <normalperson@yhbt.net>
Date: Sun, 10 Mar 2013 01:06:50 +0000
Subject: [PATCH] epoll: RCU protect wakeup_source in epitem

This prevents wakeup_source destruction when a user hits the
item with EPOLL_CTL_MOD while ep_poll_callback is running.

Signed-off-by: Eric Wong <normalperson@yhbt.net>
---
 fs/eventpoll.c | 31 ++++++++++++++++++++++++-------
 1 file changed, 24 insertions(+), 7 deletions(-)

diff --git a/fs/eventpoll.c b/fs/eventpoll.c
index 9fec183..e008d54 100644
--- a/fs/eventpoll.c
+++ b/fs/eventpoll.c
@@ -158,7 +158,7 @@ struct epitem {
 	struct list_head fllink;
 
 	/* wakeup_source used when EPOLLWAKEUP is set */
-	struct wakeup_source *ws;
+	struct wakeup_source __rcu *ws;
 
 	/* The structure that describe the interested events and the source fd */
 	struct epoll_event event;
@@ -536,6 +536,17 @@ static void ep_unregister_pollwait(struct eventpoll *ep, struct epitem *epi)
 	}
 }
 
+static inline void ep_pm_stay_awake(struct epitem *epi)
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
@@ -984,7 +995,7 @@ static int ep_poll_callback(wait_queue_t *wait, unsigned mode, int sync, void *k
 	/* If this file is already in the ready list we exit soon */
 	if (!ep_is_linked(&epi->rdllink)) {
 		list_add_tail(&epi->rdllink, &ep->rdllist);
-		__pm_stay_awake(epi->ws);
+		ep_pm_stay_awake(epi);
 	}
 
 	/*
@@ -1146,6 +1157,7 @@ static int reverse_path_check(void)
 static int ep_create_wakeup_source(struct epitem *epi)
 {
 	const char *name;
+	struct wakeup_source *ws;
 
 	if (!epi->ep->ws) {
 		epi->ep->ws = wakeup_source_register("eventpoll");
@@ -1154,17 +1166,22 @@ static int ep_create_wakeup_source(struct epitem *epi)
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
 
 static void ep_destroy_wakeup_source(struct epitem *epi)
 {
-	wakeup_source_unregister(epi->ws);
-	epi->ws = NULL;
+	struct wakeup_source *ws = epi->ws;
+
+	rcu_assign_pointer(epi->ws, NULL);
+	synchronize_rcu(); /* wait for ep_pm_stay_awake to finish */
+	wakeup_source_unregister(ws);
 }
 
 /*
@@ -1199,7 +1216,7 @@ static int ep_insert(struct eventpoll *ep, struct epoll_event *event,
 		if (error)
 			goto error_create_wakeup_source;
 	} else {
-		epi->ws = NULL;
+		RCU_INIT_POINTER(epi->ws, NULL);
 	}
 
 	/* Initialize the poll table using the queue callback */
-- 
Eric Wong

