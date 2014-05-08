Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753218AbaEHHJB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 03:09:01 -0400
Received: from mx2.parallels.com ([199.115.105.18]:54518 "EHLO
	mx2.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752757AbaEHHJA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 03:09:00 -0400
Date: Thu, 8 May 2014 11:08:54 +0400
From: Vladimir Davydov <vdavydov@parallels.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: Michal Hocko <mhocko@suse.cz>, <hannes@cmpxchg.org>,
        <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>
Subject: Re: [PATCH -mm 1/2] memcg: get rid of memcg_create_cache_name
Message-ID: <20140508070853.GG4757@esperanza>
References: <a4aa62026c10fc709e8bf13542b29cf771381394.1399450112.git.vdavydov@parallels.com>
 <20140507095127.GC9489@dhcp22.suse.cz>
 <20140507104514.GC4757@esperanza>
 <20140507135352.3790c739ae331d1f6721f3de@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20140507135352.3790c739ae331d1f6721f3de@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 07, 2014 at 01:53:52PM -0700, Andrew Morton wrote:
> On Wed, 7 May 2014 14:45:16 +0400 Vladimir Davydov <vdavydov@parallels.com> wrote:
> 
> > @@ -3164,6 +3141,7 @@ void memcg_free_cache_params(struct kmem_cache *s)
> >  static void memcg_kmem_create_cache(struct mem_cgroup *memcg,
> >  				    struct kmem_cache *root_cache)
> >  {
> > +	static char *memcg_name_buf;	/* protected by memcg_slab_mutex */
> >  	struct kmem_cache *cachep;
> >  	int id;
> >  
> > @@ -3179,7 +3157,14 @@ static void memcg_kmem_create_cache(struct mem_cgroup *memcg,
> >  	if (cache_from_memcg_idx(root_cache, id))
> >  		return;
> >  
> > -	cachep = kmem_cache_create_memcg(memcg, root_cache);
> > +	if (!memcg_name_buf) {
> > +		memcg_name_buf = kmalloc(NAME_MAX + 1, GFP_KERNEL);
> > +		if (!memcg_name_buf)
> > +			return;
> > +	}
> 
> Does this have any meaningful advantage over the simpler
> 
> 	static char memcg_name_buf[NAME_MAX + 1];
> 
> ?

Don't think so. In case nobody has objections, the patch is attached
below.

Thanks.
--

From: Vladimir Davydov <vdavydov@parallels.com>
Subject: [PATCH] memcg: memcg_kmem_create_cache: make memcg_name_buf
 statically allocated

It isn't worth complicating the code by allocating it on the first
access, because it only takes 256 bytes.

Signed-off-by: Vladimir Davydov <vdavydov@parallels.com>

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 9ff3742f4154..01fda17a2566 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -3141,7 +3141,8 @@ void memcg_free_cache_params(struct kmem_cache *s)
 static void memcg_kmem_create_cache(struct mem_cgroup *memcg,
 				    struct kmem_cache *root_cache)
 {
-	static char *memcg_name_buf;	/* protected by memcg_slab_mutex */
+	static char memcg_name_buf[NAME_MAX + 1]; /* protected by
+						     memcg_slab_mutex */
 	struct kmem_cache *cachep;
 	int id;
 
@@ -3157,12 +3158,6 @@ static void memcg_kmem_create_cache(struct mem_cgroup *memcg,
 	if (cache_from_memcg_idx(root_cache, id))
 		return;
 
-	if (!memcg_name_buf) {
-		memcg_name_buf = kmalloc(NAME_MAX + 1, GFP_KERNEL);
-		if (!memcg_name_buf)
-			return;
-	}
-
 	cgroup_name(memcg->css.cgroup, memcg_name_buf, NAME_MAX + 1);
 	cachep = kmem_cache_create_memcg(memcg, root_cache, memcg_name_buf);
 	/*
