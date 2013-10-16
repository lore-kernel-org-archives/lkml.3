Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760355Ab3JPIor (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 04:44:47 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:46536 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760315Ab3JPIo1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 04:44:27 -0400
X-AuditID: 9c930179-b7c78ae000003065-a1-525e51e078cf
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Pekka Enberg <penberg@kernel.org>
Cc: Christoph Lameter <cl@linux.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Joonsoo Kim <js1304@gmail.com>, David Rientjes <rientjes@google.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Wanpeng Li <liwanp@linux.vnet.ibm.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: [PATCH v2 15/15] slab: rename slab_bufctl to slab_freelist
Date: Wed, 16 Oct 2013 17:44:12 +0900
Message-Id: <1381913052-23875-16-git-send-email-iamjoonsoo.kim@lge.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1381913052-23875-1-git-send-email-iamjoonsoo.kim@lge.com>
References: <1381913052-23875-1-git-send-email-iamjoonsoo.kim@lge.com>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now, bufctl is not proper name to this array.
So change it.

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>

diff --git a/mm/slab.c b/mm/slab.c
index fbb594f..af2db76 100644
--- a/mm/slab.c
+++ b/mm/slab.c
@@ -2550,7 +2550,7 @@ static struct freelist *alloc_slabmgmt(struct kmem_cache *cachep,
 	return freelist;
 }
 
-static inline unsigned int *slab_bufctl(struct page *page)
+static inline unsigned int *slab_freelist(struct page *page)
 {
 	return (unsigned int *)(page->freelist);
 }
@@ -2597,7 +2597,7 @@ static void cache_init_objs(struct kmem_cache *cachep,
 		if (cachep->ctor)
 			cachep->ctor(objp);
 #endif
-		slab_bufctl(page)[i] = i;
+		slab_freelist(page)[i] = i;
 	}
 }
 
@@ -2616,7 +2616,7 @@ static void *slab_get_obj(struct kmem_cache *cachep, struct page *page,
 {
 	void *objp;
 
-	objp = index_to_obj(cachep, page, slab_bufctl(page)[page->active]);
+	objp = index_to_obj(cachep, page, slab_freelist(page)[page->active]);
 	page->active++;
 #if DEBUG
 	WARN_ON(page_to_nid(virt_to_page(objp)) != nodeid);
@@ -2637,7 +2637,7 @@ static void slab_put_obj(struct kmem_cache *cachep, struct page *page,
 
 	/* Verify double free bug */
 	for (i = page->active; i < cachep->num; i++) {
-		if (slab_bufctl(page)[i] == objnr) {
+		if (slab_freelist(page)[i] == objnr) {
 			printk(KERN_ERR "slab: double free detected in cache "
 					"'%s', objp %p\n", cachep->name, objp);
 			BUG();
@@ -2645,7 +2645,7 @@ static void slab_put_obj(struct kmem_cache *cachep, struct page *page,
 	}
 #endif
 	page->active--;
-	slab_bufctl(page)[page->active] = objnr;
+	slab_freelist(page)[page->active] = objnr;
 }
 
 /*
@@ -4218,7 +4218,7 @@ static void handle_slab(unsigned long *n, struct kmem_cache *c,
 
 		for (j = page->active; j < c->num; j++) {
 			/* Skip freed item */
-			if (slab_bufctl(page)[j] == i) {
+			if (slab_freelist(page)[j] == i) {
 				active = false;
 				break;
 			}
-- 
1.7.9.5

