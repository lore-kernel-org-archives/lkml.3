Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932943AbaJGXcY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 19:32:24 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:39707 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932167AbaJGXUC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 19:20:02 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Dan Streetman <ddstreet@ieee.org>, Mel Gorman <mgorman@suse.de>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>, Shaohua Li <shli@fusionio.com>,
        Hugh Dickins <hughd@google.com>, Michal Hocko <mhocko@suse.cz>,
        Christian Ehrhardt <ehrhardt@linux.vnet.ibm.com>,
        Weijie Yang <weijieut@gmail.com>, Rik van Riel <riel@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Bob Liu <bob.liu@oracle.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 3.14 18/37] lib/plist: add helper functions
Date: Tue,  7 Oct 2014 16:19:35 -0700
Message-Id: <20141007231827.624161537@linuxfoundation.org>
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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/linux/plist.h |   43 +++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 43 insertions(+)

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
@@ -143,6 +150,16 @@ extern void plist_del(struct plist_node
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
@@ -163,6 +180,18 @@ extern void plist_del(struct plist_node
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
@@ -229,6 +258,20 @@ static inline int plist_node_empty(const
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


