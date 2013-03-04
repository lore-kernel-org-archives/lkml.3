Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755317Ab3CDDG2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Mar 2013 22:06:28 -0500
Received: from dcvr.yhbt.net ([64.71.152.64]:42989 "EHLO dcvr.yhbt.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755255Ab3CDDGZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Mar 2013 22:06:25 -0500
From: Eric Wong <normalperson@yhbt.net>
To: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, Eric Wong <normalperson@yhbt.net>,
        Davide Libenzi <davidel@xmailserver.org>,
        Al Viro <viro@ZenIV.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 2/2] epoll: add tracepoints for epitem enqueue/dequeue
Date: Mon,  4 Mar 2013 03:06:08 +0000
Message-Id: <1362366368-15246-2-git-send-email-normalperson@yhbt.net>
X-Mailer: git-send-email 1.8.1.2.526.gf51a757
In-Reply-To: <1362366368-15246-1-git-send-email-normalperson@yhbt.net>
References: <20130304030500.GA29365@dcvr.yhbt.net>
 <1362366368-15246-1-git-send-email-normalperson@yhbt.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tracing the enqueue/dequeue of each epitem is useful for tracking
latency of userspace applications which use epoll.

This also adds tracing for spurious readiness of epitems.  Tracing
spurious readiness should allow us to notice (and hopefully fix)
kernel bugs causing unnecessary wakeups.

Signed-off-by: Eric Wong <normalperson@yhbt.net>
Cc: Davide Libenzi <davidel@xmailserver.org>
Cc: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>
---
 fs/eventpoll.c                   |  35 +++++++-----
 include/linux/eventpoll.h        |   8 +++
 include/trace/events/eventpoll.h | 113 +++++++++++++++++++++++++++++++++++++++
 3 files changed, 144 insertions(+), 12 deletions(-)
 create mode 100644 include/trace/events/eventpoll.h

diff --git a/fs/eventpoll.c b/fs/eventpoll.c
index 6a70b7d..cfc4b16 100644
--- a/fs/eventpoll.c
+++ b/fs/eventpoll.c
@@ -41,6 +41,9 @@
 #include <linux/proc_fs.h>
 #include <linux/seq_file.h>
 
