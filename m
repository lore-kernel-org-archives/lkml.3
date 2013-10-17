Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752708Ab3JQGEX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 02:04:23 -0400
Received: from lgeamrelo01.lge.com ([156.147.1.125]:43238 "EHLO
	LGEAMRELO01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751581Ab3JQGC6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 02:02:58 -0400
X-AuditID: 9c93017d-b7b2eae000005519-36-525f7d8fad4e
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Pekka Enberg <penberg@kernel.org>
Cc: Christoph Lameter <cl@linux.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Joonsoo Kim <js1304@gmail.com>, David Rientjes <rientjes@google.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Wanpeng Li <liwanp@linux.vnet.ibm.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: [PATCH v2 2/5] slab: introduce helper functions to get/set free object
Date: Thu, 17 Oct 2013 15:03:14 +0900
Message-Id: <1381989797-29269-3-git-send-email-iamjoonsoo.kim@lge.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1381989797-29269-1-git-send-email-iamjoonsoo.kim@lge.com>
References: <1381989797-29269-1-git-send-email-iamjoonsoo.kim@lge.com>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the following patches, to get/set free objects from the freelist
is changed so that simple casting doesn't work for it. Therefore,
introduce helper functions.

Acked-by: Christoph Lameter <cl@linux.com>
Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>

diff --git a/mm/slab.c b/mm/slab.c
index cb0a734..ec197b9 100644
--- a/mm/slab.c
+++ b/mm/slab.c
@@ -2556,9 +2556,15 @@ static struct freelist *alloc_slabmgmt(struct kmem_cache *cachep,
 	return freelist;
 }
 
-static inline unsigned int *slab_freelist(struct page *page)
+static inline unsigned int get_free_obj(struct page *page, unsigned int idx)
 {
-	return (unsigned int *)(page->freelist);
+	return ((unsigned int *)page->freelist)[idx];
+}
+
+static inline void set_free_obj(struct page *page,
+					unsigned int idx, unsigned int val)
+{
+	((unsigned int *)(page->freelist))[idx] = val;
 }
 
 static void cache_init_objs(struct kmem_cache *cachep,
@@ -2603,7 +2609,7 @@ static void cache_init_objs(struct kmem_cache *cachep,
 		if (cachep->ctor)
 			cachep->ctor(objp);
 #endif
-		slab_freelist(page)[i] = i;
+		set_free_obj(page, i, i);
 	}
 }
 
@@ -2622,7 +2628,7 @@ static void *slab_get_obj(struct kmem_cache *cachep, struct page *page,
 {
 	void *objp;
 
-	objp = index_to_obj(cachep, page, slab_freelist(page)[page->active]);
+	objp = index_to_obj(cachep, page, get_free_obj(page, page->active));
 	page->active++;
 #if DEBUG
 	WARN_ON(page_to_nid(virt_to_page(objp)) != nodeid);
@@ -2643,7 +2649,7 @@ static void slab_put_obj(struct kmem_cache *cachep, struct page *page,
 
 	/* Verify double free bug */
 	for (i = page->active; i < cachep->num; i++) {
-		if (slab_freelist(page)[i] == objnr) {
+		if (get_free_obj(page, i) == objnr) {
 			printk(KERN_ERR "slab: double free detected in cache "
 					"'%s', objp %p\n", cachep->name, objp);
 			BUG();
@@ -2651,7 +2657,7 @@ static void slab_put_obj(struct kmem_cache *cachep, struct page *page,
 	}
 #endif
 	page->active--;
-	slab_freelist(page)[page->active] = objnr;
+	set_free_obj(page, page->active, objnr);
 }
 
 /*
@@ -4224,7 +4230,7 @@ static void handle_slab(unsigned long *n, struct kmem_cache *c,
 
 		for (j = page->active; j < c->num; j++) {
 			/* Skip freed item */
-			if (slab_freelist(page)[j] == i) {
+			if (get_free_obj(page, j) == i) {
 				active = false;
 				break;
 			}
-- 
1.7.9.5

