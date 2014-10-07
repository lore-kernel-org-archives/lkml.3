Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932390AbaJGXUS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 19:20:18 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:39724 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932196AbaJGXUD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 19:20:03 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Dan Streetman <ddstreet@ieee.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <peterz@infradead.org>, Mel Gorman <mgorman@suse.de>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Thomas Gleixner <tglx@linutronix.de>, Shaohua Li <shli@fusionio.com>,
        Hugh Dickins <hughd@google.com>, Michal Hocko <mhocko@suse.cz>,
        Christian Ehrhardt <ehrhardt@linux.vnet.ibm.com>,
        Weijie Yang <weijieut@gmail.com>, Rik van Riel <riel@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Bob Liu <bob.liu@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 3.14 19/37] lib/plist: add plist_requeue
Date: Tue,  7 Oct 2014 16:19:36 -0700
Message-Id: <20141007231827.653691389@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141007231827.043235686@linuxfoundation.org>
References: <20141007231827.043235686@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Streetman <ddstreet@ieee.org>

commit a75f232ce0fe38bd01301899ecd97ffd0254316a upstream.

Add plist_requeue(), which moves the specified plist_node after all other
same-priority plist_nodes in the list.  This is essentially an optimized
plist_del() followed by plist_add().

This is needed by swap, which (with the next patch in this set) uses a
plist of available swap devices.  When a swap device (either a swap
partition or swap file) are added to the system with swapon(), the device
is added to a plist, ordered by the swap device's priority.  When swap
needs to allocate a page from one of the swap devices, it takes the page
from the first swap device on the plist, which is the highest priority
swap device.  The swap device is left in the plist until all its pages are
used, and then removed from the plist when it becomes full.

However, as described in man 2 swapon, swap must allocate pages from swap
devices with the same priority in round-robin order; to do this, on each
swap page allocation, swap uses a page from the first swap device in the
plist, and then calls plist_requeue() to move that swap device entry to
after any other same-priority swap devices.  The next swap page allocation
will again use a page from the first swap device in the plist and requeue
it, and so on, resulting in round-robin usage of equal-priority swap
devices.

Also add plist_test_requeue() test function, for use by plist_test() to
test plist_requeue() function.

Signed-off-by: Dan Streetman <ddstreet@ieee.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Acked-by: Mel Gorman <mgorman@suse.de>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Shaohua Li <shli@fusionio.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Dan Streetman <ddstreet@ieee.org>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Christian Ehrhardt <ehrhardt@linux.vnet.ibm.com>
Cc: Weijie Yang <weijieut@gmail.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Bob Liu <bob.liu@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Mel Gorman <mgorman@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/linux/plist.h |    2 +
 lib/plist.c           |   52 ++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 54 insertions(+)

--- a/include/linux/plist.h
+++ b/include/linux/plist.h
@@ -141,6 +141,8 @@ static inline void plist_node_init(struc
 extern void plist_add(struct plist_node *node, struct plist_head *head);
 extern void plist_del(struct plist_node *node, struct plist_head *head);
 
+extern void plist_requeue(struct plist_node *node, struct plist_head *head);
+
 /**
  * plist_for_each - iterate over the plist
  * @pos:	the type * to use as a loop counter
--- a/lib/plist.c
+++ b/lib/plist.c
@@ -134,6 +134,46 @@ void plist_del(struct plist_node *node,
 	plist_check_head(head);
 }
 
+/**
+ * plist_requeue - Requeue @node at end of same-prio entries.
+ *
+ * This is essentially an optimized plist_del() followed by
+ * plist_add().  It moves an entry already in the plist to
+ * after any other same-priority entries.
+ *
+ * @node:	&struct plist_node pointer - entry to be moved
+ * @head:	&struct plist_head pointer - list head
+ */
+void plist_requeue(struct plist_node *node, struct plist_head *head)
+{
+	struct plist_node *iter;
+	struct list_head *node_next = &head->node_list;
+
+	plist_check_head(head);
+	BUG_ON(plist_head_empty(head));
+	BUG_ON(plist_node_empty(node));
+
+	if (node == plist_last(head))
+		return;
+
+	iter = plist_next(node);
+
+	if (node->prio != iter->prio)
+		return;
+
+	plist_del(node, head);
+
+	plist_for_each_continue(iter, head) {
+		if (node->prio != iter->prio) {
+			node_next = &iter->node_list;
+			break;
+		}
+	}
+	list_add_tail(&node->node_list, node_next);
+
+	plist_check_head(head);
+}
+
 #ifdef CONFIG_DEBUG_PI_LIST
 #include <linux/sched.h>
 #include <linux/module.h>
@@ -170,6 +210,14 @@ static void __init plist_test_check(int
 	BUG_ON(prio_pos->prio_list.next != &first->prio_list);
 }
 
+static void __init plist_test_requeue(struct plist_node *node)
+{
+	plist_requeue(node, &test_head);
+
+	if (node != plist_last(&test_head))
+		BUG_ON(node->prio == plist_next(node)->prio);
+}
+
 static int  __init plist_test(void)
 {
 	int nr_expect = 0, i, loop;
@@ -193,6 +241,10 @@ static int  __init plist_test(void)
 			nr_expect--;
 		}
 		plist_test_check(nr_expect);
+		if (!plist_node_empty(test_node + i)) {
+			plist_test_requeue(test_node + i);
+			plist_test_check(nr_expect);
+		}
 	}
 
 	for (i = 0; i < ARRAY_SIZE(test_node); i++) {


