Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759266Ab3BNDHV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 22:07:21 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:48007 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754738Ab3BNDFS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 22:05:18 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        dan.magenheimer@oracle.com, gregkh@linuxfoundation.org
Cc: sjenning@linux.vnet.ibm.com, rcj@linux.vnet.ibm.com,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 14/16] zcache/zbud: Provide the accessory functions for counter decrease.
Date: Wed, 13 Feb 2013 22:05:04 -0500
Message-Id: <1360811106-2679-15-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.8.0.2
In-Reply-To: <1360811106-2679-1-git-send-email-konrad.wilk@oracle.com>
References: <1360811106-2679-1-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 drivers/staging/zcache/zbud.c | 38 ++++++++++++++++++++++++--------------
 1 file changed, 24 insertions(+), 14 deletions(-)

diff --git a/drivers/staging/zcache/zbud.c b/drivers/staging/zcache/zbud.c
index cff596c..e139cd6 100644
--- a/drivers/staging/zcache/zbud.c
+++ b/drivers/staging/zcache/zbud.c
@@ -321,6 +321,16 @@ static inline void inc_zbud_eph_unbuddied_count(void) { zbud_eph_unbuddied_count
 static inline void inc_zbud_pers_unbuddied_count(void) { zbud_pers_unbuddied_count++; };
 static inline void inc_zbud_eph_zombie_count(void) { zbud_eph_zombie_count++; };
 static inline void inc_zbud_pers_zombie_count(void) { zbud_pers_zombie_count++; };
+static inline void dec_zbud_eph_pageframes(void) { zbud_eph_pageframes--; };
+static inline void dec_zbud_pers_pageframes(void) { zbud_pers_pageframes--; };
+static inline void dec_zbud_eph_zpages(void) { zbud_eph_zpages--; };
+static inline void dec_zbud_pers_zpages(void) { zbud_pers_zpages--; };
+static inline void dec_zbud_eph_zbytes(ssize_t bytes) { zbud_eph_zbytes -= bytes; };
+static inline void dec_zbud_pers_zbytes(ssize_t bytes) { zbud_pers_zbytes -= bytes; };
+static inline void dec_zbud_eph_buddied_count(void) { zbud_eph_buddied_count--; };
+static inline void dec_zbud_pers_buddied_count(void) { zbud_pers_buddied_count--; };
+static inline void dec_zbud_eph_unbuddied_count(void) { zbud_eph_unbuddied_count--; };
+static inline void dec_zbud_pers_unbuddied_count(void) { zbud_pers_unbuddied_count--; };
 static atomic_t zbud_eph_zombie_atomic;
 static atomic_t zbud_pers_zombie_atomic;
 
@@ -420,9 +430,9 @@ static inline struct page *zbud_unuse_zbudpage(struct zbudpage *zbudpage,
 	BUG_ON(zbudpage_is_dying(zbudpage));
 	BUG_ON(zbudpage_is_zombie(zbudpage));
 	if (eph)
-		zbud_eph_pageframes--;
+		dec_zbud_eph_pageframes();
 	else
-		zbud_pers_pageframes--;
+		dec_zbud_pers_pageframes();
 	zbudpage_spin_unlock(zbudpage);
 	reset_page_mapcount(page);
 	init_page_count(page);
@@ -445,11 +455,11 @@ static inline void zbud_unuse_zbud(struct zbudpage *zbudpage,
 		zbudpage->zbud1_size = 0;
 	}
 	if (eph) {
-		zbud_eph_zbytes -= size;
-		zbud_eph_zpages--;
+		dec_zbud_eph_zbytes(size);
+		dec_zbud_eph_zpages();
 	} else {
-		zbud_pers_zbytes -= size;
-		zbud_pers_zpages--;
+		dec_zbud_pers_zbytes(size);
+		dec_zbud_pers_zpages();
 	}
 }
 
@@ -610,9 +620,9 @@ struct page *zbud_free_and_delist(struct zbudref *zref, bool eph,
 		list_del_init(&zbudpage->lru);
 		spin_unlock(lists_lock);
 		if (eph)
-			zbud_eph_unbuddied_count--;
+			dec_zbud_eph_unbuddied_count();
 		else
-			zbud_pers_unbuddied_count--;
+			dec_zbud_pers_unbuddied_count();
 		page = zbud_unuse_zbudpage(zbudpage, eph);
 	} else { /* was buddied: move remaining buddy to unbuddied list */
 		chunks = zbud_size_to_chunks(other_bud_size) ;
@@ -622,11 +632,11 @@ struct page *zbud_free_and_delist(struct zbudref *zref, bool eph,
 			unbud[chunks].count++;
 		}
 		if (eph) {
-			zbud_eph_buddied_count--;
+			dec_zbud_eph_buddied_count();
 			inc_zbud_eph_unbuddied_count();
 		} else {
 			inc_zbud_pers_unbuddied_count();
-			zbud_pers_buddied_count--;
+			dec_zbud_pers_buddied_count();
 		}
 		/* don't mess with lru, no need to move it */
 		zbudpage_spin_unlock(zbudpage);
@@ -683,7 +693,7 @@ found_unbuddied:
 	if (eph) {
 		list_add_tail(&zbudpage->budlist, &zbud_eph_buddied_list);
 		unbud[found_good_buddy].count--;
-		zbud_eph_unbuddied_count--;
+		dec_zbud_eph_unbuddied_count();
 		inc_zbud_eph_buddied_count();
 		/* "promote" raw zbudpage to most-recently-used */
 		list_del_init(&zbudpage->lru);
@@ -691,7 +701,7 @@ found_unbuddied:
 	} else {
 		list_add_tail(&zbudpage->budlist, &zbud_pers_buddied_list);
 		unbud[found_good_buddy].count--;
-		zbud_pers_unbuddied_count--;
+		dec_zbud_pers_unbuddied_count();
 		inc_zbud_pers_buddied_count();
 		/* "promote" raw zbudpage to most-recently-used */
 		list_del_init(&zbudpage->lru);
@@ -973,9 +983,9 @@ evict_page:
 	spin_unlock(&zbud_eph_lists_lock);
 	inc_zbud_eph_evicted_pageframes();
 	if (*zpages == 1)
-		zbud_eph_unbuddied_count--;
+		dec_zbud_eph_unbuddied_count();
 	else
-		zbud_eph_buddied_count--;
+		dec_zbud_eph_buddied_count();
 	zbud_evict_tmem(zbudpage);
 	zbudpage_spin_lock(zbudpage);
 	zbudpage_clear_dying(zbudpage);
-- 
1.8.0.2

