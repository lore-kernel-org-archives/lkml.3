Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752689AbaFFRiY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 13:38:24 -0400
Received: from mout.web.de ([212.227.17.11]:59881 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751471AbaFFReu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 13:34:50 -0400
From: Ken Helias <kenhelias@web.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Ken Helias <kenhelias@firemail.de>,
        Dipankar Sarma <dipankar@in.ibm.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Oleg Nesterov <oleg@redhat.com>, Dave Jones <davej@redhat.com>
Subject: [PATCH 03/13] list: Add list_add_(before|after) macros
Date: Fri,  6 Jun 2014 19:34:22 +0200
Message-Id: <1402076072-4044-3-git-send-email-kenhelias@web.de>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1402076072-4044-1-git-send-email-kenhelias@web.de>
References: <1402076072-4044-1-git-send-email-kenhelias@web.de>
X-Provags-ID: V03:K0:8nbVxsncn6PobjWA7MJH8tiUOXylvlTLR5afLI9pU7EPq70KYWu
 +a/kjCdJLGG5mXwVLBvO0KjODDxHTQmlLZTAhuftMO43jrteQMPP4sk9KjqKmM9aSPnNlRQ
 PRJlPjc28HPIohnEu6lfJHnHknlXJRZWh5XWIzPYdxI4eXRXZM8Xhx/dqDQm7Ht9dqH5xsV
 AcCxr9gkMxdK/MKPc1caw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ken Helias <kenhelias@firemail.de>

Many places in the code uses list_add_tail/list_add to insert an entry
before/after another entry. This confuses the reader because these are usually
used to add an item to a list_head and not an entry. hlist already have
functions to do the same which makes the code a lot more readable. It would be
a lot easier to understand when all places use a self explaining function name
instead of misusing other functions.

Signed-off-by: Ken Helias <kenhelias@firemail.de>
Cc: Dipankar Sarma <dipankar@in.ibm.com>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Ken Helias <kenhelias@firemail.de>
Cc: Dave Jones <davej@redhat.com>
---
 include/linux/list.h    | 22 ++++++++++++++++++++++
 include/linux/rculist.h | 38 ++++++++++++++++++++++++++++++++++++++
 2 files changed, 60 insertions(+)

diff --git a/include/linux/list.h b/include/linux/list.h
index ab43d01..5ea0eca 100644
--- a/include/linux/list.h
+++ b/include/linux/list.h
@@ -76,6 +76,28 @@ static inline void list_add_tail(struct list_head *new, struct list_head *head)
 	__list_add(new, head->prev, head);
 }
 
+/**
+ * list_add_after
+ * @n: new entry to be added
+ * @prev: the existing element to add the new element after.
+ *
+ * Description:
+ * Adds the specified element to the specified list
+ * after the specified node.
+ */
+#define list_add_after(n, prev) list_add(n, prev)
+
+/**
+ * list_add_before
+ * @n: new entry to be added
+ * @next:  the existing element to add the new element before.
+ *
+ * Description:
+ * Adds the specified element to the specified list
+ * before the specified node.
+ */
+#define list_add_before(n, next) list_add_tail(n, next)
+
 /*
  * Delete a list entry by making the prev/next entries
  * point to each other.
diff --git a/include/linux/rculist.h b/include/linux/rculist.h
index 648773f..eec274d 100644
--- a/include/linux/rculist.h
+++ b/include/linux/rculist.h
@@ -103,6 +103,44 @@ static inline void list_add_tail_rcu(struct list_head *new,
 }
 
 /**
+ * list_add_after_rcu
+ * @n: new entry to be added
+ * @prev: the existing element to add the new element after.
+ *
+ * Description:
+ * Adds the specified element to the specified list
+ * after the specified node while permitting racing traversals.
+ *
+ * The caller must take whatever precautions are necessary
+ * (such as holding appropriate locks) to avoid racing
+ * with another list-mutation primitive, such as list_add_rcu()
+ * or list_del_rcu(), running on this same list.
+ * However, it is perfectly legal to run concurrently with
+ * the _rcu list-traversal primitives, such as
+ * list_for_each_entry_rcu().
+ */
+#define list_add_after_rcu(n, next) list_add_rcu(n, next)
+
+/**
+ * list_add_before_rcu
+ * @n: new entry to be added
+ * @next:  the existing element to add the new element before.
+ *
+ * Description:
+ * Adds the specified element to the specified list
+ * before the specified node while permitting racing traversals.
+ *
+ * The caller must take whatever precautions are necessary
+ * (such as holding appropriate locks) to avoid racing
+ * with another list-mutation primitive, such as list_add_tail_rcu()
+ * or list_del_rcu(), running on this same list.
+ * However, it is perfectly legal to run concurrently with
+ * the _rcu list-traversal primitives, such as
+ * list_for_each_entry_rcu().
+ */
+#define list_add_before_rcu(n, next) list_add_tail_rcu(n, next)
+
+/**
  * list_del_rcu - deletes entry from list without re-initialization
  * @entry: the element to delete from the list.
  *
-- 
2.0.0

