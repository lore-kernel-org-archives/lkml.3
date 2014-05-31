Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932670AbaEaKSf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 May 2014 06:18:35 -0400
Received: from mx2.parallels.com ([199.115.105.18]:59715 "EHLO
	mx2.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753968AbaEaKSd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 May 2014 06:18:33 -0400
Date: Sat, 31 May 2014 14:18:21 +0400
From: Vladimir Davydov <vdavydov@parallels.com>
To: Christoph Lameter <cl@gentwo.org>
CC: <akpm@linux-foundation.org>, <hannes@cmpxchg.org>, <mhocko@suse.cz>,
        <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>
Subject: Re: [PATCH -mm 4/8] slub: never fail kmem_cache_shrink
Message-ID: <20140531101819.GA25076@esperanza>
References: <cover.1401457502.git.vdavydov@parallels.com>
 <ac8907cace921c3209aa821649349106f4f70b34.1401457502.git.vdavydov@parallels.com>
 <alpine.DEB.2.10.1405300937560.11943@gentwo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.10.1405300937560.11943@gentwo.org>
X-Originating-IP: [81.5.110.170]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 30, 2014 at 09:46:33AM -0500, Christoph Lameter wrote:
> On Fri, 30 May 2014, Vladimir Davydov wrote:
> 
> > SLUB's kmem_cache_shrink not only removes empty slabs from the cache,
> > but also sorts slabs by the number of objects in-use to cope with
> > fragmentation. To achieve that, it tries to allocate a temporary array.
> > If it fails, it will abort the whole procedure.
> 
> If we cannot allocate a kernel structure that is mostly less than a page
> size then we have much more important things to worry about.

That's all fair, but that doesn't explain why we should fail shrinking
unused slabs if we just couldn't do some unnecessary optimization? IMO,
that's a behavior one wouldn't expect.

> > This is unacceptable for kmemcg, where we want to be sure that all empty
> > slabs are removed from the cache on memcg offline, so let's just skip
> > the de-fragmentation step if the allocation fails, but still get rid of
> > empty slabs.
> 
> Lets just try the shrink and log the fact that it failed? Try again later?

... which means more async workers, more complication to kmemcg code :-(

Sorry, but I just don't get why we can't make kmem_cache_shrink never
fail? Is failing de-fragmentation, which is even not implied by the
function declaration, so critical that should be noted? If so, we can
return an error while still shrinking empty slabs...

If you just don't like the code after the patch, here is another, less
intrusive version doing practically the same. Would it be better?

diff --git a/mm/slub.c b/mm/slub.c
index d96faa2464c3..e45af8c4fb7c 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -3404,12 +3404,15 @@ int __kmem_cache_shrink(struct kmem_cache *s)
 	struct page *page;
 	struct page *t;
 	int objects = oo_objects(s->max);
+	struct list_head empty_slabs;
 	struct list_head *slabs_by_inuse =
 		kmalloc(sizeof(struct list_head) * objects, GFP_KERNEL);
 	unsigned long flags;
 
-	if (!slabs_by_inuse)
-		return -ENOMEM;
+	if (!slabs_by_inuse) {
+		slabs_by_inuse = &empty_slabs;
+		objects = 1;
+	}
 
 	flush_all(s);
 	for_each_node_state(node, N_NORMAL_MEMORY) {
@@ -3430,7 +3433,9 @@ int __kmem_cache_shrink(struct kmem_cache *s)
 		 * list_lock. page->inuse here is the upper limit.
 		 */
 		list_for_each_entry_safe(page, t, &n->partial, lru) {
-			list_move(&page->lru, slabs_by_inuse + page->inuse);
+			if (page->inuse < objects)
+				list_move(&page->lru,
+					  slabs_by_inuse + page->inuse);
 			if (!page->inuse)
 				n->nr_partial--;
 		}
