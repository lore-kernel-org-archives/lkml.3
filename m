Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751746AbaATHvY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 02:51:24 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:16524 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750743AbaATHvW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 02:51:22 -0500
X-AuditID: cbfee61b-b7f456d000006dfd-83-52dcd578be1c
From: Cai Liu <cai.liu@samsung.com>
To: "'Minchan Kim'" <minchan@kernel.org>,
        "'Andrew Morton'" <akpm@linux-foundation.org>,
        "'Seth Jennings'" <sjenning@linux.vnet.ibm.com>,
        "'Bob Liu'" <bob.liu@oracle.com>
Cc: "'Linux-MM'" <linux-mm@kvack.org>,
        "'Linux-Kernel'" <linux-kernel@vger.kernel.org>, liucai.lfn@gmail.com,
        cai.liu@samsung.com
Subject: [PATCH v2]  mm/zswap: Check all pool pages instead of one pool pages
Date: Mon, 20 Jan 2014 15:50:18 +0800
Message-id: <000701cf15b4$6822c740$386855c0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac8VtASNJJcl6u77S4+ew3qXO684Xw==
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrDLMWRmVeSWpSXmKPExsVy+t9jQd2Kq3eCDGa9l7eYs34Nm0XXqaks
	FrdnTGWzuLxrDpvFvTX/WS027TnGarHs63t2i0P7VrE7cHjsnHWX3WPTqk42j02fJrF7nJjx
	m8XjwaHNLB4fn95i8ejbsorR4/MmuQCOKC6blNSczLLUIn27BK6MWz3/2QpmKVVs6NzF3MB4
	SLqLkZNDQsBEYunsqYwQtpjEhXvr2boYuTiEBKYzSlw/d40ZJCEk8INRYucCNhCbTUBZ4sGD
	6WANIgLLGCVeHDIDaWAWaGSUuL3rM1iRsICvxNs3q8BsFgFVieMdl9hBbF4BS4kzfdtZIWxB
	iR+T77GA2MwCWhLrdx5ngrDlJTavecsMcZGCxI6zr6GW6UkcODmTHaJGXGLjkVssExgFZiEZ
	NQvJqFlIRs1C0rKAkWUVo2hqQXJBcVJ6rpFecWJucWleul5yfu4mRnCcPJPewbiqweIQowAH
	oxIPr4HbnSAh1sSy4srcQ4wSHMxKIrxbDgOFeFMSK6tSi/Lji0pzUosPMUpzsCiJ8x5stQ4U
	EkhPLEnNTk0tSC2CyTJxcEo1MPZwOKedsKv5rD5/wrvuSP6FM/KV/jLc2nE7Yrbk85N7pKc9
	3ptRmNg041f47u85kgYzyrucONJW24pytv5eWPOo5izDBU9BlXes9kvkvqgf3//QaUtPSe3r
	Tc87NQN9hSVKhAJTCh02hMownzzHwe2nKLE9jXMtn1PDZ/7t1SFf1h/MZ3hno8RSnJFoqMVc
	VJwIANplJuGPAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

zswap can support multiple swapfiles. So we need to check
all zbud pool pages in zswap.

Version 2:
  * add *total_zbud_pages* in zbud to record all the pages in pools
  * move the updating of pool pages statistics to
    alloc_zbud_page/free_zbud_page to hide the details

Signed-off-by: Cai Liu <cai.liu@samsung.com>
---
 include/linux/zbud.h |    2 +-
 mm/zbud.c            |   44 ++++++++++++++++++++++++++++++++------------
 mm/zswap.c           |    4 ++--
 3 files changed, 35 insertions(+), 15 deletions(-)

diff --git a/include/linux/zbud.h b/include/linux/zbud.h
index 2571a5c..1dbc13e 100644
--- a/include/linux/zbud.h
+++ b/include/linux/zbud.h
@@ -17,6 +17,6 @@ void zbud_free(struct zbud_pool *pool, unsigned long handle);
 int zbud_reclaim_page(struct zbud_pool *pool, unsigned int retries);
 void *zbud_map(struct zbud_pool *pool, unsigned long handle);
 void zbud_unmap(struct zbud_pool *pool, unsigned long handle);
-u64 zbud_get_pool_size(struct zbud_pool *pool);
+u64 zbud_get_pool_size(void);
 
 #endif /* _ZBUD_H_ */
