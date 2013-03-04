Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932273Ab3CDSTv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 13:19:51 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:35931 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758461Ab3CDSSf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 13:18:35 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org,
        devel@driverdev.osuosl.org
Cc: dan.magenheimer@oracle.com, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 02/11] zcache: Provide accessory functions for counter increase
Date: Mon,  4 Mar 2013 13:18:12 -0500
Message-Id: <1362421101-15896-3-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.8.0.2
In-Reply-To: <1362421101-15896-1-git-send-email-konrad.wilk@oracle.com>
References: <1362421101-15896-1-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the first step in moving the debugfs code out of the
main file in-to another file. And also allow the code to run
without CONFIG_DEBUG_FS defined.

Acked-by: Dan Magenheimer <dan.magenheimer@oracle.com>
[v2: Rebase on top staging/zcache: Fix/improve zcache writeback code, tie to a config option]
[v3: Rebase on top of zcache: Fix compile warnings due to usage of debugfs_create_size_t]
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 drivers/staging/zcache/zcache-main.c | 109 +++++++++++++++++++++++------------
 1 file changed, 73 insertions(+), 36 deletions(-)

diff --git a/drivers/staging/zcache/zcache-main.c b/drivers/staging/zcache/zcache-main.c
index d7dd02c..a3c5b7d 100644
--- a/drivers/staging/zcache/zcache-main.c
+++ b/drivers/staging/zcache/zcache-main.c
@@ -139,32 +139,87 @@ static ssize_t zcache_obj_count;
 static atomic_t zcache_obj_atomic = ATOMIC_INIT(0);
 static ssize_t zcache_obj_count_max;
 static ssize_t zcache_objnode_count;
+static inline void inc_zcache_obj_count(void)
+{
+	zcache_obj_count = atomic_inc_return(&zcache_obj_atomic);
+	if (zcache_obj_count > zcache_obj_count_max)
+		zcache_obj_count_max = zcache_obj_count;
+}
+
 static atomic_t zcache_objnode_atomic = ATOMIC_INIT(0);
 static ssize_t zcache_objnode_count_max;
+static inline void inc_zcache_objnode_count(void)
+{
+	zcache_objnode_count = atomic_inc_return(&zcache_objnode_atomic);
+	if (zcache_objnode_count > zcache_objnode_count_max)
+		zcache_objnode_count_max = zcache_objnode_count;
+};
 static u64 zcache_eph_zbytes;
 static atomic_long_t zcache_eph_zbytes_atomic = ATOMIC_INIT(0);
 static u64 zcache_eph_zbytes_max;
+static inline void inc_zcache_eph_zbytes(unsigned clen)
+{
+	zcache_eph_zbytes = atomic_long_add_return(clen, &zcache_eph_zbytes_atomic);
+	if (zcache_eph_zbytes > zcache_eph_zbytes_max)
+		zcache_eph_zbytes_max = zcache_eph_zbytes;
+};
 static u64 zcache_pers_zbytes;
 static atomic_long_t zcache_pers_zbytes_atomic = ATOMIC_INIT(0);
 static u64 zcache_pers_zbytes_max;
 static ssize_t zcache_eph_pageframes;
+static inline void inc_zcache_pers_zbytes(unsigned clen)
+{
+	zcache_pers_zbytes = atomic_long_add_return(clen, &zcache_pers_zbytes_atomic);
+	if (zcache_pers_zbytes > zcache_pers_zbytes_max)
+		zcache_pers_zbytes_max = zcache_pers_zbytes;
+}
 static atomic_t zcache_eph_pageframes_atomic = ATOMIC_INIT(0);
 static ssize_t zcache_eph_pageframes_max;
 static ssize_t zcache_pers_pageframes;
