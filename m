Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759002Ab3BNDHQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 22:07:16 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:48004 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754741Ab3BNDFS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 22:05:18 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        dan.magenheimer@oracle.com, gregkh@linuxfoundation.org
Cc: sjenning@linux.vnet.ibm.com, rcj@linux.vnet.ibm.com,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 03/16] zcache: Provide accessory functions for counter decrease.
Date: Wed, 13 Feb 2013 22:04:53 -0500
Message-Id: <1360811106-2679-4-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.8.0.2
In-Reply-To: <1360811106-2679-1-git-send-email-konrad.wilk@oracle.com>
References: <1360811106-2679-1-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This way we can have all wrapped with these functions and
can disable/enable this with CONFIG_DEBUG_FS.

[v2: Rebase on top of staging/zcache: Fix/improve zcache writeback code, tie to a config option]
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 drivers/staging/zcache/zcache-main.c | 96 +++++++++++++++++++++---------------
 1 file changed, 57 insertions(+), 39 deletions(-)

diff --git a/drivers/staging/zcache/zcache-main.c b/drivers/staging/zcache/zcache-main.c
index 5ad915a..50a408a 100644
--- a/drivers/staging/zcache/zcache-main.c
+++ b/drivers/staging/zcache/zcache-main.c
@@ -144,8 +144,12 @@ static inline void inc_zcache_obj_count(void)
 	if (zcache_obj_count > zcache_obj_count_max)
 		zcache_obj_count_max = zcache_obj_count;
 }
-
 static long zcache_objnode_count;
+static inline void dec_zcache_obj_count(void)
+{
+	zcache_obj_count = atomic_dec_return(&zcache_obj_atomic);
+	BUG_ON(zcache_obj_count < 0);
+};
 static atomic_t zcache_objnode_atomic = ATOMIC_INIT(0);
 static long zcache_objnode_count_max;
 static inline void inc_zcache_objnode_count(void)
@@ -154,6 +158,11 @@ static inline void inc_zcache_objnode_count(void)
 	if (zcache_objnode_count > zcache_objnode_count_max)
 		zcache_objnode_count_max = zcache_objnode_count;
 };
+static inline void dec_zcache_objnode_count(void)
+{
+	zcache_objnode_count = atomic_dec_return(&zcache_objnode_atomic);
+	BUG_ON(zcache_objnode_count < 0);
+};
 static u64 zcache_eph_zbytes;
 static atomic_long_t zcache_eph_zbytes_atomic = ATOMIC_INIT(0);
 static u64 zcache_eph_zbytes_max;
@@ -163,6 +172,10 @@ static inline void inc_zcache_eph_zbytes(unsigned clen)
 	if (zcache_eph_zbytes > zcache_eph_zbytes_max)
 		zcache_eph_zbytes_max = zcache_eph_zbytes;
 };
+static inline void dec_zcache_eph_zbytes(unsigned zsize)
+{
+	zcache_eph_zbytes = atomic_long_sub_return(zsize, &zcache_eph_zbytes_atomic);
+};
 static u64 zcache_pers_zbytes;
 static atomic_long_t zcache_pers_zbytes_atomic = ATOMIC_INIT(0);
 static u64 zcache_pers_zbytes_max;
@@ -173,6 +186,10 @@ static inline void inc_zcache_pers_zbytes(unsigned clen)
 		zcache_pers_zbytes_max = zcache_pers_zbytes;
 }
 static long zcache_eph_pageframes;
+static inline void dec_zcache_pers_zbytes(unsigned zsize)
+{
+	zcache_pers_zbytes = atomic_long_sub_return(zsize, &zcache_pers_zbytes_atomic);
+}
 static atomic_t zcache_eph_pageframes_atomic = ATOMIC_INIT(0);
 static long zcache_eph_pageframes_max;
 static inline void inc_zcache_eph_pageframes(void)
@@ -182,6 +199,10 @@ static inline void inc_zcache_eph_pageframes(void)
 		zcache_eph_pageframes_max = zcache_eph_pageframes;
 };
 static long zcache_pers_pageframes;
