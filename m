Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752556Ab3FXKXb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 06:23:31 -0400
Received: from e23smtp04.au.ibm.com ([202.81.31.146]:51173 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751738Ab3FXKX2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 06:23:28 -0400
From: Wanpeng Li <liwanp@linux.vnet.ibm.com>
To: Pekka Enberg <penberg@kernel.org>,
        Christoph Lameter <cl@linux-foundation.org>,
        Matt Mackall <mpm@selenic.com>
Cc: Glauber Costa <glommer@parallels.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Joonsoo Kim <js1304@gmail.com>, David Rientjes <rientjes@google.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Wanpeng Li <liwanp@linux.vnet.ibm.com>
Subject: [PATCH 1/3] mm/slab: Fix drain freelist excessively
Date: Mon, 24 Jun 2013 18:23:12 +0800
Message-Id: <1372069394-26167-1-git-send-email-liwanp@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.5.4
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13062410-9264-0000-0000-0000040005BB
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The drain_freelist is called to drain slabs_free lists for cache reap, 
cache shrink, memory hotplug callback etc. The tofree parameter is the 
number of slab objects to free instead of the number of slabs to free. 
The parameter transfered from callers is n->free_objects or n->freelimit 
+ 5 * (searchp->num - 1) / (5 * searchp->num), and both of them mean 
the number of slabs objects. I add printk to dump drain information:

[  122.864255] tofree is 2, actually free is 52, cache size is 26

The number of objects which caller prefer to drain is 2, however, actually 
52 objects are drained, this destroy the cache locality.This patch fix it 
by compare the number of slabs objects which already drained instead of 
compare the number of slabs to the number of slab objects prefer to drain.

Signed-off-by: Wanpeng Li <liwanp@linux.vnet.ibm.com>
---
 mm/slab.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/slab.c b/mm/slab.c
index be12f68..18628da 100644
--- a/mm/slab.c
+++ b/mm/slab.c
@@ -2479,7 +2479,7 @@ static void drain_cpu_caches(struct kmem_cache *cachep)
 
 /*
  * Remove slabs from the list of free slabs.
- * Specify the number of slabs to drain in tofree.
+ * Specify the number of slab objects to drain in tofree.
  *
  * Returns the actual number of slabs released.
  */
@@ -2491,7 +2491,7 @@ static int drain_freelist(struct kmem_cache *cache,
 	struct slab *slabp;
 
 	nr_freed = 0;
-	while (nr_freed < tofree && !list_empty(&n->slabs_free)) {
+	while (nr_freed * cache->num < tofree && !list_empty(&n->slabs_free)) {
 
 		spin_lock_irq(&n->list_lock);
 		p = n->slabs_free.prev;
-- 
1.7.10.4

