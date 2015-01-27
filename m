Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758780AbbA0M67 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 07:58:59 -0500
Received: from mx2.parallels.com ([199.115.105.18]:56955 "EHLO
	mx2.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755820AbbA0M6y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 07:58:54 -0500
Date: Tue, 27 Jan 2015 15:58:38 +0300
From: Vladimir Davydov <vdavydov@parallels.com>
To: Christoph Lameter <cl@linux.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>,
        <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -mm 1/3] slub: don't fail kmem_cache_shrink if slab
 placement optimization fails
Message-ID: <20150127125838.GD5165@esperanza>
References: <cover.1422275084.git.vdavydov@parallels.com>
 <3804a429071f939e6b4f654b6c6426c1fdd95f7e.1422275084.git.vdavydov@parallels.com>
 <alpine.DEB.2.11.1501260944550.15849@gentwo.org>
 <20150126170147.GB28978@esperanza>
 <alpine.DEB.2.11.1501261216120.16638@gentwo.org>
 <20150126193629.GA2660@esperanza>
 <alpine.DEB.2.11.1501261353020.16786@gentwo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.11.1501261353020.16786@gentwo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 26, 2015 at 01:53:32PM -0600, Christoph Lameter wrote:
> On Mon, 26 Jan 2015, Vladimir Davydov wrote:
> 
> > We could do that, but IMO that would only complicate the code w/o
> > yielding any real benefits. This function is slow and called rarely
> > anyway, so I don't think there is any point to optimize out a page
> > allocation here.
> 
> I think you already have the code there. Simply allow the sizeing of the
> empty_page[] array. And rename it.
> 

May be, we could remove this allocation at all then? I mean, always
distribute slabs among constant number of buckets, say 32, like this:

diff --git a/mm/slub.c b/mm/slub.c
index 5ed1a73e2ec8..a43b213770b4 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -3358,6 +3358,8 @@ void kfree(const void *x)
 }
 EXPORT_SYMBOL(kfree);
 
+#define SHRINK_BUCKETS 32
+
 /*
  * kmem_cache_shrink removes empty slabs from the partial lists and sorts
  * the remaining slabs by the number of items in use. The slabs with the
@@ -3376,19 +3378,15 @@ int __kmem_cache_shrink(struct kmem_cache *s)
 	struct page *page;
 	struct page *t;
 	int objects = oo_objects(s->max);
-	struct list_head *slabs_by_inuse =
-		kmalloc(sizeof(struct list_head) * objects, GFP_KERNEL);
+	struct list_head slabs_by_inuse[SHRINK_BUCKETS];
 	unsigned long flags;
 
-	if (!slabs_by_inuse)
-		return -ENOMEM;
-
 	flush_all(s);
 	for_each_kmem_cache_node(s, node, n) {
 		if (!n->nr_partial)
 			continue;
 
-		for (i = 0; i < objects; i++)
+		for (i = 0; i < SHRINK_BUCKETS; i++)
 			INIT_LIST_HEAD(slabs_by_inuse + i);
 
 		spin_lock_irqsave(&n->list_lock, flags);
@@ -3400,7 +3398,9 @@ int __kmem_cache_shrink(struct kmem_cache *s)
 		 * list_lock. page->inuse here is the upper limit.
 		 */
 		list_for_each_entry_safe(page, t, &n->partial, lru) {
-			list_move(&page->lru, slabs_by_inuse + page->inuse);
+			i = DIV_ROUND_UP(page->inuse * (SHRINK_BUCKETS - 1),
+					 objects);
+			list_move(&page->lru, slabs_by_inuse + i);
 			if (!page->inuse)
 				n->nr_partial--;
 		}
@@ -3409,7 +3409,7 @@ int __kmem_cache_shrink(struct kmem_cache *s)
 		 * Rebuild the partial list with the slabs filled up most
 		 * first and the least used slabs at the end.
 		 */
-		for (i = objects - 1; i > 0; i--)
+		for (i = SHRINK_BUCKETS - 1; i > 0; i--)
 			list_splice(slabs_by_inuse + i, n->partial.prev);
 
 		spin_unlock_irqrestore(&n->list_lock, flags);
@@ -3419,7 +3419,6 @@ int __kmem_cache_shrink(struct kmem_cache *s)
 			discard_slab(s, page);
 	}
 
-	kfree(slabs_by_inuse);
 	return 0;
 }
 
