Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933913Ab3DGPNU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Apr 2013 11:13:20 -0400
Received: from mail.openrapids.net ([64.15.138.104]:47329 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S933860Ab3DGPNT convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Apr 2013 11:13:19 -0400
Date: Sun, 7 Apr 2013 11:13:16 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Eric Wong <normalperson@yhbt.net>
Cc: linux-kernel@vger.kernel.org,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [RFC PATCH] wfcqueue: implement __wfcq_enqueue_head() (v3)
Message-ID: <20130407151316.GB10154@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
X-Editor: vi
X-Info: http://www.efficios.com
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Implement enqueue-to-head. It can run concurrently with enqueue, splice
to queue, and iteration, but requires a mutex against dequeue and splice
from queue operations.

Useful for special-cases where a queue needs to have nodes enqueued into
its head.

This patch is only compile-tested.

Changes since v1:
* Don't require mutual exclusion between traversals and
  __wfcq_enqueue_head().

Changes since v2:
* Only issue cmpxchg() if queue was empty.
* Add missing memory barrier.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
---
 include/linux/wfcqueue.h |   76 ++++++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 69 insertions(+), 7 deletions(-)

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
+ * [5]  -   -   X   X   -   -   -
+ * [6]  -   -   X   X   -   -   -
+ * [7]  -   X   X   X   -   -   X
  *
  * Besides locking, mutual exclusion of dequeue, splice and iteration
  * can be ensured by performing all of those operations from a single
@@ -230,6 +232,66 @@ ___wfcq_node_sync_next(struct wfcq_node
 }
 
 /*
+ * __wfcq_enqueue_head: prepend a node into a queue.
+ *
+ * Issues a write memory barrier before enqueue to head. Mutual
+ * exclusion is the responsibility of the caller.
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
+	 * linearisation point of enqueuers.
+	 */
+	if (CMM_LOAD_SHARED(tail->p) != &head->node
+			|| cmpxchg(&tail->p, &head->node, node)
+				!= &head->node) {
+		not_empty = 1;
+
+		/*
+		 * Queue was non-empty. We need to wait for
+		 * head->node.next to become non-NULL, because a
+		 * concurrent wfcq_append may be updating it.
+		 */
+		CMM_STORE_SHARED(node->next,
+			___wfcq_node_sync_next(&head->node));
+	}
+
+	/*
+	 * If cmpxchg succeeds (queue was empty), tail now points to
+	 * node, but head->node.next is still NULL. Concurrent
+	 * traversals seeing this state will busy-wait until we set
+	 * head->node.next.
+	 *
+	 * Else, queue was observed as not empty: traversals will only
+	 * see node after we set head->node.next.
+	 */
+
+	/*
+	 * Orders earlier stores to data structure containing node and
+	 * setting node->next to NULL (or to previous head->node.next
+	 * value) before publication.
+	 */
+	smp_wmb();
+
+	/*
+	 * From this point, we know that wfcq_append cannot touch
+	 * head->node.next, either because we successfully moved tail->p
+	 * to node, or because we waited for head->node.next to become
+	 * non-NULL. It is therefore safe to update it.
+	 */
+	CMM_STORE_SHARED(head->node.next, node);
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