+static inline void inc_zcache_eph_pageframes(void)
+{
+	zcache_eph_pageframes = atomic_inc_return(&zcache_eph_pageframes_atomic);
+	if (zcache_eph_pageframes > zcache_eph_pageframes_max)
+		zcache_eph_pageframes_max = zcache_eph_pageframes;
+};
 static atomic_t zcache_pers_pageframes_atomic = ATOMIC_INIT(0);
 static ssize_t zcache_pers_pageframes_max;
 static ssize_t zcache_pageframes_alloced;
+static inline void inc_zcache_pers_pageframes(void)
+{
+	zcache_pers_pageframes = atomic_inc_return(&zcache_pers_pageframes_atomic);
+	if (zcache_pers_pageframes > zcache_pers_pageframes_max)
+		zcache_pers_pageframes_max = zcache_pers_pageframes;
+}
 static atomic_t zcache_pageframes_alloced_atomic = ATOMIC_INIT(0);
 static ssize_t zcache_pageframes_freed;
+static inline void inc_zcache_pageframes_alloced(void)
+{
+	zcache_pageframes_alloced = atomic_inc_return(&zcache_pageframes_alloced_atomic);
+};
 static atomic_t zcache_pageframes_freed_atomic = ATOMIC_INIT(0);
 static ssize_t zcache_eph_zpages;
-static ssize_t zcache_eph_zpages;
+static inline void inc_zcache_pageframes_freed(void)
+{
+	zcache_pageframes_freed = atomic_inc_return(&zcache_pageframes_freed_atomic);
+}
 static atomic_t zcache_eph_zpages_atomic = ATOMIC_INIT(0);
 static ssize_t zcache_eph_zpages_max;
 static ssize_t zcache_pers_zpages;
+static inline void inc_zcache_eph_zpages(void)
+{
+	zcache_eph_zpages = atomic_inc_return(&zcache_eph_zpages_atomic);
+	if (zcache_eph_zpages > zcache_eph_zpages_max)
+		zcache_eph_zpages_max = zcache_eph_zpages;
+}
 static atomic_t zcache_pers_zpages_atomic = ATOMIC_INIT(0);
 static ssize_t zcache_pers_zpages_max;
-
+static inline void inc_zcache_pers_zpages(void)
+{
+	zcache_pers_zpages = atomic_inc_return(&zcache_pers_zpages_atomic);
+	if (zcache_pers_zpages > zcache_pers_zpages_max)
+		zcache_pers_zpages_max = zcache_pers_zpages;
+}
 /* but for the rest of these, counting races are ok */
 static ssize_t zcache_flush_total;
 static ssize_t zcache_flush_found;
@@ -422,9 +477,7 @@ static struct tmem_objnode *zcache_objnode_alloc(struct tmem_pool *pool)
 		}
 	}
 	BUG_ON(objnode == NULL);
-	zcache_objnode_count = atomic_inc_return(&zcache_objnode_atomic);
-	if (zcache_objnode_count > zcache_objnode_count_max)
-		zcache_objnode_count_max = zcache_objnode_count;
+	inc_zcache_objnode_count();
 	return objnode;
 }
 
@@ -446,9 +499,7 @@ static struct tmem_obj *zcache_obj_alloc(struct tmem_pool *pool)
 	obj = kp->obj;
 	BUG_ON(obj == NULL);
 	kp->obj = NULL;
-	zcache_obj_count = atomic_inc_return(&zcache_obj_atomic);
-	if (zcache_obj_count > zcache_obj_count_max)
-		zcache_obj_count_max = zcache_obj_count;
+	inc_zcache_obj_count();
 	return obj;
 }
 
@@ -472,8 +523,7 @@ static struct page *zcache_alloc_page(void)
 	struct page *page = alloc_page(ZCACHE_GFP_MASK);
 
 	if (page != NULL)
-		zcache_pageframes_alloced =
-			atomic_inc_return(&zcache_pageframes_alloced_atomic);
+		inc_zcache_pageframes_alloced();
 	return page;
 }
 
@@ -485,8 +535,7 @@ static void zcache_free_page(struct page *page)
 	if (page == NULL)
 		BUG();
 	__free_page(page);
