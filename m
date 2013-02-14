Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757103Ab3BNDFZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 22:05:25 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:19979 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754549Ab3BNDFS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 22:05:18 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        dan.magenheimer@oracle.com, gregkh@linuxfoundation.org
Cc: sjenning@linux.vnet.ibm.com, rcj@linux.vnet.ibm.com,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 13/16] zcache/zbud: Add incremental accessory counters
Date: Wed, 13 Feb 2013 22:05:03 -0500
Message-Id: <1360811106-2679-14-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.8.0.2
In-Reply-To: <1360811106-2679-1-git-send-email-konrad.wilk@oracle.com>
References: <1360811106-2679-1-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

that are going to be used for debug fs entries.

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 drivers/staging/zcache/zbud.c | 58 +++++++++++++++++++++++++++++--------------
 1 file changed, 39 insertions(+), 19 deletions(-)

diff --git a/drivers/staging/zcache/zbud.c b/drivers/staging/zcache/zbud.c
index 4654978..cff596c 100644
--- a/drivers/staging/zcache/zbud.c
+++ b/drivers/staging/zcache/zbud.c
@@ -301,6 +301,26 @@ static ssize_t zbud_eph_unbuddied_count;
 static ssize_t zbud_pers_unbuddied_count;
 static ssize_t zbud_eph_zombie_count;
 static ssize_t zbud_pers_zombie_count;
+static inline void inc_zbud_eph_pageframes(void) { zbud_eph_pageframes++; };
+static inline void inc_zbud_pers_pageframes(void) { zbud_pers_pageframes++; };
+static inline void inc_zbud_eph_zpages(void) { zbud_eph_zpages++; };
+static inline void inc_zbud_pers_zpages(void) { zbud_pers_zpages++; };
+static inline void inc_zbud_eph_zbytes(ssize_t bytes) { zbud_eph_zbytes += bytes; };
+static inline void inc_zbud_pers_zbytes(ssize_t bytes) { zbud_pers_zbytes += bytes; };
+static inline void inc_zbud_eph_evicted_pageframes(void) { zbud_eph_evicted_pageframes++; };
+static inline void inc_zbud_pers_evicted_pageframes(void) { zbud_pers_evicted_pageframes++; };
+static inline void inc_zbud_eph_cumul_zpages(void) { zbud_eph_cumul_zpages++; };
+static inline void inc_zbud_pers_cumul_zpages(void) { zbud_pers_cumul_zpages++; };
+static inline void inc_zbud_eph_cumul_zbytes(ssize_t bytes) { zbud_eph_cumul_zbytes += bytes; };
+static inline void inc_zbud_pers_cumul_zbytes(ssize_t bytes) { zbud_pers_cumul_zbytes += bytes; };
+static inline void inc_zbud_eph_cumul_chunk_counts(unsigned n) { zbud_eph_cumul_chunk_counts[n]++; };
+static inline void inc_zbud_pers_cumul_chunk_counts(unsigned n) { zbud_pers_cumul_chunk_counts[n]++; };
+static inline void inc_zbud_eph_buddied_count(void) { zbud_eph_buddied_count++; };
+static inline void inc_zbud_pers_buddied_count(void) { zbud_pers_buddied_count++; };
+static inline void inc_zbud_eph_unbuddied_count(void) { zbud_eph_unbuddied_count++; };
+static inline void inc_zbud_pers_unbuddied_count(void) { zbud_pers_unbuddied_count++; };
+static inline void inc_zbud_eph_zombie_count(void) { zbud_eph_zombie_count++; };
+static inline void inc_zbud_pers_zombie_count(void) { zbud_pers_zombie_count++; };
 static atomic_t zbud_eph_zombie_atomic;
 static atomic_t zbud_pers_zombie_atomic;
 
@@ -379,9 +399,9 @@ static inline struct zbudpage *zbud_init_zbudpage(struct page *page, bool eph)
 	zbudpage->zbud1_size = 0;
 	zbudpage->unevictable = 0;
 	if (eph)
-		zbud_eph_pageframes++;
+		inc_zbud_eph_pageframes();
 	else
