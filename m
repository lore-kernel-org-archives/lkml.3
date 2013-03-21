Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753881Ab3CUWMp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 18:12:45 -0400
Received: from dcvr.yhbt.net ([64.71.152.64]:56580 "EHLO dcvr.yhbt.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752854Ab3CUWMn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 18:12:43 -0400
Date: Thu, 21 Mar 2013 22:12:43 +0000
From: Eric Wong <normalperson@yhbt.net>
To: linux-kernel@vger.kernel.org
Cc: Davide Libenzi <davidel@xmailserver.org>,
        Al Viro <viro@ZenIV.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        linux-fsdevel@vger.kernel.org
Subject: [RFC v2 3/2] epoll: avoid using extra cache line on most 64-bit
Message-ID: <20130321221243.GA17708@dcvr.yhbt.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

By moving the events field epitem, we can avoid dirtying (or even
loading) an extra cache line on 64-bit machines with 64-byte cache
lines.  Since EPOLLWAKEUP is uncommonly used, we add an additional check
for the EPOLLWAKEUP flag to avoid reading a second cache line for
the wakeup_source.

This allows ep_send_events to only read/write the top 64-bytes of an
epitem in common cases.

This patch was only made possible by the smaller footprint required
by wfcqueue.

epwbench test timings:

Before (without wfcq at all):
AVG: 5.448400
SIG: 0.003056

Before (with wfcq local):
AVG: 5.532024
SIG: 0.000244

After (this commit):
AVG: 5.331539
SIG: 0.000234

Even with the variability between runs on my KVM, I'm confident this
wfcqueue epoll series introduces no performance regressions in the
common single-threaded use cases of epoll.

ref: http://www.xmailserver.org/epwbench.c

Somewhat-tested-by: Eric Wong <normalperson@yhbt.net>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Davide Libenzi <davidel@xmailserver.org>
Cc: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>
---
 fs/eventpoll.c | 27 +++++++++++++++++++++++----
 1 file changed, 23 insertions(+), 4 deletions(-)

diff --git a/fs/eventpoll.c b/fs/eventpoll.c
index 1e04175..82bf483 100644
--- a/fs/eventpoll.c
+++ b/fs/eventpoll.c
@@ -155,12 +155,27 @@ struct epitem {
 	/* The file descriptor information this item refers to */
 	struct epoll_filefd ffd;
 
-	/* Number of active wait queue attached to poll operations */
+	/*
+	 * Number of active wait queue attached to poll operations
+	 * This is infrequently used, it pads well here but may be
+	 * removed in the future
+	 */
 	int nwait;
 
 	/* state of this item */
 	enum epoll_item_state state;
 
+	/* The structure that describe the interested events and the source fd */
+	struct epoll_event event;
+
+	/*
+	 * --> 64-byte boundary for 64-bit systems <--
+	 * frequently accessed (read/written) items ar above this comment
+	 * infrequently accessed items are below this comment
+	 * Keeping frequently accessed items within the 64-byte boundary
+	 * prevents extra cache line usage on common x86-64 machines
+	 */
+
 	/* List containing poll wait queues */
 	struct list_head pwqlist;
 
@@ -172,9 +187,6 @@ struct epitem {
 
 	/* wakeup_source used when EPOLLWAKEUP is set */
 	struct wakeup_source __rcu *ws;
-
-	/* The structure that describe the interested events and the source fd */
-	struct epoll_event event;
 };
 
 /*
@@ -596,6 +608,13 @@ static void ep_unregister_pollwait(struct eventpoll *ep, struct epitem *epi)
 /* call only when ep->mtx is held */
 static inline struct wakeup_source *ep_wakeup_source(struct epitem *epi)
 {
+	/*
+	 * avoid loading the extra cache line on machines with
+	 * <= 64-byte cache lines
+	 */
+	if (!(epi->event.events & EPOLLWAKEUP))
+		return NULL;
+
 	return rcu_dereference_check(epi->ws, lockdep_is_held(&epi->ep->mtx));
 }
 
-- 
Eric Wong