+#define CREATE_TRACE_POINTS
+#include <trace/events/eventpoll.h>
+
 /*
  * LOCKING:
  * There are three level of locking required by epoll :
@@ -543,6 +546,14 @@ static int __must_check ep_wake_up_locked(struct eventpoll *ep)
 	return waitqueue_active(&ep->poll_wait);
 }
 
+static void ep_enqueue(struct eventpoll *ep, struct epitem *epi,
+			enum ep_ready_reason reason)
+{
+	trace_ep_ready(ep, epi, reason);
+	list_add_tail(&epi->rdllink, &ep->rdllist);
+	__pm_stay_awake(epi->ws);
+}
+
 /**
  * ep_scan_ready_list - Scans the ready list in a way that makes possible for
  *                      the scan code, to call f_op->poll(). Also allows for
@@ -971,6 +982,7 @@ static int ep_poll_callback(wait_queue_t *wait, unsigned mode, int sync, void *k
 	 */
 	if (unlikely(ep->ovflist != EP_UNACTIVE_PTR)) {
 		if (epi->next == EP_UNACTIVE_PTR) {
+			trace_ep_ovfready(ep, epi);
 			epi->next = ep->ovflist;
 			ep->ovflist = epi;
 			if (epi->ws) {
@@ -986,10 +998,8 @@ static int ep_poll_callback(wait_queue_t *wait, unsigned mode, int sync, void *k
 	}
 
 	/* If this file is already in the ready list we exit soon */
-	if (!ep_is_linked(&epi->rdllink)) {
-		list_add_tail(&epi->rdllink, &ep->rdllist);
-		__pm_stay_awake(epi->ws);
-	}
+	if (!ep_is_linked(&epi->rdllink))
+		ep_enqueue(ep, epi, EPR_POLL_CB);
 
 	/*
 	 * Wake up ( if active ) both the eventpoll wait list and the ->poll()
@@ -1247,8 +1257,7 @@ static int ep_insert(struct eventpoll *ep, struct epoll_event *event,
 
 	/* If the file is already "ready" we drop it inside the ready list */
 	if ((revents & event->events) && !ep_is_linked(&epi->rdllink)) {
-		list_add_tail(&epi->rdllink, &ep->rdllist);
-		__pm_stay_awake(epi->ws);
+		ep_enqueue(ep, epi, EPR_CTL_ADD);
 
 		/* Notify waiting tasks that events are available */
 		pwake = ep_wake_up_locked(ep);
@@ -1354,8 +1363,7 @@ static int ep_modify(struct eventpoll *ep, struct epitem *epi, struct epoll_even
 	if (revents & event->events) {
 		spin_lock_irq(&ep->lock);
 		if (!ep_is_linked(&epi->rdllink)) {
-			list_add_tail(&epi->rdllink, &ep->rdllist);
-			__pm_stay_awake(epi->ws);
+			ep_enqueue(ep, epi, EPR_CTL_MOD);
 
 			/* Notify waiting tasks that events are available */
 			pwake = ep_wake_up_locked(ep);
@@ -1376,6 +1384,7 @@ static int ep_send_events_proc(struct eventpoll *ep, struct list_head *head,
 	struct ep_send_events_data *esed = priv;
 	int eventcnt;
 	unsigned int revents;
+	unsigned int pevents;
 	struct epitem *epi;
 	struct epoll_event __user *uevent;
 	poll_table pt;
@@ -1406,8 +1415,8 @@ static int ep_send_events_proc(struct eventpoll *ep, struct list_head *head,
 		list_del_init(&epi->rdllink);
 
 		pt._key = epi->event.events;
-		revents = epi->ffd.file->f_op->poll(epi->ffd.file, &pt) &
-			epi->event.events;
+		pevents = epi->ffd.file->f_op->poll(epi->ffd.file, &pt);
+		revents = pevents & epi->event.events;
 
 		/*
 		 * If the event mask intersect the caller-requested one,
@@ -1422,6 +1431,7 @@ static int ep_send_events_proc(struct eventpoll *ep, struct list_head *head,
 				__pm_stay_awake(epi->ws);
 				return eventcnt ? eventcnt : -EFAULT;
 			}
+			trace_ep_sent(ep, epi, revents);
 			eventcnt++;
 			uevent++;
 			if (epi->event.events & EPOLLONESHOT)
@@ -1438,9 +1448,10 @@ static int ep_send_events_proc(struct eventpoll *ep, struct list_head *head,
 				 * ep_scan_ready_list() holding "mtx" and the
 				 * poll callback will queue them in ep->ovflist.
 				 */
-				list_add_tail(&epi->rdllink, &ep->rdllist);
-				__pm_stay_awake(epi->ws);
+				ep_enqueue(ep, epi, EPR_LEVEL_TRIGGER);
 			}
+		} else {
+			trace_ep_spurious(ep, epi, epi->event.events, pevents);
 		}
 	}
 
diff --git a/include/linux/eventpoll.h b/include/linux/eventpoll.h
index 6daf6d4..53f3850 100644
--- a/include/linux/eventpoll.h
+++ b/include/linux/eventpoll.h
@@ -22,6 +22,14 @@ struct file;
 
 #ifdef CONFIG_EPOLL
 
+enum ep_ready_reason {
+	EPR_POLL_CB,
+	EPR_OVFLIST, /* corner-case of ER_POLL_CB */
+	EPR_CTL_ADD,
+	EPR_CTL_MOD,
+	EPR_LEVEL_TRIGGER
+};
+
 /* Used to initialize the epoll bits inside the "struct file" */
 static inline void eventpoll_init_file(struct file *file)
 {
diff --git a/include/trace/events/eventpoll.h b/include/trace/events/eventpoll.h
new file mode 100644
index 0000000..d17db05
--- /dev/null
+++ b/include/trace/events/eventpoll.h
@@ -0,0 +1,113 @@
+#undef TRACE_SYSTEM
+#define TRACE_SYSTEM eventpoll
+
+#if !defined(_TRACE_EVENTPOLL_H) || defined(TRACE_HEADER_MULTI_READ)
+#define _TRACE_EVENTPOLL_H
+
+#include <linux/eventpoll.h>
+#include <linux/tracepoint.h>
+
+struct eventpoll;
+struct epitem;
+
+#define READY_REASON						\
+	{EPR_POLL_CB,		"poll_callback"},		\
+	{EPR_OVFLIST,		"ovflist"},			\
+	{EPR_CTL_ADD,		"EPOLL_CTL_ADD"},		\
+	{EPR_CTL_MOD,		"EPOLL_CTL_MOD"},		\
+	{EPR_LEVEL_TRIGGER,	"level_trigger"}
+
+TRACE_EVENT(ep_ready,
+
+	TP_PROTO(struct eventpoll *ep, struct epitem *epi,
+		enum ep_ready_reason reason),
+
+	TP_ARGS(ep, epi, reason),
+
+	TP_STRUCT__entry(
+		__field(	struct eventpoll *,	ep		)
+		__field(	struct epitem *,	epi		)
+		__field(	enum ep_ready_reason,	reason		)
+	),
+
+	TP_fast_assign(
+		__entry->ep	= ep;
+		__entry->epi	= epi;
+		__entry->reason	= reason;
+	),
+
+	TP_printk("%p,%p ep_ready %s", __entry->ep, __entry->epi,
+		__print_symbolic(__entry->reason, READY_REASON))
+);
+
+TRACE_EVENT(ep_ovfready,
+
+	TP_PROTO(struct eventpoll *ep, struct epitem *epi),
+
+	TP_ARGS(ep, epi),
+
+	TP_STRUCT__entry(
+		__field(	struct eventpoll *,	ep		)
+		__field(	struct epitem *,	epi		)
+	),
+
+	TP_fast_assign(
+		__entry->ep	= ep;
+		__entry->epi	= epi;
+	),
+
+	TP_printk("%p,%p ep_ovfready", __entry->ep, __entry->epi)
+);
+
+TRACE_EVENT(ep_sent,
+
+	TP_PROTO(struct eventpoll *ep, struct epitem *epi, unsigned int events),
+
+	TP_ARGS(ep, epi, events),
+
+	TP_STRUCT__entry(
+		__field(	struct eventpoll *,	ep		)
+		__field(	struct epitem *,	epi		)
+		__field(	unsigned int,		events		)
+	),
+
+	TP_fast_assign(
+		__entry->ep		= ep;
+		__entry->epi		= epi;
+		__entry->events		= events;
+	),
+
+	TP_printk("%p,%p ep_sent(events=0x%x)",
+		__entry->ep, __entry->epi, __entry->events)
+);
+
+TRACE_EVENT(ep_spurious,
+
+	TP_PROTO(struct eventpoll *ep, struct epitem *epi,
+		unsigned int events, unsigned int poll_events),
+
+	TP_ARGS(ep, epi, events, poll_events),
+
+	TP_STRUCT__entry(
+		__field(	struct eventpoll *,	ep		)
+		__field(	struct epitem *,	epi		)
+		__field(	unsigned int,		events		)
+		__field(	unsigned int,		poll_events	)
+	),
+
+	TP_fast_assign(
+		__entry->ep		= ep;
+		__entry->epi		= epi;
+		__entry->events		= events;
+		__entry->poll_events	= poll_events;
+	),
+
+	TP_printk("%p,%p ep_spurious events=0x%x,poll_events=0x%x",
+		__entry->ep, __entry->epi,
+		__entry->events, __entry->poll_events)
+);
+
+#endif /* _TRACE_EVENTPOLL_H */
+
+/* This part must be outside protection */
+#include <trace/define_trace.h>
-- 
1.8.1.2.526.gf51a757

