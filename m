Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752766AbaH1SgU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 14:36:20 -0400
Received: from cantor2.suse.de ([195.135.220.15]:32838 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752226AbaH1Sf5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 14:35:57 -0400
From: Mel Gorman <mgorman@suse.de>
To: Jiri Slaby <jslaby@suse.cz>
Cc: Linux-Stable <stable@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Mel Gorman <mgorman@suse.de>
Subject: [PATCH 10/97] lib/plist: add helper functions
Date: Thu, 28 Aug 2014 19:34:18 +0100
Message-Id: <1409250945-30874-11-git-send-email-mgorman@suse.de>
X-Mailer: git-send-email 1.8.4.5
In-Reply-To: <1409250945-30874-1-git-send-email-mgorman@suse.de>
References: <1409250945-30874-1-git-send-email-mgorman@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dan Streetman <ddstreet@ieee.org>

commit fd16618e12a05df79a3439d72d5ffdac5d34f3da upstream.

Add PLIST_HEAD() to plist.h, equivalent to LIST_HEAD() from list.h, to
define and initialize a struct plist_head.

Add plist_for_each_continue() and plist_for_each_entry_continue(),
equivalent to list_for_each_continue() and list_for_each_entry_continue(),
to iterate over a plist continuing after the current position.

Add plist_prev() and plist_next(), equivalent to (struct list_head*)->prev
and ->next, implemented by list_prev_entry() and list_next_entry(), to
access the prev/next struct plist_node entry.  These are needed because
unlike struct list_head, direct access of the prev/next struct plist_node
isn't possible; the list must be navigated via the contained struct
list_head.  e.g.  instead of accessing the prev by list_prev_entry(node,
node_list) it can be accessed by plist_prev(node).

Signed-off-by: Dan Streetman <ddstreet@ieee.org>
Acked-by: Mel Gorman <mgorman@suse.de>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
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
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Mel Gorman <mgorman@suse.de>
---
 include/linux/plist.h | 43 +++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 43 insertions(+)

diff --git a/include/linux/plist.h b/include/linux/plist.h
index aa0fb39..c815491 100644
--- a/include/linux/plist.h
+++ b/include/linux/plist.h
@@ -98,6 +98,13 @@ struct plist_node {
 }
 
 /**
+ * PLIST_HEAD - declare and init plist_head
+ * @head:	name for struct plist_head variable
+ */
+#define PLIST_HEAD(head) \
+	struct plist_head head = PLIST_HEAD_INIT(head)
+
+/**
  * PLIST_NODE_INIT - static struct plist_node initializer
  * @node:	struct plist_node variable name
  * @__prio:	initial node priority
@@ -143,6 +150,16 @@ extern void plist_del(struct plist_node *node, struct plist_head *head);
 	 list_for_each_entry(pos, &(head)->node_list, node_list)
 
 /**
+ * plist_for_each_continue - continue iteration over the plist
+ * @pos:	the type * to use as a loop cursor
+ * @head:	the head for your list
+ *
+ * Continue to iterate over plist, continuing after the current position.
+ */
+#define plist_for_each_continue(pos, head)	\
+	 list_for_each_entry_continue(pos, &(head)->node_list, node_list)
+
+/**
  * plist_for_each_safe - iterate safely over a plist of given type
  * @pos:	the type * to use as a loop counter
  * @n:	another type * to use as temporary storage
@@ -163,6 +180,18 @@ extern void plist_del(struct plist_node *node, struct plist_head *head);
 	 list_for_each_entry(pos, &(head)->node_list, mem.node_list)
 
 /**
+ * plist_for_each_entry_continue - continue iteration over list of given type
+ * @pos:	the type * to use as a loop cursor
+ * @head:	the head for your list
+ * @m:		the name of the list_struct within the struct
+ *
+ * Continue to iterate over list of given type, continuing after
+ * the current position.
+ */
+#define plist_for_each_entry_continue(pos, head, m)	\
+	list_for_each_entry_continue(pos, &(head)->node_list, m.node_list)
+
+/**
  * plist_for_each_entry_safe - iterate safely over list of given type
  * @pos:	the type * to use as a loop counter
  * @n:		another type * to use as temporary storage
@@ -229,6 +258,20 @@ static inline int plist_node_empty(const struct plist_node *node)
 #endif
 
 /**
+ * plist_next - get the next entry in list
+ * @pos:	the type * to cursor
+ */
+#define plist_next(pos) \
+	list_next_entry(pos, node_list)
+
+/**
+ * plist_prev - get the prev entry in list
+ * @pos:	the type * to cursor
+ */
+#define plist_prev(pos) \
+	list_prev_entry(pos, node_list)
+
+/**
  * plist_first - return the first node (and thus, highest priority)
  * @head:	the &struct plist_head pointer
  *
-- 
1.8.4.5

