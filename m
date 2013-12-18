Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754297Ab3LRTTj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 14:19:39 -0500
Received: from mx1.redhat.com ([209.132.183.28]:60599 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754164Ab3LRTTf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 14:19:35 -0500
Date: Wed, 18 Dec 2013 20:20:01 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrea Arcangeli <aarcange@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Dave Jones <davej@redhat.com>, Darren Hart <dvhart@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>, Mel Gorman <mgorman@suse.de>,
        linux-kernel@vger.kernel.org
Subject: [PATCH -mm 5/7] mm: thp: reorganize out_put_single code in
	__put_page_tail()
Message-ID: <20131218192001.GA8333@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131218191913.GA6464@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch looks complicated but it is not. It simply moves the
out_put_single label at the end of the function and changes the
!__compound_tail_refcounted() block to save a tab stop.

This cleanups the code layout a bit, and this is the preparation
for the next change.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 mm/swap.c |   70 ++++++++++++++++++++++++------------------------------------
 1 files changed, 28 insertions(+), 42 deletions(-)

diff --git a/mm/swap.c b/mm/swap.c
index 0400f3b..5f3dda6 100644
--- a/mm/swap.c
+++ b/mm/swap.c
@@ -125,42 +125,29 @@ static void __put_page_tail(struct page *page)
 		 * can be freed and reallocated.
 		 */
 		smp_rmb();
-		if (likely(PageTail(page))) {
-			/*
-			 * __split_huge_page_refcount cannot race
-			 * here.
-			 */
-			VM_BUG_ON(!PageHead(page_head));
-			VM_BUG_ON(page_mapcount(page) != 0);
-			if (put_page_testzero(page_head)) {
-				/*
-				 * If this is the tail of a slab
-				 * compound page, the tail pin must
-				 * not be the last reference held on
-				 * the page, because the PG_slab
-				 * cannot be cleared before all tail
-				 * pins (which skips the _mapcount
-				 * tail refcounting) have been
-				 * released. For hugetlbfs the tail
-				 * pin may be the last reference on
-				 * the page instead, because
-				 * PageHeadHuge will not go away until
-				 * the compound page enters the buddy
-				 * allocator.
-				 */
-				VM_BUG_ON(PageSlab(page_head));
-				__put_compound_page(page_head);
-			}
-			return;
-		} else
+		if (unlikely(!PageTail(page)))
+			goto out_put_single;
+
+		/*
+		 * __split_huge_page_refcount cannot race here.
+		 */
+		VM_BUG_ON(!PageHead(page_head));
+		VM_BUG_ON(page_mapcount(page) != 0);
+		if (put_page_testzero(page_head)) {
 			/*
-			 * __split_huge_page_refcount run before us,
-			 * "page" was a THP tail. The split page_head
-			 * has been freed and reallocated as slab or
-			 * hugetlbfs page of smaller order (only
-			 * possible if reallocated as slab on x86).
+			 * If this is the tail of a slab compound page, the
+			 * tail pin must not be the last reference held on
+			 * the page, because the PG_slab cannot be cleared
+			 * before all tail pins (which skips the _mapcount
+			 * tail refcounting) have been released. For hugetlbfs
+			 * the tail pin may be the last reference on the page
+			 * instead, because PageHeadHuge will not go away until
+			 * the compound page enters the buddy allocator.
 			 */
-			goto out_put_single;
+			VM_BUG_ON(PageSlab(page_head));
+			__put_compound_page(page_head);
+		}
+		return;
 	}
 
 	if (likely(page != page_head && get_page_unless_zero(page_head))) {
@@ -186,10 +173,7 @@ static void __put_page_tail(struct page *page)
 			 * before the split.
 			 */
 			__put_nontail_page(page_head);
-out_put_single:
-			if (put_page_testzero(page))
-				__put_single_page(page);
-			return;
+			goto out_put_single;
 		}
 		VM_BUG_ON(page_head != page->first_page);
 		/*
@@ -208,11 +192,13 @@ out_put_single:
 		compound_unlock_irqrestore(page_head, flags);
 
 		__put_nontail_page(page_head);
-	} else {
-		/* page_head is a dangling pointer */
-		VM_BUG_ON(PageTail(page));
-		goto out_put_single;
+		return;
 	}
+
+out_put_single:
+	VM_BUG_ON(PageTail(page));
+	if (put_page_testzero(page))
+		__put_single_page(page);
 }
 
 void put_page(struct page *page)
-- 
1.5.5.1

