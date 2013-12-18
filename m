Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754417Ab3LRTUP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 14:20:15 -0500
Received: from mx1.redhat.com ([209.132.183.28]:48059 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752452Ab3LRTTh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 14:19:37 -0500
Date: Wed, 18 Dec 2013 20:20:08 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrea Arcangeli <aarcange@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Dave Jones <davej@redhat.com>, Darren Hart <dvhart@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>, Mel Gorman <mgorman@suse.de>,
        linux-kernel@vger.kernel.org
Subject: [PATCH -mm 7/7] mm: thp: introduce compound_head_put_tail(),
	change get_futex_key() to use it
Message-ID: <20131218192008.GA8343@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131218191913.GA6464@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

1. Add the new helper, compound_head_put_tail(page) which returns
   the stable compound_head() and drops the reference to this page
   if it is the sub-page of __compound_tail_refcounted(head).

   Note: this patch tries to be as simple as possible. But we need
   to unify the new helper with __put_page_tail() later, or at least
   factor out the common code.

2. Remove the nasty __get_user_pages_fast() code in get_futex_key(),
   it can use the new helper to get page_head.

   Note: with or without this change basepage_index(page) after
   put_page(page) looks confusing at least, this will be addressed
   later.

Suggested-by: Andrea Arcangeli <aarcange@redhat.com>
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 include/linux/mm.h |    2 ++
 kernel/futex.c     |   37 +------------------------------------
 mm/swap.c          |   35 +++++++++++++++++++++++++++++++++++
 3 files changed, 38 insertions(+), 36 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 13495bd..545df45 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -501,6 +501,8 @@ static inline void __ClearPageBuddy(struct page *page)
 void put_page(struct page *page);
 void put_pages_list(struct list_head *pages);
 
+struct page *compound_head_put_tail(struct page *page);
+
 void split_page(struct page *page, unsigned int order);
 int split_free_page(struct page *page);
 
diff --git a/kernel/futex.c b/kernel/futex.c
index c3a1a55..1fd7031 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -282,42 +282,7 @@ again:
 	else
 		err = 0;
 
-#ifdef CONFIG_TRANSPARENT_HUGEPAGE
-	page_head = page;
-	if (unlikely(PageTail(page))) {
-		put_page(page);
-		/* serialize against __split_huge_page_splitting() */
-		local_irq_disable();
-		if (likely(__get_user_pages_fast(address, 1, 1, &page) == 1)) {
-			page_head = compound_head(page);
-			/*
-			 * page_head is valid pointer but we must pin
-			 * it before taking the PG_lock and/or
-			 * PG_compound_lock. The moment we re-enable
-			 * irqs __split_huge_page_splitting() can
-			 * return and the head page can be freed from
-			 * under us. We can't take the PG_lock and/or
-			 * PG_compound_lock on a page that could be
-			 * freed from under us.
-			 */
-			if (page != page_head) {
-				get_page(page_head);
-				put_page(page);
-			}
-			local_irq_enable();
-		} else {
-			local_irq_enable();
-			goto again;
-		}
-	}
-#else
-	page_head = compound_head(page);
-	if (page != page_head) {
-		get_page(page_head);
-		put_page(page);
-	}
-#endif
-
+	page_head = compound_head_put_tail(page);
 	lock_page(page_head);
 
 	/*
diff --git a/mm/swap.c b/mm/swap.c
index 972923d..6742c85 100644
--- a/mm/swap.c
+++ b/mm/swap.c
@@ -215,6 +215,41 @@ void put_page(struct page *page)
 EXPORT_SYMBOL(put_page);
 
 /*
+ * Like compound_head() but also drops the additional reference
+ * this page can have. Unlike compound_head() it returns the page
+ * which has a reference, and can't race with split_huge_page().
+ */
+struct page *compound_head_put_tail(struct page *page)
+{
+	struct page *page_head;
+	unsigned long flags;
+
+	if (!PageTail(page))
+		return page;
+
+	page_head = compound_trans_head(page);
+
+	if (!__compound_tail_refcounted(page_head)) {
+		smp_rmb();
+		if (likely(PageTail(page)))
+			return page_head;
+		else
+			return page;
+	}
+
+	if (likely(get_lock_thp_head(page_head, page, &flags))) {
+		if (put_page_testzero(page_head))
+			VM_BUG_ON(1);
+		atomic_dec(&page->_mapcount);
+		compound_unlock_irqrestore(page_head, flags);
+
+		return page_head;
+	}
+
+	return page;
+}
+
+/*
  * This function is exported but must not be called by anything other
  * than get_page(). It implements the slow path of get_page().
  */
-- 
1.5.5.1

