Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755864Ab3JNKMd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 06:12:33 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:9427 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753567Ab3JNKMb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 06:12:31 -0400
X-AuditID: cbfee61a-b7f7a6d00000235f-74-525bc38edaf1
From: Weijie Yang <weijie.yang@samsung.com>
To: akpm@linux-foundation.org
Cc: sjenning@linux.vnet.ibm.com, sjennings@variantweb.net,
        "'Minchan Kim'" <minchan@kernel.org>, bob.liu@oracle.com,
        weijie.yang.kh@gmail.com, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, stable@vger.kernel.org
Subject: [PATCH 1/2] mm/zswap: bugfix: memory leak when invalidate and reclaim
 occur concurrently
Date: Mon, 14 Oct 2013 18:11:11 +0800
Message-id: <000001cec8c5$e4231520$ac693f60$%yang@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac7IxbU+iflL6poRTFKa4FrW+JMliw==
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrLLMWRmVeSWpSXmKPExsVy+t9jAd2+w9FBBlNO8VvMWb+GzaLr1FQW
	i8u75rBZ3Fvzn9Vi2df37BaH9q1it/h09BGbxYKNjxgtnpz4z+LA6bFz1l12j02rOtk8Nn2a
	xO5xYsZvFo8HhzazeHx8eovF4/q3Io/Pm+QCOKK4bFJSczLLUov07RK4MnatmctS0Cpd0X30
	P1MDY4tYFyMnh4SAicTev29ZIGwxiQv31rN1MXJxCAksYpS40vGYCcL5wyjx5eNasCo2AW2J
	u/0bWUFsEQFZial/z7OAFDEL3GaUmPH9PxNIQlggWaJ3wTPmLkYODhYBVYlZm9hBwrwCdhLv
	rh1jhbAFJX5MvscCUsIsoC4xZUouSJhZQF5i85q3YJ0SQOFHf3UhNulJLNw7hxWiRFxi45Fb
	LBMYBWYhGTQLYdAsJINmIelYwMiyilE0tSC5oDgpPddQrzgxt7g0L10vOT93EyM4Up5J7WBc
	2WBxiFGAg1GJh1fAKTpIiDWxrLgy9xCjBAezkgiv4DygEG9KYmVValF+fFFpTmrxIUZpDhYl
	cd4DrdaBQgLpiSWp2ampBalFMFkmDk6pBsZtDxdHtp4xUj/8/qpD8wxVhWubvUuvxebtFL5j
	+GPJjzNpOUI8r26x+S81dnx9p/yslihb4LP/Aqsun9q5xXCx6kar1zE+T3NbgrXERFct4d3v
	bzjxzoOFIg/VtIqUZEK6a/4JXKsXvfDZyujRm8kfCmU77F4LNUxzyVUP+ehV0vxUvMlNZJES
	S3FGoqEWc1FxIgBvLYk9kAIAAA==
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
Cc: <stable@vger.kernel.org>
Acked-by: Seth Jennings <sjenning@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---
 mm/zswap.c |   22 ++++++++++++++--------
 1 file changed, 14 insertions(+), 8 deletions(-)
 mode change 100644 => 100755 mm/zswap.c

diff --git a/mm/zswap.c b/mm/zswap.c
old mode 100644
new mode 100755
index deda2b6..f25394a
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
@@ -401,9 +401,10 @@ enum zswap_get_swap_ret {
  * added to the swap cache, and returned in retpage.
  *
  * If success, the swap cache page is returned in retpage
- * Returns 0 if page was already in the swap cache, page is not locked
- * Returns 1 if the new page needs to be populated, page is locked
- * Returns <0 on error
+ * Returns ZSWAP_SWAPCACHE_EXIST if page was already in the swap cache
+ * Returns ZSWAP_SWAPCACHE_NEW if the new page needs to be populated,
+ * 	page is locked
+ * Returns ZSWAP_SWAPCACHE_FAIL on error
  */
 static int zswap_get_swap_cache_page(swp_entry_t entry,
 				struct page **retpage)
@@ -475,7 +476,7 @@ static int zswap_get_swap_cache_page(swp_entry_t entry,
 	if (new_page)
 		page_cache_release(new_page);
 	if (!found_page)
-		return ZSWAP_SWAPCACHE_NOMEM;
+		return ZSWAP_SWAPCACHE_FAIL;
 	*retpage = found_page;
 	return ZSWAP_SWAPCACHE_EXIST;
 }
@@ -529,11 +530,11 @@ static int zswap_writeback_entry(struct zbud_pool *pool, unsigned long handle)
 
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
@@ -591,7 +592,12 @@ static int zswap_writeback_entry(struct zbud_pool *pool, unsigned long handle)
 
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

