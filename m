Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966824Ab3HIKXb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Aug 2013 06:23:31 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:40725 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966223Ab3HIKWf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Aug 2013 06:22:35 -0400
X-AuditID: cbfec7f4-b7f5f6d000000ff6-0d-5204c2e97d6a
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Seth Jennings <sjenning@linux.vnet.ibm.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Cc: Mel Gorman <mgorman@suse.de>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Dave Hansen <dave.hansen@intel.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Tomasz Stanislawski <t.stanislaws@samsung.com>
Subject: [RFC PATCH v2 1/4] zbud: use page ref counter for zbud pages
Date: Fri, 09 Aug 2013 12:22:17 +0200
Message-id: <1376043740-10576-2-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1376043740-10576-1-git-send-email-k.kozlowski@samsung.com>
References: <1376043740-10576-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprALMWRmVeSWpSXmKPExsVy+t/xa7ovD7EEGbxqELCYs34Nm8XGGetZ
	LT69fMBo8fqFocXZpjfsFpd3zWGzuLfmP6vF2iN32S0mv3vGaHFo3yp2i3ntL1kduD0W73nJ
	5LHp0yR2jxMzfrN4PDi0mcWjb8sqRo/Np6s9Pm+SC2CP4rJJSc3JLEst0rdL4Mpo3xNbsMy4
	YkrXCuYGxrUaXYycHBICJhLbGrYyQ9hiEhfurWfrYuTiEBJYyigxf/1ydpCEkEAfk8SyNb4g
	NpuAscTm5UvYQGwRgT5GiUmXLUAamAX2MUnsPvmVCSQhLOAqMeX6M7AiFgFViTfL34HZvALu
	Eq1f3gIN5QDapiAxZ5INSJhTwEPi7psDzBC73CXe7ZvHOIGRdwEjwypG0dTS5ILipPRcQ73i
	xNzi0rx0veT83E2MkFD8soNx8TGrQ4wCHIxKPLwntjAHCbEmlhVX5h5ilOBgVhLh3T6BJUiI
	NyWxsiq1KD++qDQntfgQIxMHp1QD4wq+b1cDHnDJz1pnd+7m2/Bp9/2LRJrteJpvzdrVsKW5
	PGaRuqXysZ1uPmuldU03af6fFP3e35Azm/GLaNrFQGM3dreVOyzsLxiz7jOvYHr4asMOOd8E
	qdPWr9JzVaJe9oq9DE/MWFGre2ZWntpXy0eeCdbLphpvLBJ/XXqke8axXecumYkvV2Ipzkg0
	1GIuKk4EAF0fRkYjAgAA
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
 mm/zbud.c |   96 ++++++++++++++++++++++++++++++++++---------------------------
 1 file changed, 53 insertions(+), 43 deletions(-)

diff --git a/mm/zbud.c b/mm/zbud.c
index ad1e781..52f6ba1 100644
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
@@ -188,6 +180,34 @@ static int num_free_chunks(struct zbud_header *zhdr)
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
+ * Must be called under pool->lock.
+ *
+ * Returns 1 if page was freed and 0 otherwise.
+ */
+static int put_zbud_page(struct zbud_pool *pool, struct zbud_header *zhdr)
+{
+	struct page *page = virt_to_page(zhdr);
+	if (put_page_testzero(page)) {
+		free_hot_cold_page(page, 0);
+		pool->pages_nr--;
+		return 1;
+	}
+	return 0;
+}
+
+
 /*****************
  * API Functions
 *****************/
@@ -250,7 +270,7 @@ void zbud_destroy_pool(struct zbud_pool *pool)
 int zbud_alloc(struct zbud_pool *pool, int size, gfp_t gfp,
 			unsigned long *handle)
 {
-	int chunks, i, freechunks;
+	int chunks, i;
 	struct zbud_header *zhdr = NULL;
 	enum buddy bud;
 	struct page *page;
@@ -273,6 +293,7 @@ int zbud_alloc(struct zbud_pool *pool, int size, gfp_t gfp,
 				bud = FIRST;
 			else
 				bud = LAST;
+			get_zbud_page(zhdr);
 			goto found;
 		}
 	}
@@ -284,6 +305,10 @@ int zbud_alloc(struct zbud_pool *pool, int size, gfp_t gfp,
 		return -ENOMEM;
 	spin_lock(&pool->lock);
 	pool->pages_nr++;
+	/*
+	 * We will be using zhdr instead of page, so
+	 * don't increase the page count.
+	 */
 	zhdr = init_zbud_page(page);
 	bud = FIRST;
 
@@ -295,7 +320,7 @@ found:
 
 	if (zhdr->first_chunks == 0 || zhdr->last_chunks == 0) {
 		/* Add to unbuddied list */
-		freechunks = num_free_chunks(zhdr);
+		int freechunks = num_free_chunks(zhdr);
 		list_add(&zhdr->buddy, &pool->unbuddied[freechunks]);
 	} else {
 		/* Add to buddied list */
@@ -326,7 +351,6 @@ found:
 void zbud_free(struct zbud_pool *pool, unsigned long handle)
 {
 	struct zbud_header *zhdr;
-	int freechunks;
 
 	spin_lock(&pool->lock);
 	zhdr = handle_to_zbud_header(handle);
@@ -337,26 +361,18 @@ void zbud_free(struct zbud_pool *pool, unsigned long handle)
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
-		pool->pages_nr--;
 	} else {
 		/* Add to unbuddied list */
-		freechunks = num_free_chunks(zhdr);
+		int freechunks = num_free_chunks(zhdr);
 		list_add(&zhdr->buddy, &pool->unbuddied[freechunks]);
 	}
 
+	put_zbud_page(pool, zhdr);
 	spin_unlock(&pool->lock);
 }
 
@@ -400,7 +416,7 @@ void zbud_free(struct zbud_pool *pool, unsigned long handle)
  */
 int zbud_reclaim_page(struct zbud_pool *pool, unsigned int retries)
 {
-	int i, ret, freechunks;
+	int i, ret;
 	struct zbud_header *zhdr;
 	unsigned long first_handle = 0, last_handle = 0;
 
@@ -411,11 +427,23 @@ int zbud_reclaim_page(struct zbud_pool *pool, unsigned int retries)
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
@@ -441,28 +469,10 @@ int zbud_reclaim_page(struct zbud_pool *pool, unsigned int retries)
 		}
 next:
 		spin_lock(&pool->lock);
-		zhdr->under_reclaim = false;
-		if (zhdr->first_chunks == 0 && zhdr->last_chunks == 0) {
-			/*
-			 * Both buddies are now free, free the zbud page and
-			 * return success.
-			 */
-			free_zbud_page(zhdr);
-			pool->pages_nr--;
+		if (put_zbud_page(pool, zhdr)) {
 			spin_unlock(&pool->lock);
 			return 0;
-		} else if (zhdr->first_chunks == 0 ||
-				zhdr->last_chunks == 0) {
-			/* add to unbuddied list */
-			freechunks = num_free_chunks(zhdr);
-			list_add(&zhdr->buddy, &pool->unbuddied[freechunks]);
-		} else {
-			/* add to buddied list */
-			list_add(&zhdr->buddy, &pool->buddied);
 		}
-
-		/* add to beginning of LRU */
-		list_add(&zhdr->lru, &pool->lru);
 	}
 	spin_unlock(&pool->lock);
 	return -EAGAIN;
-- 
1.7.9.5

