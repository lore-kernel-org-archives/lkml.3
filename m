Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932933Ab3DFVmg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Apr 2013 17:42:36 -0400
Received: from mail.openrapids.net ([64.15.138.104]:41446 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932735Ab3DFVmf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Apr 2013 17:42:35 -0400
Date: Sat, 6 Apr 2013 17:42:33 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Eric Wong <normalperson@yhbt.net>
Cc: linux-kernel@vger.kernel.org,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [RFC PATCH] wfcqueue: implement __wfcq_enqueue_head()
Message-ID: <20130406214233.GA3631@Krystal>
References: <20130311213602.GB9829@Krystal> <20130329081016.GA15979@dcvr.yhbt.net> <20130402130541.GC11621@Krystal> <20130402211527.GA17261@dcvr.yhbt.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130402211527.GA17261@dcvr.yhbt.net>
X-Editor: vi
X-Info: http://www.efficios.com
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Implement enqueue-to-head. It can run concurrently with enqueue and
splice to queue, but requires a mutex against all other queue
operations.

Useful for special-cases where a queue needs to have nodes enqueued into
its head.

This patch is only compile-tested.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
---
 include/linux/wfcqueue.h |   54 ++++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 47 insertions(+), 7 deletions(-)

Index: linux/include/linux/wfcqueue.h
===================================================================
--- linux.orig/include/linux/wfcqueue.h
+++ linux/include/linux/wfcqueue.h
@@ -55,14 +55,16 @@
  * [4] __wfcq_splice (source queue)
  * [5] __wfcq_first
  * [6] __wfcq_next
+ * [7] __wfcq_enqueue_head
  *
- *     [1] [2] [3] [4] [5] [6]
- * [1]  -   -   -   -   -   -
- * [2]  -   -   -   -   -   -
- * [3]  -   -   X   X   X   X
- * [4]  -   -   X   -   X   X
- * [5]  -   -   X   X   -   -
- * [6]  -   -   X   X   -   -
+ *     [1] [2] [3] [4] [5] [6] [7]
+ * [1]  -   -   -   -   -   -   -
+ * [2]  -   -   -   -   -   -   X
+ * [3]  -   -   X   X   X   X   X
+ * [4]  -   -   X   -   X   X   X
+ * [5]  -   -   X   X   -   -   X
+ * [6]  -   -   X   X   -   -   X
+ * [7]  -   X   X   X   X   X   X
  *
  * Besides locking, mutual exclusion of dequeue, splice and iteration
  * can be ensured by performing all of those operations from a single
@@ -230,6 +232,44 @@ ___wfcq_node_sync_next(struct wfcq_node
 }
 
 /*
+ * __wfcq_enqueue_head: prepend a node into a queue.
+ *
+ * No memory barriers are issued. Mutual exclusion is the responsibility
+ * of the caller.
+ *
+ * Returns false if the queue was empty prior to adding the node.
+ * Returns true otherwise.
+ */
+static inline bool __wfcq_enqueue_head(struct wfcq_head *head,
+		struct wfcq_tail *tail,
+		struct wfcq_node *node)
+{
+	bool not_empty = 0;
+
+        /*
+	 * Move tail if queue was empty. Tail pointer is the
+	 * linearization point of enqueuers.
+	 */
+	if (cmpxchg(&tail->p, &head->node, node) != &head->node) {
+		not_empty = 1;
+		/*
+		 * Queue was non-empty. We need to wait for
+		 * head->node.next to become non-NULL, because a
+		 * concurrent wfcq_append may be updating it.
+		 */
+		node->next = ___wfcq_node_sync_next(&head->node);
+	}
+	/*
+	 * From this point, we know that wfcq_append cannot touch
+	 * head->node.next, either because we successfully moved tail->p
+	 * to node, or because we waited for head->node.next to become
+	 * non-NULL. It is therefore safe to update it.
+	 */
+	head->node.next = node;
+	return not_empty;
+}
+
+/*
  * __wfcq_first: get first node of a queue, without dequeuing.
  *
  * Content written into the node before enqueue is guaranteed to be


-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
