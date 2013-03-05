Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752997Ab3CEG6v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 01:58:51 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:35667 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752846Ab3CEG6n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 01:58:43 -0500
X-AuditID: cbfee61a-b7f7d6d000000f4e-52-513597a22ed6
From: Marek Szyprowski <m.szyprowski@samsung.com>
To: linux-mm@kvack.org, linaro-mm-sig@lists.linaro.org,
        linux-kernel@vger.kernel.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
        Michal Nazarewicz <mina86@mina86.com>,
        Minchan Kim <minchan@kernel.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Subject: [RFC/PATCH 4/5] mm: get_user_pages: migrate out CMA pages when
 FOLL_DURABLE flag is set
Date: Tue, 05 Mar 2013 07:57:58 +0100
Message-id: <1362466679-17111-5-git-send-email-m.szyprowski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1362466679-17111-1-git-send-email-m.szyprowski@samsung.com>
References: <1362466679-17111-1-git-send-email-m.szyprowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrFLMWRmVeSWpSXmKPExsVy+t9jQd1F000DDX6e47CYs34Nm8XfScfY
	LTbOWM9qcbbpDbvFlysPmSwu75rDZnFvzX9Wi7VH7rJb/D7YyW6x4HgLq8Wyr+/ZHbg9fv+a
	xOjRu/crq8emVZ1sHps+TWL3ODHjN4vH7X+PmT3W/XnF5NG3ZRWjx+dNcgGcUVw2Kak5mWWp
	Rfp2CVwZXxaVF+wQr5g/z7aB8bFQFyMnh4SAiURn9z5GCFtM4sK99WxdjFwcQgLTGSWuPVvF
	DuG0M0lc37eXBaSKTcBQouttFxuILSIQJvGncRsrSBGzwHEmiT8X14IlhAWSJN4duQxmswio
	SvTs3w1m8wp4SJx83wdkcwCtU5CYM8kGJMwp4CnxZPlHsPlCQCXztn1mmsDIu4CRYRWjaGpB
	ckFxUnquoV5xYm5xaV66XnJ+7iZGcIg+k9rBuLLB4hCjAAejEg8vw1GTQCHWxLLiytxDjBIc
	zEoivGJ1poFCvCmJlVWpRfnxRaU5qcWHGKU5WJTEeRlPPQkQEkhPLEnNTk0tSC2CyTJxcEo1
	MJauPWRh7VAzRW5aoJ/P1F9VETr57mtqJhvxqUVXzD1YHq/lfKM1v67ZpuWmV9REj7Djh6ZJ
	PjMx65uye5PIpy/mUquWy5lf3OriUy+kXRR1+mnH0x3C6VOdmcOcpn7v2nxskQOvnOGES/2/
	RXZ8uL2QZ/7s0xIbl7i8jZmibvid+6/LK5eoI0osxRmJhlrMRcWJAO6lV7JNAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When __get_user_pages() is called with FOLL_DURABLE flag, ensure that no
page in CMA pageblocks gets locked. This workarounds the permanent
migration failures caused by locking the pages by get_user_pages() call for
a long period of time.

Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 mm/internal.h |   12 ++++++++++++
 mm/memory.c   |   43 +++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 55 insertions(+)

diff --git a/mm/internal.h b/mm/internal.h
index 8562de0..a290d04 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -105,6 +105,18 @@ extern void prep_compound_page(struct page *page, unsigned long order);
 extern bool is_free_buddy_page(struct page *page);
 #endif
 
+#ifdef CONFIG_CMA
+static inline int is_cma_page(struct page *page)
+{
+	unsigned mt = get_pageblock_migratetype(page);
+	if (mt == MIGRATE_ISOLATE || mt == MIGRATE_CMA)
+		return true;
+	return false;
+}
+#else
+#define is_cma_page(page) 0
+#endif
+
 #if defined CONFIG_COMPACTION || defined CONFIG_CMA
 
 /*
diff --git a/mm/memory.c b/mm/memory.c
index 2b9c2dd..f81b273 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -1650,6 +1650,45 @@ static inline int stack_guard_page(struct vm_area_struct *vma, unsigned long add
 }
 
 /**
+ * replace_cma_page() - migrate page out of CMA page blocks
+ * @page:	source page to be migrated
+ *
+ * Returns either the old page (if migration was not possible) or the pointer
+ * to the newly allocated page (with additional reference taken).
+ *
+ * get_user_pages() might take a reference to a page for a long period of time,
+ * what prevent such page from migration. This is fatal to the preffered usage
+ * pattern of CMA pageblocks. This function replaces the given user page with
+ * a new one allocated from NON-MOVABLE pageblock, so locking CMA page can be
+ * avoided.
+ */
+static inline struct page *migrate_replace_cma_page(struct page *page)
+{
+	struct page *newpage = alloc_page(GFP_HIGHUSER);
+
+	if (!newpage)
+		goto out;
+
+	/*
+	 * Take additional reference to the new page to ensure it won't get
+	 * freed after migration procedure end.
+	 */
+	get_page_foll(newpage);
+
+	if (migrate_replace_page(page, newpage) == 0)
+		return newpage;
+
+	put_page(newpage);
+	__free_page(newpage);
+out:
+	/*
+	 * Migration errors in case of get_user_pages() might not
+	 * be fatal to CMA itself, so better don't fail here.
+	 */
+	return page;
+}
+
+/**
  * __get_user_pages() - pin user pages in memory
  * @tsk:	task_struct of target task
  * @mm:		mm_struct of target mm
@@ -1884,6 +1923,10 @@ long __get_user_pages(struct task_struct *tsk, struct mm_struct *mm,
 			}
 			if (IS_ERR(page))
 				return i ? i : PTR_ERR(page);
+
+			if ((gup_flags & FOLL_DURABLE) && is_cma_page(page))
+				page = migrate_replace_cma_page(page);
+
 			if (pages) {
 				pages[i] = page;
 
-- 
1.7.9.5