-	zcache_pageframes_freed =
-		atomic_inc_return(&zcache_pageframes_freed_atomic);
+	inc_zcache_pageframes_freed();
 	curr_pageframes = zcache_pageframes_alloced -
 			atomic_read(&zcache_pageframes_freed_atomic) -
 			atomic_read(&zcache_eph_pageframes_atomic) -
@@ -551,19 +600,11 @@ static void *zcache_pampd_eph_create(char *data, size_t size, bool raw,
 create_in_new_page:
 	pampd = (void *)zbud_create_prep(th, true, cdata, clen, newpage);
 	BUG_ON(pampd == NULL);
-	zcache_eph_pageframes =
-		atomic_inc_return(&zcache_eph_pageframes_atomic);
-	if (zcache_eph_pageframes > zcache_eph_pageframes_max)
-		zcache_eph_pageframes_max = zcache_eph_pageframes;
+	inc_zcache_eph_pageframes();
 
 got_pampd:
-	zcache_eph_zbytes =
-		atomic_long_add_return(clen, &zcache_eph_zbytes_atomic);
-	if (zcache_eph_zbytes > zcache_eph_zbytes_max)
-		zcache_eph_zbytes_max = zcache_eph_zbytes;
-	zcache_eph_zpages = atomic_inc_return(&zcache_eph_zpages_atomic);
-	if (zcache_eph_zpages > zcache_eph_zpages_max)
-		zcache_eph_zpages_max = zcache_eph_zpages;
+	inc_zcache_eph_zbytes(clen);
+	inc_zcache_eph_zpages();
 	if (ramster_enabled && raw)
 		ramster_count_foreign_pages(true, 1);
 out:
@@ -633,19 +674,11 @@ create_pampd:
 create_in_new_page:
 	pampd = (void *)zbud_create_prep(th, false, cdata, clen, newpage);
 	BUG_ON(pampd == NULL);
-	zcache_pers_pageframes =
-		atomic_inc_return(&zcache_pers_pageframes_atomic);
-	if (zcache_pers_pageframes > zcache_pers_pageframes_max)
-		zcache_pers_pageframes_max = zcache_pers_pageframes;
+	inc_zcache_pers_pageframes();
 
 got_pampd:
-	zcache_pers_zpages = atomic_inc_return(&zcache_pers_zpages_atomic);
-	if (zcache_pers_zpages > zcache_pers_zpages_max)
-		zcache_pers_zpages_max = zcache_pers_zpages;
-	zcache_pers_zbytes =
-		atomic_long_add_return(clen, &zcache_pers_zbytes_atomic);
-	if (zcache_pers_zbytes > zcache_pers_zbytes_max)
-		zcache_pers_zbytes_max = zcache_pers_zbytes;
+	inc_zcache_pers_zpages();
+	inc_zcache_pers_zbytes(clen);
 	if (ramster_enabled && raw)
 		ramster_count_foreign_pages(false, 1);
 out:
@@ -991,6 +1024,11 @@ out:
 
 static atomic_t zcache_outstanding_writeback_pages_atomic = ATOMIC_INIT(0);
 
+static inline void inc_zcache_outstanding_writeback_pages(void)
+{
+	zcache_outstanding_writeback_pages =
+	    atomic_inc_return(&zcache_outstanding_writeback_pages_atomic);
+}
 static void unswiz(struct tmem_oid oid, u32 index,
 				unsigned *type, pgoff_t *offset);
 
@@ -1120,8 +1158,7 @@ static int zcache_frontswap_writeback_zpage(int type, pgoff_t offset,
 	 */
 	(void)__swap_writepage(page, &wbc, zcache_end_swap_write);
 	page_cache_release(page);
-	zcache_outstanding_writeback_pages =
-	    atomic_inc_return(&zcache_outstanding_writeback_pages_atomic);
+	inc_zcache_outstanding_writeback_pages();
 
 	return 0;
 }
-- 
1.8.0.2

