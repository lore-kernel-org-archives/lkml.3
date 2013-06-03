Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759010Ab3FCUCM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 16:02:12 -0400
Received: from mga09.intel.com ([134.134.136.24]:45241 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758110Ab3FCUCH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 16:02:07 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,794,1363158000"; 
   d="scan'208";a="347576405"
Subject: [v5][PATCH 3/6] mm: vmscan: break up __remove_mapping()
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, mgorman@suse.de,
        tim.c.chen@linux.intel.com, minchan@kernel.org,
        Dave Hansen <dave@sr71.net>
From: Dave Hansen <dave@sr71.net>
Date: Mon, 03 Jun 2013 13:02:06 -0700
References: <20130603200202.7F5FDE07@viggo.jf.intel.com>
In-Reply-To: <20130603200202.7F5FDE07@viggo.jf.intel.com>
Message-Id: <20130603200206.644A9EC3@viggo.jf.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


From: Dave Hansen <dave.hansen@linux.intel.com>

Our goal here is to eventually reduce the number of repetitive
acquire/release operations on mapping->tree_lock.

Logically, this patch has two steps:
1. rename __remove_mapping() to lock_remove_mapping() since
   "__" usually means "this us the unlocked version.
2. Recreate __remove_mapping() to _be_ the lock_remove_mapping()
   but without the locks.

I think this actually makes the code flow around the locking
_much_ more straighforward since the locking just becomes:

	spin_lock_irq(&mapping->tree_lock);
	ret = __remove_mapping(mapping, page);
	spin_unlock_irq(&mapping->tree_lock);

One non-obvious part of this patch: the

	freepage = mapping->a_ops->freepage;

used to happen under the mapping->tree_lock, but this patch
moves it to outside of the lock.  All of the other
a_ops->freepage users do it outside the lock, and we only
assign it when we create inodes, so that makes it safe.

Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Acked-by: Mel Gorman <mgorman@suse.de>
Reviewed-by: Minchan Kin <minchan@kernel.org>

---

 linux.git-davehans/mm/vmscan.c |   40 ++++++++++++++++++++++++----------------
 1 file changed, 24 insertions(+), 16 deletions(-)

diff -puN mm/vmscan.c~make-remove-mapping-without-locks mm/vmscan.c
--- linux.git/mm/vmscan.c~make-remove-mapping-without-locks	2013-06-03 12:41:30.903728970 -0700
+++ linux.git-davehans/mm/vmscan.c	2013-06-03 12:41:30.907729146 -0700
@@ -455,7 +455,6 @@ static int __remove_mapping(struct addre
 	BUG_ON(!PageLocked(page));
 	BUG_ON(mapping != page_mapping(page));
 
-	spin_lock_irq(&mapping->tree_lock);
 	/*
 	 * The non racy check for a busy page.
 	 *
@@ -482,35 +481,44 @@ static int __remove_mapping(struct addre
 	 * and thus under tree_lock, then this ordering is not required.
 	 */
 	if (!page_freeze_refs(page, 2))
-		goto cannot_free;
+		return 0;
 	/* note: atomic_cmpxchg in page_freeze_refs provides the smp_rmb */
 	if (unlikely(PageDirty(page))) {
 		page_unfreeze_refs(page, 2);
-		goto cannot_free;
+		return 0;
 	}
 
 	if (PageSwapCache(page)) {
 		__delete_from_swap_cache(page);
-		spin_unlock_irq(&mapping->tree_lock);
+	} else {
+		__delete_from_page_cache(page);
+	}
+	return 1;
+}
+
+static int lock_remove_mapping(struct address_space *mapping, struct page *page)
+{
+	int ret;
+	BUG_ON(!PageLocked(page));
+
+	spin_lock_irq(&mapping->tree_lock);
+	ret = __remove_mapping(mapping, page);
+	spin_unlock_irq(&mapping->tree_lock);
+
+	/* unable to free */
+	if (!ret)
+		return 0;
+
+	if (PageSwapCache(page)) {
 		swapcache_free_page_entry(page);
 	} else {
 		void (*freepage)(struct page *);
-
 		freepage = mapping->a_ops->freepage;
-
-		__delete_from_page_cache(page);
-		spin_unlock_irq(&mapping->tree_lock);
 		mem_cgroup_uncharge_cache_page(page);
-
 		if (freepage != NULL)
 			freepage(page);
 	}
-
-	return 1;
-
-cannot_free:
-	spin_unlock_irq(&mapping->tree_lock);
-	return 0;
+	return ret;
 }
 
 /*
@@ -521,7 +529,7 @@ cannot_free:
  */
 int remove_mapping(struct address_space *mapping, struct page *page)
 {
-	if (__remove_mapping(mapping, page)) {
+	if (lock_remove_mapping(mapping, page)) {
 		/*
 		 * Unfreezing the refcount with 1 rather than 2 effectively
 		 * drops the pagecache ref for us without requiring another
_
