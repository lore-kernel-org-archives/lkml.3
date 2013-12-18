Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754387Ab3LRTTo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 14:19:44 -0500
Received: from mx1.redhat.com ([209.132.183.28]:31294 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753794Ab3LRTTm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 14:19:42 -0500
Date: Wed, 18 Dec 2013 20:20:05 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrea Arcangeli <aarcange@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Dave Jones <davej@redhat.com>, Darren Hart <dvhart@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>, Mel Gorman <mgorman@suse.de>,
        linux-kernel@vger.kernel.org
Subject: [PATCH -mm 6/7] mm: thp: introduce get_lock_thp_head()
Message-ID: <20131218192005.GA8340@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131218191913.GA6464@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Both __put_page_tail() and __get_page_tail() need to carefully
take a reference on page_head, take compound_lock() and recheck
PageTail(page) under this lock.

This patch extracts this code into the new helper, it will have
another user. This also means that __get_page_tail() gets the
same VM_BUG_ON() checks.

Note: this change can also help if we decide to change the locking,
perhaps it makes sense to change __split_huge_page_refcount() to
also do compound_lock/unlock(page_tail) in a loop. In this case it
would be simple to adapt this helper and its usage.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 mm/swap.c |   99 +++++++++++++++++++++++++++---------------------------------
 1 files changed, 45 insertions(+), 54 deletions(-)

diff --git a/mm/swap.c b/mm/swap.c
index 5f3dda6..972923d 100644
--- a/mm/swap.c
+++ b/mm/swap.c
@@ -93,12 +93,45 @@ static void __put_nontail_page(struct page *page)
 	}
 }
 
-static void __put_page_tail(struct page *page)
+static bool get_lock_thp_head(struct page *head, struct page *tail,
+				unsigned long *flags)
 {
-	struct page *page_head;
+	if (unlikely(head == tail || !get_page_unless_zero(head)))
+		return false;
+
+	/*
+	 * page_head wasn't a dangling pointer but it may not be a head
+	 * page anymore by the time we obtain the lock. That is ok as
+	 * long as it can't be freed from under us.
+	 */
+	*flags = compound_lock_irqsave(head);
+	if (likely(PageTail(tail))) {
+		VM_BUG_ON(head != tail->first_page);
+		VM_BUG_ON(atomic_read(&head->_count) <= 1);
+		VM_BUG_ON(atomic_read(&tail->_count) != 0);
+		VM_BUG_ON(page_mapcount(tail) <= 1);
+		return true;
+	}
+
+	compound_unlock_irqrestore(head, *flags);
+	/*
+	 * The head page may have been freed and reallocated as a compound
+	 * page of smaller order and then freed again. All we know is that
+	 * it cannot have become: a THP page, a compound page of higher
+	 * order, a tail page. That is because we still hold the refcount
+	 * of the split THP tail and page_head was the THP head before the
+	 * split.
+	 */
+	__put_nontail_page(head);
+	return false;
+}
 
+
+static void __put_page_tail(struct page *page)
+{
 	/* __split_huge_page_refcount can run under us */
-	page_head = compound_trans_head(page);
+	struct page *page_head = compound_trans_head(page);
+	unsigned long flags;
 
 	/*
 	 * THP can not break up slab pages so avoid taking
@@ -150,45 +183,16 @@ static void __put_page_tail(struct page *page)
 		return;
 	}
 
-	if (likely(page != page_head && get_page_unless_zero(page_head))) {
-		unsigned long flags;
-
-		/*
-		 * page_head wasn't a dangling pointer but it may not
-		 * be a head page anymore by the time we obtain the
-		 * lock. That is ok as long as it can't be freed from
-		 * under us.
-		 */
-		flags = compound_lock_irqsave(page_head);
-		if (unlikely(!PageTail(page))) {
-			/* __split_huge_page_refcount run before us */
-			compound_unlock_irqrestore(page_head, flags);
-			/*
-			 * The head page may have been freed and reallocated
-			 * as a compound page of smaller order and then freed
-			 * again. All we know is that it cannot have become:
-			 * a THP page, a compound page of higher order, a tail
-			 * page. That is because we still hold the refcount of
-			 * the split THP tail and page_head was the THP head
-			 * before the split.
-			 */
-			__put_nontail_page(page_head);
-			goto out_put_single;
-		}
-		VM_BUG_ON(page_head != page->first_page);
+	if (likely(get_lock_thp_head(page_head, page, &flags))) {
 		/*
-		 * We can release the refcount taken by
-		 * get_page_unless_zero() now that
-		 * __split_huge_page_refcount() is blocked on the
+		 * We can release the refcount taken by get_lock_thp_head()
+		 * now that __split_huge_page_refcount() is blocked on the
 		 * compound_lock.
 		 */
 		if (put_page_testzero(page_head))
 			VM_BUG_ON(1);
 		/* __split_huge_page_refcount will wait now */
-		VM_BUG_ON(page_mapcount(page) <= 0);
 		atomic_dec(&page->_mapcount);
-		VM_BUG_ON(atomic_read(&page_head->_count) <= 0);
-		VM_BUG_ON(atomic_read(&page->_count) != 0);
 		compound_unlock_irqrestore(page_head, flags);
 
 		__put_nontail_page(page_head);
@@ -224,9 +228,8 @@ bool __get_page_tail(struct page *page)
 	 * proper PT lock that already serializes against
 	 * split_huge_page().
 	 */
-	unsigned long flags;
-	bool got;
 	struct page *page_head = compound_trans_head(page);
+	unsigned long flags;
 
 	/* Ref to __put_page_tail() comment. */
 	if (!__compound_tail_refcounted(page_head)) {
@@ -254,25 +257,13 @@ bool __get_page_tail(struct page *page)
 		}
 	}
 
-	got = false;
-	if (likely(page != page_head && get_page_unless_zero(page_head))) {
-		/*
-		 * page_head wasn't a dangling pointer but it
-		 * may not be a head page anymore by the time
-		 * we obtain the lock. That is ok as long as it
-		 * can't be freed from under us.
-		 */
-		flags = compound_lock_irqsave(page_head);
-		/* here __split_huge_page_refcount won't run anymore */
-		if (likely(PageTail(page))) {
-			__get_page_tail_foll(page, false);
-			got = true;
-		}
+	if (likely(get_lock_thp_head(page_head, page, &flags))) {
+		__get_page_tail_foll(page, false);
 		compound_unlock_irqrestore(page_head, flags);
-		if (unlikely(!got))
-			__put_nontail_page(page_head);
+		return true;
 	}
-	return got;
+
+	return false;
 }
 EXPORT_SYMBOL(__get_page_tail);
 
-- 
1.5.5.1

