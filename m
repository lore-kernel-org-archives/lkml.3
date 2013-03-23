Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752071Ab3CWUmi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Mar 2013 16:42:38 -0400
Received: from dcvr.yhbt.net ([64.71.152.64]:42836 "EHLO dcvr.yhbt.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751899Ab3CWUmh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Mar 2013 16:42:37 -0400
Date: Sat, 23 Mar 2013 20:42:37 +0000
From: Eric Wong <normalperson@yhbt.net>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Davide Libenzi <davidel@xmailserver.org>, linux-kernel@vger.kernel.org
Subject: [PATCH v3] wfcqueue: functions for local append and enqueue
Message-ID: <20130323204237.GA27622@dcvr.yhbt.net>
References: <20130311213602.GB9829@Krystal>
 <20130321114313.GA17275@dcvr.yhbt.net>
 <20130322020150.GA17809@Krystal>
 <20130322103146.GA9078@dcvr.yhbt.net>
 <20130323190726.GA30029@dcvr.yhbt.net>
 <20130323194309.GA32464@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130323194309.GA32464@Krystal>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mathieu Desnoyers <mathieu.desnoyers@efficios.com> wrote:
> * Eric Wong (normalperson@yhbt.net) wrote:
> >  /*
> > + * ___wfcq_append: append one local queue to another local queue
> > + *

> __wfcq_append() and ___wfcq_append() are meant to be private to
> wfcqueue.h. Therefore, the comment above should be removed, since it is
> not part of the API.
> 
> I notice that I should have used ___wfcq_append() for the original
> append function for consistency (other private helpers in this header
> are prefixed with ___).
> 
> So maybe we should rename __wfcq_append to ___wfcq_append (making it
> clear that it is a private helper), and introduce your helper as
> ___wfcq_append_local() (I don't care about having "local" in there since
> it is not part of the exposed API).

Thanks for the explanation, I've squashed that renames into my patch
below and removed the comment.

> > +/*
> > + * __wfcq_enqueue: enqueue a node into a local queue
> 
> The concept of "local queue" is not clearly defined.
> 
> Perhaps it would be clearer to state:
> 
>  * __wfcq_enqueue: enqueue a node into a queue, requiring mutual exclusion.

Sounds good to me.  Updated patch below:

-------------------------------8<-----------------------------
From: Eric Wong <normalperson@yhbt.net>
Date: Sat, 23 Mar 2013 19:07:26 +0000
Subject: [PATCH] wfcqueue: functions for local append and enqueue

With level-triggered epoll, append/enqueue operations to the
local/locked queues increase performance by avoiding unnecessary atomic
operations and barriers.  These are necessary to avoid performance
regressions when looping through ep_send_events and appending many items
to a local queue where the caller already manages mutual exclusion.

Changes since v1 and v2:
* Function renaming and documentation updates
* rename the existing private __wfcq_append to ___wfcq_append

Signed-off-by: Eric Wong <normalperson@yhbt.net>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Stephen Hemminger <shemminger@vyatta.com>
Cc: Davide Libenzi <davidel@xmailserver.org>
---
 include/linux/wfcqueue.h | 56 +++++++++++++++++++++++++++++++++++++++---------
 1 file changed, 46 insertions(+), 10 deletions(-)

diff --git a/include/linux/wfcqueue.h b/include/linux/wfcqueue.h
index 9464a0c..a452ab9 100644
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
@@ -147,7 +149,7 @@ static inline bool wfcq_empty(struct wfcq_head *head,
 		&& CMM_LOAD_SHARED(tail->p) == &head->node;
 }
 
-static inline bool __wfcq_append(struct wfcq_head *head,
+static inline bool ___wfcq_append(struct wfcq_head *head,
 		struct wfcq_tail *tail,
 		struct wfcq_node *new_head,
 		struct wfcq_node *new_tail)
@@ -201,7 +203,41 @@ static inline bool wfcq_enqueue(struct wfcq_head *head,
 		struct wfcq_tail *tail,
 		struct wfcq_node *new_tail)
 {
-	return __wfcq_append(head, tail, new_tail, new_tail);
+	return ___wfcq_append(head, tail, new_tail, new_tail);
+}
+
+static inline bool ___wfcq_append_local(struct wfcq_head *head,
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
+ * __wfcq_enqueue: enqueue a node into a queue, requiring mutual exclusion.
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
+	return ___wfcq_append_local(head, tail, new_tail, new_tail);
 }
 
 /*
@@ -398,7 +434,7 @@ static inline enum wfcq_ret __wfcq_splice(
 	 * Append the spliced content of src_q into dest_q. Does not
 	 * require mutual exclusion on dest_q (wait-free).
 	 */
-	if (__wfcq_append(dest_q_head, dest_q_tail, head, tail))
+	if (___wfcq_append(dest_q_head, dest_q_tail, head, tail))
 		return WFCQ_RET_DEST_NON_EMPTY;
 	else
 		return WFCQ_RET_DEST_EMPTY;
-- 
1.8.2.rc3.2.geae6cf5

