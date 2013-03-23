Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751916Ab3CWTH2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Mar 2013 15:07:28 -0400
Received: from dcvr.yhbt.net ([64.71.152.64]:42423 "EHLO dcvr.yhbt.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751673Ab3CWTH1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Mar 2013 15:07:27 -0400
Date: Sat, 23 Mar 2013 19:07:26 +0000
From: Eric Wong <normalperson@yhbt.net>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Davide Libenzi <davidel@xmailserver.org>, linux-kernel@vger.kernel.org
Subject: [PATCH v2] wfcqueue: functions for local append and enqueue
Message-ID: <20130323190726.GA30029@dcvr.yhbt.net>
References: <20130311213602.GB9829@Krystal>
 <20130321114313.GA17275@dcvr.yhbt.net>
 <20130322020150.GA17809@Krystal>
 <20130322103146.GA9078@dcvr.yhbt.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130322103146.GA9078@dcvr.yhbt.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With level-triggered epoll, append/enqueue operations to the
local/locked queues increase performance by avoiding unnecessary atomic
operations and barriers.  These are necessary to avoid performance
regressions when looping through ep_send_events and appending many
items to a local queue.

Signed-off-by: Eric Wong <normalperson@yhbt.net>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Stephen Hemminger <shemminger@vyatta.com>
Cc: Davide Libenzi <davidel@xmailserver.org>
---
 I noticed the original __wfcq_append function was not in the
 synchronization table, so I left out ___wfcq_append from the table
 as well.

 include/linux/wfcqueue.h | 59 ++++++++++++++++++++++++++++++++++++++++++------
 1 file changed, 52 insertions(+), 7 deletions(-)

diff --git a/include/linux/wfcqueue.h b/include/linux/wfcqueue.h
index 9464a0c..800b1dd 100644
--- a/include/linux/wfcqueue.h
+++ b/include/linux/wfcqueue.h
@@ -55,14 +55,16 @@
  * [4] __wfcq_splice (source queue)
  * [5] __wfcq_first
  * [6] __wfcq_next
+ * [7] __wfcq_enqueue
  *
- *     [1] [2] [3] [4] [5] [6]
- * [1]  -   -   -   -   -   -
- * [2]  -   -   -   -   -   -
- * [3]  -   -   X   X   X   X
- * [4]  -   -   X   -   X   X
- * [5]  -   -   X   X   -   -
- * [6]  -   -   X   X   -   -
+ *     [1] [2] [3] [4] [5] [6] [7]
+ * [1]  -   -   -   -   -   -   X
+ * [2]  -   -   -   -   -   -   X
+ * [3]  -   -   X   X   X   X   X
+ * [4]  -   -   X   -   X   X   X
+ * [5]  -   -   X   X   -   -   X
+ * [6]  -   -   X   X   -   -   X
+ * [7]  X   X   X   X   X   X   X
  *
  * Besides locking, mutual exclusion of dequeue, splice and iteration
  * can be ensured by performing all of those operations from a single
@@ -205,6 +207,49 @@ static inline bool wfcq_enqueue(struct wfcq_head *head,
 }
 
 /*
+ * ___wfcq_append: append one local queue to another local queue
+ *
+ * No memory barriers are issued.  Mutual exclusion is the responsibility
+ * of the caller.
+ *
+ * Returns false if the queue was empty prior to adding the node.
+ * Returns true otherwise.
+ */
+static inline bool ___wfcq_append(struct wfcq_head *head,
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
+ * __wfcq_enqueue: enqueue a node into a local queue
+ *
+ * No memory barriers are issued.  Mutual exclusion is the responsibility
+ * of the caller.
+ *
+ * Returns false if the queue was empty prior to adding the node.
+ * Returns true otherwise.
+ */
+static inline bool __wfcq_enqueue(struct wfcq_head *head,
+		struct wfcq_tail *tail,
+		struct wfcq_node *new_tail)
+{
+	return ___wfcq_append(head, tail, new_tail, new_tail);
+}
+
+/*
  * ___wfcq_busy_wait: busy-wait.
  */
 static inline void ___wfcq_busy_wait(void)
-- 
1.8.2.rc3.2.geae6cf5

