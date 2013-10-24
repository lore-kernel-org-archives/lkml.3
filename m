Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754802Ab3JXJxc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Oct 2013 05:53:32 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:56485 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754173Ab3JXJx3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Oct 2013 05:53:29 -0400
X-AuditID: cbfee61a-b7f836d0000025d7-14-5268ee18cd0c
From: Weijie Yang <weijie.yang@samsung.com>
To: akpm@linux-foundation.org
Cc: sjennings@variantweb.net, "'Minchan Kim'" <minchan@kernel.org>,
        bob.liu@oracle.com, weijie.yang.kh@gmail.com, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: =?utf-8?Q?=5BPATCH_RESEND_1/2=5D_mm/zswap:_bug?=
	=?utf-8?Q?fix:_memory_leak_when_invalidate?=
	=?utf-8?Q?_and_reclaim_occur_concurrent=E2=80=8Bly?=
Date: Thu, 24 Oct 2013 17:51:11 +0800
Message-id: <000001ced09e$e3718180$aa548480$%yang@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac7QnpH3khMzroo9Rn+e4idR4EVkow==
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrMLMWRmVeSWpSXmKPExsVy+t9jAV2JdxlBBie3ilnMWb+GzaLr1FQW
	i8u75rBZ3Fvzn9Vi2df37Bafjj5is1iw8RGjxZMT/1kcODx2zrrL7rFpVSebx6ZPk9g9Tsz4
	zeLx8ektFo/r34o8Pm+SC2CP4rJJSc3JLEst0rdL4MqYuXQWW8FK6Yrzn5exNzDOFeti5OSQ
	EDCRaPzVzwRhi0lcuLeerYuRi0NIYBGjxJdLIAkQ5w+jxPeGTSwgVWwC2hJ3+zeygtgiArIS
	U/+eZwEpYhbYwyix4U0LWIewwHxGiak324BmcXCwCKhK/N1iCWLyCthJTJhTDdLLKyAo8WPy
	PRaQMLOAusSUKbkgYWYBeYnNa94yg4QlgMKP/upCbNKT6Jw5kRGiRFxi45FbLBMYBWYhGTQL
	YdAsJINmIelYwMiyilE0tSC5oDgpPddQrzgxt7g0L10vOT93EyM4Kp5J7WBc2WBxiFGAg1GJ
	h1fjQ3qQEGtiWXFl7iFGCQ5mJRFez4qMICHelMTKqtSi/Pii0pzU4kOM0hwsSuK8B1qtA4UE
	0hNLUrNTUwtSi2CyTBycUg2MKxfsuJ6zZ54uZ3p1cWox117WcqWy+1dTvq5WuHvUgIkt7N2k
	v8+z92VZirqZPvt09/fbI/WWihsnvLHJfnFK3etZ2OS3bqyWAoon2933Pf0R8LrzYFyOWMHs
	c/u+vM69ZuQ185nToxWb1vCn/pTc3j5zfZpRi/gVz1WNwavzQi4UB0ltueX6QomlOCPRUIu5
	qDgRABOa1N+GAgAA
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
index d93510c..6b86251
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
+ *     the new page is added to swapcache and locked
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


