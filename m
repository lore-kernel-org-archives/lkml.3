Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752430Ab3GCAuN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 20:50:13 -0400
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:39388 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751641Ab3GCAuL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 20:50:11 -0400
From: Wanpeng Li <liwanp@linux.vnet.ibm.com>
To: Pekka Enberg <penberg@kernel.org>,
        Christoph Lameter <cl@linux-foundation.org>,
        Matt Mackall <mpm@selenic.com>
Cc: Glauber Costa <glommer@parallels.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Joonsoo Kim <js1304@gmail.com>, David Rientjes <rientjes@google.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Wanpeng Li <liwanp@linux.vnet.ibm.com>
Subject: [PATCH v2 1/5] mm/slab: Fix drain freelist excessively
Date: Wed,  3 Jul 2013 08:49:49 +0800
Message-Id: <1372812593-7617-1-git-send-email-liwanp@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.5.4
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13070300-7014-0000-0000-00000343A15F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changelog:
 v1 -> v2:
  * Fix the callers that pass # of objects. Make sure they pass # of slabs.

The drain_freelist is called to drain slabs_free lists for cache reap,
cache shrink, memory hotplug callback etc. The tofree parameter should
be the number of slab to free instead of the number of slab objects to
free.

This patch fix the callers that pass # of objects. Make sure they pass #
of slabs.

Signed-off-by: Wanpeng Li <liwanp@linux.vnet.ibm.com>
---
 mm/slab.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/mm/slab.c b/mm/slab.c
index 17298c1..13f5ecc 100644
--- a/mm/slab.c
+++ b/mm/slab.c
@@ -1241,7 +1241,8 @@ free_array_cache:
 		n = cachep->node[node];
 		if (!n)
 			continue;
-		drain_freelist(cachep, n, n->free_objects);
+		drain_freelist(cachep, n, (n->free_objects +
+						cachep->num - 1) / cachep->num);
 	}
 }
 
@@ -1408,7 +1409,8 @@ static int __meminit drain_cache_node_node(int node)
 		if (!n)
 			continue;
 
-		drain_freelist(cachep, n, n->free_objects);
+		drain_freelist(cachep, n, (n->free_objects +
+						cachep->num - 1) / cachep->num);
 
 		if (!list_empty(&n->slabs_full) ||
 		    !list_empty(&n->slabs_partial)) {
@@ -2532,7 +2534,8 @@ static int __cache_shrink(struct kmem_cache *cachep)
 		if (!n)
 			continue;
 
-		drain_freelist(cachep, n, n->free_objects);
+		drain_freelist(cachep, n, (n->free_objects +
+						cachep->num - 1) / cachep->num);
 
 		ret += !list_empty(&n->slabs_full) ||
 			!list_empty(&n->slabs_partial);
-- 
1.8.1.2