+static inline void dec_zcache_eph_pageframes(void)
+{
+	zcache_eph_pageframes = atomic_dec_return(&zcache_eph_pageframes_atomic);
+};
 static atomic_t zcache_pers_pageframes_atomic = ATOMIC_INIT(0);
 static long zcache_pers_pageframes_max;
 static inline void inc_zcache_pers_pageframes(void)
@@ -191,6 +212,10 @@ static inline void inc_zcache_pers_pageframes(void)
 		zcache_pers_pageframes_max = zcache_pers_pageframes;
 }
 static long zcache_pageframes_alloced;
+static inline void dec_zcache_pers_pageframes(void)
+{
+	zcache_pers_pageframes = atomic_dec_return(&zcache_pers_pageframes_atomic);
+}
 static atomic_t zcache_pageframes_alloced_atomic = ATOMIC_INIT(0);
 static inline void inc_zcache_pageframes_alloced(void)
 {
@@ -212,6 +237,10 @@ static inline void inc_zcache_eph_zpages(void)
 		zcache_eph_zpages_max = zcache_eph_zpages;
 }
 static long zcache_pers_zpages;
+static inline void dec_zcache_eph_zpages(unsigned zpages)
+{
+	zcache_eph_zpages = atomic_sub_return(zpages, &zcache_eph_zpages_atomic);
+}
 static atomic_t zcache_pers_zpages_atomic = ATOMIC_INIT(0);
 static long zcache_pers_zpages_max;
 static inline void inc_zcache_pers_zpages(void)
@@ -220,6 +249,10 @@ static inline void inc_zcache_pers_zpages(void)
 	if (zcache_pers_zpages > zcache_pers_zpages_max)
 		zcache_pers_zpages_max = zcache_pers_zpages;
 }
+static inline void dec_zcache_pers_zpages(unsigned zpages)
+{
+	zcache_pers_zpages = atomic_sub_return(zpages, &zcache_pers_zpages_atomic);
+}
 /* but for the rest of these, counting races are ok */
 static unsigned long zcache_flush_total;
 static unsigned long zcache_flush_found;
@@ -484,9 +517,7 @@ static struct tmem_objnode *zcache_objnode_alloc(struct tmem_pool *pool)
 static void zcache_objnode_free(struct tmem_objnode *objnode,
 					struct tmem_pool *pool)
 {
-	zcache_objnode_count =
-		atomic_dec_return(&zcache_objnode_atomic);
-	BUG_ON(zcache_objnode_count < 0);
+	dec_zcache_objnode_count();
 	kmem_cache_free(zcache_objnode_cache, objnode);
 }
 
@@ -505,9 +536,7 @@ static struct tmem_obj *zcache_obj_alloc(struct tmem_pool *pool)
 
 static void zcache_obj_free(struct tmem_obj *obj, struct tmem_pool *pool)
 {
-	zcache_obj_count =
-		atomic_dec_return(&zcache_obj_atomic);
-	BUG_ON(zcache_obj_count < 0);
+	dec_zcache_obj_count();
 	kmem_cache_free(zcache_obj_cache, obj);
 }
 
@@ -827,20 +856,14 @@ static int zcache_pampd_get_data_and_free(char *data, size_t *sizep, bool raw,
 					&zsize, &zpages);
 	if (eph) {
 		if (page)
-			zcache_eph_pageframes =
-			    atomic_dec_return(&zcache_eph_pageframes_atomic);
-		zcache_eph_zpages =
-		    atomic_sub_return(zpages, &zcache_eph_zpages_atomic);
-		zcache_eph_zbytes =
-		    atomic_long_sub_return(zsize, &zcache_eph_zbytes_atomic);
+			dec_zcache_eph_pageframes();
+		dec_zcache_eph_zpages(zpages);
+		dec_zcache_eph_zbytes(zsize);
 	} else {
 		if (page)
-			zcache_pers_pageframes =
-			    atomic_dec_return(&zcache_pers_pageframes_atomic);
-		zcache_pers_zpages =
-		    atomic_sub_return(zpages, &zcache_pers_zpages_atomic);
-		zcache_pers_zbytes =
-		    atomic_long_sub_return(zsize, &zcache_pers_zbytes_atomic);
+			dec_zcache_pers_pageframes();
+		dec_zcache_pers_zpages(zpages);
+		dec_zcache_pers_zbytes(zsize);
 	}
 	if (!is_local_client(pool->client))
 		ramster_count_foreign_pages(eph, -1);
