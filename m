Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754091Ab3LRTTa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 14:19:30 -0500
Received: from mx1.redhat.com ([209.132.183.28]:45055 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752452Ab3LRTT0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 14:19:26 -0500
Date: Wed, 18 Dec 2013 20:19:49 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrea Arcangeli <aarcange@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Dave Jones <davej@redhat.com>, Darren Hart <dvhart@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>, Mel Gorman <mgorman@suse.de>,
        linux-kernel@vger.kernel.org
Subject: [PATCH -mm 1/7] mm: thp: introduce __put_nontail_page()
Message-ID: <20131218191949.GA8312@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131218191913.GA6464@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the new helper, __put_nontail_page(page), which simply does
compound/single put depending on PageHead(). put_compound_page()
can use it 3 times, probably it can have other users.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 mm/swap.c |   60 ++++++++++++++++++++++++++----------------------------------
 1 files changed, 26 insertions(+), 34 deletions(-)

diff --git a/mm/swap.c b/mm/swap.c
index 0040d9c..f83de1f 100644
--- a/mm/swap.c
+++ b/mm/swap.c
@@ -79,21 +79,26 @@ static void __put_compound_page(struct page *page)
 	(*dtor)(page);
 }
 
+static void __put_nontail_page(struct page *page)
+{
+	if (put_page_testzero(page)) {
+		/*
+		 * By the time all refcounts have been released
+		 * split_huge_page cannot run anymore from under us.
+		 */
+		if (PageHead(page))
+			__put_compound_page(page);
+		else
+			__put_single_page(page);
+	}
+}
+
 static void put_compound_page(struct page *page)
 {
 	struct page *page_head;
 
 	if (likely(!PageTail(page))) {
-		if (put_page_testzero(page)) {
-			/*
-			 * By the time all refcounts have been released
-			 * split_huge_page cannot run anymore from under us.
-			 */
-			if (PageHead(page))
-				__put_compound_page(page);
-			else
-				__put_single_page(page);
-		}
+		__put_nontail_page(page);
 		return;
 	}
 
@@ -176,24 +181,16 @@ static void put_compound_page(struct page *page)
 		if (unlikely(!PageTail(page))) {
 			/* __split_huge_page_refcount run before us */
 			compound_unlock_irqrestore(page_head, flags);
-			if (put_page_testzero(page_head)) {
-				/*
-				 * The head page may have been freed
-				 * and reallocated as a compound page
-				 * of smaller order and then freed
-				 * again.  All we know is that it
-				 * cannot have become: a THP page, a
-				 * compound page of higher order, a
-				 * tail page.  That is because we
-				 * still hold the refcount of the
-				 * split THP tail and page_head was
-				 * the THP head before the split.
-				 */
-				if (PageHead(page_head))
-					__put_compound_page(page_head);
-				else
-					__put_single_page(page_head);
-			}
+			/*
+			 * The head page may have been freed and reallocated
+			 * as a compound page of smaller order and then freed
+			 * again. All we know is that it cannot have become:
+			 * a THP page, a compound page of higher order, a tail
+			 * page. That is because we still hold the refcount of
+			 * the split THP tail and page_head was the THP head
+			 * before the split.
+			 */
+			__put_nontail_page(page_head);
 out_put_single:
 			if (put_page_testzero(page))
 				__put_single_page(page);
@@ -215,12 +212,7 @@ out_put_single:
 		VM_BUG_ON(atomic_read(&page->_count) != 0);
 		compound_unlock_irqrestore(page_head, flags);
 
-		if (put_page_testzero(page_head)) {
-			if (PageHead(page_head))
-				__put_compound_page(page_head);
-			else
-				__put_single_page(page_head);
-		}
+		__put_nontail_page(page_head);
 	} else {
 		/* page_head is a dangling pointer */
 		VM_BUG_ON(PageTail(page));
-- 
1.5.5.1

