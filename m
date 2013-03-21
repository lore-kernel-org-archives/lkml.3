Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758039Ab3CULyt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 07:54:49 -0400
Received: from dcvr.yhbt.net ([64.71.152.64]:52908 "EHLO dcvr.yhbt.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754254Ab3CULys (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 07:54:48 -0400
Date: Thu, 21 Mar 2013 11:54:47 +0000
From: Eric Wong <normalperson@yhbt.net>
To: linux-kernel@vger.kernel.org
Cc: Davide Libenzi <davidel@xmailserver.org>,
        Al Viro <viro@ZenIV.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        linux-fsdevel@vger.kernel.org
Subject: [RFC v3 2/2] epoll: use a local wfcq functions for Level Trigger
Message-ID: <20130321115447.GB17883@dcvr.yhbt.net>
References: <20130321115259.GA17883@dcvr.yhbt.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130321115259.GA17883@dcvr.yhbt.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Using Davide's epwbench to test, this mostly fixes a performance
regression with level trigger in a single-threaded workload.
Single-threaded level trigger is probably the most common method
of using epoll, so performance is important.

Before (without wfcq at all):
AVG: 5.448400
SIG: 0.003056

Before (with wfcq):
AVG: 7.735375
SIG: 0.000064

Currently (with wfcq local):
AVG: 5.532024
SIG: 0.000244

The margin of error for my tests is pretty high under KVM.  I'm getting
wildly varying (~0.10s) differences between runs on the same boot,
However the difference between using plain wfcq and these new _local
functions is large and outside of the margin of error.

ref: http://www.xmailserver.org/epwbench.c

Somewhat-tested-by: Eric Wong <normalperson@yhbt.net>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Davide Libenzi <davidel@xmailserver.org>
Cc: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>
---
 fs/eventpoll.c | 20 +++++++++++++++-----
 1 file changed, 15 insertions(+), 5 deletions(-)

diff --git a/fs/eventpoll.c b/fs/eventpoll.c
index e039555..1e04175 100644
--- a/fs/eventpoll.c
+++ b/fs/eventpoll.c
@@ -1356,7 +1356,7 @@ static int ep_modify(struct eventpoll *ep, struct epitem *epi, struct epoll_even
 	return 0;
 }
 
-static int ep_send_events(struct eventpoll *ep,
+static int ep_send_events(struct eventpoll *ep, bool *eavail,
 			  struct epoll_event __user *uevent, int maxevents)
 {
 	int eventcnt = 0;
@@ -1366,7 +1366,10 @@ static int ep_send_events(struct eventpoll *ep,
 	struct wfcq_node *node, *n;
 	enum epoll_item_state state;
 	poll_table pt;
+	struct wfcq_head lthead;
+	struct wfcq_tail lttail;
 
+	wfcq_init(&lthead, &lttail);
 	init_poll_funcptr(&pt, NULL);
 
 	/*
@@ -1414,7 +1417,7 @@ static int ep_send_events(struct eventpoll *ep,
 		if (revents) {
 			if (__put_user(revents, &uevent->events) ||
 			    __put_user(epi->event.data, &uevent->data)) {
-				wfcq_enqueue(&ep->txlhead, &ep->txltail,
+				wfcq_enqueue_local(&ep->txlhead, &ep->txltail,
 							&epi->rdllink);
 				ep_pm_stay_awake(epi);
 				if (!eventcnt)
@@ -1436,7 +1439,7 @@ static int ep_send_events(struct eventpoll *ep,
 				 * epoll_wait() will check again the events
 				 * availability.
 				 */
-				wfcq_enqueue(&ep->rdlhead, &ep->rdltail,
+				wfcq_enqueue_local(&lthead, &lttail,
 							&epi->rdllink);
 				ep_pm_stay_awake(epi);
 				continue;
@@ -1450,6 +1453,14 @@ static int ep_send_events(struct eventpoll *ep,
 		epi->state = EP_STATE_IDLE;
 	}
 
+	/* grab any events we got while copying */
+	*eavail = ep_events_available(ep);
+
+	/* requeue level-triggered items */
+	if (__wfcq_splice(&ep->txlhead, &ep->txltail, &lthead, &lttail)
+	    != WFCQ_RET_SRC_EMPTY)
+		*eavail = true;
+
 	return eventcnt;
 }
 
@@ -1550,12 +1561,11 @@ wait_queue_loop:
 	 * more luck.
 	 */
 	if (!res) {
-		res = ep_send_events(ep, events, maxevents);
+		res = ep_send_events(ep, &eavail, events, maxevents);
 		if (!res && timeout)
 			goto wait_queue_loop;
 	}
 
-	eavail = ep_events_available(ep);
 	mutex_unlock(&ep->mtx);
 
 	/* we may not have transferred everything, wake up others */
-- 
Eric Wong
