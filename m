Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932738Ab3IYBa3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 21:30:29 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:34183 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757120Ab3IYB3c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 21:29:32 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        sbw@mit.edu, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 05/11] rcu: Make list_splice_init_rcu() account for RCU readers
Date: Tue, 24 Sep 2013 18:29:15 -0700
Message-Id: <1380072561-31134-5-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1380072561-31134-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20130925012750.GA30601@linux.vnet.ibm.com>
 <1380072561-31134-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13092501-7164-0000-0000-000001E539E1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

The list_splice_init_rcu() function allows a list visible to RCU readers
to be spliced into another list visible to RCU readers.  This is OK,
except for the use of INIT_LIST_HEAD(), which does pointer updates
without doing anything to make those updates safe for concurrent readers.

Of course, most of the time INIT_LIST_HEAD() is being used in reader-free
contexts, such as initialization or cleanup, so it is OK for it to update
pointers in an unsafe-for-RCU-readers manner.  This commit therefore
creates an INIT_LIST_HEAD_RCU() that uses ACCESS_ONCE() to make the updates
reader-safe.  The reason that we can use ACCESS_ONCE() instead of the more
typical rcu_assign_pointer() is that list_splice_init_rcu() is updating the
pointers to reference something that is already visible to readers, so
that there is no problem with pre-initialized values.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 include/linux/rculist.h | 23 +++++++++++++++++++++--
 1 file changed, 21 insertions(+), 2 deletions(-)

diff --git a/include/linux/rculist.h b/include/linux/rculist.h
index 4106721..45a0a9e 100644
--- a/include/linux/rculist.h
+++ b/include/linux/rculist.h
@@ -19,6 +19,21 @@
  */
 
 /*
+ * INIT_LIST_HEAD_RCU - Initialize a list_head visible to RCU readers
+ * @list: list to be initialized
+ *
+ * You should instead use INIT_LIST_HEAD() for normal initialization and
+ * cleanup tasks, when readers have no access to the list being initialized.
+ * However, if the list being initialized is visible to readers, you
+ * need to keep the compiler from being too mischievous.
+ */
+static inline void INIT_LIST_HEAD_RCU(struct list_head *list)
+{
+	ACCESS_ONCE(list->next) = list;
+	ACCESS_ONCE(list->prev) = list;
+}
+
+/*
  * return the ->next pointer of a list_head in an rcu safe
  * way, we must not access it directly
  */
@@ -191,9 +206,13 @@ static inline void list_splice_init_rcu(struct list_head *list,
 	if (list_empty(list))
 		return;
 
-	/* "first" and "last" tracking list, so initialize it. */
+	/*
+	 * "first" and "last" tracking list, so initialize it.  RCU readers
+	 * have access to this list, so we must use INIT_LIST_HEAD_RCU()
+	 * instead of INIT_LIST_HEAD().
+	 */
 
-	INIT_LIST_HEAD(list);
+	INIT_LIST_HEAD_RCU(list);
 
 	/*
 	 * At this point, the list body still points to the source list.
-- 
1.8.1.5

