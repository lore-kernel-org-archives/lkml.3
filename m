Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755983Ab3FGPIT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 11:08:19 -0400
Received: from mga03.intel.com ([143.182.124.21]:20087 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755889Ab3FGPIR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 11:08:17 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,822,1363158000"; 
   d="scan'208";a="313770366"
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
To: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Dave Hansen <dave@sr71.net>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>, Hugh Dickins <hughd@google.com>,
        Wu Fengguang <fengguang.wu@intel.com>, Jan Kara <jack@suse.cz>,
        Mel Gorman <mgorman@suse.de>, linux-mm@kvack.org,
        Andi Kleen <ak@linux.intel.com>,
        Matthew Wilcox <matthew.r.wilcox@intel.com>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Hillf Danton <dhillf@gmail.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <20130528122812.0D624E0090@blue.fi.intel.com>
References: <1368321816-17719-1-git-send-email-kirill.shutemov@linux.intel.com>
 <1368321816-17719-15-git-send-email-kirill.shutemov@linux.intel.com>
 <519BD595.5040405@sr71.net>
 <20130528122812.0D624E0090@blue.fi.intel.com>
Subject: Re: [PATCHv4 14/39] thp, mm: rewrite delete_from_page_cache() to
 support huge pages
Content-Transfer-Encoding: 7bit
Message-Id: <20130607151025.241EFE0090@blue.fi.intel.com>
Date: Fri,  7 Jun 2013 18:10:25 +0300 (EEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kirill A. Shutemov wrote:
> Dave Hansen wrote:
> > Which reminds me...  Why do we handle their reference counts differently? :)
> > 
> > It seems like we could easily put a for loop in delete_from_page_cache()
> > that will release their reference counts along with the head page.
> > Wouldn't that make the code less special-cased for tail pages?
> 
> delete_from_page_cache() is not the only user of
> __delete_from_page_cache()...
> 
> It seems I did it wrong in add_to_page_cache_locked(). We shouldn't take
> references on tail pages there, only one on head. On split it will be
> distributed properly.

This way:

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index b267859..c2c0df2 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -1556,6 +1556,7 @@ static void __split_huge_page_refcount(struct page *page,
 	struct zone *zone = page_zone(page);
 	struct lruvec *lruvec;
 	int tail_count = 0;
+	int init_tail_refcount;
 
 	/* prevent PageLRU to go away from under us, and freeze lru stats */
 	spin_lock_irq(&zone->lru_lock);
@@ -1565,6 +1566,13 @@ static void __split_huge_page_refcount(struct page *page,
 	/* complete memcg works before add pages to LRU */
 	mem_cgroup_split_huge_fixup(page);
 
+	/*
+	 * When we add a huge page to page cache we take only reference to head
+	 * page, but on split we need to take addition reference to all tail
+	 * pages since they are still in page cache after splitting.
+	 */
+	init_tail_refcount = PageAnon(page) ? 0 : 1;
+
 	for (i = HPAGE_PMD_NR - 1; i >= 1; i--) {
 		struct page *page_tail = page + i;
 
@@ -1587,8 +1595,9 @@ static void __split_huge_page_refcount(struct page *page,
 		 * atomic_set() here would be safe on all archs (and
 		 * not only on x86), it's safer to use atomic_add().
 		 */
-		atomic_add(page_mapcount(page) + page_mapcount(page_tail) + 1,
-			   &page_tail->_count);
+		atomic_add(init_tail_refcount + page_mapcount(page) +
+				page_mapcount(page_tail) + 1,
+				&page_tail->_count);
 
 		/* after clearing PageTail the gup refcount can be released */
 		smp_mb();
-- 
 Kirill A. Shutemov
