Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754035AbaEGGEl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 02:04:41 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:42210 "EHLO
	lgemrelse7q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753404AbaEGGEi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 02:04:38 -0400
X-Original-SENDERIP: 10.177.220.145
X-Original-MAILFROM: iamjoonsoo.kim@lge.com
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Pekka Enberg <penberg@kernel.org>
Cc: Christoph Lameter <cl@linux.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Rientjes <rientjes@google.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Joonsoo Kim <js1304@gmail.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: [PATCH v2 03/10] slab: move up code to get kmem_cache_node in free_block()
Date: Wed,  7 May 2014 15:06:13 +0900
Message-Id: <1399442780-28748-4-git-send-email-iamjoonsoo.kim@lge.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1399442780-28748-1-git-send-email-iamjoonsoo.kim@lge.com>
References: <1399442780-28748-1-git-send-email-iamjoonsoo.kim@lge.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

node isn't changed, so we don't need to retreive this structure
everytime we move the object. Maybe compiler do this optimization,
but making it explicitly is better.

Acked-by: Christoph Lameter <cl@linux.com>
Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>

diff --git a/mm/slab.c b/mm/slab.c
index e2c80df..92d08e3 100644
--- a/mm/slab.c
+++ b/mm/slab.c
@@ -3340,7 +3340,7 @@ static void free_block(struct kmem_cache *cachep, void **objpp, int nr_objects,
 		       int node)
 {
 	int i;
-	struct kmem_cache_node *n;
+	struct kmem_cache_node *n = cachep->node[node];
 
 	for (i = 0; i < nr_objects; i++) {
 		void *objp;
@@ -3349,7 +3349,6 @@ static void free_block(struct kmem_cache *cachep, void **objpp, int nr_objects,
 		objp = clear_obj_pfmemalloc(objpp[i]);
 
 		page = virt_to_head_page(objp);
-		n = cachep->node[node];
 		list_del(&page->lru);
 		check_spinlock_acquired_node(cachep, node);
 		slab_put_obj(cachep, page, objp, node);
-- 
1.7.9.5

