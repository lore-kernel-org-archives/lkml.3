Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755219Ab3JHNaR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 09:30:17 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:22713 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754576Ab3JHNaH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 09:30:07 -0400
X-AuditID: cbfec7f5-b7ef66d00000795a-f7-525408dd1b00
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Seth Jennings <sjenning@linux.vnet.ibm.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Cc: Bob Liu <bob.liu@oracle.com>, Mel Gorman <mgorman@suse.de>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Tomasz Stanislawski <t.stanislaws@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Dave Hansen <dave.hansen@intel.com>, Minchan Kim <minchan@kernel.org>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH v3 3/6] mm: use mapcount for identifying zbud pages
Date: Tue, 08 Oct 2013 15:29:37 +0200
Message-id: <1381238980-2491-4-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1381238980-2491-1-git-send-email-k.kozlowski@samsung.com>
References: <1381238980-2491-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrCLMWRmVeSWpSXmKPExsVy+t/xa7p3OUKCDB60yVjMWb+GzWLjjPWs
	Fl2nprJYfHr5gNHi9QtDi7NNb9gtLu+aw2Zxb81/Vou1R+6yW0x+94zRYtnX9+wWh/atYreY
	1/6S1YHXY/Gel0wem1Z1snls+jSJ3ePEjN8sHg8ObWbx+Pj0FotH35ZVjB6bT1d7fN4kF8AZ
	xWWTkpqTWZZapG+XwJXR0LKLteCaYEVDw1GmBsbTfF2MnBwSAiYSK5vWsUDYYhIX7q1n62Lk
	4hASWMooMfvZFnaQhJBAH5NEQ28diM0mYCyxefkSNhBbRKCPUWLSZQuQBmaBf0wSE3ZcZgJJ
	CAs4S/y9chXMZhFQlbgwayrYBl4BN4mvaz4xdjFyAG1TkJgzyQbE5BRwl1hwUAJilZvE761P
	mCYw8i5gZFjFKJpamlxQnJSea6RXnJhbXJqXrpecn7uJERKyX3cwLj1mdYhRgINRiYdX4HBQ
	kBBrYllxZe4hRgkOZiURXr7/wUFCvCmJlVWpRfnxRaU5qcWHGJk4OKUaGBm/tMx9EKi2+0MM
	j2Mwy6+r8zd//HhC/7zMTv2lyxh9XeLOJa4OemEu29SuVfTWgl/PY0vJvLQH4k8u3NG/JStR
	fT+To9um0kQtxVhMpjL1T1lT/YIcu3Ohj45lapwL6F1mfuKRTsbxz0vtrL123e1+ae56+kaA
	RNWhtOgNPxd2Pj/aJfZotRJLcUaioRZzUXEiAAompII3AgAA
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
index 8b6e55e..4307429 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -447,6 +447,7 @@ static inline void init_page_count(struct page *page)
  * efficiently by most CPU architectures.
  */
 #define PAGE_BUDDY_MAPCOUNT_VALUE (-128)
+#define PAGE_ZBUD_MAPCOUNT_VALUE (-127)
 
 static inline int PageBuddy(struct page *page)
 {
@@ -465,6 +466,28 @@ static inline void __ClearPageBuddy(struct page *page)
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
index e19f36a..6db0557 100644
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

