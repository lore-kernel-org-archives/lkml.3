Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755387Ab3JHNb7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 09:31:59 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:22713 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752386Ab3JHNaD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 09:30:03 -0400
X-AuditID: cbfec7f5-b7ef66d00000795a-c8-525408d86a1a
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
Subject: [PATCH v3 1/6] zbud: use page ref counter for zbud pages
Date: Tue, 08 Oct 2013 15:29:35 +0200
Message-id: <1381238980-2491-2-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1381238980-2491-1-git-send-email-k.kozlowski@samsung.com>
References: <1381238980-2491-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrELMWRmVeSWpSXmKPExsVy+t/xa7o3OEKCDLb3aVjMWb+GzWLjjPWs
	Fl2nprJYfHr5gNHi9QtDi7NNb9gtLu+aw2Zxb81/Vou1R+6yW0x+94zRYtnX9+wWh/atYreY
	1/6S1YHXY/Gel0wem1Z1snls+jSJ3ePEjN8sHg8ObWbx+Pj0FotH35ZVjB6bT1d7fN4kF8AZ
	xWWTkpqTWZZapG+XwJVxou8FS8Fyp4qDr+wbGDeZdDFyckgImEjMbZ/HBGGLSVy4t54NxBYS
	WMoocb3bD8LuY5L4+kUSxGYTMJbYvHwJWI2IQB+jxKTLFl2MXBzMAv+YJCbsuAw2SFjAUWLG
	5eusIDaLgKrErG0P2EFsXgE3iXOfHgLZHEDLFCTmTLIBMTkF3CUWHJSAWOUm8XvrE6YJjLwL
	GBlWMYqmliYXFCel5xrpFSfmFpfmpesl5+duYoSE69cdjEuPWR1iFOBgVOLhFTgcFCTEmlhW
	XJl7iFGCg1lJhJfvf3CQEG9KYmVValF+fFFpTmrxIUYmDk6pBkb2ik1BoZ8mmP7zTDTas29K
	LJNbf2bprPaVOqUcGq0Fp+5YND56UNAmcmvzspxyb2nlDwtDledzzzps7iXyWW6e/5y8zXJd
	z1Z6FGUL/j/weYv9LYHD1nvfnL332v5036w839dLUxaGhO88b63pM+d6+aSzE0OPnLmineSl
	KL+kd4+TvOnanndKLMUZiYZazEXFiQD3bJJoNQIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use page reference counter for zbud pages. The ref counter replaces
zbud_header.under_reclaim flag and ensures that zbud page won't be freed
when zbud_free() is called during reclaim. It allows implementation of
additional reclaim paths.

The page count is incremented when:
 - a handle is created and passed to zswap (in zbud_alloc()),
 - user-supplied eviction callback is called (in zbud_reclaim_page()).

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Signed-off-by: Tomasz Stanislawski <t.stanislaws@samsung.com>
Reviewed-by: Bob Liu <bob.liu@oracle.com>
---
 mm/zbud.c |  117 +++++++++++++++++++++++++++++++++----------------------------
 1 file changed, 64 insertions(+), 53 deletions(-)

