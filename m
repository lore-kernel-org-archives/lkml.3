Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966792Ab3HIKWy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Aug 2013 06:22:54 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:40725 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966672Ab3HIKWh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Aug 2013 06:22:37 -0400
X-AuditID: cbfec7f4-b7f5f6d000000ff6-12-5204c2eaf397
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Seth Jennings <sjenning@linux.vnet.ibm.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Cc: Mel Gorman <mgorman@suse.de>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Dave Hansen <dave.hansen@intel.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [RFC PATCH v2 3/4] mm: use mapcount for identifying zbud pages
Date: Fri, 09 Aug 2013 12:22:19 +0200
Message-id: <1376043740-10576-4-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1376043740-10576-1-git-send-email-k.kozlowski@samsung.com>
References: <1376043740-10576-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupmluLIzCtJLcpLzFFi42I5/e/4Nd1Xh1iCDJZu5reYs34Nm8XGGetZ
	LT69fMBo8fqFocXZpjfsFpd3zWGzuLfmP6vF2iN32S0mv3vGaHFo3yp2By6PxXteMnls+jSJ
	3ePEjN8sHg8ObWbx6NuyitFj8+lqj8+b5ALYo7hsUlJzMstSi/TtErgyfvQ+Yyo4JFixe/FC
	lgbGHXxdjJwcEgImEn93bWaFsMUkLtxbzwZiCwksZZQ4eSsAwu5jkpj3xhnEZhMwlti8fAlY
	jYhAH6PEpMsWXYxcHMwCPUwS799MZgRJCAu4S0xsawIbyiKgKjF3+0IWEJsXKL63ZS1QDQfQ
	MgWJOZNsQMKcAh4Sd98cYIbY5S7xbt88xgmMvAsYGVYxiqaWJhcUJ6XnGuoVJ+YWl+al6yXn
	525ihATglx2Mi49ZHWIU4GBU4uE9sYU5SIg1say4MvcQowQHs5II7/YJLEFCvCmJlVWpRfnx
	RaU5qcWHGJk4OKUaGFsszIvdb5zyeToz7eHDDyoq/658jaj6qxeesCHt74vo+X0NkssVPr2b
	8ux8gerK2+tOnOLdv9p+8fu2l1mztPQM6o5xhl27vbtjW3eaRvYhvnAd/z8qkRe4ey5wf+vc
	pH9tyxnNXk2xgheLbgXJJZ488pdn3a49MyeUvTHW0zOapHXBxzu/MkiJpTgj0VCLuag4EQAD
	8dIpHgIAAA==
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
index 52f6ba1..24c9ba0 100644
--- a/mm/zbud.c
+++ b/mm/zbud.c
@@ -199,7 +199,10 @@ static void get_zbud_page(struct zbud_header *zhdr)
 static int put_zbud_page(struct zbud_pool *pool, struct zbud_header *zhdr)
 {
 	struct page *page = virt_to_page(zhdr);
+	BUG_ON(!PageZbud(page));
+
 	if (put_page_testzero(page)) {
+		ClearPageZbud(page);
 		free_hot_cold_page(page, 0);
 		pool->pages_nr--;
 		return 1;
@@ -310,6 +313,7 @@ int zbud_alloc(struct zbud_pool *pool, int size, gfp_t gfp,
 	 * don't increase the page count.
 	 */
 	zhdr = init_zbud_page(page);
+	SetPageZbud(page);
 	bud = FIRST;
 
 found:
-- 
1.7.9.5

