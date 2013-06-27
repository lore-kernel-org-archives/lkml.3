Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753117Ab3F0Alw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 20:41:52 -0400
Received: from e23smtp05.au.ibm.com ([202.81.31.147]:56199 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753074Ab3F0Alv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 20:41:51 -0400
From: Wanpeng Li <liwanp@linux.vnet.ibm.com>
To: Pekka Enberg <penberg@kernel.org>,
        Christoph Lameter <cl@linux-foundation.org>,
        Matt Mackall <mpm@selenic.com>
Cc: Glauber Costa <glommer@parallels.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Joonsoo Kim <js1304@gmail.com>, David Rientjes <rientjes@google.com>,
        lllllinux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Wanpeng Li <liwanp@linux.vnet.ibm.com>
Subject: [PATCH v2 1/3] mm/slab: Fix drain freelist excessively
Date: Thu, 27 Jun 2013 08:41:38 +0800
Message-Id: <1372293700-15916-1-git-send-email-liwanp@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.5.4
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13062700-1396-0000-0000-0000032D0634
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
52 objects are drained, this destroy the cache locality. This patch fix it
by compare the number of slabs objects which already drained instead of
compare the number of slabs to the number of slab objects prefer to drain.
After this patch applied, there is no excessive drain as dump information 
mentioned above.

Signed-off-by: Wanpeng Li <liwanp@linux.vnet.ibm.com>
---
 mm/slab.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/slab.c b/mm/slab.c
index 8ccd296..f58eb0b 100644
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
1.8.1.2

