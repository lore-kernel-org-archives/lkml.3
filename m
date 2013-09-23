Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753472Ab3IWIY0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 04:24:26 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:57406 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752638Ab3IWIYY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 04:24:24 -0400
X-AuditID: cbfee61a-b7f7a6d00000235f-82-523ffab795b6
From: Weijie Yang <weijie.yang@samsung.com>
To: akpm@linux-foundation.org
Cc: sjenning@linux.vnet.ibm.com, bob.liu@oracle.com, minchan@kernel.org,
        weijie.yang.kh@gmail.com, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        d.j.shin@samsung.com, heesub.shin@samsung.com,
        kyungmin.park@samsung.com, hau.chen@samsung.com,
        bifeng.tong@samsung.com, rui.xie@samsung.com
Subject: [PATCH v3 2/3] mm/zswap: bugfix: memory leak when invalidate and
 reclaim occur concurrently
Date: Mon, 23 Sep 2013 16:21:49 +0800
Message-id: <000201ceb836$4c549740$e4fdc5c0$%yang@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac64NeGGhImMztsRQey0939UCK6wew==
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprKIsWRmVeSWpSXmKPExsVy+t9jQd3tv+yDDL4fEbWYs34Nm8Wb1tts
	Fl2nprJYnLhYa3H18jJGi4OzlzBZnG16w25xedccNot7a/6zWiz7+p7d4uHT6+wWh/atYrdY
	sPERo8WTE/9ZHPg8ds66y+6xaVUnm8emT5PYPU7M+M3i8eDQZhaPj09vsXj0bVnF6PF5k1wA
	RxSXTUpqTmZZapG+XQJXxv5/+1gKfkpWvHvQz9LAOFm0i5GTQ0LAROLi5QlsELaYxIV764Fs
	Lg4hgemMEhP6DrFDOH8YJX6t38cIUsUmoC1xt38jK4gtIiArMfXveRYQm1ngIJPE3E38ILaw
	QJrEydXHwepZBFQl5v3fBWRzcPAK2En8/hMAEuYVEJT4MfkeC0iYWUBdYsqUXIgp8hKb17xl
	BglLAIUf/dWFWKQn0fnpASNEibjExiO3WCYwCsxCMmgWwqBZSAbNQtKxgJFlFaNoakFyQXFS
	eq6hXnFibnFpXrpecn7uJkZwZD2T2sG4ssHiEKMAB6MSD29Eon2QEGtiWXFl7iFGCQ5mJRHe
	pk6gEG9KYmVValF+fFFpTmrxIUZpDhYlcd4DrdaBQgLpiSWp2ampBalFMFkmDk6pBkbGlsTz
	IomHzrfueKPpWblzylOpOl85I5XJF8yePml7INTy/pd/yS/zqRuOTfhl2XykyUmEO1nxleDR
	Z8f7Cw4EpC1ftPN5nYdHQNnDfT9Wdtke3NCQEsvuxcxed+tomcmUaReV9mreLzXbu9vexDsv
	92/l/slmcn+ZjlfdmBC6dI9IkxCr3i8lluKMREMt5qLiRACis6WtqAIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Consider the following scenario:
thread 0: reclaim entry x (get refcount, but not call zswap_get_swap_cache_page)
thread 1: call zswap_frontswap_invalidate_page to invalidate entry x.
	finished, entry x and its zbud is not freed as its refcount != 0
	now, the swap_map[x] = 0
thread 0: now call zswap_get_swap_cache_page
	swapcache_prepare return -ENOENT because entry x is not used any more
	zswap_get_swap_cache_page return ZSWAP_SWAPCACHE_NOMEM
	zswap_writeback_entry do nothing except put refcount
Now, the memory of zswap_entry x and its zpage leak.

Modify:
 - check the refcount in fail path, free memory if it is not referenced.
 - use ZSWAP_SWAPCACHE_FAIL instead of ZSWAP_SWAPCACHE_NOMEM as the fail path
can be not only caused by nomem but also by invalidate.

Signed-off-by: Weijie Yang <weijie.yang@samsung.com>
Reviewed-by: Bob Liu <bob.liu@oracle.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: stable@vger.kernel.org
Acked-by: Seth Jennings <sjenning@linux.vnet.ibm.com>
---
 mm/zswap.c |   21 +++++++++++++--------
 1 file changed, 13 insertions(+), 8 deletions(-)

diff --git a/mm/zswap.c b/mm/zswap.c
index cbd9578..1be7b90 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -387,7 +387,7 @@ static void zswap_free_entry(struct zswap_tree *tree, struct zswap_entry *entry)
 enum zswap_get_swap_ret {
 	ZSWAP_SWAPCACHE_NEW,
 	ZSWAP_SWAPCACHE_EXIST,
-	ZSWAP_SWAPCACHE_NOMEM
+	ZSWAP_SWAPCACHE_FAIL,
 };
 
 /*
@@ -401,9 +401,9 @@ enum zswap_get_swap_ret {
  * added to the swap cache, and returned in retpage.
  *
  * If success, the swap cache page is returned in retpage
- * Returns 0 if page was already in the swap cache, page is not locked
- * Returns 1 if the new page needs to be populated, page is locked
- * Returns <0 on error
+ * Returns ZSWAP_SWAPCACHE_EXIST if page was already in the swap cache
+ * Returns ZSWAP_SWAPCACHE_NEW if the new page needs to be populated, page is locked
+ * Returns ZSWAP_SWAPCACHE_FAIL on error
  */
 static int zswap_get_swap_cache_page(swp_entry_t entry,
 				struct page **retpage)
@@ -475,7 +475,7 @@ static int zswap_get_swap_cache_page(swp_entry_t entry,
 	if (new_page)
 		page_cache_release(new_page);
 	if (!found_page)
-		return ZSWAP_SWAPCACHE_NOMEM;
+		return ZSWAP_SWAPCACHE_FAIL;
 	*retpage = found_page;
 	return ZSWAP_SWAPCACHE_EXIST;
 }
@@ -529,11 +529,11 @@ static int zswap_writeback_entry(struct zbud_pool *pool, unsigned long handle)
 
 	/* try to allocate swap cache page */
 	switch (zswap_get_swap_cache_page(swpentry, &page)) {
-	case ZSWAP_SWAPCACHE_NOMEM: /* no memory */
+	case ZSWAP_SWAPCACHE_FAIL: /* no memory or invalidate happened */
 		ret = -ENOMEM;
 		goto fail;
 
-	case ZSWAP_SWAPCACHE_EXIST: /* page is unlocked */
+	case ZSWAP_SWAPCACHE_EXIST:
 		/* page is already in the swap cache, ignore for now */
 		page_cache_release(page);
 		ret = -EEXIST;
@@ -591,7 +591,12 @@ static int zswap_writeback_entry(struct zbud_pool *pool, unsigned long handle)
 
 fail:
 	spin_lock(&tree->lock);
-	zswap_entry_put(entry);
+	refcount = zswap_entry_put(entry);
+	if (refcount <= 0) {
+		/* invalidate happened, consider writeback as success */
+		zswap_free_entry(tree, entry);
+		ret = 0;
+	}
 	spin_unlock(&tree->lock);
 	return ret;
 }
-- 
1.7.10.4


