Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753378Ab3IKI7u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 04:59:50 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:47123 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751758Ab3IKI7U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 04:59:20 -0400
X-AuditID: cbfec7f5-b7ef66d00000795a-2d-523030e39a30
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
Subject: [PATCH v2 3/5] mm: use mapcount for identifying zbud pages
Date: Wed, 11 Sep 2013 10:59:02 +0200
Message-id: <1378889944-23192-4-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1378889944-23192-1-git-send-email-k.kozlowski@samsung.com>
References: <1378889944-23192-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprLLMWRmVeSWpSXmKPExsVy+t/xq7qPDQyCDGacULSYs34Nm8XGGetZ
	LbpOTWWx+PTyAaPF6xeGFmeb3rBbXN41h83i3pr/rBZrj9xlt5j87hmjxbKv79ktDu1bxe7A
	47F4z0smj02rOtk8Nn2axO5xYsZvFo8HhzazeHx8eovFo2/LKkaPzaerPT5vkgvgjOKySUnN
	ySxLLdK3S+DK+NVynK3gmmDFuu5DjA2Mp/m6GDk5JARMJLqfdjJC2GISF+6tZwOxhQSWMkrc
	eGDexcgFZPcxSbyZ0MoMkmATMJbYvHwJWJGIQB+jxKTLFiBFzAJnmCSuLfnP3sXIwSEs4Cwx
	51I6iMkioCrxcjnYLl4Bd4kNE/rYQMISAgoScybZgJicAh4SJ6YpQGx1l+j8dY5tAiPvAkaG
	VYyiqaXJBcVJ6blGesWJucWleel6yfm5mxghQfp1B+PSY1aHGAU4GJV4eA0U9YOEWBPLiitz
	DzFKcDArifC+EjUIEuJNSaysSi3Kjy8qzUktPsTIxMEp1cBo4X3cb3Jr84TqEzZvL+tbszce
	PnD+a7zAnX2Cu63Yz7pq20i9Nuq+UirhP0utdUtVYq5i/vw3dkqCs9+uet/Q32Sb/co1cePN
	XJ63tvlX5F5NXR9a+Pawyv627SFFdk5iMrX8h/ry/FmNzb17KxL543Otbvb1sF6PUdxqf92e
	NW5bVKeYihJLcUaioRZzUXEiAMb3xHUwAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently zbud pages do not have any flags set so it is not possible to
identify them during migration or compaction.

Implement PageZbud() by comparing page->_mapcount to -127 to distinguish
pages allocated by zbud. Just like PageBuddy() is implemented.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Reviewed-by: Seth Jennings <sjenning@linux.vnet.ibm.com>
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
index 1d5b26b..9be160c 100644
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