-		zbud_pers_pageframes++;
+		inc_zbud_pers_pageframes();
 	return zbudpage;
 }
 
@@ -465,17 +485,17 @@ static void zbud_init_zbud(struct zbudpage *zbudpage, struct tmem_handle *th,
 	else
 		zbudpage->zbud1_size = size;
 	if (eph) {
-		zbud_eph_cumul_chunk_counts[nchunks]++;
-		zbud_eph_zpages++;
-		zbud_eph_cumul_zpages++;
-		zbud_eph_zbytes += size;
-		zbud_eph_cumul_zbytes += size;
+		inc_zbud_eph_cumul_chunk_counts(nchunks);
+		inc_zbud_eph_zpages();
+		inc_zbud_eph_cumul_zpages();
+		inc_zbud_eph_zbytes(size);
+		inc_zbud_eph_cumul_zbytes(size);
 	} else {
-		zbud_pers_cumul_chunk_counts[nchunks]++;
-		zbud_pers_zpages++;
-		zbud_pers_cumul_zpages++;
-		zbud_pers_zbytes += size;
-		zbud_pers_cumul_zbytes += size;
+		inc_zbud_pers_cumul_chunk_counts(nchunks);
+		inc_zbud_pers_zpages();
+		inc_zbud_pers_cumul_zpages();
+		inc_zbud_pers_zbytes(size);
+		inc_zbud_pers_cumul_zbytes(size);
 	}
 }
 
@@ -603,9 +623,9 @@ struct page *zbud_free_and_delist(struct zbudref *zref, bool eph,
 		}
 		if (eph) {
 			zbud_eph_buddied_count--;
-			zbud_eph_unbuddied_count++;
+			inc_zbud_eph_unbuddied_count();
 		} else {
-			zbud_pers_unbuddied_count++;
+			inc_zbud_pers_unbuddied_count();
 			zbud_pers_buddied_count--;
 		}
 		/* don't mess with lru, no need to move it */
@@ -664,7 +684,7 @@ found_unbuddied:
 		list_add_tail(&zbudpage->budlist, &zbud_eph_buddied_list);
 		unbud[found_good_buddy].count--;
 		zbud_eph_unbuddied_count--;
-		zbud_eph_buddied_count++;
+		inc_zbud_eph_buddied_count();
 		/* "promote" raw zbudpage to most-recently-used */
 		list_del_init(&zbudpage->lru);
 		list_add_tail(&zbudpage->lru, &zbud_eph_lru_list);
@@ -672,7 +692,7 @@ found_unbuddied:
 		list_add_tail(&zbudpage->budlist, &zbud_pers_buddied_list);
 		unbud[found_good_buddy].count--;
 		zbud_pers_unbuddied_count--;
-		zbud_pers_buddied_count++;
+		inc_zbud_pers_buddied_count();
 		/* "promote" raw zbudpage to most-recently-used */
 		list_del_init(&zbudpage->lru);
 		list_add_tail(&zbudpage->lru, &zbud_pers_lru_list);
@@ -723,10 +743,10 @@ struct zbudref *zbud_create_prep(struct tmem_handle *th, bool eph,
 	list_add_tail(&zbudpage->budlist, &unbud[nchunks].list);
 	if (eph) {
 		list_add_tail(&zbudpage->lru, &zbud_eph_lru_list);
-		zbud_eph_unbuddied_count++;
+		inc_zbud_eph_unbuddied_count();
 	} else {
 		list_add_tail(&zbudpage->lru, &zbud_pers_lru_list);
-		zbud_pers_unbuddied_count++;
+		inc_zbud_pers_unbuddied_count();
 	}
 	unbud[nchunks].count++;
 	zbud_init_zbud(zbudpage, th, eph, cdata, budnum, size);
@@ -951,7 +971,7 @@ evict_page:
 		BUG();
 	}
 	spin_unlock(&zbud_eph_lists_lock);
-	zbud_eph_evicted_pageframes++;
+	inc_zbud_eph_evicted_pageframes();
 	if (*zpages == 1)
 		zbud_eph_unbuddied_count--;
 	else
-- 
1.8.0.2

