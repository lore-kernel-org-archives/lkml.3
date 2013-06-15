Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754404Ab3FORff (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Jun 2013 13:35:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42661 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754112Ab3FORey (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Jun 2013 13:34:54 -0400
Date: Sat, 15 Jun 2013 19:30:43 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Andrey Vagin <avagin@openvz.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        David Howells <dhowells@redhat.com>, Huang Ying <ying.huang@intel.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] llist: fix/simplify llist_add() and llist_add_batch()
Message-ID: <20130615173043.GA15065@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130615172959.GA14656@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

1. This is mostly theoretical, but llist_add*() need ACCESS_ONCE().

   Otherwise it is not guaranteed that the first cmpxchg() uses the
   same value for old_entry and new_last->next.

2. These helpers cache the result of cmpxchg() and read the initial
   value of head->first before the main loop. I do not think this
   makes sense. In the likely case cmpxchg() succeeds, otherwise
   it doesn't hurt to reload head->first.

   I think it would be better to simplify the code and simply read
   ->first before cmpxchg().

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 include/linux/llist.h |   19 +++++++------------
 lib/llist.c           |   15 +++++----------
 2 files changed, 12 insertions(+), 22 deletions(-)

diff --git a/include/linux/llist.h b/include/linux/llist.h
index a5199f6..3e2b969 100644
--- a/include/linux/llist.h
+++ b/include/linux/llist.h
@@ -151,18 +151,13 @@ static inline struct llist_node *llist_next(struct llist_node *node)
  */
 static inline bool llist_add(struct llist_node *new, struct llist_head *head)
 {
-	struct llist_node *entry, *old_entry;
-
-	entry = head->first;
-	for (;;) {
-		old_entry = entry;
-		new->next = entry;
-		entry = cmpxchg(&head->first, old_entry, new);
-		if (entry == old_entry)
-			break;
-	}
-
-	return old_entry == NULL;
+	struct llist_node *first;
+
+	do {
+		new->next = first = ACCESS_ONCE(head->first);
+	} while (cmpxchg(&head->first, first, new) != first);
+
+	return !first;
 }
 
 /**
diff --git a/lib/llist.c b/lib/llist.c
index 4a15115..4a70d12 100644
--- a/lib/llist.c
+++ b/lib/llist.c
@@ -39,18 +39,13 @@
 bool llist_add_batch(struct llist_node *new_first, struct llist_node *new_last,
 		     struct llist_head *head)
 {
-	struct llist_node *entry, *old_entry;
+	struct llist_node *first;
 
-	entry = head->first;
-	for (;;) {
-		old_entry = entry;
-		new_last->next = entry;
-		entry = cmpxchg(&head->first, old_entry, new_first);
-		if (entry == old_entry)
-			break;
-	}
+	do {
+		new_last->next = first = ACCESS_ONCE(head->first);
+	} while (cmpxchg(&head->first, first, new_first) != first);
 
-	return old_entry == NULL;
+	return !first;
 }
 EXPORT_SYMBOL_GPL(llist_add_batch);
 
-- 
1.5.5.1

