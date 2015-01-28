Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759667AbbA2Bzw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 20:55:52 -0500
Received: from mx2.parallels.com ([199.115.105.18]:35000 "EHLO
	mx2.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759588AbbA2Bzu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 20:55:50 -0500
Date: Wed, 28 Jan 2015 20:46:39 +0300
From: Vladimir Davydov <vdavydov@parallels.com>
To: Christoph Lameter <cl@linux.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>,
        <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -mm v2 2/3] slub: fix kmem_cache_shrink return value
Message-ID: <20150128174639.GB16011@esperanza>
References: <cover.1422461573.git.vdavydov@parallels.com>
 <7ee54d0d26f6c61e2ecf50300ee955610749b344.1422461573.git.vdavydov@parallels.com>
 <alpine.DEB.2.11.1501281032220.32147@gentwo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.11.1501281032220.32147@gentwo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 28, 2015 at 10:33:50AM -0600, Christoph Lameter wrote:
> On Wed, 28 Jan 2015, Vladimir Davydov wrote:
> 
> > @@ -3419,6 +3420,9 @@ int __kmem_cache_shrink(struct kmem_cache *s)
> >  		for (i = SHRINK_PROMOTE_MAX - 1; i >= 0; i--)
> >  			list_splice_init(promote + i, &n->partial);
> >
> > +		if (n->nr_partial || slabs_node(s, node))
> 
> The total number of slabs obtained via slabs_node always contains the
> number of partial ones. So no need to check n->nr_partial.

Yeah, right. In addition to that I misplaced the check - it should go
after discard_slab, where we decrement nr_slabs. Here goes the updated
patch:

From: Vladimir Davydov <vdavydov@parallels.com>
Subject: [PATCH] slub: fix kmem_cache_shrink return value

It is supposed to return 0 if the cache has no remaining objects and 1
otherwise, while currently it always returns 0. Fix it.

Signed-off-by: Vladimir Davydov <vdavydov@parallels.com>
---
 mm/slub.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/mm/slub.c b/mm/slub.c
index dbf9334b6a5c..5626588db884 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -3379,6 +3379,7 @@ int __kmem_cache_shrink(struct kmem_cache *s)
 	LIST_HEAD(discard);
 	struct list_head promote[SHRINK_PROMOTE_MAX];
 	unsigned long flags;
+	int ret = 0;
 
 	for (i = 0; i < SHRINK_PROMOTE_MAX; i++)
 		INIT_LIST_HEAD(promote + i);
@@ -3424,9 +3425,12 @@ int __kmem_cache_shrink(struct kmem_cache *s)
 		/* Release empty slabs */
 		list_for_each_entry_safe(page, t, &discard, lru)
 			discard_slab(s, page);
+
+		if (slabs_node(s, node))
+			ret = 1;
 	}
 
-	return 0;
+	return ret;
 }
 
 static int slab_mem_going_offline_callback(void *arg)
-- 
1.7.10.4