diff --git a/mm/zbud.c b/mm/zbud.c
index 9451361..711aaf4 100644
--- a/mm/zbud.c
+++ b/mm/zbud.c
@@ -52,6 +52,13 @@
 #include <linux/spinlock.h>
 #include <linux/zbud.h>
 
+/*********************************
+* statistics
+**********************************/
+
+/* zbud pages in all pools */
+static u64 total_zbud_pages;
+
 /*****************
  * Structures
 *****************/
@@ -142,10 +149,28 @@ static struct zbud_header *init_zbud_page(struct page *page)
 	return zhdr;
 }
 
+static struct page *alloc_zbud_page(struct zbud_pool *pool, gfp_t gfp)
+{
+	struct page *page;
+
+	page = alloc_page(gfp);
+
+	if (page) {
+		pool->pages_nr++;
+		total_zbud_pages++;
+	}
+
+	return page;
+}
+
+
 /* Resets the struct page fields and frees the page */
-static void free_zbud_page(struct zbud_header *zhdr)
+static void free_zbud_page(struct zbud_pool *pool, struct zbud_header *zhdr)
 {
 	__free_page(virt_to_page(zhdr));
+
+	pool->pages_nr--;
+	total_zbud_pages--;
 }
 
 /*
@@ -279,11 +304,10 @@ int zbud_alloc(struct zbud_pool *pool, int size, gfp_t gfp,
 
 	/* Couldn't find unbuddied zbud page, create new one */
 	spin_unlock(&pool->lock);
-	page = alloc_page(gfp);
+	page = alloc_zbud_page(pool, gfp);
 	if (!page)
 		return -ENOMEM;
 	spin_lock(&pool->lock);
-	pool->pages_nr++;
 	zhdr = init_zbud_page(page);
 	bud = FIRST;
 
@@ -349,8 +373,7 @@ void zbud_free(struct zbud_pool *pool, unsigned long handle)
 	if (zhdr->first_chunks == 0 && zhdr->last_chunks == 0) {
 		/* zbud page is empty, free */
 		list_del(&zhdr->lru);
-		free_zbud_page(zhdr);
-		pool->pages_nr--;
+		free_zbud_page(pool, zhdr);
 	} else {
 		/* Add to unbuddied list */
 		freechunks = num_free_chunks(zhdr);
@@ -447,8 +470,7 @@ next:
 			 * Both buddies are now free, free the zbud page and
 			 * return success.
 			 */
-			free_zbud_page(zhdr);
-			pool->pages_nr--;
+			free_zbud_page(pool, zhdr);
 			spin_unlock(&pool->lock);
 			return 0;
 		} else if (zhdr->first_chunks == 0 ||
@@ -496,14 +518,12 @@ void zbud_unmap(struct zbud_pool *pool, unsigned long handle)
 
 /**
  * zbud_get_pool_size() - gets the zbud pool size in pages
- * @pool:	pool whose size is being queried
  *
- * Returns: size in pages of the given pool.  The pool lock need not be
- * taken to access pages_nr.
+ * Returns: size in pages of all the zbud pools.
  */
-u64 zbud_get_pool_size(struct zbud_pool *pool)
+u64 zbud_get_pool_size(void)
 {
-	return pool->pages_nr;
+	return total_zbud_pages;
 }
 
 static int __init init_zbud(void)
diff --git a/mm/zswap.c b/mm/zswap.c
index 5a63f78..ef44d9d 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -291,7 +291,7 @@ static void zswap_free_entry(struct zswap_tree *tree,
 	zbud_free(tree->pool, entry->handle);
 	zswap_entry_cache_free(entry);
 	atomic_dec(&zswap_stored_pages);
-	zswap_pool_pages = zbud_get_pool_size(tree->pool);
+	zswap_pool_pages = zbud_get_pool_size();
 }
 
 /* caller must hold the tree lock */
@@ -716,7 +716,7 @@ static int zswap_frontswap_store(unsigned type, pgoff_t offset,
 
 	/* update stats */
 	atomic_inc(&zswap_stored_pages);
-	zswap_pool_pages = zbud_get_pool_size(tree->pool);
+	zswap_pool_pages = zbud_get_pool_size();
 
 	return 0;
 
-- 
1.7.10.4

