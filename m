Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752581AbaBNG7p (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 01:59:45 -0500
Received: from lgeamrelo01.lge.com ([156.147.1.125]:46386 "EHLO
	LGEAMRELO01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751885AbaBNG51 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 01:57:27 -0500
X-AuditID: 9c93017d-b7c89ae000006ae1-e0-52fdbe54da98
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Pekka Enberg <penberg@kernel.org>
Cc: Christoph Lameter <cl@linux.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Rientjes <rientjes@google.com>,
        Wanpeng Li <liwanp@linux.vnet.ibm.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Joonsoo Kim <js1304@gmail.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: [PATCH 3/9] slab: move up code to get kmem_cache_node in free_block()
Date: Fri, 14 Feb 2014 15:57:17 +0900
Message-Id: <1392361043-22420-4-git-send-email-iamjoonsoo.kim@lge.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1392361043-22420-1-git-send-email-iamjoonsoo.kim@lge.com>
References: <1392361043-22420-1-git-send-email-iamjoonsoo.kim@lge.com>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

node isn't changed, so we don't need to retreive this structure
everytime we move the object. Maybe compiler do this optimization,
but making it explicitly is better.

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>

diff --git a/mm/slab.c b/mm/slab.c
index 6d17cad..53d1a36 100644
--- a/mm/slab.c
+++ b/mm/slab.c
@@ -3361,6 +3361,7 @@ static void free_block(struct kmem_cache *cachep, void **objpp, int nr_objects,
 	int i;
 	struct kmem_cache_node *n;
 
+	n = cachep->node[node];
 	for (i = 0; i < nr_objects; i++) {
 		void *objp;
 		struct page *page;
@@ -3368,7 +3369,6 @@ static void free_block(struct kmem_cache *cachep, void **objpp, int nr_objects,
 		objp = clear_obj_pfmemalloc(objpp[i]);
 
 		page = virt_to_head_page(objp);
-		n = cachep->node[node];
 		list_del(&page->lru);
 		check_spinlock_acquired_node(cachep, node);
 		slab_put_obj(cachep, page, objp, node);
-- 
1.7.9.5