diff --git a/mm/zbud.c b/mm/zbud.c
index 9451361..7574289 100644
--- a/mm/zbud.c
+++ b/mm/zbud.c
@@ -109,7 +109,6 @@ struct zbud_header {
 	struct list_head lru;
 	unsigned int first_chunks;
 	unsigned int last_chunks;
-	bool under_reclaim;
 };
 
 /*****************
@@ -138,16 +137,9 @@ static struct zbud_header *init_zbud_page(struct page *page)
 	zhdr->last_chunks = 0;
 	INIT_LIST_HEAD(&zhdr->buddy);
 	INIT_LIST_HEAD(&zhdr->lru);
-	zhdr->under_reclaim = 0;
 	return zhdr;
 }
 
-/* Resets the struct page fields and frees the page */
-static void free_zbud_page(struct zbud_header *zhdr)
-{
-	__free_page(virt_to_page(zhdr));
-}
-
 /*
  * Encodes the handle of a particular buddy within a zbud page
  * Pool lock should be held as this function accesses first|last_chunks
@@ -188,6 +180,31 @@ static int num_free_chunks(struct zbud_header *zhdr)
 	return NCHUNKS - zhdr->first_chunks - zhdr->last_chunks - 1;
 }
 
+/*
+ * Increases ref count for zbud page.
+ */
+static void get_zbud_page(struct zbud_header *zhdr)
+{
+	get_page(virt_to_page(zhdr));
+}
+
+/*
+ * Decreases ref count for zbud page and frees the page if it reaches 0
+ * (no external references, e.g. handles).
+ *
+ * Returns 1 if page was freed and 0 otherwise.
+ */
+static int put_zbud_page(struct zbud_header *zhdr)
+{
+	struct page *page = virt_to_page(zhdr);
+	if (put_page_testzero(page)) {
+		free_hot_cold_page(page, 0);
+		return 1;
+	}
+	return 0;
+}
+
+
 /*****************
  * API Functions
 *****************/
@@ -273,6 +290,7 @@ int zbud_alloc(struct zbud_pool *pool, int size, gfp_t gfp,
 				bud = FIRST;
 			else
 				bud = LAST;
+			get_zbud_page(zhdr);
 			goto found;
 		}
 	}
