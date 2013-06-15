Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754365Ab3FORfA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Jun 2013 13:35:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:62523 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754288Ab3FORe5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Jun 2013 13:34:57 -0400
Date: Sat, 15 Jun 2013 19:30:46 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Andrey Vagin <avagin@openvz.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        David Howells <dhowells@redhat.com>, Huang Ying <ying.huang@intel.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] llist: llist_add() can use llist_add_batch()
Message-ID: <20130615173046.GA15068@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130615172959.GA14656@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

llist_add(new, head) can simply use llist_add_batch(new, new, head),
no need to duplicate the code.

This obviously uninlines llist_add() and to me this is a win. But we
can make llist_add_batch() inline if this is desirable, in this case
gcc can notice that new_first == new_last if the caller is llist_add().

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 include/linux/llist.h |   14 ++++----------
 1 files changed, 4 insertions(+), 10 deletions(-)

diff --git a/include/linux/llist.h b/include/linux/llist.h
index 3e2b969..cdaa7f0 100644
--- a/include/linux/llist.h
+++ b/include/linux/llist.h
@@ -142,6 +142,9 @@ static inline struct llist_node *llist_next(struct llist_node *node)
 	return node->next;
 }
 
+extern bool llist_add_batch(struct llist_node *new_first,
+			    struct llist_node *new_last,
+			    struct llist_head *head);
 /**
  * llist_add - add a new entry
  * @new:	new entry to be added
@@ -151,13 +154,7 @@ static inline struct llist_node *llist_next(struct llist_node *node)
  */
 static inline bool llist_add(struct llist_node *new, struct llist_head *head)
 {
-	struct llist_node *first;
-
-	do {
-		new->next = first = ACCESS_ONCE(head->first);
-	} while (cmpxchg(&head->first, first, new) != first);
-
-	return !first;
+	return llist_add_batch(new, new, head);
 }
 
 /**
@@ -173,9 +170,6 @@ static inline struct llist_node *llist_del_all(struct llist_head *head)
 	return xchg(&head->first, NULL);
 }
 
-extern bool llist_add_batch(struct llist_node *new_first,
-			    struct llist_node *new_last,
-			    struct llist_head *head);
 extern struct llist_node *llist_del_first(struct llist_head *head);
 
 #endif /* LLIST_H */
-- 
1.5.5.1

