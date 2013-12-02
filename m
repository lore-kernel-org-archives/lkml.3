Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755305Ab3LBTWx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 14:22:53 -0500
Received: from zene.cmpxchg.org ([85.214.230.12]:43831 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752314Ab3LBTWl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 14:22:41 -0500
From: Johannes Weiner <hannes@cmpxchg.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andi Kleen <andi@firstfloor.org>, Andrea Arcangeli <aarcange@redhat.com>,
        Christoph Hellwig <hch@infradead.org>,
        Dave Chinner <david@fromorbit.com>, Greg Thelen <gthelen@google.com>,
        Hugh Dickins <hughd@google.com>, Jan Kara <jack@suse.cz>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Mel Gorman <mgorman@suse.de>, Metin Doslu <metin@citusdata.com>,
        Michel Lespinasse <walken@google.com>,
        Minchan Kim <minchan.kim@gmail.com>,
        Ozgun Erdogan <ozgun@citusdata.com>,
        Peter Zijlstra <peterz@infradead.org>, Rik van Riel <riel@redhat.com>,
        Roman Gushchin <klamm@yandex-team.ru>, Ryan Mallon <rmallon@gmail.com>,
        Tejun Heo <tj@kernel.org>, Vlastimil Babka <vbabka@suse.cz>,
        linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [patch 2/9] lib: radix-tree: radix_tree_delete_item()
Date: Mon,  2 Dec 2013 14:21:41 -0500
Message-Id: <1386012108-21006-3-git-send-email-hannes@cmpxchg.org>
X-Mailer: git-send-email 1.8.4.2
In-Reply-To: <1386012108-21006-1-git-send-email-hannes@cmpxchg.org>
References: <1386012108-21006-1-git-send-email-hannes@cmpxchg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Provide a function that does not just delete an entry at a given
index, but also allows passing in an expected item.  Delete only if
that item is still located at the specified index.

This is handy when lockless tree traversals want to delete entries as
well because they don't have to do an second, locked lookup to verify
the slot has not changed under them before deleting the entry.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Minchan Kim <minchan@kernel.org>
---
 include/linux/radix-tree.h |  1 +
 lib/radix-tree.c           | 31 +++++++++++++++++++++++++++----
 2 files changed, 28 insertions(+), 4 deletions(-)

diff --git a/include/linux/radix-tree.h b/include/linux/radix-tree.h
index 4039407..1bf0a9c 100644
--- a/include/linux/radix-tree.h
+++ b/include/linux/radix-tree.h
@@ -219,6 +219,7 @@ static inline void radix_tree_replace_slot(void **pslot, void *item)
 int radix_tree_insert(struct radix_tree_root *, unsigned long, void *);
 void *radix_tree_lookup(struct radix_tree_root *, unsigned long);
 void **radix_tree_lookup_slot(struct radix_tree_root *, unsigned long);
+void *radix_tree_delete_item(struct radix_tree_root *, unsigned long, void *);
 void *radix_tree_delete(struct radix_tree_root *, unsigned long);
 unsigned int
 radix_tree_gang_lookup(struct radix_tree_root *root, void **results,
diff --git a/lib/radix-tree.c b/lib/radix-tree.c
index 7811ed3..f442e32 100644
--- a/lib/radix-tree.c
+++ b/lib/radix-tree.c
@@ -1335,15 +1335,18 @@ static inline void radix_tree_shrink(struct radix_tree_root *root)
 }
 
 /**
- *	radix_tree_delete    -    delete an item from a radix tree
+ *	radix_tree_delete_item    -    delete an item from a radix tree
  *	@root:		radix tree root
  *	@index:		index key
+ *	@item:		expected item
  *
- *	Remove the item at @index from the radix tree rooted at @root.
+ *	Remove @item at @index from the radix tree rooted at @root.
  *
- *	Returns the address of the deleted item, or NULL if it was not present.
+ *	Returns the address of the deleted item, or NULL if it was not present
+ *	or the entry at the given @index was not @item.
  */
-void *radix_tree_delete(struct radix_tree_root *root, unsigned long index)
+void *radix_tree_delete_item(struct radix_tree_root *root,
+			     unsigned long index, void *item)
 {
 	struct radix_tree_node *node = NULL;
 	struct radix_tree_node *slot = NULL;
@@ -1378,6 +1381,11 @@ void *radix_tree_delete(struct radix_tree_root *root, unsigned long index)
 	if (slot == NULL)
 		goto out;
 
+	if (item && slot != item) {
+		slot = NULL;
+		goto out;
+	}
+
 	/*
 	 * Clear all tags associated with the item to be deleted.
 	 * This way of doing it would be inefficient, but seldom is any set.
@@ -1422,6 +1430,21 @@ void *radix_tree_delete(struct radix_tree_root *root, unsigned long index)
 out:
 	return slot;
 }
+EXPORT_SYMBOL(radix_tree_delete_item);
+
+/**
+ *	radix_tree_delete    -    delete an item from a radix tree
+ *	@root:		radix tree root
+ *	@index:		index key
+ *
+ *	Remove the item at @index from the radix tree rooted at @root.
+ *
+ *	Returns the address of the deleted item, or NULL if it was not present.
+ */
+void *radix_tree_delete(struct radix_tree_root *root, unsigned long index)
+{
+	return radix_tree_delete_item(root, index, NULL);
+}
 EXPORT_SYMBOL(radix_tree_delete);
 
 /**
-- 
1.8.4.2

