Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750830Ab3IFFSo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Sep 2013 01:18:44 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:57668 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750720Ab3IFFSn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Sep 2013 01:18:43 -0400
X-AuditID: cbfee61b-b7f776d0000016c8-11-522965b12fec
From: Weijie Yang <weijie.yang@samsung.com>
To: sjenning@linux.vnet.ibm.com
Cc: minchan@kernel.org, bob.liu@oracle.com, weijie.yang.kh@gmail.com,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 2/4] mm/zswap: bugfix: memory leak when invalidate and
 reclaim occur concurrently
Date: Fri, 06 Sep 2013 13:16:45 +0800
Message-id: <000801ceaac0$8d1f6210$a75e2630$%yang@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac6qwCrgGsLM039cSAavEDy4Gq1GFg==
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrELMWRmVeSWpSXmKPExsVy+t9jQd1NqZpBBgtesFh0nZrKYnF51xw2
	i3tr/rNaLPv6nt3i0L5V7BZPTvxncWDz2DnrLrvHplWdbB6bPk1i93hwaDOLx8ent1g8Pm+S
	C2CL4rJJSc3JLEst0rdL4MrYdrmNseCyRMXlxc/ZGhgbRboYOTkkBEwkJp/awwxhi0lcuLee
	DcQWEpjOKDHrgR6E/YdR4uIzbhCbTUBb4m7/RlYQW0RAXmL3t+9gNrNAhcTzad/B5ggLpEnc
	PnYFbA6LgKrEsu+bwWxeATuJ3c/2skPYghI/Jt9j6WLkAOpVl5gyJRdijLzE5jVvmUHCEkDh
	R391QUwRAT2J13OZISrEJTYeucUygVFgFpI5sxDmzEIyZxaSjgWMLKsYRVMLkguKk9JzjfSK
	E3OLS/PS9ZLzczcxgkP+mfQOxlUNFocYBTgYlXh4OXo0goRYE8uKK3MPMUpwMCuJ8IpraAYJ
	8aYkVlalFuXHF5XmpBYfYpTmYFES5z3Yah0oJJCeWJKanZpakFoEk2Xi4JRqYIxn324+869y
	2NY0T5VMz/0bjl6Z7bc0K/FxnNAj1RUnXEWaapo3nP7XPlU++IRC7WHx/YueTemJPKScUuy8
	9yXj0c9nH+/cd4lbpDF9U+icp7IPPWI2JLgfX9Lj1v9bU/+FrNqa3hMveI/8CfQv3zah3FZG
	fUFM8/r8V4FRmXV/TsnctWK1kVRiKc5INNRiLipOBACj+VVWdQIAAA==
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