@@ -870,23 +893,17 @@ static void zcache_pampd_free(void *pampd, struct tmem_pool *pool,
 		page = zbud_free_and_delist((struct zbudref *)pampd,
 						true, &zsize, &zpages);
 		if (page)
-			zcache_eph_pageframes =
-			    atomic_dec_return(&zcache_eph_pageframes_atomic);
-		zcache_eph_zpages =
-		    atomic_sub_return(zpages, &zcache_eph_zpages_atomic);
-		zcache_eph_zbytes =
-		    atomic_long_sub_return(zsize, &zcache_eph_zbytes_atomic);
+			dec_zcache_eph_pageframes();
+		dec_zcache_eph_zpages(zpages);
+		dec_zcache_eph_zbytes(zsize);
 		/* FIXME CONFIG_RAMSTER... check acct parameter? */
 	} else {
 		page = zbud_free_and_delist((struct zbudref *)pampd,
 						false, &zsize, &zpages);
 		if (page)
-			zcache_pers_pageframes =
-			    atomic_dec_return(&zcache_pers_pageframes_atomic);
-		zcache_pers_zpages =
-		     atomic_sub_return(zpages, &zcache_pers_zpages_atomic);
-		zcache_pers_zbytes =
-		    atomic_long_sub_return(zsize, &zcache_pers_zbytes_atomic);
+			dec_zcache_pers_pageframes();
+		dec_zcache_pers_zpages(zpages);
+		dec_zcache_pers_zbytes(zsize);
 	}
 	if (!is_local_client(pool->client))
 		ramster_count_foreign_pages(is_ephemeral(pool), -1);
@@ -1008,13 +1025,10 @@ static struct page *zcache_evict_eph_pageframe(void)
 	page = zbud_evict_pageframe_lru(&zsize, &zpages);
 	if (page == NULL)
 		goto out;
-	zcache_eph_zbytes = atomic_long_sub_return(zsize,
-					&zcache_eph_zbytes_atomic);
-	zcache_eph_zpages = atomic_sub_return(zpages,
-					&zcache_eph_zpages_atomic);
+	dec_zcache_eph_zbytes(zsize);
+	dec_zcache_eph_zpages(zpages);
 	zcache_evicted_eph_zpages += zpages;
-	zcache_eph_pageframes =
-		atomic_dec_return(&zcache_eph_pageframes_atomic);
+	dec_zcache_eph_pageframes();
 	zcache_evicted_eph_pageframes++;
 out:
 	return page;
@@ -1029,6 +1043,11 @@ static inline void inc_zcache_outstanding_writeback_pages(void)
 	zcache_outstanding_writeback_pages =
 	    atomic_inc_return(&zcache_outstanding_writeback_pages_atomic);
 }
+static inline void dec_zcache_outstanding_writeback_pages(void)
+{
+	zcache_outstanding_writeback_pages =
+	  atomic_dec_return(&zcache_outstanding_writeback_pages_atomic);
+};
 static void unswiz(struct tmem_oid oid, u32 index,
 				unsigned *type, pgoff_t *offset);
 
@@ -1042,8 +1061,7 @@ static void unswiz(struct tmem_oid oid, u32 index,
 static void zcache_end_swap_write(struct bio *bio, int err)
 {
 	end_swap_bio_write(bio, err);
-	zcache_outstanding_writeback_pages =
-	  atomic_dec_return(&zcache_outstanding_writeback_pages_atomic);
+	dec_zcache_outstanding_writeback_pages();
 	zcache_writtenback_pages++;
 }
 
-- 
1.8.0.2

