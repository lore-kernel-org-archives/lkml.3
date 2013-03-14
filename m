Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933279Ab3CNNTP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 09:19:15 -0400
Received: from mail.openrapids.net ([64.15.138.104]:47501 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932738Ab3CNNTM convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 09:19:12 -0400
Date: Thu, 14 Mar 2013 09:19:06 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Eric Wong <normalperson@yhbt.net>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Davide Libenzi <davidel@xmailserver.org>, linux-kernel@vger.kernel.org
Subject: [RFC PATCH] Linux kernel Wait-Free Concurrent Queue Implementation
	(v2)
Message-ID: <20130314131906.GA9333@Krystal>
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

Ported to the Linux kernel from Userspace RCU library, at commit
108a92e5b97ee91b2b902dba2dd2e78aab42f420.

Ref: http://git.lttng.org/userspace-rcu.git

It is provided as a starting point only. Test cases should be ported
from Userspace RCU to kernel space and thoroughly ran on a wide range of
architectures before considering this port production-ready.

Changelog since v1:
- Remove the internal mutex and helpers. Let the caller handle it.
- Disable preemption within append operation, thus removing sleep from
  dequeue, therefore removing the blocking/nonblocking API distinction.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
CC: Lai Jiangshan <laijs@cn.fujitsu.com>
CC: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
CC: Stephen Hemminger <shemminger@vyatta.com>
CC: Davide Libenzi <davidel@xmailserver.org>
CC: Eric Wong <normalperson@yhbt.net>
---
 include/linux/wfcqueue.h |  444 +++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 444 insertions(+)

Index: linux/include/linux/wfcqueue.h
===================================================================
--- /dev/null
+++ linux/include/linux/wfcqueue.h
@@ -0,0 +1,444 @@
+#ifndef _LINUX_WFCQUEUE_H
+#define _LINUX_WFCQUEUE_H
+
+/*
+ * linux/wfcqueue.h
+ *
+ * Concurrent Queue with Wait-Free Enqueue/Busy-Waiting Dequeue
+ *
+ * Copyright 2010-2013 - Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
+ * Copyright 2011-2012 - Lai Jiangshan <laijs@cn.fujitsu.com>
+ *
+ * This library is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU Lesser General Public
+ * License as published by the Free Software Foundation; either
+ * version 2.1 of the License, or (at your option) any later version.
+ *
+ * This library is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * Lesser General Public License for more details.
+ *
+ * You should have received a copy of the GNU Lesser General Public
+ * License along with this library; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA
+ */
+
+#include <linux/bug.h>
+#include <linux/types.h>
+#include <linux/compiler.h>
+#include <linux/preempt.h>
+#include <asm/cmpxchg.h>
+#include <asm/processor.h>
+#include <asm/barrier.h>
+
+/*
+ * Concurrent Queue with Wait-Free Enqueue/Busy-Waiting Dequeue
+ *
+ * This queue has been designed and implemented collaboratively by
+ * Mathieu Desnoyers and Lai Jiangshan. Inspired from
+ * half-wait-free/half-blocking queue implementation done by Paul E.
+ * McKenney.
+ *
+ * Mutual exclusion of wfcq_* / __wfcq_* API
+ *
+ * Synchronization table:
+ *
+ * External synchronization techniques described in the API below is
+ * required between pairs marked with "X". No external synchronization
+ * required between pairs marked with "-".
+ *
+ * Legend:
+ * [1] wfcq_enqueue
+ * [2] __wfcq_splice (destination queue)
+ * [3] __wfcq_dequeue
+ * [4] __wfcq_splice (source queue)
+ * [5] __wfcq_first
+ * [6] __wfcq_next
+ *
+ *     [1] [2] [3] [4] [5] [6]
+ * [1]  -   -   -   -   -   -
+ * [2]  -   -   -   -   -   -
+ * [3]  -   -   X   X   X   X
+ * [4]  -   -   X   -   X   X
+ * [5]  -   -   X   X   -   -
+ * [6]  -   -   X   X   -   -
+ *
+ * Besides locking, mutual exclusion of dequeue, splice and iteration
+ * can be ensured by performing all of those operations from a single
+ * thread, without requiring any lock.
+ */
+
+/*
+ * Load a data from shared memory.
+ */
+#define CMM_LOAD_SHARED(p)		ACCESS_ONCE(p)
+
+/*
+ * Identify a shared store.
+ */
+#define CMM_STORE_SHARED(x, v)		({ ACCESS_ONCE(x) = (v); })
+
+enum wfcq_ret {
+	WFCQ_RET_DEST_EMPTY =	0,
+	WFCQ_RET_DEST_NON_EMPTY =	1,
+	WFCQ_RET_SRC_EMPTY = 	2,
+};
+
+struct wfcq_node {
+	struct wfcq_node *next;
+};
+
+/*
+ * Do not put head and tail on the same cache-line if concurrent
+ * enqueue/dequeue are expected from many CPUs. This eliminates
+ * false-sharing between enqueue and dequeue.
+ */
+struct wfcq_head {
+	struct wfcq_node node;
+};
+
+struct wfcq_tail {
+	struct wfcq_node *p;
+};
+
+/*
+ * wfcq_node_init: initialize wait-free queue node.
+ */
+static inline void wfcq_node_init(struct wfcq_node *node)
+{
+	node->next = NULL;
+}
+
+/*
+ * wfcq_init: initialize wait-free queue.
+ */
+static inline void wfcq_init(struct wfcq_head *head,
+		struct wfcq_tail *tail)
+{
+	/* Set queue head and tail */
+	wfcq_node_init(&head->node);
+	tail->p = &head->node;
+}
+
+/*
+ * wfcq_empty: return whether wait-free queue is empty.
+ *
+ * No memory barrier is issued. No mutual exclusion is required.
+ *
+ * We perform the test on head->node.next to check if the queue is
+ * possibly empty, but we confirm this by checking if the tail pointer
+ * points to the head node because the tail pointer is the linearisation
+ * point of the enqueuers. Just checking the head next pointer could
+ * make a queue appear empty if an enqueuer is preempted for a long time
+ * between xchg() and setting the previous node's next pointer.
+ */
+static inline bool wfcq_empty(struct wfcq_head *head,
+		struct wfcq_tail *tail)
+{
+	/*
+	 * Queue is empty if no node is pointed by head->node.next nor
+	 * tail->p. Even though the tail->p check is sufficient to find
+	 * out of the queue is empty, we first check head->node.next as a
+	 * common case to ensure that dequeuers do not frequently access
+	 * enqueuer's tail->p cache line.
+	 */
+	return CMM_LOAD_SHARED(head->node.next) == NULL
+		&& CMM_LOAD_SHARED(tail->p) == &head->node;
+}
+
+static inline bool __wfcq_append(struct wfcq_head *head,
+		struct wfcq_tail *tail,
+		struct wfcq_node *new_head,
+		struct wfcq_node *new_tail)
+{
+	struct wfcq_node *old_tail;
+
+	/*
+	 * Disable preemption around append, so busy-waiting can assume
+	 * enqueue is never preempted when intermediate enqueue state is
+	 * encountered.
+	 */
+	preempt_disable();
+
+	/*
+	 * Implicit memory barrier before xchg() orders earlier
+	 * stores to data structure containing node and setting
+	 * node->next to NULL before publication.
+	 */
+	old_tail = xchg(&tail->p, new_tail);
+
+	/*
+	 * Implicit memory barrier after xchg() orders store to
+	 * q->tail before store to old_tail->next.
+	 *
+	 * At this point, dequeuers see a NULL tail->p->next, which
+	 * indicates that the queue is being appended to. The following
+	 * store will append "node" to the queue from a dequeuer
+	 * perspective.
+	 */
+	CMM_STORE_SHARED(old_tail->next, new_head);
+
+	preempt_enable();
+
+	/*
+	 * Return false if queue was empty prior to adding the node,
+	 * else return true.
+	 */
+	return old_tail != &head->node;
+}
+
+/*
+ * wfcq_enqueue: enqueue a node into a wait-free queue.
+ *
+ * Issues a full memory barrier before enqueue. No mutual exclusion is
+ * required.
+ *
+ * Returns false if the queue was empty prior to adding the node.
+ * Returns true otherwise.
+ */
+static inline bool wfcq_enqueue(struct wfcq_head *head,
+		struct wfcq_tail *tail,
+		struct wfcq_node *new_tail)
+{
+	return __wfcq_append(head, tail, new_tail, new_tail);
+}
+
+/*
+ * ___wfcq_busy_wait: busy-wait.
+ */
+static inline void ___wfcq_busy_wait(void)
+{
+	cpu_relax();
+}
+
+/*
+ * Waiting for enqueuer to complete enqueue and return the next node.
+ */
+static inline struct wfcq_node *
+___wfcq_node_sync_next(struct wfcq_node *node)
+{
+	struct wfcq_node *next;
+
+	/*
+	 * Busy-looping waiting for enqueuer to complete enqueue.
+	 */
+	while ((next = CMM_LOAD_SHARED(node->next)) == NULL)
+		___wfcq_busy_wait();
+
+	return next;
+}
+
+/*
+ * __wfcq_first: get first node of a queue, without dequeuing.
+ *
+ * Content written into the node before enqueue is guaranteed to be
+ * consistent, but no other memory ordering is ensured.
+ * Dequeue/splice/iteration mutual exclusion should be ensured by the
+ * caller.
+ *
+ * Used by for-like iteration macros in linux/wfcqueue.h:
+ * __wfcq_for_each()
+ * __wfcq_for_each_safe()
+ *
+ * Returns NULL if queue is empty, first node otherwise.
+ */
+
+static inline struct wfcq_node *
+__wfcq_first(struct wfcq_head *head, struct wfcq_tail *tail)
+{
+	struct wfcq_node *node;
+
+	if (wfcq_empty(head, tail))
+		return NULL;
+	node = ___wfcq_node_sync_next(&head->node);
+	/* Load head->node.next before loading node's content */
+	smp_read_barrier_depends();
+	return node;
+}
+
+/*
+ * __wfcq_next: get next node of a queue, without dequeuing.
+ *
+ * Content written into the node before enqueue is guaranteed to be
+ * consistent, but no other memory ordering is ensured.
+ * Dequeue/splice/iteration mutual exclusion should be ensured by the
+ * caller.
+ *
+ * Used by for-like iteration macros in linux/wfcqueue.h:
+ * __wfcq_for_each()
+ * __wfcq_for_each_safe()
+ *
+ * Returns NULL if reached end of queue, non-NULL next queue node
+ * otherwise.
+ */
+static inline struct wfcq_node *
+__wfcq_next(struct wfcq_head *head,
+		struct wfcq_tail *tail,
+		struct wfcq_node *node)
+{
+	struct wfcq_node *next;
+
+	/*
+	 * Even though the following tail->p check is sufficient to find
+	 * out if we reached the end of the queue, we first check
+	 * node->next as a common case to ensure that iteration on nodes
+	 * do not frequently access enqueuer's tail->p cache line.
+	 */
+	if ((next = CMM_LOAD_SHARED(node->next)) == NULL) {
+		/* Load node->next before tail->p */
+		smp_rmb();
+		if (CMM_LOAD_SHARED(tail->p) == node)
+			return NULL;
+		next = ___wfcq_node_sync_next(node);
+	}
+	/* Load node->next before loading next's content */
+	smp_read_barrier_depends();
+	return next;
+}
+
+/*
+ * __wfcq_dequeue: dequeue a node from the queue.
+ *
+ * Content written into the node before enqueue is guaranteed to be
+ * consistent, but no other memory ordering is ensured.
+ * It is valid to reuse and free a dequeued node immediately.
+ * Dequeue/splice/iteration mutual exclusion should be ensured by the
+ * caller.
+ */
+static inline struct wfcq_node *
+__wfcq_dequeue(struct wfcq_head *head, struct wfcq_tail *tail)
+{
+	struct wfcq_node *node, *next;
+
+	if (wfcq_empty(head, tail))
+		return NULL;
+
+	node = ___wfcq_node_sync_next(&head->node);
+
+	if ((next = CMM_LOAD_SHARED(node->next)) == NULL) {
+		/*
+		 * @node is probably the only node in the queue.
+		 * Try to move the tail to &q->head.
+		 * q->head.next is set to NULL here, and stays
+		 * NULL if the cmpxchg succeeds. Should the
+		 * cmpxchg fail due to a concurrent enqueue, the
+		 * q->head.next will be set to the next node.
+		 * The implicit memory barrier before
+		 * cmpxchg() orders load node->next
+		 * before loading q->tail.
+		 * The implicit memory barrier before cmpxchg
+		 * orders load q->head.next before loading node's
+		 * content.
+		 */
+		wfcq_node_init(&head->node);
+		if (cmpxchg(&tail->p, node, &head->node) == node)
+			return node;
+		next = ___wfcq_node_sync_next(node);
+	}
+
+	/*
+	 * Move queue head forward.
+	 */
+	head->node.next = next;
+
+	/* Load q->head.next before loading node's content */
+	smp_read_barrier_depends();
+	return node;
+}
+
+/*
+ * __wfcq_splice: enqueue all src_q nodes at the end of dest_q.
+ *
+ * Dequeue all nodes from src_q.
+ * dest_q must be already initialized.
+ * Mutual exclusion for src_q should be ensured by the caller as
+ * specified in the "Synchronisation table".
+ * Returns enum wfcq_ret which indicates the state of the src or
+ * dest queue.
+ */
+static inline enum wfcq_ret __wfcq_splice(
+		struct wfcq_head *dest_q_head,
+		struct wfcq_tail *dest_q_tail,
+		struct wfcq_head *src_q_head,
+		struct wfcq_tail *src_q_tail)
+{
+	struct wfcq_node *head, *tail;
+
+	/*
+	 * Initial emptiness check to speed up cases where queue is
+	 * empty: only require loads to check if queue is empty.
+	 */
+	if (wfcq_empty(src_q_head, src_q_tail))
+		return WFCQ_RET_SRC_EMPTY;
+
+	for (;;) {
+		/*
+		 * Open-coded _wfcq_empty() by testing result of
+		 * xchg, as well as tail pointer vs head node
+		 * address.
+		 */
+		head = xchg(&src_q_head->node.next, NULL);
+		if (head)
+			break;	/* non-empty */
+		if (CMM_LOAD_SHARED(src_q_tail->p) == &src_q_head->node)
+			return WFCQ_RET_SRC_EMPTY;
+		___wfcq_busy_wait();
+	}
+
+	/*
+	 * Memory barrier implied before xchg() orders store to
+	 * src_q->head before store to src_q->tail. This is required by
+	 * concurrent enqueue on src_q, which exchanges the tail before
+	 * updating the previous tail's next pointer.
+	 */
+	tail = xchg(&src_q_tail->p, &src_q_head->node);
+
+	/*
+	 * Append the spliced content of src_q into dest_q. Does not
+	 * require mutual exclusion on dest_q (wait-free).
+	 */
+	if (__wfcq_append(dest_q_head, dest_q_tail, head, tail))
+		return WFCQ_RET_DEST_NON_EMPTY;
+	else
+		return WFCQ_RET_DEST_EMPTY;
+}
+
+/*
+ * __wfcq_for_each: Iterate over all nodes in a queue,
+ * without dequeuing them.
+ * @head: head of the queue (struct wfcq_head pointer).
+ * @tail: tail of the queue (struct wfcq_tail pointer).
+ * @node: iterator on the queue (struct wfcq_node pointer).
+ *
+ * Content written into each node before enqueue is guaranteed to be
+ * consistent, but no other memory ordering is ensured.
+ * Dequeue/splice/iteration mutual exclusion should be ensured by the
+ * caller.
+ */
+#define __wfcq_for_each(head, tail, node)			\
+	for (node = __wfcq_first(head, tail);			\
+		node != NULL;					\
+		node = __wfcq_next(head, tail, node))
+
+/*
+ * __wfcq_for_each_safe: Iterate over all nodes in a queue,
+ * without dequeuing them. Safe against deletion.
+ * @head: head of the queue (struct wfcq_head pointer).
+ * @tail: tail of the queue (struct wfcq_tail pointer).
+ * @node: iterator on the queue (struct wfcq_node pointer).
+ * @n: struct wfcq_node pointer holding the next pointer (used
+ *     internally).
+ *
+ * Content written into each node before enqueue is guaranteed to be
+ * consistent, but no other memory ordering is ensured.
+ * Dequeue/splice/iteration mutual exclusion should be ensured by the
+ * caller.
+ */
+#define __wfcq_for_each_safe(head, tail, node, n)		       \
+	for (node = __wfcq_first(head, tail),			       \
+			n = (node ? __wfcq_next(head, tail, node) : NULL); \
+		node != NULL;					       \
+		node = n, n = (node ? __wfcq_next(head, tail, node) : NULL))
+
+#endif /* _LINUX_WFCQUEUE_H */

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
