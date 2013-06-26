Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752285Ab3FZX5x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 19:57:53 -0400
Received: from e28smtp01.in.ibm.com ([122.248.162.1]:53542 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751501Ab3FZX5w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 19:57:52 -0400
From: Wanpeng Li <liwanp@linux.vnet.ibm.com>
To: Pekka Enberg <penberg@kernel.org>,
        Christoph Lameter <cl@linux-foundation.org>,
        Matt Mackall <mpm@selenic.com>
Cc: Glauber Costa <glommer@parallels.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Joonsoo Kim <js1304@gmail.com>, David Rientjes <rientjes@google.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Wanpeng Li <liwanp@linux.vnet.ibm.com>
Subject: [PATCH 1/3] mm/slub: Fix slub calculate active slabs uncorrectly
Date: Thu, 27 Jun 2013 07:57:37 +0800
Message-Id: <1372291059-9880-1-git-send-email-liwanp@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.5.4
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13062623-4790-0000-0000-000008FDCA0F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enough slabs are queued in partial list to avoid pounding the page allocator
excessively. Entire free slabs are not discarded immediately if there are not
enough slabs in partial list(n->partial < s->min_partial). The number of total
slabs is composed by the number of active slabs and the number of entire free
slabs, however, the current logic of slub implementation ignore this which lead
to the number of active slabs and the number of total slabs in slabtop message
is always equal. This patch fix it by substract the number of entire free slabs
in partial list when caculate active slabs.

Before patch:
Active / Total Slabs (% used) : 59018 / 59018 (100.0%)

After patch:
Active / Total Slabs (% used) : 11086 / 11153 (99.4%)

Signed-off-by: Wanpeng Li <liwanp@linux.vnet.ibm.com>
---
 mm/slub.c | 24 ++++++++++++++++--------
 1 file changed, 16 insertions(+), 8 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index 57707f0..939760d 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -2055,15 +2055,20 @@ static int count_free(struct page *page)
 }
 
 static unsigned long count_partial(struct kmem_cache_node *n,
-					int (*get_count)(struct page *))
+	unsigned long *nr_inactive_slabs, int (*get_count)(struct page *))
 {
 	unsigned long flags;
 	unsigned long x = 0;
+	unsigned long nr_inactive = 0;
 	struct page *page;
 
 	spin_lock_irqsave(&n->list_lock, flags);
-	list_for_each_entry(page, &n->partial, lru)
+	list_for_each_entry(page, &n->partial, lru) {
 		x += get_count(page);
+		if (nr_inactive_slabs && page->inuse == 0)
+			nr_inactive++;
+	}
+	*nr_inactive_slabs = nr_inactive;
 	spin_unlock_irqrestore(&n->list_lock, flags);
 	return x;
 }
@@ -2102,7 +2107,7 @@ slab_out_of_memory(struct kmem_cache *s, gfp_t gfpflags, int nid)
 		if (!n)
 			continue;
 
-		nr_free  = count_partial(n, count_free);
+		nr_free  = count_partial(n, NULL, count_free);
 		nr_slabs = node_nr_slabs(n);
 		nr_objs  = node_nr_objs(n);
 
@@ -4304,7 +4309,7 @@ static ssize_t show_slab_objects(struct kmem_cache *s,
 			x = atomic_long_read(&n->total_objects);
 		else if (flags & SO_OBJECTS)
 			x = atomic_long_read(&n->total_objects) -
-				count_partial(n, count_free);
+				count_partial(n, NULL, count_free);
 
 			else
 				x = atomic_long_read(&n->nr_slabs);
@@ -4319,9 +4324,9 @@ static ssize_t show_slab_objects(struct kmem_cache *s,
 			struct kmem_cache_node *n = get_node(s, node);
 
 			if (flags & SO_TOTAL)
-				x = count_partial(n, count_total);
+				x = count_partial(n, NULL, count_total);
 			else if (flags & SO_OBJECTS)
-				x = count_partial(n, count_inuse);
+				x = count_partial(n, NULL, count_inuse);
 			else
 				x = n->nr_partial;
 			total += x;
@@ -5273,6 +5278,8 @@ void get_slabinfo(struct kmem_cache *s, struct slabinfo *sinfo)
 	unsigned long nr_slabs = 0;
 	unsigned long nr_objs = 0;
 	unsigned long nr_free = 0;
+	unsigned long nr_inactive = 0;
+	unsigned long nr_inactive_slabs = 0;
 	int node;
 
 	for_each_online_node(node) {
@@ -5284,12 +5291,13 @@ void get_slabinfo(struct kmem_cache *s, struct slabinfo *sinfo)
 		nr_partials += n->nr_partial;
 		nr_slabs += atomic_long_read(&n->nr_slabs);
 		nr_objs += atomic_long_read(&n->total_objects);
-		nr_free += count_partial(n, count_free);
+		nr_free += count_partial(n, &nr_inactive, count_free);
+		nr_inactive_slabs += nr_inactive;
 	}
 
 	sinfo->active_objs = nr_objs - nr_free;
 	sinfo->num_objs = nr_objs;
-	sinfo->active_slabs = nr_slabs;
+	sinfo->active_slabs = nr_slabs - nr_inactive_slabs;
 	sinfo->num_slabs = nr_slabs;
 	sinfo->objects_per_slab = oo_objects(s->oo);
 	sinfo->cache_order = oo_order(s->oo);
-- 
1.8.1.2

