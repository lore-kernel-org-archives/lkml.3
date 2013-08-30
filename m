Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755081Ab3H3Inf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Aug 2013 04:43:35 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:11692 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753786Ab3H3Inb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Aug 2013 04:43:31 -0400
X-AuditID: cbfec7f4-b7f0a6d000007b1b-dd-52205b305c9f
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Seth Jennings <sjenning@linux.vnet.ibm.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Cc: Bob Liu <bob.liu@oracle.com>, Mel Gorman <mgorman@suse.de>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Dave Hansen <dave.hansen@intel.com>, Minchan Kim <minchan@kernel.org>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [RFC PATCH 2/4] mm: use mapcount for identifying zbud pages
Date: Fri, 30 Aug 2013 10:42:54 +0200
Message-id: <1377852176-30970-3-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1377852176-30970-1-git-send-email-k.kozlowski@samsung.com>
References: <1377852176-30970-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprPLMWRmVeSWpSXmKPExsVy+t/xq7oG0QpBBkvm81nMWb+GzWLjjPWs
	Fl2nprJYfHr5gNHi9QtDi7NNb9gtLu+aw2Zxb81/Vou1R+6yW0x+94zRYtnX9+wWh/atYnfg
	8Vi85yWTx6ZVnWwemz5NYvc4MeM3i8eDQ5tZPD4+vcXi0bdlFaPH5tPVHp83yQVwRnHZpKTm
	ZJalFunbJXBlPPnVxlIwR7BiUsN85gbGaXxdjJwcEgImEg0t11khbDGJC/fWs4HYQgJLGSUm
	XNeHsPuYJCbf9wax2QSMJTYvXwJWIyLQxygx6bJFFyMXB7PAGSaJa0v+s4MkhAVcJP6t/swI
	YrMIqEo8f9wOtoBXwF3i5bZPzF2MHEDLFCTmTLIBCXMKeEi0vTjHBLHLXWLa/J1MExh5FzAy
	rGIUTS1NLihOSs811CtOzC0uzUvXS87P3cQICdQvOxgXH7M6xCjAwajEw/sgWD5IiDWxrLgy
	9xCjBAezkgivgK5CkBBvSmJlVWpRfnxRaU5q8SFGJg5OqQbGlVHBJkyH1ln2zmTgcUjRvtQp
	ZSkaoOc+der3adfmfbWvMmRKmxSwRZS99FC3tpJ2Y4D1k8lLJ++UfC1zbU1N7HN7PdP1C6LN
	n1uL2/o2JJrI54ndPmX1xL5g/qOY84fms95ewMYg4v/6m/8OwxD5gsetz7y/ZjF/O3w0RUe1
	/QLrpNtNGtVKLMUZiYZazEXFiQBbJTZnMgIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently zbud pages do not have any flags set so it is not possible to
identify them during migration or compaction.

Implement PageZbud() by comparing page->_mapcount to -127 to distinguish
pages allocated by zbud. Just like PageBuddy() is implemented.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
---
 include/linux/mm.h |   23 +++++++++++++++++++++++
 mm/zbud.c          |    4 ++++
 2 files changed, 27 insertions(+)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index f022460..b9ae6f2 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -440,6 +440,7 @@ static inline void init_page_count(struct page *page)
  * efficiently by most CPU architectures.
  */
 #define PAGE_BUDDY_MAPCOUNT_VALUE (-128)
+#define PAGE_ZBUD_MAPCOUNT_VALUE (-127)
 
 static inline int PageBuddy(struct page *page)
 {
@@ -458,6 +459,28 @@ static inline void __ClearPageBuddy(struct page *page)
 	atomic_set(&page->_mapcount, -1);
 }
 
+#ifdef CONFIG_ZBUD
+static inline int PageZbud(struct page *page)
+{
+	return atomic_read(&page->_mapcount) == PAGE_ZBUD_MAPCOUNT_VALUE;
+}
+
+static inline void SetPageZbud(struct page *page)
+{
+	VM_BUG_ON(atomic_read(&page->_mapcount) != -1);
+	atomic_set(&page->_mapcount, PAGE_ZBUD_MAPCOUNT_VALUE);
+}
+
+static inline void ClearPageZbud(struct page *page)
+{
+	VM_BUG_ON(!PageZbud(page));
+	atomic_set(&page->_mapcount, -1);
+}
+#else
+PAGEFLAG_FALSE(Zbud)
+#endif
+
+
 void put_page(struct page *page);
 void put_pages_list(struct list_head *pages);
 
diff --git a/mm/zbud.c b/mm/zbud.c
index aa9a15c..9267cd9 100644
--- a/mm/zbud.c
+++ b/mm/zbud.c
@@ -197,7 +197,10 @@ static void get_zbud_page(struct zbud_header *zhdr)
 static int put_zbud_page(struct zbud_header *zhdr)
 {
 	struct page *page = virt_to_page(zhdr);
+	VM_BUG_ON(!PageZbud(page));
+
 	if (put_page_testzero(page)) {
+		ClearPageZbud(page);
 		free_hot_cold_page(page, 0);
 		return 1;
 	}
@@ -307,6 +310,7 @@ int zbud_alloc(struct zbud_pool *pool, int size, gfp_t gfp,
 	 * don't increase the page count.
 	 */
 	zhdr = init_zbud_page(page);
+	SetPageZbud(page);
 	bud = FIRST;
 
 found:
-- 
1.7.9.5