@@ -284,6 +302,10 @@ int zbud_alloc(struct zbud_pool *pool, int size, gfp_t gfp,
 		return -ENOMEM;
 	spin_lock(&pool->lock);
 	pool->pages_nr++;
+	/*
+	 * We will be using zhdr instead of page, so
+	 * don't increase the page count.
+	 */
 	zhdr = init_zbud_page(page);
 	bud = FIRST;
 
@@ -318,10 +340,11 @@ found:
  * @pool:	pool in which the allocation resided
  * @handle:	handle associated with the allocation returned by zbud_alloc()
  *
- * In the case that the zbud page in which the allocation resides is under
- * reclaim, as indicated by the PG_reclaim flag being set, this function
- * only sets the first|last_chunks to 0.  The page is actually freed
- * once both buddies are evicted (see zbud_reclaim_page() below).
+ * This function sets first|last_chunks to 0, removes zbud header from
+ * appropriate lists (LRU, buddied/unbuddied) and puts the reference count
+ * for it. The page is actually freed once both buddies are evicted
+ * (zbud_free() called on both handles or page reclaim in zbud_reclaim_page()
+ * below).
  */
 void zbud_free(struct zbud_pool *pool, unsigned long handle)
 {
@@ -337,19 +360,11 @@ void zbud_free(struct zbud_pool *pool, unsigned long handle)
 	else
 		zhdr->first_chunks = 0;
 
-	if (zhdr->under_reclaim) {
-		/* zbud page is under reclaim, reclaim will free */
-		spin_unlock(&pool->lock);
-		return;
-	}
-
 	/* Remove from existing buddy list */
 	list_del(&zhdr->buddy);
 
 	if (zhdr->first_chunks == 0 && zhdr->last_chunks == 0) {
-		/* zbud page is empty, free */
 		list_del(&zhdr->lru);
-		free_zbud_page(zhdr);
 		pool->pages_nr--;
 	} else {
 		/* Add to unbuddied list */
@@ -357,6 +372,7 @@ void zbud_free(struct zbud_pool *pool, unsigned long handle)
 		list_add(&zhdr->buddy, &pool->unbuddied[freechunks]);
 	}
 
+	put_zbud_page(zhdr);
 	spin_unlock(&pool->lock);
 }
 
@@ -378,21 +394,23 @@ void zbud_free(struct zbud_pool *pool, unsigned long handle)
  * To avoid these, this is how zbud_reclaim_page() should be called:
 
  * The user detects a page should be reclaimed and calls zbud_reclaim_page().
- * zbud_reclaim_page() will remove a zbud page from the pool LRU list and call
- * the user-defined eviction handler with the pool and handle as arguments.
+ * zbud_reclaim_page() will move zbud page to the beginning of the pool
+ * LRU list, increase the page reference count and call the user-defined
+ * eviction handler with the pool and handle as arguments.
  *
  * If the handle can not be evicted, the eviction handler should return
- * non-zero. zbud_reclaim_page() will add the zbud page back to the
- * appropriate list and try the next zbud page on the LRU up to
+ * non-zero. zbud_reclaim_page() will drop the reference count for page
+ * obtained earlier and try the next zbud page on the LRU up to
  * a user defined number of retries.
  *
  * If the handle is successfully evicted, the eviction handler should
  * return 0 _and_ should have called zbud_free() on the handle. zbud_free()
- * contains logic to delay freeing the page if the page is under reclaim,
- * as indicated by the setting of the PG_reclaim flag on the underlying page.
+ * will remove the page from appropriate lists (LRU, buddied/unbuddied) and
+ * drop the reference count associated with given handle.
+ * Then the zbud_reclaim_page() will drop reference count obtained earlier.
  *
- * If all buddies in the zbud page are successfully evicted, then the
- * zbud page can be freed.
+ * If all buddies in the zbud page are successfully evicted, then dropping
+ * this last reference count will free the page.
  *
  * Returns: 0 if page is successfully freed, otherwise -EINVAL if there are
  * no pages to evict or an eviction handler is not registered, -EAGAIN if
@@ -400,7 +418,7 @@ void zbud_free(struct zbud_pool *pool, unsigned long handle)
  */
 int zbud_reclaim_page(struct zbud_pool *pool, unsigned int retries)
 {
-	int i, ret, freechunks;
+	int i, ret;
 	struct zbud_header *zhdr;
 	unsigned long first_handle = 0, last_handle = 0;
 
@@ -411,11 +429,24 @@ int zbud_reclaim_page(struct zbud_pool *pool, unsigned int retries)
 		return -EINVAL;
 	}
 	for (i = 0; i < retries; i++) {
+		if (list_empty(&pool->lru)) {
+			/*
+			 * LRU was emptied during evict calls in previous
+			 * iteration but put_zbud_page() returned 0 meaning
+			 * that someone still holds the page. This may
+			 * happen when some other mm mechanism increased
+			 * the page count.
+			 * In such case we succedded with reclaim.
+			 */
+			spin_unlock(&pool->lock);
+			return 0;
+		}
 		zhdr = list_tail_entry(&pool->lru, struct zbud_header, lru);
+		/* Move this last element to beginning of LRU */
 		list_del(&zhdr->lru);
-		list_del(&zhdr->buddy);
+		list_add(&zhdr->lru, &pool->lru);
 		/* Protect zbud page against free */
-		zhdr->under_reclaim = true;
+		get_zbud_page(zhdr);
 		/*
 		 * We need encode the handles before unlocking, since we can
 		 * race with free that will set (first|last)_chunks to 0
@@ -440,29 +471,9 @@ int zbud_reclaim_page(struct zbud_pool *pool, unsigned int retries)
 				goto next;
 		}
 next:
-		spin_lock(&pool->lock);
-		zhdr->under_reclaim = false;
-		if (zhdr->first_chunks == 0 && zhdr->last_chunks == 0) {
-			/*
-			 * Both buddies are now free, free the zbud page and
-			 * return success.
-			 */
-			free_zbud_page(zhdr);
-			pool->pages_nr--;
-			spin_unlock(&pool->lock);
+		if (put_zbud_page(zhdr))
 			return 0;
-		} else if (zhdr->first_chunks == 0 ||
-				zhdr->last_chunks == 0) {
-			/* add to unbuddied list */
-			freechunks = num_free_chunks(zhdr);
-			list_add(&zhdr->buddy, &pool->unbuddied[freechunks]);
-		} else {
-			/* add to buddied list */
-			list_add(&zhdr->buddy, &pool->buddied);
-		}
-
-		/* add to beginning of LRU */
-		list_add(&zhdr->lru, &pool->lru);
+		spin_lock(&pool->lock);
 	}
 	spin_unlock(&pool->lock);
 	return -EAGAIN;
-- 
1.7.9.5

