Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753556AbaACTzp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jan 2014 14:55:45 -0500
Received: from mx1.redhat.com ([209.132.183.28]:34075 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752436AbaACTzm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jan 2014 14:55:42 -0500
Date: Fri, 3 Jan 2014 20:55:47 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrea Arcangeli <aarcange@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Dave Jones <davej@redhat.com>, Darren Hart <dvhart@linux.intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Mel Gorman <mgorman@suse.de>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: [PATCH v2 1/1] mm: fix the theoretical compound_lock() vs
	prep_new_page() race
Message-ID: <20140103195547.GB26555@redhat.com>
References: <20131211191855.GA32485@redhat.com> <20131213151035.GE5408@redhat.com> <20131213162240.GA11762@redhat.com> <20131213173406.GG5408@redhat.com> <20131216183618.GA28252@redhat.com> <20131216201952.GE21218@redhat.com> <20131219190846.GA24566@redhat.com> <20131219190920.GB24566@redhat.com> <20131223114300.GC727@redhat.com> <20140103195519.GA26555@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140103195519.GA26555@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

get/put_page(thp_tail) paths do get_page_unless_zero(page_head) +
compound_lock(). In theory this page_head can be already freed and
reallocated as alloc_pages(__GFP_COMP, smaller_order). In this case
get_page_unless_zero() can succeed right after set_page_refcounted(),
and compound_lock() can race with the non-atomic __SetPageHead().

Perhaps we should rework the thp locking (under discussion), but
until then this patch moves set_page_refcounted() and adds wmb()
to ensure that page->_count != 0 comes as a last change.

I am not sure about other callers of set_page_refcounted(), but at
first glance they look fine to me.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: Andrea Arcangeli <aarcange@redhat.com>
---
 mm/page_alloc.c |   12 ++++++++++--
 1 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 115b23b..d323102 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -865,8 +865,6 @@ static int prep_new_page(struct page *page, int order, gfp_t gfp_flags)
 	}
 
 	set_page_private(page, 0);
-	set_page_refcounted(page);
-
 	arch_alloc_page(page, order);
 	kernel_map_pages(page, 1 << order, 1);
 
@@ -876,6 +874,16 @@ static int prep_new_page(struct page *page, int order, gfp_t gfp_flags)
 	if (order && (gfp_flags & __GFP_COMP))
 		prep_compound_page(page, order);
 
+	/*
+	 * Make sure the caller of get_page_unless_zero() will see the
+	 * fully initialized page. Say, to ensure that compound_lock()
+	 * can't race with the non-atomic __SetPage*() above.
+	 */
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
+	smp_wmb();
+#endif
+	set_page_refcounted(page);
+
 	return 0;
 }
 
-- 
1.5.5.1


