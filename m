Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932878Ab3CULnP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 07:43:15 -0400
Received: from dcvr.yhbt.net ([64.71.152.64]:52828 "EHLO dcvr.yhbt.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757636Ab3CULnN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 07:43:13 -0400
Date: Thu, 21 Mar 2013 11:43:13 +0000
From: Eric Wong <normalperson@yhbt.net>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Davide Libenzi <davidel@xmailserver.org>, linux-kernel@vger.kernel.org
Subject: [PATCH] wfcqueue: functions for local append and enqueue
Message-ID: <20130321114313.GA17275@dcvr.yhbt.net>
References: <20130311213602.GB9829@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130311213602.GB9829@Krystal>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With level-triggered epoll, append/enqueue operations to the
local/locked queues increase performance by avoiding unnecessary atomic
operations and barriers.  These are necessary to avoid performance
regressions when looping through ep_send_events and appending many
items to a queue.

Signed-off-by: Eric Wong <normalperson@yhbt.net>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Stephen Hemminger <shemminger@vyatta.com>
Cc: Davide Libenzi <davidel@xmailserver.org>
---
  Benchmark for this coming with updated epoll patches.

 include/linux/wfcqueue.h | 43 +++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 43 insertions(+)

diff --git a/include/linux/wfcqueue.h b/include/linux/wfcqueue.h
index 9464a0c..7eb2aaa 100644
--- a/include/linux/wfcqueue.h
+++ b/include/linux/wfcqueue.h
@@ -205,6 +205,49 @@ static inline bool wfcq_enqueue(struct wfcq_head *head,
 }
 
 /*
+ * __wfcq_append_local: append one local queue to another local queue
+ *
+ * No memory barriers are issued.  Mutual exclusion is the responsibility
+ * of the caller.
+ *
+ * Returns false if the queue was empty prior to adding the node.
+ * Returns true otherwise.
+ */
+static inline bool __wfcq_append_local(struct wfcq_head *head,
+		struct wfcq_tail *tail,
+		struct wfcq_node *new_head,
+		struct wfcq_node *new_tail)
+{
+	struct wfcq_node *old_tail;
+
+	old_tail = tail->p;
+	tail->p = new_tail;
+	old_tail->next = new_head;
+
+	/*
+	 * Return false if queue was empty prior to adding the node,
+	 * else return true.
+	 */
+	return old_tail != &head->node;
+}
+
+/*
+ * wfcq_enqueue_local: enqueue a node into a local wait-free queue
+ *
+ * No memory barriers are issued.  Mutual exclusion is the responsibility
+ * of the caller.
+ *
+ * Returns false if the queue was empty prior to adding the node.
+ * Returns true otherwise.
+ */
+static inline bool wfcq_enqueue_local(struct wfcq_head *head,
+		struct wfcq_tail *tail,
+		struct wfcq_node *new_tail)
+{
+	return __wfcq_append_local(head, tail, new_tail, new_tail);
+}
+
+/*
  * ___wfcq_busy_wait: busy-wait.
  */
 static inline void ___wfcq_busy_wait(void)
-- 
1.8.2.rc3.2.g89ce8d6

