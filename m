Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752499Ab3AUIBf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 03:01:35 -0500
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:53513 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752340Ab3AUIBd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 03:01:33 -0500
X-AuditID: 9c93016f-b7b70ae000000e36-30-50fcf5d9b21d
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Pekka Enberg <penberg@kernel.org>
Cc: Christoph Lameter <cl@linux-foundation.org>, js1304@gmail.com,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: [PATCH v2 2/3] slub: correct bootstrap() for kmem_cache, kmem_cache_node
Date: Mon, 21 Jan 2013 17:01:26 +0900
Message-Id: <1358755287-3899-2-git-send-email-iamjoonsoo.kim@lge.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1358755287-3899-1-git-send-email-iamjoonsoo.kim@lge.com>
References: <1358755287-3899-1-git-send-email-iamjoonsoo.kim@lge.com>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Current implementation of bootstrap() is not sufficient for kmem_cache
and kmem_cache_node.

First, for kmem_cache.
bootstrap() call kmem_cache_zalloc() at first. When kmem_cache_zalloc()
is called, kmem_cache's slab is moved to cpu slab for satisfying kmem_cache
allocation request. In current implementation, we only consider
n->partial slabs, so, we miss this cpu slab for kmem_cache.

Second, for kmem_cache_node.
When slab_state = PARTIAL, create_boot_cache() is called. And then,
kmem_cache_node's slab is moved to cpu slab for satisfying kmem_cache_node
allocation request. So, we also miss this slab.

These didn't make any error previously, because we normally don't free
objects which comes from kmem_cache's first slab and kmem_cache_node's.

Problem will be solved if we consider a cpu slab in bootstrap().
This patch implement it.

v2: don't loop over all processors in bootstrap().

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>

diff --git a/mm/slub.c b/mm/slub.c
index 7204c74..8b95364 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -3614,10 +3614,15 @@ static int slab_memory_callback(struct notifier_block *self,
 static struct kmem_cache * __init bootstrap(struct kmem_cache *static_cache)
 {
 	int node;
+	struct kmem_cache_cpu *c;
 	struct kmem_cache *s = kmem_cache_zalloc(kmem_cache, GFP_NOWAIT);
 
 	memcpy(s, static_cache, kmem_cache->object_size);
 
+	c = this_cpu_ptr(s->cpu_slab);
+	if (c->page)
+		c->page->slab_cache = s;
+
 	for_each_node_state(node, N_NORMAL_MEMORY) {
 		struct kmem_cache_node *n = get_node(s, node);
 		struct page *p;
-- 
1.7.9.5

