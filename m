Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756262Ab3GDAdi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 20:33:38 -0400
Received: from e23smtp01.au.ibm.com ([202.81.31.143]:34162 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752766Ab3GDAdg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 20:33:36 -0400
From: Wanpeng Li <liwanp@linux.vnet.ibm.com>
To: Pekka Enberg <penberg@kernel.org>,
        Christoph Lameter <cl@linux-foundation.org>,
        Matt Mackall <mpm@selenic.com>
Cc: Glauber Costa <glommer@parallels.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Joonsoo Kim <js1304@gmail.com>, David Rientjes <rientjes@google.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Wanpeng Li <liwanp@linux.vnet.ibm.com>
Subject: [PATCH v3 1/5] mm/slab: Fix drain freelist excessively
Date: Thu,  4 Jul 2013 08:33:22 +0800
Message-Id: <1372898006-6308-1-git-send-email-liwanp@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.5.4
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13070400-1618-0000-0000-00000433AE1D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changelog:
 v1 -> v2:
  * Fix the callers that pass # of objects. Make sure they pass # of slabs.
 v2 -> v3:
  * introduce helper function slabs_tofree 

The drain_freelist is called to drain slabs_free lists for cache reap,
cache shrink, memory hotplug callback etc. The tofree parameter should
be the number of slab to free instead of the number of slab objects to
free.

This patch fix the callers that pass # of objects. Make sure they pass #
of slabs.

Signed-off-by: Wanpeng Li <liwanp@linux.vnet.ibm.com>
---
 mm/slab.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/mm/slab.c b/mm/slab.c
index e6122b2..3002771 100644
--- a/mm/slab.c
+++ b/mm/slab.c
@@ -1180,6 +1180,12 @@ static int init_cache_node_node(int node)
 	return 0;
 }
 
+static inline int slabs_tofree(struct kmem_cache *cachep,
+						struct kmem_cache_node *n)
+{
+	return (n->free_objects + cachep->num - 1) / cachep->num;
+}
+
 static void cpuup_canceled(long cpu)
 {
 	struct kmem_cache *cachep;
@@ -1241,7 +1247,7 @@ free_array_cache:
 		n = cachep->node[node];
 		if (!n)
 			continue;
-		drain_freelist(cachep, n, n->free_objects);
+		drain_freelist(cachep, n, slabs_tofree(cachep, n));
 	}
 }
 
@@ -1408,7 +1414,7 @@ static int __meminit drain_cache_node_node(int node)
 		if (!n)
 			continue;
 
-		drain_freelist(cachep, n, n->free_objects);
+		drain_freelist(cachep, n, slabs_tofree(cachep, n));
 
 		if (!list_empty(&n->slabs_full) ||
 		    !list_empty(&n->slabs_partial)) {
@@ -2532,7 +2538,7 @@ static int __cache_shrink(struct kmem_cache *cachep)
 		if (!n)
 			continue;
 
-		drain_freelist(cachep, n, n->free_objects);
+		drain_freelist(cachep, n, slabs_tofree(cachep, n));
 
 		ret += !list_empty(&n->slabs_full) ||
 			!list_empty(&n->slabs_partial);
-- 
1.8.1.2

