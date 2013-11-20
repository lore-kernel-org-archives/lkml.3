Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754899Ab3KTR40 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 12:56:26 -0500
Received: from mx1.redhat.com ([209.132.183.28]:20664 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753354Ab3KTRvu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 12:51:50 -0500
From: Andrea Arcangeli <aarcange@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Khalid Aziz <khalid.aziz@oracle.com>,
        Pravin Shelar <pshelar@nicira.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ben Hutchings <bhutchings@solarflare.com>,
        Christoph Lameter <cl@linux.com>, Johannes Weiner <jweiner@redhat.com>,
        Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>,
        Andi Kleen <andi@firstfloor.org>, Minchan Kim <minchan@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 4/8] mm: thp: optimize compound_trans_huge
Date: Wed, 20 Nov 2013 18:51:12 +0100
Message-Id: <1384969876-6374-5-git-send-email-aarcange@redhat.com>
In-Reply-To: <1384969876-6374-1-git-send-email-aarcange@redhat.com>
References: <1384969876-6374-1-git-send-email-aarcange@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently we don't clobber page_tail->first_page during
split_huge_page, so compound_trans_head can be set to compound_head
without adverse effects, and this mostly optimizes away a smp_rmb.

It looks worthwhile to keep around the implementation that doesn't
relay on page_tail->first_page not to be clobbered, because it would
be necessary if we'll decide to enforce page->private to zero at all
times whenever PG_private is not set, also for anonymous pages. For
anonymous pages enforcing such an invariant doesn't matter as
anonymous pages don't use page->private so we can get away with this
microoptimization.

Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
---
 include/linux/huge_mm.h | 23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
index 91672e2..db51201 100644
--- a/include/linux/huge_mm.h
+++ b/include/linux/huge_mm.h
@@ -157,6 +157,26 @@ static inline int hpage_nr_pages(struct page *page)
 		return HPAGE_PMD_NR;
 	return 1;
 }
+/*
+ * compound_trans_head() should be used instead of compound_head(),
+ * whenever the "page" passed as parameter could be the tail of a
+ * transparent hugepage that could be undergoing a
+ * __split_huge_page_refcount(). The page structure layout often
+ * changes across releases and it makes extensive use of unions. So if
+ * the page structure layout will change in a way that
+ * page->first_page gets clobbered by __split_huge_page_refcount, the
+ * implementation making use of smp_rmb() will be required.
+ *
+ * Currently we define compound_trans_head as compound_head, because
+ * page->private is in the same union with page->first_page, and
+ * page->private isn't clobbered. However this also means we're
+ * currently leaving dirt into the page->private field of anonymous
+ * pages resulting from a THP split, instead of setting page->private
+ * to zero like for every other page that has PG_private not set. But
+ * anonymous pages don't use page->private so this is not a problem.
+ */
+#if 0
+/* This will be needed if page->private will be clobbered in split_huge_page */
 static inline struct page *compound_trans_head(struct page *page)
 {
 	if (PageTail(page)) {
@@ -174,6 +194,9 @@ static inline struct page *compound_trans_head(struct page *page)
 	}
 	return page;
 }
+#else
+#define compound_trans_head(page) compound_head(page)
+#endif
 
 extern int do_huge_pmd_numa_page(struct mm_struct *mm, struct vm_area_struct *vma,
 				unsigned long addr, pmd_t pmd, pmd_t *pmdp);
